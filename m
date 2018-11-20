From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 11/11] net/mlx5: Improve core device events handling
Date: Tue, 20 Nov 2018 14:12:28 -0800
Message-ID: <20181120221228.18365-12-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Register a separate handler per event type, rather than listening for all
events and looking for the events to handle in a switch case.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/events.c  | 223 +++++++++++-------
 1 file changed, 136 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index d3ab86bd394b..3ad004af37d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -2,15 +2,41 @@
 // Copyright (c) 2018 Mellanox Technologies
 
 #include <linux/mlx5/driver.h>
+
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "lib/mlx5.h"
 
+struct mlx5_event_nb {
+	struct mlx5_nb  nb;
+	void           *ctx;
+};
+
+/* General events handlers for the low level mlx5_core driver
+ *
+ * Other Major feature specific events such as
+ * clock/eswitch/fpga/FW trace and many others, are handled elsewhere, with
+ * separate notifiers callbacks, specifically by those mlx5 components.
+ */
+static int any_notifier(struct notifier_block *, unsigned long, void *);
+static int port_change(struct notifier_block *, unsigned long, void *);
+static int general_event(struct notifier_block *, unsigned long, void *);
+static int temp_warn(struct notifier_block *, unsigned long, void *);
+static int port_module(struct notifier_block *, unsigned long, void *);
+
+static struct mlx5_nb events_nbs_ref[] = {
+	{.nb.notifier_call = any_notifier,  .event_type = MLX5_EVENT_TYPE_NOTIFY_ANY },
+	{.nb.notifier_call = port_change,   .event_type = MLX5_EVENT_TYPE_PORT_CHANGE },
+	{.nb.notifier_call = general_event, .event_type = MLX5_EVENT_TYPE_GENERAL_EVENT },
+	{.nb.notifier_call = temp_warn,     .event_type = MLX5_EVENT_TYPE_TEMP_WARN_EVENT },
+	{.nb.notifier_call = port_module,   .event_type = MLX5_EVENT_TYPE_PORT_MODULE_EVENT },
+};
+
 struct mlx5_events {
-	struct mlx5_nb        nb;
 	struct mlx5_core_dev *dev;
+	struct mlx5_event_nb  notifiers[ARRAY_SIZE(events_nbs_ref)];
 
-	/* port module evetns stats */
+	/* port module events stats */
 	struct mlx5_pme_stats pme_stats;
 };
 
@@ -80,6 +106,19 @@ static const char *eqe_type_str(u8 type)
 	}
 }
 
