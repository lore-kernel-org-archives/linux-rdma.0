From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Fix retry with MPAv1 logic for MPAv2
Date: Mon, 28 Nov 2011 22:09:15 +0530
Message-ID: <1322498355-1410-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix logic so that we don't retry with MPAv1 once we have
done that already.
Else, we end up retrying with MPAv1 even when its not needed
on getting peer aborts -  and this could lead to kernel panic.

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b36cdac..760b2fe 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -542,8 +542,10 @@ static void send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
 		     (mpa_rev_to_use == 2 ? MPA_ENHANCED_RDMA_CONN : 0);
 	mpa->private_data_size = htons(ep->plen);
 	mpa->revision = mpa_rev_to_use;
-	if (mpa_rev_to_use == 1)
+	if (mpa_rev_to_use == 1) {
 		ep->tried_with_mpa_v1 = 1;
+		ep->retry_with_mpa_v1 = 0;
+	}
 
 	if (mpa_rev_to_use == 2) {
 		mpa->private_data_size +=
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
