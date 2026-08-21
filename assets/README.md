# Marketplace Asset Inventory and Provenance

Status: text-only initial listing approved as the build-packet screenshot exception. No image, screenshot, logo, demo video, or synthetic UI asset is included in this package.

| Asset | Present | Source / owner | Permission status | Synthetic data | Freshness | Intended use |
|---|---:|---|---|---:|---|---|
| Railway deploy button | Remote badge only | Railway `https://railway.com/button.svg` | Used as Railway deployment-link UI | N/A | Verify at publish | Repository README |
| Marketplace screenshot | No | N/A | Optional exception accepted in Build Approval Packet | N/A | Revisit after public consumer smoke | None initially |
| Centrifugo logo | No | Upstream mark not copied | Avoided pending explicit asset/license and trademark review | N/A | N/A | None |
| Demo video/GIF | No | N/A | Not required for initial package | N/A | N/A | None |

## Accepted screenshot exception

The product kit `2026-07-04-v1` allows this candidate-specific exception:

- The initial listing may be text-only.
- The marketplace overview, service map, memory-engine limits, and support boundary provide the product explanation.
- A screenshot may be added only after the public consumer smoke produces a safe, stable view and its source and permission are recorded here.
- The absence of a screenshot must not be replaced by an upstream logo copied without provenance.

No other product-kit exception is claimed.

## Rules for future assets

Before adding an asset:

1. Record the filename, creator/source URL, capture date, license or permission, modifications, and intended channel in this file.
2. Use synthetic channels, users, tokens, and messages only.
3. Remove Railway project IDs, private domains, account/workspace names, JWTs, API keys, admin cookies, environment values, timestamps that reveal private activity, and browser extensions/profile data.
4. Do not show the admin password, admin secret, HMAC secret, HTTP API key, or a decodable client JWT.
5. Do not imply upstream endorsement, PRO capability, HA, durable history, or performance guarantees.
6. Re-capture or remove an asset if the UI or package contract changes materially.

## Suggested post-smoke screenshot

If a screenshot is later useful, prefer a narrow synthetic client view showing:

- A connected state.
- A generic channel such as `example:updates`.
- One synthetic message such as `{"type":"demo","version":1}`.
- No admin surface, tokens, headers, logs, domains, or identifiers.

Capture provenance and QA acceptance before publishing the image.
