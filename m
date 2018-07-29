From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 20/27] RDMA/mlx5: Enable reformat on NIC RX if supported
Date: Sun, 29 Jul 2018 15:58:58 +0300
Message-ID: <20180729125905.31989-21-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

A L3_TUNNEL_TO_L2 decap flow action requires to enable the encap bit on
the Flow table, enable it if supported. This will allow to attach those
flow actions to NIC RX steering. We don't enable if running on a
representor.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9c42a1059590..b1c7cf26e206 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3087,6 +3087,10 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 			if (!dev->rep &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
+			if (!dev->rep &&
+			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
+						      reformat_l3_tunnel_to_l2))
+				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		} else {
 			max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev,
 								       log_max_ft_size));
-- 
2.14.4
