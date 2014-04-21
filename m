From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 10/17] xprtrdma: Add CONFIG setting that can disable
	ALLPHYSICAL
Date: Mon, 21 Apr 2014 18:02:14 -0400
Message-ID: <20140421220214.12569.23157.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ALLPHYSICAL is not a safe memory registration mode because it
permits NFS servers to write anywhere in a client's memory.  NFS
server bugs could result in client memory being overwritten.

This can be useful for embedded systems which do not support more
surgical RDMA memory registration and protection methods, or for
bring-up of new HCA hardware.

However, enterprise Linux distributions have expressed a desire to
disable it in production environments.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 include/linux/sunrpc/xprtrdma.h |    2 --
 net/sunrpc/Kconfig              |   14 ++++++++++++++
 net/sunrpc/xprtrdma/verbs.c     |   10 +++++-----
 3 files changed, 19 insertions(+), 7 deletions(-)

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
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 0754d0f..c9a736e 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -58,6 +58,20 @@ config SUNRPC_XPRT_RDMA_CLIENT
 
 	  If unsure, say N.
 
+config SUNRPC_XPRT_RDMA_CLIENT_ALLPHYSICAL
+	bool "Enable ALLPHYSICAL memory registration mode"
+	depends on SUNRPC_XPRT_RDMA_CLIENT
+	default y
+	help
+	  This option enables support for the ALLPHYSICAL memory
+	  registration mode.
+
+	  This mode is very fast but not safe because it registers
+	  and exposes all of local memory. This could allow an
+	  NFS server bug to corrupt client memory.
+
+	  If unsure, say Y.
+
 config SUNRPC_XPRT_RDMA_SERVER
 	tristate "RPC over RDMA Server Support"
 	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 35dcd10..9b71896 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -510,7 +510,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		if (!ia->ri_id->device->alloc_fmr) {
 			dprintk("RPC:       %s: MTHCAFMR registration "
 				"not supported by HCA\n", __func__);
-#if RPCRDMA_PERSISTENT_REGISTRATION
+#ifdef CONFIG_SUNRPC_XPRT_RDMA_CLIENT_ALLPHYSICAL
 			memreg = RPCRDMA_ALLPHYSICAL;
 #else
 			rc = -ENOMEM;
@@ -530,7 +530,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	switch (memreg) {
 	case RPCRDMA_FRMR:
 		break;
-#if RPCRDMA_PERSISTENT_REGISTRATION
+#ifdef CONFIG_SUNRPC_XPRT_RDMA_CLIENT_ALLPHYSICAL
 	case RPCRDMA_ALLPHYSICAL:
 		mem_priv = IB_ACCESS_LOCAL_WRITE |
 				IB_ACCESS_REMOTE_WRITE |
@@ -541,7 +541,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		if (ia->ri_have_dma_lkey)
 			break;
 		mem_priv = IB_ACCESS_LOCAL_WRITE;
-#if RPCRDMA_PERSISTENT_REGISTRATION
+#ifdef CONFIG_SUNRPC_XPRT_RDMA_CLIENT_ALLPHYSICAL
 	register_setup:
 #endif
 		ia->ri_bind_mem = ib_get_dma_mr(ia->ri_pd, mem_priv);
@@ -1601,7 +1601,7 @@ rpcrdma_register_external(struct rpcrdma_mr_seg *seg,
 
 	switch (ia->ri_memreg_strategy) {
 
-#if RPCRDMA_PERSISTENT_REGISTRATION
+#ifdef CONFIG_SUNRPC_XPRT_RDMA_CLIENT_ALLPHYSICAL
 	case RPCRDMA_ALLPHYSICAL:
 		rpcrdma_map_one(ia, seg, writing);
 		seg->mr_rkey = ia->ri_bind_mem->rkey;
@@ -1639,7 +1639,7 @@ rpcrdma_deregister_external(struct rpcrdma_mr_seg *seg,
 
 	switch (ia->ri_memreg_strategy) {
 
-#if RPCRDMA_PERSISTENT_REGISTRATION
+#ifdef CONFIG_SUNRPC_XPRT_RDMA_CLIENT_ALLPHYSICAL
 	case RPCRDMA_ALLPHYSICAL:
 		BUG_ON(nsegs != 1);
 		rpcrdma_unmap_one(ia, seg);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
