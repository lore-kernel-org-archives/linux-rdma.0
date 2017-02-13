From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 9/9] sunrpc: Allow xprt->ops->timer method to sleep
Date: Mon, 13 Feb 2017 11:57:34 -0500
Message-ID: <20170213165734.15801.736.stgit@manet.1015granger.net>
References: <20170213163936.15801.31225.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170213163936.15801.31225.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The transport lock is needed to protect the xprt_adjust_cwnd() call
in xs_udp_timer, but it is not necessary for accessing the
rq_reply_bytes_recvd or tk_status fields. It is correct to sublimate
the lock into UDP's xs_udp_timer method, where it is required.

The ->timer method has to take the transport lock if needed, but it
can now sleep safely, or even call back into the RPC scheduler.

This is more a clean-up than a fix, but the "issue" was introduced
by my transport switch patches back in 2005.

Fixes: 46c0ee8bc4ad ("RPC: separate xprt_timer implementations")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprt.c     |    2 --
 net/sunrpc/xprtsock.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 9a6be03..b530a28 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -897,13 +897,11 @@ static void xprt_timer(struct rpc_task *task)
 		return;
 	dprintk("RPC: %5u xprt_timer\n", task->tk_pid);
 
-	spin_lock_bh(&xprt->transport_lock);
 	if (!req->rq_reply_bytes_recvd) {
 		if (xprt->ops->timer)
 			xprt->ops->timer(xprt, task);
 	} else
 		task->tk_status = 0;
-	spin_unlock_bh(&xprt->transport_lock);
 }
 
 /**
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index af392d9..d9bb644 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1734,7 +1734,9 @@ static void xs_udp_set_buffer_size(struct rpc_xprt *xprt, size_t sndsize, size_t
  */
 static void xs_udp_timer(struct rpc_xprt *xprt, struct rpc_task *task)
 {
+	spin_lock_bh(&xprt->transport_lock);
 	xprt_adjust_cwnd(xprt, task, -ETIMEDOUT);
+	spin_unlock_bh(&xprt->transport_lock);
 }
 
 static unsigned short xs_get_random_port(void)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
