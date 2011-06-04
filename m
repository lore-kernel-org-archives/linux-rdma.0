From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 2/2] libmlx4: Add support for XRC extension
Date: Sat, 4 Jun 2011 00:57:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373012B93@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement the libibverbs xrc support using the defined xrc
extension.

This patch is based on a patch by Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This is an adapted version of patches found in the ofed_1_5 libmlx4
git tree.  It compiles, but would likely be a miracle if it ran
successfully the first time.  I'm including it for early review and
as a sample of implementing the libibverbs xrc extensions.

 src/cq.c       |   39 +++++++---
 src/mlx4-abi.h |    9 ++
 src/mlx4-ext.c |  214 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mlx4-ext.h |   95 ++++++++++++++++++++++++-
 src/mlx4.c     |    3 +
 src/mlx4.h     |    6 +-
 src/qp.c       |   12 ++-
 src/verbs.c    |   44 ++++++------
 8 files changed, 381 insertions(+), 41 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8226b6b..95429db 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -46,6 +46,7 @@
 
 #include "mlx4.h"
 #include "doorbell.h"
+#include "mlx4-ext.h"
 
 enum {
 	MLX4_CQ_DOORBELL			= 0x20
@@ -216,34 +217,43 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	rmb();
 
 	qpn = ntohl(cqe->my_qpn);
+	wc->qp_num = qpn & 0xffffff;
 
 	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
 	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
 		MLX4_CQE_OPCODE_ERROR;
 
-	if (!*cur_qp ||
-	    (ntohl(cqe->my_qpn) & 0xffffff) != (*cur_qp)->ibv_qp.qp_num) {
+	if ((qpn & MLX4_XRC_QPN_BIT) && !is_send) {
 		/*
-		 * We do not have to take the QP table lock here,
-		 * because CQs will be locked while QPs are removed
+		 * We do not have to take the XSRQ table lock here,
+		 * because CQs will be locked while SRQs are removed
 		 * from the table.
 		 */
-		*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context),
-				       ntohl(cqe->my_qpn) & 0xffffff);
-		if (!*cur_qp)
+		srq = mlx4_find_xsrq(to_mctx(cq->ibv_cq.context),
+				     ntohl(cqe->g_mlpath_rqpn) & 0xffffff);
+		if (!srq)
 			return CQ_POLL_ERR;
+	} else {
+		if (!*cur_qp || (wc->qp_num != (*cur_qp)->ibv_qp.qp_num)) {
+			/*
+			 * We do not have to take the QP table lock here,
+			 * because CQs will be locked while QPs are removed
+			 * from the table.
+			 */
+			*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context), wc->qp_num);
+			if (!*cur_qp)
+				return CQ_POLL_ERR;
+		}
+		srq = ((*cur_qp)->ibv_qp.srq) ? to_msrq((*cur_qp)->ibv_qp.srq) : NULL;
 	}
 
