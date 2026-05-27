---
paths:
  - "**/*.sql"
  - "**/migrations/**"
  - "**/database/**"
---

# SQL / Database conventions — SQL Server 2022 (T-SQL)

- **Never DROP TABLE without explicit user confirmation.** Prefer `ADD COLUMN` with a default, or idempotent `ALTER`. Schema deletions are irreversible.
- **Migrations must be idempotent.** Use `CREATE TABLE IF NOT EXISTS`, `IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE ...)` guards, and `IF OBJECT_ID(...) IS NULL` before DDL. Re-running a migration must be safe.
- **Schema changes that affect downstream consumers** (API queries, ETL scripts) must list verified callers in the commit body. The commit subject names the schema change; the body enumerates which consumers were verified.
- **Column alias safety (SQL Server):** avoid aliases matching T-SQL reserved words or system variables — `rowCount`, `error`, `identity`, `version`, `rowGuidCol`, `trancount`, `procid`, `spid`. The parser rejects them with cryptic errors. Prefer prefixed names: `lineupRows`, `errorMsg`, `dbVersion`.
- **Ad-hoc queries:** write to `/tmp/` and run via the project's designated query runner. Do not run SQL directly from a session without a script.
- **Connection strings** read from environment variables only — never hardcoded. Typical vars: `SQL_SERVER`, `SQL_DATABASE`, `SQL_USERNAME`, `SQL_PASSWORD`.
- **No DROP DATABASE** in migration scripts. Ever. Use separate, explicitly confirmed runbooks for destructive DB operations.
- **Test migrations against an empty DB** before running against production. Add a `--target-empty-db` guard flag to migration scripts.
