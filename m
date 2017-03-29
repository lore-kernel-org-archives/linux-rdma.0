From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Check supported flow table size
Date: Wed, 29 Mar 2017 06:09:00 +0300
Message-ID: <20170329030901.5772-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Check that the required flow table size is supported
by device. Return ENOMEM error if no space left.

In addition change the create flow table routine
to return ENOMEM instead of ENOSPC.

Fixes: 038d2ef87572 ('IB/mlx5: Add flow steering support')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4dc0a8785fe0..1bef4f5da31c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2048,11 +2048,14 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	struct mlx5_flow_namespace *ns = NULL;
 	struct mlx5_ib_flow_prio *prio;
 	struct mlx5_flow_table *ft;
+	int max_table_size;
 	int num_entries;
 	int num_groups;
 	int priority;
 	int err = 0;
 
+	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
+						       log_max_ft_size));
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
 		if (flow_is_multicast_only(flow_attr) &&
 		    !dont_trap)
@@ -2091,6 +2094,9 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	if (!ns)
 		return ERR_PTR(-ENOTSUPP);
 
+	if (num_entries > max_table_size)
+		return ERR_PTR(-ENOMEM);
+
 	ft = prio->flow_table;
 	if (!ft) {
 		ft = mlx5_create_auto_grouped_flow_table(ns, priority,
@@ -2315,7 +2321,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	int err;
 
 	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO)
-		return ERR_PTR(-ENOSPC);
+		return ERR_PTR(-ENOMEM);
 
 	if (domain != IB_FLOW_DOMAIN_USER ||
 	    flow_attr->port > MLX5_CAP_GEN(dev->mdev, num_ports) ||
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
