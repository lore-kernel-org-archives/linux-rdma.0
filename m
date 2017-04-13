From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/5] mthca: Use util/mmio.h
Date: Thu, 13 Apr 2017 16:38:46 -0600
Message-ID: <1492123127-6266-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492123127-6266-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove now duplicated mmio accessor macros.

In this driver we keep the weird uint32_t array since there are so
many places that use it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mthca/cq.c       |  38 +++++++---------
 providers/mthca/doorbell.h | 109 +++------------------------------------------
 providers/mthca/qp.c       |  44 ++++++++++--------
 providers/mthca/srq.c      |  14 +++---
 4 files changed, 55 insertions(+), 150 deletions(-)

diff --git a/providers/mthca/cq.c b/providers/mthca/cq.c
index 8d30e24c83a8e2..68550410f349af 100644
--- a/providers/mthca/cq.c
+++ b/providers/mthca/cq.c
@@ -154,10 +154,10 @@ static inline void update_cons_index(struct mthca_cq *cq, int incr)
 		*cq->set_ci_db = htobe32(cq->cons_index);
 		mmio_ordered_writes_hack();
 	} else {
-		doorbell[0] = htobe32(MTHCA_TAVOR_CQ_DB_INC_CI | cq->cqn);
-		doorbell[1] = htobe32(incr - 1);
+		doorbell[0] = MTHCA_TAVOR_CQ_DB_INC_CI | cq->cqn;
+		doorbell[1] = incr - 1;
 
-		mthca_write64(doorbell, to_mctx(cq->ibv_cq.context), MTHCA_CQ_DOORBELL);
+		mthca_write64(doorbell, to_mctx(cq->ibv_cq.context)->uar + MTHCA_CQ_DOORBELL);
 	}
 }
 
@@ -485,13 +485,12 @@ int mthca_tavor_arm_cq(struct ibv_cq *cq, int solicited)
 {
 	uint32_t doorbell[2];
 
-	doorbell[0] = htobe32((solicited ?
-			     MTHCA_TAVOR_CQ_DB_REQ_NOT_SOL :
-			     MTHCA_TAVOR_CQ_DB_REQ_NOT)      |
-			    to_mcq(cq)->cqn);
+	doorbell[0] = (solicited ? MTHCA_TAVOR_CQ_DB_REQ_NOT_SOL
+				 : MTHCA_TAVOR_CQ_DB_REQ_NOT) |
+		      to_mcq(cq)->cqn;
 	doorbell[1] = 0xffffffff;
 
-	mthca_write64(doorbell, to_mctx(cq->context), MTHCA_CQ_DOORBELL);
+	mthca_write64(doorbell, to_mctx(cq->context)->uar + MTHCA_CQ_DOORBELL);
 
 	return 0;
 }
@@ -501,16 +500,14 @@ int mthca_arbel_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	struct mthca_cq *cq = to_mcq(ibvcq);
 	uint32_t doorbell[2];
 	uint32_t sn;
-	uint32_t ci;
 
 	sn = cq->arm_sn & 3;
-	ci = htobe32(cq->cons_index);
 
-	doorbell[0] = ci;
-	doorbell[1] = htobe32((cq->cqn << 8) | (2 << 5) | (sn << 3) |
-			    (solicited ? 1 : 2));
+	doorbell[0] = cq->cons_index;
+	doorbell[1] =
+	    (cq->cqn << 8) | (2 << 5) | (sn << 3) | (solicited ? 1 : 2);
 
-	mthca_write_db_rec(doorbell, cq->arm_db);
+	mthca_write64(doorbell, cq->arm_db);
 
 	/*
 	 * Make sure that the doorbell record in host memory is
@@ -518,14 +515,13 @@ int mthca_arbel_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 */
 	udma_to_device_barrier();
 
