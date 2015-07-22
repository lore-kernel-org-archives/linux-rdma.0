From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 42/43] iser: Accept arbitrary sg lists mapping if the device supports it
Date: Wed, 22 Jul 2015 09:55:42 +0300
Message-ID: <1437548143-24893-43-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the device support arbitrary sg list mapping (device cap
IB_DEVICE_MAP_ARB_SG set) we allocate the memory regions with
IB_MR_MAP_ARB_SG and skip the counce buffer work around.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |  4 ++++
 drivers/infiniband/ulp/iser/iser_verbs.c  | 20 ++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 094cf8a..690f840 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -781,6 +781,10 @@ iser_handle_unaligned_buf(struct iscsi_iser_task *task,
 	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device,
 						iser_conn->scsi_sg_tablesize);
 	if (aligned_len != mem->dma_nents) {
+		if (device->dev_attr.device_cap_flags & IB_DEVICE_MAP_ARB_SG)
+			/* Arbitrary sg support, no need to bounce :) */
+			return 0;
+
 		err = fall_to_bounce_buf(task, mem, dir);
 		if (err)
 			return err;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 332f784..978e283 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -281,14 +281,18 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 }
 
 static int
-iser_alloc_reg_res(struct ib_device *ib_device,
+iser_alloc_reg_res(struct iser_device *device,
 		   struct ib_pd *pd,
 		   struct iser_reg_resources *res,
 		   unsigned int size)
 {
 	int ret;
+	int flags = 0;
 
-	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG, size, 0);
+	if (device->dev_attr.device_cap_flags & IB_DEVICE_MAP_ARB_SG)
+		flags = IB_MR_MAP_ARB_SG;
+
+	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG, size, flags);
 	if (IS_ERR(res->mr)) {
 		ret = PTR_ERR(res->mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
@@ -306,7 +310,7 @@ iser_free_reg_res(struct iser_reg_resources *rsc)
 }
 
 static int
-iser_alloc_pi_ctx(struct ib_device *ib_device,
+iser_alloc_pi_ctx(struct iser_device *device,
 		  struct ib_pd *pd,
 		  struct iser_fr_desc *desc,
 		  unsigned int size)
@@ -320,7 +324,7 @@ iser_alloc_pi_ctx(struct ib_device *ib_device,
 
 	pi_ctx = desc->pi_ctx;
 
-	ret = iser_alloc_reg_res(ib_device, pd, &pi_ctx->rsc, size);
+	ret = iser_alloc_reg_res(device, pd, &pi_ctx->rsc, size);
 	if (ret) {
 		iser_err("failed to allocate reg_resources\n");
 		goto alloc_reg_res_err;
@@ -353,7 +357,7 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 }
 
 static struct iser_fr_desc *
-iser_create_fastreg_desc(struct ib_device *ib_device,
+iser_create_fastreg_desc(struct iser_device *device,
 			 struct ib_pd *pd,
 			 bool pi_enable,
 			 unsigned int size)
@@ -365,12 +369,12 @@ iser_create_fastreg_desc(struct ib_device *ib_device,
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
@@ -403,7 +407,7 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
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
