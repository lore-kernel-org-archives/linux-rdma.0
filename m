From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 10/20] xprtrdma: Free the pd if ib_query_qp() fails
Date: Tue, 13 Jan 2015 11:26:06 -0500
Message-ID: <20150113162606.14086.7193.stgit@manet.1015granger.net>
References: <20150113161440.14086.24801.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113161440.14086.24801.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If ib_query_qp() fails or the memory registration mode isn't
supported, don't leak the PD. An orphaned IB/core resource will
cause IB module removal to hang.

Fixes: bd7ed1d13304 ("RPC/RDMA: check selected memory registration ...")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index c61bb61..aa012a3 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -614,7 +614,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	if (rc) {
 		dprintk("RPC:       %s: ib_query_device failed %d\n",
 			__func__, rc);
-		goto out2;
+		goto out3;
 	}
 
 	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
@@ -672,14 +672,14 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 				"phys register failed with %lX\n",
 				__func__, PTR_ERR(ia->ri_bind_mem));
 			rc = -ENOMEM;
-			goto out2;
+			goto out3;
 		}
 		break;
 	default:
 		printk(KERN_ERR "RPC: Unsupported memory "
 				"registration mode: %d\n", memreg);
 		rc = -ENOMEM;
-		goto out2;
+		goto out3;
 	}
 	dprintk("RPC:       %s: memory registration strategy is %d\n",
 		__func__, memreg);
@@ -689,6 +689,10 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 
 	rwlock_init(&ia->ri_qplock);
 	return 0;
+
+out3:
+	ib_dealloc_pd(ia->ri_pd);
+	ia->ri_pd = NULL;
 out2:
 	rdma_destroy_id(ia->ri_id);
 	ia->ri_id = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
