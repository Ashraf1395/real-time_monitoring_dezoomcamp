{{ config(
    materialized='table',
) }}


-- Create fact_time table
WITH fact_time AS 
    -- Select email and use stack function to unpivot the data
    SELECT
        COALESCE(email, 'No defined') AS email,
        STACK(9,
            'm1', COALESCE(homework_m1, 0.0), COALESCE(lectures_m1, 0.0),
            'm2', COALESCE(homework_m2, 0.0), COALESCE(lectures_m2, 0.0),
            'm3', COALESCE(homework_m3, 0.0), COALESCE(lectures_m3, 0.0),
            'm4', COALESCE(homework_m4, 0.0), COALESCE(lectures_m4, 0.0),
            'm5', COALESCE(homework_m5, 0.0), COALESCE(lectures_m5, 0.0),
            'm6', COALESCE(homework_m6, 0.0), COALESCE(lectures_m6, 0.0),
            'w3', COALESCE(homework_w3, 0.0), NULL,
            'p_eval', COALESCE(p_eval_time, 0.0), NULL,
            'p_sub', COALESCE(p_sub_time, 0.0), NULL
        ) AS (module_id, time_homework, time_lectures)
    FROM (
        -- Calculate the columns and cast them to appropriate data types
        SELECT
            email,
            COALESCE(time_homework + time_homework_homework_01b, 0.0) AS homework_m1,
            COALESCE(time_lectures + time_lectures_homework_01b, 0.0) AS lectures_m1,
            time_homework_homework_02 AS homework_m2,
            time_lectures_homework_02 AS lectures_m2,
            time_homework_homework_03 AS homework_m3,
            time_lectures_homework_03 AS lectures_m3,
            time_homework_homework_04 AS homework_m4,
            time_lectures_homework_04 AS lectures_m4,
            time_homework_homework_05 AS homework_m5,
            time_lectures_homework_05 AS lectures_m5,
            time_homework_homework_06 AS homework_m6,
            time_lectures_homework_06 AS lectures_m6,
            time_homework_homework_piperider AS homework_w3,
            time_evaluate + time_evaluate_project_02_eval AS p_eval_time,
            time_project + time_project_project_02_submissions AS p_sub_time
        FROM {{ ref('time_spent') }}
    ) AS tmp


SELECT email,module_id, time_homework, time_lectures from fact_time