From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 5/6] xprtrdma: Avoid calling ib_query_device
Date: Thu, 17 Dec 2015 15:18:59 +0200
Message-ID: <1450358340-19361-6-git-send-email-ogerlitz@mellanox.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450358340-19361-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead, use the cached copy of the attributes present on the device.

Based on a patch from Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c           |  7 ++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 48 +++++++++++++-------------------
 net/sunrpc/xprtrdma/verbs.c              | 24 ++++++----------
 net/sunrpc/xprtrdma/xprt_rdma.h          |  1 -
 4 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 88cf9e7..8d4864f 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -190,12 +190,11 @@ static int
 frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 	     struct rpcrdma_create_data_internal *cdata)
 {
-	struct ib_device_attr *devattr = &ia->ri_devattr;
 	int depth, delta;
 
 	ia->ri_max_frmr_depth =
 			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
-			      devattr->max_fast_reg_page_list_len);
+			      ia->ri_device->attrs.max_fast_reg_page_list_len);
 	dprintk("RPC:       %s: device's max FR page list len = %u\n",
 		__func__, ia->ri_max_frmr_depth);
 
@@ -222,8 +221,8 @@ frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 	}
 
 	ep->rep_attr.cap.max_send_wr *= depth;
-	if (ep->rep_attr.cap.max_send_wr > devattr->max_qp_wr) {
-		cdata->max_requests = devattr->max_qp_wr / depth;
+	if (ep->rep_attr.cap.max_send_wr > ia->ri_device->attrs.max_qp_wr) {
+		cdata->max_requests = ia->ri_device->attrs.max_qp_wr / depth;
 		if (!cdata->max_requests)
 			return -EINVAL;
 		ep->rep_attr.cap.max_send_wr = cdata->max_requests *
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index b348b4a..4d695af 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -886,10 +886,10 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct rdma_conn_param conn_param;
 	struct ib_cq_init_attr cq_attr = {};
 	struct ib_qp_init_attr qp_attr;
-	struct ib_device_attr devattr;
+	struct ib_device *dev;
 	int uninitialized_var(dma_mr_acc);
 	int need_dma_mr = 0;
-	int ret;
+	int ret = 0;
 	int i;
 
 	listen_rdma = container_of(xprt, struct svcxprt_rdma, sc_xprt);
@@ -910,20 +910,15 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	dprintk("svcrdma: newxprt from accept queue = %p, cm_id=%p\n",
 		newxprt, newxprt->sc_cm_id);
 
-	ret = ib_query_device(newxprt->sc_cm_id->device, &devattr);
-	if (ret) {
-		dprintk("svcrdma: could not query device attributes on "
-			"device %p, rc=%d\n", newxprt->sc_cm_id->device, ret);
-		goto errout;
-	}
+	dev = newxprt->sc_cm_id->device;
 
 	/* Qualify the transport resource defaults with the
 	 * capabilities of this particular device */
-	newxprt->sc_max_sge = min((size_t)devattr.max_sge,
+	newxprt->sc_max_sge = min((size_t)dev->attrs.max_sge,
 				  (size_t)RPCSVC_MAXPAGES);
-	newxprt->sc_max_sge_rd = min_t(size_t, devattr.max_sge_rd,
+	newxprt->sc_max_sge_rd = min_t(size_t, dev->attrs.max_sge_rd,
 				       RPCSVC_MAXPAGES);
-	newxprt->sc_max_requests = min((size_t)devattr.max_qp_wr,
+	newxprt->sc_max_requests = min((size_t)dev->attrs.max_qp_wr,
 				   (size_t)svcrdma_max_requests);
 	newxprt->sc_sq_depth = RPCRDMA_SQ_DEPTH_MULT * newxprt->sc_max_requests;
 
@@ -931,16 +926,16 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	 * Limit ORD based on client limit, local device limit, and
 	 * configured svcrdma limit.
 	 */
-	newxprt->sc_ord = min_t(size_t, devattr.max_qp_rd_atom, newxprt->sc_ord);
+	newxprt->sc_ord = min_t(size_t, dev->attrs.max_qp_rd_atom, newxprt->sc_ord);
 	newxprt->sc_ord = min_t(size_t,	svcrdma_ord, newxprt->sc_ord);
 
-	newxprt->sc_pd = ib_alloc_pd(newxprt->sc_cm_id->device);
+	newxprt->sc_pd = ib_alloc_pd(dev);
 	if (IS_ERR(newxprt->sc_pd)) {
 		dprintk("svcrdma: error creating PD for connect request\n");
 		goto errout;
 	}
 	cq_attr.cqe = newxprt->sc_sq_depth;
-	newxprt->sc_sq_cq = ib_create_cq(newxprt->sc_cm_id->device,
+	newxprt->sc_sq_cq = ib_create_cq(dev,
 					 sq_comp_handler,
 					 cq_event_handler,
 					 newxprt,
@@ -950,7 +945,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		goto errout;
 	}
 	cq_attr.cqe = newxprt->sc_max_requests;
-	newxprt->sc_rq_cq = ib_create_cq(newxprt->sc_cm_id->device,
+	newxprt->sc_rq_cq = ib_create_cq(dev,
 					 rq_comp_handler,
 					 cq_event_handler,
 					 newxprt,
@@ -978,7 +973,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		"    cap.max_send_sge = %d\n"
 		"    cap.max_recv_sge = %d\n",
 		newxprt->sc_cm_id, newxprt->sc_pd,
-		newxprt->sc_cm_id->device, newxprt->sc_pd->device,
+		dev, newxprt->sc_pd->device,
 		qp_attr.cap.max_send_wr,
 		qp_attr.cap.max_recv_wr,
 		qp_attr.cap.max_send_sge,
@@ -1014,9 +1009,9 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	 *	of an RDMA_READ. IB does not.
 	 */
 	newxprt->sc_reader = rdma_read_chunk_lcl;
-	if (devattr.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
+	if (dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
 		newxprt->sc_frmr_pg_list_len =
-			devattr.max_fast_reg_page_list_len;
+			dev->attrs.max_fast_reg_page_list_len;
 		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_FAST_REG;
 		newxprt->sc_reader = rdma_read_chunk_frmr;
 	}
@@ -1024,24 +1019,20 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	/*
 	 * Determine if a DMA MR is required and if so, what privs are required
 	 */
-	if (!rdma_protocol_iwarp(newxprt->sc_cm_id->device,
-				 newxprt->sc_cm_id->port_num) &&
-	    !rdma_ib_or_roce(newxprt->sc_cm_id->device,
-			     newxprt->sc_cm_id->port_num))
+	if (!rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num) &&
+	    !rdma_ib_or_roce(dev, newxprt->sc_cm_id->port_num))
 		goto errout;
 
 	if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG) ||
-	    !(devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
+	    !(dev->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
 		need_dma_mr = 1;
 		dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
-		if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
-					newxprt->sc_cm_id->port_num) &&
+		if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num) &&
 		    !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG))
 			dma_mr_acc |= IB_ACCESS_REMOTE_WRITE;
 	}
 
-	if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
-				newxprt->sc_cm_id->port_num))
+	if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num))
 		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
 
 	/* Create the DMA MR if needed, otherwise, use the DMA LKEY */
