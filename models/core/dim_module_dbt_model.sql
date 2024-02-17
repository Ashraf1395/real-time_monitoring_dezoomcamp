{{ config(
    materialized='table',
    schema='de_data',
    unique_key='email'
) }}

select *
from {{ ref('time_spent') }}

