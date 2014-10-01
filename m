From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 11/21] IB/iser: Centralize iser completion contexts
Date: Wed,  1 Oct 2014 14:02:07 +0300
Message-ID: <1412161337-25285-12-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce iser_comp which centralizes all iser completion
related items and is referenced by iser_device and each
ib_conn.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |   35 +++++---
 drivers/infiniband/ulp/iser/iser_verbs.c |  136 ++++++++++++++----------------
 2 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 95c484d..2bc34aa 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -213,7 +213,6 @@ struct iser_data_buf {
 
 /* fwd declarations */
 struct iser_device;
-struct iser_cq_desc;
 struct iscsi_iser_task;
 struct iscsi_endpoint;
 
@@ -268,20 +267,34 @@ struct iser_conn;
 struct ib_conn;
 struct iscsi_iser_task;
 
+/**
+ * struct iser_comp - iSER completion context
+ *
+ * @device:     pointer to device handle
+ * @rx_cq:      RX completion queue
+ * @tx_cq:      TX completion queue
+ * @tasklet:    Tasklet handle
+ * @active_qps: Number of active QPs attached
+ *              to completion context
+ */
+struct iser_comp {
+	struct iser_device      *device;
+	struct ib_cq		*rx_cq;
+	struct ib_cq		*tx_cq;
+	struct tasklet_struct	 tasklet;
+	int                      active_qps;
+};
+
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
 	struct ib_device_attr	     dev_attr;
-	struct ib_cq	             *rx_cq[ISER_MAX_CQ];
-	struct ib_cq	             *tx_cq[ISER_MAX_CQ];
 	struct ib_mr	             *mr;
-	struct tasklet_struct	     cq_tasklet[ISER_MAX_CQ];
 	struct ib_event_handler      event_handler;
 	struct list_head             ig_list; /* entry in ig devices list */
 	int                          refcount;
-	int                          cq_active_qps[ISER_MAX_CQ];
-	int			     cqs_used;
-	struct iser_cq_desc	     *cq_desc;
+	int			     comps_used;
+	struct iser_comp	     comps[ISER_MAX_CQ];
 	int                          (*iser_alloc_rdma_reg_res)(struct ib_conn *ib_conn,
 								unsigned cmds_max);
 	void                         (*iser_free_rdma_reg_res)(struct ib_conn *ib_conn);
@@ -327,6 +340,7 @@ struct fast_reg_descriptor {
  * @post_send_buf_count: post send counter
  * @rx_wr:               receive work request for batch posts
  * @device:              reference to iser device
+ * @comp:                iser completion context
  * @pi_support:          Indicate device T10-PI support
  * @lock:                protects fmr/fastreg pool
  * @union.fmr:
@@ -345,7 +359,7 @@ struct ib_conn {
 	atomic_t                     post_send_buf_count;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 	struct iser_device          *device;
-	int			     cq_index;
+	struct iser_comp	    *comp;
 	bool			     pi_support;
 	spinlock_t		     lock;
 	union {
@@ -404,11 +418,6 @@ struct iser_page_vec {
 	int data_size;
 };
 
-struct iser_cq_desc {
-	struct iser_device           *device;
-	int                          cq_index;
-};
-
 struct iser_global {
 	struct mutex      device_list_mutex;/*                   */
 	struct list_head  device_list;	     /* all iSER devices */
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 57b20c6..94d1b46 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -44,7 +44,7 @@
 
 static void iser_cq_tasklet_fn(unsigned long data);
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
-static int iser_drain_tx_cq(struct iser_device  *device, int cq_index);
+static int iser_drain_tx_cq(struct iser_comp *comp);
 
 static void iser_cq_event_callback(struct ib_event *cause, void *context)
 {
@@ -72,7 +72,6 @@ static void iser_event_handler(struct ib_event_handler *handler,
  */
 static int iser_create_device_ib_res(struct iser_device *device)
 {
-	struct iser_cq_desc *cq_desc;
 	struct ib_device_attr *dev_attr = &device->dev_attr;
 	int ret, i;
 
@@ -102,51 +101,44 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		return -1;
 	}
 
-	device->cqs_used = min(ISER_MAX_CQ, device->ib_device->num_comp_vectors);
+	device->comps_used = min(ISER_MAX_CQ,
+				 device->ib_device->num_comp_vectors);
 	iser_info("using %d CQs, device %s supports %d vectors\n",
-		  device->cqs_used, device->ib_device->name,
+		  device->comps_used, device->ib_device->name,
 		  device->ib_device->num_comp_vectors);
 
-	device->cq_desc = kmalloc(sizeof(struct iser_cq_desc) * device->cqs_used,
-				  GFP_KERNEL);
-	if (device->cq_desc == NULL)
-		goto cq_desc_err;
-	cq_desc = device->cq_desc;
-
 	device->pd = ib_alloc_pd(device->ib_device);
 	if (IS_ERR(device->pd))
 		goto pd_err;
 
-	for (i = 0; i < device->cqs_used; i++) {
-		cq_desc[i].device   = device;
-		cq_desc[i].cq_index = i;
-
-		device->rx_cq[i] = ib_create_cq(device->ib_device,
-					  iser_cq_callback,
-					  iser_cq_event_callback,
-					  (void *)&cq_desc[i],
-					  ISER_MAX_RX_CQ_LEN, i);
-		if (IS_ERR(device->rx_cq[i])) {
-			device->rx_cq[i] = NULL;
+	for (i = 0; i < device->comps_used; i++) {
+		struct iser_comp *comp = &device->comps[i];
+
+		comp->device = device;
+		comp->rx_cq = ib_create_cq(device->ib_device,
+					   iser_cq_callback,
+					   iser_cq_event_callback,
+					   (void *)comp,
+					   ISER_MAX_RX_CQ_LEN, i);
+		if (IS_ERR(comp->rx_cq)) {
+			comp->rx_cq = NULL;
 			goto cq_err;
 		}
 
-		device->tx_cq[i] = ib_create_cq(device->ib_device,
-					  NULL, iser_cq_event_callback,
-					  (void *)&cq_desc[i],
-					  ISER_MAX_TX_CQ_LEN, i);
-
-		if (IS_ERR(device->tx_cq[i])) {
-			device->tx_cq[i] = NULL;
+		comp->tx_cq = ib_create_cq(device->ib_device, NULL,
+					   iser_cq_event_callback,
+					   (void *)comp,
+					   ISER_MAX_TX_CQ_LEN, i);
+		if (IS_ERR(comp->tx_cq)) {
+			comp->tx_cq = NULL;
 			goto cq_err;
 		}
 
-		if (ib_req_notify_cq(device->rx_cq[i], IB_CQ_NEXT_COMP))
+		if (ib_req_notify_cq(comp->rx_cq, IB_CQ_NEXT_COMP))
 			goto cq_err;
 
-		tasklet_init(&device->cq_tasklet[i],
-			     iser_cq_tasklet_fn,
-			(unsigned long)&cq_desc[i]);
+		tasklet_init(&comp->tasklet, iser_cq_tasklet_fn,
+			     (unsigned long)comp);
 	}
 
 	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
@@ -165,19 +157,19 @@ static int iser_create_device_ib_res(struct iser_device *device)
 handler_err:
 	ib_dereg_mr(device->mr);
 dma_mr_err:
-	for (i = 0; i < device->cqs_used; i++)
-		tasklet_kill(&device->cq_tasklet[i]);
+	for (i = 0; i < device->comps_used; i++)
+		tasklet_kill(&device->comps[i].tasklet);
 cq_err:
-	for (i = 0; i < device->cqs_used; i++) {
-		if (device->tx_cq[i])
-			ib_destroy_cq(device->tx_cq[i]);
-		if (device->rx_cq[i])
-			ib_destroy_cq(device->rx_cq[i]);
+	for (i = 0; i < device->comps_used; i++) {
+		struct iser_comp *comp = &device->comps[i];
+
+		if (comp->tx_cq)
+			ib_destroy_cq(comp->tx_cq);
+		if (comp->rx_cq)
+			ib_destroy_cq(comp->rx_cq);
 	}
 	ib_dealloc_pd(device->pd);
 pd_err:
-	kfree(device->cq_desc);
-cq_desc_err:
 	iser_err("failed to allocate an IB resource\n");
 	return -1;
 }
@@ -191,20 +183,20 @@ static void iser_free_device_ib_res(struct iser_device *device)
 	int i;
 	BUG_ON(device->mr == NULL);
 
-	for (i = 0; i < device->cqs_used; i++) {
-		tasklet_kill(&device->cq_tasklet[i]);
-		(void)ib_destroy_cq(device->tx_cq[i]);
-		(void)ib_destroy_cq(device->rx_cq[i]);
-		device->tx_cq[i] = NULL;
-		device->rx_cq[i] = NULL;
+	for (i = 0; i < device->comps_used; i++) {
+		struct iser_comp *comp = &device->comps[i];
+
+		tasklet_kill(&comp->tasklet);
+		ib_destroy_cq(comp->tx_cq);
+		ib_destroy_cq(comp->rx_cq);
+		comp->tx_cq = NULL;
+		comp->rx_cq = NULL;
 	}
 
 	(void)ib_unregister_event_handler(&device->event_handler);
 	(void)ib_dereg_mr(device->mr);
 	(void)ib_dealloc_pd(device->pd);
 
-	kfree(device->cq_desc);
-
 	device->mr = NULL;
 	device->pd = NULL;
 }
@@ -456,19 +448,20 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 
 	mutex_lock(&ig.connlist_mutex);
 	/* select the CQ with the minimal number of usages */
-	for (index = 0; index < device->cqs_used; index++)
-		if (device->cq_active_qps[index] <
-		    device->cq_active_qps[min_index])
+	for (index = 0; index < device->comps_used; index++) {
+		if (device->comps[index].active_qps <
+		    device->comps[min_index].active_qps)
 			min_index = index;
-	device->cq_active_qps[min_index]++;
-	ib_conn->cq_index = min_index;
+	}
+	ib_conn->comp = &device->comps[min_index];
+	ib_conn->comp->active_qps++;
 	mutex_unlock(&ig.connlist_mutex);
 	iser_info("cq index %d used for ib_conn %p\n", min_index, ib_conn);
 
 	init_attr.event_handler = iser_qp_event_callback;
 	init_attr.qp_context	= (void *)ib_conn;
-	init_attr.send_cq	= device->tx_cq[min_index];
-	init_attr.recv_cq	= device->rx_cq[min_index];
+	init_attr.send_cq	= ib_conn->comp->tx_cq;
+	init_attr.recv_cq	= ib_conn->comp->rx_cq;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
 	init_attr.cap.max_send_sge = 2;
 	init_attr.cap.max_recv_sge = 1;
@@ -604,7 +597,7 @@ static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
 	iser_free_rx_descriptors(iser_conn);
 
 	if (ib_conn->qp != NULL) {
-		ib_conn->device->cq_active_qps[ib_conn->cq_index]--;
+		ib_conn->comp->active_qps--;
 		rdma_destroy_qp(ib_conn->cma_id);
 		ib_conn->qp = NULL;
 	}
@@ -655,14 +648,13 @@ void iser_conn_release(struct iser_conn *iser_conn)
  */
 static void iser_poll_for_flush_errors(struct ib_conn *ib_conn)
 {
-	struct iser_device *device = ib_conn->device;
 	int count = 0;
 
 	while (ib_conn->post_recv_buf_count > 0 ||
 	       atomic_read(&ib_conn->post_send_buf_count) > 0) {
 		msleep(100);
 		if (atomic_read(&ib_conn->post_send_buf_count) > 0)
-			iser_drain_tx_cq(device, ib_conn->cq_index);
+			iser_drain_tx_cq(ib_conn->comp);
 
 		count++;
 		/* Don't flood with prints */
@@ -1189,9 +1181,9 @@ iser_handle_comp_error(struct iser_tx_desc *desc,
 		kmem_cache_free(ig.desc_cache, desc);
 }
 
-static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
+static int iser_drain_tx_cq(struct iser_comp *comp)
 {
-	struct ib_cq  *cq = device->tx_cq[cq_index];
+	struct ib_cq *cq = comp->tx_cq;
 	struct ib_wc  wc;
 	struct iser_tx_desc *tx_desc;
 	struct ib_conn *ib_conn;
@@ -1222,20 +1214,18 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 
 static void iser_cq_tasklet_fn(unsigned long data)
 {
-	struct iser_cq_desc *cq_desc = (struct iser_cq_desc *)data;
-	struct iser_device  *device = cq_desc->device;
-	int cq_index = cq_desc->cq_index;
-	struct ib_cq	     *cq = device->rx_cq[cq_index];
-	 struct ib_wc	     wc;
-	 struct iser_rx_desc *desc;
-	 unsigned long	     xfer_len;
+	struct iser_comp *comp = (struct iser_comp *)data;
+	struct ib_cq *cq = comp->rx_cq;
+	struct ib_wc wc;
+	struct iser_rx_desc *desc;
+	unsigned long xfer_len;
 	struct ib_conn *ib_conn;
 	int completed_tx, completed_rx = 0;
 
 	/* First do tx drain, so in a case where we have rx flushes and a successful
 	 * tx completion we will still go through completion error handling.
 	 */
-	completed_tx = iser_drain_tx_cq(device, cq_index);
+	completed_tx = iser_drain_tx_cq(comp);
 
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
@@ -1257,7 +1247,7 @@ static void iser_cq_tasklet_fn(unsigned long data)
 		}
 		completed_rx++;
 		if (!(completed_rx & 63))
-			completed_tx += iser_drain_tx_cq(device, cq_index);
+			completed_tx += iser_drain_tx_cq(comp);
 	}
 	/* #warning "it is assumed here that arming CQ only once its empty" *
 	 * " would not cause interrupts to be missed"                       */
@@ -1268,11 +1258,9 @@ static void iser_cq_tasklet_fn(unsigned long data)
 
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context)
 {
-	struct iser_cq_desc *cq_desc = (struct iser_cq_desc *)cq_context;
-	struct iser_device  *device = cq_desc->device;
-	int cq_index = cq_desc->cq_index;
+	struct iser_comp *comp = cq_context;
 
-	tasklet_schedule(&device->cq_tasklet[cq_index]);
+	tasklet_schedule(&comp->tasklet);
 }
 
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
