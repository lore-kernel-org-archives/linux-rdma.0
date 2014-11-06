From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 4/5] mlx5_ib: Add support for DC
Date: Thu,  6 Nov 2014 17:52:38 +0200
Message-ID: <1415289159-4376-5-git-send-email-eli@mellanox.com>
References: <1415289159-4376-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415289159-4376-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  19 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  24 +++
 drivers/infiniband/hw/mlx5/qp.c      | 289 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/user.h    |  41 +++++
 4 files changed, 370 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3c6fa99c4256..c805385d878d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -283,6 +283,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
+	if (gen->flags & MLX5_DEV_CAP_FLAG_DCT) {
+		props->device_cap_flags |= IB_DEVICE_DC_TRANSPORT;
+		props->dc_rd_req = 1 << gen->log_max_ra_req_dc;
+		props->dc_rd_res = 1 << gen->log_max_ra_res_dc;
+	}
 
 out:
 	kfree(in_mad);
@@ -1405,6 +1410,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
+	dev->ib_dev.uverbs_ex_cmd_mask	|=
+		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_QP);
 
 	if (mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_XRC) {
 		dev->ib_dev.alloc_xrcd = mlx5_ib_alloc_xrcd;
@@ -1417,6 +1424,18 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.uverbs_ex_cmd_mask  |=
 		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
 
+	if (mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_DCT) {
+		dev->ib_dev.create_dct = mlx5_ib_create_dct;
+		dev->ib_dev.destroy_dct = mlx5_ib_destroy_dct;
+		dev->ib_dev.query_dct = mlx5_ib_query_dct;
+		dev->ib_dev.arm_dct = mlx5_ib_arm_dct;
+		dev->ib_dev.uverbs_ex_cmd_mask |=
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_DCT)	|
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_DCT)	|
+			(1ull << IB_USER_VERBS_EX_CMD_QUERY_DCT)	|
+			(1ull << IB_USER_VERBS_EX_CMD_ARM_DCT);
+	}
+
 	err = init_node_data(dev);
 	if (err)
 		goto err_eqs;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 386780f0d1e1..5a78f2c60867 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -194,6 +194,11 @@ struct mlx5_ib_qp {
 	bool			signature_en;
 };
 
+struct mlx5_ib_dct {
+	struct ib_dct		ibdct;
+	struct mlx5_core_dct	mdct;
+};
+
 struct mlx5_ib_cq_buf {
 	struct mlx5_buf		buf;
 	struct ib_umem		*umem;
@@ -444,6 +449,16 @@ static inline struct mlx5_ib_fast_reg_page_list *to_mfrpl(struct ib_fast_reg_pag
 	return container_of(ibfrpl, struct mlx5_ib_fast_reg_page_list, ibfrpl);
 }
 
+static inline struct mlx5_ib_dct *to_mibdct(struct mlx5_core_dct *mdct)
+{
+	return container_of(mdct, struct mlx5_ib_dct, mdct);
+}
+
+static inline struct mlx5_ib_dct *to_mdct(struct ib_dct *ibdct)
+{
+	return container_of(ibdct, struct mlx5_ib_dct, ibdct);
+}
+
 struct mlx5_ib_ah {
 	struct ib_ah		ibah;
 	struct mlx5_av		av;
@@ -482,6 +497,8 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 				struct ib_udata *udata);
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata);
+int mlx5_ib_modify_qp_ex(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			 int attr_mask, struct ib_udata *udata);
 int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_mask,
 		     struct ib_qp_init_attr *qp_init_attr);
 int mlx5_ib_destroy_qp(struct ib_qp *qp);
@@ -524,6 +541,13 @@ struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 					  struct ib_ucontext *context,
 					  struct ib_udata *udata);
 int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd);
