From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/5] Add mmio_memcpy_x64
Date: Thu, 13 Apr 2017 16:38:47 -0600
Message-ID: <1492123127-6266-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492123127-6266-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This pattern is common in a couple of drivers, and needs the s390
syscall.

The common version properly handles 32 bit and prevents reordering of
the stores, which is the stated reason for this to exist. It is also
slightly more optimized, since it assumes a non-zero transfer length.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/mmio.h | 43 -----------------------------------------
 providers/mlx4/qp.c   |  5 ++---
 providers/mlx5/qp.c   | 17 ++++++-----------
 util/mmio.h           | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 60 insertions(+), 58 deletions(-)
 delete mode 100644 providers/mlx4/mmio.h

diff --git a/providers/mlx4/mmio.h b/providers/mlx4/mmio.h
deleted file mode 100644
index 9821e85224dcfd..00000000000000
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 423f59533de68d..e7f10b9f1524d5 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -43,7 +43,6 @@
 
 #include "mlx4.h"
 #include "wqe.h"
-#include "mmio.h"
 
 static const uint32_t mlx4_ib_opcode[] = {
 	[IBV_WR_SEND]			= MLX4_OPCODE_SEND,
@@ -481,8 +480,8 @@ out:
 		 */
 		mmio_wc_spinlock(&ctx->bf_lock);
 
-		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
-			     align(size * 16, 64));
+		mmio_memcpy_x64(ctx->bf_page + ctx->bf_offset, ctrl,
+				align(size * 16, 64));
 		/* Flush before toggling bf_offset to be latency oriented */
 		mmio_flush_writes();
 
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index 7f67a0b61b221f..c4789bf0d909a4 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -239,19 +239,14 @@ static void set_data_ptr_seg_atomic(struct mlx5_wqe_data_seg *dseg,
 static void mlx5_bf_copy(unsigned long long *dst, unsigned long long *src,
 			 unsigned bytecnt, struct mlx5_qp *qp)
 {
-	while (bytecnt > 0) {
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		*dst++ = *src++;
-		bytecnt -= 8 * sizeof(unsigned long long);
+	do {
+		mmio_memcpy_x64(dst, src, 64);
+		bytecnt -= 64;
+		dst += 8;
+		src += 8;
 		if (unlikely(src == qp->sq.qend))
 			src = qp->sq_start;
-	}
+	} while (bytecnt > 0);
 }
 
 static uint32_t send_ieth(struct ibv_send_wr *wr)
diff --git a/util/mmio.h b/util/mmio.h
index 0b89f5fcbe000e..1d45d6d6364d4e 100644
--- a/util/mmio.h
+++ b/util/mmio.h
@@ -56,6 +56,7 @@
 #include <linux/types.h>
 #include <stdatomic.h>
 #include <stdint.h>
+#include <stddef.h>
 #include <endian.h>
 
 #include <config.h>
@@ -158,7 +159,6 @@ static inline uint8_t mmio_read8(const void *addr)
 	return atomic_load_explicit((_Atomic(uint32_t) *)addr,
 				    memory_order_relaxed);
 }
-
 #endif /* __s390x__ */
 
 MAKE_WRITE(mmio_write16, 16)
@@ -200,6 +200,57 @@ __le64 mmio_read64_le(const void *addr);
 		return le##_SZ_##toh(_NAME_##_le(addr));                       \
 	}
 
+/* This strictly guarantees the order of TLP generation for the memory copy to
+   be in ascending address order.
+*/
+#ifdef __s390x__
+static inline void mmio_memcpy_x64(void *dest, const void *src, size_t bytecnt)
+{
+	s390_mmio_write(addr, src, bytecnt);
+}
+#else
+
+/* Transfer is some multiple of 64 bytes */
+static inline void mmio_memcpy_x64(void *dest, const void *src, size_t bytecnt)
+{
+	uintptr_t *dst_p = dest;
+
+	/* Caller must guarantee:
+	    assert(bytecnt != 0);
+	    assert((bytecnt % 64) == 0);
+	    assert(((uintptr_t)dest) % __alignof__(*dst) == 0);
+	    assert(((uintptr_t)src) % __alignof__(*dst) == 0);
+	*/
+
+	/* Use the native word size for the copy */
+	if (sizeof(*dst_p) == 8) {
+		const __be64 *src_p = src;
+
+		do {
+			/* Do 64 bytes at a time */
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+			mmio_write64_be(dst_p++, *src_p++);
+
+			bytecnt -= 8 * sizeof(*dst_p);
+		} while (bytecnt > 0);
+	} else if (sizeof(*dst_p) == 4) {
+		const __be32 *src_p = src;
+
+		do {
+			mmio_write32_be(dst_p++, *src_p++);
+			mmio_write32_be(dst_p++, *src_p++);
+			bytecnt -= 2 * sizeof(*dst_p);
+		} while (bytecnt > 0);
+	}
+}
+#endif
+
 MAKE_WRITE(mmio_write16, 16)
 MAKE_WRITE(mmio_write32, 32)
 MAKE_WRITE(mmio_write64, 64)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
