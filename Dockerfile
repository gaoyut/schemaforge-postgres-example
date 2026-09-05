ARG RUNTIME_IMAGE=schemaforge-runtime:13.4.0
FROM ${RUNTIME_IMAGE}

COPY migrations/ /flyway/sql/

