
echo "Starting Postgres related containers"
docker-compose -f ./docker/postgres/docker-compose.yml up -d
echo "  "

echo "Starting Mage container"
docker-compose -f ./docker/mage/docker-compose.yml up -d
echo "  "

echo "Starting Metabase container"
docker-compose -f ./docker/metabase/docker-compose.yml up -d
echo "  "

echo "Starting Kafka related containers"
docker-compose -f ./docker/kafka/docker-compose.yml up -d
echo "  "

echo "Starting Spark related containers"
chmod +x ./docker/spark/build.sh
./docker/spark/build.sh
echo "  "
docker-compose -f ./docker/spark/docker-compose.yml up -d
echo "  "

echo "Started all containers you can check their ps here:"
docker ps