-	doorbell[0] = htobe32((sn << 28)                       |
-			    (solicited ?
-			     MTHCA_ARBEL_CQ_DB_REQ_NOT_SOL :
-			     MTHCA_ARBEL_CQ_DB_REQ_NOT)      |
-			    cq->cqn);
-	doorbell[1] = ci;
+	doorbell[0] = (sn << 28) | (solicited ? MTHCA_ARBEL_CQ_DB_REQ_NOT_SOL
+					      : MTHCA_ARBEL_CQ_DB_REQ_NOT) |
+		      cq->cqn;
+	doorbell[1] = cq->cons_index;
 
-	mthca_write64(doorbell, to_mctx(ibvcq->context), MTHCA_CQ_DOORBELL);
+	mthca_write64(doorbell,
+		      to_mctx(ibvcq->context)->uar + MTHCA_CQ_DOORBELL);
 
 	return 0;
 }
diff --git a/providers/mthca/doorbell.h b/providers/mthca/doorbell.h
index 32829a4d1c967e..d2411ea040d8d4 100644
--- a/providers/mthca/doorbell.h
+++ b/providers/mthca/doorbell.h
@@ -1,113 +1,14 @@
-/*
- * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
+/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file */
 #ifndef DOORBELL_H
 #define DOORBELL_H
 
-#include <stdint.h>
-#include <pthread.h>
+#include <util/mmio.h>
 #include "mthca.h"
 
-struct mthca_context;
-
-#ifdef __i386__
-
-static inline void mthca_write64(uint32_t val[2], struct mthca_context *ctx, int offset)
+static inline void mthca_write64(uint32_t val[2], void *reg)
 {
-	/* i386 stack is aligned to 8 bytes, so this should be OK: */
-	uint8_t xmmsave[8] __attribute__((aligned(8)));
-
-	asm volatile (
-		"movlps %%xmm0,(%0); \n\t"
-		"movlps (%1),%%xmm0; \n\t"
-		"movlps %%xmm0,(%2); \n\t"
-		"movlps (%0),%%xmm0; \n\t"
-		:
-		: "r" (xmmsave), "r" (val), "r" (ctx->uar + offset)
-		: "memory" );
+	uint64_t doorbell = (((uint64_t)val[0]) << 32) | val[1];
+	mmio_write64_be(reg, htobe64(doorbell));
 }
 
-static inline void mthca_write_db_rec(uint32_t val[2], uint32_t *db)
-{
-	/* i386 stack is aligned to 8 bytes, so this should be OK: */
-	uint8_t xmmsave[8] __attribute__((aligned(8)));
-
-	asm volatile (
-		"movlps %%xmm0,(%0); \n\t"
-		"movlps (%1),%%xmm0; \n\t"
-		"movlps %%xmm0,(%2); \n\t"
-		"movlps (%0),%%xmm0; \n\t"
-		:
-		: "r" (xmmsave), "r" (val), "r" (db)
-		: "memory" );
-}
-
-#elif SIZEOF_LONG == 8
-
-#if __BYTE_ORDER == __LITTLE_ENDIAN
-#  define MTHCA_PAIR_TO_64(val) ((uint64_t) val[1] << 32 | val[0])
-#elif __BYTE_ORDER == __BIG_ENDIAN
-#  define MTHCA_PAIR_TO_64(val) ((uint64_t) val[0] << 32 | val[1])
-#else
-#  error __BYTE_ORDER not defined
 #endif
