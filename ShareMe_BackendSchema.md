# ShareMe — Backend Schema

## Document 04 — v1.0.0

---

## Important Context First

Phase 1 of ShareMe is **fully peer-to-peer** — no cloud server sits in the transfer path (confirmed in PRD §6.5: "no data persisted on any server"). This means there are two separate schemas to document, not one:

| Schema | Where it lives | Built now? |
|---|---|---|
| **A. Local On-Device Schema** | SQLite, on each phone | ✅ Yes — Phase 1 |
| **B. Future Cloud Backend Schema** | Server-side, for Tier 2/3 (relay, accounts, payments) | ❌ Not yet — documented for forward planning only |

---

## Engineering Principles Applied (applies to both schemas below)

- **UUIDs as primary keys**, not auto-increment integers — avoids ID collisions if local data ever syncs to a future server, and avoids leaking row-count/sequence information
- **Explicit `NOT NULL` everywhere** unless a field is genuinely optional — no implicit nulls hiding bugs
- **Enum-like fields stored as TEXT + `CHECK` constraint**, not magic numbers — `status = 'completed'` is debuggable at a glance, `status = 2` is not
- **Foreign keys with explicit `ON DELETE` behavior** — every relationship states what happens to child rows when a parent is deleted, instead of leaving it to app-layer code to remember
- **Timestamps as epoch milliseconds (UTC)**, consistently — fast to sort/index, no timezone ambiguity
- **No raw file bytes ever stored in any database** — only file paths/URIs on-device, only metadata server-side. Files live on the filesystem or in object storage, never in a DB row
- **Indexes on every foreign key and every column used in `WHERE`/`ORDER BY`** in real query patterns (not speculative indexing)
- **Schema versioning from day one** — even a "v1" schema ships with a migrations folder, not a single hardcoded `CREATE TABLE` set, so v1.1 doesn't require a rewrite
- **snake_case table & column names, plural table names, singular column names** — consistent naming convention across the whole schema
- **Repository pattern at the access layer** — native transfer engine never touches the DB directly; it emits events, a single repository class owns all reads/writes, keeping transfer logic and persistence logic decoupled

---

## A. Local On-Device Schema (Phase 1 — built now)

**Engine:** SQLite, accessed via a typed wrapper (e.g. Drift) from the Flutter layer — kept out of the native speed-critical transfer engine entirely, per the architecture split in the TRD.

### A.1 `devices`

Cache of previously seen/paired peers, so the radar screen can show "last connected" hints and avoid re-negotiating capability info every time.

```sql
CREATE TABLE devices (
  id              TEXT PRIMARY KEY,          -- UUID, generated on first contact
  device_name     TEXT NOT NULL,
  platform        TEXT NOT NULL CHECK (platform IN ('android', 'ios')),
  last_band_used  TEXT CHECK (last_band_used IN ('2.4ghz', '5ghz', '6ghz')),
  last_seen_at    INTEGER NOT NULL,           -- epoch ms
  created_at      INTEGER NOT NULL,           -- epoch ms
  UNIQUE(device_name, platform)               -- prevents duplicate cache entries
);

CREATE INDEX idx_devices_last_seen ON devices(last_seen_at DESC);
```

### A.2 `transfers`

One row per transfer session (a single send/receive action, possibly containing multiple files).

```sql
CREATE TABLE transfers (
  id                 TEXT PRIMARY KEY,        -- UUID
  direction          TEXT NOT NULL CHECK (direction IN ('sent', 'received')),
  peer_device_id     TEXT NOT NULL REFERENCES devices(id) ON DELETE SET NULL,
  status             TEXT NOT NULL CHECK (status IN
                        ('pending', 'in_progress', 'completed', 'failed', 'cancelled')),
  band_used          TEXT CHECK (band_used IN ('2.4ghz', '5ghz', '6ghz')),
  total_bytes        INTEGER NOT NULL DEFAULT 0,
  transferred_bytes  INTEGER NOT NULL DEFAULT 0,
  error_reason       TEXT,                    -- nullable, only set when status='failed'
  started_at         INTEGER NOT NULL,
  completed_at       INTEGER                  -- nullable until finished
);

CREATE INDEX idx_transfers_started_at ON transfers(started_at DESC);
CREATE INDEX idx_transfers_status ON transfers(status);
CREATE INDEX idx_transfers_peer ON transfers(peer_device_id);
```

