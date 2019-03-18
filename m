From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] net: mlx5: Add a missing check on idr_find
Date: Mon, 18 Mar 2019 17:18:51 -0500
Message-ID: <20190318221924.7034-1-pakki001@umn.edu>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Boris Pismenny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

idr_find() can return a NULL value to 'flow' which is used without a check.
The patch adds a check to avoid potential NULL pointer dereference.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
index 5cf5f2a9d51f..3df468acdffc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
@@ -226,6 +226,8 @@ int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
 	rcu_read_lock();
 	flow = idr_find(&mdev->fpga->tls->rx_idr, ntohl(handle));
 	rcu_read_unlock();
+	if (!flow)
+		return -EINVAL;
 	mlx5_fpga_tls_flow_to_cmd(flow, cmd);
 
 	MLX5_SET(tls_cmd, cmd, swid, ntohl(handle));
-- 
2.17.1
