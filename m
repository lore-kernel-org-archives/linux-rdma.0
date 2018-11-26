From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/13] net/mlx5: Remove unused events callback and logic
Date: Mon, 26 Nov 2018 14:39:01 -0800
Message-ID: <20181126223908.15988-7-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

The mlx5_interface->event callback is not used by mlx5e/mlx5_ib anymore.

We totally remove the delayed events logic work around, since with
the dynamic notifier registration API it is not needed anymore, mlx5_ib
can register its notifier and start receiving events exactly at the moment
it is ready to handle them.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 109 +-----------------
 .../net/ethernet/mellanox/mlx5/core/events.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  10 --
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 -
 include/linux/mlx5/driver.h                   |  10 +-
 6 files changed, 11 insertions(+), 132 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index d63ba8813829..d2ed14bc37c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -32,7 +32,6 @@
 
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
-#include "lib/mlx5.h"
 
 static LIST_HEAD(intf_list);
 static LIST_HEAD(mlx5_dev_list);
@@ -46,75 +45,11 @@ struct mlx5_device_context {
 	unsigned long		state;
 };
 
-struct mlx5_delayed_event {
-	struct list_head	list;
-	struct mlx5_core_dev	*dev;
-	enum mlx5_dev_event	event;
-	unsigned long		param;
-};
-
 enum {
 	MLX5_INTERFACE_ADDED,
 	MLX5_INTERFACE_ATTACHED,
 };
 
-static void add_delayed_event(struct mlx5_priv *priv,
-			      struct mlx5_core_dev *dev,
-			      enum mlx5_dev_event event,
-			      unsigned long param)
-{
-	struct mlx5_delayed_event *delayed_event;
-
-	delayed_event = kzalloc(sizeof(*delayed_event), GFP_ATOMIC);
-	if (!delayed_event) {
-		mlx5_core_err(dev, "event %d is missed\n", event);
-		return;
-	}
-
-	mlx5_core_dbg(dev, "Accumulating event %d\n", event);
-	delayed_event->dev = dev;
-	delayed_event->event = event;
-	delayed_event->param = param;
-	list_add_tail(&delayed_event->list, &priv->waiting_events_list);
-}
-
-static void delayed_event_release(struct mlx5_device_context *dev_ctx,
-				  struct mlx5_priv *priv)
-{
-	struct mlx5_core_dev *dev = container_of(priv, struct mlx5_core_dev, priv);
-	struct mlx5_delayed_event *de;
-	struct mlx5_delayed_event *n;
-	struct list_head temp;
-
-	INIT_LIST_HEAD(&temp);
-
-	spin_lock_irq(&priv->ctx_lock);
-
-	priv->is_accum_events = false;
-	list_splice_init(&priv->waiting_events_list, &temp);
-	if (!dev_ctx->context)
-		goto out;
-	list_for_each_entry_safe(de, n, &temp, list)
-		dev_ctx->intf->event(dev, dev_ctx->context, de->event, de->param);
-
-out:
-	spin_unlock_irq(&priv->ctx_lock);
-
-	list_for_each_entry_safe(de, n, &temp, list) {
-		list_del(&de->list);
-		kfree(de);
-	}
-}
-
-/* accumulating events that can come after mlx5_ib calls to
- * ib_register_device, till adding that interface to the events list.
- */
-static void delayed_event_start(struct mlx5_priv *priv)
-{
-	spin_lock_irq(&priv->ctx_lock);
-	priv->is_accum_events = true;
-	spin_unlock_irq(&priv->ctx_lock);
-}
 
 void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv *priv)
 {
@@ -130,8 +65,6 @@ void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv *priv)
 
 	dev_ctx->intf = intf;
 
-	delayed_event_start(priv);
-
 	dev_ctx->context = intf->add(dev);
 	if (dev_ctx->context) {
 		set_bit(MLX5_INTERFACE_ADDED, &dev_ctx->state);
@@ -143,8 +76,6 @@ void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv *priv)
 		spin_unlock_irq(&priv->ctx_lock);
 	}
 
-	delayed_event_release(dev_ctx, priv);
-
 	if (!dev_ctx->context)
 		kfree(dev_ctx);
 }
@@ -188,26 +119,20 @@ static void mlx5_attach_interface(struct mlx5_interface *intf, struct mlx5_priv
 	if (!dev_ctx)
 		return;
 
-	delayed_event_start(priv);
 	if (intf->attach) {
 		if (test_bit(MLX5_INTERFACE_ATTACHED, &dev_ctx->state))
-			goto out;
+			return;
 		if (intf->attach(dev, dev_ctx->context))
-			goto out;
-
+			return;
 		set_bit(MLX5_INTERFACE_ATTACHED, &dev_ctx->state);
 	} else {
 		if (test_bit(MLX5_INTERFACE_ADDED, &dev_ctx->state))
-			goto out;
+			return;
 		dev_ctx->context = intf->add(dev);
 		if (!dev_ctx->context)
-			goto out;
-
+			return;
 		set_bit(MLX5_INTERFACE_ADDED, &dev_ctx->state);
 	}
-
-out:
-	delayed_event_release(dev_ctx, priv);
 }
 
 void mlx5_attach_device(struct mlx5_core_dev *dev)
@@ -403,32 +328,6 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	return res;
 }
 
