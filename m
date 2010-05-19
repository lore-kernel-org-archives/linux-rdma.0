From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2 4/4] mlx4_ib: XRC RCV qp implementation.
Date: Wed, 19 May 2010 10:44:08 +0300
Message-ID: <201005191044.08237.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RE-sending with correct subject line (should be V2).

Support for XRC RCV-only QP (requested by userspace,
but resides in kernel space).

Implements create_xrc_rcv_qp, modify_xrc_rcv_qp, query_xrc_rcv_qp,
and destroy_xrc_rcv_qp.

Since query_xrc_rcv_qp and query_qp are very similar, the common portions
have been placed in a helper function which is invoked by both query methods.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      |    4 +-
 drivers/infiniband/hw/mlx4/main.c    |   60 ++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   13 ++
 drivers/infiniband/hw/mlx4/qp.c      |  208 +++++++++++++++++++++++++++++++++-
 4 files changed, 272 insertions(+), 13 deletions(-)

Index: infiniband/drivers/infiniband/hw/mlx4/cq.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/cq.c
+++ infiniband/drivers/infiniband/hw/mlx4/cq.c
@@ -176,7 +176,7 @@ struct ib_cq *mlx4_ib_create_cq(struct i
 	if (entries < 1 || entries > dev->dev->caps.max_cqes)
 		return ERR_PTR(-EINVAL);
 
-	cq = kmalloc(sizeof *cq, GFP_KERNEL);
+	cq = kzalloc(sizeof *cq, GFP_KERNEL);
 	if (!cq)
 		return ERR_PTR(-ENOMEM);
 
@@ -545,7 +545,7 @@ static int mlx4_ib_poll_one(struct mlx4_
 	struct mlx4_cqe *cqe;
 	struct mlx4_qp *mqp;
 	struct mlx4_ib_wq *wq;
-	struct mlx4_ib_srq *srq;
+	struct mlx4_ib_srq *uninitialized_var(srq);
 	struct mlx4_srq *msrq;
 	int is_send;
 	int is_error;
Index: infiniband/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/main.c
+++ infiniband/drivers/infiniband/hw/mlx4/main.c
@@ -420,7 +420,7 @@ static struct ib_pd *mlx4_ib_alloc_pd(st
 	struct mlx4_ib_pd *pd;
 	int err;
 
-	pd = kmalloc(sizeof *pd, GFP_KERNEL);
+	pd = kzalloc(sizeof *pd, GFP_KERNEL);
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
@@ -462,12 +462,18 @@ static int mlx4_ib_mcg_detach(struct ib_
 				     &to_mqp(ibqp)->mqp, gid->raw);
 }
 
+static void mlx4_dummy_comp_handler(struct ib_cq *cq, void *cq_context)
+{
+}
+
 static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 					  struct ib_ucontext *context,
 					  struct ib_udata *udata)
 {
 	struct mlx4_ib_xrcd *xrcd;
 	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
+	struct ib_pd *pd;
+	struct ib_cq *cq;
 	int err;
 
 	if (!(mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
@@ -478,23 +484,51 @@ static struct ib_xrcd *mlx4_ib_alloc_xrc
 		return ERR_PTR(-ENOMEM);
 
 	err = mlx4_xrcd_alloc(mdev->dev, &xrcd->xrcdn);
-	if (err) {
-		kfree(xrcd);
-		return ERR_PTR(err);
+	if (err)
+		goto err_xrcd;
+
+	pd = mlx4_ib_alloc_pd(ibdev, NULL, NULL);
+	if (IS_ERR(pd)) {
+		err = PTR_ERR(pd);
+		goto err_pd;
 	}
+	pd->device  = ibdev;
+
+	cq = mlx4_ib_create_cq(ibdev, 1, 0, NULL, NULL);
+	if (IS_ERR(cq)) {
+		err = PTR_ERR(cq);
+		goto err_cq;
+	}
+	cq->device        = ibdev;
+	cq->comp_handler  = mlx4_dummy_comp_handler;
 
 	if (context)
 		if (ib_copy_to_udata(udata, &xrcd->xrcdn, sizeof(__u32))) {
-			mlx4_xrcd_free(mdev->dev, xrcd->xrcdn);
-			kfree(xrcd);
-			return ERR_PTR(-EFAULT);
+			err = -EFAULT;
+			goto err_copy;
 		}
 
+	xrcd->cq = cq;
+	xrcd->pd = pd;
 	return &xrcd->ibxrcd;
+
+err_copy:
+	mlx4_ib_destroy_cq(cq);
+err_cq:
+	mlx4_ib_dealloc_pd(pd);
+err_pd:
+	mlx4_xrcd_free(mdev->dev, xrcd->xrcdn);
+err_xrcd:
+	kfree(xrcd);
+	return ERR_PTR(err);
 }
 
 static int mlx4_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 {
+	struct mlx4_ib_xrcd *mxrcd = to_mxrcd(xrcd);
+
+	mlx4_ib_destroy_cq(mxrcd->cq);
+	mlx4_ib_dealloc_pd(mxrcd->pd);
 	mlx4_xrcd_free(to_mdev(xrcd->device)->dev, to_mxrcd(xrcd)->xrcdn);
 	kfree(xrcd);
 
@@ -700,18 +734,28 @@ static void *mlx4_ib_add(struct mlx4_dev
 		ibdev->ib_dev.create_xrc_srq = mlx4_ib_create_xrc_srq;
 		ibdev->ib_dev.alloc_xrcd = mlx4_ib_alloc_xrcd;
 		ibdev->ib_dev.dealloc_xrcd = mlx4_ib_dealloc_xrcd;
+		ibdev->ib_dev.create_xrc_rcv_qp = mlx4_ib_create_xrc_rcv_qp;
+		ibdev->ib_dev.modify_xrc_rcv_qp = mlx4_ib_modify_xrc_rcv_qp;
+		ibdev->ib_dev.query_xrc_rcv_qp = mlx4_ib_query_xrc_rcv_qp;
+		ibdev->ib_dev.destroy_xrc_rcv_qp = mlx4_ib_destroy_xrc_rcv_qp;
 		ibdev->ib_dev.uverbs_cmd_mask |=
 			(1ull << IB_USER_VERBS_CMD_CREATE_XRC_SRQ)	|
 			(1ull << IB_USER_VERBS_CMD_OPEN_XRCD)	|
-			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
+			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD)	|
+			(1ull << IB_USER_VERBS_CMD_CREATE_XRC_RCV_QP)	|
+			(1ull << IB_USER_VERBS_CMD_MODIFY_XRC_RCV_QP)	|
+			(1ull << IB_USER_VERBS_CMD_QUERY_XRC_RCV_QP)	|
+			(1ull << IB_USER_VERBS_CMD_DESTROY_XRC_RCV_QP)  |
+			(1ull << IB_USER_VERBS_CMD_REG_XRC_RCV_QP)      |
+			(1ull << IB_USER_VERBS_CMD_UNREG_XRC_RCV_QP);
 	}
 
-
 	if (init_node_data(ibdev))
 		goto err_map;
 
 	spin_lock_init(&ibdev->sm_lock);
 	mutex_init(&ibdev->cap_mask_mutex);
+	mutex_init(&ibdev->xrc_rcv_mutex);
 
 	if (ib_register_device(&ibdev->ib_dev))
 		goto err_map;
Index: infiniband/drivers/infiniband/hw/mlx4/mlx4_ib.h
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ infiniband/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -59,6 +59,8 @@ struct mlx4_ib_pd {
 struct mlx4_ib_xrcd {
 	struct ib_xrcd	ibxrcd;
 	u32		xrcdn;
+	struct ib_pd	*pd;
+	struct ib_cq	*cq;
 };
 
 struct mlx4_ib_cq_buf {
@@ -115,6 +117,7 @@ struct mlx4_ib_wq {
 enum mlx4_ib_qp_flags {
 	MLX4_IB_QP_LSO				= 1 << 0,
 	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+	MLX4_IB_XRC_RCV				= 1 << 2,
 };
 
 struct mlx4_ib_qp {
@@ -181,6 +184,7 @@ struct mlx4_ib_dev {
 	spinlock_t		sm_lock;
 
 	struct mutex		cap_mask_mutex;
+	struct mutex		xrc_rcv_mutex;
 	bool			ib_active;
 };
 
@@ -329,6 +333,15 @@ int mlx4_ib_map_phys_fmr(struct ib_fmr *
 			 u64 iova);
 int mlx4_ib_unmap_fmr(struct list_head *fmr_list);
 int mlx4_ib_fmr_dealloc(struct ib_fmr *fmr);
+int mlx4_ib_create_xrc_rcv_qp(struct ib_qp_init_attr *init_attr,
+			      u32 *qp_num);
+int mlx4_ib_modify_xrc_rcv_qp(struct ib_xrcd *xrcd, u32 qp_num,
+			      struct ib_qp_attr *attr, int attr_mask);
+int mlx4_ib_query_xrc_rcv_qp(struct ib_xrcd *xrcd, u32 qp_num,
+			     struct ib_qp_attr *attr, int attr_mask,
+			     struct ib_qp_init_attr *init_attr);
+int mlx4_ib_destroy_xrc_rcv_qp(struct ib_xrcd *xrcd, u32 qp_num);
+
 
 static inline int mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 {
Index: infiniband/drivers/infiniband/hw/mlx4/qp.c
===================================================================
--- infiniband.orig/drivers/infiniband/hw/mlx4/qp.c
+++ infiniband/drivers/infiniband/hw/mlx4/qp.c
@@ -59,6 +59,7 @@ enum {
 	MLX4_IB_LSO_HEADER_SPARE	= 128,
 };
 
+
 struct mlx4_ib_sqp {
 	struct mlx4_ib_qp	qp;
 	int			pkey_index;
@@ -209,14 +210,14 @@ static inline unsigned pad_wraparound(st
 static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
 {
 	struct ib_event event;
-	struct ib_qp *ibqp = &to_mibqp(qp)->ibqp;
+	struct mlx4_ib_qp *mqp = to_mibqp(qp);
+	struct ib_qp *ibqp = &mqp->ibqp;
 
 	if (type == MLX4_EVENT_TYPE_PATH_MIG)
 		to_mibqp(qp)->port = to_mibqp(qp)->alt_port;
 
 	if (ibqp->event_handler) {
 		event.device     = ibqp->device;
-		event.element.qp = ibqp;
 		switch (type) {
 		case MLX4_EVENT_TYPE_PATH_MIG:
 			event.event = IB_EVENT_PATH_MIG;
@@ -248,6 +249,12 @@ static void mlx4_ib_qp_event(struct mlx4
 			return;
 		}
 
+		if (unlikely(ibqp->qp_type == IB_QPT_XRC &&
+			     mqp->flags & MLX4_IB_XRC_RCV)) {
+				event.event |= IB_XRC_QP_EVENT_FLAG;
+				event.element.xrc_qp_num = ibqp->qp_num;
+		} else
+				event.element.qp = ibqp;
 		ibqp->event_handler(&event, ibqp->qp_context);
 	}
 }
@@ -1886,27 +1893,15 @@ static void to_ib_ah_attr(struct mlx4_de
 	}
 }
 
-int mlx4_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_mask,
-		     struct ib_qp_init_attr *qp_init_attr)
+int mlx4_ib_query_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
+			    struct ib_qp_attr *qp_attr,
+			    struct ib_qp_init_attr *qp_init_attr)
 {
-	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
-	struct mlx4_ib_qp *qp = to_mqp(ibqp);
 	struct mlx4_qp_context context;
 	int mlx4_state;
-	int err = 0;
 
-	mutex_lock(&qp->mutex);
-
-	if (qp->state == IB_QPS_RESET) {
-		qp_attr->qp_state = IB_QPS_RESET;
-		goto done;
-	}
-
-	err = mlx4_qp_query(dev->dev, &qp->mqp, &context);
-	if (err) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (mlx4_qp_query(dev->dev, &qp->mqp, &context))
+		return -EINVAL;
 
 	mlx4_state = be32_to_cpu(context.flags) >> 28;
 
@@ -1950,7 +1945,26 @@ int mlx4_ib_query_qp(struct ib_qp *ibqp,
 	qp_attr->rnr_retry	    = (be32_to_cpu(context.params1) >> 13) & 0x7;
 	qp_attr->alt_timeout	    = context.alt_path.ackto >> 3;
 
-done:
+	return 0;
+}
+
+int mlx4_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_mask,
+		     struct ib_qp_init_attr *qp_init_attr)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx4_ib_qp *qp = to_mqp(ibqp);
+	int err = 0;
+
+	mutex_lock(&qp->mutex);
+
+	if (qp->state == IB_QPS_RESET)
+		qp_attr->qp_state = IB_QPS_RESET;
+	else {
+		err = mlx4_ib_query_qp_common(dev, qp, qp_attr, qp_init_attr);
+		if (err)
+			goto out;
+	}
+
 	qp_attr->cur_qp_state	     = qp_attr->qp_state;
 	qp_attr->cap.max_recv_wr     = qp->rq.wqe_cnt;
 	qp_attr->cap.max_recv_sge    = qp->rq.max_gs;
@@ -1983,3 +1997,164 @@ out:
 	return err;
 }
 
+int mlx4_ib_create_xrc_rcv_qp(struct ib_qp_init_attr *init_attr,
+			      u32 *qp_num)
+{
+	struct mlx4_ib_dev *dev = to_mdev(init_attr->xrcd->device);
+	struct mlx4_ib_xrcd *xrcd = to_mxrcd(init_attr->xrcd);
+	struct ib_qp_init_attr lcl_init;
+	struct mlx4_ib_qp *qp;
+	struct ib_qp *ibqp;
+	int err;
+
+	if (!(dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+		return -ENOSYS;
+
+	memcpy(&lcl_init, init_attr, sizeof(struct ib_qp_init_attr));
+	lcl_init.qp_type = IB_QPT_XRC;
+	lcl_init.sq_sig_type = 0;
+	lcl_init.cap.max_inline_data = 0;
+	lcl_init.cap.max_recv_sge = 0;
+	lcl_init.cap.max_recv_wr = 0;
+	lcl_init.cap.max_send_sge = 1;
+	lcl_init.cap.max_send_wr = 1;
+
+	qp = kzalloc(sizeof *qp, GFP_KERNEL);
+	if (!qp)
+		return -ENOMEM;
+
+	qp->flags = MLX4_IB_XRC_RCV;
+	qp->xrcdn = xrcd->xrcdn;
+	err = create_qp_common(dev, xrcd->pd, &lcl_init, NULL, 0, qp);
+	if (err) {
+		kfree(qp);
+		return err;
+	}
+
+	ibqp = &qp->ibqp;
+	/* set the ibpq attributes which will be used by the mlx4 module */
+	ibqp->qp_num = qp->mqp.qpn;
+	ibqp->device = lcl_init.xrcd->device;
+	ibqp->pd = xrcd->pd;
+	ibqp->send_cq = ibqp->recv_cq = xrcd->cq;
+	ibqp->event_handler = lcl_init.event_handler;
+	ibqp->qp_context = lcl_init.qp_context;
+	ibqp->qp_type = lcl_init.qp_type;
+	ibqp->xrcd = lcl_init.xrcd;
+
+	*qp_num = qp->mqp.qpn;
+	return 0;
+}
+
+int mlx4_ib_modify_xrc_rcv_qp(struct ib_xrcd *ibxrcd, u32 qp_num,
+			      struct ib_qp_attr *attr, int attr_mask)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibxrcd->device);
+	struct mlx4_ib_xrcd *xrcd = to_mxrcd(ibxrcd);
+	struct mlx4_ib_qp *qp;
+	struct mlx4_qp *mqp;
+	int err = -EINVAL;
+
+	if (!(dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+		return -ENOSYS;
+
+	mutex_lock(&dev->xrc_rcv_mutex);
+	mqp = __mlx4_qp_lookup(dev->dev, qp_num);
+	if (unlikely(!mqp)) {
+		printk(KERN_WARNING "mlx4_ib_modify_xrc_rcv_qp: "
+		       "unknown QPN %06x\n", qp_num);
+		goto out;
+	}
+
+	qp = to_mibqp(mqp);
+	if (qp->ibqp.qp_type != IB_QPT_XRC || !(qp->flags & MLX4_IB_XRC_RCV) ||
+	    !qp->ibqp.xrcd || xrcd->xrcdn != to_mxrcd(qp->ibqp.xrcd)->xrcdn)
+		goto out;
+
+	err = mlx4_ib_modify_qp(&qp->ibqp, attr, attr_mask, NULL);
+
+out:
+	mutex_unlock(&dev->xrc_rcv_mutex);
+	return err;
+}
+
+int mlx4_ib_query_xrc_rcv_qp(struct ib_xrcd *ibxrcd, u32 qp_num,
+			     struct ib_qp_attr *qp_attr, int qp_attr_mask,
+			     struct ib_qp_init_attr *qp_init_attr)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibxrcd->device);
+	struct mlx4_ib_xrcd *xrcd = to_mxrcd(ibxrcd);
+	struct mlx4_ib_qp *qp;
+	struct mlx4_qp *mqp;
+	int err = -EINVAL;
+
+	if (!(dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+		return -ENOSYS;
+
+	mutex_lock(&dev->xrc_rcv_mutex);
+	mqp = __mlx4_qp_lookup(dev->dev, qp_num);
+	if (unlikely(!mqp)) {
+		printk(KERN_WARNING "mlx4_ib_query_xrc_rcv_qp: "
+		       "unknown QPN %06x\n", qp_num);
+		goto err_out;
+	}
+
+	qp = to_mibqp(mqp);
+	if (qp->ibqp.qp_type != IB_QPT_XRC || !(qp->flags & MLX4_IB_XRC_RCV) ||
+	    !qp->ibqp.xrcd || xrcd->xrcdn != to_mxrcd(qp->ibqp.xrcd)->xrcdn)
+		goto err_out;
+
+	if (qp->state == IB_QPS_RESET)
+		qp_attr->qp_state = IB_QPS_RESET;
+	else {
+		err = mlx4_ib_query_qp_common(dev, qp, qp_attr, qp_init_attr);
+		if (err)
+			goto err_out;
+	}
+
+	qp_attr->cur_qp_state	     = qp_attr->qp_state;
+	qp_attr->cap.max_recv_wr     = 0;
+	qp_attr->cap.max_recv_sge    = 0;
+	qp_attr->cap.max_send_wr     = 0;
+	qp_attr->cap.max_send_sge    = 0;
+	qp_attr->cap.max_inline_data = 0;
+	qp_init_attr->cap	     = qp_attr->cap;
+
+	err = 0;
+
+err_out:
+	mutex_unlock(&dev->xrc_rcv_mutex);
+	return err;
+}
+
+int mlx4_ib_destroy_xrc_rcv_qp(struct ib_xrcd *ibxrcd, u32 qp_num)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibxrcd->device);
+	struct mlx4_ib_xrcd *xrcd = to_mxrcd(ibxrcd);
+	struct mlx4_ib_qp *qp;
+	struct mlx4_qp *mqp;
+	int err = -EINVAL;
+
+	mutex_lock(&dev->xrc_rcv_mutex);
+	mqp = __mlx4_qp_lookup(dev->dev, qp_num);
+	if (unlikely(!mqp)) {
+		printk(KERN_WARNING "mlx4_ib_destroy_xrc_rcv_qp: "
+		       "unknown QPN %06x\n", qp_num);
+		goto out;
+	}
+
+	qp = to_mibqp(mqp);
+
+	if (qp->ibqp.qp_type != IB_QPT_XRC || !(qp->flags & MLX4_IB_XRC_RCV) ||
+	    !qp->ibqp.xrcd || xrcd->xrcdn != to_mxrcd(qp->ibqp.xrcd)->xrcdn)
+		goto out;
+
+	mlx4_ib_destroy_qp(&qp->ibqp);
+
+	err = 0;
+
+out:
+	mutex_unlock(&dev->xrc_rcv_mutex);
+	return err;
+}
+


-------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
