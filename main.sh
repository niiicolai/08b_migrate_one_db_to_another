#!/bin/bash

echo ""
echo "-- MySQL Database Migration Tool --"
echo "This tool will help you migrate a MySQL database to another MySQL or PostgreSQL database"
echo "Please follow the steps below to complete the migration"

mysql_to_mysql="MySQL to MySQL"
mysql_to_postgres_pgloader="MySQL to PostgreSQL using pgloader"
mysql_to_postgres_knex="MySQL to PostgreSQL using knex"
exit="Exit"

echo ""
echo "-- Select a migration option --"
select opt in "$mysql_to_mysql" "$mysql_to_postgres_pgloader" "$mysql_to_postgres_knex" "$exit"
do
    case $opt in
        $mysql_to_mysql)
            echo ""
            echo "-- MySQL to MySQL Migration using mysqldump --"
            ./utils/mysql_to_mysql.sh
            break
            ;;
        $mysql_to_postgres_pgloader)
            echo ""
            echo "-- MySQL to PostgreSQL Migration using pgloader --"
            ./utils/mysql_to_postgres_pgloader.sh
            break
            ;;
        $mysql_to_postgres_knex)
            echo ""
            echo "-- MySQL to PostgreSQL Migration using knex --"
            ./utils/mysql_to_postgres_knex.sh
            break
            ;;
        $exit)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
