#!/bin/sh

echo "[INFO] Bringing instances down (if they're up)..."
docker-compose down
sleep 2

echo "[INFO] Removing old volumes...."
docker volume rm demo_mysql_binary_logs_db-data demo_mysql_binary_logs_db-logs

echo "[INFO] Preparing new volumes..."
cp docker-compose.yml docker-compose.yml.bak

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/^#//g' docker-compose.yml
else
    sed -i 's/^#//g' docker-compose.yml
fi

docker-compose up
sleep 2
docker-compose down

echo "[INFO] Starting now, for reals..."
mv docker-compose.yml.bak docker-compose.yml
docker-compose up -d
sleep 10

echo "[INFO] Loading Database...classicmodels"
docker exec mysql sh -c "mysql < /scripts/mysqlsampledatabase.sql"

echo "[INFO] Result of [show databases]..."
docker exec mysql sh -c "mysql -e 'show databases;'"

