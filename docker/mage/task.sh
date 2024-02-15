sudo cp ./docker/mage/batch_pipeline/exporter/* ./docker/mage/ashraf-magic/data_exporters/

sudo cp ./docker/mage/batch_pipeline/ingestion/* ./docker/mage/ashraf-magic/data_loaders/

sudo mkdir ./docker/mage/ashraf-magic/pipelines/late_flower

sudo cp ./docker/mage/batch_pipeline/metadata.yaml ./docker/mage/ashraf-magic/pipelines/late_flower/
sudo cp ./docker/mage/batch_pipeline/__init__.py ./docker/mage/ashraf-magic/pipelines/late_flower/
sudo cp ./docker/mage/batch_pipeline/triggers.yaml ./docker/mage/ashraf-magic/pipelines/late_flower/


sudo cp ./docker/mage/batch_pipeline/io_config.yaml ./docker/mage/ashraf-magic/


curl -X POST http://127.0.0.1:6789/api/pipeline_schedules/1/pipeline_runs/beaba82164454f1aa4641eb0b37de207


