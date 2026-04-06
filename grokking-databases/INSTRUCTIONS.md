
## Instructions for daily work

In this directory, there's one subdirectory per chapter. You will write the book, each chapter in a BOOK.md file in the right directory. Gather other information from the web that can be useful for this chapter in a REFERENCES.md.
I will also work on it, it's a team work. You add content, I add content, you fix typos and grammar. And every day the book will be better and better.

## Book Proposal

Grokking Database Internals
Franck Pachot

1. Tell us about yourself. Please include
What are your qualifications for writing this book? 

I have been working with databases for more than 30 years and have always been passionate about understanding how database engines work internally rather than treating them as black boxes. I am an Oracle Certified Master and an AWS Data Hero, recognitions that reflect both deep technical expertise and the ability to communicate complex ideas clearly.

A key part of my work has been comparing database implementations and their internal trade‑offs. I regularly present at international conferences such as FOSDEM, where I’ve given talks comparing MVCC implementations, consensus protocols, and indexing structures.

What is your current job role? Previous roles?

I am currently a Developer Advocate at MongoDB, working primarily with developers to explain how databases behave and how design choices impact performance, scalability, and correctness.

Previously, I was a Developer Advocate at YugabyteDB, a distributed SQL database based on PostgreSQL with a distributed storage on RocksDB.

Before that, I spent 30 years as a database consultant, working on database operations, application development support, and performance tuning across a wide range of relational database systems. From this customer experience, I focus on what engineers actually observe in production, and how that behavior follows from internal design choices.

Do you have any unique characteristics or experiences that will make you stand out as the author?

I have published nearly a thousand blog posts about database internals and behavior on dbi-services.com, on dev.to, and other platforms. I was also a co‑author of Oracle 12c Multitenant (Oracle Press). All content I publish is based on fact, with small reproducible demos when possible, so that the internals behavior is visible from a user point of view.

A distinguishing aspect of my work is explaining complex database implementation, trade‑offs, and comparisons across systems rather than focusing on a single vendor. I am active on social media and in the database community, where my goal is to consistently help practitioners build accurate mental models of how databases work in order to make the best architecture and development decisions. In social media and forums, I focus on providing concise and accurate answers rather than long explanations.

2. Tell us about the book’s topic. 
What is the technology or idea that you’re writing about? 

This book explains how modern database engines operate internally and is written explicitly for application developers and engineers who use databases in real production systems.

The target reader is not someone building a database engine or reading engine source code. Instead, the reader is a developer who needs to reason about performance, concurrency, correctness, and scaling when designing applications, often across multiple databases, without treating the database as a black box.

Rather than teaching features, APIs, or SQL syntax, the book focuses on the mechanisms that determine observable behavior: storage engines, indexing, query planning and execution, transaction processing, MVCC, replication, and scaling trade-offs. The goal is to help readers understand why a database behaves the way it does under load, concurrency, and failure.

The book draws concrete examples from widely used systems (PostgreSQL, MySQL, Oracle, SQL Server, MongoDB, and DynamoDB) not to teach those products, but to compare implementation choices and trade-offs. Systems are used as case studies to show that different engines solve the same problems in fundamentally different ways, and how it impacts the visible behavior.

This positioning differentiates the book from academic descriptions of database internals aimed at database engineers and product-specific internals books aimed at administrators of a single system.
The emphasis throughout is on building accurate mental models that developers can apply immediately when designing schemas, writing queries, choosing isolation levels, or debugging production issues.

Why is it important now? 

Modern application architectures make database internals more important than ever. Today’s developers routinely work with multiple databases in the same system (OLTP, analytics, caches, search, streams) as well as cloud-managed services that hide implementation details, distributed SQL and globally replicated systems, and abstraction layers such as ORMs and data access frameworks.

These trends boost productivity but also obscure the mechanisms that govern performance, consistency, and failure behavior. When something goes wrong—slow queries, deadlocks, replication lag, write conflicts, or unexpected anomalies—developers must reason about systems whose internals they never explicitly learned.

Meanwhile, few teams can invest months of deep study into every database they use. Developers, therefore, tend to assume that a new database behaves like the one they already know, which leads to incorrect assumptions and costly production incidents.

This book addresses that gap with a concept-first, implementation-aware explanation of database internals, emphasizing how behavior emerges from design choices. It helps developers reason confidently about databases in today’s multi-database, cloud-native, distributed world—without requiring them to become database engine experts.

