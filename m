From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/4] IB/mlx4: Add support for WQ related verbs
Date: Thu, 22 Jun 2017 16:44:09 +0300
Message-ID: <20170622134412.7680-2-leon@kernel.org>
References: <20170622134412.7680-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170622134412.7680-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Support create/modify/destroy WQ related verbs.

The base IB object to enable RSS functionality is a WQ (i.e. ib_wq).
This patch implements the related WQ verbs as of create, modify and
destroy.

In downstream patches the WQ will be used as part of an indirection
table (i.e. ib_rwq_ind_table) to enable RSS QP creation.

Notes:
ConnectX-3 hardware requires consecutive WQNs list as receive descriptor
queues for the RSS QP. Hence, the driver reserves 128 consecutive WQNs
per user context which will be allocated for the created WQs.
Destroying the WQ will not return the WQN back to the reserve list.

Since the WQ object is not a natural object in the hardware, the driver
implements the WQ by the hardware QP.

As such, the WQ inherits its port from his RSS QP parent upon its
RST->INIT transition and by that time its state is applied to the
hardware.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |  40 ++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  18 +-
 drivers/infiniband/hw/mlx4/qp.c      | 417 ++++++++++++++++++++++++++++++-----
 include/uapi/rdma/mlx4-abi.h         |  12 +
 4 files changed, 429 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bfdd4e117813..e084eb88d44b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -81,6 +81,8 @@ static const char mlx4_ib_version[] =
 	DRV_VERSION "\n";

 static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init);
+static enum rdma_link_layer mlx4_ib_port_link_layer(struct ib_device *device,
+						    u8 port_num);

 static struct workqueue_struct *wq;

@@ -552,6 +554,11 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->timestamp_mask = 0xFFFFFFFFFFFFULL;
 	props->max_ah = INT_MAX;

+	if ((dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS) &&
+	    (mlx4_ib_port_link_layer(ibdev, 1) == IB_LINK_LAYER_ETHERNET ||
+	     mlx4_ib_port_link_layer(ibdev, 2) == IB_LINK_LAYER_ETHERNET))
+		props->max_wq_type_rq = MLX4_IB_MAX_CTX_WQS;
+
 	if (!mlx4_is_slave(dev->dev))
 		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);

@@ -1087,6 +1094,21 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 		return ERR_PTR(-EFAULT);
 	}

+	context->wq_use_cnt = MLX4_IB_MAX_CTX_WQS; /* WQs pool is empty */
+	context->base_wqn = 0xFFFFFFFF; /* invalid wqn */
+
+	if ((rdma_port_get_link_layer(ibdev, 1) == IB_LINK_LAYER_ETHERNET) ||
+	    (rdma_port_get_link_layer(ibdev, 2) == IB_LINK_LAYER_ETHERNET)) {
+		if (!mlx4_qp_reserve_range(dev->dev, MLX4_IB_MAX_CTX_WQS,
+					   MLX4_IB_MAX_CTX_WQS,
+					   &context->base_wqn, 0,
+					   MLX4_RES_USAGE_USER_VERBS)) {
+			context->wq_use_cnt = 0;
+		} else {
+			pr_warn("Failed to reserve WQNs for user context\n");
+		}
+	}
+
 	return &context->ibucontext;
 }

@@ -1094,6 +1116,10 @@ static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 {
 	struct mlx4_ib_ucontext *context = to_mucontext(ibcontext);

+	if (context->base_wqn != 0xFFFFFFFF)
+		mlx4_qp_release_range(to_mdev(ibcontext->device)->dev,
+				      context->base_wqn, MLX4_IB_MAX_CTX_WQS);
+
 	mlx4_uar_free(to_mdev(ibcontext->device)->dev, &context->uar);
 	kfree(context);

@@ -2720,6 +2746,20 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.get_dev_fw_str    = get_fw_ver_str;
 	ibdev->ib_dev.disassociate_ucontext = mlx4_ib_disassociate_ucontext;

+	if ((dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS) &&
+	    ((mlx4_ib_port_link_layer(&ibdev->ib_dev, 1) ==
+	    IB_LINK_LAYER_ETHERNET) ||
+	    (mlx4_ib_port_link_layer(&ibdev->ib_dev, 2) ==
+	    IB_LINK_LAYER_ETHERNET))) {
+		ibdev->ib_dev.create_wq		= mlx4_ib_create_wq;
+		ibdev->ib_dev.modify_wq		= mlx4_ib_modify_wq;
+		ibdev->ib_dev.destroy_wq	= mlx4_ib_destroy_wq;
+		ibdev->ib_dev.uverbs_ex_cmd_mask |=
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ);
+	}
+
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
 		ibdev->ib_dev.map_phys_fmr	= mlx4_ib_map_phys_fmr;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index a6337f3161cf..6d8ef6506f09 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -82,12 +82,16 @@ struct mlx4_ib_vma_private_data {
 	struct vm_area_struct *vma;
 };

