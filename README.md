# MySQL Migration Tool
The repository contains a simple bash script making it easy to migrate from a MySQL to another MySQL database or from a MySQL to a PostgreSQL database. The script utilizes the `mysqldump` when only MySQL databases are involved, and it uses `pgloader` to handle the process of migrating from MySQL to PostgreSQL.

## Dependencies
The `PG_ONLY` dependencies are only required if you want to migrate from MySQL to PostgreSQL.
* `REQUIRED` - MySQL (https://www.mysql.com/)
* `PG_ONLY` - PostgreSQL (https://www.postgresql.org/)
* `PG_ONLY` - pgloader (https://pgloader.io/)

## Usage
Execute the script and follow the steps.
```
$ bash main.sh
```

### MySQL to MySQL Example
```
$ bash main.sh

-- MySQL Database Migration Tool --
This tool will help you migrate a MySQL database to another MySQL or PostgreSQL database
Please follow the steps below to complete the migration

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
Dump created at output/dump_2024-04-24_18-06-20.sql

-- Step 4: Select the target database type --
1) MySQL
2) PostgreSQL
#? 1
Selected MySQL

-- Step 5: Connect to the target MySQL database --
Target MySQL Host:
localhost
Target MySQL User:
root
Target MySQL Password:

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

### MySQL to PostgrSQL Example
```
$ bash main.sh
```
