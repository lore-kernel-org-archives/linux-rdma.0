From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/7] RDMA/cxgb4: process ep timeouts in safe context.
Date: Thu, 06 May 2010 18:06:30 -0500
Message-ID: <20100506230630.25362.85417.stgit@build.ogc.int>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230619.25362.97591.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: root <root-m5ktC/4JIOOIE2W2IvP7LA@public.gmane.org>

Schedule the workq handler to process timed out endpoints rather than
try and process them on the timeout interrupt.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |  112 +++++++++++++++++++++-----------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 
 2 files changed, 73 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 85418f3..d146639 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -125,6 +125,9 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp);
 static void ep_timeout(unsigned long arg);
 static void connect_reply_upcall(struct c4iw_ep *ep, int status);
 
+static LIST_HEAD(timeout_list);
+static spinlock_t timeout_lock;
+
 static void start_ep_timer(struct c4iw_ep *ep)
 {
 	PDBG("%s ep %p\n", __func__, ep);
@@ -1775,46 +1778,6 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 	return 0;
 }
 
-static void ep_timeout(unsigned long arg)
-{
-	struct c4iw_ep *ep = (struct c4iw_ep *)arg;
-	struct c4iw_qp_attributes attrs;
-	unsigned long flags;
-	int abort = 1;
-
-	spin_lock_irqsave(&ep->com.lock, flags);
-	PDBG("%s ep %p tid %u state %d\n", __func__, ep, ep->hwtid,
-	     ep->com.state);
-	switch (ep->com.state) {
-	case MPA_REQ_SENT:
-		__state_set(&ep->com, ABORTING);
-		connect_reply_upcall(ep, -ETIMEDOUT);
-		break;
-	case MPA_REQ_WAIT:
-		__state_set(&ep->com, ABORTING);
-		break;
-	case CLOSING:
-	case MORIBUND:
-		if (ep->com.cm_id && ep->com.qp) {
-			attrs.next_state = C4IW_QP_STATE_ERROR;
-			c4iw_modify_qp(ep->com.qp->rhp,
-				     ep->com.qp, C4IW_QP_ATTR_NEXT_STATE,
-				     &attrs, 1);
-		}
-		__state_set(&ep->com, ABORTING);
-		break;
-	default:
-		printk(KERN_ERR "%s unexpected state ep %p tid %u state %u\n",
-			__func__, ep, ep->hwtid, ep->com.state);
-		WARN_ON(1);
-		abort = 0;
-	}
-	spin_unlock_irqrestore(&ep->com.lock, flags);
-	if (abort)
-		abort_connection(ep, NULL, GFP_ATOMIC);
-	c4iw_put_ep(&ep->com);
-}
-
 int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 {
 	int err;
@@ -2219,6 +2182,62 @@ static c4iw_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_FW4_ACK] = fw4_ack
 };
 
+static void process_timeout(struct c4iw_ep *ep)
+{
+	struct c4iw_qp_attributes attrs;
+	int abort = 1;
+
+	spin_lock_irq(&ep->com.lock);
+	PDBG("%s ep %p tid %u state %d\n", __func__, ep, ep->hwtid,
+	     ep->com.state);
+	switch (ep->com.state) {
+	case MPA_REQ_SENT:
+		__state_set(&ep->com, ABORTING);
+		connect_reply_upcall(ep, -ETIMEDOUT);
+		break;
+	case MPA_REQ_WAIT:
+		__state_set(&ep->com, ABORTING);
+		break;
+	case CLOSING:
+	case MORIBUND:
+		if (ep->com.cm_id && ep->com.qp) {
+			attrs.next_state = C4IW_QP_STATE_ERROR;
+			c4iw_modify_qp(ep->com.qp->rhp,
+				     ep->com.qp, C4IW_QP_ATTR_NEXT_STATE,
+				     &attrs, 1);
+		}
+		__state_set(&ep->com, ABORTING);
+		break;
+	default:
+		printk(KERN_ERR "%s unexpected state ep %p tid %u state %u\n",
+			__func__, ep, ep->hwtid, ep->com.state);
+		WARN_ON(1);
+		abort = 0;
+	}
+	spin_unlock_irq(&ep->com.lock);
+	if (abort)
+		abort_connection(ep, NULL, GFP_KERNEL);
+	c4iw_put_ep(&ep->com);
+}
+
+static void process_timedout_eps(void)
+{
+	struct c4iw_ep *ep;
+
+	spin_lock_irq(&timeout_lock);
+	while (!list_empty(&timeout_list)) {
+		struct list_head *tmp;
+
+		tmp = timeout_list.next;
+		list_del(tmp);
+		spin_unlock_irq(&timeout_lock);
+		ep = list_entry(tmp, struct c4iw_ep, entry);
+		process_timeout(ep);
+		spin_lock_irq(&timeout_lock);
+	}
+	spin_unlock_irq(&timeout_lock);
+}
+
 static void process_work(struct work_struct *work)
 {
 	struct sk_buff *skb = NULL;
@@ -2237,10 +2256,21 @@ static void process_work(struct work_struct *work)
 		if (!ret)
 			kfree_skb(skb);
 	}
+	process_timedout_eps();
 }
 
 static DECLARE_WORK(skb_work, process_work);
 
+static void ep_timeout(unsigned long arg)
+{
+	struct c4iw_ep *ep = (struct c4iw_ep *)arg;
+
+	spin_lock(&timeout_lock);
+	list_add_tail(&ep->entry, &timeout_list);
+	spin_unlock(&timeout_lock);
+	queue_work(workq, &skb_work);
+}
+
 /*
  * All the CM events are handled on a work queue to have a safe context.
  */
@@ -2326,6 +2356,7 @@ c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS] = {
 
 int __init c4iw_cm_init(void)
 {
+	spin_lock_init(&timeout_lock);
 	skb_queue_head_init(&rxq);
 
 	workq = create_singlethread_workqueue("iw_cxgb4");
@@ -2337,6 +2368,7 @@ int __init c4iw_cm_init(void)
 
 void __exit c4iw_cm_term(void)
 {
+	WARN_ON(!list_empty(&timeout_list));
 	flush_workqueue(workq);
 	destroy_workqueue(workq);
 }
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index c3ea5a2..a626998 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -597,6 +597,7 @@ struct c4iw_ep {
 	struct c4iw_ep_common com;
 	struct c4iw_ep *parent_ep;
 	struct timer_list timer;
+	struct list_head entry;
 	unsigned int atid;
 	u32 hwtid;
 	u32 snd_seq;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
