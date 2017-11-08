From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 3/9] IB/iser: use implicit CQ allocation
Date: Wed,  8 Nov 2017 11:57:36 +0200
Message-ID: <20171108095742.25365-4-sagi@grimberg.me>
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
 drivers/infiniband/ulp/iser/iscsi_iser.h | 19 --------
 drivers/infiniband/ulp/iser/iser_verbs.c | 82 ++++----------------------------
 2 files changed, 8 insertions(+), 93 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index c1ae4aeae2f9..cc4134acebdf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -317,18 +317,6 @@ struct iser_conn;
 struct ib_conn;
 struct iscsi_iser_task;
 
-/**
- * struct iser_comp - iSER completion context
- *
- * @cq:         completion queue
- * @active_qps: Number of active QPs attached
- *              to completion context
- */
-struct iser_comp {
-	struct ib_cq		*cq;
-	int                      active_qps;
-};
-
 /**
  * struct iser_device - Memory registration operations
  *     per-device registration schemes
@@ -365,9 +353,6 @@ struct iser_reg_ops {
  * @event_handler: IB events handle routine
  * @ig_list:	   entry in devices list
  * @refcount:      Reference counter, dominated by open iser connections
- * @comps_used:    Number of completion contexts used, Min between online
- *                 cpus and device max completion vectors
- * @comps:         Dinamically allocated array of completion handlers
  * @reg_ops:       Registration ops
  * @remote_inv_sup: Remote invalidate is supported on this device
  */
@@ -377,8 +362,6 @@ struct iser_device {
 	struct ib_event_handler      event_handler;
 	struct list_head             ig_list;
 	int                          refcount;
-	int			     comps_used;
-	struct iser_comp	     *comps;
 	const struct iser_reg_ops    *reg_ops;
 	bool                         remote_inv_sup;
 };
@@ -456,7 +439,6 @@ struct iser_fr_pool {
  * @sig_count:           send work request signal count
  * @rx_wr:               receive work request for batch posts
  * @device:              reference to iser device
- * @comp:                iser completion context
  * @fr_pool:             connection fast registration poool
  * @pi_support:          Indicate device T10-PI support
  */
@@ -467,7 +449,6 @@ struct ib_conn {
 	u8                           sig_count;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 	struct iser_device          *device;
-	struct iser_comp	    *comp;
 	struct iser_fr_pool          fr_pool;
 	bool			     pi_support;
 	struct ib_cqe		     reg_cqe;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 55a73b0ed4c6..8f8d853b1dc9 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -68,40 +68,17 @@ static void iser_event_handler(struct ib_event_handler *handler,
 static int iser_create_device_ib_res(struct iser_device *device)
 {
 	struct ib_device *ib_dev = device->ib_device;
-	int ret, i, max_cqe;
+	int ret;
 
 	ret = iser_assign_reg_ops(device);
 	if (ret)
 		return ret;
 
-	device->comps_used = min_t(int, num_online_cpus(),
-				 ib_dev->num_comp_vectors);
-
-	device->comps = kcalloc(device->comps_used, sizeof(*device->comps),
-				GFP_KERNEL);
-	if (!device->comps)
-		goto comps_err;
-
-	max_cqe = min(ISER_MAX_CQ_LEN, ib_dev->attrs.max_cqe);
-
-	iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n",
-		  device->comps_used, ib_dev->name,
-		  ib_dev->num_comp_vectors, max_cqe);
-
 	device->pd = ib_alloc_pd(ib_dev,
 		iser_always_reg ? 0 : IB_PD_UNSAFE_GLOBAL_RKEY);
-	if (IS_ERR(device->pd))
-		goto pd_err;
-
-	for (i = 0; i < device->comps_used; i++) {
-		struct iser_comp *comp = &device->comps[i];
-
-		comp->cq = ib_alloc_cq(ib_dev, comp, max_cqe, i,
-				       IB_POLL_SOFTIRQ);
-		if (IS_ERR(comp->cq)) {
-			comp->cq = NULL;
-			goto cq_err;
-		}
+	if (IS_ERR(device->pd)) {
+		ret = PTR_ERR(device->pd);
+		goto out;
 	}
 
 	INIT_IB_EVENT_HANDLER(&device->event_handler, ib_dev,
@@ -109,19 +86,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
 	ib_register_event_handler(&device->event_handler);
 	return 0;
 
-cq_err:
-	for (i = 0; i < device->comps_used; i++) {
-		struct iser_comp *comp = &device->comps[i];
-
-		if (comp->cq)
-			ib_free_cq(comp->cq);
-	}
-	ib_dealloc_pd(device->pd);
-pd_err:
-	kfree(device->comps);
-comps_err:
+out:
 	iser_err("failed to allocate an IB resource\n");
-	return -1;
+	return ret;
 }
 
 /**
@@ -130,20 +97,8 @@ static int iser_create_device_ib_res(struct iser_device *device)
  */
 static void iser_free_device_ib_res(struct iser_device *device)
 {
-	int i;
-
-	for (i = 0; i < device->comps_used; i++) {
-		struct iser_comp *comp = &device->comps[i];
-
-		ib_free_cq(comp->cq);
-		comp->cq = NULL;
-	}
-
 	ib_unregister_event_handler(&device->event_handler);
 	ib_dealloc_pd(device->pd);
-
-	kfree(device->comps);
-	device->comps = NULL;
 	device->pd = NULL;
 }
 
@@ -423,7 +378,6 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	struct ib_device	*ib_dev;
 	struct ib_qp_init_attr	init_attr;
 	int			ret = -ENOMEM;
-	int index, min_index = 0;
 
 	BUG_ON(ib_conn->device == NULL);
 
@@ -431,23 +385,10 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	ib_dev = device->ib_device;
 
 	memset(&init_attr, 0, sizeof init_attr);
-
-	mutex_lock(&ig.connlist_mutex);
-	/* select the CQ with the minimal number of usages */
-	for (index = 0; index < device->comps_used; index++) {
-		if (device->comps[index].active_qps <
-		    device->comps[min_index].active_qps)
-			min_index = index;
-	}
-	ib_conn->comp = &device->comps[min_index];
-	ib_conn->comp->active_qps++;
-	mutex_unlock(&ig.connlist_mutex);
-	iser_info("cq index %d used for ib_conn %p\n", min_index, ib_conn);
-
+	init_attr.create_flags = IB_QP_CREATE_ASSIGN_CQS;
 	init_attr.event_handler = iser_qp_event_callback;
 	init_attr.qp_context	= (void *)ib_conn;
-	init_attr.send_cq	= ib_conn->comp->cq;
-	init_attr.recv_cq	= ib_conn->comp->cq;
+	init_attr.poll_ctx = IB_POLL_SOFTIRQ;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
 	init_attr.cap.max_send_sge = 2;
 	init_attr.cap.max_recv_sge = 1;
@@ -483,11 +424,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	return ret;
 
 out_err:
-	mutex_lock(&ig.connlist_mutex);
-	ib_conn->comp->active_qps--;
-	mutex_unlock(&ig.connlist_mutex);
 	iser_err("unable to alloc mem or create resource, err %d\n", ret);
-
 	return ret;
 }
 
@@ -597,9 +534,6 @@ static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
 		  iser_conn, ib_conn->cma_id, ib_conn->qp);
 
 	if (ib_conn->qp != NULL) {
-		mutex_lock(&ig.connlist_mutex);
-		ib_conn->comp->active_qps--;
-		mutex_unlock(&ig.connlist_mutex);
 		rdma_destroy_qp(ib_conn->cma_id);
 		ib_conn->qp = NULL;
 	}
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
