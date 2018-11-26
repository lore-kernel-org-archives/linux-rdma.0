From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/13] net/mlx5e: Use the new mlx5 core notifier API
Date: Mon, 26 Nov 2018 14:38:58 -0800
Message-ID: <20181126223908.15988-4-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the deprecated mlx5_interface->event mlx5e callback and use new
mlx5 notifier API to subscribe for mlx5 events, handle port change event
as received from FW rather than handling the mlx5 core processed port
change software version event.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 27 ++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index aea74856c702..13d8a74d3db5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -631,7 +631,6 @@ struct mlx5e_channel_stats {
 } ____cacheline_aligned_in_smp;
 
 enum {
-	MLX5E_STATE_ASYNC_EVENTS_ENABLED,
 	MLX5E_STATE_OPENED,
 	MLX5E_STATE_DESTROYING,
 };
@@ -690,6 +689,8 @@ struct mlx5e_priv {
 	struct hwtstamp_config     tstamp;
 	u16                        q_counter;
 	u16                        drop_rq_q_counter;
+	struct notifier_block      events_nb;
+
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	struct mlx5e_dcbx          dcbx;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0d495a6b3949..56bc41b1c31f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -294,33 +294,35 @@ void mlx5e_queue_update_stats(struct mlx5e_priv *priv)
 	queue_work(priv->wq, &priv->update_stats_work);
 }
 
-static void mlx5e_async_event(struct mlx5_core_dev *mdev, void *vpriv,
-			      enum mlx5_dev_event event, unsigned long param)
+static int async_event(struct notifier_block *nb, unsigned long event, void *data)
 {
-	struct mlx5e_priv *priv = vpriv;
+	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv, events_nb);
+	struct mlx5_eqe   *eqe = data;
 
-	if (!test_bit(MLX5E_STATE_ASYNC_EVENTS_ENABLED, &priv->state))
-		return;
+	if (event != MLX5_EVENT_TYPE_PORT_CHANGE)
+		return NOTIFY_DONE;
 
-	switch (event) {
-	case MLX5_DEV_EVENT_PORT_UP:
-	case MLX5_DEV_EVENT_PORT_DOWN:
+	switch (eqe->sub_type) {
+	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
 		queue_work(priv->wq, &priv->update_carrier_work);
 		break;
 	default:
-		break;
+		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_OK;
 }
 
 static void mlx5e_enable_async_events(struct mlx5e_priv *priv)
 {
-	set_bit(MLX5E_STATE_ASYNC_EVENTS_ENABLED, &priv->state);
+	priv->events_nb.notifier_call = async_event;
+	mlx5_notifier_register(priv->mdev, &priv->events_nb);
 }
 
 static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
 {
-	clear_bit(MLX5E_STATE_ASYNC_EVENTS_ENABLED, &priv->state);
-	mlx5_eq_synchronize_async_irq(priv->mdev);
+	mlx5_notifier_unregister(priv->mdev, &priv->events_nb);
 }
 
 static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
@@ -5170,7 +5172,6 @@ static struct mlx5_interface mlx5e_interface = {
 	.remove    = mlx5e_remove,
 	.attach    = mlx5e_attach,
 	.detach    = mlx5e_detach,
-	.event     = mlx5e_async_event,
 	.protocol  = MLX5_INTERFACE_PROTOCOL_ETH,
 	.get_dev   = mlx5e_get_netdev,
 };
-- 
2.19.1
