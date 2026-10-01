## from ai:

Assuming you mean Amazon Kinesis (AWS), it’s easiest to understand it as a way to continuously move and process events/data in near real time.

Imagine:

Applications / Devices / Logs
           │
           ▼
    ┌──────────────┐
    │ Kinesis      │
    │ Data Streams │
    └──────┬───────┘
           │
      ┌────┴────────────┐
      ▼                 ▼
 Lambda Consumer    Custom Consumer
      │                 │
      ▼                 ▼
 DynamoDB/S3        Analytics/Alerts

1. Records: the basic unit of data

A record is one event sent into a Kinesis Data Stream.

For example, your application could generate:

{
  "userId": "U123",
  "action": "LOGIN",
  "timestamp": "2026-09-12T10:30:00Z"
}

Using Python and boto3:

import boto3
import json

kinesis = boto3.client("kinesis", region_name="us-east-1")

event = {
    "userId": "U123",
    "action": "LOGIN"
}

response = kinesis.put_record(
    StreamName="user-events",
    Data=json.dumps(event),
    PartitionKey="U123"
)

print(response)

The important pieces are:

Data          → actual payload
PartitionKey  → decides where the record goes
StreamName    → Kinesis stream receiving it


---

2. Streams

A Kinesis Data Stream is essentially a continuously flowing sequence of records.

Suppose an application generates:

LOGIN
SEARCH
CLICK
PURCHASE
LOGOUT

Instead of processing each event synchronously, the application publishes them:

App
 │
 ├── LOGIN ──────►
 ├── SEARCH ─────► Kinesis Stream
 ├── CLICK ──────►
 └── PURCHASE ───►
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
            Lambda   Analytics   Fraud

This decouples producers from consumers.

The application producing an event doesn't need to know who will eventually process it.


---

3. Shards

A fundamental Kinesis concept is the shard.

A shard can be thought of as a lane inside the stream:

Kinesis Stream

Shard 1: ── A ── B ── C ── D ──►

Shard 2: ── E ── F ── G ── H ──►

Shard 3: ── I ── J ── K ── L ──►

More shards allow greater parallelism and throughput.

In provisioned mode, shard count is therefore an important scaling decision. Kinesis also supports on-demand capacity, where AWS manages capacity scaling for you.


---

4. Partition keys

How does Kinesis decide which shard receives a record?

That's where the partition key comes in.

kinesis.put_record(
    StreamName="orders",
    Data=json.dumps({
        "customerId": "C100",
        "amount": 1500
    }),
    PartitionKey="C100"
)

Conceptually:

PartitionKey
    "C100"
       │
       ▼
     Hash
       │
       ▼
    Shard 2

Records with the same partition key are routed consistently, which is important for ordering.

For example:

Customer C100:

ADD_TO_CART
     ↓
CHECKOUT
     ↓
PAYMENT
     ↓
ORDER_CONFIRMED

Using:

PartitionKey="C100"

helps preserve the ordering of C100's records within their shard.


---

5. Sequence numbers and ordering

Within a shard, Kinesis assigns records sequence numbers.

Conceptually:

Shard 1

Sequence 1001 → LOGIN
Sequence 1002 → SEARCH
Sequence 1003 → ADD_TO_CART
Sequence 1004 → PURCHASE

This provides ordering within a shard.

But don't assume global ordering across different shards:

Shard 1: A → B → C

Shard 2: X → Y → Z

There isn't necessarily a meaningful ordering between B and Y.

This is why partition-key design matters so much.


---

6. Producers

A producer sends records into Kinesis.

Examples include:

Web applications
Mobile applications
Microservices
IoT devices
Servers
Logging systems

A simple producer:

import boto3
import json

kinesis = boto3.client("kinesis")

def publish_order(order):
    kinesis.put_record(
        StreamName="orders",
        Data=json.dumps(order),
        PartitionKey=order["customerId"]
    )

publish_order({
    "orderId": "ORD-101",
    "customerId": "C100",
    "amount": 2500
})

For higher throughput, you can batch records:

kinesis.put_records(
    StreamName="orders",
    Records=[
        {
            "Data": json.dumps({"orderId": "1"}),
            "PartitionKey": "C100"
        },
        {
            "Data": json.dumps({"orderId": "2"}),
            "PartitionKey": "C200"
        }
    ]
)

PutRecords is generally more efficient when publishing many events.


---

7. Consumers

Consumers read and process records.

Common consumers are:

AWS Lambda
Kinesis Client Library applications
Apache Flink applications
Custom services

A very common architecture is:

Application
     │
     ▼
Kinesis Stream
     │
     ▼
   Lambda
     │
     ├──► DynamoDB
     ├──► S3
     └──► SNS / alerts

A Lambda consumer might look like:

import base64
import json

def lambda_handler(event, context):

    for record in event["Records"]:

        data = base64.b64decode(
            record["kinesis"]["data"]
        )

        message = json.loads(data)

        print("Received:", message)

AWS invokes the Lambda when records become available.


---

8. Checkpointing

Suppose your consumer has processed:

Record 1 ✓
Record 2 ✓
Record 3 ✓
Record 4 ✓
Record 5
Record 6

It needs some way of knowing:

> "I've successfully processed through record 4."



