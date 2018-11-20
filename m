From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 01/11] net/mlx5: EQ, Introduce atomic notifier chain subscription API
Date: Tue, 20 Nov 2018 14:12:18 -0800
Message-ID: <20181120221228.18365-2-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Use atomic_notifier_chain to fire firmware events at internal mlx5 core
components such as eswitch/fpga/clock/FW tracer/etc.., this is to
avoid explicit calls from low level mlx5_core to upper components and to
simplify the mlx5_core API for future developments.

Simply provide register/unregister notifiers API and call the notifier
chain on firmware async events.

Example: to subscribe to a FW event:
struct mlx5_nb port_event;

MLX5_NB_INIT(&port_event, port_event_handler, PORT_CHANGE);
mlx5_eq_notifier_register(mdev, &port_event);

where:
 - port_event_handler is the notifier block callback.
 - PORT_EVENT is the suffix of MLX5_EVENT_TYPE_PORT_CHANGE.

The above will guarantee that port_event_handler will receive all FW
events of the type MLX5_EVENT_TYPE_PORT_CHANGE.

To receive all FW/HW events one can subscribe to
MLX5_EVENT_TYPE_NOTIFY_ANY.

The next few patches will start moving all mlx5 core components to use
this new API and cleanup mlx5_eq_async_int misx handler from component
explicit calls and specific logic.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 42 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  5 +++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  5 +++
 include/linux/mlx5/device.h                   | 10 ++++-
 include/linux/mlx5/eq.h                       | 16 ++++++-
 5 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 6ba8e401a0c7..34e4b2c246ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eq.h>
