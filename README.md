# MySQL Migration Tool
The repository contains a simple bash script making it easy to migrate from a MySQL to another MySQL database or from a MySQL to a PostgreSQL database. The script utilizes the `mysqldump` when only MySQL databases are involved, and it uses `knex` migration and seeder files to migrate from MySQL to PostgreSQL. Note: **The tool is created for educational purpose and it is not suitable for production purposes.**

## Dependencies
The `PG_ONLY` dependencies are only required if you want to migrate from MySQL to PostgreSQL.
* `REQUIRED` - MySQL (https://www.mysql.com/)
* `PG_ONLY` - PostgreSQL (https://www.postgresql.org/)

## Install
1. Clone the repository.
2. Run `npm install`. 

## Usage
Execute the script and follow the steps.
```
$ bash main.sh
```

### MySQL to PostgrSQL Example
```
$ bash main.sh

-- MySQL Database Migration Tool --
This tool will help you migrate a MySQL database to another MySQL or PostgreSQL database
Please follow the steps below to complete the migration

-- Select a migration option --
1) MySQL to MySQL using mysqldump
2) MySQL to PostgreSQL using knex
3) Exit
#? 2

-- MySQL to PostgreSQL Migration using knex --

-- Step 1: Connect to the source MySQL database --
Source MySQL Host:
localhost
Source MySQL Port:
3306
Source MySQL User:
root
Source MySQL Password:
+--------------------+
| Database           |
+--------------------+
| test               |
| test_copy          |
| ...                |
+--------------------+

-- Step 2: Select source database --
Enter the name of the source database:
test
Selected database: test

-- Step 3: Connect to the target PostgreSQL database --
Target PostgreSQL Host:
localhost
Target PostgreSQL Port:
5432
Target PostgreSQL User:
root
Target PostgreSQL Password:

  datname
-----------
 postgres
 template1
 template0
 test
(4 rows)



-- Step 4: Check if the target database exists --
Enter the name of the target database:
test
  datname
-----------
 postgres
 template1
 template0
 test
(4 rows)


Warning: Database test already exists
Do you want to overwrite? (y/n)
y

-- Step 5: Drop and create the target database --
Dropping database test
DROP DATABASE
Creating database test
CREATE DATABASE

-- Step 6: Generate knex migration files --
Migrations generated successfully

-- Step 7: Generate knex seed files --
Seeds generated successfully

-- Step 8: Generate knex configuration file --
Knexfile.js generated successfully

-- Step 9: Migrate the database --
Using environment: development
Batch 1 run: 12 migrations

-- Step 10: Seed the database --
Using environment: development
Ran 8 seed files

-- Migration complete --

```

### MySQL to MySQL Example
```
$ bash main.sh

-- MySQL Database Migration Tool --
This tool will help you migrate a MySQL database to another MySQL or PostgreSQL database
Please follow the steps below to complete the migration

-- Select a migration option --
1) MySQL to MySQL using mysqldump
2) MySQL to PostgreSQL using knex
3) Exit
#? 1

-- MySQL to MySQL Migration using mysqldump --

-- Step 1: Connect to the source MySQL database --
Source MySQL Host:
localhost
Source MySQL User:
root
Source MySQL Password:

+--------------------+
| Database           |
+--------------------+
| test               |
| test_copy          |
| ...                |
+--------------------+

-- Step 2: Select source database --
Enter the name of the source database:
test
Selected database: test

-- Step 3: Create a dump of the source database --
mysqldump: [Warning] Using a password on the command line interface can be insecure.
Dump created at output/dump_2024-04-24_23-44-58.sql

-- Step 5: Connect to the target database --
Target Host:
localhost
Target User:
root
Target Password:

+--------------------+
| Database           |
+--------------------+
| test               |
| test_copy          |
| ...                |
+--------------------+

-- Step 6: Select target database --
Enter the name of the database to migrate to:
test_copy
Database test_copy already exists
Do you want to overwrite it? (y/n)
y

-- Step 7: Migrate the database --
Dropping database test_copy
mysql: [Warning] Using a password on the command line interface can be insecure.
Creating database test_copy
mysql: [Warning] Using a password on the command line interface can be insecure.
Modifying dump to use test_copy
Restoring dump to test_copy
mysql: [Warning] Using a password on the command line interface can be insecure.

-- Step 8: Clean up --
Do you want to delete the dump file? (y/n)
y
Migration complete

```

## Todo
- Add support for references.
- Add support for unique constraints