-	wc->qp_num = (*cur_qp)->ibv_qp.qp_num;
-
 	if (is_send) {
 		wq = &(*cur_qp)->sq;
 		wqe_index = ntohs(cqe->wqe_index);
 		wq->tail += (uint16_t) (wqe_index - (uint16_t) wq->tail);
 		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
-	} else if ((*cur_qp)->ibv_qp.srq) {
-		srq = to_msrq((*cur_qp)->ibv_qp.srq);
+	} else if (srq) {
 		wqe_index = htons(cqe->wqe_index);
 		wc->wr_id = srq->wrid[wqe_index];
 		mlx4_free_srq_wqe(srq, wqe_index);
@@ -405,7 +415,12 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	 */
 	while ((int) --prod_index - (int) cq->cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
-		if ((ntohl(cqe->my_qpn) & 0xffffff) == qpn) {
+		if (srq && (MLX4_GET_SRQT(srq) == IBV_SRQT_XRC) &&
+		    (ntohl(cqe->g_mlpath_rqpn & 0xffffff) == MLX4_GET_SRQN(srq)) &&
+		    !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK)) {
+			mlx4_free_srq_wqe(srq, ntohs(cqe->wqe_index));
+			++nfreed;
+		} else if ((ntohl(cqe->my_qpn) & 0xffffff) == qpn) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_free_srq_wqe(srq, ntohs(cqe->wqe_index));
 			++nfreed;
diff --git a/src/mlx4-abi.h b/src/mlx4-abi.h
index 20a40c9..a35aa20 100644
--- a/src/mlx4-abi.h
+++ b/src/mlx4-abi.h
@@ -33,6 +33,7 @@
 #ifndef MLX4_ABI_H
 #define MLX4_ABI_H
 
+#include <infiniband/verbs.h>
 #include <infiniband/kern-abi.h>
 
 #define MLX4_UVERBS_MIN_ABI_VERSION	2
@@ -74,6 +75,14 @@ struct mlx4_create_srq {
 	__u64				db_addr;
 };
 
+#ifdef IBV_XRC_OPS
+struct mlx4_create_xsrq {
+	struct ibv_create_xsrq		ibv_cmd;
+	__u64				buf_addr;
+	__u64				db_addr;
+};
+#endif /* IBV_XRC_OPS */
+
 struct mlx4_create_srq_resp {
 	struct ibv_create_srq_resp	ibv_resp;
 	__u32				srqn;
diff --git a/src/mlx4-ext.c b/src/mlx4-ext.c
index 7734720..79987cb 100644
--- a/src/mlx4-ext.c
+++ b/src/mlx4-ext.c
@@ -45,6 +45,211 @@
 #include "mlx4-abi.h"
 #include "mlx4-ext.h"
 
+#ifdef IBV_XRC_OPS
+struct ibv_xrcd *mlx4_open_xrcd(struct ibv_context *context, int fd, int oflags)
+{
+	struct ibv_open_xrcd cmd;
+	struct ibv_open_xrcd_resp resp;
+	struct ibv_xrcd *xrcd;
+	int ret;
+
+	xrcd = calloc(1, sizeof *xrcd);
+	if (!xrcd)
+		return NULL;
+
+	ret = ibv_cmd_open_xrcd(context, xrcd, fd, oflags,
+				&cmd, sizeof cmd, &resp, sizeof resp);
+	if (ret)
+		goto err;
+
+	return xrcd;
+
+err:
+	free(xrcd);
+	return NULL;
+}
+
+int mlx4_close_xrcd(struct ibv_xrcd *xrcd)
+{
+	int ret;
+
+	ret = ibv_cmd_close_xrcd(xrcd);
+	if (!ret)
+		free(xrcd);
+
+	return ret;
+}
+
+struct ibv_srq *mlx4_create_xsrq(struct ibv_pd *pd, struct ibv_xrcd *xrcd,
+				 struct ibv_cq *cq, struct ibv_srq_init_attr *attr)
+{
+	struct mlx4_create_xsrq cmd;
+	struct mlx4_create_srq_resp resp;
+	struct mlx4_srq *srq;
+	int ret;
+
+	/* Sanity check SRQ size before proceeding */
+	if (attr->attr.max_wr > 1 << 16 || attr->attr.max_sge > 64)
+		return NULL;
+
+	srq = calloc(1, sizeof *srq);
+	if (!srq)
+		return NULL;
+
+	if (pthread_spin_init(&srq->lock, PTHREAD_PROCESS_PRIVATE))
+		goto err;
+
+	srq->max     = align_queue_size(attr->attr.max_wr + 1);
+	srq->max_gs  = attr->attr.max_sge;
+	srq->counter = 0;
+
+	if (mlx4_alloc_srq_buf(pd, &attr->attr, srq))
+		goto err;
+
+	srq->db = mlx4_alloc_db(to_mctx(pd->context), MLX4_DB_TYPE_RQ);
+	if (!srq->db)
+		goto err_free;
+
+	*srq->db = 0;
+
+	cmd.buf_addr = (uintptr_t) srq->buf.buf;
+	cmd.db_addr  = (uintptr_t) srq->db;
+
+	srq->srq_type = IBV_SRQT_XRC;
+	srq->ext.xrc.xrcd = xrcd;
+	srq->ext.xrc.cq = cq;
+
+	ret = ibv_cmd_create_xsrq(pd, &srq->ibv_srq, attr,
+				  &cmd.ibv_cmd, sizeof cmd,
+				  &resp.ibv_resp, sizeof resp);
+	if (ret)
+		goto err_db;
+
+	return &srq->ibv_srq;
+
+err_db:
+	mlx4_free_db(to_mctx(pd->context), MLX4_DB_TYPE_RQ, srq->db);
+err_free:
+	free(srq->wrid);
+	mlx4_free_buf(&srq->buf);
+err:
+	free(srq);
+	return NULL;
+}
+
+int mlx4_destroy_xsrq(struct ibv_srq *srq)
+{
+	struct mlx4_context *mctx = to_mctx(srq->context);
+	struct mlx4_srq *msrq = to_msrq(srq);
+	struct mlx4_cq *mcq;
+	int ret;
+
+	if (srq->srq_type == IBV_SRQT_XRC) {
+		mcq = to_mcq(srq->ext.xrc.cq);
+		mlx4_cq_clean(mcq, 0, msrq);
+		pthread_spin_lock(&mcq->lock);
+		mlx4_clear_xsrq(mctx, srq->ext.xrc.srq_num);
+		pthread_spin_unlock(&mcq->lock);
+	}
+
+	ret = ibv_cmd_destroy_srq(srq);
+	if (ret) {
+		if (srq->srq_type == IBV_SRQT_XRC) {
+			pthread_spin_lock(&mcq->lock);
+			mlx4_store_xsrq(mctx, srq->ext.xrc.srq_num);
+			pthread_spin_unlock(&mcq->lock);
+		}
+		return ret;
+	}
+
+	mlx4_free_db(mctx, MLX4_DB_TYPE_RQ, msrq->db);
+	mlx4_free_buf(&msrq->buf);
+	free(msrq->wrid);
+	free(msrq);
+
+	return 0;
+}
+
+void mlx4_init_xsrq_table(struct mlx4_xsrq_table *xsrq_table, int size)
+{
+	memset(xsrq_table, 0, sizeof *xsrq_table);
+	xsrq_table->num_xsrq = size;
+	xsrq_table->shift = ffs(size) - 1 - MLX4_XSRQ_TABLE_BITS;
+	xsrq_table->mask = (1 << xsrq_table->shift) - 1;
+
+	pthread_mutex_init(&db_xsrq->mutex, NULL);
+}
+
+struct mlx4_srq *mlx4_find_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn)
+{
+	int index;
+
+	index = (srqn & (xsrq_table->num_xsrq - 1) >> xsrq_table->shift;
+	if (xsrq_table->xsrq_table[index].refcnt)
+		return xsrq_table->xsrq_table[index].table[srqn & xsrq_table->mask];
+
+	return NULL;
+}
+
+int mlx4_store_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn,
+		    struct mlx4_srq *srq)
+{
+	int index, ret = 0;
+
+	index = (srqn & (xsrq_table->num_xsrq - 1) >> xsrq_table->shift;
+	pthread_mutex_lock(&xsrq_table->mutex);
+	if (!xsrq_table->xsrq_table[index].refcnt) {
+		xsrq_table->xsrq_table[index].table = calloc(xsrq_table->mask + 1,
+							     sizeof(struct mlx4_srq *));
+		if (!xsrq_table->xsrq_table[index]) {
+			ret = -1;
+			goto out;
+		}
+	}
+
+	xsrq_table->xsrq_table[index].refcnt++;
+	xsrq_table->xsrq_table[index].table[srqn & xsrq_table->mask] = srq;
+
+out:
+	pthread_mutex_unlock(&xsrq_table->mutex);
+	return ret;
+}
+
+void mlx4_clear_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn)
+{
+	int index;
+
+	index = (srqn & (xsrq_table->num_xsrq - 1) >> xsrq_table->shift;
+	pthread_mutex_lock(&xsrq_table->mutex);
+
+	if (--xsrq_table->xsrq_table[index].refcnt)
+		xsrq_table->xsrq_table[index].table[srqn & xsrq_table->mask] = NULL;
+	else
+		free(xsrq_table->xsrq_table[index].table);
+
+	pthread_mutex_unlock(&xsrq_table->mutex);
+}
+
+static struct ibv_xrc_ops *mlx4_get_ibv_xrc_ops(void)
+{
+	struct ibv_xrc_ops *ops;
+
+	ops = calloc(1, sizeof *ops);
+	if (!ops)
+		return NULL;
+
+	ops->open_xrcd = mlx4_open_xrcd;
+	ops->close_xrcd = mlx4_close_xrcd;
+	ops->create_srq = mlx4_create_xsrq;
+	return ops;
+}
+#else
+static struct ibv_xrc_ops *mlx4_get_ibv_xrc_ops(void)
+{
+	return NULL;
+}
+#endif /* IBV_XRC_OPS */
+
 int mlx4_have_ext_ops(struct ibv_device *device, const char *ext_name)
 {
 	if (!stricmp(ext_name, "ibv_xrc"))
@@ -61,7 +266,14 @@ void mlx4_device_config_ext(struct ibv_device *device)
 
 static void *mlx4_get_ext_ops(struct ibv_context *context, const char *ext_name)
 {
-	return NULL;
+	void *ops;
+
+	if (!stricmp(ext_name, "ibv_xrc"))
+		ops = mlx4_get_ibv_xrc_ops();
+	else
+		ops = NULL;
+
+	return ops;
 }
 
 void mlx4_context_config_ext(struct ibv_context *ibv_ctx)
diff --git a/src/mlx4-ext.h b/src/mlx4-ext.h
index a91d6ba..b3b20dd 100644
--- a/src/mlx4-ext.h
+++ b/src/mlx4-ext.h
@@ -33,9 +33,13 @@
 #ifndef MLX4_EXT_H
 #define MLX4_EXT_H
 
+#include <pthread.h>
 #include <infiniband/driver.h>
 #include <infiniband/verbs.h>
 
+/*
+ * General verbs extension support
+ */
 #ifdef HAVE_IBV_EXT
 #define IBV_REGISTER_DRIVER_EXT ibv_register_driver_ext
 
@@ -43,10 +47,97 @@ int mlx4_have_ext_ops(struct ibv_device *device, const char *ext_name);
 void mlx4_device_config_ext(struct ibv_device *device);
 void mlx4_context_config_ext(struct ibv_context *context);
 
-#else /* HAVE_IBV_EXT */
+struct ibv_xrcd *mlx4_open_xrcd(struct ibv_context, int fd, int oflags);
+int mlx4_close_xrcd(struct ibv_xrcd *xrcd);
+struct ibv_src *mlx4_create_xsrq(struct ibv_pd *pd, struct ibv_xrcd *xrcd,
+				 struct ibv_cq *cq, struct ibv_srq_init_attr *attr);
+
+#else  /* HAVE_IBV_EXT */
 #define IBV_REGISTER_DRIVER_EXT ibv_register_driver
 #define mlx4_device_config_ext(x)
 #define mlx4_context_config_ext(x)
-#endif
+#endif /* HAVE_IBV_EXT */
+
+
+/*
+ * XRC extension support
+ */
+enum {
+	MLX4_XRC_QPN_BIT     = (1 << 23)
+};
+
+#ifdef IBV_XRC_OPS
+
+static inline struct ibv_context *
+mlx4_get_context_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
+{
+	return (attr->qp_type != IBV_QPT_XRC_RECV) ?
+		pd->context : attr->ext.xrc_recv.xrcd->context;
+}
+
+#define MLX4_REMOTE_SRQN_FLAGS(wr) htonl((wr)->wr.xrc.remote_srqn << 8)
+#define MLX4_SET_SRQT(srq, srqt) (srq)->srq_type = srqt
+#define MLX4_GET_SRQT(srq) (srq)->srq_type
+#define MLX4_GET_SRQN(srq) (srq)->ext.xrc.srq_num
+
+enum {
+	MLX4_XSRQ_TABLE_BITS = 8,
+	MLX4_XSRQ_TABLE_SIZE = 1 << MLX4_XSRQ_TABLE_BITS,
+	MLX4_XSRQ_TABLE_MASK = MLX4_XSRQ_TABLE_SIZE - 1
+};
+
+struct mlx4_xsrq_table {
+	struct {
+		struct mlx4_srq **table;
+		int		  refcnt;
+	} xsrq_table[MLX4_XSRQ_TABLE_SIZE];
+
+	pthread_mutex_t		  mutex;
+	int			  num_xsrq;
+	int			  shift;
+	int			  mask;
+};
+
+int mlx4_destroy_xsrq(struct ibv_srq *srq);
+#define MLX4_DESTROY_SRQ mlx4_destroy_xsrq
+
+void mlx4_init_xsrq_table(struct mlx4_xsrq_table *xsrq_table, int size);
+struct mlx4_srq *mlx4_find_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn);
+int mlx4_store_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn,
+		    struct mlx4_srq *srq);
+void mlx4_clear_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn);
+
+
+#else  /* IBV_XRC_OPS */
+
+static inline struct ibv_context *
+mlx4_get_context_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
+{
+	return pd->context;
+}
+
+#define MLX4_REMOTE_SRQN_FLAGS(wr) 0
+
+enum ibv_srq_type {
+	IBV_SRQT_BASIC,
+	IBV_SRQT_XRC
+};
+
+#define MLX4_SET_SRQT(srq, srqt)
+#define MLX4_GET_SRQT(srq) IBV_SRQT_BASIC
+#define MLX4_GET_SRQN(srq) 0
+#define IBV_QPT_XRC_SEND 0
+#define IBV_QPT_XRC_RECV 0
+
+#define MLX4_DESTROY_SRQ mlx4_destroy_srq
+
+struct mlx4_xsrq_table {};
+#define mlx4_init_xsrq_table(t, s)
+#define mlx4_find_xsrq(t, n) NULL
+#define mlx4_store_xsrq(t, n, s) ENOSYS
+#define mlx4_clear_xsrq(t, n)
+
+#endif /* IBV_XRC_OPS */
+
 
 #endif /* MLX4_EXT_H */
diff --git a/src/mlx4.c b/src/mlx4.c
index 2a091a1..9932f55 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -85,7 +85,7 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.create_srq    = mlx4_create_srq,
 	.modify_srq    = mlx4_modify_srq,
 	.query_srq     = mlx4_query_srq,
-	.destroy_srq   = mlx4_destroy_srq,
+	.destroy_srq   = MLX4_DESTROY_SRQ,
 	.post_srq_recv = mlx4_post_srq_recv,
 	.create_qp     = mlx4_create_qp,
 	.query_qp      = mlx4_query_qp,
@@ -127,6 +127,7 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 	for (i = 0; i < MLX4_NUM_DB_TYPE; ++i)
 		context->db_list[i] = NULL;
 
+	mlx4_init_xsrq_table(&context->xsrq_table, resp.qp_tab_size);
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
 	context->uar = mmap(NULL, to_mdev(ibdev)->page_size, PROT_WRITE,
diff --git a/src/mlx4.h b/src/mlx4.h
index 4445998..b0558c8 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -39,6 +39,8 @@
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
 
+#include "mlx4-ext.h"
+
 #ifdef HAVE_VALGRIND_MEMCHECK_H
 
 #  include <valgrind/memcheck.h>
@@ -157,6 +159,8 @@ struct mlx4_context {
 	int				qp_table_shift;
 	int				qp_table_mask;
 
+	struct mlx4_xsrq_table		xsrq_table;
+
 	struct mlx4_db_page	       *db_list[MLX4_NUM_DB_TYPE];
 	pthread_mutex_t			db_list_mutex;
 };
@@ -349,7 +353,7 @@ int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
 void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 			   struct mlx4_qp *qp);
-int mlx4_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
+int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
 		       enum ibv_qp_type type, struct mlx4_qp *qp);
 void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
 		       enum ibv_qp_type type);
