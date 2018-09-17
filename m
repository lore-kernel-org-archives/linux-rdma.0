From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 13/25] IB/mlx5: Set uid as part of TIS commands
Date: Mon, 17 Sep 2018 14:04:06 +0300
Message-ID: <20180917110418.18937-14-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of TIS commands so that the firmware can manage the
TIS object in a secured way.

That will enable using a TIS that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c | 12 ++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c  | 27 +++++++++++++++++----------
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index e150ae44e06a..8a3623bbca94 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -208,3 +208,15 @@ void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid)
 	MLX5_SET(destroy_tir_in, in, uid, uid);
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+
+void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_tis_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(destroy_tis_out)] = {0};
+
+	MLX5_SET(destroy_tis_in, in, opcode, MLX5_CMD_OP_DESTROY_TIS);
+	MLX5_SET(destroy_tis_in, in, tisn, tisn);
+	MLX5_SET(destroy_tis_in, in, uid, uid);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 274090a38c4b..a55e750591e5 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -48,4 +48,5 @@ int mlx5_cmd_alloc_memic(struct mlx5_memic *memic, phys_addr_t *addr,
 			 u64 length, u32 alignment);
 int mlx5_cmd_dealloc_memic(struct mlx5_memic *memic, u64 addr, u64 length);
 void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
+void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 07bf5128bee4..5421857f195e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1062,11 +1062,12 @@ static int is_connected(enum ib_qp_type qp_type)
 
 static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_qp *qp,
-				    struct mlx5_ib_sq *sq, u32 tdn)
+				    struct mlx5_ib_sq *sq, u32 tdn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {0};
 	void *tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
+	MLX5_SET(create_tis_in, in, uid, uid);
 	MLX5_SET(tisc, tisc, transport_domain, tdn);
 	if (qp->flags & MLX5_IB_QP_UNDERLAY)
 		MLX5_SET(tisc, tisc, underlay_qpn, qp->underlay_qpn);
@@ -1075,9 +1076,9 @@ static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 }
 
 static void destroy_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
-				      struct mlx5_ib_sq *sq)
+				      struct mlx5_ib_sq *sq, u16 uid)
 {
-	mlx5_core_destroy_tis(dev->mdev, sq->tisn);
+	mlx5_cmd_destroy_tis(dev->mdev, sq->tisn, uid);
 }
 
 static void destroy_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
@@ -1337,7 +1338,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	u16 uid = mucontext->devx_uid;
 
 	if (qp->sq.wqe_cnt) {
-		err = create_raw_packet_qp_tis(dev, qp, sq, tdn);
+		err = create_raw_packet_qp_tis(dev, qp, sq, tdn, uid);
 		if (err)
 			return err;
 
@@ -1378,7 +1379,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return err;
 	destroy_raw_packet_qp_sq(dev, sq);
 err_destroy_tis:
-	destroy_raw_packet_qp_tis(dev, sq);
+	destroy_raw_packet_qp_tis(dev, sq, uid);
 
 	return err;
 }
@@ -1398,7 +1399,7 @@ static void destroy_raw_packet_qp(struct mlx5_ib_dev *dev,
 
 	if (qp->sq.wqe_cnt) {
 		destroy_raw_packet_qp_sq(dev, sq);
-		destroy_raw_packet_qp_tis(dev, sq);
+		destroy_raw_packet_qp_tis(dev, sq, uid);
 	}
 }
 
@@ -2579,7 +2580,7 @@ static int ib_rate_to_mlx5(struct mlx5_ib_dev *dev, u8 rate)
 }
 
 static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
-				      struct mlx5_ib_sq *sq, u8 sl)
+				      struct mlx5_ib_sq *sq, u8 sl, u16 uid)
 {
 	void *in;
 	void *tisc;
@@ -2592,6 +2593,7 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
 		return -ENOMEM;
 
 	MLX5_SET(modify_tis_in, in, bitmask.prio, 1);
+	MLX5_SET(modify_tis_in, in, uid, uid);
 
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, prio, ((sl & 0x7) << 1));
@@ -2604,7 +2606,8 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
 }
 
 static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
-					 struct mlx5_ib_sq *sq, u8 tx_affinity)
+					 struct mlx5_ib_sq *sq, u8 tx_affinity,
+					 u16 uid)
 {
 	void *in;
 	void *tisc;
@@ -2617,6 +2620,7 @@ static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
 		return -ENOMEM;
 
 	MLX5_SET(modify_tis_in, in, bitmask.lag_tx_port_affinity, 1);
+	MLX5_SET(modify_tis_in, in, uid, uid);
 
 	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
 	MLX5_SET(tisc, tisc, lag_tx_port_affinity, tx_affinity);
@@ -2639,6 +2643,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	enum ib_gid_type gid_type;
 	u8 ah_flags = rdma_ah_get_ah_flags(ah);
 	u8 sl = rdma_ah_get_sl(ah);
+	u16 uid;
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
 		path->pkey_index = cpu_to_be16(alt ? attr->alt_pkey_index :
@@ -2698,10 +2703,12 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (attr_mask & IB_QP_TIMEOUT)
 		path->ackto_lt = (alt ? attr->alt_timeout : attr->timeout) << 3;
 
+	uid = qp->ibqp.uobject ?
+		to_mucontext(qp->ibqp.uobject->context)->devx_uid : 0;
 	if ((qp->ibqp.qp_type == IB_QPT_RAW_PACKET) && qp->sq.wqe_cnt)
 		return modify_raw_packet_eth_prio(dev->mdev,
 						  &qp->raw_packet_qp.sq,
-						  sl & 0xf);
+						  sl & 0xf, uid);
 
 	return 0;
 }
@@ -3025,7 +3032,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (modify_sq) {
 		if (tx_affinity) {
 			err = modify_raw_packet_tx_affinity(dev->mdev, sq,
-							    tx_affinity);
+							    tx_affinity, uid);
 			if (err)
 				return err;
 		}
-- 
2.14.4
