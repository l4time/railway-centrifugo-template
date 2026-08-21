# Template Product Kit Completion Packet

Packet status: filled by Template Builder and accepted by independent local QA on 2026-08-21; post-build external gates remain pending.

| Field | Answer |
|---|---|
| Template code / candidate | `centrifugo-on-railway` / Centrifugo |
| Kit version | `2026-07-04-v1` |
| Archetype / native-service pattern | Single stateless realtime app; one public app with separate internal listener, no stateful service |
| Completion owner | `centrifugo_template_builder`; main thread owns integration and external gates |
| Required kit pieces | README deploy path and env guide; operations; support boundary; issue intake; changelog/update; marketplace; labels/triage; legal/security/trademark — all present |
| Repository assets | `README.md`, `CHANGELOG.md`, issue form/config, labels, `SECURITY.md`, `LICENSE`, `NOTICE.md`, `TRADEMARKS.md`, asset provenance, `Dockerfile`, `railway.json`, exact editor contract |
| Runtime/user-path evidence | Passed corrected Railway proof: terminal success, health, isolation, API/JWT/Origin negatives, WSS delivery, restart/reconnect, logs, resource gates, cleanup. Fresh consumer deploy from public template remains required |
| Support path evidence | Issue form, public issue routing, private security advisory URL, upstream discussion route, Railway help route, no-secrets warnings all packaged; links must be verified in real public repo |
| Exceptions | Optional screenshot only: text-only initial listing accepted by Build Approval Packet and documented in `assets/README.md`; no other exception |
| QA blocker status | Accepted after one fix cycle: two P1 documentation/contract findings corrected; re-audit returned zero local publish blockers |
| Publish readiness | Listing copy, intended slug/button, fallback category, source version, service map, required origin, and asset exception prepared. Actual repo/draft/category/link inspection, publish approval, and public consumer smoke pending |
| Monitoring intake | Same-day/7-day/30-day monitoring contract, metrics/support/source checks, resource cleanup, and product-kit adoption rows are main-thread post-publish work |
| Main-thread ledger updates | Build/Publish Work Order; Product Kit Adoption; Active Subagent Registry; then Published Templates, monitoring contract, metrics snapshot, support contacts, managed resources, review dates, operating-loop and winner-cycle evidence after publish/smoke |
| Compaction rule | After 30-day review, collapse detailed build/QA/smoke evidence to dashboard refs unless a gap or incident remains open |

## Completion evidence

| Required piece | Artifact | Builder verdict | QA required |
|---|---|---|---|
| Deploy path | `README.md` | Complete | Non-expert review and public consumer smoke |
| Environment guide | `README.md`, `docs/railway-template-contract.md` | Complete | Compare template editor values |
| Operations | `docs/operations.md` | Complete | Reconnect/security/update review |
| Support boundary | README, operations, issue routes | Complete | Public-route verification |
| Issue intake | `.github/ISSUE_TEMPLATE/*` | Complete | YAML/schema and public rendering |
| Changelog/update | `CHANGELOG.md` | Complete | Commit/version and rollback review |
| Marketplace overview | `overview.md`, marketplace packet | Complete for draft | Actual category/slug/button/listing review |
| Support labels | `.github/labels.yml` | Complete | YAML and naming review |
| Legal/security/trademark | Four root assets | Complete | License/notices/link review |
| Screenshot/demo provenance | `assets/README.md` | Accepted exception | Confirm text-only listing is acceptable |
| Config-as-code | Dockerfile, railway.json, editor contract | Complete | Build/static and draft comparison |

## Runtime contract reconciliation

- Exact image: present and consistent.
- `PORT=8000`: mandatory and documented in every runtime contract.
- Public `8000` / internal `9000`: documented.
- Health `/connection/init`, `30` seconds: config and docs agree.
- Generated HMAC/API/admin secret types: documented with Railway generators only.
- Exact user origin: required; wildcard explicitly prohibited.
- API/admin external and insecure flags: all `false`.
- Direct private API publishing: trusted backend must share the Railway project/private network; reference wiring is in the pre-deploy path.
- External backend: separately secured/tested ingress is outside the template; private port `9000` stays private.
- Base-namespace client subscribe: enabled as proved, but explicitly not channel-level authorization.
- Sensitive/private/tenant/per-user channels: require an upstream-supported authorization mechanism and separate allowed/denied tests.
- Serverless: disabled.
- Topology: one app; no Redis/DB/volume/Bucket/gateway.
- Memory engine: ephemeral; backend source of truth; client reconnect/retry/resubscribe required.
- Backup: accepted `N/A` for template-owned state; adding persistence invalidates that stance.
- Update/rollback: immutable tag and digest change together; disposable proof required.
- Claims: no HA, Redis, durable history, PRO, performance, cost, or endorsement promise.

## Remaining workflow, not kit exceptions

These are lifecycle gates rather than missing repository assets:

1. Public repository creation and root commit.
2. Railway template draft configuration/inspection.
3. Concrete publish approval packet.
4. Public publication.
5. Clean consumer smoke from the published template.
6. Monitoring and support intake.

The packet must not be marked publish-ready until those gates pass.
