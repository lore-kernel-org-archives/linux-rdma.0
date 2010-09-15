From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch] infiniband: nes_cm: remove unneeded variable
Date: Wed, 15 Sep 2010 18:32:39 +0200
Message-ID: <20100915160726.GA5854@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Just a small cleanup.  The "passive_state" variable isn't used any more
after: dae58728dc "RDMA/nes: Fix double CLOSE event indication crash"

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 61e0efd..5c8d34c 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1424,7 +1424,6 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 {
 
 	int	reset = 0;	/* whether to send reset in case of err.. */
-	int	passive_state;
 	atomic_inc(&cm_resets_recvd);
 	nes_debug(NES_DBG_CM, "Received Reset, cm_node = %p, state = %u."
 			" refcnt=%d\n", cm_node, cm_node->state,
@@ -1439,7 +1438,7 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		active_open_err(cm_node, skb, reset);
 		break;
 	case NES_CM_STATE_MPAREQ_RCVD:
-		passive_state = atomic_add_return(1, &cm_node->passive_state);
+		atomic_inc(&cm_node->passive_state);
 		dev_kfree_skb_any(skb);
 		break;
 	case NES_CM_STATE_ESTABLISHED:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
