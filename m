From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.1] iw_cxgb4: Remove negative advice dmesg warnings
Date: Tue,  5 May 2015 03:55:24 +0530
Message-ID: <1430778324-17389-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove these log messages in favor of per-endpoint counters as well as
device-global counters that can be inspected via debugfs.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       | 27 ++++++++++++++++++---------
 drivers/infiniband/hw/cxgb4/device.c   |  7 +++++++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  7 +++++++
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3c3b00e..bb95a6c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2058,9 +2058,12 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	     status, status2errno(status));
 
 	if (is_neg_adv(status)) {
-		dev_warn(&dev->rdev.lldi.pdev->dev,
-			 "Connection problems for atid %u status %u (%s)\n",
-			 atid, status, neg_adv_str(status));
+		PDBG("%s Connection problems for atid %u status %u (%s)\n",
+		     __func__, atid, status, neg_adv_str(status));
+		ep->stats.connect_neg_adv++;
+		mutex_lock(&dev->rdev.stats.lock);
+		dev->rdev.stats.neg_adv++;
+		mutex_unlock(&dev->rdev.stats.lock);
 		return 0;
 	}
 
@@ -2566,9 +2569,13 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	ep = lookup_tid(t, tid);
 	if (is_neg_adv(req->status)) {
-		dev_warn(&dev->rdev.lldi.pdev->dev,
-			 "Negative advice on abort - tid %u status %d (%s)\n",
-			 ep->hwtid, req->status, neg_adv_str(req->status));
+		PDBG("%s Negative advice on abort- tid %u status %d (%s)\n",
+		     __func__, ep->hwtid, req->status,
+		     neg_adv_str(req->status));
+		ep->stats.abort_neg_adv++;
+		mutex_lock(&dev->rdev.stats.lock);
+		dev->rdev.stats.neg_adv++;
+		mutex_unlock(&dev->rdev.stats.lock);
 		return 0;
 	}
 	PDBG("%s ep %p tid %u state %u\n", __func__, ep, ep->hwtid,
@@ -3977,9 +3984,11 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 		return 0;
 	}
 	if (is_neg_adv(req->status)) {
-		dev_warn(&dev->rdev.lldi.pdev->dev,
-			 "Negative advice on abort - tid %u status %d (%s)\n",
-			 ep->hwtid, req->status, neg_adv_str(req->status));
+		PDBG("%s Negative advice on abort- tid %u status %d (%s)\n",
+		     __func__, ep->hwtid, req->status,
+		     neg_adv_str(req->status));
+		ep->stats.abort_neg_adv++;
+		dev->rdev.stats.neg_adv++;
 		kfree_skb(skb);
 		return 0;
 	}
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 1ffbd03..cf54d69 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -490,6 +490,7 @@ static int stats_show(struct seq_file *seq, void *v)
 		   dev->rdev.stats.act_ofld_conn_fails);
 	seq_printf(seq, "PAS_OFLD_CONN_FAILS: %10llu\n",
 		   dev->rdev.stats.pas_ofld_conn_fails);
+	seq_printf(seq, "NEG_ADV_RCVD: %10llu\n", dev->rdev.stats.neg_adv);
 	seq_printf(seq, "AVAILABLE IRD: %10u\n", dev->avail_ird);
 	return 0;
 }
@@ -561,10 +562,13 @@ static int dump_ep(int id, void *p, void *data)
 		cc = snprintf(epd->buf + epd->pos, space,
 			      "ep %p cm_id %p qp %p state %d flags 0x%lx "
 			      "history 0x%lx hwtid %d atid %d "
+			      "conn_na %u abort_na %u "
 			      "%pI4:%d/%d <-> %pI4:%d/%d\n",
 			      ep, ep->com.cm_id, ep->com.qp,
 			      (int)ep->com.state, ep->com.flags,
 			      ep->com.history, ep->hwtid, ep->atid,
+			      ep->stats.connect_neg_adv,
+			      ep->stats.abort_neg_adv,
 			      &lsin->sin_addr, ntohs(lsin->sin_port),
 			      ntohs(mapped_lsin->sin_port),
 			      &rsin->sin_addr, ntohs(rsin->sin_port),
@@ -582,10 +586,13 @@ static int dump_ep(int id, void *p, void *data)
 		cc = snprintf(epd->buf + epd->pos, space,
 			      "ep %p cm_id %p qp %p state %d flags 0x%lx "
 			      "history 0x%lx hwtid %d atid %d "
+			      "conn_na %u abort_na %u "
 			      "%pI6:%d/%d <-> %pI6:%d/%d\n",
 			      ep, ep->com.cm_id, ep->com.qp,
 			      (int)ep->com.state, ep->com.flags,
 			      ep->com.history, ep->hwtid, ep->atid,
+			      ep->stats.connect_neg_adv,
+			      ep->stats.abort_neg_adv,
 			      &lsin6->sin6_addr, ntohs(lsin6->sin6_port),
 			      ntohs(mapped_lsin6->sin6_port),
 			      &rsin6->sin6_addr, ntohs(rsin6->sin6_port),
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index d87e165..97bb555 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -137,6 +137,7 @@ struct c4iw_stats {
 	u64  tcam_full;
 	u64  act_ofld_conn_fails;
 	u64  pas_ofld_conn_fails;
+	u64  neg_adv;
 };
 
 struct c4iw_hw_queue {
@@ -814,6 +815,11 @@ struct c4iw_listen_ep {
 	int backlog;
 };
 
+struct c4iw_ep_stats {
+	unsigned connect_neg_adv;
+	unsigned abort_neg_adv;
+};
+
 struct c4iw_ep {
 	struct c4iw_ep_common com;
 	struct c4iw_ep *parent_ep;
@@ -846,6 +852,7 @@ struct c4iw_ep {
 	unsigned int retry_count;
 	int snd_win;
 	int rcv_win;
+	struct c4iw_ep_stats stats;
 };
 
 static inline void print_addr(struct c4iw_ep_common *epc, const char *func,
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