+#define MLX4_IB_MAX_CTX_WQS 128
+
 struct mlx4_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct mlx4_uar		uar;
 	struct list_head	db_page_list;
 	struct mutex		db_page_mutex;
 	struct mlx4_ib_vma_private_data hw_bar_info[HW_BAR_COUNT];
+	int			base_wqn;
+	int			wq_use_cnt;
 };

 struct mlx4_ib_pd {
@@ -290,7 +294,10 @@ struct mlx4_roce_smac_vlan_info {
 };

 struct mlx4_ib_qp {
-	struct ib_qp		ibqp;
+	union {
+		struct ib_qp	ibqp;
+		struct ib_wq	ibwq;
+	};
 	struct mlx4_qp		mqp;
 	struct mlx4_buf		buf;

@@ -329,6 +336,8 @@ struct mlx4_ib_qp {
 	struct list_head	cq_recv_list;
 	struct list_head	cq_send_list;
 	struct counter_index	*counter_index;
+	/* Number of RSS QP parents that uses this WQ */
+	u32			rss_usecnt;
 };

 struct mlx4_ib_srq {
@@ -893,4 +902,11 @@ void mlx4_sched_ib_sl2vl_update_work(struct mlx4_ib_dev *ibdev,

 void mlx4_ib_sl2vl_update(struct mlx4_ib_dev *mdev, int port);

+struct ib_wq *mlx4_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata);
+int mlx4_ib_destroy_wq(struct ib_wq *wq);
+int mlx4_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      u32 wq_attr_mask, struct ib_udata *udata);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 247b9132e9de..bca7b5f8b627 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -116,6 +116,11 @@ static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD]	= cpu_to_be32(MLX4_OPCODE_MASKED_ATOMIC_FA),
 };

+enum mlx4_ib_source_type {
+	MLX4_IB_QP_SRC	= 0,
+	MLX4_IB_RWQ_SRC	= 1,
+};
+
 static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
 {
 	return container_of(mqp, struct mlx4_ib_sqp, qp);
@@ -330,6 +335,12 @@ static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
 	}
 }

