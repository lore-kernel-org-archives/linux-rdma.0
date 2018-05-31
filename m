From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v3 12/14] IB/mlx5: Add flow counters binding support
Date: Thu, 31 May 2018 16:43:39 +0300
Message-ID: <20180531134341.18441-13-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Associates a counters with a flow when IB_FLOW_SPEC_ACTION_COUNT
is part of the flow specifications.

The counters user space placements of location and description
(index, description) pairs are passed as private data of the
counters flow specification.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 223 ++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  15 +++
 include/linux/mlx5/fs.h              |   1 +
 include/uapi/rdma/mlx5-abi.h         |  24 ++++
 4 files changed, 249 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4d0f53566854..6a5600db897e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2480,7 +2480,7 @@ static int check_mpls_supp_fields(u32 field_support, const __be32 *set_mask)
 #define LAST_TUNNEL_FIELD tunnel_id
 #define LAST_FLOW_TAG_FIELD tag_id
 #define LAST_DROP_FIELD size
-#define LAST_DROP_FIELD size
+#define LAST_COUNTERS_FIELD counters
 
 /* Field is the last supported field */
 #define FIELDS_NOT_SUPPORTED(filter, field)\
@@ -2844,6 +2844,18 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 		if (ret)
 			return ret;
 		break;
+	case IB_FLOW_SPEC_ACTION_COUNT:
+		if (FIELDS_NOT_SUPPORTED(ib_spec->flow_count,
+					 LAST_COUNTERS_FIELD))
+			return -EOPNOTSUPP;
+
+		/* for now support only one counters spec per flow */
+		if (action->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
+			return -EINVAL;
+
+		action->counters = ib_spec->flow_count.counters;
+		action->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2991,6 +3003,17 @@ static void put_flow_table(struct mlx5_ib_dev *dev,
 	}
 }
 
+static void counters_clear_description(struct ib_counters *counters)
+{
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
+
+	mutex_lock(&mcounters->mcntrs_mutex);
+	kfree(mcounters->counters_data);
+	mcounters->counters_data = NULL;
+	mcounters->cntrs_max_index = 0;
+	mutex_unlock(&mcounters->mcntrs_mutex);
+}
+
 static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 {
 	struct mlx5_ib_dev *dev = to_mdev(flow_id->qp->device);
@@ -3010,8 +3033,11 @@ static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 
 	mlx5_del_flow_rules(handler->rule);
 	put_flow_table(dev, handler->prio, true);
-	mutex_unlock(&dev->flow_db->lock);
+	if (handler->ibcounters &&
+	    atomic_read(&handler->ibcounters->usecnt) == 1)
+		counters_clear_description(handler->ibcounters);
 
+	mutex_unlock(&dev->flow_db->lock);
 	kfree(handler);
 
 	return 0;
@@ -3131,22 +3157,128 @@ static void set_underlay_qp(struct mlx5_ib_dev *dev,
 	}
 }
 
