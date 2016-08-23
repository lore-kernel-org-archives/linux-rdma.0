From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] iw_cxgb4: Fix cxgb4 arm CQ logic to handle IB_CQ_REPORT_MISSED_EVENTS
Date: Tue, 23 Aug 2016 20:27:33 +0530
Message-ID: <20160823145733.21093-1-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Current cxgb4 arm CQ logic ignores IB_CQ_REPORT_MISSED_EVENTS for
request completion notification on a CQ. Due to this ib_poll_handler()
assumes all events polled and avoids further iopoll scheduling.

This patch adds logic to cxgb4 ib_req_notify_cq() handler to check if
CQ is not empty and return accordingly. Based on the return value of
ib_req_notify_cq() handler, ib_poll_handler() will schedule a run of
iopoll handler.

Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 10 +++++-----
 drivers/infiniband/hw/cxgb4/t4.h |  5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 812ab7278b8e..ac926c942fee 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -1016,15 +1016,15 @@ int c4iw_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata)
 int c4iw_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct c4iw_cq *chp;
-	int ret;
+	int ret = 0;
 	unsigned long flag;
 
 	chp = to_c4iw_cq(ibcq);
 	spin_lock_irqsave(&chp->lock, flag);
-	ret = t4_arm_cq(&chp->cq,
-			(flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED);
+	t4_arm_cq(&chp->cq,
+		  (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED);
+	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
+		ret = t4_cq_notempty(&chp->cq);
 	spin_unlock_irqrestore(&chp->lock, flag);
-	if (ret && !(flags & IB_CQ_REPORT_MISSED_EVENTS))
-		ret = 0;
 	return ret;
 }
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 6126bbe36095..02173f4315fa 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -634,6 +634,11 @@ static inline int t4_valid_cqe(struct t4_cq *cq, struct t4_cqe *cqe)
 	return (CQE_GENBIT(cqe) == cq->gen);
 }
 
+static inline int t4_cq_notempty(struct t4_cq *cq)
+{
+	return cq->sw_in_use || t4_valid_cqe(cq, &cq->queue[cq->cidx]);
+}
+
 static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
 {
 	int ret;
-- 
2.10.0.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
