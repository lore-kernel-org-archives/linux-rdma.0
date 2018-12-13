From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/6] IB/mlx5: Unify e-switch representors load approach between uplink and VFs
Date: Wed, 12 Dec 2018 19:11:37 -0800
Message-ID: <20181213031141.12783-3-saeedm@mellanox.com>
References: <20181213031141.12783-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213031141.12783-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

When in switchdev mode and the add function is called by the core
level driver, make sure we only register the callbacks, but don't
create the mlx5 IB device or initialize anything. With this change
all the IB devices in switchdev mode are created only once the load
callback is invoked by the e-switch core sub-module. This follows
the design paradigm under which the all the Eth representors must
be loaded before any of IB reprs is loaded.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c  | 11 ++++++++++-
 drivers/infiniband/hw/mlx5/main.c    | 29 +++++++++-------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 -
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 8a682d86d634..46a9ddc8ca56 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -48,13 +48,21 @@ static const struct mlx5_ib_profile rep_profile = {
 static int
 mlx5_ib_nic_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
+	struct mlx5_ib_dev *ibdev;
+
+	ibdev = mlx5_ib_rep_to_dev(rep);
+	if (!__mlx5_ib_add(ibdev, ibdev->profile))
+		return -EINVAL;
 	return 0;
 }
 
 static void
 mlx5_ib_nic_rep_unload(struct mlx5_eswitch_rep *rep)
 {
-	rep->rep_if[REP_IB].priv = NULL;
+	struct mlx5_ib_dev *ibdev;
+
+	ibdev = mlx5_ib_rep_to_dev(rep);
+	__mlx5_ib_remove(ibdev, ibdev->profile, MLX5_IB_STAGE_MAX);
 }
 
 static int
@@ -89,6 +97,7 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	dev = mlx5_ib_rep_to_dev(rep);
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 	rep->rep_if[REP_IB].priv = NULL;
+	ib_dealloc_device(&dev->ib_dev);
 }
 
 static void *mlx5_ib_vport_get_proto_dev(struct mlx5_eswitch_rep *rep)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2560996fce79..4a4200a88957 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6214,18 +6214,6 @@ static void mlx5_ib_stage_delay_drop_cleanup(struct mlx5_ib_dev *dev)
 	cancel_delay_drop(dev);
 }
 
-static int mlx5_ib_stage_rep_reg_init(struct mlx5_ib_dev *dev)
-{
-	mlx5_ib_register_vport_reps(dev);
-
-	return 0;
-}
-
-static void mlx5_ib_stage_rep_reg_cleanup(struct mlx5_ib_dev *dev)
-{
-	mlx5_ib_unregister_vport_reps(dev);
-}
-
 static int mlx5_ib_stage_dev_notifier_init(struct mlx5_ib_dev *dev)
 {
 	dev->mdev_events.notifier_call = mlx5_ib_event;
@@ -6264,8 +6252,6 @@ void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		if (profile->stage[stage].cleanup)
 			profile->stage[stage].cleanup(dev);
 	}
-
-	ib_dealloc_device((struct ib_device *)dev);
 }
 
 void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
@@ -6399,9 +6385,6 @@ static const struct mlx5_ib_profile nic_rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_POST_IB_REG_UMR,
 		     mlx5_ib_stage_post_ib_reg_umr_init,
 		     NULL),
-	STAGE_CREATE(MLX5_IB_STAGE_REP_REG,
-		     mlx5_ib_stage_rep_reg_init,
-		     mlx5_ib_stage_rep_reg_cleanup),
 };
 
 static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev)
@@ -6469,8 +6452,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (MLX5_ESWITCH_MANAGER(mdev) &&
 	    mlx5_ib_eswitch_mode(mdev->priv.eswitch) == SRIOV_OFFLOADS) {
 		dev->rep = mlx5_ib_vport_rep(mdev->priv.eswitch, 0);
-
-		return __mlx5_ib_add(dev, &nic_rep_profile);
+		dev->profile = &nic_rep_profile;
+		mlx5_ib_register_vport_reps(dev);
+		return dev;
 	}
 
 	return __mlx5_ib_add(dev, &pf_profile);
@@ -6492,7 +6476,12 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	}
 
 	dev = context;
-	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
+	if (dev->profile == &nic_rep_profile)
+		mlx5_ib_unregister_vport_reps(dev);
+	else
+		__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
+
+	ib_dealloc_device((struct ib_device *)dev);
 }
 
 static struct mlx5_interface mlx5_ib_interface = {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 861b68f2e330..c89b3b44b22e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -790,7 +790,6 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
 	MLX5_IB_STAGE_DELAY_DROP,
 	MLX5_IB_STAGE_CLASS_ATTR,
-	MLX5_IB_STAGE_REP_REG,
 	MLX5_IB_STAGE_MAX,
 };
 
-- 
2.19.2
