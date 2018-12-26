From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 43/97] net/mlx5e: RX, Verify MPWQE stride size is in range
Date: Wed, 26 Dec 2018 17:35:03 -0500
Message-ID: <20181226223557.149329-43-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Moshe Shemesh <moshe@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit e1c15b62b7015119d3e5915cd2ae3b89d59c2576 ]

Add check of MPWQE stride size is within range supported by HW. In case
calculated MPWQE stride size exceed range, linear SKB can't be used and
we should use non linear MPWQE instead.

Fixes: 619a8f2a42f1 ("net/mlx5e: Use linear SKB in Striding RQ")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index faa84b45e20a..06c3902d1f94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -128,6 +128,8 @@ static bool mlx5e_rx_is_linear_skb(struct mlx5_core_dev *mdev,
 	return !params->lro_en && frag_sz <= PAGE_SIZE;
 }
 
+#define MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ ((BIT(__mlx5_bit_sz(wq, log_wqe_stride_size)) - 1) + \
+					  MLX5_MPWQE_LOG_STRIDE_SZ_BASE)
 static bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
 					 struct mlx5e_params *params)
 {
@@ -138,6 +140,9 @@ static bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
 	if (!mlx5e_rx_is_linear_skb(mdev, params))
 		return false;
 
+	if (order_base_2(frag_sz) > MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ)
+		return false;
+
 	if (MLX5_CAP_GEN(mdev, ext_stride_num_range))
 		return true;
 
-- 
2.19.1
