
# PERSON Table — Field Reference (Authoritative)

> Each field name links directly to its entry in the Illuminate Data Dictionary.

## Identifiers & Keys

- **[ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-ID)** — Snowflake-generated surrogate key; not sourced from Blackboard.
- **[GLOBAL_PERSON_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-GLOBAL_PERSON_ID)** — Global identifier for the person across deployments; stable in Snowflake.
- **[INSTANCE_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-INSTANCE_ID)** — Identifier for the Blackboard deployment; all records from a single deployment share this key.
- **[SOURCE_ID](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-SOURCE_ID)** — Blackboard database primary key (`pk1`) for the user record. Primary keys are not reused in Blackboard.
- **[STAGE:uuid](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-STAGE_UUID)** — Blackboard-generated UUID used for integration with other systems (e.g., LTI).
- **[STAGE:batch_uid](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-STAGE_BATCH_UID)** — Blackboard external user key; required to be unique in Blackboard; often sourced from a system of record (e.g., SIS).
- **[STAGE:user_id](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-STAGE_USER_ID)** — Blackboard username used for authentication and UI login.

## Identity & Profile Information

- **[FIRST_NAME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-FIRST_NAME)** — User’s first name from Blackboard.
- **[LAST_NAME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-LAST_NAME)** — User’s last name from Blackboard.
- **[EMAIL](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-EMAIL)** — User’s email address from Blackboard.
- **[AVATAR_URL](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-AVATAR_URL)** — URL to the user’s profile avatar image in Blackboard, if present.
- **[BIRTH_DATE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-BIRTH_DATE)** — User’s date of birth, when supplied by the source system.
- **[POSTAL_CODE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-POSTAL_CODE)** — User’s postal code, when supplied by the source system.

## Organizational & Employment Attributes

- **[JOB_TITLE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-JOB_TITLE)** — User’s job title, when supplied by the source system.
- **[DEPARTMENT](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-DEPARTMENT)** — User’s department, when supplied by the source system.
- **[COMPANY](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-COMPANY)** — User’s organization or company, when supplied by the source system.

## Institutional & System Roles

- **[INSTITUTION_ROLE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-INSTITUTION_ROLE)** — User’s primary institutional role (e.g., Student, Faculty, Staff).
- **[INSTITUTION_ROLE_SOURCE_CODE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-INSTITUTION_ROLE_SOURCE_CODE)** — Source code corresponding to the institutional role.
- **[INSTITUTION_ROLE_SOURCE_DESC](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-INSTITUTION_ROLE_SOURCE_DESC)** — Description of the institutional role source code.
- **[SYSTEM_ROLE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-SYSTEM_ROLE)** — Blackboard system-level role granting platform permissions.
- **[SYSTEM_ROLE_SOURCE_CODE](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-SYSTEM_ROLE_SOURCE_CODE)** — Source code corresponding to the system role.
- **[SYSTEM_ROLE_SOURCE_DESC](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-SYSTEM_ROLE_SOURCE_DESC)** — Description of the system role source code.

## Availability & Enablement

- **[AVAILABLE_IND](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-AVAILABLE_IND)** — Direct availability flag from the Blackboard user record.
- **[ENABLED_IND](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-ENABLED_IND)** — Direct enablement flag from the Blackboard user record.

## Lifecycle & Audit (Source vs Warehouse)

- **[CREATED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-CREATED_TIME)** — Timestamp when the user was created in Blackboard.
- **[MODIFIED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-MODIFIED_TIME)** — Timestamp when the user record was last updated in Blackboard.
- **[ROW_INSERTED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-ROW_INSERTED_TIME)** — Timestamp when the record was created in Snowflake.
- **[ROW_UPDATED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-ROW_UPDATED_TIME)** — Timestamp when the record was last updated in Snowflake.
- **[ROW_DELETED_TIME](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-ROW_DELETED_TIME)** — Timestamp indicating when the Snowflake record was marked as deleted due to Blackboard source deletion.

## Data Source & Governance (STAGE)

- **[STAGE:data_src_batchuid](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-STAGE_DATA_SRC_BATCHUID)** — Identifier of the data source in Blackboard (e.g., SYSTEM, SIS, PENDING PURGE).
- **[STAGE:foundations_id](https://illuminate.blackboard.com/dictionary/entries/entry/CDM_LMS-PERSON-STAGE_FOUNDATIONS_ID)** — Internal Blackboard identifier used for integration with other Blackboard services.
