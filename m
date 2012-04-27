From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] iw_cxgb4: always wake up waiters in
	c4iw_peer_abort_intr().
Date: Fri, 27 Apr 2012 09:59:16 -0500
Message-ID: <20120427145915.27184.35216.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sbest-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This fixes a race where an ingress abort fails to wake up the
thread blocked in rdma_init() causing the app to hang.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 drivers/infiniband/hw/cxgb4/cm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 92b4c2b..8f43143 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2667,11 +2667,8 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	/*
 	 * Wake up any threads in rdma_init() or rdma_fini().
-	 * However, this is not needed if com state is just
-	 * MPA_REQ_SENT
 	 */
-	if (ep->com.state != MPA_REQ_SENT)
-		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 	sched(dev, skb);
 	return 0;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
