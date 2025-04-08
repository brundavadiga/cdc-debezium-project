#!/bin/bash

# Create Docker network (if it doesn't exist)
docker network create comb_network || echo "Network already exists."
docker network create post-network
docker network connect post-network postgres
docker network connect post-network connect

# Start MSSQL Server container using docker-compose
docker-compose -f db-docker-compose.yml up -d

# Define the container names to check
containers=("mysql" "sqlserver" "postgres" "mariadb" "mongodb")

# Function to check if a specific container is running
check_container() {
    if docker ps --format '{{.Names}}' | grep -q "$1"; then

        echo "$1 is running"
        return 0
    else
        echo "$1 is NOT running"
        return 1
    fi
}

# Track overall status
all_running=true

# Check each container
for container in "${containers[@]}"; do
    if ! check_container "$container"; then
        all_running=false
    fi
done

if [ "$all_running" = true ]; then
    echo "All required database containers are running!"
else
     echo "Some containers are not running!"
fi