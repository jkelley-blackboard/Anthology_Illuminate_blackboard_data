/* ============================================================================================
   QUERY: Course Grade Metrics (Non-Final Grade Counts + Final-Grade Stats)
   AUTHOR: Jeff Kelley
   DATE:   2026-02-02
   Provided without support or warranty

   PURPOSE:
     - Return per-course metrics for a given term, including:
       * Total enrolled students
       * Count of NON-FINAL grade columns (gradebook items), regardless of any grades
       * Total number of grades recorded for NON-FINAL items (student × item rows with non-NULL scores)
       * Summary statistics for FINAL grades (max/min/avg and IQR)

   DEFINITIONS / ASSUMPTIONS:
     - "Non-final grade columns" are gradebook items where FINAL_GRADE_IND = FALSE.
     - "Non-final grades count" includes only rows in CDM_LMS.GRADE where:
          • The item is non-final (joined via gradebook),
          • The score is present (GR.NORMALIZED_SCORE IS NOT NULL),
          • The student is an enabled, non-preview student in the course.
     - "Student count" is the number of enrolled, enabled, non-preview students per course—independent
       of whether they have any grades (computed from enrollment, not grade rows).
     - Final-grade stats (MAX/MIN/AVG/IQR) are computed only from rows where FINAL_GRADE_IND = TRUE.

   DISCLAIMER:
     - Results depend on upstream data quality and flags:
         • If auto-zeros are stored as NULL, they are EXCLUDED by design (see WHERE in select_grades).
         • If gradebook FINAL_GRADE_IND or GRADE.DELETED/ROW_DELETED flags behave differently in your
           environment, adjust filters accordingly.
     - This SQL targets Snowflake semantics (COUNT_IF, IFF, ordered-set PERCENTILE_CONT).
       Review expressions if running on a different engine.
   ============================================================================================ */

WITH
/* --------------------------------------
   Filter courses to the target term
   -------------------------------------- */
select_courses AS (
  SELECT
    cr.id,
    cr.course_number,
    cr.name AS courseName,
    tm.name AS termName,
    tm.source_id,
    cr.available_to_students_ind
  FROM CDM_LMS.course AS cr
  LEFT JOIN CDM_LMS.term AS tm ON tm.id = cr.term_id
  WHERE cr.row_deleted_time IS NULL
    AND tm.name = '2025 Fall'
),

/* --------------------------------------
   Enrollment: enabled, non-preview students
   -------------------------------------- */
select_students AS (
  SELECT
    pc.id AS person_course_id,
    pc.course_id,
    pc.person_id
  FROM CDM_LMS.person_course AS pc
  JOIN CDM_LMS.person AS pr ON pr.id = pc.person_id
  JOIN select_courses AS crs ON pc.course_id = crs.id
  WHERE pc.course_role = 'S'
    AND pc.enabled_ind = TRUE
    AND pc.row_deleted_time IS NULL
    AND pr.stage:data_src_batchuid::string <> 'BB_STUDENT_PREVIEW'
),

/* --------------------------------------
   Gradebook items for our courses
   -------------------------------------- */
select_grade_items AS (
  SELECT
    gb.id,
    gb.course_id,
    gb.final_grade_ind
  FROM CDM_LMS.gradebook AS gb
  JOIN select_courses AS cr ON cr.id = gb.course_id
  WHERE gb.deleted_ind = FALSE
    AND gb.row_deleted_time IS NULL
),

/* --------------------------------------
   Grade rows (student × item) that are actually graded (non-NULL score)
   Carry the final/non-final flag from the item
   -------------------------------------- */
select_grades AS (
  SELECT
    gi.course_id,
    gi.final_grade_ind,
    gi.id AS gradebook_id,
    gr.person_course_id,
    gr.normalized_score,
    gr.id AS grade_id
  FROM CDM_LMS.grade AS gr
  JOIN select_grade_items AS gi ON gi.id = gr.gradebook_id
  JOIN select_students AS st ON st.person_course_id = gr.person_course_id
  WHERE gr.row_deleted_time IS NULL
    AND gr.normalized_score IS NOT NULL
),

/* --------------------------------------
   Student counts per course (all enrolled, regardless of grades)
   -------------------------------------- */
students_per_course AS (
  SELECT
    course_id,
    COUNT(DISTINCT person_course_id) AS student_count
  FROM select_students
  GROUP BY course_id
),

/* --------------------------------------
   Non-final item counts per course (exists even if no grade rows)
   -------------------------------------- */
non_final_items_per_course AS (
  SELECT
    course_id,
    COUNT(DISTINCT id) AS non_final_items_count
  FROM select_grade_items
  WHERE final_grade_ind = FALSE
  GROUP BY course_id
)

/* --------------------------------------
   Final output
   -------------------------------------- */
SELECT 
  cr.termName,
  cr.course_number AS courseId,
  cr.courseName,
  cr.available_to_students_ind,

  /* All enrolled, enabled, non-preview students per course */
  spc.student_count,

  /* All non-final gradebook items, regardless of whether any grades exist */
  COALESCE(nfi.non_final_items_count, 0) AS non_final_grade_columns,

  /* Total number of grades for NON-FINAL items (student × item graded rows) */
  COUNT_IF(fg.final_grade_ind = FALSE) AS non_final_grades_count,

  /* Summary stats on FINAL grades only */
  ROUND(MAX(IFF(fg.final_grade_ind, fg.normalized_score, NULL)), 2) AS final_maximum,
  ROUND(MIN(IFF(fg.final_grade_ind, fg.normalized_score, NULL)), 2) AS final_minimum,
  ROUND(AVG(IFF(fg.final_grade_ind, fg.normalized_score, NULL)), 2) AS final_average,

  /* Distribution (IQR = Q3 - Q1) on FINAL grades only */
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY IFF(fg.final_grade_ind, fg.normalized_score, NULL))
    -
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY IFF(fg.final_grade_ind, fg.normalized_score, NULL))
  , 2) AS final_distribution

FROM select_courses AS cr
LEFT JOIN students_per_course AS spc ON spc.course_id = cr.id
LEFT JOIN non_final_items_per_course AS nfi ON nfi.course_id = cr.id
LEFT JOIN select_grades AS fg ON fg.course_id = cr.id
GROUP BY
  cr.termName, cr.course_number, cr.courseName, cr.available_to_students_ind, spc.student_count, nfi.non_final_items_count
ORDER BY
  cr.course_number;