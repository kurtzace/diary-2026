## About
Medalion: bronze - raw, silver is (cleaned), partly joined. Gold is aggre data

CDC: lakehouse

Modern:
ELT: ex, injest, load, trans, analyze AI


## Key Layers: Consumption

| Layer | Purpose | Tools |
| --- | --- | --- |
| Consumption | Dashboards, insights, notebooks, APIs, and curated data access | Amazon Redshift, Azure Synapse, BigQuery |
| Orchestration | Reliability, scheduling, management, dependencies, and controlled flow | AWS Step Functions, Azure Data Factory, Google Cloud Composer |
| Processing | Cleaning, joining, aggregation, customer 360, and summaries | AWS EMR, Azure Synapse Spark, Google Cloud Dataflow |
| Ingestion | Batch and streaming, with reliable data landing | AWS Kinesis, Azure Event Hubs, Google Cloud Pub/Sub |
| Storage | Central system of record for raw and processed data | Amazon S3, Azure Data Lake Storage |

Governance and observability span all layers. Examples include AWS IAM, Azure Purview, and Google Cloud Data Catalog.

Observability dimensions: freshness, distribution, volume, schema, and lineage. Openlineage

Snowflake: modern dw

lakehouse : databricks

Flink: stream


microservices - all separate dbs

Fabrics, Databricks : vendor lock- has all ELT layers

### Managed Open-Source Compatible Services

| Open-source technology | Managed services |
| --- | --- |
| Apache Spark | Databricks, AWS EMR, Azure Synapse |
| Kafka | AWS MSK, Azure Event Hubs, Google Cloud Managed Service for Apache Kafka |


## pipeline
Batch: low cost


stream: realtime, op discipline

Managed connectors: airbyte/fivetran

data contract/schema

SLA

Quality gates

Idempotency: retries - singluar updates/no dupli

Warehouse(cleaned/structured/modelled/speed/reporting)->data lake(repo/schema on read - clickstream/flexibility - low cost scale) - ->lakehouse (convergence/opentable Iceberg/Delta lake/hudi - timetravel, recover,audit, , unify anlytics/ml))

## compute

| Compute model | Flow | Infrastructure | Outcome |
| --- | --- | --- | --- |
| Athena serverless | S3 data lake (Parquet, CSV, JSON, ORC) → Athena SQL managed engine | No servers to manage | Fast query results |
| Trino distributed | S3 data lake (Parquet, CSV, JSON, ORC) → Trino SQL federated queries | Cluster nodes to manage | Fast analytics |

Spark: clean, aggre, large join, dedup, vali, aggre


## orchestrator
scheduling

dependencies

retries

alerts

tools: airflow - dag


Dagster: run when data is ready

## distributed
centeal vs dis

RBAC

Regualotry

Lineage: record , debugging, trust

### Data Mesh vs. Data Fabric

| | Data mesh | Data fabric |
| --- | --- | --- |
| Organizing idea | Domain-oriented data products owned by teams | Shared metadata and automation connect data across environments |
| Example domains or sources | Finance, customer, marketing, sales, operations, business, campaigns, and HR | Cloud, on-premises, IoT, operations, data, and social sources |
| Focus | Make domain teams responsible for useful, discoverable data products | Use metadata and automation to integrate and manage distributed data |

### S3 Data Formats

| Format | Type | Best for | Multi-engine support | Schema evolution | ACID | Recommendation |
| --- | --- | --- | --- | --- | --- | --- |
| Parquet | File | Analytics storage | Excellent | No | No | Always use for analytics files |
| Iceberg | Table | Lakehouse tables | Excellent | Yes | Yes | Default table format |
| Avro | File | Streaming and events | Good | Yes | No | Streaming standard |
| ORC | File | Legacy Hive workloads | Good | Limited | No | Hadoop legacy |
| Delta | Table | Databricks | Limited | Yes | Yes | Databricks focused |


Finops



# Paimon in opensource mag july 26
 Apache Paimon is an open-source lakehouse storage framework built specifically for continuous data ingestion, upserts, and incremental processing. It fuses the benefits of traditional data lake formats with a database-like storage structure to bring real-time streaming updates into data lakes. [1, 2] 
Below is an explanation of the core concepts, setup, and operations covered in the article snippets:
## 1. The Core Architecture
Unlike traditional table formats that are strictly append-only, Paimon leverages Log-Structured Merge-tree (LSM-tree) principles. This means it can accept massive amounts of small updates in real-time and efficiently merge them into larger data files behind the scenes. [1] 
As structured in the text, Paimon sits directly in the middle of a modern data stack: [1] 

