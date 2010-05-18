From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2 3/4] mlx4: XRC base implementation
Date: Tue, 18 May 2010 14:56:17 +0300
Message-ID: <201005181456.17214.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Support for XRC base implementation in mlx4 low-level driver.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      |   37 ++++++++++++++++-
 drivers/infiniband/hw/mlx4/main.c    |   52 +++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   16 ++++++++
 drivers/infiniband/hw/mlx4/qp.c      |   49 +++++++++++++++++------
 drivers/infiniband/hw/mlx4/srq.c     |   39 ++++++++++++++++--
 drivers/net/mlx4/Makefile            |    2 +-
 drivers/net/mlx4/fw.c                |    7 +++
 drivers/net/mlx4/fw.h                |    2 +
 drivers/net/mlx4/main.c              |   21 ++++++++++-
 drivers/net/mlx4/mlx4.h              |    4 +-
 drivers/net/mlx4/qp.c                |    2 +
 drivers/net/mlx4/srq.c               |   46 ++++++++++++++--------
 drivers/net/mlx4/xrcd.c              |   70 ++++++++++++++++++++++++++++++++++
 include/linux/mlx4/device.h          |   11 ++++-
 include/linux/mlx4/qp.h              |    3 +-
 include/linux/mlx4/srq.h             |   12 ++++++
 16 files changed, 330 insertions(+), 43 deletions(-)
 create mode 100644 drivers/net/mlx4/xrcd.c

Index: infiniband/drivers/infiniband/hw/mlx4/cq.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/cq.c
+++ infiniband/drivers/infiniband/hw/mlx4/cq.c
@@ -33,6 +33,7 @@
 
 #include <linux/mlx4/cq.h>
 #include <linux/mlx4/qp.h>
+#include <linux/mlx4/srq.h>
 #include <linux/slab.h>
 
 #include "mlx4_ib.h"
@@ -545,9 +546,11 @@ static int mlx4_ib_poll_one(struct mlx4_
 	struct mlx4_qp *mqp;
 	struct mlx4_ib_wq *wq;
 	struct mlx4_ib_srq *srq;
+	struct mlx4_srq *msrq;
 	int is_send;
 	int is_error;
 	u32 g_mlpath_rqpn;
+	int is_xrc_recv = 0;
 	u16 wqe_ctr;
 
 repoll:
@@ -589,7 +592,24 @@ repoll:
 		goto repoll;
 	}
 
