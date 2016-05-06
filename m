From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 15/17] RDMA/iw_cxgb4: Handle ret value of process_mpa_reply() in rx_data
Date: Fri,  6 May 2016 22:18:08 +0530
Message-ID: <1462553290-16422-16-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 4ee10547a4e4..0502fac4a214 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1864,7 +1864,7 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	case MPA_REQ_WAIT:
 		ep->rcv_seq += dlen;
-		process_mpa_request(ep, skb);
+		disconnect = process_mpa_request(ep, skb);
 		break;
 	case FPDU_MODE: {
 		struct c4iw_qp_attributes attrs;
@@ -1885,7 +1885,7 @@ static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
 	}
 	mutex_unlock(&ep->com.mutex);
 	if (disconnect)
-		c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
+		c4iw_ep_disconnect(ep, disconnect == 2, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
 	return 0;
 }
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