* Compute / Streaming Ingestion Engines: Apache Flink, Apache Spark.
* Storage Layer: Distributed file systems or object storage (HDFS, Amazon S3, etc.).
* Workloads: Analytics, Machine Learning, and real-time dashboards. [1] 

------------------------------
## 2. Setting Up Apache Paimon on Linux
To get Paimon running locally on Linux, the article outlines the following key environment preparation steps: [1] 

* Prerequisites: Ensure you have a Linux-based operating system (such as Ubuntu or CentOS) along with a Java Runtime Environment (JRE) installed.
* Download Components: Download Apache Flink and the matching Apache Paimon components.
* Configuration: Create a dedicated local warehouse directory to serve as your storage root. [1] 

The environment variables snippet shown in the document looks like this: [1] 

# Example configuration in flink-conf.yaml
vikas-ubuntu-vm ~/flink-1.14.4
vikas-ubuntu-vm bin/sql-client.sh
paimon-flink-1.14-0.4.1.jar

------------------------------
## 3. Basic Data Operations with SQL
Once set up, you can interact with Paimon tables directly using standard SQL via processing engines like Flink. Paimon is designed around primary-key tables, allowing you to seamlessly process updates and deletes. [1] 
## Creating a Table

CREATE TABLE my_table (
    id INT,
    name STRING,
    dt STRING,
    PRIMARY KEY (dt, id) NOT ENFORCED
) PARTITIONED BY (dt);

## Inserting Data
You can insert rows just like a regular database table: [1] 

INSERT INTO my_table VALUES 
(1, 'a', '2026-09-28'), 
(2, 'b', '2026-09-28');

Because it uses an LSM-tree architecture, if you insert a row containing a duplicate primary key, Paimon treats it as an update (upsert) rather than throwing a duplicate error—overwriting or merging the record based on your engine rules. [2, 3, 4] 
------------------------------
## 4. Primary Use Cases
According to the document, Paimon is ideally deployed for: [1] 

* Streaming Pipelines: Managing low-latency data feeds from message systems like Apache Kafka.
* Change Data Capture (CDC): Continuously streaming updates directly from transactional databases into the lake.
* AI and ML Storage: Serving as a cost-effective, historical database for model training and feature extraction. 





# Pyspark
Big Data Analytics with PySpark
by Warner Chaves - Pluralsight

struc, semi, unstrictured

scala, ml, ai

spark session -> load -> dF -> process -> SQL

## platforms

- On-premises Spark
- AWS EMR
- Google Cloud Dataproc
- Microsoft Fabric
- Databricks

List files in Azure cloud storage with `dbutils`:

```python
dbutils.fs.ls("abfss://pyspark@warnerdatalake.dfs.core.windows.net/")
```

Read a CSV file, use the first row as the header, and infer column types:

```python
df_csv = (
    spark.read
    .option("header", "true")       # Assume first row is header
    .option("inferSchema", "true")  # Infer data types
    .csv(csv_path)
)

print("CSV Data:")
df_csv.show(5) # or limit(20).display()
```

Read JSON data and inspect its inferred schema:

```python
df_json = (
    spark.read
    .json(json_path)
)

print("JSON Schema:")
df_json.printSchema()
print("JSON Data:")
df_json.show(5)
```

Read a Parquet file from Azure cloud storage:

```python
parquet_path = "abfss://pyspark@warnerdatalake.dfs.core.windows.net//imports/customers_data.parquet"
df_customers = spark.read.parquet(parquet_path)

print("Parquet Data:")
df_customers.show(5)
```


.describe()

.summary().display()

## Transform

Filter rows where `age` is greater than 40:

```python
from pyspark.sql import functions as F

df_over_40 = df_customers.filter(F.col("age") > 40); #or df_customers['age']
df_over_40.limit(5).display()
```


`orderBy(df.age.asc())`

Select specific columns:

```python
df_select_columns = df_customers.select("customer_id", "first_name", "country")
df_select_columns.limit(5).display()
```

Rename columns:

```python
df_renamed = (
    df_customers.withColumnRenamed("first_name", "fname")
    .withColumnRenamed("last_name", "lname")
)
df_renamed.limit(5).display()
```

Cast `age` to a string in a new column:

```python
df_casted = df_customers.withColumn("age_str", F.col("age").cast("string"))
```

Create age groups with conditional logic:

```python
df_age_group = df_customers.withColumn(
    "age_group",
    F.when(F.col("age") < 30, "Young")
    .when((F.col("age") >= 30) & (F.col("age") < 50), "Middle-aged")
    .otherwise("Senior")
)
```


`newdf=....drop("ea")`


## Aggregate

Aggregate transaction amounts by category and sort by the total descending:

```python
df_category_total = (
    df_transactions
    .groupBy("category")
    .agg(F.sum("amount").alias("total_amount")) # avg/min # .count
    .orderBy(F.col("total_amount").desc())
)
```

