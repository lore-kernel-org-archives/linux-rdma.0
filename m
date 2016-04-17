From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 04/10] IB/mlx5: Add receive Work Queue verbs
Date: Sun, 17 Apr 2016 17:27:11 +0300
Message-ID: <1460903237-16870-5-git-send-email-yishaih@mellanox.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903237-16870-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A QP can be created without internal WQs "packaged" inside it,
this QP can be configured to use "external" WQ object as its
receive/send queue.

WQ is a necessary component for RSS technology since RSS mechanism
is supposed to distribute the traffic between multiple
Receive Work Queues

Receive WQs are implemented by RQs.

Implement the WQ creation, modification and destruction verbs.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |   8 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  35 ++++
 drivers/infiniband/hw/mlx5/qp.c      | 306 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h    |  25 +++
 4 files changed, 373 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5acf346..4435958 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2383,9 +2383,15 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	    IB_LINK_LAYER_ETHERNET) {
 		dev->ib_dev.create_flow	= mlx5_ib_create_flow;
 		dev->ib_dev.destroy_flow = mlx5_ib_destroy_flow;
+		dev->ib_dev.create_wq	 = mlx5_ib_create_wq;
+		dev->ib_dev.modify_wq	 = mlx5_ib_modify_wq;
+		dev->ib_dev.destroy_wq	 = mlx5_ib_destroy_wq;
 		dev->ib_dev.uverbs_ex_cmd_mask |=
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW) |
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ);
 	}
 	err = init_node_data(dev);
 	if (err)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f16c818..9a82a0a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -215,12 +215,36 @@ struct mlx5_ib_wq {
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
@@ -625,6 +649,11 @@ static inline struct mlx5_ib_qp *to_mqp(struct ib_qp *ibqp)
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
@@ -760,6 +789,12 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
 int mlx5_mr_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift);
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
+struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata);
+int mlx5_ib_destroy_wq(struct ib_wq *wq);
+int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      u32 wq_attr_mask, struct ib_udata *udata);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 extern struct workqueue_struct *mlx5_ib_page_fault_wq;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8dee8bc..f9ae6b7 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -647,6 +647,71 @@ err_umem:
 	return err;
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
+	rwq->log_page_size =  page_shift - MLX5_ADAPTER_PAGE_SHIFT;
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
 			  struct ib_qp_init_attr *attr,
@@ -4136,3 +4201,244 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 
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
+	struct mlx5_ib_create_wq ucmd = {};
+	int err;
+	size_t required_cmd_sz;
+
+	required_cmd_sz = offsetof(typeof(ucmd), reserved) + sizeof(ucmd.reserved);
+	if (udata->inlen < required_cmd_sz) {
+		mlx5_ib_dbg(dev, "invalid inlen\n");
+		return -EINVAL;
+	}
+
+	if (udata->inlen > sizeof(ucmd) &&
+	    !ib_is_udata_cleared(udata, sizeof(ucmd),
+				 udata->inlen - sizeof(ucmd))) {
+		mlx5_ib_dbg(dev, "inlen is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen))) {
+		mlx5_ib_dbg(dev, "copy failed\n");
+		return -EFAULT;
+	}
+
+	if (ucmd.comp_mask) {
+		mlx5_ib_dbg(dev, "invalid comp mask\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ucmd.reserved) {
+		mlx5_ib_dbg(dev, "invalid reserved\n");
+		return -EOPNOTSUPP;
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
+	struct mlx5_ib_create_wq_resp resp = {};
+	size_t min_resp_len;
+	int err;
+
+	if (!udata)
+		return ERR_PTR(-ENOSYS);
+
+	min_resp_len = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
+	if (udata->outlen && udata->outlen < min_resp_len)
+		return ERR_PTR(-EINVAL);
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
+	if (udata->outlen) {
+		resp.response_length = offsetof(typeof(resp), response_length) +
+				sizeof(resp.response_length);
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err)
+			goto err_copy;
+	}
+
+	return &rwq->ibwq;
+
+err_copy:
+	mlx5_core_destroy_rq(dev->mdev, rwq->rqn);
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
+	mlx5_core_destroy_rq(dev->mdev, rwq->rqn);
+	destroy_user_rq(wq->pd, rwq);
+	kfree(rwq);
+
+	return 0;
+}
+
+int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      u32 wq_attr_mask, struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev = to_mdev(wq->device);
+	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
+	struct mlx5_ib_modify_wq ucmd = {};
+	size_t required_cmd_sz;
+	int curr_wq_state;
+	int wq_state;
+	int inlen;
+	int err;
+	void *rqc;
+	void *in;
+
+	required_cmd_sz = offsetof(typeof(ucmd), reserved) + sizeof(ucmd.reserved);
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
+	inlen = MLX5_ST_SZ_BYTES(modify_rq_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
+
+	curr_wq_state = (wq_attr_mask & IB_WQ_CUR_STATE) ?
+		wq_attr->curr_wq_state : wq->state;
+	wq_state = (wq_attr_mask & IB_WQ_STATE) ?
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
index 61bc308..3e66f93 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -46,6 +46,10 @@ enum {
 	MLX5_SRQ_FLAG_SIGNATURE		= 1 << 0,
 };
 
+enum {
+	MLX5_WQ_FLAG_SIGNATURE		= 1 << 0,
+};
+
 
 /* Increment this value if any changes that break userspace ABI
  * compatibility are made.
@@ -159,6 +163,27 @@ struct mlx5_ib_alloc_mw {
 	__u16	reserved2;
 };
 
+struct mlx5_ib_create_wq {
+	__u64   buf_addr;
+	__u64   db_addr;
+	__u32   rq_wqe_count;
+	__u32   rq_wqe_shift;
+	__u32   user_index;
+	__u32   flags;
+	__u32   comp_mask;
+	__u32   reserved;
+};
+
+struct mlx5_ib_create_wq_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
+struct mlx5_ib_modify_wq {
+	__u32	comp_mask;
+	__u32	reserved;
+};
+
 static inline int get_qp_user_index(struct mlx5_ib_ucontext *ucontext,
 				    struct mlx5_ib_create_qp *ucmd,
 				    int inlen,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