+static void mlx4_ib_wq_event(struct mlx4_qp *qp, enum mlx4_event type)
+{
+	pr_warn_ratelimited("Unexpected event type %d on WQ 0x%06x. Events are not supported for WQs\n",
+			    type, qp->qpn);
+}
+
 static int send_wqe_overhead(enum mlx4_ib_qp_type type, u32 flags)
 {
 	/*
@@ -639,7 +650,19 @@ static void mlx4_ib_free_qp_counter(struct mlx4_ib_dev *dev,
 	qp->counter_index = NULL;
 }

+static int mlx4_ib_alloc_wqn(struct mlx4_ib_ucontext *context, int *wqn)
+{
+	if (context->wq_use_cnt == MLX4_IB_MAX_CTX_WQS) {
+		pr_debug("WQ pool is empty\n");
+		return -ENOMEM;
+	}
+
+	*wqn = context->base_wqn + context->wq_use_cnt++;
+	return 0;
+}
+
 static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
+			    enum mlx4_ib_source_type src,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, int sqpn,
 			    struct mlx4_ib_qp **caller_qp)
@@ -728,27 +751,57 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,


 	if (pd->uobject) {
-		struct mlx4_ib_create_qp ucmd;
+		union {
+			struct mlx4_ib_create_qp qp;
+			struct mlx4_ib_create_wq wq;
+		} ucmd;
+		size_t copy_len;

-		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+		copy_len = (src == MLX4_IB_QP_SRC) ?
+			   sizeof(struct mlx4_ib_create_qp) :
+			   min(sizeof(struct mlx4_ib_create_wq), udata->inlen);
+
+		if (ib_copy_from_udata(&ucmd, udata, copy_len)) {
 			err = -EFAULT;
 			goto err;
 		}

-		err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
-				  qp_has_rq(init_attr), qp, ucmd.inl_recv_sz);
-		if (err)
+		if ((src == MLX4_IB_RWQ_SRC) &&
+		    (ucmd.wq.comp_mask || ucmd.wq.reserved)) {
+			err = -EOPNOTSUPP;
 			goto err;
+		}

-		qp->inl_recv_sz = ucmd.inl_recv_sz;
-		qp->sq_no_prefetch = ucmd.sq_no_prefetch;
+		qp->inl_recv_sz = (src == MLX4_IB_QP_SRC) ?
+				  ucmd.qp.inl_recv_sz : 0;

-		err = set_user_sq_size(dev, qp, &ucmd);
+		err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
+				  qp_has_rq(init_attr), qp, qp->inl_recv_sz);
 		if (err)
 			goto err;

-		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0, 0);
+		if (src == MLX4_IB_QP_SRC) {
+			qp->sq_no_prefetch = ucmd.qp.sq_no_prefetch;
+
+			err = set_user_sq_size(dev, qp,
+					       (struct mlx4_ib_create_qp *)
+					       &ucmd);
+			if (err)
+				goto err;
+		} else {
+			qp->sq_no_prefetch = 1;
+			qp->sq.wqe_cnt = 1;
+			qp->sq.wqe_shift = MLX4_IB_MIN_SQ_STRIDE;
+			/* Allocated buffer expects to have at least that SQ
+			 * size.
+			 */
+			qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
+				(qp->sq.wqe_cnt << qp->sq.wqe_shift);
+		}
+
+		qp->umem = ib_umem_get(pd->uobject->context,
+				(src == MLX4_IB_QP_SRC) ? ucmd.qp.buf_addr :
+				ucmd.wq.buf_addr, qp->buf_size, 0, 0);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
@@ -765,7 +818,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,

 		if (qp_has_rq(init_attr)) {
 			err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
-						  ucmd.db_addr, &qp->db);
+				(src == MLX4_IB_QP_SRC) ? ucmd.qp.db_addr :
+				ucmd.wq.db_addr, &qp->db);
 			if (err)
 				goto err_mtt;
 		}
@@ -853,6 +907,11 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 				goto err_wrid;
 			}
 		}
+	} else if (src == MLX4_IB_RWQ_SRC) {
+		err = mlx4_ib_alloc_wqn(to_mucontext(pd->uobject->context),
+					&qpn);
+		if (err)
+			goto err_wrid;
 	} else {
 		/* Raw packet QPNs may not have bits 6,7 set in their qp_num;
 		 * otherwise, the WQE BlueFlame setup flow wrongly causes
@@ -891,7 +950,9 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	 */
 	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);

-	qp->mqp.event = mlx4_ib_qp_event;
+	qp->mqp.event = (src == MLX4_IB_QP_SRC) ? mlx4_ib_qp_event :
+						  mlx4_ib_wq_event;
+
 	if (!*caller_qp)
 		*caller_qp = qp;

@@ -918,7 +979,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (!sqpn) {
 		if (qp->flags & MLX4_IB_QP_NETIF)
 			mlx4_ib_steer_qp_free(dev, qpn, 1);
-		else
+		else if (src != MLX4_IB_RWQ_SRC)
 			mlx4_qp_release_range(dev->dev, qpn, 1);
 	}
 err_proxy:
@@ -1016,7 +1077,7 @@ static struct mlx4_ib_pd *get_pd(struct mlx4_ib_qp *qp)
 		return to_mpd(qp->ibqp.pd);
 }

