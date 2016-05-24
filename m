From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/10] IB/hfi1: Fix hard lockup due to not using
 save/restore spin lock
Date: Tue, 24 May 2016 12:50:23 -0700
Message-ID: <20160524195022.19706.52616.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org#4.6+
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Commit b9b06cb6feda
("IB/hfi1: Fix missing lock/unlock in verbs drain callback")
added a spin lock.

Unfortunately, the new lock code can be called from a base
level interrupt state, and an interrupt that can get stacked
will attempt to get the same lock.

Fix by using the flag save/restore spin lock variation.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.6+
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 14f889e..1a942ff 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
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
