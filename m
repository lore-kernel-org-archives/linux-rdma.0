From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 03/17] Update comment in cxbg* drivers
Date: Thu,  6 Oct 2016 14:51:29 -0600
Message-ID: <1475787103-13283-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The swap is correct on most arches we support, the note should be
to move this stuff to common code.

Fixes: 1df0888f6a73 ("Remove most checks of __BYTE_ORDER")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/src/cxio_wr.h | 3 +--
 libcxgb4/src/t4.h      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/libcxgb3/src/cxio_wr.h b/libcxgb3/src/cxio_wr.h
index e24c7fed7d76..e15479540598 100644
--- a/libcxgb3/src/cxio_wr.h
+++ b/libcxgb3/src/cxio_wr.h
@@ -50,8 +50,7 @@
 #define Q_COUNT(rptr,wptr) ((wptr)-(rptr))
 #define Q_PTR2IDX(ptr,size_log2) (ptr & ((1UL<<size_log2)-1))
 
-/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
-   probably wrong */
+/* FIXME: Move me to a generic PCI mmio accessor */
 #define cpu_to_pci32(val) htole32(val)
 
 #define RING_DOORBELL(doorbell, QPID) { \
diff --git a/libcxgb4/src/t4.h b/libcxgb4/src/t4.h
index 45de5e3a7f71..eda9a203295d 100644
--- a/libcxgb4/src/t4.h
+++ b/libcxgb4/src/t4.h
@@ -63,8 +63,7 @@
 #define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
-/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
-   probably wrong */
+/* FIXME: Move me to a generic PCI mmio accessor */
 #define cpu_to_pci32(val) htole32(val)
 
 #define writel(v, a) do { *((volatile u32 *)(a)) = cpu_to_pci32(v); } while (0)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
