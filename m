From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 10/12] xprtrdma: Shorten QP access error message
Date: Tue, 29 Nov 2016 10:53:21 -0500
Message-ID: <20161129155321.23061.56897.stgit@manet.1015granger.net>
References: <20161129154845.23061.29385.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129154845.23061.29385.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: The convention for this type of warning message is not to
show the function name or "RPC:       ".

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 9f66fd8..11d0774 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -103,9 +103,9 @@
 {
 	struct rpcrdma_ep *ep = context;
 
-	pr_err("RPC:       %s: %s on device %s ep %p\n",
-	       __func__, ib_event_msg(event->event),
-		event->device->name, context);
+	pr_err("rpcrdma: %s on device %s ep %p\n",
+	       ib_event_msg(event->event), event->device->name, context);
+
 	if (ep->rep_connected == 1) {
 		ep->rep_connected = -EIO;
 		rpcrdma_conn_func(ep);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
