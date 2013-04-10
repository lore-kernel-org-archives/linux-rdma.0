From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx4: Fetch XRC SRQ in the CQ polling code
Date: Wed, 10 Apr 2013 17:26:48 +0300
Message-ID: <1365604008-22455-4-git-send-email-ogerlitz@mellanox.com>
References: <1365604008-22455-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365604008-22455-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

An XRC target QP may redirect to more than one XRC SRQ. This means
that for work completions associated with a XRC TGT QP, the srq field
in the QP has no usage and the real XRC SRQ need to be retrived using
the information from the XRCETH placed into the CQE, do that.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index ae67df3..dab4b51 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -33,6 +33,7 @@
 
 #include <linux/mlx4/cq.h>
 #include <linux/mlx4/qp.h>
+#include <linux/mlx4/srq.h>
 #include <linux/slab.h>
 
 #include "mlx4_ib.h"
@@ -585,6 +586,7 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 	struct mlx4_qp *mqp;
 	struct mlx4_ib_wq *wq;
 	struct mlx4_ib_srq *srq;
+	struct mlx4_srq *msrq = NULL;
 	int is_send;
 	int is_error;
 	u32 g_mlpath_rqpn;
@@ -653,6 +655,20 @@ repoll:
 
 	wc->qp = &(*cur_qp)->ibqp;
 
+	if (wc->qp->qp_type == IB_QPT_XRC_TGT) {
+		u32 srq_num;
+		g_mlpath_rqpn = be32_to_cpu(cqe->g_mlpath_rqpn);
+		srq_num       = g_mlpath_rqpn & 0xffffff;
+		/* SRQ is also in the radix tree */
+		msrq = mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
+				       srq_num);
+		if (unlikely(!msrq)) {
+			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
+				cq->mcq.cqn, srq_num);
+			return -EINVAL;
+		}
+	}
+
 	if (is_send) {
 		wq = &(*cur_qp)->sq;
 		if (!(*cur_qp)->sq_signal_bits) {
@@ -666,6 +682,11 @@ repoll:
 		wqe_ctr = be16_to_cpu(cqe->wqe_index);
 		wc->wr_id = srq->wrid[wqe_ctr];
 		mlx4_ib_free_srq_wqe(srq, wqe_ctr);
+	} else if (msrq) {
+		srq = to_mibsrq(msrq);
+		wqe_ctr = be16_to_cpu(cqe->wqe_index);
+		wc->wr_id = srq->wrid[wqe_ctr];
+		mlx4_ib_free_srq_wqe(srq, wqe_ctr);
 	} else {
 		wq	  = &(*cur_qp)->rq;
 		tail	  = wq->tail & (wq->wqe_cnt - 1);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