-static void get_cqs(struct mlx4_ib_qp *qp,
+static void get_cqs(struct mlx4_ib_qp *qp, enum mlx4_ib_source_type src,
 		    struct mlx4_ib_cq **send_cq, struct mlx4_ib_cq **recv_cq)
 {
 	switch (qp->ibqp.qp_type) {
@@ -1029,14 +1090,16 @@ static void get_cqs(struct mlx4_ib_qp *qp,
 		*recv_cq = *send_cq;
 		break;
 	default:
-		*send_cq = to_mcq(qp->ibqp.send_cq);
-		*recv_cq = to_mcq(qp->ibqp.recv_cq);
+		*recv_cq = (src == MLX4_IB_QP_SRC) ? to_mcq(qp->ibqp.recv_cq) :
+						     to_mcq(qp->ibwq.cq);
+		*send_cq = (src == MLX4_IB_QP_SRC) ? to_mcq(qp->ibqp.send_cq) :
+						     *recv_cq;
 		break;
 	}
 }

 static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
-			      int is_user)
+			      enum mlx4_ib_source_type src, int is_user)
 {
 	struct mlx4_ib_cq *send_cq, *recv_cq;
 	unsigned long flags;
@@ -1069,7 +1132,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 		}
 	}

-	get_cqs(qp, &send_cq, &recv_cq);
+	get_cqs(qp, src, &send_cq, &recv_cq);

 	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
 	mlx4_ib_lock_cqs(send_cq, recv_cq);
@@ -1095,16 +1158,19 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	if (!is_sqp(dev, qp) && !is_tunnel_qp(dev, qp)) {
 		if (qp->flags & MLX4_IB_QP_NETIF)
 			mlx4_ib_steer_qp_free(dev, qp->mqp.qpn, 1);
-		else
+		else if (src != MLX4_IB_RWQ_SRC)
 			mlx4_qp_release_range(dev->dev, qp->mqp.qpn, 1);
 	}

 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);

 	if (is_user) {
-		if (qp->rq.wqe_cnt)
-			mlx4_ib_db_unmap_user(to_mucontext(qp->ibqp.uobject->context),
-					      &qp->db);
+		if (qp->rq.wqe_cnt) {
+			struct mlx4_ib_ucontext *mcontext = !src ?
+				to_mucontext(qp->ibqp.uobject->context) :
+				to_mucontext(qp->ibwq.uobject->context);
+			mlx4_ib_db_unmap_user(mcontext, &qp->db);
+		}
 		ib_umem_release(qp->umem);
 	} else {
 		kvfree(qp->sq.wrid);
@@ -1200,8 +1266,8 @@ static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
 		/* fall through */
 	case IB_QPT_UD:
 	{
-		err = create_qp_common(to_mdev(pd->device), pd, init_attr,
-				       udata, 0, &qp);
+		err = create_qp_common(to_mdev(pd->device), pd,	MLX4_IB_QP_SRC,
+				       init_attr, udata, 0, &qp);
 		if (err) {
 			kfree(qp);
 			return ERR_PTR(err);
@@ -1231,8 +1297,8 @@ static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
 			sqpn = get_sqp_num(to_mdev(pd->device), init_attr);
 		}

-		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata,
-				       sqpn, &qp);
+		err = create_qp_common(to_mdev(pd->device), pd, MLX4_IB_QP_SRC,
+				       init_attr, udata, sqpn, &qp);
 		if (err)
 			return ERR_PTR(err);

@@ -1303,7 +1369,7 @@ static int _mlx4_ib_destroy_qp(struct ib_qp *qp)
 		mlx4_ib_free_qp_counter(dev, mqp);

 	pd = get_pd(mqp);
-	destroy_qp_common(dev, mqp, !!pd->ibpd.uobject);
+	destroy_qp_common(dev, mqp, MLX4_IB_QP_SRC, !!pd->ibpd.uobject);

 	if (is_sqp(dev, mqp))
 		kfree(to_msqp(mqp));
@@ -1626,12 +1692,15 @@ static u8 gid_type_to_qpc(enum ib_gid_type gid_type)
 	}
 }

