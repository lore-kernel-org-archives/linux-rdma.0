From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 26/27] RDMA/mlx5: Add NIC TX namespace when getting a flow table
Date: Sun, 29 Jul 2018 15:59:04 +0300
Message-ID: <20180729125905.31989-27-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Add the ability to get a NIC TX flow table when using _get_flow_table().
This will allow to create a matcher and a flow rule on the NIC TX path.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c    |  1 +
 drivers/infiniband/hw/mlx5/main.c    | 38 ++++++++++++++++++++++++++----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index b254b55e8de0..2422629f48c9 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -162,6 +162,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (!obj)
 		return -ENOMEM;
 
+	obj->ns_type = MLX5_FLOW_NAMESPACE_BYPASS;
 	obj->mask_len = uverbs_attr_get_len(
 		attrs, MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
 	err = uverbs_copy_from(&obj->matcher_mask,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2b2af82dc32e..ba4bcbc3adb6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3695,33 +3695,52 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 }
 
 static struct mlx5_ib_flow_prio *_get_flow_table(struct mlx5_ib_dev *dev,
-						 int priority, bool mcast)
+						 struct mlx5_ib_flow_matcher *fs_matcher,
+						 bool mcast)
 {
-	int max_table_size;
 	struct mlx5_flow_namespace *ns = NULL;
 	struct mlx5_ib_flow_prio *prio;
+	int max_table_size = 0;
+	u32 flags = 0;
+	int priority;
+
+	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_BYPASS) {
+		max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
+							       log_max_ft_size));
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
+					      reformat_l3_tunnel_to_l2))
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
+	} else { /* Can only be MLX5_FLOW_NAMESPACE_EGRESS */
+		max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev,
+							       log_max_ft_size));
+		if (MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat))
+			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
+	}
 
-	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
-			     log_max_ft_size));
 	if (max_table_size < MLX5_FS_MAX_ENTRIES)
 		return ERR_PTR(-ENOMEM);
 
 	if (mcast)
 		priority = MLX5_IB_FLOW_MCAST_PRIO;
 	else
-		priority = ib_prio_to_core_prio(priority, false);
+		priority = ib_prio_to_core_prio(fs_matcher->priority, false);
 
-	ns = mlx5_get_flow_namespace(dev->mdev, MLX5_FLOW_NAMESPACE_BYPASS);
+	ns = mlx5_get_flow_namespace(dev->mdev, fs_matcher->ns_type);
 	if (!ns)
 		return ERR_PTR(-ENOTSUPP);
 
-	prio = &dev->flow_db->prios[priority];
+	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_BYPASS)
+		prio = &dev->flow_db->prios[priority];
+	else
+		prio = &dev->flow_db->egress_prios[priority];
 
 	if (prio->flow_table)
 		return prio;
 
 	return _get_prio(ns, prio, priority, MLX5_FS_MAX_ENTRIES,
-			 MLX5_FS_MAX_TYPES, 0);
+			 MLX5_FS_MAX_TYPES, flags);
 }
 
 static struct mlx5_ib_flow_handler *
@@ -3820,7 +3839,6 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 {
 	struct mlx5_flow_destination *dst;
 	struct mlx5_ib_flow_prio *ft_prio;
-	int priority = fs_matcher->priority;
 	struct mlx5_ib_flow_handler *handler;
 	bool mcast;
 	int err;
@@ -3838,7 +3856,7 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 	mcast = raw_fs_is_multicast(fs_matcher, cmd_in);
 	mutex_lock(&dev->flow_db->lock);
 
-	ft_prio = _get_flow_table(dev, priority, mcast);
+	ft_prio = _get_flow_table(dev, fs_matcher, mcast);
 	if (IS_ERR(ft_prio)) {
 		err = PTR_ERR(ft_prio);
 		goto unlock;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 76f1c178cef7..639b5dccf079 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -187,6 +187,7 @@ struct mlx5_ib_flow_matcher {
 	struct mlx5_ib_match_params matcher_mask;
 	int			mask_len;
 	enum mlx5_ib_flow_type	flow_type;
+	u8			ns_type;
 	u16			priority;
 	struct mlx5_core_dev	*mdev;
 	atomic_t		usecnt;
-- 
2.14.4
