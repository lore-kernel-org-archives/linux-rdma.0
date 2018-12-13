From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 3/6] net/mlx5: E-Switch, Introduce flow counter affinity
Date: Wed, 12 Dec 2018 19:11:38 -0800
Message-ID: <20181213031141.12783-4-saeedm@mellanox.com>
References: <20181213031141.12783-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213031141.12783-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Shahar Klein <shahark@mellanox.com>, Roi Dayan <roid@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Shahar Klein <shahark@mellanox.com>

This dictates the device affinity for eswitch flow counters, set by the FW
according to the HW device capabilities.

Under "source eswitch" affinity, the counter should be allocated on the
device related to the source vport in the match. This covers both non
merged e-switch mode as well as old FW that does not advertise this cap.

Under "flow eswitch" affinity, the counter should be allocated on the
device where the eswitch rule is set.

Signed-off-by: Shahar Klein <shahark@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a56bd3b1f579..f48d7ee345ff 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -608,13 +608,19 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
 	u8      reserved_at_800[0x7800];
 };
 
+enum {
+	MLX5_COUNTER_SOURCE_ESWITCH = 0x0,
+	MLX5_COUNTER_FLOW_ESWITCH   = 0x1,
+};
+
 struct mlx5_ifc_e_switch_cap_bits {
 	u8         vport_svlan_strip[0x1];
 	u8         vport_cvlan_strip[0x1];
 	u8         vport_svlan_insert[0x1];
 	u8         vport_cvlan_insert_if_not_exist[0x1];
 	u8         vport_cvlan_insert_overwrite[0x1];
-	u8         reserved_at_5[0x18];
+	u8         reserved_at_5[0x17];
+	u8         counter_eswitch_affinity[0x1];
 	u8         merged_eswitch[0x1];
 	u8         nic_vport_node_guid_modify[0x1];
 	u8         nic_vport_port_guid_modify[0x1];
-- 
2.19.2
