From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 10/16] xprtrdma: Add "open" memreg op
Date: Fri, 13 Mar 2015 17:28:07 -0400
Message-ID: <20150313212807.22783.61881.stgit@manet.1015granger.net>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212517.22783.18364.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The open op determines the size of various transport data structures
based on device capabilities and memory registration mode.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c      |   22 +++++++++++++
 net/sunrpc/xprtrdma/frwr_ops.c     |   60 ++++++++++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/physical_ops.c |   22 +++++++++++++
 net/sunrpc/xprtrdma/verbs.c        |   54 ++------------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h    |    3 ++
 5 files changed, 110 insertions(+), 51 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 3115e4b..96e6cd3 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -46,6 +46,27 @@ out_err:
 	return nsegs;
 }
 
+static int
+fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
+	    struct rpcrdma_create_data_internal *cdata)
+{
+	struct ib_device_attr *devattr = &ia->ri_devattr;
+	unsigned int wrs, max_wrs;
+
+	max_wrs = devattr->max_qp_wr;
+	if (cdata->max_requests > max_wrs)
+		cdata->max_requests = max_wrs;
+
+	wrs = cdata->max_requests;
+	ep->rep_attr.cap.max_send_wr = wrs;
+	ep->rep_attr.cap.max_recv_wr = wrs;
+
+	dprintk("RPC:       %s: pre-allocating %u send WRs, %u recv WRs\n",
+		__func__, ep->rep_attr.cap.max_send_wr,
+		ep->rep_attr.cap.max_recv_wr);
+	return 0;
+}
+
 /* FMR mode conveys up to 64 pages of payload per chunk segment.
  */
 static size_t
@@ -201,6 +222,7 @@ fmr_op_destroy(struct rpcrdma_buffer *buf)
 const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops = {
 	.ro_map				= fmr_op_map,
 	.ro_unmap			= fmr_op_unmap,
+	.ro_open			= fmr_op_open,
 	.ro_maxpages			= fmr_op_maxpages,
 	.ro_init			= fmr_op_init,
 	.ro_reset			= fmr_op_reset,
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index fc3a228..9bb4b2d 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -93,6 +93,65 @@ __frwr_release(struct rpcrdma_mw *r)
 	ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
 }
 
+static int
+frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
+	     struct rpcrdma_create_data_internal *cdata)
+{
+	struct ib_device_attr *devattr = &ia->ri_devattr;
+	unsigned int wrs, max_wrs;
+	int depth = 7;
+
+	max_wrs = devattr->max_qp_wr;
+	if (cdata->max_requests > max_wrs)
+		cdata->max_requests = max_wrs;
+
+	wrs = cdata->max_requests;
+	ep->rep_attr.cap.max_send_wr = wrs;
+	ep->rep_attr.cap.max_recv_wr = wrs;
+
+	ia->ri_max_frmr_depth =
+			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
+			      devattr->max_fast_reg_page_list_len);
+	dprintk("RPC:       %s: device's max FR page list len = %u\n",
+		__func__, ia->ri_max_frmr_depth);
+
+	/* Add room for frmr register and invalidate WRs.
+	 * 1. FRMR reg WR for head
+	 * 2. FRMR invalidate WR for head
+	 * 3. N FRMR reg WRs for pagelist
+	 * 4. N FRMR invalidate WRs for pagelist
+	 * 5. FRMR reg WR for tail
+	 * 6. FRMR invalidate WR for tail
+	 * 7. The RDMA_SEND WR
+	 */
+
+	/* Calculate N if the device max FRMR depth is smaller than
+	 * RPCRDMA_MAX_DATA_SEGS.
+	 */
+	if (ia->ri_max_frmr_depth < RPCRDMA_MAX_DATA_SEGS) {
+		int delta = RPCRDMA_MAX_DATA_SEGS - ia->ri_max_frmr_depth;
+
+		do {
+			depth += 2; /* FRMR reg + invalidate */
+			delta -= ia->ri_max_frmr_depth;
+		} while (delta > 0);
+	}
+
+	ep->rep_attr.cap.max_send_wr *= depth;
+	if (ep->rep_attr.cap.max_send_wr > max_wrs) {
+		cdata->max_requests = max_wrs / depth;
+		if (!cdata->max_requests)
+			return -EINVAL;
+		ep->rep_attr.cap.max_send_wr = cdata->max_requests *
+					       depth;
+	}
+
+	dprintk("RPC:       %s: pre-allocating %u send WRs, %u recv WRs\n",
+		__func__, ep->rep_attr.cap.max_send_wr,
+		ep->rep_attr.cap.max_recv_wr);
+	return 0;
+}
+
 /* FRWR mode conveys a list of pages per chunk segment. The
  * maximum length of that list is the FRWR page list depth.
  */
