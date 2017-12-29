From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next v2] iw_cxgb4: Change error/warn prints to pr_debug
Date: Fri, 29 Dec 2017 13:11:14 +0530
Message-ID: <1514533274-23613-1-git-send-email-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These prints not neccesarily mean error/warning, so changing them to
debug.

changes since v1:
- Revert the pr_fmt changes.
- Few more prints changed from pr_warn() to pr_debug().

Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 17 ++++++++---------
 drivers/infiniband/hw/cxgb4/ev.c |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 21db3b48a617..4829c2783e94 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -257,8 +257,8 @@ static void set_emss(struct c4iw_ep *ep, u16 opt)
 	if (ep->emss < 128)
 		ep->emss = 128;
 	if (ep->emss & 7)
-		pr_warn("Warning: misaligned mtu idx %u mss %u emss=%u\n",
-			TCPOPT_MSS_G(opt), ep->mss, ep->emss);
+		pr_debug("Warning: misaligned mtu idx %u mss %u emss=%u\n",
+			 TCPOPT_MSS_G(opt), ep->mss, ep->emss);
 	pr_debug("mss_idx %u mss %u emss=%u\n", TCPOPT_MSS_G(opt), ep->mss,
 		 ep->emss);
 }
@@ -2733,9 +2733,8 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		return 0;
 
 	if (cxgb_is_neg_adv(req->status)) {
-		pr_warn("%s Negative advice on abort- tid %u status %d (%s)\n",
-			__func__, ep->hwtid, req->status,
-			neg_adv_str(req->status));
+		pr_debug("Negative advice on abort- tid %u status %d (%s)\n",
+			 ep->hwtid, req->status, neg_adv_str(req->status));
 		ep->stats.abort_neg_adv++;
 		mutex_lock(&dev->rdev.stats.lock);
 		dev->rdev.stats.neg_adv++;
@@ -3567,8 +3566,8 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	case MORIBUND:
 	case ABORTING:
 	case DEAD:
-		pr_info("%s ignoring disconnect ep %p state %u\n",
-			__func__, ep, ep->com.state);
+		pr_debug("ignoring disconnect ep %p state %u\n",
+			 ep, ep->com.state);
 		break;
 	default:
 		WARN_ONCE(1, "Bad endpoint state %u\n", ep->com.state);
@@ -4201,8 +4200,8 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 		return 0;
 	}
 	if (cxgb_is_neg_adv(req->status)) {
-		pr_warn("%s Negative advice on abort- tid %u status %d (%s)\n",
-			__func__, ep->hwtid, req->status,
+		pr_debug("Negative advice on abort- tid %u status %d (%s)\n",
+			 ep->hwtid, req->status,
 			 neg_adv_str(req->status));
 		goto out;
 	}
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index a252d5c40ae3..3e9d8b277ab9 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -236,7 +236,7 @@ int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
 		if (atomic_dec_and_test(&chp->refcnt))
 			wake_up(&chp->wait);
 	} else {
-		pr_warn("%s unknown cqid 0x%x\n", __func__, qid);
+		pr_debug("unknown cqid 0x%x\n", qid);
 		spin_unlock_irqrestore(&dev->lock, flag);
 	}
 	return 0;
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
