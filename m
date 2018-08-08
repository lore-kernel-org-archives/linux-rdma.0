From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 3/6] net/mlx5: E-Switch, Remove unused argument when creating legacy FDB
Date: Wed,  8 Aug 2018 16:23:50 -0700
Message-ID: <20180808232353.15514-4-saeedm@mellanox.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Eli Cohen <eli@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Remove unused nvports argument.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 4e5305106695..d9ba5a7452c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -246,7 +246,7 @@ esw_fdb_set_vport_promisc_rule(struct mlx5_eswitch *esw, u32 vport)
 	return __esw_fdb_set_vport_rule(esw, vport, true, mac_c, mac_v);
 }
 
-static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw, int nvports)
+static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {};
@@ -1620,7 +1620,7 @@ int mlx5_eswitch_enable_sriov(struct mlx5_eswitch *esw, int nvfs, int mode)
 	esw->mode = mode;
 
 	if (mode == SRIOV_LEGACY) {
-		err = esw_create_legacy_fdb_table(esw, nvfs + 1);
+		err = esw_create_legacy_fdb_table(esw);
 	} else {
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 
-- 
2.17.0