diff --git a/src/qp.c b/src/qp.c
index d194ae3..b78242e 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -44,6 +44,7 @@
 #include "mlx4.h"
 #include "doorbell.h"
 #include "wqe.h"
+#include "mlx4-ext.h"
 
 static const uint32_t mlx4_ib_opcode[] = {
 	[IBV_WR_SEND]			= MLX4_OPCODE_SEND,
@@ -243,6 +244,9 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		size = sizeof *ctrl / 16;
 
 		switch (ibqp->qp_type) {
+		case IBV_QPT_XRC_SEND:
+			ctrl->srcrb_flags |= MLX4_REMOTE_SRQN_FLAGS(wr);
+			/* fall through */
 		case IBV_QPT_RC:
 		case IBV_QPT_UC:
 			switch (wr->opcode) {
@@ -543,6 +547,7 @@ void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 		size += sizeof (struct mlx4_wqe_raddr_seg);
 		break;
 
+	case IBV_QPT_XRC_SEND:
 	case IBV_QPT_RC:
 		size += sizeof (struct mlx4_wqe_raddr_seg);
 		/*
@@ -572,7 +577,7 @@ void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 		; /* nothing */
 }
 
-int mlx4_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
+int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
 		       enum ibv_qp_type type, struct mlx4_qp *qp)
 {
 	qp->rq.max_gs	 = cap->max_recv_sge;
@@ -605,8 +610,8 @@ int mlx4_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 	}
 
 	if (mlx4_alloc_buf(&qp->buf,
-			    align(qp->buf_size, to_mdev(pd->context->device)->page_size),
-			    to_mdev(pd->context->device)->page_size)) {
+			    align(qp->buf_size, to_mdev(context->device)->page_size),
+			    to_mdev(context->device)->page_size)) {
 		free(qp->sq.wrid);
 		free(qp->rq.wrid);
 		return -1;
@@ -628,6 +633,7 @@ void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
 		wqe_size -= sizeof (struct mlx4_wqe_datagram_seg);
 		break;
 
+	case IBV_QPT_XRC_SEND:
 	case IBV_QPT_UC:
 	case IBV_QPT_RC:
 		wqe_size -= sizeof (struct mlx4_wqe_raddr_seg);
diff --git a/src/verbs.c b/src/verbs.c
index 1ac1362..6772637 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -334,7 +334,7 @@ struct ibv_srq *mlx4_create_srq(struct ibv_pd *pd,
 	if (ret)
 		goto err_db;
 
-	srq->srqn = resp.srqn;
+	MLX4_SET_SRQT(srq, IBV_SRQT_BASIC);
 
 	return &srq->ibv_srq;
 
@@ -386,6 +386,7 @@ int mlx4_destroy_srq(struct ibv_srq *srq)
 
 struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 {
+	struct ibv_context	 *context;
 	struct mlx4_create_qp     cmd;
 	struct ibv_create_qp_resp resp;
 	struct mlx4_qp		 *qp;
@@ -399,6 +400,7 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	    attr->cap.max_inline_data > 1024)
 		return NULL;
 
+	context = mlx4_get_context_qp(pd, attr);
 	qp = malloc(sizeof *qp);
 	if (!qp)
 		return NULL;
@@ -411,18 +413,19 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	 */
 	qp->sq_spare_wqes = (2048 >> qp->sq.wqe_shift) + 1;
 	qp->sq.wqe_cnt = align_queue_size(attr->cap.max_send_wr + qp->sq_spare_wqes);
-	qp->rq.wqe_cnt = align_queue_size(attr->cap.max_recv_wr);
 
-	if (attr->srq)
+	if (attr->srq || attr->qp_type == IBV_QPT_XRC_SEND ||
+	    attr->qp_type == IBV_QPT_XRC_RECV) {
 		attr->cap.max_recv_wr = qp->rq.wqe_cnt = 0;
-	else {
+	} else {
+		qp->rq.wqe_cnt = align_queue_size(attr->cap.max_recv_wr);
 		if (attr->cap.max_recv_sge < 1)
 			attr->cap.max_recv_sge = 1;
 		if (attr->cap.max_recv_wr < 1)
 			attr->cap.max_recv_wr = 1;
 	}
 
-	if (mlx4_alloc_qp_buf(pd, &attr->cap, attr->qp_type, qp))
+	if (mlx4_alloc_qp_buf(context, &attr->cap, attr->qp_type, qp))
 		goto err;
 
 	mlx4_init_qp_indices(qp);
@@ -431,19 +434,18 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	    pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE))
 		goto err_free;
 
-	if (!attr->srq) {
-		qp->db = mlx4_alloc_db(to_mctx(pd->context), MLX4_DB_TYPE_RQ);
+	if (attr->cap.max_recv_sge) {
+		qp->db = mlx4_alloc_db(to_mctx(context), MLX4_DB_TYPE_RQ);
 		if (!qp->db)
 			goto err_free;
 
 		*qp->db = 0;
+		cmd.db_addr = (uintptr_t) qp->db;
+	} else {
+		cmd.db_addr = 0;
 	}
 
 	cmd.buf_addr	    = (uintptr_t) qp->buf.buf;
-	if (attr->srq)
-		cmd.db_addr = 0;
-	else
-		cmd.db_addr = (uintptr_t) qp->db;
 	cmd.log_sq_stride   = qp->sq.wqe_shift;
 	for (cmd.log_sq_bb_count = 0;
 	     qp->sq.wqe_cnt > 1 << cmd.log_sq_bb_count;
@@ -452,17 +454,17 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	cmd.sq_no_prefetch = 0;	/* OK for ABI 2: just a reserved field */
 	memset(cmd.reserved, 0, sizeof cmd.reserved);
 
-	pthread_mutex_lock(&to_mctx(pd->context)->qp_table_mutex);
+	pthread_mutex_lock(&to_mctx(context)->qp_table_mutex);
 
 	ret = ibv_cmd_create_qp(pd, &qp->ibv_qp, attr, &cmd.ibv_cmd, sizeof cmd,
 				&resp, sizeof resp);
 	if (ret)
 		goto err_rq_db;
 
-	ret = mlx4_store_qp(to_mctx(pd->context), qp->ibv_qp.qp_num, qp);
+	ret = mlx4_store_qp(to_mctx(context), qp->ibv_qp.qp_num, qp);
 	if (ret)
 		goto err_destroy;
-	pthread_mutex_unlock(&to_mctx(pd->context)->qp_table_mutex);
+	pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
 
 	qp->rq.wqe_cnt = qp->rq.max_post = attr->cap.max_recv_wr;
 	qp->rq.max_gs  = attr->cap.max_recv_sge;
@@ -480,9 +482,9 @@ err_destroy:
 	ibv_cmd_destroy_qp(&qp->ibv_qp);
 
 err_rq_db:
-	pthread_mutex_unlock(&to_mctx(pd->context)->qp_table_mutex);
-	if (!attr->srq)
-		mlx4_free_db(to_mctx(pd->context), MLX4_DB_TYPE_RQ, qp->db);
+	pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
+	if (attr->cap.max_recv_sge)
+		mlx4_free_db(to_mctx(context), MLX4_DB_TYPE_RQ, qp->db);
 
 err_free:
 	free(qp->sq.wrid);
@@ -540,7 +542,7 @@ int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 			mlx4_cq_clean(to_mcq(qp->send_cq), qp->qp_num, NULL);
 
 		mlx4_init_qp_indices(to_mqp(qp));
-		if (!qp->srq)
+		if (to_mqp(qp)->rq.wqe_cnt)
 			*to_mqp(qp)->db = 0;
 	}
 
@@ -603,11 +605,11 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 	mlx4_unlock_cqs(ibqp);
 	pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
 
-	if (!ibqp->srq)
+	if (qp->rq.wqe_cnt) {
 		mlx4_free_db(to_mctx(ibqp->context), MLX4_DB_TYPE_RQ, qp->db);
-	free(qp->sq.wrid);
-	if (qp->rq.wqe_cnt)
 		free(qp->rq.wrid);
+	}
+	free(qp->sq.wrid);
 	mlx4_free_buf(&qp->buf);
 	free(qp);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
