From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/mlx5: Add CQE version 1 support to user space
Date: Thu, 10 Dec 2015 21:54:28 +0200
Message-ID: <1449777273-9219-2-git-send-email-majd@mellanox.com>
References: <1449777273-9219-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449777273-9219-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch prepares the infrastructure to work with CQE version 1
if the user-space works this way, otherwise work with CQE version 0.

After this patch the kernel still reports CQE version 0.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  2 ++
 drivers/infiniband/hw/mlx5/qp.c               | 15 +++++++++++++
 drivers/infiniband/hw/mlx5/srq.c              | 31 +++++++++++++++++++++------
 drivers/infiniband/hw/mlx5/user.h             |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  7 ------
 drivers/net/ethernet/mellanox/mlx5/core/srq.c |  2 --
 6 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6333472..e1c46c6 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -55,6 +55,8 @@ pr_err("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 pr_warn("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 	__LINE__, current->pid, ##arg)
 
+#define MLX5_IB_DEFAULT_UIDX 0xffffff
+
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
 	MLX5_IB_MMAP_CMD_MASK	= 0xff,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 307bdbc..e0be8b3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -864,6 +865,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	struct mlx5_ib_create_qp ucmd;
 	int inlen = sizeof(*in);
 	int err;
+	u32 uidx;
+	void *qpc;
 
 	mlx5_ib_odp_create_qp(qp);
 
@@ -889,10 +892,16 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			return -EFAULT;
 		}
 
+		if (udata->inlen > offsetof(struct mlx5_ib_create_qp, uidx))
+			uidx = ucmd.uidx;
+		else
+			uidx = MLX5_IB_DEFAULT_UIDX;
+
 		qp->wq_sig = !!(ucmd.flags & MLX5_QP_FLAG_SIGNATURE);
 		qp->scat_cqe = !!(ucmd.flags & MLX5_QP_FLAG_SCATTER_CQE);
 	} else {
 		qp->wq_sig = !!wq_signature;
+		uidx = MLX5_IB_DEFAULT_UIDX;
 	}
 
 	qp->has_rq = qp_has_rq(init_attr);
@@ -1018,6 +1027,12 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	in->ctx.db_rec_addr = cpu_to_be64(qp->db.dma);
 
+	if (MLX5_CAP_GEN(mdev, cqe_version) == 1) {
+		qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+		/* 0xffffff means we ask to work with cqe version 0 */
+		MLX5_SET(qpc, qpc, user_index, uidx);
+	}
+
 	err = mlx5_core_create_qp(dev->mdev, &qp->mqp, in, inlen);
 	if (err) {
 		mlx5_ib_dbg(dev, "create qp failed\n");
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index e008505..07e1a39 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -80,24 +80,24 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_create_srq ucmd;
 	size_t ucmdlen;
+	void *xsrqc;
 	int err;
 	int npages;
 	int page_shift;
 	int ncont;
 	u32 offset;
+	int drv_data = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
 
-	ucmdlen =
-		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
-		 sizeof(ucmd)) ? (sizeof(ucmd) -
-				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+	ucmdlen = (drv_data < sizeof(ucmd)) ?
+		  drv_data : sizeof(ucmd);
 
+	memset(&ucmd, 0, sizeof(ucmd));
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen)) {
 		mlx5_ib_dbg(dev, "failed copy udata\n");
 		return -EFAULT;
 	}
 
-	if (ucmdlen == sizeof(ucmd) &&
-	    ucmd.reserved != 0)
+	if (ucmd.reserved || ucmd.reserved1)
 		return -EINVAL;
 
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
@@ -138,6 +138,17 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	(*in)->ctx.pgoff_cqn = cpu_to_be32(offset << 26);
 
+	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == 1) {
+		xsrqc = MLX5_ADDR_OF(create_xrc_srq_in, *in,
+				     xrc_srq_context_entry);
+		/* 0xffffff means we ask to work with cqe version 0 */
+		if (drv_data > offsetof(struct mlx5_ib_create_srq, uidx))
+			MLX5_SET(xrc_srqc, xsrqc, user_index, ucmd.uidx);
+		else
+			MLX5_SET(xrc_srqc, xsrqc, user_index,
+				 MLX5_IB_DEFAULT_UIDX);
+	}
+
 	return 0;
 
 err_in:
@@ -158,6 +169,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	struct mlx5_wqe_srq_next_seg *next;
 	int page_shift;
 	int npages;
+	void *xsrqc;
 
 	err = mlx5_db_alloc(dev->mdev, &srq->db);
 	if (err) {
@@ -204,6 +216,13 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 
 	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 
+	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == 1) {
+		xsrqc = MLX5_ADDR_OF(create_xrc_srq_in, *in,
+				     xrc_srq_context_entry);
+		/* 0xffffff means we ask to work with cqe version 0 */
+		MLX5_SET(xrc_srqc, xsrqc, user_index, MLX5_IB_DEFAULT_UIDX);
+	}
+
 	return 0;
 
 err_in:
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 76fb7b9..9a78578 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -111,6 +111,8 @@ struct mlx5_ib_create_srq {
 	__u64	db_addr;
 	__u32	flags;
 	__u32	reserved; /* explicit padding (optional on i386) */
+	__u32	uidx;
+	__u32	reserved1;
 };
 
 struct mlx5_ib_create_srq_resp {
@@ -125,6 +127,8 @@ struct mlx5_ib_create_qp {
 	__u32	rq_wqe_count;
 	__u32	rq_wqe_shift;
 	__u32	flags;
+	__u32	uidx;
+	__u32	reserved;
 };
 
 struct mlx5_ib_create_qp_resp {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 8b494b5..dc7dbf7 100644
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
index c48f504..7504d11 100644
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
