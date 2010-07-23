From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/4] RDMA/cxgb4: Use correct control txq.
Date: Fri, 23 Jul 2010 14:12:32 -0500
Message-ID: <20100723191232.15832.18267.stgit@build.ogc.int>
References: <20100723191221.15832.79704.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723191221.15832.79704.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is only one control txq per tx channel.  So use the port number
as the queue index when sending.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   13 +++++++++----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8d1f09b..6e480cd 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -473,7 +473,7 @@ static int send_connect(struct c4iw_ep *ep)
 		       __func__);
 		return -ENOMEM;
 	}
-	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->txq_idx);
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->ctrlq_idx);
 
 	cxgb4_best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx);
 	wscale = compute_wscale(rcv_win);
@@ -853,7 +853,7 @@ static int update_rx_credits(struct c4iw_ep *ep, u32 credits)
 	req->credit_dack = cpu_to_be32(credits | RX_FORCE_ACK(1) |
 				       F_RX_DACK_CHANGE |
 				       V_RX_DACK_MODE(dack_mode));
-	set_wr_txq(skb, CPL_PRIORITY_ACK, ep->txq_idx);
+	set_wr_txq(skb, CPL_PRIORITY_ACK, ep->ctrlq_idx);
 	c4iw_ofld_send(&ep->com.dev->rdev, skb);
 	return credits;
 }
@@ -1295,7 +1295,7 @@ static void accept_cr(struct c4iw_ep *ep, __be32 peer_ip, struct sk_buff *skb,
 				      ep->hwtid));
 	rpl->opt0 = cpu_to_be64(opt0);
 	rpl->opt2 = cpu_to_be32(opt2);
-	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->txq_idx);
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->ctrlq_idx);
 	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 
 	return;
@@ -1352,7 +1352,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	u16 rss_qid;
 	u32 mtu;
 	int step;
-	int txq_idx;
+	int txq_idx, ctrlq_idx;
 
 	parent_ep = lookup_stid(t, stid);
 	PDBG("%s parent ep %p tid %u\n", __func__, parent_ep, hwtid);
@@ -1384,6 +1384,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 		smac_idx = (cxgb4_port_viid(pdev) & 0x7F) << 1;
 		step = dev->rdev.lldi.ntxq / dev->rdev.lldi.nchan;
 		txq_idx = cxgb4_port_idx(pdev) * step;
+		ctrlq_idx = cxgb4_port_idx(pdev);
 		step = dev->rdev.lldi.nrxq / dev->rdev.lldi.nchan;
 		rss_qid = dev->rdev.lldi.rxq_ids[cxgb4_port_idx(pdev) * step];
 		dev_put(pdev);
@@ -1395,6 +1396,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 		smac_idx = (cxgb4_port_viid(dst->neighbour->dev) & 0x7F) << 1;
 		step = dev->rdev.lldi.ntxq / dev->rdev.lldi.nchan;
 		txq_idx = cxgb4_port_idx(dst->neighbour->dev) * step;
+		ctrlq_idx = cxgb4_port_idx(dst->neighbour->dev);
 		step = dev->rdev.lldi.nrxq / dev->rdev.lldi.nchan;
 		rss_qid = dev->rdev.lldi.rxq_ids[
 			  cxgb4_port_idx(dst->neighbour->dev) * step];
@@ -1434,6 +1436,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	child_ep->rss_qid = rss_qid;
 	child_ep->mtu = mtu;
 	child_ep->txq_idx = txq_idx;
+	child_ep->ctrlq_idx = ctrlq_idx;
 
 	PDBG("%s tx_chan %u smac_idx %u rss_qid %u\n", __func__,
 	     tx_chan, smac_idx, rss_qid);
@@ -1965,6 +1968,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		ep->txq_idx = cxgb4_port_idx(pdev) * step;
 		step = ep->com.dev->rdev.lldi.nrxq /
 		       ep->com.dev->rdev.lldi.nchan;
+		ep->ctrlq_idx = cxgb4_port_idx(pdev);
 		ep->rss_qid = ep->com.dev->rdev.lldi.rxq_ids[
 			      cxgb4_port_idx(pdev) * step];
 		dev_put(pdev);
@@ -1979,6 +1983,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		step = ep->com.dev->rdev.lldi.ntxq /
 		       ep->com.dev->rdev.lldi.nchan;
 		ep->txq_idx = cxgb4_port_idx(ep->dst->neighbour->dev) * step;
+		ep->ctrlq_idx = cxgb4_port_idx(ep->dst->neighbour->dev);
 		step = ep->com.dev->rdev.lldi.nrxq /
 		       ep->com.dev->rdev.lldi.nchan;
 		ep->rss_qid = ep->com.dev->rdev.lldi.rxq_ids[
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 277ab58..bda0af7 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -619,6 +619,7 @@ struct c4iw_ep {
 	u16 plen;
 	u16 rss_qid;
 	u16 txq_idx;
+	u16 ctrlq_idx;
 	u8 tos;
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