@@ -290,6 +349,7 @@ frwr_op_destroy(struct rpcrdma_buffer *buf)
 const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops = {
 	.ro_map				= frwr_op_map,
 	.ro_unmap			= frwr_op_unmap,
+	.ro_open			= frwr_op_open,
 	.ro_maxpages			= frwr_op_maxpages,
 	.ro_init			= frwr_op_init,
 	.ro_reset			= frwr_op_reset,
diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
index f8da8c4..0998f4f 100644
--- a/net/sunrpc/xprtrdma/physical_ops.c
+++ b/net/sunrpc/xprtrdma/physical_ops.c
@@ -19,6 +19,27 @@
 # define RPCDBG_FACILITY	RPCDBG_TRANS
 #endif
 
+static int
+physical_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
+		 struct rpcrdma_create_data_internal *cdata)
+{
+	struct ib_device_attr *devattr = &ia->ri_devattr;
+	unsigned int wrs, max_wrs;
+
+	max_wrs = devattr->max_qp_wr;
+	if (cdata->max_requests > max_wrs)
+		cdata->max_requests = max_wrs;
+
+	wrs = cdata->max_requests;
+	ep->rep_attr.cap.max_send_wr = wrs;
+	ep->rep_attr.cap.max_recv_wr = wrs;
+
+	dprintk("RPC:       %s: pre-allocating %u send WRs, %u recv WRs\n",
+		__func__, ep->rep_attr.cap.max_send_wr,
+		ep->rep_attr.cap.max_recv_wr);
+	return 0;
+}
+
 /* PHYSICAL memory registration conveys one page per chunk segment.
  */
 static size_t
@@ -75,6 +96,7 @@ physical_op_destroy(struct rpcrdma_buffer *buf)
 const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops = {
 	.ro_map				= physical_op_map,
 	.ro_unmap			= physical_op_unmap,
+	.ro_open			= physical_op_open,
 	.ro_maxpages			= physical_op_maxpages,
 	.ro_init			= physical_op_init,
 	.ro_reset			= physical_op_reset,
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index dcbc736..17b2a29 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -621,11 +621,6 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 			dprintk("RPC:       %s: FRMR registration "
 				"not supported by HCA\n", __func__);
 			memreg = RPCRDMA_MTHCAFMR;
-		} else {
-			/* Mind the ia limit on FRMR page list depth */
-			ia->ri_max_frmr_depth = min_t(unsigned int,
-				RPCRDMA_MAX_DATA_SEGS,
-				devattr->max_fast_reg_page_list_len);
 		}
 	}
 	if (memreg == RPCRDMA_MTHCAFMR) {
@@ -734,56 +729,13 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	struct ib_cq *sendcq, *recvcq;
 	int rc, err;
 
-	/* check provider's send/recv wr limits */
-	if (cdata->max_requests > devattr->max_qp_wr)
-		cdata->max_requests = devattr->max_qp_wr;
+	rc = ia->ri_ops->ro_open(ia, ep, cdata);
+	if (rc)
+		return rc;
 
 	ep->rep_attr.event_handler = rpcrdma_qp_async_error_upcall;
 	ep->rep_attr.qp_context = ep;
-	/* send_cq and recv_cq initialized below */
 	ep->rep_attr.srq = NULL;
-	ep->rep_attr.cap.max_send_wr = cdata->max_requests;
-	switch (ia->ri_memreg_strategy) {
-	case RPCRDMA_FRMR: {
-		int depth = 7;
-
-		/* Add room for frmr register and invalidate WRs.
-		 * 1. FRMR reg WR for head
-		 * 2. FRMR invalidate WR for head
-		 * 3. N FRMR reg WRs for pagelist
-		 * 4. N FRMR invalidate WRs for pagelist
-		 * 5. FRMR reg WR for tail
-		 * 6. FRMR invalidate WR for tail
-		 * 7. The RDMA_SEND WR
-		 */
-
-		/* Calculate N if the device max FRMR depth is smaller than
-		 * RPCRDMA_MAX_DATA_SEGS.
-		 */
-		if (ia->ri_max_frmr_depth < RPCRDMA_MAX_DATA_SEGS) {
-			int delta = RPCRDMA_MAX_DATA_SEGS -
-				    ia->ri_max_frmr_depth;
-
-			do {
-				depth += 2; /* FRMR reg + invalidate */
-				delta -= ia->ri_max_frmr_depth;
-			} while (delta > 0);
-
-		}
-		ep->rep_attr.cap.max_send_wr *= depth;
-		if (ep->rep_attr.cap.max_send_wr > devattr->max_qp_wr) {
-			cdata->max_requests = devattr->max_qp_wr / depth;
-			if (!cdata->max_requests)
-				return -EINVAL;
-			ep->rep_attr.cap.max_send_wr = cdata->max_requests *
-						       depth;
-		}
-		break;
-	}
-	default:
-		break;
-	}
-	ep->rep_attr.cap.max_recv_wr = cdata->max_requests;
 	ep->rep_attr.cap.max_send_sge = (cdata->padding ? 4 : 2);
 	ep->rep_attr.cap.max_recv_sge = 1;
 	ep->rep_attr.cap.max_inline_data = 0;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index a0e3c3e..a53a564 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -340,6 +340,9 @@ struct rpcrdma_memreg_ops {
 				  struct rpcrdma_mr_seg *, int, bool);
 	void		(*ro_unmap)(struct rpcrdma_xprt *,
 				    struct rpcrdma_req *, unsigned int);
+	int		(*ro_open)(struct rpcrdma_ia *,
+				   struct rpcrdma_ep *,
+				   struct rpcrdma_create_data_internal *);
 	size_t		(*ro_maxpages)(struct rpcrdma_xprt *);
 	int		(*ro_init)(struct rpcrdma_xprt *);
 	void		(*ro_reset)(struct rpcrdma_xprt *);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
