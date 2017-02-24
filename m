From: David Marchand <david.marchand@6wind.com>
Subject: [PATCH] IB/rxe: increment msn only when completing a request
Date: Fri, 24 Feb 2017 15:38:26 +0100
Message-ID: <1487947106-21382-1-git-send-email-david.marchand@6wind.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: monis@mellanox.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

According to C9-147, MSN should only be incremented when the last packet of
a multi packet request has been received.

"Logically, the requester associates a sequential Send Sequence Number
(SSN) with each WQE posted to the send queue. The SSN bears a one-
to-one relationship to the MSN returned by the responder in each re-
sponse packet. Therefore, when the requester receives a response, it in-
terprets the MSN as representing the SSN of the most recent request
completed by the responder to determine which send WQE(s) can be
completed."

Fixes: 8700e3e7c485 ("Soft RoCE driver")

Signed-off-by: David Marchand <david.marchand@6wind.com>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 5bcf073..193d95c 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -812,18 +812,18 @@ static enum resp_states execute(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 		/* Unreachable */
 		WARN_ON(1);
 
-	/* We successfully processed this new request. */
-	qp->resp.msn++;
-
 	/* next expected psn, read handles this separately */
 	qp->resp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
 
 	qp->resp.opcode = pkt->opcode;
 	qp->resp.status = IB_WC_SUCCESS;
 
-	if (pkt->mask & RXE_COMP_MASK)
+	if (pkt->mask & RXE_COMP_MASK) {
+		/* We successfully processed this new request. See C9-147. */
+		qp->resp.msn++;
+
 		return RESPST_COMPLETE;
-	else if (qp_type(qp) == IB_QPT_RC)
+	} else if (qp_type(qp) == IB_QPT_RC)
 		return RESPST_ACKNOWLEDGE;
 	else
 		return RESPST_CLEANUP;
-- 
2.7.4
