{{ config(
    materialized='table',
    schema='de_data',
    unique_key='email'
) }}

select email
from {{ ref('time_spent') }}



