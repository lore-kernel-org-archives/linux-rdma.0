From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] RDMA/nes: Fix for unlinking skbs from empty list
Date: Fri, 2 Nov 2012 18:17:45 -0500
Message-ID: <20121102231744.GA4028@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for unlinking skbs from empty list

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_mgt.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 8cf74fd..2d710e1 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -210,6 +210,9 @@ static struct sk_buff *nes_get_next_skb(struct nes_device *nesdev, struct nes_qp
 	}
 
 	while (1) {
+		if (skb_queue_empty(&nesqp->pau_list))
+			goto out;
+
 		seq = nes_get_seq(skb, ack, wnd, fin_rcvd, rst_rcvd);
 		if (seq == nextseq) {
 			if (skb->len || processacks)
@@ -218,14 +221,13 @@ static struct sk_buff *nes_get_next_skb(struct nes_device *nesdev, struct nes_qp
 			goto out;
 		}
 
-		if (skb->next == (struct sk_buff *)&nesqp->pau_list)
-			goto out;
-
 		old_skb = skb;
 		skb = skb->next;
 		skb_unlink(old_skb, &nesqp->pau_list);
 		nes_mgt_free_skb(nesdev, old_skb, PCI_DMA_TODEVICE);
 		nes_rem_ref_cm_node(nesqp->cm_node);
+		if (skb == (struct sk_buff *)&nesqp->pau_list)
+			goto out;
 	}
 	return skb;
 
@@ -384,7 +386,8 @@ static int get_fpdu_info(struct nes_device *nesdev, struct nes_qp *nesqp,
 		if (frags[i].skb->len == 0) {
 			/* Pull skb off the list - it will be freed in the callback */
 			spin_lock_irqsave(&nesqp->pau_lock, flags);
-			skb_unlink(frags[i].skb, &nesqp->pau_list);
+			if (!skb_queue_empty(&nesqp->pau_list))
+				skb_unlink(frags[i].skb, &nesqp->pau_list);
 			spin_unlock_irqrestore(&nesqp->pau_lock, flags);
 		} else {
 			/* Last skb still has data so update the seq */
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
