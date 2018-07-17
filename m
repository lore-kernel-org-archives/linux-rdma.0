From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 7/8] net/mlx5: Better return types for CQE API
Date: Mon, 16 Jul 2018 18:35:36 -0700
Message-ID: <20180717013537.26411-8-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Reduce sizes of return types.
Use bool for binary indication.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f8671c0a43aa..0566c6a94805 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -750,7 +750,7 @@ enum {
 
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
 
-static inline int mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
+static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->op_own >> 2) & 0x3;
 }
@@ -770,14 +770,14 @@ static inline u8 get_cqe_l3_hdr_type(struct mlx5_cqe64 *cqe)
 	return (cqe->l4_l3_hdr_type >> 2) & 0x3;
 }
 
-static inline u8 cqe_is_tunneled(struct mlx5_cqe64 *cqe)
+static inline bool cqe_is_tunneled(struct mlx5_cqe64 *cqe)
 {
 	return cqe->outer_l3_tunneled & 0x1;
 }
 
-static inline int cqe_has_vlan(struct mlx5_cqe64 *cqe)
+static inline bool cqe_has_vlan(struct mlx5_cqe64 *cqe)
 {
-	return !!(cqe->l4_l3_hdr_type & 0x1);
+	return cqe->l4_l3_hdr_type & 0x1;
 }
 
 static inline u64 get_cqe_ts(struct mlx5_cqe64 *cqe)
-- 
2.17.0
