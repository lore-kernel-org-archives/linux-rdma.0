From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 02/13] sunrpc: Export xprt_force_disconnect()
Date: Tue, 11 Apr 2017 13:22:38 -0400
Message-ID: <20170411172238.11300.91110.stgit@manet.1015granger.net>
References: <20170411171820.11300.55637.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170411171820.11300.55637.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

xprt_force_disconnect() is already invoked from the socket
transport. I want to invoke xprt_force_disconnect() from the
RPC-over-RDMA transport, which is a separate module from sunrpc.ko.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index b530a28..3e63c5e 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -651,6 +651,7 @@ void xprt_force_disconnect(struct rpc_xprt *xprt)
 	xprt_wake_pending_tasks(xprt, -EAGAIN);
 	spin_unlock_bh(&xprt->transport_lock);
 }
+EXPORT_SYMBOL_GPL(xprt_force_disconnect);
 
 /**
  * xprt_conditional_disconnect - force a transport to disconnect

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
