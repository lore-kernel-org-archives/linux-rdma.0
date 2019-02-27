From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH 1/8] net/mlx4: use kzalloc instead of kmalloc
Date: Tue, 26 Feb 2019 22:09:56 -0800
Message-ID: <b350ebb5410291e80e12244ccb41b4b4bae31e0c.1551246708.git.bobbyeshleman@gmail.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bobbyeshleman@gmail.com
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch replaces a kmalloc/memset(,0) call with a call to kzalloc.
It also removes a memset(,0) call that always follows a *zalloc call.

Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c   | 1 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index e65bc3c95630..7bfa6e850e5f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -3307,7 +3307,6 @@ int mlx4_get_counter_stats(struct mlx4_dev *dev, int counter_index,
 	if (IS_ERR(mailbox))
 		return PTR_ERR(mailbox);
 
-	memset(mailbox->buf, 0, sizeof(struct mlx4_counter));
 	if_stat_in_mod = counter_index;
 	if (reset)
 		if_stat_in_mod |= MLX4_QUERY_IF_STAT_RESET;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 9a0881cb7f51..f55805d206ef 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1044,7 +1044,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	struct mlx4_qp_context *context;
 	int err = 0;
 
-	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -1055,7 +1055,6 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	}
 	qp->event = mlx4_en_sqp_event;
 
-	memset(context, 0, sizeof(*context));
 	mlx4_en_fill_qp_context(priv, ring->actual_size, ring->stride, 0, 0,
 				qpn, ring->cqn, -1, context);
 	context->db_rec_addr = cpu_to_be64(ring->wqres.db.dma);
-- 
2.20.1
