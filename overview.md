# Deploy and Host Centrifugo with Railway

Centrifugo is an open-source, language-agnostic realtime messaging server for adding authenticated WebSocket and related realtime transports to applications. This template deploys one digest-pinned Centrifugo `6.9.2` service with generated secrets, explicit browser origins, a Railway health check, and a deliberate public/internal port split.

## What this template creates

- One always-on `centrifugo` service.
- Public authenticated client transports on port `8000`.
- Private HTTP API, admin, and true-health surfaces on internal port `9000`.
- Generated client HMAC, HTTP API, admin password, and admin-session secrets.
- No database, Redis, volume, Bucket, gateway, worker, or scheduler.

## Why use it

Self-hosting an access-separated realtime node requires more than opening a WebSocket port. The public listener, private publish API, JWT signing, Origin enforcement, admin access, health checks, restart behavior, and delivery semantics must agree. This package captures the exact low-footprint contract proved on Railway while keeping insecure API/admin modes off.

## Required input

Provide the exact HTTPS origin or origins used by your client application. Wildcard origins are not a safe default and are not included.

Your trusted application backend must issue client JWTs, publish through the private HTTP API, and remain the durable source of truth. Clients must reconnect, retry, resubscribe, and refresh state after interruptions.

Direct API publishing on port `9000` requires that backend to share the Centrifugo service's Railway project/private network. External backends need a separately secured and separately tested ingress design outside this template.

The enabled base-namespace subscription flag lets authenticated clients initiate subscriptions; it is not channel-level authorization. Sensitive, private, tenant, or per-user channels require an upstream-supported authorization mechanism or permissions model that the application configures and tests separately.

## Persistence

The default memory engine is ephemeral. Presence, publication history, and recovery state may disappear on restart or redeploy. This template is not a database or durable message queue and makes no durable-history, guaranteed-delivery, HA, Redis, or PRO promise.

## Operating stance

Railway Serverless is disabled because long-lived realtime connections do not fit sleep/cold-start behavior. The template is designed for one always-on node. It includes documented health, security, restart/reconnect, update, rollback, and support boundaries.

## Support

Template support covers the Railway deployment contract. Backend and channel authorization/token issuance, external-backend ingress, application code, Redis/HA/brokers, custom proxies, PRO, and performance guarantees remain outside the package.

This is an unofficial template and is not endorsed by or affiliated with the Centrifugo maintainers.
