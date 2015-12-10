From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx5: Add Raw Packet Queue Pair (QP) support
Date: Thu, 10 Dec 2015 21:54:33 +0200
Message-ID: <1449777273-9219-7-git-send-email-majd@mellanox.com>
References: <1449777273-9219-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449777273-9219-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patchs adds support for Raw Packet QP for the mlx5 device.

Raw Packet QP, unlike other QP types, has no matching mlx5_core_qp
object but rather it is built of RQ/SQ/TIR/TIS/TD mlx5_core object.

The Raw Packet QP state changes are implemented by changing the
state of the sub-objects.

Since the SQ and RQ work-queue (WQ) buffers are not contiguous like
other QPs, we allocate separate buffers in the user-space and pass
the address of each one of them separately to the kernel.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c                  |  15 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  52 +-
 drivers/infiniband/hw/mlx5/qp.c                    | 894 ++++++++++++++++++---
 drivers/infiniband/hw/mlx5/user.h                  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  48 +-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c |  39 +
 include/linux/mlx5/mlx5_ifc.h                      |  11 +-
 include/linux/mlx5/qp.h                            |   3 +-
 include/linux/mlx5/transobj.h                      |   4 +
 9 files changed, 913 insertions(+), 154 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1b503e0..de533b9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -680,6 +680,12 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
 #endif
 
+	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain)) {
+		err = mlx5_alloc_transport_domain(dev->mdev, &context->tdn);
+		if (err)
+			goto out_uars;
+	}
+
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
@@ -688,7 +694,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	err = ib_copy_to_udata(udata, &resp,
 			       min(sizeof(resp), udata->outlen));
 	if (err)
-		goto out_uars;
+		goto out_td;
 
 	uuari->ver = ver;
 	uuari->num_low_latency_uuars = req.num_low_latency_uuars;
@@ -696,6 +702,10 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	uuari->num_uars = num_uars;
 	return &context->ibucontext;
 
+out_td:
+	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
+		mlx5_dealloc_transport_domain(dev->mdev, context->tdn);
+
 out_uars:
 	for (i--; i >= 0; i--)
 		mlx5_cmd_free_uar(dev->mdev, uars[i].index);
@@ -720,6 +730,9 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	struct mlx5_uuar_info *uuari = &context->uuari;
 	int i;
 
