From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 6/6] IB/mlx5: Add support for DC target QP
Date: Wed, 27 Dec 2017 19:15:40 +0200
Message-ID: <20171227171540.1646-7-leon@kernel.org>
References: <20171227171540.1646-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227171540.1646-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A DC Target (DCT) QP is represented in the hardware as a unique object.
This object is created by CREATE_DCT command and destroyed by
DESTROY_DCT command. However, in the driver we describe it as a QP.
The hardware command that creates a DCT needs parameters that
the verb create_qp() does not provide. Those remaining parameters are
provided with the call to the verb modify_qp(). Therefore we delay the
actual creation of a DCT in the hardware until the stage of
modify_qp() to RTR.
A support for query_qp() was added as well. It uses QUERY_DCT command to
retrieve the applicable fields.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  27 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   8 ++
 drivers/infiniband/hw/mlx5/qp.c      | 231 +++++++++++++++++++++++++++++++++++
 include/uapi/rdma/mlx5-abi.h         |   5 +
 4 files changed, 269 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9c737cc65503..5d596bff798b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -561,11 +561,11 @@ static int mlx5_get_vport_access_method(struct ib_device *ibdev)
 }
 
 static void get_atomic_caps(struct mlx5_ib_dev *dev,
+			    u8 atomic_size_qp,
 			    struct ib_device_attr *props)
 {
 	u8 tmp;
 	u8 atomic_operations = MLX5_CAP_ATOMIC(dev->mdev, atomic_operations);
-	u8 atomic_size_qp = MLX5_CAP_ATOMIC(dev->mdev, atomic_size_qp);
 	u8 atomic_req_8B_endianness_mode =
 		MLX5_CAP_ATOMIC(dev->mdev, atomic_req_8B_endianness_mode);
 
@@ -582,6 +582,29 @@ static void get_atomic_caps(struct mlx5_ib_dev *dev,
 	}
 }
 
+static void get_atomic_caps_qp(struct mlx5_ib_dev *dev,
+			       struct ib_device_attr *props)
+{
+	u8 atomic_size_qp = MLX5_CAP_ATOMIC(dev->mdev, atomic_size_qp);
+
+	get_atomic_caps(dev, atomic_size_qp, props);
+}
+
+static void get_atomic_caps_dc(struct mlx5_ib_dev *dev,
+			       struct ib_device_attr *props)
+{
+	u8 atomic_size_qp = MLX5_CAP_ATOMIC(dev->mdev, atomic_size_dc);
+
+	get_atomic_caps(dev, atomic_size_qp, props);
+}
+
+bool mlx5_ib_dc_atomic_is_supported(struct mlx5_ib_dev *dev)
+{
+	struct ib_device_attr props = {};
+
+	get_atomic_caps_dc(dev, &props);
+	return (props.atomic_cap == IB_ATOMIC_HCA) ? true : false;
+}
 static int mlx5_query_system_image_guid(struct ib_device *ibdev,
 					__be64 *sys_image_guid)
 {
@@ -873,7 +896,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_srq_sge	   = max_rq_sg - 1;
 	props->max_fast_reg_page_list_len =
 		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
-	get_atomic_caps(dev, props);
+	get_atomic_caps_qp(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
 	props->max_mcast_grp	   = 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
 	props->max_mcast_qp_attach = MLX5_CAP_GEN(mdev, max_qp_mcg);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 66e9c2190f2d..81de3c1f5e97 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -364,12 +364,18 @@ struct mlx5_bf {
 	struct mlx5_sq_bfreg   *bfreg;
 };
 
+struct mlx5_ib_dct {
+	struct mlx5_core_dct	mdct;
+	u32			*in;
+};
+
 struct mlx5_ib_qp {
 	struct ib_qp		ibqp;
 	union {
 		struct mlx5_ib_qp_trans trans_qp;
 		struct mlx5_ib_raw_packet_qp raw_packet_qp;
 		struct mlx5_ib_rss_qp rss_qp;
+		struct mlx5_ib_dct dct;
 	};
 	struct mlx5_buf		buf;
 
@@ -1022,6 +1028,8 @@ struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
 						      struct ib_rwq_ind_table_init_attr *init_attr,
 						      struct ib_udata *udata);
 int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
+bool mlx5_ib_dc_atomic_is_supported(struct mlx5_ib_dev *dev);
+
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 87613c8edac1..e43825ac09e3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2125,6 +2125,52 @@ static const char *ib_qp_type_str(enum ib_qp_type type)
 	}
 }
 
