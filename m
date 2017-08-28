From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/9] IB/hfi1: Use accessor to determine ring size
Date: Mon, 28 Aug 2017 11:23:39 -0700
Message-ID: <20170828182338.29434.15806.stgit@scvm10.sc.intel.com>
References: <20170828182121.29434.18989.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828182121.29434.18989.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The qp_stats print will soon be moving to rdmavt, so use the proper
accessor to get the ring size rather than a driver supplied constant.

Fixes: Commit ff8d836efe06 ("IB/hfi1: Add receiving queue info to qp_stats")
Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index b87889d..6daa396 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -659,7 +659,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   qp->s_avail,
 		   /* ack_queue ring pointers, size */
 		   qp->s_tail_ack_queue, qp->r_head_ack_queue,
-		   HFI1_MAX_RDMA_ATOMIC,
+		   rvt_max_atomic(&to_idev(qp->ibqp.device)->rdi),
 		   /* remote QP info  */
 		   qp->remote_qpn,
 		   rdma_ah_get_dlid(&qp->remote_ah_attr),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
