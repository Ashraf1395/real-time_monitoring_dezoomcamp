{{ config(
    materialized='table',
) }}

-- Create user_id and user_type columns
WITH user_data AS (
    -- Assign row numbers as user_id for students
    SELECT
        ROW_NUMBER() OVER (ORDER BY email) AS user_id,
        email,
        'student' AS user_type
    FROM {{ ref('time_spent') }}

    UNION ALL

    -- Add instructor data with negative user_id
    SELECT
        -ROW_NUMBER() OVER () AS user_id,
        email,
        'instructor' AS user_type
    FROM (
        SELECT email FROM (
            SELECT email FROM UNNEST([
                '@Ankush_Khanna.com',
                '@Victoria_Perez_Mola.com', 
                '@Alexey_Grigorev.com', 
                '@Matt_Palmer.com', 
                '@Luis_Oliveira.com', 
                '@Michael_Shoemaker.com', 
                '@Irem_Erturk.com', 
                '@Adrian_Brudaru.com', 
                'To_be_named_Workshop-2', 
                '@CL_Kao.com', 
                'Self'
            ]) AS email
        ) AS instructor_emails
    ) AS instructor_data
)
-- Select user_id, email, and user_type
SELECT user_id, email, user_type
FROM user_data