+static struct ib_qp *mlx5_ib_create_dct(struct ib_pd *pd,
+					struct ib_qp_init_attr *attr,
+					struct mlx5_ib_create_qp *ucmd)
+{
+	struct mlx5_ib_dev *dev;
+	struct mlx5_ib_qp *qp;
+	int err = 0;
+	u32 uidx = MLX5_IB_DEFAULT_UIDX;
+	void *dctc;
+
+	if (!attr->srq || !attr->recv_cq)
+		return ERR_PTR(-EINVAL);
+
+	dev = to_mdev(pd->device);
+
+	err = get_qp_user_index(to_mucontext(pd->uobject->context),
+				ucmd, sizeof(*ucmd), &uidx);
+	if (err)
+		return ERR_PTR(err);
+
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp)
+		return ERR_PTR(-ENOMEM);
+
+	qp->dct.in = kzalloc(MLX5_ST_SZ_BYTES(create_dct_in), GFP_KERNEL);
+	if (!qp->dct.in) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	dctc = MLX5_ADDR_OF(create_dct_in, qp->dct.in, dct_context_entry);
+	qp->driver_qp_type = MLX5_IB_QPT_DCT;
+	MLX5_SET(dctc, dctc, pd, to_mpd(pd)->pdn);
+	MLX5_SET(dctc, dctc, srqn_xrqn, to_msrq(attr->srq)->msrq.srqn);
+	MLX5_SET(dctc, dctc, cqn, to_mcq(attr->recv_cq)->mcq.cqn);
+	MLX5_SET64(dctc, dctc, dc_access_key, ucmd->access_key);
+	MLX5_SET(dctc, dctc, user_index, uidx);
+
+	qp->state = IB_QPS_RESET;
+
+	return &qp->ibqp;
+err_free:
+	kfree(qp);
+	return ERR_PTR(err);
+}
+
 static int validate_driver_qp(struct mlx5_ib_dev *dev,
 			      struct ib_qp_init_attr *init_attr,
 			      struct mlx5_ib_create_qp *ucmd,
@@ -2212,6 +2258,8 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 				mlx5_ib_dbg(dev, "DCI QP requires zero size receive queue\n");
 				return ERR_PTR(-EINVAL);
 			}
+		} else {
+			return mlx5_ib_create_dct(pd, init_attr, &ucmd);
 		}
 	}
 
@@ -2283,6 +2331,25 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 	return &qp->ibqp;
 }
 
