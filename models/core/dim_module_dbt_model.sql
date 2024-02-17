
{{
    config(
        materialized='table',
    )
}}

select *  
    from {{ ref('time_spent') }}
