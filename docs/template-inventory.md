# Centrifugo Template Packaging Inventory

Status: published and launch-ready on 2026-08-21 after independent QA, clean draft smoke, public consumer smoke, operational cleanup, and monitoring intake.

## Package

| Field | Answer |
|---|---|
| Template code / candidate | `centrifugo-on-railway` / Centrifugo |
| Product-kit version | `2026-07-04-v1` |
| Source type | Public wrapper repository around an immutable public Docker image |
| Source repository / branch | `https://github.com/l4time/railway-centrifugo-template` / `main` |
| Dockerfile source | `centrifugo/centrifugo:v6.9.2@sha256:f89352e38ef8043aaaa9045dec41cc8f2d35075b86ff553d4091ac19b547a3a6` |
| Upstream version | Centrifugo `6.9.2` |
| Build method | Railway Dockerfile builder |
| Start command | Upstream image default; no override |
| Pre-deploy command | None |
| Config-as-code | `Dockerfile`, `.dockerignore`, `railway.json`; editor-only settings captured in `docs/railway-template-contract.md` |
| Wrapper behavior | No script or config transformation; adds only digest pin, OCI metadata, and config-as-code |

## Railway topology

| Field | Answer |
|---|---|
| Railway services | One `centrifugo` app service |
| Native service pattern | `Single stateless realtime app` |
| Public routing | One Railway domain targeting port `8000` |
| Public surface | Authenticated client transports and `/connection/init` |
| Internal routing | HTTP API, admin, and true health on port `9000` |
| Health check | `/connection/init`, timeout `30` seconds |
| Restart policy | On failure, maximum `10` retries |
| Serverless | Disabled; realtime connections/reconnect conflict with sleep/cold starts |
| Replicas | One |
| Database | None |
| Redis | None |
| Volume | None |
| Bucket | None |
| Gateway/proxy | None |
| Worker/scheduler/cron | None |
| Custom stateful service | None |

## Variables

| Variable | Class | Value source | Required | Notes |
|---|---|---|---:|---|
| `PORT` | Fixed non-secret | `8000` | Yes | Mandatory Railway health-port contract |
| `CENTRIFUGO_HTTP_SERVER_PORT` | Fixed non-secret | `8000` | Yes | Public listener |
| `CENTRIFUGO_HTTP_SERVER_INTERNAL_PORT` | Fixed non-secret | `9000` | Yes | Internal listener |
| `CENTRIFUGO_INIT_ENABLED` | Fixed non-secret | `true` | Yes | Public-safe init path |
| `CENTRIFUGO_HEALTH_ENABLED` | Fixed non-secret | `true` | Yes | Internal health |
| `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY` | Generated secret | Railway `${{secret(64)}}` | Yes | Backend-only JWT signing/verifying |
| `CENTRIFUGO_HTTP_API_KEY` | Generated secret | Railway `${{secret(64)}}` | Yes | Backend-only API authentication |
| `CENTRIFUGO_HTTP_API_EXTERNAL` | Fixed non-secret | `false` | Yes | Never public by default |
| `CENTRIFUGO_HTTP_API_INSECURE` | Fixed non-secret | `false` | Yes | API key required |
| `CENTRIFUGO_ADMIN_ENABLED` | Fixed non-secret | `true` | Yes | Internal admin available |
| `CENTRIFUGO_ADMIN_PASSWORD` | Generated secret | Railway `${{secret(32)}}` | Yes | No default password |
| `CENTRIFUGO_ADMIN_SECRET` | Generated secret | Railway `${{secret(64)}}` | Yes | Signs admin sessions |
| `CENTRIFUGO_ADMIN_EXTERNAL` | Fixed non-secret | `false` | Yes | Never public by default |
| `CENTRIFUGO_ADMIN_INSECURE` | Fixed non-secret | `false` | Yes | Insecure admin disabled |
| `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS` | User-supplied non-secret | Exact origin(s), no default | Yes | Space-separated; no wildcard |
| `CENTRIFUGO_CHANNEL_WITHOUT_NAMESPACE_ALLOW_SUBSCRIBE_FOR_CLIENT` | Fixed non-secret | `true` | Yes | Authenticated clients may initiate base-namespace subscriptions; not channel-level authorization |

No real secret is required or generated at build time. No value is committed in this package.

## User path and operations

