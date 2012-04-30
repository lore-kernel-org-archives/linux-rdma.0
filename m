From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: Drop peer_abort when no endpoint found.
Date: Mon, 30 Apr 2012 15:31:29 -0500
Message-ID: <20120430203129.14228.19855.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Log a warning and drop the abort message.  Otherwise
we will do a bogus wake_up() and crash.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 drivers/infiniband/hw/cxgb4/cm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8f43143..b75d407 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2656,6 +2656,12 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 	unsigned int tid = GET_TID(req);
 
 	ep = lookup_tid(t, tid);
+	if (!ep) {
+		printk(KERN_WARNING MOD
+		       "Abort on non-existent endpoint, tid %d\n", tid);
+		kfree_skb(skb);
+		return 0;
+	}
 	if (is_neg_adv_abort(req->status)) {
 		PDBG("%s neg_adv_abort ep %p tid %u\n", __func__, ep,
 		     ep->hwtid);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
