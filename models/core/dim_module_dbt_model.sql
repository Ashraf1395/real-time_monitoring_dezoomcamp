{{ config(
    materialized='table',
) }}

WITH 
module_data AS (SELECT * FROM (VALUES
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
) AS module_info(module_id, module_name)),
module_instructor_mapping AS (SELECT * FROM (VALUES
    ('m1', ARRAY[-6, -5, -3]),
    ('m2', ARRAY[-4]),
    ('w1', ARRAY[-8]),
    ('m3', ARRAY[-1]),
    ('m4', ARRAY[-2]),
    ('m5', ARRAY[-3]),
    ('m6', ARRAY[-1, -7]),
    ('w2', ARRAY[-9]),
    ('p_eval', ARRAY[-11]),
    ('p_sub', ARRAY[-11]),
    ('w3', ARRAY[-10])
) AS module_info(module_id, instructor_id))
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
