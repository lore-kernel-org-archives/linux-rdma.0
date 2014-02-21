From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] RDMA/libocrdma: eq overflow fix for library
Date: Fri, 21 Feb 2014 11:01:41 +0530
Message-ID: <1392960704-10871-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

EQ overflow avoidance fix for libocrdma. This go hand in hand with the
ocrdma patch to avoid EQ full in ocrdma driver.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_main.c  |    1 -
 src/ocrdma_main.h  |    7 +++----
 src/ocrdma_verbs.c |   47 +++++++++++++++++++----------------------------
 3 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/src/ocrdma_main.c b/src/ocrdma_main.c
index cdefe24..4df6b99 100644
--- a/src/ocrdma_main.c
+++ b/src/ocrdma_main.c
@@ -83,7 +83,6 @@ static struct ibv_context_ops ocrdma_ctx_ops = {
 	.create_cq = ocrdma_create_cq,
 	.poll_cq = ocrdma_poll_cq,
 	.req_notify_cq = ocrdma_arm_cq,
-	.cq_event = ocrdma_cq_handler,
 	.resize_cq = ocrdma_resize_cq,
 	.destroy_cq = ocrdma_destroy_cq,
 
diff --git a/src/ocrdma_main.h b/src/ocrdma_main.h
index 392c77a..5a386bb 100644
--- a/src/ocrdma_main.h
+++ b/src/ocrdma_main.h
@@ -103,9 +103,9 @@ struct ocrdma_cq {
 	uint32_t phase;
 	int phase_change;
 
-	int armed;
-	int solicited;
-	int arm_needed;
+	uint8_t deferred_arm;
+	uint8_t deferred_sol;
+	uint8_t first_arm;
 	struct ocrdma_list_head sq_head;
 	struct ocrdma_list_head rq_head;
 };
@@ -273,7 +273,6 @@ int ocrdma_resize_cq(struct ibv_cq *, int);
 int ocrdma_destroy_cq(struct ibv_cq *);
 int ocrdma_poll_cq(struct ibv_cq *, int, struct ibv_wc *);
 int ocrdma_arm_cq(struct ibv_cq *, int);
-void ocrdma_cq_handler(struct ibv_cq *);
 
 struct ibv_qp *ocrdma_create_qp(struct ibv_pd *, struct ibv_qp_init_attr *);
 int ocrdma_modify_qp(struct ibv_qp *, struct ibv_qp_attr *,
diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index ee8411a..aedb578 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -301,8 +301,8 @@ static struct ibv_cq *ocrdma_create_cq_common(struct ibv_context *context,
 	cq->db_va = map_addr;
 	cq->db_size = resp.db_page_size;
 	cq->phase = OCRDMA_CQE_VALID;
+	cq->first_arm = 1;
 	if (!dpp_cq) {
-		cq->arm_needed = 1;
 		ocrdma_ring_cq_db(cq, 0, 0, 0);
 	}
 	cq->ibv_cq.cqe = cqe;
@@ -1965,8 +1965,16 @@ expand_cqe:
 	}
 stop_cqe:
 	cq->getp = cur_getp;
-	if (polled_hw_cqes || expand || stop)
-		ocrdma_ring_cq_db(cq, cq->armed, cq->solicited, polled_hw_cqes);
+	if (cq->deferred_arm) {
+		ocrdma_ring_cq_db(cq, 1, cq->deferred_sol, polled_hw_cqes);
+		cq->deferred_arm = 0;
+		cq->deferred_sol = 0;
+	} else {
+		/* We need to pop the CQE. No need to arm */
+		ocrdma_ring_cq_db(cq, 0, cq->deferred_sol, polled_hw_cqes);
+		cq->deferred_sol = 0;
+	}
+
 	return i;
 }
 
@@ -2035,41 +2043,24 @@ int ocrdma_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 int ocrdma_arm_cq(struct ibv_cq *ibcq, int solicited)
 {
 	struct ocrdma_cq *cq;
-	uint16_t cur_getp;
-	struct ocrdma_cqe *cqe;
 
 	cq = get_ocrdma_cq(ibcq);
 	pthread_spin_lock(&cq->cq_lock);
 
-	cur_getp = cq->getp;
-	cqe = cq->va + cur_getp;
-
-	cq->armed = 1;
-	cq->solicited = solicited;
-	/* check whether any valid cqe exist or not, if not then safe to
-	 * arm. If cqe is not yet consumed, then let it get consumed and then
-	 * we arm it to avoid 0 interrupts.
-	 */
-	if (!is_cqe_valid(cq, cqe) || cq->arm_needed) {
-		cq->arm_needed = 0;
-		ocrdma_ring_cq_db(cq, cq->armed, cq->solicited, 0);
+	if (cq->first_arm) {
+		ocrdma_ring_cq_db(cq, 1, solicited, 0);
+		cq->first_arm = 0;
+		goto skip_defer;
 	}
-	pthread_spin_unlock(&cq->cq_lock);
 
-	return 0;
-}
+	cq->deferred_arm = 1;
 
-void ocrdma_cq_handler(struct ibv_cq *ibcq)
-{
-	struct ocrdma_cq *cq;
+skip_defer:
+	cq->deferred_sol = solicited;
 
-	cq = get_ocrdma_cq(ibcq);
-	pthread_spin_lock(&cq->cq_lock);
-	cq->armed = 0;
-	cq->solicited = 0;
-	ocrdma_ring_cq_db(cq, cq->armed, cq->solicited, 0);
 	pthread_spin_unlock(&cq->cq_lock);
 
+	return 0;
 }
 
 /*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
