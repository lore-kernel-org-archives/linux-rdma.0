From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/5] net/mlx5: Introduce set delay drop command
Date: Tue, 30 May 2017 10:29:11 +0300
Message-ID: <20170530072914.9709-3-leon@kernel.org>
References: <20170530072914.9709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530072914.9709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to SET_DELAY_DROP command.

This command will be used in downstream patches for delay packet drop.
The timeout value should be indicated by delay_drop_timeout field.
Packet processing will be delayed till timeout value passed or until
more WQEs are posted.

Setting this value to 0 disables the feature.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 14 ++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                | 25 ++++++++++++++++++++++++-
 include/linux/mlx5/qp.h                      |  3 +++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 573a6b27fed8..f9fcfec0e198 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -243,6 +243,20 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_core_destroy_qp);

+int mlx5_core_set_delay_drop(struct mlx5_core_dev *dev,
+			     u32 timeout_usec)
+{
+	u32 out[MLX5_ST_SZ_DW(set_delay_drop_params_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(set_delay_drop_params_in)]   = {0};
+
+	MLX5_SET(set_delay_drop_params_in, in, opcode,
+		 MLX5_CMD_OP_SET_DELAY_DROP_PARAMS);
+	MLX5_SET(set_delay_drop_params_in, in, delay_drop_timeout,
+		 timeout_usec / 100);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+EXPORT_SYMBOL_GPL(mlx5_core_set_delay_drop);
+
 struct mbox_info {
 	u32 *in;
 	u32 *out;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6fa1eb6766af..5b9f836e66ca 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -200,6 +200,7 @@ enum {
 	MLX5_CMD_OP_QUERY_SQ                      = 0x907,
 	MLX5_CMD_OP_CREATE_RQ                     = 0x908,
 	MLX5_CMD_OP_MODIFY_RQ                     = 0x909,
+	MLX5_CMD_OP_SET_DELAY_DROP_PARAMS         = 0x910,
 	MLX5_CMD_OP_DESTROY_RQ                    = 0x90a,
 	MLX5_CMD_OP_QUERY_RQ                      = 0x90b,
 	MLX5_CMD_OP_CREATE_RMP                    = 0x90c,
@@ -824,7 +825,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         retransmission_q_counters[0x1];
 	u8         reserved_at_183[0x1];
 	u8         modify_rq_counter_set_id[0x1];
-	u8         reserved_at_185[0x1];
+	u8         rq_delay_drop[0x1];
 	u8         max_qp_cnt[0xa];
 	u8         pkey_table_size[0x10];

@@ -5820,6 +5821,28 @@ struct mlx5_ifc_destroy_rq_in_bits {
 	u8         reserved_at_60[0x20];
 };

+struct mlx5_ifc_set_delay_drop_params_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_at_10[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x10];
+	u8         delay_drop_timeout[0x10];
+};
+
+struct mlx5_ifc_set_delay_drop_params_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_destroy_rmp_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index bef80d0a0e30..9aaa4951bc6a 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -551,6 +551,9 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 int mlx5_core_qp_query(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		       u32 *out, int outlen);

+int mlx5_core_set_delay_drop(struct mlx5_core_dev *dev,
+			     u32 timeout_usec);
+
 int mlx5_core_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn);
 int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn);
 void mlx5_init_qp_table(struct mlx5_core_dev *dev);
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
