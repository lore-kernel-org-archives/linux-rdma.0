From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Fix hard lockup due to not using save/restore spin
 lock
Date: Wed, 01 Jun 2016 10:38:12 -0400
Message-ID: <20160601143812.26872.85826.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upstream commit 7049de65c9e5 into 4.6.

Commit b9b06cb6feda
("IB/hfi1: Fix missing lock/unlock in verbs drain callback")
added a spin lock.

Unfortunately, the new lock code can be called from a base
level interrupt state, and an interrupt that can get stacked
will attempt to get the same lock.

Fix by using the flag save/restore spin lock variation.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index dc9119e..0401955 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -512,6 +512,7 @@ static void iowait_wakeup(struct iowait *wait, int reason)
 static void iowait_sdma_drained(struct iowait *wait)
 {
 	struct rvt_qp *qp = iowait_to_qp(wait);
+	unsigned long flags;
 
 	/*
 	 * This happens when the send engine notes
@@ -519,12 +520,12 @@ static void iowait_sdma_drained(struct iowait *wait)
 	 * do the flush work until that QP's
 	 * sdma work has finished.
 	 */
-	spin_lock(&qp->s_lock);
+	spin_lock_irqsave(&qp->s_lock, flags);
 	if (qp->s_flags & RVT_S_WAIT_DMA) {
 		qp->s_flags &= ~RVT_S_WAIT_DMA;
 		hfi1_schedule_send(qp);
 	}
-	spin_unlock(&qp->s_lock);
+	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
