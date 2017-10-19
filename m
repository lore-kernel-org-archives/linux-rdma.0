From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 15/16] IB/mlx5: Add flow counter set support
Date: Thu, 19 Oct 2017 17:41:57 +0300
Message-ID: <1508424118-27205-16-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Associates a counter set with a flow when IB_FLOW_SPEC_ACTION_COUNT
is part of the flow specifications.

Expose flow counters to the generic counters sets interface.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 178 +++++++++++++++++++++++++++++++++++---
 include/linux/mlx5/fs.h           |   1 +
 2 files changed, 168 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2b434db..46ac67b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1931,6 +1931,16 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 	MLX5_SET(fte_match_set_lyr_2_4, outer_v, ip_dscp, val >> 2);
 }
 
+static bool is_counter_set_valid(struct ib_counter_set *cs,
+				 enum ib_counter_set_type type)
+{
+	struct mlx5_ib_cs *mcs;
+
+	mcs = to_mcs(cs);
+
+	return (mcs->desc_cs->cs_desc.counted_type == type);
+}
+
 #define LAST_ETH_FIELD vlan_tag
 #define LAST_IB_FIELD sl
 #define LAST_IPV4_FIELD tos
@@ -1939,6 +1949,7 @@ static void set_tos(void *outer_c, void *outer_v, u8 mask, u8 val)
 #define LAST_TUNNEL_FIELD tunnel_id
 #define LAST_FLOW_TAG_FIELD tag_id
 #define LAST_DROP_FIELD size
+#define LAST_FLOW_COUNTER_FIELD counter_set
 
 /* Field is the last supported field */
 #define FIELDS_NOT_SUPPORTED(filter, field)\
@@ -2178,6 +2189,16 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 			return -EOPNOTSUPP;
 		action->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 		break;
+	case IB_FLOW_SPEC_ACTION_COUNT:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->flow_count,
+					 LAST_FLOW_COUNTER_FIELD))
+			return -EOPNOTSUPP;
+		action->counter_set = ib_spec->flow_count.counter_set;
+		if (!is_counter_set_valid(action->counter_set,
+					  IB_COUNTER_SET_FLOW))
+			return -EINVAL;
+		action->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2429,13 +2450,16 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 {
 	struct mlx5_flow_table	*ft = ft_prio->flow_table;
 	struct mlx5_ib_flow_handler *handler;
-	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
+	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG,
+					 .counter_set = NULL};
 	struct mlx5_flow_spec *spec;
-	struct mlx5_flow_destination *rule_dst = dst;
+	struct mlx5_flow_destination dest_arr[2] = {};
+	struct mlx5_flow_destination *rule_dst = dest_arr;
+	struct mlx5_ib_cs *rcs;
 	const void *ib_flow = (const void *)flow_attr + sizeof(*flow_attr);
 	unsigned int spec_index;
 	int err = 0;
-	int dest_num = 1;
+	int dest_num = 0;
 
 	if (!is_valid_attr(dev->mdev, flow_attr))
 		return ERR_PTR(-EINVAL);
