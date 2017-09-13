From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v3 1/3] iw_cxgb4: put ep reference in pass_accept_req()
Date: Wed, 13 Sep 2017 09:52:32 -0700
Message-ID: <468f0009b232db179963647515110f33541450b5.1505510827.git.swise@opengridcomputing.com>
References: <cover.1505510827.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1505510827.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The listening endpoint should always be dereferenced at the end of
pass_accept_req().

Fixes: f86fac79afec ("RDMA/iw_cxgb4: atomic find and reference for listening endpoints")

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e49b34c..6d85a5d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2594,9 +2594,9 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	c4iw_put_ep(&child_ep->com);
 reject:
 	reject_cr(dev, hwtid, skb);
+out:
 	if (parent_ep)
 		c4iw_put_ep(&parent_ep->com);
-out:
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
