# docker-compose -f ./docker/mage/docker-compose.yml up -d
# docker-compose -f ./docker/postgres/docker-compose.yml up -d


# sudo cp ./orchestration_pipeline/exporter/* ./docker/mage/ashraf-magic/data_exporters/

# sudo cp ./orchestration_pipeline/ingestion/* ./docker/mage/ashraf-magic/data_loaders/

# sudo mkdir ./docker/mage/ashraf-magic/pipelines/late_flower

# sudo cp ./orchestration_pipeline/metadata.yaml ./docker/mage/ashraf-magic/pipelines/late_flower/
# sudo cp ./orchestration_pipeline/__init__.py ./docker/mage/ashraf-magic/pipelines/late_flower/
# sudo cp ./orchestration_pipeline/triggers.yaml ./docker/mage/ashraf-magic/pipelines/late_flower/


# sudo cp ./orchestration_pipeline/io_config.yaml ./docker/mage/ashraf-magic/


# curl -X POST http://127.0.0.1:6789/api/pipeline_schedules/1/pipeline_runs/beaba82164454f1aa4641eb0b37de207



# Define file paths
MAGE_COMPOSE_FILE="./docker/mage/docker-compose.yml"
POSTGRES_COMPOSE_FILE="./docker/postgres/docker-compose.yml"
EXPORTER_DIR="./orchestration_pipeline/exporter/"
INGESTION_DIR="./orchestration_pipeline/ingestion/"
IO_CONFIG_FILE="./orchestration_pipeline/io_config.yaml"
PIPELINE_SCHEDULE_ID="1"
PIPELINE_RUN_ID="1b102c7e768f4f4d97c1b01a3902a191"
API_ENDPOINT="http://127.0.0.1:6789/api/pipeline_schedules/${PIPELINE_SCHEDULE_ID}/pipeline_runs/${PIPELINE_RUN_ID}"

echo "Starting Docker services..."
# Start Docker services
docker-compose -f "$MAGE_COMPOSE_FILE" up -d
docker-compose -f "$POSTGRES_COMPOSE_FILE" up -d
echo "Copying exporters and loaders..."
# Copy exporters and loaders
sudo cp "${EXPORTER_DIR}"* ./docker/mage/${PROJECT_NAME}/data_exporters/
sudo cp "${INGESTION_DIR}"* ./docker/mage/${PROJECT_NAME}/data_loaders/

echo "Creating directory and copying files for late_flower pipeline..."
# Create directory and copy files for late_flower pipeline
sudo mkdir -p ./docker/mage/${PROJECT_NAME}/pipelines/late_flower
sudo cp ./orchestration_pipeline/{metadata.yaml,__init__.py,triggers.yaml} ./docker/mage/${PROJECT_NAME}/pipelines/late_flower/

echo "Copying io_config.yaml..."
# Copy io_config.yaml
sudo cp "$IO_CONFIG_FILE" ./docker/mage/${PROJECT_NAME}/

echo "Waiting for Docker services to be up and running..."
# Wait for Docker services to be up and running
until docker-compose -f "$MAGE_COMPOSE_FILE" -f "$POSTGRES_COMPOSE_FILE" ps --quiet; do
    sleep 1
done

echo "Triggering pipeline run..."
# Trigger pipeline run
curl -X POST "$API_ENDPOINT"

echo "Pipeline run triggered successfully."