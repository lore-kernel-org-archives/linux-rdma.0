From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/4] net/mlx5: When fetching CQEs return CQE instead of void pointer
Date: Tue,  4 Dec 2018 18:03:00 -0800
Message-ID: <20181205020303.16318-2-saeedm@mellanox.com>
References: <20181205020303.16318-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205020303.16318-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

The function is only used to retrieve CQEs, use the proper type as the
return value.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/wq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index b1293d153a58..9bc2184a46bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -177,7 +177,7 @@ static inline u32 mlx5_cqwq_get_ci(struct mlx5_cqwq *wq)
 	return mlx5_cqwq_ctr2ix(wq, wq->cc);
 }
 
-static inline void *mlx5_cqwq_get_wqe(struct mlx5_cqwq *wq, u32 ix)
+static inline struct mlx5_cqe64 *mlx5_cqwq_get_wqe(struct mlx5_cqwq *wq, u32 ix)
 {
 	return mlx5_frag_buf_get_wqe(&wq->fbc, ix);
 }
-- 
2.19.2
