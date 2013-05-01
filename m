From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.10 2/4] IB/iser: Move informational messages from error to info level
Date: Wed,  1 May 2013 16:25:25 +0300
Message-ID: <1367414727-22680-3-git-send-email-ogerlitz@mellanox.com>
References: <1367414727-22680-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367414727-22680-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce iser_info and move informational messages that were treated
as errors with respect to printing them to use that macro. Also,
cleanup printk leftovers to use the existing macros.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   18 +++++++++---------
 drivers/infiniband/ulp/iser/iscsi_iser.h |   12 ++++++++++--
 drivers/infiniband/ulp/iser/iser_verbs.c |   29 +++++++++++++++--------------
 3 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 69e0d7c..f19b099 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -370,8 +370,8 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	/* binds the iSER connection retrieved from the previously
 	 * connected ep_handle to the iSCSI layer connection. exchanges
 	 * connection pointers */
-	iser_err("binding iscsi/iser conn %p %p to ib_conn %p\n",
-					conn, conn->dd_data, ib_conn);
+	iser_info("binding iscsi/iser conn %p %p to ib_conn %p\n",
+		  conn, conn->dd_data, ib_conn);
 	iser_conn = conn->dd_data;
 	ib_conn->iser_conn = iser_conn;
 	iser_conn->ib_conn  = ib_conn;
@@ -475,28 +475,28 @@ iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_HDRDGST_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			printk(KERN_ERR "DataDigest wasn't negotiated to None");
+			iser_err("DataDigest wasn't negotiated to None");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			printk(KERN_ERR "DataDigest wasn't negotiated to None");
+			iser_err("DataDigest wasn't negotiated to None");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_IFMARKER_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			printk(KERN_ERR "IFMarker wasn't negotiated to No");
+			iser_err("IFMarker wasn't negotiated to No");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_OFMARKER_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			printk(KERN_ERR "OFMarker wasn't negotiated to No");
+			iser_err("OFMarker wasn't negotiated to No");
 			return -EPROTO;
 		}
 		break;
@@ -596,7 +596,7 @@ iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	     ib_conn->state == ISER_CONN_DOWN))
 		rc = -1;
 
-	iser_err("ib conn %p rc = %d\n", ib_conn, rc);
+	iser_info("ib conn %p rc = %d\n", ib_conn, rc);
 
 	if (rc > 0)
 		return 1; /* success, this is the equivalent of POLLOUT */
@@ -623,7 +623,7 @@ iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 		iscsi_suspend_tx(ib_conn->iser_conn->iscsi_conn);
 
 
-	iser_err("ib conn %p state %d\n",ib_conn, ib_conn->state);
+	iser_info("ib conn %p state %d\n", ib_conn, ib_conn->state);
 	iser_conn_terminate(ib_conn);
 }
 
