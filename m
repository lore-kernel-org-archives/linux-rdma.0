From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next] iw_cxgb3: Ignore positive return values from the ofld send functions
Date: Fri, 11 Dec 2015 13:59:17 +0530
Message-ID: <1449822557-8661-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The cxgb3_*_send() functions return NET_XMIT_ values, which are
positive integers values. So don't treat positive return values
as an error.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index cb78b1e..f504ba7 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -149,7 +149,7 @@ static int iwch_l2t_send(struct t3cdev *tdev, struct sk_buff *skb, struct l2t_en
 	error = l2t_send(tdev, skb, l2e);
 	if (error < 0)
 		kfree_skb(skb);
-	return error;
+	return error < 0 ? error : 0;
 }
 
 int iwch_cxgb3_ofld_send(struct t3cdev *tdev, struct sk_buff *skb)
@@ -165,7 +165,7 @@ int iwch_cxgb3_ofld_send(struct t3cdev *tdev, struct sk_buff *skb)
 	error = cxgb3_ofld_send(tdev, skb);
 	if (error < 0)
 		kfree_skb(skb);
-	return error;
+	return error < 0 ? error : 0;
 }
 
 static void release_tid(struct t3cdev *tdev, u32 hwtid, struct sk_buff *skb)
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
