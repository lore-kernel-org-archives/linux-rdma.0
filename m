From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 6/6] IB/mlx5: Move locks initialization to the corresponding stage
Date: Mon,  1 Jan 2018 13:07:03 +0200
Message-ID: <20180101110703.28759-7-leon@kernel.org>
References: <20180101110703.28759-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110703.28759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Unconditional locks/list and ODP srcu initialization should be done in
the INIT stage. Remove those from the CAPS stage and move them to the
proper stage.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 26 +++++++++++++++-----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 --
 drivers/infiniband/hw/mlx5/odp.c     |  9 ---------
 3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b8952fff1fc8..b9e195d154b1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4026,6 +4026,9 @@ mlx5_ib_get_vector_affinity(struct ib_device *ibdev, int comp_vector)
 
 static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	cleanup_srcu_struct(&dev->mr_srcu);
+#endif
 	kfree(dev->port);
 }
 
@@ -4063,6 +4066,17 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		dev->mdev->priv.eq_table.num_comp_vectors;
 	dev->ib_dev.dev.parent		= &mdev->pdev->dev;
 
+	mutex_init(&dev->flow_db.lock);
+	mutex_init(&dev->cap_mask_mutex);
+	INIT_LIST_HEAD(&dev->qp_list);
+	spin_lock_init(&dev->reset_flow_resource_lock);
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	err = init_srcu_struct(&dev->mr_srcu);
+	if (err)
+		goto err_free_port;
+#endif
+
 	return 0;
 
 err_free_port:
@@ -4198,11 +4212,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
-	mutex_init(&dev->flow_db.lock);
-	mutex_init(&dev->cap_mask_mutex);
-	INIT_LIST_HEAD(&dev->qp_list);
-	spin_lock_init(&dev->reset_flow_resource_lock);
-
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
 	    MLX5_CAP_GEN(dev->mdev, disable_local_lb))
 		mutex_init(&dev->lb_mutex);
@@ -4274,11 +4283,6 @@ static int mlx5_ib_stage_odp_init(struct mlx5_ib_dev *dev)
 	return mlx5_ib_odp_init_one(dev);
 }
 
-static void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
-{
-	mlx5_ib_odp_remove_one(dev);
-}
-
 static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
@@ -4451,7 +4455,7 @@ static const struct mlx5_ib_profile pf_profile = {
 		     mlx5_ib_stage_dev_res_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_ODP,
 		     mlx5_ib_stage_odp_init,
-		     mlx5_ib_stage_odp_cleanup),
+		     NULL),
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_stage_counters_init,
 		     mlx5_ib_stage_counters_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 768fa7334100..b3f2f5cae672 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -998,7 +998,6 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev);
 void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
 		    struct mlx5_pagefault *pfault);
 int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev);
-void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev);
 int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
 void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
@@ -1013,7 +1012,6 @@ static inline void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 }
 
 static inline int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev) { return 0; }
-static inline void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)	    {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
 static inline void mlx5_ib_odp_cleanup(void)				    {}
 static inline void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent) {}
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e2197bdda89c..f1a87a690a4c 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1207,10 +1207,6 @@ int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 {
 	int ret;
 
-	ret = init_srcu_struct(&dev->mr_srcu);
-	if (ret)
-		return ret;
-
 	if (dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT) {
 		ret = mlx5_cmd_null_mkey(dev->mdev, &dev->null_mkey);
 		if (ret) {
@@ -1222,11 +1218,6 @@ int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *dev)
-{
-	cleanup_srcu_struct(&dev->mr_srcu);
-}
-
 int mlx5_ib_odp_init(void)
 {
 	mlx5_imr_ksm_entries = BIT_ULL(get_order(TASK_SIZE) -
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
