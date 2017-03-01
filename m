From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/20] IB/rdmavt: Avoid reseting wqe send_flags in unreserve
Date: Wed, 01 Mar 2017 10:23:30 -0800
Message-ID: <20170301182323.29989.59221.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The wqe should be read only and in fact the superfluous reset of the
RVT_SEND_RESERVE_USED flag causes an issue where reserved operations
elicit a bad completion to the ULP.

The maintenance of the flag is now entirely within rvt_post_one_wr()
where a reserved operation will set the flag and a non-reserved operation
will insure the operation that is about to be posted has the flag reset.

Fixes: Commit 856cc4c237ad ("IB/hfi1: Add the capability for reserved operations")
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    7 +++++--
 include/rdma/rdmavt_qp.h          |    4 +---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index d7dabdf..728f5f1 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1772,10 +1772,13 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 					0);
 		qp->s_next_psn = wqe->lpsn + 1;
 	}
-	if (unlikely(reserved_op))
+	if (unlikely(reserved_op)) {
+		wqe->wr.send_flags |= RVT_SEND_RESERVE_USED;
 		rvt_qp_wqe_reserve(qp, wqe);
-	else
+	} else {
+		wqe->wr.send_flags &= ~RVT_SEND_RESERVE_USED;
 		qp->s_avail--;
+	}
 	trace_rvt_post_one_wr(qp, wqe);
 	smp_wmb(); /* see request builders */
 	qp->s_head = next;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 3cdd9e2..e3bb312 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVT_INCQP_H
 
 /*
- * Copyright(c) 2016 Intel Corporation.
+ * Copyright(c) 2016, 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -526,7 +526,6 @@ static inline void rvt_qp_wqe_reserve(
 	struct rvt_qp *qp,
 	struct rvt_swqe *wqe)
 {
-	wqe->wr.send_flags |= RVT_SEND_RESERVE_USED;
 	atomic_inc(&qp->s_reserved_used);
 }
 
@@ -550,7 +549,6 @@ static inline void rvt_qp_wqe_unreserve(
 	struct rvt_swqe *wqe)
 {
 	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED)) {
-		wqe->wr.send_flags &= ~RVT_SEND_RESERVE_USED;
 		atomic_dec(&qp->s_reserved_used);
 		/* insure no compiler re-order up to s_last change */
 		smp_mb__after_atomic();

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