-
-static inline void mthca_write64(uint32_t val[2], struct mthca_context *ctx, int offset)
-{
-	*(volatile uint64_t *) (ctx->uar + offset) = MTHCA_PAIR_TO_64(val);
-}
-
-static inline void mthca_write_db_rec(uint32_t val[2], uint32_t *db)
-{
-	*(volatile uint64_t *) db = MTHCA_PAIR_TO_64(val);
-}
-
-#else
-
-static inline void mthca_write64(uint32_t val[2], struct mthca_context *ctx, int offset)
-{
-	pthread_spin_lock(&ctx->uar_lock);
-	*(volatile uint32_t *) (ctx->uar + offset)     = val[0];
-	*(volatile uint32_t *) (ctx->uar + offset + 4) = val[1];
-	pthread_spin_unlock(&ctx->uar_lock);
-}
-
-static inline void mthca_write_db_rec(uint32_t val[2], uint32_t *db)
-{
-	*(volatile uint32_t *) db       = val[0];
-	mmio_ordered_writes_hack();
-	*(volatile uint32_t *) (db + 1) = val[1];
-}
-
-#endif
-
-#endif /* MTHCA_H */
diff --git a/providers/mthca/qp.c b/providers/mthca/qp.c
index 52850a4a9daa8a..1907f2b82d6987 100644
--- a/providers/mthca/qp.c
+++ b/providers/mthca/qp.c
@@ -310,12 +310,14 @@ out:
 	if (nreq) {
 		uint32_t doorbell[2];
 
-		doorbell[0] = htobe32(((qp->sq.next_ind << qp->sq.wqe_shift) +
-				     qp->send_wqe_offset) | f0 | op0);
-		doorbell[1] = htobe32((ibqp->qp_num << 8) | size0);
+		doorbell[0] = ((qp->sq.next_ind << qp->sq.wqe_shift) +
+			       qp->send_wqe_offset) |
+			      f0 | op0;
+		doorbell[1] = (ibqp->qp_num << 8) | size0;
 
 		udma_to_device_barrier();
-		mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_SEND_DOORBELL);
+		mthca_write64(doorbell, to_mctx(ibqp->context)->uar +
+					    MTHCA_SEND_DOORBELL);
 	}
 
 	qp->sq.next_ind = ind;
@@ -395,8 +397,9 @@ int mthca_tavor_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		if (nreq == MTHCA_TAVOR_MAX_WQES_PER_RECV_DB) {
 			nreq = 0;
 
-			doorbell[0] = htobe32((qp->rq.next_ind << qp->rq.wqe_shift) | size0);
-			doorbell[1] = htobe32(ibqp->qp_num << 8);
+			doorbell[0] =
+			    (qp->rq.next_ind << qp->rq.wqe_shift) | size0;
+			doorbell[1] = ibqp->qp_num << 8;
 
 			/*
 			 * Make sure that descriptors are written
@@ -404,7 +407,8 @@ int mthca_tavor_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			 */
 			udma_to_device_barrier();
 
-			mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_RECV_DOORBELL);
+			mthca_write64(doorbell, to_mctx(ibqp->context)->uar +
+						    MTHCA_RECV_DOORBELL);
 
 			qp->rq.next_ind = ind;
 			qp->rq.head += MTHCA_TAVOR_MAX_WQES_PER_RECV_DB;
@@ -414,8 +418,8 @@ int mthca_tavor_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 
 out:
 	if (nreq) {
-		doorbell[0] = htobe32((qp->rq.next_ind << qp->rq.wqe_shift) | size0);
-		doorbell[1] = htobe32((ibqp->qp_num << 8) | nreq);
+		doorbell[0] = (qp->rq.next_ind << qp->rq.wqe_shift) | size0;
+		doorbell[1] = (ibqp->qp_num << 8) | nreq;
 
 		/*
 		 * Make sure that descriptors are written before
@@ -423,7 +427,8 @@ out:
 		 */
 		udma_to_device_barrier();
 
-		mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_RECV_DOORBELL);
+		mthca_write64(doorbell, to_mctx(ibqp->context)->uar +
+					    MTHCA_RECV_DOORBELL);
 	}
 
 	qp->rq.next_ind = ind;