+	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
+		mlx5_dealloc_transport_domain(dev->mdev, context->tdn);
+
 	for (i = 0; i < uuari->num_uars; i++) {
 		if (mlx5_cmd_free_uar(dev->mdev, uuari->uars[i].index))
 			mlx5_ib_warn(dev, "failed to free UAR 0x%x\n", uuari->uars[i].index);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e1c46c6..dbdf331 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -42,6 +42,7 @@
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/srq.h>
 #include <linux/types.h>
+#include <linux/mlx5/transobj.h>
 
 #define mlx5_ib_dbg(dev, format, arg...)				\
 pr_debug("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
@@ -95,6 +96,8 @@ struct mlx5_ib_ucontext {
 	 */
 	struct mutex		db_page_mutex;
 	struct mlx5_uuar_info	uuari;
+	/* Transport Domain number */
+	u32			tdn;
 };
 
 static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibucontext)
@@ -173,23 +176,52 @@ struct mlx5_ib_pfault {
 	struct mlx5_pagefault	mpfault;
 };
 
+struct mlx5_ib_ubuffer {
+	struct ib_umem	       *umem;
+	int			buf_size;
+	u64			buf_addr;
+};
+
+struct mlx5_ib_rq {
+	struct mlx5_ib_wq	*rq;
+	struct mlx5_core_qp	mrq;
+	struct mlx5_ib_ubuffer  ubuffer;
+	struct mlx5_db		*doorbell;
+	u32			tirn;
+	u8			state;
+};
+
+struct mlx5_ib_sq {
+	struct mlx5_ib_wq	*sq;
+	struct mlx5_core_qp	msq;
+	struct mlx5_ib_ubuffer  ubuffer;
+	struct mlx5_db		*doorbell;
+	u32			tisn;
+	u8			state;
+};
+
+struct mlx5_ib_raw_packet_qp {
+	struct mlx5_ib_sq sq;
+	struct mlx5_ib_rq rq;
+};
+
 struct mlx5_ib_qp {
 	struct ib_qp		ibqp;
-	struct mlx5_core_qp	mqp;
-	struct mlx5_buf		buf;
+	union {
+		struct mlx5_core_qp		mqp;
+		struct mlx5_ib_raw_packet_qp	raw_packet_qp;
+	};
 
-	struct mlx5_db		db;
 	struct mlx5_ib_wq	rq;
+	struct mlx5_ib_wq	sq;
+
+	struct mlx5_buf		buf;
+	struct mlx5_db		db;
+
+	struct mlx5_ib_ubuffer	ubuffer;
 
-	u32			doorbell_qpn;
 	u8			sq_signal_bits;
 	u8			fm_cache;
-	int			sq_max_wqes_per_wr;
-	int			sq_spare_wqes;
-	struct mlx5_ib_wq	sq;
-
-	struct ib_umem	       *umem;
-	int			buf_size;
 
 	/* serialize qp state modifications
 	 */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e0be8b3..a590e47 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -55,6 +55,13 @@ enum {
 	MLX5_IB_CACHE_LINE_SIZE	= 64,
 };
 
+enum {
+	MLX5_RQ_NUM_STATE	= MLX5_RQC_STATE_ERR + 1,
+	MLX5_SQ_NUM_STATE	= MLX5_SQC_STATE_ERR + 1,
+	MLX5_QP_STATE		= MLX5_QP_NUM_STATE + 1,
+	MLX5_QP_STATE_BAD	= MLX5_QP_STATE + 1,
+};
+
 static const u32 mlx5_ib_opcode[] = {
 	[IB_WR_SEND]				= MLX5_OPCODE_SEND,
 	[IB_WR_SEND_WITH_IMM]			= MLX5_OPCODE_SEND_IMM,
@@ -122,7 +129,7 @@ int mlx5_ib_read_user_wqe(struct mlx5_ib_qp *qp, int send, int wqe_index,
 	struct mlx5_ib_wq *wq = send ? &qp->sq : &qp->rq;
 	size_t offset;
 	size_t wq_end;
-	struct ib_umem *umem = qp->umem;
+	struct ib_umem *umem = qp->ubuffer.umem;
 	u32 first_copy_length;
 	int wqe_length;
 	int ret;
@@ -367,7 +374,8 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 
 static int set_user_buf_size(struct mlx5_ib_dev *dev,
 			    struct mlx5_ib_qp *qp,
-			    struct mlx5_ib_create_qp *ucmd)
+			    struct mlx5_ib_create_qp *ucmd,
+			    struct ib_qp_init_attr *attr)
 {
 	int desc_sz = 1 << qp->sq.wqe_shift;
 
@@ -392,8 +400,14 @@ static int set_user_buf_size(struct mlx5_ib_dev *dev,
 		return -EINVAL;
 	}
 
-	qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
-		(qp->sq.wqe_cnt << 6);
+	if (attr->qp_type == IB_QPT_RAW_PACKET) {
+		qp->ubuffer.buf_size = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+		qp->raw_packet_qp.sq.ubuffer.buf_size = qp->sq.wqe_cnt << 6;
+	} else {
+		qp->ubuffer.buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
+				       (qp->sq.wqe_cnt << 6);
+		qp->raw_packet_qp.sq.ubuffer.buf_size = 0;
+	}
 
 	return 0;
 }
@@ -579,8 +593,8 @@ static int to_mlx5_st(enum ib_qp_type type)
 	case IB_QPT_SMI:		return MLX5_QP_ST_QP0;
 	case IB_QPT_GSI:		return MLX5_QP_ST_QP1;
 	case IB_QPT_RAW_IPV6:		return MLX5_QP_ST_RAW_IPV6;
-	case IB_QPT_RAW_ETHERTYPE:	return MLX5_QP_ST_RAW_ETHERTYPE;
 	case IB_QPT_RAW_PACKET:
+	case IB_QPT_RAW_ETHERTYPE:	return MLX5_QP_ST_RAW_ETHERTYPE;
 	case IB_QPT_MAX:
 	default:		return -EINVAL;
 	}
@@ -593,11 +607,13 @@ static int uuarn_to_uar_index(struct mlx5_uuar_info *uuari, int uuarn)
 
 static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			  struct mlx5_ib_qp *qp, struct ib_udata *udata,
+			  struct ib_qp_init_attr *attr,
 			  struct mlx5_create_qp_mbox_in **in,
 			  struct mlx5_ib_create_qp_resp *resp, int *inlen)
 {
 	struct mlx5_ib_ucontext *context;
 	struct mlx5_ib_create_qp ucmd;
+	struct mlx5_ib_ubuffer *ubuffer = &qp->ubuffer;
 	int page_shift = 0;
 	int uar_index;
 	int npages;
@@ -639,32 +655,35 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
 	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
 
-	err = set_user_buf_size(dev, qp, &ucmd);
+	err = set_user_buf_size(dev, qp, &ucmd, attr);
 	if (err)
 		goto err_uuar;
 
-	if (ucmd.buf_addr && qp->buf_size) {
-		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0, 0);
-		if (IS_ERR(qp->umem)) {
+	if (ucmd.buf_addr && ubuffer->buf_size) {
+		ubuffer->buf_addr = ucmd.buf_addr;
+		qp->ubuffer.umem = ib_umem_get(pd->uobject->context,
+					       ucmd.buf_addr, ubuffer->buf_size,
+					       0, 0);
+		if (IS_ERR(qp->ubuffer.umem)) {
 			mlx5_ib_dbg(dev, "umem_get failed\n");
-			err = PTR_ERR(qp->umem);
+			err = PTR_ERR(qp->ubuffer.umem);
 			goto err_uuar;
 		}
 	} else {
-		qp->umem = NULL;
+		qp->ubuffer.umem = NULL;
 	}
 
-	if (qp->umem) {
-		mlx5_ib_cont_pages(qp->umem, ucmd.buf_addr, &npages, &page_shift,
-				   &ncont, NULL);
+	if (qp->ubuffer.umem) {
+		mlx5_ib_cont_pages(qp->ubuffer.umem, ucmd.buf_addr, &npages,
+				   &page_shift, &ncont, NULL);
 		err = mlx5_ib_get_buf_offset(ucmd.buf_addr, page_shift, &offset);
 		if (err) {
 			mlx5_ib_warn(dev, "bad offset\n");
 			goto err_umem;
 		}
 		mlx5_ib_dbg(dev, "addr 0x%llx, size %d, npages %d, page_shift %d, ncont %d, offset %d\n",
-			    ucmd.buf_addr, qp->buf_size, npages, page_shift, ncont, offset);
+			    ucmd.buf_addr, ubuffer->buf_size, npages,
+			    page_shift, ncont, offset);
 	}
 
 	*inlen = sizeof(**in) + sizeof(*(*in)->pas) * ncont;
@@ -673,8 +692,9 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		err = -ENOMEM;
 		goto err_umem;
 	}
-	if (qp->umem)
-		mlx5_ib_populate_pas(dev, qp->umem, page_shift, (*in)->pas, 0);
+	if (qp->ubuffer.umem)
+		mlx5_ib_populate_pas(dev, qp->ubuffer.umem, page_shift,
+				     (*in)->pas, 0);
 	(*in)->ctx.log_pg_sz_remote_qpn =
 		cpu_to_be32((page_shift - MLX5_ADAPTER_PAGE_SHIFT) << 24);
 	(*in)->ctx.params2 = cpu_to_be32(offset << 6);
@@ -705,8 +725,8 @@ err_free:
 	kvfree(*in);
 
 err_umem:
-	if (qp->umem)
-		ib_umem_release(qp->umem);
+	if (qp->ubuffer.umem)
+		ib_umem_release(qp->ubuffer.umem);
 
 err_uuar:
 	free_uuar(&context->uuari, uuarn);
@@ -719,8 +739,8 @@ static void destroy_qp_user(struct ib_pd *pd, struct mlx5_ib_qp *qp)
 
 	context = to_mucontext(pd->uobject->context);
 	mlx5_ib_db_unmap_user(context, &qp->db);
-	if (qp->umem)
-		ib_umem_release(qp->umem);
+	if (qp->ubuffer.umem)
+		ib_umem_release(qp->ubuffer.umem);
 	free_uuar(&context->uuari, qp->uuarn);
 }
 
@@ -759,9 +779,9 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 
 	qp->rq.offset = 0;
 	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
-	qp->buf_size = err + (qp->rq.wqe_cnt << qp->rq.wqe_shift);
+	qp->ubuffer.buf_size = err + (qp->rq.wqe_cnt << qp->rq.wqe_shift);
 
-	err = mlx5_buf_alloc(dev->mdev, qp->buf_size, &qp->buf);
+	err = mlx5_buf_alloc(dev->mdev, qp->ubuffer.buf_size, &qp->buf);
 	if (err) {
 		mlx5_ib_dbg(dev, "err %d\n", err);
 		goto err_uuar;
@@ -854,6 +874,293 @@ static int is_connected(enum ib_qp_type qp_type)
 	return 0;
 }
 
+static int create_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
+				    struct mlx5_ib_sq *sq, u32 tdn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)];
+	void *tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+	memset(in, 0, sizeof(in));
+
+	MLX5_SET(tisc, tisc, transport_domain, tdn);
+
+	return mlx5_core_create_tis(dev->mdev, in, sizeof(in), &sq->tisn);
+}
+
+static void destroy_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
+				      struct mlx5_ib_sq *sq)
+{
+	mlx5_core_destroy_tis(dev->mdev, sq->tisn);
+}
+
+static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
+				   struct mlx5_ib_sq *sq, void *qpin,
+				   struct ib_pd *pd)
+{
+	struct mlx5_ib_ubuffer *ubuffer = &sq->ubuffer;
+	__be64 *pas;
+	void *in;
+	void *sqc;
+	void *qpc = MLX5_ADDR_OF(create_qp_in, qpin, qpc);
+	void *wq;
+	int inlen;
+	int err;
+	int page_shift = 0;
+	int npages;
+	int ncont = 0;
+	u32 offset = 0;
+
+	sq->ubuffer.umem = ib_umem_get(pd->uobject->context, ubuffer->buf_addr,
+				       ubuffer->buf_size, 0, 0);
+	if (IS_ERR(sq->ubuffer.umem)) {
+		mlx5_ib_dbg(dev, "umem_get failed\n");
+		sq->ubuffer.umem = NULL;
+		return -ENOMEM;
+	}
+
+	mlx5_ib_cont_pages(sq->ubuffer.umem, ubuffer->buf_addr, &npages,
+			   &page_shift, &ncont, NULL);
+	err = mlx5_ib_get_buf_offset(ubuffer->buf_addr, page_shift, &offset);
+	if (err) {
+		mlx5_ib_warn(dev, "SQ bad offset\n");
+		err = -EINVAL;
+		goto err_umem;
+	}
+
+	mlx5_ib_dbg(dev, "addr 0x%llx, size %d, npages %d, page_shift %d, ncont %d, offset %d\n",
+		    ubuffer->buf_addr, ubuffer->buf_size, npages,
+		    page_shift, ncont, offset);
+
+	inlen = MLX5_ST_SZ_BYTES(create_sq_in) + sizeof(u64) * ncont;
+	in = mlx5_vzalloc(inlen);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_umem;
+	}
+
+	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
+	MLX5_SET(sqc, sqc, flush_in_error_en, 1);
+	MLX5_SET(sqc, sqc, state, MLX5_SQC_STATE_RST);
+	MLX5_SET(sqc, sqc, user_index, MLX5_GET(qpc, qpc, user_index));
+	MLX5_SET(sqc, sqc, cqn, MLX5_GET(qpc, qpc, cqn_snd));
+	MLX5_SET(sqc, sqc, tis_lst_sz, 1);
+	MLX5_SET(sqc, sqc, tis_num_0, sq->tisn);
+
+	wq = MLX5_ADDR_OF(sqc, sqc, wq);
+	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
+	MLX5_SET(wq, wq, pd, MLX5_GET(qpc, qpc, pd));
+	MLX5_SET(wq, wq, uar_page, MLX5_GET(qpc, qpc, uar_page));
+	MLX5_SET64(wq, wq, dbr_addr, MLX5_GET64(qpc, qpc, dbr_addr));
+	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
+	MLX5_SET(wq, wq, log_wq_sz, MLX5_GET(qpc, qpc, log_sq_size));
+	MLX5_SET(wq, wq, log_wq_pg_sz,  page_shift - MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET(wq, wq, page_offset, offset);
+
+	pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
+	mlx5_ib_populate_pas(dev, sq->ubuffer.umem, page_shift, pas, 0);
+
+	err = mlx5_core_create_sq_tracked(dev->mdev, in, inlen, &sq->msq);
+
+	kvfree(in);
+
+	if (err)
+		goto err_umem;
+
+	return 0;
+
+err_umem:
+	ib_umem_release(sq->ubuffer.umem);
+	sq->ubuffer.umem = NULL;
+
+	return err;
+}
+
+static void destroy_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
+				     struct mlx5_ib_sq *sq)
+{
+	mlx5_core_destroy_sq_tracked(dev->mdev, &sq->msq);
+	if (sq->ubuffer.umem)
+		ib_umem_release(sq->ubuffer.umem);
+}
+
+static int get_rq_pas_size(void *qpc)
+{
+	u32 log_page_size = MLX5_GET(qpc, qpc, log_page_size) + 12;
+	u32 log_rq_stride = MLX5_GET(qpc, qpc, log_rq_stride);
+	u32 log_rq_size   = MLX5_GET(qpc, qpc, log_rq_size);
+	u32 page_offset   = MLX5_GET(qpc, qpc, page_offset);
+	u32 po_quanta	  = 1 << (log_page_size - 6);
+	u32 rq_sz	  = 1 << (log_rq_size + 4 + log_rq_stride);
+	u32 page_size	  = 1 << log_page_size;
+	u32 rq_sz_po      = rq_sz + (page_offset * po_quanta);
+	u32 rq_num_pas	  = (rq_sz_po + page_size - 1) / page_size;
+
+	return rq_num_pas * sizeof(u64);
+}
+
+static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
+				   struct mlx5_ib_rq *rq, void *qpin)
+{
+	__be64 *pas;
+	__be64 *qp_pas;
+	void *in;
+	void *rqc;
+	void *wq;
+	void *qpc = MLX5_ADDR_OF(create_qp_in, qpin, qpc);
+	int inlen;
+	int err;
+	u32 rq_pas_size = get_rq_pas_size(qpc);
+
+	inlen = MLX5_ST_SZ_BYTES(create_rq_in) + rq_pas_size;
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
+	MLX5_SET(rqc, rqc, vsd, 1);
+	MLX5_SET(rqc, rqc, mem_rq_type, MLX5_RQC_MEM_RQ_TYPE_MEMORY_RQ_INLINE);
+	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RST);
+	MLX5_SET(rqc, rqc, flush_in_error_en, 1);
+	MLX5_SET(rqc, rqc, user_index, MLX5_GET(qpc, qpc, user_index));
+	MLX5_SET(rqc, rqc, cqn, MLX5_GET(qpc, qpc, cqn_rcv));
+
+	wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
+	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+	MLX5_SET(wq, wq, page_offset, MLX5_GET(qpc, qpc, page_offset));
+	MLX5_SET(wq, wq, pd, MLX5_GET(qpc, qpc, pd));
+	MLX5_SET64(wq, wq, dbr_addr, MLX5_GET64(qpc, qpc, dbr_addr));
+	MLX5_SET(wq, wq, log_wq_stride, MLX5_GET(qpc, qpc, log_rq_stride) + 4);
+	MLX5_SET(wq, wq, log_wq_pg_sz, MLX5_GET(qpc, qpc, log_page_size));
+	MLX5_SET(wq, wq, log_wq_sz, MLX5_GET(qpc, qpc, log_rq_size));
+
+	pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
+	qp_pas = (__be64 *)MLX5_ADDR_OF(create_qp_in, qpin, pas);
+	memcpy(pas, qp_pas, rq_pas_size);
+
+	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rq->mrq);
+
+	kvfree(in);
+
+	return err;
+}
+
+static void destroy_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
+				     struct mlx5_ib_rq *rq)
+{
+	mlx5_core_destroy_rq_tracked(dev->mdev, &rq->mrq);
+}
+
+static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
+				    struct mlx5_ib_rq *rq, u32 tdn)
+{
+	u32 *in;
+	void *tirc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
+	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
+	MLX5_SET(tirc, tirc, inline_rqn, rq->mrq.qpn);
+	MLX5_SET(tirc, tirc, transport_domain, tdn);
+
+	err = mlx5_core_create_tir(dev->mdev, in, inlen, &rq->tirn);
+
+	kvfree(in);
+
+	return err;
+}
+
+static void destroy_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
+				      struct mlx5_ib_rq *rq)
+{
+	mlx5_core_destroy_tir(dev->mdev, rq->tirn);
+}
+
+static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
+				struct mlx5_create_qp_mbox_in *in,
+				struct ib_pd *pd)
+{
+	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
+	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+	struct ib_uobject *uobj = pd->uobject;
+	struct ib_ucontext *ucontext = uobj->context;
+	struct mlx5_ib_ucontext *mucontext = to_mucontext(ucontext);
+	int err;
+	u32 tdn = mucontext->tdn;
+
+	if (qp->sq.wqe_cnt) {
+		err = create_raw_packet_qp_tis(dev, sq, tdn);
+		if (err)
+			return err;
+
+		err = create_raw_packet_qp_sq(dev, sq, in, pd);
+		if (err)
+			goto err_destroy_tis;
+	}
+
+	if (qp->rq.wqe_cnt) {
+		err = create_raw_packet_qp_rq(dev, rq, in);
+		if (err)
+			goto err_destroy_sq;
+
+		err = create_raw_packet_qp_tir(dev, rq, tdn);
+		if (err)
+			goto err_destroy_rq;
+	}
+
+	qp->mqp.qpn = qp->sq.wqe_cnt ? sq->msq.qpn : rq->mrq.qpn;
+
+	return 0;
+
+err_destroy_rq:
+	destroy_raw_packet_qp_rq(dev, rq);
+err_destroy_sq:
+	if (!qp->sq.wqe_cnt)
+		return err;
+	destroy_raw_packet_qp_sq(dev, sq);
+err_destroy_tis:
+	destroy_raw_packet_qp_tis(dev, sq);
+
+	return err;
+}
+
+static void destroy_raw_packet_qp(struct mlx5_ib_dev *dev,
+				  struct mlx5_ib_qp *qp)
+{
+	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
+	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+
+	if (qp->rq.wqe_cnt) {
+		destroy_raw_packet_qp_tir(dev, rq);
+		destroy_raw_packet_qp_rq(dev, rq);
+	}
+
+	if (qp->sq.wqe_cnt) {
+		destroy_raw_packet_qp_sq(dev, sq);
+		destroy_raw_packet_qp_tis(dev, sq);
+	}
+}
+
+static void raw_packet_qp_copy_info(struct mlx5_ib_qp *qp,
+				    struct mlx5_ib_raw_packet_qp *raw_packet_qp)
+{
+	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+
+	sq->sq = &qp->sq;
+	rq->rq = &qp->rq;
+	sq->doorbell = &qp->db;
+	rq->doorbell = &qp->db;
+}
+
 static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, struct mlx5_ib_qp *qp)
