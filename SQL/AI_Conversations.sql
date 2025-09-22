-- jeff.kelley@anthology.com  
-- provided without support or warranty
-- a list of all instructors with at least 1 AI Conversation assessment in Blackboard Ultra

SELECT
  per.stage['user_id']::text as instructor_id,
  per.email as instructor_email,
  SUM(CASE WHEN ci.stage['bbmd_questiontype']::text = 21 THEN 1 ELSE 0 END) as ai_chat_quests

FROM course_item ci
  JOIN person_course pc on pc.course_id = ci.course_id
  JOIN person per on per.id = pc.person_id

WHERE ci.row_deleted_time IS NULL  --no deleted questions
  AND pc.course_role = 'I'         --instructors only
  AND pc.row_deleted_time is NULL  --no deleted instructors

GROUP BY instructor_id, email

HAVING ai_chat_quests > 0   --exclude instructors with no questions
