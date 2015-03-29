From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 12/18] IB/iser: Move PI context alloc/free to routines
Date: Sun, 29 Mar 2015 15:45:26 +0300
Message-ID: <1427633132-23910-13-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make iser_[create|destroy]_fastreg_desc shorter, more
readable and easily extendable.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |  118 ++++++++++++++++--------------
 1 files changed, 63 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 20eec09..cc2dd35 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -274,6 +274,65 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 }
 
 static int
+iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
+		  struct fast_reg_descriptor *desc)
+{
+	struct iser_pi_context *pi_ctx = NULL;
+	struct ib_mr_init_attr mr_init_attr = {.max_reg_descriptors = 2,
+					       .flags = IB_MR_SIGNATURE_EN};
+	int ret = 0;
+
+	desc->pi_ctx = kzalloc(sizeof(*desc->pi_ctx), GFP_KERNEL);
+	if (!desc->pi_ctx)
+		return -ENOMEM;
+
+	pi_ctx = desc->pi_ctx;
+
+	pi_ctx->prot_frpl = ib_alloc_fast_reg_page_list(ib_device,
+					    ISCSI_ISER_SG_TABLESIZE);
+	if (IS_ERR(pi_ctx->prot_frpl)) {
+		ret = PTR_ERR(pi_ctx->prot_frpl);
+		goto prot_frpl_failure;
+	}
+
+	pi_ctx->prot_mr = ib_alloc_fast_reg_mr(pd,
+					ISCSI_ISER_SG_TABLESIZE + 1);
+	if (IS_ERR(pi_ctx->prot_mr)) {
+		ret = PTR_ERR(pi_ctx->prot_mr);
+		goto prot_mr_failure;
+	}
+	desc->reg_indicators |= ISER_PROT_KEY_VALID;
+
+	pi_ctx->sig_mr = ib_create_mr(pd, &mr_init_attr);
+	if (IS_ERR(pi_ctx->sig_mr)) {
+		ret = PTR_ERR(pi_ctx->sig_mr);
+		goto sig_mr_failure;
+	}
+	desc->reg_indicators |= ISER_SIG_KEY_VALID;
+	desc->reg_indicators &= ~ISER_FASTREG_PROTECTED;
+
+	return 0;
+
+sig_mr_failure:
+	ib_dereg_mr(desc->pi_ctx->prot_mr);
+prot_mr_failure:
+	ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
+prot_frpl_failure:
+	kfree(desc->pi_ctx);
+
+	return ret;
+}
+
+static void
+iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
+{
+	ib_free_fast_reg_page_list(pi_ctx->prot_frpl);
+	ib_dereg_mr(pi_ctx->prot_mr);
+	ib_destroy_mr(pi_ctx->sig_mr);
+	kfree(pi_ctx);
+}
+
+static int
 iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 			 bool pi_enable, struct fast_reg_descriptor *desc)
 {
@@ -297,59 +356,12 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	desc->reg_indicators |= ISER_DATA_KEY_VALID;
 
 	if (pi_enable) {
-		struct ib_mr_init_attr mr_init_attr = {0};
-		struct iser_pi_context *pi_ctx = NULL;
-
-		desc->pi_ctx = kzalloc(sizeof(*desc->pi_ctx), GFP_KERNEL);
-		if (!desc->pi_ctx) {
-			iser_err("Failed to allocate pi context\n");
-			ret = -ENOMEM;
+		ret = iser_alloc_pi_ctx(ib_device, pd, desc);
+		if (ret)
 			goto pi_ctx_alloc_failure;
-		}
-		pi_ctx = desc->pi_ctx;
-
-		pi_ctx->prot_frpl = ib_alloc_fast_reg_page_list(ib_device,
-						    ISCSI_ISER_SG_TABLESIZE);
-		if (IS_ERR(pi_ctx->prot_frpl)) {
-			ret = PTR_ERR(pi_ctx->prot_frpl);
-			iser_err("Failed to allocate prot frpl ret=%d\n",
-				 ret);
-			goto prot_frpl_failure;
-		}
-
-		pi_ctx->prot_mr = ib_alloc_fast_reg_mr(pd,
-						ISCSI_ISER_SG_TABLESIZE + 1);
-		if (IS_ERR(pi_ctx->prot_mr)) {
-			ret = PTR_ERR(pi_ctx->prot_mr);
-			iser_err("Failed to allocate prot frmr ret=%d\n",
-				 ret);
-			goto prot_mr_failure;
-		}
-		desc->reg_indicators |= ISER_PROT_KEY_VALID;
-
-		mr_init_attr.max_reg_descriptors = 2;
-		mr_init_attr.flags |= IB_MR_SIGNATURE_EN;
-		pi_ctx->sig_mr = ib_create_mr(pd, &mr_init_attr);
-		if (IS_ERR(pi_ctx->sig_mr)) {
-			ret = PTR_ERR(pi_ctx->sig_mr);
-			iser_err("Failed to allocate signature enabled mr err=%d\n",
-				 ret);
-			goto sig_mr_failure;
-		}
-		desc->reg_indicators |= ISER_SIG_KEY_VALID;
 	}
-	desc->reg_indicators &= ~ISER_FASTREG_PROTECTED;
-
-	iser_dbg("Create fr_desc %p page_list %p\n",
-		 desc, desc->data_frpl->page_list);
 
 	return 0;
-sig_mr_failure:
-	ib_dereg_mr(desc->pi_ctx->prot_mr);
-prot_mr_failure:
-	ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
-prot_frpl_failure:
-	kfree(desc->pi_ctx);
 pi_ctx_alloc_failure:
 	ib_dereg_mr(desc->data_mr);
 fast_reg_mr_failure:
@@ -416,12 +428,8 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 		list_del(&desc->list);
 		ib_free_fast_reg_page_list(desc->data_frpl);
 		ib_dereg_mr(desc->data_mr);
-		if (desc->pi_ctx) {
-			ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
-			ib_dereg_mr(desc->pi_ctx->prot_mr);
-			ib_destroy_mr(desc->pi_ctx->sig_mr);
-			kfree(desc->pi_ctx);
-		}
+		if (desc->pi_ctx)
+			iser_free_pi_ctx(desc->pi_ctx);
 		kfree(desc);
 		++i;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
