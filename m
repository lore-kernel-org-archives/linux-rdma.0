From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Add scatter end padding support
Date: Tue, 17 Oct 2017 18:18:57 +0300
Message-ID: <20171017151857.11934-3-leon@kernel.org>
References: <20171017151857.11934-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017151857.11934-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the scatter end padding flag to device_cap_flags enum and set it
during mlx5_ib_query_device so it will be reported to user-space.

During WQ/QP creation, set the scatter end padding capability for
WQ/QP if user requested it and HW supports it.

Scatter end padding modification is not supported for now. There's no
such flag for a QP but for a WQ, create and modify use the same flag.
Return an error if scatter end padding flag is set during modify_wq.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  3 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
 drivers/infiniband/hw/mlx5/qp.c      | 36 +++++++++++++++++++++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 02da3f58f296..f66f693c058b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -715,6 +715,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (mlx5_get_flow_namespace(dev->mdev, MLX5_FLOW_NAMESPACE_BYPASS))
 		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
 
+	if (MLX5_CAP_GEN(mdev, end_pad))
+		props->device_cap_flags |= IB_DEVICE_SCATTER_END_PADDING;
+
 	props->vendor_part_id	   = mdev->pdev->device;
 	props->hw_ver		   = mdev->pdev->revision;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e7deaa08535b..b30945c3a1fb 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -228,6 +228,7 @@ struct wr_list {
 
 enum mlx5_ib_rq_flags {
 	MLX5_IB_RQ_CVLAN_STRIPPING	= 1 << 0,
+	MLX5_IB_RQ_SCATTER_END_PADDING	= 1 << 1,
 };
 
 struct mlx5_ib_wq {
@@ -420,6 +421,7 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_RSS				= 1 << 8,
 	MLX5_IB_QP_CVLAN_STRIPPING		= 1 << 9,
 	MLX5_IB_QP_UNDERLAY			= 1 << 10,
+	MLX5_IB_QP_SCATTER_END_PADDING		= 1 << 11,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d209c684d729..511d4fdcaaae 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1178,8 +1178,8 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 
 	wq = MLX5_ADDR_OF(rqc, rqc, wq);
 	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
-	MLX5_SET(wq, wq, end_padding_mode,
-		 MLX5_GET(qpc, qpc, end_padding_mode));
+	if (rq->flags & MLX5_IB_RQ_SCATTER_END_PADDING)
+		MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
 	MLX5_SET(wq, wq, page_offset, MLX5_GET(qpc, qpc, page_offset));
 	MLX5_SET(wq, wq, pd, MLX5_GET(qpc, qpc, pd));
 	MLX5_SET64(wq, wq, dbr_addr, MLX5_GET64(qpc, qpc, dbr_addr));
@@ -1266,6 +1266,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 		if (qp->flags & MLX5_IB_QP_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
+		if (qp->flags & MLX5_IB_QP_SCATTER_END_PADDING)
+			rq->flags |= MLX5_IB_RQ_SCATTER_END_PADDING;
 		err = create_raw_packet_qp_rq(dev, rq, in);
 		if (err)
 			goto err_destroy_sq;
@@ -1781,6 +1783,19 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags |= MLX5_IB_QP_LSO;
 	}
 
+	if (init_attr->create_flags & IB_QP_CREATE_SCATTER_END_PADDING) {
+		if (!MLX5_CAP_GEN(dev->mdev, end_pad)) {
+			mlx5_ib_dbg(dev, "scatter end padding is not supported\n");
+			err = -EOPNOTSUPP;
+			goto err;
+		} else if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
+			MLX5_SET(qpc, qpc, end_padding_mode,
+				 MLX5_WQ_END_PAD_MODE_ALIGN);
+		} else {
+			qp->flags |= MLX5_IB_QP_SCATTER_END_PADDING;
+		}
+	}
+
 	if (init_attr->qp_type == IB_QPT_RAW_PACKET ||
 	    qp->flags & MLX5_IB_QP_UNDERLAY) {
 		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd.sq_buf_addr;
@@ -1825,6 +1840,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	else if (qp->create_type == MLX5_QP_KERNEL)
 		destroy_qp_kernel(dev, qp);
 
+err:
 	kvfree(in);
 	return err;
 }
@@ -4709,7 +4725,15 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	MLX5_SET(wq, wq, wq_type,
 		 rwq->create_flags & MLX5_IB_WQ_FLAGS_STRIDING_RQ ?
 		 MLX5_WQ_TYPE_CYCLIC_STRIDING_RQ : MLX5_WQ_TYPE_CYCLIC);
-	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+	if (init_attr->create_flags & IB_WQ_FLAGS_SCATTER_END_PADDING) {
+		if (!MLX5_CAP_GEN(dev->mdev, end_pad)) {
+			mlx5_ib_dbg(dev, "Scatter end padding is not supported\n");
+			err = -EOPNOTSUPP;
+			goto out;
+		} else {
+			MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+		}
+	}
 	MLX5_SET(wq, wq, log_wq_stride, rwq->log_rq_stride);
 	if (rwq->create_flags & MLX5_IB_WQ_FLAGS_STRIDING_RQ) {
 		MLX5_SET(wq, wq, two_byte_shift_en, rwq->two_byte_shift_en);
@@ -5089,6 +5113,12 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 			MLX5_SET(rqc, rqc, vsd,
 				 (wq_attr->flags & IB_WQ_FLAGS_CVLAN_STRIPPING) ? 0 : 1);
 		}
+
+		if (wq_attr->flags_mask & IB_WQ_FLAGS_SCATTER_END_PADDING) {
+			mlx5_ib_dbg(dev, "Modifying scatter end padding is not supported\n");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
 	}
 
 	if (curr_wq_state == IB_WQS_RESET && wq_state == IB_WQS_RDY) {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
