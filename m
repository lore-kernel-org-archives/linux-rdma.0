From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 20/21] xprtrdma: Remove RPCRDMA_PERSISTENT_REGISTRATION
 macro
Date: Tue, 29 Jul 2014 17:26:04 -0400
Message-ID: <20140729212604.2812.98504.stgit@manet.1015granger.net>
References: <20140729211534.2812.3128.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729211534.2812.3128.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

RPCRDMA_PERSISTENT_REGISTRATION was a compile-time switch between
RPCRDMA_REGISTER mode and RPCRDMA_ALLPHYSICAL mode.  Since
RPCRDMA_REGISTER has been removed, there's no need for the extra
conditional compilation.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/xprtrdma.h |    2 --
 net/sunrpc/xprtrdma/verbs.c     |   13 -------------
 2 files changed, 15 deletions(-)

diff --git a/include/linux/sunrpc/xprtrdma.h b/include/linux/sunrpc/xprtrdma.h
index c2f04e1..64a0a0a 100644
--- a/include/linux/sunrpc/xprtrdma.h
+++ b/include/linux/sunrpc/xprtrdma.h
@@ -62,8 +62,6 @@
 #define RPCRDMA_INLINE_PAD_THRESH  (512)/* payload threshold to pad (bytes) */
 
 /* memory registration strategies */
-#define RPCRDMA_PERSISTENT_REGISTRATION (1)
-
 enum rpcrdma_memreg {
 	RPCRDMA_BOUNCEBUFFERS = 0,
 	RPCRDMA_REGISTER,
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a1b70fc..699e62d 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -561,12 +561,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		if (!ia->ri_id->device->alloc_fmr) {
 			dprintk("RPC:       %s: MTHCAFMR registration "
 				"not supported by HCA\n", __func__);
-#if RPCRDMA_PERSISTENT_REGISTRATION
 			memreg = RPCRDMA_ALLPHYSICAL;
-#else
-			rc = -ENOMEM;
-			goto out2;
-#endif
 		}
 	}
 
@@ -581,20 +576,16 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	switch (memreg) {
 	case RPCRDMA_FRMR:
 		break;
-#if RPCRDMA_PERSISTENT_REGISTRATION
 	case RPCRDMA_ALLPHYSICAL:
 		mem_priv = IB_ACCESS_LOCAL_WRITE |
 				IB_ACCESS_REMOTE_WRITE |
 				IB_ACCESS_REMOTE_READ;
 		goto register_setup;
-#endif
 	case RPCRDMA_MTHCAFMR:
 		if (ia->ri_have_dma_lkey)
 			break;
 		mem_priv = IB_ACCESS_LOCAL_WRITE;
-#if RPCRDMA_PERSISTENT_REGISTRATION
 	register_setup:
-#endif
 		ia->ri_bind_mem = ib_get_dma_mr(ia->ri_pd, mem_priv);
 		if (IS_ERR(ia->ri_bind_mem)) {
 			printk(KERN_ALERT "%s: ib_get_dma_mr for "
@@ -1902,7 +1893,6 @@ rpcrdma_register_external(struct rpcrdma_mr_seg *seg,
 
 	switch (ia->ri_memreg_strategy) {
 
-#if RPCRDMA_PERSISTENT_REGISTRATION
 	case RPCRDMA_ALLPHYSICAL:
 		rpcrdma_map_one(ia, seg, writing);
 		seg->mr_rkey = ia->ri_bind_mem->rkey;
@@ -1910,7 +1900,6 @@ rpcrdma_register_external(struct rpcrdma_mr_seg *seg,
 		seg->mr_nsegs = 1;
 		nsegs = 1;
 		break;
-#endif
 
 	/* Registration using frmr registration */
 	case RPCRDMA_FRMR:
@@ -1940,13 +1929,11 @@ rpcrdma_deregister_external(struct rpcrdma_mr_seg *seg,
 
 	switch (ia->ri_memreg_strategy) {
 
-#if RPCRDMA_PERSISTENT_REGISTRATION
 	case RPCRDMA_ALLPHYSICAL:
 		read_lock(&ia->ri_qplock);
 		rpcrdma_unmap_one(ia, seg);
 		read_unlock(&ia->ri_qplock);
 		break;
-#endif
 
 	case RPCRDMA_FRMR:
 		rc = rpcrdma_deregister_frmr_external(seg, ia, r_xprt);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
