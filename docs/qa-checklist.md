# Centrifugo Proof, Package, Publish, and Consumer QA Checklist

Status: published and launch-ready on 2026-08-21. Independent QA, clean unpublished-draft smoke, public publication, clean public consumer smoke, operational cleanup, and monitoring intake passed. Only Railway raw soft-delete literal-absence follow-ups remain scheduled for 2026-08-23.

## Source and build

- [x] Dockerfile uses `centrifugo/centrifugo:v6.9.2@sha256:f89352e38ef8043aaaa9045dec41cc8f2d35075b86ff553d4091ac19b547a3a6`.
- [x] Tag and digest appear together; no `latest`, RC, moving branch, or tag-only runtime pin.
- [x] Upstream default entrypoint/command is preserved.
- [x] No wrapper script, database, Redis, volume, Bucket, gateway, worker, or scheduler is added.
- [x] `railway.json` selects the Dockerfile builder.
- [x] `railway.json` sets `/connection/init`, timeout `30`, and restart-on-failure policy.
- [x] JSON parses locally.
- [x] Independent QA validates Dockerfile syntax/build without source mutation.
- [x] Public repository `main` contains the accepted package; public consumer smoke deployed runtime source commit `cb7d81114c6f87cff649d88b7e8c527e427b1097`.

## Railway service contract

- [x] One service named `centrifugo` is specified.
- [x] `PORT=8000` is mandatory and never omitted from the service contract.
- [x] Public/domain target port is `8000`.
- [x] Internal listener is `9000`.
- [x] Port `9000` has no public domain or TCP proxy in the intended topology.
- [x] `/connection/init` is the Railway health path with a `30`-second timeout.
- [x] Serverless is explicitly disabled; no scale-to-zero credit/claim.
- [x] One replica is the supported default.
- [x] No custom or native stateful service is required.
- [x] Railway template draft exactly matches the service/port/domain/health/Serverless contract.
- [x] Clean public consumer deploy contains exactly one app service and no hidden resource.

## Variables and secrets

- [x] All fixed non-secret variables match the passed proof contract.
- [x] HMAC, HTTP API, admin password, and admin secret are Railway-generated types.
- [x] No generated value exists in package source.
- [x] `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS` is a required consumer input.
- [x] No wildcard origin is a default or recommendation.
- [x] HTTP API external and insecure defaults are `false`.
- [x] Admin external and insecure defaults are `false`.
- [x] Generated values are documented as backend-only/stable across routine restart.
- [x] Rotation impact for JWTs, publishers, and admin sessions is documented.
- [x] Pre-deploy path states direct private API publishing requires a trusted backend in the same Railway project/private network.
- [x] Pre-deploy path includes Railway reference-variable wiring for private host, API key, and HMAC secret.
- [x] External-backend ingress is separately secured/tested and excluded; port `9000` stays private.
- [x] Base-namespace subscription `true` is preserved from proof and explicitly not treated as channel-level authorization.
- [x] Sensitive/private/tenant/per-user channels require an upstream-supported authorization mechanism and separate allowed/denied tests.
- [x] Static independent secret scan returns no credential or proof-only value.
- [x] Template editor hides generated values and does not prompt for them.
- [x] Clean unpublished-draft deploy generated unique non-placeholder values.

## Proof evidence

- [x] Corrected exact-digest Railway deployment reached terminal `SUCCESS` with `PORT=8000`.
- [x] Public `/connection/init` returned `200 {}`.
- [x] Public internal/admin/API/health/metrics/debug/Swagger surfaces were not exposed.
- [x] Internal health passed.
- [x] Missing/wrong API keys failed and valid API key succeeded.
- [x] Wrong Origin and malformed/expired JWT failed.
- [x] Valid WSS subscription and private-API publish/delivery passed.
- [x] Restart/reconnect/resubscribe/new delivery passed within the gate after a transient first attempt.
- [x] Bounded proof logs contained no generated-value match.
- [x] Synthetic proof stayed below resource stop gates.
- [x] Operational proof cleanup and zero active inventory were recorded.
- [ ] Main thread closes the scheduled raw soft-delete ID follow-up in canonical memory.

## Security and networking

- [x] README makes port `9000` private-only.
- [x] Public-surface incident steps are documented.
- [x] JWT, API-key, Origin, and admin boundaries are explicit.
- [x] No secret, full env dump, private hostname, JWT, or unredacted-log request appears in issue intake.
- [x] Security policy routes wrapper reports privately and separates upstream/Railway ownership.
- [x] Support links distinguish template, upstream, platform, and security routes.
- [x] QA checks all public copy for accidental endorsement or security guarantees.
- [x] Consumer smoke rechecks public rejection of API/admin/health/metrics/debug/Swagger surfaces.

## Functional consumer smoke