@@ -1056,8 +1047,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		}
 		newxprt->sc_dma_lkey = newxprt->sc_phys_mr->lkey;
 	} else
-		newxprt->sc_dma_lkey =
-			newxprt->sc_cm_id->device->local_dma_lkey;
+		newxprt->sc_dma_lkey = dev->local_dma_lkey;
 
 	/* Post receive buffers */
 	for (i = 0; i < newxprt->sc_max_requests; i++) {
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index eadd1655..aa9b444 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -462,7 +462,6 @@ int
 rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 {
 	struct rpcrdma_ia *ia = &xprt->rx_ia;
-	struct ib_device_attr *devattr = &ia->ri_devattr;
 	int rc;
 
 	ia->ri_dma_mr = NULL;
@@ -482,16 +481,10 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		goto out2;
 	}
 
-	rc = ib_query_device(ia->ri_device, devattr);
-	if (rc) {
-		dprintk("RPC:       %s: ib_query_device failed %d\n",
-			__func__, rc);
-		goto out3;
-	}
-
 	if (memreg == RPCRDMA_FRMR) {
-		if (!(devattr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) ||
-		    (devattr->max_fast_reg_page_list_len == 0)) {
+		if (!(ia->ri_device->attrs.device_cap_flags &
+				IB_DEVICE_MEM_MGT_EXTENSIONS) ||
+		    (ia->ri_device->attrs.max_fast_reg_page_list_len == 0)) {
 			dprintk("RPC:       %s: FRMR registration "
 				"not supported by HCA\n", __func__);
 			memreg = RPCRDMA_MTHCAFMR;
@@ -566,24 +559,23 @@ int
 rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 				struct rpcrdma_create_data_internal *cdata)
 {
-	struct ib_device_attr *devattr = &ia->ri_devattr;
 	struct ib_cq *sendcq, *recvcq;
 	struct ib_cq_init_attr cq_attr = {};
 	unsigned int max_qp_wr;
 	int rc, err;
 
-	if (devattr->max_sge < RPCRDMA_MAX_IOVS) {
+	if (ia->ri_device->attrs.max_sge < RPCRDMA_MAX_IOVS) {
 		dprintk("RPC:       %s: insufficient sge's available\n",
 			__func__);
 		return -ENOMEM;
 	}
 
-	if (devattr->max_qp_wr <= RPCRDMA_BACKWARD_WRS) {
+	if (ia->ri_device->attrs.max_qp_wr <= RPCRDMA_BACKWARD_WRS) {
 		dprintk("RPC:       %s: insufficient wqe's available\n",
 			__func__);
 		return -ENOMEM;
 	}
-	max_qp_wr = devattr->max_qp_wr - RPCRDMA_BACKWARD_WRS;
+	max_qp_wr = ia->ri_device->attrs.max_qp_wr - RPCRDMA_BACKWARD_WRS;
 
 	/* check provider's send/recv wr limits */
 	if (cdata->max_requests > max_qp_wr)
@@ -670,11 +662,11 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 
 	/* Client offers RDMA Read but does not initiate */
 	ep->rep_remote_cma.initiator_depth = 0;
-	if (devattr->max_qp_rd_atom > 32)	/* arbitrary but <= 255 */
+	if (ia->ri_device->attrs.max_qp_rd_atom > 32)	/* arbitrary but <= 255 */
 		ep->rep_remote_cma.responder_resources = 32;
 	else
 		ep->rep_remote_cma.responder_resources =
-						devattr->max_qp_rd_atom;
+						ia->ri_device->attrs.max_qp_rd_atom;
 
 	ep->rep_remote_cma.retry_count = 7;
 	ep->rep_remote_cma.flow_control = 0;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index ac7f8d4..4197191 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -68,7 +68,6 @@ struct rpcrdma_ia {
 	struct completion	ri_done;
 	int			ri_async_rc;
 	unsigned int		ri_max_frmr_depth;
-	struct ib_device_attr	ri_devattr;
 	struct ib_qp_attr	ri_qp_attr;
 	struct ib_qp_init_attr	ri_qp_init_attr;
 };
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
