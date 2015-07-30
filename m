From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 09/22] IB/iser: Introduce struct iser_reg_resources
Date: Thu, 30 Jul 2015 11:06:22 +0300
Message-ID: <1438243595-32288-10-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Have fast_reg_descriptor hold struct iser_reg_resources
(mr, frpl, valid flag). This will be useful when the
actual buffer registration routines will be passed with
the needed registration resources (i.e. iser_reg_resources)
without being aware of their nature (i.e. data or protection).

In order to achieve this, we remove reg_indicators flags container
and place specific flags (mr_valid) within iser_reg_resources struct.
We also place the sig_mr_valid and sig_protcted flags in iser_pi_context.

This patch also modifies iser_fast_reg_mr to receive the
reg_resources instead of the fast_reg_descriptor and a data/protection
indicator.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |  36 ++++++-----
 drivers/infiniband/ulp/iser/iser_memory.c |  35 +++++------
 drivers/infiniband/ulp/iser/iser_verbs.c  | 101 +++++++++++++++++-------------
 3 files changed, 91 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index d2b6caf..9cdfdbd 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -367,41 +367,45 @@ struct iser_device {
 #define ISER_CHECK_REFTAG	0x0f
 #define ISER_CHECK_APPTAG	0x30
 
-enum iser_reg_indicator {
-	ISER_DATA_KEY_VALID	= 1 << 0,
-	ISER_PROT_KEY_VALID	= 1 << 1,
-	ISER_SIG_KEY_VALID	= 1 << 2,
-	ISER_FASTREG_PROTECTED	= 1 << 3,
+/**
+ * struct iser_reg_resources - Fast registration recources
+ *
+ * @mr:         memory region
+ * @frpl:       fast reg page list
+ * @mr_valid:   is mr valid indicator
+ */
+struct iser_reg_resources {
+	struct ib_mr			 *mr;
+	struct ib_fast_reg_page_list     *frpl;
+	u8				  mr_valid:1;
 };
 
 /**
  * struct iser_pi_context - Protection information context
  *
- * @prot_mr:        protection memory region
- * @prot_frpl:      protection fastreg page list
- * @sig_mr:         signature feature enabled memory region
+ * @rsc:             protection buffer registration resources
+ * @sig_mr:          signature enable memory region
+ * @sig_mr_valid:    is sig_mr valid indicator
+ * @sig_protected:   is region protected indicator
  */
 struct iser_pi_context {
-	struct ib_mr                   *prot_mr;
-	struct ib_fast_reg_page_list   *prot_frpl;
+	struct iser_reg_resources	rsc;
 	struct ib_mr                   *sig_mr;
+	u8                              sig_mr_valid:1;
+	u8                              sig_protected:1;
 };
 
 /**
  * struct fast_reg_descriptor - Fast registration descriptor
  *
  * @list:           entry in connection fastreg pool
- * @data_mr:        data memory region
- * @data_frpl:      data fastreg page list
+ * @rsc:            data buffer registration resources
  * @pi_ctx:         protection information context
- * @reg_indicators: fast registration indicators
  */
 struct fast_reg_descriptor {
 	struct list_head		  list;
-	struct ib_mr			 *data_mr;
-	struct ib_fast_reg_page_list     *data_frpl;
+	struct iser_reg_resources	  rsc;
 	struct iser_pi_context		 *pi_ctx;
-	u8				  reg_indicators;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 56dd53b..e6516bc 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -647,13 +647,12 @@ iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 
 static int
 iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
-		struct fast_reg_descriptor *desc,
+		struct iser_pi_context *pi_ctx,
 		struct iser_mem_reg *data_reg,
 		struct iser_mem_reg *prot_reg,
 		struct iser_mem_reg *sig_reg)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_pi_context *pi_ctx = desc->pi_ctx;
 	struct ib_send_wr sig_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
 	struct ib_sig_attrs sig_attrs;
@@ -666,7 +665,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 
 	iser_set_prot_checks(iser_task->sc, &sig_attrs.check_mask);
 
-	if (!(desc->reg_indicators & ISER_SIG_KEY_VALID)) {
+	if (!pi_ctx->sig_mr_valid) {
 		iser_inv_rkey(&inv_wr, pi_ctx->sig_mr);
 		wr = &inv_wr;
 	}
@@ -694,7 +693,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 		iser_err("reg_sig_mr failed, ret:%d\n", ret);
 		goto err;
 	}
-	desc->reg_indicators &= ~ISER_SIG_KEY_VALID;
+	pi_ctx->sig_mr_valid = 0;
 
 	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
 	sig_reg->rkey = pi_ctx->sig_mr->rkey;
@@ -710,8 +709,7 @@ err:
 
 static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf *mem,
-			    struct fast_reg_descriptor *desc,
-			    enum iser_reg_indicator ind,
+			    struct iser_reg_resources *rsc,
 			    struct iser_mem_reg *reg)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
@@ -726,13 +724,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	if (mem->dma_nents == 1)
 		return iser_reg_dma(device, mem, reg);
 
-	if (ind == ISER_DATA_KEY_VALID) {
-		mr = desc->data_mr;
-		frpl = desc->data_frpl;
-	} else {
-		mr = desc->pi_ctx->prot_mr;
-		frpl = desc->pi_ctx->prot_frpl;
-	}
+	mr = rsc->mr;
+	frpl = rsc->frpl;
 
 	plen = iser_sg_to_page_vec(mem, device->ib_device, frpl->page_list,
 				   &offset, &size);
@@ -741,7 +734,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		return -EINVAL;
 	}
 
