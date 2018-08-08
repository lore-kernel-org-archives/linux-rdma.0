From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 5/6] net/mlx5: Unexport functions that need not be exported
Date: Wed,  8 Aug 2018 16:23:52 -0700
Message-ID: <20180808232353.15514-6-saeedm@mellanox.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Eli Cohen <eli@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

mlx5_query_vport_state() and mlx5_modify_vport_admin_state() are used
only from within mlx5_core  - unexport them.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 7ec85747c450..702e235962aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -62,7 +62,6 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
 
 	return MLX5_GET(query_vport_state_out, out, state);
 }
-EXPORT_SYMBOL_GPL(mlx5_query_vport_state);
 
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 state)
@@ -80,7 +79,6 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
-EXPORT_SYMBOL_GPL(mlx5_modify_vport_admin_state);
 
 static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
 					u32 *out, int outlen)
-- 
2.17.0