@@ -2448,6 +2472,10 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	INIT_LIST_HEAD(&handler->list);
+	if (dst) {
+		memcpy(&dest_arr[0], dst, sizeof(*dst));
+		dest_num++;
+	}
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(dev->mdev, spec->match_criteria,
@@ -2463,12 +2491,25 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		set_underlay_qp(dev, spec, underlay_qpn);
 
 	spec->match_criteria_enable = get_match_criteria_enable(spec->match_criteria);
-	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		rule_dst = NULL;
-		dest_num = 0;
-	} else {
-		flow_act.action = dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
-		    MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+	if (!(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP)) {
+		if (dst) {
+			flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		} else {
+			flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+			rule_dst = NULL;
+		}
+	}
+
+	if (rule_dst && flow_act.counter_set) {
+		rcs = to_mcs(flow_act.counter_set);
+		dest_arr[dest_num].type =
+				MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		dest_arr[dest_num].counter =
+				(struct mlx5_fc *)(rcs->hw_cs_handle);
+		dest_num++;
+		handler->ibflow.counter_set =
+				flow_act.counter_set;
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	}
 
 	if (flow_act.flow_tag != MLX5_FS_DEFAULT_FLOW_TAG &&
@@ -3989,10 +4030,35 @@ static int mlx5_ib_describe_counter_set(struct ib_device *ib_dev,
 	return 0;
 }
 
+static int query_flow_counter_set(struct ib_device *ibdev,
+				  struct mlx5_query_count_attr *query_attr)
+{
+	struct mlx5_fc *fc = (struct mlx5_fc *)(query_attr->hw_cs_handle);
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	int ret = 0;
+	u64 last_used;
+
+	if (query_attr->query_flags & IB_COUNTER_SET_FORCE_UPDATE) {
+		ret = mlx5_cmd_fc_query(dev->mdev,
+					fc->id,
+					&query_attr->out[0],
+					&query_attr->out[1]);
+	} else {
+		mlx5_fc_query_cached(fc, &query_attr->out[1],
+				     &query_attr->out[0],
+				     &last_used,
+				     MLX5_FLOW_QUERY_CACHED_ABS);
+	}
+	return ret;
+}
+
 static int mlx5_ib_destroy_counter_set(struct ib_counter_set *cs)
 {
+	struct mlx5_ib_dev *dev = to_mdev(cs->device);
 	struct mlx5_ib_cs *mcs = to_mcs(cs);
 
+	mlx5_fc_destroy(dev->mdev,
+			(struct mlx5_fc *)(mcs->hw_cs_handle));
 	kfree(mcs);
 
 	return 0;
@@ -4004,6 +4070,7 @@ static struct ib_counter_set *mlx5_ib_create_counter_set(
 		struct ib_udata *udata)
 {
 	struct mlx5_ib_create_counter_set_resp resp = {};
+	struct mlx5_fc *flow_count;
 	struct mlx5_ib_dev *dev;
 	struct mlx5_ib_cs *mcs;
 	size_t min_resp_len;
@@ -4027,17 +4094,34 @@ static struct ib_counter_set *mlx5_ib_create_counter_set(
 		return ERR_PTR(-ENOMEM);
 
 	mcs->desc_cs = &dev->counter_sets.desc_cs_arr[cs_id];
+	switch (mcs->desc_cs->cs_desc.counted_type) {
+	case IB_COUNTER_SET_FLOW:
+		mcs->query_count = query_flow_counter_set;
+		flow_count = mlx5_fc_create(dev->mdev, true);
+		if (IS_ERR(flow_count)) {
+			kfree(mcs);
+			return ERR_CAST(flow_count);
+		}
+		mcs->hw_cs_handle = (void *)flow_count;
+		break;
+	default:
+		mlx5_ib_dbg(dev, "unsupported counter set type %d\n",
+			    mcs->desc_cs->cs_desc.counted_type);
+		err = -EINVAL;
+		goto err_get_counter;
+	}
+
 	if (udata && udata->outlen) {
 		resp.response_length = offsetof(typeof(resp), response_length) +
 					sizeof(resp.response_length);
 		err = ib_copy_to_udata(udata, &resp, resp.response_length);
 		if (err)
-			goto err_copy;
+			goto err_get_counter;
 	}
 
 	return &mcs->ibcs;
 
-err_copy:
+err_get_counter:
 	mlx5_ib_destroy_counter_set(&mcs->ibcs);
 	return ERR_PTR(err);
 }
@@ -4081,13 +4165,85 @@ static int mlx5_ib_query_counter_set(struct ib_counter_set *cs,
 	return ret;
 }
 
+struct mlx5_ib_flow_counter {
+	size_t offset;
+	const char *name;
+};
+
+#define INIT_COUNTER(_struct, _name)\
+	{ .name = #_name, .offset = MLX5_BYTE_OFF(_struct, _name)}
+
+static const struct mlx5_ib_flow_counter basic_flow_cnts[] = {
+	INIT_COUNTER(traffic_counter, packets),
+	INIT_COUNTER(traffic_counter, octets),
+};
+
+static void fill_counters_names_flow(char *names_buff)
+{
+	u32 basic_flow_size = ARRAY_SIZE(basic_flow_cnts);
+	int i;
+
+	for (i = 0; i < basic_flow_size; i++) {
+		strlcpy(names_buff, basic_flow_cnts[i].name,
+			IB_COUNTER_NAME_LEN - 1);
+		names_buff += IB_COUNTER_NAME_LEN;
+	}
+}
+
+static int mlx5_ib_init_flow_counter_entry(struct mlx5_ib_dev *dev,
+					   struct mlx5_desc_cs_attr *desc_cs)
+{
+	u32 basic_flow_size = ARRAY_SIZE(basic_flow_cnts);
+	struct ib_counter_set_describe_attr *ib_cs_desc;
+
+	ib_cs_desc = &desc_cs->cs_desc;
+	ib_cs_desc->counted_type = IB_COUNTER_SET_FLOW;
+	ib_cs_desc->num_of_cs =
+			1 << MLX5_CAP_GEN(dev->mdev, log_max_flow_counter_bulk);
+	ib_cs_desc->entries_count = basic_flow_size;
+	ib_cs_desc->attributes = IB_COUNTER_SET_ATTR_CACHED;
+	ib_cs_desc->counters_names_len = basic_flow_size * IB_COUNTER_NAME_LEN;
+	desc_cs->fill_counters_names = fill_counters_names_flow;
+
+	return 0;
+}
+
 static int alloc_ib_counter_sets(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_counter_sets *ib_css = &dev->counter_sets;
+	u32 num_of_css = 0;
+	u32 ret;
 
 	ib_css->max_counter_sets = 0;
+	/* flow counters support */
+	ib_css->max_counter_sets +=
+		(mlx5_ib_port_link_layer(&dev->ib_dev, 1)
+				== IB_LINK_LAYER_ETHERNET);
+
+	if (!ib_css->max_counter_sets)
+		return 0;
+
+	/* alloc counter sets array  */
+	ib_css->desc_cs_arr =
+		kcalloc(ib_css->max_counter_sets,
+			sizeof(struct mlx5_desc_cs_attr),
+			GFP_KERNEL);
+	if (!ib_css->desc_cs_arr) {
+		ret = -ENOMEM;
+		goto err_no_cs;
+	}
+
+	ret = mlx5_ib_init_flow_counter_entry(dev,
+					      &ib_css->desc_cs_arr[num_of_css++]);
+	if (ret)
+		goto err_init_flow_counter_entry;
 
 	return 0;
+
+err_init_flow_counter_entry:
+	kfree(ib_css->desc_cs_arr);
+err_no_cs:
+	return ret;
 }
 
 static void dealloc_ib_counter_sets(struct mlx5_ib_dev *dev)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 8e0331c..9a84527 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -140,6 +140,7 @@ struct mlx5_flow_act {
 	u32 flow_tag;
 	u32 encap_id;
 	u32 modify_id;
+	struct ib_counter_set *counter_set;
 };
 
 #define MLX5_DECLARE_FLOW_ACT(name) \
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
