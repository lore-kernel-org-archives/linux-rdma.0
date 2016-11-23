From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 2/8] IB/rxe: Advance the consumer pointer before posting the CQE
Date: Wed, 23 Nov 2016 12:39:18 -0500
Message-ID: <1479922764-13091-3-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A simple userspace application might poll the CQ, find a completion,
and then attempt to post a new WQE to the SQ. A spurious error can
occur if the userspace application detects a full SQ in the instant
before the kernel is able to advance the SQ consumer pointer.

This is noticeable when using single-entry SQs with ibv_rc_pingpong
if lots of kernel and userspace library debugging is enabled.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Reviewed-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 6c5e29d..d46c49b 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -420,11 +420,12 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
 	    (qp->req.state == QP_STATE_ERROR)) {
 		make_send_cqe(qp, wqe, &cqe);
+		advance_consumer(qp->sq.queue);
 		rxe_cq_post(qp->scq, &cqe, 0);
+	} else {
+		advance_consumer(qp->sq.queue);
 	}
 
-	advance_consumer(qp->sq.queue);
-
 	/*
 	 * we completed something so let req run again
 	 * if it is trying to fence
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
