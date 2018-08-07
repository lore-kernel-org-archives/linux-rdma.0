From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 17/33] net/mlx4/mcg: Mark expected switch fall-throughs
Date: Tue, 7 Aug 2018 18:21:05 -0500
Message-ID: <36bde39221c9fc3bcf1a8697c5da2a6887d0398b.1533675546.git.gustavo@embeddedor.com>
References: <cover.1533675546.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1533675546.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114792 ("Missing break in switch")
Addresses-Coverity-ID: 114793 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 4c5306d..ffed2d4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1412,6 +1412,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	case MLX4_STEERING_MODE_A0:
 		if (prot == MLX4_PROT_ETH)
 			return 0;
+		/* fall through */
 
 	case MLX4_STEERING_MODE_B0:
 		if (prot == MLX4_PROT_ETH)
@@ -1441,6 +1442,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	case MLX4_STEERING_MODE_A0:
 		if (prot == MLX4_PROT_ETH)
 			return 0;
+		/* fall through */
 
 	case MLX4_STEERING_MODE_B0:
 		if (prot == MLX4_PROT_ETH)
-- 
2.7.4
