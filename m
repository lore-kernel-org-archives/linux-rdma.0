From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] i40iw: Correct CQ arming
Date: Tue, 14 Jun 2016 16:54:16 -0500
Message-ID: <1465941259-4492-2-git-send-email-shiraz.saleem@intel.com>
References: <1465941259-4492-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465941259-4492-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CQ is armed for solicited events only, ignoring other notification
flags. Correct this by arming for next and arming for solicited
event if IB_CQ_SOLICITED is set. Also protect CQ shadow area update
with spinlock.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 02a735b..c6e75ac 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2327,13 +2327,16 @@ static int i40iw_req_notify_cq(struct ib_cq *ibcq,
 {
 	struct i40iw_cq *iwcq;
 	struct i40iw_cq_uk *ukcq;
-	enum i40iw_completion_notify cq_notify = IW_CQ_COMPL_SOLICITED;
+	unsigned long flags;
+	enum i40iw_completion_notify cq_notify = IW_CQ_COMPL_EVENT;
 
 	iwcq = (struct i40iw_cq *)ibcq;
 	ukcq = &iwcq->sc_cq.cq_uk;
-	if (notify_flags == IB_CQ_NEXT_COMP)
-		cq_notify = IW_CQ_COMPL_EVENT;
+	if (notify_flags == IB_CQ_SOLICITED)
+		cq_notify = IW_CQ_COMPL_SOLICITED;
+	spin_lock_irqsave(&iwcq->lock, flags);
 	ukcq->ops.iw_cq_request_notification(ukcq, cq_notify);
+	spin_unlock_irqrestore(&iwcq->lock, flags);
 	return 0;
 }
 
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
