From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
Date: Thu, 10 Apr 2014 00:10:08 +0530
Message-ID: <014738b6-698e-4ea1-82f9-287378bfec19@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the rdma_create_qp fails to create qp due to device firmware being in invalid state
xprtrdma still tries to destroy the non-existant qp and ends up in a NULL pointer reference
crash.
Adding proper checks for vaidating QP pointer avoids this to happen.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 9372656..902ac78 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -831,10 +831,12 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 	if (ep->rep_connected != 0) {
 		struct rpcrdma_xprt *xprt;
 retry:
-		rc = rpcrdma_ep_disconnect(ep, ia);
-		if (rc && rc != -ENOTCONN)
-			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
+		if (ia->ri_id->qp) {
+			rc = rpcrdma_ep_disconnect(ep, ia);
+			if (rc && rc != -ENOTCONN)
+				dprintk("RPC:       %s: rpcrdma_ep_disconnect"
 				" status %i\n", __func__, rc);
+		}
 		rpcrdma_clean_cq(ep->rep_cq);
 
 		xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
@@ -859,7 +861,9 @@ retry:
 			goto out;
 		}
 		/* END TEMP */
-		rdma_destroy_qp(ia->ri_id);
+		if (ia->ri_id->qp) {
+			rdma_destroy_qp(ia->ri_id);
+		}
 		rdma_destroy_id(ia->ri_id);
 		ia->ri_id = id;
 	}
@@ -1557,6 +1561,13 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	frmr_wr.wr.fast_reg.rkey = seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
+	if (!ia->ri_is->qp) {
+		rc = -EINVAL;
+		while (i--)
+			rpcrdma_unmap_one(ia, --seg);
+		goto out;
+	}
+
 	rc = ib_post_send(ia->ri_id->qp, post_wr, &bad_wr);
 
 	if (rc) {
@@ -1571,6 +1582,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 		seg1->mr_len = len;
 	}
 	*nsegs = i;
+out:
 	return rc;
 }
 
@@ -1592,6 +1604,9 @@ rpcrdma_deregister_frmr_external(struct rpcrdma_mr_seg *seg,
 	invalidate_wr.ex.invalidate_rkey = seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
+	if (!ia->ri_id->qp)
+		return -EINVAL;
+
 	rc = ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
 	if (rc)
 		dprintk("RPC:       %s: failed ib_post_send for invalidate,"
@@ -1923,6 +1938,9 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
 		send_wr.send_flags = IB_SEND_SIGNALED;
 	}
 
+	if (!ia->ri_id->qp)
+		return -EINVAL;
+
 	rc = ib_post_send(ia->ri_id->qp, &send_wr, &send_wr_fail);
 	if (rc)
 		dprintk("RPC:       %s: ib_post_send returned %i\n", __func__,
@@ -1951,6 +1969,9 @@ rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
 		rep->rr_iov.addr, rep->rr_iov.length, DMA_BIDIRECTIONAL);
 
 	DECR_CQCOUNT(ep);
+
+	if (!ia->ri_id->qp)
+		return -EINVAL;
 	rc = ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
 
 	if (rc)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
