From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] libbnxt_re: sq needs to be augmented by 128B
Date: Fri, 12 May 2017 06:24:22 -0400
Message-ID: <1494584666-11064-2-git-send-email-devesh.sharma@broadcom.com>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494584666-11064-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

In order to avoid out of order completions there is a
requirement to augment the SQ of any QP by 128B.
This patch adds (128 + 1)B delta while SQ allocation and
updates the queue-full determining logic.

bnxt_re_query_qp is relying on whatever attributes driver
returns. Thus, dropping to update the max_send_wr and
max_recv_wr caps during bnxt_re_create_qp.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/bnxt_re-abi.h |  2 ++
 providers/bnxt_re/memory.h      | 10 +++++++++-
 providers/bnxt_re/verbs.c       |  9 ++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index 205d8c4..73beef5 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -43,6 +43,8 @@
 
 #define BNXT_RE_ABI_VERSION 1
 
+#define BNXT_RE_FULL_FLAG_DELTA        0x80
+
 enum bnxt_re_wr_opcode {
 	BNXT_RE_WR_OPCD_SEND		= 0x00,
 	BNXT_RE_WR_OPCD_SEND_IMM	= 0x01,
diff --git a/providers/bnxt_re/memory.h b/providers/bnxt_re/memory.h
index 0150d80..aac0ff3 100644
--- a/providers/bnxt_re/memory.h
+++ b/providers/bnxt_re/memory.h
@@ -49,6 +49,14 @@ struct bnxt_re_queue {
 	uint32_t head;
 	uint32_t tail;
 	uint32_t stride;
+	/* Represents the difference between the real queue depth allocated in
+	 * HW and the user requested queue depth and is used to correctly flag
+	 * queue full condition based on user supplied queue depth.
+	 * This value can vary depending on the type of queue and any HW
+	 * requirements that mandate keeping a fixed gap between the producer
+	 * and the consumer indices in the queue
+	 */
+	uint32_t diff;
 	pthread_spinlock_t qlock;
 };
 
@@ -86,7 +94,7 @@ static inline void iowrite32(__u32 *dst, __le32 *src)
 /* Basic queue operation */
 static inline uint32_t bnxt_re_is_que_full(struct bnxt_re_queue *que)
 {
-	return (((que->tail + 1) & (que->depth - 1)) == que->head);
+	return (((que->diff + que->tail) & (que->depth - 1)) == que->head);
 }
 
 static inline uint32_t bnxt_re_is_que_empty(struct bnxt_re_queue *que)
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 2768a56..35eb12d 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -793,7 +793,11 @@ static int bnxt_re_alloc_queues(struct bnxt_re_qp *qp,
 
 	que = qp->sqq;
 	que->stride = bnxt_re_get_sqe_sz();
-	que->depth = roundup_pow_of_two(attr->cap.max_send_wr + 1);
+	/* 8916 adjustment */
+	que->depth = roundup_pow_of_two(attr->cap.max_send_wr + 1 +
+					BNXT_RE_FULL_FLAG_DELTA);
+	que->diff = que->depth - attr->cap.max_send_wr;
+
 	/* psn_depth extra entries of size que->stride */
 	psn_depth = (que->depth * sizeof(struct bnxt_re_psns)) /
 		     que->stride;
@@ -828,6 +832,7 @@ static int bnxt_re_alloc_queues(struct bnxt_re_qp *qp,
 		que = qp->rqq;
 		que->stride = bnxt_re_get_rqe_sz();
 		que->depth = roundup_pow_of_two(attr->cap.max_recv_wr + 1);
+		que->diff = que->depth - attr->cap.max_recv_wr;
 		ret = bnxt_re_alloc_aligned(qp->rqq, pg_size);
 		if (ret)
 			goto fail;
@@ -888,9 +893,7 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
 	qp->rcq = to_bnxt_re_cq(attr->recv_cq);
 	qp->udpi = &cntx->udpi;
 	/* Save/return the altered Caps. */
-	attr->cap.max_send_wr = cap->max_swr;
 	cap->max_ssge = attr->cap.max_send_sge;
-	attr->cap.max_recv_wr = cap->max_rwr;
 	cap->max_rsge = attr->cap.max_recv_sge;
 	cap->max_inline = attr->cap.max_inline_data;
 	cap->sqsig = attr->sq_sig_all;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
