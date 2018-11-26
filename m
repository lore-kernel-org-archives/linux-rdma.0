From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/7] net/mlx5: Update mlx5_ifc with DEVX UCTX capabilities bits
Date: Mon, 26 Nov 2018 08:28:32 +0200
Message-ID: <20181126062838.5907-2-leon@kernel.org>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose device capabilities for DEVX user context, it includes which caps
the device is supported and a matching bit to set as part of user
context creation.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6f64e814cc10..ece1b606c909 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -883,6 +883,10 @@ enum {
 	MLX5_CAP_UMR_FENCE_NONE		= 0x2,
 };
 
+enum {
+	MLX5_UCTX_CAP_RAW_TX = 1UL << 0,
+};
+
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x30];
 	u8         vhca_id[0x10];
@@ -1193,7 +1197,13 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   num_vhca_ports[0x8];
 	u8	   reserved_at_618[0x6];
 	u8	   sw_owner_id[0x1];
-	u8	   reserved_at_61f[0x1e1];
+	u8         reserved_at_61f[0x1];
+
+	u8         reserved_at_620[0x80];
+
+	u8         uctx_cap[0x20];
+
+	u8	   reserved_at_6c0[0x140];
 };
 
 enum mlx5_flow_destination_type {
@@ -9276,7 +9286,9 @@ struct mlx5_ifc_umem_bits {
 struct mlx5_ifc_uctx_bits {
 	u8         modify_field_select[0x40];
 
-	u8         reserved_at_40[0x1c0];
+	u8         cap[0x20];
+
+	u8         reserved_at_60[0x1a0];
 };
 
 struct mlx5_ifc_create_umem_in_bits {
-- 
2.19.1
