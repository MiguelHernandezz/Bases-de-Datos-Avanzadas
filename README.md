<div align="center">

# 🐘 Bases de Datos Avanzadas · UAH

**Advanced Databases (Bases de Datos Avanzadas, 780020) · B.S. Computer Engineering · Universidad de Alcalá · 2025–2026**

[![build](https://github.com/MiguelHernandezz/Bases-de-Datos-Avanzadas/actions/workflows/build.yml/badge.svg)](https://github.com/MiguelHernandezz/Bases-de-Datos-Avanzadas/actions/workflows/build.yml)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL_17-316192?style=flat-square&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Team](https://img.shields.io/badge/team-2_people-00C853?style=flat-square)

</div>

PostgreSQL from the inside: how tables are stored on disk, how the planner picks a plan, what the WAL and transactions guarantee, and how to replicate and distribute a database across servers. Every practice works with **millions of generated rows**.

> Done in a **team of 2**; my teammate's name and both ID numbers have been removed from the reports, logs and config files for privacy.

Every push spins up a **real PostgreSQL 17** in [GitHub Actions](.github/workflows/build.yml), bulk-loads data from the generators and runs the SQL scripts.

---

## 📁 Contents

| Folder | Practice | What's inside |
|---|---|---|
| [`PL1-almacenamiento-fisico`](PL1-almacenamiento-fisico) | Physical storage | 30M-row generator, bulk load, report, server logs |
| [`PECL2-carga-masiva-optimizacion`](PECL2-carga-masiva-optimizacion) | Bulk loading & query optimisation | Data generator for the MUSICOS database (~40M rows), report, logs |
| [`PECL3-seguridad-transacciones`](PECL3-seguridad-transacciones) | Security, users & transactions | Full SQL script, `postgresql.conf`, deadlock and recovery logs, report |
| [`PECL4-replicacion-distribuida`](PECL4-replicacion-distribuida) | Replication & distributed database | Config (`postgresql.conf`, `pg_hba.conf`) and logs of 4 servers, report |

Each folder includes the report (`Memoria_*.pdf`) answering every question with commands, query plans and screenshots.

---

## PL1 · Physical storage (30M rows)

- Theoretical size of a table in **8 KB blocks** vs the real size reported by PostgreSQL.
- Same query on a heap table, a table **physically ordered** by the search key, and a **partitioned** table, with block reads compared.
- **B-tree vs hash indexes** on 30 million rows: size, build time and blocks read per lookup.
- Inserts, deletes, dead tuples and **VACUUM / ANALYZE**.

## PECL2 · Bulk loading & query optimisation

- A Python generator for a music-industry schema (bands, musicians, albums, 12M songs, concerts, 24M tickets), modelled in **pgModeler**.
- Bulk load with `COPY` and use of the **statistics collector**.
- Reading `EXPLAIN` plans (seq scan, index scan, **hash join**, aggregates), then proposing indexes, statistics and configuration changes.
- Deleting 30% of musicians with cascades, then re-planning the same query and explaining what changed.

## PECL3 · Security, users & transactions

- **WAL**: inspecting records with `pg_waldump` and finding the transaction ID of a given insert.
- **Users and privileges** (`CREATE USER`, `GRANT`) and monitoring with `pg_stat_activity` and `pg_locks`.
- **Isolation between sessions**: uncommitted data invisible to other users, automatic rollback after an error, manual `ROLLBACK`.
- A three-session schedule that ends in a **deadlock**, and how PostgreSQL resolves it.
- **Point-in-time recovery (PITR)**: base backup + WAL archive, simulated cluster loss and full restore.

## PECL4 · Replication & distributed database

- Four servers: two masters (`MUSICOS1`, `MUSICOS2`) and two standbys.
- **Streaming replication** master → standby, and **logical replication**, with what each node type allows.
- A **distributed database** across both masters with `postgres_fdw` (foreign servers and tables).

---

## ▶️ Run it

Requires PostgreSQL (with `psql`) and Python 3.

```bash
# PL1: generate students (default 30M; pass a smaller number to try it) and load them
cd PL1-almacenamiento-fisico
python "Int. Datos.py" 100000
psql -d <your_db> -f Consulta1.sql

# PECL2: generate the MUSICOS data (scale 1 = full size, 0.001 = small sample)
cd ../PECL2-carga-masiva-optimizacion
python CSVMusicos.py 0.001
```

`PECL3.sql` is a lab script: parts of it are meant to run in **different `psql` sessions at the same time** (musico1, musico2, musico3) to reproduce the isolation and deadlock scenarios, as marked in its comments.

---

<!-- syllabus:start -->
## 📘 Syllabus · official UAH teaching guide

> **Bases de Datos Avanzadas (780020)** · 6 ECTS · 2nd year · 2nd semester · contents from the 2025-26 teaching guide · [official subject page](https://www.uah.es/es/estudios/estudios-oficiales/grados/asignatura/Bases-de-Datos-Avanzadas-780020/)

| Unit | Hours | Topics |
|---|---|---|
| Storage planning and indexes | 20 h | Storage devices and record structures · File organisation · Index structures and how they work |
| Query processing and optimisation | 20 h | Query-processing algorithms and their cost · Statistics-based optimisation · Pipelining and materialisation |
| Database administration | 12 h | Transactions, concurrency control and recovery · Auditing, monitoring and performance tuning · Security, users and privileges |
| Distributed and large databases | 4 h | Architecture and types of distribution · Distributed transactions, concurrency and availability |
<!-- syllabus:end -->

---

<div align="center">

Miguel Hernández López · [GitHub](https://github.com/MiguelHernandezz) · [LinkedIn](https://www.linkedin.com/in/miguel-hernandez-lopez/)

</div>