| Field | Answer |
|---|---|
| Intended user | Backend developer/team adding self-hosted realtime delivery |
| First login/admin | No end-user bootstrap; admin stays private |
| First success | Terminal deploy; `/connection/init`; valid JWT/Origin WSS connect; private API publish; message delivery |
| Private API caller | Trusted backend in the same Railway project/private network; use Railway reference variables |
| External backend | Requires a separately secured and separately tested ingress design outside this template |
| Channel authorization | Base subscription flag is not channel-level authorization; sensitive/private/tenant/per-user channels require separately configured/tested upstream permissions |
| Persistence | Ephemeral in-memory presence/history/recovery only |
| Source of truth | User backend and durable application datastore |
| Client responsibility | Reconnect, backoff/retry, refresh JWT, resubscribe, refresh authoritative state |
| Backup | Accepted N/A for template-owned state; memory history cannot be backed up/restored |
| Restore | Redeploy pin/config, preserve/restore backend, reconnect and refresh clients |
| Update | Review release notes; resolve new digest; disposable full security/reconnect proof; change tag/digest together |
| Rollback | Restore prior tag/digest/config; no memory-state or data migration rollback |
| Expected boot | Health timeout `30` seconds; no stronger startup guarantee |
| Cost shape | Low always-on class based on synthetic proof; no bill/performance guarantee |

## Product-kit files

| Kit piece | File/evidence | Builder status |
|---|---|---|
| README deploy path and env guide | `README.md` | Complete |
| Operations/update/rollback/backup | `README.md`, `docs/operations.md` | Complete |
| Support boundary | `README.md`, issue routing | Complete |
| Issue intake | `.github/ISSUE_TEMPLATE/bug_report.yml`, `config.yml` | Complete |
| Changelog/update note | `CHANGELOG.md` | Complete |
| Marketplace overview | `overview.md`, `docs/marketplace-overview.md` | Published and verified |
| Support labels/triage | `.github/labels.yml` | Complete |
| Legal/security/trademark | `LICENSE`, `NOTICE.md`, `TRADEMARKS.md`, `SECURITY.md` | Complete |
| Assets/provenance | `assets/README.md` | Complete with accepted optional screenshot exception |
| Railway config contract | `Dockerfile`, `railway.json`, `docs/railway-template-contract.md` | Complete |
| Completion packet | `docs/product-kit-completion.md` | Filled |
| QA checklist | `docs/qa-checklist.md` | Complete; independent QA zero blockers |

## Support boundary

Template owner:

- Digest and wrapper metadata.
- Railway service/port/domain/health configuration.
- Required variables and generated-secret wiring.
- Public/internal surface isolation.
- Memory-engine and reconnect documentation.
- Reproducible clean-deploy package defects.

User/upstream:

- Backend JWT issuance, authorization, business logic, and durable state.
- Sensitive/private/tenant/per-user channel authorization design and tests.
- External-backend ingress to private port `9000`.
- Client libraries, retry behavior, frontend integration, and clock handling.
- Redis, brokers, HA, replicas, durable history, and multi-region design.
- PRO features and licensing.
- Custom gateway/proxy, gRPC/WebTransport tuning, performance/load sizing.
- Railway account/billing/platform incidents and custom DNS.

## Evidence and current gates

| Gate | State |
|---|---|
| Exact Railway proof | Passed for image/config contract |
| Proof cleanup | Operational cleanup passed; main dashboard owns grace-period follow-up |
| Build approval | Approved |
| Local package | Builder complete |
| Independent local QA | Passed after corrective re-audits |
| Public repository | Published at `https://github.com/l4time/railway-centrifugo-template` |
| Railway template | Published as `centrifugo-on-railway` / `73621515-56bf-4385-a0d0-9aac57a83a77` |
| Concrete publish approval packet | Approved and executed 2026-08-21 |
| Public consumer smoke | Passed from the public code; operational cleanup verified |
| Monitoring intake | Complete; 7-day review 2026-08-28 and 30-day review 2026-09-20 |

## Exceptions

Only the optional screenshot/UI-capture exception is accepted. The initial listing uses the original `assets/icon.svg` wrapper icon, no upstream logo is copied, and provenance rules are recorded in `assets/README.md`. No other kit piece is removed or marked not applicable.

## Publish blockers

- Any mismatch with the exact digest or `PORT=8000`.
- Wildcard origin or insecure/external API/admin default.
- Public port `9000`, API, admin, health, metrics, debug, or Swagger exposure.
- Serverless enabled or hidden extra/stateful service.
- Generated value stored in source, logs, issue copy, or marketplace asset.
- README cannot be followed from a clean template deployment.
- README/listing omits the same-project/private-network prerequisite or implies external backends can reach port `9000` directly.
- README/listing treats authenticated base-namespace subscription as channel-level authorization or lacks sensitive-channel allowed/denied testing requirements.
- Broken repo/support/security/deploy links.
- Unsupported durable-history, HA, PRO, performance, cost, or endorsement claim.
- Missing independent QA, concrete publish approval, consumer smoke, or monitoring intake.
