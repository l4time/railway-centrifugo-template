# Marketplace Asset Inventory and Provenance

Status: original wrapper icon included because Railway requires a marketplace icon. The build-packet screenshot exception remains: no screenshot, upstream logo, demo video, or synthetic UI capture is included.

| Asset | Present | Source / owner | Permission status | Synthetic data | Freshness | Intended use |
|---|---:|---|---|---:|---|---|
| Railway deploy button | Remote badge only | Railway `https://railway.com/button.svg` | Used as Railway deployment-link UI | N/A | Verified with public slug 2026-08-21 | Repository README |
| Wrapper marketplace icon | Yes: `assets/icon.svg` | Original geometric SVG created for this repository on 2026-08-21 | Covered by this repository's Apache-2.0 wrapper license; contains no copied upstream logo or Railway mark | N/A | Review when visual identity changes | Railway template icon and repository asset |
| Marketplace screenshot | No | N/A | Optional exception accepted in Build Approval Packet | N/A | Post-smoke decision: not needed for launch | None |
| Centrifugo logo | No | Upstream mark intentionally excluded | Not needed; avoids trademark/license ambiguity and upstream-endorsement implications | N/A | N/A | None |
| Demo video/GIF | No | N/A | Not required for initial package | N/A | N/A | None |

## Accepted screenshot exception

The product kit `2026-07-04-v1` allows this candidate-specific exception:

- The initial listing may omit screenshots and UI captures; Railway's required original wrapper icon is not a screenshot.
- The marketplace overview, service map, memory-engine limits, and support boundary provide the product explanation.
- Public consumer smoke passed without requiring a screenshot; any later screenshot must use a safe, stable synthetic view and record its source and permission here.
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
