From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 11/20] xprtrdma: Use core ib_drain_qp() API
Date: Mon, 02 May 2016 14:41:47 -0400
Message-ID: <20160502184147.10798.39729.stgit@manet.1015granger.net>
References: <20160502183144.10798.99847.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502183144.10798.99847.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Replace rpcrdma_flush_cqs() and rpcrdma_clean_cqs() with
the new ib_drain_qp() API.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-By: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   41 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 9f8d6c1..b7a5bc1 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -203,15 +203,6 @@ out_fail:
 	goto out_schedule;
 }
 
-static void
-rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
-{
-	struct ib_wc wc;
-
-	while (ib_poll_cq(ep->rep_attr.recv_cq, 1, &wc) > 0)
-		rpcrdma_receive_wc(NULL, &wc);
-}
-
 static int
 rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 {
@@ -374,23 +365,6 @@ out:
 }
 
 /*
- * Drain any cq, prior to teardown.
- */
-static void
-rpcrdma_clean_cq(struct ib_cq *cq)
-{
-	struct ib_wc wc;
-	int count = 0;
-
-	while (1 == ib_poll_cq(cq, 1, &wc))
-		++count;
-
-	if (count)
-		dprintk("RPC:       %s: flushed %d events (last 0x%x)\n",
-			__func__, count, wc.opcode);
-}
-
-/*
  * Exported functions.
  */
 
@@ -515,7 +489,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 			__func__);
 		return -ENOMEM;
 	}
-	max_qp_wr = ia->ri_device->attrs.max_qp_wr - RPCRDMA_BACKWARD_WRS;
+	max_qp_wr = ia->ri_device->attrs.max_qp_wr - RPCRDMA_BACKWARD_WRS - 1;
 
 	/* check provider's send/recv wr limits */
 	if (cdata->max_requests > max_qp_wr)
@@ -526,11 +500,13 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	ep->rep_attr.srq = NULL;
 	ep->rep_attr.cap.max_send_wr = cdata->max_requests;
 	ep->rep_attr.cap.max_send_wr += RPCRDMA_BACKWARD_WRS;
+	ep->rep_attr.cap.max_send_wr += 1;	/* drain cqe */
 	rc = ia->ri_ops->ro_open(ia, ep, cdata);
 	if (rc)
 		return rc;
 	ep->rep_attr.cap.max_recv_wr = cdata->max_requests;
 	ep->rep_attr.cap.max_recv_wr += RPCRDMA_BACKWARD_WRS;
+	ep->rep_attr.cap.max_recv_wr += 1;	/* drain cqe */
 	ep->rep_attr.cap.max_send_sge = RPCRDMA_MAX_IOVS;
 	ep->rep_attr.cap.max_recv_sge = 1;
 	ep->rep_attr.cap.max_inline_data = 0;
@@ -622,13 +598,8 @@ rpcrdma_ep_destroy(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 
 	cancel_delayed_work_sync(&ep->rep_connect_worker);
 
-	if (ia->ri_id->qp)
-		rpcrdma_ep_disconnect(ep, ia);
-
-	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
-	rpcrdma_clean_cq(ep->rep_attr.send_cq);
-
 	if (ia->ri_id->qp) {
+		rpcrdma_ep_disconnect(ep, ia);
 		rdma_destroy_qp(ia->ri_id);
 		ia->ri_id->qp = NULL;
 	}
@@ -659,7 +630,6 @@ retry:
 		dprintk("RPC:       %s: reconnecting...\n", __func__);
 
 		rpcrdma_ep_disconnect(ep, ia);
-		rpcrdma_flush_cqs(ep);
 
 		xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
 		id = rpcrdma_create_id(xprt, ia,
@@ -785,7 +755,6 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 {
 	int rc;
 
-	rpcrdma_flush_cqs(ep);
 	rc = rdma_disconnect(ia->ri_id);
 	if (!rc) {
 		/* returns without wait if not connected */
@@ -797,6 +766,8 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 		dprintk("RPC:       %s: rdma_disconnect %i\n", __func__, rc);
 		ep->rep_connected = rc;
 	}
+
+	ib_drain_qp(ia->ri_id->qp);
 }
 
 struct rpcrdma_req *

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
