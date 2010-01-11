From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMA Read sge errors
Date: Mon, 11 Jan 2010 14:21:46 +0200
Message-ID: <4B4B17DA.2070106@Voltaire.com>
References: <2AAC14CC-DACE-4CD8-833A-5E7406593732@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2AAC14CC-DACE-4CD8-833A-5E7406593732-U0mLk4xYmo8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jack, I see now that commit cd155c1 "IB/mlx4: Fix creation of kernel QP with max number of send s/g entries" is mainstream but not ofed 1.4.x and that mlx4_0090_fix_sq_wrs.patch (below) is in ofed but not mainstream, was it rejected from the mainline kernel? why?

Or.


1. Limit qp resources accepted for ib_create_qp() to the limits reported
   in ib_query_device(). In kernel space,make sure that the limits
   returned to the caller following qp creation also lie within the
   reported device limits. For userspace, report as before, and
   do adjustment in libmlx4 (so as not to break ABI).

2. Limit max number of wqes per QP reported when querying the device,
   so that ib_create_qp will never fail due to any additional headroom WQEs allocated.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 drivers/infiniband/hw/mlx4/main.c    |    2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    7 +++++++
 drivers/infiniband/hw/mlx4/qp.c      |   25 +++++++++++++++++++------
 3 files changed, 27 insertions(+), 7 deletions(-)

Index: ofed_kernel/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/hw/mlx4/main.c
+++ ofed_kernel/drivers/infiniband/hw/mlx4/main.c
@@ -122,7 +122,7 @@ static int mlx4_ib_query_device(struct i
 	props->max_mr_size	   = ~0ull;
 	props->page_size_cap	   = dev->dev->caps.page_size_cap;
 	props->max_qp		   = dev->dev->caps.num_qps - dev->dev->caps.reserved_qps;
-	props->max_qp_wr	   = dev->dev->caps.max_wqes;
+	props->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
 	props->max_sge		   = min(dev->dev->caps.max_sq_sg,
 					 dev->dev->caps.max_rq_sg);
 	props->max_cq		   = dev->dev->caps.num_cqs - dev->dev->caps.reserved_cqs;
Index: ofed_kernel/drivers/infiniband/hw/mlx4/mlx4_ib.h
===================================================================
--- ofed_kernel.orig/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ ofed_kernel/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -44,6 +44,13 @@
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
 
+enum {
+	MLX4_IB_SQ_MIN_WQE_SHIFT = 6
+};
+
+#define MLX4_IB_SQ_HEADROOM(shift) ((2048 >> (shift)) + 1)
+#define MLX4_IB_SQ_MAX_SPARE (MLX4_IB_SQ_HEADROOM(MLX4_IB_SQ_MIN_WQE_SHIFT))
+
 struct mlx4_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct mlx4_uar		uar;
Index: ofed_kernel/drivers/infiniband/hw/mlx4/qp.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/hw/mlx4/qp.c
+++ ofed_kernel/drivers/infiniband/hw/mlx4/qp.c
@@ -289,8 +289,9 @@ static int set_rq_size(struct mlx4_ib_de
 		       int is_user, int has_srq, struct mlx4_ib_qp *qp)
 {
 	/* Sanity check RQ size before proceeding */
-	if (cap->max_recv_wr  > dev->dev->caps.max_wqes  ||
-	    cap->max_recv_sge > dev->dev->caps.max_rq_sg)
+	if (cap->max_recv_wr > dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE ||
+	    cap->max_recv_sge >
+		min(dev->dev->caps.max_sq_sg, dev->dev->caps.max_rq_sg))
 		return -EINVAL;
 
 	if (has_srq) {
@@ -309,8 +310,19 @@ static int set_rq_size(struct mlx4_ib_de
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
+				    	dev->dev->caps.max_rq_sg));
+	}
+	/* We don't support inline sends for kernel QPs (yet) */
+
 
 	return 0;
 }
@@ -321,8 +333,9 @@ static int set_kernel_sq_size(struct mlx
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
