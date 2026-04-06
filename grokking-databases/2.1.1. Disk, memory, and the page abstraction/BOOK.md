# Disk, Memory, and the Page Abstraction

## What is a Page?

A *page* (sometimes called a *block* or *extent*) is the basic unit of I/O that a storage engine reads from or writes to the underlying storage medium.  All modern relational databases allocate and manage data in fixed‑size pages because it aligns nicely with the operating system’s disk cache and reduces the number of system calls required to process large tables.

## The Page Abstraction Stack

```mermaid
graph TD
    subgraph "Application Layer"
        A[SQL Query] --> B[Tables/Indexes]
    end
    
    subgraph "Database Storage Engine"
        B --> C[Database Pages 8KB-64KB]
        C --> D[Buffer Pool Memory Cache]
    end
    
    subgraph "Operating System"
        D --> E[OS Page Cache 4KB]
        E --> F[Virtual Memory System]
    end
    
    subgraph "Hardware"
        F --> G[Disk Blocks 512B-4KB]
        G --> H[SSD/HDD Physical Sectors]
    end
    
    style C fill:#e1f5e1
    style E fill:#f0f8ff
    style G fill:#fff0f0
```

**Key Insight:** Database pages are typically larger than OS pages and disk blocks. This means:
- One database page = multiple OS pages
- One OS page = one or more disk blocks
- This hierarchical arrangement allows databases to manage their own caching (buffer pool) while still leveraging the OS page cache

## Database Page Anatomy

```mermaid
graph LR
    P[Database Page 8KB-16KB] --> H[Page Header 24-128 bytes]
    P --> RP[Row Pointers Array]
    P --> FS[Free Space]
    P --> D[Row Data]
    P --> T[Tuple Data]
    
    subgraph "Page Header Details"
        H1[LSN - Log Sequence Number]
        H2[Checksum]
        H3[Page Type]
        H4[Free Space Pointer]
        H5[Row Count]
    end
    
    subgraph "Row Data Layout"
        D1[Row Header]
        D2[Null Bitmap]
        D3[Column 1 Data<br/>VARCHAR(100)]
        D4[Column 2 Data<br/>INTEGER]
        D5[Column 3 Data<br/>TIMESTAMP]
    end
    
    H --> H1
    H --> H2
    H --> H3
    H --> H4
    H --> H5
    
    D --> D1
    D --> D2
    D --> D3
    D --> D4
    D --> D5
```

**Page Header:** Contains metadata about the page (when it was last modified, what type of page it is, how much free space remains).
**Row Pointers Array:** An array of offsets pointing to where each row starts within the page (allowing rows to be moved without updating all indexes).
**Free Space:** The gap between the row pointers and the actual row data that grows/shrinks as rows are inserted/deleted.
**Row Data:** The actual row content stored in the page.

## Default Page / Block Sizes in Popular Databases

| Database | Default Page / Block Size | Notes |
|----------|---------------------------|-------|
| **PostgreSQL** | 8 KB (configurable at initdb with `-D` and `-B`) | Fixed size; larger pages can be set at cluster creation time.
| **MySQL (InnoDB)** | 16 KB (configurable via `innodb_page_size` up to 64 KB) | Must be set before the tablespace is created.
| **Oracle** | 8 KB (default) – can be 2 KB, 4 KB, 8 KB, 16 KB, or 32 KB | Chosen per tablespace at creation.
| **SQL Server** | 8 KB (fixed for data pages) | Index and row‑overflow pages are also 8 KB; large rows spill to *LOB* pages.
| **SQLite** | 4 KB (default) – configurable with `PRAGMA page_size` | Page size must be a power of two between 512 B and 65536 B.
| **MongoDB** | Variable – *records are stored in *extents* that start at 64 KB and grow geometrically* | MongoDB does not use a fixed page size; instead it allocates extents that double in size until a configured limit. |

### Page Size Comparisons

```mermaid
graph LR
    subgraph "Fixed-Size Pages (Relational DBs)"
        A1[PostgreSQL<br/>8KB]
        A2[MySQL<br/>16KB]
        A3[SQL Server<br/>8KB]
    end
    
    subgraph "Variable-Size Extents (MongoDB)"
        B1[Small Collection<br/>64KB extent]
        B2[Medium Collection<br/>128KB extent]
        B3[Large Collection<br/>256KB+ extent]
    end
    
    subgraph "Configurable Sizes"
        C1[Oracle<br/>2-32KB tablespace]
        C2[SQLite<br/>512B-64KB]
    end
    
    A1 -->|Standard I/O Unit| IO[Database I/O]
    A2 --> IO
    A3 --> IO
    
    B1 -->|Adaptive Growth| AD[Auto-scaling]
    B2 --> AD
    B3 --> AD
    
    C1 -->|Per-tablespace| TC[Tablespace Config]
    C2 -->|Database-wide| PF[PRAGMA setting]
```

### Why the Defaults Matter

* **I/O Efficiency** – Larger pages reduce the number of reads/writes for sequential scans but can increase waste for small lookups.
* **Memory Footprint** – The buffer pool holds a number of pages; the total memory usage is `page_size × number_of_cached_pages`.
* **Concurrency & Locking** – Some engines lock at the page level; larger pages can increase contention.
* **Fragmentation** – Fixed‑size pages can lead to internal fragmentation when rows do not exactly fill the page.

