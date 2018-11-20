From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 02/11] net/mlx5: FWTrace, Use async events chain
Date: Tue, 20 Nov 2018 14:12:19 -0800
Message-ID: <20181120221228.18365-3-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_fw_tracer_event on
MLX5_EVENT_TYPE_DEVICE_TRACER and let fw tracer to register
its own handler when its ready.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 27 ++++++++++---------
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  4 ---
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index d4ec93bde4de..6999f4486e9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 #define CREATE_TRACE_POINTS
+#include "lib/eq.h"
 #include "fw_tracer.h"
 #include "fw_tracer_tracepoint.h"
 
@@ -846,9 +847,9 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 	return ERR_PTR(err);
 }
 
-/* Create HW resources + start tracer
- * must be called before Async EQ is created
- */
+static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data);
+
+/* Create HW resources + start tracer */
 int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 {
 	struct mlx5_core_dev *dev;
@@ -874,6 +875,9 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 		goto err_dealloc_pd;
 	}
 
+	MLX5_NB_INIT(&tracer->nb, fw_tracer_event, DEVICE_TRACER);
+	mlx5_eq_notifier_register(dev, &tracer->nb);
+
 	mlx5_fw_tracer_start(tracer);
 
 	return 0;
@@ -883,9 +887,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	return err;
 }
 
-/* Stop tracer + Cleanup HW resources
- * must be called after Async EQ is destroyed
- */
+/* Stop tracer + Cleanup HW resources */
 void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 {
 	if (IS_ERR_OR_NULL(tracer))
@@ -893,7 +895,7 @@ void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 
 	mlx5_core_dbg(tracer->dev, "FWTracer: Cleanup, is owner ? (%d)\n",
 		      tracer->owner);
-
+	mlx5_eq_notifier_unregister(tracer->dev, &tracer->nb);
 	cancel_work_sync(&tracer->ownership_change_work);
 	cancel_work_sync(&tracer->handle_traces_work);
 
@@ -922,12 +924,11 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	kfree(tracer);
 }
 
-void mlx5_fw_tracer_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
+static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data)
 {
-	struct mlx5_fw_tracer *tracer = dev->tracer;
-
-	if (!tracer)
-		return;
+	struct mlx5_fw_tracer *tracer = mlx5_nb_cof(nb, struct mlx5_fw_tracer, nb);
+	struct mlx5_core_dev *dev = tracer->dev;
+	struct mlx5_eqe *eqe = data;
 
 	switch (eqe->sub_type) {
 	case MLX5_TRACER_SUBTYPE_OWNERSHIP_CHANGE:
@@ -942,6 +943,8 @@ void mlx5_fw_tracer_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)
 		mlx5_core_dbg(dev, "FWTracer: Event with unrecognized subtype: sub_type %d\n",
 			      eqe->sub_type);
 	}
+
+	return NOTIFY_OK;
 }
 
 EXPORT_TRACEPOINT_SYMBOL(mlx5_fw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 0347f2dd5cee..a8b8747f2b61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -55,6 +55,7 @@
 
 struct mlx5_fw_tracer {
 	struct mlx5_core_dev *dev;
+	struct mlx5_nb        nb;
 	bool owner;
 	u8   trc_ver;
 	struct workqueue_struct *work_queue;
@@ -170,6 +171,5 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev);
 int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer);
 void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer);
 void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer);
-void mlx5_fw_tracer_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 34e4b2c246ff..c7c436b0ed2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -434,10 +434,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			general_event_handler(dev, eqe);
 			break;
 
-		case MLX5_EVENT_TYPE_DEVICE_TRACER:
-			mlx5_fw_tracer_event(dev, eqe);
-			break;
-
 		default:
 			mlx5_core_warn(dev, "Unhandled event 0x%x on EQ 0x%x\n",
 				       eqe->type, eq->eqn);
-- 
2.19.1