3. Tell us about the book you plan to write.
Describe 3-5 tasks that the reader be able to do after reading this book.  

After reading this book, readers will be able to reason about database behavior before writing or running code, rather than reacting to production issues after the fact. Key outcomes include:

Predict query performance characteristics before running them by reasoning about access paths and execution plans
Diagnose plan regressions and concurrency issues without relying on trial-and-error tuning
Choose isolation levels, replication modes, and scaling strategies that match business invariants
Select between relational, document, or distributed SQL models based on internal trade-offs rather than marketing claims


Are there any unique characteristics of the proposed book, such as a distinctive visual style, questions and exercises, supplementary online materials like video, etc?

This book follows a Grokking-style approach, meaning:

Concept-first explanations: each topic starts with the core idea and intuition before introducing optimizations or product-specific details.
Diagrams before details: visual explanations show how data flows, how structures evolve, and how components interact.
Fewer topics, more depth: instead of covering every feature, the book focuses on the mechanisms that explain most real-world behavior.
Comparisons across engines: different database implementations are shown side by side to highlight trade-offs and design choices.
Visual explanations are a key strength of the book. Diagrams will illustrate, for example:

B-tree structure and page splits
LSM-tree compaction and read amplification
MVCC snapshots, visibility rules, and garbage collection
Query execution plans and operator pipelines
Locking vs. MVCC concurrency models
Write-ahead logging and crash recovery timelines
Replication flows, commit paths, and failover behavior
Sharding and distributed query execution

The goal is to help readers “see” how databases work, so they can form mental models that remain valid across products and versions.

4. Keywords
List some words or phrases a reader might use if searching for this book

database internals
query planner
B-tree
LSM tree
index
transaction
ACID
MVCC
SQL
distributed SQL
replication

5. Tell us about your readers. 
What skills do you expect the reader to already have? Be specific

Readers should be able to use databases:
Comfortable writing SQL queries (SELECT, JOIN, WHERE, basic indexing concepts)
Familiar with relational database concepts (tables, rows, primary keys)
Experience working with databases in production systems

What are the typical job roles for the primary reader? 

Backend engineers
Application developers
Full‑stack engineers (DevOps)
Site reliability engineers (SREs) working with databases on premises or with cloud-managed services
Senior software engineers responsible for performance and data consistency
Architects in charge of choosing the right database for their needs

In short, readers don’t have time to explore all the internals of the databases they use, yet they also can’t simply ignore them and treat the database as a black box.

6. Tell us about the competition and the ecosystem.
What are the best books available on this topic and how does the proposed book compare to them?

While several existing books explain database theory or distributed systems, few focus on helping everyday developers predict real-world database behavior across engines without requiring a deep academic background or source code study.

Database Internals by Alex Petrov: Comprehensive but academic and not developer‑friendly
Designing Data-Intensive Applications by Martin Kleppmann: Excellent for distributed systems, but less focused on relational database internals and execution details
PostgreSQL 14 Internals by Egor Rogov: Very useful but product‑specific.
SQL Performance Explained, by Markus Winand, offers a developer-focused exploration of multi-database topics and includes illustrations, but narrows its scope to SQL operations and indexing, without going into the details of storage internals and replication that impact performance.

What are the best videos available on this topic, and how does the proposed book compare to them?

CMU database courses: High quality, but academic and too long for non-database experts
Ben Dickens channel: Great visualization, but on isolated topics

What other resources would you recommend to someone wanting to learn this subject?

Official documentation of PostgreSQL, MySQL, and Oracle
SIGMOD VLDB papers to understand in-depth theory and details

What are the most important websites and companies?

PostgreSQL, MySQL, Oracle, SQL Server
AWS, Google Cloud, Azure database services

This book occupies a distinct space: a developer-focused, visually driven, implementation-aware guide to database internals, designed to help practitioners reason about real systems rather than study databases as an academic discipline or a single product.

7. Book size and illustrations

Approximate number of published pages: 250–300 pages
Approximate number of diagrams and graphics: 120–160
Approximate number of code listings: 40–60 (mostly SQL and pseudo‑code)

8. Contact information
Full Name, as it would appear on a contract: Franck Pachot
Name you would want on the book cover: Franck Pachot
Mailing Address: Rue des Fossés-Dessous 27, 1170 Aubonne, Switzerland
Preferred email: mail@pachot.net
Preferred phone: +41765107133
Website/blog: https://dev.to/franckpachot 
Twitter, etc: @FranckPachot, LinkedIn

