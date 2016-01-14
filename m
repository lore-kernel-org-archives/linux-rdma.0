From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 11/13] IB/mlx5: Support setting Ethernet priority for Raw Packet QPs
Date: Thu, 14 Jan 2016 19:13:06 +0200
Message-ID: <1452791588-19895-12-git-send-email-majd@mellanox.com>
References: <1452791588-19895-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452791588-19895-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the user changes the Address Vector(AV) in the modify QP, he
provides an SL. This SL should be translated to Ethernet Priority
by taking the 3 LSB bits, and modify the QP's TIS according to this
Ethernet priority.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c                    | 38 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c | 12 +++++++
 include/linux/mlx5/mlx5_ifc.h                      |  9 ++++-
 include/linux/mlx5/transobj.h                      |  2 ++
 4 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 290e97b..38413dc 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1752,7 +1752,33 @@ static int ib_rate_to_mlx5(struct mlx5_ib_dev *dev, u8 rate)
 	return rate + MLX5_STAT_RATE_OFFSET;
 }
 
-static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
+static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
+				      struct mlx5_ib_sq *sq, u8 sl)
+{
+	void *in;
+	void *tisc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_tis_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_tis_in, in, bitmask.prio, 1);
+
+	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
+	MLX5_SET(tisc, tisc, prio, ((sl & 0x7) << 1));
+
+	err = mlx5_core_modify_tis(dev, sq->tisn, in, inlen);
+
+	kvfree(in);
+
+	return err;
+}
+
+static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
+			 const struct ib_ah_attr *ah,
 			 struct mlx5_qp_path *path, u8 port, int attr_mask,
 			 u32 path_flags, const struct ib_qp_attr *attr)
 {
@@ -1808,6 +1834,11 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 	if (attr_mask & IB_QP_TIMEOUT)
 		path->ackto_lt = attr->timeout << 3;
 
+	if ((qp->ibqp.qp_type == IB_QPT_RAW_PACKET) && qp->sq.wqe_cnt)
+		return modify_raw_packet_eth_prio(dev->mdev,
+						  &qp->raw_packet_qp.sq,
+						  ah->sl & 0xf);
+
 	return 0;
 }
 
@@ -2029,7 +2060,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		context->pri_path.port = attr->port_num;
 
 	if (attr_mask & IB_QP_AV) {
-		err = mlx5_set_path(dev, &attr->ah_attr, &context->pri_path,
+		err = mlx5_set_path(dev, qp, &attr->ah_attr, &context->pri_path,
 				    attr_mask & IB_QP_PORT ? attr->port_num : qp->port,
 				    attr_mask, 0, attr);
 		if (err)
@@ -2040,7 +2071,8 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		context->pri_path.ackto_lt |= attr->timeout << 3;
 
 	if (attr_mask & IB_QP_ALT_PATH) {
-		err = mlx5_set_path(dev, &attr->alt_ah_attr, &context->alt_path,
+		err = mlx5_set_path(dev, qp, &attr->alt_ah_attr,
+				    &context->alt_path,
 				    attr->alt_port_num, attr_mask, 0, attr);
 		if (err)
 			goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index 460d9ff..03a5093 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -235,6 +235,18 @@ int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 }
 EXPORT_SYMBOL(mlx5_core_create_tis);
 
+int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in,
+			 int inlen)
+{
+	u32 out[MLX5_ST_SZ_DW(modify_tis_out)] = {0};
+
+	MLX5_SET(modify_tis_in, in, tisn, tisn);
+	MLX5_SET(modify_tis_in, in, opcode, MLX5_CMD_OP_MODIFY_TIS);
+
+	return mlx5_cmd_exec_check_status(dev, in, inlen, out, sizeof(out));
+}
+EXPORT_SYMBOL(mlx5_core_modify_tis);
+
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_tis_in)];
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 991283b..4633b88 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4052,6 +4052,13 @@ struct mlx5_ifc_modify_tis_out_bits {
 	u8         reserved_1[0x40];
 };
 
+struct mlx5_ifc_modify_tis_bitmask_bits {
+	u8         reserved_0[0x20];
+
+	u8         reserved_1[0x1f];
+	u8         prio[0x1];
+};
+
 struct mlx5_ifc_modify_tis_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_0[0x10];
@@ -4064,7 +4071,7 @@ struct mlx5_ifc_modify_tis_in_bits {
 
 	u8         reserved_3[0x20];
 
-	u8         modify_bitmask[0x40];
+	struct mlx5_ifc_modify_tis_bitmask_bits bitmask;
 
 	u8         reserved_4[0x40];
 
diff --git a/include/linux/mlx5/transobj.h b/include/linux/mlx5/transobj.h
index d259e4c..88441f5 100644
--- a/include/linux/mlx5/transobj.h
+++ b/include/linux/mlx5/transobj.h
@@ -54,6 +54,8 @@ int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
 void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn);
 int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tisn);
+int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in,
+			 int inlen);
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn);
 int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rmpn);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
