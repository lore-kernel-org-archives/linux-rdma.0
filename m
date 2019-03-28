From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 05/12] RDMA/mlx5: Move ports allocation to outside of INIT stage
Date: Thu, 28 Mar 2019 15:27:35 +0200
Message-ID: <20190328132742.12070-6-leon@kernel.org>
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

In downstream patches we will need access to the ports before doing
any stages, in order to set net device per representor.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 12 ++++++++++--
 drivers/infiniband/hw/mlx5/main.c   | 24 ++++++++++++------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 87d553396fb4..14ac728b460c 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -51,6 +51,7 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
+	int num_ports = 1;
 
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		profile = &uplink_rep_profile;
@@ -61,10 +62,17 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	if (!ibdev)
 		return -ENOMEM;
 
+	ibdev->port = kcalloc(num_ports, sizeof(*ibdev->port),
+			      GFP_KERNEL);
+	if (!ibdev->port) {
+		ib_dealloc_device(&ibdev->ib_dev);
+		return -ENOMEM;
+	}
+
 	ibdev->rep = rep;
 	ibdev->mdev = dev;
-	ibdev->num_ports = max(MLX5_CAP_GEN(dev, num_ports),
-			       MLX5_CAP_GEN(dev, num_vhca_ports));
+	ibdev->num_ports = num_ports;
+
 	if (!__mlx5_ib_add(ibdev, profile))
 		return -EINVAL;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index df38e24119ff..e3483ecc2f98 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5914,7 +5914,6 @@ void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 		srcu_barrier(&dev->mr_srcu);
 		cleanup_srcu_struct(&dev->mr_srcu);
 	}
-	kfree(dev->port);
 }
 
 int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
@@ -5923,11 +5922,6 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	int err;
 	int i;
 
-	dev->port = kcalloc(dev->num_ports, sizeof(*dev->port),
-			    GFP_KERNEL);
-	if (!dev->port)
-		return -ENOMEM;
-
 	for (i = 0; i < dev->num_ports; i++) {
 		spin_lock_init(&dev->port[i].mp.mpi_lock);
 		rwlock_init(&dev->port[i].roce.netdev_lock);
@@ -5935,7 +5929,7 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 
 	err = mlx5_ib_init_multiport_master(dev);
 	if (err)
-		goto err_free_port;
+		return err;
 
 	if (!mlx5_core_mp_enabled(mdev)) {
 		for (i = 1; i <= dev->num_ports; i++) {
@@ -5976,9 +5970,6 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 err_mp:
 	mlx5_ib_cleanup_multiport_master(dev);
 
-err_free_port:
-	kfree(dev->port);
-
 	return -ENOMEM;
 }
 
@@ -6492,6 +6483,7 @@ void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 			profile->stage[stage].cleanup(dev);
 	}
 
+	kfree(dev->port);
 	ib_dealloc_device(&dev->ib_dev);
 }
 
@@ -6667,6 +6659,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	enum rdma_link_layer ll;
 	struct mlx5_ib_dev *dev;
 	int port_type_cap;
+	int num_ports;
 
 	printk_once(KERN_INFO "%s", mlx5_version);
 
@@ -6682,13 +6675,20 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (mlx5_core_is_mp_slave(mdev) && ll == IB_LINK_LAYER_ETHERNET)
 		return mlx5_ib_add_slave_port(mdev);
 
+	num_ports = max(MLX5_CAP_GEN(mdev, num_ports),
+			MLX5_CAP_GEN(mdev, num_vhca_ports));
 	dev = ib_alloc_device(mlx5_ib_dev, ib_dev);
 	if (!dev)
 		return NULL;
+	dev->port = kcalloc(num_ports, sizeof(*dev->port),
+			     GFP_KERNEL);
+	if (!dev->port) {
+		ib_dealloc_device((struct ib_device *)dev);
+		return NULL;
+	}
 
 	dev->mdev = mdev;
-	dev->num_ports = max(MLX5_CAP_GEN(mdev, num_ports),
-			     MLX5_CAP_GEN(mdev, num_vhca_ports));
+	dev->num_ports = num_ports;
 
 	return __mlx5_ib_add(dev, &pf_profile);
 }
-- 
2.20.1
