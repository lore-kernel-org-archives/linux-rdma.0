From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4] Add support for 64B CQEs
Date: Wed, 17 Oct 2012 18:43:01 +0200
Message-ID: <1350492181-13471-5-git-send-email-ogerlitz@mellanox.com>
References: <1350492181-13471-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350492181-13471-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CX3 devices can work with 64 or 32 byte CQEs. Using 64 byte CQEs allow better
utilization of new chipsets and gaining higher performance. This patch will read 
from kernel the configured size of a CQE and use this size in CQ related code.

The code is changed to store the per device ABI version read from the device uverbs 
sysfs entry, and uses it as the key to realize the CQE size if/as advertized by 
the kernel mlx4_ib driver. Older kernel mlx4_ib ABI versions are still supported.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c       |   39 ++++++++++++++++++---------------------
 src/mlx4-abi.h |   17 ++++++++++++++++-
 src/mlx4.c     |   39 +++++++++++++++++++++++++++++----------
 src/mlx4.h     |   25 ++++++++++++++++++++-----
 src/verbs.c    |    6 ++++--
 5 files changed, 87 insertions(+), 39 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8f7a8cc..18447c4 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -87,20 +87,6 @@ enum {
 	MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
 };
 
-struct mlx4_cqe {
-	uint32_t	vlan_my_qpn;
-	uint32_t	immed_rss_invalid;
-	uint32_t	g_mlpath_rqpn;
-	uint16_t	sl_vid;
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
 	uint32_t	vlan_my_qpn;
 	uint32_t	reserved1[5];
@@ -113,14 +99,15 @@ struct mlx4_err_cqe {
 
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
 
@@ -209,6 +196,9 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	if (!cqe)
 		return CQ_EMPTY;
 
+	if (cq->cqe_size == 64)
+		++cqe;
+
 	++cq->cons_index;
 
 	VALGRIND_MAKE_MEM_DEFINED(cqe, sizeof *cqe);
@@ -393,6 +383,7 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	uint32_t prod_index;
 	uint8_t owner_bit;
 	int nfreed = 0;
+	int cqe_inc = cq->cqe_size == 64 ? 1 : 0;
 
 	/*
 	 * First we need to find the current producer index, so we
@@ -411,12 +402,14 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	 */
 	while ((int) --prod_index - (int) cq->cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
+		cqe += cqe_inc;
 		if ((ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) == qpn) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_free_srq_wqe(srq, ntohs(cqe->wqe_index));
 			++nfreed;
 		} else if (nfreed) {
 			dest = get_cqe(cq, (prod_index + nfreed) & cq->ibv_cq.cqe);
+			dest += cqe_inc;
 			owner_bit = dest->owner_sr_opcode & MLX4_CQE_OWNER_MASK;
 			memcpy(dest, cqe, sizeof *cqe);
 			dest->owner_sr_opcode = owner_bit |
@@ -456,28 +449,32 @@ void mlx4_cq_resize_copy_cqes(struct mlx4_cq *cq, void *buf, int old_cqe)
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
+	memset(buf->buf, 0, nent * entry_size);
 
 	return 0;
 }
diff --git a/src/mlx4-abi.h b/src/mlx4-abi.h
index 20a40c9..a1328af 100644
--- a/src/mlx4-abi.h
+++ b/src/mlx4-abi.h
@@ -36,13 +36,28 @@
 #include <infiniband/kern-abi.h>
 
 #define MLX4_UVERBS_MIN_ABI_VERSION	2
-#define MLX4_UVERBS_MAX_ABI_VERSION	3
+#define MLX4_UVERBS_MAX_ABI_VERSION	4
+
+#define MLX4_UVERBS_NO_DEV_CAPS_ABI_VERSION	3
+
+enum {
+	MLX4_USER_DEV_CAP_64B_CQE	= 1L << 0
+};
+
+struct mlx4_alloc_ucontext_resp_v3 {
+	struct ibv_get_context_resp	ibv_resp;
+	__u32				qp_tab_size;
+	__u16				bf_reg_size;
+	__u16				bf_regs_per_page;
+};
 
 struct mlx4_alloc_ucontext_resp {
 	struct ibv_get_context_resp	ibv_resp;
+	__u32				dev_caps;
 	__u32				qp_tab_size;
 	__u16				bf_reg_size;
 	__u16				bf_regs_per_page;
+	__u32				cqe_size;
 };
 
 struct mlx4_alloc_pd_resp {
diff --git a/src/mlx4.c b/src/mlx4.c
index 8cf249a..60201af 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -126,6 +126,9 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 	struct ibv_get_context		cmd;
 	struct mlx4_alloc_ucontext_resp resp;
 	int				i;
+	struct mlx4_alloc_ucontext_resp_v3 resp_v3;
+	__u16				bf_reg_size;
+	struct mlx4_device		*dev = to_mdev(ibdev);
 
 	context = calloc(1, sizeof *context);
 	if (!context)
@@ -133,11 +136,27 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 
 	context->ibv_ctx.cmd_fd = cmd_fd;
 
-	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
-				&resp.ibv_resp, sizeof resp))
-		goto err_free;
+	if (dev->abi_version <= MLX4_UVERBS_NO_DEV_CAPS_ABI_VERSION) {
+		if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
+					&resp_v3.ibv_resp, sizeof resp_v3))
+			goto err_free;
+
+		context->num_qps  = resp_v3.qp_tab_size;
+		bf_reg_size	  = resp_v3.bf_reg_size;
+		context->cqe_size = sizeof (struct mlx4_cqe);
+	} else  {
+		if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
+					&resp.ibv_resp, sizeof resp))
+			goto err_free;
+
+		context->num_qps  = resp.qp_tab_size;
+		bf_reg_size	  = resp.bf_reg_size;
+		if (resp.dev_caps & MLX4_USER_DEV_CAP_64B_CQE)
+			context->cqe_size = resp.cqe_size;
+		else
+			context->cqe_size = sizeof (struct mlx4_cqe);
+	}
 
