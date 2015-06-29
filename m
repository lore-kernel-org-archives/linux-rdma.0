From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] mlx4, mlx5, mthca: Expose max_sge_rd correctly
Date: Mon, 29 Jun 2015 21:12:44 +0300
Message-ID: <1435601564-10830-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applications must not assume that max_sge and max_sge_rd
are the same, Hence expose max_sge_rd correctly as well.

Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c            | 1 +
 drivers/infiniband/hw/mlx5/main.c            | 1 +
 drivers/infiniband/hw/mthca/mthca_provider.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 166da78..81c342f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -229,6 +229,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
 	props->max_sge		   = min(dev->dev->caps.max_sq_sg,
 					 dev->dev->caps.max_rq_sg);
+	props->max_sge_rd = props->max_sge;
 	props->max_cq		   = dev->dev->quotas.cq;
 	props->max_cqe		   = dev->dev->caps.max_cqes;
 	props->max_mr		   = dev->dev->quotas.mpt;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index eb938ea..2ef6f40 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -138,6 +138,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	max_sq_sg = (gen->max_sq_desc_sz - sizeof(struct mlx5_wqe_ctrl_seg)) /
 		sizeof(struct mlx5_wqe_data_seg);
 	props->max_sge = min(max_rq_sg, max_sq_sg);
+	props->max_sge_rd = props->max_sge;
 	props->max_cq		   = 1 << gen->log_max_cq;
 	props->max_cqe		   = gen->max_cqes - 1;
 	props->max_mr		   = 1 << gen->log_max_mkey;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 93ae51d..dc2d48c 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -97,6 +97,7 @@ static int mthca_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 	props->max_qp              = mdev->limits.num_qps - mdev->limits.reserved_qps;
 	props->max_qp_wr           = mdev->limits.max_wqes;
 	props->max_sge             = mdev->limits.max_sg;
+	props->max_sge_rd          = props->max_sge;
 	props->max_cq              = mdev->limits.num_cqs - mdev->limits.reserved_cqs;
 	props->max_cqe             = mdev->limits.max_cqes;
 	props->max_mr              = mdev->limits.num_mpts - mdev->limits.reserved_mrws;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
