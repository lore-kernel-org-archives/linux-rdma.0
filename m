From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add shared Q counter bits
Date: Sun,  9 Dec 2018 12:52:35 +0200
Message-ID: <20181209105236.26233-2-leon@kernel.org>
References: <20181209105236.26233-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181209105236.26233-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Updated HW specification file with needed bits to allow
sharing of Q counters between DEVX contexts and kernel.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 52393fbcf3b4..15093356a226 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -85,6 +85,10 @@ enum {
 	MLX5_OBJ_TYPE_UMEM = 0x0005,
 };
 
+enum {
+	MLX5_SHARED_RESOURCE_UID = 0xffff,
+};
+
 enum {
 	MLX5_CMD_OP_QUERY_HCA_CAP                 = 0x100,
 	MLX5_CMD_OP_QUERY_ADAPTER                 = 0x101,
@@ -7464,7 +7468,7 @@ struct mlx5_ifc_alloc_q_counter_out_bits {
 
 struct mlx5_ifc_alloc_q_counter_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.19.1
