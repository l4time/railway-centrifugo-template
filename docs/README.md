# Centrifugo on Railway Documentation

This directory is the production handoff for template code `centrifugo-on-railway`, product kit `2026-07-04-v1`.

## Document map

- [Railway template contract](railway-template-contract.md): exact service, ports, variables, secret generators, health, and Serverless settings.
- [Operations guide](operations.md): health, logs, security checks, reconnect behavior, rotation, updates, rollback, and incident response.
- [Build notes](build-notes.md): design rationale, proof basis, accepted scope, and publish gates.
- [Marketplace overview](marketplace-overview.md): listing title, description, category, overview copy, deploy button, and asset plan.
- [Template inventory](template-inventory.md): filled source, service, variable, routing, persistence, update, and support inventory.
- [Product-kit completion packet](product-kit-completion.md): filled `2026-07-04-v1` handoff and exception record.
- [QA checklist](qa-checklist.md): builder checks, reviewer gates, consumer smoke, publish, and monitoring intake.
- [Asset provenance](../assets/README.md): original wrapper icon, screenshot/UI-capture exception, and future asset rules.

The repository-level [README](../README.md) is the non-expert deployment and operating path. When documents disagree, the exact pinned image, approved build packet, and the Railway contract in this directory take precedence until the discrepancy is corrected.

## Product promise

One access-separated, always-on, single-node Centrifugo memory-engine service on Railway:

- Digest-pinned Centrifugo `6.9.2`.
- Public authenticated client listener on `8000`.
- Private API/admin/health listener on `9000`.
- Generated HMAC/API/admin secret types.
- Exact user-supplied client origin(s), with no wildcard default.
- No Redis, database, volume, Bucket, gateway, worker, or scheduler.
- No durable-history, HA, multi-replica, PRO, scale-to-zero, or performance promise.

Direct private API publishing requires a trusted backend in the same Railway project/private network. External-backend ingress is a separately secured and tested user-owned design.

The backend remains the durable source of truth and clients must reconnect, retry, resubscribe, and refresh state. The enabled base-namespace subscription flag is not channel-level authorization; sensitive, private, tenant, or per-user channels require a separately configured and tested upstream-supported authorization mechanism.
