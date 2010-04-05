From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: Don't free skbs on NET_XMIT_* indications from
	LLD.
Date: Mon, 05 Apr 2010 14:59:57 -0500
Message-ID: <20100405195956.28814.29311.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The low level cxgb3 driver can return NET_XMIT_CN and friends.
The iw_cxgb3 driver should _not_ treat these as errors.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index d94388b..4953146 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -150,7 +150,7 @@ int iwch_l2t_send(struct t3cdev *tdev, struct sk_buff *skb, struct l2t_entry *l2
 		return -EIO;
 	}
 	error = l2t_send(tdev, skb, l2e);
-	if (error)
+	if (error < 0)
 		kfree_skb(skb);
 	return error;
 }
@@ -166,7 +166,7 @@ int iwch_cxgb3_ofld_send(struct t3cdev *tdev, struct sk_buff *skb)
 		return -EIO;
 	}
 	error = cxgb3_ofld_send(tdev, skb);
-	if (error)
+	if (error < 0)
 		kfree_skb(skb);
 	return error;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