+static int counters_set_description(struct ib_counters *counters,
+				    enum mlx5_ib_counters_type counters_type,
+				    struct mlx5_ib_flow_counters_desc *desc_data,
+				    u32 ncounters)
+{
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
+	u32 cntrs_max_index = 0;
+	int i;
+
+	if (counters_type != MLX5_IB_COUNTERS_FLOW)
+		return -EINVAL;
+
+	/* init the fields for the object */
+	mcounters->type = counters_type;
+	mcounters->ncounters = ncounters;
+	/* each counter entry have both description and index pair */
+	for (i = 0; i < ncounters; i++) {
+		if (desc_data[i].description > IB_COUNTER_BYTES)
+			return -EINVAL;
+
+		if (cntrs_max_index <= desc_data[i].index)
+			cntrs_max_index = desc_data[i].index + 1;
+	}
+
+	mutex_lock(&mcounters->mcntrs_mutex);
+	mcounters->counters_data = desc_data;
+	mcounters->cntrs_max_index = cntrs_max_index;
+	mutex_unlock(&mcounters->mcntrs_mutex);
+
+	return 0;
+}
+
+#define MAX_COUNTERS_NUM (USHRT_MAX / (sizeof(u32) * 2))
+static int flow_counters_set_data(struct ib_counters *ibcounters,
+				  struct mlx5_ib_create_flow *ucmd)
+{
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(ibcounters);
+	struct mlx5_ib_flow_counters_data *cntrs_data = NULL;
+	struct mlx5_ib_flow_counters_desc *desc_data = NULL;
+	bool hw_hndl = false;
+	int ret = 0;
+
+	if (ucmd && ucmd->ncounters_data != 0) {
+		cntrs_data = ucmd->data;
+		if (cntrs_data->ncounters > MAX_COUNTERS_NUM)
+			return -EINVAL;
+
+		desc_data = kcalloc(cntrs_data->ncounters,
+				    sizeof(*desc_data),
+				    GFP_KERNEL);
+		if (!desc_data)
+			return  -ENOMEM;
+
+		if (copy_from_user(desc_data,
+				   u64_to_user_ptr(cntrs_data->counters_data),
+				   sizeof(*desc_data) * cntrs_data->ncounters)) {
+				ret = -EFAULT;
+				goto free;
+		}
+	}
+
+	if (!mcounters->hw_cntrs_hndl) {
+		mcounters->hw_cntrs_hndl = mlx5_fc_create(
+			to_mdev(ibcounters->device)->mdev, false);
+		if (!mcounters->hw_cntrs_hndl) {
+			ret = -ENOMEM;
+			goto free;
+		}
+		hw_hndl = true;
+	}
+
+	if (desc_data) {
+		/* counters already bound to at least one flow */
+		if (mcounters->cntrs_max_index) {
+			ret = -EINVAL;
+			goto free_hndl;
+		}
+
+		ret = counters_set_description(ibcounters,
+					       MLX5_IB_COUNTERS_FLOW,
+					       desc_data,
+					       cntrs_data->ncounters);
+		if (ret)
+			goto free_hndl;
+
+	} else if (!mcounters->cntrs_max_index) {
+		/* counters not bound yet, must have udata passed */
+			ret = -EINVAL;
+			goto free_hndl;
+	}
+
+	return 0;
+
+free_hndl:
+	if (hw_hndl) {
+		mlx5_fc_destroy(to_mdev(ibcounters->device)->mdev,
+				mcounters->hw_cntrs_hndl);
+		mcounters->hw_cntrs_hndl = NULL;
+	}
+free:
+	kfree(desc_data);
+	return ret;
+}
+
 static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 						      struct mlx5_ib_flow_prio *ft_prio,
 						      const struct ib_flow_attr *flow_attr,
 						      struct mlx5_flow_destination *dst,
-						      u32 underlay_qpn)
+						      u32 underlay_qpn,
+						      struct mlx5_ib_create_flow *ucmd)
 {
 	struct mlx5_flow_table	*ft = ft_prio->flow_table;
 	struct mlx5_ib_flow_handler *handler;
 	struct mlx5_flow_act flow_act = {.flow_tag = MLX5_FS_DEFAULT_FLOW_TAG};
 	struct mlx5_flow_spec *spec;
-	struct mlx5_flow_destination *rule_dst = dst;
+	struct mlx5_flow_destination dest_arr[2] = {};
+	struct mlx5_flow_destination *rule_dst = dest_arr;
 	const void *ib_flow = (const void *)flow_attr + sizeof(*flow_attr);
 	unsigned int spec_index;
 	u32 prev_type = 0;
 	int err = 0;
-	int dest_num = 1;
+	int dest_num = 0;
 	bool is_egress = flow_attr->flags & IB_FLOW_ATTR_FLAGS_EGRESS;
 
 	if (!is_valid_attr(dev->mdev, flow_attr))
@@ -3160,6 +3292,10 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	}
 
 	INIT_LIST_HEAD(&handler->list);
