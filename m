From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 10/24] xprtrdma: Clean up device capability detection
Date: Wed, 29 Jun 2016 13:53:27 -0400
Message-ID: <20160629175327.15094.30754.stgit@manet.1015granger.net>
References: <20160629173231.15094.52660.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629173231.15094.52660.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Move device capability detection into memreg-specific
source files.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c   |   11 ++++++++++
 net/sunrpc/xprtrdma/frwr_ops.c  |   17 +++++++++++++++
 net/sunrpc/xprtrdma/verbs.c     |   43 +++++++++++++--------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 ++
 4 files changed, 44 insertions(+), 29 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 6c4527b..8b6ce8e 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -34,6 +34,17 @@ enum {
 					  IB_ACCESS_REMOTE_READ,
 };
 
+bool
+fmr_is_supported(struct rpcrdma_ia *ia)
+{
+	if (!ia->ri_device->alloc_fmr) {
+		pr_info("rpcrdma: 'fmr' mode is not supported by device %s\n",
+			ia->ri_device->name);
+		return false;
+	}
+	return true;
+}
+
 static int
 __fmr_init(struct rpcrdma_mw *mw, struct ib_pd *pd)
 {
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index c9ead2b..fc2826b 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -73,6 +73,23 @@
 # define RPCDBG_FACILITY	RPCDBG_TRANS
 #endif
 
+bool
+frwr_is_supported(struct rpcrdma_ia *ia)
+{
+	struct ib_device_attr *attrs = &ia->ri_device->attrs;
+
+	if (!(attrs->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
+		goto out_not_supported;
+	if (attrs->max_fast_reg_page_list_len == 0)
+		goto out_not_supported;
+	return true;
+
+out_not_supported:
+	pr_info("rpcrdma: 'frwr' mode is not supported by device %s\n",
+		ia->ri_device->name);
+	return false;
+}
+
 static int
 __frwr_init(struct rpcrdma_mw *r, struct ib_pd *pd, unsigned int depth)
 {
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index b80e767f..cd4c5f1 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -389,44 +389,29 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	ia->ri_pd = ib_alloc_pd(ia->ri_device);
 	if (IS_ERR(ia->ri_pd)) {
 		rc = PTR_ERR(ia->ri_pd);
-		dprintk("RPC:       %s: ib_alloc_pd() failed %i\n",
-			__func__, rc);
+		pr_err("rpcrdma: ib_alloc_pd() returned %d\n", rc);
 		goto out2;
 	}
 
-	if (memreg == RPCRDMA_FRMR) {
-		if (!(ia->ri_device->attrs.device_cap_flags &
-				IB_DEVICE_MEM_MGT_EXTENSIONS) ||
-		    (ia->ri_device->attrs.max_fast_reg_page_list_len == 0)) {
-			dprintk("RPC:       %s: FRMR registration "
-				"not supported by HCA\n", __func__);
-			memreg = RPCRDMA_MTHCAFMR;
-		}
-	}
-	if (memreg == RPCRDMA_MTHCAFMR) {
-		if (!ia->ri_device->alloc_fmr) {
-			dprintk("RPC:       %s: MTHCAFMR registration "
-				"not supported by HCA\n", __func__);
-			rc = -EINVAL;
-			goto out3;
-		}
-	}
-
 	switch (memreg) {
 	case RPCRDMA_FRMR:
-		ia->ri_ops = &rpcrdma_frwr_memreg_ops;
-		break;
+		if (frwr_is_supported(ia)) {
+			ia->ri_ops = &rpcrdma_frwr_memreg_ops;
+			break;
+		}
+		/*FALLTHROUGH*/
 	case RPCRDMA_MTHCAFMR:
-		ia->ri_ops = &rpcrdma_fmr_memreg_ops;
-		break;
+		if (fmr_is_supported(ia)) {
+			ia->ri_ops = &rpcrdma_fmr_memreg_ops;
+			break;
+		}
+		/*FALLTHROUGH*/
 	default:
-		printk(KERN_ERR "RPC: Unsupported memory "
-				"registration mode: %d\n", memreg);
-		rc = -ENOMEM;
+		pr_err("rpcrdma: Unsupported memory registration mode: %d\n",
+		       memreg);
+		rc = -EINVAL;
 		goto out3;
 	}
-	dprintk("RPC:       %s: memory registration strategy is '%s'\n",
-		__func__, ia->ri_ops->ro_displayname);
 
 	return 0;
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index f1b6f2f..08d441d 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -446,6 +446,8 @@ extern int xprt_rdma_pad_optimize;
  */
 int rpcrdma_ia_open(struct rpcrdma_xprt *, struct sockaddr *, int);
 void rpcrdma_ia_close(struct rpcrdma_ia *);
+bool frwr_is_supported(struct rpcrdma_ia *);
+bool fmr_is_supported(struct rpcrdma_ia *);
 
 /*
  * Endpoint calls - xprtrdma/verbs.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
