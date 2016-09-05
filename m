From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/4] IB/rxe: Fix duplicate atomic request handling
Date: Mon,  5 Sep 2016 15:09:17 +0300
Message-ID: <1473077359-11546-3-git-send-email-leon@kernel.org>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473077359-11546-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When handling ack for atomic opcodes like "fetch&add"
or "cmp&swp", the method send_atomic_ack() saves the ack
before sending it, in case it gets lost and never reach the
requester. In which case the method duplicate_request()
will need to find it using the duplicated request.psn.
But send_atomic_ack() used a wrong psn value and thus
the above ack was never found.
This fix uses the ack.psn to locate the ack in case
its needed.
This fix also copies the ack packet to the skb's control buffer
since duplicate_request() will need it when calling rxe_xmit_packet()

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index ebb03b4..3e0f0f2 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -972,11 +972,13 @@ static int send_atomic_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	free_rd_atomic_resource(qp, res);
 	rxe_advance_resp_resource(qp);
 
+	memcpy(SKB_TO_PKT(skb), &ack_pkt, sizeof(skb->cb));
+
 	res->type = RXE_ATOMIC_MASK;
 	res->atomic.skb = skb;
-	res->first_psn = qp->resp.psn;
-	res->last_psn = qp->resp.psn;
-	res->cur_psn = qp->resp.psn;
+	res->first_psn = ack_pkt.psn;
+	res->last_psn  = ack_pkt.psn;
+	res->cur_psn   = ack_pkt.psn;
 
 	rc = rxe_xmit_packet(rxe, qp, &ack_pkt, skb_copy);
 	if (rc) {
@@ -1116,8 +1118,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 				rc = RESPST_CLEANUP;
 				goto out;
 			}
-			bth_set_psn(SKB_TO_PKT(skb_copy),
-				    qp->resp.psn - 1);
+
 			/* Resend the result. */
 			rc = rxe_xmit_packet(to_rdev(qp->ibqp.device), qp,
 					     pkt, skb_copy);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
