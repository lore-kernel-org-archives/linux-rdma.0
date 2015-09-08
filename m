From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 2/5] iw_cxgb4: pass the ord/ird in connect reply events
Date: Tue,  8 Sep 2015 09:56:58 +0530
Message-ID: <1441686421-5899-3-git-send-email-hariprasad@chelsio.com>
References: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441686421-5899-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This allows client ULPs to get the negotiated ord/ird which is useful
to avoid stalling the SQ due to exceeding the ORD.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 42087c9..a26d293 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1169,6 +1169,8 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status)
 	if ((status == 0) || (status == -ECONNREFUSED)) {
 		if (!ep->tried_with_mpa_v1) {
 			/* this means MPA_v2 is used */
+			event.ord = ep->ird;
+			event.ird = ep->ord;
 			event.private_data_len = ep->plen -
 				sizeof(struct mpa_v2_conn_params);
 			event.private_data = ep->mpa_pkt +
@@ -1176,6 +1178,8 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status)
 				sizeof(struct mpa_v2_conn_params);
 		} else {
 			/* this means MPA_v1 is used */
+			event.ord = cur_max_read_depth(ep->com.dev);
+			event.ird = cur_max_read_depth(ep->com.dev);
 			event.private_data_len = ep->plen;
 			event.private_data = ep->mpa_pkt +
 				sizeof(struct mpa_message);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
