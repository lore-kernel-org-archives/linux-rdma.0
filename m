From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 1/2] net/mlx5e: Add missing static function annotation
Date: Sun, 17 Feb 2019 15:21:27 +0200
Message-ID: <20190217132128.9709-2-leon@kernel.org>
References: <20190217132128.9709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217132128.9709-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "David S . Miller" <davem@davemloft.net>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Eyal Davidovich <eyald@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>


Compilation with W=1 produces following warning:

drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c:69:6:
warning: no previous prototype for _mlx5e_monitor_counter_start_ [-Wmissing-prototypes]
 void mlx5e_monitor_counter_start(struct mlx5e_priv *priv)
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Avoid it by declaring mlx5e_monitor_counter_start() as a static function.

Fixes: 5c7e8bbb0257 ("net/mlx5e: Use monitor counters for update stats")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
index 2ce420851e77..7cd5b02e0f10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
@@ -66,7 +66,7 @@ static int mlx5e_monitor_event_handler(struct notifier_block *nb,
 	return NOTIFY_OK;
 }

-void mlx5e_monitor_counter_start(struct mlx5e_priv *priv)
+static void mlx5e_monitor_counter_start(struct mlx5e_priv *priv)
 {
 	MLX5_NB_INIT(&priv->monitor_counters_nb, mlx5e_monitor_event_handler,
 		     MONITOR_COUNTER);
