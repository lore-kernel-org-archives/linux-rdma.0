From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 10/10] IB/mlx5: Add RSS QP support
Date: Sun, 17 Apr 2016 17:27:17 +0300
Message-ID: <1460903237-16870-11-git-send-email-yishaih@mellanox.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903237-16870-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for Raw Ethernet RX HASH QP. Currently, creation and
destruction of such a QP are supported. This QP is implemented as
a simple TIR object which points to the receive RQ indirection table.
The given hashing configuration is used to configure the TIR and by
that it chooses the right RQ from the RQ indirection table.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   5 +
 drivers/infiniband/hw/mlx5/qp.c      | 183 +++++++++++++++++++++++++++++++++++
 2 files changed, 188 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7c4769a..072db4a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -293,6 +293,10 @@ struct mlx5_ib_qp_trans {
 	u8			resp_depth;
 };
 
+struct mlx5_ib_rss_qp {
+	u32	tirn;
+};
+
 struct mlx5_ib_rq {
 	struct mlx5_ib_qp_base base;
 	struct mlx5_ib_wq	*rq;
@@ -321,6 +325,7 @@ struct mlx5_ib_qp {
 	union {
 		struct mlx5_ib_qp_trans trans_qp;
 		struct mlx5_ib_raw_packet_qp raw_packet_qp;
+		struct mlx5_ib_rss_qp rss_qp;
 	};
 	struct mlx5_buf		buf;
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 67c7ad3..6b8fbc6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1259,6 +1259,170 @@ static void raw_packet_qp_copy_info(struct mlx5_ib_qp *qp,
 	rq->doorbell = &qp->db;
 }
 
+static void destroy_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
+{
+	mlx5_core_destroy_tir(dev->mdev, qp->rss_qp.tirn);
+}
+
+static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
+				 struct ib_pd *pd,
+				 struct ib_qp_init_attr *init_attr,
+				 struct ib_udata *udata)
+{
+	struct ib_uobject *uobj = pd->uobject;
+	struct ib_ucontext *ucontext = uobj->context;
+	struct mlx5_ib_ucontext *mucontext = to_mucontext(ucontext);
+	struct mlx5_ib_create_qp_resp resp = {};
+	int inlen;
+	int err;
+	u32 *in;
+	void *tirc;
+	void *hfso;
+	u32 selected_fields = 0;
+	size_t min_resp_len;
+	u32 tdn = mucontext->tdn;
+
+	if (init_attr->qp_type != IB_QPT_RAW_PACKET)
+		return -EOPNOTSUPP;
+
+	if (init_attr->create_flags || init_attr->recv_cq || init_attr->send_cq ||
+	    init_attr->srq || init_attr->xrcd ||
+	    memchr_inv(&init_attr->cap, 0, sizeof(init_attr->cap)))
+		return -EINVAL;
+
+	min_resp_len = offsetof(typeof(resp), uuar_index) + sizeof(resp.uuar_index);
+	if (udata->outlen < min_resp_len)
+		return -EINVAL;
+
+	if (udata->inlen > 0 &&
+	    !ib_is_udata_cleared(udata, 0,
+				 udata->inlen)) {
+		mlx5_ib_dbg(dev, "no udata is expected for rss qp\n");
+		return -EINVAL;
+	}
+
+	err = ib_copy_to_udata(udata, &resp, min_resp_len);
+	if (err) {
+		mlx5_ib_dbg(dev, "copy failed\n");
+		return -EINVAL;
+	}
+
+	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
+	MLX5_SET(tirc, tirc, disp_type,
+		 MLX5_TIRC_DISP_TYPE_INDIRECT);
+	MLX5_SET(tirc, tirc, indirect_table,
+		 init_attr->rx_hash_conf->rwq_ind_tbl->ind_tbl_num);
+	MLX5_SET(tirc, tirc, transport_domain, tdn);
+
+	hfso = MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_outer);
+	switch (init_attr->rx_hash_conf->rx_hash_function) {
+	case IB_RX_HASH_FUNC_XOR:
+		err = -ENOSYS;
+		goto err;
+
+	case IB_RX_HASH_FUNC_TOEPLITZ:
+	{
+		void *rss_key = MLX5_ADDR_OF(tirc, tirc, rx_hash_toeplitz_key);
+		size_t len = MLX5_FLD_SZ_BYTES(tirc, rx_hash_toeplitz_key);
+
+		if (len != init_attr->rx_hash_conf->rx_key_len) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_TOEPLITZ);
+		MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
+		memcpy(rss_key, init_attr->rx_hash_conf->rx_hash_key, len);
+		break;
+	}
+	default:
+		err = -EINVAL;
+		goto err;
+	}
+
+	if (!init_attr->rx_hash_conf->rx_hash_fields_mask) {
+		/* special case when this TIR serves as steering entry without hashing */
+		if (!init_attr->rx_hash_conf->rwq_ind_tbl->log_ind_tbl_size)
+			goto create_tir;
+		err = -EINVAL;
+		goto err;
+	}
+
+	if (((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_IPV4) ||
+	     (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_IPV4)) &&
+	     ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_IPV6) ||
+	     (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_IPV6))) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* If none of IPV4 & IPV6 SRC/DST was set - this bit field is ignored */
+	if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_IPV4) ||
+	    (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_IPV4))
+		MLX5_SET(rx_hash_field_select, hfso, l3_prot_type,
+			 MLX5_L3_PROT_TYPE_IPV4);
+	else if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_IPV6) ||
+		 (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_IPV6))
+		MLX5_SET(rx_hash_field_select, hfso, l3_prot_type,
+			 MLX5_L3_PROT_TYPE_IPV6);
+
+	if (((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_PORT_TCP) ||
+	     (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_PORT_TCP)) &&
+	     ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_PORT_UDP) ||
+	     (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_PORT_UDP))) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* If none of TCP & UDP SRC/DST was set - this bit field is ignored */
+	if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_PORT_TCP) ||
+	    (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_PORT_TCP))
+		MLX5_SET(rx_hash_field_select, hfso, l4_prot_type,
+			 MLX5_L4_PROT_TYPE_TCP);
+	else if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_PORT_UDP) ||
+		 (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_PORT_UDP))
+		MLX5_SET(rx_hash_field_select, hfso, l4_prot_type,
+			 MLX5_L4_PROT_TYPE_UDP);
+
+	if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_IPV4) ||
+	    (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_IPV6))
+		selected_fields |= MLX5_HASH_FIELD_SEL_SRC_IP;
+
+	if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_IPV4) ||
+	    (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_IPV6))
+		selected_fields |= MLX5_HASH_FIELD_SEL_DST_IP;
+
+	if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_PORT_TCP) ||
+	    (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_SRC_PORT_UDP))
+		selected_fields |= MLX5_HASH_FIELD_SEL_L4_SPORT;
+
+	if ((init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_PORT_TCP) ||
+	    (init_attr->rx_hash_conf->rx_hash_fields_mask & IB_RX_HASH_DST_PORT_UDP))
+		selected_fields |= MLX5_HASH_FIELD_SEL_L4_DPORT;
+
+	MLX5_SET(rx_hash_field_select, hfso, selected_fields, selected_fields);
+
+create_tir:
+	err = mlx5_core_create_tir(dev->mdev, in, inlen, &qp->rss_qp.tirn);
+
+	if (err)
+		goto err;
+
+	kvfree(in);
+	/* qpn is reserved for that QP */
+	qp->trans_qp.base.mqp.qpn = 0;
+	return 0;
+
+err:
+	kvfree(in);
+	return err;
+}
+
 static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, struct mlx5_ib_qp *qp)
