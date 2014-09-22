From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] svcrdma: Advertise the correct max payload
Date: Mon, 22 Sep 2014 13:36:53 -0500
Message-ID: <20140922183653.19376.14276.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Svcrdma currently advertises 1MB, which is too large.  The correct value
is the max scatter-gather allowed in an NFSRDMA IO chunk * the host page
size. This bug is usually benign because the Linux X64 NFSRDMA client
correctly limits the payload size to the correct value (64*4096 = 256KB).
But if the Linux client is PPC64 with a 64KB page size, then the client
will indeed use a payload size that will overflow the server.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h          |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

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
index c419498..467a77c 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -392,4 +392,6 @@ extern struct kmem_cache *svc_rdma_ctxt_cachep;
 /* Workqueue created in svc_rdma.c */
 extern struct workqueue_struct *svc_rdma_wq;
 
+#define RPCSVC_MAXPAYLOAD_RDMA	(RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT)
+
 #endif				/* _LINUX_SUNRPC_XPRT_RDMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