9. Schedule
•	Most authors require 2-4 weeks to write each chapter. Please estimate your writing schedule

Chapter 1: 1 month
1/3 manuscript: 4–5 months
2/3 manuscript: 8–9 months
3/3 manuscript: 12 months

•	Are there any critical deadlines for the completion of this book? New software versions? Known competition? Technical conferences?

No strict dependency on software versions, as it is about database concepts

10. Table of Contents

A database is used to store, process, and share data, and to be resilient, and we structure chapters around those four pillars. The progression is: Storage -> Access paths -> Planning -> Execution -> Concurrency -> Transactions -> Replication -> Scaling.

Part I - Introduction
Why Database Internals Matter
Databases as Black Boxes		
1.1.1. Abstraction layers in database systems [data independence]
1.1.2. What application developers see [ORM, SQL, logical model]
1.1.3. What database engines actually do [execution plan, physical model]
When Things Go Wrong
1.2.1. Performance surprises [predictability, scalability]
1.2.2. Concurrency anomalies [race conditions]
1.2.3. Production incidents and operations [failures, upgrades]
Building Mental Models
1.3.1. Different implementations, shared concepts [ARIES]
1.3.2. Forty years of database ideas [storage, virtualization]
1.3.3. Software development evolution [monolithic, microservices]
Summary [Thinking in mechanisms, not products]
Part II - Data storage
How Databases Store Data
Pages, Blocks, and Files: Why Everything Is a Page
2.1.1. Disk, memory, and the page abstraction [shared buffers, metadata]
2.1.2. In‑place updates vs copy‑on‑write [fragmentation, block size]
2.1.3. Thinking like a filesystem [durability, log, reordering, cache, encryption]
Rows, Records, and Columns: How Data Really Lives on Disk
2.2.1. Normalization and physical storage [data independence]
2.2.2. Row‑oriented vs column‑oriented layouts [OLTP vs OLAP]
2.2.3. Documents, tuples, and rows [schema, catalog]
Heap Tables and Indexes: What Organizes the Data?
2.3.1. Heap organization and row identifiers [Db2, PostgreSQL, Oracle]
2.3.2. Index-organized [MySQL InnoDB, SQL Server]
2.3.3. Primary and secondary indexes [primary keys, hash, and sort]
Summary [intro to access paths]
Data Access Paths
Why Indexes Exist
3.1.1. Filtering rows efficiently [point queries, range queries]
3.1.2. Supporting ordering and grouping [pagination, unique constraints]
3.1.3. Avoiding full table scans [scalability]
Index Types
3.2.1. indexing trade-offs [read, write, and storage amplification]
3.2.2. B-trees and page splits [B+Tree, WiredTiger]
3.2.3. LSM trees and compaction [RocksDB]
Caching is everywhere
3.1.1. OS cache and DB cache [random and sequential reads]
3.1.2. Caching algorithms [LRU]
3.1.3. Shared and private memory [shared buffers, workarea memory]
The access path mental model
3.3.1. Cardinality and data distribution [index keys, rows, correlation factor]
3.3.2. Cost estimation fundamentals [how statistics are collected, sampling, histograms, correlation]
3.3.3. Introducing the query planner [compound indexes vs multiple indexes]
Summary [and this is for a single table, no joins yet]
Part III - Data Processing
From Queries to Query Plan
Application queries
4.1.1. Domain model, records, or objects [key-value get/put or aggregates]
4.1.2. Object-Relational Mapper [identity, eager and lazy fetching,]
4.1.3. SQL [multi-statement tx, multi-table joins, normalization, analytics, nulls]
Parsing and planning
4.2.1. Query API [protocol, bind variables, stored procedures]
4.2.2. Parsing and rewriting [syntax, semantics, and security check, transformations]
4.2.3. Optimization [indexes, join order, pushdowns]
Plan Stability and Changes
4.3.1. Why plans change over time [parameters, how stats become stale, out-of bound]
4.3.2. Plan caching, adaptive plans [multi-planner, plan cache, reoptimizations]
4.3.3. Hints, plan fixing, and abstraction trade‑offs [storing plans, avoiding joins]
Summary [spending time before execution to make execution faster]
Query Execution
How Queries Actually Run
5.1.1. Iterator models [volcano, explain plan]
5.1.2. Scans and Filters [multi-block, cache, prefetching, push-downs, offloading]
5.1.3. Blocking operations [hash, sort, distinct, spill to disk]
Join Methods
5.2.1. Join Types [cartesian, inner, outer joins, semi joins anti-joins]
5.2.2. Nested Loops [with index, memoize, batched]
5.2.3. Hash and Merge Joins [costing challenges, adaptive joins]
Making Queries Faster Without Changing SQL
5.3.1. Modern execution trends [SIMD, JIT]
5.3.2. Write optimizations [delayed garbage collection, upsert, foreign keys]
5.3.3. Read optimizations [offloading, parallel query]
Summary [many threads execute concurrently]
Part IV - Data Sharing
Concurrency Control 
When Transactions Collide
6.1.1. locks [latches per call, transaction locks, S, X]
6.1.2. fail on conflict [detection, transparent rewrites, retry logic]
6.1.3. wait on conflict [enqueues, wait queues, escalation, deadlocks, and lock levels/mode]
Multi-Version Concurrency Control
6.2.1. non-blocking reads [read snapshots]
6.2.2. read time vs commit time [visibility rules]
6.2.3. uncommitted changes [provisional records, in-memory, on disk]
MVCC garbage collection
6.3.1. out-of-place undo like Oracle, MySQL [but difference on indexes]
6.3.2. in-place dead tuples like postgres [dead tuples, vacuum, index bloat]
6.3.3. other trade-offs [in LSM-tree compaction, No-Steal]
Summary [lead to different anomalies than what SQL defined]
ACID transactions, 
Transactions
7.1.1. atomicity [implicit , explicit, auto-commit]
7.1.2. consistency [foreign keys, assertions]
7.1.3. domain-driven aggregates [transaction boundaries, invariants, business logic]
Isolation levels
7.2.1. SQL-92 [phenomena and anomalies]
7.2.2. MVCC [more anomalies, RC in PostgreSQL without restart, write skew in Oracle serializable]
7.2.3. explicit locking  [select for update]
Durability
7.3.1. WAL [physical, crash recovery, before or after visibility]
7.3.2. persistent storage [direct io, double write, double buffering]
7.3.3. backups [snapshots, incremental, point-in-time reccovery]
Summary [durability with replication, 2PC]

