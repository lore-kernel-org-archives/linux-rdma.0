From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 4/7] net/rds: Avoid calling ib_query_device
Date: Fri, 18 Dec 2015 10:59:47 +0200
Message-ID: <1450429190-5898-5-git-send-email-ogerlitz@mellanox.com>
References: <1450429190-5898-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450429190-5898-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead, use the cached copy of the attributes present on the device.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/rds/ib.c | 34 +++++++++++-----------------------
 net/rds/iw.c | 23 +++++------------------
 2 files changed, 16 insertions(+), 41 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index f222885..9481d55 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -122,44 +122,34 @@ void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
 static void rds_ib_add_one(struct ib_device *device)
 {
 	struct rds_ib_device *rds_ibdev;
-	struct ib_device_attr *dev_attr;
 
 	/* Only handle IB (no iWARP) devices */
 	if (device->node_type != RDMA_NODE_IB_CA)
 		return;
 
-	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
-	if (!dev_attr)
-		return;
-
-	if (ib_query_device(device, dev_attr)) {
-		rdsdebug("Query device failed for %s\n", device->name);
-		goto free_attr;
-	}
-
 	rds_ibdev = kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
 				 ibdev_to_node(device));
 	if (!rds_ibdev)
-		goto free_attr;
+		return;
 
 	spin_lock_init(&rds_ibdev->spinlock);
 	atomic_set(&rds_ibdev->refcount, 1);
 	INIT_WORK(&rds_ibdev->free_work, rds_ib_dev_free);
 
-	rds_ibdev->max_wrs = dev_attr->max_qp_wr;
-	rds_ibdev->max_sge = min(dev_attr->max_sge, RDS_IB_MAX_SGE);
+	rds_ibdev->max_wrs = device->attrs.max_qp_wr;
+	rds_ibdev->max_sge = min(device->attrs.max_sge, RDS_IB_MAX_SGE);
 
-	rds_ibdev->fmr_max_remaps = dev_attr->max_map_per_fmr?: 32;
-	rds_ibdev->max_1m_fmrs = dev_attr->max_mr ?
-		min_t(unsigned int, (dev_attr->max_mr / 2),
+	rds_ibdev->fmr_max_remaps = device->attrs.max_map_per_fmr?: 32;
+	rds_ibdev->max_1m_fmrs = device->attrs.max_mr ?
+		min_t(unsigned int, (device->attrs.max_mr / 2),
 		      rds_ib_fmr_1m_pool_size) : rds_ib_fmr_1m_pool_size;
 
-	rds_ibdev->max_8k_fmrs = dev_attr->max_mr ?
-		min_t(unsigned int, ((dev_attr->max_mr / 2) * RDS_MR_8K_SCALE),
+	rds_ibdev->max_8k_fmrs = device->attrs.max_mr ?
+		min_t(unsigned int, ((device->attrs.max_mr / 2) * RDS_MR_8K_SCALE),
 		      rds_ib_fmr_8k_pool_size) : rds_ib_fmr_8k_pool_size;
 
-	rds_ibdev->max_initiator_depth = dev_attr->max_qp_init_rd_atom;
-	rds_ibdev->max_responder_resources = dev_attr->max_qp_rd_atom;
+	rds_ibdev->max_initiator_depth = device->attrs.max_qp_init_rd_atom;
+	rds_ibdev->max_responder_resources = device->attrs.max_qp_rd_atom;
 
 	rds_ibdev->dev = device;
 	rds_ibdev->pd = ib_alloc_pd(device);
@@ -183,7 +173,7 @@ static void rds_ib_add_one(struct ib_device *device)
 	}
 
 	rdsdebug("RDS/IB: max_mr = %d, max_wrs = %d, max_sge = %d, fmr_max_remaps = %d, max_1m_fmrs = %d, max_8k_fmrs = %d\n",
-		 dev_attr->max_fmr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
+		 device->attrs.max_fmr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
 		 rds_ibdev->fmr_max_remaps, rds_ibdev->max_1m_fmrs,
 		 rds_ibdev->max_8k_fmrs);
 
@@ -202,8 +192,6 @@ static void rds_ib_add_one(struct ib_device *device)
 
 put_dev:
 	rds_ib_dev_put(rds_ibdev);
-free_attr:
-	kfree(dev_attr);
 }
 
 /*
diff --git a/net/rds/iw.c b/net/rds/iw.c
index 576f182..f4a9fff 100644
--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -60,30 +60,20 @@ LIST_HEAD(iw_nodev_conns);
 static void rds_iw_add_one(struct ib_device *device)
 {
 	struct rds_iw_device *rds_iwdev;
-	struct ib_device_attr *dev_attr;
 
 	/* Only handle iwarp devices */
 	if (device->node_type != RDMA_NODE_RNIC)
 		return;
 
-	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
-	if (!dev_attr)
-		return;
-
-	if (ib_query_device(device, dev_attr)) {
-		rdsdebug("Query device failed for %s\n", device->name);
-		goto free_attr;
-	}
-
 	rds_iwdev = kmalloc(sizeof *rds_iwdev, GFP_KERNEL);
 	if (!rds_iwdev)
-		goto free_attr;
+		return;
 
 	spin_lock_init(&rds_iwdev->spinlock);
 
-	rds_iwdev->dma_local_lkey = !!(dev_attr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY);
-	rds_iwdev->max_wrs = dev_attr->max_qp_wr;
-	rds_iwdev->max_sge = min(dev_attr->max_sge, RDS_IW_MAX_SGE);
+	rds_iwdev->dma_local_lkey = !!(device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY);
+	rds_iwdev->max_wrs = device->attrs.max_qp_wr;
+	rds_iwdev->max_sge = min(device->attrs.max_sge, RDS_IW_MAX_SGE);
 
 	rds_iwdev->dev = device;
 	rds_iwdev->pd = ib_alloc_pd(device);
@@ -111,8 +101,7 @@ static void rds_iw_add_one(struct ib_device *device)
 	list_add_tail(&rds_iwdev->list, &rds_iw_devices);
 
 	ib_set_client_data(device, &rds_iw_client, rds_iwdev);
-
-	goto free_attr;
+	return;
 
 err_mr:
 	if (rds_iwdev->mr)
@@ -121,8 +110,6 @@ err_pd:
 	ib_dealloc_pd(rds_iwdev->pd);
 free_dev:
 	kfree(rds_iwdev);
-free_attr:
-	kfree(dev_attr);
 }
 
 static void rds_iw_remove_one(struct ib_device *device, void *client_data)
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