**Why `ON DELETE SET NULL` here, not `CASCADE`:** if a cached device record is purged, the transfer history shouldn't disappear with it — you still want to know "I sent a file" even if the device-cache entry expired.

### A.3 `transfer_files`

Individual files within a transfer batch (a transfer can contain 1 file or many).

```sql
CREATE TABLE transfer_files (
  id            TEXT PRIMARY KEY,             -- UUID
  transfer_id   TEXT NOT NULL REFERENCES transfers(id) ON DELETE CASCADE,
  file_name     TEXT NOT NULL,
  file_path     TEXT NOT NULL,                -- local URI, never the file content itself
  mime_type     TEXT NOT NULL,
  size_bytes    INTEGER NOT NULL,
  checksum      TEXT NOT NULL,                -- SHA-256, full-file, set on completion
  chunk_count   INTEGER NOT NULL,
  status        TEXT NOT NULL CHECK (status IN
                   ('pending', 'in_progress', 'completed', 'failed'))
);

CREATE INDEX idx_transfer_files_transfer_id ON transfer_files(transfer_id);
```

**Why `CASCADE` here, not `SET NULL`:** a file row has no meaning without its parent transfer — if the transfer record is deleted, its file rows should go with it.

### A.4 `app_settings`

Simple key-value store for device name, parallel-stream override, and future preferences — deliberately schema-light so new settings don't require migrations.

```sql
CREATE TABLE app_settings (
  key         TEXT PRIMARY KEY,
  value       TEXT NOT NULL,
  updated_at  INTEGER NOT NULL
);
```

### A.5 Migration Strategy (Phase 1)

- Migrations folder ships from v1: `migrations/001_initial_schema.sql`
- Every future schema change is a new numbered file, never an edit to an existing one — this is the standard "append-only migrations" practice, so any device upgrading from any prior version replays the same deterministic path
- A `schema_version` pragma/table tracks which migration each local DB is currently at

### A.6 What is deliberately NOT in this schema

- No user/account table — Phase 1 has no accounts
- No encryption-key table — session keys are ephemeral (generated per-handshake, per TRD §6.5) and never persisted to disk
- No file content of any kind — only paths and checksums

---

## B. Future Cloud Backend Schema (Tier 2/3 — NOT built in Phase 1)

This section exists purely for forward planning, so Phase 1's local schema doesn't paint us into a corner later. **None of this is implemented now.**

### B.1 Entities (when relay/accounts/payments arrive)

```sql
-- Users (only needed once accounts exist — still optional even in Tier 2)
CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email         TEXT UNIQUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at    TIMESTAMPTZ            -- soft delete, since this is now user data w/ compliance implications
);

-- Relay sessions (Tier 3 fallback only — used when P2P fails)
CREATE TABLE relay_sessions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_user_id    UUID REFERENCES users(id) ON DELETE SET NULL,
  storage_key       TEXT NOT NULL,        -- pointer to object storage (S3/R2), never the file itself
  size_bytes        BIGINT NOT NULL,
  expires_at        TIMESTAMPTZ NOT NULL, -- enforce auto-deletion of relayed files
  status            TEXT NOT NULL CHECK (status IN ('uploading','ready','downloaded','expired')),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Subscriptions (only relevant once paid tiers exist)
CREATE TABLE subscriptions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tier          TEXT NOT NULL CHECK (tier IN ('free','pro','unlimited')),
  renews_at     TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_relay_expires ON relay_sessions(expires_at);
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
```

### B.2 Why this is deferred, not built now

- Building this now would mean shipping idle infrastructure that costs money for zero benefit — Phase 1's entire value proposition is *not needing a server*
- `relay_sessions.expires_at` enforces auto-deletion — this matters for cost control and is the right pattern once you do build it, but premature today
- `users.deleted_at` (soft delete) is included here because once real accounts/emails exist, deletion requests carry compliance weight — that's a Tier 2+ problem, irrelevant to Phase 1's anonymous local-only data

---

## Summary

Phase 1 ships with **schema A only** — 4 tables, fully local, zero network dependency for persistence. Schema B is a planning artifact so that when relay/accounts do get built, the local schema already isolates transfer history cleanly enough to sync or extend without a rewrite.
