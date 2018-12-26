From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 86/97] net/mlx5e: Remove the false indication of software timestamping support
Date: Wed, 26 Dec 2018 17:35:46 -0500
Message-ID: <20181226223557.149329-86-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alaa Hleihel <alaa@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit 4765420439e758bfa4808392d18b0a4cb6f06065 ]

mlx5 driver falsely advertises support of software timestamping.
Fix it by removing the false indication.

Fixes: ef9814deafd0 ("net/mlx5e: Add HW timestamping (TS) support")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 98dd3e0ada72..5e5423076b03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1101,11 +1101,6 @@ int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
 			      struct ethtool_ts_info *info)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	int ret;
-
-	ret = ethtool_op_get_ts_info(priv->netdev, info);
-	if (ret)
-		return ret;
 
 	info->phc_index = mlx5_clock_get_ptp_index(mdev);
 
@@ -1113,9 +1108,9 @@ int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
 	    info->phc_index == -1)
 		return 0;
 
-	info->so_timestamping |= SOF_TIMESTAMPING_TX_HARDWARE |
-				 SOF_TIMESTAMPING_RX_HARDWARE |
-				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
 
 	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
 			 BIT(HWTSTAMP_TX_ON);
-- 
2.19.1
