From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/mlx5: Support padded 128B CQE feature
Date: Thu, 19 Oct 2017 08:25:53 +0300
Message-ID: <20171019052556.8514-4-leon@kernel.org>
References: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In some benchmarks and some CPU architectures, writing the CQE on a full
cache line size improves performance by saving memory access operations
(read-modify-write) relative to partial cache line change. This patch
lets the user to configure the device to pad the CQE up to 128B in case
its content is less than 128B. Currently the driver supports only padding
for a CQE size of 128B.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c      | 27 +++++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/main.c    |  4 ++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 +++++
 include/linux/mlx5/cq.h              |  6 ++++--
 include/uapi/rdma/mlx5-abi.h         |  7 ++++++-
 5 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 51871f049c57..01b218a3c277 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -754,13 +754,13 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	int err;
 
 	ucmdlen = udata->inlen < sizeof(ucmd) ?
-		  (sizeof(ucmd) - sizeof(ucmd.reserved)) : sizeof(ucmd);
+		  (sizeof(ucmd) - sizeof(ucmd.flags)) : sizeof(ucmd);
 
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen))
 		return -EFAULT;
 
 	if (ucmdlen == sizeof(ucmd) &&
-	    ucmd.reserved != 0)
+	    (ucmd.flags & ~(MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD)))
 		return -EINVAL;
 
 	if (ucmd.cqe_size != 64 && ucmd.cqe_size != 128)
@@ -830,6 +830,19 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 			 ilog2(ucmd.cqe_comp_res_format));
 	}
 
+	if (ucmd.flags & MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD) {
+		if (*cqe_size != 128 ||
+		    !MLX5_CAP_GEN(dev->mdev, cqe_128_always)) {
+			err = -EOPNOTSUPP;
+			mlx5_ib_warn(dev,
+				     "CQE padding is not supported for CQE size of %dB!\n",
+				     *cqe_size);
+			goto err_cqb;
+		}
+
+		cq->private_flags |= MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD;
+	}
+
 	return 0;
 
 err_cqb:
@@ -989,7 +1002,10 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 	cq->cqe_size = cqe_size;
 
 	cqc = MLX5_ADDR_OF(create_cq_in, cqb, cq_context);
-	MLX5_SET(cqc, cqc, cqe_sz, cqe_sz_to_mlx_sz(cqe_size));
+	MLX5_SET(cqc, cqc, cqe_sz,
+		 cqe_sz_to_mlx_sz(cqe_size,
+				  cq->private_flags &
+				  MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD));
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(entries));
 	MLX5_SET(cqc, cqc, uar_page, index);
 	MLX5_SET(cqc, cqc, c_eqn, eqn);
@@ -1339,7 +1355,10 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 
 	MLX5_SET(cqc, cqc, log_page_size,
 		 page_shift - MLX5_ADAPTER_PAGE_SHIFT);
-	MLX5_SET(cqc, cqc, cqe_sz, cqe_sz_to_mlx_sz(cqe_size));
+	MLX5_SET(cqc, cqc, cqe_sz,
+		 cqe_sz_to_mlx_sz(cqe_size,
+				  cq->private_flags &
+				  MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD));
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(entries));
 
 	MLX5_SET(modify_cq_in, in, op_mod, MLX5_CQ_OPMOD_RESIZE);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 249c01c24eac..107c038da328 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -829,9 +829,13 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 	if (field_avail(typeof(resp), flags, uhw->outlen)) {
 		resp.response_length += sizeof(resp.flags);
+
 		if (MLX5_CAP_GEN(mdev, cqe_compression_128))
 			resp.flags |=
 				MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP;
+
+		if (MLX5_CAP_GEN(mdev, cqe_128_always))
+			resp.flags |= MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD;
 	}
 
 	if (field_avail(typeof(resp), sw_parsing_caps,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b30945c3a1fb..2063d1dfc101 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -446,6 +446,10 @@ struct mlx5_shared_mr_info {
 	struct ib_umem		*umem;
 };
 
+enum mlx5_ib_cq_pr_flags {
+	MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD	= 1 << 0,
+};
+
 struct mlx5_ib_cq {
 	struct ib_cq		ibcq;
 	struct mlx5_core_cq	mcq;
@@ -468,6 +472,7 @@ struct mlx5_ib_cq {
 	struct list_head	wc_list;
 	enum ib_cq_notify_flags notify_flags;
 	struct work_struct	notify_work;
+	u16			private_flags; /* Use mlx5_ib_cq_pr_flags */
 };
 
 struct mlx5_ib_wc {
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 95898847c7d4..cc718e245b1e 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -125,11 +125,13 @@ struct mlx5_cq_modify_params {
 enum {
 	CQE_SIZE_64 = 0,
 	CQE_SIZE_128 = 1,
+	CQE_SIZE_128_PAD = 2,
 };
 
-static inline int cqe_sz_to_mlx_sz(u8 size)
+static inline int cqe_sz_to_mlx_sz(u8 size, int padding_128_en)
 {
-	return size == 64 ? CQE_SIZE_64 : CQE_SIZE_128;
+	return padding_128_en ? CQE_SIZE_128_PAD :
+				size == 64 ? CQE_SIZE_64 : CQE_SIZE_128;
 }
 
 static inline void mlx5_cq_set_ci(struct mlx5_core_cq *cq)
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index a8fc1f0956d0..201a60f032dd 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -206,6 +206,7 @@ struct mlx5_ib_striding_rq_caps {
 enum mlx5_ib_query_dev_resp_flags {
 	/* Support 128B CQE compression */
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
+	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
 };
 
 struct mlx5_ib_query_device_resp {
@@ -221,13 +222,17 @@ struct mlx5_ib_query_device_resp {
 	struct mlx5_ib_striding_rq_caps striding_rq_caps;
 };
 
+enum mlx5_ib_create_cq_flags {
+	MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD	= 1 << 0,
+};
+
 struct mlx5_ib_create_cq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	cqe_size;
 	__u8    cqe_comp_en;
 	__u8    cqe_comp_res_format;
-	__u16	reserved; /* explicit padding (optional on i386) */
+	__u16	flags;
 };
 
 struct mlx5_ib_create_cq_resp {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
