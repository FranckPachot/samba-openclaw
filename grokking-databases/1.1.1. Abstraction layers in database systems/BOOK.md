# 1.1.1. Abstraction Layers in Database Systems

## Introduction

Modern database systems present a set of layered abstractions that separate the concerns of developers, applications, and the underlying storage engine. Understanding these layers helps developers reason about performance, reliability, and portability without needing to dive into low‑level implementation details.

| Layer | Primary Concern | Typical API | Example Tools |
|-------|------------------|------------|---------------|
| **Application / Domain Model** | Business logic, data modeling | ORM entities, domain objects | Hibernate, Prisma, ActiveRecord |
| **SQL / Query Language** | Expressing data manipulation and retrieval | SQL statements, parameterised queries | psql, MySQL client |
| **Query Planner / Optimizer** | Turning SQL into an efficient execution plan | Explain plans, hints | PostgreSQL `EXPLAIN`, MySQL `EXPLAIN` |
| **Execution Engine** | Running operators (scans, joins, sorts) | Execution nodes, pipelines | Volcano model, vectorized engine |
| **Storage Engine** | Managing pages, indexes, logging | Page reads/writes, B‑tree, LSM‑tree | InnoDB, PostgreSQL heap, RocksDB |
| **Operating System / Hardware** | Memory, I/O, CPU scheduling | System calls, DMA | Linux kernel, SSD/NVMe |

### Why Layers Matter

* **Portability** – Applications can switch databases if they stay within the SQL layer.
* **Performance Tuning** – Knowing which layer is the bottleneck guides the right optimisation (e.g., adding an index vs. rewriting a query).
* **Reliability** – Failures are isolated; a crash in the storage engine does not corrupt the application state if the engine follows WAL and atomic commit protocols.
* **Development Efficiency** – Developers work at the SQL layer without understanding B‑tree page splits or LSM‑tree compaction.

## Core Concepts

1. **Data Independence** – The logical schema (tables, columns) is independent from how rows are stored on disk. This is the classic *three‑level* architecture (external, conceptual, internal).
2. **Encapsulation** – Each layer hides its internal complexities behind a well‑defined contract, allowing developers to focus on the level they care about.
3. **Cost Model** – The optimizer uses statistics collected by the storage engine to estimate costs; accurate stats are essential for good plans.

## Layer-by-Layer Examples

### Example 1: Simple Query Execution

Consider the query:

```sql
SELECT name FROM users WHERE created_at > now() - interval '30 days';
```

| Layer | Action | Developer Concerns |
|-------|--------|-------------------|
| **Application** | ORM builds `.where("created_at > ?", thirty_days_ago)` | Object mapping, N+1 queries |
| **SQL** | Generates parameterized query with placeholders | SQL injection prevention, query readability |
| **Planner** | Chooses between index scan or sequential scan | Missing index warnings, outdated statistics |
| **Execution** | Executes index scan operator | CPU utilization, memory spilling to disk |
| **Storage** | Reads B‑tree index pages | Page cache hits, SSD vs HDD latency |
| **OS/Hardware** | Services read I/O requests | Disk queue length, memory pressure |

### Example 2: Transaction Isolation

```sql
-- Transaction 1
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- Meanwhile, Transaction 2 runs:
SELECT balance FROM accounts WHERE id = 1;
```

| Layer | Concern | Implementation Detail |
|-------|---------|----------------------|
| **Application** | Business logic for transferring funds | Race conditions, retry logic |
| **SQL** | MVCC visibility rules | Isolation level (READ COMMITTED vs SERIALIZABLE) |
| **Planner/Execution** | Lock acquisition strategy | Row locks vs predicate locks |
| **Storage** | Multi‑version concurrency control | Undo logs, version chains |
| **OS/Hardware** | Atomic writes for durability | fsync guarantees, RAID controllers |

### Example 3: The N+1 Query Problem

An ORM might generate:

```python
# Application layer: Object‑oriented thinking
users = User.objects.filter(active=True)
for user in users:
    posts = user.posts.filter(published=True)  # N+1 queries!
```

What happens under the hood:

1. **Application**: 1 query for users + N queries for posts
2. **SQL**: N+1 separate SELECT statements
3. **Planner**: Each query optimized individually
4. **Execution**: N+1 network round trips, N+1 query parsing
5. **Storage**: N+1 index lookups, inefficient page access

**Solution**: Use `SELECT ... FROM users JOIN posts ...` (single query) or eager loading (`User.objects.prefetch_related('posts')`). Understanding layers helps you know when to bypass the ORM abstraction.

## Common Problems at Each Layer

### Application Layer Problems
- **N+1 queries** (as above)
- **Object‑relational impedance mismatch** – Complex object graphs that don't map well to relational tables
- **Over‑fetching** – Retrieving entire objects when only a few fields are needed

### SQL Layer Problems  
- **SQL injection** – String concatenation instead of parameterization
- **Cartesian products** – Missing JOIN conditions
- **Type mismatches** – Implicit conversions that prevent index usage

### Planner/Execution Problems
- **Outdated statistics** leading to wrong plan choices
- **Missing indexes** forcing sequential scans
- **Parameter sniffing** – Plans optimized for one parameter value perform poorly for others

### Storage Engine Problems
- **Fragmentation** – Indexes become inefficient after many updates/deletes
- **Write amplification** – LSM‑trees rewriting data during compaction
- **Buffer pool pressure** – Not enough memory for hot pages

### OS/Hardware Problems
- **Disk I/O bottlenecks** – Queries waiting on slow storage
- **Memory pressure** – System swapping instead of caching database pages
- **NUMA effects** – Memory access patterns on multi‑socket servers

## Practical Developer Advice

1. **Profile across layers** – When a query is slow, check:
   - Application: Are you making N+1 queries?
   - SQL: Is the query using indexes? Check `EXPLAIN`
   - Storage: Are pages being read from disk or memory?

2. **Know when to bypass layers** – Sometimes you need to:
   - Use raw SQL instead of ORM for complex joins
   - Add query hints when the planner makes wrong choices
   - Configure storage‑layer settings (like `shared_buffers` in PostgreSQL)

3. **Think about the whole stack** – A "database performance" problem might be:
   - Missing index (storage layer)
   - Outdated stats (planner layer)  
   - ORM generating inefficient SQL (application layer)
   - Disk too slow (hardware layer)

## Real‑World Scenario: E‑Commerce Checkout

Imagine an e‑commerce checkout that:
1. Validates inventory (application logic)
2. Updates inventory count (SQL UPDATE)
3. Creates order record (SQL INSERT)
4. Sends confirmation email (external service)

**Layers in action:**
- **Application**: Business rules, retry logic for failures
- **SQL**: Transactions ensuring atomicity (all or nothing)
- **Planner**: Choosing indexes for inventory lookup
- **Storage**: WAL ensuring durability even if crash occurs
- **OS/Hardware**: Fast SSD for WAL writes, enough RAM for inventory cache

Understanding these layers helps debug why checkout might be slow (inventory table locked? WAL sync delay? application‑level deadlock?).

---

*Next steps*: Dive deeper into the **SQL Layer** (Chapter 1.1.2) to see how parsing and rewriting shape the execution plan.
