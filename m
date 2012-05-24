From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] IB/mlx4: Fix max_wqe capacity report for query device
Date: Thu, 24 May 2012 16:08:08 +0300
Message-ID: <1337864889-20886-3-git-send-email-ogerlitz@mellanox.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337864889-20886-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

1. Limit max number of wqes per QP reported when querying the device,
so that ib_create_qp will never fail due to any additional headroom WQEs
allocated.

2. Limit qp resources accepted for ib_create_qp() to the limits
reported in ib_query_device(). In kernel space, make sure that
the limits returned to the caller following qp creation also
lie within the reported device limits. For userspace, report
as before, and do adjustment in libmlx4 (so as not to break ABI).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Roland, you can see past correspondence from 2007 (...) here:
http://lists.openfabrics.org/pipermail/general/2007-October/042351.html

The libmlx4 patches will be send in a user space batch which has also 
has the user space RAW QP code and more fun stuff, after 3.5-rc1 is out,
but again, this specific patch was written as of not to introduce mlx4 
ABI changes.

 drivers/infiniband/hw/mlx4/main.c    |    2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    8 ++++++++
 drivers/infiniband/hw/mlx4/qp.c      |   25 +++++++++++++++++++------
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8afea12..3530c41 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -140,7 +140,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_mr_size	   = ~0ull;
 	props->page_size_cap	   = dev->dev->caps.page_size_cap;
 	props->max_qp		   = dev->dev->caps.num_qps - dev->dev->caps.reserved_qps;
-	props->max_qp_wr	   = dev->dev->caps.max_wqes;
+	props->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
 	props->max_sge		   = min(dev->dev->caps.max_sq_sg,
 					 dev->dev->caps.max_rq_sg);
 	props->max_cq		   = dev->dev->caps.num_cqs - dev->dev->caps.reserved_cqs;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e62297c..6c45b8f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -44,6 +44,14 @@
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
 
+enum {
+	MLX4_IB_SQ_MIN_WQE_SHIFT = 6,
+	MLX4_IB_MAX_HEADROOM	 = 2048
+};
+
+#define MLX4_IB_SQ_HEADROOM(shift) ((MLX4_IB_MAX_HEADROOM >> (shift)) + 1)
+#define MLX4_IB_SQ_MAX_SPARE (MLX4_IB_SQ_HEADROOM(MLX4_IB_SQ_MIN_WQE_SHIFT))
+
 struct mlx4_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct mlx4_uar		uar;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index ceb3332..ca8115f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -310,8 +310,9 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		       int is_user, int has_rq, struct mlx4_ib_qp *qp)
 {
 	/* Sanity check RQ size before proceeding */
-	if (cap->max_recv_wr  > dev->dev->caps.max_wqes  ||
-	    cap->max_recv_sge > dev->dev->caps.max_rq_sg)
+	if (cap->max_recv_wr > dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE ||
+	    cap->max_recv_sge >
+		min(dev->dev->caps.max_sq_sg, dev->dev->caps.max_rq_sg))
 		return -EINVAL;
 
 	if (!has_rq) {
@@ -329,8 +330,19 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		qp->rq.wqe_shift = ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg));
 	}
 
-	cap->max_recv_wr  = qp->rq.max_post = qp->rq.wqe_cnt;
-	cap->max_recv_sge = qp->rq.max_gs;
+	/* leave userspace return values as they were, so as not to break ABI */
+	if (is_user) {
+		cap->max_recv_wr  = qp->rq.max_post = qp->rq.wqe_cnt;
+		cap->max_recv_sge = qp->rq.max_gs;
+	} else {
+		cap->max_recv_wr  = qp->rq.max_post =
+			min(dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE, qp->rq.wqe_cnt);
+		cap->max_recv_sge = min(qp->rq.max_gs,
+					min(dev->dev->caps.max_sq_sg,
+					dev->dev->caps.max_rq_sg));
+	}
+	/* We don't support inline sends for kernel QPs (yet) */
+
 
 	return 0;
 }
@@ -341,8 +353,9 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	int s;
 
 	/* Sanity check SQ size before proceeding */
-	if (cap->max_send_wr	 > dev->dev->caps.max_wqes  ||
-	    cap->max_send_sge	 > dev->dev->caps.max_sq_sg ||
+	if (cap->max_send_wr	 > (dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE) ||
+	    cap->max_send_sge	 >
+		min(dev->dev->caps.max_sq_sg, dev->dev->caps.max_rq_sg) ||
 	    cap->max_inline_data + send_wqe_overhead(type, qp->flags) +
 	    sizeof (struct mlx4_wqe_inline_seg) > dev->dev->caps.max_sq_desc_sz)
 		return -EINVAL;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
