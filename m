From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 08/11] net/mlx5: Resource tables, Use async events chain
Date: Tue, 20 Nov 2018 14:12:25 -0800
Message-ID: <20181120221228.18365-9-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to QP/SRQ resources events handlers on several FW
events and let resources logic register resources events notifiers via the
new API.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 29 --------
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  | 68 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 55 +++++++++++++--
 include/linux/mlx5/driver.h                   |  6 +-
 4 files changed, 108 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index b28869aa1a4e..0cf448575ebd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -324,7 +324,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 	struct mlx5_eqe *eqe;
 	int set_ci = 0;
 	u32 cqn = -1;
-	u32 rsn;
 	u8 port;
 
 	dev = eq->dev;
@@ -340,34 +339,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 		mlx5_core_dbg(eq->dev, "eqn %d, eqe type %s\n",
 			      eq->eqn, eqe_type_str(eqe->type));
 		switch (eqe->type) {
-		case MLX5_EVENT_TYPE_DCT_DRAINED:
-			rsn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
-			rsn |= (MLX5_RES_DCT << MLX5_USER_INDEX_LEN);
-			mlx5_rsc_event(dev, rsn, eqe->type);
-			break;
-		case MLX5_EVENT_TYPE_PATH_MIG:
-		case MLX5_EVENT_TYPE_COMM_EST:
-		case MLX5_EVENT_TYPE_SQ_DRAINED:
-		case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
-		case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
-		case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
-		case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
-		case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
-			rsn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
-			rsn |= (eqe->data.qp_srq.type << MLX5_USER_INDEX_LEN);
-			mlx5_core_dbg(dev, "event %s(%d) arrived on resource 0x%x\n",
-				      eqe_type_str(eqe->type), eqe->type, rsn);
-			mlx5_rsc_event(dev, rsn, eqe->type);
-			break;
-
-		case MLX5_EVENT_TYPE_SRQ_RQ_LIMIT:
-		case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
-			rsn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
-			mlx5_core_dbg(dev, "SRQ event %s(%d): srqn 0x%x\n",
-				      eqe_type_str(eqe->type), eqe->type, rsn);
-			mlx5_srq_event(dev, rsn, eqe->type);
-			break;
-
 		case MLX5_EVENT_TYPE_PORT_CHANGE:
 			port = (eqe->data.port.port >> 4) & 0xf;
 			switch (eqe->sub_type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index cba4a435043a..28726c63101f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -38,11 +38,11 @@
 #include <linux/mlx5/transobj.h>
 
 #include "mlx5_core.h"
+#include "lib/eq.h"
 
-static struct mlx5_core_rsc_common *mlx5_get_rsc(struct mlx5_core_dev *dev,
-						 u32 rsn)
+static struct mlx5_core_rsc_common *
+mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
 	struct mlx5_core_rsc_common *common;
 
 	spin_lock(&table->lock);
@@ -53,11 +53,6 @@ static struct mlx5_core_rsc_common *mlx5_get_rsc(struct mlx5_core_dev *dev,
 
 	spin_unlock(&table->lock);
 
-	if (!common) {
-		mlx5_core_warn(dev, "Async event for bogus resource 0x%x\n",
-			       rsn);
-		return NULL;
-	}
 	return common;
 }
 
@@ -120,14 +115,52 @@ static bool is_event_type_allowed(int rsc_type, int event_type)
 	}
 }
 
-void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
+static int rsc_event_notifier(struct notifier_block *nb,
+			      unsigned long type, void *data)
 {
-	struct mlx5_core_rsc_common *common = mlx5_get_rsc(dev, rsn);
+	struct mlx5_core_rsc_common *common;
+	struct mlx5_qp_table *table;
+	struct mlx5_core_dev *dev;
 	struct mlx5_core_dct *dct;
+	u8 event_type = (u8)type;
 	struct mlx5_core_qp *qp;
+	struct mlx5_priv *priv;
+	struct mlx5_eqe *eqe;
+	u32 rsn;
+
+	switch (event_type) {
+	case MLX5_EVENT_TYPE_DCT_DRAINED:
+		eqe = data;
+		rsn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
+		rsn |= (MLX5_RES_DCT << MLX5_USER_INDEX_LEN);
+		break;
+	case MLX5_EVENT_TYPE_PATH_MIG:
+	case MLX5_EVENT_TYPE_COMM_EST:
+	case MLX5_EVENT_TYPE_SQ_DRAINED:
+	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+		eqe = data;
+		rsn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
+		rsn |= (eqe->data.qp_srq.type << MLX5_USER_INDEX_LEN);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	table = mlx5_nb_cof(nb, struct mlx5_qp_table, nb);
+	priv  = container_of(table, struct mlx5_priv, qp_table);
+	dev   = container_of(priv, struct mlx5_core_dev, priv);
 
-	if (!common)
-		return;
+	mlx5_core_dbg(dev, "event (%d) arrived on resource 0x%x\n", eqe->type, rsn);
+
+	common = mlx5_get_rsc(table, rsn);
+	if (!common) {
+		mlx5_core_warn(dev, "Async event for bogus resource 0x%x\n", rsn);
+		return NOTIFY_OK;
+	}
 
 	if (!is_event_type_allowed((rsn >> MLX5_USER_INDEX_LEN), event_type)) {
 		mlx5_core_warn(dev, "event 0x%.2x is not allowed on resource 0x%.8x\n",
@@ -152,6 +185,8 @@ void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type)
 	}
 out:
 	mlx5_core_put_rsc(common);
+
+	return NOTIFY_OK;
 }
 
 static int create_resource_common(struct mlx5_core_dev *dev,
@@ -487,10 +522,16 @@ void mlx5_init_qp_table(struct mlx5_core_dev *dev)
 	spin_lock_init(&table->lock);
 	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
 	mlx5_qp_debugfs_init(dev);
+
+	MLX5_NB_INIT(&table->nb, rsc_event_notifier, NOTIFY_ANY);
+	mlx5_eq_notifier_register(dev, &table->nb);
 }
 
 void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev)
 {
+	struct mlx5_qp_table *table = &dev->priv.qp_table;
+
+	mlx5_eq_notifier_unregister(dev, &table->nb);
 	mlx5_qp_debugfs_cleanup(dev);
 }
 
