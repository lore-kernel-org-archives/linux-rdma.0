From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 1/2] iw_cxgb4: serialize CQ event upcalls with CQ destruction
Date: Wed, 17 Dec 2014 14:11:02 +0530
Message-ID: <1418805663-15333-2-git-send-email-hariprasad@chelsio.com>
References: <1418805663-15333-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418805663-15333-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A race exists where the application can be destroying the CQ concurrently
with a HW interrupt indicating a completion has been inserted into the CQ.
This can case an event notification upcall to the application after the
CQ has been destroyed.

The solution is to serialize looking up the CQ in the IDR table and
referencing the CQ in c4iw_ev_handler(), with removing the CQID from the
IDR table and blocking until the refcnt reaches 0 in c4iw_destroy_cq().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/ev.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index c9df054..4498a89 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -225,13 +225,20 @@ int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
 	struct c4iw_cq *chp;
 	unsigned long flag;
 
+	spin_lock_irqsave(&dev->lock, flag);
 	chp = get_chp(dev, qid);
 	if (chp) {
+		atomic_inc(&chp->refcnt);
+		spin_unlock_irqrestore(&dev->lock, flag);
 		t4_clear_cq_armed(&chp->cq);
 		spin_lock_irqsave(&chp->comp_handler_lock, flag);
 		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
 		spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
-	} else
+		if (atomic_dec_and_test(&chp->refcnt))
+			wake_up(&chp->wait);
+	} else {
 		PDBG("%s unknown cqid 0x%x\n", __func__, qid);
+		spin_unlock_irqrestore(&dev->lock, flag);
+	}
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
