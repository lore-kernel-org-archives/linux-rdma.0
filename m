From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Rename incorrect naming in IFC file
Date: Mon, 17 Sep 2018 13:30:46 +0300
Message-ID: <20180917103049.18235-2-leon@kernel.org>
References: <20180917103049.18235-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917103049.18235-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Remove a trailing underscore from the multicast/unicast names.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c                     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                       | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1f35ecbefffe..8bada4b94444 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1279,7 +1279,7 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 
 	if (dev->rep)
 		MLX5_SET(tirc, tirc, self_lb_block,
-			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST_);
+			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST);
 
 	err = mlx5_core_create_tir(dev->mdev, in, inlen, &rq->tirn);
 
@@ -1582,7 +1582,7 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 create_tir:
 	if (dev->rep)
 		MLX5_SET(tirc, tirc, self_lb_block,
-			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST_);
+			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST);
 
 	err = mlx5_core_create_tir(dev->mdev, in, inlen, &qp->rss_qp.tirn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index db3278cc052b..3078491cc0d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -153,7 +153,7 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb)
 
 	if (enable_uc_lb)
 		MLX5_SET(modify_tir_in, in, ctx.self_lb_block,
-			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST_);
+			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST);
 
 	MLX5_SET(modify_tir_in, in, bitmask.self_lb_en, 1);
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3a4a2e0567e9..4c7a1d25d73b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2559,8 +2559,8 @@ enum {
 };
 
 enum {
-	MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST_    = 0x1,
-	MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST_  = 0x2,
+	MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST    = 0x1,
+	MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST  = 0x2,
 };
 
 struct mlx5_ifc_tirc_bits {
-- 
2.14.4
