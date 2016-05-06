From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 10/17] RDMA/iw_cxgb4: atomically lookup ep and get a reference
Date: Fri,  6 May 2016 22:18:03 +0530
Message-ID: <1462553290-16422-11-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a race between ULP threads calling c4iw_ep_disconnect() via
c4iw_modify_rc_qp() and the ingress CPL thread where the ULP thread
can free the endpoint just after the ingress CPL thread finds the ep
pointer in the tid table.  To avoid this, we now use the hwtid_idr table
for lookups instead of the LLD tid table so we can lock around insert,
remove, and lookup+get_ep to avoid the race.  The CPL handlers now will
either find the ep ptr and have a ref on it, or not find it and they
can discard the CPL.  Callers of get_ep_from_tid() will have a ref
on the ep if found, and thus must deref when they are done.
Negative advice in peer_abort_intr() need to dereference the ep.
therefore peer_abort() is scheduled to dereference the ep later.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 110 +++++++++++++++++++++++++++++----------
 1 file changed, 82 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 6129dbd0dc9e..c247812fd38c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -308,6 +308,40 @@ static void *alloc_ep(int size, gfp_t gfp)
 	return epc;
 }
 
+static void remove_ep_tid(struct c4iw_ep *ep)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ep->com.dev->lock, flags);
+	_remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid, 0);
+	spin_unlock_irqrestore(&ep->com.dev->lock, flags);
+}
+
+static void insert_ep_tid(struct c4iw_ep *ep)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ep->com.dev->lock, flags);
+	_insert_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep, ep->hwtid, 0);
+	spin_unlock_irqrestore(&ep->com.dev->lock, flags);
+}
+
+/*
+ * Atomically lookup the ep ptr given the tid and grab a reference on the ep.
+ */
+static struct c4iw_ep *get_ep_from_tid(struct c4iw_dev *dev, unsigned int tid)
+{
+	struct c4iw_ep *ep;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	ep = idr_find(&dev->hwtid_idr, tid);
+	if (ep)
+		c4iw_get_ep(&ep->com);
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ep;
+}
+
 void _c4iw_free_ep(struct kref *kref)
 {
 	struct c4iw_ep *ep;
@@ -327,7 +361,6 @@ void _c4iw_free_ep(struct kref *kref)
 					(const u32 *)&sin6->sin6_addr.s6_addr,
 					1);
 		}
-		remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid);
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, ep->hwtid);
 		dst_release(ep->dst);
 		cxgb4_l2t_release(ep->l2t);
@@ -338,6 +371,15 @@ void _c4iw_free_ep(struct kref *kref)
 static void release_ep_resources(struct c4iw_ep *ep)
 {
 	set_bit(RELEASE_RESOURCES, &ep->com.flags);
+
+	/*
+	 * If we have a hwtid, then remove it from the idr table
+	 * so lookups will no longer find this endpoint.  Otherwise
+	 * we have a race where one thread finds the ep ptr just
+	 * before the other thread is freeing the ep memory.
+	 */
+	if (ep->hwtid != -1)
+		remove_ep_tid(ep);
 	c4iw_put_ep(&ep->com);
 }
 
@@ -1167,7 +1209,7 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	/* setup the hwtid for this connection */
 	ep->hwtid = tid;
 	cxgb4_insert_tid(t, ep, tid);
-	insert_handle(dev, &dev->hwtid_idr, ep, ep->hwtid);
+	insert_ep_tid(ep);
 
 	ep->snd_seq = be32_to_cpu(req->snd_isn);
 	ep->rcv_seq = be32_to_cpu(req->rcv_isn);
@@ -1782,11 +1824,10 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct cpl_rx_data *hdr = cplhdr(skb);
 	unsigned int dlen = ntohs(hdr->len);
 	unsigned int tid = GET_TID(hdr);
-	struct tid_info *t = dev->rdev.lldi.tids;
 	__u8 status = hdr->status;
 	int disconnect = 0;
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
 	if (!ep)
 		return 0;
 	PDBG("%s ep %p tid %u dlen %u\n", __func__, ep, ep->hwtid, dlen);
@@ -1826,6 +1867,7 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 	mutex_unlock(&ep->com.mutex);
 	if (disconnect)
 		c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
@@ -1835,9 +1877,8 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct cpl_abort_rpl_rss *rpl = cplhdr(skb);
 	int release = 0;
 	unsigned int tid = GET_TID(rpl);
