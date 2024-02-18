{{ config(
    materialized='table',
) }}

WITH 
module_data AS (
    SELECT module_info[OFFSET(0)] AS module_id,
           module_info[OFFSET(1)] AS module_name
    FROM UNNEST([
        ('m1', 'Containerization and Infrastructure as Code'),
        ('m2', 'Workflow Orchestration'),
        ('w1', 'Data Ingestion'),
        ('m3', 'Data Warehouse'),
        ('m4', 'Analytics Engineering'),
        ('m5', 'Batch processing'),
        ('m6', 'Streaming'),
        ('w2', 'Stream Processing with SQL'),
        ('p_eval', 'Project_Evaluation'),
        ('p_sub', 'Project_Submission'),
        ('w3', 'Piperider')
    ]) AS module_info
),
module_instructor_mapping AS (
    SELECT 'm1' AS module_id, [-6, -5, -3] AS instructor_id UNION ALL
    SELECT 'm2', [-4] UNION ALL
    SELECT 'w1', [-8] UNION ALL
    SELECT 'm3', [-1] UNION ALL
    SELECT 'm4', [-2] UNION ALL
    SELECT 'm5', [-3] UNION ALL
    SELECT 'm6', [-1, -7] UNION ALL
    SELECT 'w2', [-9] UNION ALL
    SELECT 'p_eval', [-11] UNION ALL
    SELECT 'p_sub', [-11] UNION ALL
    SELECT 'w3', [-10]
)
SELECT
    md.module_id,
    md.module_name,
    COALESCE(mim.instructor_id, ARRAY[]) AS instructor_id
FROM
    module_data md
LEFT JOIN
    module_instructor_mapping mim
ON
    md.module_id = mim.module_id