# SchemaForge PostgreSQL Example

An application-owned database version repository for PostgreSQL. It contains only
schema history inputs and builds an immutable image on top of SchemaForge Runtime.

## Versioning rules

- Put forward-only changes in `migrations/V<version>__<description>.sql`.
- Put repeatable objects such as views in `migrations/R__<description>.sql`.
- Never edit an applied versioned migration; add a new version instead.
- Keep each migration focused and review SQL changes before applying them.
- Never commit database URLs, users, passwords, or other credentials.

## Start a local PostgreSQL database

Docker Desktop is required. The official PostgreSQL image is multi-architecture,
so it runs natively on Apple Silicon:

```sh
make db-up
make db-ps
```

The default local connection is:

```text
Host: localhost
Port: 5432
Database: schemaforge_example
User: schema_owner
Password: localdev
```

These defaults are for local learning only. Override them with an untracked `.env`
file when needed.

## Build and run Flyway

Build the runtime repository first so `schemaforge-runtime:13.4.0` exists locally:

```sh
make lint
make build
```

Copy the example environment file and load it into the shell:

```sh
cp config/flyway.env.example .env
set -a
. ./.env
set +a

make info
make validate
make migrate
```

Run `info` and `validate` before `migrate`. Flyway records applied versions in its
schema history table. A second `make migrate` should report that there is nothing
new to apply.

## Migration lifecycle

1. Add a new SQL file with the next version number.
2. Run `make lint` and review the SQL.
3. Build an immutable application-schema image.
4. Run `info` and `validate` against the target database.
5. Back up the database according to the application's recovery policy.
6. Run `migrate`, then retain the image digest and Flyway output as audit evidence.

This repository intentionally uses PostgreSQL syntax and is separate from
`schemaforge-sybase-example`; do not mix migrations between database engines.

