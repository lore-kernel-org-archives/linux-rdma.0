From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/4] RDMA/libocrdma: Fix compile time warnings
Date: Thu, 25 Feb 2016 02:50:45 -0500
Message-ID: <1456386647-22315-3-git-send-email-devesh.sharma@broadcom.com>
References: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456386647-22315-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes couple of build warnings.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 src/ocrdma_verbs.c | 48 +++++++++++++-----------------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index c62ced0..f04b3d6 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -453,41 +453,24 @@ cmd_err:
 int ocrdma_modify_srq(struct ibv_srq *ibsrq,
 		      struct ibv_srq_attr *attr, int attr_mask)
 {
-	int status;
-	struct ocrdma_device *dev;
-	struct ocrdma_srq *srq;
 	struct ibv_modify_srq cmd;
 
-	srq = get_ocrdma_srq(ibsrq);
-	dev = srq->dev;
-
-	status = ibv_cmd_modify_srq(ibsrq, attr, attr_mask, &cmd, sizeof cmd);
-	return status;
+	return ibv_cmd_modify_srq(ibsrq, attr, attr_mask, &cmd, sizeof cmd);
 }
 
 int ocrdma_query_srq(struct ibv_srq *ibsrq, struct ibv_srq_attr *attr)
 {
-	int status;
 	struct ibv_query_srq cmd;
-	struct ocrdma_device *dev;
-	struct ocrdma_srq *srq;
 
-	srq = get_ocrdma_srq(ibsrq);
-	dev = srq->dev;
-	status = ibv_cmd_query_srq(ibsrq, attr, &cmd, sizeof cmd);
-	return status;
+	return ibv_cmd_query_srq(ibsrq, attr, &cmd, sizeof cmd);
 }
 
 int ocrdma_destroy_srq(struct ibv_srq *ibsrq)
 {
 	int status;
-	int id;
 	struct ocrdma_srq *srq;
-	struct ocrdma_device *dev;
 	srq = get_ocrdma_srq(ibsrq);
-	dev = srq->dev;
 
-	id = dev->id;
 	status = ibv_cmd_destroy_srq(ibsrq);
 	if (status)
 		return status;
@@ -668,6 +651,10 @@ enum ocrdma_qp_state get_ocrdma_qp_state(enum ibv_qp_state qps)
 		return OCRDMA_QPS_SQE;
 	case IBV_QPS_ERR:
 		return OCRDMA_QPS_ERR;
+	case IBV_QPS_UNKNOWN:
+		break;
+	default:
+		break;
 	};
 	return OCRDMA_QPS_ERR;
 }
@@ -1096,10 +1083,9 @@ int ocrdma_destroy_qp(struct ibv_qp *ibqp)
 	int status = 0;
 	struct ocrdma_qp *qp;
 	struct ocrdma_device *dev;
-	int id;
+
 	qp = get_ocrdma_qp(ibqp);
 	dev = qp->dev;
-	id = dev->id;
 	/*
 	 * acquire CQ lock while destroy is in progress, in order to
 	 * protect against proessing in-flight CQEs for this QP.
@@ -2178,9 +2164,9 @@ int ocrdma_destroy_ah(struct ibv_ah *ibah)
 {
 	int status;
 	struct ocrdma_ah *ah;
-	struct ocrdma_device *dev;
+
 	ah = get_ocrdma_ah(ibah);
-	dev = ah->pd->dev;
+
 	status = ibv_cmd_destroy_ah(ibah);
 	ocrdma_free_ah_tbl_id(ah->pd->uctx, ah->id);
 	free(ah);
@@ -2193,11 +2179,7 @@ int ocrdma_destroy_ah(struct ibv_ah *ibah)
 int ocrdma_attach_mcast(struct ibv_qp *ibqp, const union ibv_gid *gid,
 			uint16_t lid)
 {
-	int status;
-	struct ocrdma_qp *qp;
-	qp = get_ocrdma_qp(ibqp);
-	status = ibv_cmd_attach_mcast(ibqp, gid, lid);
-	return status;
+	return ibv_cmd_attach_mcast(ibqp, gid, lid);
 }
 
 /*
@@ -2206,17 +2188,13 @@ int ocrdma_attach_mcast(struct ibv_qp *ibqp, const union ibv_gid *gid,
 int ocrdma_detach_mcast(struct ibv_qp *ibqp, const union ibv_gid *gid,
 			uint16_t lid)
 {
-	int status;
-	struct ocrdma_qp *qp;
-	qp = get_ocrdma_qp(ibqp);
-	status = ibv_cmd_detach_mcast(ibqp, gid, lid);
-	return status;
+	return ibv_cmd_detach_mcast(ibqp, gid, lid);
 }
 
 void ocrdma_async_event(struct ibv_async_event *event)
 {
-	struct ocrdma_cq *cq = NULL;
-	struct ocrdma_qp *qp = NULL;
+	struct ocrdma_cq *cq;
+	struct ocrdma_qp *qp;
 	switch (event->event_type) {
 	case IBV_EVENT_CQ_ERR:
 		cq = get_ocrdma_cq(event->element.cq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
