From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V3] svcrdma: advertise the correct max payload
Date: Tue, 23 Sep 2014 17:11:22 -0500
Message-ID: <20140923221122.24227.91718.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Svcrdma currently advertises 1MB, which is too large.  The correct value
is the minimum of RPCSVC_MAXPAYLOAD and the max scatter-gather allowed
in an NFSRDMA IO chunk * the host page size. This bug is usually benign
because the Linux X64 NFSRDMA client correctly limits the payload size to
the correct value (64*4096 = 256KB).  But if the Linux client is PPC64
with a 64KB page size, then the client will indeed use a payload size
that will overflow the server.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h          |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 374feb4..4e61880 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -91,7 +91,7 @@ struct svc_xprt_class svc_rdma_class = {
 	.xcl_name = "rdma",
 	.xcl_owner = THIS_MODULE,
 	.xcl_ops = &svc_rdma_ops,
-	.xcl_max_payload = RPCSVC_MAXPAYLOAD_TCP,
+	.xcl_max_payload = RPCSVC_MAXPAYLOAD_RDMA,
 	.xcl_ident = XPRT_TRANSPORT_RDMA,
 };
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index c419498..ac7fc9a 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -51,6 +51,7 @@
 #include <linux/sunrpc/clnt.h> 		/* rpc_xprt */
 #include <linux/sunrpc/rpc_rdma.h> 	/* RPC/RDMA protocol */
 #include <linux/sunrpc/xprtrdma.h> 	/* xprt parameters */
+#include <linux/sunrpc/svc.h>		/* RPCSVC_MAXPAYLOAD */
 
 #define RDMA_RESOLVE_TIMEOUT	(5000)	/* 5 seconds */
 #define RDMA_CONNECT_RETRY_MAX	(2)	/* retries if no listener backlog */
@@ -392,4 +393,10 @@ extern struct kmem_cache *svc_rdma_ctxt_cachep;
 /* Workqueue created in svc_rdma.c */
 extern struct workqueue_struct *svc_rdma_wq;
 
+#if RPCSVC_MAXPAYLOAD < (RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT)
+#define RPCSVC_MAXPAYLOAD_RDMA RPCSVC_MAXPAYLOAD
+#else
+#define RPCSVC_MAXPAYLOAD_RDMA (RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT)
+#endif
+
 #endif				/* _LINUX_SUNRPC_XPRT_RDMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