+	if (dst) {
+		memcpy(&dest_arr[0], dst, sizeof(*dst));
+		dest_num++;
+	}
 
 	for (spec_index = 0; spec_index < flow_attr->num_of_specs; spec_index++) {
 		err = parse_flow_attr(dev->mdev, spec->match_criteria,
@@ -3196,15 +3332,30 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		goto free;
 	}
 
+	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
+		err = flow_counters_set_data(flow_act.counters, ucmd);
+		if (err)
+			goto free;
+
+		handler->ibcounters = flow_act.counters;
+		dest_arr[dest_num].type =
+			MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		dest_arr[dest_num].counter =
+			to_mcounters(flow_act.counters)->hw_cntrs_hndl;
+		dest_num++;
+	}
+
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_DROP) {
-		rule_dst = NULL;
-		dest_num = 0;
+		if (!(flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT)) {
+			rule_dst = NULL;
+			dest_num = 0;
+		}
 	} else {
 		if (is_egress)
 			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 		else
 			flow_act.action |=
-				dst ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
+				dest_num ?  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
 					MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
 	}
 
@@ -3230,8 +3381,12 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 
 	ft_prio->flow_table = ft;
 free:
-	if (err)
+	if (err && handler) {
+		if (handler->ibcounters &&
+		    atomic_read(&handler->ibcounters->usecnt) == 1)
+			counters_clear_description(handler->ibcounters);
 		kfree(handler);
+	}
 	kvfree(spec);
 	return err ? ERR_PTR(err) : handler;
 }
@@ -3241,7 +3396,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 						     const struct ib_flow_attr *flow_attr,
 						     struct mlx5_flow_destination *dst)
 {
-	return _create_flow_rule(dev, ft_prio, flow_attr, dst, 0);
+	return _create_flow_rule(dev, ft_prio, flow_attr, dst, 0, NULL);
 }
 
 static struct mlx5_ib_flow_handler *create_dont_trap_rule(struct mlx5_ib_dev *dev,
@@ -3381,12 +3536,43 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	struct mlx5_ib_flow_prio *ft_prio_tx = NULL;
 	struct mlx5_ib_flow_prio *ft_prio;
 	bool is_egress = flow_attr->flags & IB_FLOW_ATTR_FLAGS_EGRESS;
+	struct mlx5_ib_create_flow *ucmd = NULL, ucmd_hdr;
+	size_t min_ucmd_sz, required_ucmd_sz;
 	int err;
 	int underlay_qpn;
 
-	if (udata &&
-	    udata->inlen && !ib_is_udata_cleared(udata, 0, udata->inlen))
-		return ERR_PTR(-EOPNOTSUPP);
+	if (udata && udata->inlen) {
+		min_ucmd_sz = offsetof(typeof(ucmd_hdr), reserved) +
+				sizeof(ucmd_hdr.reserved);
+		if (udata->inlen < min_ucmd_sz)
+			return ERR_PTR(-EOPNOTSUPP);
+
+		err = ib_copy_from_udata(&ucmd_hdr, udata, min_ucmd_sz);
+		if (err)
+			return ERR_PTR(err);
+
+		/* currently supports only one counters data */
+		if (ucmd_hdr.ncounters_data > 1)
+			return ERR_PTR(-EINVAL);
+
+		required_ucmd_sz = min_ucmd_sz +
+			sizeof(struct mlx5_ib_flow_counters_data) *
+			ucmd_hdr.ncounters_data;
+		if (udata->inlen > required_ucmd_sz &&
+		    !ib_is_udata_cleared(udata, required_ucmd_sz,
+					 udata->inlen - required_ucmd_sz))
+			return ERR_PTR(-EOPNOTSUPP);
+
+		ucmd = kzalloc(required_ucmd_sz, GFP_KERNEL);
+		if (!ucmd)
+			return ERR_PTR(-ENOMEM);
+
+		err = ib_copy_from_udata(ucmd, udata, required_ucmd_sz);
+		if (err) {
+			kfree(ucmd);
+			return ERR_PTR(err);
+		}
+	}
 
 	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO)
 		return ERR_PTR(-ENOMEM);
