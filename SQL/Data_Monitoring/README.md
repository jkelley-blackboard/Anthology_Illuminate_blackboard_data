# Anthology Illuminate — CDM Insert Monitoring

Snowflake SQL queries for monitoring data freshness across Anthology Illuminate Canonical Data Models (CDMs). Detects insert cadence gaps and classifies each time bucket against per-source expectations, surfacing anomalies before they affect downstream reporting.

---

## Files

| File | Description |
|------|-------------|
| `illuminate_monitoring.sql` | Full query including per-source executive summary and fleet-wide rollup |
| `illuminate_monitoring_detail.sql` | Detail-only variant — one row per 5-minute bucket per source, no rollup |

Both files share the same CTE structure up through the `detail` stage. The executive summary builds on top of that foundation and can be toggled off by swapping the final `SELECT` as noted in the comments.

---

## Disclaimer

### Health Status is Data-Derived, Not System-Authoritative

The `health_status` values (`HEALTHY`, `WATCH`, `DEGRADED`) and `gap_class` classifications produced by these queries are derived entirely from insert activity observed in your Snowflake CDM tables. They reflect patterns in the data — specifically, the presence or absence of row inserts within expected time windows.

**This is not a real-time system health monitor.** These queries cannot detect upstream pipeline failures, Anthology platform incidents, network issues, or any condition that does not ultimately manifest as a change in insert activity. A `HEALTHY` status means inserts are arriving on the expected cadence as configured; it does not mean the underlying Anthology Illuminate platform is operating normally, nor should it be used as a substitute for official monitoring or support channels.

Always verify unexpected results against the [Anthology Illuminate status page](https://status.anthology.com) and consult Anthology support for confirmed data pipeline issues.

---

## License & Support

This project is provided **as-is**, without warranty of any kind, express or implied. It is not an Anthology product and is not covered by any Anthology support agreement.

- No guarantee is made that query results are accurate, complete, or suitable for any particular purpose
- No support, maintenance, or updates are promised or implied
- Use in production environments is at your own discretion and risk
- Anthology Illuminate schema changes may require updates to these queries without notice

> This is community/internal tooling. If you encounter issues, please raise them in this repository rather than contacting Anthology support.

---

## What It Does

The query looks back over a configurable window (default: 5 days) and groups insert events into 5-minute buckets per source table. Each bucket is then classified against that source's expected refresh cadence:

| `gap_class` | Meaning |
|-------------|---------|
| `FIRST_SEEN` | No prior bucket to compare against |
| `ON_EXPECTED_CADENCE` | Gap within one bucket-width of expected |
| `DAILY_LOAD_WINDOW` | Daily ETL gap within ±60 min of 24 hours |
| `MINOR_VARIANCE` | Gap exceeded expected but within tolerance multiplier |
| `LARGE_GAP` | Gap exceeded all tolerance thresholds |

The executive summary (`illuminate_monitoring.sql`) rolls these up to a `health_status` per source — `HEALTHY`, `WATCH`, or `DEGRADED` — plus a single fleet-wide row.

---

## CDM Refresh Rates

Source configurations in `source_config` are aligned to the published Anthology Illuminate refresh cadences. Refer to the official documentation when adjusting `expected_gap_minutes`:

> **[Refresh Rates for Canonical Data Models — Anthology Illuminate Help](https://help.anthology.com/illuminate/en/anthology-illuminate-developer/refresh-rates-for-illuminate-canonical-data-models.html)**

Current cadences relevant to this query:

| CDM | Refresh Cadence | `source_profile` used |
|-----|----------------|-----------------------|
| CDM\_TLM (Telemetry) | Every 30 minutes | `SCHEDULED_BATCH_30M` |
| CDM\_MEDIA (Video Studio) | Near real-time | `NEAR_REALTIME` |
| CDM\_LMS (Blackboard) | Overnight (region-dependent) | `DAILY_ETL` |
| CDM\_MAP (Mapping) | Every 2 hours | `SCHEDULED_BATCH_2H` |
| CDM\_ALY (Ally) | Every 12 hours | `SCHEDULED_BATCH_12H` |
| LEARN (Blackboard source tables) ⚠️ | Every 4 hours | `SCHEDULED_BATCH_4H` |

> ⚠️ **Illuminate Premium required:** The `LEARN` schema (`LEARN.ACTIVITY_ACCUMULATOR`) is only available to institutions with an Anthology Illuminate Premium licence. If you do not have Premium, the query will fail with a table-not-found error. To disable it, comment out **two** locations in each SQL file:
>
> **1. In `source_config`** — comment out the `LEARN.ACTIVITY_ACCUMULATOR` row:
> ```sql
> -- ('LEARN.ACTIVITY_ACCUMULATOR',    240,  2, 'SCHEDULED_BATCH_4H')
> ```
> **2. In `all_events_raw`** — comment out the matching `UNION ALL` block:
> ```sql
> -- UNION ALL
> -- SELECT 'LEARN.ACTIVITY_ACCUMULATOR', ROW_INSERTED_TIME
> -- FROM learn.activity_accumulator
> -- WHERE ROW_INSERTED_TIME >= (SELECT start_ts FROM date_window)
> ```

> **Note:** CDM\_LMS refresh start times vary by AWS region. The `DAILY_LOAD_WINDOW` gap class in the query tolerates ±60 minutes around the 24-hour mark to account for this. Verify the correct start time for your region in the documentation above.

---

## Configuration

All tunable parameters are in the `parameters` and `source_config` CTEs at the top of the file.

### Global parameters

```sql
SELECT
    5    AS days_back,      -- lookback window in days
    5    AS minute_bucket,  -- bucket width in minutes
    '1970-01-01'::TIMESTAMP AS epoch_ts
```

### Per-source configuration

```sql
-- source_table          | expected_gap_minutes | small_gap_multiplier | source_profile
('CDM_TLM.ULTRA_EVENTS',   30,                    2,                    'SCHEDULED_BATCH_15M')
```

- **`expected_gap_minutes`** — the normal interval between inserts for this source
- **`small_gap_multiplier`** — gap is acceptable up to `expected_gap_minutes × multiplier`; tune per source based on observed variance

### Adding a new source

1. Add a row to `source_config`
2. Add a corresponding `UNION ALL` block to `all_events_raw`

These two must stay in sync — a source present in one but not the other will fail silently.

---

## Requirements

- Snowflake (tested on standard Snowflake SQL; no Snowpark or UDFs required)
- `SELECT` privileges on all monitored CDM tables
- The query assumes `ROW_INSERTED_TIME` is present and indexed on each source table

---

## Usage

Run directly in Snowflake worksheet, or schedule via a Snowflake Task. For QuickSight integration, wrap the executive summary output in a view and use Direct Query mode to avoid stale cached results.

```sql
-- Detail view only (swap the final SELECT in illuminate_monitoring.sql):
SELECT * FROM detail ORDER BY source_table, bucket_ts DESC;

-- Or use the standalone detail file:
-- illuminate_monitoring_detail.sql
```