-	if (!*cur_qp ||
+	if ((be32_to_cpu(cqe->vlan_my_qpn) & (1 << 23)) && !is_send) {
+		 /*
+		  * We do not have to take the XRC SRQ table lock here,
+		  * because CQs will be locked while XRC SRQs are removed
+		  * from the table.
+		  */
+		 msrq = __mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
+					 be32_to_cpu(cqe->g_mlpath_rqpn) &
+					 0xffffff);
+		 if (unlikely(!msrq)) {
+			 printk(KERN_WARNING "CQ %06x with entry for unknown "
+				"XRC SRQ %06x\n", cq->mcq.cqn,
+				be32_to_cpu(cqe->g_mlpath_rqpn) & 0xffffff);
+			 return -EINVAL;
+		 }
+		 is_xrc_recv = 1;
+		 srq = to_mibsrq(msrq);
+	} else if (!*cur_qp ||
 	    (be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) != (*cur_qp)->mqp.qpn) {
 		/*
 		 * We do not have to take the QP table lock here,
@@ -607,7 +627,7 @@ repoll:
 		*cur_qp = to_mibqp(mqp);
 	}
 
-	wc->qp = &(*cur_qp)->ibqp;
+	wc->qp = is_xrc_recv ? NULL: &(*cur_qp)->ibqp;
 
 	if (is_send) {
 		wq = &(*cur_qp)->sq;
@@ -617,6 +637,10 @@ repoll:
 		}
 		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
+	} else if (is_xrc_recv) {
+		wqe_ctr = be16_to_cpu(cqe->wqe_index);
+		wc->wr_id = srq->wrid[wqe_ctr];
+		mlx4_ib_free_srq_wqe(srq, wqe_ctr);
 	} else if ((*cur_qp)->ibqp.srq) {
 		srq = to_msrq((*cur_qp)->ibqp.srq);
 		wqe_ctr = be16_to_cpu(cqe->wqe_index);
@@ -756,6 +780,10 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_c
 	int nfreed = 0;
 	struct mlx4_cqe *cqe, *dest;
 	u8 owner_bit;
+	int is_xrc_srq = 0;
+
+	if (srq && srq->ibsrq.xrc_cq)
+		is_xrc_srq = 1;
 
 	/*
 	 * First we need to find the current producer index, so we
@@ -774,7 +802,10 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_c
 	 */
 	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
-		if ((be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) == qpn) {
+		if (((be32_to_cpu(cqe->vlan_my_qpn) & 0xffffff) == qpn) ||
+		    (is_xrc_srq &&
+		     (be32_to_cpu(cqe->g_mlpath_rqpn) & 0xffffff) ==
+		      srq->msrq.srqn)) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_ib_free_srq_wqe(srq, be16_to_cpu(cqe->wqe_index));
 			++nfreed;
Index: infiniband/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/main.c
+++ infiniband/drivers/infiniband/hw/mlx4/main.c
@@ -112,6 +112,8 @@ static int mlx4_ib_query_device(struct i
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
 		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC)
+		props->device_cap_flags |= IB_DEVICE_XRC;
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
@@ -460,6 +462,46 @@ static int mlx4_ib_mcg_detach(struct ib_
 				     &to_mqp(ibqp)->mqp, gid->raw);
 }
 
+static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
+					  struct ib_ucontext *context,
+					  struct ib_udata *udata)
+{
+	struct mlx4_ib_xrcd *xrcd;
+	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
+	int err;
+
+	if (!(mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+		return ERR_PTR(-ENOSYS);
+
+	xrcd = kmalloc(sizeof *xrcd, GFP_KERNEL);
+	if (!xrcd)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_xrcd_alloc(mdev->dev, &xrcd->xrcdn);
+	if (err) {
+		kfree(xrcd);
+		return ERR_PTR(err);
+	}
+
+	if (context)
+		if (ib_copy_to_udata(udata, &xrcd->xrcdn, sizeof(__u32))) {
+			mlx4_xrcd_free(mdev->dev, xrcd->xrcdn);
+			kfree(xrcd);
+			return ERR_PTR(-EFAULT);
+		}
+
+	return &xrcd->ibxrcd;
+}
+
+static int mlx4_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
+{
+	mlx4_xrcd_free(to_mdev(xrcd->device)->dev, to_mxrcd(xrcd)->xrcdn);
+	kfree(xrcd);
+
+	return 0;
+}
+
+
 static int init_node_data(struct mlx4_ib_dev *dev)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -654,6 +696,16 @@ static void *mlx4_ib_add(struct mlx4_dev
 	ibdev->ib_dev.map_phys_fmr	= mlx4_ib_map_phys_fmr;
 	ibdev->ib_dev.unmap_fmr		= mlx4_ib_unmap_fmr;
 	ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) {
+		ibdev->ib_dev.create_xrc_srq = mlx4_ib_create_xrc_srq;
+		ibdev->ib_dev.alloc_xrcd = mlx4_ib_alloc_xrcd;
+		ibdev->ib_dev.dealloc_xrcd = mlx4_ib_dealloc_xrcd;
+		ibdev->ib_dev.uverbs_cmd_mask |=
+			(1ull << IB_USER_VERBS_CMD_CREATE_XRC_SRQ)	|
+			(1ull << IB_USER_VERBS_CMD_OPEN_XRCD)	|
+			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
+	}
+
 
 	if (init_node_data(ibdev))
 		goto err_map;
Index: infiniband/drivers/infiniband/hw/mlx4/mlx4_ib.h
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ infiniband/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -56,6 +56,11 @@ struct mlx4_ib_pd {
 	u32			pdn;
 };
 
+struct mlx4_ib_xrcd {
+	struct ib_xrcd	ibxrcd;
+	u32		xrcdn;
+};
+
 struct mlx4_ib_cq_buf {
 	struct mlx4_buf		buf;
 	struct mlx4_mtt		mtt;
@@ -132,6 +137,7 @@ struct mlx4_ib_qp {
 	int			buf_size;
 	struct mutex		mutex;
 	u32			flags;
+	u16			xrcdn;
 	u8			port;
 	u8			alt_port;
 	u8			atomic_rd_en;
@@ -193,6 +199,11 @@ static inline struct mlx4_ib_pd *to_mpd(
 	return container_of(ibpd, struct mlx4_ib_pd, ibpd);
 }
 
+static inline struct mlx4_ib_xrcd *to_mxrcd(struct ib_xrcd *ibxrcd)
+{
+	return container_of(ibxrcd, struct mlx4_ib_xrcd, ibxrcd);
+}
+
 static inline struct mlx4_ib_cq *to_mcq(struct ib_cq *ibcq)
 {
 	return container_of(ibcq, struct mlx4_ib_cq, ibcq);
@@ -277,6 +288,11 @@ int mlx4_ib_destroy_ah(struct ib_ah *ah)
 struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 				  struct ib_srq_init_attr *init_attr,
 				  struct ib_udata *udata);
+struct ib_srq *mlx4_ib_create_xrc_srq(struct ib_pd *pd,
+				      struct ib_cq *xrc_cq,
+				      struct ib_xrcd *xrcd,
+				      struct ib_srq_init_attr *init_attr,
+				      struct ib_udata *udata);
 int mlx4_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		       enum ib_srq_attr_mask attr_mask, struct ib_udata *udata);
 int mlx4_ib_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr);
Index: infiniband/drivers/infiniband/hw/mlx4/qp.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/qp.c
+++ infiniband/drivers/infiniband/hw/mlx4/qp.c
@@ -268,6 +268,7 @@ static int send_wqe_overhead(enum ib_qp_
 	case IB_QPT_UC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_raddr_seg);
+	case IB_QPT_XRC:
 	case IB_QPT_RC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_atomic_seg) +
@@ -289,14 +290,14 @@ static int send_wqe_overhead(enum ib_qp_
 }
 
 static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
-		       int is_user, int has_srq, struct mlx4_ib_qp *qp)
+		       int is_user, int has_srq_or_is_xrc, struct mlx4_ib_qp *qp)
 {
 	/* Sanity check RQ size before proceeding */
 	if (cap->max_recv_wr  > dev->dev->caps.max_wqes  ||
 	    cap->max_recv_sge > dev->dev->caps.max_rq_sg)
 		return -EINVAL;
 
-	if (has_srq) {
+	if (has_srq_or_is_xrc) {
 		/* QPs attached to an SRQ should have no RQ */
 		if (cap->max_recv_wr)
 			return -EINVAL;
@@ -465,7 +466,8 @@ static int create_qp_common(struct mlx4_
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
 
-	err = set_rq_size(dev, &init_attr->cap, !!pd->uobject, !!init_attr->srq, qp);
+	err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
+			  !!init_attr->srq || !!init_attr->xrcd , qp);
 	if (err)
 		goto err;
 
@@ -499,7 +501,7 @@ static int create_qp_common(struct mlx4_
 		if (err)
 			goto err_mtt;
 
-		if (!init_attr->srq) {
+		if (!init_attr->srq && init_attr->qp_type != IB_QPT_XRC) {
 			err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
 						  ucmd.db_addr, &qp->db);
 			if (err)
@@ -518,7 +520,7 @@ static int create_qp_common(struct mlx4_
 		if (err)
 			goto err;
 
-		if (!init_attr->srq) {
+		if (!init_attr->srq && init_attr->qp_type != IB_QPT_XRC) {
 			err = mlx4_db_alloc(dev->dev, &qp->db, 0);
 			if (err)
 				goto err;
@@ -561,6 +563,9 @@ static int create_qp_common(struct mlx4_
 	if (err)
 		goto err_qpn;
 
+	if (init_attr->qp_type == IB_QPT_XRC)
+		qp->mqp.qpn |= (1 << 23);
+
 	/*
 	 * Hardware wants QPN written in big-endian order (after
 	 * shifting) for send doorbell.  Precompute this value to save
@@ -578,7 +583,7 @@ err_qpn:
 
 err_wrid:
 	if (pd->uobject) {
-		if (!init_attr->srq)
+		if (!init_attr->srq && init_attr->qp_type != IB_QPT_XRC)
 			mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context),
 					      &qp->db);
 	} else {
@@ -596,7 +601,7 @@ err_buf:
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
 
 err_db:
-	if (!pd->uobject && !init_attr->srq)
+	if (!pd->uobject && !init_attr->srq && init_attr->qp_type != IB_QPT_XRC)
 		mlx4_db_free(dev->dev, &qp->db);
 
 err:
@@ -682,7 +687,7 @@ static void destroy_qp_common(struct mlx
 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
 
 	if (is_user) {
-		if (!qp->ibqp.srq)
+		if (!qp->ibqp.srq && qp->ibqp.qp_type != IB_QPT_XRC)
 			mlx4_ib_db_unmap_user(to_mucontext(qp->ibqp.uobject->context),
 					      &qp->db);
 		ib_umem_release(qp->umem);
@@ -690,7 +695,7 @@ static void destroy_qp_common(struct mlx
 		kfree(qp->sq.wrid);
 		kfree(qp->rq.wrid);
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
-		if (!qp->ibqp.srq)
+		if (!qp->ibqp.srq && qp->ibqp.qp_type != IB_QPT_XRC)
 			mlx4_db_free(dev->dev, &qp->db);
 	}
 }
@@ -717,6 +722,9 @@ struct ib_qp *mlx4_ib_create_qp(struct i
 		return ERR_PTR(-EINVAL);
 
 	switch (init_attr->qp_type) {
+	case IB_QPT_XRC:
+		if (!(dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+			return ERR_PTR(-ENOSYS);
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
@@ -731,6 +739,11 @@ struct ib_qp *mlx4_ib_create_qp(struct i
 			return ERR_PTR(err);
 		}
 
+		if (init_attr->qp_type == IB_QPT_XRC)
+			qp->xrcdn = to_mxrcd(init_attr->xrcd)->xrcdn;
+		else
+			qp->xrcdn = 0;
+
 		qp->ibqp.qp_num = qp->mqp.qpn;
 
 		break;
@@ -795,6 +808,7 @@ static int to_mlx4_st(enum ib_qp_type ty
 	case IB_QPT_RC:		return MLX4_QP_ST_RC;
 	case IB_QPT_UC:		return MLX4_QP_ST_UC;
 	case IB_QPT_UD:		return MLX4_QP_ST_UD;
+	case IB_QPT_XRC:	return MLX4_QP_ST_XRC;
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:	return MLX4_QP_ST_MLX;
 	default:		return -1;
@@ -944,8 +958,11 @@ static int __mlx4_ib_modify_qp(struct ib
 		context->sq_size_stride = ilog2(qp->sq.wqe_cnt) << 3;
 	context->sq_size_stride |= qp->sq.wqe_shift - 4;
 
-	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		context->sq_size_stride |= !!qp->sq_no_prefetch << 7;
+		if (ibqp->qp_type == IB_QPT_XRC)
+			context->xrcd = cpu_to_be32((u32) qp->xrcdn);
+	}
 
 	if (qp->ibqp.uobject)
 		context->usr_page = cpu_to_be32(to_mucontext(ibqp->uobject->context)->uar.index);
@@ -1061,7 +1078,8 @@ static int __mlx4_ib_modify_qp(struct ib
 	if (ibqp->srq)
 		context->srqn = cpu_to_be32(1 << 24 | to_msrq(ibqp->srq)->msrq.srqn);
 
-	if (!ibqp->srq && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (!ibqp->srq && ibqp->qp_type != IB_QPT_XRC &&
+	    cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
 		context->db_rec_addr = cpu_to_be64(qp->db.dma);
 
 	if (cur_state == IB_QPS_INIT &&
@@ -1154,7 +1172,7 @@ static int __mlx4_ib_modify_qp(struct ib
 		qp->sq.head = 0;
 		qp->sq.tail = 0;
 		qp->sq_next_wqe = 0;
-		if (!ibqp->srq)
+		if (!ibqp->srq && ibqp->qp_type != IB_QPT_XRC)
 			*qp->db.db  = 0;
 	}
 
@@ -1562,6 +1580,10 @@ int mlx4_ib_post_send(struct ib_qp *ibqp
 		size = sizeof *ctrl / 16;
 
 		switch (ibqp->qp_type) {
+		case IB_QPT_XRC:
+			ctrl->srcrb_flags |=
+				cpu_to_be32(wr->xrc_remote_srq_num << 8);
+			/* fall thru */
 		case IB_QPT_RC:
 		case IB_QPT_UC:
 			switch (wr->opcode) {
@@ -1900,7 +1922,8 @@ int mlx4_ib_query_qp(struct ib_qp *ibqp,
 	qp_attr->qp_access_flags     =
 		to_ib_qp_access_flags(be32_to_cpu(context.params2));
 
-	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC) {
+	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC ||
+	    qp->ibqp.qp_type == IB_QPT_XRC) {
 		to_ib_ah_attr(dev->dev, &qp_attr->ah_attr, &context.pri_path);
 		to_ib_ah_attr(dev->dev, &qp_attr->alt_ah_attr, &context.alt_path);
 		qp_attr->alt_pkey_index = context.alt_path.pkey_index & 0x7f;
Index: infiniband/drivers/infiniband/hw/mlx4/srq.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/srq.c
+++ infiniband/drivers/infiniband/hw/mlx4/srq.c
@@ -68,14 +68,18 @@ static void mlx4_ib_srq_event(struct mlx
 	}
 }
 
-struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
-				  struct ib_srq_init_attr *init_attr,
-				  struct ib_udata *udata)
+struct ib_srq *mlx4_ib_create_xrc_srq(struct ib_pd *pd,
+				      struct ib_cq *xrc_cq,
+				      struct ib_xrcd *xrcd,
+				      struct ib_srq_init_attr *init_attr,
+				      struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(pd->device);
 	struct mlx4_ib_srq *srq;
 	struct mlx4_wqe_srq_next_seg *next;
 	struct mlx4_wqe_data_seg *scatter;
+	u32	cqn;
+	u16	xrcdn;
 	int desc_size;
 	int buf_size;
 	int err;
@@ -174,18 +178,24 @@ struct ib_srq *mlx4_ib_create_srq(struct
 		}
 	}
 
-	err = mlx4_srq_alloc(dev->dev, to_mpd(pd)->pdn, &srq->mtt,
+	cqn = xrc_cq ? (u32) (to_mcq(xrc_cq)->mcq.cqn) : 0;
+	xrcdn = xrcd ? (u16) (to_mxrcd(xrcd)->xrcdn) :
+		(u16) dev->dev->caps.reserved_xrcds;
+
+	err = mlx4_srq_alloc(dev->dev, to_mpd(pd)->pdn, cqn, xrcdn, &srq->mtt,
 			     srq->db.dma, &srq->msrq);
 	if (err)
 		goto err_wrid;
 
 	srq->msrq.event = mlx4_ib_srq_event;
 
-	if (pd->uobject)
+	if (pd->uobject) {
 		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof (__u32))) {
 			err = -EFAULT;
 			goto err_wrid;
 		}
+	} else
+		srq->ibsrq.xrc_srq_num = srq->msrq.srqn;
 
 	init_attr->attr.max_wr = srq->msrq.max - 1;
 
@@ -242,6 +252,13 @@ int mlx4_ib_modify_srq(struct ib_srq *ib
 	return 0;
 }
 
+struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
+				  struct ib_srq_init_attr *init_attr,
+				  struct ib_udata *udata)
+{
+	return mlx4_ib_create_xrc_srq(pd, NULL, NULL, init_attr, udata);
+}
+
 int mlx4_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibsrq->device);
@@ -264,6 +281,18 @@ int mlx4_ib_destroy_srq(struct ib_srq *s
 {
 	struct mlx4_ib_dev *dev = to_mdev(srq->device);
 	struct mlx4_ib_srq *msrq = to_msrq(srq);
+	struct mlx4_ib_cq *cq;
+
+	mlx4_srq_invalidate(dev->dev, &msrq->msrq);
+
+	if (srq->xrc_cq && !srq->uobject) {
+		cq = to_mcq(srq->xrc_cq);
+		spin_lock_irq(&cq->lock);
+		__mlx4_ib_cq_clean(cq, -1, msrq);
+		mlx4_srq_remove(dev->dev, &msrq->msrq);
+		spin_unlock_irq(&cq->lock);
+	} else
+		mlx4_srq_remove(dev->dev, &msrq->msrq);
 
 	mlx4_srq_free(dev->dev, &msrq->msrq);
 	mlx4_mtt_cleanup(dev->dev, &msrq->mtt);
Index: infiniband/drivers/net/mlx4/Makefile
===================================================================
--- infiniband.orig/drivers/net/mlx4/Makefile
+++ infiniband/drivers/net/mlx4/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_MLX4_CORE)		+= mlx4_core.o
 
 mlx4_core-y :=	alloc.o catas.o cmd.o cq.o eq.o fw.o icm.o intf.o main.o mcg.o \
-		mr.o pd.o port.o profile.o qp.o reset.o sense.o srq.o
+		mr.o pd.o port.o profile.o qp.o reset.o sense.o srq.o xrcd.o
 
 obj-$(CONFIG_MLX4_EN)               += mlx4_en.o
 
Index: infiniband/drivers/net/mlx4/fw.c
===================================================================
--- infiniband.orig/drivers/net/mlx4/fw.c
+++ infiniband/drivers/net/mlx4/fw.c
@@ -195,6 +195,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 #define QUERY_DEV_CAP_MAX_MCG_OFFSET		0x63
 #define QUERY_DEV_CAP_RSVD_PD_OFFSET		0x64
 #define QUERY_DEV_CAP_MAX_PD_OFFSET		0x65
+#define QUERY_DEV_CAP_RSVD_XRC_OFFSET		0x66
+#define QUERY_DEV_CAP_MAX_XRC_OFFSET		0x67
 #define QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET	0x80
 #define QUERY_DEV_CAP_QPC_ENTRY_SZ_OFFSET	0x82
 #define QUERY_DEV_CAP_AUX_ENTRY_SZ_OFFSET	0x84
@@ -305,6 +307,11 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PD_OFFSET);
 	dev_cap->max_pds = 1 << (field & 0x3f);
 
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_XRC_OFFSET);
+	dev_cap->reserved_xrcds = field >> 4;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_XRC_OFFSET);
+	dev_cap->max_xrcds = 1 << (field & 0x1f);
+
 	MLX4_GET(size, outbox, QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET);
 	dev_cap->rdmarc_entry_sz = size;
 	MLX4_GET(size, outbox, QUERY_DEV_CAP_QPC_ENTRY_SZ_OFFSET);
Index: infiniband/drivers/net/mlx4/fw.h
===================================================================
--- infiniband.orig/drivers/net/mlx4/fw.h
+++ infiniband/drivers/net/mlx4/fw.h
@@ -89,6 +89,8 @@ struct mlx4_dev_cap {
 	int max_mcgs;
 	int reserved_pds;
 	int max_pds;
+	int reserved_xrcds;
+	int max_xrcds;
 	int qpc_entry_sz;
 	int rdmarc_entry_sz;
 	int altc_entry_sz;
Index: infiniband/drivers/net/mlx4/main.c
===================================================================
--- infiniband.orig/drivers/net/mlx4/main.c
+++ infiniband/drivers/net/mlx4/main.c
@@ -222,6 +222,13 @@ static int mlx4_dev_cap(struct mlx4_dev 
 	dev->caps.reserved_lkey	     = dev_cap->reserved_lkey;
 	dev->caps.stat_rate_support  = dev_cap->stat_rate_support;
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) {
+		dev->caps.reserved_xrcds = dev_cap->reserved_xrcds;
+		dev->caps.max_xrcds = dev_cap->max_xrcds;
+	} else {
+		dev->caps.reserved_xrcds = 0;
+		dev->caps.max_xrcds = 0;
+	}
 
 	dev->caps.log_num_macs  = log_num_mac;
 	dev->caps.log_num_vlans = log_num_vlan;
@@ -838,11 +845,18 @@ static int mlx4_setup_hca(struct mlx4_de
 		goto err_kar_unmap;
 	}
 
+	err = mlx4_init_xrcd_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize extended "
+			 "reliably connected domain table, aborting.\n");
+		goto err_pd_table_free;
+	}
+
 	err = mlx4_init_mr_table(dev);
 	if (err) {
 		mlx4_err(dev, "Failed to initialize "
 			 "memory region table, aborting.\n");
-		goto err_pd_table_free;
+		goto err_xrcd_table_free;
 	}
 
 	err = mlx4_init_eq_table(dev);
@@ -945,6 +959,9 @@ err_eq_table_free:
 err_mr_table_free:
 	mlx4_cleanup_mr_table(dev);
 
+err_xrcd_table_free:
+	mlx4_cleanup_xrcd_table(dev);
+
 err_pd_table_free:
 	mlx4_cleanup_pd_table(dev);
 
@@ -1186,6 +1203,7 @@ err_port:
 	mlx4_cmd_use_polling(dev);
 	mlx4_cleanup_eq_table(dev);
 	mlx4_cleanup_mr_table(dev);
+	mlx4_cleanup_xrcd_table(dev);
 	mlx4_cleanup_pd_table(dev);
 	mlx4_cleanup_uar_table(dev);
 
@@ -1248,6 +1266,7 @@ static void mlx4_remove_one(struct pci_d
 		mlx4_cmd_use_polling(dev);
 		mlx4_cleanup_eq_table(dev);
 		mlx4_cleanup_mr_table(dev);
+		mlx4_cleanup_xrcd_table(dev);
 		mlx4_cleanup_pd_table(dev);
 
 		iounmap(priv->kar);
Index: infiniband/drivers/net/mlx4/mlx4.h
===================================================================
--- infiniband.orig/drivers/net/mlx4/mlx4.h
+++ infiniband/drivers/net/mlx4/mlx4.h
@@ -214,7 +214,6 @@ struct mlx4_eq_table {
 struct mlx4_srq_table {
 	struct mlx4_bitmap	bitmap;
 	spinlock_t		lock;
-	struct radix_tree_root	tree;
 	struct mlx4_icm_table	table;
 	struct mlx4_icm_table	cmpt_table;
 };
@@ -296,6 +295,7 @@ struct mlx4_priv {
 	struct mlx4_cmd		cmd;
 
 	struct mlx4_bitmap	pd_bitmap;
+	struct mlx4_bitmap	xrcd_bitmap;
 	struct mlx4_uar_table	uar_table;
 	struct mlx4_mr_table	mr_table;
 	struct mlx4_cq_table	cq_table;
@@ -338,6 +338,7 @@ int mlx4_alloc_eq_table(struct mlx4_dev 
 void mlx4_free_eq_table(struct mlx4_dev *dev);
 
 int mlx4_init_pd_table(struct mlx4_dev *dev);
+int mlx4_init_xrcd_table(struct mlx4_dev *dev);
 int mlx4_init_uar_table(struct mlx4_dev *dev);
 int mlx4_init_mr_table(struct mlx4_dev *dev);
 int mlx4_init_eq_table(struct mlx4_dev *dev);
@@ -354,6 +355,7 @@ void mlx4_cleanup_cq_table(struct mlx4_d
 void mlx4_cleanup_qp_table(struct mlx4_dev *dev);
 void mlx4_cleanup_srq_table(struct mlx4_dev *dev);
 void mlx4_cleanup_mcg_table(struct mlx4_dev *dev);
+void mlx4_cleanup_xrcd_table(struct mlx4_dev *dev);
 
 void mlx4_start_catas_poll(struct mlx4_dev *dev);
 void mlx4_stop_catas_poll(struct mlx4_dev *dev);
Index: infiniband/drivers/net/mlx4/qp.c
===================================================================
--- infiniband.orig/drivers/net/mlx4/qp.c
+++ infiniband/drivers/net/mlx4/qp.c
@@ -280,6 +280,8 @@ int mlx4_init_qp_table(struct mlx4_dev *
 	 * We reserve 2 extra QPs per port for the special QPs.  The
 	 * block of special QPs must be aligned to a multiple of 8, so
 	 * round up.
+	 * We also reserve the MSB of the 24-bit QP number to indicate
+	 * an XRC qp.
 	 */
 	dev->caps.sqp_start =
 		ALIGN(dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW], 8);
Index: infiniband/drivers/net/mlx4/srq.c
===================================================================
--- infiniband.orig/drivers/net/mlx4/srq.c
+++ infiniband/drivers/net/mlx4/srq.c
@@ -40,20 +40,20 @@
 struct mlx4_srq_context {
 	__be32			state_logsize_srqn;
 	u8			logstride;
-	u8			reserved1[3];
-	u8			pg_offset;
-	u8			reserved2[3];
-	u32			reserved3;
+	u8			reserved1;
+	__be16			xrc_domain;
+	__be32			pg_offset_cqn;
+	u32			reserved2;
 	u8			log_page_size;
-	u8			reserved4[2];
+	u8			reserved3[2];
 	u8			mtt_base_addr_h;
 	__be32			mtt_base_addr_l;
 	__be32			pd;
 	__be16			limit_watermark;
 	__be16			wqe_cnt;
-	u16			reserved5;
+	u16			reserved4;
 	__be16			wqe_counter;
-	u32			reserved6;
+	u32			reserved5;
 	__be64			db_rec_addr;
 };
 
@@ -64,7 +64,8 @@ void mlx4_srq_event(struct mlx4_dev *dev
 
 	spin_lock(&srq_table->lock);
 
-	srq = radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - 1));
+	srq = radix_tree_lookup(&dev->srq_table_tree,
+				srqn & (dev->caps.num_srqs - 1));
 	if (srq)
 		atomic_inc(&srq->refcount);
 
@@ -109,8 +110,8 @@ static int mlx4_QUERY_SRQ(struct mlx4_de
 			    MLX4_CMD_TIME_CLASS_A);
 }
 
-int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
-		   u64 db_rec, struct mlx4_srq *srq)
+int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
+		   struct mlx4_mtt *mtt, u64 db_rec, struct mlx4_srq *srq)
 {
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 	struct mlx4_cmd_mailbox *mailbox;
@@ -131,7 +132,7 @@ int mlx4_srq_alloc(struct mlx4_dev *dev,
 		goto err_put;
 
 	spin_lock_irq(&srq_table->lock);
-	err = radix_tree_insert(&srq_table->tree, srq->srqn, srq);
+	err = radix_tree_insert(&dev->srq_table_tree, srq->srqn, srq);
 	spin_unlock_irq(&srq_table->lock);
 	if (err)
 		goto err_cmpt_put;
@@ -148,6 +149,8 @@ int mlx4_srq_alloc(struct mlx4_dev *dev,
 	srq_context->state_logsize_srqn = cpu_to_be32((ilog2(srq->max) << 24) |
 						      srq->srqn);
 	srq_context->logstride          = srq->wqe_shift - 4;
+	srq_context->xrc_domain		= cpu_to_be16(xrcd);
+	srq_context->pg_offset_cqn	= cpu_to_be32(cqn & 0xffffff);
 	srq_context->log_page_size      = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
 
 	mtt_addr = mlx4_mtt_addr(dev, mtt);
@@ -168,7 +171,7 @@ int mlx4_srq_alloc(struct mlx4_dev *dev,
 
 err_radix:
 	spin_lock_irq(&srq_table->lock);
-	radix_tree_delete(&srq_table->tree, srq->srqn);
+	radix_tree_delete(&dev->srq_table_tree, srq->srqn);
 	spin_unlock_irq(&srq_table->lock);
 
 err_cmpt_put:
@@ -184,18 +187,29 @@ err_out:
 }
 EXPORT_SYMBOL_GPL(mlx4_srq_alloc);
 
-void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq)
+void mlx4_srq_invalidate(struct mlx4_dev *dev, struct mlx4_srq *srq)
 {
-	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 	int err;
 
 	err = mlx4_HW2SW_SRQ(dev, NULL, srq->srqn);
 	if (err)
 		mlx4_warn(dev, "HW2SW_SRQ failed (%d) for SRQN %06x\n", err, srq->srqn);
+}
+EXPORT_SYMBOL_GPL(mlx4_srq_invalidate);
+
+void mlx4_srq_remove(struct mlx4_dev *dev, struct mlx4_srq *srq)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 
 	spin_lock_irq(&srq_table->lock);
-	radix_tree_delete(&srq_table->tree, srq->srqn);
+	radix_tree_delete(&dev->srq_table_tree, srq->srqn);
 	spin_unlock_irq(&srq_table->lock);
+}
+EXPORT_SYMBOL_GPL(mlx4_srq_remove);
+
+void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 
 	if (atomic_dec_and_test(&srq->refcount))
 		complete(&srq->free);
@@ -241,7 +255,7 @@ int mlx4_init_srq_table(struct mlx4_dev 
 	int err;
 
 	spin_lock_init(&srq_table->lock);
-	INIT_RADIX_TREE(&srq_table->tree, GFP_ATOMIC);
+	INIT_RADIX_TREE(&dev->srq_table_tree, GFP_ATOMIC);
 
 	err = mlx4_bitmap_init(&srq_table->bitmap, dev->caps.num_srqs,
 			       dev->caps.num_srqs - 1, dev->caps.reserved_srqs, 0);
Index: infiniband/drivers/net/mlx4/xrcd.c
===================================================================
--- /dev/null
+++ infiniband/drivers/net/mlx4/xrcd.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2006, 2007 Cisco Systems, Inc.  All rights reserved.
+ * Copyright (c) 2007 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+
+#include "mlx4.h"
+
+int mlx4_xrcd_alloc(struct mlx4_dev *dev, u32 *xrcdn)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	*xrcdn = mlx4_bitmap_alloc(&priv->xrcd_bitmap);
+	if (*xrcdn == -1)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_xrcd_alloc);
+
+void mlx4_xrcd_free(struct mlx4_dev *dev, u32 xrcdn)
+{
+	mlx4_bitmap_free(&mlx4_priv(dev)->xrcd_bitmap, xrcdn);
+}
+EXPORT_SYMBOL_GPL(mlx4_xrcd_free);
+
+int __devinit mlx4_init_xrcd_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	return mlx4_bitmap_init(&priv->xrcd_bitmap, (1 << 16),
+				(1 << 16) - 1, dev->caps.reserved_xrcds + 1, 0);
+}
+
+void mlx4_cleanup_xrcd_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->xrcd_bitmap);
+}
+
+
Index: infiniband/include/linux/mlx4/device.h
===================================================================
--- infiniband.orig/include/linux/mlx4/device.h
+++ infiniband/include/linux/mlx4/device.h
@@ -56,6 +56,7 @@ enum {
 	MLX4_DEV_CAP_FLAG_RC		= 1 <<  0,
 	MLX4_DEV_CAP_FLAG_UC		= 1 <<  1,
 	MLX4_DEV_CAP_FLAG_UD		= 1 <<  2,
+	MLX4_DEV_CAP_FLAG_XRC		= 1 <<  3,
 	MLX4_DEV_CAP_FLAG_SRQ		= 1 <<  6,
 	MLX4_DEV_CAP_FLAG_IPOIB_CSUM	= 1 <<  7,
 	MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1 <<  8,
@@ -223,6 +224,8 @@ struct mlx4_caps {
 	int			num_pds;
 	int			reserved_pds;
 	int			mtt_entry_sz;
+	int			reserved_xrcds;
+	int			max_xrcds;
 	u32			max_msg_sz;
 	u32			page_size_cap;
 	u32			flags;
@@ -378,6 +381,7 @@ struct mlx4_dev {
 	unsigned long		flags;
 	struct mlx4_caps	caps;
 	struct radix_tree_root	qp_table_tree;
+	struct radix_tree_root	srq_table_tree;
 	u32			rev_id;
 	char			board_id[MLX4_BOARD_ID_LEN];
 };
@@ -416,6 +420,9 @@ static inline void *mlx4_buf_offset(stru
 int mlx4_pd_alloc(struct mlx4_dev *dev, u32 *pdn);
 void mlx4_pd_free(struct mlx4_dev *dev, u32 pdn);
 
+int mlx4_xrcd_alloc(struct mlx4_dev *dev, u32 *xrcdn);
+void mlx4_xrcd_free(struct mlx4_dev *dev, u32 xrcdn);
+
 int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar);
 void mlx4_uar_free(struct mlx4_dev *dev, struct mlx4_uar *uar);
 
@@ -452,8 +459,8 @@ void mlx4_qp_release_range(struct mlx4_d
 int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp);
 void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp);
 
-int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
-		   u64 db_rec, struct mlx4_srq *srq);
+int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
+		   struct mlx4_mtt *mtt, u64 db_rec, struct mlx4_srq *srq);
 void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq);
 int mlx4_srq_arm(struct mlx4_dev *dev, struct mlx4_srq *srq, int limit_watermark);
 int mlx4_srq_query(struct mlx4_dev *dev, struct mlx4_srq *srq, int *limit_watermark);
