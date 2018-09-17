From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 20/25] IB/mlx5: Set uid as part of MCG commands
Date: Mon, 17 Sep 2018 14:04:13 +0300
Message-ID: <20180917110418.18937-21-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of MCG commands so that the firmware can manage the
MCG object in a secured way.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c  | 30 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h  |  4 ++++
 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++--
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 51c39bc77ac7..ababc5cdbcaa 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -296,3 +296,33 @@ int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid)
 	MLX5_SET(dealloc_xrcd_in, in, uid, uid);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+
+int mlx5_cmd_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+			u32 qpn, u16 uid)
+{
+	u32 out[MLX5_ST_SZ_DW(attach_to_mcg_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(attach_to_mcg_in)]   = {0};
+	void *gid;
+
+	MLX5_SET(attach_to_mcg_in, in, opcode, MLX5_CMD_OP_ATTACH_TO_MCG);
+	MLX5_SET(attach_to_mcg_in, in, qpn, qpn);
+	MLX5_SET(attach_to_mcg_in, in, uid, uid);
+	gid = MLX5_ADDR_OF(attach_to_mcg_in, in, multicast_gid);
+	memcpy(gid, mgid, sizeof(*mgid));
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5_cmd_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+			u32 qpn, u16 uid)
+{
+	u32 out[MLX5_ST_SZ_DW(detach_from_mcg_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(detach_from_mcg_in)]   = {0};
+	void *gid;
+
+	MLX5_SET(detach_from_mcg_in, in, opcode, MLX5_CMD_OP_DETACH_FROM_MCG);
+	MLX5_SET(detach_from_mcg_in, in, qpn, qpn);
+	MLX5_SET(detach_from_mcg_in, in, uid, uid);
+	gid = MLX5_ADDR_OF(detach_from_mcg_in, in, multicast_gid);
+	memcpy(gid, mgid, sizeof(*mgid));
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 76823e86fd17..7cf364af7c28 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -57,4 +57,8 @@ void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
 				       u16 uid);
 int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid);
 int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid);
+int mlx5_cmd_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+			u32 qpn, u16 uid);
+int mlx5_cmd_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid,
+			u32 qpn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c1f94bc09606..ac2abfc866a6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4139,13 +4139,17 @@ static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(ibqp);
 	int err;
+	u16 uid;
+
+	uid = ibqp->uobject ?
+		to_mucontext(ibqp->uobject->context)->devx_uid : 0;
 
 	if (mqp->flags & MLX5_IB_QP_UNDERLAY) {
 		mlx5_ib_dbg(dev, "Attaching a multi cast group to underlay QP is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5_core_attach_mcg(dev->mdev, gid, ibqp->qp_num);
+	err = mlx5_cmd_attach_mcg(dev->mdev, gid, ibqp->qp_num, uid);
 	if (err)
 		mlx5_ib_warn(dev, "failed attaching QPN 0x%x, MGID %pI6\n",
 			     ibqp->qp_num, gid->raw);
@@ -4157,8 +4161,11 @@ static int mlx5_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	int err;
+	u16 uid;
 
-	err = mlx5_core_detach_mcg(dev->mdev, gid, ibqp->qp_num);
+	uid = ibqp->uobject ?
+		to_mucontext(ibqp->uobject->context)->devx_uid : 0;
+	err = mlx5_cmd_detach_mcg(dev->mdev, gid, ibqp->qp_num, uid);
 	if (err)
 		mlx5_ib_warn(dev, "failed detaching QPN 0x%x, MGID %pI6\n",
 			     ibqp->qp_num, gid->raw);
-- 
2.14.4
