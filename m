From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 01/13] net/mlx5: Driver events notifier API
Date: Mon, 26 Nov 2018 14:38:56 -0800
Message-ID: <20181126223908.15988-2-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Use atomic notifier chain to fire events to mlx5 core driver
consumers (mlx5e/mlx5_ib) and provide mlx5 register/unregister notifier
API.

This API will replace the current mlx5_interface->event callback and all
the logic around it, especially the delayed events logic introduced by
commit 97834eba7c19 ("net/mlx5: Delay events till ib registration ends")

Which is not needed anymore with this new API where the mlx5 interface
can dynamically register/unregister its notifier.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/events.c  | 25 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  1 +
 include/linux/mlx5/driver.h                   |  4 +++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 3ad004af37d7..560cc14c55f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -35,7 +35,8 @@ static struct mlx5_nb events_nbs_ref[] = {
 struct mlx5_events {
 	struct mlx5_core_dev *dev;
 	struct mlx5_event_nb  notifiers[ARRAY_SIZE(events_nbs_ref)];
-
+	/* driver notifier chain */
+	struct atomic_notifier_head nh;
 	/* port module events stats */
 	struct mlx5_pme_stats pme_stats;
 };
@@ -300,6 +301,7 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 	if (!events)
 		return -ENOMEM;
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&events->nh);
 	events->dev = dev;
 	dev->priv.events = events;
 	return 0;
@@ -330,3 +332,24 @@ void mlx5_events_stop(struct mlx5_core_dev *dev)
 	for (i = ARRAY_SIZE(events_nbs_ref) - 1; i >= 0 ; i--)
 		mlx5_eq_notifier_unregister(dev, &events->notifiers[i].nb);
 }
+
+int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb)
+{
+	struct mlx5_events *events = dev->priv.events;
+
+	return atomic_notifier_chain_register(&events->nh, nb);
+}
+EXPORT_SYMBOL(mlx5_notifier_register);
+
+int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb)
+{
+	struct mlx5_events *events = dev->priv.events;
+
+	return atomic_notifier_chain_unregister(&events->nh, nb);
+}
+EXPORT_SYMBOL(mlx5_notifier_unregister);
+
+int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data)
+{
+	return atomic_notifier_call_chain(&events->nh, event, data);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 23317e328b0b..4d78a459676e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -73,5 +73,6 @@ struct mlx5_pme_stats {
 };
 
 void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
+int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
 
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ba64ecf72478..b96929d0cc9c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -46,6 +46,7 @@
 #include <linux/mempool.h>
 #include <linux/interrupt.h>
 #include <linux/idr.h>
+#include <linux/notifier.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -1062,6 +1063,9 @@ struct mlx5_interface {
 void *mlx5_get_protocol_dev(struct mlx5_core_dev *mdev, int protocol);
 int mlx5_register_interface(struct mlx5_interface *intf);
 void mlx5_unregister_interface(struct mlx5_interface *intf);
+int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
+int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb);
+
 int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id);
 
 int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev);
-- 
2.19.1
