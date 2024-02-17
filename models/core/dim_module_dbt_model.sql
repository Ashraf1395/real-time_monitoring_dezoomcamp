select *
from {{ ref('time_spent') }}

-- select * from {{ copy('gs://de-zoomcamp-project-data/historical_data/time_spent.parquet') }}