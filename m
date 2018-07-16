From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 03/18] net/mlx5: Add support for more namespaces when allocating modify header
Date: Mon, 16 Jul 2018 11:22:50 +0300
Message-ID: <20180716082305.11744-4-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

There are RX and TX flow steering namespaces with different number of
actions. Initialize them accordingly.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 31f71094db9c..53666b22ad92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -660,9 +660,14 @@ int mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 		table_type = FS_FT_FDB;
 		break;
 	case MLX5_FLOW_NAMESPACE_KERNEL:
+	case MLX5_FLOW_NAMESPACE_BYPASS:
 		max_actions = MLX5_CAP_FLOWTABLE_NIC_RX(dev, max_modify_header_actions);
 		table_type = FS_FT_NIC_RX;
 		break;
+	case MLX5_FLOW_NAMESPACE_EGRESS:
+		max_actions = MLX5_CAP_FLOWTABLE_NIC_TX(dev, max_modify_header_actions);
+		table_type = FS_FT_NIC_TX;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
