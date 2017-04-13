From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/5] mlx4: Use util/mmio.h
Date: Thu, 13 Apr 2017 16:38:44 -0600
Message-ID: <1492123127-6266-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492123127-6266-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove now duplicated mmio accessor macros.

This fixes a bug in mlx4_read_clock where a pointer was read twice without any
sort of barrier, resulting in mis-compilation. (eg the double read of clockhi
never worked)

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/cq.c       | 14 +++++----
 providers/mlx4/doorbell.h | 70 ---------------------------------------------
 providers/mlx4/mlx4.c     |  1 -
 providers/mlx4/mlx4.h     |  1 -
 providers/mlx4/mmio.h     | 73 -----------------------------------------------
 providers/mlx4/qp.c       |  7 +++--
 providers/mlx4/srq.c      |  1 -
 providers/mlx4/verbs.c    |  9 +++---
 8 files changed, 17 insertions(+), 159 deletions(-)
 delete mode 100644 providers/mlx4/doorbell.h

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index f0a47ae374a689..8ebc2aeaf941bf 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -40,10 +40,10 @@
 #include <string.h>
 
 #include <util/compiler.h>
+#include <util/mmio.h>
 #include <infiniband/opcode.h>
 
 #include "mlx4.h"
-#include "doorbell.h"
 
 enum {
 	MLX4_CQ_DOORBELL			= 0x20
@@ -682,7 +682,7 @@ void mlx4_cq_fill_pfns(struct mlx4_cq *cq, const struct ibv_cq_init_attr_ex *cq_
 int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx4_cq *cq = to_mcq(ibvcq);
-	uint32_t doorbell[2];
+	uint64_t doorbell;
 	uint32_t sn;
 	uint32_t ci;
 	uint32_t cmd;
@@ -691,6 +691,10 @@ int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	ci  = cq->cons_index & 0xffffff;
 	cmd = solicited ? MLX4_CQ_DB_REQ_NOT_SOL : MLX4_CQ_DB_REQ_NOT;
 
+	doorbell = sn << 28 | cmd | cq->cqn;
+	doorbell <<= 32;
+	doorbell |= ci;
+
 	*cq->arm_db = htobe32(sn << 28 | cmd | ci);
 
 	/*
@@ -699,10 +703,8 @@ int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 */
 	udma_to_device_barrier();
 
-	doorbell[0] = htobe32(sn << 28 | cmd | cq->cqn);
-	doorbell[1] = htobe32(ci);
-
-	mlx4_write64(doorbell, to_mctx(ibvcq->context), MLX4_CQ_DOORBELL);
+	mmio_write64_be(to_mctx(ibvcq->context)->uar + MLX4_CQ_DOORBELL,
+			htobe64(doorbell));
 
 	return 0;
 }
diff --git a/providers/mlx4/doorbell.h b/providers/mlx4/doorbell.h
deleted file mode 100644
index 140a6158d7f2ee..00000000000000
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 229c2670b5ed85..b798b37f9a8f36 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -219,7 +219,6 @@ static int mlx4_init_context(struct verbs_device *v_device,
 		context->bf_buf_size = 0;
 	}
 
-	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 	ibv_ctx->ops = mlx4_ctx_ops;
 
 	context->hca_core_clock = NULL;
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index a14245976c01bf..b4f6e864722e00 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -127,7 +127,6 @@ struct mlx4_context {
 	struct ibv_context		ibv_ctx;
 
 	void			       *uar;
-	pthread_spinlock_t		uar_lock;
 
 	void			       *bf_page;
 	int				bf_buf_size;
diff --git a/providers/mlx4/mmio.h b/providers/mlx4/mmio.h
index a1a296658fdbb0..9821e85224dcfd 100644
--- a/providers/mlx4/mmio.h
+++ b/providers/mlx4/mmio.h
@@ -7,30 +7,6 @@
 #include <sys/syscall.h>
 #ifdef __s390x__
 
-static inline long mmio_writeb(const unsigned long mmio_addr,
-			       const uint8_t val)
-{
-	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
-}
-
-static inline long mmio_writew(const unsigned long mmio_addr,
-			       const uint16_t val)
-{
-	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
-}
-
-static inline long mmio_writel(const unsigned long mmio_addr,
-			       const uint32_t val)
-{
-	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
-}
-
-static inline long mmio_writeq(const unsigned long mmio_addr,
-			       const uint64_t val)
-{
-	return syscall(__NR_s390_pci_mmio_write, mmio_addr, &val, sizeof(val));
-}
-
 static inline long mmio_write(const unsigned long mmio_addr,
 			      const void *val,
 			      const size_t length)
@@ -38,33 +14,6 @@ static inline long mmio_write(const unsigned long mmio_addr,
 	return syscall(__NR_s390_pci_mmio_write, mmio_addr, val, length);
 }
 
-static inline long mmio_readb(const unsigned long mmio_addr, uint8_t *val)
-{
-	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
-}
-
-static inline long mmio_readw(const unsigned long mmio_addr, uint16_t *val)
-{
-	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
-}
-
-static inline long mmio_readl(const unsigned long mmio_addr, uint32_t *val)
-{
-	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
-}
-
-static inline long mmio_readq(const unsigned long mmio_addr, uint64_t *val)
-{
-	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, sizeof(*val));
-}
-
-static inline long mmio_read(const unsigned long mmio_addr,
-			     void *val,
-			     const size_t length)
-{
-	return syscall(__NR_s390_pci_mmio_read, mmio_addr, val, length);
-}
-
 static inline void mlx4_bf_copy(unsigned long *dst,
 				unsigned long *src,
 				unsigned bytecnt)
@@ -74,28 +23,6 @@ static inline void mlx4_bf_copy(unsigned long *dst,
 
 #else
 
-#define mmio_writeb(addr, value) \
-	(*((volatile uint8_t *)addr) = value)
-#define mmio_writew(addr, value) \
-	(*((volatile uint16_t *)addr) = value)
-#define mmio_writel(addr, value) \
-	(*((volatile uint32_t *)addr) = value)
-#define mmio_writeq(addr, value) \
-	(*((volatile uint64_t *)addr) = value)
-#define mmio_write(addr, value, length) \
-	memcpy(addr, value, length)
-
-#define mmio_readb(addr, value) \
-	(value = *((volatile uint8_t *)addr))
-#define mmio_readw(addr, value) \
-	(value = *((volatile uint16_t *)addr))
-#define mmio_readl(addr, value) \
-	(value = *((volatile uint32_t *)addr))
-#define mmio_readq(addr, value) \
-	(value = *((volatile uint64_t *)addr))
-#define mmio_read(addr, value, length) \
-	memcpy(value, addr, length)
-
 /*
  * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
  * implementations may use move-string-buffer assembler instructions,
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index a8eb8e295edeb2..423f59533de68d 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -38,11 +38,12 @@
 #include <pthread.h>
 #include <string.h>
 #include <errno.h>
+#include <util/mmio.h>
 #include <util/compiler.h>
 
 #include "mlx4.h"
-#include "doorbell.h"
 #include "wqe.h"
+#include "mmio.h"
 
 static const uint32_t mlx4_ib_opcode[] = {
 	[IBV_WR_SEND]			= MLX4_OPCODE_SEND,
@@ -497,8 +498,8 @@ out:
 		 */
 		udma_to_device_barrier();
 
-		mmio_writel((unsigned long)(ctx->uar + MLX4_SEND_DOORBELL),
-			    qp->doorbell_qpn);
+		mmio_write32_be(ctx->uar + MLX4_SEND_DOORBELL,
+				qp->doorbell_qpn);
 	}
 
 	if (nreq)
diff --git a/providers/mlx4/srq.c b/providers/mlx4/srq.c
index b8d25bb343da30..f30cc2e44a0e9e 100644
--- a/providers/mlx4/srq.c
+++ b/providers/mlx4/srq.c
@@ -37,7 +37,6 @@
 #include <string.h>
 
 #include "mlx4.h"
-#include "doorbell.h"
 #include "wqe.h"
 #include "mlx4-abi.h"
 
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 97816a9814999d..80efd9ac4b2426 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -39,6 +39,8 @@
 #include <pthread.h>
 #include <errno.h>
 
+#include <util/mmio.h>
+
 #include "mlx4.h"
 #include "mlx4-abi.h"
 #include "wqe.h"
@@ -101,7 +103,6 @@ int mlx4_query_device_ex(struct ibv_context *context,
 	return 0;
 }
 
-#define READL(ptr) (*((uint32_t *)(ptr)))
 static int mlx4_read_clock(struct ibv_context *context, uint64_t *cycles)
 {
 	unsigned int clockhi, clocklo, clockhi1;
@@ -113,9 +114,9 @@ static int mlx4_read_clock(struct ibv_context *context, uint64_t *cycles)
 
 	/* Handle wraparound */
 	for (i = 0; i < 2; i++) {
-		clockhi = be32toh(READL(ctx->hca_core_clock));
-		clocklo = be32toh(READL(ctx->hca_core_clock + 4));
-		clockhi1 = be32toh(READL(ctx->hca_core_clock));
+		clockhi = be32toh(mmio_read32_be(ctx->hca_core_clock));
+		clocklo = be32toh(mmio_read32_be(ctx->hca_core_clock + 4));
+		clockhi1 = be32toh(mmio_read32_be(ctx->hca_core_clock));
 		if (clockhi == clockhi1)
 			break;
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