@@ -927,7 +1234,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 					    ucmd.sq_wqe_count, max_wqes);
 				return -EINVAL;
 			}
-			err = create_user_qp(dev, pd, qp, udata, &in, &resp, &inlen);
+			err = create_user_qp(dev, pd, qp, udata, init_attr, &in,
+					     &resp, &inlen);
 			if (err)
 				mlx5_ib_dbg(dev, "err %d\n", err);
 		} else {
@@ -1033,18 +1341,20 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		MLX5_SET(qpc, qpc, user_index, uidx);
 	}
 
-	err = mlx5_core_create_qp(dev->mdev, &qp->mqp, in, inlen);
+	if (init_attr->qp_type == IB_QPT_RAW_PACKET) {
+		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd.sq_buf_addr;
+		raw_packet_qp_copy_info(qp, &qp->raw_packet_qp);
+		err = create_raw_packet_qp(dev, qp, in, pd);
+	} else {
+		err = mlx5_core_create_qp(dev->mdev, &qp->mqp, in, inlen);
+	}
+
 	if (err) {
 		mlx5_ib_dbg(dev, "create qp failed\n");
 		goto err_create;
 	}
 
 	kvfree(in);
-	/* Hardware wants QPN written in big-endian order (after
-	 * shifting) for send doorbell.  Precompute this value to save
-	 * a little bit when posting sends.
-	 */
-	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
 
 	qp->mqp.event = mlx5_ib_qp_event;
 
