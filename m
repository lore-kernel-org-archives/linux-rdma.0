From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-RC] IB/cm: Fix rb-tree duplicate free and use-after-free
Date: Sun, 11 Oct 2015 15:58:17 +0300
Message-ID: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ib_send_cm_sidr_rep could sometimes erase the node from the sidr
(depending on errors in the process). Since ib_send_cm_sidr_rep is
called both from cm_sidr_req_handler and cm_destroy_id, cm_id_priv
could be either erased from the rb_tree twice or not erased at all.
Fixing that by making sure it's erased only once before freeing
cm_id_priv.

Fixes: a977049dacde ('[PATCH] IB: Add the kernel CM implementation')
Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Doug,
This patch fixes a bug in the CM. In some flow, rb-tree could be
freed twice or used after it was freed. This bug was picked by
our regression tests and this fix was verified.

Thanks,
Doron and Matan

 drivers/infiniband/core/cm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index f5cf1c4..56ff0f3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -844,6 +844,11 @@ retest:
 	case IB_CM_SIDR_REQ_RCVD:
 		spin_unlock_irq(&cm_id_priv->lock);
 		cm_reject_sidr_req(cm_id_priv, IB_SIDR_REJECT);
+		spin_lock_irq(&cm.lock);
+		if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node))
+			rb_erase(&cm_id_priv->sidr_id_node,
+				 &cm.remote_sidr_table);
+		spin_unlock_irq(&cm.lock);
 		break;
 	case IB_CM_REQ_SENT:
 	case IB_CM_MRA_REQ_RCVD:
@@ -3210,7 +3215,10 @@ int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id,
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 
 	spin_lock_irqsave(&cm.lock, flags);
-	rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
+	if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
+		rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
+		RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
+	}
 	spin_unlock_irqrestore(&cm.lock, flags);
 	return 0;
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
