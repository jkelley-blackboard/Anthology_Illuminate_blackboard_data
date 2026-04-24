-- ============================================================
-- Rubric Cell-Level Results
-- Returns one row per student attempt per rubric criterion cell
--
-- Join path:
--   RUBRIC_CRITERIA (cell_eval)
--     -> RUBRIC (rubric_eval) via STAGE:parent_source_id = SOURCE_ID
--     -> ATTEMPT via STAGE:attempt_pk1 = ATTEMPT.SOURCE_ID
--     -> PERSON_COURSE -> PERSON / COURSE
--     -> EVALUABLE_COURSE_ITEM -> GRADEBOOK (when available)
--     -> EVALUABLE_ITEM (criterion definition) for criterion name

-- Author : Jeff Kelley, Principal Solutions Engineer, Blackboard Inc.
--          jeff.kelley@blackboard.com
-- Date   : 2026-04-24
-- © Blackboard Inc. All rights reserved.
-- Provided as-is without support or warranty of any kind.
-- ============================================================

SELECT

    -- Course context
    c.COURSE_NUMBER                                         AS course_id
  , c.NAME                                                  AS course_name

    -- Gradebook column
  , gb.NAME                                                 AS gradebook_column_name
  , gb.POSSIBLE_SCORE                                       AS column_possible_score
  , gb.DUE_TIME                                             AS column_due_date

    -- Student
  , p.STAGE:user_id::STRING                                 AS username
  , p.FIRST_NAME
  , p.LAST_NAME
  , p.EMAIL

    -- Attempt context
  , a.ATTEMPT_TIME
  , a.STATUS_SOURCE_DESC                                    AS attempt_status
  , a.LAST_ATTEMPT_IND
  , a.OVERRIDE_IND
  , a.SCORE                                                 AS attempt_score

    -- Rubric-level score (overall)
  , rubric_eval.SCORE                                       AS rubric_total_score
  , rubric_eval.POSSIBLE_SCORE                              AS rubric_possible_score
  , rubric_eval.NORMALIZED_SCORE                            AS rubric_normalized_score
  , rubric_eval.FEEDBACK                                    AS rubric_feedback

    -- Criterion name from EVALUABLE_ITEM
  , ei.NAME                                                 AS criterion_name
  , ei.STAGE:percentage::FLOAT                              AS criterion_weight_pct

    -- Cell-level result
  , cell_eval.NAME                                          AS cell_level_selected
  , cell_eval.SCORE                                         AS cell_score
  , cell_eval.POSSIBLE_SCORE                                AS cell_possible_score
  , cell_eval.NORMALIZED_SCORE                              AS cell_normalized_score
  , cell_eval.FEEDBACK                                      AS cell_feedback
  , cell_eval.CREATED_TIME                                  AS cell_eval_time

    -- Source keys for troubleshooting
  , rubric_eval.SOURCE_ID                                   AS rubric_eval_source_id
  , cell_eval.SOURCE_ID                                     AS cell_eval_source_id
  , a.SOURCE_ID                                             AS attempt_pk1
  , gb.SOURCE_ID                                            AS gradebook_pk1

FROM CDM_LMS.EVALUATION                     cell_eval

    -- Step 1: walk up to parent RUBRIC row
    JOIN CDM_LMS.EVALUATION                 rubric_eval
        ON rubric_eval.SOURCE_ID = cell_eval.STAGE:parent_source_id::STRING
        AND rubric_eval.TYPE     = 'RUBRIC'

    -- Step 2: RUBRIC -> ATTEMPT via STAGE:attempt_pk1
    JOIN CDM_LMS.ATTEMPT                    a
        ON a.SOURCE_ID = rubric_eval.STAGE:attempt_pk1::STRING

    -- Step 3: ATTEMPT -> enrollment
    JOIN CDM_LMS.PERSON_COURSE              pc
        ON pc.ID = a.PERSON_COURSE_ID

    -- Step 4: student
    JOIN CDM_LMS.PERSON                     p
        ON p.ID = pc.PERSON_ID

    -- Step 5: course
    JOIN CDM_LMS.COURSE                     c
        ON c.ID = pc.COURSE_ID

    -- Step 6: RUBRIC -> EVALUABLE_COURSE_ITEM (nullable)
    LEFT JOIN CDM_LMS.EVALUABLE_COURSE_ITEM eci
        ON eci.ID = rubric_eval.EVALUABLE_COURSE_ITEM_ID

    -- Step 7: EVALUABLE_COURSE_ITEM -> GRADEBOOK via STAGE:gradebook_main_pk1
    LEFT JOIN CDM_LMS.GRADEBOOK             gb
        ON gb.SOURCE_ID = eci.STAGE:gradebook_main_pk1::STRING
        AND gb.DELETED_IND = FALSE

    -- Step 8: criterion definition from EVALUABLE_ITEM
    LEFT JOIN CDM_LMS.EVALUABLE_ITEM        ei
        ON ei.ID = cell_eval.EVALUABLE_ITEM_ID
        AND ei.TYPE = 'RUBRIC_CRITERIA'

WHERE cell_eval.TYPE = 'RUBRIC_CRITERIA'

    -- ── FILTER OPTIONS ──────────────────────────────────────
    -- Option A: specific course
    -- AND c.COURSE_NUMBER = 'YOUR_COURSE_ID'

    -- Option B: gradebook column name across courses
    -- AND gb.NAME = 'Your Assignment Name'

    -- Option C: specific term
    -- AND c.TERM_ID = (SELECT ID FROM CDM_LMS.TERM WHERE NAME = 'Your Term Name')

    -- Option D: last attempt only
    -- AND a.LAST_ATTEMPT_IND = TRUE
    -- ────────────────────────────────────────────────────────

