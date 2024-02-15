sudo cp ./docker/mage/batch_pipeline/exporter/* ./docker/mage/ashraf-magic/data_exporters/

sudo cp ./docker/mage/batch_pipeline/ingestion/* ./docker/mage/ashraf-magic/data_loaders/

sudo mkdir ./docker/mage/ashraf-magic/pipelines/late_flower

sudo cp ./docker/mage/batch_pipeline/metadata.yaml ./docker/mage/ashraf-magic/pipelines/late_flower/
sudo cp ./docker/mage/batch_pipeline/__init__.py ./docker/mage/ashraf-magic/pipelines/late_flower/
sudo cp ./docker/mage/batch_pipeline/triggers.yaml ./docker/mage/ashraf-magic/pipelines/late_flower/


sudo cp ./docker/mage/batch_pipeline/io_config.yaml ./docker/mage/ashraf-magic/


curl -X POST http://127.0.0.1:6789/api/pipeline_schedules/4/pipeline_runs/515ea1cd64dc4cea8ec0ab0226dcd356 