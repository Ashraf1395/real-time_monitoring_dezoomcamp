

{% set gcs_data = read_from_gcs('de-zoomcamp-project-data', '/historical_data/time_spent.parquet') %}

{{ config(
    materialized='table',
    schema='de_data',
    unique_key='email'
) }}

SELECT *
FROM {{ gcs_data }}

-- select * from {{ copy('gs://de-zoomcamp-project-data/historical_data/time_spent.parquet') }}