-void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
-		     unsigned long param)
-{
-	struct mlx5_priv *priv = &dev->priv;
-	struct mlx5_device_context *dev_ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->ctx_lock, flags);
-
-	if (priv->is_accum_events)
-		add_delayed_event(priv, dev, event, param);
-
-	/* After mlx5_detach_device, the dev_ctx->intf is still set and dev_ctx is
-	 * still in priv->ctx_list. In this case, only notify the dev_ctx if its
-	 * ADDED or ATTACHED bit are set.
-	 */
-	list_for_each_entry(dev_ctx, &priv->ctx_list, list)
-		if (dev_ctx->intf->event &&
-		    (test_bit(MLX5_INTERFACE_ADDED, &dev_ctx->state) ||
-		     test_bit(MLX5_INTERFACE_ATTACHED, &dev_ctx->state)))
-			dev_ctx->intf->event(dev, dev_ctx->context, event, param);
-
-	spin_unlock_irqrestore(&priv->ctx_lock, flags);
-
-	mlx5_notifier_call_chain(dev->priv.events, event, (void *)param);
-}
 
 void mlx5_dev_list_lock(void)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index adab66eb726c..ab66f5d65a04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -178,8 +178,8 @@ static int port_change(struct notifier_block *nb,
 			       port, eqe->sub_type);
 	}
 
-	if (dev->event && dev_event_dispatch)
-		dev->event(dev, dev_event, dev_event_data);
+	if (dev_event_dispatch)
+		mlx5_notifier_call_chain(events, dev_event, (void *)dev_event_data);
 
 	return NOTIFY_OK;
 }
@@ -207,8 +207,8 @@ static int general_event(struct notifier_block *nb, unsigned long type, void *da
 			      eqe->sub_type);
 	}
 
-	if (dev->event && dev_event_dispatch)
-		dev->event(dev, dev_event, dev_event_data);
+	if (dev_event_dispatch)
+		mlx5_notifier_call_chain(events, dev_event, (void *)dev_event_data);
 
 	return NOTIFY_OK;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 4e42bd290959..196c07383082 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -39,6 +39,7 @@
 #include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 #include "lib/eq.h"
+#include "lib/mlx5.h"
 
 enum {
 	MLX5_HEALTH_POLL_INTERVAL	= 2 * HZ,
@@ -105,7 +106,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 		mlx5_cmd_trigger_completions(dev);
 	}
 
-	mlx5_core_event(dev, MLX5_DEV_EVENT_SYS_ERROR, 1);
+	mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_SYS_ERROR, (void *)1);
 	mlx5_core_err(dev, "end\n");
 
 unlock:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e56278ead4eb..4bc27a073dc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1125,12 +1125,6 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	return err;
 }
 
-struct mlx5_core_event_handler {
-	void (*event)(struct mlx5_core_dev *dev,
-		      enum mlx5_dev_event event,
-		      void *data);
-};
-
 static const struct devlink_ops mlx5_devlink_ops = {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set = mlx5_devlink_eswitch_mode_set,
@@ -1164,7 +1158,6 @@ static int init_one(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, dev);
 
 	dev->pdev = pdev;
-	dev->event = mlx5_core_event;
 	dev->profile = &profile[prof_sel];
 
 	INIT_LIST_HEAD(&priv->ctx_list);
@@ -1172,9 +1165,6 @@ static int init_one(struct pci_dev *pdev,
 	mutex_init(&dev->pci_status_mutex);
 	mutex_init(&dev->intf_state_mutex);
 
-	INIT_LIST_HEAD(&priv->waiting_events_list);
-	priv->is_accum_events = false;
-
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
 	INIT_LIST_HEAD(&priv->bfregs.reg_head.list);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index c70bd94e18d6..fd3141a4b3f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -102,9 +102,6 @@ int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
 int mlx5_cmd_teardown_hca(struct mlx5_core_dev *dev);
 int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev);
 int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev);
-
-void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
-		     unsigned long param);
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force);
 void mlx5_disable_device(struct mlx5_core_dev *dev);
 void mlx5_recover_device(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 14ca74707275..d3ffc64f9a75 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -588,10 +588,7 @@ struct mlx5_priv {
 	struct list_head        dev_list;
 	struct list_head        ctx_list;
 	spinlock_t              ctx_lock;
-
-	struct list_head	waiting_events_list;
-	bool			is_accum_events;
-	struct mlx5_events     *events;
+	struct mlx5_events      *events;
 
 	struct mlx5_flow_steering *steering;
 	struct mlx5_mpfs        *mpfs;
@@ -696,9 +693,6 @@ struct mlx5_core_dev {
 	/* sync interface state */
 	struct mutex		intf_state_mutex;
 	unsigned long		intf_state;
-	void			(*event) (struct mlx5_core_dev *dev,
-					  enum mlx5_dev_event event,
-					  unsigned long param);
 	struct mlx5_priv	priv;
 	struct mlx5_profile	*profile;
 	atomic_t		num_qps;
@@ -1053,8 +1047,6 @@ struct mlx5_interface {
 	void			(*remove)(struct mlx5_core_dev *dev, void *context);
 	int			(*attach)(struct mlx5_core_dev *dev, void *context);
 	void			(*detach)(struct mlx5_core_dev *dev, void *context);
-	void			(*event)(struct mlx5_core_dev *dev, void *context,
-					 enum mlx5_dev_event event, unsigned long param);
 	void *                  (*get_dev)(void *context);
 	int			protocol;
 	struct list_head	list;
-- 
2.19.1
