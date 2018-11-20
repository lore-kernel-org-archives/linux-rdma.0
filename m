From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/11] net/mlx5: Device events, Use async events chain
Date: Tue, 20 Nov 2018 14:12:27 -0800
Message-ID: <20181120221228.18365-11-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Move all the generic async events handling into new specific events
handling file events.c to keep eq.c file clean from concrete event logic
handling.

Use new API to register for NOTIFY_ANY to handle generic events and
dispatch allowed events to mlx5_core consumers (mlx5_ib and mlx5e)

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 157 ----------
 .../net/ethernet/mellanox/mlx5/core/events.c  | 283 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  34 +++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  16 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   6 +-
 .../net/ethernet/mellanox/mlx5/core/port.c    |  57 ----
 include/linux/mlx5/driver.h                   |  29 +-
 include/linux/mlx5/port.h                     |   3 -
 10 files changed, 344 insertions(+), 252 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/events.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index d324a3884462..26afe0779a0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		health.o mcg.o cq.o srq.o alloc.o qp.o port.o mr.o pd.o \
 		mad.o transobj.o vport.o sriov.o fs_cmd.o fs_core.o \
-		fs_counters.o rl.o lag.o dev.o wq.o lib/gid.o  \
+		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		diag/fs_tracepoint.o diag/fw_tracer.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 1e55b9c27ffc..748d23806391 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include "lib/mlx5.h"
 #include "en.h"
 #include "en_accel/ipsec.h"
 #include "en_accel/tls.h"
