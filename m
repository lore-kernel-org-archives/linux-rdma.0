From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/13] IB/rdmavt: Move reset calldown to reset path
Date: Tue, 06 Sep 2016 04:37:07 -0700
Message-ID: <20160906113658.27413.21709.stgit@scvm10.sc.intel.com>
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

The reset calldown is misplaced.

It should only be called in the code that actually
transitions the QP to reset.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 80d2c50..0a29815 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -530,14 +530,13 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		spin_lock(&qp->s_lock);
 
 		rvt_clear_mr_refs(qp, 1);
+		/*
+		 * Let the driver do any tear down it needs to for a qp
+		 * that has been reset
+		 */
+		rdi->driver_f.notify_qp_reset(qp);
 	}
 
-	/*
-	 * Let the driver do any tear down it needs to for a qp
-	 * that has been reset
-	 */
-	rdi->driver_f.notify_qp_reset(qp);
-
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
 	qp->qp_access_flags = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
