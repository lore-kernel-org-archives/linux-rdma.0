From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/11] xprtrdma: Introduce ro_unmap_sync method
Date: Mon, 30 Nov 2015 17:14:38 -0500
Message-ID: <20151130221438.12235.51061.stgit@manet.1015granger.net>
References: <20151130221349.12235.29565.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151130221349.12235.29565.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the current xprtrdma implementation, some memreg strategies
implement ro_unmap synchronously (the MR is knocked down before the
method returns) and some asynchonously (the MR will be knocked down
and returned to the pool in the background).

To guarantee the MR is truly invalid before the RPC consumer is
allowed to resume execution, we need an unmap method that is
always synchronous, invoked from the RPC/RDMA reply handler.

The new method unmaps all MRs for an RPC. The existing ro_unmap
method unmaps only one MR at a time.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index ca481b2..d2384b5 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -366,6 +366,8 @@ struct rpcrdma_xprt;
 struct rpcrdma_memreg_ops {
 	int		(*ro_map)(struct rpcrdma_xprt *,
 				  struct rpcrdma_mr_seg *, int, bool);
+	void		(*ro_unmap_sync)(struct rpcrdma_xprt *,
+					 struct rpcrdma_req *);
 	int		(*ro_unmap)(struct rpcrdma_xprt *,
 				    struct rpcrdma_mr_seg *);
 	int		(*ro_open)(struct rpcrdma_ia *,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
