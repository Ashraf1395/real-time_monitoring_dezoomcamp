select *
from {{ source('gs://my_bucket', 'my_file.csv') }}

-- select * from {{ copy('gs://de-zoomcamp-project-data/historical_data/time_spent.parquet') }}