From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v2 10/20] net/mlx5: Expose DEVX ifc structures
Date: Sun, 17 Jun 2018 12:59:56 +0300
Message-ID: <20180617100006.30663-11-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

This patch updates the mlx5_ifc structures with the following:
- Expose general command header in/out format.
- Expose user context format.
- Expose umem format.

Downstream patches from this series will use this stuff.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 27134c4fcb76..78d4993a2920 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9115,4 +9115,56 @@ struct mlx5_ifc_dealloc_memic_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         obj_type[0x10];
+
+	u8         obj_id[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         obj_id[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_umem_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x5b];
+	u8         log_page_size[0x5];
+
+	u8         page_offset[0x20];
+
+	u8         num_of_mtt[0x40];
+
+	struct mlx5_ifc_mtt_bits  mtt[0];
+};
+
+struct mlx5_ifc_uctx_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x1c0];
+};
+
+struct mlx5_ifc_create_umem_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits   hdr;
+	struct mlx5_ifc_umem_bits                     umem;
+};
+
+struct mlx5_ifc_create_uctx_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits   hdr;
+	struct mlx5_ifc_uctx_bits                     uctx;
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.14.4
