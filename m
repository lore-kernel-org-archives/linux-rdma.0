From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 03/11] RDMA/cxgb4: Ignore positive return values from
	cxgb4_*_send() functions.
Date: Fri, 10 Sep 2010 11:14:58 -0500
Message-ID: <20100910161458.6829.40425.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The cxgb4_*_send() functions return the NET_XMIT_ values, which are
positive integers or negative errno values.  So don't treat positive
return values as an error.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 32d352a..d548167 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -172,7 +172,7 @@ static int c4iw_l2t_send(struct c4iw_rdev *rdev, struct sk_buff *skb,
 	error = cxgb4_l2t_send(rdev->lldi.ports[0], skb, l2e);
 	if (error < 0)
 		kfree_skb(skb);
-	return error;
+	return error < 0 ? error : 0;
 }
 
 int c4iw_ofld_send(struct c4iw_rdev *rdev, struct sk_buff *skb)
@@ -187,7 +187,7 @@ int c4iw_ofld_send(struct c4iw_rdev *rdev, struct sk_buff *skb)
 	error = cxgb4_ofld_send(rdev->lldi.ports[0], skb);
 	if (error < 0)
 		kfree_skb(skb);
-	return error;
+	return error < 0 ? error : 0;
 }
 
 static void release_tid(struct c4iw_rdev *rdev, u32 hwtid, struct sk_buff *skb)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
