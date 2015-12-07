From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/6] svcrdma: Define maximum number of backchannel
 requests
Date: Mon, 07 Dec 2015 15:42:48 -0500
Message-ID: <20151207204248.12988.97122.stgit@klimt.1015granger.net>
References: <20151207203851.12988.97804.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207203851.12988.97804.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extra resources for handling backchannel requests have to be
pre-allocated when a transport instance is created. Set a limit.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    2 ++
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   14 +++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 2bb0ff3..f71c625 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -138,6 +138,7 @@ struct svcxprt_rdma {
 
 	int                  sc_max_requests;	/* Depth of RQ */
 	int                  sc_max_req_size;	/* Size of each RQ WR buf */
+	int                  sc_max_bc_requests;
 
 	struct ib_pd         *sc_pd;
 
@@ -182,6 +183,7 @@ struct svcxprt_rdma {
 #define RPCRDMA_SQ_DEPTH_MULT   8
 #define RPCRDMA_MAX_REQUESTS    32
 #define RPCRDMA_MAX_REQ_SIZE    4096
+#define RPCRDMA_MAX_BC_REQUESTS	2
 
 #define RPCSVC_MAXPAYLOAD_RDMA	RPCSVC_MAXPAYLOAD
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index ede88f3..ed5dd93 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -566,6 +566,7 @@ static struct svcxprt_rdma *rdma_create_xprt(struct svc_serv *serv,
 
 	cma_xprt->sc_max_req_size = svcrdma_max_req_size;
 	cma_xprt->sc_max_requests = svcrdma_max_requests;
+	cma_xprt->sc_max_bc_requests = RPCRDMA_MAX_BC_REQUESTS;
 	cma_xprt->sc_sq_depth = svcrdma_max_requests * RPCRDMA_SQ_DEPTH_MULT;
 	atomic_set(&cma_xprt->sc_sq_count, 0);
 	atomic_set(&cma_xprt->sc_ctxt_used, 0);
@@ -922,6 +923,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct ib_device_attr devattr;
 	int uninitialized_var(dma_mr_acc);
 	int need_dma_mr = 0;
+	int total_reqs;
 	int ret;
 	int i;
 
@@ -957,8 +959,10 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_sge_rd = min_t(size_t, devattr.max_sge_rd,
 				       RPCSVC_MAXPAGES);
 	newxprt->sc_max_requests = min((size_t)devattr.max_qp_wr,
-				   (size_t)svcrdma_max_requests);
-	newxprt->sc_sq_depth = RPCRDMA_SQ_DEPTH_MULT * newxprt->sc_max_requests;
+				       (size_t)svcrdma_max_requests);
+	newxprt->sc_max_bc_requests = RPCRDMA_MAX_BC_REQUESTS;
+	total_reqs = newxprt->sc_max_requests + newxprt->sc_max_bc_requests;
+	newxprt->sc_sq_depth = total_reqs * RPCRDMA_SQ_DEPTH_MULT;
 
 	for (i = newxprt->sc_sq_depth; i; i--) {
 		struct svc_rdma_op_ctxt *ctxt;
@@ -997,7 +1001,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		dprintk("svcrdma: error creating SQ CQ for connect request\n");
 		goto errout;
 	}
-	cq_attr.cqe = newxprt->sc_max_requests;
+	cq_attr.cqe = total_reqs;
 	newxprt->sc_rq_cq = ib_create_cq(newxprt->sc_cm_id->device,
 					 rq_comp_handler,
 					 cq_event_handler,
@@ -1012,7 +1016,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	qp_attr.event_handler = qp_event_handler;
 	qp_attr.qp_context = &newxprt->sc_xprt;
 	qp_attr.cap.max_send_wr = newxprt->sc_sq_depth;
-	qp_attr.cap.max_recv_wr = newxprt->sc_max_requests;
+	qp_attr.cap.max_recv_wr = total_reqs;
 	qp_attr.cap.max_send_sge = newxprt->sc_max_sge;
 	qp_attr.cap.max_recv_sge = newxprt->sc_max_sge;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
@@ -1108,7 +1112,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 			newxprt->sc_cm_id->device->local_dma_lkey;
 
 	/* Post receive buffers */
-	for (i = 0; i < newxprt->sc_max_requests; i++) {
+	for (i = 0; i < total_reqs; i++) {
 		ret = svc_rdma_post_recv(newxprt);
 		if (ret) {
 			dprintk("svcrdma: failure posting receive buffers\n");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
