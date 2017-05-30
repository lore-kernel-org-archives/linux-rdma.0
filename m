From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] net/mlx5: Add raw ethernet local loopback firmware command
Date: Tue, 30 May 2017 09:42:53 +0300
Message-ID: <20170530064255.3745-2-leon@kernel.org>
References: <20170530064255.3745-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530064255.3745-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for raw ethernet local loopback firmware command.

Signed-off-by: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 62 +++++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                   | 11 +++--
 include/linux/mlx5/vport.h                      |  3 +-
 3 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 15c2294dd2b4..3eaa4aac13dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -901,6 +901,68 @@ int mlx5_modify_nic_vport_promisc(struct mlx5_core_dev *mdev,
 }
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_promisc);
 
+enum {
+	UC_LOCAL_LB,
+	MC_LOCAL_LB
+};
+
+int mlx5_nic_vport_update_local_lb(struct mlx5_core_dev *mdev, bool enable)
+{
+	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
+	void *in;
+	int err;
+
+	mlx5_core_dbg(mdev, "%s local_lb\n", enable ? "enable" : "disable");
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 field_select.disable_mc_local_lb, 1);
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 nic_vport_context.disable_mc_local_lb, !enable);
+
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 field_select.disable_uc_local_lb, 1);
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 nic_vport_context.disable_uc_local_lb, !enable);
+
+	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_nic_vport_update_local_lb);
+
+int mlx5_nic_vport_query_local_lb(struct mlx5_core_dev *mdev, bool *status)
+{
+	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+	u32 *out;
+	int value;
+	int err;
+
+	out = kzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	err = mlx5_query_nic_vport_context(mdev, 0, out, outlen);
+	if (err)
+		goto out;
+
+	value = MLX5_GET(query_nic_vport_context_out, out,
+			 nic_vport_context.disable_mc_local_lb) << MC_LOCAL_LB;
+
+	value |= MLX5_GET(query_nic_vport_context_out, out,
+			  nic_vport_context.disable_uc_local_lb) << UC_LOCAL_LB;
+
+	*status = !value;
+
+out:
+	kfree(out);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_nic_vport_query_local_lb);
+
 enum mlx5_vport_roce_state {
 	MLX5_VPORT_ROCE_DISABLED = 0,
 	MLX5_VPORT_ROCE_ENABLED  = 1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 32de0724b400..d55076bb4646 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -994,7 +994,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_wq_sz[0x5];
 
 	u8         nic_vport_change_event[0x1];
-	u8         reserved_at_3e1[0xa];
+	u8         disable_local_lb[0x1];
+	u8         reserved_at_3e2[0x9];
 	u8         log_max_vlan_list[0x5];
 	u8         reserved_at_3f0[0x3];
 	u8         log_max_current_mc_list[0x5];
@@ -2538,7 +2539,9 @@ struct mlx5_ifc_rmpc_bits {
 struct mlx5_ifc_nic_vport_context_bits {
 	u8         reserved_at_0[0x5];
 	u8         min_wqe_inline_mode[0x3];
-	u8         reserved_at_8[0x17];
+	u8         reserved_at_8[0x15];
+	u8         disable_mc_local_lb[0x1];
+	u8         disable_uc_local_lb[0x1];
 	u8         roce_en[0x1];
 
 	u8         arm_change_event[0x1];
@@ -5197,7 +5200,9 @@ struct mlx5_ifc_modify_nic_vport_context_out_bits {
 };
 
 struct mlx5_ifc_modify_nic_vport_field_select_bits {
-	u8         reserved_at_0[0x16];
+	u8         reserved_at_0[0x14];
+	u8         disable_uc_local_lb[0x1];
+	u8         disable_mc_local_lb[0x1];
 	u8         node_guid[0x1];
 	u8         port_guid[0x1];
 	u8         min_inline[0x1];
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 656c70b65dd2..aaa0bb9e7655 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -114,5 +114,6 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 				       u8 other_vport, u8 port_num,
 				       int vf,
 				       struct mlx5_hca_vport_context *req);
-
+int mlx5_nic_vport_update_local_lb(struct mlx5_core_dev *mdev, bool enable);
+int mlx5_nic_vport_query_local_lb(struct mlx5_core_dev *mdev, bool *status);
 #endif /* __MLX5_VPORT_H__ */
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
