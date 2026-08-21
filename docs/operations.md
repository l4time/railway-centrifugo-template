# Operations Guide

This runbook covers the supported one-node Centrifugo memory-engine package. It does not convert the template into a durable queue, HA cluster, or managed application backend.

## Normal health

Require all of the following:

1. The latest Railway deployment is terminal `SUCCESS`.
2. Public `GET /connection/init` returns `200 {}`.
3. Public API/admin/true-health/metrics/debug/Swagger paths remain unavailable.
4. A synthetic authenticated client can connect with the exact allowed Origin.
5. A trusted backend in the same Railway project/private network can publish through the private API and the client receives the message.
6. Sensitive, private, tenant, or per-user channels have a separately tested upstream-supported channel authorization mechanism; the base subscription flag alone is insufficient.
7. Bounded logs show no recurring configuration, authentication, panic, or restart loop.

The init endpoint proves that the external listener is responsive. It does not prove backend authorization, channel-level authorization, delivery, durable state, or the internal API. Use an end-to-end synthetic message for functional monitoring.

Direct port `9000` operations require the caller to share the Railway project/private network. An external backend needs a separately secured and tested ingress design outside this runbook; never make the private listener public as a shortcut.

## Logs

Use Railway deployment and service logs with a bounded time/line window. Look for:

- Configuration parsing failures.
- Port/listener conflicts.
- Repeated authentication or Origin failures.
- Panic/fatal messages and restart loops.
- Unexpected admin, API, metrics, debug, or Swagger exposure.
- Resource pressure and connection churn.

Before sharing an excerpt, remove secrets, JWTs, cookies, private hostnames, account/project IDs, user identifiers, channel names, and message payloads. Never collect a full environment dump for support.

## Restart and reconnect

Routine restart expectations:

1. Existing clients disconnect.
2. A first reconnect attempt can fail while the process returns.
3. Clients back off and request a fresh short-lived JWT when required.
4. Clients reconnect, resubscribe, and receive a newly published message.
5. Clients refresh authoritative application state from the backend.

Do not claim recovery of in-memory presence or publication history. Set the application's recovery objective based on its own retry policy, not a template guarantee.

## Memory-engine state

The default package owns no durable state:

- No backup job is required for Centrifugo itself.
- No restore of in-memory history is possible.
- Restart/redeploy can erase publication history, presence, and recovery state.
- The backend database and event/business records are user-owned and must have their own backups.

Adding Redis, a database, a volume, broker, or multiple replicas exits the supported default and requires a separately tested design, cost model, backup plan, and incident boundary.

## Secret rotation

### Client HMAC secret

1. Prepare the trusted JWT issuer to use the replacement.
2. Coordinate a maintenance window or dual-key strategy only if upstream configuration has been separately validated.
3. Replace the Railway value.
4. Issue fresh tokens; old tokens will fail.
5. Verify valid/invalid JWT behavior and one WSS delivery.

### HTTP API key

1. Identify every trusted publisher.
2. Update the Railway secret and all publishers in one coordinated change.
3. Confirm missing/old keys fail and the new key succeeds.
4. Verify a synthetic publish/delivery.

### Admin credentials

Rotate `CENTRIFUGO_ADMIN_PASSWORD` and `CENTRIFUGO_ADMIN_SECRET` together after suspected compromise. Expect existing admin sessions to stop working. Admin remains private on port `9000`.

Never put a replacement value in source control, a shell history command argument, a screenshot, or a support ticket.

## Origin changes

1. Record the exact new HTTPS origin including port if non-default.
2. Add it without a wildcard.
3. Deploy and test the new correct Origin.
4. Confirm an unrelated Origin still fails.
5. Remove the old origin after the migration window.

An Origin setting is not a substitute for valid JWTs and backend authorization.

## Update procedure

1. Review upstream release, compatibility, migration, configuration, security, and license notes.
2. Choose an immutable release and resolve its digest.
3. Open a disposable Railway test scoped to one app/domain, with no stateful service.
4. Apply the full template contract, including `PORT=8000`.
5. Require terminal deployment `SUCCESS`.
6. Re-run public/internal isolation, API-key negatives/positive, JWT/Origin negatives, WSS delivery, controlled restart/reconnect, bounded-log secret search, and CPU/RAM checks.
7. Update the Dockerfile tag and digest together.
8. Update `CHANGELOG.md`, `README.md`, inventory, QA evidence, and marketplace version copy.
9. Roll out to consumers only after QA and rollback readiness.

Do not use `latest`, a release candidate, or a moving branch in the public template.

## Rollback

1. Restore the last proved Docker image tag and digest together.
2. Restore the last compatible non-secret configuration.
3. Preserve generated secrets unless compromise caused the rollback.
4. Redeploy and require terminal success.
5. Verify isolation, authenticated WSS delivery, and reconnect behavior.
6. Instruct clients to refresh state from the backend.

There is no memory-state rollback and no template-owned database migration in the default package.

## Incident priorities

| Priority | Examples | First action |
|---|---|---|
| S0 security/data | Public private API/admin, leaked secret, unauthorized publish, business correctness depended on lost memory history | Contain exposure, rotate affected secrets, preserve sanitized evidence, use private security route |
| S1 deploy | Clean deploy fails, health fails, restart loop, valid clients cannot reconnect/deliver | Stop rollout, inspect deployment/logs/config, roll back if change-related |
| S2 docs/setup | Required variable ambiguity, wrong port/origin guidance, incomplete recovery instructions | Reproduce safely, correct docs/package, add regression check |
| S3 enhancement/upstream | Redis/HA/broker/PRO request, new transport, upstream behavior | Route upstream or require separately approved scope |

## Public-surface incident

If `/api`, `/admin`, `/health`, metrics, debug, or Swagger becomes public:

1. Treat it as S0 until exposure and credentials are assessed.
2. Remove or disable the affected public domain/TCP proxy.
3. Confirm the domain targets only port `8000`.
4. Restore all API/admin external/insecure flags to `false`.
5. Rotate potentially exposed API/admin values.
6. Verify public rejection and internal authenticated access.
7. Record the template cause and add a regression test before republishing.

## Capacity and cost

The proof observed a low footprint for a synthetic test, not a production guarantee. Watch:

- Concurrent connections and reconnect storms.
- Message rate and size.
- Enabled history/presence features.
- Authentication errors and abusive origins.
- CPU, RAM, egress, and restart count.

Keep one replica in the supported package. Scaling or HA requires Redis/broker and application-level analysis outside this runbook.

## Backup/restore verification

For the default package, QA records backup as accepted `N/A` because no template-owned durable state exists. Verification consists of:

1. Restart/redeploy the service.
2. Confirm clients reconnect and receive a new message.
3. Confirm the backend restores authoritative state independently.
4. Confirm documentation does not promise recovery of old in-memory publications.

If persistence is added, replace this section with a tested backup/export, restore-to-disposable, integrity, retention, and rollback procedure before release.
