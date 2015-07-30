From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-4.3 09/15] mlx4: Support ib_alloc_mr verb
Date: Thu, 30 Jul 2015 10:32:42 +0300
Message-ID: <1438241568-3685-10-git-send-email-sagig@mellanox.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nfs@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c    |  2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  5 +++--
 drivers/infiniband/hw/mlx4/mr.c      | 11 ++++++++---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 05166b7..9ab73a4 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2294,7 +2294,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.reg_user_mr	= mlx4_ib_reg_user_mr;
 	ibdev->ib_dev.rereg_user_mr	= mlx4_ib_rereg_user_mr;
 	ibdev->ib_dev.dereg_mr		= mlx4_ib_dereg_mr;
-	ibdev->ib_dev.alloc_fast_reg_mr = mlx4_ib_alloc_fast_reg_mr;
+	ibdev->ib_dev.alloc_mr		= mlx4_ib_alloc_mr;
 	ibdev->ib_dev.alloc_fast_reg_page_list = mlx4_ib_alloc_fast_reg_page_list;
 	ibdev->ib_dev.free_fast_reg_page_list  = mlx4_ib_free_fast_reg_page_list;
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 9066fc2..80228b2 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -679,8 +679,9 @@ struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
 int mlx4_ib_bind_mw(struct ib_qp *qp, struct ib_mw *mw,
 		    struct ib_mw_bind *mw_bind);
 int mlx4_ib_dealloc_mw(struct ib_mw *mw);
-struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
-					int max_page_list_len);
+struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
+			       enum ib_mr_type mr_type,
+			       u32 max_num_sg);
 struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
 							       int page_list_len);
 void mlx4_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index e0d2717..2542fd3 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -350,19 +350,24 @@ int mlx4_ib_dealloc_mw(struct ib_mw *ibmw)
 	return 0;
 }
 
-struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
-					int max_page_list_len)
+struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
+			       enum ib_mr_type mr_type,
+			       u32 max_num_sg)
 {
 	struct mlx4_ib_dev *dev = to_mdev(pd->device);
 	struct mlx4_ib_mr *mr;
 	int err;
 
+	if (mr_type != IB_MR_TYPE_MEM_REG ||
+	    max_num_sg > MLX4_MAX_FAST_REG_PAGES)
+		return ERR_PTR(-EINVAL);
+
 	mr = kmalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
 	err = mlx4_mr_alloc(dev->dev, to_mpd(pd)->pdn, 0, 0, 0,
-			    max_page_list_len, 0, &mr->mmr);
+			    max_num_sg, 0, &mr->mmr);
 	if (err)
 		goto err_free;
 
-- 
1.8.4.3