-static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
+static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
 {
-	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
-	struct mlx4_ib_qp *qp = to_mqp(ibqp);
+	struct ib_uobject *ibuobject;
+	struct ib_srq  *ibsrq;
+	enum ib_qp_type qp_type;
+	struct mlx4_ib_dev *dev;
+	struct mlx4_ib_qp *qp;
 	struct mlx4_ib_pd *pd;
 	struct mlx4_ib_cq *send_cq, *recv_cq;
 	struct mlx4_qp_context *context;
@@ -1641,6 +1710,28 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	int err = -EINVAL;
 	int counter_index;

+	if (src_type == MLX4_IB_RWQ_SRC) {
+		struct ib_wq *ibwq;
+
+		ibwq	   = (struct ib_wq *)src;
+		ibuobject  = ibwq->uobject;
+		ibsrq	   = NULL;
+		qp_type    = IB_QPT_RAW_PACKET;
+		qp	   = to_mqp((struct ib_qp *)ibwq);
+		dev	   = to_mdev(ibwq->device);
+		pd	   = to_mpd(ibwq->pd);
+	} else {
+		struct ib_qp *ibqp;
+
+		ibqp	   = (struct ib_qp *)src;
+		ibuobject  = ibqp->uobject;
+		ibsrq	   = ibqp->srq;
+		qp_type    = ibqp->qp_type;
+		qp	   = to_mqp(ibqp);
+		dev	   = to_mdev(ibqp->device);
+		pd	   = get_pd(qp);
+	}
+
 	/* APM is not supported under RoCE */
 	if (attr_mask & IB_QP_ALT_PATH &&
 	    rdma_port_get_link_layer(&dev->ib_dev, qp->port) ==
@@ -1674,11 +1765,11 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (qp->inl_recv_sz)
 		context->param3 |= cpu_to_be32(1 << 25);

-	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
+	if (qp_type == IB_QPT_GSI || qp_type == IB_QPT_SMI)
 		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
-	else if (ibqp->qp_type == IB_QPT_RAW_PACKET)
+	else if (qp_type == IB_QPT_RAW_PACKET)
 		context->mtu_msgmax = (MLX4_RAW_QP_MTU << 5) | MLX4_RAW_QP_MSGMAX;
-	else if (ibqp->qp_type == IB_QPT_UD) {
+	else if (qp_type == IB_QPT_UD) {
 		if (qp->flags & MLX4_IB_QP_LSO)
 			context->mtu_msgmax = (IB_MTU_4096 << 5) |
 					      ilog2(dev->dev->caps.max_gso_sz);
@@ -1708,14 +1799,15 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		context->sq_size_stride |= !!qp->sq_no_prefetch << 7;
 		context->xrcd = cpu_to_be32((u32) qp->xrcdn);
-		if (ibqp->qp_type == IB_QPT_RAW_PACKET)
+		if (qp_type == IB_QPT_RAW_PACKET)
 			context->param3 |= cpu_to_be32(1 << 30);
 	}

-	if (qp->ibqp.uobject)
+	if (ibuobject)
 		context->usr_page = cpu_to_be32(
 			mlx4_to_hw_uar_index(dev->dev,
-					     to_mucontext(ibqp->uobject->context)->uar.index));
+					     to_mucontext(ibuobject->context)
+					     ->uar.index));
 	else
 		context->usr_page = cpu_to_be32(
 			mlx4_to_hw_uar_index(dev->dev, dev->priv_uar.index));
@@ -1759,7 +1851,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			steer_qp = 1;
 		}

