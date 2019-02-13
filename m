From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/15] IB/mlx5: Use unified register/load function for uplink and VF vports
Date: Tue, 12 Feb 2019 22:55:34 -0800
Message-ID: <20190213065546.3013-4-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

IB driver maintains different registration and load function calls
for uplink and VF vports. This is not necessary as they only differ
with each other on their profiles.

This patch doesn't change any functionality.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 73 +++++++----------------------
 drivers/infiniband/hw/mlx5/ib_rep.h | 10 ++--
 drivers/infiniband/hw/mlx5/main.c   | 26 +++++-----
 3 files changed, 37 insertions(+), 72 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 46a9ddc8ca56..3fb22967c098 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -6,7 +6,7 @@
 #include "ib_rep.h"
 #include "srq.h"
 
-static const struct mlx5_ib_profile rep_profile = {
+static const struct mlx5_ib_profile vf_rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_INIT,
 		     mlx5_ib_stage_init_init,
 		     mlx5_ib_stage_init_cleanup),
@@ -45,31 +45,18 @@ static const struct mlx5_ib_profile rep_profile = {
 		     NULL),
 };
 
-static int
-mlx5_ib_nic_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
-{
-	struct mlx5_ib_dev *ibdev;
-
-	ibdev = mlx5_ib_rep_to_dev(rep);
-	if (!__mlx5_ib_add(ibdev, ibdev->profile))
-		return -EINVAL;
-	return 0;
-}
-
-static void
-mlx5_ib_nic_rep_unload(struct mlx5_eswitch_rep *rep)
-{
-	struct mlx5_ib_dev *ibdev;
-
-	ibdev = mlx5_ib_rep_to_dev(rep);
-	__mlx5_ib_remove(ibdev, ibdev->profile, MLX5_IB_STAGE_MAX);
-}
-
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
+#define FDB_UPLINK_VPORT 0xffff
+	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
 
+	if (rep->vport == FDB_UPLINK_VPORT)
+		profile = &uplink_rep_profile;
+	else
+		profile = &vf_rep_profile;
+
 	ibdev = (struct mlx5_ib_dev *)ib_alloc_device(sizeof(*ibdev));
 	if (!ibdev)
 		return -ENOMEM;
@@ -78,7 +65,7 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	ibdev->mdev = dev;
 	ibdev->num_ports = max(MLX5_CAP_GEN(dev, num_ports),
 			       MLX5_CAP_GEN(dev, num_vhca_ports));
-	if (!__mlx5_ib_add(ibdev, &rep_profile))
+	if (!__mlx5_ib_add(ibdev, profile))
 		return -EINVAL;
 
 	rep->rep_if[REP_IB].priv = ibdev;
@@ -105,15 +92,14 @@ static void *mlx5_ib_vport_get_proto_dev(struct mlx5_eswitch_rep *rep)
 	return mlx5_ib_rep_to_dev(rep);
 }
 
-static void mlx5_ib_rep_register_vf_vports(struct mlx5_ib_dev *dev)
+void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_eswitch *esw   = dev->mdev->priv.eswitch;
-	int total_vfs = MLX5_TOTAL_VPORTS(dev->mdev);
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	int total_vports = MLX5_TOTAL_VPORTS(mdev);
+	struct mlx5_eswitch_rep_if rep_if = {};
 	int vport;
 
-	for (vport = 1; vport < total_vfs; vport++) {
-		struct mlx5_eswitch_rep_if rep_if = {};
-
+	for (vport = 0; vport < total_vports; vport++) {
 		rep_if.load = mlx5_ib_vport_rep_load;
 		rep_if.unload = mlx5_ib_vport_rep_unload;
 		rep_if.get_proto_dev = mlx5_ib_vport_get_proto_dev;
@@ -121,39 +107,16 @@ static void mlx5_ib_rep_register_vf_vports(struct mlx5_ib_dev *dev)
 	}
 }
 
-static void mlx5_ib_rep_unregister_vf_vports(struct mlx5_ib_dev *dev)
+void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_eswitch *esw   = dev->mdev->priv.eswitch;
-	int total_vfs = MLX5_TOTAL_VPORTS(dev->mdev);
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	int total_vports = MLX5_TOTAL_VPORTS(mdev);
 	int vport;
 
-	for (vport = 1; vport < total_vfs; vport++)
+	for (vport = total_vports - 1; vport >= 0; vport--)
 		mlx5_eswitch_unregister_vport_rep(esw, vport, REP_IB);
 }
 
