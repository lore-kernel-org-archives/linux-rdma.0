From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 13/43] mlx5: Drop mlx5_ib_alloc_fast_reg_mr
Date: Wed, 22 Jul 2015 09:55:13 +0300
Message-ID: <1437548143-24893-14-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  1 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 --
 drivers/infiniband/hw/mlx5/mr.c      | 44 ------------------------------------
 3 files changed, 47 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 82a371f..ce75875 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1503,7 +1503,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
 	dev->ib_dev.process_mad		= mlx5_ib_process_mad;
 	dev->ib_dev.alloc_mr		= mlx5_ib_alloc_mr;
-	dev->ib_dev.alloc_fast_reg_mr	= mlx5_ib_alloc_fast_reg_mr;
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index cd6fb5d..c2916f1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -577,8 +577,6 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_entries,
 			       u32 flags);
-struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
-					int max_page_list_len);
 struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
 							       int page_list_len);
 void mlx5_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 185c963..c8de302 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1344,50 +1344,6 @@ err_free:
 	return ERR_PTR(err);
 }
 
-struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
-					int max_page_list_len)
-{
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct mlx5_create_mkey_mbox_in *in;
-	struct mlx5_ib_mr *mr;
-	int err;
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
-
-	in = kzalloc(sizeof(*in), GFP_KERNEL);
-	if (!in) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
-	in->seg.status = MLX5_MKEY_STATUS_FREE;
-	in->seg.xlt_oct_size = cpu_to_be32((max_page_list_len + 1) / 2);
-	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
-	in->seg.flags = MLX5_PERM_UMR_EN | MLX5_ACCESS_MODE_MTT;
-	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
-	/*
-	 * TBD not needed - issue 197292 */
-	in->seg.log2_page_size = PAGE_SHIFT;
-
-	err = mlx5_core_create_mkey(dev->mdev, &mr->mmr, in, sizeof(*in), NULL,
-				    NULL, NULL);
-	kfree(in);
-	if (err)
-		goto err_free;
-
-	mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.rkey = mr->mmr.key;
-	mr->umem = NULL;
-
-	return &mr->ibmr;
-
-err_free:
-	kfree(mr);
-	return ERR_PTR(err);
-}
-
 struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
 							       int page_list_len)
 {
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
