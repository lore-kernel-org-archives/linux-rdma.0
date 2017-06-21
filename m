From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx4: Add inline-receive support
Date: Wed, 21 Jun 2017 09:26:28 +0300
Message-ID: <20170621062628.7416-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When inline-receive is enabled, the HCA may write received
data into the receive WQE.

Inline-receive is enabled by setting its matching bit in
the QP context and each single-packet message with payload
not exceeding the receive WQE size will be delivered to
the WQE.

The completion report will indicate that the payload was placed to the WQE.

It includes:
1) Return maximum supported size of inline-receive by the hardware
in query_device vendor's data part.
2) Enable the feature when requested by the vendor data input.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hi Doug,

This patch is based on commit 4931c6ef04b4 ("net/mlx4_en: Optimized single ring steering")
from Dave's net-next

Thanks
---
 drivers/infiniband/hw/mlx4/main.c    |  7 +++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  3 +++
 drivers/infiniband/hw/mlx4/qp.c      | 32 +++++++++++++++++++++++++-------
 include/uapi/rdma/mlx4-abi.h         |  3 ++-
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75b2f7d4cd95..2c7d24b99fec 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -563,6 +563,13 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		}
 	}

+	if (uhw->outlen >= resp.response_length +
+	    sizeof(resp.max_inl_recv_sz)) {
+		resp.response_length += sizeof(resp.max_inl_recv_sz);
+		resp.max_inl_recv_sz  = dev->dev->caps.max_rq_sg *
+			sizeof(struct mlx4_wqe_data_seg);
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 		if (err)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index c2b9cbf4da05..e8989c7585a7 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -319,6 +319,7 @@ struct mlx4_ib_qp {
 	u8			sq_no_prefetch;
 	u8			state;
 	int			mlx_type;
+	u32			inl_recv_sz;
 	struct list_head	gid_list;
 	struct list_head	steering_rules;
 	struct mlx4_ib_buf	*sqp_proxy_rcv;
@@ -624,6 +625,8 @@ struct mlx4_uverbs_ex_query_device_resp {
 	__u32 comp_mask;
 	__u32 response_length;
 	__u64 hca_core_clock_offset;
+	__u32 max_inl_recv_sz;
+	__u32 reserved;
 };

 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 996e9058e515..76125bf4bea9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -377,7 +377,8 @@ static int send_wqe_overhead(enum mlx4_ib_qp_type type, u32 flags)
 }

 static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
-		       int is_user, int has_rq, struct mlx4_ib_qp *qp)
+		       int is_user, int has_rq, struct mlx4_ib_qp *qp,
+		       u32 inl_recv_sz)
 {
 	/* Sanity check RQ size before proceeding */
 	if (cap->max_recv_wr > dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE ||
@@ -385,18 +386,24 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		return -EINVAL;

 	if (!has_rq) {
-		if (cap->max_recv_wr)
+		if (cap->max_recv_wr || inl_recv_sz)
 			return -EINVAL;

 		qp->rq.wqe_cnt = qp->rq.max_gs = 0;
 	} else {
+		u32 max_inl_recv_sz = dev->dev->caps.max_rq_sg *
+			sizeof(struct mlx4_wqe_data_seg);
+		u32 wqe_size;
+
 		/* HW requires >= 1 RQ entry with >= 1 gather entry */
-		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge))
+		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge ||
+				inl_recv_sz > max_inl_recv_sz))
 			return -EINVAL;

 		qp->rq.wqe_cnt	 = roundup_pow_of_two(max(1U, cap->max_recv_wr));
 		qp->rq.max_gs	 = roundup_pow_of_two(max(1U, cap->max_recv_sge));
-		qp->rq.wqe_shift = ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg));
+		wqe_size = qp->rq.max_gs * sizeof(struct mlx4_wqe_data_seg);
+		qp->rq.wqe_shift = ilog2(max_t(u32, wqe_size, inl_recv_sz));
 	}

 	/* leave userspace return values as they were, so as not to break ABI */
@@ -719,9 +726,6 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);

-	err = set_rq_size(dev, &init_attr->cap, !!pd->uobject, qp_has_rq(init_attr), qp);
-	if (err)
-		goto err;

 	if (pd->uobject) {
 		struct mlx4_ib_create_qp ucmd;
@@ -731,6 +735,12 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 		}

+		err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
+				  qp_has_rq(init_attr), qp, ucmd.inl_recv_sz);
+		if (err)
+			goto err;
+
+		qp->inl_recv_sz = ucmd.inl_recv_sz;
 		qp->sq_no_prefetch = ucmd.sq_no_prefetch;

 		err = set_user_sq_size(dev, qp, &ucmd);
@@ -760,6 +770,11 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 				goto err_mtt;
 		}
 	} else {
+		err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
+				  qp_has_rq(init_attr), qp, 0);
+		if (err)
+			goto err;
+
 		qp->sq_no_prefetch = 0;

 		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
@@ -1657,6 +1672,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}

+	if (qp->inl_recv_sz)
+		context->param3 |= cpu_to_be32(1 << 25);
+
 	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
 		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
 	else if (ibqp->qp_type == IB_QPT_RAW_PACKET)
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index af431752655c..bf3bdba2f326 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -101,7 +101,8 @@ struct mlx4_ib_create_qp {
 	__u8	log_sq_bb_count;
 	__u8	log_sq_stride;
 	__u8	sq_no_prefetch;
-	__u8	reserved[5];
+	__u32	inl_recv_sz;
+	__u8	reserved;
 };

 #endif /* MLX4_ABI_USER_H */
--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