Part V - Data Resilience
Replication
Why Replicate
8.1.1. High availability [standby in recovery mode, power loss during commit, failover while keeping transaction order]
8.1.2. Read scalability [use standby as read replica, limitations of it when not sharding]
8.1.3. Disaster recovery [resilience vs disaster recovery, RPO, RPO -> crash timelines]
Replication Models
8.2.1. Physical vs logical replication [Storage, WAL, binlog, DDL, upgrades]
8.2.2. Synchronous vs asynchronous replication [wait on commit]
8.2.3. Leader‑based and multi‑leader models [Raft]
Lag and Consistency
8.3.1. Replication factor [availability and performance, RF5, RF3]
8.3.2. The case of two data centers [challenges, arbitrers/observers]
8.3.3. Trade‑offs [read and write concerns, 2-way replication]
Summary [read replicas limitation and need to shard]
Scaling Databases
Vertical vs Horizontal Scaling
9.1.1. Scaling up limitations [limits, availability]
9.1.2. Latency vs. throughput [scale up vs speed up]
9.1.3. What to distribute [storage layer, transaction layer, query layer]
Sharding Concepts
9.2.1. Data partitioning strategies [range, hash]
9.2.2. Challenges in SQL [global indexes, foreign keys]
9.2.3. Data modeling solutions [broadcast, duplicate, denormalize]
Why Scaling Is Always a Compromise
9.3.1. Optimizations for OLTP [cross-shard transactions]
9.3.2. Optimization for Analytics [scatter-gather]
9.3.3. Infrastructure challenges [atomic clocks, lamport logical time]
Summary [current solutions - Distributed SQL, New SQL, Application based]
Part VI - Conclusion
What Developers Must Remember
Database choice		
10.1.1. On-premises vs cloud  [and open source vs. black box]
10.1.2. General purpose or purpose-build [and built-in or extensions]
10.1.3. Current solutions [list and classify database services]
Data modeling
10.2.1. Database-first or Application first [domain-driven design, or business logic in DB]
10.2.2. Indexing and access paths [compound indexes]
10.2.3. Data locality [partitioning, sharding, document, denormalization]
Query optimization
10.3.1.  Reduce roundtrips [cost of network, and context switch]
10.3.2.  Where busines logic lives [in application or in database - stored procedure]
10.3.3.   Monitoring [what is a good measure for performance]
Summary [continuous learning]







