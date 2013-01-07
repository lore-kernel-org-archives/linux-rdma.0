From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 10/11] RDMA/cxgb4: Insert hwtid in pass_accept_req instead in pass_establish
Date: Mon,  7 Jan 2013 18:41:59 +0530
Message-ID: <1357564320-15022-11-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CPL_ABORT_REQ_RSS can come before TCP connection is established. In such case
peer_abort was trying to remove the hwtid which was not inserted. To avoid this
we insert the hwtid when we are sure that we are surely going to send passive
accept request.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 06c3a52..37ea2fc 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2010,6 +2010,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	init_timer(&child_ep->timer);
 	cxgb4_insert_tid(t, child_ep, hwtid);
+	insert_handle(dev, &dev->hwtid_idr, child_ep, child_ep->hwtid);
 	accept_cr(child_ep, peer_ip, skb, req);
 	set_bit(PASS_ACCEPT_REQ, &child_ep->com.history);
 	goto out;
@@ -2035,7 +2036,6 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	     ntohs(req->tcp_opt));
 
 	set_emss(ep, ntohs(req->tcp_opt));
-	insert_handle(dev, &dev->hwtid_idr, ep, ep->hwtid);
 
 	dst_confirm(ep->dst);
 	state_set(&ep->com, MPA_REQ_WAIT);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
