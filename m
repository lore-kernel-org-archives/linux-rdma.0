From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 09/13] IB/rdmavt: Correct sparse annotation
Date: Tue, 06 Sep 2016 04:36:33 -0700
Message-ID: <20160906113623.27413.51936.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The __must_hold() is sufficent to correct the sparse
context imbalance inside a function.

Per Documentation/sparse.txt:
__must_hold - The specified lock is held on function entry and exit.

Fixes: Commit c0a67f6ba356 ("IB/rdmavt: Annotate rvt_reset_qp()")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index da5c8d6..80d2c50 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -500,12 +500,9 @@ static void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
  */
 static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		  enum ib_qp_type type)
-	__releases(&qp->s_lock)
-	__releases(&qp->s_hlock)
-	__releases(&qp->r_lock)
-	__acquires(&qp->r_lock)
-	__acquires(&qp->s_hlock)
-	__acquires(&qp->s_lock)
+	__must_hold(&qp->r_lock)
+	__must_hold(&qp->s_hlock)
+	__must_hold(&qp->s_lock)
 {
 	if (qp->state != IB_QPS_RESET) {
 		qp->state = IB_QPS_RESET;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
