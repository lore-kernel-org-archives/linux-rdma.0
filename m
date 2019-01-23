From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net/mlx4: Mark expected switch fall-through
Date: Wed, 23 Jan 2019 02:05:11 -0600
Message-ID: <20190123080511.GA32528@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/ethernet/mellanox/mlx4/eq.c: In function ‘mlx4_eq_int’:
drivers/net/ethernet/mellanox/mlx4/mlx4.h:219:5: warning: this statement may fall through [-Wimplicit-fallthrough=]
  if (mlx4_debug_level)      \
     ^
drivers/net/ethernet/mellanox/mlx4/eq.c:558:4: note: in expansion of macro ‘mlx4_dbg’
    mlx4_dbg(dev, "%s: MLX4_EVENT_TYPE_SRQ_LIMIT. srq_no=0x%x, eq 0x%x\n",
    ^~~~~~~~
drivers/net/ethernet/mellanox/mlx4/eq.c:561:3: note: here
   case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
   ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enabling
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 4953c852c247..2f4201023836 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -558,6 +558,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			mlx4_dbg(dev, "%s: MLX4_EVENT_TYPE_SRQ_LIMIT. srq_no=0x%x, eq 0x%x\n",
 				 __func__, be32_to_cpu(eqe->event.srq.srqn),
 				 eq->eqn);
+			/* fall through */
 		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
 			if (mlx4_is_master(dev)) {
 				/* forward only to slave owning the SRQ */
-- 
2.20.1
