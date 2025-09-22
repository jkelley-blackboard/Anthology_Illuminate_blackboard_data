-- find out who converted a course to ultra
-- example of useing the objectId value from Ultra Events
-- for audit activity investigations.
-- jeff.kelley@anthology.com  2025-08-09
-- no warranty or support


SELECT
  per.stage:user_id::text AS username,
  cor.course_number AS bb_course_id,
  ue.data:objectId::text AS objectId,
  ue.event_type,
  ue.event_time,
  --ue.data::text   --examine the full data object
FROM CDM_TLM.ultra_events ue
JOIN CDM_LMS.person per
  ON per.stage:uuid::text = ue.data:userId::text
JOIN CDM_LMS.course cor
  ON '_' || cor.source_id || '_1' = ue.data:contextId::text
WHERE cor.course_number like '%'   --select course(s)
  AND ue.event_time BETWEEN '2025-07-01' AND '2025-08-31'
  AND ue.data:objectId::text = 'course.conversion.statusBar.useUltra.button'  -- this is the analytics_id tag for the button
ORDER BY ue.event_time DESC;