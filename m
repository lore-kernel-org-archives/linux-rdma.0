From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/3] xprtrdma: disconnect and flush cqs before freeing buffers
Date: Mon, 21 Sep 2015 12:24:23 -0500
Message-ID: <20150921172423.9761.92399.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Otherwise a FRMR completion can cause a touch-after-free crash.

In xprt_rdma_destroy(), call rpcrdma_buffer_destroy() only after calling
rpcrdma_ep_destroy().

In rpcrdma_ep_destroy(), disconnect the cm_id first which should flush the
qp, then drain the cqs, then destroy the qp, and finally destroy the cqs.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/transport.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c     |    9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 64443eb..41e452b 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -270,8 +270,8 @@ xprt_rdma_destroy(struct rpc_xprt *xprt)
 
 	xprt_clear_connected(xprt);
 
-	rpcrdma_buffer_destroy(&r_xprt->rx_buf);
 	rpcrdma_ep_destroy(&r_xprt->rx_ep, &r_xprt->rx_ia);
+	rpcrdma_buffer_destroy(&r_xprt->rx_buf);
 	rpcrdma_ia_close(&r_xprt->rx_ia);
 
 	xprt_rdma_free_addresses(xprt);
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 6829967..01a314a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -755,19 +755,22 @@ rpcrdma_ep_destroy(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 
 	cancel_delayed_work_sync(&ep->rep_connect_worker);
 
-	if (ia->ri_id->qp) {
+	if (ia->ri_id->qp)
 		rpcrdma_ep_disconnect(ep, ia);
+
+	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
+	rpcrdma_clean_cq(ep->rep_attr.send_cq);
+
+	if (ia->ri_id->qp) {
 		rdma_destroy_qp(ia->ri_id);
 		ia->ri_id->qp = NULL;
 	}
 
-	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
 	rc = ib_destroy_cq(ep->rep_attr.recv_cq);
 	if (rc)
 		dprintk("RPC:       %s: ib_destroy_cq returned %i\n",
 			__func__, rc);
 
-	rpcrdma_clean_cq(ep->rep_attr.send_cq);
 	rc = ib_destroy_cq(ep->rep_attr.send_cq);
 	if (rc)
 		dprintk("RPC:       %s: ib_destroy_cq returned %i\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