Index: infiniband/include/linux/mlx4/qp.h
===================================================================
--- infiniband.orig/include/linux/mlx4/qp.h
+++ infiniband/include/linux/mlx4/qp.h
@@ -74,6 +74,7 @@ enum {
 	MLX4_QP_ST_UC				= 0x1,
 	MLX4_QP_ST_RD				= 0x2,
 	MLX4_QP_ST_UD				= 0x3,
+	MLX4_QP_ST_XRC				= 0x6,
 	MLX4_QP_ST_MLX				= 0x7
 };
 
@@ -136,7 +137,7 @@ struct mlx4_qp_context {
 	__be32			ssn;
 	__be32			params2;
 	__be32			rnr_nextrecvpsn;
-	__be32			srcd;
+	__be32			xrcd;
 	__be32			cqn_recv;
 	__be64			db_rec_addr;
 	__be32			qkey;
Index: infiniband/include/linux/mlx4/srq.h
===================================================================
--- infiniband.orig/include/linux/mlx4/srq.h
+++ infiniband/include/linux/mlx4/srq.h
@@ -33,10 +33,22 @@
 #ifndef MLX4_SRQ_H
 #define MLX4_SRQ_H
 
+#include <linux/types.h>
+#include <linux/mlx4/device.h>
+
 struct mlx4_wqe_srq_next_seg {
 	u16			reserved1;
 	__be16			next_wqe_index;
 	u32			reserved2[3];
 };
 
+void mlx4_srq_invalidate(struct mlx4_dev *dev, struct mlx4_srq *srq);
+void mlx4_srq_remove(struct mlx4_dev *dev, struct mlx4_srq *srq);
+
+static inline struct mlx4_srq *__mlx4_srq_lookup(struct mlx4_dev *dev, u32 srqn)
+{
+	return radix_tree_lookup(&dev->srq_table_tree,
+				 srqn & (dev->caps.num_srqs - 1));
+}
+
 #endif /* MLX4_SRQ_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
