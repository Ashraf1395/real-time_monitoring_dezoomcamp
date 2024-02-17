select *
from {{ source('gs://de-zoomcamp-project-data', 'historical_data/time_spent.parquet') }}

-- select * from {{ copy('gs://de-zoomcamp-project-data/historical_data/time_spent.parquet') }}