@@ -1120,15 +1121,17 @@ static int mlx5e_grp_pme_fill_strings(struct mlx5e_priv *priv, u8 *data,
 static int mlx5e_grp_pme_fill_stats(struct mlx5e_priv *priv, u64 *data,
 				    int idx)
 {
-	struct mlx5_priv *mlx5_priv = &priv->mdev->priv;
+	struct mlx5_pme_stats pme_stats;
 	int i;
 
+	mlx5_get_pme_stats(priv->mdev, &pme_stats);
+
 	for (i = 0; i < NUM_PME_STATUS_STATS; i++)
-		data[idx++] = MLX5E_READ_CTR64_CPU(mlx5_priv->pme_stats.status_counters,
+		data[idx++] = MLX5E_READ_CTR64_CPU(pme_stats.status_counters,
 						   mlx5e_pme_status_desc, i);
 
 	for (i = 0; i < NUM_PME_ERR_STATS; i++)
-		data[idx++] = MLX5E_READ_CTR64_CPU(mlx5_priv->pme_stats.error_counters,
+		data[idx++] = MLX5E_READ_CTR64_CPU(pme_stats.error_counters,
 						   mlx5e_pme_error_desc, i);
 
 	return idx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 4e3febbf639d..4aa39a1fe23f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -108,121 +108,6 @@ static int mlx5_cmd_destroy_eq(struct mlx5_core_dev *dev, u8 eqn)
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
-static const char *eqe_type_str(u8 type)
-{
-	switch (type) {
-	case MLX5_EVENT_TYPE_COMP:
-		return "MLX5_EVENT_TYPE_COMP";
-	case MLX5_EVENT_TYPE_PATH_MIG:
-		return "MLX5_EVENT_TYPE_PATH_MIG";
-	case MLX5_EVENT_TYPE_COMM_EST:
-		return "MLX5_EVENT_TYPE_COMM_EST";
-	case MLX5_EVENT_TYPE_SQ_DRAINED:
-		return "MLX5_EVENT_TYPE_SQ_DRAINED";
-	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
-		return "MLX5_EVENT_TYPE_SRQ_LAST_WQE";
-	case MLX5_EVENT_TYPE_SRQ_RQ_LIMIT:
-		return "MLX5_EVENT_TYPE_SRQ_RQ_LIMIT";
-	case MLX5_EVENT_TYPE_CQ_ERROR:
-		return "MLX5_EVENT_TYPE_CQ_ERROR";
-	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
-		return "MLX5_EVENT_TYPE_WQ_CATAS_ERROR";
-	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
-		return "MLX5_EVENT_TYPE_PATH_MIG_FAILED";
-	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
-		return "MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR";
-	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
-		return "MLX5_EVENT_TYPE_WQ_ACCESS_ERROR";
-	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
-		return "MLX5_EVENT_TYPE_SRQ_CATAS_ERROR";
-	case MLX5_EVENT_TYPE_INTERNAL_ERROR:
-		return "MLX5_EVENT_TYPE_INTERNAL_ERROR";
-	case MLX5_EVENT_TYPE_PORT_CHANGE:
-		return "MLX5_EVENT_TYPE_PORT_CHANGE";
-	case MLX5_EVENT_TYPE_GPIO_EVENT:
-		return "MLX5_EVENT_TYPE_GPIO_EVENT";
-	case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
-		return "MLX5_EVENT_TYPE_PORT_MODULE_EVENT";
-	case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
-		return "MLX5_EVENT_TYPE_TEMP_WARN_EVENT";
-	case MLX5_EVENT_TYPE_REMOTE_CONFIG:
-		return "MLX5_EVENT_TYPE_REMOTE_CONFIG";
-	case MLX5_EVENT_TYPE_DB_BF_CONGESTION:
-		return "MLX5_EVENT_TYPE_DB_BF_CONGESTION";
-	case MLX5_EVENT_TYPE_STALL_EVENT:
-		return "MLX5_EVENT_TYPE_STALL_EVENT";
-	case MLX5_EVENT_TYPE_CMD:
-		return "MLX5_EVENT_TYPE_CMD";
-	case MLX5_EVENT_TYPE_PAGE_REQUEST:
-		return "MLX5_EVENT_TYPE_PAGE_REQUEST";
-	case MLX5_EVENT_TYPE_PAGE_FAULT:
-		return "MLX5_EVENT_TYPE_PAGE_FAULT";
-	case MLX5_EVENT_TYPE_PPS_EVENT:
-		return "MLX5_EVENT_TYPE_PPS_EVENT";
-	case MLX5_EVENT_TYPE_NIC_VPORT_CHANGE:
-		return "MLX5_EVENT_TYPE_NIC_VPORT_CHANGE";
-	case MLX5_EVENT_TYPE_FPGA_ERROR:
-		return "MLX5_EVENT_TYPE_FPGA_ERROR";
-	case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
-		return "MLX5_EVENT_TYPE_FPGA_QP_ERROR";
-	case MLX5_EVENT_TYPE_GENERAL_EVENT:
-		return "MLX5_EVENT_TYPE_GENERAL_EVENT";
-	case MLX5_EVENT_TYPE_DEVICE_TRACER:
-		return "MLX5_EVENT_TYPE_DEVICE_TRACER";
-	default:
-		return "Unrecognized event";
-	}
-}
-
-static enum mlx5_dev_event port_subtype_event(u8 subtype)
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
-static void general_event_handler(struct mlx5_core_dev *dev,
-				  struct mlx5_eqe *eqe)
-{
-	switch (eqe->sub_type) {
-	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
-		if (dev->event)
-			dev->event(dev, MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT, 0);
-		break;
-	default:
-		mlx5_core_dbg(dev, "General event with unrecognized subtype: sub_type %d\n",
-			      eqe->sub_type);
-	}
-}
-
-static void mlx5_temp_warning_event(struct mlx5_core_dev *dev,
-				    struct mlx5_eqe *eqe)
-{
-	u64 value_lsb;
-	u64 value_msb;
-
-	value_lsb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_lsb);
-	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
-
-	mlx5_core_warn(dev,
-		       "High temperature on sensors with bit set %llx %llx",
-		       value_msb, value_lsb);
-}
-
 /* caller must eventually call mlx5_cq_put on the returned cq */
 static struct mlx5_core_cq *mlx5_eq_cq_get(struct mlx5_eq *eq, u32 cqn)
 {
@@ -312,7 +197,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 	struct mlx5_core_dev *dev;
 	struct mlx5_eqe *eqe;
 	int set_ci = 0;
-	u8 port;
 
 	dev = eq->dev;
 	eqt = dev->priv.eq_table;
@@ -324,47 +208,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 		 */
 		dma_rmb();
 
-		mlx5_core_dbg(eq->dev, "eqn %d, eqe type %s\n",
-			      eq->eqn, eqe_type_str(eqe->type));
-		switch (eqe->type) {
-		case MLX5_EVENT_TYPE_PORT_CHANGE:
-			port = (eqe->data.port.port >> 4) & 0xf;
-			switch (eqe->sub_type) {
-			case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
-			case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
-			case MLX5_PORT_CHANGE_SUBTYPE_LID:
-			case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
-			case MLX5_PORT_CHANGE_SUBTYPE_GUID:
-			case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
-			case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
-				if (dev->event)
-					dev->event(dev, port_subtype_event(eqe->sub_type),
-						   (unsigned long)port);
-				break;
-			default:
-				mlx5_core_warn(dev, "Port event with unrecognized subtype: port %d, sub_type %d\n",
-					       port, eqe->sub_type);
-			}
-			break;
-
-		case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
-			mlx5_port_module_event(dev, eqe);
-			break;
-
-		case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
-			mlx5_temp_warning_event(dev, eqe);
-			break;
-
-		case MLX5_EVENT_TYPE_GENERAL_EVENT:
-			general_event_handler(dev, eqe);
-			break;
-
-		default:
-			mlx5_core_warn(dev, "Unhandled event 0x%x on EQ 0x%x\n",
-				       eqe->type, eq->eqn);
-			break;
-		}
-
 		if (likely(eqe->type < MLX5_EVENT_TYPE_MAX))
 			atomic_notifier_call_chain(&eqt->nh[eqe->type], eqe->type, eqe);
 		else
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
new file mode 100644
index 000000000000..d3ab86bd394b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2018 Mellanox Technologies
+
+#include <linux/mlx5/driver.h>
+#include "mlx5_core.h"
+#include "lib/eq.h"
+#include "lib/mlx5.h"
+
+struct mlx5_events {
+	struct mlx5_nb        nb;
+	struct mlx5_core_dev *dev;
+
+	/* port module evetns stats */
+	struct mlx5_pme_stats pme_stats;
+};
+
+static const char *eqe_type_str(u8 type)
+{
+	switch (type) {
+	case MLX5_EVENT_TYPE_COMP:
+		return "MLX5_EVENT_TYPE_COMP";
+	case MLX5_EVENT_TYPE_PATH_MIG:
+		return "MLX5_EVENT_TYPE_PATH_MIG";
+	case MLX5_EVENT_TYPE_COMM_EST:
+		return "MLX5_EVENT_TYPE_COMM_EST";
+	case MLX5_EVENT_TYPE_SQ_DRAINED:
+		return "MLX5_EVENT_TYPE_SQ_DRAINED";
+	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
+		return "MLX5_EVENT_TYPE_SRQ_LAST_WQE";
+	case MLX5_EVENT_TYPE_SRQ_RQ_LIMIT:
+		return "MLX5_EVENT_TYPE_SRQ_RQ_LIMIT";
+	case MLX5_EVENT_TYPE_CQ_ERROR:
+		return "MLX5_EVENT_TYPE_CQ_ERROR";
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+		return "MLX5_EVENT_TYPE_WQ_CATAS_ERROR";
+	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
+		return "MLX5_EVENT_TYPE_PATH_MIG_FAILED";
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		return "MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR";
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+		return "MLX5_EVENT_TYPE_WQ_ACCESS_ERROR";
+	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
+		return "MLX5_EVENT_TYPE_SRQ_CATAS_ERROR";
+	case MLX5_EVENT_TYPE_INTERNAL_ERROR:
+		return "MLX5_EVENT_TYPE_INTERNAL_ERROR";
+	case MLX5_EVENT_TYPE_PORT_CHANGE:
+		return "MLX5_EVENT_TYPE_PORT_CHANGE";
+	case MLX5_EVENT_TYPE_GPIO_EVENT:
+		return "MLX5_EVENT_TYPE_GPIO_EVENT";
+	case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
+		return "MLX5_EVENT_TYPE_PORT_MODULE_EVENT";
+	case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
+		return "MLX5_EVENT_TYPE_TEMP_WARN_EVENT";
+	case MLX5_EVENT_TYPE_REMOTE_CONFIG:
+		return "MLX5_EVENT_TYPE_REMOTE_CONFIG";
+	case MLX5_EVENT_TYPE_DB_BF_CONGESTION:
+		return "MLX5_EVENT_TYPE_DB_BF_CONGESTION";
+	case MLX5_EVENT_TYPE_STALL_EVENT:
+		return "MLX5_EVENT_TYPE_STALL_EVENT";
+	case MLX5_EVENT_TYPE_CMD:
+		return "MLX5_EVENT_TYPE_CMD";
+	case MLX5_EVENT_TYPE_PAGE_REQUEST:
+		return "MLX5_EVENT_TYPE_PAGE_REQUEST";
+	case MLX5_EVENT_TYPE_PAGE_FAULT:
+		return "MLX5_EVENT_TYPE_PAGE_FAULT";
+	case MLX5_EVENT_TYPE_PPS_EVENT:
+		return "MLX5_EVENT_TYPE_PPS_EVENT";
+	case MLX5_EVENT_TYPE_NIC_VPORT_CHANGE:
+		return "MLX5_EVENT_TYPE_NIC_VPORT_CHANGE";
+	case MLX5_EVENT_TYPE_FPGA_ERROR:
+		return "MLX5_EVENT_TYPE_FPGA_ERROR";
+	case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
+		return "MLX5_EVENT_TYPE_FPGA_QP_ERROR";
+	case MLX5_EVENT_TYPE_GENERAL_EVENT:
+		return "MLX5_EVENT_TYPE_GENERAL_EVENT";
+	case MLX5_EVENT_TYPE_DEVICE_TRACER:
+		return "MLX5_EVENT_TYPE_DEVICE_TRACER";
+	default:
+		return "Unrecognized event";
+	}
+}
+
+static enum mlx5_dev_event port_subtype2dev(u8 subtype)
+{
+	switch (subtype) {
+	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+		return MLX5_DEV_EVENT_PORT_DOWN;
+	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
+		return MLX5_DEV_EVENT_PORT_UP;
+	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
+		return MLX5_DEV_EVENT_PORT_INITIALIZED;
+	case MLX5_PORT_CHANGE_SUBTYPE_LID:
+		return MLX5_DEV_EVENT_LID_CHANGE;
+	case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
+		return MLX5_DEV_EVENT_PKEY_CHANGE;
+	case MLX5_PORT_CHANGE_SUBTYPE_GUID:
+		return MLX5_DEV_EVENT_GUID_CHANGE;
+	case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
+		return MLX5_DEV_EVENT_CLIENT_REREG;
+	}
+	return -1;
+}
+
+static void temp_warning_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
+{
+	u64 value_lsb;
+	u64 value_msb;
+
+	value_lsb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_lsb);
+	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
+
+	mlx5_core_warn(dev,
+		       "High temperature on sensors with bit set %llx %llx",
+		       value_msb, value_lsb);
+}
+
+static const char *mlx5_pme_status[MLX5_MODULE_STATUS_NUM] = {
+	"Cable plugged",   /* MLX5_MODULE_STATUS_PLUGGED    = 0x1 */
+	"Cable unplugged", /* MLX5_MODULE_STATUS_UNPLUGGED  = 0x2 */
+	"Cable error",     /* MLX5_MODULE_STATUS_ERROR      = 0x3 */
+};
+
+static const char *mlx5_pme_error[MLX5_MODULE_EVENT_ERROR_NUM] = {
+	"Power budget exceeded",
+	"Long Range for non MLNX cable",
+	"Bus stuck(I2C or data shorted)",
+	"No EEPROM/retry timeout",
+	"Enforce part number list",
+	"Unknown identifier",
+	"High Temperature",
+	"Bad or shorted cable/module",
+	"Unknown status",
+};
+
+static void port_module_event(struct mlx5_events *events, struct mlx5_eqe *eqe)
+{
+	enum port_module_event_status_type module_status;
+	enum port_module_event_error_type error_type;
+	struct mlx5_eqe_port_module *module_event_eqe;
+	struct mlx5_core_dev *dev = events->dev;
+	u8 module_num;
+
+	module_event_eqe = &eqe->data.port_module;
+	module_num = module_event_eqe->module;
+	module_status = module_event_eqe->module_status &
+			PORT_MODULE_EVENT_MODULE_STATUS_MASK;
+	error_type = module_event_eqe->error_type &
+		     PORT_MODULE_EVENT_ERROR_TYPE_MASK;
+
+	if (module_status < MLX5_MODULE_STATUS_ERROR) {
+		events->pme_stats.status_counters[module_status - 1]++;
+	} else if (module_status == MLX5_MODULE_STATUS_ERROR) {
+		if (error_type >= MLX5_MODULE_EVENT_ERROR_UNKNOWN)
+			/* Unknown error type */
+			error_type = MLX5_MODULE_EVENT_ERROR_UNKNOWN;
+		events->pme_stats.error_counters[error_type]++;
+	}
+
+	if (!printk_ratelimit())
+		return;
+
+	if (module_status < MLX5_MODULE_STATUS_ERROR)
+		mlx5_core_info(dev,
+			       "Port module event: module %u, %s\n",
+			       module_num, mlx5_pme_status[module_status - 1]);
+
+	else if (module_status == MLX5_MODULE_STATUS_ERROR)
+		mlx5_core_info(dev,
+			       "Port module event[error]: module %u, %s, %s\n",
+			       module_num, mlx5_pme_status[module_status - 1],
+			       mlx5_pme_error[error_type]);
+}
+
+void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats)
+{
+	*stats = dev->priv.events->pme_stats;
+}
+
+/* Event handler for the low level mlx5_core driver.
+ * This handler will process/filter _some_ events and sometimes dispatch
+ * the equivalent mlx5_dev_event to the HCA interfaces (mlx5_ib and mlx5e)
+ *
+ * Other Major feature specific events such as
+ * clock/eswitch/fpga/FW trace and many others, are handled elsewhere, with
+ * separate notifiers callbacks, specifically by those mlx5 components.
+ */
+static int events_notifier(struct notifier_block *nb,
+			   unsigned long type, void *data)
+{
+	bool dev_event_dispatch = false;
+	enum mlx5_dev_event dev_event;
+	unsigned long dev_event_data;
+
+	struct mlx5_eqe *eqe = data;
+	struct mlx5_events *events;
+	struct mlx5_core_dev *dev;
+	u8 port;
+
+	events = mlx5_nb_cof(nb, struct mlx5_events, nb);
+	dev = events->dev;
+
+	mlx5_core_dbg(dev, "Async eqe type %s, subtype (%d)\n",
+		      eqe_type_str(eqe->type), eqe->sub_type);
+	switch (eqe->type) {
+	case MLX5_EVENT_TYPE_PORT_CHANGE:
+		port = (eqe->data.port.port >> 4) & 0xf;
+		switch (eqe->sub_type) {
+		case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+		case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
+		case MLX5_PORT_CHANGE_SUBTYPE_LID:
+		case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
+		case MLX5_PORT_CHANGE_SUBTYPE_GUID:
+		case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
+		case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
+			dev_event = port_subtype2dev(eqe->sub_type);
+			dev_event_data = (unsigned long)port;
+			dev_event_dispatch = true;
+			break;
+		default:
+			mlx5_core_warn(dev, "Port event with unrecognized subtype: port %d, sub_type %d\n",
+				       port, eqe->sub_type);
+		}
+		break;
+	case MLX5_EVENT_TYPE_GENERAL_EVENT:
+		switch (eqe->sub_type) {
+		case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
+			dev_event = MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT;
+			dev_event_data = 0;
+			dev_event_dispatch = true;
+			break;
+		default:
+			mlx5_core_dbg(dev, "General event with unrecognized subtype: sub_type %d\n",
+				      eqe->sub_type);
+		}
+		break;
+
+	case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
+		port_module_event(events, eqe);
+		break;
+	case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
+		temp_warning_event(dev, eqe);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	if (dev->event && dev_event_dispatch)
+		dev->event(dev, dev_event, dev_event_data);
+
+	return NOTIFY_OK;
+}
+
+int mlx5_events_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_events *events = kzalloc(sizeof(*events), GFP_KERNEL);
+
+	if (!events)
+		return -ENOMEM;
+
+	events->dev = dev;
+	dev->priv.events = events;
+	return 0;
+}
+
+void mlx5_events_cleanup(struct mlx5_core_dev *dev)
+{
+	kvfree(dev->priv.events);
+}
+
+void mlx5_events_start(struct mlx5_core_dev *dev)
+{
+	struct mlx5_events *events = dev->priv.events;
+
+	MLX5_NB_INIT(&events->nb, events_notifier, NOTIFY_ANY);
+	mlx5_eq_notifier_register(dev, &events->nb);
+}
+
+void mlx5_events_stop(struct mlx5_core_dev *dev)
+{
+	struct mlx5_events *events = dev->priv.events;
+
+	mlx5_eq_notifier_unregister(dev, &events->nb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 7550b1cc8c6a..23317e328b0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -33,6 +33,8 @@
 #ifndef __LIB_MLX5_H__
 #define __LIB_MLX5_H__
 
+#include "mlx5_core.h"
+
 void mlx5_init_reserved_gids(struct mlx5_core_dev *dev);
 void mlx5_cleanup_reserved_gids(struct mlx5_core_dev *dev);
 int  mlx5_core_reserve_gids(struct mlx5_core_dev *dev, unsigned int count);
@@ -40,4 +42,36 @@ void mlx5_core_unreserve_gids(struct mlx5_core_dev *dev, unsigned int count);
 int  mlx5_core_reserved_gid_alloc(struct mlx5_core_dev *dev, int *gid_index);
 void mlx5_core_reserved_gid_free(struct mlx5_core_dev *dev, int gid_index);
 
+/* TODO move to lib/events.h */
+
+#define PORT_MODULE_EVENT_MODULE_STATUS_MASK 0xF
+#define PORT_MODULE_EVENT_ERROR_TYPE_MASK    0xF
+
+enum port_module_event_status_type {
+	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
+	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
+	MLX5_MODULE_STATUS_ERROR     = 0x3,
+	MLX5_MODULE_STATUS_NUM       = 0x3,
+};
+
+enum  port_module_event_error_type {
+	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED,
+	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX_CABLE_MODULE,
+	MLX5_MODULE_EVENT_ERROR_BUS_STUCK,
+	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT,
+	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST,
+	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER,
+	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE,
+	MLX5_MODULE_EVENT_ERROR_BAD_CABLE,
+	MLX5_MODULE_EVENT_ERROR_UNKNOWN,
+	MLX5_MODULE_EVENT_ERROR_NUM,
+};
+
+struct mlx5_pme_stats {
+	u64 status_counters[MLX5_MODULE_STATUS_NUM];
+	u64 error_counters[MLX5_MODULE_EVENT_ERROR_NUM];
+};
+
+void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9e4cd2757ea8..e56278ead4eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -735,10 +735,16 @@ static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 		goto out;
 	}
 
+	err = mlx5_events_init(dev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to initialize events\n");
+		goto err_eq_cleanup;
+	}
+
 	err = mlx5_cq_debugfs_init(dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to initialize cq debugfs\n");
-		goto err_eq_cleanup;
+		goto err_events_cleanup;
 	}
 
 	mlx5_init_qp_table(dev);
@@ -801,7 +807,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 	mlx5_cleanup_srq_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
-
+err_events_cleanup:
+	mlx5_events_cleanup(dev);
 err_eq_cleanup:
 	mlx5_eq_table_cleanup(dev);
 
@@ -824,6 +831,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_srq_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
+	mlx5_events_cleanup(dev);
 	mlx5_eq_table_cleanup(dev);
 }
 
@@ -947,6 +955,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_get_uars;
 	}
 
+	mlx5_events_start(dev);
 	mlx5_pagealloc_start(dev);
 
 	err = mlx5_eq_table_create(dev);
@@ -1036,6 +1045,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 
 err_eq_table:
 	mlx5_pagealloc_stop(dev);
+	mlx5_events_stop(dev);
 	mlx5_put_uars_page(dev, priv->uar);
 
 err_get_uars:
@@ -1095,8 +1105,8 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
 	mlx5_pagealloc_stop(dev);
+	mlx5_events_stop(dev);
 	mlx5_put_uars_page(dev, priv->uar);
-
 	if (cleanup)
 		mlx5_cleanup_once(dev);
 	mlx5_stop_health_poll(dev, cleanup);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 5dd453e47a04..c70bd94e18d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -105,7 +105,6 @@ int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev);
 
 void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
 		     unsigned long param);
