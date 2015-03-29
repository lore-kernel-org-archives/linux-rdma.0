From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 09/18] iser-target: Introduce isert_[alloc|free]_comps
Date: Sun, 29 Mar 2015 15:52:11 +0300
Message-ID: <1427633540-30352-10-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the code for completion context handling to dedicated
routines. This simplifies the code and removes code duplication.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  106 +++++++++++++++++-------------
 1 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 2a4a435..db5460a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -275,39 +275,31 @@ isert_free_rx_descriptors(struct isert_conn *isert_conn)
 static void isert_cq_work(struct work_struct *);
 static void isert_cq_callback(struct ib_cq *, void *);
 
-static int
-isert_create_device_ib_res(struct isert_device *device)
+static void
+isert_free_comps(struct isert_device *device)
 {
-	struct ib_device *ib_dev = device->ib_device;
-	struct ib_device_attr *dev_attr;
-	int ret = 0, i;
-	int max_cqe;
-
-	dev_attr = &device->dev_attr;
-	ret = isert_query_device(ib_dev, dev_attr);
-	if (ret)
-		return ret;
+	int i;
 
-	max_cqe = min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
+	for (i = 0; i < device->comps_used; i++) {
+		struct isert_comp *comp = &device->comps[i];
 
-	/* asign function handlers */
-	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
-	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
-		device->use_fastreg = 1;
-		device->reg_rdma_mem = isert_reg_rdma;
-		device->unreg_rdma_mem = isert_unreg_rdma;
-	} else {
-		device->use_fastreg = 0;
-		device->reg_rdma_mem = isert_map_rdma;
-		device->unreg_rdma_mem = isert_unmap_cmd;
+		if (comp->cq) {
+			cancel_work_sync(&comp->work);
+			ib_destroy_cq(comp->cq);
+		}
 	}
+	kfree(device->comps);
+}
 
-	/* Check signature cap */
-	device->pi_capable = dev_attr->device_cap_flags &
-			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
+static int
+isert_alloc_comps(struct isert_device *device,
+		  struct ib_device_attr *attr)
+{
+	int i, max_cqe, ret = 0;
 
 	device->comps_used = min(ISERT_MAX_CQ, min_t(int, num_online_cpus(),
-					device->ib_device->num_comp_vectors));
+				 device->ib_device->num_comp_vectors));
+
 	isert_info("Using %d CQs, %s supports %d vectors support "
 		   "Fast registration %d pi_capable %d\n",
 		   device->comps_used, device->ib_device->name,
@@ -321,6 +313,8 @@ isert_create_device_ib_res(struct isert_device *device)
 		return -ENOMEM;
 	}
 
+	max_cqe = min(ISER_MAX_CQ_LEN, attr->max_cqe);
+
 	for (i = 0; i < device->comps_used; i++) {
 		struct isert_comp *comp = &device->comps[i];
 
@@ -332,6 +326,7 @@ isert_create_device_ib_res(struct isert_device *device)
 					(void *)comp,
 					max_cqe, i);
 		if (IS_ERR(comp->cq)) {
+			isert_err("Unable to allocate cq\n");
 			ret = PTR_ERR(comp->cq);
 			comp->cq = NULL;
 			goto out_cq;
@@ -342,6 +337,40 @@ isert_create_device_ib_res(struct isert_device *device)
 			goto out_cq;
 	}
 
+	return 0;
+out_cq:
+	isert_free_comps(device);
+	return ret;
+}
+
+static int
+isert_create_device_ib_res(struct isert_device *device)
+{
+	struct ib_device *ib_dev = device->ib_device;
+	struct ib_device_attr *dev_attr;
+	int ret = 0;
+
+	dev_attr = &device->dev_attr;
+	ret = isert_query_device(ib_dev, dev_attr);
+	if (ret)
+		return ret;
+
+	/* asign function handlers */
+	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
+	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
+		device->use_fastreg = 1;
+		device->reg_rdma_mem = isert_reg_rdma;
+		device->unreg_rdma_mem = isert_unreg_rdma;
+	} else {
+		device->use_fastreg = 0;
+		device->reg_rdma_mem = isert_map_rdma;
+		device->unreg_rdma_mem = isert_unmap_cmd;
+	}
+
+	ret = isert_alloc_comps(device, dev_attr);
+	if (ret)
+		return ret;
+
 	device->pd = ib_alloc_pd(device->ib_device);
 	if (IS_ERR(device->pd)) {
 		ret = PTR_ERR(device->pd);
@@ -358,42 +387,27 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_mr;
 	}
 
+	/* Check signature cap */
+	device->pi_capable = dev_attr->device_cap_flags &
+			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
 
 	return 0;
 
 out_mr:
 	ib_dealloc_pd(device->pd);
 out_cq:
-	for (i = 0; i < device->comps_used; i++) {
-		struct isert_comp *comp = &device->comps[i];
-
-		if (comp->cq) {
-			cancel_work_sync(&comp->work);
-			ib_destroy_cq(comp->cq);
-		}
-	}
-	kfree(device->comps);
-
+	isert_free_comps(device);
 	return ret;
 }
 
 static void
 isert_free_device_ib_res(struct isert_device *device)
 {
-	int i;
-
 	isert_info("device %p\n", device);
 
 	ib_dereg_mr(device->mr);
 	ib_dealloc_pd(device->pd);
-	for (i = 0; i < device->comps_used; i++) {
-		struct isert_comp *comp = &device->comps[i];
-
-		cancel_work_sync(&comp->work);
-		ib_destroy_cq(comp->cq);
-		comp->cq = NULL;
-	}
-	kfree(device->comps);
+	isert_free_comps(device);
 }
 
 static void
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
