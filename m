From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: Don't change QP state outside EP lock.
Date: Thu, 31 Mar 2011 11:14:19 -0500
Message-ID: <20110331161418.4653.90690.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Concurrent ingress CLOSE and ULP ABORT operations causes a crash due
to a race condition where the close path releases the EP lock and then
tries to move the QP state to CLOSED.  This must be done inside the EP
lock to avoid the race.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   16 +++++++---------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    4 ++--
 drivers/infiniband/hw/cxgb4/qp.c       |    1 -
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 9d8dcfa..d235810 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1466,7 +1466,7 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_qp_attributes attrs;
 	int disconnect = 1;
 	int release = 0;
-	int closing = 0;
+	int abort = 0;
 	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int tid = GET_TID(hdr);
 
@@ -1507,8 +1507,11 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 	case FPDU_MODE:
 		start_ep_timer(ep);
 		__state_set(&ep->com, CLOSING);
-		closing = 1;
+		attrs.next_state = C4IW_QP_STATE_CLOSING;
+		abort = c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
+				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
 		peer_close_upcall(ep);
+		disconnect = 1;
 		break;
 	case ABORTING:
 		disconnect = 0;
@@ -1536,11 +1539,6 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		BUG_ON(1);
 	}
 	mutex_unlock(&ep->com.mutex);
-	if (closing) {
-		attrs.next_state = C4IW_QP_STATE_CLOSING;
-		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
-			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
-	}
 	if (disconnect)
 		c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
 	if (release)
@@ -1710,14 +1708,14 @@ static int terminate(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = lookup_tid(t, tid);
 	BUG_ON(!ep);
 
-	if (ep->com.qp) {
+	if (ep && ep->com.qp) {
 		printk(KERN_WARNING MOD "TERM received tid %u qpid %u\n", tid,
 		       ep->com.qp->wq.sq.qid);
 		attrs.next_state = C4IW_QP_STATE_TERMINATE;
 		c4iw_modify_qp(ep->com.qp->rhp, ep->com.qp,
 			       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
 	} else
-		printk(KERN_WARNING MOD "TERM received tid %u no qp\n", tid);
+		printk(KERN_WARNING MOD "TERM received tid %u no ep/qp\n", tid);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 9f6166f..8e16eb2 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -161,8 +161,8 @@ static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
 		}
 	} while (!wr_waitp->done);
 	if (wr_waitp->ret)
-		printk(KERN_WARNING MOD "%s: FW reply %d tid %u qpid %u\n",
-		       pci_name(rdev->lldi.pdev), wr_waitp->ret, hwtid, qpid);
+		PDBG("%s: FW reply %d tid %u qpid %u\n",
+		     pci_name(rdev->lldi.pdev), wr_waitp->ret, hwtid, qpid);
 	return wr_waitp->ret;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 70a5a3c..a1824a5 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1210,7 +1210,6 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 			if (ret) {
 				if (internal)
 					c4iw_get_ep(&qhp->ep->com);
-				disconnect = abort = 1;
 				goto err;
 			}
 			break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