-	context->num_qps	= resp.qp_tab_size;
 	context->qp_table_shift = ffs(context->num_qps) - 1 - MLX4_QP_TABLE_BITS;
 	context->qp_table_mask	= (1 << context->qp_table_shift) - 1;
 
@@ -155,7 +174,7 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 	if (context->uar == MAP_FAILED)
 		goto err_free;
 
-	if (resp.bf_reg_size) {
+	if (bf_reg_size) {
 		context->bf_page = mmap(NULL, to_mdev(ibdev)->page_size,
 					PROT_WRITE, MAP_SHARED, cmd_fd,
 					to_mdev(ibdev)->page_size);
@@ -165,7 +184,7 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 				context->bf_page     = NULL;
 				context->bf_buf_size = 0;
 		} else {
-			context->bf_buf_size = resp.bf_reg_size / 2;
+			context->bf_buf_size = bf_reg_size / 2;
 			context->bf_offset   = 0;
 			pthread_spin_init(&context->bf_lock, PTHREAD_PROCESS_PRIVATE);
 		}
@@ -200,8 +219,7 @@ static struct ibv_device_ops mlx4_dev_ops = {
 	.free_context  = mlx4_free_context
 };
 
-static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
 {
 	char			value[8];
 	struct mlx4_device    *dev;
@@ -245,6 +263,7 @@ found:
 
 	dev->ibv_dev.ops = mlx4_dev_ops;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
+	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
 }
@@ -261,13 +280,13 @@ static __attribute__((constructor)) void mlx4_register_driver(void)
  */
 struct ibv_device *openib_driver_init(struct sysfs_class_device *sysdev)
 {
-	int abi_ver = 0;
+	int abi_version = 0;
 	char value[8];
 
 	if (ibv_read_sysfs_file(sysdev->path, "abi_version",
 				value, sizeof value) > 0)
 		abi_ver = strtol(value, NULL, 10);
 
-	return mlx4_driver_init(sysdev->path, abi_ver);
+	return mlx4_driver_init(sysdev->path, abi_version);
 }
 #endif /* HAVE_IBV_REGISTER_DRIVER */
diff --git a/src/mlx4.h b/src/mlx4.h
index 13c13d8..218a3f1 100644
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
 
@@ -133,6 +129,7 @@ enum {
 struct mlx4_device {
 	struct ibv_device		ibv_dev;
 	int				page_size;
+	int				abi_version;
 };
 
 struct mlx4_db_page;
@@ -159,6 +156,7 @@ struct mlx4_context {
 
 	struct mlx4_db_page	       *db_list[MLX4_NUM_DB_TYPE];
 	pthread_mutex_t			db_list_mutex;
+	int				cqe_size;
 };
 
 struct mlx4_buf {
@@ -181,6 +179,7 @@ struct mlx4_cq {
 	uint32_t		       *set_ci_db;
 	uint32_t		       *arm_db;
 	int				arm_sn;
+	int				cqe_size;
 };
 
 struct mlx4_srq {
@@ -247,6 +246,21 @@ struct mlx4_ah {
 	uint8_t				mac[6];
 };
 
+struct mlx4_cqe {
+	uint32_t	vlan_my_qpn;
+	uint32_t	immed_rss_invalid;
+	uint32_t	g_mlpath_rqpn;
+	uint8_t		sl_vid;
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
@@ -312,7 +326,8 @@ int mlx4_dereg_mr(struct ibv_mr *mr);
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
index 408fc6d..443ba9d 100644
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