@@ -1144,11 +1454,11 @@ static void get_cqs(struct mlx5_ib_qp *qp,
 	case IB_QPT_UD:
 	case IB_QPT_RAW_IPV6:
 	case IB_QPT_RAW_ETHERTYPE:
+	case IB_QPT_RAW_PACKET:
 		*send_cq = to_mcq(qp->ibqp.send_cq);
 		*recv_cq = to_mcq(qp->ibqp.recv_cq);
 		break;
 
-	case IB_QPT_RAW_PACKET:
 	case IB_QPT_MAX:
 	default:
 		*send_cq = NULL;
@@ -1157,6 +1467,9 @@ static void get_cqs(struct mlx5_ib_qp *qp,
 	}
 }
 
+static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
+				u16 operation);
+
 static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
 	struct mlx5_ib_cq *send_cq, *recv_cq;
@@ -1169,9 +1482,16 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 
 	if (qp->state != IB_QPS_RESET) {
 		mlx5_ib_qp_disable_pagefaults(qp);
-		if (mlx5_core_qp_modify(dev->mdev, to_mlx5_state(qp->state),
-					MLX5_QP_STATE_RST, in, 0, &qp->mqp))
-			mlx5_ib_warn(dev, "mlx5_ib: modify QP %06x to RESET failed\n",
+		if (qp->ibqp.qp_type != IB_QPT_RAW_PACKET) {
+			err = mlx5_core_qp_modify(dev->mdev,
+						  MLX5_CMD_OP_2RST_QP, in, 0,
+						  &qp->mqp);
+		} else {
+			err = modify_raw_packet_qp(dev, qp,
+						   MLX5_CMD_OP_2RST_QP);
+		}
+		if (err)
+			mlx5_ib_warn(dev, "mlx5_ib: modify QP 0x%06x to RESET failed\n",
 				     qp->mqp.qpn);
 	}
 
@@ -1186,11 +1506,16 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 		mlx5_ib_unlock_cqs(send_cq, recv_cq);
 	}
 
-	err = mlx5_core_destroy_qp(dev->mdev, &qp->mqp);
-	if (err)
-		mlx5_ib_warn(dev, "failed to destroy QP 0x%x\n", qp->mqp.qpn);
-	kfree(in);
+	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET) {
+		destroy_raw_packet_qp(dev, qp);
+	} else {
+		err = mlx5_core_destroy_qp(dev->mdev, &qp->mqp);
+		if (err)
+			mlx5_ib_warn(dev, "failed to destroy QP 0x%x\n",
+				     qp->mqp.qpn);
+	}
 
+	kfree(in);
 
 	if (qp->create_type == MLX5_QP_KERNEL)
 		destroy_qp_kernel(dev, qp);
@@ -1265,6 +1590,11 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 		}
 
 		/* fall through */