+/* handles all FW events, type == eqe->type */
+static int any_notifier(struct notifier_block *nb,
+			unsigned long type, void *data)
+{
+	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
+	struct mlx5_events   *events   = event_nb->ctx;
+	struct mlx5_eqe      *eqe      = data;
+
+	mlx5_core_dbg(events->dev, "Async eqe type %s, subtype (%d)\n",
+		      eqe_type_str(eqe->type), eqe->sub_type);
+	return NOTIFY_OK;
+}
+
 static enum mlx5_dev_event port_subtype2dev(u8 subtype)
 {
 	switch (subtype) {
@@ -101,19 +140,92 @@ static enum mlx5_dev_event port_subtype2dev(u8 subtype)
 	return -1;
 }
 
-static void temp_warning_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
+/* type == MLX5_EVENT_TYPE_PORT_CHANGE */
+static int port_change(struct notifier_block *nb,
+		       unsigned long type, void *data)
 {
+	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
+	struct mlx5_events   *events   = event_nb->ctx;
+	struct mlx5_core_dev *dev      = events->dev;
+
+	bool dev_event_dispatch = false;
+	enum mlx5_dev_event dev_event;
+	unsigned long dev_event_data;
+	struct mlx5_eqe *eqe = data;
+	u8 port = (eqe->data.port.port >> 4) & 0xf;
+
+	switch (eqe->sub_type) {
+	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
+	case MLX5_PORT_CHANGE_SUBTYPE_LID:
+	case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
+	case MLX5_PORT_CHANGE_SUBTYPE_GUID:
+	case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
+	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
+		dev_event = port_subtype2dev(eqe->sub_type);
+		dev_event_data = (unsigned long)port;
+		dev_event_dispatch = true;
+		break;
+	default:
+		mlx5_core_warn(dev, "Port event with unrecognized subtype: port %d, sub_type %d\n",
+			       port, eqe->sub_type);
+	}
+
+	if (dev->event && dev_event_dispatch)
+		dev->event(dev, dev_event, dev_event_data);
+
+	return NOTIFY_OK;
+}
+
+/* type == MLX5_EVENT_TYPE_GENERAL_EVENT */
+static int general_event(struct notifier_block *nb, unsigned long type, void *data)
+{
+	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
+	struct mlx5_events   *events   = event_nb->ctx;
+	struct mlx5_core_dev *dev      = events->dev;
+
+	bool dev_event_dispatch = false;
+	enum mlx5_dev_event dev_event;
+	unsigned long dev_event_data;
+	struct mlx5_eqe *eqe = data;
+
+	switch (eqe->sub_type) {
+	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
+		dev_event = MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT;
+		dev_event_data = 0;
+		dev_event_dispatch = true;
+		break;
+	default:
+		mlx5_core_dbg(dev, "General event with unrecognized subtype: sub_type %d\n",
+			      eqe->sub_type);
+	}
+
+	if (dev->event && dev_event_dispatch)
+		dev->event(dev, dev_event, dev_event_data);
+
+	return NOTIFY_OK;
+}
+
+/* type == MLX5_EVENT_TYPE_TEMP_WARN_EVENT */
+static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
+{
+	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
+	struct mlx5_events   *events   = event_nb->ctx;
+	struct mlx5_eqe      *eqe      = data;
 	u64 value_lsb;
 	u64 value_msb;
 
 	value_lsb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_lsb);
 	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
 
-	mlx5_core_warn(dev,
+	mlx5_core_warn(events->dev,
 		       "High temperature on sensors with bit set %llx %llx",
 		       value_msb, value_lsb);
+
+	return NOTIFY_OK;
 }
 
+/* MLX5_EVENT_TYPE_PORT_MODULE_EVENT */
 static const char *mlx5_pme_status[MLX5_MODULE_STATUS_NUM] = {
 	"Cable plugged",   /* MLX5_MODULE_STATUS_PLUGGED    = 0x1 */
 	"Cable unplugged", /* MLX5_MODULE_STATUS_UNPLUGGED  = 0x2 */
@@ -132,12 +244,16 @@ static const char *mlx5_pme_error[MLX5_MODULE_EVENT_ERROR_NUM] = {
 	"Unknown status",
 };
 
-static void port_module_event(struct mlx5_events *events, struct mlx5_eqe *eqe)
+/* type == MLX5_EVENT_TYPE_PORT_MODULE_EVENT */
+static int port_module(struct notifier_block *nb, unsigned long type, void *data)
 {
+	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
+	struct mlx5_events   *events   = event_nb->ctx;
+	struct mlx5_eqe      *eqe      = data;
+
 	enum port_module_event_status_type module_status;
 	enum port_module_event_error_type error_type;
 	struct mlx5_eqe_port_module *module_event_eqe;
-	struct mlx5_core_dev *dev = events->dev;
 	u8 module_num;
 
 	module_event_eqe = &eqe->data.port_module;
@@ -146,7 +262,6 @@ static void port_module_event(struct mlx5_events *events, struct mlx5_eqe *eqe)
 			PORT_MODULE_EVENT_MODULE_STATUS_MASK;
 	error_type = module_event_eqe->error_type &
 		     PORT_MODULE_EVENT_ERROR_TYPE_MASK;
-
 	if (module_status < MLX5_MODULE_STATUS_ERROR) {
 		events->pme_stats.status_counters[module_status - 1]++;
 	} else if (module_status == MLX5_MODULE_STATUS_ERROR) {
@@ -157,18 +272,20 @@ static void port_module_event(struct mlx5_events *events, struct mlx5_eqe *eqe)
 	}
 
 	if (!printk_ratelimit())
-		return;
+		return NOTIFY_OK;
 
 	if (module_status < MLX5_MODULE_STATUS_ERROR)
-		mlx5_core_info(dev,
+		mlx5_core_info(events->dev,
 			       "Port module event: module %u, %s\n",
 			       module_num, mlx5_pme_status[module_status - 1]);
 
 	else if (module_status == MLX5_MODULE_STATUS_ERROR)
-		mlx5_core_info(dev,
+		mlx5_core_info(events->dev,
 			       "Port module event[error]: module %u, %s, %s\n",
 			       module_num, mlx5_pme_status[module_status - 1],
 			       mlx5_pme_error[error_type]);
+
+	return NOTIFY_OK;
 }
 
 void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats)
@@ -176,80 +293,6 @@ void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats)
 	*stats = dev->priv.events->pme_stats;
 }
 
-/* Event handler for the low level mlx5_core driver.
- * This handler will process/filter _some_ events and sometimes dispatch
- * the equivalent mlx5_dev_event to the HCA interfaces (mlx5_ib and mlx5e)
- *
- * Other Major feature specific events such as
- * clock/eswitch/fpga/FW trace and many others, are handled elsewhere, with
- * separate notifiers callbacks, specifically by those mlx5 components.
- */
-static int events_notifier(struct notifier_block *nb,
-			   unsigned long type, void *data)
-{
-	bool dev_event_dispatch = false;
-	enum mlx5_dev_event dev_event;
-	unsigned long dev_event_data;
-
-	struct mlx5_eqe *eqe = data;
-	struct mlx5_events *events;
-	struct mlx5_core_dev *dev;
-	u8 port;
-
-	events = mlx5_nb_cof(nb, struct mlx5_events, nb);
-	dev = events->dev;
-
-	mlx5_core_dbg(dev, "Async eqe type %s, subtype (%d)\n",
-		      eqe_type_str(eqe->type), eqe->sub_type);
-	switch (eqe->type) {
-	case MLX5_EVENT_TYPE_PORT_CHANGE:
-		port = (eqe->data.port.port >> 4) & 0xf;
-		switch (eqe->sub_type) {
-		case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
-		case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
-		case MLX5_PORT_CHANGE_SUBTYPE_LID:
-		case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
-		case MLX5_PORT_CHANGE_SUBTYPE_GUID:
-		case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
-		case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
-			dev_event = port_subtype2dev(eqe->sub_type);
-			dev_event_data = (unsigned long)port;
-			dev_event_dispatch = true;
-			break;
-		default:
-			mlx5_core_warn(dev, "Port event with unrecognized subtype: port %d, sub_type %d\n",
-				       port, eqe->sub_type);
-		}
-		break;
-	case MLX5_EVENT_TYPE_GENERAL_EVENT:
-		switch (eqe->sub_type) {
-		case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
-			dev_event = MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT;
-			dev_event_data = 0;
-			dev_event_dispatch = true;
-			break;
-		default:
-			mlx5_core_dbg(dev, "General event with unrecognized subtype: sub_type %d\n",
-				      eqe->sub_type);
-		}
-		break;
-
-	case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
-		port_module_event(events, eqe);
-		break;
-	case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
-		temp_warning_event(dev, eqe);
-		break;
-	default:
-		return NOTIFY_DONE;
-	}
-
-	if (dev->event && dev_event_dispatch)
-		dev->event(dev, dev_event, dev_event_data);
-
-	return NOTIFY_OK;
-}
-
 int mlx5_events_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_events *events = kzalloc(sizeof(*events), GFP_KERNEL);
@@ -270,14 +313,20 @@ void mlx5_events_cleanup(struct mlx5_core_dev *dev)
 void mlx5_events_start(struct mlx5_core_dev *dev)
 {
 	struct mlx5_events *events = dev->priv.events;
+	int i;
 
-	MLX5_NB_INIT(&events->nb, events_notifier, NOTIFY_ANY);
-	mlx5_eq_notifier_register(dev, &events->nb);
+	for (i = 0; i < ARRAY_SIZE(events_nbs_ref); i++) {
+		events->notifiers[i].nb  = events_nbs_ref[i];
+		events->notifiers[i].ctx = events;
+		mlx5_eq_notifier_register(dev, &events->notifiers[i].nb);
+	}
 }
 
 void mlx5_events_stop(struct mlx5_core_dev *dev)
 {
 	struct mlx5_events *events = dev->priv.events;
+	int i;
 
-	mlx5_eq_notifier_unregister(dev, &events->nb);
+	for (i = ARRAY_SIZE(events_nbs_ref) - 1; i >= 0 ; i--)
+		mlx5_eq_notifier_unregister(dev, &events->notifiers[i].nb);
 }
-- 
2.19.1
