From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: Don't post zero-byte read if endpoint is going
	away.
Date: Fri, 13 May 2011 13:37:18 -0500
Message-ID: <20110513183718.32131.81315.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

tx_ack() wasn't checking the endpoint state and consequently would
attempt to post the p2p 0B read on an endpoint/qp that is closing
or aborting.  This causes a null ptr dereference crash.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c       |   26 +++++++++++++++++---------
 drivers/infiniband/hw/cxgb3/iwch_provider.h |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |    6 +++---
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 3216bca..ad998c0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -913,7 +913,7 @@ static void process_mpa_reply(struct iwch_ep *ep, struct sk_buff *skb)
 		goto err;
 
 	if (peer2peer && iwch_rqes_posted(ep->com.qp) == 0) {
-		iwch_post_zb_read(ep->com.qp);
+		iwch_post_zb_read(ep);
 	}
 
 	goto out;
@@ -1077,6 +1077,8 @@ static int tx_ack(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	struct iwch_ep *ep = ctx;
 	struct cpl_wr_ack *hdr = cplhdr(skb);
 	unsigned int credits = ntohs(hdr->credits);
+	unsigned long flags;
+	int post_zb = 0;
 
 	PDBG("%s ep %p credits %u\n", __func__, ep, credits);
 
@@ -1086,28 +1088,34 @@ static int tx_ack(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		return CPL_RET_BUF_DONE;
 	}
 
+	spin_lock_irqsave(&ep->com.lock, flags);
 	BUG_ON(credits != 1);
 	dst_confirm(ep->dst);
 	if (!ep->mpa_skb) {
 		PDBG("%s rdma_init wr_ack ep %p state %u\n",
-			__func__, ep, state_read(&ep->com));
+			__func__, ep, ep->com.state);
 		if (ep->mpa_attr.initiator) {
 			PDBG("%s initiator ep %p state %u\n",
-				__func__, ep, state_read(&ep->com));
-			if (peer2peer)
-				iwch_post_zb_read(ep->com.qp);
+				__func__, ep, ep->com.state);
+			if (peer2peer && ep->com.state == FPDU_MODE)
+				post_zb = 1;
 		} else {
 			PDBG("%s responder ep %p state %u\n",
-				__func__, ep, state_read(&ep->com));
-			ep->com.rpl_done = 1;
-			wake_up(&ep->com.waitq);
+				__func__, ep, ep->com.state);
+			if (ep->com.state == MPA_REQ_RCVD) {
+				ep->com.rpl_done = 1;
+				wake_up(&ep->com.waitq);
+			}
 		}
 	} else {
 		PDBG("%s lsm ack ep %p state %u freeing skb\n",
-			__func__, ep, state_read(&ep->com));
+			__func__, ep, ep->com.state);
 		kfree_skb(ep->mpa_skb);
 		ep->mpa_skb = NULL;
 	}
+	spin_unlock_irqrestore(&ep->com.lock, flags);
+	if (post_zb)
+		iwch_post_zb_read(ep);
 	return CPL_RET_BUF_DONE;
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index c5406da..9a342c9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -332,7 +332,7 @@ int iwch_bind_mw(struct ib_qp *qp,
 			     struct ib_mw_bind *mw_bind);
 int iwch_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int iwch_post_terminate(struct iwch_qp *qhp, struct respQ_msg_t *rsp_msg);
-int iwch_post_zb_read(struct iwch_qp *qhp);
+int iwch_post_zb_read(struct iwch_ep *ep);
 int iwch_register_device(struct iwch_dev *dev);
 void iwch_unregister_device(struct iwch_dev *dev);
 void stop_read_rep_timer(struct iwch_qp *qhp);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 1b4cd09..ecd313f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -738,7 +738,7 @@ static inline void build_term_codes(struct respQ_msg_t *rsp_msg,
 	}
 }
 
-int iwch_post_zb_read(struct iwch_qp *qhp)
+int iwch_post_zb_read(struct iwch_ep *ep)
 {
 	union t3_wr *wqe;
 	struct sk_buff *skb;
@@ -761,10 +761,10 @@ int iwch_post_zb_read(struct iwch_qp *qhp)
 	wqe->read.local_len = cpu_to_be32(0);
 	wqe->read.local_to = cpu_to_be64(1);
 	wqe->send.wrh.op_seop_flags = cpu_to_be32(V_FW_RIWR_OP(T3_WR_READ));
-	wqe->send.wrh.gen_tid_len = cpu_to_be32(V_FW_RIWR_TID(qhp->ep->hwtid)|
+	wqe->send.wrh.gen_tid_len = cpu_to_be32(V_FW_RIWR_TID(ep->hwtid)|
 						V_FW_RIWR_LEN(flit_cnt));
 	skb->priority = CPL_PRIORITY_DATA;
-	return iwch_cxgb3_ofld_send(qhp->rhp->rdev.t3cdev_p, skb);
+	return iwch_cxgb3_ofld_send(ep->com.qp->rhp->rdev.t3cdev_p, skb);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
