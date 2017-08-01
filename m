From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 1/3] svcrdma: Limit RQ depth
Date: Tue, 01 Aug 2017 17:06:59 -0400
Message-ID: <20170801210659.15781.22769.stgit@klimt.1015granger.net>
References: <20170801205334.15781.18761.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801205334.15781.18761.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ensure that the chosen Receive Queue depth for a newly created
transport does not overrun the QP WR limit of the underlying device.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 2aa8473..cdb04f8 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -167,8 +167,8 @@ static bool svc_rdma_prealloc_ctxts(struct svcxprt_rdma *xprt)
 {
 	unsigned int i;
 
-	/* Each RPC/RDMA credit can consume a number of send
-	 * and receive WQEs. One ctxt is allocated for each.
+	/* Each RPC/RDMA credit can consume one Receive and
+	 * one Send WQE at the same time.
 	 */
 	i = xprt->sc_sq_depth + xprt->sc_rq_depth;
 
@@ -742,13 +742,18 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_sge = min((size_t)dev->attrs.max_sge,
 				  (size_t)RPCSVC_MAXPAGES);
 	newxprt->sc_max_req_size = svcrdma_max_req_size;
-	newxprt->sc_max_requests = min_t(u32, dev->attrs.max_qp_wr,
-					 svcrdma_max_requests);
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
-	newxprt->sc_max_bc_requests = min_t(u32, dev->attrs.max_qp_wr,
-					    svcrdma_max_bc_requests);
+	newxprt->sc_max_requests = svcrdma_max_requests;
+	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_rq_depth = newxprt->sc_max_requests +
 			       newxprt->sc_max_bc_requests;
+	if (newxprt->sc_rq_depth > dev->attrs.max_qp_wr) {
+		pr_warn("svcrdma: reducing receive depth to %d\n",
+			dev->attrs.max_qp_wr);
+		newxprt->sc_rq_depth = dev->attrs.max_qp_wr;
+		newxprt->sc_max_requests = newxprt->sc_rq_depth - 2;
+		newxprt->sc_max_bc_requests = 2;
+	}
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 	newxprt->sc_sq_depth = newxprt->sc_rq_depth;
 	atomic_set(&newxprt->sc_sq_avail, newxprt->sc_sq_depth);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
