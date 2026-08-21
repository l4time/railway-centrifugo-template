# Changelog

All notable changes to the Centrifugo on Railway template are recorded here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the template uses explicit upstream version and digest pins rather than semantic versioning promises for the packaged application.

## [Unreleased]

- Public repository, Railway template draft, publish approval, and public consumer smoke are pending the separate QA/publish workflow.

## [2026-08-21]

### Added

- Initial `centrifugo-on-railway` product package using product kit `2026-07-04-v1`.
- Exact upstream runtime pin:
  `centrifugo/centrifugo:v6.9.2@sha256:f89352e38ef8043aaaa9045dec41cc8f2d35075b86ff553d4091ac19b547a3a6`.
- One-service Railway contract with public port `8000`, internal port `9000`, `/connection/init` health check, generated secret types, explicit origins, API/admin external and insecure modes disabled, and Serverless disabled.
- Pre-deploy requirements for a same-project/private-network publishing backend and separate external-ingress design.
- Explicit warning that authenticated base-namespace subscriptions are not channel-level authorization; sensitive/private channels require separately configured and tested upstream permissions.
- Documentation for the ephemeral memory engine, backend source of truth, client reconnect/retry/resubscription, updates, rollback, no-backup-required default, support boundaries, and legal/security notices.

### Proof basis

- The exact digest reached terminal success in a disposable Railway proof with `PORT=8000`.
- Public/internal isolation, valid and invalid API authentication, JWT and Origin rejection, WebSocket delivery, one restart/reconnect cycle, bounded logs, and low resource stop gates passed.
- The proof project was removed from active inventory. These results justify the package contract; they are not a performance, availability, or cost guarantee.

### Rollback

Restore this initial tag and digest together with the documented variables. The memory-engine package has no template-owned data migration or durable state to roll back.
