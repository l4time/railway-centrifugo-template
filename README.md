# Centrifugo

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/centrifugo-on-railway)

Deploy one low-footprint, access-separated [Centrifugo](https://github.com/centrifugal/centrifugo) realtime messaging node on Railway. The package pins Centrifugo `6.9.2` by tag and digest, exposes authenticated client transports on port `8000`, keeps the HTTP API, admin UI, and true health endpoint on internal port `9000`, and creates no database, Redis, volume, Bucket, gateway, worker, or scheduler.

This is an unofficial Railway deployment wrapper, not an upstream Centrifugo distribution or support channel.

## What gets deployed

| Service | Public | Purpose | Persistence |
|---|---:|---|---|
| `centrifugo` | Yes, port `8000` | Authenticated WebSocket/client transports and `/connection/init` | None; the default memory engine is ephemeral |

The service uses:

```text
centrifugo/centrifugo:v6.9.2@sha256:f89352e38ef8043aaaa9045dec41cc8f2d35075b86ff553d4091ac19b547a3a6
```

The upstream image's default command starts Centrifugo. This repository does not add an entrypoint, proxy, database, or stateful service.

## Before you deploy

You need the exact browser or application origin that will connect to Centrifugo, including the scheme and optional port, for example `https://app.example.com`. Enter that value as `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS`.

Do not use `*`. Add only origins you control. Multiple origins use the upstream-supported space-separated form, for example:

```text
https://app.example.com https://admin.example.com
```

Your application backend must issue Centrifugo client JWTs and publish through the private HTTP API. The template does not create that backend or implement authorization rules for your application.

> **Private-network requirement:** Direct publishing to port `9000` works only when the trusted backend shares this Centrifugo service's Railway project/private network. An external backend cannot reach the private listener directly; it needs a separately secured and separately tested ingress design outside this template.

For a trusted backend service in the same Railway project, prefer Railway reference variables:

```text
CENTRIFUGO_INTERNAL_URL=http://${{centrifugo.RAILWAY_PRIVATE_DOMAIN}}:9000
CENTRIFUGO_API_KEY=${{centrifugo.CENTRIFUGO_HTTP_API_KEY}}
CENTRIFUGO_HMAC_SECRET=${{centrifugo.CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY}}
```

Those backend variable names are examples; adapt them to your application and never expose either referenced secret to browser code.

> **Channel authorization requirement:** `CENTRIFUGO_CHANNEL_WITHOUT_NAMESPACE_ALLOW_SUBSCRIBE_FOR_CLIENT=true` lets an authenticated client initiate subscriptions to channels in the base (unnamed) namespace. A valid client JWT plus this flag is not channel-level authorization. Before using sensitive, private, tenant, or per-user channels, configure an upstream-supported channel authorization mechanism or permissions model and test allowed and denied subscriptions separately. This template proves only the documented base subscription flow.

## Required Railway service contract

The Railway template must create exactly one service, set its public domain target port to `8000`, keep Serverless disabled, and configure these variables:

| Variable | Source | Purpose |
|---|---|---|
| `PORT` | Fixed `8000` | Railway health and public-port contract; do not omit |
| `CENTRIFUGO_HTTP_SERVER_PORT` | Fixed `8000` | Public client listener |
| `CENTRIFUGO_HTTP_SERVER_INTERNAL_PORT` | Fixed `9000` | Internal API, admin, and true-health listener |
| `CENTRIFUGO_INIT_ENABLED` | Fixed `true` | Enables public-safe `/connection/init` health probe |
| `CENTRIFUGO_HEALTH_ENABLED` | Fixed `true` | Enables true health on the internal listener |
| `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY` | Railway-generated secret | Signs/verifies client JWTs |
| `CENTRIFUGO_HTTP_API_KEY` | Railway-generated secret | Authenticates backend publish/API calls |
| `CENTRIFUGO_HTTP_API_EXTERNAL` | Fixed `false` | Keeps the HTTP API off the public listener |
| `CENTRIFUGO_HTTP_API_INSECURE` | Fixed `false` | Requires the API key |
| `CENTRIFUGO_ADMIN_ENABLED` | Fixed `true` | Enables admin access on the internal listener |
| `CENTRIFUGO_ADMIN_PASSWORD` | Railway-generated secret | Admin login password |
| `CENTRIFUGO_ADMIN_SECRET` | Railway-generated secret | Signs admin sessions |
| `CENTRIFUGO_ADMIN_EXTERNAL` | Fixed `false` | Keeps admin off the public listener |
| `CENTRIFUGO_ADMIN_INSECURE` | Fixed `false` | Prevents insecure admin mode |
| `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS` | Required user input | Exact allowed browser/application origin(s); never wildcard |
| `CENTRIFUGO_CHANNEL_WITHOUT_NAMESPACE_ALLOW_SUBSCRIBE_FOR_CLIENT` | Fixed `true` | Allows authenticated clients to initiate base-namespace subscriptions; not channel-level authorization |

The four generated values must be unique, stable Railway template secrets. Never reuse them across projects, put them in source, paste them into issue reports, or expose them to browser code. The client HMAC secret and HTTP API key belong only in your trusted backend.

The complete editor contract is in [docs/railway-template-contract.md](docs/railway-template-contract.md).

## First application setup

There is no first-user or first-admin bootstrap flow in this package. Centrifugo is realtime infrastructure, not an end-user application.

After deployment:

1. Confirm the Railway deployment reaches terminal `SUCCESS`.
2. Open `https://<your-domain>/connection/init`; it should return `200` with `{}`.
3. Keep `/api`, `/admin`, `/health`, `/metrics`, `/debug`, and Swagger paths inaccessible from the public domain.
4. Add your trusted backend to the same Railway project/private network and wire the private hostname and generated values with the reference variables shown above.
5. Use `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY` in the backend to issue short-lived client JWTs.
6. Use `CENTRIFUGO_HTTP_API_KEY` from the backend to publish through the private HTTP API.
7. Connect the client to `wss://<your-domain>/connection/websocket` with an allowed `Origin`.
8. Subscribe, publish one synthetic message from the backend, and verify delivery.
9. Restart the service once; the client must reconnect, resubscribe, and tolerate a transient failed attempt while the service returns.

Do not copy generated values out of Railway unless your backend needs them. When services share a Railway project, prefer Railway reference variables over manually duplicated values.

## Persistence and delivery semantics

This template intentionally uses Centrifugo's single-node memory engine:

- Presence, publication history, recovery state, and other in-memory data can disappear on restart, redeploy, crash, or replacement.
- The service is not a database, durable queue, event ledger, or source of truth.
- Your application backend and durable datastore remain the source of truth.
- Clients must implement reconnect, retry, resubscribe, and authoritative state refresh.
- A successful reconnect does not mean publications emitted during downtime can be recovered.
- One replica is the supported default. Redis-backed multi-node/HA and durable-history designs are outside this template's promise.

Use application-level idempotency and sequence/version checks when duplicate or reordered messages matter. Do not make business correctness depend on one in-memory publication.

## Always-on operation

Keep Railway Serverless disabled. Long-lived realtime connections and reconnect semantics conflict with sleeping after outbound inactivity. This package makes no scale-to-zero or cold-start promise.

The live proof for this exact digest observed a low resource footprint, but that is not a performance or cost guarantee. Connection count, channel activity, message size, history configuration, logging, and client behavior change resource use. Monitor your own service and set appropriate Railway usage limits.

## Health and networking

Railway health check:

- Path: `/connection/init`
- Timeout: `30` seconds
- Public listener/domain port: `8000`

True internal health:

```text
http://<private-service-host>:9000/health
```

The public init endpoint is intentionally shallow. Use Railway deployment status and logs alongside it. Do not expose port `9000` through a public domain or TCP proxy.

## Operations

The detailed runbook is in [docs/operations.md](docs/operations.md). In normal operation:

- Check Railway deployment status before declaring a release healthy.
- Inspect bounded logs without posting generated values.
- Test one authenticated WebSocket delivery after configuration changes.
- Test reconnect and resubscription after a controlled restart.
- Rotate a compromised secret deliberately and update every trusted consumer at the same time.

## Backup and restore

There is no application data or volume to back up in the default package. The memory engine is deliberately ephemeral.

Preserve outside the service:

- Your backend's durable state and its normal backups.
- The exact image tag and digest.
- The non-secret configuration and allowed-origin list.
- A secure recovery process for generated secrets.

A default restore means redeploying the pinned image/configuration, restoring the backend source of truth, and letting clients reconnect and refresh state. In-memory history cannot be restored. If you add Redis, a database, or a volume, this no-backup-required statement no longer applies and you own a separate backup/restore design.

## Updates and rollback

Never change only the image tag, use `latest`, or follow a moving branch.

Before an update:

1. Review upstream release, migration, configuration, security, and compatibility notes.
2. Resolve the new image digest for the chosen immutable release.
3. Test the new tag and digest in a disposable Railway project.
4. Repeat public/internal isolation, missing/wrong/valid API-key, invalid/expired JWT, wrong-Origin, WSS delivery, restart/reconnect, bounded-log, and resource checks.
5. Change the Dockerfile tag and digest together.
6. Record the change and user impact in `CHANGELOG.md`.

Rollback by restoring the previously proved tag and digest plus the previous configuration. Memory mode has no data migration or state rollback; clients reconnect and rebuild state from the backend.

## Secret rotation

- `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY`: rotating it invalidates existing client JWTs. Update the issuer first or coordinate a short maintenance window, then require fresh tokens.
- `CENTRIFUGO_HTTP_API_KEY`: update every trusted publisher at the same time.
- `CENTRIFUGO_ADMIN_PASSWORD` and `CENTRIFUGO_ADMIN_SECRET`: rotate together when admin access may be compromised; existing admin sessions can be invalidated.

Never rotate secrets merely to redeploy. Stable generated values are expected across routine restarts.

## Troubleshooting

### Deployment never becomes healthy

- Confirm `PORT=8000` exists. Omitting it caused a real Railway proof failure even though Centrifugo itself was listening.
- Confirm the domain targets port `8000`.
- Confirm `/connection/init` is enabled and the health timeout is `30`.
- Confirm the image tag and digest match this repository.
- Inspect bounded service logs for configuration errors without sharing secrets.

### WebSocket connection is rejected

- Use `wss://<domain>/connection/websocket`, not internal port `9000`.
- Confirm the browser sends an origin exactly present in `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS`.
- Confirm the client JWT is signed by the configured HMAC secret, is not expired, and contains the expected Centrifugo claims.
- Check client clock skew and token refresh behavior.

### Connection works but subscribe or publish fails

- Confirm the base subscription flag remains `true` if you rely on unnamed-channel client subscriptions.
- Remember that this flag permits authenticated clients to initiate base-namespace subscriptions; it does not authorize individual channels.
- For sensitive, private, tenant, or per-user channels, configure and separately test an upstream-supported channel authorization mechanism or permissions model before use.
- Keep application authorization decisions in the backend and issue appropriate short-lived credentials.
- Publish from a trusted backend through the private API on port `9000`.
- Confirm the API key is supplied through the expected header and was not rotated on only one side.

### Reconnect is briefly unsuccessful

A transient first reconnect attempt during restart is expected. Use backoff, obtain a fresh JWT when needed, resubscribe after connection, and refresh authoritative state from the backend. Treat failure to reconnect and receive a new message within your own recovery objective as an incident.

### Admin or API appears publicly

Stop using the deployment. Confirm the public domain targets only `8000`, internal port `9000` has no public domain/TCP proxy, and all `*_EXTERNAL` and `*_INSECURE` variables are `false`.

## Known limits

This package does not promise or support:

- Durable history, guaranteed delivery, or recovery of messages emitted during downtime.
- Redis, Redis Cluster, NATS, broker integrations, HA, horizontal replicas, or multi-region operation.
- Centrifugo PRO features or licensing.
- Backend token issuance, user authorization, business logic, schema design, or frontend client code.
- Channel-level authorization policy for sensitive, private, tenant, or per-user channels.
- Public ingress for an external backend that does not share the Railway private network.
- Custom gateways/proxies, gRPC/WebTransport tuning, performance sizing, or cost guarantees.
- A publicly exposed API, admin UI, internal health endpoint, metrics, debug, or Swagger surface.

## Support boundary

Template support covers the Dockerfile pin, Railway build/deploy configuration, required variables, public/internal port split, health path, generated-secret wiring, origin defaults, and documentation for the proved single-node memory-engine path.

Use the repository issue form for reproducible template defects. Upstream Centrifugo behavior belongs in the [Centrifugo repository](https://github.com/centrifugal/centrifugo). Your team owns backend JWT issuance, authorization, durable state, client reconnect logic, application integrations, load testing, custom domains/DNS, optional engines/brokers, and production architecture.

Do not post secrets, full environment dumps, private hostnames, JWTs, API keys, or unredacted logs in either support channel. Security reports follow [SECURITY.md](SECURITY.md).

## License and trademarks

The wrapper files in this repository are licensed under Apache License 2.0. Centrifugo is an upstream open-source project with its own Apache-2.0 licensing and notices; review the upstream repository for the authoritative terms.

“Centrifugo” and related marks belong to their respective owners. This repository is unofficial, is not endorsed by the Centrifugo maintainers, and provides no official Centrifugo support. See [NOTICE.md](NOTICE.md) and [TRADEMARKS.md](TRADEMARKS.md).
