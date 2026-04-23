
# COURSE Table — Field Reference (Authoritative)

> Each non-STAGE field links directly to its entry in the Illuminate Data Dictionary.
> All STAGE attributes link to the shared `COURSE.stage` dictionary entry.

## Identifiers & Keys

- **[ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ID)** — Snowflake-generated surrogate key; not sourced from Blackboard.
- **[SOURCE_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-SOURCE_ID)** — Blackboard database primary key (`pk1`). Primary keys are not reused in Blackboard; value may be observed in course URLs.
- **[COURSE_NUMBER](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-COURSE_NUMBER)** — Blackboard visible Course ID. Unique in Blackboard, not guaranteed unique in Snowflake due to historical retention.
- **[STAGE:uuid](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Blackboard-generated UUID used for integration with other systems (e.g., LTI); stored within `COURSE.stage`.
- **[STAGE:batch_uid](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Blackboard external course key; required to be unique in Blackboard; stored within `COURSE.stage`.
- **[STAGE:foundations_id](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Internal Blackboard identifier used for integration with other Blackboard services; stored within `COURSE.stage`.

## Relationships

- **[COURSE_PARENT_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-COURSE_PARENT_ID)** — Lookup to `COURSE.id` of the parent (merged) course.
- **[STAGE:crsmain_parent_pk1](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-COURSE_STAGE)** — Blackboard primary key for a parent (merged) course; stored within `COURSE.stage`.
- **[TERM_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-TERM_ID)** — Lookup to `TERM.id` value in Snowflake.
- **[COPY_FROM_COURSES](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-COPY_FROM_COURSES)** — Lookup to `COURSE.id` values for source courses from which copies were made.

## Descriptive Metadata

- **[NAME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-NAME)** — Blackboard Course Name.
- **[DESCRIPTION](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-DESCRIPTION)** — Blackboard Course Description.

## Course Experience / Design

- **[DESIGN_MODE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-DESIGN_MODE)** — Blackboard Course Experience (Ultra or Original).
- **[DESIGN_MODE_SOURCE_CODE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-DESIGN_MODE_SOURCE_CODE)** — Duplicate of `DESIGN_MODE`.
- **[DESIGN_MODE_SOURCE_DESC](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-DESIGN_MODE_SOURCE_DESC)** — Not implemented.

## Enrollment Configuration

- **[ENROLLMENT_METHOD](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ENROLLMENT_METHOD)** — Blackboard enrollment setting: `I` = Instructor/Admin only; `E` = email approval; `S` = self-enrollment.
- **[ENROLLMENT_METHOD_SOURCE_CODE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ENROLLMENT_METHOD_SOURCE_CODE)** — Duplicate of `ENROLLMENT_METHOD`.
- **[ENROLLMENT_METHOD_SOURCE_DESC](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ENROLLMENT_METHOD_SOURCE_DESC)** — Not implemented.

## Availability & Enablement

- **[AVAILABLE_IND](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-AVAILABLE_IND)** — Direct value from the Blackboard course record indicating availability.
- **[AVAILABLE_TO_STUDENTS_IND](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-AVAILABLE_TO_STUDENTS_IND)** — Derived value based on availability rules applied to the course.
- **[ENABLED_IND](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ENABLED_IND)** — Direct value from the Blackboard course record indicating system enablement.
- **[STAGE:avl_rule_indicator](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Indicates whether availability rules are applied; stored within `COURSE.stage`.

## Scheduling (Configured)

- **[START_DATE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-START_DATE)** — Date portion of the course start date in Blackboard.
- **[END_DATE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-END_DATE)** — Date portion of the course end date in Blackboard.
- **[START_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-START_TIME)** — Full timestamp of the course start date in Blackboard.
- **[END_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-END_TIME)** — Full timestamp of the course end date in Blackboard.

## Access Activity (Derived)

- **[FIRST_COURSE_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-FIRST_COURSE_TIME)** — Timestamp of the first known access to the course by any user, derived from `CDM_LMS.course_activity`.
- **[LAST_COURSE_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-LAST_COURSE_TIME)** — Timestamp of the last known access to the course by any user, derived from `CDM_LMS.course_activity`.
- **[FIRST_COURSE_WEEK](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-FIRST_COURSE_WEEK)** — Monday preceding `FIRST_COURSE_TIME`, used for week-based reporting.
- **[LAST_COURSE_WEEK](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-LAST_COURSE_WEEK)** — Monday preceding `LAST_COURSE_TIME`, used for week-based reporting.

## Lifecycle & Audit (Source vs Warehouse)

- **[CREATED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-CREATED_TIME)** — Timestamp when the course was created in Blackboard.
- **[MODIFIED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-MODIFIED_TIME)** — Timestamp when the course was last updated in Blackboard.
- **[ROW_INSERTED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ROW_INSERTED_TIME)** — Timestamp when the record was created in Snowflake.
- **[ROW_UPDATED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ROW_UPDATED_TIME)** — Timestamp when the record was updated in Snowflake.
- **[ROW_DELETED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-ROW_DELETED_TIME)** — Timestamp indicating when the Snowflake record was marked as deleted due to Blackboard source deletion.

## Settings and other Metadata

- **[STAGE:data_src_batchuid](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Identifier of the data source in Blackboard (e.g., SYSTEM, FLAT_FILES, SIS); stored within `COURSE.stage`.
- **[STAGE:service_level](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Course type specialization (e.g., `F` = Course, `C` = Organization); stored within `COURSE.stage`.
- **[STAGE:allow_guest](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Guest access setting (`Y`/`N`); stored within `COURSE.stage`.
- **[STAGE:allow_observer](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Observer access setting (`Y`/`N`); stored within `COURSE.stage`.
- **[STAGE:sos_id_pk2](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-STAGE)** — Deprecated; former tenant key for virtual Blackboard deployments; stored within `COURSE.stage`.
- **[INSTANCE_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-COURSE-INSTANCE_ID)** — Identifier for the Blackboard deployment; all records from a single deployment share this key.