+static int mlx5_ib_destroy_dct(struct mlx5_ib_qp *mqp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(mqp->ibqp.device);
+
+	if (mqp->state == IB_QPS_RTR) {
+		int err;
+
+		err = mlx5_core_destroy_dct(dev->mdev, &mqp->dct.mdct);
+		if (err) {
+			mlx5_ib_warn(dev, "failed to destroy DCT %d\n", err);
+			return err;
+		}
+	}
+
+	kfree(mqp->dct.in);
+	kfree(mqp);
+	return 0;
+}
+
 int mlx5_ib_destroy_qp(struct ib_qp *qp)
 {
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
@@ -2291,6 +2358,9 @@ int mlx5_ib_destroy_qp(struct ib_qp *qp)
 	if (unlikely(qp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_destroy_qp(qp);
 
+	if (mqp->driver_qp_type == MLX5_IB_QPT_DCT)
+		return mlx5_ib_destroy_dct(mqp);
+
 	destroy_qp_common(dev, mqp);
 
 	kfree(mqp);
@@ -3136,6 +3206,95 @@ static bool mlx5_ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state
 	return false;
 }
 
+/* mlx5_ib_modify_dct: modify a DCT QP
+ * valid transitions are:
+ * RESET to INIT: must set access_flags, pkey_index and port
+ * INIT  to RTR : must set min_rnr_timer, tclass, flow_label,
+ *			   mtu, gid_index and hop_limit
+ * Other transitions and attributes are illegal
+ */
+static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			      int attr_mask, struct ib_udata *udata)
+{
+	struct mlx5_ib_qp *qp = to_mqp(ibqp);
+	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	enum ib_qp_state cur_state, new_state;
+	int err = 0;
+	int required = IB_QP_STATE;
+	void *dctc;
+
+	if (!(attr_mask & IB_QP_STATE))
+		return -EINVAL;
+
+	cur_state = qp->state;
+	new_state = attr->qp_state;
+
+	dctc = MLX5_ADDR_OF(create_dct_in, qp->dct.in, dct_context_entry);
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+		required |= IB_QP_ACCESS_FLAGS | IB_QP_PKEY_INDEX | IB_QP_PORT;
+		if (!is_valid_mask(attr_mask, required, 0))
+			return -EINVAL;
+
+		if (attr->port_num == 0 ||
+		    attr->port_num > MLX5_CAP_GEN(dev->mdev, num_ports)) {
+			mlx5_ib_dbg(dev, "invalid port number %d. number of ports is %d\n",
+				    attr->port_num, dev->num_ports);
+			return -EINVAL;
+		}
+		if (attr->qp_access_flags & IB_ACCESS_REMOTE_READ)
+			MLX5_SET(dctc, dctc, rre, 1);
+		if (attr->qp_access_flags & IB_ACCESS_REMOTE_WRITE)
+			MLX5_SET(dctc, dctc, rwe, 1);
+		if (attr->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC) {
+			if (!mlx5_ib_dc_atomic_is_supported(dev))
+				return -EOPNOTSUPP;
+			MLX5_SET(dctc, dctc, rae, 1);
+			MLX5_SET(dctc, dctc, atomic_mode, MLX5_ATOMIC_MODE_DCT_CX);
+		}
+		MLX5_SET(dctc, dctc, pkey_index, attr->pkey_index);
+		MLX5_SET(dctc, dctc, port, attr->port_num);
+		MLX5_SET(dctc, dctc, counter_set_id, dev->port[attr->port_num - 1].cnts.set_id);
+
+	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
+		struct mlx5_ib_modify_qp_resp resp = {};
+		u32 min_resp_len = offsetof(typeof(resp), dctn) +
+				   sizeof(resp.dctn);
+
+		if (udata->outlen < min_resp_len)
+			return -EINVAL;
+		resp.response_length = min_resp_len;
+
+		required |= IB_QP_MIN_RNR_TIMER | IB_QP_AV | IB_QP_PATH_MTU;
+		if (!is_valid_mask(attr_mask, required, 0))
+			return -EINVAL;
+		MLX5_SET(dctc, dctc, min_rnr_nak, attr->min_rnr_timer);
+		MLX5_SET(dctc, dctc, tclass, attr->ah_attr.grh.traffic_class);
+		MLX5_SET(dctc, dctc, flow_label, attr->ah_attr.grh.flow_label);
+		MLX5_SET(dctc, dctc, mtu, attr->path_mtu);
+		MLX5_SET(dctc, dctc, my_addr_index, attr->ah_attr.grh.sgid_index);
+		MLX5_SET(dctc, dctc, hop_limit, attr->ah_attr.grh.hop_limit);
+
+		err = mlx5_core_create_dct(dev->mdev, &qp->dct.mdct, qp->dct.in,
+					   MLX5_ST_SZ_BYTES(create_dct_in));
+		if (err)
+			return err;
+		resp.dctn = qp->dct.mdct.mqp.qpn;
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err) {
+			mlx5_core_destroy_dct(dev->mdev, &qp->dct.mdct);
+			return err;
+		}
+	} else {
+		mlx5_ib_warn(dev, "Modify DCT: Invalid transition from %d to %d\n", cur_state, new_state);
+		return -EINVAL;
+	}
+	if (err)
+		qp->state = IB_QPS_ERR;
+	else
+		qp->state = new_state;
+	return err;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -3159,6 +3318,8 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		qp_type = (unlikely(ibqp->qp_type == MLX5_IB_QPT_HW_GSI)) ?
 			IB_QPT_GSI : ibqp->qp_type;
 
+	if (qp_type == MLX5_IB_QPT_DCT)
+		return mlx5_ib_modify_dct(ibqp, attr, attr_mask, udata);
 
 	mutex_lock(&qp->mutex);
 