+	case IB_QPT_RAW_PACKET:
+		if (!pd->uobject) {
+			mlx5_ib_dbg(dev, "Raw Packet QP is not supported for Kernel consumers\n");
+			return ERR_PTR(-EINVAL);
+		}
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
@@ -1299,7 +1629,6 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 
 	case IB_QPT_RAW_IPV6:
 	case IB_QPT_RAW_ETHERTYPE:
-	case IB_QPT_RAW_PACKET:
 	case IB_QPT_MAX:
 	default:
 		mlx5_ib_dbg(dev, "unsupported qp type %d\n",
@@ -1375,7 +1704,33 @@ static int ib_rate_to_mlx5(struct mlx5_ib_dev *dev, u8 rate)
 	return rate + MLX5_STAT_RATE_OFFSET;
 }
 
-static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
+static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
+				      struct mlx5_ib_sq *sq, u8 sl)
+{
+	void *in;
+	void *tisc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_tis_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_tis_in, in, bitmask.prio, 1);
+
+	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
+	MLX5_SET(tisc, tisc, prio, ((sl & 0x7) << 1));
+
+	err = mlx5_core_modify_tis(dev, sq->tisn, in, inlen);
+
+	kvfree(in);
+
+	return err;
+}
+
+static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
+			 const struct ib_ah_attr *ah,
 			 struct mlx5_qp_path *path, u8 port, int attr_mask,
 			 u32 path_flags, const struct ib_qp_attr *attr)
 {
@@ -1418,6 +1773,11 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 
 	path->sl = ah->sl & 0xf;
 
+	if ((qp->ibqp.qp_type == IB_QPT_RAW_PACKET) && qp->sq.wqe_cnt)
+		return modify_raw_packet_eth_prio(dev->mdev,
+						  &qp->raw_packet_qp.sq,
+						  path->sl);
+
 	return 0;
 }
 
@@ -1564,10 +1924,152 @@ static int ib_mask_to_mlx5_opt(int ib_mask)
 	return result;
 }
 
+static int modify_raw_packet_qp_rq(struct mlx5_core_dev *dev,
+				   struct mlx5_ib_rq *rq, int new_state)
+{
+	void *in;
+	void *rqc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_rq_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_rq_in, in, rq_state, rq->state);
+
+	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
+	MLX5_SET(rqc, rqc, state, new_state);
+
+	err = mlx5_core_modify_rq(dev, rq->mrq.qpn, in, inlen);
+	if (err)
+		goto out;
+
+	rq->state = new_state;
+
+out:
+	kvfree(in);
+	return err;
+}
+
+static int modify_raw_packet_qp_sq(struct mlx5_core_dev *dev,
+				   struct mlx5_ib_sq *sq, int new_state)
+{
+	void *in;
+	void *sqc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_sq_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_sq_in, in, sq_state, sq->state);
+
+	sqc = MLX5_ADDR_OF(modify_sq_in, in, ctx);
+	MLX5_SET(sqc, sqc, state, new_state);
+
+	err = mlx5_core_modify_sq(dev, sq->msq.qpn, in, inlen);
+	if (err)
+		goto out;
+
+	sq->state = new_state;
+
+out:
+	kvfree(in);
+	return err;
+}
+
+static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
+				u16 operation)
+{
+	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
+	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+	int rq_state;
+	int sq_state;
+	int err;
+
+	switch (operation) {
+	case MLX5_CMD_OP_RST2INIT_QP:
+		rq_state = MLX5_RQC_STATE_RDY;
+		sq_state = MLX5_SQC_STATE_RDY;
+		break;
+	case MLX5_CMD_OP_2ERR_QP:
+		rq_state = MLX5_RQC_STATE_ERR;
+		sq_state = MLX5_SQC_STATE_ERR;
+		break;
+	case MLX5_CMD_OP_2RST_QP:
+		rq_state = MLX5_RQC_STATE_RST;
+		sq_state = MLX5_SQC_STATE_RST;
+		break;
+	case MLX5_CMD_OP_INIT2INIT_QP:
+	case MLX5_CMD_OP_INIT2RTR_QP:
+	case MLX5_CMD_OP_RTR2RTS_QP:
+	case MLX5_CMD_OP_RTS2RTS_QP:
+		/* Nothing to do here... */
+		return 0;
+
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (qp->rq.wqe_cnt) {
+		err =  modify_raw_packet_qp_rq(dev->mdev, rq, rq_state);
+		if (err)
+			return err;
+	}
+
+	if (qp->sq.wqe_cnt)
+		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state);
+
+	return 0;
+}
+
 static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
 {
+	static const u16 optab[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE] = {
+		[MLX5_QP_STATE_RST] = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+			[MLX5_QP_STATE_INIT]	= MLX5_CMD_OP_RST2INIT_QP,
+		},
+		[MLX5_QP_STATE_INIT]  = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+			[MLX5_QP_STATE_INIT]	= MLX5_CMD_OP_INIT2INIT_QP,
+			[MLX5_QP_STATE_RTR]	= MLX5_CMD_OP_INIT2RTR_QP,
+		},
+		[MLX5_QP_STATE_RTR]   = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+			[MLX5_QP_STATE_RTS]	= MLX5_CMD_OP_RTR2RTS_QP,
+		},
+		[MLX5_QP_STATE_RTS]   = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+			[MLX5_QP_STATE_RTS]	= MLX5_CMD_OP_RTS2RTS_QP,
+		},
+		[MLX5_QP_STATE_SQD] = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+		},
+		[MLX5_QP_STATE_SQER] = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+			[MLX5_QP_STATE_RTS]	= MLX5_CMD_OP_SQERR2RTS_QP,
+		},
+		[MLX5_QP_STATE_ERR] = {
+			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
+			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
+		}
+	};
+
 	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_ib_cq *send_cq, *recv_cq;
@@ -1579,6 +2081,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	int sqd_event;
 	int mlx5_st;
 	int err;
+	u16 op;
 
 	in = kzalloc(sizeof(*in), GFP_KERNEL);
 	if (!in)