That's checkpointing.

Consumer frameworks such as the Kinesis Client Library (KCL) manage much of this coordination for you.

This becomes especially important with multiple workers:

Stream

Shard 1 ─────► Worker A
Shard 2 ─────► Worker B
Shard 3 ─────► Worker C
Shard 4 ─────► Worker D

If Worker B dies, the consumer group can redistribute its work.


---

9. Retention and replay

One of the most useful characteristics of Kinesis is that reading a message doesn't immediately remove it.

Contrast this mentally with a simple work queue:

Queue

Message → Consumer → removed

Kinesis behaves more like a durable event log:

Kinesis

A → B → C → D → E → F
    ▲             ▲
 Consumer 1    Consumer 2

Different consumers can independently read the same data.

This also allows replaying historical events while they're retained.

For example, suppose you deploy a new fraud algorithm. You could potentially process earlier transaction events again through the new algorithm.


---

10. Multiple consumers

A particularly powerful architecture is:

┌──► Fraud Detection
                         │
Orders ──► Kinesis ──────┼──► Analytics
                         │
                         ├──► Data Lake
                         │
                         └──► Notifications

One producer generates an ORDER_CREATED event:

{
  "eventType": "ORDER_CREATED",
  "orderId": "O100",
  "customerId": "C200",
  "amount": 5000
}

Four completely different systems can consume that same event without the producer knowing about them.

That's a major reason event-driven architectures use streaming platforms.


---

11. Enhanced fan-out

If you have several high-throughput consumers, consumers can otherwise compete for shard read capacity.

Kinesis supports enhanced fan-out, giving registered consumers dedicated read throughput from shards.

Conceptually:

Normal:

              shared throughput
Shard ───────────────────────────
        │        │        │
       C1       C2       C3


Enhanced fan-out:

Shard ─────► C1 dedicated
      ─────► C2 dedicated
      ─────► C3 dedicated

It's useful when multiple applications need low-latency access to the same high-volume stream.


---

12. Kinesis vs SQS

This distinction comes up frequently in system-design interviews.

Concept	Kinesis	SQS

Primary model	Event stream	Message queue
Multiple consumers reading same data	Excellent fit	Different semantics
Ordering	Per shard	FIFO available
Replay	Yes, within retention	Not the main model
Partitioning	Shards/partition keys	Abstracted
Streaming analytics	Excellent	Less suitable
Background jobs	Possible, but often overkill	Excellent


A useful rule of thumb:

"Someone needs to do this job."
              ↓
             SQS

"This event happened; multiple systems may care."
              ↓
           Kinesis

For example:

Generate PDF invoice
       ↓
      SQS
       ↓
 Invoice Worker

versus:

ORDER_CREATED
       ↓
    Kinesis
       │
 ┌─────┼──────┐
 ▼     ▼      ▼
Fraud BI   Inventory


---

13. Kinesis vs Kafka

Conceptually, Kinesis Data Streams and Kafka are much closer relatives.

A simplified mapping is:

Kinesis	Kafka

Stream	Topic
Shard	Partition
Partition key	Message key
Record	Record/message
Sequence number	Offset-like ordering concept
KCL consumers	Kafka consumers


For example:

Kafka
Topic
 ├── Partition 0
 ├── Partition 1
 └── Partition 2

Kinesis
Stream
 ├── Shard 0
 ├── Shard 1
 └── Shard 2

There are substantial implementation and operational differences, but this mapping is useful for understanding the mental model.


---

14. A realistic architecture

Imagine you're building an e-commerce platform:

┌───────────────┐
                │ Order Service │
                └───────┬───────┘
                        │
                  ORDER_CREATED
                        │
                        ▼
                ┌───────────────┐
                │    Kinesis    │
                └───────┬───────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
      Analytics       Fraud       Inventory
       Lambda         Service       Service
          │             │             │
          ▼             ▼             ▼
          S3          Alerts        DynamoDB

Producer:

def order_created(order):

    event = {
        "eventType": "ORDER_CREATED",
        "orderId": order["id"],
        "customerId": order["customerId"],
        "amount": order["amount"]
    }

    kinesis.put_record(
        StreamName="order-events",
        Data=json.dumps(event),
        PartitionKey=order["customerId"]
    )

Now the order service is decoupled from analytics, fraud detection, and inventory processing.

The core mental model

If you remember only six things, remember:

KINESIS STREAM
     │
     ├── contains SHARDS
     │
     ├── shards contain RECORDS
     │
     ├── PRODUCERS write records
     │
     ├── PARTITION KEYS route records
     │
     ├── CONSUMERS read records
     │
     └── records can be retained/replayed

So the flow is essentially:

Producer
   │
   │ PutRecord
   ▼
Partition Key
   │
   ▼
Kinesis Stream
   │
   ├── Shard 1 ──► records
   ├── Shard 2 ──► records
   └── Shard 3 ──► records
         │
         ▼
     Consumers
         │
    ┌────┼────┐
    ▼    ▼    ▼
 Lambda App  Flink

The next concepts worth learning are hot shards, partition-key design, Lambda batch processing, retries/duplicates/idempotency, iterator age, resharding, and Kinesis vs Kafka/MSK. Those are where Kinesis becomes particularly interesting in real production system design.