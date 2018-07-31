From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] net/mlx5e: Fix uninitialized variable
Date: Tue, 31 Jul 2018 09:21:57 -0500
Message-ID: <20180731142157.GA24066@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

There is a potential execution path in which variable *err* is returned
without being properly initialized previously.

Fix this by initializing variable *err* to 0.

Addresses-Coverity-ID: 1472116 ("Uninitialized scalar variable")
Fixes: 0ec13877ce95 ("net/mlx5e: Gather all XDP pre-requisite checks in a single function")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fde3502..de2827a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4215,7 +4215,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct bpf_prog *old_prog;
 	bool reset, was_opened;
-	int err;
+	int err = 0;
 	int i;
 
 	mutex_lock(&priv->state_lock);
-- 
2.7.4
