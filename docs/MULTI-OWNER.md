# Design draft: multi-owner mode (clients.json) — v1.1 target

Status: DESIGN — not implemented in v1.0. Recorded in ROADMAP.md. Read this
before v1.1 work; DO NOT treat shipped behavior as matching this doc.

## Goal

One bot on one VPS supervises SEVERAL earning nodes and gives each client
a scoped view of only their node — the single-VPS-per-client pattern
(docs/HOSTING-PACKAGES.md) made denser when VPS cost dominates.

## File shape (draft)

```json
{
  "clients": [
    {
      "id": "c1",
      "telegram_ids": [123456789],
      "label": "client-a",
      "state_file": "state-c1.json",
      "log_file": "node-c1.log",
      "quota_minutes": 43200,
      "owner_ids": [111111111]
    }
  ]
}
```

Loaded by bot/config.py; validation: unique ids, telegram_ids may not
overlap between clients (a message must map to exactly one client), ONE
owner id may own several clients.

## Supervisor changes (draft)

- supervisor becomes per-clip class instance keyed by client id;
  state.json path becomes per-client; `_restart_scheduled` guard moves
  into the per-common tracer instance.
- Docker/image probes stay shared;
  /status output becomes per-client section for owners, own-slice for clients.

## Scoping rules

| Role | Sees | Can do |
|---|---|---|
| client | own /status /rewards /logs | /restart_node own node |
| owner | all clients + aggregate | everything incl. config reload |

## Open risks (why this is not shipped)

1. One crash-looping node shares CPU with healthy ones (cgroup limits via
   compose needed — upstream CLI is not cgroup-aware).
2. Process kill is process-group-wide today; signaling ONE node of several
   needs the spawn refactor in optimai.py.
3. Two clients see each other's node.log unless per-node file separation
   lands first (file separate per client: trivial, listed above).
