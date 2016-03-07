From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx5: Add support for don't trap rules
Date: Mon,  7 Mar 2016 18:51:47 +0200
Message-ID: <1457369507-30999-4-git-send-email-matanb@mellanox.com>
References: <1457369507-30999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457369507-30999-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Each bypass flow steering priority will be split into two priorities:
1. Priority for don't trap rules.
2. Priority for normal rules.

When user creates a flow using IB_FLOW_ATTR_FLAGS_DONT_TRAP flag, the
driver creates two flow rules, one used for receiving the traffic and
the other one for forwarding the packet to continue matching in lower
or equal priorities.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 54 ++++++++++++++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 include/linux/mlx5/device.h          |  7 ++++-
 3 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7e89a54..5afbb69 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1382,11 +1382,20 @@ static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 	return 0;
 }
 
+static int ib_prio_to_core_prio(unsigned int priority, bool dont_trap)
+{
+	priority *= 2;
+	if (!dont_trap)
+		priority++;
+	return priority;
+}
+
 #define MLX5_FS_MAX_TYPES	 10
 #define MLX5_FS_MAX_ENTRIES	 32000UL
 static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 						struct ib_flow_attr *flow_attr)
 {
+	bool dont_trap = flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP;
 	struct mlx5_flow_namespace *ns = NULL;
 	struct mlx5_ib_flow_prio *prio;
 	struct mlx5_flow_table *ft;
@@ -1396,10 +1405,12 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	int err = 0;
 
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
-		if (flow_is_multicast_only(flow_attr))
+		if (flow_is_multicast_only(flow_attr) &&
+		    !dont_trap)
 			priority = MLX5_IB_FLOW_MCAST_PRIO;
 		else
-			priority = flow_attr->priority;
+			priority = ib_prio_to_core_prio(flow_attr->priority,
+							dont_trap);
 		ns = mlx5_get_flow_namespace(dev->mdev,
 					     MLX5_FLOW_NAMESPACE_BYPASS);
 		num_entries = MLX5_FS_MAX_ENTRIES;
@@ -1447,6 +1458,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	unsigned int spec_index;
 	u32 *match_c;
 	u32 *match_v;
+	u32 action;
 	int err = 0;
 
 	if (!is_valid_attr(flow_attr))
@@ -1472,9 +1484,11 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 
 	/* Outer header support only */
 	match_criteria_enable = (!outer_header_zero(match_c)) << 0;
+	action = dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
+		MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
 	handler->rule = mlx5_add_flow_rule(ft, match_criteria_enable,
 					   match_c, match_v,
-					   MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+					   action,
 					   MLX5_FS_DEFAULT_FLOW_TAG,
 					   dst);
 
@@ -1494,6 +1508,29 @@ free:
 	return err ? ERR_PTR(err) : handler;
 }
 
+static struct mlx5_ib_flow_handler *create_dont_trap_rule(struct mlx5_ib_dev *dev,
+							  struct mlx5_ib_flow_prio *ft_prio,
+							  struct ib_flow_attr *flow_attr,
+							  struct mlx5_flow_destination *dst)
+{
+	struct mlx5_ib_flow_handler *handler_dst = NULL;
+	struct mlx5_ib_flow_handler *handler = NULL;
+
+	handler = create_flow_rule(dev, ft_prio, flow_attr, NULL);
+	if (!IS_ERR(handler)) {
+		handler_dst = create_flow_rule(dev, ft_prio,
+					       flow_attr, dst);
+		if (IS_ERR(handler_dst)) {
+			mlx5_del_flow_rule(handler->rule);
+			kfree(handler);
+			handler = handler_dst;
+		} else {
+			list_add(&handler_dst->list, &handler->list);
+		}
+	}
+
+	return handler;
+}
 enum {
 	LEFTOVERS_MC,
 	LEFTOVERS_UC,
@@ -1571,7 +1608,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 
 	if (domain != IB_FLOW_DOMAIN_USER ||
 	    flow_attr->port > MLX5_CAP_GEN(dev->mdev, num_ports) ||
-	    flow_attr->flags)
+	    (flow_attr->flags & ~IB_FLOW_ATTR_FLAGS_DONT_TRAP))
 		return ERR_PTR(-EINVAL);
 
 	dst = kzalloc(sizeof(*dst), GFP_KERNEL);
@@ -1590,8 +1627,13 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	dst->tir_num = to_mqp(qp)->raw_packet_qp.rq.tirn;
 
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
-		handler = create_flow_rule(dev, ft_prio, flow_attr,
-					   dst);
+		if (flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP)  {
+			handler = create_dont_trap_rule(dev, ft_prio,
+							flow_attr, dst);
+		} else {
+			handler = create_flow_rule(dev, ft_prio, flow_attr,
+						   dst);
+		}
 	} else if (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
 		   flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT) {
 		handler = create_leftovers_rule(dev, ft_prio, flow_attr,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 60b8962..76b2b42 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -127,7 +127,7 @@ struct mlx5_ib_pd {
 };
 
 #define MLX5_IB_FLOW_MCAST_PRIO		(MLX5_BY_PASS_NUM_PRIOS - 1)
-#define MLX5_IB_FLOW_LAST_PRIO		(MLX5_IB_FLOW_MCAST_PRIO - 1)
+#define MLX5_IB_FLOW_LAST_PRIO		(MLX5_BY_PASS_NUM_REGULAR_PRIOS - 1)
 #if (MLX5_IB_FLOW_LAST_PRIO <= 0)
 #error "Invalid number of bypass priorities"
 #endif
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 12079fd..9566b3b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1318,6 +1318,11 @@ static inline u16 mlx5_to_sw_pkey_sz(int pkey_sz)
 	return MLX5_MIN_PKEY_TABLE_SIZE << pkey_sz;
 }
 
-#define MLX5_BY_PASS_NUM_PRIOS 9
+#define MLX5_BY_PASS_NUM_REGULAR_PRIOS 8
+#define MLX5_BY_PASS_NUM_DONT_TRAP_PRIOS 8
+#define MLX5_BY_PASS_NUM_MULTICAST_PRIOS 1
+#define MLX5_BY_PASS_NUM_PRIOS (MLX5_BY_PASS_NUM_REGULAR_PRIOS +\
+				MLX5_BY_PASS_NUM_DONT_TRAP_PRIOS +\
+				MLX5_BY_PASS_NUM_MULTICAST_PRIOS)
 
 #endif /* MLX5_DEVICE_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
