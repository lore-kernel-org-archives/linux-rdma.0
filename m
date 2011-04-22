From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] RDMA/cxgb4: Reset wait condition atomically.
Date: Fri, 22 Apr 2011 12:56:07 -0500
Message-ID: <20110422175607.8004.14295.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The driver was never really waiting for RDMA_WR/FINI completions because
the condition variable used to determine if the completion happened was
never reset, and this condition variable is reused for both connection
setup and teardown.  This causes various driver crashes under heavy
loads due to releasing resources too early.

The fix is to use atomic bits to correctly reset the condition immediately
after the completion is detected.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   30 +++++++-----------------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   26 +++++++++++++++++++-------
 2 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d235810..d7ee70f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1198,9 +1198,7 @@ static int pass_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	}
 	PDBG("%s ep %p status %d error %d\n", __func__, ep,
 	     rpl->status, status2errno(rpl->status));
-	ep->com.wr_wait.ret = status2errno(rpl->status);
-	ep->com.wr_wait.done = 1;
-	wake_up(&ep->com.wr_wait.wait);
+	c4iw_wake_up(&ep->com.wr_wait, status2errno(rpl->status));
 
 	return 0;
 }
@@ -1234,9 +1232,7 @@ static int close_listsrv_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_listen_ep *ep = lookup_stid(t, stid);
 
 	PDBG("%s ep %p\n", __func__, ep);
-	ep->com.wr_wait.ret = status2errno(rpl->status);
-	ep->com.wr_wait.done = 1;
-	wake_up(&ep->com.wr_wait.wait);
+	c4iw_wake_up(&ep->com.wr_wait, status2errno(rpl->status));
 	return 0;
 }
 
@@ -1492,17 +1488,13 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		 * in rdma connection migration (see c4iw_accept_cr()).
 		 */
 		__state_set(&ep->com, CLOSING);
-		ep->com.wr_wait.done = 1;
-		ep->com.wr_wait.ret = -ECONNRESET;
 		PDBG("waking up ep %p tid %u\n", ep, ep->hwtid);
-		wake_up(&ep->com.wr_wait.wait);
+		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 		break;
 	case MPA_REP_SENT:
 		__state_set(&ep->com, CLOSING);
-		ep->com.wr_wait.done = 1;
-		ep->com.wr_wait.ret = -ECONNRESET;
 		PDBG("waking up ep %p tid %u\n", ep, ep->hwtid);
-		wake_up(&ep->com.wr_wait.wait);
+		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 		break;
 	case FPDU_MODE:
 		start_ep_timer(ep);
@@ -1579,9 +1571,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 	/*
 	 * Wake up any threads in rdma_init() or rdma_fini().
 	 */
-	ep->com.wr_wait.done = 1;
-	ep->com.wr_wait.ret = -ECONNRESET;
-	wake_up(&ep->com.wr_wait.wait);
+	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 
 	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
@@ -2294,14 +2284,8 @@ static int fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
 		ret = (int)((be64_to_cpu(rpl->data[0]) >> 8) & 0xff);
 		wr_waitp = (struct c4iw_wr_wait *)(__force unsigned long) rpl->data[1];
 		PDBG("%s wr_waitp %p ret %u\n", __func__, wr_waitp, ret);
-		if (wr_waitp) {
-			if (ret)
-				wr_waitp->ret = -ret;
-			else
-				wr_waitp->ret = 0;
-			wr_waitp->done = 1;
-			wake_up(&wr_waitp->wait);
-		}
+		if (wr_waitp)
+			c4iw_wake_up(wr_waitp, ret ? -ret : 0);
 		kfree_skb(skb);
 		break;
 	case 2:
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 8e16eb2..3dcfe82 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -131,42 +131,54 @@ static inline int c4iw_num_stags(struct c4iw_rdev *rdev)
 
 #define C4IW_WR_TO (10*HZ)
 
+enum {
+	REPLY_READY = 0,
+};
+
 struct c4iw_wr_wait {
 	wait_queue_head_t wait;
-	int done;
+	unsigned long status;
 	int ret;
 };
 
 static inline void c4iw_init_wr_wait(struct c4iw_wr_wait *wr_waitp)
 {
 	wr_waitp->ret = 0;
-	wr_waitp->done = 0;
+	wr_waitp->status = 0;
 	init_waitqueue_head(&wr_waitp->wait);
 }
 
+static inline void c4iw_wake_up(struct c4iw_wr_wait *wr_waitp, int ret)
+{
+	wr_waitp->ret = ret;
+	set_bit(REPLY_READY, &wr_waitp->status);
+	wake_up(&wr_waitp->wait);
+}
+
 static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
 				 struct c4iw_wr_wait *wr_waitp,
 				 u32 hwtid, u32 qpid,
 				 const char *func)
 {
 	unsigned to = C4IW_WR_TO;
-	do {
+	int ret;
 
-		wait_event_timeout(wr_waitp->wait, wr_waitp->done, to);
-		if (!wr_waitp->done) {
+	do {
+		ret = wait_event_timeout(wr_waitp->wait,
+			test_and_clear_bit(REPLY_READY, &wr_waitp->status), to);
+		if (!ret) {
 			printk(KERN_ERR MOD "%s - Device %s not responding - "
 			       "tid %u qpid %u\n", func,
 			       pci_name(rdev->lldi.pdev), hwtid, qpid);
 			to = to << 2;
 		}
-	} while (!wr_waitp->done);
+	} while (!ret);
 	if (wr_waitp->ret)
 		PDBG("%s: FW reply %d tid %u qpid %u\n",
 		     pci_name(rdev->lldi.pdev), wr_waitp->ret, hwtid, qpid);
 	return wr_waitp->ret;
 }
 
-
 struct c4iw_dev {
 	struct ib_device ibdev;
 	struct c4iw_rdev rdev;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
