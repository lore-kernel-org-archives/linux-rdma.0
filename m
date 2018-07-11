From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 6/8] IB/mlx5: Support adding flow steering rule by raw data
Date: Wed, 11 Jul 2018 14:10:43 +0300
Message-ID: <20180711111045.6282-7-leon@kernel.org>
References: <20180711111045.6282-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180711111045.6282-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add support to set a public flow steering rule which its destination is
a TIR by using raw specification data.

The logic follows the verbs API but instead of using ib_spec(s) the raw
input data is used.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 216 ++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   2 +
 2 files changed, 201 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 53e30449477e..dba3d529f49f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2980,11 +2980,11 @@ static void counters_clear_description(struct ib_counters *counters)
 
 static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 {
-	struct mlx5_ib_dev *dev = to_mdev(flow_id->qp->device);
 	struct mlx5_ib_flow_handler *handler = container_of(flow_id,
 							  struct mlx5_ib_flow_handler,
 							  ibflow);
 	struct mlx5_ib_flow_handler *iter, *tmp;
+	struct mlx5_ib_dev *dev = handler->dev;
 
 	mutex_lock(&dev->flow_db->lock);
 
@@ -3002,6 +3002,8 @@ static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 		counters_clear_description(handler->ibcounters);
 
 	mutex_unlock(&dev->flow_db->lock);
+	if (handler->flow_matcher)
+		atomic_dec(&handler->flow_matcher->usecnt);
 	kfree(handler);
 
 	return 0;
@@ -3022,6 +3024,26 @@ enum flow_table_type {
 
 #define MLX5_FS_MAX_TYPES	 6
 #define MLX5_FS_MAX_ENTRIES	 BIT(16)
+
+static struct mlx5_ib_flow_prio *_get_prio(struct mlx5_flow_namespace *ns,
+					   struct mlx5_ib_flow_prio *prio,
+					   int priority,
+					   int num_entries, int num_groups)
+{
+	struct mlx5_flow_table *ft;
+
+	ft = mlx5_create_auto_grouped_flow_table(ns, priority,
+						 num_entries,
+						 num_groups,
+						 0, 0);
+	if (IS_ERR(ft))
+		return ERR_CAST(ft);
+
+	prio->flow_table = ft;
+	prio->refcount = 0;
+	return prio;
+}
+
 static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 						struct ib_flow_attr *flow_attr,
 						enum flow_table_type ft_type)
@@ -3034,7 +3056,6 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	int num_entries;
 	int num_groups;
 	int priority;
-	int err = 0;
 
 	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 						       log_max_ft_size));
@@ -3084,21 +3105,10 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 		return ERR_PTR(-ENOMEM);
 
 	ft = prio->flow_table;
-	if (!ft) {
-		ft = mlx5_create_auto_grouped_flow_table(ns, priority,
-							 num_entries,
-							 num_groups,
-							 0, 0);
-
-		if (!IS_ERR(ft)) {
-			prio->refcount = 0;
-			prio->flow_table = ft;
-		} else {
-			err = PTR_ERR(ft);
-		}
-	}
+	if (!ft)
+		return _get_prio(ns, prio, priority, num_entries, num_groups);
 
-	return err ? ERR_PTR(err) : prio;
+	return prio;
 }
 
 static void set_underlay_qp(struct mlx5_ib_dev *dev,
@@ -3357,6 +3367,7 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 
 	ft_prio->refcount++;
 	handler->prio = ft_prio;
+	handler->dev = dev;
 
 	ft_prio->flow_table = ft;
 free:
@@ -3643,13 +3654,184 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	return ERR_PTR(err);
 }
 
