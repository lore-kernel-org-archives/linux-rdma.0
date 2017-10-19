From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 13/16] IB/mlx5: Add counter set operations
Date: Thu, 19 Oct 2017 17:41:55 +0300
Message-ID: <1508424118-27205-14-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch implements the uverbs counter sets API (e.g.
describe,create,destroy,query) by introducing some
internal management structures.

Downstream patches in this series will add the
functionality to support flow counters.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 171 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  31 +++++++
 include/uapi/rdma/mlx5-abi.h         |  16 ++++
 3 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 61ce3ca..a5ff217 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3945,6 +3945,158 @@ static void init_delay_drop(struct mlx5_ib_dev *dev)
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 
 	return mlx5_get_vector_affinity(dev->mdev, comp_vector);
+};
+
+static int mlx5_ib_describe_counter_set(struct ib_device *ib_dev,
+					u16	cs_id,
+					struct ib_counter_set_describe_attr *cs_describe_attr,
+					struct ib_udata *udata)
+{
+	struct mlx5_ib_describe_counter_set_resp resp = {};
+	struct ib_counter_set_describe_attr *ib_cs_desc;
+	struct mlx5_ib_dev *dev = to_mdev(ib_dev);
+	struct mlx5_desc_cs_attr *desc_cs;
+	size_t min_resp_len;
+
+	if (udata && udata->inlen > 0 &&
+	    !ib_is_udata_cleared(udata, 0,
+				 udata->inlen))
+		return -EINVAL;
+
+	min_resp_len = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
+	if (udata && udata->outlen && udata->outlen < min_resp_len)
+		return -EINVAL;
+
+	if (cs_id >= dev->counter_sets.max_counter_sets)
+		return -EINVAL;
+
+	desc_cs = &dev->counter_sets.desc_cs_arr[cs_id];
+	ib_cs_desc = &desc_cs->cs_desc;
+	if (cs_describe_attr->counters_names_buff) {
+		if (cs_describe_attr->counters_names_len <
+				ib_cs_desc->counters_names_len)
+			return -EINVAL;
+
+		desc_cs->fill_counters_names(cs_describe_attr->counters_names_buff);
+	}
+
+	cs_describe_attr->counted_type = ib_cs_desc->counted_type;
+	cs_describe_attr->num_of_cs = ib_cs_desc->num_of_cs;
+	cs_describe_attr->attributes = ib_cs_desc->attributes;
+	cs_describe_attr->entries_count = ib_cs_desc->entries_count;
+	if (udata && udata->outlen) {
+		resp.response_length = offsetof(typeof(resp), response_length) +
+					sizeof(resp.response_length);
+		return ib_copy_to_udata(udata, &resp, resp.response_length);
+	}
+
+	return 0;
+}
+
+static int mlx5_ib_destroy_counter_set(struct ib_counter_set *cs)
+{
+	struct mlx5_ib_cs *mcs = to_mcs(cs);
+
+	kfree(mcs);
+
+	return 0;
+}
+
+static struct ib_counter_set *mlx5_ib_create_counter_set(
+		struct ib_device *device,
+		u16 cs_id,
+		struct ib_udata *udata)
+{
+	struct mlx5_ib_create_counter_set_resp resp = {};
+	struct mlx5_ib_dev *dev;
+	struct mlx5_ib_cs *mcs;
+	size_t min_resp_len;
+	int err;
+
+	if (udata && udata->inlen > 0 &&
+	    !ib_is_udata_cleared(udata, 0,
+				 udata->inlen))
+		return ERR_PTR(-EINVAL);
+
+	min_resp_len = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
+	if (udata && udata->outlen && udata->outlen < min_resp_len)
+		return ERR_PTR(-EINVAL);
+
+	dev = to_mdev(device);
+	if (cs_id >= dev->counter_sets.max_counter_sets)
+		return ERR_PTR(-EINVAL);
+
+	mcs = kzalloc(sizeof(*mcs), GFP_KERNEL);
+	if (!mcs)
+		return ERR_PTR(-ENOMEM);
+
+	mcs->desc_cs = &dev->counter_sets.desc_cs_arr[cs_id];
+	if (udata && udata->outlen) {
+		resp.response_length = offsetof(typeof(resp), response_length) +
+					sizeof(resp.response_length);
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err)
+			goto err_copy;
+	}
+
+	return &mcs->ibcs;
+
+err_copy:
+	mlx5_ib_destroy_counter_set(&mcs->ibcs);
+	return ERR_PTR(err);
+}
+
+static int mlx5_ib_query_counter_set(struct ib_counter_set *cs,
+				     struct ib_counter_set_query_attr *cs_query_attr,
+				     struct ib_udata *udata)
+{
+	struct mlx5_query_count_attr query_attr = {};
+	struct mlx5_ib_query_counter_set_resp resp = {};
+	struct mlx5_ib_cs *mcs = to_mcs(cs);
+	size_t	required_buff_len;
+	size_t min_resp_len;
+	int ret;
+
+	if (udata && udata->inlen > 0 &&
+	    !ib_is_udata_cleared(udata, 0,
+				 udata->inlen))
+		return -EINVAL;
+
+	min_resp_len = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
+	if (udata && udata->outlen && udata->outlen < min_resp_len)
+		return -EINVAL;
+
+	required_buff_len = mcs->desc_cs->cs_desc.entries_count * sizeof(u64);
+	if (required_buff_len > cs_query_attr->buff_len)
+		return -EINVAL;
+
+	cs_query_attr->outlen = required_buff_len;
+	query_attr.out = cs_query_attr->out_buff;
+	query_attr.hw_cs_handle = mcs->hw_cs_handle;
+	query_attr.query_flags =
+			cs_query_attr->query_flags;
+	ret = mcs->query_count(cs->device, &query_attr);
+	if (udata && udata->outlen) {
+		resp.response_length = offsetof(typeof(resp), response_length) +
+					sizeof(resp.response_length);
+		ret = ib_copy_to_udata(udata, &resp, resp.response_length);
+	}
+
+	return ret;
+}
+
+static int alloc_ib_counter_sets(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_ib_counter_sets *ib_css = &dev->counter_sets;
+
+	ib_css->max_counter_sets = 0;
+
+	return 0;
+}
+
+static void dealloc_ib_counter_sets(struct mlx5_ib_dev *dev)
+{
+	kfree(dev->counter_sets.desc_cs_arr);
 }
 
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
@@ -4028,7 +4180,11 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ)	|
 		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP)	|
 		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_QP)	|
