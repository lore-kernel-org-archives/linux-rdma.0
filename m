From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 2/9] IB/isert: use implicit CQ allocation
Date: Wed,  8 Nov 2017 11:57:35 +0200
Message-ID: <20171108095742.25365-3-sagi@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
[hch: ported to the new API]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 165 ++++----------------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  16 ----
 2 files changed, 20 insertions(+), 161 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index ceabdb85df8b..bcf4adac5d8c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -35,8 +35,6 @@
 #define ISER_MAX_RX_CQ_LEN	(ISERT_QP_MAX_RECV_DTOS * ISERT_MAX_CONN)
 #define ISER_MAX_TX_CQ_LEN \
 	((ISERT_QP_MAX_REQ_DTOS + ISCSI_DEF_XMIT_CMDS_MAX) * ISERT_MAX_CONN)
-#define ISER_MAX_CQ_LEN		(ISER_MAX_RX_CQ_LEN + ISER_MAX_TX_CQ_LEN + \
-				 ISERT_MAX_CONN)
 
 static int isert_debug_level;
 module_param_named(debug_level, isert_debug_level, int, 0644);
@@ -89,55 +87,26 @@ isert_qp_event_callback(struct ib_event *e, void *context)
 	}
 }
 
-static struct isert_comp *
-isert_comp_get(struct isert_conn *isert_conn)
-{
-	struct isert_device *device = isert_conn->device;
-	struct isert_comp *comp;
-	int i, min = 0;
-
-	mutex_lock(&device_list_mutex);
-	for (i = 0; i < device->comps_used; i++)
-		if (device->comps[i].active_qps <
-		    device->comps[min].active_qps)
-			min = i;
-	comp = &device->comps[min];
-	comp->active_qps++;
-	mutex_unlock(&device_list_mutex);
-
-	isert_info("conn %p, using comp %p min_index: %d\n",
-		   isert_conn, comp, min);
-
-	return comp;
-}
-
-static void
-isert_comp_put(struct isert_comp *comp)
-{
-	mutex_lock(&device_list_mutex);
-	comp->active_qps--;
-	mutex_unlock(&device_list_mutex);
-}
-
 static struct ib_qp *
