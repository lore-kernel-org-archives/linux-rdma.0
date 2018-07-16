From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 05/18] net/mlx5: Move header encap type to IFC header file
Date: Mon, 16 Jul 2018 11:22:52 +0300
Message-ID: <20180716082305.11744-6-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Those bits are hardware specification bits and should be defined at the
IFC header file.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 -----
 include/linux/mlx5/mlx5_ifc.h                   | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0edf4751a8ba..74601f9d1c28 100644
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
index fb89cc519703..1b94fcc0109a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4836,6 +4836,11 @@ struct mlx5_ifc_alloc_encap_header_out_bits {
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
