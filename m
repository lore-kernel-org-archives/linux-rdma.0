From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Allow creation of a multi-packet RQ
Date: Tue, 17 Oct 2017 18:01:13 +0300
Message-ID: <20171017150113.8544-3-leon@kernel.org>
References: <20171017150113.8544-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017150113.8544-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow creation of a multi-packet receive queue.

In order to create a multi-packet RQ, the following fields in
the mlx5_ib_rwq should be set:
- log_num_strides: Log of number of strides per WQE
- single_stride_log_num_of_bytes: Log of a single stride size
- two_byte_shift_en: When enabled, hardware pads 2 bytes of zeros
  before writing the message to memory (e.g. for the IP alignment).

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +++
 drivers/infiniband/hw/mlx5/qp.c      | 52 ++++++++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc.h        |  1 +
 include/uapi/rdma/mlx5-abi.h         |  8 +++++-
 4 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8de40852818b..e7deaa08535b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -254,6 +254,7 @@ struct mlx5_ib_wq {
 
 enum mlx5_ib_wq_flags {
 	MLX5_IB_WQ_FLAGS_DELAY_DROP = 0x1,
+	MLX5_IB_WQ_FLAGS_STRIDING_RQ = 0x2,
 };
 
 #define MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES 9
@@ -269,6 +270,9 @@ struct mlx5_ib_rwq {
 	u32			log_rq_size;
 	u32			rq_page_offset;
 	u32			log_page_size;
+	u32			log_num_strides;
+	u32			two_byte_shift_en;
+	u32			single_stride_log_num_of_bytes;
 	struct ib_umem		*umem;
 	size_t			buf_size;
 	unsigned int		page_shift;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 37a0976240fd..d209c684d729 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4706,9 +4706,19 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	MLX5_SET(rqc,  rqc, state, MLX5_RQC_STATE_RST);
 	MLX5_SET(rqc,  rqc, flush_in_error_en, 1);
 	wq = MLX5_ADDR_OF(rqc, rqc, wq);
-	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
+	MLX5_SET(wq, wq, wq_type,
+		 rwq->create_flags & MLX5_IB_WQ_FLAGS_STRIDING_RQ ?
+		 MLX5_WQ_TYPE_CYCLIC_STRIDING_RQ : MLX5_WQ_TYPE_CYCLIC);
 	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
 	MLX5_SET(wq, wq, log_wq_stride, rwq->log_rq_stride);
+	if (rwq->create_flags & MLX5_IB_WQ_FLAGS_STRIDING_RQ) {
+		MLX5_SET(wq, wq, two_byte_shift_en, rwq->two_byte_shift_en);
+		MLX5_SET(wq, wq, log_wqe_stride_size,
+			 rwq->single_stride_log_num_of_bytes -
+			 MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES);
+		MLX5_SET(wq, wq, log_wqe_num_of_strides, rwq->log_num_strides -
+			 MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES);
+	}
 	MLX5_SET(wq, wq, log_wq_sz, rwq->log_rq_size);
 	MLX5_SET(wq, wq, pd, to_mpd(pd)->pdn);
 	MLX5_SET(wq, wq, page_offset, rwq->rq_page_offset);
@@ -4790,7 +4800,8 @@ static int prepare_user_rq(struct ib_pd *pd,
 	int err;
 	size_t required_cmd_sz;
 
-	required_cmd_sz = offsetof(typeof(ucmd), reserved) + sizeof(ucmd.reserved);
+	required_cmd_sz = offsetof(typeof(ucmd), single_stride_log_num_of_bytes)
+		+ sizeof(ucmd.single_stride_log_num_of_bytes);
 	if (udata->inlen < required_cmd_sz) {
 		mlx5_ib_dbg(dev, "invalid inlen\n");
 		return -EINVAL;
@@ -4808,14 +4819,39 @@ static int prepare_user_rq(struct ib_pd *pd,
 		return -EFAULT;
 	}
 
-	if (ucmd.comp_mask) {
+	if (ucmd.comp_mask & (~MLX5_IB_CREATE_WQ_STRIDING_RQ)) {
 		mlx5_ib_dbg(dev, "invalid comp mask\n");
 		return -EOPNOTSUPP;
-	}
-
-	if (ucmd.reserved) {
-		mlx5_ib_dbg(dev, "invalid reserved\n");
-		return -EOPNOTSUPP;
+	} else if (ucmd.comp_mask & MLX5_IB_CREATE_WQ_STRIDING_RQ) {
+		if (!MLX5_CAP_GEN(dev->mdev, striding_rq)) {
+			mlx5_ib_dbg(dev, "Striding RQ is not supported\n");
+			return -EOPNOTSUPP;
+		}
+		if ((ucmd.single_stride_log_num_of_bytes <
+		    MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES) ||
+		    (ucmd.single_stride_log_num_of_bytes >
+		     MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES)) {
+			mlx5_ib_dbg(dev, "Invalid log stride size (%u. Range is %u - %u)\n",
+				    ucmd.single_stride_log_num_of_bytes,
+				    MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES,
+				    MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES);
+			return -EINVAL;
+		}
+		if ((ucmd.single_wqe_log_num_of_strides >
+		    MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES) ||
+		     (ucmd.single_wqe_log_num_of_strides <
+			MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES)) {
+			mlx5_ib_dbg(dev, "Invalid log num strides (%u. Range is %u - %u)\n",
+				    ucmd.single_wqe_log_num_of_strides,
+				    MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES,
+				    MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES);
+			return -EINVAL;
+		}
+		rwq->single_stride_log_num_of_bytes =
+			ucmd.single_stride_log_num_of_bytes;
+		rwq->log_num_strides = ucmd.single_wqe_log_num_of_strides;
+		rwq->two_byte_shift_en = !!ucmd.two_byte_shift_en;
+		rwq->create_flags |= MLX5_IB_WQ_FLAGS_STRIDING_RQ;
 	}
 
 	err = set_user_rq_size(dev, init_attr, &ucmd, rwq);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 69772347f866..db655db45b77 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -744,6 +744,7 @@ enum {
 	MLX5_WQ_TYPE_LINKED_LIST  = 0x0,
 	MLX5_WQ_TYPE_CYCLIC       = 0x1,
 	MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ = 0x2,
+	MLX5_WQ_TYPE_CYCLIC_STRIDING_RQ = 0x3,
 };
 
 enum {
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 0832d9502200..b1d5b87ba3fd 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -308,6 +308,10 @@ struct mlx5_ib_alloc_mw {
 	__u16	reserved2;
 };
 
+enum mlx5_ib_create_wq_mask {
+	MLX5_IB_CREATE_WQ_STRIDING_RQ	= (1 << 0),
+};
+
 struct mlx5_ib_create_wq {
 	__u64   buf_addr;
 	__u64   db_addr;
@@ -316,7 +320,9 @@ struct mlx5_ib_create_wq {
 	__u32   user_index;
 	__u32   flags;
 	__u32   comp_mask;
-	__u32   reserved;
+	__u32	single_stride_log_num_of_bytes;
+	__u32	single_wqe_log_num_of_strides;
+	__u32	two_byte_shift_en;
 };
 
 struct mlx5_ib_create_ah_resp {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
