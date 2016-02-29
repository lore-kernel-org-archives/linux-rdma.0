From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] iser: Accept arbitrary sg lists mapping if the device supports it
Date: Mon, 29 Feb 2016 19:07:34 +0200
Message-ID: <1456765654-27592-4-git-send-email-sagig@mellanox.com>
References: <1456765654-27592-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456765654-27592-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the device support arbitrary sg list mapping (device cap
IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
IB_MR_TYPE_SG_GAPS and allow the block layer to pass us
gaps by skip setting the queue virt_boundary.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 11 ++++++++++-
 drivers/infiniband/ulp/iser/iser_verbs.c | 23 +++++++++++++++--------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index c827c93f46c5..80b6bedc172f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -969,7 +969,16 @@ static umode_t iser_attr_is_visible(int param_type, int param)
 
 static int iscsi_iser_slave_alloc(struct scsi_device *sdev)
 {
-	blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K);
+	struct iscsi_session *session;
+	struct iser_conn *iser_conn;
+	struct ib_device *ib_dev;
+
+	session = starget_to_session(scsi_target(sdev))->dd_data;
+	iser_conn = session->leadconn->dd_data;
+	ib_dev = iser_conn->ib_conn.device->ib_device;
+
+	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+		blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K);
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 40c0f4978e2f..f21bdcc34d59 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -252,14 +252,21 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 }
 
 static int
-iser_alloc_reg_res(struct ib_device *ib_device,
+iser_alloc_reg_res(struct iser_device *device,
 		   struct ib_pd *pd,
 		   struct iser_reg_resources *res,
 		   unsigned int size)
 {
+	struct ib_device *ib_dev = device->ib_device;
+	enum ib_mr_type mr_type;
 	int ret;
 
-	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, size);
+	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+		mr_type = IB_MR_TYPE_SG_GAPS;
+	else
+		mr_type = IB_MR_TYPE_MEM_REG;
+
+	res->mr = ib_alloc_mr(pd, mr_type, size);
 	if (IS_ERR(res->mr)) {
 		ret = PTR_ERR(res->mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
@@ -277,7 +284,7 @@ iser_free_reg_res(struct iser_reg_resources *rsc)
 }
 
 static int
-iser_alloc_pi_ctx(struct ib_device *ib_device,
+iser_alloc_pi_ctx(struct iser_device *device,
 		  struct ib_pd *pd,
 		  struct iser_fr_desc *desc,
 		  unsigned int size)
@@ -291,7 +298,7 @@ iser_alloc_pi_ctx(struct ib_device *ib_device,
 
 	pi_ctx = desc->pi_ctx;
 
-	ret = iser_alloc_reg_res(ib_device, pd, &pi_ctx->rsc, size);
+	ret = iser_alloc_reg_res(device, pd, &pi_ctx->rsc, size);
 	if (ret) {
 		iser_err("failed to allocate reg_resources\n");
 		goto alloc_reg_res_err;
@@ -324,7 +331,7 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 }
 
 static struct iser_fr_desc *
-iser_create_fastreg_desc(struct ib_device *ib_device,
+iser_create_fastreg_desc(struct iser_device *device,
 			 struct ib_pd *pd,
 			 bool pi_enable,
 			 unsigned int size)
@@ -336,12 +343,12 @@ iser_create_fastreg_desc(struct ib_device *ib_device,
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
 
-	ret = iser_alloc_reg_res(ib_device, pd, &desc->rsc, size);
+	ret = iser_alloc_reg_res(device, pd, &desc->rsc, size);
 	if (ret)
 		goto reg_res_alloc_failure;
 
 	if (pi_enable) {
-		ret = iser_alloc_pi_ctx(ib_device, pd, desc, size);
+		ret = iser_alloc_pi_ctx(device, pd, desc, size);
 		if (ret)
 			goto pi_ctx_alloc_failure;
 	}
@@ -374,7 +381,7 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
 	spin_lock_init(&fr_pool->lock);
 	fr_pool->size = 0;
 	for (i = 0; i < cmds_max; i++) {
-		desc = iser_create_fastreg_desc(device->ib_device, device->pd,
+		desc = iser_create_fastreg_desc(device, device->pd,
 						ib_conn->pi_support, size);
 		if (IS_ERR(desc)) {
 			ret = PTR_ERR(desc);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
