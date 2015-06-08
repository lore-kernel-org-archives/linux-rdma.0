From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Get rid of redundant verb ib_destroy_mr
Date: Mon,  8 Jun 2015 16:14:43 +0300
Message-ID: <1433769283-30541-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This was added in a thought of uniting all mr allocation
and deallocation routines but the fact is we have a single
deallocation routine already, ib_dereg_mr.

And, move mlx5_ib_destroy_mr specific logic into mlx5_ib_dereg_mr
(includes only signature stuff for now).

And, fixup the only callers (iser/isert) accordingly.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c          |   17 ------------
 drivers/infiniband/hw/mlx5/main.c        |    1 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |    1 -
 drivers/infiniband/hw/mlx5/mr.c          |   42 ++++++++---------------------
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c  |    2 +-
 include/rdma/ib_verbs.h                  |   10 -------
 7 files changed, 14 insertions(+), 61 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 658c283..927cf2e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1256,23 +1256,6 @@ struct ib_mr *ib_create_mr(struct ib_pd *pd,
 }
 EXPORT_SYMBOL(ib_create_mr);
 
-int ib_destroy_mr(struct ib_mr *mr)
-{
-	struct ib_pd *pd;
-	int ret;
-
-	if (atomic_read(&mr->usecnt))
-		return -EBUSY;
-
-	pd = mr->pd;
-	ret = mr->device->destroy_mr(mr);
-	if (!ret)
-		atomic_dec(&pd->usecnt);
-
-	return ret;
-}
-EXPORT_SYMBOL(ib_destroy_mr);
-
 struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
 {
 	struct ib_mr *mr;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b2fdb9c..582bfd9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1293,7 +1293,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.get_dma_mr		= mlx5_ib_get_dma_mr;
 	dev->ib_dev.reg_user_mr		= mlx5_ib_reg_user_mr;
 	dev->ib_dev.dereg_mr		= mlx5_ib_dereg_mr;
-	dev->ib_dev.destroy_mr		= mlx5_ib_destroy_mr;
 	dev->ib_dev.attach_mcast	= mlx5_ib_mcg_attach;
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
 	dev->ib_dev.process_mad		= mlx5_ib_process_mad;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c621903..d8e07c1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -571,7 +571,6 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
 		       int npages, int zap);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
-int mlx5_ib_destroy_mr(struct ib_mr *ibmr);
 struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 				struct ib_mr_init_attr *mr_init_attr);
 struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 71c5935..04b6787 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1174,6 +1174,18 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 	int umred = mr->umred;
 	int err;
 
+	if (mr->sig) {
+		if (mlx5_core_destroy_psv(dev->mdev,
+					  mr->sig->psv_memory.psv_idx))
+			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
+				     mr->sig->psv_memory.psv_idx);
+		if (mlx5_core_destroy_psv(dev->mdev,
+					  mr->sig->psv_wire.psv_idx))
+			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
+				     mr->sig->psv_wire.psv_idx);
+		kfree(mr->sig);
+	}
+
 	if (!umred) {
 		err = destroy_mkey(dev, mr);
 		if (err) {
@@ -1321,36 +1333,6 @@ err_free:
 	return ERR_PTR(err);
 }
 
-int mlx5_ib_destroy_mr(struct ib_mr *ibmr)
-{
-	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
-	struct mlx5_ib_mr *mr = to_mmr(ibmr);
-	int err;
-
-	if (mr->sig) {
-		if (mlx5_core_destroy_psv(dev->mdev,
-					  mr->sig->psv_memory.psv_idx))
-			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
-				     mr->sig->psv_memory.psv_idx);
-		if (mlx5_core_destroy_psv(dev->mdev,
-					  mr->sig->psv_wire.psv_idx))
-			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
-				     mr->sig->psv_wire.psv_idx);
-		kfree(mr->sig);
-	}
-
-	err = destroy_mkey(dev, mr);
-	if (err) {
-		mlx5_ib_warn(dev, "failed to destroy mkey 0x%x (%d)\n",
-			     mr->mmr.key, err);
-		return err;
-	}
-
-	kfree(mr);
-
-	return err;
-}
-
 struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len)
 {
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index d33c5c0..32906fa 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -331,7 +331,7 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 {
 	ib_free_fast_reg_page_list(pi_ctx->prot_frpl);
 	ib_dereg_mr(pi_ctx->prot_mr);
-	ib_destroy_mr(pi_ctx->sig_mr);
+	ib_dereg_mr(pi_ctx->sig_mr);
 	kfree(pi_ctx);
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d99a0c8..51a2859 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -486,7 +486,7 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 		if (fr_desc->pi_ctx) {
 			ib_free_fast_reg_page_list(fr_desc->pi_ctx->prot_frpl);
 			ib_dereg_mr(fr_desc->pi_ctx->prot_mr);
-			ib_destroy_mr(fr_desc->pi_ctx->sig_mr);
+			ib_dereg_mr(fr_desc->pi_ctx->sig_mr);
 			kfree(fr_desc->pi_ctx);
 		}
 		kfree(fr_desc);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7d78794..3fedea5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1652,7 +1652,6 @@ struct ib_device {
 	int                        (*query_mr)(struct ib_mr *mr,
 					       struct ib_mr_attr *mr_attr);
 	int                        (*dereg_mr)(struct ib_mr *mr);
-	int                        (*destroy_mr)(struct ib_mr *mr);
 	struct ib_mr *		   (*create_mr)(struct ib_pd *pd,
 						struct ib_mr_init_attr *mr_init_attr);
 	struct ib_mr *		   (*alloc_fast_reg_mr)(struct ib_pd *pd,
@@ -2758,15 +2757,6 @@ struct ib_mr *ib_create_mr(struct ib_pd *pd,
 			   struct ib_mr_init_attr *mr_init_attr);
 
 /**
- * ib_destroy_mr - Destroys a memory region that was created using
- *     ib_create_mr and removes it from HW translation tables.
- * @mr: The memory region to destroy.
- *
- * This function can fail, if the memory region has memory windows bound to it.
- */
-int ib_destroy_mr(struct ib_mr *mr);
-
-/**
  * ib_alloc_fast_reg_mr - Allocates memory region usable with the
  *   IB_WR_FAST_REG_MR send work request.
  * @pd: The protection domain associated with the region.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
