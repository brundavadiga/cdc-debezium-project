#!/bin/bash

# Create Docker network (if it doesn't exist)
docker network create debezium-network || echo "Network already exists."

# Start the containers using docker-compose
docker compose up -d

# Define the container names to check
containers=("connect" "kafka" "zookeeper" "flask_api")

# Function to check if a specific container is running
check_container() {
    if docker ps --format '{{.Names}}' | grep -q "$1"; then
        echo " $1 is running"
        return 0
    else
        echo " $1 is NOT running"
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

echo "--------------------------------"
if [ "$all_running" = true ]; then
    echo "All required containers are running!"
else
    echo "Some containers are not running!"
fi