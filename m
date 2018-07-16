From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 07/18] net/mlx5: Expose new packet reformat capabilities
Date: Mon, 16 Jul 2018 11:22:54 +0300
Message-ID: <20180716082305.11744-8-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Expose new abilities when creating a packet reformat context.

The new types which can be created are:
MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL: Ability to create generic encap
opertion to be done by the HW.

MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2: Ability to create generic decap
opertion where the inner packet doesn't contain L2.

MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL: Ability to create generic encap
opertion to be done by the HW. The L2 of the original packet
is dropped.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 059ec97e7b32..c71d711d4893 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -341,8 +341,13 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_9[0x1];
 	u8         pop_vlan[0x1];
 	u8         push_vlan[0x1];
-	u8         reserved_at_c[0x14];
-
+	u8	   reserved_at_c[0x3];
+	u8	   reformat_and_vlan_action[0x1];
+	u8	   reserved_at_10[0x2];
+	u8	   reformat_l3_tunnel_to_l2[0x1];
+	u8	   reformat_l2_to_l3_tunnel[0x1];
+	u8	   reformat_and_modify_action[0x1];
+	u8         reserved_at_15[0xb];
 	u8         reserved_at_20[0x2];
 	u8         log_max_ft_size[0x6];
 	u8         log_max_modify_header_context[0x8];
@@ -551,7 +556,13 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 	u8         nic_rx_multi_path_tirs[0x1];
 	u8         nic_rx_multi_path_tirs_fts[0x1];
 	u8         allow_sniffer_and_nic_rx_shared_tir[0x1];
-	u8         reserved_at_3[0x1fd];
+	u8	   reserved_at_3[0x1d];
+	u8	   encap_general_header[0x1];
+	u8	   reserved_at_21[0xa];
+	u8	   log_max_packet_reformat_context[0x5];
+	u8	   reserved_at_30[0x6];
+	u8	   max_encap_header_size[0xa];
+	u8	   reserved_at_40[0x1c0];

 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_receive;

@@ -4839,6 +4850,9 @@ struct mlx5_ifc_alloc_packet_reformat_context_out_bits {
 enum {
 	MLX5_REFORMAT_TYPE_L2_TO_VXLAN = 0x0,
 	MLX5_REFORMAT_TYPE_L2_TO_NVGRE = 0x1,
+	MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL = 0x2,
+	MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x3,
+	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
 };

 struct mlx5_ifc_alloc_packet_reformat_context_in_bits {