-		if (ibqp->qp_type == IB_QPT_GSI) {
+		if (qp_type == IB_QPT_GSI) {
 			enum ib_gid_type gid_type = qp->flags & MLX4_IB_ROCE_V2_GSI_QP ?
 				IB_GID_TYPE_ROCE_UDP_ENCAP : IB_GID_TYPE_ROCE;
 			u8 qpc_roce_mode = gid_type_to_qpc(gid_type);
@@ -1776,7 +1868,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}

 	if (attr_mask & IB_QP_AV) {
-		u8 port_num = mlx4_is_bonded(to_mdev(ibqp->device)->dev) ? 1 :
+		u8 port_num = mlx4_is_bonded(dev->dev) ? 1 :
 			attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 		union ib_gid gid;
 		struct ib_gid_attr gid_attr = {.gid_type = IB_GID_TYPE_IB};
@@ -1791,7 +1883,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			int index =
 				rdma_ah_read_grh(&attr->ah_attr)->sgid_index;

-			status = ib_get_cached_gid(ibqp->device, port_num,
+			status = ib_get_cached_gid(&dev->ib_dev, port_num,
 						   index, &gid, &gid_attr);
 			if (!status && !memcmp(&gid, &zgid, sizeof(gid)))
 				status = -ENOENT;
@@ -1848,15 +1940,14 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		optpar |= MLX4_QP_OPTPAR_ALT_ADDR_PATH;
 	}

-	pd = get_pd(qp);
-	get_cqs(qp, &send_cq, &recv_cq);
+	get_cqs(qp, src_type, &send_cq, &recv_cq);
 	context->pd       = cpu_to_be32(pd->pdn);
 	context->cqn_send = cpu_to_be32(send_cq->mcq.cqn);
 	context->cqn_recv = cpu_to_be32(recv_cq->mcq.cqn);
 	context->params1  = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);

 	/* Set "fast registration enabled" for all kernel QPs */
-	if (!qp->ibqp.uobject)
+	if (!ibuobject)
 		context->params1 |= cpu_to_be32(1 << 11);

 	if (attr_mask & IB_QP_RNR_RETRY) {
@@ -1891,7 +1982,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		optpar |= MLX4_QP_OPTPAR_RWE | MLX4_QP_OPTPAR_RRE | MLX4_QP_OPTPAR_RAE;
 	}

-	if (ibqp->srq)
+	if (ibsrq)
 		context->params2 |= cpu_to_be32(MLX4_QP_BIT_RIC);

 	if (attr_mask & IB_QP_MIN_RNR_TIMER) {
@@ -1922,17 +2013,19 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		optpar |= MLX4_QP_OPTPAR_Q_KEY;
 	}

-	if (ibqp->srq)
-		context->srqn = cpu_to_be32(1 << 24 | to_msrq(ibqp->srq)->msrq.srqn);
+	if (ibsrq)
+		context->srqn = cpu_to_be32(1 << 24 |
+					    to_msrq(ibsrq)->msrq.srqn);

-	if (qp->rq.wqe_cnt && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (qp->rq.wqe_cnt &&
+	    cur_state == IB_QPS_RESET &&
+	    new_state == IB_QPS_INIT)
 		context->db_rec_addr = cpu_to_be64(qp->db.dma);

 	if (cur_state == IB_QPS_INIT &&
 	    new_state == IB_QPS_RTR  &&
-	    (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI ||
-	     ibqp->qp_type == IB_QPT_UD ||
-	     ibqp->qp_type == IB_QPT_RAW_PACKET)) {
+	    (qp_type == IB_QPT_GSI || qp_type == IB_QPT_SMI ||
+	     qp_type == IB_QPT_UD || qp_type == IB_QPT_RAW_PACKET)) {
 		context->pri_path.sched_queue = (qp->port - 1) << 6;
 		if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_SMI ||
 		    qp->mlx4_ib_qp_type &
@@ -1965,7 +2058,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}

-	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET) {
+	if (qp_type == IB_QPT_RAW_PACKET) {
 		context->pri_path.ackto = (context->pri_path.ackto & 0xf8) |
 					MLX4_IB_LINK_TYPE_ETH;
 		if (dev->dev->caps.tunnel_offload_mode ==  MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
@@ -1975,7 +2068,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}

-	if (ibqp->qp_type == IB_QPT_UD && (new_state == IB_QPS_RTR)) {
+	if (qp_type == IB_QPT_UD && (new_state == IB_QPS_RTR)) {
 		int is_eth = rdma_port_get_link_layer(
 				&dev->ib_dev, qp->port) ==
 				IB_LINK_LAYER_ETHERNET;
@@ -1985,14 +2078,15 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}

-
 	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
 	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
 		sqd_event = 1;
 	else
 		sqd_event = 0;

-	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (!ibuobject &&
+	    cur_state == IB_QPS_RESET &&
+	    new_state == IB_QPS_INIT)
 		context->rlkey_roce_mode |= (1 << 4);

 	/*
@@ -2001,7 +2095,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	 * headroom is stamped so that the hardware doesn't start
 	 * processing stale work requests.
 	 */
-	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+	if (!ibuobject &&
+	    cur_state == IB_QPS_RESET &&
+	    new_state == IB_QPS_INIT) {
 		struct mlx4_wqe_ctrl_seg *ctrl;
 		int i;

@@ -2058,9 +2154,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	 * entries and reinitialize the QP.
 	 */
 	if (new_state == IB_QPS_RESET) {
-		if (!ibqp->uobject) {
+		if (!ibuobject) {
 			mlx4_ib_cq_clean(recv_cq, qp->mqp.qpn,
-					 ibqp->srq ? to_msrq(ibqp->srq) : NULL);
+					 ibsrq ? to_msrq(ibsrq) : NULL);
 			if (send_cq != recv_cq)
 				mlx4_ib_cq_clean(send_cq, qp->mqp.qpn, NULL);

@@ -2265,7 +2361,8 @@ static int _mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto out;
 	}

-	err = __mlx4_ib_modify_qp(ibqp, attr, attr_mask, cur_state, new_state);
+	err = __mlx4_ib_modify_qp(ibqp, MLX4_IB_QP_SRC, attr, attr_mask,
+				  cur_state, new_state);

 	if (mlx4_is_bonded(dev->dev) && (attr_mask & IB_QP_PORT))
 		attr->port_num = 1;
@@ -3550,3 +3647,209 @@ int mlx4_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 	return err;
 }

+struct ib_wq *mlx4_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev;
+	struct ib_qp_init_attr ib_qp_init_attr;
+	struct mlx4_ib_qp *qp;
+	struct mlx4_ib_create_wq ucmd;
+	int err, required_cmd_sz;
+
+	if (!(udata && pd->uobject))
+		return ERR_PTR(-EINVAL);
+
+	required_cmd_sz = offsetof(typeof(ucmd), reserved) +
+			  sizeof(ucmd.reserved);
+	if (udata->inlen < required_cmd_sz) {
+		pr_debug("invalid inlen\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (udata->inlen > sizeof(ucmd) &&
+	    !ib_is_udata_cleared(udata, sizeof(ucmd),
+				 udata->inlen - sizeof(ucmd))) {
+		pr_debug("inlen is not supported\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	if (udata->outlen)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	dev = to_mdev(pd->device);
+
+	if (init_attr->wq_type != IB_WQT_RQ) {
+		pr_debug("unsupported wq type %d\n", init_attr->wq_type);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	if (init_attr->create_flags) {
+		pr_debug("unsupported create_flags %u\n",
+			 init_attr->create_flags);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp)
+		return ERR_PTR(-ENOMEM);
+
+	qp->pri.vid = 0xFFFF;
+	qp->alt.vid = 0xFFFF;
+
+	memset(&ib_qp_init_attr, 0, sizeof(ib_qp_init_attr));
+	ib_qp_init_attr.qp_context = init_attr->wq_context;
+	ib_qp_init_attr.qp_type = IB_QPT_RAW_PACKET;
+	ib_qp_init_attr.cap.max_recv_wr = init_attr->max_wr;
+	ib_qp_init_attr.cap.max_recv_sge = init_attr->max_sge;
+	ib_qp_init_attr.recv_cq = init_attr->cq;
+	ib_qp_init_attr.send_cq = ib_qp_init_attr.recv_cq; /* Dummy CQ */
+
+	err = create_qp_common(dev, pd, MLX4_IB_RWQ_SRC, &ib_qp_init_attr,
+			       udata, 0, &qp);
+	if (err) {
+		kfree(qp);
+		return ERR_PTR(err);
+	}
+
+	qp->ibwq.event_handler = init_attr->event_handler;
+	qp->ibwq.wq_num = qp->mqp.qpn;
+	qp->ibwq.state = IB_WQS_RESET;
+
+	return &qp->ibwq;
+}
+
+static int ib_wq2qp_state(enum ib_wq_state state)
+{
+	switch (state) {
+	case IB_WQS_RESET:
+		return IB_QPS_RESET;
+	case IB_WQS_RDY:
+		return IB_QPS_RTR;
+	default:
+		return IB_QPS_ERR;
+	}
+}
+
+static int _mlx4_ib_modify_wq(struct ib_wq *ibwq, enum ib_wq_state new_state)
+{
+	struct mlx4_ib_qp *qp = to_mqp((struct ib_qp *)ibwq);
+	enum ib_qp_state qp_cur_state;
+	enum ib_qp_state qp_new_state;
+	int attr_mask;
+	int err;
+
+	/* ib_qp.state represents the WQ HW state while ib_wq.state represents
+	 * the WQ logic state.
+	 */
+	qp_cur_state = qp->state;
+	qp_new_state = ib_wq2qp_state(new_state);
+
+	if (ib_wq2qp_state(new_state) == qp_cur_state)
+		return 0;
+
+	if (new_state == IB_WQS_RDY) {
+		struct ib_qp_attr attr = {};
+
+		attr.port_num = qp->port;
+		attr_mask = IB_QP_PORT;
+
+		err = __mlx4_ib_modify_qp(ibwq, MLX4_IB_RWQ_SRC, &attr,
+					  attr_mask, IB_QPS_RESET, IB_QPS_INIT);
+		if (err) {
+			pr_debug("WQN=0x%06x failed to apply RST->INIT on the HW QP\n",
+				 ibwq->wq_num);
+			return err;
+		}
+
+		qp_cur_state = IB_QPS_INIT;
+	}
+
+	attr_mask = 0;
+	err = __mlx4_ib_modify_qp(ibwq, MLX4_IB_RWQ_SRC, NULL, attr_mask,
+				  qp_cur_state,  qp_new_state);
+
+	if (err && (qp_cur_state == IB_QPS_INIT)) {
+		qp_new_state = IB_QPS_RESET;
+		if (__mlx4_ib_modify_qp(ibwq, MLX4_IB_RWQ_SRC, NULL,
+					attr_mask, IB_QPS_INIT, IB_QPS_RESET)) {
+			pr_warn("WQN=0x%06x failed with reverting HW's resources failure\n",
+				ibwq->wq_num);
+			qp_new_state = IB_QPS_INIT;
+		}
+	}
+
+	qp->state = qp_new_state;
+
+	return err;
+}
+
+int mlx4_ib_modify_wq(struct ib_wq *ibwq, struct ib_wq_attr *wq_attr,
+		      u32 wq_attr_mask, struct ib_udata *udata)
+{
+	struct mlx4_ib_qp *qp = to_mqp((struct ib_qp *)ibwq);
+	struct mlx4_ib_modify_wq ucmd = {};
+	size_t required_cmd_sz;
+	enum ib_wq_state cur_state, new_state;
+	int err = 0;
+
+	required_cmd_sz = offsetof(typeof(ucmd), reserved) +
+				   sizeof(ucmd.reserved);
+	if (udata->inlen < required_cmd_sz)
+		return -EINVAL;
+
+	if (udata->inlen > sizeof(ucmd) &&
+	    !ib_is_udata_cleared(udata, sizeof(ucmd),
+				 udata->inlen - sizeof(ucmd)))
+		return -EOPNOTSUPP;
+
+	if (ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen)))
+		return -EFAULT;
+
+	if (ucmd.comp_mask || ucmd.reserved)
+		return -EOPNOTSUPP;
+
+	if (wq_attr_mask & IB_WQ_FLAGS)
+		return -EOPNOTSUPP;
+
+	cur_state = wq_attr_mask & IB_WQ_CUR_STATE ? wq_attr->curr_wq_state :
+						     ibwq->state;
+	new_state = wq_attr_mask & IB_WQ_STATE ? wq_attr->wq_state : cur_state;
+
+	if (cur_state  < IB_WQS_RESET || cur_state  > IB_WQS_ERR ||
+	    new_state < IB_WQS_RESET || new_state > IB_WQS_ERR)
+		return -EINVAL;
+
+	if ((new_state == IB_WQS_RDY) && (cur_state == IB_WQS_ERR))
+		return -EINVAL;
+
+	if ((new_state == IB_WQS_ERR) && (cur_state == IB_WQS_RESET))
+		return -EINVAL;
+
+	/* Can update HW state only if a RSS QP has already associated to this
+	 * WQ, so we can apply its port on the WQ.
+	 */
+	if (qp->rss_usecnt)
+		err = _mlx4_ib_modify_wq(ibwq, new_state);
+
+	if (!err)
+		ibwq->state = new_state;
+
+	return err;
+}
+
+int mlx4_ib_destroy_wq(struct ib_wq *ibwq)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibwq->device);
+	struct mlx4_ib_qp *qp = to_mqp((struct ib_qp *)ibwq);
+
+	if (qp->counter_index)
+		mlx4_ib_free_qp_counter(dev, qp);
+
+	destroy_qp_common(dev, qp, MLX4_IB_RWQ_SRC, 1);
+
+	kfree(qp);
+
+	return 0;
+}
+
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index bf3bdba2f326..12b23b80dae5 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -105,4 +105,16 @@ struct mlx4_ib_create_qp {
 	__u8	reserved;
 };

+struct mlx4_ib_create_wq {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32   comp_mask;
+	__u32   reserved;
+};
+
+struct mlx4_ib_modify_wq {
+	__u32	comp_mask;
+	__u32	reserved;
+};
+
 #endif /* MLX4_ABI_USER_H */
--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