-isert_create_qp(struct isert_conn *isert_conn,
-		struct isert_comp *comp,
-		struct rdma_cm_id *cma_id)
+isert_create_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
 {
 	struct isert_device *device = isert_conn->device;
 	struct ib_qp_init_attr attr;
 	int ret;
 
-	memset(&attr, 0, sizeof(struct ib_qp_init_attr));
+	memset(&attr, 0, sizeof(attr));
+	attr.create_flags = IB_QP_CREATE_ASSIGN_CQS;
 	attr.event_handler = isert_qp_event_callback;
 	attr.qp_context = isert_conn;
-	attr.send_cq = comp->cq;
-	attr.recv_cq = comp->cq;
+	attr.poll_ctx = IB_POLL_WORKQUEUE;
+
 	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS + 1;
-	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
 	attr.cap.max_rdma_ctxs = ISCSI_DEF_XMIT_CMDS_MAX;
 	attr.cap.max_send_sge = device->ib_device->attrs.max_sge;
+
+	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
 	attr.cap.max_recv_sge = 1;
+
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr.qp_type = IB_QPT_RC;
 	if (device->pi_capable)
@@ -152,25 +121,6 @@ isert_create_qp(struct isert_conn *isert_conn,
 	return cma_id->qp;
 }
 
-static int
-isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
-{
-	struct isert_comp *comp;
-	int ret;
-
-	comp = isert_comp_get(isert_conn);
-	isert_conn->qp = isert_create_qp(isert_conn, comp, cma_id);
-	if (IS_ERR(isert_conn->qp)) {
-		ret = PTR_ERR(isert_conn->qp);
-		goto err;
-	}
-
-	return 0;
-err:
-	isert_comp_put(comp);
-	return ret;
-}
-
 static int
 isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 {
@@ -237,61 +187,6 @@ isert_free_rx_descriptors(struct isert_conn *isert_conn)
 	isert_conn->rx_descs = NULL;
 }
 
-static void
-isert_free_comps(struct isert_device *device)
-{
-	int i;
-
-	for (i = 0; i < device->comps_used; i++) {
-		struct isert_comp *comp = &device->comps[i];
-
-		if (comp->cq)
-			ib_free_cq(comp->cq);
-	}
-	kfree(device->comps);
-}
-
-static int
-isert_alloc_comps(struct isert_device *device)
-{
-	int i, max_cqe, ret = 0;
-
-	device->comps_used = min(ISERT_MAX_CQ, min_t(int, num_online_cpus(),
-				 device->ib_device->num_comp_vectors));
-
-	isert_info("Using %d CQs, %s supports %d vectors support "
-		   "pi_capable %d\n",
-		   device->comps_used, device->ib_device->name,
-		   device->ib_device->num_comp_vectors,
-		   device->pi_capable);
-
-	device->comps = kcalloc(device->comps_used, sizeof(struct isert_comp),
-				GFP_KERNEL);
-	if (!device->comps)
-		return -ENOMEM;
-
-	max_cqe = min(ISER_MAX_CQ_LEN, device->ib_device->attrs.max_cqe);
-
-	for (i = 0; i < device->comps_used; i++) {
-		struct isert_comp *comp = &device->comps[i];
-
-		comp->device = device;
-		comp->cq = ib_alloc_cq(device->ib_device, comp, max_cqe, i,
-				IB_POLL_WORKQUEUE);
-		if (IS_ERR(comp->cq)) {
-			isert_err("Unable to allocate cq\n");
-			ret = PTR_ERR(comp->cq);
-			comp->cq = NULL;
-			goto out_cq;
-		}
-	}
-
-	return 0;
-out_cq:
-	isert_free_comps(device);
-	return ret;
-}
-
 static int
 isert_create_device_ib_res(struct isert_device *device)
 {
@@ -301,16 +196,12 @@ isert_create_device_ib_res(struct isert_device *device)
 	isert_dbg("devattr->max_sge: %d\n", ib_dev->attrs.max_sge);
 	isert_dbg("devattr->max_sge_rd: %d\n", ib_dev->attrs.max_sge_rd);
 
-	ret = isert_alloc_comps(device);
-	if (ret)
-		goto out;
-
 	device->pd = ib_alloc_pd(ib_dev, 0);
 	if (IS_ERR(device->pd)) {
 		ret = PTR_ERR(device->pd);
-		isert_err("failed to allocate pd, device %p, ret=%d\n",
-			  device, ret);
-		goto out_cq;
+		isert_err("%s: failed to allocate pd, ret=%d\n",
+			  ib_dev->name, ret);
+		return ret;
 	}
 
 	/* Check signature cap */
@@ -318,22 +209,6 @@ isert_create_device_ib_res(struct isert_device *device)
 			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
 
 	return 0;
-
-out_cq:
-	isert_free_comps(device);
-out:
-	if (ret > 0)
-		ret = -EINVAL;
-	return ret;
-}
-
-static void
-isert_free_device_ib_res(struct isert_device *device)
-{
-	isert_info("device %p\n", device);
-
-	ib_dealloc_pd(device->pd);
-	isert_free_comps(device);
 }
 
 static void
@@ -343,7 +218,7 @@ isert_device_put(struct isert_device *device)
 	device->refcount--;
 	isert_info("device %p refcount %d\n", device, device->refcount);
 	if (!device->refcount) {
-		isert_free_device_ib_res(device);
+		ib_dealloc_pd(device->pd);
 		list_del(&device->dev_node);
 		kfree(device);
 	}
@@ -535,13 +410,15 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 
 	isert_set_nego_params(isert_conn, &event->param.conn);
 
-	ret = isert_conn_setup_qp(isert_conn, cma_id);
-	if (ret)
+	isert_conn->qp = isert_create_qp(isert_conn, cma_id);
+	if (IS_ERR(isert_conn->qp)) {
+		ret = PTR_ERR(isert_conn->qp);
 		goto out_conn_dev;
+	}
 
 	ret = isert_login_post_recv(isert_conn);
 	if (ret)
-		goto out_conn_dev;
+		goto out_conn_qp;
 
 	ret = isert_rdma_accept(isert_conn);
 	if (ret)
@@ -553,6 +430,8 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 
 	return 0;
 
+out_conn_qp:
+	ib_destroy_qp(isert_conn->qp);
 out_conn_dev:
 	isert_device_put(device);
 out_rsp_dma_map:
@@ -577,12 +456,8 @@ isert_connect_release(struct isert_conn *isert_conn)
 	    !isert_conn->dev_removed)
 		rdma_destroy_id(isert_conn->cm_id);
 
-	if (isert_conn->qp) {
-		struct isert_comp *comp = isert_conn->qp->recv_cq->cq_context;
-
-		isert_comp_put(comp);
+	if (isert_conn->qp)
 		ib_destroy_qp(isert_conn->qp);
-	}
 
 	if (isert_conn->login_req_buf)
 		isert_free_login_buf(isert_conn);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 87d994de8c91..bb7fda807471 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -165,27 +165,11 @@ struct isert_conn {
 
 #define ISERT_MAX_CQ 64
 
-/**
- * struct isert_comp - iSER completion context
- *
- * @device:     pointer to device handle
- * @cq:         completion queue
- * @active_qps: Number of active QPs attached
- *              to completion context
- */
-struct isert_comp {
-	struct isert_device     *device;
-	struct ib_cq		*cq;
-	int                      active_qps;
-};
-
 struct isert_device {
 	bool			pi_capable;
 	int			refcount;
 	struct ib_device	*ib_device;
 	struct ib_pd		*pd;
-	struct isert_comp	*comps;
-	int                     comps_used;
 	struct list_head	dev_node;
 };
 
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
