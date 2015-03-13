From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 04/16] xprtrdma: Add a "max_payload" op for each memreg
 mode
Date: Fri, 13 Mar 2015 17:27:08 -0400
Message-ID: <20150313212708.22783.70403.stgit@manet.1015granger.net>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212517.22783.18364.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The max_payload computation is generalized to ensure that the
payload maximum is the lesser of RPC_MAX_DATA_SEGS and the number of
data segments that can be transmitted in an inline buffer.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c      |   13 ++++++++++
 net/sunrpc/xprtrdma/frwr_ops.c     |   13 ++++++++++
 net/sunrpc/xprtrdma/physical_ops.c |   10 +++++++
 net/sunrpc/xprtrdma/transport.c    |    5 +++-
 net/sunrpc/xprtrdma/verbs.c        |   49 +++++++++++-------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h    |    5 +++-
 6 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index ffb7d93..eec2660 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -17,6 +17,19 @@
 # define RPCDBG_FACILITY	RPCDBG_TRANS
 #endif
 
+/* Maximum scatter/gather per FMR */
+#define RPCRDMA_MAX_FMR_SGES	(64)
+
+/* FMR mode conveys up to 64 pages of payload per chunk segment.
+ */
+static size_t
+fmr_op_maxpages(struct rpcrdma_xprt *r_xprt)
+{
+	return min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
+		     rpcrdma_max_segments(r_xprt) * RPCRDMA_MAX_FMR_SGES);
+}
+
 const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops = {
+	.ro_maxpages			= fmr_op_maxpages,
 	.ro_displayname			= "fmr",
 };
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 79173f9..73a5ac8 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -17,6 +17,19 @@
 # define RPCDBG_FACILITY	RPCDBG_TRANS
 #endif
 
+/* FRWR mode conveys a list of pages per chunk segment. The
+ * maximum length of that list is the FRWR page list depth.
+ */
+static size_t
+frwr_op_maxpages(struct rpcrdma_xprt *r_xprt)
+{
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
+
+	return min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
+		     rpcrdma_max_segments(r_xprt) * ia->ri_max_frmr_depth);
+}
+
 const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops = {
+	.ro_maxpages			= frwr_op_maxpages,
 	.ro_displayname			= "frwr",
 };
diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
index b0922ac..28ade19 100644
--- a/net/sunrpc/xprtrdma/physical_ops.c
+++ b/net/sunrpc/xprtrdma/physical_ops.c
@@ -19,6 +19,16 @@
 # define RPCDBG_FACILITY	RPCDBG_TRANS
 #endif
 
+/* PHYSICAL memory registration conveys one page per chunk segment.
+ */
+static size_t
+physical_op_maxpages(struct rpcrdma_xprt *r_xprt)
+{
+	return min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
+		     rpcrdma_max_segments(r_xprt));
+}
+
 const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops = {
+	.ro_maxpages			= physical_op_maxpages,
 	.ro_displayname			= "physical",
 };
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 271d306..9a9da40 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -406,7 +406,10 @@ xprt_setup_rdma(struct xprt_create *args)
 			  xprt_rdma_connect_worker);
 
 	xprt_rdma_format_addresses(xprt);
-	xprt->max_payload = rpcrdma_max_payload(new_xprt);
+	xprt->max_payload = new_xprt->rx_ia.ri_ops->ro_maxpages(new_xprt);
+	if (xprt->max_payload == 0)
+		goto out4;
+	xprt->max_payload <<= PAGE_SHIFT;
 	dprintk("RPC:       %s: transport data payload maximum: %zu bytes\n",
 		__func__, xprt->max_payload);
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index e4d9d9c..837d4ea 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -2215,43 +2215,24 @@ rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
 	return rc;
 }
 
-/* Physical mapping means one Read/Write list entry per-page.
- * All list entries must fit within an inline buffer
- *
- * NB: The server must return a Write list for NFS READ,
- *     which has the same constraint. Factor in the inline
- *     rsize as well.
+/* How many chunk list items fit within our inline buffers?
  */
-static size_t
-rpcrdma_physical_max_payload(struct rpcrdma_xprt *r_xprt)
+unsigned int
+rpcrdma_max_segments(struct rpcrdma_xprt *r_xprt)
 {
 	struct rpcrdma_create_data_internal *cdata = &r_xprt->rx_data;
-	unsigned int inline_size, pages;
-
-	inline_size = min_t(unsigned int,
-			    cdata->inline_wsize, cdata->inline_rsize);
-	inline_size -= RPCRDMA_HDRLEN_MIN;
-	pages = inline_size / sizeof(struct rpcrdma_segment);
-	return pages << PAGE_SHIFT;
-}
+	int bytes, segments;
 
-static size_t
-rpcrdma_mr_max_payload(struct rpcrdma_xprt *r_xprt)
-{
-	return RPCRDMA_MAX_DATA_SEGS << PAGE_SHIFT;
-}
-
-size_t
-rpcrdma_max_payload(struct rpcrdma_xprt *r_xprt)
-{
-	size_t result;
-
-	switch (r_xprt->rx_ia.ri_memreg_strategy) {
-	case RPCRDMA_ALLPHYSICAL:
-		result = rpcrdma_physical_max_payload(r_xprt);
-		break;
-	default:
-		result = rpcrdma_mr_max_payload(r_xprt);
+	bytes = min_t(unsigned int, cdata->inline_wsize, cdata->inline_rsize);
+	bytes -= RPCRDMA_HDRLEN_MIN;
+	if (bytes < sizeof(struct rpcrdma_segment) * 2) {
+		pr_warn("RPC:       %s: inline threshold too small\n",
+			__func__);
+		return 0;
 	}
-	return result;
+
+	segments = 1 << (fls(bytes / sizeof(struct rpcrdma_segment)) - 1);
+	dprintk("RPC:       %s: max chunk list size = %d segments\n",
+		__func__, segments);
+	return segments;
 }
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index ef3cf4a..59e627e 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -334,7 +334,9 @@ struct rpcrdma_stats {
 /*
  * Per-registration mode operations
  */
+struct rpcrdma_xprt;
 struct rpcrdma_memreg_ops {
+	size_t		(*ro_maxpages)(struct rpcrdma_xprt *);
 	const char	*ro_displayname;
 };
 
@@ -411,6 +413,8 @@ struct rpcrdma_regbuf *rpcrdma_alloc_regbuf(struct rpcrdma_ia *,
 void rpcrdma_free_regbuf(struct rpcrdma_ia *,
 			 struct rpcrdma_regbuf *);
 
+unsigned int rpcrdma_max_segments(struct rpcrdma_xprt *);
+
 /*
  * RPC/RDMA connection management calls - xprtrdma/rpc_rdma.c
  */
@@ -422,7 +426,6 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *);
  * RPC/RDMA protocol calls - xprtrdma/rpc_rdma.c
  */
 int rpcrdma_marshal_req(struct rpc_rqst *);
-size_t rpcrdma_max_payload(struct rpcrdma_xprt *);
 
 /* Temporary NFS request map cache. Created in svc_rdma.c  */
 extern struct kmem_cache *svc_rdma_map_cachep;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
