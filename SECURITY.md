# Security Policy

## Supported scope

Security reports for this repository should concern the Centrifugo on Railway wrapper and deployment contract, including:

- A package default that exposes the HTTP API, admin, health, metrics, debug, or Swagger surface publicly.
- Missing or insecure Railway variable defaults.
- Secrets committed to this repository or printed by wrapper-owned behavior.
- A misleading origin, port, health, image-pin, or support instruction that creates a security risk.
- A vulnerability in repository automation, issue forms, or documentation-controlled deployment behavior.

Upstream Centrifugo vulnerabilities belong to the upstream project's published security route. Railway platform vulnerabilities belong to Railway's security reporting route. Do not disclose either class publicly here before following the responsible upstream process.

## Reporting

Use GitHub's private security advisory feature for the public repository:

`Security` → `Advisories` → `Report a vulnerability`

If private advisories are unavailable, contact the repository owner through the private contact path on the owner's GitHub profile and ask for a secure reporting channel. Do not open a public issue for a suspected vulnerability.

Include:

- Template code `centrifugo-on-railway`.
- Template/package version and the exact upstream tag and digest.
- A concise impact statement and reproducible steps.
- The affected Railway surface, without account or project secrets.
- Sanitized evidence only.

## Never include

Do not send:

- `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY`.
- `CENTRIFUGO_HTTP_API_KEY`.
- `CENTRIFUGO_ADMIN_PASSWORD` or `CENTRIFUGO_ADMIN_SECRET`.
- Client JWTs, cookies, private hostnames, account tokens, full environment dumps, or unredacted logs.
- Real customer messages, user identifiers, or other production data.

If a value was exposed, revoke or rotate it in Railway immediately, update every trusted consumer, invalidate affected sessions/tokens where possible, and then submit a sanitized report.

## Operational security defaults

- Public domain target: port `8000` only.
- Internal API/admin/health listener: port `9000`, with no public domain or TCP proxy.
- `CENTRIFUGO_HTTP_API_EXTERNAL=false`.
- `CENTRIFUGO_HTTP_API_INSECURE=false`.
- `CENTRIFUGO_ADMIN_EXTERNAL=false`.
- `CENTRIFUGO_ADMIN_INSECURE=false`.
- Exact client origins only; no wildcard origin.
- Unique Railway-generated secrets per project.
- Direct API publishing only from a trusted backend sharing the Railway project/private network; no external ingress is included.
- The enabled base-namespace client-subscription flag is not channel-level authorization; sensitive/private/tenant/per-user channels require separately configured and tested upstream-supported permissions.
- Serverless disabled for the always-on realtime contract.

Changing these defaults creates a user-owned security design outside the tested template scope.

## Response expectations

The maintainer will acknowledge a valid wrapper/template report when reasonably available, assess severity, coordinate a fix and disclosure path, and avoid requesting raw secrets. This repository does not promise an upstream Centrifugo or Railway remediation timeline.
