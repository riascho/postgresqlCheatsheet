# 🐘 PostgreSQL Cheat Sheet

Documentation: https://www.postgresql.org/docs/current/

Don't forget semi-colon `;` at the end of each psql command to run it!

## Creating a databse / table

`CREATE DATABASE` or `CREATE TABLE` followed by `[name]`

```
CREATE TABLE cars (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 2) NOT NULL
);
```

## Deleting a database / table

! This is a powerful command - careful !
See [Bobby Tables - preventing SQL injection](https://bobby-tables.com/)

`DROP DATABASE` or `DROP TABLE` followed by `[name]`

## Selecting and Filtering

```
SELECT country_of_birth, COUNT(*) FROM random_people GROUP BY country_of_birth HAVING COUNT(*) >= 40 ORDER BY country_of_birth;
```

`SELECT` column names separated by comma, or `*` for all, `FROM` `[table name]`

`COUNT(*) AS` `[new column name]` after a column will create a new column with the counts of the entries in that before mentioned column (only works together with `GROUP BY`)

`GROUP BY` `[column name]` (when using `COUNT(*)` - needs to be same column)

`HAVING` followed by a filter to be applied within the grouping

`ORDER BY` `[column name]` to sort the results by specified column in either `ASC`ending (default) or `DESC`ending order

```
SELECT * FROM random_people WHERE gender = 'Female' AND country_of_birth = 'Germany' OR country_of_birth = 'Austria' AND gender <> 'Male' AND date_of_birth BETWEEN DATE '2000-01-01' AND '2000-12-31' LIMIT 10 OFFSET 5;
```

`WHERE` specifies the conditions for filtering rows
`AND` combines multiple conditions that must all be true
`OR` combines multiple conditions where at least one must be true
`<>` means "not equal to"
`BETWEEN` specifies a range of values
`LIMIT` specifies the maximum number of rows to return
`OFFSET` specifies the number of rows to skip before starting to return rows

```
SELECT * FROM random_people WHERE gender NOT IN ('Female','Male');
SELECT * FROM random_people WHERE country_of_birth IN ('Nigeria);
```

`NOT` / `NOT IN` specifies an array of values to include / exclude

```
SELECT * FROM random_people WHERE email LIKE '%google.%';
SELECT * FROM random_people WHERE first_name ='___';
```

`LIKE` is used for pattern matching
`%` matches any sequence of characters
`_` matches any single character

```
SELECT DISTINCT country_of_birth FROM random_people WHERE country_of_birth ILIKE 'n%';
```

`SELECT DISTINCT` selects unique values
`ILIKE` is a case-insensitive pattern matching operator

## Aggregation

` MAX``MIN``AVG``SUM``(column_name) ` returns the maximum / minimum / average / sum value of a column

```
SELECT ROUND(AVG(price), 2) AS dicsounted FROM cars;
```

`ROUND(expression, precision)` rounds a numeric expression to a specified precision

## Date & Time

`SELECT NOW()` returns the current date and time

```
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
```

`EXTRACT(field FROM source)` retrieves a specific field (such as year, month, day) from a date or time expression.

```
SELECT NOW() + INTERVAL '6 MONTH';
```

`INTERVAL` adds or subtracts a specific amount of time from a date or time.

```
test=# SELECT first_name, last_name, date_of_birth, AGE(NOW(), date_of_birth) AS age FROM person;
```

`AGE()` subtracts the 2nd argument from the 1st

## COALESCE & NULL

```
SELECT COALESCE(NULL, NULL, 3, 4) AS number;
SELECT COALESCE(email, 'N/A') FROM random_people;
```

`COALESCE()` returns the first non-null expression
second parameter will be used as a default value for NULL values

```
SELECT NULLIF(10, 10); -- Returns NULL
SELECT NULLIF(10, 1);  -- Returns 10
```

`NULLIF(expression1, expression2)` returns NULL if both expressions are equal; otherwise, it returns the first expression.

## Type Casting

```
SELECT NOW()::DATE;
SELECT NOW()::TIME with time zone;
```

converts one data type into another

## Inserting into a Table

`INSERT INTO` table name (list column names) `VALUES` (list of values to insert in sequence of beforementioned columns)

```
INSERT INTO persons (first_name, last_name) VALUES ('Ria', 'Scholz');
```

## Conflict Handling

```
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

```
UPDATE persons SET car_id = 1 WHERE id = 4;
```

## Delete a Table Record

`DELETE FROM` which table name `WHERE` which row in the table you want to change (identifier) `=` matching value. e.g. deletes person with id 7 from the table persons.

```
DELETE FROM persons WHERE id = 7;
```

## Inner Joins

Combines two tables with records that have foreign key values.

`SELECT` the columns to display `FROM` which table `JOIN`ed with which other table `ON` which **table.columns** (foreign key) to match.

```
SELECT persons.first_name, cars.make, cars.model, cars.price FROM persons JOIN cars ON persons.car_id = cars.id;
```

![INNER JOIN](join.png)

## Left Joins

Combines two tables with all records, also ones without foreign key values.

`SELECT` the columns to display `FROM` which table `LEFT JOIN`ed with which other table `ON` which **table.columns** (foreign key) to match. This will keep all records from table A even if there are no records for some of them in the table B.

```
SELECT * FROM persons LEFT JOIN cars ON cars.id = persons.car_id;
```

![LEFT JOIN](leftJoin.png)

If both tables have same column matches you can simply use `USING (column name)`

```
SELECT * FROM persons LEFT JOIN cars USING (car_uid);
```

## Constraints

Constraints are rules applied to table columns that ensure data integrity, such as:

- primary key
- unique
- check

```
ALTER TABLE persons ADD PRIMARY KEY (id);
ALTER TABLE random_people ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE person ADD UNIQUE (email);
ALTER TABLE persons DROP CONSTRAINT person_pkey;
```

`ALTER TABLE` is used to add, drop, or modify constraints on a table
`ADD UNIQUE (column)` adds a unique constraint on the specified column

```
ALTER TABLE random_people ADD CONSTRAINT gender_constraint CHECK (gender = 'Male' OR gender = 'Female');
```

`ADD CONSTRAINT constraint_name` adds a new constraint and naming it
`CHECK (condition)` defines a condition that every row in the table must satisfy

## Generate CSV

`\copy` command and in () the actual query `TO` filepath (new filename.extension) `DELIMITER` and if `CSV HEADER` true or not.

```
\copy (SELECT * FROM persons LEFT JOIN cars ON persons.car_id = cars.id ORDER BY persons.id) TO '/Users/ria/Desktop/persons.csv' DELIMITER ',' CSV HEADER;
```

## Sequencing

If table description has an id serial (or any other serialized column) it will have a function to call the next increment.

![\d persons](describeTable.png)

View current serial number `tablename_columnname_seq`:

```
SELECT * FROM persons_id_seq;
```

Invoke function and increment this value:

```
SELECT nextval('persons_id_seq'::regclass)
```

![sequence](seq.png)

reseting the serial sequence:

```
ALTER SEQUENCE persons_id_seq RESTART WITH 1000;
```

setting the sequence to a specific value

```
SELECT setval('random_people_id_seq', (SELECT MAX(id) FROM random_people));
```

`setval(sequence_name, value_to_set)`

# Extensions

View available extensions:

```
SELECT * FROM pg_available_extensions;
```

Install an extension (in double quotes):

```
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
