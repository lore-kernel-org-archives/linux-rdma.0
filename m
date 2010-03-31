From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] IB/iser: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed
	CQ callbacks
Date: Wed, 31 Mar 2010 10:57:58 -0700
Message-ID: <20100331175757.24522.71999.stgit@chromite.mv.qlogic.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331175742.24522.17850.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ib_req_notify_cq(IB_CQ_NEXT_COMP) is not guaranteed to generate
a callback for the next completion entered since there is a race
between arming the callback and another CQE being added to the queue.
The IB_CQ_REPORT_MISSED_EVENTS flag was added to detect this
race and allow the verbs consumer to call ib_poll_cq() and
ib_req_notify_cq() again to avoid delays in processing the CQE.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/ulp/iser/iser_verbs.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 308d17b..8cfd1c0 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -783,8 +783,11 @@ static void iser_cq_tasklet_fn(unsigned long data)
 	 unsigned long	     xfer_len;
 	struct iser_conn *ib_conn;
 	int completed_tx, completed_rx;
+	int ret;
+
 	completed_tx = completed_rx = 0;
 
+again:
 	while (ib_poll_cq(cq, 1, &wc) == 1) {
 		desc	 = (struct iser_rx_desc *) (unsigned long) wc.wr_id;
 		BUG_ON(desc == NULL);
@@ -807,9 +810,10 @@ static void iser_cq_tasklet_fn(unsigned long data)
 		if (!(completed_rx & 63))
 			completed_tx += iser_drain_tx_cq(device);
 	}
-	/* #warning "it is assumed here that arming CQ only once its empty" *
-	 * " would not cause interrupts to be missed"                       */
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+	ret = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
+				   IB_CQ_REPORT_MISSED_EVENTS);
+	if (ret > 0)
+		goto again;
 
 	completed_tx += iser_drain_tx_cq(device);
 	iser_dbg("got %d rx %d tx completions\n", completed_rx, completed_tx);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
