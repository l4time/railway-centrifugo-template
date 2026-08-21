# Build Notes

Status: local production package built from the approved Centrifugo Build Approval Packet. Separate QA, repository creation, Railway template draft, publish approval, public consumer smoke, and monitoring intake remain external gates.

## Design

The smallest credible product is one unmodified, digest-pinned Centrifugo image:

- Public listener `8000` for authenticated client transports and `/connection/init`.
- Internal listener `9000` for HTTP API, admin, and true health.
- Generated HMAC/API/admin values.
- Exact user-supplied allowed origin(s).
- Memory engine, one replica, always-on.
- No Redis, database, volume, Bucket, gateway, worker, scheduler, or custom stateful service.

This extends the portfolio's `Single stateless realtime app` native pattern. No Railway-native stateful service is needed because durable history and HA are outside the default promise.

## Why a Dockerfile

The Dockerfile:

- Pins both the upstream `v6.9.2` tag and the proved immutable digest.
- Preserves the upstream entrypoint and command.
- Adds only OCI metadata and exposed-port documentation.
- Lets Railway use repository config-as-code and future root-branch update notifications.

No wrapper script or generated configuration file is needed because Centrifugo's environment-variable interface expresses the proved contract.

## Proof basis

The corrected disposable Railway proof for this exact digest and `PORT=8000` passed:

- Terminal deployment success.
- Public `/connection/init` response.
- Public/internal API/admin/health isolation.
- Missing/wrong/valid API-key behavior.
- Wrong-Origin and malformed/expired-JWT rejection.
- Valid WSS subscription and private-API publish/delivery.
- Reconnect/resubscribe/new delivery after one restart, allowing one transient first attempt.
- Bounded logs with no generated-value match.
- Peak synthetic proof metrics below the approved stop gates.
- No stateful or extra service.
- Operational project deletion and zero active inventory.

Proof does not establish production capacity, SLA, durable delivery, HA, Redis, PRO, or cost guarantees.

## Accepted support burden

Medium:

- Railway port/domain/health wiring.
- JWT and API-key integration boundaries.
- Exact Origin configuration.
- Memory-engine expectations.
- Client reconnect/retry/resubscription.
- Explicit public/internal surface split with external and insecure modes disabled.
- Private API publishing requires a trusted backend sharing the Railway project/private network; external ingress is separately secured/tested and excluded.
- The proved base-namespace client-subscription flag is not channel-level authorization; sensitive/private channels require separately configured/tested upstream permissions.

Excluded:

- Backend token issuance and authorization implementation.
- Sensitive, private, tenant, or per-user channel authorization design.
- External-backend ingress to the private publish API.
- Frontend client code and framework integration.
- Redis, broker, HA, multi-replica, multi-region, or durable history.
- Custom proxy/gateway, gRPC/WebTransport tuning, load testing, and sizing.
- Centrifugo PRO features, licenses, or support.

## Cost and Serverless

The synthetic proof peaked at `73.02 MiB` RAM and `0.004816 vCPU`. Those numbers support a low-footprint classification only; they are not a bill or production estimate.

Serverless is deliberately off. Long-lived realtime connections and predictable reconnect behavior conflict with service sleep/cold starts. Functions do not fit a full Centrifugo server.

## Package inventory

- Runtime/config: `Dockerfile`, `.dockerignore`, `railway.json`.
- User path: `README.md`, `overview.md`.
- Lifecycle: `CHANGELOG.md`, `docs/operations.md`.
- Support: issue form/config, canonical labels, support boundary.
- Legal/security: `SECURITY.md`, `LICENSE`, `NOTICE.md`, `TRADEMARKS.md`.
- Marketplace/assets: `docs/marketplace-overview.md`, `assets/README.md`.
- QA/control: exact Railway contract, filled template inventory, product-kit completion packet, QA checklist.

## Build-time secrets

None. The repository contains only secret generator expressions and secret type names. Real values are created by Railway at consumer deployment time and must not be added to source or documentation.

## Publish blockers

- Separate QA Reviewer has not yet accepted all builder-controlled checks.
- Public repository and actual root commit do not yet exist.
- Railway template draft variables/domain/Serverless configuration are not yet built or inspected.
- Publish approval packet is not yet concrete.
- Public consumer smoke has not yet followed the README from zero.
- Deploy button and support/security links must be verified after the real public slug/repository exist.
- Monitoring intake must be prepared before publish and finalized after consumer smoke.

The optional screenshot is the only accepted product-kit asset exception. It is recorded in `assets/README.md`.

## QA handoff

The QA Reviewer should:

1. Compare every variable and topology field with the approved build packet and passed proof.
2. Validate JSON/YAML/Dockerfile and local Markdown links.
3. Scan for secret-looking literals, stale proof URLs/IDs, wildcard origin defaults, insecure/external `true`, `latest`, Serverless claims, and unsupported Redis/HA/PRO promises.
4. Build the Dockerfile locally without changing source, if the QA scope allows local image access.
5. Confirm the upstream default command is preserved.
6. Review README as a non-expert backend developer.
7. Mark builder-controlled checklist items accepted or return exact blockers.

Repository creation, Railway draft configuration, clean consumer deploy, publication, and monitoring are separate authorized main-thread actions after local QA.
