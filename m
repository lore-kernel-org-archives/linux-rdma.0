From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 18/18] IB/rdmavt: Use new driver specific post send
 table
Date: Fri, 01 Jul 2016 16:02:24 -0700
Message-ID: <20160701230223.20160.95655.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change rvt_post_one_wr to use the new table mechanism for
post send.

Validate that each low level driver specifies the table.

Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   46 ++++++-------------------------------
 drivers/infiniband/sw/rdmavt/vt.c |    3 ++
 2 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index d2b5b54..ebc37f5 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1535,6 +1535,7 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
 	u8 log_pmtu;
 	int ret;
+	size_t cplen;
 
 	BUILD_BUG_ON(IB_QPT_MAX >= (sizeof(u32) * BITS_PER_BYTE));
 
@@ -1542,32 +1543,11 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	if (unlikely(wr->num_sge > qp->s_max_sge))
 		return -EINVAL;
 
-	/*
-	 * Don't allow RDMA reads or atomic operations on UC or
-	 * undefined operations.
-	 * Make sure buffer is large enough to hold the result for atomics.
-	 */
-	if (qp->ibqp.qp_type == IB_QPT_UC) {
-		if ((unsigned)wr->opcode >= IB_WR_RDMA_READ)
-			return -EINVAL;
-	} else if (qp->ibqp.qp_type != IB_QPT_RC) {
-		/* Check IB_QPT_SMI, IB_QPT_GSI, IB_QPT_UD opcode */
-		if (wr->opcode != IB_WR_SEND &&
-		    wr->opcode != IB_WR_SEND_WITH_IMM)
-			return -EINVAL;
-		/* Check UD destination address PD */
-		if (qp->ibqp.pd != ud_wr(wr)->ah->pd)
-			return -EINVAL;
-	} else if ((unsigned)wr->opcode > IB_WR_ATOMIC_FETCH_AND_ADD) {
-		return -EINVAL;
-	} else if (wr->opcode >= IB_WR_ATOMIC_CMP_AND_SWP &&
-		   (wr->num_sge == 0 ||
-		    wr->sg_list[0].length < sizeof(u64) ||
-		    wr->sg_list[0].addr & (sizeof(u64) - 1))) {
-		return -EINVAL;
-	} else if (wr->opcode >= IB_WR_RDMA_READ && !qp->s_max_rd_atomic) {
-		return -EINVAL;
-	}
+	ret = rvt_qp_valid_operation(qp, rdi->post_parms, wr);
+	if (ret < 0)
+		return ret;
+	cplen = ret;
+
 	/* check for avail */
 	if (unlikely(!qp->s_avail)) {
 		qp->s_avail = qp_get_savail(qp);
@@ -1588,18 +1568,8 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	wqe = rvt_get_swqe_ptr(qp, qp->s_head);
 
-	if (qp->ibqp.qp_type != IB_QPT_UC &&
-	    qp->ibqp.qp_type != IB_QPT_RC)
-		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
-	else if (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
-		 wr->opcode == IB_WR_RDMA_WRITE ||
-		 wr->opcode == IB_WR_RDMA_READ)
-		memcpy(&wqe->rdma_wr, rdma_wr(wr), sizeof(wqe->rdma_wr));
-	else if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
-		 wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
-		memcpy(&wqe->atomic_wr, atomic_wr(wr), sizeof(wqe->atomic_wr));
-	else
-		memcpy(&wqe->wr, wr, sizeof(wqe->wr));
+	/* cplen has length from above */
+	memcpy(&wqe->wr, wr, cplen);
 
 	wqe->length = 0;
 	j = 0;
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 30c4fda..89fe967 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -528,7 +528,8 @@ static noinline int check_support(struct rvt_dev_info *rdi, int verb)
 							 post_send),
 					   rvt_post_send))
 			if (!rdi->driver_f.schedule_send ||
-			    !rdi->driver_f.do_send)
+			    !rdi->driver_f.do_send ||
+			    !rdi->post_parms)
 				return -EINVAL;
 		break;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
