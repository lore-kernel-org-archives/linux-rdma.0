From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/3] xprtrdma: Use ro_unmap_sync in xprt_rdma_send_request
Date: Mon, 09 Oct 2017 12:03:34 -0400
Message-ID: <20171009160334.18726.33163.stgit@manet.1015granger.net>
References: <20171009155524.18726.32086.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009155524.18726.32086.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The "safe" version of ro_unmap is used here to avoid waiting
unnecessarily. However:

 - It is safe to wait. After all, we have to wait anyway when using
   FMR to register memory.

 - This case is rare: it occurs only after a reconnect.

By switching this call site to ro_unmap_sync, the final use of
ro_unmap_safe is removed.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 8cf5ccf..eb46d24 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -728,7 +728,8 @@
 
 	/* On retransmit, remove any previously registered chunks */
 	if (unlikely(!list_empty(&req->rl_registered)))
-		r_xprt->rx_ia.ri_ops->ro_unmap_safe(r_xprt, req, false);
+		r_xprt->rx_ia.ri_ops->ro_unmap_sync(r_xprt,
+						    &req->rl_registered);
 
 	rc = rpcrdma_marshal_req(r_xprt, rqst);
 	if (rc < 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
