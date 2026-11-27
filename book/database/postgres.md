# PostgreSQL Notes for Professionals Notes for Professionals

PostGIS - GPS
pgAdmin


## Install
- `--with-[perl/python/openssl/ldap]` - add perl, python, openssl, or ldap support
- `--with-blocksize=BLOCKSIZE` - set pagesize in KB (`BLOCKSIZE` must be a power of 2 between 1 and 32)
- `--with-wal-segsize=SEGSIZE` - set size of WAL-Segment size in MB (`SEGSIZE` must be a power of 2 between 1 and 64)


`sudo port list | grep "^postgresql # or brew install postgresql`

`psql`

```
\d tablename
```

## datatypes
SMALLINT, INTEGER, BIGINT, DECIMAL, NUMERIC, REAL, DOUBLE PRECISION, smallserial, serial, BIGSERIAL, int4range, int8range, numrange, TIMESTAMP, DATE, TIME, INTERVAL, tsrange, tstzrange, daterange, point, line, lseg, BOX, path, polygon, CIRCLE, CIDR, INET, macaddr, CHARACTER, character, TEXT

`SELECT INTEGER[]` or `SELECT '{{0,1},{1,2}}';` --drop integer if needed

`WITH arr AS (SELECT ARRAY[0,1,2] int_arr) SELECT int_arr[1:2] FROM arr;`

`ARRAY_DIMS(int_arr), ARRAY_LENGTH(int_arr,1), cardinality..`

`SELECT TO_CHAR('2016-08-12 16:40:32'::TIMESTAMP, 'DD Mon YYYY HH:MI:SSPM`

```
SELECT DATE_TRUNC('week', <>) AS "Week" , COUNT(*)
FROM <>
GROUP BY 1
ORDER BY 1;


SELECT CHAR_LENGTH('ABCDE')

SELECT COALESCE(NULL, NULL, 'HELLO WORLD'); --'HELLO WORLD' or first non null

```


## Command
```
CREATE TABLE person (
person_id BIGINT NOT NULL, -- PRIMARY KEY `ok too`
PRIMARY KEY (person_id)
)

CREATE TABLE people_over_30 AS SELECT * FROM person WHERE age > 30;

CREATE UNLOGGED TABLE person --skips write ahead , faster


CREATE TABLE agencies (
id SERIAL PRIMARY KEY
DATA JSONb NOT NULL -- '{ "title": '
) -- SELECT client, DATA->'title' AS title FROM --; -- WHERE DATA->'title' = '"Dharma Bums"'; -- nested is `WHERE DATA->'author'->>'last_name' = 'Kerouac';`

CREATE TABLE users (
id SERIAL PRIMARY KEY,
agency_id NOT NULL INTEGER REFERENCES agencies(id) DEFERRABLE INITIALLY DEFERRED --ref agency .
)

COPY copy_test FROM '/path/to/file/sample_data.csv' DELIMITER ','; --STDIN

INSERT INTO person (NAME, age) VALUES ('john doe', 25); --INSERT INTO person SELECT * FROM tmp_person WHERE age < 30; -- RETURNING id


postgres=# copy my_table to '/home/postgres/my_table.txt' using delimiters '|' with null as
'null_string' csv header


UPDATE person SET state_code = cities.state_code
FROM cities WHERE cities.city = city;

CREATE DATABASE books_db WITH ENCODING='UTF8' TEMPLATE template0

CREATE TABLE mytable (DATA JSONB NOT NULL);
INSERT INTO mytable VALUES($$
{
"name": "Alice",
$$);

-- SELECT DATA->>'name' FROM mytable WHERE DATA @> '{"name":"Alice"}';


CREATE TABLE users (username TEXT, email TEXT);
CREATE TABLE users_with_password (PASSWORD TEXT) INHERITS (users);

```


## Aggregate
`SELECT AVG(CAST(browser->'resolution'->>'x' AS INTEGER)) AS width` -- ->> is nested for JSONb

`STRING_AGG(NAME, ', ')`

```
WITH sales AS (
SELECT

...
)
SELECT .. from sales JOIN users USING (user_id)
```



Recursive

```
CREATE TABLE empl (
NAME TEXT PRIMARY KEY,
boss TEXT NULL
  REFERENCES NAME
    ON UPDATE CASCADE
    ON DELETE CASCADE
  DEFAULT NULL
);

-- Traversing tree using WITH RECURSIVE
WITH RECURSIVE t(LEVEL,path,boss,NAME) AS (
  SELECT 0,NAME,boss,NAME FROM empl WHERE boss IS NULL
UNION
 SELECT
    LEVEL + 1,
    path || ' > ' || empl.NAME,
    empl.boss,
    empl.NAME
 FROM
    empl JOIN t
    ON empl.boss = t.NAME
    ) SELECT * FROM t ORDER BY path;

```


