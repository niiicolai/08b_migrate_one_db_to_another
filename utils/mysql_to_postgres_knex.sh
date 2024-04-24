###
### This script migrates a MySQL database to a PostgreSQL database using knex
###

echo ""
echo "-- Step 1: Connect to the source MySQL database --"
while true
do
    echo "Source MySQL Host: "
    read source_host

    echo "Source MySQL Port: "
    read source_port

    echo "Source MySQL User: "
    read source_user

    echo "Source MySQL Password: "
    read -s source_password
    
    # Check if it is possible to connect to the database
    # and ouput the list of databases
    # note: 2>/dev/null; is used to suppress the error message
    if mysql -h $source_host -u $source_user -p$source_password -e "show databases" 2>/dev/null; then
        break
    else
        echo "Could not connect to MySQL database"
        echo "Please check your credentials and try again"
        echo "Note: ensure you can execute 'mysql' from the command line"
    fi
done

echo ""
echo "-- Step 2: Select source database --"
while true
do
  echo "Enter the name of the source database: "
  read database
  if mysql -h $source_host -u $source_user -p$source_password -e "use $database
" 2>/dev/null; then
    echo "Selected database: $database"
    break
  else
    echo "Database $database does not exist"
  fi
done


echo ""
echo "-- Step 3: Connect to the target PostgreSQL database --"
while true
do
    echo "Target PostgreSQL Host: "
    read target_host

    echo "Target PostgreSQL Port: "
    read target_port

    echo "Target PostgreSQL User: "
    read target_user

    echo "Target PostgreSQL Password: "
    read -s target_password
    
    # Check if it is possible to connect to the database
    # and ouput the list of databases
    # note: 2>/dev/null; is used to suppress the error message
    if psql -h $target_host -p $target_port -U $target_user -c "SELECT datname FROM pg_database" 2>/dev/null; then
        break
    else
        echo "Could not connect to PostgreSQL database"
        echo "Please check your credentials and try again"
        echo "Note: ensure you can execute 'psql' from the command line"
    fi
done

echo ""
echo "-- Step 4: Check if the target database exists --"
while true
do
    echo "Enter the name of the target database: "
    read target_database
    if psql -h $target_host -p $target_port -U $target_user -d $target_database -c "SELECT datname FROM pg_database" 2>/dev/null; then
        echo "Warning: Database $target_database already exists"
        echo "Do you want to overwrite? (y/n)"
        read overwrite
        if [ "$overwrite" == "y" ]; then
            break
        fi
    else
        break
    fi
done

echo ""
echo "-- Step 5: Drop and create the target database --"
if [ "$overwrite" == "y" ]; then
    echo "Dropping database $target_database"
    psql -h $target_host -p $target_port -U $target_user -d postgres -c "DROP DATABASE $target_database"
fi
echo "Creating database $target_database"
psql -h $target_host -p $target_port -U $target_user -d postgres -c "CREATE DATABASE $target_database"

echo ""
echo "-- Step 6: Generate knex migration files --"
node src/generateMigrations.js -h $source_host -p $source_port -u $source_user -pw $source_password -d $database -o './migrations' -c 'mysql2'

echo ""
echo "-- Step 7: Generate knex seed files --"
node src/generateSeeds.js -h $source_host -p $source_port -u $source_user -pw $source_password -d $database -o './seeds' -c 'mysql2'

echo ""
echo "-- Step 8: Generate knex configuration file --"
node src/generateKnexFile.js -h $target_host -p $target_port -u $target_user -pw $target_password -d $target_database -c 'pg'

echo ""
echo "-- Step 9: Migrate the database --"
npx knex migrate:latest

echo ""
echo "-- Step 10: Seed the database --"
npx knex seed:run

echo ""
echo "-- Migration complete --"