@@ -68,8 +69,10 @@ struct mlx5_irq_info {
 struct mlx5_eq_table {
 	struct list_head        comp_eqs_list;
 	struct mlx5_eq          pages_eq;
-	struct mlx5_eq          async_eq;
 	struct mlx5_eq	        cmd_eq;
+	struct mlx5_eq          async_eq;
+
+	struct atomic_notifier_head nh[MLX5_EVENT_TYPE_MAX];
 
 	struct mutex            lock; /* sync async eqs creations */
 	int			num_comp_vectors;
@@ -316,13 +319,17 @@ u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq)
 static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 {
 	struct mlx5_eq *eq = eq_ptr;
-	struct mlx5_core_dev *dev = eq->dev;
+	struct mlx5_eq_table *eqt;
+	struct mlx5_core_dev *dev;
 	struct mlx5_eqe *eqe;
 	int set_ci = 0;
 	u32 cqn = -1;
 	u32 rsn;
 	u8 port;
 
+	dev = eq->dev;
+	eqt = dev->priv.eq_table;
+
 	while ((eqe = next_eqe_sw(eq))) {
 		/*
 		 * Make sure we read EQ entry contents after we've
@@ -437,6 +444,13 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			break;
 		}
 
+		if (likely(eqe->type < MLX5_EVENT_TYPE_MAX))
+			atomic_notifier_call_chain(&eqt->nh[eqe->type], eqe->type, eqe);
+		else
+			mlx5_core_warn_once(dev, "notifier_call_chain is not setup for eqe: %d\n", eqe->type);
+
+		atomic_notifier_call_chain(&eqt->nh[MLX5_EVENT_TYPE_NOTIFY_ANY], eqe->type, eqe);
+
 		++eq->cons_index;
 		++set_ci;
 
@@ -625,7 +639,7 @@ int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table;
-	int err;
+	int i, err;
 
 	eq_table = kvzalloc(sizeof(*eq_table), GFP_KERNEL);
 	if (!eq_table)
@@ -638,6 +652,8 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 		goto kvfree_eq_table;
 
 	mutex_init(&eq_table->lock);
+	for (i = 0; i < MLX5_EVENT_TYPE_MAX; i++)
+		ATOMIC_INIT_NOTIFIER_HEAD(&eq_table->nh[i]);
 
 	return 0;
 
@@ -1202,3 +1218,23 @@ void mlx5_eq_table_destroy(struct mlx5_core_dev *dev)
 	destroy_async_eqs(dev);
 	free_irq_vectors(dev);
 }
+
+int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
+{
+	struct mlx5_eq_table *eqt = dev->priv.eq_table;
+
+	if (nb->event_type >= MLX5_EVENT_TYPE_MAX)
+		return -EINVAL;
+
+	return atomic_notifier_chain_register(&eqt->nh[nb->event_type], &nb->nb);
+}
+
+int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
+{
+	struct mlx5_eq_table *eqt = dev->priv.eq_table;
+
+	if (nb->event_type >= MLX5_EVENT_TYPE_MAX)
+		return -EINVAL;
+
+	return atomic_notifier_chain_unregister(&eqt->nh[nb->event_type], &nb->nb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 6d8c8a57d52b..c0fb6d72b695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -4,6 +4,8 @@
 #ifndef __LIB_MLX5_EQ_H__
 #define __LIB_MLX5_EQ_H__
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/eq.h>
+#include <linux/mlx5/cq.h>
 
 #define MLX5_MAX_IRQ_NAME   (32)
 #define MLX5_EQE_SIZE       (sizeof(struct mlx5_eqe))
@@ -90,4 +92,7 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev);
 #endif
 
+int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
+int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 21727d9eeb84..e06c6e16ffc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -78,6 +78,11 @@ do {									\
 		 __func__, __LINE__, current->pid,			\
 		##__VA_ARGS__)
 
+#define mlx5_core_warn_once(__dev, format, ...)				\
+	dev_warn_once(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,	\
+		      __func__, __LINE__, current->pid,			\
+		      ##__VA_ARGS__)
+
 #define mlx5_core_info(__dev, format, ...)				\
 	dev_info(&(__dev)->pdev->dev, format, ##__VA_ARGS__)
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index e326524bafcc..f7c8bebfe472 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -301,9 +301,15 @@ enum {
 	MLX5_EVENT_QUEUE_TYPE_DCT = 6,
 };
 
+/* mlx5 components can subscribe to any one of these events via
+ * mlx5_eq_notifier_register API.
+ */
 enum mlx5_event {
+	/* Special value to subscribe to any event */
+	MLX5_EVENT_TYPE_NOTIFY_ANY	   = 0x0,
+	/* HW events enum start: comp events are not subscribable */
 	MLX5_EVENT_TYPE_COMP		   = 0x0,
-
+	/* HW Async events enum start: subscribable events */
 	MLX5_EVENT_TYPE_PATH_MIG	   = 0x01,
 	MLX5_EVENT_TYPE_COMM_EST	   = 0x02,
 	MLX5_EVENT_TYPE_SQ_DRAINED	   = 0x03,
@@ -341,6 +347,8 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_FPGA_QP_ERROR      = 0x21,
 
 	MLX5_EVENT_TYPE_DEVICE_TRACER      = 0x26,
+
+	MLX5_EVENT_TYPE_MAX                = MLX5_EVENT_TYPE_DEVICE_TRACER + 1,
 };
 
 enum {
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index 71d82c5a1a02..00045cc4ea11 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -4,8 +4,6 @@
 #ifndef MLX5_CORE_EQ_H
 #define MLX5_CORE_EQ_H
 
-#include <linux/mlx5/driver.h>
-
 enum {
 	MLX5_EQ_PAGEREQ_IDX        = 0,
 	MLX5_EQ_CMD_IDX            = 1,
@@ -22,6 +20,7 @@ enum {
 #define MLX5_NUM_SPARE_EQE (0x80)
 
 struct mlx5_eq;
+struct mlx5_core_dev;
 
 struct mlx5_eq_param {
 	u8             index;
@@ -57,4 +56,17 @@ static inline u32 mlx5_eq_update_cc(struct mlx5_eq *eq, u32 cc)
 	return cc;
 }
 
+struct mlx5_nb {
+	struct notifier_block nb;
+	u8 event_type;
+};
+
+#define mlx5_nb_cof(ptr, type, member) \
+	(container_of(container_of(ptr, struct mlx5_nb, nb), type, member))
+
+#define MLX5_NB_INIT(name, handler, event) do {              \
+	(name)->nb.notifier_call = handler;                  \
+	(name)->event_type = MLX5_EVENT_TYPE_##event;        \
+} while (0)
+
 #endif /* MLX5_CORE_EQ_H */
-- 
2.19.1
