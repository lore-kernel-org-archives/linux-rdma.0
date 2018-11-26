From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/13] net/mlx5: Remove all deprecated software versions of FW events
Date: Mon, 26 Nov 2018 14:39:05 -0800
Message-ID: <20181126223908.15988-11-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Before the new mlx5 event notification infrastructure and API,
mlx5_core used to process all events before forwarding them to mlx5
interfaces (mlx5e/mlx5_ib) and used to translate the event type enum
to a software defined enum, this is not needed anymore since it is ok
for mlx5e and mlx5_ib to receive FW events as is, at least the few ones
mlx5 core allows.

mlx5e and mlx5_ib already moved to use the new API and they only handle FW
events types, it is now safe to remove all equivalent software defined
events and the logic around them.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/events.c  | 92 +------------------
 include/linux/mlx5/driver.h                   |  9 --
 2 files changed, 1 insertion(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 735a9b038a73..3708b42c1d6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -19,8 +19,6 @@ struct mlx5_event_nb {
  * separate notifiers callbacks, specifically by those mlx5 components.
  */
 static int any_notifier(struct notifier_block *, unsigned long, void *);
-static int port_change(struct notifier_block *, unsigned long, void *);
-static int general_event(struct notifier_block *, unsigned long, void *);
 static int temp_warn(struct notifier_block *, unsigned long, void *);
 static int port_module(struct notifier_block *, unsigned long, void *);
 
@@ -28,9 +26,8 @@ static int port_module(struct notifier_block *, unsigned long, void *);
 static int forward_event(struct notifier_block *, unsigned long, void *);
 
 static struct mlx5_nb events_nbs_ref[] = {
+	/* Events to be proccessed by mlx5_core */
 	{.nb.notifier_call = any_notifier,  .event_type = MLX5_EVENT_TYPE_NOTIFY_ANY },
-	{.nb.notifier_call = port_change,   .event_type = MLX5_EVENT_TYPE_PORT_CHANGE },
-	{.nb.notifier_call = general_event, .event_type = MLX5_EVENT_TYPE_GENERAL_EVENT },
 	{.nb.notifier_call = temp_warn,     .event_type = MLX5_EVENT_TYPE_TEMP_WARN_EVENT },
 	{.nb.notifier_call = port_module,   .event_type = MLX5_EVENT_TYPE_PORT_MODULE_EVENT },
 
@@ -127,93 +124,6 @@ static int any_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static enum mlx5_dev_event port_subtype2dev(u8 subtype)
-{
-	switch (subtype) {
-	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
-		return MLX5_DEV_EVENT_PORT_DOWN;
-	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
-		return MLX5_DEV_EVENT_PORT_UP;
-	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
-		return MLX5_DEV_EVENT_PORT_INITIALIZED;
-	case MLX5_PORT_CHANGE_SUBTYPE_LID:
-		return MLX5_DEV_EVENT_LID_CHANGE;
-	case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
-		return MLX5_DEV_EVENT_PKEY_CHANGE;
-	case MLX5_PORT_CHANGE_SUBTYPE_GUID:
-		return MLX5_DEV_EVENT_GUID_CHANGE;
-	case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
-		return MLX5_DEV_EVENT_CLIENT_REREG;
-	}
-	return -1;
-}
-
-/* type == MLX5_EVENT_TYPE_PORT_CHANGE */
-static int port_change(struct notifier_block *nb,
-		       unsigned long type, void *data)
-{
-	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
-	struct mlx5_events   *events   = event_nb->ctx;
-	struct mlx5_core_dev *dev      = events->dev;
-
-	bool dev_event_dispatch = false;
-	enum mlx5_dev_event dev_event;
-	unsigned long dev_event_data;
-	struct mlx5_eqe *eqe = data;
-	u8 port = (eqe->data.port.port >> 4) & 0xf;
-
-	switch (eqe->sub_type) {
-	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
-	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
-	case MLX5_PORT_CHANGE_SUBTYPE_LID:
-	case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
-	case MLX5_PORT_CHANGE_SUBTYPE_GUID:
-	case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
-	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
-		dev_event = port_subtype2dev(eqe->sub_type);
-		dev_event_data = (unsigned long)port;
-		dev_event_dispatch = true;
-		break;
-	default:
-		mlx5_core_warn(dev, "Port event with unrecognized subtype: port %d, sub_type %d\n",
-			       port, eqe->sub_type);
-	}
-
-	if (dev_event_dispatch)
-		mlx5_notifier_call_chain(events, dev_event, (void *)dev_event_data);
-
-	return NOTIFY_OK;
-}
-
-/* type == MLX5_EVENT_TYPE_GENERAL_EVENT */
-static int general_event(struct notifier_block *nb, unsigned long type, void *data)
-{
-	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
-	struct mlx5_events   *events   = event_nb->ctx;
-	struct mlx5_core_dev *dev      = events->dev;
-
-	bool dev_event_dispatch = false;
-	enum mlx5_dev_event dev_event;
-	unsigned long dev_event_data;
-	struct mlx5_eqe *eqe = data;
-
-	switch (eqe->sub_type) {
-	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
-		dev_event = MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT;
-		dev_event_data = 0;
-		dev_event_dispatch = true;
-		break;
-	default:
-		mlx5_core_dbg(dev, "General event with unrecognized subtype: sub_type %d\n",
-			      eqe->sub_type);
-	}
-
-	if (dev_event_dispatch)
-		mlx5_notifier_call_chain(events, dev_event, (void *)dev_event_data);
-
-	return NOTIFY_OK;
-}
-
 /* type == MLX5_EVENT_TYPE_TEMP_WARN_EVENT */
 static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d3ffc64f9a75..a77bedb8a556 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -196,15 +196,6 @@ struct mlx5_rsc_debug {
 
 enum mlx5_dev_event {
 	MLX5_DEV_EVENT_SYS_ERROR = 128, /* 0 - 127 are FW events */
-	MLX5_DEV_EVENT_PORT_UP,
-	MLX5_DEV_EVENT_PORT_DOWN,
-	MLX5_DEV_EVENT_PORT_INITIALIZED,
-	MLX5_DEV_EVENT_LID_CHANGE,
-	MLX5_DEV_EVENT_PKEY_CHANGE,
-	MLX5_DEV_EVENT_GUID_CHANGE,
-	MLX5_DEV_EVENT_CLIENT_REREG,
-	MLX5_DEV_EVENT_PPS,
-	MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT,
 };
 
 enum mlx5_port_status {
-- 
2.19.1
