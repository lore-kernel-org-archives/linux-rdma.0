From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: Enable decap and packet reformat on FDB
Date: Thu,  6 Jun 2019 14:06:09 +0300
Message-ID: <20190606110609.11588-4-leon@kernel.org>
References: <20190606110609.11588-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190606110609.11588-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

If FDB flow tables support decap operation, enable it on creation,
This allows to perform decapsulation of tunnelled packets by steering
rules. If FDB flow tables support reformat operation, enable it on
creation as well.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 70d565283508..cd0c005d1120 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3917,6 +3917,11 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		max_table_size = BIT(
 			MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, log_max_ft_size));
+		if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, decap) && esw_encap)
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
+		if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, reformat_l3_tunnel_to_l2) &&
+		    esw_encap)
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		priority = FDB_BYPASS_PATH;
 	}
 
-- 
2.20.1