-	if (!(desc->reg_indicators & ind)) {
+	if (!rsc->mr_valid) {
 		iser_inv_rkey(&inv_wr, mr);
 		wr = &inv_wr;
 	}
@@ -770,7 +763,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		iser_err("fast registration failed, ret:%d\n", ret);
 		return ret;
 	}
-	desc->reg_indicators &= ~ind;
+	rsc->mr_valid = 0;
 
 	reg->sge.lkey = mr->lkey;
 	reg->rkey = mr->rkey;
@@ -812,8 +805,8 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		mem_reg->mem_h = desc;
 	}
 
-	err = iser_fast_reg_mr(iser_task, mem, desc,
-			       ISER_DATA_KEY_VALID, mem_reg);
+	err = iser_fast_reg_mr(iser_task, mem,
+			       desc ? &desc->rsc : NULL, mem_reg);
 	if (err)
 		goto err_reg;
 
@@ -833,19 +826,19 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 				}
 			}
 
-			err = iser_fast_reg_mr(iser_task, mem, desc,
-					       ISER_PROT_KEY_VALID, &prot_reg);
+			err = iser_fast_reg_mr(iser_task, mem,
+					       &desc->pi_ctx->rsc, &prot_reg);
 			if (err)
 				goto err_reg;
 		}
 
-		err = iser_reg_sig_mr(iser_task, desc, mem_reg,
+		err = iser_reg_sig_mr(iser_task, desc->pi_ctx, mem_reg,
 				      &prot_reg, mem_reg);
 		if (err) {
 			iser_err("Failed to register signature mr\n");
 			return err;
 		}
-		desc->reg_indicators |= ISER_FASTREG_PROTECTED;
+		desc->pi_ctx->sig_protected = 1;
 	}
 
 	return 0;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 0a7ceb9..46b8875 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -280,6 +280,45 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 }
 
 static int
