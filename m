From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 06/12] xprtrdma: Avoid calls to ro_unmap_safe()
Date: Fri, 18 Nov 2016 09:59:44 -0500
Message-ID: <20161118145944.10592.47236.stgit@manet.1015granger.net>
References: <20161118145547.10592.66470.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161118145547.10592.66470.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Micro-optimization: Most of the time, calls to ro_unmap_safe are
expensive no-ops. Call only when there is work to do.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index ed5e285..545d3fc 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -621,7 +621,8 @@
 
 	dprintk("RPC:       %s: called on 0x%p\n", __func__, req->rl_reply);
 
-	ia->ri_ops->ro_unmap_safe(r_xprt, req, !RPC_IS_ASYNC(task));
+	if (unlikely(!list_empty(&req->rl_registered)))
+		ia->ri_ops->ro_unmap_safe(r_xprt, req, !RPC_IS_ASYNC(task));
 	rpcrdma_unmap_sges(ia, req);
 	rpcrdma_buffer_put(req);
 }
@@ -657,7 +658,8 @@
 	int rc = 0;
 
 	/* On retransmit, remove any previously registered chunks */
-	r_xprt->rx_ia.ri_ops->ro_unmap_safe(r_xprt, req, false);
+	if (unlikely(!list_empty(&req->rl_registered)))
+		r_xprt->rx_ia.ri_ops->ro_unmap_safe(r_xprt, req, false);
 
 	rc = rpcrdma_marshal_req(rqst);
 	if (rc < 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
