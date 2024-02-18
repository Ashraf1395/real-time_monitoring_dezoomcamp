{{ config(
    materialized='table',
) }}

-- Create fact_scores table
WITH fact_scores AS (
    -- Select email and unpivot the data using UNION ALL
    SELECT email, 'm1' AS module_id, COALESCE(`hw-01a` + `hw-01b`, 0.0) AS score FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'm2', COALESCE(`hw-02`, 0.0) FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'm3', COALESCE(`hw-03`, 0.0) FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'm4', COALESCE(`hw-04`, 0.0) FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'm5', COALESCE(`hw-05`, 0.0) FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'm6', COALESCE(`hw-06`, 0.0) FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'w3', COALESCE(`hw-piperider`, 0.0) FROM {{ ref('scores') }}
    UNION ALL
    SELECT email, 'p_sub', COALESCE(`project-01` + `project-02`, 0.0) FROM {{ ref('scores') }}
)

SELECT * FROM fact_scores