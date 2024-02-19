{{ config(
    materialized='table',
) }}


-- Create fact_time table
WITH fact_time AS (
    SELECT
        user_id,
        module_id,
        COALESCE(time_homework, 0.0) AS time_homework,
        COALESCE(time_lectures, 0.0) AS time_lectures
    FROM (
        SELECT
            user_id,
            'm1' AS module_id,
            COALESCE(`time_homework` + `time_homework_homework-01b`, 0.0) AS time_homework,
            COALESCE(`time_lectures` + `time_lectures_homework-01b`, 0.0) AS time_lectures
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'm2',
            COALESCE(`time_homework_homework-02`, 0.0),
            COALESCE(`time_lectures_homework-02`, 0.0)
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'm3',
            COALESCE(`time_homework_homework-03`, 0.0),
            COALESCE(`time_lectures_homework-03`, 0.0)
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'm4',
            COALESCE(`time_homework_homework-04`, 0.0),
            COALESCE(`time_lectures_homework-04`, 0.0)
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'm5',
            COALESCE(`time_homework_homework-05`, 0.0),
            COALESCE(`time_lectures_homework-05`, 0.0)
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'm6',
            COALESCE(`time_homework_homework-06`, 0.0),
            COALESCE(`time_lectures_homework-06`, 0.0)
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'w3',
            COALESCE(`time_homework_homework-piperider`, 0.0),
            NULL
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'p_eval',
            COALESCE(`time_evaluate` + `time_evaluate_project-02-eval`, 0.0),
            NULL
        FROM {{ ref('time_spent') }}

        UNION ALL

        SELECT
            user_id,
            'p_sub',
            COALESCE(`time_project` + `time_project_project-02-submissions`, 0.0),
            NULL
        FROM {{ ref('time_spent') }}
    ) AS tmp
)

SELECT user_id, module_id, time_homework, time_lectures FROM fact_time
