###
### This script migrates a MySQL database to another MySQL database
###

echo ""
echo "-- Step 1: Connect to the source MySQL database --"
# Get the source database details
# by looping until a connection is established
while true
do
    echo "Source MySQL Host: "
    read source_host

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
    fi
done


# Get the source database details
# by looping until a valid database is selected
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
echo "-- Step 3: Create a dump of the source database --"
# Check if the output directory exists
if [ ! -d "output" ]; then
  mkdir output
fi
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
dump_file="output/dump_$database_$timestamp.sql"
mysqldump -h $source_host -u $source_user -p$source_password --databases $database > $dump_file
echo "Dump created at $dump_file"


# Get the target database details
# by looping until a connection is established
echo ""
echo "-- Step 5: Connect to the target $target_type database --"
while true
do
    echo "Target $target_type Host: "
    read target_host

    echo "Target $target_type User: "
    read target_user

    echo "Target $target_type Password: "
    read -s target_password
    
    # Check if it is possible to connect to the database
    # and ouput the list of databases
    if mysql -h $target_host -u $target_user -p$target_password -e "show databases" 2>/dev/null; then
        break
    else
        echo "Could not connect to MySQL database"
        echo "Please check your credentials and try again"
    fi
done


# Get the target database details
# by looping until a option is selected
echo ""
echo "-- Step 6: Select target database --"
while true
do
    echo "Enter the name of the database to migrate to: "
    read target_database

    # Check if the database exists
    if mysql -h $target_host -u $target_user -p$target_password -e "use $target_database" 2>/dev/null; then
        echo "Database $target_database already exists"
        echo "Do you want to overwrite it? (y/n)"
        read overwrite
        if [ "$overwrite" == "y" ]; then
            break
        fi
    else
        break
    fi
done


echo ""
echo "-- Step 7: Migrate the database --"
# Drop the target database if overwrite is selected
if [ "$overwrite" == "y" ]; then
    echo "Dropping database $target_database"
    mysql -h $target_host -u $target_user -p$target_password -e "drop database $target_database"
fi


# Create the target database
echo "Creating database $target_database"
mysql -h $target_host -u $target_user -p$target_password -e "create database $target_database"


# Modify the dump file to use the target database instead of the source database
echo "Modifying dump to use $target_database"
sed -i "s/USE \`$database\`/USE \`$target_database\`/g" $dump_file


# Restore the dump to the target database
echo "Restoring dump to $target_database"
mysql -h $target_host -u $target_user -p$target_password $target_database < $dump_file


echo ""
echo "-- Step 8: Clean up --"
# Ask the user if they want to delete the dump file
echo "Do you want to delete the dump file? (y/n)"
read delete_dump
if [ "$delete_dump" == "y" ]; then
    rm $dump_file
fi


# Let the user know the migration is complete
echo "Migration complete"
