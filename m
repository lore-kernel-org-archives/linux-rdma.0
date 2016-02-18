From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] net/mlx5_core: Add helper function to read virtual port counters
Date: Thu, 18 Feb 2016 18:14:59 +0200
Message-ID: <1455812101-1258-2-git-send-email-matanb@mellanox.com>
References: <1455812101-1258-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455812101-1258-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added helper function to read 64bit virtual port Infiniband traffic
counters.

Signed-off-by: Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 40 +++++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                   |  3 +-
 include/linux/mlx5/vport.h                      |  2 ++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index c7398b9..90ab09e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -850,3 +850,43 @@ int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev)
 	return mlx5_nic_vport_update_roce_state(mdev, MLX5_VPORT_ROCE_DISABLED);
 }
 EXPORT_SYMBOL_GPL(mlx5_nic_vport_disable_roce);
+
+int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
+				  u8 port_num, void *out, size_t out_sz)
+{
+	int	in_sz = MLX5_ST_SZ_BYTES(query_vport_counter_in);
+	int	is_group_manager;
+	void   *in;
+	int	err;
+
+	is_group_manager = MLX5_CAP_GEN(dev, vport_group_manager);
+	in = mlx5_vzalloc(in_sz);
+	if (!in) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	MLX5_SET(query_vport_counter_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_VPORT_COUNTER);
+	if (other_vport) {
+		if (is_group_manager) {
+			MLX5_SET(query_vport_counter_in, in, other_vport, 1);
+			MLX5_SET(query_vport_counter_in, in, vport_number, 0);
+		} else {
+			err = -EPERM;
+			goto free;
+		}
+	}
+	if (MLX5_CAP_GEN(dev, num_ports) == 2)
+		MLX5_SET(query_vport_counter_in, in, port_num, port_num);
+
+	err = mlx5_cmd_exec(dev, in, in_sz, out,  out_sz);
+	if (err)
+		goto free;
+	err = mlx5_cmd_status_to_err_v2(out);
+
+free:
+	kvfree(in);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_query_vport_counter);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index d34ad50..7dd48b32 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3169,7 +3169,8 @@ struct mlx5_ifc_query_vport_counter_in_bits {
 	u8         op_mod[0x10];
 
 	u8         other_vport[0x1];
-	u8         reserved_at_41[0xf];
+	u8         reserved_at_41[0xb];
+	u8	   port_num[0x4];
 	u8         vport_number[0x10];
 
 	u8         reserved_at_60[0x60];
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 1237710..a9f2bcc 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -92,5 +92,7 @@ int mlx5_modify_nic_vport_vlans(struct mlx5_core_dev *dev,
 
 int mlx5_nic_vport_enable_roce(struct mlx5_core_dev *mdev);
 int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev);
+int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
+				  u8 port_num, void *out, size_t out_sz);
 
 #endif /* __MLX5_VPORT_H__ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
