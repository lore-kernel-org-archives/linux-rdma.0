From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 012/262] net/mlx5e: Fix access to non-existing receive queue
Date: Wed, 27 Mar 2019 13:57:47 -0400
Message-ID: <20190327180158.10245-12-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit c475e11e82d16133304321bae285c5c1d4cfc856 ]

In case number of channels is changed while interface is down,
RSS indirection table is mistakenly not modified accordingly,
causing access to out-of-range non-existing object.

Fix by updating the RSS indireciton table also in the early
return flow of interface down.

Fixes: fb35c534b788 ("net/mlx5e: Fix NULL pointer derefernce in set channels error flow")
Fixes: bbeb53b8b2c9 ("net/mlx5e: Move RSS params to a dedicated struct")
Reported-by: Or Gerlitz <ogerlitz@mellanox.com>
Tested-by: Maria Pasechnik <mariap@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 47233b9a4f81..e6099f51d25f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -357,6 +357,9 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		priv->channels.params = new_channels.params;
+		if (!netif_is_rxfh_configured(priv->netdev))
+			mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
+						      MLX5E_INDIR_RQT_SIZE, count);
 		goto out;
 	}
 
-- 
2.19.1
