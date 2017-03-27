From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 10/13] xprtrdma: Annotate receive workqueue
Date: Mon, 27 Mar 2017 10:06:56 -0400
Message-ID: <20170327140656.20813.45323.stgit@manet.1015granger.net>
References: <20170327134847.20813.52412.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170327134847.20813.52412.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Micro-optimize the receive workqueue by marking it's anchor "read-
mostly."

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index d7c1600..3dbce9a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -73,7 +73,7 @@
 static void rpcrdma_destroy_mrs(struct rpcrdma_buffer *buf);
 static void rpcrdma_dma_unmap_regbuf(struct rpcrdma_regbuf *rb);
 
-static struct workqueue_struct *rpcrdma_receive_wq;
+static struct workqueue_struct *rpcrdma_receive_wq __read_mostly;
 
 int
 rpcrdma_alloc_wq(void)

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