## Memory vs. Disk: The Buffer Pool

```mermaid
graph TB
    subgraph "Buffer Pool (Memory)"
        BP[Buffer Pool Manager]
        
        subgraph "LRU List"
            LRU1[Hot Page 1]
            LRU2[Hot Page 2]
            LRU3[...]
            LRU4[Warm Page N-1]
            LRU5[Cold Page N]
        end
        
        subgraph "Free List"
            FL1[Free Page]
            FL2[Free Page]
            FL3[...]
        end
        
        subgraph "Dirty Pages"
            DP1[Modified Page]
            DP2[Modified Page]
            DP3[...]
        end
    end
    
    subgraph "Working Memory"
        WM1[Query Working Memory]
        WM2[Sort Memory]
        WM3[Hash Join Memory]
    end
    
    subgraph "Disk"
        DISK1[Data File .ibd/.mdf]
        DISK2[Index File]
        DISK3[Transaction Log]
    end
    
    BP --> LRU1
    BP --> FL1
    BP --> DP1
    
    LRU5 -.->|Eviction| FL1
    DISK1 -->|Page Read| FL1
    FL1 -->|Page Load| LRU1
    LRU1 -->|Modification| DP1
    DP1 -->|Checkpoint/Background Write| DISK1
    
    WM1 --> BP
    WM2 --> BP
    WM3 --> BP
```

**The Buffer Pool Lifecycle:**
1. Page requested by query
2. If in buffer pool (cache hit), use immediately
3. If not in buffer pool (cache miss), read from disk into free page
4. Page becomes "hot" (frequently accessed) and moves to LRU head
5. Page becomes "cold" (infrequently accessed) and moves to LRU tail
6. When buffer pool is full, cold pages are evicted
7. Modified (dirty) pages are written to disk during checkpoints

## MongoDB’s Variable‑Size Extents

MongoDB’s storage engine (WiredTiger) does not adhere to a single, fixed block size. Instead, it allocates *extents* that start at 64 KB and then grow roughly by a factor of 2 (128 KB, 256 KB, …) until they hit a configurable maximum (default 2 GB). This design:

```mermaid
graph TD
    subgraph "WiredTiger Extent Management"
        C1[Small Collection<br/>Few documents] --> E1[64KB Extent]
        E1 -->|Grows 50% full| E2[128KB Extent]
        E2 -->|Grows 50% full| E3[256KB Extent]
        E3 -->|...| E4[...]
        
        C2[Large Collection<br/>Many documents] --> L1[Multiple Large Extents]
        L1 --> LM[Extent Manager]
        
        LM --> A1[Allocation Strategy]
        LM --> GC[Garbage Collection]
        LM --> CP[Compaction]
    end
    
    subgraph "Traditional Fixed Pages"
        FP1[8KB Page]
        FP2[8KB Page]
        FP3[8KB Page]
        FP4[8KB Page]
        FP5[8KB Page]
        FP6[8KB Page]
        FP7[8KB Page]
        FP8[8KB Page]
        
        FP1 & FP2 & FP3 & FP4 & FP5 & FP6 & FP7 & FP8 --> TS[Tablespace File]
    end
    
    style E1 fill:#e1f5e1
    style E2 fill:#f0f8ff
    style E3 fill:#f5f0e1
```

1. **Adapts to Workload** – Small collections start with tiny extents, conserving disk space. Large collections automatically acquire larger extents, reducing metadata overhead.
2. **Reduces Allocation Overhead** – Growing extents avoid the need to frequently allocate many tiny blocks.
3. **Impacts Vacuum / Compaction** – Because extents can be variably sized, compaction may need to rewrite entire extents rather than individual pages.

When comparing MongoDB to relational databases, keep in mind that its *block* concept is more fluid. For performance‑tuning discussions, you’ll often talk about *WiredTiger cache size* (default 50 % of RAM) rather than a page size.

## Practical Takeaways

* For relational DBMSs, the default page size is a key tuning knob that influences I/O patterns, memory usage, and lock granularity.
* In MongoDB, the emphasis shifts to extent management and cache configuration rather than a static page size.
* When designing a schema or indexing strategy, always consider how many pages a typical row or document will occupy and whether that fits the engine’s default block size.

## Performance Implications

| Operation | Small Pages (4KB) | Large Pages (16KB+) |
|-----------|-------------------|---------------------|
| **Random Lookup** | More I/O operations for same data | Fewer I/O ops, but may read unused data |
| **Sequential Scan** | Many small reads | Fewer larger reads, more efficient |
| **Memory Cache** | More pages fit in same memory | Fewer pages fit, but each has more data |
| **Write Amplification** | Lower (write less data) | Higher (write more data per update) |
| **Concurrency** | Fine-grained locking | Coarse-grained locking, more contention |

**Rule of Thumb:** OLTP workloads (many small random reads) may benefit from smaller pages. OLAP/workloads (large sequential scans) often benefit from larger pages.

---

*This section provides a quick reference for developers who need to reason about storage layout across different database families.*
