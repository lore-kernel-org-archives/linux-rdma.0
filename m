From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC] xprtrdma: Fail quickly if proto=rdma not supported
Date: Mon, 30 Oct 2017 16:45:15 -0400
Message-ID: <20171030202930.8929.36866.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rpcrdma_conn_upcall() converts RDMA CM connection events into
errnos:

  RDMA_CM_EVENT_ADDR_ERROR  -> EHOSTUNREACH

  RDMA_CM_EVENT_ROUTE_ERROR -> ENETUNREACH

  RDMA_CM_EVENT_UNREACHABLE  -> ENETDOWN

mount.nfs seems to want to retry EHOSTUNREACH and friends forever.
This makes mount.nfs appear to hang if I try to mount with
proto=rdma via a conventional Ethernet device.

If the admin has specified proto=rdma along with a server IP address
that requires a local interface or network path that does not
support RDMA, fail immediately with a permanent error during
transport set up.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Hi all-

I'm probably confused about when certain connection events fire.

I'd like to ensure that the RPC-over-RDMA client implementation
can very quickly detect when RDMA can't be supported so that it
can fall back to trying TCP (IPoIB) or reporting a problem.


diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 68ab522..5f534ba 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -396,12 +396,18 @@
 	new_xprt = rpcx_to_rdmax(xprt);
 
 	rc = rpcrdma_ia_open(new_xprt, sap);
-	if (rc)
+	switch (rc) {
+	case 0:
+		break;
+	case -ENETDOWN:
+	case -EHOSTUNREACH:
+	case -ENETUNREACH:
+		rc = -EINVAL;
+		/* fall through */
+	default:
 		goto out1;
+	}
 
-	/*
-	 * initialize and create ep
-	 */
 	new_xprt->rx_data = cdata;
 	new_ep = &new_xprt->rx_ep;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
