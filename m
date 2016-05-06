From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 16/17] RDMA/iw_cxgb4: Always wake up waiter in c4iw_peer_abort_intr()
Date: Fri,  6 May 2016 22:18:09 +0530
Message-ID: <1462553290-16422-17-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently c4iw_peer_abort_intr() does not wake up the waiter if the
endpoint state indicates we're using MPAv2 and we're currently trying to
connect. This was introduced with commit 7c0a33d61187a ("RDMA/cxgb4:
Don't wakeup threads for MPAv2")

However, this original fix is flawed because it introduces a race that
can cause a deadlock of the iwarp stack.  Here is the race:

->local side sets up an active offload connection.

->local side sends MPA_START request.

->peer sends MPA_START response.

->local side ingress cpl thread begins processing the MPA_START response,
but before it changes the state from MPA_REQ_SENT to FPDU_MODE:

->peer sends a RST which results in a ABORT_REQ_RSS.  This triggers
peer_abort_intr() which sees the state in MPA_REQ_SENT and since mpa_rev
is 2, it will avoid waking up the endpoint with -ECONNRESET, assuming the
stack will re-attempt the connection using MPAv1.

->Meanwhile, the cpl thread moves the state to FPDU_MODE and calls
c4iw_modify_rc_qp() which calls rdma_init() which sends a RI_WR/INIT WR
to firmware.  But since HW sent an abort, FW correctly drops the RI_WR/INIT
WR.

->So the cpl thread is stuck waiting for a reply and cannot process the
ABORT_REQ_RSS cpl sitting in its input queue. Thus everything comes to a
halt because no more ingress cpls are processed by the stack...

The correct fix for the issue is to always do the wake up in
c4iw_abort_intr() but reinitialize the wait object in c4iw_reconnect().

Fixes: 7c0a33d61187a ("RDMA/cxgb4: Don't wakeup threads for MPAv2")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0502fac4a214..4f8afa2b8e21 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2136,6 +2136,7 @@ static int c4iw_reconnect(struct c4iw_ep *ep)
 
 	PDBG("%s qp %p cm_id %p\n", __func__, ep->com.qp, ep->com.cm_id);
 	init_timer(&ep->timer);
+	c4iw_init_wr_wait(&ep->com.wr_wait);
 
 	/*
 	 * Allocate an active TID to initiate a TCP connection.
@@ -4239,16 +4240,7 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 	PDBG("%s ep %p tid %u state %u\n", __func__, ep, ep->hwtid,
 	     ep->com.state);
 
-	/*
-	 * Wake up any threads in rdma_init() or rdma_fini().
-	 * However, if we are on MPAv2 and want to retry with MPAv1
-	 * then, don't wake up yet.
-	 */
-	if (mpa_rev == 2 && !ep->tried_with_mpa_v1) {
-		if (ep->com.state != MPA_REQ_SENT)
-			c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
-	} else
-		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 out:
 	sched(dev, skb);
 	return 0;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
