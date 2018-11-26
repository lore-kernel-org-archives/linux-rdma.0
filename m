From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 02/13] net/mlx5: Allow port change event to be forwarded to driver notifiers chain
Date: Mon, 26 Nov 2018 14:38:57 -0800
Message-ID: <20181126223908.15988-3-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

The idea is to allow mlx5 core interfaces (mlx5e/mlx5_ib) to be able to
receive some allowed FW events as is via the new notifier API.

In this patch we allow forwarding port change event to mlx5 core interfaces
(mlx5e/mlx5_ib) as it was received from FW.
Once mlx5e and mlx5_ib start using this event we can safely remove the
redundant software version of it and its translation logic.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 560cc14c55f7..adab66eb726c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -24,12 +24,18 @@ static int general_event(struct notifier_block *, unsigned long, void *);
 static int temp_warn(struct notifier_block *, unsigned long, void *);
 static int port_module(struct notifier_block *, unsigned long, void *);
 
+/* handler which forwards the event to events->nh, driver notifiers */
+static int forward_event(struct notifier_block *, unsigned long, void *);
+
 static struct mlx5_nb events_nbs_ref[] = {
 	{.nb.notifier_call = any_notifier,  .event_type = MLX5_EVENT_TYPE_NOTIFY_ANY },
 	{.nb.notifier_call = port_change,   .event_type = MLX5_EVENT_TYPE_PORT_CHANGE },
 	{.nb.notifier_call = general_event, .event_type = MLX5_EVENT_TYPE_GENERAL_EVENT },
 	{.nb.notifier_call = temp_warn,     .event_type = MLX5_EVENT_TYPE_TEMP_WARN_EVENT },
 	{.nb.notifier_call = port_module,   .event_type = MLX5_EVENT_TYPE_PORT_MODULE_EVENT },
+
+	/* Events to be forwarded (as is) to mlx5 core interfaces (mlx5e/mlx5_ib) */
+	{.nb.notifier_call = forward_event,   .event_type = MLX5_EVENT_TYPE_PORT_CHANGE },
 };
 
 struct mlx5_events {
@@ -294,6 +300,16 @@ void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats)
 	*stats = dev->priv.events->pme_stats;
 }
 
+/* forward event as is to registered interfaces (mlx5e/mlx5_ib) */
+static int forward_event(struct notifier_block *nb, unsigned long event, void *data)
+{
+	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
+	struct mlx5_events   *events   = event_nb->ctx;
+
+	atomic_notifier_call_chain(&events->nh, event, data);
+	return NOTIFY_OK;
+}
+
 int mlx5_events_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_events *events = kzalloc(sizeof(*events), GFP_KERNEL);
-- 
2.19.1
