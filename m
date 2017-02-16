From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 14/14] Remove the old barrier macros
Date: Thu, 16 Feb 2017 12:23:09 -0700
Message-ID: <1487272989-8215-15-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Inline the required assembly directly into the new names. No change to
the asm.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 util/udma_barrier.h | 195 +++++++++++++++++++++++++---------------------------
 1 file changed, 94 insertions(+), 101 deletions(-)

diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index f9b8291db20210..cc2718f33fc3a2 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -33,95 +33,6 @@
 #ifndef __UTIL_UDMA_BARRIER_H
 #define __UTIL_UDMA_BARRIER_H
 
-/*
- * Architecture-specific defines.  Currently, an architecture is
- * required to implement the following operations:
- *
- * mb() - memory barrier.  No loads or stores may be reordered across
- *     this macro by either the compiler or the CPU.
- * rmb() - read memory barrier.  No loads may be reordered across this
- *     macro by either the compiler or the CPU.
- * wmb() - write memory barrier.  No stores may be reordered across
- *     this macro by either the compiler or the CPU.
- * wc_wmb() - flush write combine buffers.  No write-combined writes
- *     will be reordered across this macro by either the compiler or
- *     the CPU.
- */
-
-#if defined(__i386__)
-
-#define mb()	 asm volatile("lock; addl $0,0(%%esp) " ::: "memory")
-#define rmb()	 mb()
-#define wmb()	 asm volatile("" ::: "memory")
-#define wc_wmb() mb()
-
-#elif defined(__x86_64__)
-
-/*
- * Only use lfence for mb() and rmb() because we don't care about
- * ordering against non-temporal stores (for now at least).
- */
-#define mb()	 asm volatile("lfence" ::: "memory")
-#define rmb()	 mb()
-#define wmb()	 asm volatile("" ::: "memory")
-#define wc_wmb() asm volatile("sfence" ::: "memory")
-
-#elif defined(__PPC64__)
-
-#define mb()	 asm volatile("sync" ::: "memory")
-#define rmb()	 asm volatile("lwsync" ::: "memory")
-#define wmb()	 mb()
-#define wc_wmb() wmb()
-
-#elif defined(__ia64__)
-
-#define mb()	 asm volatile("mf" ::: "memory")
-#define rmb()	 mb()
-#define wmb()	 mb()
-#define wc_wmb() asm volatile("fwb" ::: "memory")
-
-#elif defined(__PPC__)
-
-#define mb()	 asm volatile("sync" ::: "memory")
-#define rmb()	 mb()
-#define wmb()	 mb()
-#define wc_wmb() wmb()
-
-#elif defined(__sparc_v9__)
-
-#define mb()	 asm volatile("membar #LoadLoad | #LoadStore | #StoreStore | #StoreLoad" ::: "memory")
-#define rmb()	 asm volatile("membar #LoadLoad" ::: "memory")
-#define wmb()	 asm volatile("membar #StoreStore" ::: "memory")
-#define wc_wmb() wmb()
-
-#elif defined(__sparc__)
-
-#define mb()	 asm volatile("" ::: "memory")
-#define rmb()	 mb()
-#define wmb()	 mb()
-#define wc_wmb() wmb()
-
-#elif defined(__s390x__)
-
-#define mb()	{ asm volatile("" : : : "memory"); }	/* for s390x */
-#define rmb()	mb()					/* for s390x */
-#define wmb()	mb()					/* for s390x */
-#define wc_wmb() wmb()					/* for s390x */
-
-#elif defined(__aarch64__)
-
-/* Perhaps dmb would be sufficient? Let us be conservative for now. */
-#define mb()	{ asm volatile("dsb sy" ::: "memory"); }
-#define rmb()	{ asm volatile("dsb ld" ::: "memory"); }
-#define wmb()	{ asm volatile("dsb st" ::: "memory"); }
-#define wc_wmb() wmb()
-
-#else
-
-#error No architecture specific memory barrier defines found!
-
-#endif
-
 /* Barriers for DMA.
 
    These barriers are expliclty only for use with user DMA operations. If you
@@ -143,6 +54,10 @@
    The ordering guarentee is always stated between those two streams. Eg what
    happens if a MemRd TLP is sent in via PCI-E relative to a CPU WRITE to the
    same memory location.
+
+   The providers have a very regular and predictable use of these barriers,
+   to make things very clear each narrow use is given a name and the proper
+   name should be used in the provider as a form of documentation.
 */
 
 /* Ensure that the device's view of memory matches the CPU's view of memory.
@@ -163,7 +78,25 @@
    memory types or non-temporal stores are required to use SFENCE in their own
    code prior to calling verbs to start a DMA.
 */
-#define udma_to_device_barrier() wmb()
+#if defined(__i386__)
+#define udma_to_device_barrier() asm volatile("" ::: "memory")
+#elif defined(__x86_64__)
+#define udma_to_device_barrier() asm volatile("" ::: "memory")
+#elif defined(__PPC64__)
+#define udma_to_device_barrier() asm volatile("sync" ::: "memory")
+#elif defined(__PPC__)
+#define udma_to_device_barrier() asm volatile("sync" ::: "memory")
+#elif defined(__ia64__)
+#define udma_to_device_barrier() asm volatile("mf" ::: "memory")
+#elif defined(__sparc_v9__)
+#define udma_to_device_barrier() asm volatile("membar #StoreStore" ::: "memory")
+#elif defined(__aarch64__)
+#define wmb() asm volatile("dsb st" ::: "memory");
+#elif defined(__sparc__) || defined(__s390x__)
+#define udma_to_device_barrier() asm volatile("" ::: "memory")
+#else
+#error No architecture specific memory barrier defines found!
+#endif
 
 /* Ensure that all ordered stores from the device are observable from the
    CPU. This only makes sense after something that observes an ordered store
@@ -177,7 +110,25 @@
    that is a DMA target, to ensure that the following reads see the
    data written before the MemWr TLP that set the valid bit.
 */