+struct ib_dct *mlx5_ib_create_dct(struct ib_pd *pd,
+				  struct ib_dct_init_attr *attr,
+				  struct ib_udata *uhw);
+int mlx5_ib_destroy_dct(struct ib_dct *dct, struct ib_udata *uhw);
+int mlx5_ib_query_dct(struct ib_dct *dct, struct ib_dct_attr *attr,
+		      struct ib_udata *uhw);
+int mlx5_ib_arm_dct(struct ib_dct *dct, struct ib_udata *uhw);
 int mlx5_vector2eqn(struct mlx5_ib_dev *dev, int vector, int *eqn, int *irqn);
 int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset);
 int mlx5_query_ext_port_caps(struct mlx5_ib_dev *dev, u8 port);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 47ca93ce214f..cc514de33444 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
+#include <linux/mlx5/mlx5_ifc.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -155,6 +156,34 @@ static void mlx5_ib_qp_event(struct mlx5_core_qp *qp, int type)
 	}
 }
 
+static void mlx5_ib_dct_event(struct mlx5_core_dct *dct, enum mlx5_event type)
+{
+	struct ib_dct *ibdct = &to_mibdct(dct)->ibdct;
+	struct ib_event event;
+
+	if (ibdct->event_handler) {
+		event.device     = ibdct->device;
+		event.element.dct = ibdct;
+		switch (type) {
+		case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+			event.event = IB_EVENT_DCT_REQ_ERR;
+			break;
+		case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+			event.event = IB_EVENT_DCT_ACCESS_ERR;
+			break;
+		case MLX5_EVENT_TYPE_DCT_KEY_VIOLATION:
+			event.event = IB_EVENT_DCT_KEY_VIOLATION;
+			break;
+		default:
+			pr_warn("mlx5_ib: Unexpected event type %d on DCT %06x\n",
+				type, dct->dctn);
+			return;
+		}
+
+		ibdct->event_handler(&event, ibdct->dct_context);
+	}
+}
+
 static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 		       int has_rq, struct mlx5_ib_qp *qp, struct mlx5_ib_create_qp *ucmd)
 {
@@ -516,6 +545,7 @@ static int to_mlx5_st(enum ib_qp_type type)
 {
 	switch (type) {
 	case IB_QPT_RC:			return MLX5_QP_ST_RC;
+	case IB_QPT_DC_INI:		return MLX5_QP_ST_DC;
 	case IB_QPT_UC:			return MLX5_QP_ST_UC;
 	case IB_QPT_UD:			return MLX5_QP_ST_UD;
 	case MLX5_IB_QPT_REG_UMR:	return MLX5_QP_ST_REG_UMR;
@@ -785,8 +815,10 @@ static void destroy_qp_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 
 static __be32 get_rx_type(struct mlx5_ib_qp *qp, struct ib_qp_init_attr *attr)
 {
-	if (attr->srq || (attr->qp_type == IB_QPT_XRC_TGT) ||
-	    (attr->qp_type == IB_QPT_XRC_INI))
+	enum ib_qp_type qt = attr->qp_type;
+
+	if (attr->srq || (qt == IB_QPT_XRC_TGT) || (qt == IB_QPT_XRC_INI) ||
+	    (qt == IB_QPT_DC_INI))
 		return cpu_to_be32(MLX5_SRQ_RQ);
 	else if (!qp->has_rq)
 		return cpu_to_be32(MLX5_ZERO_LEN_RQ);
@@ -1065,6 +1097,7 @@ static void get_cqs(struct mlx5_ib_qp *qp,
 		break;
 	case MLX5_IB_QPT_REG_UMR:
 	case IB_QPT_XRC_INI:
+	case IB_QPT_DC_INI:
 		*send_cq = to_mcq(qp->ibqp.send_cq);
 		*recv_cq = NULL;
 		break;
@@ -1150,6 +1183,8 @@ static const char *ib_qp_type_str(enum ib_qp_type type)
 		return "IB_QPT_XRC_TGT";
 	case IB_QPT_RAW_PACKET:
 		return "IB_QPT_RAW_PACKET";
+	case IB_QPT_DC_INI:
+		return "IB_QPT_DC_INI";
 	case MLX5_IB_QPT_REG_UMR:
 		return "MLX5_IB_QPT_REG_UMR";
 	case IB_QPT_MAX:
@@ -1197,6 +1232,7 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 
 		/* fall through */
 	case IB_QPT_RC:
+	case IB_QPT_DC_INI:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
 	case IB_QPT_SMI:
@@ -1581,6 +1617,9 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_DEST_QPN)
 		context->log_pg_sz_remote_qpn = cpu_to_be32(attr->dest_qp_num);
 
+	if (attr_mask & IB_QP_DC_KEY)
+		context->dc_access_key = cpu_to_be64(attr->dct_key);
+
 	if (attr_mask & IB_QP_PKEY_INDEX)
 		context->pri_path.pkey_index = attr->pkey_index;
 
@@ -2972,7 +3011,9 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 	qp_attr->qp_access_flags     =
 		to_ib_qp_access_flags(be32_to_cpu(context->params2));
 
-	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC) {
+	if (qp->ibqp.qp_type == IB_QPT_RC ||
+	    qp->ibqp.qp_type == IB_QPT_UC ||
+	    qp->ibqp.qp_type == IB_QPT_DC_INI) {
 		to_ib_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
 		to_ib_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
 		qp_attr->alt_pkey_index = context->alt_path.pkey_index & 0x7f;
@@ -3071,3 +3112,245 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 
 	return 0;
 }
+
+static void set_dct_access(void *dctx, struct mlx5_ib_dev *dev, u32 ib_flags)
+{
+	if (ib_flags & IB_ACCESS_REMOTE_READ)
+		MLX5_SET(dctc, dctx, rre, 1);
+
+	if (ib_flags & IB_ACCESS_REMOTE_WRITE)
+		MLX5_SET(dctc, dctx, rwe, 1);
+
+	if (ib_flags & IB_ACCESS_REMOTE_ATOMIC) {
+		MLX5_SET(dctc, dctx, rre, 1);
+		MLX5_SET(dctc, dctx, rwe, 1);
+		MLX5_SET(dctc, dctx, rae, 1);
+	}
+}
+
+struct ib_dct *mlx5_ib_create_dct(struct ib_pd *pd,
+				  struct ib_dct_init_attr *attr,
+				  struct ib_udata *uhw)
+{
+	void *in;
+	int in_sz = MLX5_ST_SZ_BYTES(create_dct_in);
+	void *dctx;
+	struct mlx5_ib_dev *dev;
+	struct mlx5_ib_dct *dct;
+	struct mlx5_ib_create_dct ucmd;
+	struct mlx5_ib_create_dct_resp resp;
+	int cqe_sz;
+	u32 cqn;
+	int err;
+
+	if (uhw) {
+		err = ib_copy_from_udata(&ucmd, uhw, sizeof(ucmd));
+		if (err) {
+			mlx5_ib_dbg(dev, "copy failed\n");
+			return ERR_PTR(err);
+		}
+
+		if (ucmd.reserved0 || ucmd.reserved1)
+			return ERR_PTR(-EINVAL);
+	}
+	dev = to_mdev(pd->device);
+	dct = kzalloc(sizeof(*dct), GFP_KERNEL);
+	if (!dct)
+		return ERR_PTR(-ENOMEM);
+
+	in = kzalloc(in_sz, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	dctx = MLX5_ADDR_OF(create_dct_in, in, dct_context_entry);
+
+	cqn = to_mcq(attr->cq)->mcq.cqn;
+	MLX5_SET(dctc, dctx, cqn, cqn);
+	set_dct_access(dctx, dev, attr->access_flags);
+
+	if (attr->inline_size) {
+		cqe_sz = mlx5_ib_get_cqe_size(dev, attr->cq);
+		if (cqe_sz == 128) {
+			MLX5_SET(dctc, dctx, cs_res, MLX5_DCT_CS_RES_64);
+			attr->inline_size = 64;
+		} else {
+			attr->inline_size = 0;
+		}
+	}
+	MLX5_SET(dctc, dctx, min_rnr_nak, attr->min_rnr_timer);
+	MLX5_SET(dctc, dctx, srqn, to_msrq(attr->srq)->msrq.srqn);
+	MLX5_SET(dctc, dctx, pd, to_mpd(pd)->pdn);
+	MLX5_SET(dctc, dctx, tclass, attr->tclass);
+	MLX5_SET(dctc, dctx, flow_label, attr->flow_label);
+	MLX5_SET64(dctc, dctx, dc_access_key, attr->dc_key);
+	MLX5_SET(dctc, dctx, mtu, attr->mtu);
+	MLX5_SET(dctc, dctx, port, attr->port);
+	MLX5_SET(dctc, dctx, pkey_index, attr->pkey_index);
+	MLX5_SET(dctc, dctx, my_addr_index, attr->gid_index);
+	MLX5_SET(dctc, dctx, hop_limit, attr->hop_limit);
+
+	err = mlx5_core_create_dct(dev->mdev, &dct->mdct, in);
+	if (err)
+		goto err_alloc;
+
+	dct->ibdct.dct_num = dct->mdct.dctn;
+	dct->mdct.event = mlx5_ib_dct_event;
+	kfree(in);
+
+	if (uhw) {
+		memset(&resp, 0, sizeof(resp));
+		err = ib_copy_to_udata(uhw, &resp, sizeof(resp));
+		if (err) {
+			mlx5_ib_dbg(dev, "copy failed\n");
+			return ERR_PTR(err);
+		}
+	}
+
+	return &dct->ibdct;
+
+err_alloc:
+	kfree(in);
+	kfree(dct);
+	return ERR_PTR(err);
+}
+
+int mlx5_ib_destroy_dct(struct ib_dct *dct, struct ib_udata *uhw)
+{
+	struct mlx5_ib_dev *dev = to_mdev(dct->device);
+	struct mlx5_ib_dct *mdct = to_mdct(dct);
+	struct mlx5_ib_destroy_dct ucmd;
+	struct mlx5_ib_destroy_dct_resp resp;
+	int err;
+
+	if (uhw) {
+		err = ib_copy_from_udata(&ucmd, uhw, sizeof(ucmd));
+		if (err) {
+			mlx5_ib_dbg(dev, "copy failed\n");
+			return err;
+		}
+
+		if (ucmd.reserved0 || ucmd.reserved1)
+			return -EINVAL;
+	}
+	err = mlx5_core_destroy_dct(dev->mdev, &mdct->mdct);
+	if (!err)
+		kfree(mdct);
+
+	if (uhw) {
+		memset(&resp, 0, sizeof(resp));
+		err = ib_copy_to_udata(uhw, &resp, sizeof(resp));
+		if (err)
+			mlx5_ib_dbg(dev, "copy failed\n");
+	}
+
+	return err;
+}
+
+static void dct_to_ib_access(void *out, u32 *access_flags)
+{
+	u32 flags = 0;
+	void *dctc = MLX5_ADDR_OF(query_dct_out, out, dct_context_entry);
+
+	if (MLX5_GET(dctc, dctc, rre))
+		flags |= IB_ACCESS_REMOTE_READ;
+	if (MLX5_GET(dctc, dctc, rwe))
+		flags |= IB_ACCESS_REMOTE_WRITE;
+	if (MLX5_GET(dctc, dctc, atomic_mode) == MLX5_ATOMIC_MODE_CX)
+		flags |= IB_ACCESS_REMOTE_ATOMIC;
+
+	*access_flags = flags;
+}
+
+int mlx5_ib_query_dct(struct ib_dct *dct, struct ib_dct_attr *attr,
+		      struct ib_udata *uhw)
+{
+	struct mlx5_ib_dev *dev = to_mdev(dct->device);
+	struct mlx5_ib_dct *mdct = to_mdct(dct);
+	int out_sz = MLX5_ST_SZ_BYTES(query_dct_out);
+	struct mlx5_ib_query_dct ucmd;
+	struct mlx5_ib_query_dct_resp resp;
+	void *dctc;
+	void *out;
+	int err;
+
+	if (uhw) {
+		err = ib_copy_from_udata(&ucmd, uhw, sizeof(ucmd));
+		if (err) {
+			mlx5_ib_dbg(dev, "copy failed\n");
+			return err;
+		}
+
+		if (ucmd.reserved0 || ucmd.reserved1)
+			return -EINVAL;
+	}
+
+	out = kzalloc(out_sz, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	err = mlx5_core_dct_query(dev->mdev, &mdct->mdct, out);
+	if (err)
+		goto out;
+
+	dctc = MLX5_ADDR_OF(query_dct_out, out, dct_context_entry);
+
+	attr->dc_key = MLX5_GET64(dctc, dctc, dc_access_key);
+	attr->port = MLX5_GET(dctc, dctc, port);
+	dct_to_ib_access(out, &attr->access_flags);
+	attr->min_rnr_timer = MLX5_GET(dctc, dctc, min_rnr_nak);
+	attr->tclass = MLX5_GET(dctc, dctc, tclass);
+	attr->flow_label = MLX5_GET(dctc, dctc, flow_label);
+	attr->mtu = MLX5_GET(dctc, dctc, mtu);
+	attr->pkey_index = MLX5_GET(dctc, dctc, pkey_index);
+	attr->gid_index = MLX5_GET(dctc, dctc, my_addr_index);
+	attr->hop_limit = MLX5_GET(dctc, dctc, hop_limit);
+	attr->key_violations = MLX5_GET(dctc, dctc, dc_access_key_violation_count);
+	attr->state = MLX5_GET(dctc, dctc, state);
+
+	if (uhw) {
+		memset(&resp, 0, sizeof(resp));
+		err = ib_copy_to_udata(uhw, &resp, sizeof(resp));
+		if (err)
+			mlx5_ib_dbg(dev, "copy failed\n");
+	}
+
+out:
+	kfree(out);
+	return err;
+}
+
+int mlx5_ib_arm_dct(struct ib_dct *dct, struct ib_udata *uhw)
+{
+	struct mlx5_ib_dev *dev = to_mdev(dct->device);
+	struct mlx5_ib_dct *mdct = to_mdct(dct);
+	struct mlx5_ib_arm_dct ucmd;
+	struct mlx5_ib_arm_dct_resp resp;
+	int err;
+
+	if (uhw) {
+		err = ib_copy_from_udata(&ucmd, uhw, sizeof(ucmd));
+		if (err) {
+			mlx5_ib_dbg(dev, "copy failed\n");
+			return err;
+		}
+
+		if (ucmd.reserved0 || ucmd.reserved1)
+			return -EINVAL;
+	}
+
+	err = mlx5_core_arm_dct(dev->mdev, &mdct->mdct);
+	if (err)
+		goto out;
+
+	if (uhw) {
+		memset(&resp, 0, sizeof(resp));
+		err = ib_copy_to_udata(uhw, &resp, sizeof(resp));
+		if (err)
+			mlx5_ib_dbg(dev, "copy failed\n");
+	}
+
+out:
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index d0ba264ac1ed..1aecd0ac9844 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -130,4 +130,45 @@ struct mlx5_ib_create_qp {
 struct mlx5_ib_create_qp_resp {
 	__u32	uuar_index;
 };
+
+struct mlx5_ib_arm_dct {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_arm_dct_resp {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_create_dct {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_create_dct_resp {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_destroy_dct {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_destroy_dct_resp {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_query_dct {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
+struct mlx5_ib_query_dct_resp {
+	__u64	reserved0;
+	__u64	reserved1;
+};
+
 #endif /* MLX5_IB_USER_H */
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