@@ -1285,6 +1449,14 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
 
+	if (init_attr->rx_hash_conf) {
+		if (!udata)
+			return -ENOSYS;
+
+		err = create_rss_raw_qp_tir(dev, qp, pd, init_attr, udata);
+		return err;
+	}
+
 	if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
 		if (!MLX5_CAP_GEN(mdev, block_lb_mc)) {
 			mlx5_ib_dbg(dev, "block multicast loopback isn't supported\n");
@@ -1624,6 +1796,11 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 	struct mlx5_modify_qp_mbox_in *in;
 	int err;
 
+	if (qp->ibqp.rwq_ind_tbl) {
+		destroy_rss_raw_qp_tir(dev, qp);
+		return;
+	}
+
 	base = qp->ibqp.qp_type == IB_QPT_RAW_PACKET ?
 	       &qp->raw_packet_qp.rq.base :
 	       &qp->trans_qp.base;
@@ -2480,6 +2657,9 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int port;
 	enum rdma_link_layer ll = IB_LINK_LAYER_UNSPECIFIED;
 
+	if (ibqp->rwq_ind_tbl)
+		return -ENOSYS;
+
 	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_modify_qp(ibqp, attr, attr_mask);
 
@@ -4094,6 +4274,9 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	int err = 0;
 	u8 raw_packet_qp_state;
 
+	if (ibqp->rwq_ind_tbl)
+		return -ENOSYS;
+
 	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_query_qp(ibqp, qp_attr, qp_attr_mask,
 					    qp_init_attr);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
