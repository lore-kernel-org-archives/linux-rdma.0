From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 02/13] IB/mlx5: Add CQE version 1 support to user QPs and SRQs
Date: Thu, 14 Jan 2016 19:12:57 +0200
Message-ID: <1452791588-19895-3-git-send-email-majd@mellanox.com>
References: <1452791588-19895-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452791588-19895-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enforce working with CQE version 1 when the user supports CQE
version 1 and asked to work this way.

If the user still works with CQE version 0, then use the default
CQE version to tell the Firmware that the user still works in the
older mode.

After this patch, the kernel still reports CQE version 0.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h           | 23 ++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c                | 14 ++++++++
 drivers/infiniband/hw/mlx5/srq.c               | 41 ++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/user.h              | 44 +++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  4 ---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c   |  7 ----
 drivers/net/ethernet/mellanox/mlx5/core/srq.c  |  2 --
 7 files changed, 114 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d4b2271..a6a57de 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -57,6 +57,8 @@ pr_warn("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 
 #define field_avail(type, fld, sz) (offsetof(type, fld) +		\
 				    sizeof(((type *)0)->fld) <= (sz))
+#define MLX5_IB_DEFAULT_UIDX 0xffffff
+#define MLX5_USER_ASSIGNED_UIDX_MASK __mlx5_mask(qpc, user_index)
 
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
@@ -94,6 +96,11 @@ enum {
 	MLX5_CROSS_CHANNEL_UUAR         = 0,
 };
 
+enum {
+	MLX5_CQE_VERSION_V0,
+	MLX5_CQE_VERSION_V1,
+};
+
 struct mlx5_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct list_head	db_page_list;
@@ -102,6 +109,7 @@ struct mlx5_ib_ucontext {
 	 */
 	struct mutex		db_page_mutex;
 	struct mlx5_uuar_info	uuari;
+	u8			cqe_version;
 };
 
 static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibucontext)
@@ -694,4 +702,19 @@ static inline u32 check_cq_create_flags(u32 flags)
 	 */
 	return (flags & ~IB_CQ_FLAGS_IGNORE_OVERRUN);
 }
+
+static inline int verify_assign_uidx(u8 cqe_version, u32 cmd_uidx,
+				     u32 *user_index)
+{
+	if (cqe_version) {
+		if ((cmd_uidx == MLX5_IB_DEFAULT_UIDX) ||
+		    (cmd_uidx & ~MLX5_USER_ASSIGNED_UIDX_MASK))
+			return -EINVAL;
+		*user_index = cmd_uidx;
+	} else {
+		*user_index = MLX5_IB_DEFAULT_UIDX;
+	}
+
+	return 0;
+}
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1ea049e..5c92d08 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_cache.h>
+#include <rdma/ib_user_verbs.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -870,6 +871,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	struct mlx5_ib_create_qp ucmd;
 	int inlen = sizeof(*in);
 	int err;
+	u32 uidx = MLX5_IB_DEFAULT_UIDX;
+	void *qpc;
 
 	mlx5_ib_odp_create_qp(qp);
 
@@ -910,6 +913,11 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			return -EFAULT;
 		}
 
+		err = get_qp_user_index(to_mucontext(pd->uobject->context),
+					&ucmd, udata->inlen, &uidx);
+		if (err)
+			return err;
+
 		qp->wq_sig = !!(ucmd.flags & MLX5_QP_FLAG_SIGNATURE);
 		qp->scat_cqe = !!(ucmd.flags & MLX5_QP_FLAG_SCATTER_CQE);
 	} else {
@@ -1046,6 +1054,12 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	in->ctx.db_rec_addr = cpu_to_be64(qp->db.dma);
 
+	if (MLX5_CAP_GEN(mdev, cqe_version) == MLX5_CQE_VERSION_V1) {
+		qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+		/* 0xffffff means we ask to work with cqe version 0 */
+		MLX5_SET(qpc, qpc, user_index, uidx);
+	}
+
 	err = mlx5_core_create_qp(dev->mdev, &qp->mqp, in, inlen);
 	if (err) {
 		mlx5_ib_dbg(dev, "create qp failed\n");
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index e008505..4659256 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -78,28 +78,41 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 			   struct ib_udata *udata, int buf_size, int *inlen)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct mlx5_ib_create_srq ucmd;
+	struct mlx5_ib_create_srq ucmd = {};
 	size_t ucmdlen;
+	void *xsrqc;
 	int err;
 	int npages;
 	int page_shift;
 	int ncont;
 	u32 offset;
+	u32 uidx = MLX5_IB_DEFAULT_UIDX;
+	int drv_data = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
 
-	ucmdlen =
-		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
-		 sizeof(ucmd)) ? (sizeof(ucmd) -
-				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+	if (drv_data < 0)
+		return -EINVAL;
+
+	ucmdlen = (drv_data < sizeof(ucmd)) ?
+		  drv_data : sizeof(ucmd);
 
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen)) {
 		mlx5_ib_dbg(dev, "failed copy udata\n");
 		return -EFAULT;
 	}
 
-	if (ucmdlen == sizeof(ucmd) &&
-	    ucmd.reserved != 0)
+	if (ucmd.reserved0 || ucmd.reserved1)
 		return -EINVAL;
 
+	if (drv_data > sizeof(ucmd) &&
+	    !ib_is_udata_cleared(udata, sizeof(ucmd),
+				 drv_data - sizeof(ucmd)))
+		return -EINVAL;
+
+	err = get_srq_user_index(to_mucontext(pd->uobject->context),
+				 &ucmd, udata->inlen, &uidx);
+	if (err)
+		return err;
+
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
 	srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr, buf_size,