@@ -3441,7 +3627,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 			underlay_qpn = (mqp->flags & MLX5_IB_QP_UNDERLAY) ?
 					mqp->underlay_qpn : 0;
 			handler = _create_flow_rule(dev, ft_prio, flow_attr,
-						    dst, underlay_qpn);
+						    dst, underlay_qpn, ucmd);
 		}
 	} else if (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
 		   flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT) {
@@ -3462,6 +3648,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 
 	mutex_unlock(&dev->flow_db->lock);
 	kfree(dst);
+	kfree(ucmd);
 
 	return &handler->ibflow;
 
@@ -3472,6 +3659,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 unlock:
 	mutex_unlock(&dev->flow_db->lock);
 	kfree(dst);
+	kfree(ucmd);
 	kfree(handler);
 	return ERR_PTR(err);
 }
@@ -5136,6 +5324,11 @@ static int mlx5_ib_destroy_counters(struct ib_counters *counters)
 {
 	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
 
+	counters_clear_description(counters);
+	if (mcounters->hw_cntrs_hndl)
+		mlx5_fc_destroy(to_mdev(counters->device)->mdev,
+				mcounters->hw_cntrs_hndl);
+
 	kfree(mcounters);
 
 	return 0;
@@ -5150,6 +5343,8 @@ static struct ib_counters *mlx5_ib_create_counters(struct ib_device *device,
 	if (!mcounters)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&mcounters->mcntrs_mutex);
+
 	return &mcounters->ibcntrs;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index fd27ec1aed08..155bca627222 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -175,6 +175,7 @@ struct mlx5_ib_flow_handler {
 	struct ib_flow			ibflow;
 	struct mlx5_ib_flow_prio	*prio;
 	struct mlx5_flow_handle		*rule;
+	struct ib_counters		*ibcounters;
 };
 
 struct mlx5_ib_flow_db {
@@ -813,8 +814,22 @@ struct mlx5_memic {
 	DECLARE_BITMAP(memic_alloc_pages, MLX5_MAX_MEMIC_PAGES);
 };
 
+enum mlx5_ib_counters_type {
+	MLX5_IB_COUNTERS_FLOW,
+};
+
 struct mlx5_ib_mcounters {
 	struct ib_counters ibcntrs;
+	enum mlx5_ib_counters_type type;
+	void *hw_cntrs_hndl;
+	/* max index set as part of create_flow */
+	u32 cntrs_max_index;
+	/* number of counters data entries (<description,index> pair) */
+	u32 ncounters;
+	/* counters data array for descriptions and indexes */
+	struct mlx5_ib_flow_counters_desc *counters_data;
+	/* protects access to mcounters internal data */
+	struct mutex mcntrs_mutex;
 };
 
 static inline struct mlx5_ib_mcounters *
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 3b4c3298061c..757b4a30281e 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -160,6 +160,7 @@ struct mlx5_flow_act {
 	u32 modify_id;
 	uintptr_t esp_id;
 	struct mlx5_fs_vlan vlan;
+	struct ib_counters *counters;
 };
 
 #define MLX5_DECLARE_FLOW_ACT(name) \
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 729b18f8c046..8daec1fa49cf 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -36,6 +36,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h>	/* For ETH_ALEN. */
+#include <rdma/ib_user_ioctl_verbs.h>
 
 enum {
 	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
@@ -443,4 +444,27 @@ enum {
 enum {
 	MLX5_IB_CLOCK_INFO_V1              = 0,
 };
+
+struct mlx5_ib_flow_counters_desc {
+	__u32	description;
+	__u32	index;
+};
+
+struct mlx5_ib_flow_counters_data {
+	RDMA_UAPI_PTR(struct mlx5_ib_flow_counters_desc *, counters_data);
+	__u32   ncounters;
+	__u32   reserved;
+};
+
+struct mlx5_ib_create_flow {
+	__u32   ncounters_data;
+	__u32   reserved;
+	/*
+	 * Following are counters data based on ncounters_data, each
+	 * entry in the data[] should match a corresponding counter object
+	 * that was pointed by a counters spec upon the flow creation
+	 */
+	struct mlx5_ib_flow_counters_data data[];
+};
+
 #endif /* MLX5_ABI_USER_H */
-- 
2.14.3
