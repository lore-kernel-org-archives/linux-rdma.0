From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 6/8] IB/rxe: Add support for IB_CQ_REPORT_MISSED_EVENTS
Date: Wed, 23 Nov 2016 12:39:22 -0500
Message-ID: <1479922764-13091-7-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Peek at the CQ after arming it so that we can return a hint.
This avoids missed completions due to a race between posting
CQEs and arming the CQ.

For example, CM teardown waits on MAD requests to complete with
ib_cq_poll_work(). Without this fix, the last completion might be
left on the CQ, hanging the kthread doing the teardown.

The console backtraces look like this:

[ 4199.911284] Call Trace:
[ 4199.911401]  [<ffffffff9657fe95>] schedule+0x35/0x80
[ 4199.911556]  [<ffffffff965830df>] schedule_timeout+0x22f/0x2c0
[ 4199.911727]  [<ffffffff9657f7a8>] ? __schedule+0x368/0xa20
[ 4199.911891]  [<ffffffff96580903>] wait_for_completion+0xb3/0x130
[ 4199.912067]  [<ffffffff960a17e0>] ? wake_up_q+0x70/0x70
[ 4199.912243]  [<ffffffffc074a06d>] cm_destroy_id+0x13d/0x450 [ib_cm]
[ 4199.912422]  [<ffffffff961615d5>] ? printk+0x57/0x73
[ 4199.912578]  [<ffffffffc074a390>] ib_destroy_cm_id+0x10/0x20 [ib_cm]
[ 4199.912759]  [<ffffffffc076098c>] rdma_destroy_id+0xac/0x340 [rdma_cm]
[ 4199.912941]  [<ffffffffc076f2cc>] 0xffffffffc076f2cc

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 19841c8..de39b0a 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1007,11 +1007,19 @@ static int rxe_peek_cq(struct ib_cq *ibcq, int wc_cnt)
 static int rxe_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct rxe_cq *cq = to_rcq(ibcq);
+	unsigned long irq_flags;
+	int ret = 0;
 
+	spin_lock_irqsave(&cq->cq_lock, irq_flags);
 	if (cq->notify != IB_CQ_NEXT_COMP)
 		cq->notify = flags & IB_CQ_SOLICITED_MASK;
 
-	return 0;
+	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !queue_empty(cq->queue))
+		ret = 1;
+
+	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);
+
+	return ret;
 }
 
 static struct ib_mr *rxe_get_dma_mr(struct ib_pd *ibpd, int access)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
