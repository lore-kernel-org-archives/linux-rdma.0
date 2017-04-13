From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/5] mlx5: Use util/mmio.h
Date: Thu, 13 Apr 2017 16:38:45 -0600
Message-ID: <1492123127-6266-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492123127-6266-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove now duplicated mmio accessor macros.

This fixes a bug in mlx5_read_clock where a pointer was read twice without any
sort of barrier, resulting in mis-compilation. (eg the double read of clockhi
never worked)

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx5/cq.c       | 13 ++++-----
 providers/mlx5/doorbell.h | 67 -----------------------------------------------
 providers/mlx5/mlx5.c     |  2 --
 providers/mlx5/mlx5.h     |  1 -
 providers/mlx5/qp.c       |  5 ++--
 providers/mlx5/srq.c      |  1 -
 providers/mlx5/verbs.c    |  9 ++++---
 7 files changed, 14 insertions(+), 84 deletions(-)
 delete mode 100644 providers/mlx5/doorbell.h

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 2e8b584b0930fd..0a1dd55896e775 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -40,11 +40,11 @@
 #include <unistd.h>
 
 #include <util/compiler.h>
+#include <util/mmio.h>
 #include <infiniband/opcode.h>
 
 #include "mlx5.h"
 #include "wqe.h"
-#include "doorbell.h"
 
 enum {
 	CQ_OK					=  0,
@@ -1285,7 +1285,7 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx5_cq *cq = to_mcq(ibvcq);
 	struct mlx5_context *ctx = to_mctx(ibvcq->context);
-	uint32_t doorbell[2];
+	uint64_t doorbell;
 	uint32_t sn;
 	uint32_t ci;
 	uint32_t cmd;
@@ -1294,6 +1294,10 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	ci  = cq->cons_index & 0xffffff;
 	cmd = solicited ? MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT;
 
+	doorbell = sn << 28 | cmd | ci;
+	doorbell <<= 32;
+	doorbell |= cq->cqn;
+
 	cq->dbrec[MLX5_CQ_ARM_DB] = htobe32(sn << 28 | cmd | ci);
 
 	/*
@@ -1302,10 +1306,7 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 */
 	mmio_wc_start();
 
-	doorbell[0] = htobe32(sn << 28 | cmd | ci);
-	doorbell[1] = htobe32(cq->cqn);
-
-	mlx5_write64(doorbell, ctx->uar[0] + MLX5_CQ_DOORBELL, &ctx->lock32);
+	mmio_write64_be(ctx->uar[0] + MLX5_CQ_DOORBELL, htobe64(doorbell));
 
 	mmio_flush_writes();
 
diff --git a/providers/mlx5/doorbell.h b/providers/mlx5/doorbell.h
deleted file mode 100644
index 2d5ede4604d398..00000000000000
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 30f165b0280559..88a808fb045a1a 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -891,8 +891,6 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		mlx5_map_internal_clock(mdev, ctx);
 	}
 
-	mlx5_spinlock_init(&context->lock32);
-
 	context->prefer_bf = get_always_bf();
 	context->shut_up_bf = get_shut_up_bf();
 	mlx5_read_env(&vdev->device, context);
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 0de40a809ffbee..615dea38e4fedd 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -236,7 +236,6 @@ struct mlx5_context {
 	pthread_mutex_t                 uidx_table_mutex;
 
 	void			       *uar[MLX5_MAX_UARS];
-	struct mlx5_spinlock		lock32;
 	struct mlx5_db_page	       *db_list;
 	pthread_mutex_t			db_list_mutex;
 	int				cache_line_size;
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index 1d5a2f9238cfe9..7f67a0b61b221f 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -37,10 +37,10 @@
 #include <string.h>
 #include <errno.h>
 #include <stdio.h>
+#include <util/mmio.h>
 #include <util/compiler.h>
 
 #include "mlx5.h"
-#include "doorbell.h"
 #include "wqe.h"
 
 #define MLX5_ATOMIC_SIZE 8
@@ -942,8 +942,7 @@ out:
 			mlx5_bf_copy(bf->reg + bf->offset, (unsigned long long *)ctrl,
 				     align(size * 16, 64), qp);
 		else
-			mlx5_write64((__be32 *)ctrl, bf->reg + bf->offset,
-				     &ctx->lock32);
+			mmio_write64_be(bf->reg + bf->offset, *(__be64 *)ctrl);
 
 		/*
 		 * use mmio_flush_writes() to ensure write combining buffers are flushed out
diff --git a/providers/mlx5/srq.c b/providers/mlx5/srq.c
index 202fa87aceef59..94528bba94d232 100644
--- a/providers/mlx5/srq.c
+++ b/providers/mlx5/srq.c
@@ -38,7 +38,6 @@
 #include <errno.h>
 
 #include "mlx5.h"
-#include "doorbell.h"
 #include "wqe.h"
 
 static void *get_wqe(struct mlx5_srq *srq, int n)
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index f0e4aabb0dbcef..4fc186e48847c7 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -45,6 +45,8 @@
 #include <sys/mman.h>
 
 #include <util/compiler.h>
+#include <util/mmio.h>
+
 #include "mlx5.h"
 #include "mlx5-abi.h"
 #include "wqe.h"
@@ -77,7 +79,6 @@ int mlx5_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 	return 0;
 }
 
-#define READL(ptr) (*((uint32_t *)(ptr)))
 static int mlx5_read_clock(struct ibv_context *context, uint64_t *cycles)
 {
 	unsigned int clockhi, clocklo, clockhi1;
@@ -89,9 +90,9 @@ static int mlx5_read_clock(struct ibv_context *context, uint64_t *cycles)
 
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
