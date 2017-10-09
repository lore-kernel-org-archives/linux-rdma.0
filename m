From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/3] xprtrdma: Don't defer fencing an async RPC's chunks
Date: Mon, 09 Oct 2017 12:03:26 -0400
Message-ID: <20171009160326.18726.9300.stgit@manet.1015granger.net>
References: <20171009155524.18726.32086.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009155524.18726.32086.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In current kernels, waiting in xprt_release appears to be safe to
do. I had erroneously believed that for ASYNC RPCs, waiting of any
kind in xprt_release->xprt_rdma_free would result in deadlock. I've
done injection testing and consulted with Trond to confirm that
waiting in the RPC release path is safe.

For the very few times where RPC resources haven't yet been released
earlier by the reply handler, it is safe to wait synchronously in
xprt_rdma_free for invalidation rather than defering it to MR
recovery.

Note: When the QP is error state, posting a LocalInvalidate should
flush and mark the MR as bad. There is no way the remote HCA can
access that MR via a QP in error state, so it is effectively already
inaccessible and thus safe for the Upper Layer to access. The next
time the MR is used it should be recognized and cleaned up properly
by frwr_op_map.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index c84e2b6..8cf5ccf 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -686,7 +686,7 @@
 	dprintk("RPC:       %s: called on 0x%p\n", __func__, req->rl_reply);
 
 	if (!list_empty(&req->rl_registered))
-		ia->ri_ops->ro_unmap_safe(r_xprt, req, !RPC_IS_ASYNC(task));
+		ia->ri_ops->ro_unmap_sync(r_xprt, &req->rl_registered);
 	rpcrdma_unmap_sges(ia, req);
 	rpcrdma_buffer_put(req);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
