From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 4/5] iw_cxgb4: reverse the ord/ird in the ESTABLISHED upcall
Date: Tue,  8 Sep 2015 09:57:00 +0530
Message-ID: <1441686421-5899-5-git-send-email-hariprasad@chelsio.com>
References: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441686421-5899-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ESTABLISHED event should have the peer's ord/ird so
swap the values in the event before the upcall.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 06d208c..0e2741b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1242,8 +1242,8 @@ static void established_upcall(struct c4iw_ep *ep)
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_ESTABLISHED;
-	event.ird = ep->ird;
-	event.ord = ep->ord;
+	event.ird = ep->ord;
+	event.ord = ep->ird;
 	if (ep->com.cm_id) {
 		PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
