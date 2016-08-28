From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 7/7] IB/mlx5: Add sniffer support to steering
Date: Sun, 28 Aug 2016 14:16:34 +0300
Message-ID: <1472382994-32091-8-git-send-email-leon@kernel.org>
References: <1472382994-32091-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to create sniffer rule. This rule receive all
incoming and outgoing packets from the port.
A user could create such rule by using IB_FLOW_ATTR_SNIFFER type.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 74 +++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fc2ff93..0510dc25 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1618,6 +1618,7 @@ static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 
 	list_for_each_entry_safe(iter, tmp, &handler->list, list) {
 		mlx5_del_flow_rule(iter->rule);
+		put_flow_table(dev, iter->prio, true);
 		list_del(&iter->list);
 		kfree(iter);
 	}
@@ -1639,10 +1640,16 @@ static int ib_prio_to_core_prio(unsigned int priority, bool dont_trap)
 	return priority;
 }
 
+enum flow_table_type {
+	MLX5_IB_FT_RX,
+	MLX5_IB_FT_TX
+};
+
 #define MLX5_FS_MAX_TYPES	 10
 #define MLX5_FS_MAX_ENTRIES	 32000UL
 static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
-						struct ib_flow_attr *flow_attr)
+						struct ib_flow_attr *flow_attr,
+						enum flow_table_type ft_type)
 {
 	bool dont_trap = flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP;
 	struct mlx5_flow_namespace *ns = NULL;
@@ -1673,6 +1680,19 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 					 &num_entries,
 					 &num_groups);
 		prio = &dev->flow_db.prios[MLX5_IB_FLOW_LEFTOVERS_PRIO];
+	} else if (flow_attr->type == IB_FLOW_ATTR_SNIFFER) {
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					allow_sniffer_and_nic_rx_shared_tir))
+			return ERR_PTR(-ENOTSUPP);
+
+		ns = mlx5_get_flow_namespace(dev->mdev, ft_type == MLX5_IB_FT_RX ?
+					     MLX5_FLOW_NAMESPACE_SNIFFER_RX :
+					     MLX5_FLOW_NAMESPACE_SNIFFER_TX);
+
+		prio = &dev->flow_db.sniffer[ft_type];
+		priority = 0;
+		num_entries = 1;
+		num_groups = 1;
 	}
 
 	if (!ns)
@@ -1844,6 +1864,43 @@ static struct mlx5_ib_flow_handler *create_leftovers_rule(struct mlx5_ib_dev *de
 	return handler;
 }
 
+static struct mlx5_ib_flow_handler *create_sniffer_rule(struct mlx5_ib_dev *dev,
+							struct mlx5_ib_flow_prio *ft_rx,
+							struct mlx5_ib_flow_prio *ft_tx,
+							struct mlx5_flow_destination *dst)
+{
+	struct mlx5_ib_flow_handler *handler_rx;
+	struct mlx5_ib_flow_handler *handler_tx;
+	int err;
+	static const struct ib_flow_attr flow_attr  = {
+		.num_of_specs = 0,
+		.size = sizeof(flow_attr)
+	};
+
+	handler_rx = create_flow_rule(dev, ft_rx, &flow_attr, dst);
+	if (IS_ERR(handler_rx)) {
+		err = PTR_ERR(handler_rx);
+		goto err;
+	}
+
+	handler_tx = create_flow_rule(dev, ft_tx, &flow_attr, dst);
+	if (IS_ERR(handler_tx)) {
+		err = PTR_ERR(handler_tx);
+		goto err_tx;
+	}
+
+	list_add(&handler_tx->list, &handler_rx->list);
+
+	return handler_rx;
+
+err_tx:
+	mlx5_del_flow_rule(handler_rx->rule);
+	ft_rx->refcount--;
+	kfree(handler_rx);
+err:
+	return ERR_PTR(err);
+}
+
 static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 					   struct ib_flow_attr *flow_attr,
 					   int domain)
@@ -1851,6 +1908,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
 	struct mlx5_ib_flow_handler *handler = NULL;
 	struct mlx5_flow_destination *dst = NULL;
+	struct mlx5_ib_flow_prio *ft_prio_tx = NULL;
 	struct mlx5_ib_flow_prio *ft_prio;
 	int err;
 
@@ -1868,11 +1926,19 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 
 	mutex_lock(&dev->flow_db.lock);
 
-	ft_prio = get_flow_table(dev, flow_attr);
+	ft_prio = get_flow_table(dev, flow_attr, MLX5_IB_FT_RX);
 	if (IS_ERR(ft_prio)) {
 		err = PTR_ERR(ft_prio);
 		goto unlock;
 	}
+	if (flow_attr->type == IB_FLOW_ATTR_SNIFFER) {
+		ft_prio_tx = get_flow_table(dev, flow_attr, MLX5_IB_FT_TX);
+		if (IS_ERR(ft_prio_tx)) {
+			err = PTR_ERR(ft_prio_tx);
+			ft_prio_tx = NULL;
+			goto destroy_ft;
+		}
+	}
 
 	dst->type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 	dst->tir_num = to_mqp(qp)->raw_packet_qp.rq.tirn;
@@ -1889,6 +1955,8 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 		   flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT) {
 		handler = create_leftovers_rule(dev, ft_prio, flow_attr,
 						dst);
+	} else if (flow_attr->type == IB_FLOW_ATTR_SNIFFER) {
+		handler = create_sniffer_rule(dev, ft_prio, ft_prio_tx, dst);
 	} else {
 		err = -EINVAL;
 		goto destroy_ft;
@@ -1907,6 +1975,8 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 
 destroy_ft:
 	put_flow_table(dev, ft_prio, false);
+	if (ft_prio_tx)
+		put_flow_table(dev, ft_prio_tx, false);
 unlock:
 	mutex_unlock(&dev->flow_db.lock);
 	kfree(dst);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a24cc20..e1b1205 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -142,6 +142,7 @@ struct mlx5_ib_pd {
 #define MLX5_IB_FLOW_LEFTOVERS_PRIO	(MLX5_IB_FLOW_MCAST_PRIO + 1)
 
 #define MLX5_IB_NUM_FLOW_FT		(MLX5_IB_FLOW_LEFTOVERS_PRIO + 1)
+#define MLX5_IB_NUM_SNIFFER_FTS		2
 struct mlx5_ib_flow_prio {
 	struct mlx5_flow_table		*flow_table;
 	unsigned int			refcount;
@@ -156,6 +157,7 @@ struct mlx5_ib_flow_handler {
 
 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
+	struct mlx5_ib_flow_prio	sniffer[MLX5_IB_NUM_SNIFFER_FTS];
 	/* Protect flow steering bypass flow tables
 	 * when add/del flow rules.
 	 * only single add/removal of flow steering rule could be done
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
