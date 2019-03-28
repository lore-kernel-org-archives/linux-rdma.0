From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 12/12] RDMA/mlx5: Remove VF representor profile
Date: Thu, 28 Mar 2019 15:27:42 +0200
Message-ID: <20190328132742.12070-13-leon@kernel.org>
References: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190328132742.12070-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Now that we have a single IB device with multipul ports we can remove
the VF representor profile.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c  | 39 -----------------------
 drivers/infiniband/hw/mlx5/main.c    | 46 ++++++++++------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 17 ----------
 3 files changed, 16 insertions(+), 86 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 224ef6c88d17..cbcc40d776b9 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -7,45 +7,6 @@
 #include "ib_rep.h"
 #include "srq.h"
 
-static const struct mlx5_ib_profile vf_rep_profile = {
-	STAGE_CREATE(MLX5_IB_STAGE_INIT,
-		     mlx5_ib_stage_init_init,
-		     mlx5_ib_stage_init_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_FLOW_DB,
-		     mlx5_ib_stage_rep_flow_db_init,
-		     NULL),
-	STAGE_CREATE(MLX5_IB_STAGE_CAPS,
-		     mlx5_ib_stage_caps_init,
-		     NULL),
-	STAGE_CREATE(MLX5_IB_STAGE_NON_DEFAULT_CB,
-		     mlx5_ib_stage_rep_non_default_cb,
-		     NULL),
-	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
-		     mlx5_ib_stage_rep_roce_init,
-		     mlx5_ib_stage_rep_roce_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
-		     mlx5_init_srq_table,
-		     mlx5_cleanup_srq_table),
-	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
-		     mlx5_ib_stage_dev_res_init,
-		     mlx5_ib_stage_dev_res_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
-		     mlx5_ib_stage_counters_init,
-		     mlx5_ib_stage_counters_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_BFREG,
-		     mlx5_ib_stage_bfrag_init,
-		     mlx5_ib_stage_bfrag_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_PRE_IB_REG_UMR,
-		     NULL,
-		     mlx5_ib_stage_pre_ib_reg_umr_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
-		     mlx5_ib_stage_ib_reg_init,
-		     mlx5_ib_stage_ib_reg_cleanup),
-	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
-		     mlx5_ib_stage_post_ib_reg_umr_init,
-		     NULL),
-};
-
 static int
 mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 57d269c1b874..840240e0367e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5949,7 +5949,7 @@ static struct ib_counters *mlx5_ib_create_counters(struct ib_device *device,
 	return &mcounters->ibcntrs;
 }
 
-void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_cleanup_multiport_master(dev);
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
@@ -5958,7 +5958,7 @@ void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 	}
 }
 
-int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
 	int err;
@@ -6031,20 +6031,6 @@ static int mlx5_ib_stage_flow_db_init(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-int mlx5_ib_stage_rep_flow_db_init(struct mlx5_ib_dev *dev)
-{
-	struct mlx5_ib_dev *nic_dev;
-
-	nic_dev = mlx5_ib_get_uplink_ibdev(dev->mdev->priv.eswitch);
-
-	if (!nic_dev)
-		return -EINVAL;
-
-	dev->flow_db = nic_dev->flow_db;
-
-	return 0;
-}
-
 static void mlx5_ib_stage_flow_db_cleanup(struct mlx5_ib_dev *dev)
 {
 	kfree(dev->flow_db);
@@ -6143,7 +6129,7 @@ static const struct ib_device_ops mlx5_ib_dev_dm_ops = {
 	.reg_dm_mr = mlx5_ib_reg_dm_mr,
 };
 
-int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
 	int err;
@@ -6249,7 +6235,7 @@ static const struct ib_device_ops mlx5_ib_dev_port_rep_ops = {
 	.query_port = mlx5_ib_rep_query_port,
 };
 
-int mlx5_ib_stage_rep_non_default_cb(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_rep_non_default_cb(struct mlx5_ib_dev *dev)
 {
 	ib_set_device_ops(&dev->ib_dev, &mlx5_ib_dev_port_rep_ops);
 	return 0;
@@ -6296,7 +6282,7 @@ static void mlx5_ib_stage_common_roce_cleanup(struct mlx5_ib_dev *dev)
 	mlx5_remove_netdev_notifier(dev, port_num);
 }
 
-int mlx5_ib_stage_rep_roce_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_rep_roce_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
@@ -6312,7 +6298,7 @@ int mlx5_ib_stage_rep_roce_init(struct mlx5_ib_dev *dev)
 	return err;
 }
 
-void mlx5_ib_stage_rep_roce_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_rep_roce_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_stage_common_roce_cleanup(dev);
 }
@@ -6359,12 +6345,12 @@ static void mlx5_ib_stage_roce_cleanup(struct mlx5_ib_dev *dev)
 	}
 }
 
-int mlx5_ib_stage_dev_res_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_dev_res_init(struct mlx5_ib_dev *dev)
 {
 	return create_dev_resources(&dev->devr);
 }
 
-void mlx5_ib_stage_dev_res_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_dev_res_cleanup(struct mlx5_ib_dev *dev)
 {
 	destroy_dev_resources(&dev->devr);
 }
@@ -6390,7 +6376,7 @@ static const struct ib_device_ops mlx5_ib_dev_hw_stats_ops = {
 	.counter_update_stats = mlx5_ib_counter_update_stats,
 };
 
-int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
 		ib_set_device_ops(&dev->ib_dev, &mlx5_ib_dev_hw_stats_ops);
@@ -6401,7 +6387,7 @@ int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-void mlx5_ib_stage_counters_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_counters_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
 		mlx5_ib_dealloc_counters(dev);
@@ -6431,7 +6417,7 @@ static void mlx5_ib_stage_uar_cleanup(struct mlx5_ib_dev *dev)
 	mlx5_put_uars_page(dev->mdev, dev->mdev->priv.uar);
 }
 
-int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 {
 	int err;
 
@@ -6446,13 +6432,13 @@ int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 	return err;
 }
 
-void mlx5_ib_stage_bfrag_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_bfrag_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
 	mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 }
 
-int mlx5_ib_stage_ib_reg_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_ib_reg_init(struct mlx5_ib_dev *dev)
 {
 	const char *name;
 
@@ -6464,17 +6450,17 @@ int mlx5_ib_stage_ib_reg_init(struct mlx5_ib_dev *dev)
 	return ib_register_device(&dev->ib_dev, name);
 }
 
-void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev)
 {
 	destroy_umrc_res(dev);
 }
 
-void mlx5_ib_stage_ib_reg_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_ib_reg_cleanup(struct mlx5_ib_dev *dev)
 {
 	ib_unregister_device(&dev->ib_dev);
 }
 
-int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
 {
 	return create_umr_res(dev);
 }
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7daa20102b1d..505332015ff2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1235,23 +1235,6 @@ static inline void mlx5_ib_invalidate_range(struct ib_umem_odp *umem_odp,
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
 /* Needed for rep profile */
-int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_rep_flow_db_init(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_rep_non_default_cb(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_rep_roce_init(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_rep_roce_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_dev_res_init(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_dev_res_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_counters_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_bfrag_cleanup(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_ib_reg_init(struct mlx5_ib_dev *dev);
-void mlx5_ib_stage_ib_reg_cleanup(struct mlx5_ib_dev *dev);
-int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev);
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage);
-- 
2.20.1
