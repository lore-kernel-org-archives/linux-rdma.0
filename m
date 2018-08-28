From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 06/15] net/mlx5: Move header encap type to IFC header file
Date: Tue, 28 Aug 2018 14:18:45 +0300
Message-ID: <20180828111854.14367-7-leon@kernel.org>
References: <20180828111854.14367-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828111854.14367-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Those bits are hardware specification and should be defined in the
IFC header file.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 -----
 include/linux/mlx5/mlx5_ifc.h                   | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9131a1376e7d..240a6fe1587e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -100,11 +100,6 @@ struct mlx5e_tc_flow_parse_attr {
 	int mirred_ifindex;
 };
 
-enum {
-	MLX5_HEADER_TYPE_VXLAN = 0x0,
-	MLX5_HEADER_TYPE_NVGRE = 0x1,
-};
-
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(16)
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f043d65b9bac..bd725e0924e5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4848,6 +4848,11 @@ struct mlx5_ifc_alloc_encap_header_out_bits {
 	u8         reserved_at_60[0x20];
 };
 
+enum {
+	MLX5_HEADER_TYPE_VXLAN = 0x0,
+	MLX5_HEADER_TYPE_NVGRE = 0x1,
+};
+
 struct mlx5_ifc_alloc_encap_header_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];
-- 
2.14.4
