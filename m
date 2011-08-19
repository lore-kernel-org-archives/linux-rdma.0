From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/20 v2] rdma/mlx4: Add support for XRC QPs
Date: Fri, 19 Aug 2011 02:14:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A9D@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support the creation of XRC INI and TGT QPs.  To handle the
case where a CQ or PD is not needed, we allocate them internally
with the xrcd.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |    2 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 
 drivers/infiniband/hw/mlx4/qp.c      |  120 +++++++++++++++++++++++++---------
 drivers/net/mlx4/qp.c                |    2 +
 include/linux/mlx4/qp.h              |    3 +
 5 files changed, 94 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d08cc2d..9cfa6f9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -128,6 +128,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
 		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC)
+		props->device_cap_flags |= IB_DEVICE_XRC;
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 57ea82d..849366c 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -145,6 +145,7 @@ struct mlx4_ib_qp {
 	struct mlx4_mtt		mtt;
 	int			buf_size;
 	struct mutex		mutex;
+	u16			xrcdn;
 	u32			flags;
 	u8			port;
 	u8			alt_port;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2001f20..5b0b17c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -302,15 +302,14 @@ static int send_wqe_overhead(enum ib_qp_type type, u32 flags)
 }
 
 static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
-		       int is_user, int has_srq, struct mlx4_ib_qp *qp)
+		       int is_user, int has_rq, struct mlx4_ib_qp *qp)
 {
 	/* Sanity check RQ size before proceeding */
 	if (cap->max_recv_wr  > dev->dev->caps.max_wqes  ||
 	    cap->max_recv_sge > dev->dev->caps.max_rq_sg)
 		return -EINVAL;
 
-	if (has_srq) {
-		/* QPs attached to an SRQ should have no RQ */
+	if (!has_rq) {
 		if (cap->max_recv_wr)
 			return -EINVAL;
 
@@ -463,6 +462,14 @@ static int set_user_sq_size(struct mlx4_ib_dev *dev,
 	return 0;
 }
 
+static int qp_has_rq(struct ib_qp_init_attr *attr)
+{
+	if (attr->qp_type == IB_QPT_XRC_INI || attr->qp_type == IB_QPT_XRC_TGT)
+		return 0;
+
+	return !attr->srq;
+}
+
 static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp *qp)
@@ -479,7 +486,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
 
-	err = set_rq_size(dev, &init_attr->cap, !!pd->uobject, !!init_attr->srq, qp);
+	err = set_rq_size(dev, &init_attr->cap, !!pd->uobject, qp_has_rq(init_attr), qp);
 	if (err)
 		goto err;
 
@@ -513,7 +520,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		if (!init_attr->srq) {
+		if (qp_has_rq(init_attr)) {
 			err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
 						  ucmd.db_addr, &qp->db);
 			if (err)
@@ -532,7 +539,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err;
 
-		if (!init_attr->srq) {
+		if (qp_has_rq(init_attr)) {
 			err = mlx4_db_alloc(dev->dev, &qp->db, 0);
 			if (err)
 				goto err;
@@ -575,6 +582,9 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (err)
 		goto err_qpn;
 
+	if (init_attr->qp_type == IB_QPT_XRC_TGT)
+		qp->mqp.qpn |= (1 << 23);
+
 	/*
 	 * Hardware wants QPN written in big-endian order (after
 	 * shifting) for send doorbell.  Precompute this value to save
@@ -592,9 +602,8 @@ err_qpn:
 
 err_wrid:
 	if (pd->uobject) {
-		if (!init_attr->srq)
-			mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context),
-					      &qp->db);
+		if (qp_has_rq(init_attr))
+			mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &qp->db);
 	} else {
 		kfree(qp->sq.wrid);
 		kfree(qp->rq.wrid);
@@ -610,7 +619,7 @@ err_buf:
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
 
 err_db:
-	if (!pd->uobject && !init_attr->srq)
+	if (!pd->uobject && qp_has_rq(init_attr))
 		mlx4_db_free(dev->dev, &qp->db);
 
 err:
@@ -671,6 +680,33 @@ static void del_gid_entries(struct mlx4_ib_qp *qp)
 	}
 }
 
+static struct mlx4_ib_pd *get_pd(struct mlx4_ib_qp *qp)
+{
+	if (qp->ibqp.qp_type == IB_QPT_XRC_TGT)
+		return to_mpd(to_mxrcd(qp->ibqp.xrcd)->pd);
+	else
+		return to_mpd(qp->ibqp.pd);
+}
+
+static void get_cqs(struct mlx4_ib_qp *qp,
+		    struct mlx4_ib_cq **send_cq, struct mlx4_ib_cq **recv_cq)
+{
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_XRC_TGT:
+		*send_cq = to_mcq(to_mxrcd(qp->ibqp.xrcd)->cq);
+		*recv_cq = *send_cq;
+		break;
+	case IB_QPT_XRC_INI:
+		*send_cq = to_mcq(qp->ibqp.send_cq);
+		*recv_cq = *send_cq;
+		break;
+	default:
+		*send_cq = to_mcq(qp->ibqp.send_cq);
+		*recv_cq = to_mcq(qp->ibqp.recv_cq);
+		break;
+	}
+}
+
 static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 			      int is_user)
 {
@@ -682,8 +718,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 			printk(KERN_WARNING "mlx4_ib: modify QP %06x to RESET failed.\n",
 			       qp->mqp.qpn);
 
-	send_cq = to_mcq(qp->ibqp.send_cq);
-	recv_cq = to_mcq(qp->ibqp.recv_cq);
+	get_cqs(qp, &send_cq, &recv_cq);
 
 	mlx4_ib_lock_cqs(send_cq, recv_cq);
 
@@ -706,7 +741,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
 
 	if (is_user) {
-		if (!qp->ibqp.srq)
+		if (qp->rq.wqe_cnt)
 			mlx4_ib_db_unmap_user(to_mucontext(qp->ibqp.uobject->context),
 					      &qp->db);
 		ib_umem_release(qp->umem);
@@ -714,7 +749,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 		kfree(qp->sq.wrid);
 		kfree(qp->rq.wrid);
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
-		if (!qp->ibqp.srq)
+		if (qp->rq.wqe_cnt)
 			mlx4_db_free(dev->dev, &qp->db);
 	}
 
@@ -725,10 +760,10 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 				struct ib_qp_init_attr *init_attr,
 				struct ib_udata *udata)
 {
-	struct mlx4_ib_dev *dev = to_mdev(pd->device);
 	struct mlx4_ib_sqp *sqp;
 	struct mlx4_ib_qp *qp;
 	int err;
+	u16 xrcdn = 0;
 
 	/*
 	 * We only support LSO and multicast loopback blocking, and
@@ -739,10 +774,20 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 		return ERR_PTR(-EINVAL);
 
 	if (init_attr->create_flags &&
-	    (pd->uobject || init_attr->qp_type != IB_QPT_UD))
+	    (udata || init_attr->qp_type != IB_QPT_UD))
 		return ERR_PTR(-EINVAL);
 
 	switch (init_attr->qp_type) {
+	case IB_QPT_XRC_TGT:
+		pd = to_mxrcd(init_attr->xrcd)->pd;
+		xrcdn = to_mxrcd(init_attr->xrcd)->xrcdn;
+		init_attr->send_cq = to_mxrcd(init_attr->xrcd)->cq;
+		/* fall through */
+	case IB_QPT_XRC_INI:
+		if (!(to_mdev(pd->device)->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+			return ERR_PTR(-ENOSYS);
+		init_attr->recv_cq = init_attr->send_cq;
+		/* fall through */
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
@@ -751,13 +796,14 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 		if (!qp)
 			return ERR_PTR(-ENOMEM);
 
-		err = create_qp_common(dev, pd, init_attr, udata, 0, qp);
+		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata, 0, qp);
 		if (err) {
 			kfree(qp);
 			return ERR_PTR(err);
 		}
 
 		qp->ibqp.qp_num = qp->mqp.qpn;
+		qp->xrcdn = xrcdn;
 
 		break;
 	}
@@ -765,7 +811,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_GSI:
 	{
 		/* Userspace is not allowed to create special QPs: */
-		if (pd->uobject)
+		if (udata)
 			return ERR_PTR(-EINVAL);
 
 		sqp = kzalloc(sizeof *sqp, GFP_KERNEL);
@@ -774,8 +820,8 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 
 		qp = &sqp->qp;
 
-		err = create_qp_common(dev, pd, init_attr, udata,
-				       dev->dev->caps.sqp_start +
+		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata,
+				       to_mdev(pd->device)->dev->caps.sqp_start +
 				       (init_attr->qp_type == IB_QPT_SMI ? 0 : 2) +
 				       init_attr->port_num - 1,
 				       qp);
@@ -801,11 +847,13 @@ int mlx4_ib_destroy_qp(struct ib_qp *qp)
 {
 	struct mlx4_ib_dev *dev = to_mdev(qp->device);
 	struct mlx4_ib_qp *mqp = to_mqp(qp);
+	struct mlx4_ib_pd *pd;
 
 	if (is_qp0(dev, mqp))
 		mlx4_CLOSE_PORT(dev->dev, mqp->port);
 
-	destroy_qp_common(dev, mqp, !!qp->pd->uobject);
+	pd = get_pd(mqp);
+	destroy_qp_common(dev, mqp, !!pd->ibpd.uobject);
 
 	if (is_sqp(dev, mqp))
 		kfree(to_msqp(mqp));
@@ -821,6 +869,8 @@ static int to_mlx4_st(enum ib_qp_type type)
 	case IB_QPT_RC:		return MLX4_QP_ST_RC;
 	case IB_QPT_UC:		return MLX4_QP_ST_UC;
 	case IB_QPT_UD:		return MLX4_QP_ST_UD;
+	case IB_QPT_XRC_INI:
+	case IB_QPT_XRC_TGT:	return MLX4_QP_ST_XRC;
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:	return MLX4_QP_ST_MLX;
 	default:		return -1;
@@ -960,6 +1010,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx4_ib_qp *qp = to_mqp(ibqp);
+	struct mlx4_ib_pd *pd;
+	struct mlx4_ib_cq *send_cq, *recv_cq;
 	struct mlx4_qp_context *context;
 	enum mlx4_qp_optpar optpar = 0;
 	int sqd_event;
@@ -1015,8 +1067,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		context->sq_size_stride = ilog2(qp->sq.wqe_cnt) << 3;
 	context->sq_size_stride |= qp->sq.wqe_shift - 4;
 
-	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		context->sq_size_stride |= !!qp->sq_no_prefetch << 7;
+		context->xrcd = cpu_to_be32((u32) qp->xrcdn);
+	}
 
 	if (qp->ibqp.uobject)
 		context->usr_page = cpu_to_be32(to_mucontext(ibqp->uobject->context)->uar.index);
@@ -1071,8 +1125,12 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		optpar |= MLX4_QP_OPTPAR_ALT_ADDR_PATH;
 	}
 
-	context->pd	    = cpu_to_be32(to_mpd(ibqp->pd)->pdn);
-	context->params1    = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
+	pd = get_pd(qp);
+	get_cqs(qp, &send_cq, &recv_cq);
+	context->pd       = cpu_to_be32(pd->pdn);
+	context->cqn_send = cpu_to_be32(send_cq->mcq.cqn);
+	context->cqn_recv = cpu_to_be32(recv_cq->mcq.cqn);
+	context->params1  = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
 
 	/* Set "fast registration enabled" for all kernel QPs */
 	if (!qp->ibqp.uobject)
@@ -1098,8 +1156,6 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_SQ_PSN)
 		context->next_send_psn = cpu_to_be32(attr->sq_psn);
 
-	context->cqn_send = cpu_to_be32(to_mcq(ibqp->send_cq)->mcq.cqn);
-
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
 		if (attr->max_dest_rd_atomic)
 			context->params2 |=
@@ -1122,8 +1178,6 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_RQ_PSN)
 		context->rnr_nextrecvpsn |= cpu_to_be32(attr->rq_psn);
 
-	context->cqn_recv = cpu_to_be32(to_mcq(ibqp->recv_cq)->mcq.cqn);
-
 	if (attr_mask & IB_QP_QKEY) {
 		context->qkey = cpu_to_be32(attr->qkey);
 		optpar |= MLX4_QP_OPTPAR_Q_KEY;
@@ -1132,7 +1186,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (ibqp->srq)
 		context->srqn = cpu_to_be32(1 << 24 | to_msrq(ibqp->srq)->msrq.srqn);
 
-	if (!ibqp->srq && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (qp->rq.wqe_cnt && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
 		context->db_rec_addr = cpu_to_be64(qp->db.dma);
 
 	if (cur_state == IB_QPS_INIT &&
@@ -1217,17 +1271,17 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	 * entries and reinitialize the QP.
 	 */
 	if (new_state == IB_QPS_RESET && !ibqp->uobject) {
-		mlx4_ib_cq_clean(to_mcq(ibqp->recv_cq), qp->mqp.qpn,
+		mlx4_ib_cq_clean(recv_cq, qp->mqp.qpn,
 				 ibqp->srq ? to_msrq(ibqp->srq): NULL);
-		if (ibqp->send_cq != ibqp->recv_cq)
-			mlx4_ib_cq_clean(to_mcq(ibqp->send_cq), qp->mqp.qpn, NULL);
+		if (send_cq != recv_cq)
+			mlx4_ib_cq_clean(send_cq, qp->mqp.qpn, NULL);
 
 		qp->rq.head = 0;
 		qp->rq.tail = 0;
 		qp->sq.head = 0;
 		qp->sq.tail = 0;
 		qp->sq_next_wqe = 0;
-		if (!ibqp->srq)
+		if (qp->rq.wqe_cnt)
 			*qp->db.db  = 0;
 	}
 
diff --git a/drivers/net/mlx4/qp.c b/drivers/net/mlx4/qp.c
index ec9350e..81e11bd 100644
--- a/drivers/net/mlx4/qp.c
+++ b/drivers/net/mlx4/qp.c
@@ -280,6 +280,8 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 	 * We reserve 2 extra QPs per port for the special QPs.  The
 	 * block of special QPs must be aligned to a multiple of 8, so
 	 * round up.
+	 * We also reserver the msb of the 24-bit QP number to indicate
+	 * XRC QP.
 	 */
 	dev->caps.sqp_start =
 		ALIGN(dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW], 8);
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9e9eb21..83ef4c2 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -74,6 +74,7 @@ enum {
 	MLX4_QP_ST_UC				= 0x1,
 	MLX4_QP_ST_RD				= 0x2,
 	MLX4_QP_ST_UD				= 0x3,
+	MLX4_QP_ST_XRC				= 0x6,
 	MLX4_QP_ST_MLX				= 0x7
 };
 
@@ -137,7 +138,7 @@ struct mlx4_qp_context {
 	__be32			ssn;
 	__be32			params2;
 	__be32			rnr_nextrecvpsn;
-	__be32			srcd;
+	__be32			xrcd;
 	__be32			cqn_recv;
 	__be64			db_rec_addr;
 	__be32			qkey;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
