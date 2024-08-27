blogdb=# SELECT oid, datname FROM pg_database;
  oid  |  datname  
-------+-----------
     5 | postgres
 16385 | maria
     1 | template1
     4 | template0
 16390 | test
 24623 | blogdb
(6 rows)

blogdb=# select to_regnamespace('public')::oid;
 to_regnamespace 
-----------------
            2200


                                                              Table "public.countries"
          Column          |     Type     | Collation | Nullable |           Default            | Storage  | Compression | Stats target | Description 
--------------------------+--------------+-----------+----------+------------------------------+----------+-------------+--------------+-------------
 id                       | integer      |           | not null | generated always as identity | plain    |             |              | 
 name                     | text         |           | not null |                              | extended |             |              | 
 alpha_2                  | character(2) |           | not null |                              | extended |             |              | 
 alpha_3                  | character(3) |           | not null |                              | extended |             |              | 
 numeric_3                | character(3) |           | not null |                              | extended |             |              | 
 iso_3166_2               | text         |           | not null |                              | extended |             |              | 
 region                   | text         |           |          |                              | extended |             |              | 
 sub_region               | text         |           |          |                              | extended |             |              | 
 intermediate_region      | text         |           |          |                              | extended |             |              | 
 region_code              | character(3) |           |          |                              | extended |             |              | 
 sub_region_code          | character(3) |           |          |                              | extended |             |              | 
 intermediate_region_code | character(3) |           |          |                              | extended |             |              | 
Indexes:
    "countries_pkey" PRIMARY KEY, btree (id)
    "countries_name_key" UNIQUE CONSTRAINT, btree (name)
Access method: heap


blogdb=# SELECT * FROM pg_class WHERE relnamespace = to_regnamespace('public')::oid;
  oid  |      relname       | relnamespace | reltype | reloftype | relowner | relam | relfilenode | reltablespace | relpages | reltuples | relallvisible | reltoastrelid | relhasindex | relisshared | relpersistence | relkind | relnatts | relchecks | relhasrules | relhastriggers | relhassubclass | relrowsecurity | relforcerowsecurity | relispopulated | relreplident | relispartition | relrewrite | relfrozenxid | relminmxid | relacl | reloptions | relpartbound 
-------+--------------------+--------------+---------+-----------+----------+-------+-------------+---------------+----------+-----------+---------------+---------------+-------------+-------------+----------------+---------+----------+-----------+-------------+----------------+----------------+----------------+---------------------+----------------+--------------+----------------+------------+--------------+------------+--------+------------+--------------
 24624 | countries_id_seq   |         2200 |       0 |         0 |    16384 |     0 |       24624 |             0 |        1 |         1 |             0 |             0 | f           | f           | p              | S       |        3 |         0 | f           | f              | f              | f              | f                   | t              | n            | f              |          0 |            0 |          0 |        |            | 
 24625 | countries          |         2200 |   24627 |         0 |    16384 |     2 |       24625 |             0 |        4 |       249 |             0 |         24628 | t           | f           | p              | r       |       12 |         0 | f           | f              | f              | f              | f                   | t              | d            | f              |          0 |         3779 |          1 |        |            | 
 24630 | countries_pkey     |         2200 |       0 |         0 |    16384 |   403 |       24630 |             0 |        2 |       249 |             0 |             0 | f           | f           | p              | i       |        1 |         0 | f           | f              | f              | f              | f                   | t              | n            | f              |          0 |            0 |          0 |        |            | 
 24632 | countries_name_key |         2200 |       0 |         0 |    16384 |   403 |       24632 |             0 |        2 |       249 |             0 |             0 | f           | f           | p              | i       |        1 |         0 | f           | f              | f              | f              | f                   | t              | n            | f              |          0 |            0 |          0 |        |            | 
(4 rows)