From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net/mlx5e: Remove redundant assignment
Date: Sat, 2 Mar 2019 13:39:33 -0600
Message-ID: <20190302193933.GA13467@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eli Britstein <elibr@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Remove redundant assignment to tun_entropy->enabled.

Addesses-Coverity-ID: 1477328 ("Unused value")
Fixes: 97417f6182f8 ("net/mlx5e: Fix GRE key by controlling port tunnel entropy calculation")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index 40f4a19b1ce1..be69c1d7941a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -80,10 +80,8 @@ void mlx5_init_port_tun_entropy(struct mlx5_tun_entropy *tun_entropy,
 	mlx5_query_port_tun_entropy(mdev, &entropy_flags);
 	tun_entropy->num_enabling_entries = 0;
 	tun_entropy->num_disabling_entries = 0;
-	tun_entropy->enabled = entropy_flags.calc_enabled;
-	tun_entropy->enabled =
-		(entropy_flags.calc_supported) ?
-		entropy_flags.calc_enabled : true;
+	tun_entropy->enabled = entropy_flags.calc_supported ?
+			       entropy_flags.calc_enabled : true;
 }
 
 static int mlx5_set_entropy(struct mlx5_tun_entropy *tun_entropy,
-- 
2.21.0