@@ -1638,7 +2141,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		context->pri_path.port = attr->port_num;
 
 	if (attr_mask & IB_QP_AV) {
-		err = mlx5_set_path(dev, &attr->ah_attr, &context->pri_path,
+		err = mlx5_set_path(dev, qp, &attr->ah_attr, &context->pri_path,
 				    attr_mask & IB_QP_PORT ? attr->port_num : qp->port,
 				    attr_mask, 0, attr);
 		if (err)
@@ -1649,7 +2152,8 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		context->pri_path.ackto_lt |= attr->timeout << 3;
 
 	if (attr_mask & IB_QP_ALT_PATH) {
-		err = mlx5_set_path(dev, &attr->alt_ah_attr, &context->alt_path,
+		err = mlx5_set_path(dev, qp, &attr->alt_ah_attr,
+				    &context->alt_path,
 				    attr->alt_port_num, attr_mask, 0, attr);
 		if (err)
 			goto out;
@@ -1724,12 +2228,20 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	    (new_state == IB_QPS_RESET || new_state == IB_QPS_ERR))
 		mlx5_ib_qp_disable_pagefaults(qp);
 
+	if (mlx5_cur >= MLX5_QP_NUM_STATE || mlx5_new >= MLX5_QP_NUM_STATE ||
+	    !optab[mlx5_cur][mlx5_new])
+		goto out;
+
+	op = optab[mlx5_cur][mlx5_new];
 	optpar = ib_mask_to_mlx5_opt(attr_mask);
 	optpar &= opt_mask[mlx5_cur][mlx5_new][mlx5_st];
 	in->optparam = cpu_to_be32(optpar);
-	err = mlx5_core_qp_modify(dev->mdev, to_mlx5_state(cur_state),
-				  to_mlx5_state(new_state), in, sqd_event,
-				  &qp->mqp);
+
+	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET)
+		err = modify_raw_packet_qp(dev, qp, op);
+	else
+		err = mlx5_core_qp_modify(dev->mdev, op, in, sqd_event,
+					  &qp->mqp);
 	if (err)
 		goto out;
 
@@ -3036,6 +3548,185 @@ static void to_ib_ah_attr(struct mlx5_ib_dev *ibdev, struct ib_ah_attr *ib_ah_at
 	}
 }
 
+static int query_raw_packet_qp_sq_state(struct mlx5_ib_dev *dev,
+					struct mlx5_ib_sq *sq,
+					u8 *sq_state)
+{
+	void *out;
+	void *sqc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(query_sq_out);
+	out = mlx5_vzalloc(inlen);
+	if (!out)
+		return -ENOMEM;
+
+	err = mlx5_core_query_sq(dev->mdev, sq->msq.qpn, out);
+	if (err)
+		goto out;
+
+	sqc = MLX5_ADDR_OF(query_sq_out, out, sq_context);
+	*sq_state = MLX5_GET(sqc, sqc, state);
+	sq->state = *sq_state;
+
+out:
+	kvfree(out);
+	return err;
+}
+
+static int query_raw_packet_qp_rq_state(struct mlx5_ib_dev *dev,
+					struct mlx5_ib_rq *rq,
+					u8 *rq_state)
+{
+	void *out;
+	void *rqc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(query_rq_out);
+	out = mlx5_vzalloc(inlen);
+	if (!out)
+		return -ENOMEM;
+
+	err = mlx5_core_query_rq(dev->mdev, rq->mrq.qpn, out);
+	if (err)
+		goto out;
+
+	rqc = MLX5_ADDR_OF(query_rq_out, out, rq_context);
+	*rq_state = MLX5_GET(rqc, rqc, state);
+	rq->state = *rq_state;
+
+out:
+	kvfree(out);
+	return err;
+}
+
+static int sqrq_state_to_qp_state(u8 sq_state, u8 rq_state,
+				  struct mlx5_ib_qp *qp, u8 *qp_state)
+{
+	static const u8 sqrq_trans[MLX5_RQ_NUM_STATE][MLX5_SQ_NUM_STATE] = {
+		[MLX5_RQC_STATE_RST] = {
+			[MLX5_SQC_STATE_RST]	= IB_QPS_RESET,
+			[MLX5_SQC_STATE_RDY]	= MLX5_QP_STATE_BAD,
+			[MLX5_SQC_STATE_ERR]	= MLX5_QP_STATE_BAD,
+		},
+		[MLX5_RQC_STATE_RDY] = {
+			[MLX5_SQC_STATE_RST]	= MLX5_QP_STATE_BAD,
+			[MLX5_SQC_STATE_RDY]	= MLX5_QP_STATE,
+			[MLX5_SQC_STATE_ERR]	= IB_QPS_SQE,
+		},
+		[MLX5_RQC_STATE_ERR] = {
+			[MLX5_SQC_STATE_RST]    = MLX5_QP_STATE_BAD,
+			[MLX5_SQC_STATE_RDY]	= MLX5_QP_STATE_BAD,
+			[MLX5_SQC_STATE_ERR]	= IB_QPS_ERR,
+		},
+	};
+
+	*qp_state = sqrq_trans[rq_state][sq_state];
+
+	if (*qp_state == MLX5_QP_STATE_BAD)
+		return -EINVAL;
+
+	if (*qp_state == MLX5_QP_STATE) {
+		if (qp->state == IB_QPS_INIT ||
+		    qp->state == IB_QPS_RTR ||
+		    qp->state == IB_QPS_RTS) {
+			*qp_state = qp->state;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int sq_state_to_qp_state(u8 sq_state, struct mlx5_ib_qp *qp,
+				u8 *qp_state)
+{
+	switch (sq_state) {
+	case MLX5_SQC_STATE_RST:
+		*qp_state = IB_QPS_RESET;
+		break;
+	case MLX5_SQC_STATE_RDY:
+		if (qp->state == IB_QPS_INIT ||
+		    qp->state == IB_QPS_RTR ||
+		    qp->state == IB_QPS_RTS)
+			*qp_state = qp->state;
+		else
+			return -EINVAL;
+		break;
+	case MLX5_SQC_STATE_ERR:
+		if (qp->state == IB_QPS_SQE ||
+		    qp->state == IB_QPS_ERR)
+			*qp_state = qp->state;
+		else
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int rq_state_to_qp_state(u8 rq_state, struct mlx5_ib_qp *qp,
+				u8 *qp_state)
+{
+	switch (rq_state) {
+	case MLX5_RQC_STATE_RST:
+		*qp_state = IB_QPS_RESET;
+		break;
+	case MLX5_RQC_STATE_RDY:
+		if (qp->state == IB_QPS_INIT ||
+		    qp->state == IB_QPS_RTR ||
+		    qp->state == IB_QPS_RTS)
+			*qp_state = qp->state;
+		else
+			return -EINVAL;
+		break;
+	case MLX5_RQC_STATE_ERR:
+		*qp_state = IB_QPS_ERR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int query_raw_packet_qp_state(struct mlx5_ib_dev *dev,
+				     struct mlx5_ib_qp *qp,
+				     u8 *raw_packet_qp_state)
+{
+	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
+	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+	int err;
+	u8 sq_state = 0;
+	u8 rq_state = 0;
+
+	if (qp->sq.wqe_cnt) {
+		err = query_raw_packet_qp_sq_state(dev, sq, &sq_state);
+		if (err)
+			return err;
+	}
+
+	if (qp->rq.wqe_cnt) {
+		err = query_raw_packet_qp_rq_state(dev, rq, &rq_state);
+		if (err)
+			return err;
+	}
+
+	if (qp->sq.wqe_cnt && qp->rq.wqe_cnt)
+		return sqrq_state_to_qp_state(sq_state, rq_state, qp,
+					      raw_packet_qp_state);
+	else if (qp->sq.wqe_cnt)
+		return sq_state_to_qp_state(sq_state, qp, raw_packet_qp_state);
+	else
+		return rq_state_to_qp_state(rq_state, qp, raw_packet_qp_state);
+}
+
 int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_mask,
 		     struct ib_qp_init_attr *qp_init_attr)
 {
@@ -3045,6 +3736,7 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 	struct mlx5_qp_context *context;
 	int mlx5_state;
 	int err = 0;
+	u8 raw_packet_qp_state;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	/*
@@ -3055,53 +3747,72 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 #endif
 
 	mutex_lock(&qp->mutex);
-	outb = kzalloc(sizeof(*outb), GFP_KERNEL);
-	if (!outb) {
-		err = -ENOMEM;
-		goto out;
-	}
-	context = &outb->ctx;
-	err = mlx5_core_qp_query(dev->mdev, &qp->mqp, outb, sizeof(*outb));
-	if (err)
-		goto out_free;
 
-	mlx5_state = be32_to_cpu(context->flags) >> 28;
+	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET) {
+		err = query_raw_packet_qp_state(dev, qp, &raw_packet_qp_state);
+		if (err)
+			goto out;
+		qp->state = raw_packet_qp_state;
+		qp_attr->port_num = 1;
+	} else {
+		outb = kzalloc(sizeof(*outb), GFP_KERNEL);
+		if (!outb) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		context = &outb->ctx;
+		err = mlx5_core_qp_query(dev->mdev, &qp->mqp, outb,
+					 sizeof(*outb));
+		if (err) {
+			kfree(outb);
+			goto out;
+		}
+
+		mlx5_state = be32_to_cpu(context->flags) >> 28;
+
+		qp->state		     = to_ib_qp_state(mlx5_state);
+		qp_attr->path_mtu	     = context->mtu_msgmax >> 5;
+		qp_attr->path_mig_state	     =
+			to_ib_mig_state((be32_to_cpu(context->flags) >> 11) & 0x3);
+		qp_attr->qkey		     = be32_to_cpu(context->qkey);
+		qp_attr->rq_psn		     = be32_to_cpu(context->rnr_nextrecvpsn) & 0xffffff;
+		qp_attr->sq_psn		     = be32_to_cpu(context->next_send_psn) & 0xffffff;
+		qp_attr->dest_qp_num	     = be32_to_cpu(context->log_pg_sz_remote_qpn) & 0xffffff;
+		qp_attr->qp_access_flags     =
+			to_ib_qp_access_flags(be32_to_cpu(context->params2));
+
+		if (qp->ibqp.qp_type == IB_QPT_RC ||
+		    qp->ibqp.qp_type == IB_QPT_UC) {
+			to_ib_ah_attr(dev, &qp_attr->ah_attr,
+				      &context->pri_path);
+			to_ib_ah_attr(dev, &qp_attr->alt_ah_attr,
+				      &context->alt_path);
+			qp_attr->alt_pkey_index = context->alt_path.pkey_index & 0x7f;
+			qp_attr->alt_port_num	= qp_attr->alt_ah_attr.port_num;
+		}
+
+		qp_attr->pkey_index = context->pri_path.pkey_index & 0x7f;
+		qp_attr->port_num = context->pri_path.port;
+
+		/* qp_attr->en_sqd_async_notify is only applicable in modify qp */
+		qp_attr->sq_draining = mlx5_state == MLX5_QP_STATE_SQ_DRAINING;
+
+		qp_attr->max_rd_atomic = 1 << ((be32_to_cpu(context->params1) >> 21) & 0x7);
+
+		qp_attr->max_dest_rd_atomic =
+			1 << ((be32_to_cpu(context->params2) >> 21) & 0x7);
+		qp_attr->min_rnr_timer	    =
+			(be32_to_cpu(context->rnr_nextrecvpsn) >> 24) & 0x1f;
+		qp_attr->timeout	    = context->pri_path.ackto_lt >> 3;
+		qp_attr->retry_cnt	    = (be32_to_cpu(context->params1) >> 16) & 0x7;
+		qp_attr->rnr_retry	    = (be32_to_cpu(context->params1) >> 13) & 0x7;
+		qp_attr->alt_timeout	    = context->alt_path.ackto_lt >> 3;
+
+		kfree(outb);
+	}
 
-	qp->state		     = to_ib_qp_state(mlx5_state);
 	qp_attr->qp_state	     = qp->state;
-	qp_attr->path_mtu	     = context->mtu_msgmax >> 5;
-	qp_attr->path_mig_state	     =
-		to_ib_mig_state((be32_to_cpu(context->flags) >> 11) & 0x3);
-	qp_attr->qkey		     = be32_to_cpu(context->qkey);
-	qp_attr->rq_psn		     = be32_to_cpu(context->rnr_nextrecvpsn) & 0xffffff;
-	qp_attr->sq_psn		     = be32_to_cpu(context->next_send_psn) & 0xffffff;
-	qp_attr->dest_qp_num	     = be32_to_cpu(context->log_pg_sz_remote_qpn) & 0xffffff;
-	qp_attr->qp_access_flags     =
-		to_ib_qp_access_flags(be32_to_cpu(context->params2));
-
-	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC) {
-		to_ib_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
-		to_ib_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
-		qp_attr->alt_pkey_index = context->alt_path.pkey_index & 0x7f;
-		qp_attr->alt_port_num	= qp_attr->alt_ah_attr.port_num;
-	}
-
-	qp_attr->pkey_index = context->pri_path.pkey_index & 0x7f;
-	qp_attr->port_num = context->pri_path.port;
-
-	/* qp_attr->en_sqd_async_notify is only applicable in modify qp */
-	qp_attr->sq_draining = mlx5_state == MLX5_QP_STATE_SQ_DRAINING;
-
-	qp_attr->max_rd_atomic = 1 << ((be32_to_cpu(context->params1) >> 21) & 0x7);
-
-	qp_attr->max_dest_rd_atomic =
-		1 << ((be32_to_cpu(context->params2) >> 21) & 0x7);
-	qp_attr->min_rnr_timer	    =
-		(be32_to_cpu(context->rnr_nextrecvpsn) >> 24) & 0x1f;
-	qp_attr->timeout	    = context->pri_path.ackto_lt >> 3;
-	qp_attr->retry_cnt	    = (be32_to_cpu(context->params1) >> 16) & 0x7;
-	qp_attr->rnr_retry	    = (be32_to_cpu(context->params1) >> 13) & 0x7;
-	qp_attr->alt_timeout	    = context->alt_path.ackto_lt >> 3;
 	qp_attr->cur_qp_state	     = qp_attr->qp_state;
 	qp_attr->cap.max_recv_wr     = qp->rq.wqe_cnt;
 	qp_attr->cap.max_recv_sge    = qp->rq.max_gs;
@@ -3128,9 +3839,6 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 	qp_init_attr->sq_sig_type = qp->sq_signal_bits & MLX5_WQE_CTRL_CQ_UPDATE ?
 		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
 
-out_free:
-	kfree(outb);
-
 out:
 	mutex_unlock(&qp->mutex);
 	return err;
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 4d70505..3f02e21 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -130,6 +130,7 @@ struct mlx5_ib_create_qp {
 	__u32	flags;
 	__u32	uidx;
 	__u32	reserved;
+	__u64	sq_buf_addr;
 };
 
 struct mlx5_ib_create_qp_resp {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 0b803a1..590c7fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -345,59 +345,15 @@ int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_core_destroy_qp);
 
-int mlx5_core_qp_modify(struct mlx5_core_dev *dev, enum mlx5_qp_state cur_state,
-			enum mlx5_qp_state new_state,
+int mlx5_core_qp_modify(struct mlx5_core_dev *dev, u16 operation,
 			struct mlx5_modify_qp_mbox_in *in, int sqd_event,
 			struct mlx5_core_qp *qp)
 {
-	static const u16 optab[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE] = {
-		[MLX5_QP_STATE_RST] = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-			[MLX5_QP_STATE_INIT]	= MLX5_CMD_OP_RST2INIT_QP,
-		},
-		[MLX5_QP_STATE_INIT]  = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-			[MLX5_QP_STATE_INIT]	= MLX5_CMD_OP_INIT2INIT_QP,
-			[MLX5_QP_STATE_RTR]	= MLX5_CMD_OP_INIT2RTR_QP,
-		},
-		[MLX5_QP_STATE_RTR]   = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-			[MLX5_QP_STATE_RTS]	= MLX5_CMD_OP_RTR2RTS_QP,
-		},
-		[MLX5_QP_STATE_RTS]   = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-			[MLX5_QP_STATE_RTS]	= MLX5_CMD_OP_RTS2RTS_QP,
-		},
-		[MLX5_QP_STATE_SQD] = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-		},
-		[MLX5_QP_STATE_SQER] = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-			[MLX5_QP_STATE_RTS]	= MLX5_CMD_OP_SQERR2RTS_QP,
-		},
-		[MLX5_QP_STATE_ERR] = {
-			[MLX5_QP_STATE_RST]	= MLX5_CMD_OP_2RST_QP,
-			[MLX5_QP_STATE_ERR]	= MLX5_CMD_OP_2ERR_QP,
-		}
-	};
-
 	struct mlx5_modify_qp_mbox_out out;
 	int err = 0;
-	u16 op;
-
-	if (cur_state >= MLX5_QP_NUM_STATE || new_state >= MLX5_QP_NUM_STATE ||
-	    !optab[cur_state][new_state])
-		return -EINVAL;
 
 	memset(&out, 0, sizeof(out));
-	op = optab[cur_state][new_state];
-	in->hdr.opcode = cpu_to_be16(op);
+	in->hdr.opcode = cpu_to_be16(operation);
 	in->qpn = cpu_to_be32(qp->qpn);
 	err = mlx5_cmd_exec(dev, in, sizeof(*in), &out, sizeof(out));
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index 7523cb1..8d65f6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -111,6 +111,19 @@ void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn)
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
 
+int mlx5_core_query_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *out)
+{
+	u32 in[MLX5_ST_SZ_DW(query_rq_in)];
+	int outlen = MLX5_ST_SZ_BYTES(query_rq_out);
+
+	memset(in, 0, sizeof(in));
+	MLX5_SET(query_rq_in, in, opcode, MLX5_CMD_OP_QUERY_RQ);
+	MLX5_SET(query_rq_in, in, rqn, rqn);
+
+	return mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, outlen);
+}
+EXPORT_SYMBOL(mlx5_core_query_rq);
+
 int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *sqn)
 {
 	u32 out[MLX5_ST_SZ_DW(create_sq_out)];
@@ -151,6 +164,19 @@ void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn)
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
 