@@ -676,8 +717,9 @@ struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
 						enum mlx5_res_type res_type)
 {
 	u32 rsn = res_num | (res_type << MLX5_USER_INDEX_LEN);
+	struct mlx5_qp_table *table = &dev->priv.qp_table;
 
-	return mlx5_get_rsc(dev, rsn);
+	return mlx5_get_rsc(table, rsn);
 }
 EXPORT_SYMBOL_GPL(mlx5_core_res_hold);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 6a6fc9be01e6..0563866c13f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -36,13 +36,25 @@
 #include <linux/mlx5/cmd.h>
 #include <linux/mlx5/srq.h>
 #include <rdma/ib_verbs.h>
-#include "mlx5_core.h"
 #include <linux/mlx5/transobj.h>
+#include "mlx5_core.h"
+#include "lib/eq.h"
 
-void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type)
+static int srq_event_notifier(struct mlx5_srq_table *table,
+			      unsigned long type, void *data)
 {
-	struct mlx5_srq_table *table = &dev->priv.srq_table;
+	struct mlx5_core_dev *dev;
 	struct mlx5_core_srq *srq;
+	struct mlx5_priv *priv;
+	struct mlx5_eqe *eqe;
+	u32 srqn;
+
+	priv  = container_of(table, struct mlx5_priv, srq_table);
+	dev   = container_of(priv, struct mlx5_core_dev, priv);
+
+	eqe = data;
+	srqn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
+	mlx5_core_dbg(dev, "SRQ event (%d): srqn 0x%x\n", eqe->type, srqn);
 
 	spin_lock(&table->lock);
 
@@ -54,13 +66,35 @@ void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type)
 
 	if (!srq) {
 		mlx5_core_warn(dev, "Async event for bogus SRQ 0x%08x\n", srqn);
-		return;
+		return NOTIFY_OK;
 	}
 
-	srq->event(srq, event_type);
+	srq->event(srq, eqe->type);
 
 	if (atomic_dec_and_test(&srq->refcount))
 		complete(&srq->free);
+
+	return NOTIFY_OK;
+}
+
+static int catas_err_notifier(struct notifier_block *nb,
+			      unsigned long type, void *data)
+{
+	struct mlx5_srq_table *table;
+
+	table = mlx5_nb_cof(nb, struct mlx5_srq_table, catas_err_nb);
+	/* type == MLX5_EVENT_TYPE_SRQ_CATAS_ERROR */
+	return srq_event_notifier(table, type, data);
+}
+
+static int rq_limit_notifier(struct notifier_block *nb,
+			     unsigned long type, void *data)
+{
+	struct mlx5_srq_table *table;
+
+	table = mlx5_nb_cof(nb, struct mlx5_srq_table, rq_limit_nb);
+	/* type == MLX5_EVENT_TYPE_SRQ_RQ_LIMIT */
+	return srq_event_notifier(table, type, data);
 }
 
 static int get_pas_size(struct mlx5_srq_attr *in)
@@ -708,9 +742,18 @@ void mlx5_init_srq_table(struct mlx5_core_dev *dev)
 	memset(table, 0, sizeof(*table));
 	spin_lock_init(&table->lock);
 	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+
+	MLX5_NB_INIT(&table->catas_err_nb, catas_err_notifier, SRQ_CATAS_ERROR);
+	mlx5_eq_notifier_register(dev, &table->catas_err_nb);
+
+	MLX5_NB_INIT(&table->rq_limit_nb, rq_limit_notifier, SRQ_RQ_LIMIT);
+	mlx5_eq_notifier_register(dev, &table->rq_limit_nb);
 }
 
 void mlx5_cleanup_srq_table(struct mlx5_core_dev *dev)
 {
-	/* nothing */
+	struct mlx5_srq_table *table = &dev->priv.srq_table;
+
+	mlx5_eq_notifier_unregister(dev, &table->rq_limit_nb);
+	mlx5_eq_notifier_unregister(dev, &table->catas_err_nb);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a8d638134fc8..afba0864f45c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -464,6 +464,8 @@ struct mlx5_core_health {
 };
 
 struct mlx5_qp_table {
+	struct mlx5_nb          nb;
+
 	/* protect radix tree
 	 */
 	spinlock_t		lock;
@@ -471,6 +473,8 @@ struct mlx5_qp_table {
 };
 
 struct mlx5_srq_table {
+	struct mlx5_nb          catas_err_nb;
+	struct mlx5_nb          rq_limit_nb;
 	/* protect radix tree
 	 */
 	spinlock_t		lock;
@@ -978,8 +982,6 @@ void mlx5_unregister_debugfs(void);
 
 void mlx5_fill_page_array(struct mlx5_frag_buf *buf, __be64 *pas);
 void mlx5_fill_page_frag_array(struct mlx5_frag_buf *frag_buf, __be64 *pas);
-void mlx5_rsc_event(struct mlx5_core_dev *dev, u32 rsn, int event_type);
-void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type);
 struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn);
 int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 		    unsigned int *irqn);
-- 
2.19.1