- [x] Deployment reaches terminal `SUCCESS`.
- [x] Public `/connection/init` returns `200 {}`.
- [x] Valid client JWT and exact Origin establish WSS.
- [x] Wrong Origin fails.
- [x] Malformed/expired JWT fails.
- [x] Missing/wrong API key fails internally.
- [x] Valid private API publish reaches the subscribed client.
- [x] Consumer smoke used a service-scoped simulated private caller; it did not deploy a separate backend or prove reference-variable wiring. A real publishing backend must share the Railway project/private network and use the documented references.
- [x] No sensitive/private channel was used; the base-channel test makes no channel-authorization claim, so the separate allowed/denied sensitive-channel gate is not applicable to this smoke.
- [x] One restart causes disconnect, retry, reconnect, resubscribe, and new delivery.
- [x] Client refreshes authoritative state rather than claiming memory-history recovery.
- [x] Logs are bounded, understandable, and free of generated values.
- [x] CPU/RAM/egress evidence is recorded without a performance or bill guarantee.

## Persistence, backup, and recovery

- [x] Memory-engine ephemerality is prominent.
- [x] Backend/durable datastore is the source of truth.
- [x] Client reconnect, retry, fresh-token, resubscribe, and state-refresh duties are explicit.
- [x] Template-owned backup is accepted `N/A` because no durable state exists.
- [x] In-memory history is explicitly non-restorable.
- [x] Adding Redis/database/volume invalidates the default backup stance and requires separate proof/docs.
- [x] Update and rollback preserve tag/digest coupling.
- [x] Consumer restart smoke confirms new delivery without claiming pre-restart history.

## Documentation and product kit

- [x] README explains product, architecture, deploy input, variables, first setup, persistence, always-on stance, health, operations, backup/restore, update/rollback, troubleshooting, limits, support, legal, and trademarks.
- [x] Operations guide covers health, logs, reconnect, rotation, origins, updates, rollback, incidents, capacity, and N/A backup verification.
- [x] Changelog records initial version, digest, proof basis, and rollback.
- [x] Issue form asks for template/upstream version, deploy date, service list, expected/actual behavior, steps, and sanitized logs.
- [x] Canonical S0-S3, template, upstream, and user-config labels are present.
- [x] Wrapper Apache-2.0 license and upstream/unofficial notices are present.
- [x] Marketplace overview avoids unsupported claims.
- [x] README and marketplace copy surface private-network and channel-authorization prerequisites before the first-run path.
- [x] Asset inventory records the accepted optional screenshot exception.
- [x] Template inventory and completion packet are filled.
- [x] No other product-kit exception is claimed.
- [x] Independent QA follows README as a non-expert and records exact blockers or acceptance.
- [x] All repository-relative links pass after files are placed at public repo root.

## Marketplace and publish

- [x] Listing title, short description, overview, services-created copy, required-input copy, and first-run copy are prepared.
- [x] Public slug `centrifugo-on-railway` and deploy button are included.
- [x] Railway accepted and published the template in category `Other`.
- [x] Original wrapper icon and no-screenshot/UI-capture exception are documented.
- [x] Current Railway category `Other` is selected and recorded.
- [x] Actual generated slug matches links.
- [x] Public repository/support/security links work before publication.
- [x] Template draft variable prompts/defaults and hidden secrets are reviewed.
- [x] Marketplace/draft copy does not imply JWT authentication alone authorizes channels or that external backends can directly reach port `9000`.
- [x] Concrete publish approval packet names the exact draft/listing/config.
- [x] Publish succeeds and public page is searchable/healthy.
- [x] Deploy button/public code works from a clean new-project path.
- [x] Public consumer smoke passes before work order closure.

## Monitoring intake

- [x] Published Templates registry row added.
- [x] Product Kit Adoption row changed from Building to Complete.
- [x] Published Template Monitoring Contract added.
- [x] Template Metrics Snapshot baseline recorded.
- [x] Support Contacts and support-health source checks recorded.
- [x] Managed Railway Resources confirms no active proof/source/draft-smoke resource; raw soft-delete follow-ups remain scheduled.
- [x] Same-day, 7-day, and 30-day review dates scheduled.
- [x] Winner Cycle Evidence and Portfolio Operating Loop ledgers updated after consumer smoke.
- [x] Builder, QA, and Deploy Tester registry rows closed after integration.

## Hard blockers

Do not publish or keep public if any of these is true:

- Digest/tag mismatch, missing `PORT=8000`, wrong health port, or nonterminal deploy.
- Wildcard Origin default or public/insecure API/admin.
- Missing same-project/private-network prerequisite for direct port `9000` publishing, or implied built-in external ingress.
- Treating authenticated base-namespace subscription as channel-level authorization, or using sensitive/private channels without separately tested upstream-supported permissions.
- Public port `9000`, health, metrics, debug, Swagger, API, or admin exposure.
- Serverless enabled for the base promise.
- Secret literal, leaked generated value, unredacted log, or private identifier in source/assets/support.
- Extra Redis/database/volume/Bucket/gateway/worker/scheduler or multiple replicas.
- Reconnect/delivery failure after the bounded recovery window.
- Docs imply durable history, guaranteed delivery, HA, PRO, scale-to-zero, performance/cost guarantee, or upstream endorsement.
- Broken support/security/deploy route.
- Missing independent QA, publish approval, consumer smoke, cleanup, or monitoring intake.
