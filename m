From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 13/13] xprtrdma: Remove rpcrdma_buffer::rb_pool
Date: Mon, 27 Mar 2017 10:07:20 -0400
Message-ID: <20170327140720.20813.3528.stgit@manet.1015granger.net>
References: <20170327134847.20813.52412.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170327134847.20813.52412.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since commit 1e465fd4ff47 ("xprtrdma: Replace send and receive
arrays"), this field is no longer used.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 1c5de1a..1d66acf 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -391,7 +391,6 @@ struct rpcrdma_buffer {
 	spinlock_t		rb_mwlock;	/* protect rb_mws list */
 	struct list_head	rb_mws;
 	struct list_head	rb_all;
-	char			*rb_pool;
 
 	spinlock_t		rb_lock;	/* protect buf lists */
 	int			rb_send_count, rb_recv_count;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