@@ -4729,6 +4890,71 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return err;
 }
 
+static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
+				struct ib_qp_attr *qp_attr, int qp_attr_mask,
+				struct ib_qp_init_attr *qp_init_attr)
+{
+	struct mlx5_core_dct	*dct = &mqp->dct.mdct;
+	u32 *out;
+	u32 access_flags = 0;
+	int outlen = MLX5_ST_SZ_BYTES(query_dct_out);
+	void *dctc;
+	int err;
+	int supported_mask = IB_QP_STATE |
+			     IB_QP_ACCESS_FLAGS |
+			     IB_QP_PORT |
+			     IB_QP_MIN_RNR_TIMER |
+			     IB_QP_AV |
+			     IB_QP_PATH_MTU |
+			     IB_QP_PKEY_INDEX;
+
+	if (qp_attr_mask & ~supported_mask)
+		return -EINVAL;
+	if (mqp->state != IB_QPS_RTR)
+		return -EINVAL;
+
+	out = kzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	err = mlx5_core_dct_query(dev->mdev, dct, out, outlen);
+	if (err)
+		goto out;
+
+	dctc = MLX5_ADDR_OF(query_dct_out, out, dct_context_entry);
+
+	if (qp_attr_mask & IB_QP_STATE)
+		qp_attr->qp_state = IB_QPS_RTR;
+
+	if (qp_attr_mask & IB_QP_ACCESS_FLAGS) {
+		if (MLX5_GET(dctc, dctc, rre))
+			access_flags |= IB_ACCESS_REMOTE_READ;
+		if (MLX5_GET(dctc, dctc, rwe))
+			access_flags |= IB_ACCESS_REMOTE_WRITE;
+		if (MLX5_GET(dctc, dctc, rae))
+			access_flags |= IB_ACCESS_REMOTE_ATOMIC;
+		qp_attr->qp_access_flags = access_flags;
+	}
+
+	if (qp_attr_mask & IB_QP_PORT)
+		qp_attr->port_num = MLX5_GET(dctc, dctc, port);
+	if (qp_attr_mask & IB_QP_MIN_RNR_TIMER)
+		qp_attr->min_rnr_timer = MLX5_GET(dctc, dctc, min_rnr_nak);
+	if (qp_attr_mask & IB_QP_AV) {
+		qp_attr->ah_attr.grh.traffic_class = MLX5_GET(dctc, dctc, tclass);
+		qp_attr->ah_attr.grh.flow_label = MLX5_GET(dctc, dctc, flow_label);
+		qp_attr->ah_attr.grh.sgid_index = MLX5_GET(dctc, dctc, my_addr_index);
+		qp_attr->ah_attr.grh.hop_limit = MLX5_GET(dctc, dctc, hop_limit);
+	}
+	if (qp_attr_mask & IB_QP_PATH_MTU)
+		qp_attr->path_mtu = MLX5_GET(dctc, dctc, mtu);
+	if (qp_attr_mask & IB_QP_PKEY_INDEX)
+		qp_attr->pkey_index = MLX5_GET(dctc, dctc, pkey_index);
+out:
+	kfree(out);
+	return err;
+}
+
 int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		     int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
 {
@@ -4748,6 +4974,11 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	memset(qp_init_attr, 0, sizeof(*qp_init_attr));
 	memset(qp_attr, 0, sizeof(*qp_attr));
 
+	if (unlikely(ibqp->qp_type == IB_QPT_DRIVER &&
+		     qp->driver_qp_type == MLX5_IB_QPT_DCT))
+		return mlx5_ib_dct_query_qp(dev, qp, qp_attr,
+					    qp_attr_mask, qp_init_attr);
+
 	mutex_lock(&qp->mutex);
 
 	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET ||
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 83bde975d3f9..f6d319dfc7bf 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -362,6 +362,11 @@ struct mlx5_ib_create_ah_resp {
 	__u8	reserved[6];
 };
 
+struct mlx5_ib_modify_qp_resp {
+	__u32	response_length;
+	__u32	dctn;
+};
+
 struct mlx5_ib_create_wq_resp {
 	__u32	response_length;
 	__u32	reserved;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
