From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Allocate the per-port Q counter shared when DEVX is supported
Date: Sun,  9 Dec 2018 12:52:36 +0200
Message-ID: <20181209105236.26233-3-leon@kernel.org>
References: <20181209105236.26233-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181209105236.26233-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

The per-port Q counter is some kernel resource and as such may be used
by few UID(s) upon DEVX usage.

To enable using it for QP/RQ when DEVX context is used need to allocate
it with a sharing mode indication to let firmware allows its usage.

The UID = 0xffff was chosen to mark it.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c  | 17 +++++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h  |  2 ++
 drivers/infiniband/hw/mlx5/main.c | 10 ++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index ca060a2e2b36..752c60426a1c 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -326,3 +326,20 @@ int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid)
 	MLX5_SET(dealloc_xrcd_in, in, uid, uid);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+
+int mlx5_cmd_alloc_q_counter(struct mlx5_core_dev *dev, u16 *counter_id,
+			     u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(alloc_q_counter_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_q_counter_out)] = {0};
+	int err;
+
+	MLX5_SET(alloc_q_counter_in, in, opcode, MLX5_CMD_OP_ALLOC_Q_COUNTER);
+	MLX5_SET(alloc_q_counter_in, in, uid, uid);
+
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*counter_id = MLX5_GET(alloc_q_counter_out, out,
+				       counter_set_id);
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index c03c56455534..1e76dc67a369 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -61,4 +61,6 @@ int mlx5_cmd_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
 			u32 qpn, u16 uid);
 int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid);
 int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid);
+int mlx5_cmd_alloc_q_counter(struct mlx5_core_dev *dev, u16 *counter_id,
+			     u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4660f5f1547a..3477fa1b2289 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5114,6 +5114,10 @@ static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
 {
 	int err = 0;
 	int i;
+	bool is_shared;
+
+	is_shared = MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
+				MLX5_GENERAL_OBJ_TYPES_CAP_UCTX;
 
 	for (i = 0; i < dev->num_ports; i++) {
 		err = __mlx5_ib_alloc_counters(dev, &dev->port[i].cnts);
@@ -5123,8 +5127,10 @@ static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
 		mlx5_ib_fill_counters(dev, dev->port[i].cnts.names,
 				      dev->port[i].cnts.offsets);
 
-		err = mlx5_core_alloc_q_counter(dev->mdev,
-						&dev->port[i].cnts.set_id);
+		err = mlx5_cmd_alloc_q_counter(dev->mdev,
+					       &dev->port[i].cnts.set_id,
+					       is_shared ?
+					       MLX5_SHARED_RESOURCE_UID : 0);
 		if (err) {
 			mlx5_ib_warn(dev,
 				     "couldn't allocate queue counter for port %d, err %d\n",
-- 
2.19.1
