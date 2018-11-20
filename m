From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/11] net/mlx5: CQ ERR, Use async events chain
Date: Tue, 20 Nov 2018 14:12:26 -0800
Message-ID: <20181120221228.18365-10-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_eq_cq_event on MLX5_EVENT_TYPE_CQ_ERROR
and register a specific CQ ERROR handler via the new API.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 66 +++++++++++++-------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 0cf448575ebd..4e3febbf639d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -74,6 +74,9 @@ struct mlx5_eq_table {
 
 	struct atomic_notifier_head nh[MLX5_EVENT_TYPE_MAX];
 
+	/* Since CQ DB is stored in async_eq */
+	struct mlx5_nb          cq_err_nb;
+
 	struct mutex            lock; /* sync async eqs creations */
 	int			num_comp_vectors;
 	struct mlx5_irq_info	*irq_info;
@@ -235,20 +238,6 @@ static struct mlx5_core_cq *mlx5_eq_cq_get(struct mlx5_eq *eq, u32 cqn)
 	return cq;
 }
 
-static void mlx5_eq_cq_event(struct mlx5_eq *eq, u32 cqn, int event_type)
-{
-	struct mlx5_core_cq *cq = mlx5_eq_cq_get(eq, cqn);
-
-	if (unlikely(!cq)) {
-		mlx5_core_warn(eq->dev, "Async event for bogus CQ 0x%x\n", cqn);
-		return;
-	}
-
-	cq->event(cq, event_type);
-
-	mlx5_cq_put(cq);
-}
-
 static irqreturn_t mlx5_eq_comp_int(int irq, void *eq_ptr)
 {
 	struct mlx5_eq_comp *eq_comp = eq_ptr;
@@ -323,7 +312,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 	struct mlx5_core_dev *dev;
 	struct mlx5_eqe *eqe;
 	int set_ci = 0;
-	u32 cqn = -1;
 	u8 port;
 
 	dev = eq->dev;
@@ -358,12 +346,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 					       port, eqe->sub_type);
 			}
 			break;
-		case MLX5_EVENT_TYPE_CQ_ERROR:
-			cqn = be32_to_cpu(eqe->data.cq_err.cqn) & 0xffffff;
-			mlx5_core_warn(dev, "CQ error on CQN 0x%x, syndrome 0x%x\n",
-				       cqn, eqe->data.cq_err.syndrome);
-			mlx5_eq_cq_event(eq, cqn, eqe->type);
-			break;
 
 		case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
 			mlx5_port_module_event(dev, eqe);
@@ -639,6 +621,38 @@ static int destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 	return err;
 }
 
+static int cq_err_event_notifier(struct notifier_block *nb,
+				 unsigned long type, void *data)
+{
+	struct mlx5_eq_table *eqt;
+	struct mlx5_core_cq *cq;
+	struct mlx5_eqe *eqe;
+	struct mlx5_eq *eq;
+	u32 cqn;
+
+	/* type == MLX5_EVENT_TYPE_CQ_ERROR */
+
+	eqt = mlx5_nb_cof(nb, struct mlx5_eq_table, cq_err_nb);
+	eq  = &eqt->async_eq;
+	eqe = data;
+
+	cqn = be32_to_cpu(eqe->data.cq_err.cqn) & 0xffffff;
+	mlx5_core_warn(eq->dev, "CQ error on CQN 0x%x, syndrome 0x%x\n",
+		       cqn, eqe->data.cq_err.syndrome);
+
+	cq = mlx5_eq_cq_get(eq, cqn);
+	if (unlikely(!cq)) {
+		mlx5_core_warn(eq->dev, "Async event for bogus CQ 0x%x\n", cqn);
+		return NOTIFY_OK;
+	}
+
+	cq->event(cq, type);
+
+	mlx5_cq_put(cq);
+
+	return NOTIFY_OK;
+}
+
 static u64 gather_async_events_mask(struct mlx5_core_dev *dev)
 {
 	u64 async_event_mask = MLX5_ASYNC_EVENT_MASK;
@@ -679,6 +693,9 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	struct mlx5_eq_param param = {};
 	int err;
 
+	MLX5_NB_INIT(&table->cq_err_nb, cq_err_event_notifier, CQ_ERROR);
+	mlx5_eq_notifier_register(dev, &table->cq_err_nb);
+
 	param = (struct mlx5_eq_param) {
 		.index = MLX5_EQ_CMD_IDX,
 		.mask = 1ull << MLX5_EVENT_TYPE_CMD,
@@ -689,7 +706,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	err = create_async_eq(dev, "mlx5_cmd_eq", &table->cmd_eq, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create cmd EQ %d\n", err);
-		return err;
+		goto err0;
 	}
 
 	mlx5_cmd_use_events(dev);
@@ -728,6 +745,8 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 err1:
 	mlx5_cmd_use_polling(dev);
 	destroy_async_eq(dev, &table->cmd_eq);
+err0:
+	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 	return err;
 }
 
@@ -745,12 +764,15 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 	if (err)
 		mlx5_core_err(dev, "failed to destroy async eq, err(%d)\n",
 			      err);
+
 	mlx5_cmd_use_polling(dev);
 
 	err = destroy_async_eq(dev, &table->cmd_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy command eq, err(%d)\n",
 			      err);
+
+	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 }
 
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev)
-- 
2.19.1
