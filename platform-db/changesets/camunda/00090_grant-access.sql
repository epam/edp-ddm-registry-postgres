--liquibase formatted sql
--changeset platform:grant-access
-- revoke engine
revoke all on ACT_GE_PROPERTY from public;
revoke all on ACT_GE_BYTEARRAY from public;
revoke all on ACT_GE_SCHEMA_LOG from public;
revoke all on ACT_RE_DEPLOYMENT from public;
revoke all on ACT_RU_EXECUTION from public;
revoke all on ACT_RU_JOB from public;
revoke all on ACT_RU_JOBDEF from public;
revoke all on ACT_RE_PROCDEF from public;
revoke all on ACT_RE_CAMFORMDEF from public;
revoke all on ACT_RU_TASK from public;
revoke all on ACT_RU_IDENTITYLINK from public;
revoke all on ACT_RU_VARIABLE from public;
revoke all on ACT_RU_EVENT_SUBSCR from public;
revoke all on ACT_RU_INCIDENT from public;
revoke all on ACT_RU_AUTHORIZATION from public;
revoke all on ACT_RU_FILTER from public;
revoke all on ACT_RU_METER_LOG from public;
revoke all on ACT_RU_TASK_METER_LOG from public;
revoke all on ACT_RU_EXT_TASK from public;
revoke all on ACT_RU_BATCH from public;

-- revoke history
revoke all on ACT_HI_PROCINST from public;
revoke all on ACT_HI_ACTINST from public;
revoke all on ACT_HI_TASKINST from public;
revoke all on ACT_HI_VARINST from public;
revoke all on ACT_HI_DETAIL from public;
revoke all on ACT_HI_IDENTITYLINK from public;
revoke all on ACT_HI_COMMENT from public;
revoke all on ACT_HI_ATTACHMENT from public;
revoke all on ACT_HI_OP_LOG from public;
revoke all on ACT_HI_INCIDENT from public;
revoke all on ACT_HI_JOB_LOG from public;
revoke all on ACT_HI_BATCH from public;
revoke all on ACT_HI_EXT_TASK_LOG from public;

-- revoke identity
revoke all on ACT_ID_GROUP from public;
revoke all on ACT_ID_MEMBERSHIP from public;
revoke all on ACT_ID_USER from public;
revoke all on ACT_ID_INFO from public;
revoke all on ACT_ID_TENANT from public;
revoke all on ACT_ID_TENANT_MEMBER from public;

-- revoke case engine
revoke all on ACT_RE_CASE_DEF from public;
revoke all on ACT_RU_CASE_EXECUTION from public;
revoke all on ACT_RU_CASE_SENTRY_PART from public;

-- revoke case history
revoke all on ACT_HI_CASEINST from public;
revoke all on ACT_HI_CASEACTINST from public;

-- revoke decision engine
revoke all on ACT_RE_DECISION_DEF from public;
revoke all on ACT_RE_DECISION_REQ_DEF from public;

-- revoke decision history
revoke all on ACT_HI_DECINST from public;
revoke all on ACT_HI_DEC_IN from public;
revoke all on ACT_HI_DEC_OUT from public;


-- grants
-- role bpm_service_user
-- engine
grant select, insert, update, delete on  ACT_GE_PROPERTY to ${bpmServiceName};
grant select, insert, update, delete on  ACT_GE_BYTEARRAY to ${bpmServiceName};
grant select, insert, update, delete on  ACT_GE_SCHEMA_LOG to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RE_DEPLOYMENT to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_EXECUTION to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_JOB to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_JOBDEF to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RE_PROCDEF to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RE_CAMFORMDEF to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_TASK to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_IDENTITYLINK to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_VARIABLE to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_EVENT_SUBSCR to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_INCIDENT to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_AUTHORIZATION to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_FILTER to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_METER_LOG to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_TASK_METER_LOG to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_EXT_TASK to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_BATCH to ${bpmServiceName};

