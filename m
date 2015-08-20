From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/10] net/mlx5_core: Introduce access functions to query vport RoCE fields
Date: Thu, 20 Aug 2015 19:46:24 +0300
Message-ID: <1440089189-3361-6-git-send-email-achiad@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089189-3361-1-git-send-email-achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce access functions to query NIC vport system_image_guid,
node_guid and qkey_viol_cntr.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 62 +++++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                   | 10 +++-
 include/linux/mlx5/vport.h                      |  5 ++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 245ff4a..ecb274a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -103,6 +103,68 @@ void mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev, u8 *addr)
 }
 EXPORT_SYMBOL(mlx5_query_nic_vport_mac_address);
 
+int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
+					   u64 *system_image_guid)
+{
+	u32 *out;
+	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+
+	out = mlx5_vzalloc(outlen);
+	if (!out)
+		return -ENOMEM;
+
+	mlx5_query_nic_vport_context(mdev, out, outlen);
+
+	*system_image_guid = MLX5_GET64(query_nic_vport_context_out, out,
+					nic_vport_context.system_image_guid);
+
+	kfree(out);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_system_image_guid);
+
+int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid)
+{
+	u32 *out;
+	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+
+	out = mlx5_vzalloc(outlen);
+	if (!out)
+		return -ENOMEM;
+
+	mlx5_query_nic_vport_context(mdev, out, outlen);
+
+	*node_guid = MLX5_GET64(query_nic_vport_context_out, out,
+				nic_vport_context.node_guid);
+
+	kfree(out);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_node_guid);
+
+int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
+					u16 *qkey_viol_cntr)
+{
+	u32 *out;
+	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+
+	out = mlx5_vzalloc(outlen);
+	if (!out)
+		return -ENOMEM;
+
+	mlx5_query_nic_vport_context(mdev, out, outlen);
+
+	*qkey_viol_cntr = MLX5_GET(query_nic_vport_context_out, out,
+				   nic_vport_context.qkey_violation_counter);
+
+	kfree(out);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_qkey_viol_cntr);
+
 int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
 			     u8 port_num, u16  vf_num, u16 gid_index,
 			     union ib_gid *gid)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6d2f6fe..62f1ebf 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2139,7 +2139,15 @@ struct mlx5_ifc_nic_vport_context_bits {
 	u8         reserved_0[0x1f];
 	u8         roce_en[0x1];
 
-	u8         reserved_1[0x760];
+	u8         reserved_1[0x120];
+
+	u8         system_image_guid[0x40];
+	u8         port_guid[0x40];
+	u8         node_guid[0x40];
+
+	u8         reserved_5[0x140];
+	u8         qkey_violation_counter[0x10];
+	u8         reserved_6[0x430];
 
 	u8         reserved_2[0x5];
 	u8         allowed_list_type[0x3];
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 4c9ac60..dfb2d94 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -37,6 +37,11 @@
 
 u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod);
 void mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev, u8 *addr);
+int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
+					   u64 *system_image_guid);
+int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid);
+int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
+					u16 *qkey_viol_cntr);
 int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
 			     u8 port_num, u16  vf_num, u16 gid_index,
 			     union ib_gid *gid);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
