From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/5] IB/iser: Pass iser device to registration routines
Date: Mon,  8 Jun 2015 16:15:37 +0300
Message-ID: <1433769339-949-4-git-send-email-sagig@mellanox.com>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769339-949-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Will be needed when the device capability flags will be
checked for indirect registration support.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6a407a3..3267a9c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -279,9 +279,11 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 }
 
 static int
-iser_alloc_reg_res(struct ib_device *ib_device, struct ib_pd *pd,
+iser_alloc_reg_res(struct iser_device *device,
+		   struct ib_pd *pd,
 		   struct iser_reg_resources *res)
 {
+	struct ib_device *ib_device = device->ib_device;
 	int ret;
 
 	res->frpl = ib_alloc_fast_reg_page_list(ib_device,
@@ -317,7 +319,8 @@ iser_free_reg_res(struct iser_reg_resources *rsc)
 }
 
 static int
-iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
+iser_alloc_pi_ctx(struct iser_device *device,
+		  struct ib_pd *pd,
 		  struct iser_fr_desc *desc)
 {
 	struct iser_pi_context *pi_ctx = NULL;
@@ -331,7 +334,7 @@ iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
 
 	pi_ctx = desc->pi_ctx;
 
-	ret = iser_alloc_reg_res(ib_device, pd, &pi_ctx->rsc);
+	ret = iser_alloc_reg_res(device, pd, &pi_ctx->rsc);
 	if (ret) {
 		iser_err("failed to allocate reg_resources\n");
 		goto alloc_reg_res_err;
@@ -364,7 +367,8 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 }
 
 static struct iser_fr_desc *
-iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
+iser_create_fastreg_desc(struct iser_device *device,
+			 struct ib_pd *pd,
 			 bool pi_enable)
 {
 	struct iser_fr_desc *desc;
@@ -374,12 +378,12 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
 
-	ret = iser_alloc_reg_res(ib_device, pd, &desc->rsc);
+	ret = iser_alloc_reg_res(device, pd, &desc->rsc);
 	if (ret)
 		goto reg_res_alloc_failure;
 
 	if (pi_enable) {
-		ret = iser_alloc_pi_ctx(ib_device, pd, desc);
+		ret = iser_alloc_pi_ctx(device, pd, desc);
 		if (ret)
 			goto pi_ctx_alloc_failure;
 	}
@@ -410,7 +414,7 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	spin_lock_init(&fr_pool->lock);
 	fr_pool->size = 0;
 	for (i = 0; i < cmds_max; i++) {
-		desc = iser_create_fastreg_desc(device->ib_device, device->pd,
+		desc = iser_create_fastreg_desc(device, device->pd,
 						ib_conn->pi_support);
 		if (IS_ERR(desc))
 			goto err;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