@@ -740,7 +740,7 @@ static int __init iser_init(void)
 	iser_dbg("Starting iSER datamover...\n");
 
 	if (iscsi_max_lun < 1) {
-		printk(KERN_ERR "Invalid max_lun value of %u\n", iscsi_max_lun);
+		iser_err("Invalid max_lun value of %u\n", iscsi_max_lun);
 		return -EINVAL;
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 0da04bf..f6b8ff0 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -42,6 +42,7 @@
 
 #include <linux/types.h>
 #include <linux/net.h>
+#include <linux/printk.h>
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
 
@@ -69,15 +70,22 @@
 
 #define iser_dbg(fmt, arg...)				\
 	do {						\
-		if (iser_debug_level > 1)		\
+		if (iser_debug_level > 2)		\
 			printk(KERN_DEBUG PFX "%s:" fmt,\
 				__func__ , ## arg);	\
 	} while (0)
 
 #define iser_warn(fmt, arg...)				\
 	do {						\
+		if (iser_debug_level > 1)		\
+			printk(KERN_WARNING PFX "%s:" fmt,\
+				__func__ , ## arg);	\
+	} while (0)
+
+#define iser_info(fmt, arg...)				\
+	do {						\
 		if (iser_debug_level > 0)		\
-			printk(KERN_DEBUG PFX "%s:" fmt,\
+			pr_info(PFX "%s:" fmt,          \
 				__func__ , ## arg);	\
 	} while (0)
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 4debadc..13838ad 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -74,8 +74,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
 	struct iser_cq_desc *cq_desc;
 
 	device->cqs_used = min(ISER_MAX_CQ, device->ib_device->num_comp_vectors);
-	iser_err("using %d CQs, device %s supports %d vectors\n", device->cqs_used,
-		 device->ib_device->name, device->ib_device->num_comp_vectors);
+	iser_info("using %d CQs, device %s supports %d vectors\n",
+		  device->cqs_used, device->ib_device->name,
+		  device->ib_device->num_comp_vectors);
 
 	device->cq_desc = kmalloc(sizeof(struct iser_cq_desc) * device->cqs_used,
 				  GFP_KERNEL);
@@ -262,7 +263,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 			min_index = index;
 	device->cq_active_qps[min_index]++;
 	mutex_unlock(&ig.connlist_mutex);
-	iser_err("cq index %d used for ib_conn %p\n", min_index, ib_conn);
+	iser_info("cq index %d used for ib_conn %p\n", min_index, ib_conn);
 
 	init_attr.event_handler = iser_qp_event_callback;
 	init_attr.qp_context	= (void *)ib_conn;
@@ -280,9 +281,9 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 		goto out_err;
 
 	ib_conn->qp = ib_conn->cma_id->qp;
-	iser_err("setting conn %p cma_id %p: fmr_pool %p qp %p\n",
-		 ib_conn, ib_conn->cma_id,
-		 ib_conn->fmr_pool, ib_conn->cma_id->qp);
+	iser_info("setting conn %p cma_id %p: fmr_pool %p qp %p\n",
+		  ib_conn, ib_conn->cma_id,
+		  ib_conn->fmr_pool, ib_conn->cma_id->qp);
 	return ret;
 
 out_err:
@@ -299,9 +300,9 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn, int can_destroy_id)
 	int cq_index;
 	BUG_ON(ib_conn == NULL);
 
-	iser_err("freeing conn %p cma_id %p fmr pool %p qp %p\n",
-		 ib_conn, ib_conn->cma_id,
-		 ib_conn->fmr_pool, ib_conn->qp);
+	iser_info("freeing conn %p cma_id %p fmr pool %p qp %p\n",
+		  ib_conn, ib_conn->cma_id,
+		  ib_conn->fmr_pool, ib_conn->qp);
 
 	/* qp is created only once both addr & route are resolved */
 	if (ib_conn->fmr_pool != NULL)
@@ -379,7 +380,7 @@ static void iser_device_try_release(struct iser_device *device)
 {
 	mutex_lock(&ig.device_list_mutex);
 	device->refcount--;
-	iser_err("device %p refcount %d\n",device,device->refcount);
+	iser_info("device %p refcount %d\n", device, device->refcount);
 	if (!device->refcount) {
 		iser_free_device_ib_res(device);
 		list_del(&device->ig_list);
@@ -558,8 +559,8 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 {
 	int ret = 0;
 
-	iser_err("event %d status %d conn %p id %p\n",
-		event->event, event->status, cma_id->context, cma_id);
+	iser_info("event %d status %d conn %p id %p\n",
+		  event->event, event->status, cma_id->context, cma_id);
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
@@ -619,8 +620,8 @@ int iser_connect(struct iser_conn   *ib_conn,
 	/* the device is known only --after-- address resolution */
 	ib_conn->device = NULL;
 
-	iser_err("connecting to: %pI4, port 0x%x\n",
-		 &dst_addr->sin_addr, dst_addr->sin_port);
+	iser_info("connecting to: %pI4, port 0x%x\n",
+		  &dst_addr->sin_addr, dst_addr->sin_port);
 
 	ib_conn->state = ISER_CONN_PENDING;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