+static struct mlx5_ib_flow_prio *_get_flow_table(struct mlx5_ib_dev *dev,
+						 int priority, bool mcast)
+{
+	int max_table_size;
+	struct mlx5_flow_namespace *ns = NULL;
+	struct mlx5_ib_flow_prio *prio;
+
+	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
+			     log_max_ft_size));
+	if (max_table_size < MLX5_FS_MAX_ENTRIES)
+		return ERR_PTR(-ENOMEM);
+
+	if (mcast)
+		priority = MLX5_IB_FLOW_MCAST_PRIO;
+	else
+		priority = ib_prio_to_core_prio(priority, false);
+
+	ns = mlx5_get_flow_namespace(dev->mdev, MLX5_FLOW_NAMESPACE_BYPASS);
+	if (!ns)
+		return ERR_PTR(-ENOTSUPP);
+
+	prio = &dev->flow_db->prios[priority];
+
+	if (prio->flow_table)
+		return prio;
+
+	return _get_prio(ns, prio, priority, MLX5_FS_MAX_ENTRIES,
+			 MLX5_FS_MAX_TYPES);
+}
+
+static struct mlx5_ib_flow_handler *
+_create_raw_flow_rule(struct mlx5_ib_dev *dev,
+		      struct mlx5_ib_flow_prio *ft_prio,
+		      struct mlx5_flow_destination *dst,
+		      struct mlx5_ib_flow_matcher  *fs_matcher,
+		      void *cmd_in, int inlen)
+{
+	struct mlx5_ib_flow_handler *handler;
+	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
+	struct mlx5_flow_spec *spec;
+	struct mlx5_flow_table *ft = ft_prio->flow_table;
+	int err = 0;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	handler = kzalloc(sizeof(*handler), GFP_KERNEL);
+	if (!handler || !spec) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	INIT_LIST_HEAD(&handler->list);
+
+	memcpy(spec->match_value, cmd_in, inlen);
+	memcpy(spec->match_criteria, fs_matcher->matcher_mask.match_params,
+	       fs_matcher->mask_len);
+	spec->match_criteria_enable = fs_matcher->match_criteria_enable;
+
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	handler->rule = mlx5_add_flow_rules(ft, spec,
+					    &flow_act, dst, 1);
+
+	if (IS_ERR(handler->rule)) {
+		err = PTR_ERR(handler->rule);
+		goto free;
+	}
+
+	ft_prio->refcount++;
+	handler->prio = ft_prio;
+	handler->dev = dev;
+	ft_prio->flow_table = ft;
+
+free:
+	if (err)
+		kfree(handler);
+	kvfree(spec);
+	return err ? ERR_PTR(err) : handler;
+}
+
+static bool raw_fs_is_multicast(struct mlx5_ib_flow_matcher *fs_matcher,
+				void *match_v)
+{
+	void *match_c;
+	void *match_v_set_lyr_2_4, *match_c_set_lyr_2_4;
+	void *dmac, *dmac_mask;
+	void *ipv4, *ipv4_mask;
+
+	if (!(fs_matcher->match_criteria_enable &
+	      (1 << MATCH_CRITERIA_ENABLE_OUTER_BIT)))
+		return false;
+
+	match_c = fs_matcher->matcher_mask.match_params;
+	match_v_set_lyr_2_4 = MLX5_ADDR_OF(fte_match_param, match_v,
+					   outer_headers);
+	match_c_set_lyr_2_4 = MLX5_ADDR_OF(fte_match_param, match_c,
+					   outer_headers);
+
+	dmac = MLX5_ADDR_OF(fte_match_set_lyr_2_4, match_v_set_lyr_2_4,
+			    dmac_47_16);
+	dmac_mask = MLX5_ADDR_OF(fte_match_set_lyr_2_4, match_c_set_lyr_2_4,
+				 dmac_47_16);
+
+	if (is_multicast_ether_addr(dmac) &&
+	    is_multicast_ether_addr(dmac_mask))
+		return true;
+
+	ipv4 = MLX5_ADDR_OF(fte_match_set_lyr_2_4, match_v_set_lyr_2_4,
+			    dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+
+	ipv4_mask = MLX5_ADDR_OF(fte_match_set_lyr_2_4, match_c_set_lyr_2_4,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+
+	if (ipv4_is_multicast(*(__be32 *)(ipv4)) &&
+	    ipv4_is_multicast(*(__be32 *)(ipv4_mask)))
+		return true;
+
+	return false;
+}
+
 struct mlx5_ib_flow_handler *
 mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 			struct mlx5_ib_flow_matcher *fs_matcher,
 			void *cmd_in, int inlen, int dest_id,
 			int dest_type)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct mlx5_flow_destination *dst;
+	struct mlx5_ib_flow_prio *ft_prio;
+	int priority = fs_matcher->priority;
+	struct mlx5_ib_flow_handler *handler;
+	bool mcast;
+	int err;
+
+	if (fs_matcher->flow_type != MLX5_IB_FLOW_TYPE_NORMAL)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (fs_matcher->priority > MLX5_IB_FLOW_LAST_PRIO)
+		return ERR_PTR(-ENOMEM);
+
+	if (dest_type != MLX5_FLOW_DESTINATION_TYPE_TIR)
+		return ERR_PTR(-ENOTSUPP);
+
+	dst = kzalloc(sizeof(*dst), GFP_KERNEL);
+	if (!dst)
+		return ERR_PTR(-ENOMEM);
+
+	mcast = raw_fs_is_multicast(fs_matcher, cmd_in);
+	mutex_lock(&dev->flow_db->lock);
+
+	ft_prio = _get_flow_table(dev, priority, mcast);
+	if (IS_ERR(ft_prio)) {
+		err = PTR_ERR(ft_prio);
+		goto unlock;
+	}
+
+	dst->type = dest_type;
+	dst->tir_num = dest_id;
+	handler = _create_raw_flow_rule(dev, ft_prio, dst, fs_matcher, cmd_in,
+					inlen);
+
+	if (IS_ERR(handler)) {
+		err = PTR_ERR(handler);
+		goto destroy_ft;
+	}
+
+	mutex_unlock(&dev->flow_db->lock);
+	atomic_inc(&fs_matcher->usecnt);
+	handler->flow_matcher = fs_matcher;
+
+	kfree(dst);
+
+	return handler;
+
+destroy_ft:
+	put_flow_table(dev, ft_prio, false);
+unlock:
+	mutex_unlock(&dev->flow_db->lock);
+	kfree(dst);
+
+	return ERR_PTR(err);
 }
 
 static u32 mlx5_ib_flow_action_flags_to_accel_xfrm_flags(u32 mlx5_flags)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7c502052cb87..7690dc6a897e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -178,6 +178,8 @@ struct mlx5_ib_flow_handler {
 	struct mlx5_ib_flow_prio	*prio;
 	struct mlx5_flow_handle		*rule;
 	struct ib_counters		*ibcounters;
+	struct mlx5_ib_dev		*dev;
+	struct mlx5_ib_flow_matcher	*flow_matcher;
 };
 
 struct mlx5_ib_flow_matcher {
-- 
2.14.4