-void mlx5_port_module_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe);
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force);
 void mlx5_disable_device(struct mlx5_core_dev *dev);
 void mlx5_recover_device(struct mlx5_core_dev *dev);
@@ -141,6 +140,11 @@ int mlx5_query_qcam_reg(struct mlx5_core_dev *mdev, u32 *qcam,
 void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev);
 void mlx5_lag_remove(struct mlx5_core_dev *dev);
 
+int mlx5_events_init(struct mlx5_core_dev *dev);
+void mlx5_events_cleanup(struct mlx5_core_dev *dev);
+void mlx5_events_start(struct mlx5_core_dev *dev);
+void mlx5_events_stop(struct mlx5_core_dev *dev);
+
 void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv *priv);
 void mlx5_remove_device(struct mlx5_interface *intf, struct mlx5_priv *priv);
 void mlx5_attach_device(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 31a9cbd85689..2b82f35f4c35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -915,63 +915,6 @@ void mlx5_query_port_fcs(struct mlx5_core_dev *mdev, bool *supported,
 	*enabled = !!(MLX5_GET(pcmr_reg, out, fcs_chk));
 }
 
-static const char *mlx5_pme_status[MLX5_MODULE_STATUS_NUM] = {
-	"Cable plugged",   /* MLX5_MODULE_STATUS_PLUGGED    = 0x1 */
-	"Cable unplugged", /* MLX5_MODULE_STATUS_UNPLUGGED  = 0x2 */
-	"Cable error",     /* MLX5_MODULE_STATUS_ERROR      = 0x3 */
-};
-
-static const char *mlx5_pme_error[MLX5_MODULE_EVENT_ERROR_NUM] = {
-	"Power budget exceeded",
-	"Long Range for non MLNX cable",
-	"Bus stuck(I2C or data shorted)",
-	"No EEPROM/retry timeout",
-	"Enforce part number list",
-	"Unknown identifier",
-	"High Temperature",
-	"Bad or shorted cable/module",
-	"Unknown status",
-};
-
-void mlx5_port_module_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
-{
-	enum port_module_event_status_type module_status;
-	enum port_module_event_error_type error_type;
-	struct mlx5_eqe_port_module *module_event_eqe;
-	struct mlx5_priv *priv = &dev->priv;
-	u8 module_num;
-
-	module_event_eqe = &eqe->data.port_module;
-	module_num = module_event_eqe->module;
-	module_status = module_event_eqe->module_status &
-			PORT_MODULE_EVENT_MODULE_STATUS_MASK;
-	error_type = module_event_eqe->error_type &
-		     PORT_MODULE_EVENT_ERROR_TYPE_MASK;
-
-	if (module_status < MLX5_MODULE_STATUS_ERROR) {
-		priv->pme_stats.status_counters[module_status - 1]++;
-	} else if (module_status == MLX5_MODULE_STATUS_ERROR) {
-		if (error_type >= MLX5_MODULE_EVENT_ERROR_UNKNOWN)
-			/* Unknown error type */
-			error_type = MLX5_MODULE_EVENT_ERROR_UNKNOWN;
-		priv->pme_stats.error_counters[error_type]++;
-	}
-
-	if (!printk_ratelimit())
-		return;
-
-	if (module_status < MLX5_MODULE_STATUS_ERROR)
-		mlx5_core_info(dev,
-			       "Port module event: module %u, %s\n",
-			       module_num, mlx5_pme_status[module_status - 1]);
-
-	else if (module_status == MLX5_MODULE_STATUS_ERROR)
-		mlx5_core_info(dev,
-			       "Port module event[error]: module %u, %s, %s\n",
-			       module_num, mlx5_pme_status[module_status - 1],
-			       mlx5_pme_error[error_type]);
-}
-
 int mlx5_query_mtpps(struct mlx5_core_dev *mdev, u32 *mtpps, u32 mtpps_size)
 {
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index afba0864f45c..ba64ecf72478 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -514,6 +514,7 @@ struct mlx5_fc_stats {
 	unsigned long sampling_interval; /* jiffies */
 };
 
+struct mlx5_events;
 struct mlx5_mpfs;
 struct mlx5_eswitch;
 struct mlx5_lag;
@@ -540,31 +541,6 @@ struct mlx5_rl_table {
 	struct mlx5_rl_entry   *rl_entry;
 };
 
-enum port_module_event_status_type {
-	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
-	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
-	MLX5_MODULE_STATUS_ERROR     = 0x3,
-	MLX5_MODULE_STATUS_NUM       = 0x3,
-};
-
-enum  port_module_event_error_type {
-	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED,
-	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX_CABLE_MODULE,
-	MLX5_MODULE_EVENT_ERROR_BUS_STUCK,
-	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT,
-	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST,
-	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER,
-	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE,
-	MLX5_MODULE_EVENT_ERROR_BAD_CABLE,
-	MLX5_MODULE_EVENT_ERROR_UNKNOWN,
-	MLX5_MODULE_EVENT_ERROR_NUM,
-};
-
-struct mlx5_port_module_event_stats {
-	u64 status_counters[MLX5_MODULE_STATUS_NUM];
-	u64 error_counters[MLX5_MODULE_EVENT_ERROR_NUM];
-};
-
 struct mlx5_priv {
 	char			name[MLX5_MAX_NAME_LEN];
 	struct mlx5_eq_table	*eq_table;
@@ -614,6 +590,7 @@ struct mlx5_priv {
 
 	struct list_head	waiting_events_list;
 	bool			is_accum_events;
+	struct mlx5_events     *events;
 
 	struct mlx5_flow_steering *steering;
 	struct mlx5_mpfs        *mpfs;
@@ -624,8 +601,6 @@ struct mlx5_priv {
 	struct mlx5_fc_stats		fc_stats;
 	struct mlx5_rl_table            rl_table;
 
-	struct mlx5_port_module_event_stats  pme_stats;
-
 	struct mlx5_bfreg_data		bfregs;
 	struct mlx5_uars_page	       *uar;
 };
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 34aed6032f86..bf4bc01ffb0c 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -107,9 +107,6 @@ enum mlx5e_connector_type {
 
 #define MLX5E_PROT_MASK(link_mode) (1 << link_mode)
 
-#define PORT_MODULE_EVENT_MODULE_STATUS_MASK 0xF
-#define PORT_MODULE_EVENT_ERROR_TYPE_MASK         0xF
-
 int mlx5_set_port_caps(struct mlx5_core_dev *dev, u8 port_num, u32 caps);
 int mlx5_query_port_ptys(struct mlx5_core_dev *dev, u32 *ptys,
 			 int ptys_size, int proto_mask, u8 local_port);
-- 
2.19.1
