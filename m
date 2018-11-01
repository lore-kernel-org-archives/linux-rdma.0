From: Joe Perches <joe@perches.com>
Subject: [PATCH] mlx5: Fix formats with line continuation whitespace
Date: Thu, 01 Nov 2018 00:09:36 -0700
Message-ID: <e076161b88d0c87f083f28450a130de8eead618f.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The line continuations unintentionally add whitespace so
instead use coalesced formats to remove the whitespace.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index bc86dffdc43c..377b7e65ecf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -188,8 +188,7 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
 		/* new rate limit */
 		err = mlx5_set_pp_rate_limit_cmd(dev, entry->index, rl);
 		if (err) {
-			mlx5_core_err(dev, "Failed configuring rate limit(err %d): \
-				      rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
+			mlx5_core_err(dev, "Failed configuring rate limit(err %d): rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
 				      err, rl->rate, rl->max_burst_sz,
 				      rl->typical_pkt_sz);
 			goto out;
@@ -218,8 +217,7 @@ void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl)
 	mutex_lock(&table->rl_lock);
 	entry = find_rl_entry(table, rl);
 	if (!entry || !entry->refcount) {
-		mlx5_core_warn(dev, "Rate %u, max_burst_sz %u typical_pkt_sz %u \
-			       are not configured\n",
+		mlx5_core_warn(dev, "Rate %u, max_burst_sz %u typical_pkt_sz %u  are not configured\n",
 			       rl->rate, rl->max_burst_sz, rl->typical_pkt_sz);
 		goto out;
 	}