### Window
https://www.geeksforgeeks.org/postgresql/postgre-window-functions/

1. Ranking Functions
ROW_NUMBER() – sequential numbering.
RANK() – ranking with gaps.
DENSE_RANK() – ranking without gaps.
PERCENT_RANK() – relative rank.
CUME_DIST() – cumulative distribution.


2. Aggregate Functions as Window Functions
Any aggregate can be used with OVER:

SUM(), AVG(), MIN(), MAX(), COUNT()
GeeksforGeeks
GeeksforGeeks
3. Lead/Lag Functions
LAG(value, offset, default) – previous row’s value.
LEAD(value, offset, default) – next row’s value.


4. Value Functions
FIRST_VALUE()
LAST_VALUE()
NTH_VALUE()


5. Distribution Functions
NTILE(n) – divides rows into buckets.


### Recurse
sum of integers
```
WITH RECURSIVE t(n) AS (
VALUES (1)
UNION ALL
SELECT n+1 FROM t WHERE n < 100
)
SELECT SUM(n) FROM t;
```


## func
```
CREATE FUNCTION get_film_count() RETURNS int
{
SELECT COUNT(*) FROM films;
}


CREATE OR REPLACE FUNCTION totalRecords ()
RETURNS integer AS $total$
declare
	total integer;
BEGIN
   SELECT count(*) into total FROM COMPANY;
   -- raise exception USING message = 'S 164', detail = 'D 164', hint = 'H 164', errcode = 'P2222';
   RETURN total;
EXCEPTION
    -- return NULL if table "total" does not exist
    WHEN undefined_table
    THEN RETURN NULL;
END;
$total$ LANGUAGE plpgsql;

```


trigger

```
CREATE TRIGGER add_created_at_trigger
BEFORE INSERT --after/INSTEAD OF
ON company
FOR EACH ROW--STATEMENT
EXECUTE PROCEDURE totalRecords();

```


### cond

```
IF (TG_OP = 'INSERT') THEN

ELSIF .. THEN
END IF;
RAISE NOTICE 'TRIGER called on % - Log: %', TG_TABLE_NAME, vDescription;
```


### event

Event Type

DDL_COMMAND_START
DDL_COMMAND_END
SQL_DROP

COMMENT ON TABLE table_name IS 'this is student details table';


## Role
CREATE ROLE niceusername WITH PASSWORD 'very-strong-password' LOGIN;


REVOKE CONNECT ON DATABASE nova FROM PUBLIC;
GRANT CONNECT ON DATABASE nova TO USER;

GRANT UPDATE ON ALL SEQUENCES IN SCHEMA public TO read_write; 


## sec
SELECT DIGEST('1', 'sha1')


## Restore backup
pg_dump -Fc -f DATABASE.pgsql DATABASE

psql < backup.sql

pg_restore -d DATABASE DATABASE.pgsql


`psql -p \<port> -U \<username> -d \<DATABASE> -A -F<DELIMITER> -c\<sql TO EXECUTE> \> \<output filename WITH path>

COPY USER FROM '/home/user/user_data.csv'; --  WITH DELIMITER '|' HEADER


## programming
## python
```
import psycopg2
conn = psycopg2.connect("dbname={} host={} user={} password={}".format(
cur=conn.cursor()
sql = 'select * from testtable where id > %s and id < %s'
args = (1, 4)
cur.execute(sql, args)
print(cur.fetchall())
```

## c#
```
using (var conn = new NpgsqlConnection(connString))
{var querystring = "INSERT INTO data (some_field) VALUES (@content)";
conn.Open();
using (var cmd = new NpgsqlCommand(querystring, conn))//cmd.ExecuteReader();(reader.Read()) 
{
var contentString = "Hello World!";
cmd.Parameters.Add("@content", NpgsqlDbType.Text).Value = contentString;
cmd.ExecuteNonQuery();
}
```

## java
```
private static java.sql.Connection connect(String url, String user, String password)
throws ClassNotFoundException, java.sql.SQLException
{
/*
* Register the PostgreSQL JDBC driver.
* This may throw a ClassNotFoundException.
*/
Class.forName("org.postgresql.Driver");
java.util.Properties props = new java.util.Properties();
...
props.setProperty("prepareThreshold", "0");//user
return java.sql.DriverManager.getConnection(url, props);
```


## facts
In PostgreSQL, dblink allows you to execute SQL queries on a remote PostgreSQL database from within your current database session. It’s useful for cross-database queries without setting up replication or exporting/importing data.


ctid is a system column in PostgreSQL that identifies the physical location of a row within a table.

so remove dup

```
DELETE
FROM <SCHEMA_NAME>.<Table_NAME>
WHERE
ctid NOT IN
(
SELECT
MAX(ctid)
```