Join transactions with customers on `customer_id`:

```python
df_joined = df_transactions.join(df_customers, on="customer_id", how="inner")
```

Rank transactions per customer by transaction date:

```python
from pyspark.sql.window import Window

window_spec = Window.partitionBy("customer_id").orderBy(F.col("transaction_date").asc())

df_ranked = (
    df_transactions
    .withColumn("row_number", F.row_number().over(window_spec))
    .withColumn("rank", F.rank().over(window_spec))
    .withColumn("dense_rank", F.dense_rank().over(window_spec))
)

df_ranked.limit(5).display()
```

Calculate a seven-row rolling average of transaction amount per customer:

```python
rolling_window = (
    Window.partitionBy("customer_id")
    .orderBy(F.col("transaction_date"))
    .rowsBetween(-6, 0)
)

df_rolling_avg = (
    df_transactions
    .withColumn("rolling_avg_amount", F.avg("amount").over(rolling_window))
)
```

Calculate a cumulative transaction amount per customer:

```python
cumulative_window = (
    Window.partitionBy("customer_id")
    .orderBy(F.col("transaction_date"))
    .rowsBetween(Window.unboundedPreceding, 0)
)

df_running_total = (
    df_transactions
    .withColumn("cumulative_total", F.sum("amount").over(cumulative_window))
)

df_running_total.limit(5).display()
```

Compare each transaction amount with the previous and next transaction for the customer:

```python
df_lag_lead = (
    df_transactions
    .withColumn("previous_transaction_amount", F.lag("amount", 1).over(window_spec))
    .withColumn("next_transaction_amount", F.lead("amount", 1).over(window_spec))
)
```

Approximate distinct customer counts by category with HyperLogLog:

```python
df_hyperloglog = (
    df_transactions
    .groupBy("category")
    .agg(F.approx_count_distinct("customer_id").alias("approx_unique_customers"))
)

df_hyperloglog.limit(5).display()
```



A Bloom filter in Apache Spark is a space-efficient probabilistic data structure that tests whether an element is in a set, guaranteeing no false negatives while allowing a configurable false positive rate


## Performance

Catalyst format: colum : parquet , orc or delta

Cache and persit


Partition by country , groups folders



Bucket(3) by country 

Predicate push down


Write transactions as partitioned Parquet folders by category and transaction date:



```python
partitioned_path = "abfss://pyspark@warnerdatalake.dfs.core.windows.net//exports//transactions_partitioned"

df_transactions.write.mode("overwrite").partitionBy("category", "transaction_date").parquet(partitioned_path)
```

Write transactions in Delta format, partitioned to help prune files for category and date range queries:

```python
delta_path = "abfss://pyspark@warnerdatalake.dfs.core.windows.net//exports//transactions_delta"

df_transactions.write.format("delta").mode("overwrite").partitionBy("category", "transaction_date").save(delta_path)
```

Optimize Delta data layout with Z-ordering on `amount`:

```python
from delta.tables import DeltaTable

delta_table = DeltaTable.forPath(spark, delta_path)
delta_table.optimize().executeZOrderBy("amount")
```
, example amount>n



.cache() on result df - InMemeory table scan


.explain(True) to see exe plan 


.unperisst




Persist filtered transactions in memory and on disk:

```python
from pyspark import StorageLevel

df_persisted = df_transactions.filter(F.col("amount") > 50).persist(StorageLevel.MEMORY_AND_DISK)

# MEMORY_ONLY stores data in RAM; it is fast but can be recomputed if evicted.
# MEMORY_AND_DISK uses RAM first, then disk for partitions that do not fit.
# DISK_ONLY stores data on disk.

# Trigger computation and materialize the persisted DataFrame.
df_persisted.count()

# Verify that the DataFrame is cached.
print(f"Is DataFrame persisted? {df_persisted.is_cached}")
```

Create temporary SQL views for querying DataFrames with Spark SQL:

```python
df_customers.createOrReplaceTempView("customers")
df_transactions.createOrReplaceTempView("transactions")
```



newdf=spark.sql("""

""")

or 

%sql

Create database marketeting
Write the denormalized customer transactions DataFrame as a managed table:

```python
denormalized_df.write.mode("overwrite").saveAsTable("denormalized_customer_transactions")
```





## Viz
my_df=sparkDf.toPandas()

Create an interactive scatter plot with Plotly Express: or matplotlib or seaborn

```python
import plotly.express as px

fig = px.scatter(
    df_pandas,
    x="total_transactions",
    y="avg_transaction_amount",
    text="email",
    title="Avg Transaction Amount vs Total Transactions",
)
fig.update_traces(textposition="top center")
fig.show()
```


