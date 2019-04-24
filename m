From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 24/66] net/mlx5: E-Switch, Protect from invalid memory access in offload fdb table
Date: Wed, 24 Apr 2019 10:32:58 -0400
Message-ID: <20190424143341.27665-24-sashal@kernel.org>
References: <20190424143341.27665-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424143341.27665-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit 5c1d260ed10cf08dd7a0299c103ad0a3f9a9f7a1 ]

The esw offloads structures share a union with the legacy mode structs.
Reset the offloads struct to zero in init to protect from null
assumptions made by the legacy mode code.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d4e6fe5b9300..ce5766a26baa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1402,6 +1402,7 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
 {
 	int err;
 
+	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
 	mutex_init(&esw->fdb_table.offloads.fdb_prio_lock);
 
 	err = esw_create_offloads_fdb_tables(esw, nvports);
-- 
2.19.1
