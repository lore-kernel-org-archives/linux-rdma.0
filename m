From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/4] RDMA/bnxt_re: synchronize poll_cq and req_notify_cq verbs
Date: Mon,  6 Nov 2017 08:07:32 -0800
Message-ID: <1509984452-18336-5-git-send-email-selvin.xavier@broadcom.com>
References: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509984452-18336-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Synchronize poll_cq and req_notify_cq verbs using cq_lock,
instead of the lower level qplib->hwq.lock.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 96ec797..d5770aa 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2999,8 +2999,10 @@ int bnxt_re_req_notify_cq(struct ib_cq *ib_cq,
 			  enum ib_cq_notify_flags ib_cqn_flags)
 {
 	struct bnxt_re_cq *cq = container_of(ib_cq, struct bnxt_re_cq, ib_cq);
-	int type = 0;
+	int type = 0, rc = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&cq->cq_lock, flags);
 	/* Trigger on the very next completion */
 	if (ib_cqn_flags & IB_CQ_NEXT_COMP)
 		type = DBR_DBR_TYPE_CQ_ARMALL;
@@ -3010,12 +3012,15 @@ int bnxt_re_req_notify_cq(struct ib_cq *ib_cq,
 
 	/* Poll to see if there are missed events */
 	if ((ib_cqn_flags & IB_CQ_REPORT_MISSED_EVENTS) &&
-	    !(bnxt_qplib_is_cq_empty(&cq->qplib_cq)))
-		return 1;
-
+	    !(bnxt_qplib_is_cq_empty(&cq->qplib_cq))) {
+		rc = 1;
+		goto exit;
+	}
 	bnxt_qplib_req_notify_cq(&cq->qplib_cq, type);
 
-	return 0;
+exit:
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+	return rc;
 }
 
 /* Memory Regions */
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
