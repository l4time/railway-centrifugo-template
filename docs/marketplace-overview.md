# Centrifugo Marketplace Listing Packet

Status: published and consumer-smoked on 2026-08-21. The public slug, listing fields, icon, source, deploy path, support routes, one-service contract, and operational cleanup are verified.

## Listing fields

| Field | Proposed value |
|---|---|
| Title | Centrifugo |
| Template code / public slug | `centrifugo-on-railway` |
| Category | `Other` |
| Short description | Single-node Centrifugo with private API access and generated secrets. |
| Source repository | `https://github.com/l4time/railway-centrifugo-template` |
| Upstream version | `6.9.2` |
| Services | One `centrifugo` service |
| Required user input | Exact allowed HTTPS client origin(s) |
| Persistence | None; memory-engine state is ephemeral |
| Asset plan | Original wrapper icon at `assets/icon.svg`; optional screenshot/UI-capture exception recorded in `assets/README.md` |
| Public template URL | `https://railway.com/deploy/centrifugo-on-railway` |

Railway assigned the intended slug; the deploy-button links require no reconciliation.

## Marketplace overview copy

### Deploy an access-separated Centrifugo realtime node

Centrifugo is an open-source, language-agnostic realtime messaging server for authenticated WebSocket and related client transports. This template deploys one always-on Centrifugo `6.9.2` service from an image pinned by tag and digest.

The package handles the easy-to-miss Railway wiring:

- Public client listener and domain on port `8000`.
- Internal HTTP API, admin, and true health on port `9000`.
- Railway-generated client HMAC, HTTP API, admin password, and admin-session secrets.
- Exact user-supplied client origins, with no wildcard default.
- `/connection/init` Railway health check.
- API/admin external and insecure modes disabled.
- No database, Redis, volume, Bucket, gateway, worker, or scheduler.

### What you provide

Enter the exact HTTPS origin or origins used by your browser/application clients. Your trusted backend must issue client JWTs, publish through the private HTTP API, and remain the durable source of truth.

Direct publishing on private port `9000` works only when the trusted backend shares the Centrifugo service's Railway project/private network. An external backend needs a separately secured and separately tested ingress design outside this template.

The enabled base-namespace subscription flag lets authenticated clients initiate subscriptions. It is not channel-level authorization. Applications using sensitive, private, tenant, or per-user channels must configure and separately test an upstream-supported channel authorization mechanism or permissions model before use.

### Persistence and reconnect behavior

This base template uses Centrifugo's single-node memory engine. Presence, publication history, and recovery state may disappear on restart or redeploy. Clients must reconnect, retry, resubscribe, and refresh authoritative state from the backend. The template is not a database, durable queue, or guaranteed-delivery system.

Railway Serverless is disabled because realtime connections do not fit sleep and cold-start behavior.

### Scope

The template covers the proved one-node Railway deployment contract. Redis, brokers, HA, multiple replicas, durable history, PRO, backend/channel authorization code, external-backend ingress, frontend integrations, custom proxies, and performance guarantees are not included.

This is an unofficial community template and is not affiliated with or endorsed by the Centrifugo maintainers.

## Deploy button

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/centrifugo-on-railway)

The public code was deployed into a clean project and passed consumer smoke.

## Services-created copy

> Creates one public `centrifugo` service. It does not create Redis, a database, persistent storage, a gateway, or an application backend. The HTTP API, admin, and true health listener remain private on port `9000`.

## Required-input copy

> Enter the exact HTTPS origin(s) allowed to connect, including the scheme and optional port. Separate multiple origins with spaces. Never use `*`. Your backend must generate Centrifugo client JWTs. Direct private API publishing requires a backend in the same Railway project/private network. The base subscription flag is not channel-level authorization.

## First-run copy

> After the deployment reaches `SUCCESS`, open `/connection/init`, then connect an authenticated client at `/connection/websocket`. From a trusted backend sharing the Railway private network, publish a synthetic message through the private API and confirm delivery. For sensitive/private channels, first configure and test upstream-supported channel authorization. Restart once to confirm the client retries, reconnects, resubscribes, and receives a new message.

## Listing claims to reject

Do not say or imply:

- Production-ready, enterprise-ready, highly available, zero-downtime, or guaranteed delivery.
- Durable history, backup-free business data, or message recovery across restart.
- Redis, broker, multi-node, multi-region, or horizontal scaling support.
- Serverless, scale-to-zero, or no-cost idle operation.
- Centrifugo PRO features, licensing, or official support.
- Backend JWT/authorization logic or frontend integration is included.
- A valid client JWT or the base subscription flag alone authorizes access to every channel.
- External backends can directly reach private port `9000`, or public ingress is included.
- The proof footprint guarantees a consumer's bill, capacity, or performance.
- Upstream or Railway endorses this community package.

## Marketplace QA

- Confirm the valid category in the current editor.
- Confirm title, short description, overview, and exact version.
- Confirm the service count is one and no hidden resource is added.
- Confirm all generated secret fields are non-prompting and hidden.
- Confirm the exact origin field prompts the consumer and has no wildcard default.
- Confirm user-path copy requires a backend in the same Railway project/private network for direct publishing and includes reference-variable wiring.
- Confirm user-path copy states the base subscription flag is not channel authorization and requires separate allowed/denied tests for sensitive channels.
- Confirm the domain targets `8000` and Serverless is disabled.
- Confirm the repo, support, security, and deploy links work.
- Confirm the original wrapper icon loads and the optional screenshot/UI-capture exception remains explicit.
- Confirm consumer smoke passes before monitoring intake closes.
