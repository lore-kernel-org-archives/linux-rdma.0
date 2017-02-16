From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 02/14] Provide new names for the CPU barriers related to DMA
Date: Thu, 16 Feb 2017 12:22:57 -0700
Message-ID: <1487272989-8215-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Broadly speaking, providers are not using the existing macros
consistently and the existing macros are very poorly defined.

Due to this poor definition we struggled to implement a sensible
barrier for ARM64 and just went with the strongest barriers instead.

Split wmb/wmb_wc into several cases:
 udma_to_device_barrier - Think dma_map(TO_DEVICE) in kernel terms
 udma_ordering_write_barrier - Weaker than wmb() in the kernel
 mmio_flush_writes - Special to help work with WC memory
 mmio_wc_start - Special to help work with WC memory
 mmio_ordered_writes_hack - Stand in for lack an ordered writel()

rmb becomes:
 udma_from_device_barrier - Think dmap_unamp(FROM_DEVICE) in kernel terms

The split forces provider authors to think about what they are doing more
carefully and the comments provide a solid explanation for when the barrier
is actually supposed to be used and when to use it with the common idioms
all drivers seem to have.

NOTE: do not assume that the existing asm optimally implements the defined
semantics. The required semantics were derived primarily from what the
existing providers do.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 util/udma_barrier.h | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 57ab0f76cbe33e..f9b8291db20210 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -122,4 +122,111 @@
 
 #endif
 
+/* Barriers for DMA.
+
+   These barriers are expliclty only for use with user DMA operations. If you
+   are looking for barriers to use with cache-coherent multi-threaded
+   consitency then look in stdatomic.h. If you need both kinds of synchronicity
+   for the same address then use an atomic operation followed by one
+   of these barriers.
+
+   When reasoning about these barriers there are two objects:
+     - CPU attached address space (the CPU memory could be a range of things:
+       cached/uncached/non-temporal CPU DRAM, uncached MMIO space in another
+       device, pMEM). Generally speaking the ordering is only relative
+       to the local CPU's view of the system. Eg if the local CPU
+       is not guarenteed to see a write from another CPU then it is also
+       OK for the DMA device to also not see the write after the barrier.
+     - A DMA initiator on a bus. For instance a PCI-E device issuing
+       MemRd/MemWr TLPs.
+
+   The ordering guarentee is always stated between those two streams. Eg what
+   happens if a MemRd TLP is sent in via PCI-E relative to a CPU WRITE to the
+   same memory location.
+*/
+
+/* Ensure that the device's view of memory matches the CPU's view of memory.
+   This should be placed before any MMIO store that could trigger the device
+   to begin doing DMA, such as a device doorbell ring.
+
+   eg
+    *dma_buf = 1;
+    udma_to_device_barrier();
+    mmio_write(DO_DMA_REG, dma_buf);
+   Must ensure that the device sees the '1'.
+
+   This is required to fence writes created by the libibverbs user. Those
+   writes could be to any CPU mapped memory object with any cachability mode.
+
+   NOTE: x86 has historically used a weaker semantic for this barrier, and
+   only fenced normal stores to normal memory. libibverbs users using other
+   memory types or non-temporal stores are required to use SFENCE in their own
+   code prior to calling verbs to start a DMA.
+*/
+#define udma_to_device_barrier() wmb()
+
+/* Ensure that all ordered stores from the device are observable from the
+   CPU. This only makes sense after something that observes an ordered store
+   from the device - eg by reading a MMIO register or seeing that CPU memory is
+   updated.
+
+   This guarentees that all reads that follow the barrier see the ordered
+   stores that preceded the observation.
+
+   For instance, this would be used after testing a valid bit in a memory
+   that is a DMA target, to ensure that the following reads see the
+   data written before the MemWr TLP that set the valid bit.
+*/
+#define udma_from_device_barrier() rmb()
+
+/* Order writes to CPU memory so that a DMA device cannot view writes after
+   the barrier without also seeing all writes before the barrier. This does
+   not guarentee any writes are visible to DMA.
+
+   This would be used in cases where a DMA buffer might have a valid bit and
+   data, this barrier is placed after writing the data but before writing the
+   valid bit to ensure the DMA device cannot observe a set valid bit with
+   unwritten data.
+
+   Compared to udma_to_device_barrier() this barrier is not required to fence
+   anything but normal stores to normal malloc memory. Usage should be:
+
+   write_wqe
+      udma_to_device_barrier();    // Get user memory ready for DMA
+      wqe->addr = ...;
+      wqe->flags = ...;
+      udma_ordering_write_barrier();  // Guarantee WQE written in order
+      wqe->valid = 1;
+*/
+#define udma_ordering_write_barrier() wmb()
+
+/* Promptly flush writes, possibly in a write buffer, to MMIO backed memory.
+   This is not required to have any effect on CPU memory. If done while
+   holding a lock then the ordering of MMIO writes across CPUs must be
+   guarenteed to follow the natural ordering implied by the lock.
+
+   This must also act as a barrier that prevents write combining, eg
+     *wc_mem = 1;
+     mmio_flush_writes();
+     *wc_mem = 2;
+   Must always produce two MemWr TLPs, the '2' cannot be combined with and
+   supress the '1'.
+
+   This is intended to be used in conjunction with write combining memory
+   to generate large PCI-E MemWr TLPs from the CPU.
+*/
+#define mmio_flush_writes() wc_wmb()
+
+/* Keep MMIO writes in order.
+   Currently we lack writel macros that universally guarentee MMIO
+   writes happen in order, like the kernel does. Even worse many
+   providers haphazardly open code writes to MMIO memory omitting even
+   volatile.
+
+   Until this can be fixed with a proper writel macro, this barrier
+   is a stand in to indicate places where MMIO writes should be switched
+   to some future writel.
+*/
+#define mmio_ordered_writes_hack() mmio_flush_writes()
+
 #endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
