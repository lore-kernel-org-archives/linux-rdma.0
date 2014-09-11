From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES for-3.17] mlx4: Correct the error flows in rereg_mr
Date: Thu, 11 Sep 2014 13:18:37 +0300
Message-ID: <1410430717-6489-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch addresses feedback from Sagi Grimberg on the rereg_mr 
implementation of mlx4, the following is fixed:

1. Set the correct pd_flags 

2. Make sure we change the iova and size MR fields only after 
successful write and allocation of the MTTs.

3. make the error checking more robus

Fixes: e630664 ('mlx4_core: Add helper functions to support MR re-registration')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mr.c         |    7 ++++-
 drivers/net/ethernet/mellanox/mlx4/mr.c |   33 ++++++++++++++++++++----------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 9b0e80e..8f9325c 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -234,14 +234,13 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 					0);
 		if (IS_ERR(mmr->umem)) {
 			err = PTR_ERR(mmr->umem);
+			/* Prevent mlx4_ib_dereg_mr from free'ing invalid pointer */
 			mmr->umem = NULL;
 			goto release_mpt_entry;
 		}
 		n = ib_umem_page_count(mmr->umem);
 		shift = ilog2(mmr->umem->page_size);
 
-		mmr->mmr.iova       = virt_addr;
-		mmr->mmr.size       = length;
 		err = mlx4_mr_rereg_mem_write(dev->dev, &mmr->mmr,
 					      virt_addr, length, n, shift,
 					      *pmpt_entry);
@@ -249,6 +248,8 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 			ib_umem_release(mmr->umem);
 			goto release_mpt_entry;
 		}
+		mmr->mmr.iova       = virt_addr;
+		mmr->mmr.size       = length;
 
 		err = mlx4_ib_umem_write_mtt(dev, &mmr->mmr.mtt, mmr->umem);
 		if (err) {
@@ -262,6 +263,8 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 	 * return a failure. But dereg_mr will free the resources.
 	 */
 	err = mlx4_mr_hw_write_mpt(dev->dev, &mmr->mmr, pmpt_entry);
+	if (!err && flags & IB_MR_REREG_ACCESS)
+		mmr->mmr.access = mr_access_flags;
 
 release_mpt_entry:
 	mlx4_mr_hw_put_mpt(dev->dev, pmpt_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index 7d717ec..193a6ad 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -298,6 +298,7 @@ static int mlx4_HW2SW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
 			    MLX4_CMD_TIME_CLASS_B, MLX4_CMD_WRAPPED);
 }
 
+/* Must protect against concurrent access */
 int mlx4_mr_hw_get_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
 		       struct mlx4_mpt_entry ***mpt_entry)
 {
@@ -305,13 +306,10 @@ int mlx4_mr_hw_get_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
 	int key = key_to_hw_index(mmr->key) & (dev->caps.num_mpts - 1);
 	struct mlx4_cmd_mailbox *mailbox = NULL;
 
-	/* Make sure that at this point we have single-threaded access only */
-
 	if (mmr->enabled != MLX4_MPT_EN_HW)
 		return -EINVAL;
 
 	err = mlx4_HW2SW_MPT(dev, NULL, key);
-
 	if (err) {
 		mlx4_warn(dev, "HW2SW_MPT failed (%d).", err);
 		mlx4_warn(dev, "Most likely the MR has MWs bound to it.\n");
@@ -333,7 +331,6 @@ int mlx4_mr_hw_get_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
 				   0, MLX4_CMD_QUERY_MPT,
 				   MLX4_CMD_TIME_CLASS_B,
 				   MLX4_CMD_WRAPPED);
-
 		if (err)
 			goto free_mailbox;
 
@@ -378,9 +375,10 @@ int mlx4_mr_hw_write_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
 		err = mlx4_SW2HW_MPT(dev, mailbox, key);
 	}
 
-	mmr->pd = be32_to_cpu((*mpt_entry)->pd_flags) & MLX4_MPT_PD_MASK;
-	if (!err)
+	if (!err) {
+		mmr->pd = be32_to_cpu((*mpt_entry)->pd_flags) & MLX4_MPT_PD_MASK;
 		mmr->enabled = MLX4_MPT_EN_HW;
+	}
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx4_mr_hw_write_mpt);
@@ -400,11 +398,12 @@ EXPORT_SYMBOL_GPL(mlx4_mr_hw_put_mpt);
 int mlx4_mr_hw_change_pd(struct mlx4_dev *dev, struct mlx4_mpt_entry *mpt_entry,
 			 u32 pdn)
 {
-	u32 pd_flags = be32_to_cpu(mpt_entry->pd_flags);
+	u32 pd_flags = be32_to_cpu(mpt_entry->pd_flags) & ~MLX4_MPT_PD_MASK;
 	/* The wrapper function will put the slave's id here */
 	if (mlx4_is_mfunc(dev))
 		pd_flags &= ~MLX4_MPT_PD_VF_MASK;
-	mpt_entry->pd_flags = cpu_to_be32((pd_flags &  ~MLX4_MPT_PD_MASK) |
+
+	mpt_entry->pd_flags = cpu_to_be32(pd_flags |
 					  (pdn & MLX4_MPT_PD_MASK)
 					  | MLX4_MPT_PD_FLAG_EN_INV);
 	return 0;
@@ -600,14 +599,18 @@ int mlx4_mr_rereg_mem_write(struct mlx4_dev *dev, struct mlx4_mr *mr,
 {
 	int err;
 
-	mpt_entry->start       = cpu_to_be64(mr->iova);
-	mpt_entry->length      = cpu_to_be64(mr->size);
-	mpt_entry->entity_size = cpu_to_be32(mr->mtt.page_shift);
+	mpt_entry->start       = cpu_to_be64(iova);
+	mpt_entry->length      = cpu_to_be64(size);
+	mpt_entry->entity_size = cpu_to_be32(page_shift);
 
 	err = mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
 	if (err)
 		return err;
 
+	mpt_entry->pd_flags &= cpu_to_be32(MLX4_MPT_PD_MASK |
+					   MLX4_MPT_PD_FLAG_EN_INV);
+	mpt_entry->flags    &= cpu_to_be32(MLX4_MPT_FLAG_FREE |
+					   MLX4_MPT_FLAG_SW_OWNS);
 	if (mr->mtt.order < 0) {
 		mpt_entry->flags |= cpu_to_be32(MLX4_MPT_FLAG_PHYSICAL);
 		mpt_entry->mtt_addr = 0;
@@ -617,6 +620,14 @@ int mlx4_mr_rereg_mem_write(struct mlx4_dev *dev, struct mlx4_mr *mr,
 		if (mr->mtt.page_shift == 0)
 			mpt_entry->mtt_sz    = cpu_to_be32(1 << mr->mtt.order);
 	}
+	if (mr->mtt.order >= 0 && mr->mtt.page_shift == 0) {
+		/* fast register MR in free state */
+		mpt_entry->flags    |= cpu_to_be32(MLX4_MPT_FLAG_FREE);
+		mpt_entry->pd_flags |= cpu_to_be32(MLX4_MPT_PD_FLAG_FAST_REG |
+						   MLX4_MPT_PD_FLAG_RAE);
+	} else {
+		mpt_entry->flags    |= cpu_to_be32(MLX4_MPT_FLAG_SW_OWNS);
+	}
 	mr->enabled = MLX4_MPT_EN_SW;
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
