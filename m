From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/4] RDMA/libocrdma: Remove async-event hook from context ops
Date: Thu, 25 Feb 2016 02:50:46 -0500
Message-ID: <1456386647-22315-4-git-send-email-devesh.sharma@broadcom.com>
References: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456386647-22315-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

libocrdma is not doing anything fruitful in ocrdma_async_event()
thus this hook is not required for us. Removing it.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 src/ocrdma_main.c  |  1 -
 src/ocrdma_verbs.c | 28 ----------------------------
 2 files changed, 29 deletions(-)

diff --git a/src/ocrdma_main.c b/src/ocrdma_main.c
index 4df6b99..5c494d8 100644
--- a/src/ocrdma_main.c
+++ b/src/ocrdma_main.c
@@ -94,7 +94,6 @@ static struct ibv_context_ops ocrdma_ctx_ops = {
 	.post_recv = ocrdma_post_recv,
 	.create_ah = ocrdma_create_ah,
 	.destroy_ah = ocrdma_destroy_ah,
-	.async_event = ocrdma_async_event,
 
 	.create_srq = ocrdma_create_srq,
 	.modify_srq = ocrdma_modify_srq,
diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index f04b3d6..5248e7e 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -2190,31 +2190,3 @@ int ocrdma_detach_mcast(struct ibv_qp *ibqp, const union ibv_gid *gid,
 {
 	return ibv_cmd_detach_mcast(ibqp, gid, lid);
 }
-
-void ocrdma_async_event(struct ibv_async_event *event)
-{
-	struct ocrdma_cq *cq;
-	struct ocrdma_qp *qp;
-	switch (event->event_type) {
-	case IBV_EVENT_CQ_ERR:
-		cq = get_ocrdma_cq(event->element.cq);
-		break;
-	case IBV_EVENT_QP_FATAL:
-	case IBV_EVENT_QP_REQ_ERR:
-	case IBV_EVENT_QP_ACCESS_ERR:
-	case IBV_EVENT_PATH_MIG_ERR:{
-			qp = get_ocrdma_qp(event->element.qp);
-			break;
-		}
-	case IBV_EVENT_SQ_DRAINED:
-	case IBV_EVENT_PATH_MIG:
-	case IBV_EVENT_COMM_EST:
-	case IBV_EVENT_QP_LAST_WQE_REACHED:
-		break;
-	case IBV_EVENT_PORT_ACTIVE:
-	case IBV_EVENT_PORT_ERR:
-		break;
-	default:
-		break;
-	}
-}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
