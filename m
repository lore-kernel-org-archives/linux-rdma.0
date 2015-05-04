From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 11/14] xprtrdma: Remove rpcrdma_ia::ri_memreg_strategy
Date: Mon, 04 May 2015 13:58:27 -0400
Message-ID: <20150504175827.3483.62904.stgit@manet.1015granger.net>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504174626.3483.97639.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: This field is no longer used.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/xprtrdma.h |    3 ++-
 net/sunrpc/xprtrdma/verbs.c     |    3 ---
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/xprtrdma.h b/include/linux/sunrpc/xprtrdma.h
index c984c85..b176130 100644
--- a/include/linux/sunrpc/xprtrdma.h
+++ b/include/linux/sunrpc/xprtrdma.h
@@ -56,7 +56,8 @@
 
 #define RPCRDMA_INLINE_PAD_THRESH  (512)/* payload threshold to pad (bytes) */
 
-/* memory registration strategies */
+/* Memory registration strategies, by number.
+ * This is part of a kernel / user space API. Do not remove. */
 enum rpcrdma_memreg {
 	RPCRDMA_BOUNCEBUFFERS = 0,
 	RPCRDMA_REGISTER,
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index eaf0b9d..1f51547 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -671,9 +671,6 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	dprintk("RPC:       %s: memory registration strategy is '%s'\n",
 		__func__, ia->ri_ops->ro_displayname);
 
-	/* Else will do memory reg/dereg for each chunk */
-	ia->ri_memreg_strategy = memreg;
-
 	rwlock_init(&ia->ri_qplock);
 	return 0;
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 6a1e565..5650c23 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -70,7 +70,6 @@ struct rpcrdma_ia {
 	int			ri_have_dma_lkey;
 	struct completion	ri_done;
 	int			ri_async_rc;
-	enum rpcrdma_memreg	ri_memreg_strategy;
 	unsigned int		ri_max_frmr_depth;
 	struct ib_device_attr	ri_devattr;
 	struct ib_qp_attr	ri_qp_attr;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
