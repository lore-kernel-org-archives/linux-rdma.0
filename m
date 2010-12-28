From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 22/24] IB/qib: Un-necessary delayed completions on RC
	connection
Date: Tue, 28 Dec 2010 10:28:45 -0500
Message-ID: <20101228152844.19960.31519.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently on receipt of a response message (ACKs, RDMA Response, Atomic
Responses etc.) if the SDMA completion counter is not advanced the
driver delays the completion of the WQE. In most cases this is overly
pessimistic as the response (ACK) to a previously transmitted send
implies that the send is complete. Ensure that SDMA queue is progressed
appropriately before determining if a send has delayed completions.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 955fb71..8245237 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1407,6 +1407,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 			    struct qib_ctxtdata *rcd)
 {
 	struct qib_swqe *wqe;
+	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	enum ib_wc_status status;
 	unsigned long flags;
 	int diff;
@@ -1414,6 +1415,29 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 	u32 aeth;
 	u64 val;
 
+	if (opcode != OP(RDMA_READ_RESPONSE_MIDDLE)) {
+		/*
+		 * If ACK'd PSN on SDMA busy list try to make progress to
+		 * reclaim SDMA credits.
+		 */
+		if ((qib_cmp24(psn, qp->s_sending_psn) >= 0) &&
+		    (qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)) {
+
+			/*
+			 * If send tasklet not running attempt to progress
+			 * SDMA queue.
+			 */
+			if (!(qp->s_flags & QIB_S_BUSY)) {
+				/* Acquire SDMA Lock */
+				spin_lock_irqsave(&ppd->sdma_lock, flags);
+				/* Invoke sdma make progress */
+				qib_sdma_make_progress(ppd);
+				/* Release SDMA Lock */
+				spin_unlock_irqrestore(&ppd->sdma_lock, flags);
+			}
+		}
+	}
+
 	spin_lock_irqsave(&qp->s_lock, flags);
 
 	/* Ignore invalid responses. */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