-void mlx5_ib_register_vport_reps(struct mlx5_ib_dev *dev)
-{
-	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
-	struct mlx5_eswitch_rep_if rep_if = {};
-
-	rep_if.load = mlx5_ib_nic_rep_load;
-	rep_if.unload = mlx5_ib_nic_rep_unload;
-	rep_if.get_proto_dev = mlx5_ib_vport_get_proto_dev;
-	rep_if.priv = dev;
-
-	mlx5_eswitch_register_vport_rep(esw, 0, &rep_if, REP_IB);
-
-	mlx5_ib_rep_register_vf_vports(dev);
-}
-
-void mlx5_ib_unregister_vport_reps(struct mlx5_ib_dev *dev)
-{
-	struct mlx5_eswitch *esw   = dev->mdev->priv.eswitch;
-
-	mlx5_ib_rep_unregister_vf_vports(dev); /* VFs vports */
-	mlx5_eswitch_unregister_vport_rep(esw, 0, REP_IB); /* UPLINK PF*/
-}
-
 u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw)
 {
 	return mlx5_eswitch_mode(esw);
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
index 2ba73636a2fb..798d41e61fb4 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -10,14 +10,16 @@
 #include "mlx5_ib.h"
 
 #ifdef CONFIG_MLX5_ESWITCH
+extern const struct mlx5_ib_profile uplink_rep_profile;
+
 u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw);
 struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
 					  int vport_index);
 struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw);
 struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
 					   int vport_index);
-void mlx5_ib_register_vport_reps(struct mlx5_ib_dev *dev);
-void mlx5_ib_unregister_vport_reps(struct mlx5_ib_dev *dev);
+void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev);
+void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev);
 int create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 			      struct mlx5_ib_sq *sq);
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
@@ -48,8 +50,8 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
 	return NULL;
 }
 
-static inline void mlx5_ib_register_vport_reps(struct mlx5_ib_dev *dev) {}
-static inline void mlx5_ib_unregister_vport_reps(struct mlx5_ib_dev *dev) {}
+static inline void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev) {}
+static inline void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev) {}
 static inline int create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 					    struct mlx5_ib_sq *sq)
 {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 94fe253d4956..87ce62e44898 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6386,7 +6386,7 @@ static const struct mlx5_ib_profile pf_profile = {
 		     mlx5_ib_stage_delay_drop_cleanup),
 };
 
-static const struct mlx5_ib_profile nic_rep_profile = {
+const struct mlx5_ib_profile uplink_rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_INIT,
 		     mlx5_ib_stage_init_init,
 		     mlx5_ib_stage_init_cleanup),
@@ -6479,6 +6479,12 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	printk_once(KERN_INFO "%s", mlx5_version);
 
+	if (MLX5_ESWITCH_MANAGER(mdev) &&
+	    mlx5_ib_eswitch_mode(mdev->priv.eswitch) == SRIOV_OFFLOADS) {
+		mlx5_ib_register_vport_reps(mdev);
+		return mdev;
+	}
+
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
@@ -6493,14 +6499,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->num_ports = max(MLX5_CAP_GEN(mdev, num_ports),
 			     MLX5_CAP_GEN(mdev, num_vhca_ports));
 
-	if (MLX5_ESWITCH_MANAGER(mdev) &&
-	    mlx5_ib_eswitch_mode(mdev->priv.eswitch) == SRIOV_OFFLOADS) {
-		dev->rep = mlx5_ib_vport_rep(mdev->priv.eswitch, 0);
-		dev->profile = &nic_rep_profile;
-		mlx5_ib_register_vport_reps(dev);
-		return dev;
-	}
-
 	return __mlx5_ib_add(dev, &pf_profile);
 }
 
@@ -6509,6 +6507,11 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	struct mlx5_ib_multiport_info *mpi;
 	struct mlx5_ib_dev *dev;
 
+	if (MLX5_ESWITCH_MANAGER(mdev) && context == mdev) {
+		mlx5_ib_unregister_vport_reps(mdev);
+		return;
+	}
+
 	if (mlx5_core_is_mp_slave(mdev)) {
 		mpi = context;
 		mutex_lock(&mlx5_ib_multiport_mutex);
@@ -6520,10 +6523,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	}
 
 	dev = context;
-	if (dev->profile == &nic_rep_profile)
-		mlx5_ib_unregister_vport_reps(dev);
-	else
-		__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
+	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 
 	ib_dealloc_device((struct ib_device *)dev);
 }
-- 
2.20.1
