# 🐘 PostgreSQL Cheat Sheet

Documentation: https://www.postgresql.org/docs/current/

Don't forget semi-colon `;` at the end of each psql command to run it!

## Creating a databse / table

`CREATE DATABASE` or `CREATE TABLE` followed by `[name]`

```sql
CREATE TABLE cars (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 2) NOT NULL
);
```

## Updating a table

`ALTER TABLE` followed by `[table_name]` and adding whatever needed (e.g. column)
`ADD COLUMN` (needs column name and data type!, e.g. `INTEGER`)

```sql
ALTER TABLE table_name
ADD COLUMN new_column_name column_type;
```

## Deleting a database / table

! This is a powerful command - careful !
See [Bobby Tables - preventing SQL injection](https://bobby-tables.com/)

`DROP DATABASE` or `DROP TABLE` followed by `[name]`

## Selecting and Filtering

```sql
SELECT country_of_birth, COUNT(*) FROM random_people GROUP BY country_of_birth HAVING COUNT(*) >= 40 ORDER BY country_of_birth;
```

`SELECT` column names separated by comma, or `*` for all, `FROM` `[table name]`

`COUNT()` returns the number of rows that match a specified condition

`COUNT(*) AS` `[new column name]` after a column will create a new column with the counts of the entries in that before mentioned column (only works together with `GROUP BY`)

`GROUP BY` `[column name]` (when using `COUNT(*)` - needs to be same column)

`HAVING` followed by a filter to be applied within the grouping. `HAVING` always comes after `GROUP BY`, but before
`ORDER BY` and `LIMIT`.

> When we want to limit the results of a query based on values of the individual rows, use `WHERE`. When we want to limit the results of a query based on an aggregate property, use `HAVING`.

`ORDER BY` `[column name]` to sort the results by specified column in either `ASC`ending (default) or `DESC`ending order

```sql
SELECT * FROM random_people WHERE gender = 'Female' AND country_of_birth = 'Germany' OR country_of_birth = 'Austria' AND gender <> 'Male' AND date_of_birth BETWEEN DATE '2000-01-01' AND '2000-12-31' LIMIT 10 OFFSET 5;
```

`WHERE` specifies the conditions for filtering rows
`AND` combines multiple conditions that must all be true
`OR` combines multiple conditions where at least one must be true
`<>` means "not equal to"
`BETWEEN` specifies a range of values
`LIMIT` specifies the maximum number of rows to return
`OFFSET` specifies the number of rows to skip before starting to return rows

```sql
SELECT * FROM random_people WHERE gender NOT IN ('Female','Male');
SELECT * FROM random_people WHERE country_of_birth IN ('Nigeria);
```

`NOT` / `NOT IN` specifies an array of values to include / exclude

```sql
SELECT * FROM random_people WHERE email LIKE '%google.%';
SELECT * FROM random_people WHERE first_name ='___';
```

`LIKE` is used for pattern matching
`%` matches any sequence of characters
`_` matches any single character

```sql
SELECT DISTINCT country_of_birth FROM random_people WHERE country_of_birth ILIKE 'n%';
```

`SELECT DISTINCT` selects unique values
`ILIKE` is a case-insensitive pattern matching operator

## Column Referencing

Any column mentioned after a `SELECT` gets a reference number "behind the scenes" that can be used for further statements in order not to repeat ourselves. (Indexed from `1`)

For example:

```sql
SELECT category, price, AVG(downloads)
FROM fake_apps
GROUP BY category, price;
```

Can be written:

```sql
SELECT category, price, AVG(downloads)
FROM fake_apps
GROUP BY 1, 2;
```

## Aggregation

`MAX`/`MIN`/`AVG`/`SUM` and `(column_name) ` returns the maximum / minimum / average / sum value of a column

```sql
SELECT ROUND(AVG(price), 2) AS dicsounted FROM cars;
```

`ROUND(expression, precision)` rounds a numeric expression to a specified precision

## Date & Time

`SELECT NOW()` returns the current date and time

```sql
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
```

`EXTRACT(field FROM source)` retrieves a specific field (such as year, month, day) from a date or time expression.

```sql
SELECT NOW() + INTERVAL '6 MONTH';
```

`INTERVAL` adds or subtracts a specific amount of time from a date or time.

```sql
test=# SELECT first_name, last_name, date_of_birth, AGE(NOW(), date_of_birth) AS age FROM person;
```

`AGE()` subtracts the 2nd argument from the 1st

## COALESCE & NULL

```sql
SELECT COALESCE(NULL, NULL, 3, 4) AS number;
SELECT COALESCE(email, 'N/A') FROM random_people;
```

`COALESCE()` returns the first non-null expression
second parameter will be used as a default value for NULL values

```sql
SELECT NULLIF(10, 10); -- Returns NULL
SELECT NULLIF(10, 1);  -- Returns 10
```

`NULLIF(expression1, expression2)` returns NULL if both expressions are equal; otherwise, it returns the first expression.

## Type Casting

```sql
SELECT NOW()::DATE;
SELECT NOW()::TIME with time zone;
```

converts one data type into another

## Inserting into a Table

`INSERT INTO` table name (list column names) `VALUES` (list of values to insert in sequence of before mentioned columns)

```sql
INSERT INTO persons (first_name, last_name) VALUES ('Ria', 'Scholz');
```

## Conflict Handling

```sql
INSERT INTO random_people (id, first_name, last_name, gender, email, date_of_birth, country_of_birth)
VALUES (2017, 'Russell', 'Ruddoch', 'Male', 'rrudoch7@hhs.gov.uk', DATE '1952-09-25', 'Norway')
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, first_name = EXCLUDED.first_name;
```

`INSERT INTO ... ON CONFLICT` allows you to insert data into a table but specify how to handle conflicts if a unique constraint (such as a primary key or unique column) is violated

`ON CONFLICT (column_name)` defines which column(s) should be checked for conflicts
`DO UPDATE` tells the database what to do if a conflict occurs
`EXCLUDED.column_name` refers to the value that was intended to be inserted but was excluded due to the conflict.
`ON CONFLICT() ... DO NOTHING` skips the insert if a conflict occurs without performing any updates

## Update a Table Record

`UPDATE` which table name `SET` column name `=` new value `WHERE` which row in the table you want to change (identifier) `=` matching value. e.g. person with id 4 gets a car with id 1.

```sql
UPDATE persons SET car_id = 1 WHERE id = 4;
```

## Delete a Table Record

`DELETE FROM` which table name `WHERE` which row in the table you want to change (identifier) `=` matching value. e.g. deletes person with id 7 from the table persons.

```sql
DELETE FROM persons WHERE id = 7;
```

## Inner Joins

Combines two tables with records that have foreign key values.

`SELECT` the columns to display `FROM` which table `JOIN`ed with which other table `ON` which **table.columns** (foreign key) to match.

```sql
SELECT persons.first_name, cars.make, cars.model, cars.price FROM persons JOIN cars ON persons.car_id = cars.id;
```

![INNER JOIN](join.png)

## Left Joins

Combines two tables with all records, also ones without foreign key values.

`SELECT` the columns to display `FROM` which table `LEFT JOIN`ed with which other table `ON` which **table.columns** (foreign key) to match. This will keep all records from table A even if there are no records for some of them in the table B.

```sql
SELECT * FROM persons LEFT JOIN cars ON cars.id = persons.car_id;
```

![LEFT JOIN](leftJoin.png)

If both tables have same column matches you can simply use `USING (column name)`

```sql
SELECT * FROM persons LEFT JOIN cars USING (car_uid);
```

## Constraints

Constraints are rules applied to table columns that ensure data integrity, such as:

- primary key
- unique
- check

```sql
ALTER TABLE persons ADD PRIMARY KEY (id);
ALTER TABLE random_people ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE person ADD UNIQUE (email);
ALTER TABLE persons DROP CONSTRAINT person_pkey;
```

`ALTER TABLE` is used to add, drop, or modify constraints on a table
`ADD UNIQUE (column)` adds a unique constraint on the specified column

```sql
ALTER TABLE random_people ADD CONSTRAINT gender_constraint CHECK (gender = 'Male' OR gender = 'Female');
```

`ADD CONSTRAINT constraint_name` adds a new constraint and naming it
`CHECK (condition)` defines a condition that every row in the table must satisfy

## Generate CSV

`\copy` command and in () the actual query `TO` filepath (new filename.extension) `DELIMITER` and if `CSV HEADER` true or not.

```sql
\copy (SELECT * FROM persons LEFT JOIN cars ON persons.car_id = cars.id ORDER BY persons.id) TO '/Users/ria/Desktop/persons.csv' DELIMITER ',' CSV HEADER;
```

## Sequencing

If table description has an id serial (or any other serialized column) it will have a function to call the next increment.

![\d persons](describeTable.png)

View current serial number `tablename_columnname_seq`:

```sql
SELECT * FROM persons_id_seq;
```

Invoke function and increment this value:

```sql
SELECT nextval('persons_id_seq'::regclass)
```

![sequence](seq.png)

reseting the serial sequence:

```sql
ALTER SEQUENCE persons_id_seq RESTART WITH 1000;
```

setting the sequence to a specific value

```sql
SELECT setval('random_people_id_seq', (SELECT MAX(id) FROM random_people));
```

`setval(sequence_name, value_to_set)`

# Extensions

View available extensions:

```sql
SELECT * FROM pg_available_extensions;
```

Install an extension (in double quotes):

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

# Important Keyboard Shortcut Commands

| Shortcut             | Description                                             |
| -------------------- | ------------------------------------------------------- |
| `psql`               | start postgresql                                        |
| `\q`                 | quit postgresql                                         |
| `\l`                 | lists databases                                         |
| `\c [database name]` | connect to databse                                      |
| `\d`                 | describe databases (shows tables)                       |
| `\d [table name]`    | describes specific table                                |
| `\dt`                | describes tables in current database                    |
| `\d+ [table name]`   | describes table with metadata                           |
| `\df`                | list of installed function                              |
| `CTRL`+`L`           | clear screen                                            |
| `\x`                 | toggle expanded display (vertical alignment per record) |
| `\i [FILE PATH]`     | execute a sql file (queries)                            |
| `\s`                 | show query history                                      |
| `\s [FILE PATH]`     | save query history to a file                            |

# Understanding postgres structure

(from https://drew.silcock.dev/blog/how-postgres-stores-data-on-disk/)

Postgres stores all its data in a directory called `/var/lib/postgresql/data`

| Directory            | Explanation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| base/                | Contains a subdirectory for each database. Inside each sub-directory are the files with the actual data in them. We’ll dig into this more in a second.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| global/              | Directly contains files for cluster-wide tables like pg_database.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| pg_commit_ts/        | As the name suggests, contains timestamps for transaction commits. We don’t have any commits or transactions yet, so this is empty.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| pg_dynshmem/         | Postgres uses multiple processes (not multiple threads, although there has been discussion around it) so in order to share memory between processes, Postgres has a dynamic shared memory subsystem. This can use shm_open, shmget or mmap on Linux – by default it uses shm_open. The shared memory object files are stored in this folder.                                                                                                                                                                                                                                                                                                                                                                                                                          |
| pg_hba.conf          | This is the Host-Based Authentication (HBA) file which allows you to configure access to your cluster based on hostname. For instance, by default this file has host all all 127.0.0.1/32 trust which means “trust anyone connecting to any database without a password if they’re connecting from localhost”. If you’ve ever wondered why you don’t need to put your password in when running psql on the same machine as the server, this is why.                                                                                                                                                                                                                                                                                                                   |
| pg_ident.conf        | This is a user name mapping file which isn’t particularly interesting for our purposes.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| pg_logical/          | Contains status data for logical decoding. We don’t have time to talk about how the Write-Ahead Log (WAL) works in full, but in short, Postgres writes changes that it’s going to make to the WAL, then if it crashes it can just re-read and re-run all the operations in the WAL to get back to the expected database state. The process of turning the WAL back into the high-level operations – for the purposes of recovery, replication, or auditing – is called logical decoding and Postgres stores files related to this process in here.                                                                                                                                                                                                                    |
| pg_multixact/        | ”xact” is what the Postgres calls transactions so this contains status data for multitransactions. Multitransactions are a thing that happens when you’ve got multiple sessions who are all trying to do a row-level lock on the same rows.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| pg_notify/           | In Postgres you can listen for changes on a channel and notify listeners of changes. This is useful if you have an application that wants to action something whenever a particular event happens. For instance, if you have an application that wants to know every time a row is added or updated in a particular table so that it can synchronise with an external system. You can set up a trigger which notifies all the listeners whenever this change occurs. Your application can then listen for that notification and update the external data store however it wants to.                                                                                                                                                                                   |
| pg_replslot/         | Replication is the mechanism by which databases can synchronise between multiple running server instances. For instance, if you have some really important data that you don’t want to lose, you could set up a couple of replicas so that if your main database dies and you lose all your data, you can recover from one of the replicas. This can be physical replication (literally copying disk files) and logical replication (basically copying the WAL to all the replicas so that the main database can eb reconstructed from the replica’s WAL via logical decoding.) This folder contains data for the various replication slots, which are a way of ensuring WAL entries are kept for particular replicas even when it’s not needed by the main database. |
| pg_serial/           | Contains information on committed serialisable transactions. Serialisable transactions are the highest level of strictness for transaction isolation, which you can read more about in the docs.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| pg_snapshots/        | Contains exported snapshots, used e.g. by pg_dump which can dump a database in parallel.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| pg_stat/             | Postgres calculates statistics for the various tables which it uses to inform sensible query plans and plan executions. For instance, if the query planner knows it needs to do a sequential scan across a table, it can look at approximately how many rows are in that table to determine how much memory should be allocated. This folder contains permanent statistics files calculated form the tables. Understanding statistics is really important to analysing and fixing poor query performance.                                                                                                                                                                                                                                                             |
| pg_stat_tmp/         | Similar to pg_stat/ apart from this folder contains temporary files relating to the statistics that Postgres keeps, not the permanent files.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| pg_subtrans/         | Subtransactions are another kind of transaction, like multitransactions. They’re a way to split a single transaction into multiple smaller subtransactions, and this folder contains status data for them.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| pg_tblspc/           | Contains symbolic references to the different tablespaces. A tablespace is a physical location which can be used to store some of the database objects, as configured by the DB administrator. For instance, if you have a really frequently used index, you could use a tablespace to put that index on a super speedy expensive solid state drive while the rest of the table sits on a cheaper, slower disk.                                                                                                                                                                                                                                                                                                                                                       |
| pg_twophase/         | It’s possible to “prepare” transactions, which means that the transaction is dissociated from the current session and is stored on disk. This is useful for two-phase commits, where you want to commit changes to multiple systems at the same time and ensure that both transactions either fail and rollback or succeed and commit.                                                                                                                                                                                                                                                                                                                                                                                                                                |
| PG_VERSION           | This one’s easy – it’s got a single number in which is the major version of Postgres we’re in, so in this case we’d expect this to have the number 16 in.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| pg_wal/              | This is where the Write-Ahead Log (WAL) files are stored.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| pg_xact/             | Contains status data for transaction commits, i.e. metadata logs.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| postgresql.auto.conf | This contains server configuration parameters, like postgresql.conf, but is automatically written to by alter system commands, which are SQL commands that you can run to dynamically modify server parameters.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| postgresql.conf      | This file contains all the possible server parameters you can configure for a Postgres instance. This goes all the way from autovacuum_naptime to zero_damaged_pages. If you want to understand all the possible Postgres server parameters and what they do in human language, I’d highly recommend checking out postgresqlco.nf                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| postmaster.opts      | This simple file contains the full CLI command used to invoke Postgres the last time that it was run.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

## system catalogs

| description                                               | command                                                                       |
| --------------------------------------------------------- | ----------------------------------------------------------------------------- |
| show name from object identifiers for databases           | `SELECT oid, datname FROM pg_database;`                                       |
| get OID of 'public' namespace (connect to database first) | `SELECT to_regnamespace('public')::oid;`                                      |
| list all tables, indexes etc that live in a namespace     | `SELECT * FROM pg_class WHERE relnamespace = to_regnamespace('public')::oid;` |

see [examples](./pg_classes.sql)
