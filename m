From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] IB/sa: Put netlink request into the request list before sending
Date: Wed, 28 Oct 2015 09:44:27 -0400
Message-ID: <1446039867-27883-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It was found by Saurabh Sengar that the netlink code tried to allocate
memory with GFP_KERNEL while holding a spinlock. While it is possible
to fix the issue by replacing GFP_KERNEL with GFP_ATOMIC, it is better
to get rid of the spinlock while sending the packet. However, in order
to protect against a race condition that a quick response may be received
before the request is put on the request list, we need to put the request
on the list first.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index edcf568..240b57c 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -562,23 +562,25 @@ static int ib_nl_make_request(struct ib_sa_query *query)
 	INIT_LIST_HEAD(&query->list);
 	query->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
 
+	/* Put the request on the list first.*/
 	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
+	query->timeout = delay + jiffies;
+	list_add_tail(&query->list, &ib_nl_request_list);
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
 	ret = ib_nl_send_msg(query);
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
 	if (ret <= 0) {
 		ret = -EIO;
-		goto request_out;
+		/* Remove the request */
+		list_del(&query->list);
 	} else {
 		ret = 0;
+		/* Start the timeout if this is the only request */
+		if (ib_nl_request_list.next == &query->list)
+			queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
 	}
-
-	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
-	query->timeout = delay + jiffies;
-	list_add_tail(&query->list, &ib_nl_request_list);
-	/* Start the timeout if this is the only request */
-	if (ib_nl_request_list.next == &query->list)
-		queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
-
-request_out:
 	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 
 	return ret;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
