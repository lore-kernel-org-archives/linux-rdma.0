From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Add missing peer2peer check in MPAv2 code
Date: Mon, 13 Feb 2012 22:36:40 +0530
Message-ID: <1329152800-17455-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Don't worry about p2p_type if peer2peer itself is not requested
in the first place.

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0668bb3..006a353 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1114,7 +1114,7 @@ static void process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 	 * generated when moving QP to RTS state.
 	 * A TERM message will be sent after QP has moved to RTS state
 	 */
-	if ((ep->mpa_attr.version == 2) &&
+	if ((ep->mpa_attr.version == 2) && peer2peer &&
 			(ep->mpa_attr.p2p_type != p2p_type)) {
 		ep->mpa_attr.p2p_type = FW_RI_INIT_P2PTYPE_DISABLED;
 		rtr_mismatch = 1;
-- 
1.7.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
