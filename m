From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 01/10] svcrdma: Clean up rdma_create_xprt()
Date: Thu, 07 Jan 2016 14:48:55 -0500
Message-ID: <20160107194855.2662.37386.stgit@klimt.1015granger.net>
References: <20160107194251.2662.88158.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160107194251.2662.88158.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

kzalloc is used here, so setting the atomic fields to zero is
unnecessary. sc_ord is set again in handle_connect_req. The other
fields are re-initialized in svc_rdma_accept().

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 4d695af..45d1824 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -529,14 +529,6 @@ static struct svcxprt_rdma *rdma_create_xprt(struct svc_serv *serv,
 	spin_lock_init(&cma_xprt->sc_rq_dto_lock);
 	spin_lock_init(&cma_xprt->sc_frmr_q_lock);
 
-	cma_xprt->sc_ord = svcrdma_ord;
-
-	cma_xprt->sc_max_req_size = svcrdma_max_req_size;
-	cma_xprt->sc_max_requests = svcrdma_max_requests;
-	cma_xprt->sc_sq_depth = svcrdma_max_requests * RPCRDMA_SQ_DEPTH_MULT;
-	atomic_set(&cma_xprt->sc_sq_count, 0);
-	atomic_set(&cma_xprt->sc_ctxt_used, 0);
-
 	if (listener)
 		set_bit(XPT_LISTENER, &cma_xprt->sc_xprt.xpt_flags);
 
@@ -918,6 +910,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 				  (size_t)RPCSVC_MAXPAGES);
 	newxprt->sc_max_sge_rd = min_t(size_t, dev->attrs.max_sge_rd,
 				       RPCSVC_MAXPAGES);
+	newxprt->sc_max_req_size = svcrdma_max_req_size;
 	newxprt->sc_max_requests = min((size_t)dev->attrs.max_qp_wr,
 				   (size_t)svcrdma_max_requests);
 	newxprt->sc_sq_depth = RPCRDMA_SQ_DEPTH_MULT * newxprt->sc_max_requests;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
