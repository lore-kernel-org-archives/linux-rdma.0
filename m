From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 2/6] IB/core: Avoid calling ib_query_device when possible
Date: Thu, 17 Dec 2015 15:18:56 +0200
Message-ID: <1450358340-19361-3-git-send-email-ogerlitz@mellanox.com>
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
 drivers/infiniband/core/cm.c         | 12 +-----------
 drivers/infiniband/core/cma.c        |  8 --------
 drivers/infiniband/core/fmr_pool.c   | 20 ++------------------
 drivers/infiniband/core/sysfs.c      | 14 ++++----------
 drivers/infiniband/core/uverbs_cmd.c | 23 ++++-------------------
 drivers/infiniband/core/verbs.c      |  8 +-------
 6 files changed, 12 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 0a26dd6..7fa2b94 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3731,16 +3731,6 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
 }
 EXPORT_SYMBOL(ib_cm_init_qp_attr);
 
-static void cm_get_ack_delay(struct cm_device *cm_dev)
-{
-	struct ib_device_attr attr;
-
-	if (ib_query_device(cm_dev->ib_device, &attr))
-		cm_dev->ack_delay = 0; /* acks will rely on packet life time */
-	else
-		cm_dev->ack_delay = attr.local_ca_ack_delay;
-}
-
 static ssize_t cm_show_counter(struct kobject *obj, struct attribute *attr,
 			       char *buf)
 {
@@ -3852,7 +3842,7 @@ static void cm_add_one(struct ib_device *ib_device)
 		return;
 
 	cm_dev->ib_device = ib_device;
-	cm_get_ack_delay(cm_dev);
+	cm_dev->ack_delay = ib_device->attrs.local_ca_ack_delay;
 	cm_dev->going_down = 0;
 	cm_dev->device = device_create(&cm_class, &ib_device->dev,
 				       MKDEV(0, 0), NULL,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d2d5d00..f8dfc63 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1894,7 +1894,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	struct rdma_id_private *listen_id, *conn_id;
 	struct rdma_cm_event event;
 	int ret;
-	struct ib_device_attr attr;
 	struct sockaddr *laddr = (struct sockaddr *)&iw_event->local_addr;
 	struct sockaddr *raddr = (struct sockaddr *)&iw_event->remote_addr;
 
@@ -1936,13 +1935,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	memcpy(cma_src_addr(conn_id), laddr, rdma_addr_size(laddr));
 	memcpy(cma_dst_addr(conn_id), raddr, rdma_addr_size(raddr));
 
-	ret = ib_query_device(conn_id->id.device, &attr);
-	if (ret) {
-		mutex_unlock(&conn_id->handler_mutex);
-		rdma_destroy_id(new_cm_id);
-		goto out;
-	}
-
 	memset(&event, 0, sizeof event);
 	event.event = RDMA_CM_EVENT_CONNECT_REQUEST;
 	event.param.conn.private_data = iw_event->private_data;
diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 9f5ad7c..6ac3683 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -212,7 +212,6 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 {
 	struct ib_device   *device;
 	struct ib_fmr_pool *pool;
-	struct ib_device_attr *attr;
 	int i;
 	int ret;
 	int max_remaps;
@@ -228,25 +227,10 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 		return ERR_PTR(-ENOSYS);
 	}
 
-	attr = kmalloc(sizeof *attr, GFP_KERNEL);
-	if (!attr) {
-		printk(KERN_WARNING PFX "couldn't allocate device attr struct\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	ret = ib_query_device(device, attr);
-	if (ret) {
-		printk(KERN_WARNING PFX "couldn't query device: %d\n", ret);
-		kfree(attr);
-		return ERR_PTR(ret);
-	}
-
-	if (!attr->max_map_per_fmr)
+	if (!device->attrs.max_map_per_fmr)
 		max_remaps = IB_FMR_MAX_REMAPS;
 	else
-		max_remaps = attr->max_map_per_fmr;
-
-	kfree(attr);
+		max_remaps = device->attrs.max_map_per_fmr;
 
 	pool = kmalloc(sizeof *pool, GFP_KERNEL);
 	if (!pool) {
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index b1f37d4..1d5b4b0 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -614,18 +614,12 @@ static ssize_t show_sys_image_guid(struct device *device,
 				   struct device_attribute *dev_attr, char *buf)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
-	struct ib_device_attr attr;
-	ssize_t ret;
-
-	ret = ib_query_device(dev, &attr);
-	if (ret)
-		return ret;
 
 	return sprintf(buf, "%04x:%04x:%04x:%04x\n",
-		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[0]),
-		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[1]),
-		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[2]),
-		       be16_to_cpu(((__be16 *) &attr.sys_image_guid)[3]));
+		       be16_to_cpu(((__be16 *) &dev->attrs.sys_image_guid)[0]),
+		       be16_to_cpu(((__be16 *) &dev->attrs.sys_image_guid)[1]),
+		       be16_to_cpu(((__be16 *) &dev->attrs.sys_image_guid)[2]),
+		       be16_to_cpu(((__be16 *) &dev->attrs.sys_image_guid)[3]));
 }
 
 static ssize_t show_node_guid(struct device *device,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e358fa1..cb21af7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -291,9 +291,6 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct ib_uverbs_get_context      cmd;
 	struct ib_uverbs_get_context_resp resp;
 	struct ib_udata                   udata;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	struct ib_device_attr		  dev_attr;
-#endif
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
 	int ret;
@@ -342,10 +339,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	ucontext->odp_mrs_count = 0;
 	INIT_LIST_HEAD(&ucontext->no_private_counters);
 
-	ret = ib_query_device(ib_dev, &dev_attr);
-	if (ret)
-		goto err_free;
-	if (!(dev_attr.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
+	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
 		ucontext->invalidate_range = NULL;
 
 #endif
@@ -447,8 +441,6 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_device      cmd;
 	struct ib_uverbs_query_device_resp resp;
-	struct ib_device_attr              attr;
-	int                                ret;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -456,12 +448,8 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = ib_query_device(ib_dev, &attr);
-	if (ret)
-		return ret;
-
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, ib_dev, &resp, &attr);
+	copy_query_dev_fields(file, ib_dev, &resp, &ib_dev->attrs);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -986,11 +974,8 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	}
 
 	if (cmd.access_flags & IB_ACCESS_ON_DEMAND) {
-		struct ib_device_attr attr;
-
-		ret = ib_query_device(pd->device, &attr);
-		if (ret || !(attr.device_cap_flags &
-				IB_DEVICE_ON_DEMAND_PAGING)) {
+		if (!(pd->device->attrs.device_cap_flags &
+		      IB_DEVICE_ON_DEMAND_PAGING)) {
 			pr_debug("ODP support not available\n");
 			ret = -EINVAL;
 			goto err_put;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 545906d..7617d94 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -229,12 +229,6 @@ EXPORT_SYMBOL(rdma_port_get_link_layer);
 struct ib_pd *ib_alloc_pd(struct ib_device *device)
 {
 	struct ib_pd *pd;
-	struct ib_device_attr devattr;
-	int rc;
-
-	rc = ib_query_device(device, &devattr);
-	if (rc)
-		return ERR_PTR(rc);
 
 	pd = device->alloc_pd(device, NULL, NULL);
 	if (IS_ERR(pd))
@@ -245,7 +239,7 @@ struct ib_pd *ib_alloc_pd(struct ib_device *device)
 	pd->local_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
 
-	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
+	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
 		pd->local_dma_lkey = device->local_dma_lkey;
 	else {
 		struct ib_mr *mr;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
