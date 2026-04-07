# WORKING.md

## Purpose

Track ongoing editing progress for the *Grokking Database Internals* book. This file records what was improved, what remains, and any notes on upcoming work.

## Process

- **Hourly review**: Every hour I will glance at the existing chapter content, pick one chapter that can benefit from an improvement, and make edits.
- **Log entry**: After each edit I append a brief log entry here, noting the chapter, what was changed, and any follow‑up tasks.
- **To‑Do list**: Keep a running list of chapters that still need work.

## Log

*2026-04-05 16:55 UTC* – Created WORKING.md and outlined the hourly‑review process.

*2026-04-05 21:32 UTC* – Enhanced `1.1.1. Abstraction layers in database systems`:
  - Added detailed layer-by-layer examples with tables showing actions at each level
  - Included three comprehensive examples (simple query, transaction isolation, N+1 problem)
  - Added "Common Problems at Each Layer" section covering application to hardware issues
  - Added "Practical Developer Advice" section with diagnostic techniques
  - Included a real-world e-commerce checkout scenario

*2026-04-05 21:37 UTC* – Added comprehensive diagrams to `2.1.1. Disk, memory, and the page abstraction`:
  - Added Mermaid diagram showing page abstraction stack
  - Added page anatomy diagram showing header, row pointers, free space, data layout
  - Added comparison diagram of fixed-size vs variable-size extents
  - Added buffer pool lifecycle with LRU lists, free lists, dirty pages
  - Added MongoDB extent management visualization
  - Added performance implications table comparing small vs large pages
  - Enhanced with buffer pool management details and practical tuning advice

*2026-04-05 21:42 UTC* – Created full content for `4.3.2. Plan caching, adaptive plans`:
  - Added diagram showing plan caching workflow with cache hits/misses
  - Included comprehensive table comparing plan caching across databases
  - Explained parameter sniffing problem with visual examples
  - Covered adaptive query processing techniques
  - Added database-specific adaptive features comparison table
  - Included plan cache management strategies with eviction policies
  - Provided real-world examples (e-commerce search, multi-tenant SaaS)
  - Added performance implications and best practices sections
  - Discussed future trends with machine learning optimizers

*2026-04-06 07:47 UTC* – Created comprehensive content for `4.3.3. Hints, plan fixing, and abstraction trade‑offs`:
  - Added "optimization dilemma" diagram showing intervention options
  - Included detailed comparison of query hints across databases (Oracle, SQL Server, PostgreSQL, MySQL)
  - Covered plan fixing techniques: stored outlines, plan guides, SQL Plan Management
  - Explained denormalization strategies to avoid joins (materialized views, pre-joined tables, flattened documents)
  - Created "Abstraction Trade‑off Pyramid" showing intervention levels
  - Added three real-world case studies with solutions and trade‑offs
  - Included best practices and anti‑patterns for plan intervention
  - Discussed future AI‑driven optimization trends
  - Added summary table matching problems to appropriate solutions

*2026-04-06 09:51 UTC* – Created comprehensive content for `1.1.2. What application developers see`:
  - Added diagram showing developer's view vs hidden database layers
  - Covered three primary interfaces: ORM, SQL, and API/driver level
  - Explained logical data model vs physical storage with comparison diagram
  - Detailed common developer-facing features (schema definition, transactions, views)
  - Explained the N+1 query problem with practical solutions
  - Identified visible performance bottlenecks (query time, connection pool, lock contention)
  - Listed tools developers use to peek underneath (EXPLAIN, profiling, ORM debugging)
  - Provided real-world cases of abstraction leaks with solutions
  - Added best practices for working at the application layer
  - Discussed developer responsibilities in database optimization

*2026-04-07 07:16 UTC* – Created comprehensive content for `1.1.3. What database engines actually do`:
  - Added diagram showing complete journey from SQL to disk I/O
  - Covered buffer pool memory management and optimization strategies
  - Detailed storage layers, concurrency control, and WAL mechanics
  - Explained MVCC under the hood with vacuum operations
  - Covered index structures (B+ tree, LSM-tree, GIN, BRIN) with practical examples
  - Provided real-world performance patterns and solutions for production scenarios
  - Compared different storage engines (InnoDB, PostgreSQL, LSM implementations)
  - Included crash recovery mechanics and checkpoint optimization
  - Added practical SQL examples and monitoring techniques
  - Completed foundational Part I series on database abstraction layers

## To‑Do

- ~~Review and polish `1.1.1. Abstraction layers in database systems` (add more examples).~~ ✓ **Done**
- ~~Add diagrams to `2.1.1. Disk, memory, and the page abstraction`.~~ ✓ **Done**
- ~~Refine wording in `4.3.2. Plan caching, adaptive plans`.~~ ✓ **Done** (created full content)
- ~~Review and polish `4.3.3. Hints, plan fixing, and abstraction trade‑offs`.~~ ✓ **Done** (created full content)
- ~~Add content to one of the empty chapters from Part I.~~ ✓ **Done** (created 1.1.2 & 1.1.3)
- Verify consistency of numbering across all chapters.
- Create cross-reference between chapters (e.g., link from page abstraction to buffer pool discussions in later chapters).
- Continue with Chapter 5.1.1. Iterator models (next section: Query Execution).
- Work on Chapter 1.2.1. Performance surprises (next in Part I, Section 2).
