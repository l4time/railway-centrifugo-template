# Railway Template Contract

Template code: `centrifugo-on-railway`

Package version: `2026-08-21`

Product-kit version: `2026-07-04-v1`

This is the exact contract the Railway template editor, QA Reviewer, and consumer-smoke Deploy Tester must reproduce. Repository config-as-code does not create template-editor variables or a public domain by itself.

## Source

| Field | Required value |
|---|---|
| Repository | `https://github.com/l4time/railway-centrifugo-template` |
| Branch | `main` |
| Dockerfile | `/Dockerfile` |
| Upstream image | `centrifugo/centrifugo:v6.9.2@sha256:f89352e38ef8043aaaa9045dec41cc8f2d35075b86ff553d4091ac19b547a3a6` |
| Start command | Upstream image default; no override |
| Pre-deploy command | None |

## Service and networking

| Field | Required value |
|---|---|
| Service name | `centrifugo` |
| Service count | `1` |
| Public domain | One Railway domain |
| Public target port | `8000` |
| Internal listener | `9000` |
| Health path | `/connection/init` |
| Health timeout | `30` seconds |
| Restart policy | `ON_FAILURE`, maximum `10` retries |
| Serverless | Disabled |
| Replicas | One |
| Volumes | None |
| Native databases | None |
| Redis | None |
| Buckets | None |
| TCP proxies | None |
| Other public ports/domains | None |

Port `9000` must have no public domain or TCP proxy. The package does not require a gateway because Centrifugo's external/internal listener split provides the required boundary.

## Template variables

Enter fixed values exactly. Configure generated values with Railway template secret generators; examples below express schema, not literal credentials.

| Variable | Editor value/type | Required | Secret | Consumer prompt | Rotation |
|---|---|---:|---:|---:|---|
| `PORT` | `8000` | Yes | No | No | Never independently |
| `CENTRIFUGO_HTTP_SERVER_PORT` | `8000` | Yes | No | No | Never independently |
| `CENTRIFUGO_HTTP_SERVER_INTERNAL_PORT` | `9000` | Yes | No | No | Never independently |
| `CENTRIFUGO_INIT_ENABLED` | `true` | Yes | No | No | No |
| `CENTRIFUGO_HEALTH_ENABLED` | `true` | Yes | No | No | No |
| `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY` | `${{secret(64)}}` | Yes | Yes | No | Coordinate with JWT issuer; invalidates old JWTs |
| `CENTRIFUGO_HTTP_API_KEY` | `${{secret(64)}}` | Yes | Yes | No | Coordinate with every publisher |
| `CENTRIFUGO_HTTP_API_EXTERNAL` | `false` | Yes | No | No | Must remain false |
| `CENTRIFUGO_HTTP_API_INSECURE` | `false` | Yes | No | No | Must remain false |
| `CENTRIFUGO_ADMIN_ENABLED` | `true` | Yes | No | No | Disable if admin is not used |
| `CENTRIFUGO_ADMIN_PASSWORD` | `${{secret(32)}}` | Yes | Yes | No | Rotate with admin secret after compromise |
| `CENTRIFUGO_ADMIN_SECRET` | `${{secret(64)}}` | Yes | Yes | No | Rotate with admin password after compromise |
| `CENTRIFUGO_ADMIN_EXTERNAL` | `false` | Yes | No | No | Must remain false |
| `CENTRIFUGO_ADMIN_INSECURE` | `false` | Yes | No | No | Must remain false |
| `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS` | Required exact origin(s) | Yes | No | Yes | Update deliberately when client origins change |
| `CENTRIFUGO_CHANNEL_WITHOUT_NAMESPACE_ALLOW_SUBSCRIBE_FOR_CLIENT` | `true` | Yes | No | No | Authenticated clients may initiate base-namespace subscriptions; not channel-level authorization |

The template must not provide a wildcard or empty convenience default for `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS`. Prompt text:

> Exact HTTPS origin(s) allowed to connect, including scheme and optional port. Use a space-separated list for multiple origins. Do not use `*`.

## Private backend wiring

No backend service is included. Direct API publishing on private port `9000` requires a trusted backend in the same Railway project/private network. Wire that backend with reference variables rather than copied values:

```text
CENTRIFUGO_INTERNAL_URL=http://${{centrifugo.RAILWAY_PRIVATE_DOMAIN}}:9000
CENTRIFUGO_API_KEY=${{centrifugo.CENTRIFUGO_HTTP_API_KEY}}
CENTRIFUGO_HMAC_SECRET=${{centrifugo.CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY}}
```

Those backend variable names are examples; adapt them to the backend. Never send either referenced secret to a browser client.

An external backend cannot directly reach the Railway private listener. Publishing from outside the project requires a separately secured and separately tested ingress design outside this template; do not expose port `9000` or enable the external/insecure API flags as a shortcut.

## Channel authorization boundary

The proved setting:

```text
CENTRIFUGO_CHANNEL_WITHOUT_NAMESPACE_ALLOW_SUBSCRIBE_FOR_CLIENT=true
```

allows an authenticated client to initiate subscriptions to channels in the base (unnamed) namespace. It does not decide whether that client should be allowed to subscribe to a particular channel.

Applications using sensitive, private, tenant, or per-user channels must configure an upstream-supported channel authorization mechanism or permissions model and separately test both allowed and denied subscription cases before use. Backend-issued client JWTs, exact Origin checks, and API-key protection do not by themselves supply channel-level authorization.

## Expected public behavior

| Check | Expected |
|---|---|
| `GET /connection/init` | `200` with `{}` |
| WebSocket `/connection/websocket` with correct Origin and valid JWT | Connects |
| Wrong Origin | Rejected |
| Malformed or expired JWT | Rejected |
| `/api`, `/admin`, `/health`, metrics, debug, Swagger paths | Not exposed publicly |

## Expected internal behavior

| Check | Expected |
|---|---|
| `GET http://127.0.0.1:9000/health` | `200` with `{}` |
| HTTP API without key | `401` |
| HTTP API with wrong key | `401` |
| HTTP API with valid key | Successful request |

Never paste the valid key into commands captured in tickets or documentation.

## Config-as-code boundary

`railway.json` controls:

- Dockerfile build selection.
- `/connection/init` health path.
- `30`-second health timeout.
- Restart-on-failure policy.

The Railway template draft controls:

- All service variables and secret generators.
- Public domain and target port.
- Serverless disabled.
- One-service topology and no stateful/extra resources.

QA must compare both surfaces. A green build with missing template-editor settings is not a valid template.
