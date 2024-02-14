
echo "Closing Postgres related containers"
docker-compose -f ./docker/postgres/docker-compose.yml down
echo "  "

echo "Closing Mage container"
docker-compose -f ./docker/mage/docker-compose.yml down
echo "  "

echo "Closing Metabase container"
docker-compose -f ./docker/metabase/docker-compose.yml down
echo "  "

echo "Closing Kafka related containers"
docker-compose -f ./docker/kafka/docker-compose.yml down
echo "  "

echo "Closing Spark related containers"
chmod +x ./docker/spark/build.sh
echo "  "
docker-compose -f ./docker/spark/docker-compose.yml down
echo "  "

echo "Closed all containers. "