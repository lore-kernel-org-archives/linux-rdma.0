From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rxe: Fix honoring max IRD value for rd/atomic.
Date: Wed, 28 Sep 2016 20:26:44 +0000
Message-ID: <1475094404-18494-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes honoring max incoming read request count instead of
outgoing read req count
(a) during modify qp by allocating response queue metadata
(b) during incoming read request processing

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  2 +-
 drivers/infiniband/sw/rxe/rxe_qp.c   | 24 +++++++++++++-----------
 drivers/infiniband/sw/rxe/rxe_resp.c |  2 +-
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 4a5484e..73849a5a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -198,7 +198,7 @@ void free_rd_atomic_resource(struct rxe_qp *qp, struct resp_res *res);
 static inline void rxe_advance_resp_resource(struct rxe_qp *qp)
 {
 	qp->resp.res_head++;
-	if (unlikely(qp->resp.res_head == qp->attr.max_rd_atomic))
+	if (unlikely(qp->resp.res_head == qp->attr.max_dest_rd_atomic))
 		qp->resp.res_head = 0;
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index f2c0dc2..b8036cf 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -146,7 +146,7 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 	if (qp->resp.resources) {
 		int i;
 
-		for (i = 0; i < qp->attr.max_rd_atomic; i++) {
+		for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
 			struct resp_res *res = &qp->resp.resources[i];
 
 			free_rd_atomic_resource(qp, res);
@@ -174,7 +174,7 @@ static void cleanup_rd_atomic_resources(struct rxe_qp *qp)
 	struct resp_res *res;
 
 	if (qp->resp.resources) {
-		for (i = 0; i < qp->attr.max_rd_atomic; i++) {
+		for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
 			res = &qp->resp.resources[i];
 			free_rd_atomic_resource(qp, res);
 		}
@@ -596,14 +596,21 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 	if (mask & IB_QP_MAX_QP_RD_ATOMIC) {
 		int max_rd_atomic = __roundup_pow_of_two(attr->max_rd_atomic);
 
+		qp->attr.max_rd_atomic = max_rd_atomic;
+		atomic_set(&qp->req.rd_atomic, max_rd_atomic);
+	}
+
+	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
+		int max_dest_rd_atomic =
+			__roundup_pow_of_two(attr->max_dest_rd_atomic);
+
+		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
+
 		free_rd_atomic_resources(qp);
 
-		err = alloc_rd_atomic_resources(qp, max_rd_atomic);
+		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
 		if (err)
 			return err;
-
-		qp->attr.max_rd_atomic = max_rd_atomic;
-		atomic_set(&qp->req.rd_atomic, max_rd_atomic);
 	}
 
 	if (mask & IB_QP_CUR_STATE)
@@ -704,11 +711,6 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		pr_debug("qp#%d set req psn = 0x%x\n", qp_num(qp), qp->req.psn);
 	}
 
-	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
-		qp->attr.max_dest_rd_atomic =
-			__roundup_pow_of_two(attr->max_dest_rd_atomic);
-	}
-
 	if (mask & IB_QP_PATH_MIG_STATE)
 		qp->attr.path_mig_state = attr->path_mig_state;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index d0be8f2..dd3d88a 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -383,7 +383,7 @@ static enum resp_states check_resource(struct rxe_qp *qp,
 		 * too many read/atomic ops, we just
 		 * recycle the responder resource queue
 		 */
-		if (likely(qp->attr.max_rd_atomic > 0))
+		if (likely(qp->attr.max_dest_rd_atomic > 0))
 			return RESPST_CHK_LENGTH;
 		else
 			return RESPST_ERR_TOO_MANY_RDMA_ATM_REQ;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
