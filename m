From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 2/2] net/mlx5: Set completion EQs as shared resources
Date: Tue, 14 May 2019 14:44:12 +0300
Message-ID: <20190514114412.30604-3-leon@kernel.org>
References: <20190514114412.30604-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190514114412.30604-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Mark completion EQs as shared resources so that they can be used by CQs
with uid != 0.

Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 +++
 include/linux/mlx5/mlx5_ifc.h                | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 5aac97847721..23883d1fa22f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -291,6 +291,9 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, const char *name,
 	mlx5_fill_page_array(&eq->buf, pas);
 
 	MLX5_SET(create_eq_in, in, opcode, MLX5_CMD_OP_CREATE_EQ);
+	if (!param->mask && MLX5_CAP_GEN(dev, log_max_uctx))
+		MLX5_SET(create_eq_in, in, uid, MLX5_SHARED_RESOURCE_UID);
+
 	MLX5_SET64(create_eq_in, in, event_bitmask, param->mask);
 
 	eqc = MLX5_ADDR_OF(create_eq_in, in, eq_context_entry);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9be13e2c5a20..9c9979cf0fd5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -7346,7 +7346,7 @@ struct mlx5_ifc_create_eq_out_bits {
 
 struct mlx5_ifc_create_eq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.20.1
