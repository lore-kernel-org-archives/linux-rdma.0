From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 04/12] RDMA/mlx5: Free IB device on remove
Date: Thu, 28 Mar 2019 15:27:34 +0200
Message-ID: <20190328132742.12070-5-leon@kernel.org>
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

Simplify the code and move the deallocation of the IB device into the
remove function.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 5 +----
 drivers/infiniband/hw/mlx5/main.c   | 4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index b8639ac71336..87d553396fb4 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -65,10 +65,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	ibdev->mdev = dev;
 	ibdev->num_ports = max(MLX5_CAP_GEN(dev, num_ports),
 			       MLX5_CAP_GEN(dev, num_vhca_ports));
-	if (!__mlx5_ib_add(ibdev, profile)) {
-		ib_dealloc_device(&ibdev->ib_dev);
+	if (!__mlx5_ib_add(ibdev, profile))
 		return -EINVAL;
-	}
 
 	rep->rep_if[REP_IB].priv = ibdev;
 
@@ -86,7 +84,6 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	dev = mlx5_ib_rep_to_dev(rep);
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 	rep->rep_if[REP_IB].priv = NULL;
-	ib_dealloc_device(&dev->ib_dev);
 }
 
 static void *mlx5_ib_vport_get_proto_dev(struct mlx5_eswitch_rep *rep)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a8522a0dedae..df38e24119ff 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6491,6 +6491,8 @@ void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		if (profile->stage[stage].cleanup)
 			profile->stage[stage].cleanup(dev);
 	}
+
+	ib_dealloc_device(&dev->ib_dev);
 }
 
 void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
@@ -6713,8 +6715,6 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 
 	dev = context;
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
-
-	ib_dealloc_device((struct ib_device *)dev);
 }
 
 static struct mlx5_interface mlx5_ib_interface = {
-- 
2.20.1