ORDER BY
    c.COURSE_NUMBER
  , p.LAST_NAME
  , p.FIRST_NAME
  , gb.NAME
  , a.ATTEMPT_TIME
  , ei.NAME
;-- ============================================================
-- Rubric Cell-Level Results
-- Returns one row per student attempt per rubric criterion cell
--
-- Join path:
--   RUBRIC_CRITERIA (cell_eval)
--     -> RUBRIC (rubric_eval) via STAGE:parent_source_id = SOURCE_ID
--     -> ATTEMPT via STAGE:attempt_pk1 = ATTEMPT.SOURCE_ID
--     -> PERSON_COURSE -> PERSON / COURSE
--     -> EVALUABLE_COURSE_ITEM -> GRADEBOOK (when available)
--     -> EVALUABLE_ITEM (criterion definition) for criterion name
-- ============================================================

SELECT

    -- Course context
    c.COURSE_NUMBER                                         AS course_id
  , c.NAME                                                  AS course_name

    -- Gradebook column
  , gb.NAME                                                 AS gradebook_column_name
  , gb.POSSIBLE_SCORE                                       AS column_possible_score
  , gb.DUE_TIME                                             AS column_due_date

    -- Student
  , p.STAGE:user_id::STRING                                 AS username
  , p.FIRST_NAME
  , p.LAST_NAME
  , p.EMAIL

    -- Attempt context
  , a.ATTEMPT_TIME
  , a.STATUS_SOURCE_DESC                                    AS attempt_status
  , a.LAST_ATTEMPT_IND
  , a.OVERRIDE_IND
  , a.SCORE                                                 AS attempt_score

    -- Rubric-level score (overall)
  , rubric_eval.SCORE                                       AS rubric_total_score
  , rubric_eval.POSSIBLE_SCORE                              AS rubric_possible_score
  , rubric_eval.NORMALIZED_SCORE                            AS rubric_normalized_score
  , rubric_eval.FEEDBACK                                    AS rubric_feedback

    -- Criterion name from EVALUABLE_ITEM
  , ei.NAME                                                 AS criterion_name
  , ei.STAGE:percentage::FLOAT                              AS criterion_weight_pct

    -- Cell-level result
  , cell_eval.NAME                                          AS cell_level_selected
  , cell_eval.SCORE                                         AS cell_score
  , cell_eval.POSSIBLE_SCORE                                AS cell_possible_score
  , cell_eval.NORMALIZED_SCORE                              AS cell_normalized_score
  , cell_eval.FEEDBACK                                      AS cell_feedback
  , cell_eval.CREATED_TIME                                  AS cell_eval_time

    -- Source keys for troubleshooting
  , rubric_eval.SOURCE_ID                                   AS rubric_eval_source_id
  , cell_eval.SOURCE_ID                                     AS cell_eval_source_id
  , a.SOURCE_ID                                             AS attempt_pk1
  , gb.SOURCE_ID                                            AS gradebook_pk1

FROM CDM_LMS.EVALUATION                     cell_eval

    -- Step 1: walk up to parent RUBRIC row
    JOIN CDM_LMS.EVALUATION                 rubric_eval
        ON rubric_eval.SOURCE_ID = cell_eval.STAGE:parent_source_id::STRING
        AND rubric_eval.TYPE     = 'RUBRIC'

    -- Step 2: RUBRIC -> ATTEMPT via STAGE:attempt_pk1
    JOIN CDM_LMS.ATTEMPT                    a
        ON a.SOURCE_ID = rubric_eval.STAGE:attempt_pk1::STRING

    -- Step 3: ATTEMPT -> enrollment
    JOIN CDM_LMS.PERSON_COURSE              pc
        ON pc.ID = a.PERSON_COURSE_ID

    -- Step 4: student
    JOIN CDM_LMS.PERSON                     p
        ON p.ID = pc.PERSON_ID

    -- Step 5: course
    JOIN CDM_LMS.COURSE                     c
        ON c.ID = pc.COURSE_ID

    -- Step 6: RUBRIC -> EVALUABLE_COURSE_ITEM (nullable)
    LEFT JOIN CDM_LMS.EVALUABLE_COURSE_ITEM eci
        ON eci.ID = rubric_eval.EVALUABLE_COURSE_ITEM_ID

    -- Step 7: EVALUABLE_COURSE_ITEM -> GRADEBOOK via STAGE:gradebook_main_pk1
    LEFT JOIN CDM_LMS.GRADEBOOK             gb
        ON gb.SOURCE_ID = eci.STAGE:gradebook_main_pk1::STRING
        AND gb.DELETED_IND = FALSE

    -- Step 8: criterion definition from EVALUABLE_ITEM
    LEFT JOIN CDM_LMS.EVALUABLE_ITEM        ei
        ON ei.ID = cell_eval.EVALUABLE_ITEM_ID
        AND ei.TYPE = 'RUBRIC_CRITERIA'

WHERE cell_eval.TYPE = 'RUBRIC_CRITERIA'

    -- ── FILTER OPTIONS ──────────────────────────────────────
    -- Option A: specific course
    -- AND c.COURSE_NUMBER = 'YOUR_COURSE_ID'

    -- Option B: gradebook column name across courses
    -- AND gb.NAME = 'Your Assignment Name'

    -- Option C: specific term
    -- AND c.TERM_ID = (SELECT ID FROM CDM_LMS.TERM WHERE NAME = 'Your Term Name')

    -- Option D: last attempt only
    -- AND a.LAST_ATTEMPT_IND = TRUE
    -- ────────────────────────────────────────────────────────

ORDER BY
    c.COURSE_NUMBER
  , p.LAST_NAME
  , p.FIRST_NAME
  , gb.NAME
  , a.ATTEMPT_TIME
  , ei.NAME
;