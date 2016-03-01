From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/10] IB/ipoib: Allow mcast packets from other VFs
Date: Tue,  1 Mar 2016 18:52:22 +0200
Message-ID: <1456851143-138332-10-git-send-email-eli@mellanox.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456851143-138332-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With SRIOV enabled, two VFs on the same HCA which have the same port LID
and may have the same QP number. To enable receiving multicasts from
such VFs, further qualify the check: ignore the receive only if, in
addition, the packet source gid equals the receiving VF's source gid.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index fa9c42ff1fb0..e0b953cdab50 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -180,6 +180,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	struct sk_buff *skb;
 	u64 mapping[IPOIB_UD_RX_SG];
 	union ib_gid *dgid;
+	union ib_gid *sgid;
 
 	ipoib_dbg_data(priv, "recv completion: id %d, status: %d\n",
 		       wr_id, wc->status);
@@ -203,13 +204,6 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		return;
 	}
 
-	/*
-	 * Drop packets that this interface sent, ie multicast packets
-	 * that the HCA has replicated.
-	 */
-	if (wc->slid == priv->local_lid && wc->src_qp == priv->qp->qp_num)
-		goto repost;
-
 	memcpy(mapping, priv->rx_ring[wr_id].mapping,
 	       IPOIB_UD_RX_SG * sizeof *mapping);
 
@@ -239,6 +233,27 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	else
 		skb->pkt_type = PACKET_MULTICAST;
 
+	sgid = &((struct ib_grh *)skb->data)->sgid;
+
+	/*
+	 * Drop packets that this interface sent, ie multicast packets
+	 * that the HCA has replicated.
+	 */
+	if (wc->slid == priv->local_lid && wc->src_qp == priv->qp->qp_num) {
+		int need_repost = 1;
+
+		if ((wc->wc_flags & IB_WC_GRH) &&
+		    memcmp(&sgid->global.interface_id,
+			   &priv->local_gid.global.interface_id,
+			   sizeof(sgid->global.interface_id)))
+			need_repost = 0;
+
+		if (need_repost) {
+			dev_kfree_skb_any(skb);
+			goto repost;
+		}
+	}
+
 	skb_pull(skb, IB_GRH_BYTES);
 
 	skb->protocol = ((struct ipoib_header *) skb->data)->proto;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
