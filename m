From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 08/17] xprtrdma: Fall back to MTHCAFMR when FRMR is not
	supported
Date: Mon, 21 Apr 2014 18:01:56 -0400
Message-ID: <20140421220156.12569.83037.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An audit of in-kernel RDMA providers that do not support the FRMR
memory registration shows that several of them support MTHCAFMR.
Prefer MTHCAFMR when FRMR is not supported.

If MTHCAFMR is not supported, only then choose ALLPHYSICAL.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/verbs.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 6bb9a07..a352798 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -491,33 +491,32 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		ia->ri_dma_lkey = ia->ri_id->device->local_dma_lkey;
 	}
 
-	switch (memreg) {
-	case RPCRDMA_MTHCAFMR:
-		if (!ia->ri_id->device->alloc_fmr) {
-			dprintk("RPC:       %s: MTHCAFMR registration "
-				"specified but not supported by adapter, "
-				"using riskier RPCRDMA_ALLPHYSICAL\n",
-				__func__);
-			memreg = RPCRDMA_ALLPHYSICAL;
-		}
-		break;
-	case RPCRDMA_FRMR:
+	if (memreg == RPCRDMA_FRMR) {
 		/* Requires both frmr reg and local dma lkey */
 		if ((devattr.device_cap_flags &
 		     (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) !=
 		    (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) {
 			dprintk("RPC:       %s: FRMR registration "
-				"specified but not supported by adapter, "
-				"using riskier RPCRDMA_ALLPHYSICAL\n",
-				__func__);
-			memreg = RPCRDMA_ALLPHYSICAL;
+				"not supported by HCA\n", __func__);
+			memreg = RPCRDMA_MTHCAFMR;
 		} else {
 			/* Mind the ia limit on FRMR page list depth */
 			ia->ri_max_frmr_depth = min_t(unsigned int,
 				RPCRDMA_MAX_DATA_SEGS,
 				devattr.max_fast_reg_page_list_len);
 		}
-		break;
+	}
+	if (memreg == RPCRDMA_MTHCAFMR) {
+		if (!ia->ri_id->device->alloc_fmr) {
+			dprintk("RPC:       %s: MTHCAFMR registration "
+				"not supported by HCA\n", __func__);
+#if RPCRDMA_PERSISTENT_REGISTRATION
+			memreg = RPCRDMA_ALLPHYSICAL;
+#else
+			rc = -EINVAL;
+			goto out2;
+#endif
+		}
 	}
 
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