@@ -458,9 +463,9 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		if (nreq == MTHCA_ARBEL_MAX_WQES_PER_SEND_DB) {
 			nreq = 0;
 
-			doorbell[0] = htobe32((MTHCA_ARBEL_MAX_WQES_PER_SEND_DB << 24) |
-					    ((qp->sq.head & 0xffff) << 8) | f0 | op0);
-			doorbell[1] = htobe32((ibqp->qp_num << 8) | size0);
+			doorbell[0] = (MTHCA_ARBEL_MAX_WQES_PER_SEND_DB << 24) |
+				      ((qp->sq.head & 0xffff) << 8) | f0 | op0;
+			doorbell[1] = (ibqp->qp_num << 8) | size0;
 
 			qp->sq.head += MTHCA_ARBEL_MAX_WQES_PER_SEND_DB;
 
@@ -476,7 +481,8 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			 * write MMIO send doorbell.
 			 */
 			mmio_ordered_writes_hack();
-			mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_SEND_DOORBELL);
+			mthca_write64(doorbell, to_mctx(ibqp->context)->uar +
+						    MTHCA_SEND_DOORBELL);
 
 			size0 = 0;
 		}
@@ -665,10 +671,9 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 out:
 	if (nreq) {
-		doorbell[0] = htobe32((nreq << 24)                  |
-				    ((qp->sq.head & 0xffff) << 8) |
-				    f0 | op0);
-		doorbell[1] = htobe32((ibqp->qp_num << 8) | size0);
+		doorbell[0] =
+		    (nreq << 24) | ((qp->sq.head & 0xffff) << 8) | f0 | op0;
+		doorbell[1] = (ibqp->qp_num << 8) | size0;
 
 		qp->sq.head += nreq;
 
@@ -684,7 +689,8 @@ out:
 		 * write MMIO send doorbell.
 		 */
 		mmio_ordered_writes_hack();
-		mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_SEND_DOORBELL);
+		mthca_write64(doorbell, to_mctx(ibqp->context)->uar +
+					    MTHCA_SEND_DOORBELL);
 	}
 
 	pthread_spin_unlock(&qp->sq.lock);
diff --git a/providers/mthca/srq.c b/providers/mthca/srq.c
index 9abf95b15903f3..ad68961341b053 100644
--- a/providers/mthca/srq.c
+++ b/providers/mthca/srq.c
@@ -145,8 +145,8 @@ int mthca_tavor_post_srq_recv(struct ibv_srq *ibsrq,
 		if (++nreq == MTHCA_TAVOR_MAX_WQES_PER_RECV_DB) {
 			nreq = 0;
 
-			doorbell[0] = htobe32(first_ind << srq->wqe_shift);
-			doorbell[1] = htobe32(srq->srqn << 8);
+			doorbell[0] = first_ind << srq->wqe_shift;
+			doorbell[1] = srq->srqn << 8;
 
 			/*
 			 * Make sure that descriptors are written
@@ -154,15 +154,16 @@ int mthca_tavor_post_srq_recv(struct ibv_srq *ibsrq,
 			 */
 			udma_to_device_barrier();
 
-			mthca_write64(doorbell, to_mctx(ibsrq->context), MTHCA_RECV_DOORBELL);
+			mthca_write64(doorbell, to_mctx(ibsrq->context)->uar +
+						    MTHCA_RECV_DOORBELL);
 
 			first_ind = srq->first_free;
 		}
 	}
 
 	if (nreq) {
-		doorbell[0] = htobe32(first_ind << srq->wqe_shift);
-		doorbell[1] = htobe32((srq->srqn << 8) | nreq);
+		doorbell[0] = first_ind << srq->wqe_shift;
+		doorbell[1] = (srq->srqn << 8) | nreq;
 
 		/*
 		 * Make sure that descriptors are written before
@@ -170,7 +171,8 @@ int mthca_tavor_post_srq_recv(struct ibv_srq *ibsrq,
 		 */
 		udma_to_device_barrier();
 
-		mthca_write64(doorbell, to_mctx(ibsrq->context), MTHCA_RECV_DOORBELL);
+		mthca_write64(doorbell, to_mctx(ibsrq->context)->uar +
+					    MTHCA_RECV_DOORBELL);
 	}
 
 	pthread_spin_unlock(&srq->lock);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
