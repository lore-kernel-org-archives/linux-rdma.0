From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 01/10] net/mlx5: Rework handling of port module events
Date: Sun,  9 Dec 2018 19:04:33 -0800
Message-ID: <20181210030442.7543-2-saeedm@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Mikhael Goikhman <migo@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mikhael Goikhman <migo@mellanox.com>

Add explicit HW defined error values. For simplicity, keep counters for all
statuses starting from 0, although currently status=0 is not used.

Additionally, when HW signals an unexpected cable status, it is reported
now rather than ignored. And status counter is now updated on errors.

Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  | 83 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    | 19 ++---
 3 files changed, 65 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 748d23806391..881c54c12e19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1087,13 +1087,13 @@ static void mlx5e_grp_per_prio_update_stats(struct mlx5e_priv *priv)
 }
 
 static const struct counter_desc mlx5e_pme_status_desc[] = {
-	{ "module_unplug", 8 },
+	{ "module_unplug",       sizeof(u64) * MLX5_MODULE_STATUS_UNPLUGGED },
 };
 
 static const struct counter_desc mlx5e_pme_error_desc[] = {
-	{ "module_bus_stuck", 16 },       /* bus stuck (I2C or data shorted) */
-	{ "module_high_temp", 48 },       /* high temperature */
-	{ "module_bad_shorted", 56 },    /* bad or shorted cable/module */
+	{ "module_bus_stuck",    sizeof(u64) * MLX5_MODULE_EVENT_ERROR_BUS_STUCK },
+	{ "module_high_temp",    sizeof(u64) * MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE },
+	{ "module_bad_shorted",  sizeof(u64) * MLX5_MODULE_EVENT_ERROR_BAD_CABLE },
 };
 
 #define NUM_PME_STATUS_STATS		ARRAY_SIZE(mlx5e_pme_status_desc)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index e92df7020a26..587d93ec905f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -157,23 +157,43 @@ static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
 }
 
 /* MLX5_EVENT_TYPE_PORT_MODULE_EVENT */
-static const char *mlx5_pme_status[MLX5_MODULE_STATUS_NUM] = {
-	"Cable plugged",   /* MLX5_MODULE_STATUS_PLUGGED    = 0x1 */
-	"Cable unplugged", /* MLX5_MODULE_STATUS_UNPLUGGED  = 0x2 */
-	"Cable error",     /* MLX5_MODULE_STATUS_ERROR      = 0x3 */
-};
+static const char *mlx5_pme_status_to_string(enum port_module_event_status_type status)
+{
+	switch (status) {
+	case MLX5_MODULE_STATUS_PLUGGED:
+		return "Cable plugged";
+	case MLX5_MODULE_STATUS_UNPLUGGED:
+		return "Cable unplugged";
+	case MLX5_MODULE_STATUS_ERROR:
+		return "Cable error";
+	default:
+		return "Unknown status";
+	}
+}
 
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
+static const char *mlx5_pme_error_to_string(enum port_module_event_error_type error)
+{
+	switch (error) {
+	case MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED:
+		return "Power budget exceeded";
+	case MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX:
+		return "Long Range for non MLNX cable";
+	case MLX5_MODULE_EVENT_ERROR_BUS_STUCK:
+		return "Bus stuck (I2C or data shorted)";
+	case MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT:
+		return "No EEPROM/retry timeout";
+	case MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST:
+		return "Enforce part number list";
+	case MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER:
+		return "Unknown identifier";
+	case MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE:
+		return "High Temperature";
+	case MLX5_MODULE_EVENT_ERROR_BAD_CABLE:
+		return "Bad or shorted cable/module";
+	default:
+		return "Unknown error";
+	}
+}
 
 /* type == MLX5_EVENT_TYPE_PORT_MODULE_EVENT */
 static int port_module(struct notifier_block *nb, unsigned long type, void *data)
@@ -185,6 +205,7 @@ static int port_module(struct notifier_block *nb, unsigned long type, void *data
 	enum port_module_event_status_type module_status;
 	enum port_module_event_error_type error_type;
 	struct mlx5_eqe_port_module *module_event_eqe;
+	const char *status_str, *error_str;
 	u8 module_num;
 
 	module_event_eqe = &eqe->data.port_module;
@@ -193,28 +214,28 @@ static int port_module(struct notifier_block *nb, unsigned long type, void *data
 			PORT_MODULE_EVENT_MODULE_STATUS_MASK;
 	error_type = module_event_eqe->error_type &
 		     PORT_MODULE_EVENT_ERROR_TYPE_MASK;
-	if (module_status < MLX5_MODULE_STATUS_ERROR) {
-		events->pme_stats.status_counters[module_status - 1]++;
-	} else if (module_status == MLX5_MODULE_STATUS_ERROR) {
-		if (error_type >= MLX5_MODULE_EVENT_ERROR_UNKNOWN)
-			/* Unknown error type */
-			error_type = MLX5_MODULE_EVENT_ERROR_UNKNOWN;
-		events->pme_stats.error_counters[error_type]++;
+
+	if (module_status < MLX5_MODULE_STATUS_NUM)
+		events->pme_stats.status_counters[module_status]++;
+	status_str = mlx5_pme_status_to_string(module_status);
+
+	if (module_status == MLX5_MODULE_STATUS_ERROR) {
+		if (error_type < MLX5_MODULE_EVENT_ERROR_NUM)
+			events->pme_stats.error_counters[error_type]++;
+		error_str = mlx5_pme_error_to_string(error_type);
 	}
 
 	if (!printk_ratelimit())
 		return NOTIFY_OK;
 
-	if (module_status < MLX5_MODULE_STATUS_ERROR)
+	if (module_status == MLX5_MODULE_STATUS_ERROR)
+		mlx5_core_err(events->dev,
+			      "Port module event[error]: module %u, %s, %s\n",
+			      module_num, status_str, error_str);
+	else
 		mlx5_core_info(events->dev,
 			       "Port module event: module %u, %s\n",
-			       module_num, mlx5_pme_status[module_status - 1]);
-
-	else if (module_status == MLX5_MODULE_STATUS_ERROR)
-		mlx5_core_info(events->dev,
-			       "Port module event[error]: module %u, %s, %s\n",
-			       module_num, mlx5_pme_status[module_status - 1],
-			       mlx5_pme_error[error_type]);
+			       module_num, status_str);
 
 	return NOTIFY_OK;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 4d78a459676e..af19fa61e9ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -51,19 +51,18 @@ enum port_module_event_status_type {
 	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
 	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
 	MLX5_MODULE_STATUS_ERROR     = 0x3,
-	MLX5_MODULE_STATUS_NUM       = 0x3,
+	MLX5_MODULE_STATUS_NUM,
 };
 
 enum  port_module_event_error_type {
-	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED,
-	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX_CABLE_MODULE,
-	MLX5_MODULE_EVENT_ERROR_BUS_STUCK,
-	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT,
-	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST,
-	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER,
-	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE,
-	MLX5_MODULE_EVENT_ERROR_BAD_CABLE,
-	MLX5_MODULE_EVENT_ERROR_UNKNOWN,
+	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED    = 0x0,
+	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX  = 0x1,
+	MLX5_MODULE_EVENT_ERROR_BUS_STUCK                = 0x2,
+	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT  = 0x3,
+	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST = 0x4,
+	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER       = 0x5,
+	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE         = 0x6,
+	MLX5_MODULE_EVENT_ERROR_BAD_CABLE                = 0x7,
 	MLX5_MODULE_EVENT_ERROR_NUM,
 };
 
-- 
2.19.2