-#define udma_from_device_barrier() rmb()
+#if defined(__i386__)
+#define udma_from_device_barrier() asm volatile("lock; addl $0,0(%%esp) " ::: "memory")
+#elif defined(__x86_64__)
+#define udma_from_device_barrier() asm volatile("lfence" ::: "memory")
+#elif defined(__PPC64__)
+#define udma_from_device_barrier() asm volatile("lwsync" ::: "memory")
+#elif defined(__PPC__)
+#define udma_from_device_barrier() asm volatile("sync" ::: "memory")
+#elif defined(__ia64__)
+#define udma_from_device_barrier() asm volatile("mf" ::: "memory")
+#elif defined(__sparc_v9__)
+#define udma_from_device_barrier() asm volatile("membar #LoadLoad" ::: "memory")
+#elif defined(__aarch64__)
+#define udma_from_device_barrier() asm volatile("dsb ld" ::: "memory");
+#elif defined(__sparc__) || defined(__s390x__)
+#define udma_from_device_barrier() asm volatile("" ::: "memory")
+#else
+#error No architecture specific memory barrier defines found!
+#endif
 
 /* Order writes to CPU memory so that a DMA device cannot view writes after
    the barrier without also seeing all writes before the barrier. This does
@@ -198,24 +149,66 @@
       udma_ordering_write_barrier();  // Guarantee WQE written in order
       wqe->valid = 1;
 */
-#define udma_ordering_write_barrier() wmb()
+#define udma_ordering_write_barrier() udma_to_device_barrier()
 
-/* Promptly flush writes, possibly in a write buffer, to MMIO backed memory.
-   This is not required to have any effect on CPU memory. If done while
-   holding a lock then the ordering of MMIO writes across CPUs must be
-   guarenteed to follow the natural ordering implied by the lock.
+/* Promptly flush writes to MMIO Write Cominbing memory.
+   This should be used after a write to WC memory. This is both a barrier
+   and a hint to the CPU to flush any buffers to reduce latency to TLP
+   generation.
+
+   This is not required to have any effect on CPU memory.
+
+   If done while holding a lock then the ordering of MMIO writes across CPUs
+   must be guarenteed to follow the natural ordering implied by the lock.
 
    This must also act as a barrier that prevents write combining, eg
      *wc_mem = 1;
      mmio_flush_writes();
      *wc_mem = 2;
-   Must always produce two MemWr TLPs, the '2' cannot be combined with and
-   supress the '1'.
+   Must always produce two MemWr TLPs, '1' and '2'. Without the barrier
+   the CPU is allowed to produce a single TLP '2'.
+
+   Note that there is no order guarentee for writes to WC memory without
+   barriers.
+
+   This is intended to be used in conjunction with WC memory to generate large
+   PCI-E MemWr TLPs from the CPU.
+*/
+#if defined(__i386__)
+#define mmio_flush_writes() asm volatile("lock; addl $0,0(%%esp) " ::: "memory")
+#elif defined(__x86_64__)
+#define mmio_flush_writes() asm volatile("sfence" ::: "memory")
+#elif defined(__PPC64__)
+#define mmio_flush_writes() asm volatile("sync" ::: "memory")
+#elif defined(__PPC__)
+#define mmio_flush_writes() asm volatile("sync" ::: "memory")
+#elif defined(__ia64__)
+#define mmio_flush_writes() asm volatile("fwb" ::: "memory")
+#elif defined(__sparc_v9__)
+#define mmio_flush_writes() asm volatile("membar #StoreStore" ::: "memory")
+#elif defined(__aarch64__)
+#define mmio_flush_writes() asm volatile("dsb st" ::: "memory");
+#elif defined(__sparc__) || defined(__s390x__)
+#define mmio_flush_writes() asm volatile("" ::: "memory")
+#error No architecture specific memory barrier defines found!
+#endif
+
+/* Prevent WC writes from being re-ordered relative to other MMIO
+   writes. This should be used before a write to WC memory.
+
+   This must act as a barrier to prevent write re-ordering from different
+   memory types:
+     *mmio_mem = 1;
+     mmio_flush_writes();
+     *wc_mem = 2;
+   Must always produce a TLP '1' followed by '2'.
+
+   This barrier implies udma_to_device_barrier()
 
-   This is intended to be used in conjunction with write combining memory
-   to generate large PCI-E MemWr TLPs from the CPU.
+   This is intended to be used in conjunction with WC memory to generate large
+   PCI-E MemWr TLPs from the CPU.
 */
-#define mmio_flush_writes() wc_wmb()
+#define mmio_wc_start() mmio_flush_writes()
 
 /* Keep MMIO writes in order.
    Currently we lack writel macros that universally guarentee MMIO
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
