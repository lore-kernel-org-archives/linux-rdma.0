From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] IB/rxe: use setup_timer to simplify the code
Date: Tue,  7 Feb 2017 15:15:10 +0000
Message-ID: <20170207151510.12503-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Use setup_timer function instead of initializing timer with the function
and data fields.

Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 5749ff0..f98a19e 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -273,13 +273,8 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	rxe_init_task(rxe, &qp->comp.task, qp,
 		      rxe_completer, "comp");
 
-	init_timer(&qp->rnr_nak_timer);
-	qp->rnr_nak_timer.function = rnr_nak_timer;
-	qp->rnr_nak_timer.data = (unsigned long)qp;
-
-	init_timer(&qp->retrans_timer);
-	qp->retrans_timer.function = retransmit_timer;
-	qp->retrans_timer.data = (unsigned long)qp;
+	setup_timer(&qp->rnr_nak_timer, rnr_nak_timer, (unsigned long)qp);
+	setup_timer(&qp->retrans_timer, retransmit_timer, (unsigned long)qp);
 	qp->qp_timeout_jiffies = 0; /* Can't be set for UD/UC in modify_qp */
 
 	return 0;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
