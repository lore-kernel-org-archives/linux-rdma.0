From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 07/11] RDMA/cxgb4: endpoint timeout race condition
Date: Mon,  7 Jan 2013 18:41:56 +0530
Message-ID: <1357564320-15022-8-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The endpoint timeout logic had a race that could cause an endpoint
object to be freed while it was still on the timedout list.  This
can happen if the timer is stopped after it had fired, but before
the timedout thread processed the endpoint timeout.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       |   29 ++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 +
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 51ceb61..ab5b4dd 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -159,10 +159,12 @@ static void start_ep_timer(struct c4iw_ep *ep)
 {
 	PDBG("%s ep %p\n", __func__, ep);
 	if (timer_pending(&ep->timer)) {
-		PDBG("%s stopped / restarted timer ep %p\n", __func__, ep);
-		del_timer_sync(&ep->timer);
-	} else
-		c4iw_get_ep(&ep->com);
+		pr_err("%s timer already started! ep %p\n",
+		       __func__, ep);
+		return;
+	}
+	clear_bit(TIMEOUT, &ep->com.flags);
+	c4iw_get_ep(&ep->com);
 	ep->timer.expires = jiffies + ep_timeout_secs * HZ;
 	ep->timer.data = (unsigned long)ep;
 	ep->timer.function = ep_timeout;
@@ -171,14 +173,10 @@ static void start_ep_timer(struct c4iw_ep *ep)
 
 static void stop_ep_timer(struct c4iw_ep *ep)
 {
-	PDBG("%s ep %p\n", __func__, ep);
-	if (!timer_pending(&ep->timer)) {
-		WARN(1, "%s timer stopped when its not running! "
-		       "ep %p state %u\n", __func__, ep, ep->com.state);
-		return;
-	}
+	PDBG("%s ep %p stopping\n", __func__, ep);
 	del_timer_sync(&ep->timer);
-	c4iw_put_ep(&ep->com);
+	if (!test_and_set_bit(TIMEOUT, &ep->com.flags))
+		c4iw_put_ep(&ep->com);
 }
 
 static int c4iw_l2t_send(struct c4iw_rdev *rdev, struct sk_buff *skb,
@@ -3191,11 +3189,16 @@ static DECLARE_WORK(skb_work, process_work);
 static void ep_timeout(unsigned long arg)
 {
 	struct c4iw_ep *ep = (struct c4iw_ep *)arg;
+	int kickit = 0;
 
 	spin_lock(&timeout_lock);
-	list_add_tail(&ep->entry, &timeout_list);
+	if (!test_and_set_bit(TIMEOUT, &ep->com.flags)) {
+		list_add_tail(&ep->entry, &timeout_list);
+		kickit = 1;
+	}
 	spin_unlock(&timeout_lock);
-	queue_work(workq, &skb_work);
+	if (kickit)
+		queue_work(workq, &skb_work);
 }
 
 /*
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 0aaaa0e..94a3b3c 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -716,6 +716,7 @@ enum c4iw_ep_flags {
 	ABORT_REQ_IN_PROGRESS	= 1,
 	RELEASE_RESOURCES	= 2,
 	CLOSE_SENT		= 3,
+	TIMEOUT                 = 4,
 	QP_REFERENCED           = 5,
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
