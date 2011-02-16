From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Prevent double completions after a timeout or RNR
	error
Date: Wed, 16 Feb 2011 10:48:25 -0500
Message-ID: <20110216154825.24564.28020.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is a double completion associated with error handling
for RC QP's.

The sequence is:
- The do_rc_ack() routine fields an RNR nack and there are 0 rnr_retries
configured on the QP.
- qib_error_qp() stops the pending timer
- qib_rc_send_complete() is called from sdma_complete()
- qib_rc_send_complete() starts the timer because the msb of the psn just
completed says and ack is needed.
- a bunch of flushes occur as ipoib posts wqe's to an error'ed qp
- rc_timeout() calls qib_restart_rc()
- qib_restart_rc() calls qib_send_complete() with a IB_WC_RETRY_EXC_ERR on a
wqe that has already been completed in the past

The fix avoids starting the timer since another packet will never
arrive.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 25ddb5b..ea8b02c 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1005,7 +1005,8 @@ void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr)
 	 * there are still requests that haven't been acked.
 	 */
 	if ((psn & IB_BTH_REQ_ACK) && qp->s_acked != qp->s_tail &&
-	    !(qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR | QIB_S_WAIT_PSN)))
+	    !(qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR | QIB_S_WAIT_PSN)) &&
+	    (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
 		start_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