@@ -138,6 +151,12 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	(*in)->ctx.pgoff_cqn = cpu_to_be32(offset << 26);
 
+	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1) {
+		xsrqc = MLX5_ADDR_OF(create_xrc_srq_in, *in,
+				     xrc_srq_context_entry);
+		MLX5_SET(xrc_srqc, xsrqc, user_index, uidx);
+	}
+
 	return 0;
 
 err_in:
@@ -158,6 +177,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	struct mlx5_wqe_srq_next_seg *next;
 	int page_shift;
 	int npages;
+	void *xsrqc;
 
 	err = mlx5_db_alloc(dev->mdev, &srq->db);
 	if (err) {
@@ -204,6 +224,13 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 
 	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 
+	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1) {
+		xsrqc = MLX5_ADDR_OF(create_xrc_srq_in, *in,
+				     xrc_srq_context_entry);
+		/* 0xffffff means we ask to work with cqe version 0 */
+		MLX5_SET(xrc_srqc, xsrqc, user_index, MLX5_IB_DEFAULT_UIDX);
+	}
+
 	return 0;
 
 err_in:
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index e22a35f..5bf0935 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -35,6 +35,8 @@
 
 #include <linux/types.h>
 
+#include "mlx5_ib.h"
+
 enum {
 	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
@@ -118,7 +120,9 @@ struct mlx5_ib_create_srq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	flags;
-	__u32	reserved; /* explicit padding (optional on i386) */
+	__u32	reserved0; /* explicit padding (optional on i386) */
+	__u32	uidx;
+	__u32	reserved1;
 };
 
 struct mlx5_ib_create_srq_resp {
@@ -133,9 +137,47 @@ struct mlx5_ib_create_qp {
 	__u32	rq_wqe_count;
 	__u32	rq_wqe_shift;
 	__u32	flags;
+	__u32	uidx;
+	__u32	reserved0;
 };
 
 struct mlx5_ib_create_qp_resp {
 	__u32	uuar_index;
 };
+
+static inline int get_qp_user_index(struct mlx5_ib_ucontext *ucontext,
+				    struct mlx5_ib_create_qp *ucmd,
+				    int inlen,
+				    u32 *user_index)
+{
+	u8 cqe_version = ucontext->cqe_version;
+
+	if (field_avail(struct mlx5_ib_create_qp, uidx, inlen) &&
+	    !cqe_version && (ucmd->uidx == MLX5_IB_DEFAULT_UIDX))
+		return 0;
+
+	if (!!(field_avail(struct mlx5_ib_create_qp, uidx, inlen) !=
+	       !!cqe_version))
+		return -EINVAL;
+
+	return verify_assign_uidx(cqe_version, ucmd->uidx, user_index);
+}
+
+static inline int get_srq_user_index(struct mlx5_ib_ucontext *ucontext,
+				     struct mlx5_ib_create_srq *ucmd,
+				     int inlen,
+				     u32 *user_index)
+{
+	u8 cqe_version = ucontext->cqe_version;
+
+	if (field_avail(struct mlx5_ib_create_srq, uidx, inlen) &&
+	    !cqe_version && (ucmd->uidx == MLX5_IB_DEFAULT_UIDX))
+		return 0;
+
+	if (!!(field_avail(struct mlx5_ib_create_srq, uidx, inlen) !=
+	       !!cqe_version))
+		return -EINVAL;
+
+	return verify_assign_uidx(cqe_version, ucmd->uidx, user_index);
+}
 #endif /* MLX5_IB_USER_H */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b69fbf..fa1ca28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -696,7 +696,6 @@ clean:
 	return err;
 }
 
-#ifdef CONFIG_MLX5_CORE_EN
 static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 {
 	u32 query_in[MLX5_ST_SZ_DW(query_issi_in)];
@@ -749,7 +748,6 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 
 	return -ENOTSUPP;
 }
-#endif
 
 static int map_bf_area(struct mlx5_core_dev *dev)
 {
@@ -995,13 +993,11 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 		goto err_pagealloc_cleanup;
 	}
 
-#ifdef CONFIG_MLX5_CORE_EN
 	err = mlx5_core_set_issi(dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to set issi\n");
 		goto err_disable_hca;
 	}
-#endif
 
 	err = mlx5_satisfy_startup_pages(dev, 1);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 30e2ba3..803a1f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -187,17 +187,10 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
 	struct mlx5_destroy_qp_mbox_in din;
 	struct mlx5_destroy_qp_mbox_out dout;
 	int err;
-	void *qpc;
 
 	memset(&out, 0, sizeof(out));
 	in->hdr.opcode = cpu_to_be16(MLX5_CMD_OP_CREATE_QP);
 
-	if (dev->issi) {
-		qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
-		/* 0xffffff means we ask to work with cqe version 0 */
-		MLX5_SET(qpc, qpc, user_index, 0xffffff);
-	}
-
 	err = mlx5_cmd_exec(dev, in, inlen, &out, sizeof(out));
 	if (err) {
 		mlx5_core_warn(dev, "ret %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index ffada80..ec5f901 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -241,8 +241,6 @@ static int create_xrc_srq_cmd(struct mlx5_core_dev *dev,
 
 	memcpy(xrc_srqc, srqc, MLX5_ST_SZ_BYTES(srqc));
 	memcpy(pas, in->pas, pas_size);
-	/* 0xffffff means we ask to work with cqe version 0 */
-	MLX5_SET(xrc_srqc,	    xrc_srqc,  user_index, 0xffffff);
 	MLX5_SET(create_xrc_srq_in, create_in, opcode,
 		 MLX5_CMD_OP_CREATE_XRC_SRQ);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
