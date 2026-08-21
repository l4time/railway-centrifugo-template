# Deploy and Host Centrifugo on Railway

Centrifugo is an open-source realtime messaging server for authenticated WebSocket and related client transports. This template deploys one always-on Centrifugo 6.9.2 service from an image pinned by tag and digest.

## About Hosting Centrifugo

The template exposes authenticated client transports on port 8000 and keeps the HTTP API, admin, and true health listener private on port 9000. Railway generates the client HMAC, API key, admin password, and admin-session secret. The deployment uses the ephemeral memory engine and creates no database, Redis, volume, Bucket, gateway, worker, or scheduler.

## Common Use Cases

- Realtime application notifications and live status updates.
- Collaborative UI updates backed by an authoritative application database.
- Authenticated event delivery from a trusted backend to connected clients.

## Dependencies for Centrifugo Hosting

- A trusted backend in the same Railway project/private network for direct API publishing.
- A client application with an exact HTTPS origin and short-lived client JWT flow.
- A durable backend datastore that remains the source of truth.

### Implementation Details

Enter exact client origins; never use a wildcard. The base subscription flag is not channel-level authorization. Sensitive or per-user channels require a separately configured and tested upstream authorization mechanism. Clients must reconnect, retry, resubscribe, and refresh authoritative state after interruptions. In-memory history may disappear on restart.

## Why Deploy Centrifugo on Railway?

Railway supplies the service domain, TLS termination, deployment health gate, generated secret values, and private project networking for the proved one-node contract. Serverless remains disabled because long-lived realtime connections do not fit sleep and cold-start behavior.

This is an unofficial community template and is not affiliated with or endorsed by the Centrifugo maintainers.
