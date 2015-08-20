From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 04/10] net/mlx5_core: Introduce access functions to enable/disable RoCE
Date: Thu, 20 Aug 2015 19:46:23 +0300
Message-ID: <1440089189-3361-5-git-send-email-achiad@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089189-3361-1-git-send-email-achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A mlx5 Ethernet port must be explicitly enabled for RoCE.
When RoCE is not enabled on the port, the NIC will refuse to create
QPs attached to it and incoming RoCE packets will be considered by the
NIC as plain Ethernet packets.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 52 +++++++++++++++++++++++++
 include/linux/mlx5/vport.h                      |  3 ++
 2 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 54ab63b..245ff4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -70,6 +70,17 @@ static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u32 *out,
 	return mlx5_cmd_exec_check_status(mdev, in, sizeof(in), out, outlen);
 }
 
+static int mlx5_modify_nic_vport_context(struct mlx5_core_dev *mdev, void *in,
+					 int inlen)
+{
+	u32 out[MLX5_ST_SZ_DW(modify_nic_vport_context_out)];
+
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
+
+	return mlx5_cmd_exec_check_status(mdev, in, inlen, out, sizeof(out));
+}
+
 void mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev, u8 *addr)
 {
 	u32 *out;
@@ -350,3 +361,44 @@ int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_node_guid);
+
+enum mlx5_vport_roce_state {
+	MLX5_VPORT_ROCE_DISABLED = 0,
+	MLX5_VPORT_ROCE_ENABLED  = 1,
+};
+
+static int mlx5_nic_vport_update_roce_state(struct mlx5_core_dev *mdev,
+					    enum mlx5_vport_roce_state state)
+{
+	void *in;
+	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
+	int err;
+
+	in = mlx5_vzalloc(inlen);
+	if (!in) {
+		mlx5_core_warn(mdev, "failed to allocate inbox\n");
+		return -ENOMEM;
+	}
+
+	MLX5_SET(modify_nic_vport_context_in, in, field_select.roce_en, 1);
+	MLX5_SET(modify_nic_vport_context_in, in, nic_vport_context.roce_en,
+		 state);
+
+	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+
+	kvfree(in);
+
+	return err;
+}
+
+int mlx5_nic_vport_enable_roce(struct mlx5_core_dev *mdev)
+{
+	return mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_ENABLED);
+}
+EXPORT_SYMBOL_GPL(mlx5_nic_vport_enable_roce);
+
+int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev)
+{
+	return mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_DISABLED);
+}
+EXPORT_SYMBOL_GPL(mlx5_nic_vport_disable_roce);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 967e0fd..4c9ac60 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -52,4 +52,7 @@ int mlx5_query_hca_vport_system_image_guid(struct mlx5_core_dev *dev,
 int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 				   u64 *node_guid);
 
+int mlx5_nic_vport_enable_roce(struct mlx5_core_dev *mdev);
+int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev);
+
 #endif /* __MLX5_VPORT_H__ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
