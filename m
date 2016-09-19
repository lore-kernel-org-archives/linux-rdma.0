From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] IB/rxe: avoid putting a large struct rxe_qp on stack
Date: Mon, 19 Sep 2016 13:57:26 +0200
Message-ID: <20160919115826.553858-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A race condition fix added an rxe_qp structure to the stack in order
to be able to perform rollback in rxe_requester(), but the structure
is large enough to trigger the warning for possible stack overflow:

drivers/infiniband/sw/rxe/rxe_req.c: In function 'rxe_requester':
drivers/infiniband/sw/rxe/rxe_req.c:757:1: error: the frame size of 2064 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

This changes the rollback function to only save the psn inside
the qp, which is the only field we access in the rollback_qp
anyway.

Fixes: 3050b9985024 ("IB/rxe: Fix race condition between requester and completer")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 13a848a518e8..cf1ffac25585 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -548,23 +548,23 @@ static void update_wqe_psn(struct rxe_qp *qp,
 static void save_state(struct rxe_send_wqe *wqe,
 		       struct rxe_qp *qp,
 		       struct rxe_send_wqe *rollback_wqe,
-		       struct rxe_qp *rollback_qp)
+		       u32 *rollback_psn)
 {
 	rollback_wqe->state     = wqe->state;
 	rollback_wqe->first_psn = wqe->first_psn;
 	rollback_wqe->last_psn  = wqe->last_psn;
-	rollback_qp->req.psn    = qp->req.psn;
+	*rollback_psn		= qp->req.psn;
 }
 
 static void rollback_state(struct rxe_send_wqe *wqe,
 			   struct rxe_qp *qp,
 			   struct rxe_send_wqe *rollback_wqe,
-			   struct rxe_qp *rollback_qp)
+			   u32 rollback_psn)
 {
 	wqe->state     = rollback_wqe->state;
 	wqe->first_psn = rollback_wqe->first_psn;
 	wqe->last_psn  = rollback_wqe->last_psn;
-	qp->req.psn    = rollback_qp->req.psn;
+	qp->req.psn    = rollback_psn;
 }
 
 static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
@@ -593,8 +593,8 @@ int rxe_requester(void *arg)
 	int mtu;
 	int opcode;
 	int ret;
-	struct rxe_qp rollback_qp;
 	struct rxe_send_wqe rollback_wqe;
+	u32 rollback_psn;
 
 next_wqe:
 	if (unlikely(!qp->valid || qp->req.state == QP_STATE_ERROR))
@@ -717,7 +717,7 @@ int rxe_requester(void *arg)
 	 * rxe_xmit_packet().
 	 * Otherwise, completer might initiate an unjustified retry flow.
 	 */
-	save_state(wqe, qp, &rollback_wqe, &rollback_qp);
+	save_state(wqe, qp, &rollback_wqe, &rollback_psn);
 	update_wqe_state(qp, wqe, &pkt);
 	update_wqe_psn(qp, wqe, &pkt, payload);
 	ret = rxe_xmit_packet(to_rdev(qp->ibqp.device), qp, &pkt, skb);
@@ -725,7 +725,7 @@ int rxe_requester(void *arg)
 		qp->need_req_skb = 1;
 		kfree_skb(skb);
 
-		rollback_state(wqe, qp, &rollback_wqe, &rollback_qp);
+		rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
 
 		if (ret == -EAGAIN) {
 			rxe_run_task(&qp->req.task, 1);
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