+int mlx5_core_query_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *out)
+{
+	u32 in[MLX5_ST_SZ_DW(query_sq_in)];
+	int outlen = MLX5_ST_SZ_BYTES(query_sq_out);
+
+	memset(in, 0, sizeof(in));
+	MLX5_SET(query_sq_in, in, opcode, MLX5_CMD_OP_QUERY_SQ);
+	MLX5_SET(query_sq_in, in, sqn, sqn);
+
+	return mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, outlen);
+}
+EXPORT_SYMBOL(mlx5_core_query_sq);
+
 int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tirn)
 {
@@ -211,6 +237,19 @@ int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 }
 EXPORT_SYMBOL(mlx5_core_create_tis);
 
+int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in,
+			 int inlen)
+{
+	u32 out[MLX5_ST_SZ_DW(modify_tis_out)];
+
+	MLX5_SET(modify_tis_in, in, tisn, tisn);
+	MLX5_SET(modify_tis_in, in, opcode, MLX5_CMD_OP_MODIFY_TIS);
+
+	memset(out, 0, sizeof(out));
+	return mlx5_cmd_exec_check_status(dev, in, inlen, out, sizeof(out));
+}
+EXPORT_SYMBOL(mlx5_core_modify_tis);
+
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_tis_out)];
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index dd20974..186d01c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4031,6 +4031,13 @@ struct mlx5_ifc_modify_tis_out_bits {
 	u8         reserved_1[0x40];
 };
 
