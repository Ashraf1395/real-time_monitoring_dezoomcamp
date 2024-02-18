{{ config(
    materialized='table',
) }}


-- Create fact_scores table
WITH fact_scores AS (
    -- Select email and use stack function to unpivot the data
    SELECT
        COALESCE(email, 'No defined') AS email,
        STACK(8,
            'm1', COALESCE(hw_m1, 0.0),
            'm2', COALESCE(hw_m2, 0.0),
            'm3', COALESCE(hw_m3, 0.0),
            'm4', COALESCE(hw_m4, 0.0),
            'm5', COALESCE(hw_m5, 0.0),
            'm6', COALESCE(hw_m6, 0.0),
            'w3', COALESCE(hw_w3, 0.0),
            'p_sub', COALESCE(p, 0.0)
        ) AS (module_id, score)
    FROM (
        -- Calculate the columns and cast them to appropriate data types
        SELECT
            email,
            COALESCE(hw_01a + hw_01b, 0.0) AS hw_m1,
            COALESCE(hw_02, 0.0) AS hw_m2,
            COALESCE(hw_03, 0.0) AS hw_m3,
            COALESCE(hw_04, 0.0) AS hw_m4,
            COALESCE(hw_05, 0.0) AS hw_m5,
            COALESCE(hw_06, 0.0) AS hw_m6,
            COALESCE(hw_piperider, 0.0) AS hw_w3,
            COALESCE(project_01 + project_02, 0.0) AS p
        FROM {{ ref('scores') }}
    ) AS tmp
)

SELECT email,module_id, score from fact_scores