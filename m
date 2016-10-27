From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 10/12] IB/mlx5: Fix reported max SGE calculation
Date: Thu, 27 Oct 2016 16:36:45 +0300
Message-ID: <1477575407-20562-11-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the 512 bytes limit of RDMA READ and the size of remote
address to the max SGE calculation.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |  8 +++++---
 drivers/infiniband/hw/mlx5/qp.c   | 29 ++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 88ff2e3..8ebfd1e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -496,6 +496,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	int err = -ENOMEM;
+	int max_sq_desc;
 	int max_rq_sg;
 	int max_sq_sg;
 	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
@@ -618,9 +619,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_qp_wr	   = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
 	max_rq_sg =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
 		     sizeof(struct mlx5_wqe_data_seg);
-	max_sq_sg = (MLX5_CAP_GEN(mdev, max_wqe_sz_sq) -
-		     sizeof(struct mlx5_wqe_ctrl_seg)) /
-		     sizeof(struct mlx5_wqe_data_seg);
+	max_sq_desc = min_t(int, MLX5_CAP_GEN(mdev, max_wqe_sz_sq), 512);
+	max_sq_sg = (max_sq_desc - sizeof(struct mlx5_wqe_ctrl_seg) -
+		     sizeof(struct mlx5_wqe_raddr_seg)) /
+		sizeof(struct mlx5_wqe_data_seg);
 	props->max_sge = min(max_rq_sg, max_sq_sg);
 	props->max_sge_rd	   = MLX5_MAX_SGE_RD;
 	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 047f7e4..2ba0bbf 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -352,6 +352,29 @@ static int calc_send_wqe(struct ib_qp_init_attr *attr)
 		return ALIGN(max_t(int, inl_size, size), MLX5_SEND_WQE_BB);
 }
 
+static int get_send_sge(struct ib_qp_init_attr *attr, int wqe_size)
+{
+	int max_sge;
+
+	if (attr->qp_type == IB_QPT_RC)
+		max_sge = (min_t(int, wqe_size, 512) -
+			   sizeof(struct mlx5_wqe_ctrl_seg) -
+			   sizeof(struct mlx5_wqe_raddr_seg)) /
+			sizeof(struct mlx5_wqe_data_seg);
+	else if (attr->qp_type == IB_QPT_XRC_INI)
+		max_sge = (min_t(int, wqe_size, 512) -
+			   sizeof(struct mlx5_wqe_ctrl_seg) -
+			   sizeof(struct mlx5_wqe_xrc_seg) -
+			   sizeof(struct mlx5_wqe_raddr_seg)) /
+			sizeof(struct mlx5_wqe_data_seg);
+	else
+		max_sge = (wqe_size - sq_overhead(attr)) /
+			sizeof(struct mlx5_wqe_data_seg);
+
+	return min_t(int, max_sge, wqe_size - sq_overhead(attr) /
+		     sizeof(struct mlx5_wqe_data_seg));
+}
+
 static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 			struct mlx5_ib_qp *qp)
 {
@@ -388,7 +411,11 @@ static int calc_sq_size(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 		return -ENOMEM;
 	}
 	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
-	qp->sq.max_gs = attr->cap.max_send_sge;
+	qp->sq.max_gs = get_send_sge(attr, wqe_size);
+	if (qp->sq.max_gs < attr->cap.max_send_sge)
+		return -ENOMEM;
+
+	attr->cap.max_send_sge = qp->sq.max_gs;
 	qp->sq.max_post = wq_size / wqe_size;
 	attr->cap.max_send_wr = qp->sq.max_post;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