+struct mlx5_ifc_modify_tis_bitmask_bits {
+	u8         reserved_0[0x20];
+
+	u8         reserved_1[0x1f];
+	u8         prio[0x1];
+};
+
 struct mlx5_ifc_modify_tis_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_0[0x10];
@@ -4043,7 +4050,7 @@ struct mlx5_ifc_modify_tis_in_bits {
 
 	u8         reserved_3[0x20];
 
-	u8         modify_bitmask[0x40];
+	struct mlx5_ifc_modify_tis_bitmask_bits bitmask;
 
 	u8         reserved_4[0x40];
 
@@ -4171,7 +4178,7 @@ struct mlx5_ifc_modify_rq_in_bits {
 
 	u8         reserved_3[0x20];
 
-	u8         modify_bitmask[0x40];
+	struct mlx5_ifc_modify_tis_bitmask_bits bitmask;
 
 	u8         reserved_4[0x40];
 
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 3c4b3e9..5325061 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -620,8 +620,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 			struct mlx5_core_qp *qp,
 			struct mlx5_create_qp_mbox_in *in,
 			int inlen);
-int mlx5_core_qp_modify(struct mlx5_core_dev *dev, enum mlx5_qp_state cur_state,
-			enum mlx5_qp_state new_state,
+int mlx5_core_qp_modify(struct mlx5_core_dev *dev, u16 operation,
 			struct mlx5_modify_qp_mbox_in *in, int sqd_event,
 			struct mlx5_core_qp *qp);
 int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/transobj.h b/include/linux/mlx5/transobj.h
index 821e71b..e3ff3f2 100644
--- a/include/linux/mlx5/transobj.h
+++ b/include/linux/mlx5/transobj.h
@@ -41,10 +41,12 @@ int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			u32 *rqn);
 int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen);
 void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn);
+int mlx5_core_query_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *out);
 int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			u32 *sqn);
 int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in, int inlen);
 void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn);
+int mlx5_core_query_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *out);
 int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tirn);
 int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
@@ -52,6 +54,8 @@ int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
 void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn);
 int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tisn);
+int mlx5_core_modify_tis(struct mlx5_core_dev *dev, u32 tisn, u32 *in,
+			 int inlen);
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn);
 int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rmpn);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