+iser_alloc_reg_res(struct ib_device *ib_device, struct ib_pd *pd,
+		   struct iser_reg_resources *res)
+{
+	int ret;
+
+	res->frpl = ib_alloc_fast_reg_page_list(ib_device,
+						ISCSI_ISER_SG_TABLESIZE + 1);
+	if (IS_ERR(res->frpl)) {
+		ret = PTR_ERR(res->frpl);
+		iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n",
+			 ret);
+		return PTR_ERR(res->frpl);
+	}
+
+	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+			      ISCSI_ISER_SG_TABLESIZE + 1);
+	if (IS_ERR(res->mr)) {
+		ret = PTR_ERR(res->mr);
+		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
+		goto fast_reg_mr_failure;
+	}
+	res->mr_valid = 1;
+
+	return 0;
+
+fast_reg_mr_failure:
+	ib_free_fast_reg_page_list(res->frpl);
+
+	return ret;
+}
+
+static void
+iser_free_reg_res(struct iser_reg_resources *rsc)
+{
+	ib_dereg_mr(rsc->mr);
+	ib_free_fast_reg_page_list(rsc->frpl);
+}
+
+static int
 iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
 		  struct fast_reg_descriptor *desc)
 {
@@ -292,36 +331,25 @@ iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
 
 	pi_ctx = desc->pi_ctx;
 
-	pi_ctx->prot_frpl = ib_alloc_fast_reg_page_list(ib_device,
-					    ISCSI_ISER_SG_TABLESIZE);
-	if (IS_ERR(pi_ctx->prot_frpl)) {
-		ret = PTR_ERR(pi_ctx->prot_frpl);
-		goto prot_frpl_failure;
-	}
-
-	pi_ctx->prot_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
-				      ISCSI_ISER_SG_TABLESIZE + 1);
-	if (IS_ERR(pi_ctx->prot_mr)) {
-		ret = PTR_ERR(pi_ctx->prot_mr);
-		goto prot_mr_failure;
+	ret = iser_alloc_reg_res(ib_device, pd, &pi_ctx->rsc);
+	if (ret) {
+		iser_err("failed to allocate reg_resources\n");
+		goto alloc_reg_res_err;
 	}
-	desc->reg_indicators |= ISER_PROT_KEY_VALID;
 
 	pi_ctx->sig_mr = ib_alloc_mr(pd, IB_MR_TYPE_SIGNATURE, 2);
 	if (IS_ERR(pi_ctx->sig_mr)) {
 		ret = PTR_ERR(pi_ctx->sig_mr);
 		goto sig_mr_failure;
 	}
-	desc->reg_indicators |= ISER_SIG_KEY_VALID;
-	desc->reg_indicators &= ~ISER_FASTREG_PROTECTED;
+	pi_ctx->sig_mr_valid = 1;
+	desc->pi_ctx->sig_protected = 0;
 
 	return 0;
 
 sig_mr_failure:
-	ib_dereg_mr(desc->pi_ctx->prot_mr);
-prot_mr_failure:
-	ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
-prot_frpl_failure:
+	iser_free_reg_res(&pi_ctx->rsc);
+alloc_reg_res_err:
 	kfree(desc->pi_ctx);
 
 	return ret;
@@ -330,8 +358,7 @@ prot_frpl_failure:
 static void
 iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 {
-	ib_free_fast_reg_page_list(pi_ctx->prot_frpl);
-	ib_dereg_mr(pi_ctx->prot_mr);
+	iser_free_reg_res(&pi_ctx->rsc);
 	ib_dereg_mr(pi_ctx->sig_mr);
 	kfree(pi_ctx);
 }
@@ -342,23 +369,11 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 {
 	int ret;
 
-	desc->data_frpl = ib_alloc_fast_reg_page_list(ib_device,
-						      ISCSI_ISER_SG_TABLESIZE + 1);
-	if (IS_ERR(desc->data_frpl)) {
-		ret = PTR_ERR(desc->data_frpl);
-		iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n",
-			 ret);
-		return PTR_ERR(desc->data_frpl);
-	}
-
-	desc->data_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
-				    ISCSI_ISER_SG_TABLESIZE + 1);
-	if (IS_ERR(desc->data_mr)) {
-		ret = PTR_ERR(desc->data_mr);
-		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
-		goto fast_reg_mr_failure;
+	ret = iser_alloc_reg_res(ib_device, pd, &desc->rsc);
+	if (ret) {
+		iser_err("failed to allocate reg_resources\n");
+		return ret;
 	}
-	desc->reg_indicators |= ISER_DATA_KEY_VALID;
 
 	if (pi_enable) {
 		ret = iser_alloc_pi_ctx(ib_device, pd, desc);
@@ -367,10 +382,9 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	}
 
 	return 0;
+
 pi_ctx_alloc_failure:
-	ib_dereg_mr(desc->data_mr);
-fast_reg_mr_failure:
-	ib_free_fast_reg_page_list(desc->data_frpl);
+	iser_free_reg_res(&desc->rsc);
 
 	return ret;
 }
@@ -431,8 +445,7 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 
 	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.pool, list) {
 		list_del(&desc->list);
-		ib_free_fast_reg_page_list(desc->data_frpl);
-		ib_dereg_mr(desc->data_mr);
+		iser_free_reg_res(&desc->rsc);
 		if (desc->pi_ctx)
 			iser_free_pi_ctx(desc->pi_ctx);
 		kfree(desc);
@@ -1244,8 +1257,8 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 	struct ib_mr_status mr_status;
 	int ret;
 
-	if (desc && desc->reg_indicators & ISER_FASTREG_PROTECTED) {
-		desc->reg_indicators &= ~ISER_FASTREG_PROTECTED;
+	if (desc && desc->pi_ctx->sig_protected) {
+		desc->pi_ctx->sig_protected = 0;
 		ret = ib_check_mr_status(desc->pi_ctx->sig_mr,
 					 IB_MR_CHECK_SIG_STATUS, &mr_status);
 		if (ret) {
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