-- history
grant select, insert, update, delete on  ACT_HI_PROCINST to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_ACTINST to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_TASKINST to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_VARINST to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_DETAIL to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_IDENTITYLINK to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_COMMENT to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_ATTACHMENT to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_OP_LOG to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_INCIDENT to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_JOB_LOG to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_BATCH to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_EXT_TASK_LOG to ${bpmServiceName};

-- identity
grant select, insert, update, delete on  ACT_ID_GROUP to ${bpmServiceName};
grant select, insert, update, delete on  ACT_ID_MEMBERSHIP to ${bpmServiceName};
grant select, insert, update, delete on  ACT_ID_USER to ${bpmServiceName};
grant select, insert, update, delete on  ACT_ID_INFO to ${bpmServiceName};
grant select, insert, update, delete on  ACT_ID_TENANT to ${bpmServiceName};
grant select, insert, update, delete on  ACT_ID_TENANT_MEMBER to ${bpmServiceName};

-- case engine
grant select, insert, update, delete on  ACT_RE_CASE_DEF to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_CASE_EXECUTION to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RU_CASE_SENTRY_PART to ${bpmServiceName};

-- case history
grant select, insert, update, delete on  ACT_HI_CASEINST to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_CASEACTINST to ${bpmServiceName};

-- decision engine
grant select, insert, update, delete on  ACT_RE_DECISION_DEF to ${bpmServiceName};
grant select, insert, update, delete on  ACT_RE_DECISION_REQ_DEF to ${bpmServiceName};

-- decision history
grant select, insert, update, delete on  ACT_HI_DECINST to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_DEC_IN to ${bpmServiceName};
grant select, insert, update, delete on  ACT_HI_DEC_OUT to ${bpmServiceName};

-- grants
-- role bp_admin_portal_service_user
-- engine
grant select, insert, update, delete on  ACT_GE_PROPERTY to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_GE_BYTEARRAY to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_GE_SCHEMA_LOG to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RE_DEPLOYMENT to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_EXECUTION to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_JOB to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_JOBDEF to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RE_PROCDEF to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RE_CAMFORMDEF to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_TASK to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_IDENTITYLINK to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_VARIABLE to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_EVENT_SUBSCR to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_INCIDENT to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_AUTHORIZATION to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_FILTER to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_METER_LOG to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_TASK_METER_LOG to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_EXT_TASK to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_BATCH to ${bpAdminPortalServiceName};

-- history
grant select, insert, update, delete on  ACT_HI_PROCINST to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_ACTINST to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_TASKINST to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_VARINST to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_DETAIL to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_IDENTITYLINK to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_COMMENT to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_ATTACHMENT to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_OP_LOG to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_INCIDENT to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_JOB_LOG to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_BATCH to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_EXT_TASK_LOG to ${bpAdminPortalServiceName};

-- identity
grant select, insert, update, delete on  ACT_ID_GROUP to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_ID_MEMBERSHIP to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_ID_USER to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_ID_INFO to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_ID_TENANT to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_ID_TENANT_MEMBER to ${bpAdminPortalServiceName};

-- case engine
grant select, insert, update, delete on  ACT_RE_CASE_DEF to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_CASE_EXECUTION to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RU_CASE_SENTRY_PART to ${bpAdminPortalServiceName};

-- case history
grant select, insert, update, delete on  ACT_HI_CASEINST to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_CASEACTINST to ${bpAdminPortalServiceName};

-- decision engine
grant select, insert, update, delete on  ACT_RE_DECISION_DEF to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_RE_DECISION_REQ_DEF to ${bpAdminPortalServiceName};

-- decision history
grant select, insert, update, delete on  ACT_HI_DECINST to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_DEC_IN to ${bpAdminPortalServiceName};
grant select, insert, update, delete on  ACT_HI_DEC_OUT to ${bpAdminPortalServiceName};