-		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_CQ);
+		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_CQ)	|
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_COUNTER_SET)	|
+		(1ull << IB_USER_VERBS_EX_CMD_DESTROY_COUNTER_SET)	|
+		(1ull << IB_USER_VERBS_EX_CMD_QUERY_COUNTER_SET)	|
+		(1ull << IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
@@ -4081,6 +4237,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.get_vector_affinity	= mlx5_ib_get_vector_affinity;
 	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads))
 		dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
+	dev->ib_dev.create_counter_set  = mlx5_ib_create_counter_set;
+	dev->ib_dev.destroy_counter_set = mlx5_ib_destroy_counter_set;
+	dev->ib_dev.query_counter_set   = mlx5_ib_query_counter_set;
+	dev->ib_dev.describe_counter_set = mlx5_ib_describe_counter_set;
 
 	if (mlx5_core_is_pf(mdev)) {
 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
@@ -4199,6 +4359,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 			goto err_delay_drop;
 	}
 
+	err = alloc_ib_counter_sets(dev);
+	if (err)
+		goto err_create_file;
+
 	if ((MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
 	    MLX5_CAP_GEN(mdev, disable_local_lb))
 		mutex_init(&dev->lb_mutex);
@@ -4207,6 +4371,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	return dev;
 
+err_create_file:
+	device_remove_file(&dev->ib_dev.dev,
+			   mlx5_class_attributes[i]);
+
 err_delay_drop:
 	cancel_delay_drop(dev);
 	destroy_umrc_res(dev);
@@ -4265,6 +4433,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
 		mlx5_ib_dealloc_counters(dev);
 	destroy_umrc_res(dev);
+	dealloc_ib_counter_sets(dev);
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
 	if (ll == IB_LINK_LAYER_ETHERNET)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 14b1554..d2f9016 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -705,6 +705,35 @@ struct mlx5_ib_delay_drop {
 	struct mlx5_ib_dbg_delay_drop *dbg;
 };
 
+struct mlx5_query_count_attr {
+	void *hw_cs_handle;
+	u64 *out;
+	u32 query_flags;
+};
+
+struct mlx5_desc_cs_attr {
+	struct ib_counter_set_describe_attr cs_desc;
+	void (*fill_counters_names)(char *cs_names_buff);
+};
+
+struct mlx5_ib_cs {
+	struct ib_counter_set ibcs;
+	struct mlx5_desc_cs_attr *desc_cs;
+	void *hw_cs_handle;
+	int (*query_count)(struct ib_device *ibdev,
+			   struct mlx5_query_count_attr *query_attr);
+};
+
+static inline struct mlx5_ib_cs *to_mcs(struct ib_counter_set *ibcs)
+{
+	return container_of(ibcs, struct mlx5_ib_cs, ibcs);
+}
+
+struct mlx5_ib_counter_sets {
+	struct mlx5_desc_cs_attr *desc_cs_arr;
+	u16 max_counter_sets;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -748,6 +777,8 @@ struct mlx5_ib_dev {
 	struct mutex		lb_mutex;
 	u32			user_td;
 	u8			umr_fence;
+
+	struct mlx5_ib_counter_sets counter_sets;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 442b46b..6412400 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -366,4 +366,20 @@ struct mlx5_ib_modify_wq {
 	__u32	comp_mask;
 	__u32	reserved;
 };
+
+struct mlx5_ib_describe_counter_set_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
+struct mlx5_ib_create_counter_set_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
+struct mlx5_ib_query_counter_set_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
 #endif /* MLX5_ABI_USER_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
