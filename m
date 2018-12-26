From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 85/97] net/mlx5: Typo fix in del_sw_hw_rule
Date: Wed, 26 Dec 2018 17:35:45 -0500
Message-ID: <20181226223557.149329-85-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Yuval Avnery <yuvalav@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Yuval Avnery <yuvalav@mellanox.com>

[ Upstream commit f0337889147c956721696553ffcc97212b0948fe ]

Expression terminated with "," instead of ";", resulted in
set_fte getting bad value for modify_enable_mask field.

Fixes: bd5251dbf156 ("net/mlx5_core: Introduce flow steering destination of type counter")
Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 37d114c668b7..d181645fd968 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -432,7 +432,7 @@ static void del_sw_hw_rule(struct fs_node *node)
 
 	if ((fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) &&
 	    --fte->dests_size) {
-		modify_mask = BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_DESTINATION_LIST),
+		modify_mask = BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_DESTINATION_LIST);
 		update_fte = true;
 	}
 out:
-- 
2.19.1
