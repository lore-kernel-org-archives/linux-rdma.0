From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 09/16] xprtrdma: Support IPv6 in xprt_rdma_set_port
Date: Thu, 14 Dec 2017 20:57:06 -0500
Message-ID: <20171215015706.13776.10025.stgit@manet.1015granger.net>
References: <20171215015403.13776.46706.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171215015403.13776.46706.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up a harmless oversight. xprtrdma's ->set_port method has
never properly supported IPv6.

This issue has never been a problem because NFS/RDMA mounts have
always required "port=20049", thus so far, rpcbind is not invoked
for these mounts.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 8ba0aa8..cebcd02 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -474,14 +474,34 @@
 	rpcrdma_ep_disconnect(ep, ia);
 }
 
+/**
+ * xprt_rdma_set_port - update server port with rpcbind result
+ * @xprt: controlling RPC transport
+ * @port: new port value
+ *
+ * Transport connect status is unchanged.
+ */
 static void
 xprt_rdma_set_port(struct rpc_xprt *xprt, u16 port)
 {
-	struct sockaddr_in *sap;
+	struct sockaddr *sap = (struct sockaddr *)&xprt->addr;
+	char buf[8];
+
+	dprintk("RPC:       %s: setting port for xprt %p (%s:%s) to %u\n",
+		__func__, xprt,
+		xprt->address_strings[RPC_DISPLAY_ADDR],
+		xprt->address_strings[RPC_DISPLAY_PORT],
+		port);
+
+	rpc_set_port(sap, port);
 
-	sap = (struct sockaddr_in *)&xprt->addr;
-	sap->sin_port = htons(port);
-	dprintk("RPC:       %s: %u\n", __func__, port);
+	kfree(xprt->address_strings[RPC_DISPLAY_PORT]);
+	snprintf(buf, sizeof(buf), "%u", port);
+	xprt->address_strings[RPC_DISPLAY_PORT] = kstrdup(buf, GFP_KERNEL);
+
+	kfree(xprt->address_strings[RPC_DISPLAY_HEX_PORT]);
+	snprintf(buf, sizeof(buf), "%4hx", port);
+	xprt->address_strings[RPC_DISPLAY_HEX_PORT] = kstrdup(buf, GFP_KERNEL);
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
