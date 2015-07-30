From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 13/22] IB/iser: Move fastreg descriptor allocation to iser_create_fastreg_desc
Date: Thu, 30 Jul 2015 11:06:26 +0300
Message-ID: <1438243595-32288-14-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Don't have the caller allocate the structure and worry about
freeing it in case the routine failed.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 38 ++++++++++++++------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ca0aba3..5f3af96 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -341,17 +341,20 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 	kfree(pi_ctx);
 }
 
-static int
+static struct iser_fr_desc *
 iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
-			 bool pi_enable, struct iser_fr_desc *desc)
+			 bool pi_enable)
 {
+	struct iser_fr_desc *desc;
 	int ret;
 
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return ERR_PTR(-ENOMEM);
+
 	ret = iser_alloc_reg_res(ib_device, pd, &desc->rsc);
-	if (ret) {
-		iser_err("failed to allocate reg_resources\n");
-		return ret;
-	}
+	if (ret)
+		goto reg_res_alloc_failure;
 
 	if (pi_enable) {
 		ret = iser_alloc_pi_ctx(ib_device, pd, desc);
@@ -359,12 +362,14 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 			goto pi_ctx_alloc_failure;
 	}
 
-	return 0;
+	return desc;
 
 pi_ctx_alloc_failure:
 	iser_free_reg_res(&desc->rsc);
+reg_res_alloc_failure:
+	kfree(desc);
 
-	return ret;
+	return ERR_PTR(ret);
 }
 
 /**
@@ -381,19 +386,10 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
 	ib_conn->fastreg.pool_size = 0;
 	for (i = 0; i < cmds_max; i++) {
-		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
-		if (!desc) {
-			iser_err("Failed to allocate a new fast_reg descriptor\n");
-			ret = -ENOMEM;
-			goto err;
-		}
-
-		ret = iser_create_fastreg_desc(device->ib_device, device->pd,
-					       ib_conn->pi_support, desc);
-		if (ret) {
-			iser_err("Failed to create fastreg descriptor err=%d\n",
-				 ret);
-			kfree(desc);
+		desc = iser_create_fastreg_desc(device->ib_device, device->pd,
+						ib_conn->pi_support);
+		if (IS_ERR(desc)) {
+			ret = PTR_ERR(desc);
 			goto err;
 		}
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
