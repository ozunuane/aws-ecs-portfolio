#!/bin/bash

# Replace these variables with your actual values
DB_CLUSTER_IDENTIFIER="mongo-staging-combyn"
MASTER_USERNAME="root"
MASTER_PASSWORD="rootpassword"
NEW_DATABASE_NAME="combyn"

# Create the DocumentDB database
aws docdb create-db-instance \
  --db-instance-identifier $NEW_DATABASE_NAME \
  --db-instance-class db.r5.large \  # Replace with your desired instance type
  --db-cluster-identifier $DB_CLUSTER_IDENTIFIER \
  --engine docdb \
  --master-username $MASTER_USERNAME \
  --master-user-password $MASTER_PASSWORD

# Wait for the database creation to complete
echo "Waiting for the database to become available..."
aws docdb wait db-instance-available --db-instance-identifier $NEW_DATABASE_NAME

echo "Database $NEW_DATABASE_NAME has been created successfully."



aws ecs execute-command --cluster dev-cluster --task 0818873f28e44d498615a339fc51f37a --container mongodb-staging	 --interactive --command "mongo"