-	struct tid_info *t = dev->rdev.lldi.tids;
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
 	if (!ep) {
 		printk(KERN_WARNING MOD "Abort rpl to freed endpoint\n");
 		return 0;
@@ -1859,6 +1900,7 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	if (release)
 		release_ep_resources(ep);
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
@@ -2559,7 +2601,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	init_timer(&child_ep->timer);
 	cxgb4_insert_tid(t, child_ep, hwtid);
-	insert_handle(dev, &dev->hwtid_idr, child_ep, child_ep->hwtid);
+	insert_ep_tid(child_ep);
 	if (accept_cr(child_ep, skb, req)) {
 		c4iw_put_ep(&parent_ep->com);
 		release_ep_resources(child_ep);
@@ -2582,11 +2624,10 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 {
 	struct c4iw_ep *ep;
 	struct cpl_pass_establish *req = cplhdr(skb);
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(req);
 	int ret;
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	ep->snd_seq = be32_to_cpu(req->snd_isn);
 	ep->rcv_seq = be32_to_cpu(req->rcv_isn);
@@ -2605,6 +2646,7 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	mutex_unlock(&ep->com.mutex);
 	if (ret)
 		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
+	c4iw_put_ep(&ep->com);
 
 	return 0;
 }
@@ -2616,11 +2658,13 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_qp_attributes attrs;
 	int disconnect = 1;
 	int release = 0;
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(hdr);
 	int ret;
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
+
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	dst_confirm(ep->dst);
 
@@ -2692,6 +2736,7 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
 	if (release)
 		release_ep_resources(ep);
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
@@ -2704,10 +2749,12 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_qp_attributes attrs;
 	int ret;
 	int release = 0;
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(req);
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
+
 	if (is_neg_adv(req->status)) {
 		PDBG("%s Negative advice on abort- tid %u status %d (%s)\n",
 		     __func__, ep->hwtid, req->status,
@@ -2716,7 +2763,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		mutex_lock(&dev->rdev.stats.lock);
 		dev->rdev.stats.neg_adv++;
 		mutex_unlock(&dev->rdev.stats.lock);
-		return 0;
+		goto deref_ep;
 	}
 	PDBG("%s ep %p tid %u state %u\n", __func__, ep, ep->hwtid,
 	     ep->com.state);
@@ -2782,7 +2829,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	case DEAD:
 		PDBG("%s PEER_ABORT IN DEAD STATE!!!!\n", __func__);
 		mutex_unlock(&ep->com.mutex);
-		return 0;
+		goto deref_ep;
 	default:
 		BUG_ON(1);
 		break;
@@ -2829,6 +2876,10 @@ out:
 		c4iw_reconnect(ep);
 	}
 
+deref_ep:
+	c4iw_put_ep(&ep->com);
+	/* Dereferencing ep, referenced in peer_abort_intr() */
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
@@ -2838,10 +2889,11 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_qp_attributes attrs;
 	struct cpl_close_con_rpl *rpl = cplhdr(skb);
 	int release = 0;
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(rpl);
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
 
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	BUG_ON(!ep);
@@ -2876,18 +2928,18 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	mutex_unlock(&ep->com.mutex);
 	if (release)
 		release_ep_resources(ep);
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
 static int terminate(struct c4iw_dev *dev, struct sk_buff *skb)
 {
 	struct cpl_rdma_terminate *rpl = cplhdr(skb);
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(rpl);
 	struct c4iw_ep *ep;
 	struct c4iw_qp_attributes attrs;
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
 	BUG_ON(!ep);
 
 	if (ep && ep->com.qp) {
@@ -2898,6 +2950,7 @@ static int terminate(struct c4iw_dev *dev, struct sk_buff *skb)
 			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
 	} else
 		printk(KERN_WARNING MOD "TERM received tid %u no ep/qp\n", tid);
+	c4iw_put_ep(&ep->com);
 
 	return 0;
 }
@@ -2913,15 +2966,16 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct cpl_fw4_ack *hdr = cplhdr(skb);
 	u8 credits = hdr->credits;
 	unsigned int tid = GET_TID(hdr);
-	struct tid_info *t = dev->rdev.lldi.tids;
 
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
 	PDBG("%s ep %p tid %u credits %u\n", __func__, ep, ep->hwtid, credits);
 	if (credits == 0) {
 		PDBG("%s 0 credit ack ep %p tid %u state %u\n",
 		     __func__, ep, ep->hwtid, state_read(&ep->com));
-		return 0;
+		goto out;
 	}
 
 	dst_confirm(ep->dst);
@@ -2936,6 +2990,8 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 			stop_ep_timer(ep);
 		mutex_unlock(&ep->com.mutex);
 	}
+out:
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
@@ -4142,10 +4198,10 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 {
 	struct cpl_abort_req_rss *req = cplhdr(skb);
 	struct c4iw_ep *ep;
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(req);
 
-	ep = lookup_tid(t, tid);
+	ep = get_ep_from_tid(dev, tid);
+	/* This EP will be dereferenced in peer_abort() */
 	if (!ep) {
 		printk(KERN_WARNING MOD
 		       "Abort on non-existent endpoint, tid %d\n", tid);
@@ -4156,10 +4212,7 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 		PDBG("%s Negative advice on abort- tid %u status %d (%s)\n",
 		     __func__, ep->hwtid, req->status,
 		     neg_adv_str(req->status));
-		ep->stats.abort_neg_adv++;
-		dev->rdev.stats.neg_adv++;
-		kfree_skb(skb);
-		return 0;
+		goto out;
 	}
 	PDBG("%s ep %p tid %u state %u\n", __func__, ep, ep->hwtid,
 	     ep->com.state);
@@ -4174,6 +4227,7 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 			c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 	} else
 		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+out:
 	sched(dev, skb);
 	return 0;
 }
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
