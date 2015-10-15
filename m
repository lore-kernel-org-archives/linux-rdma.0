From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/7] IB/mlx5: Add receive Work Queue verbs
Date: Thu, 15 Oct 2015 10:16:47 +0300
Message-ID: <1444893410-13242-5-git-send-email-yishaih@mellanox.com>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444893410-13242-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

QP can be created without internal WQs "packaged" inside it,
this QP can be configured to use "external" WQ object as its
receive/send queue.

WQ is a necessary component for RSS technology since RSS mechanism
is supposed to distribute the traffic between multiple
Receive Work Queues

Add receive Work Queue verbs, it includes:
creation, modification and destruction.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |    9 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   35 +++++
 drivers/infiniband/hw/mlx5/qp.c      |  263 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h    |   15 ++
 4 files changed, 322 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 41d6911..1601f19 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1505,6 +1505,15 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
 	}
 
+	if (MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) {
+		dev->ib_dev.create_wq		= mlx5_ib_create_wq;
+		dev->ib_dev.modify_wq		= mlx5_ib_modify_wq;
+		dev->ib_dev.destroy_wq		= mlx5_ib_destroy_wq;
+		dev->ib_dev.uverbs_ex_cmd_mask |=
+				(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
+				(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
+				(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ);
+	}
 	err = init_node_data(dev);
 	if (err)
 		goto err_dealloc;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bb8cda7..6c00aca 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -143,12 +143,36 @@ struct mlx5_ib_wq {
 	void		       *qend;
 };
 
+struct mlx5_ib_rwq {
+	struct ib_wq		ibwq;
+	u32			rqn;
+	u32			rq_num_pas;
+	u32			log_rq_stride;
+	u32			log_rq_size;
+	u32			rq_page_offset;
+	u32			log_page_size;
+	struct ib_umem		*umem;
+	size_t			buf_size;
+	unsigned int		page_shift;
+	int			create_type;
+	struct mlx5_db		db;
+	u32			user_index;
+	u32			wqe_count;
+	u32			wqe_shift;
+	int			wq_sig;
+};
+
 enum {
 	MLX5_QP_USER,
 	MLX5_QP_KERNEL,
 	MLX5_QP_EMPTY
 };
 
+enum {
+	MLX5_WQ_USER,
+	MLX5_WQ_KERNEL
+};
+
 /*
  * Connect-IB can trigger up to four concurrent pagefaults
  * per-QP.
@@ -493,6 +517,11 @@ static inline struct mlx5_ib_qp *to_mqp(struct ib_qp *ibqp)
 	return container_of(ibqp, struct mlx5_ib_qp, ibqp);
 }
 
+static inline struct mlx5_ib_rwq *to_mrwq(struct ib_wq *ibwq)
+{
+	return container_of(ibwq, struct mlx5_ib_rwq, ibwq);
+}
+
 static inline struct mlx5_ib_srq *to_mibsrq(struct mlx5_core_srq *msrq)
 {
 	return container_of(msrq, struct mlx5_ib_srq, msrq);
@@ -630,6 +659,12 @@ int mlx5_mr_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift
 void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context);
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
+struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata);
+int mlx5_ib_destroy_wq(struct ib_wq *wq);
+int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      enum ib_wq_attr_mask attr_mask, struct ib_udata *udata);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 extern struct workqueue_struct *mlx5_ib_page_fault_wq;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index c745c6c..3763205 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
+#include <linux/mlx5/transobj.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -590,6 +591,71 @@ static int uuarn_to_uar_index(struct mlx5_uuar_info *uuari, int uuarn)
 	return uuari->uars[uuarn / MLX5_BF_REGS_PER_PAGE].index;
 }
 
+static void destroy_user_rq(struct ib_pd *pd, struct mlx5_ib_rwq *rwq)
+{
+	struct mlx5_ib_ucontext *context;
+
+	context = to_mucontext(pd->uobject->context);
+	mlx5_ib_db_unmap_user(context, &rwq->db);
+	if (rwq->umem)
+		ib_umem_release(rwq->umem);
+}
+
+static int create_user_rq(struct mlx5_ib_dev *dev, struct ib_pd *pd,
+			  struct mlx5_ib_rwq *rwq,
+			  struct mlx5_ib_create_wq *ucmd)
+{
+	struct mlx5_ib_ucontext *context;
+	int page_shift = 0;
+	int npages;
+	u32 offset = 0;
+	int ncont = 0;
+	int err;
+
+	if (!ucmd->buf_addr)
+		return -EINVAL;
+
+	context = to_mucontext(pd->uobject->context);
+	rwq->umem = ib_umem_get(pd->uobject->context, ucmd->buf_addr,
+			       rwq->buf_size, 0, 0);
+	if (IS_ERR(rwq->umem)) {
+		mlx5_ib_dbg(dev, "umem_get failed\n");
+		err = PTR_ERR(rwq->umem);
+		return err;
+	}
+
+	mlx5_ib_cont_pages(rwq->umem, ucmd->buf_addr, &npages, &page_shift,
+			   &ncont, NULL);
+	err = mlx5_ib_get_buf_offset(ucmd->buf_addr, page_shift,
+				     &rwq->rq_page_offset);
+	if (err) {
+		mlx5_ib_warn(dev, "bad offset\n");
+		goto err_umem;
+	}
+
+	rwq->rq_num_pas = ncont;
+	rwq->page_shift = page_shift;
+	rwq->log_page_size =  page_shift - PAGE_SHIFT;
+	rwq->wq_sig = !!(ucmd->flags & MLX5_WQ_FLAG_SIGNATURE);
+
+	mlx5_ib_dbg(dev, "addr 0x%llx, size %zd, npages %d, page_shift %d, ncont %d, offset %d\n",
+		    (unsigned long long)ucmd->buf_addr, rwq->buf_size,
+		    npages, page_shift, ncont, offset);
+
+	err = mlx5_ib_db_map_user(context, ucmd->db_addr, &rwq->db);
+	if (err) {
+		mlx5_ib_dbg(dev, "map failed\n");
+		goto err_umem;
+	}
+
+	rwq->create_type = MLX5_WQ_USER;
+	return 0;
+
+err_umem:
+	ib_umem_release(rwq->umem);
+	return err;
+}
+
 static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			  struct mlx5_ib_qp *qp, struct ib_udata *udata,
 			  struct mlx5_create_qp_mbox_in **in,
@@ -3160,3 +3226,200 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 
 	return 0;
 }
+
+static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
+		      struct ib_wq_init_attr *init_attr)
+{
+	struct mlx5_ib_dev *dev;
+	__be64 *rq_pas0;
+	void *in;
+	void *rqc;
+	void *wq;
+	int inlen;
+	int err;
+
+	dev = to_mdev(pd->device);
+
+	inlen = MLX5_ST_SZ_BYTES(create_rq_in) + sizeof(u64) * rwq->rq_num_pas;
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
+	MLX5_SET(rqc,  rqc, mem_rq_type,
+		 MLX5_RQC_MEM_RQ_TYPE_MEMORY_RQ_INLINE);
+	MLX5_SET(rqc, rqc, user_index, rwq->user_index);
+	MLX5_SET(rqc,  rqc, cqn, to_mcq(init_attr->cq)->mcq.cqn);
+	MLX5_SET(rqc,  rqc, state, MLX5_RQC_STATE_RST);
+	MLX5_SET(rqc,  rqc, flush_in_error_en, 1);
+	wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
+	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+	MLX5_SET(wq, wq, log_wq_stride, rwq->log_rq_stride);
+	MLX5_SET(wq, wq, log_wq_sz, rwq->log_rq_size);
+	MLX5_SET(wq, wq, pd, to_mpd(pd)->pdn);
+	MLX5_SET(wq, wq, page_offset, rwq->rq_page_offset);
+	MLX5_SET(wq, wq, log_wq_pg_sz, rwq->log_page_size);
+	MLX5_SET(wq, wq, wq_signature, rwq->wq_sig);
+	MLX5_SET64(wq, wq, dbr_addr, rwq->db.dma);
+	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
+	mlx5_ib_populate_pas(dev, rwq->umem, rwq->page_shift, rq_pas0, 0);
+	err = mlx5_core_create_rq(dev->mdev, in, inlen, &rwq->rqn);
+	kvfree(in);
+	return err;
+}
+
+static int set_user_rq_size(struct mlx5_ib_dev *dev,
+			    struct ib_wq_init_attr *wq_init_attr,
+			    struct mlx5_ib_create_wq *ucmd,
+			    struct mlx5_ib_rwq *rwq)
+{
+	/* Sanity check RQ size before proceeding */
+	if (wq_init_attr->max_wr > (1 << MLX5_CAP_GEN(dev->mdev, log_max_wq_sz)))
+		return -EINVAL;
+
+	if (!ucmd->rq_wqe_count)
+		return -EINVAL;
+
+	rwq->wqe_count = ucmd->rq_wqe_count;
+	rwq->wqe_shift = ucmd->rq_wqe_shift;
+	rwq->buf_size = (rwq->wqe_count << rwq->wqe_shift);
+	rwq->log_rq_stride = rwq->wqe_shift;
+	rwq->log_rq_size = ilog2(rwq->wqe_count);
+	return 0;
+}
+
+static int prepare_user_rq(struct ib_pd *pd,
+			   struct ib_wq_init_attr *init_attr,
+			   struct ib_udata *udata,
+			   struct mlx5_ib_rwq *rwq)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_ib_create_wq ucmd;
+	int err;
+
+	if (udata->inlen < sizeof(ucmd)) {
+		mlx5_ib_dbg(dev, "invalid inlen\n");
+		return -EINVAL;
+	}
+
+	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
+		mlx5_ib_dbg(dev, "copy failed\n");
+		return -EFAULT;
+	}
+
+	if (ucmd.reserved[0] || (ucmd.reserved[1])) {
+		mlx5_ib_dbg(dev, "invalid reserved\n");
+		return -EFAULT;
+	}
+
+	err = set_user_rq_size(dev, init_attr, &ucmd, rwq);
+	if (err) {
+		mlx5_ib_dbg(dev, "err %d\n", err);
+		return err;
+	}
+
+	err = create_user_rq(dev, pd, rwq, &ucmd);
+	if (err) {
+		mlx5_ib_dbg(dev, "err %d\n", err);
+		if (err)
+			return err;
+	}
+
+	rwq->user_index = ucmd.user_index;
+	return 0;
+}
+
+struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev;
+	struct mlx5_ib_rwq *rwq;
+	int err;
+
+	if (!udata)
+		return ERR_PTR(-ENOSYS);
+
+	dev = to_mdev(pd->device);
+	switch (init_attr->wq_type) {
+	case IB_WQT_RQ:
+		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
+		if (!rwq)
+			return ERR_PTR(-ENOMEM);
+		err = prepare_user_rq(pd, init_attr, udata, rwq);
+		if (err)
+			goto err;
+		err = create_rq(rwq, pd, init_attr);
+		if (err)
+			goto err_user_rq;
+		break;
+	default:
+		mlx5_ib_dbg(dev, "unsupported wq type %d\n",
+			    init_attr->wq_type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	rwq->ibwq.wq_num = rwq->rqn;
+	rwq->ibwq.state = IB_WQS_RESET;
+	return &rwq->ibwq;
+
+err_user_rq:
+	destroy_user_rq(pd, rwq);
+err:
+	kfree(rwq);
+	return ERR_PTR(err);
+}
+
+int mlx5_ib_destroy_wq(struct ib_wq *wq)
+{
+	struct mlx5_ib_dev *dev = to_mdev(wq->device);
+	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
+
+	if (wq->wq_type != IB_WQT_RQ)
+		return -EINVAL;
+
+	mlx5_core_destroy_rq(dev->mdev, rwq->rqn);
+	destroy_user_rq(wq->pd, rwq);
+	kfree(rwq);
+
+	return 0;
+}
+
+int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      enum ib_wq_attr_mask attr_mask, struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev = to_mdev(wq->device);
+	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
+	int curr_wq_state;
+	int wq_state;
+	int inlen;
+	int err;
+	void *rqc;
+	void *in;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_rq_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
+
+	curr_wq_state = (attr_mask & IB_WQ_CUR_STATE) ?
+		wq_attr->curr_wq_state : wq->state;
+	wq_state = (attr_mask & IB_WQ_STATE) ?
+		wq_attr->wq_state : curr_wq_state;
+	if (curr_wq_state == IB_WQS_ERR)
+		curr_wq_state = MLX5_RQC_STATE_ERR;
+	if (wq_state == IB_WQS_ERR)
+		wq_state = MLX5_RQC_STATE_ERR;
+	MLX5_SET(modify_rq_in, in, rq_state, curr_wq_state);
+	MLX5_SET(rqc, rqc, state, wq_state);
+
+	err = mlx5_core_modify_rq(dev->mdev, rwq->rqn, in, inlen);
+	kvfree(in);
+	if (!err)
+		rwq->ibwq.state = (wq_state == MLX5_RQC_STATE_ERR) ? IB_WQS_ERR : wq_state;
+
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 76fb7b9..270c699 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -44,6 +44,10 @@ enum {
 	MLX5_SRQ_FLAG_SIGNATURE		= 1 << 0,
 };
 
+enum {
+	MLX5_WQ_FLAG_SIGNATURE		= 1 << 0,
+};
+
 
 /* Increment this value if any changes that break userspace ABI
  * compatibility are made.
@@ -130,4 +134,15 @@ struct mlx5_ib_create_qp {
 struct mlx5_ib_create_qp_resp {
 	__u32	uuar_index;
 };
+
+struct mlx5_ib_create_wq {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	rq_wqe_count;
+	__u32	rq_wqe_shift;
+	__u32	user_index;
+	__u32	flags;
+	__u64	reserved[2];
+};
+
 #endif /* MLX5_IB_USER_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
