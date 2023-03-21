SELECT 
  crs.course_number AS course_id
  ,per.stage['user_id']::text AS instructor_id
  ,ROUND(COALESCE(gact.time_spent,0),1) AS inst_minutes_grading
  ,COALESCE(gact.interaction_cnt,0) AS inst_grading_interactions
  ,coalesce(std.student_count,0) AS crs_student_cnt
  ,coalesce(gbk.item_count,0) AS crs_item_cnt
  ,coalesce(gds.grades_count,0) AS crs_grades_cnt
  
FROM course crs
  LEFT JOIN person_course pc on pc.course_id = crs.id
  LEFT JOIN person per on per.id = pc.person_id

  --student counter 
  LEFT JOIN (
    SELECT
      course_id,
      count(1) as student_count
    FROM person_course
    WHERE row_deleted_time IS NULL
      AND course_role = 'S'
      AND enabled_ind
    GROUP BY course_id
    ) std ON std.course_id = crs.id

  -- item counter  
  LEFT JOIN ( 
    SELECT 
      course_id,
      count(1) as item_count
    FROM gradebook
    WHERE deleted_ind = FALSE
      AND row_deleted_time IS NULL
    GROUP BY course_id      
      ) gbk ON gbk.course_id = crs.id

  --grades counter
  LEFT JOIN (
    SELECT 
      gradebook.course_id,
      count(1) as grades_count
    FROM grade
      LEFT JOIN gradebook on gradebook.id = grade.gradebook_id
    WHERE grade.row_deleted_time IS NULL
      AND gradebook.row_deleted_time IS NULL
    GROUP BY gradebook.course_id      
      ) gds ON gds.course_id = crs.id

  --grading activity by instuctor
  LEFT JOIN (
    SELECT 
      person_course_id,
      SUM(duration_sum)/60 AS time_spent,
      SUM(interaction_cnt) AS interaction_cnt
    FROM course_tool_activity
    WHERE tool_source_id = 'instructor_gradebook'
    GROUP BY person_course_id
    ) gact ON gact.person_course_id = pc.id

WHERE pc.course_role = 'I'
  AND pc.row_deleted_time IS NULL
  AND crs.course_number like '%kelley%'
  AND crs.row_deleted_time IS NULL

ORDER BY crs.course_number ASC