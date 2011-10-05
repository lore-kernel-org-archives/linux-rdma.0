From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH - resend] libmlx4: add support for 64 byte CQE
Date: Wed, 5 Oct 2011 14:58:08 +0200
Message-ID: <20111005125808.GG2681@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CX3 devices can work with 64 or 32 byte CQEs. Using 64 byte CQEs allow better
utilization of new chipsets and gaining higher performance. This patch will
read from kernel the configured size of a CQE and use this size in CQ related
code. It also reads the ABI version to a gloabl varialbe and uses it to choose
either the value read from the kernel (ABI > 3), or use the regular 32 byte
value.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 src/cq.c       |   41 +++++++++++++++++++----------------------
 src/mlx4-abi.h |    3 ++-
 src/mlx4.c     |    7 +++++++
 src/mlx4.h     |   24 +++++++++++++++++++-----
 src/verbs.c    |    6 ++++--
 5 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8226b6b..eaadcb0 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -82,21 +82,6 @@ enum {
 	MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
 };
 
-struct mlx4_cqe {
-	uint32_t	my_qpn;
-	uint32_t	immed_rss_invalid;
-	uint32_t	g_mlpath_rqpn;
-	uint8_t		sl;
-	uint8_t		reserved1;
-	uint16_t	rlid;
-	uint32_t	reserved2;
-	uint32_t	byte_cnt;
-	uint16_t	wqe_index;
-	uint16_t	checksum;
-	uint8_t		reserved3[3];
-	uint8_t		owner_sr_opcode;
-};
-
 struct mlx4_err_cqe {
 	uint32_t	my_qpn;
 	uint32_t	reserved1[5];
@@ -109,14 +94,15 @@ struct mlx4_err_cqe {
 
 static struct mlx4_cqe *get_cqe(struct mlx4_cq *cq, int entry)
 {
-	return cq->buf.buf + entry * MLX4_CQ_ENTRY_SIZE;
+	return cq->buf.buf + entry * cq->cqe_size;
 }
 
 static void *get_sw_cqe(struct mlx4_cq *cq, int n)
 {
 	struct mlx4_cqe *cqe = get_cqe(cq, n & cq->ibv_cq.cqe);
+	struct mlx4_cqe *tcqe = cq->cqe_size == 64 ? cqe + 1 : cqe;
 
-	return (!!(cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK) ^
+	return (!!(tcqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK) ^
 		!!(n & (cq->ibv_cq.cqe + 1))) ? NULL : cqe;
 }
 
@@ -205,6 +191,9 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	if (!cqe)
 		return CQ_EMPTY;
 
+	if (cq->cqe_size == 64)
+		++cqe;
+
 	++cq->cons_index;
 
 	VALGRIND_MAKE_MEM_DEFINED(cqe, sizeof *cqe);
@@ -387,6 +376,7 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	uint32_t prod_index;
 	uint8_t owner_bit;
 	int nfreed = 0;
+	int cqe_inc = cq->cqe_size == 64 ? 1 : 0;
 
 	/*
 	 * First we need to find the current producer index, so we
@@ -405,12 +395,14 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	 */
 	while ((int) --prod_index - (int) cq->cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
+		cqe += cqe_inc;
 		if ((ntohl(cqe->my_qpn) & 0xffffff) == qpn) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_free_srq_wqe(srq, ntohs(cqe->wqe_index));
 			++nfreed;
 		} else if (nfreed) {
 			dest = get_cqe(cq, (prod_index + nfreed) & cq->ibv_cq.cqe);
+			dest += cqe_inc;
 			owner_bit = dest->owner_sr_opcode & MLX4_CQE_OWNER_MASK;
 			memcpy(dest, cqe, sizeof *cqe);
 			dest->owner_sr_opcode = owner_bit |
@@ -450,28 +442,33 @@ void mlx4_cq_resize_copy_cqes(struct mlx4_cq *cq, void *buf, int old_cqe)
 {
 	struct mlx4_cqe *cqe;
 	int i;
+	int cqe_inc = cq->cqe_size == 64 ? 1 : 0;
 
 	i = cq->cons_index;
 	cqe = get_cqe(cq, (i & old_cqe));
+	cqe += cqe_inc;
 
 	while ((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) != MLX4_CQE_OPCODE_RESIZE) {
 		cqe->owner_sr_opcode = (cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK) |
 			(((i + 1) & (cq->ibv_cq.cqe + 1)) ? MLX4_CQE_OWNER_MASK : 0);
-		memcpy(buf + ((i + 1) & cq->ibv_cq.cqe) * MLX4_CQ_ENTRY_SIZE,
-		       cqe, MLX4_CQ_ENTRY_SIZE);
+		memcpy(buf + ((i + 1) & cq->ibv_cq.cqe) * cq->cqe_size,
+		       cqe - cqe_inc, cq->cqe_size);
 		++i;
 		cqe = get_cqe(cq, (i & old_cqe));
+		cqe += cqe_inc;
 	}
 
 	++cq->cons_index;
 }
 
-int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent)
+int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent,
+		      int entry_size)
 {
-	if (mlx4_alloc_buf(buf, align(nent * MLX4_CQ_ENTRY_SIZE, dev->page_size),
+	if (mlx4_alloc_buf(buf, align(nent * entry_size, dev->page_size),
 			   dev->page_size))
 		return -1;
-	memset(buf->buf, 0, nent * MLX4_CQ_ENTRY_SIZE);
+
+	memset(buf->buf, 0, nent * entry_size);
 
 	return 0;
 }
diff --git a/src/mlx4-abi.h b/src/mlx4-abi.h
index 20a40c9..9524eea 100644
--- a/src/mlx4-abi.h
+++ b/src/mlx4-abi.h
@@ -36,13 +36,14 @@
 #include <infiniband/kern-abi.h>
 
 #define MLX4_UVERBS_MIN_ABI_VERSION	2
-#define MLX4_UVERBS_MAX_ABI_VERSION	3
+#define MLX4_UVERBS_MAX_ABI_VERSION	4
 
 struct mlx4_alloc_ucontext_resp {
 	struct ibv_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
 	__u16				bf_reg_size;
 	__u16				bf_regs_per_page;
+	__u32				cqe_size;
 };
 
 struct mlx4_alloc_pd_resp {
diff --git a/src/mlx4.c b/src/mlx4.c
index 8cf249a..0ee8f64 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -57,6 +57,8 @@
 	{ .vendor = PCI_VENDOR_ID_##v,			\
 	  .device = d }
 
+HIDDEN int abi_ver;
+
 struct {
 	unsigned		vendor;
 	unsigned		device;
@@ -140,6 +142,10 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 	context->num_qps	= resp.qp_tab_size;
 	context->qp_table_shift = ffs(context->num_qps) - 1 - MLX4_QP_TABLE_BITS;
 	context->qp_table_mask	= (1 << context->qp_table_shift) - 1;
+	if (abi_ver > 3)
+		context->cqe_size = resp.cqe_size;
+	else
+		context->cqe_size = sizeof (struct mlx4_cqe);
 
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	for (i = 0; i < MLX4_QP_TABLE_SIZE; ++i)
@@ -245,6 +251,7 @@ found:
 
 	dev->ibv_dev.ops = mlx4_dev_ops;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
+	abi_ver = abi_version;
 
 	return &dev->ibv_dev;
 }
diff --git a/src/mlx4.h b/src/mlx4.h
index 0ad838d..7924ebf 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -84,10 +84,6 @@
 #define PFX		"mlx4: "
 
 enum {
-	MLX4_CQ_ENTRY_SIZE		= 0x20
-};
-
-enum {
 	MLX4_STAT_RATE_OFFSET		= 5
 };
 
@@ -159,6 +155,7 @@ struct mlx4_context {
 
 	struct mlx4_db_page	       *db_list[MLX4_NUM_DB_TYPE];
 	pthread_mutex_t			db_list_mutex;
+	int				cqe_size;
 };
 
 struct mlx4_buf {
@@ -181,6 +178,7 @@ struct mlx4_cq {
 	uint32_t		       *set_ci_db;
 	uint32_t		       *arm_db;
 	int				arm_sn;
+	int				cqe_size;
 };
 
 struct mlx4_srq {
@@ -245,6 +243,21 @@ struct mlx4_ah {
 	uint8_t				mac[6];
 };
 
+struct mlx4_cqe {
+	uint32_t	my_qpn;
+	uint32_t	immed_rss_invalid;
+	uint32_t	g_mlpath_rqpn;
+	uint8_t		sl;
+	uint8_t		reserved1;
+	uint16_t	rlid;
+	uint32_t	reserved2;
+	uint32_t	byte_cnt;
+	uint16_t	wqe_index;
+	uint16_t	checksum;
+	uint8_t		reserved3[3];
+	uint8_t		owner_sr_opcode;
+};
+
 static inline unsigned long align(unsigned long val, unsigned long align)
 {
 	return (val + align - 1) & ~(align - 1);
@@ -310,7 +323,8 @@ int mlx4_dereg_mr(struct ibv_mr *mr);
 struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
-int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent);
+int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent,
+		      int entry_size);
 int mlx4_resize_cq(struct ibv_cq *cq, int cqe);
 int mlx4_destroy_cq(struct ibv_cq *cq);
 int mlx4_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
diff --git a/src/verbs.c b/src/verbs.c
index 199d107..7d3519d 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -168,6 +168,7 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 	struct mlx4_create_cq_resp resp;
 	struct mlx4_cq		  *cq;
 	int			   ret;
+	struct mlx4_context       *mctx = to_mctx(context);
 
 	/* Sanity check CQ size before proceeding */
 	if (cqe > 0x3fffff)
@@ -184,9 +185,10 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 
 	cqe = align_queue_size(cqe + 1);
 
-	if (mlx4_alloc_cq_buf(to_mdev(context->device), &cq->buf, cqe))
+	if (mlx4_alloc_cq_buf(to_mdev(context->device), &cq->buf, cqe, mctx->cqe_size))
 		goto err;
 
+	cq->cqe_size = mctx->cqe_size;
 	cq->set_ci_db  = mlx4_alloc_db(to_mctx(context), MLX4_DB_TYPE_CQ);
 	if (!cq->set_ci_db)
 		goto err_buf;
@@ -247,7 +249,7 @@ int mlx4_resize_cq(struct ibv_cq *ibcq, int cqe)
 		goto out;
 	}
 
-	ret = mlx4_alloc_cq_buf(to_mdev(ibcq->context->device), &buf, cqe);
+	ret = mlx4_alloc_cq_buf(to_mdev(ibcq->context->device), &buf, cqe, cq->cqe_size);
 	if (ret)
 		goto out;
 
-- 
1.7.7.rc0.70.g82660

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
