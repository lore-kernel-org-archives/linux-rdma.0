From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 4/6] net/mlx5: Remove unused mlx5_query_vport_admin_state
Date: Wed,  8 Aug 2018 16:23:51 -0700
Message-ID: <20180808232353.15514-5-saeedm@mellanox.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Eli Cohen <eli@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

mlx5_query_vport_admin_state() is not used anywhere. Remove it.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 10 ----------
 include/linux/mlx5/vport.h                      |  2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 719cecb182c6..7ec85747c450 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -64,16 +64,6 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_vport_state);
 
-u8 mlx5_query_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
-{
-	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {0};
-
-	_mlx5_query_vport_state(mdev, opmod, vport, out, sizeof(out));
-
-	return MLX5_GET(query_vport_state_out, out, admin_state);
-}
-EXPORT_SYMBOL_GPL(mlx5_query_vport_admin_state);
-
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 state)
 {
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 9208cb8809ac..7e7c6dfcfb09 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -43,8 +43,6 @@ enum {
 };
 
 u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport);
-u8 mlx5_query_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
-				u16 vport);
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 state);
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
-- 
2.17.0
