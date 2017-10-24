From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] IB/rxe: Convert timers to use timer_setup()
Date: Tue, 24 Oct 2017 03:28:27 -0700
Message-ID: <20171024102827.GA69848@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 4 ++--
 drivers/infiniband/sw/rxe/rxe_loc.h  | 4 ++--
 drivers/infiniband/sw/rxe/rxe_qp.c   | 4 ++--
 drivers/infiniband/sw/rxe/rxe_req.c  | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 9eb12c2e3c74..a4cda6b3a04b 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -136,9 +136,9 @@ static enum ib_wc_opcode wr_to_wc_opcode(enum ib_wr_opcode opcode)
 	}
 }
 
-void retransmit_timer(unsigned long data)
+void retransmit_timer(struct timer_list *t)
 {
-	struct rxe_qp *qp = (struct rxe_qp *)data;
+	struct rxe_qp *qp = from_timer(qp, t, retrans_timer);
 
 	if (qp->valid) {
 		qp->comp.timeout = 1;
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 77b3ed0df936..d7472a442a2c 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -218,8 +218,8 @@ static inline void rxe_advance_resp_resource(struct rxe_qp *qp)
 		qp->resp.res_head = 0;
 }
 
-void retransmit_timer(unsigned long data);
-void rnr_nak_timer(unsigned long data);
+void retransmit_timer(struct timer_list *t);
+void rnr_nak_timer(struct timer_list *t);
 
 /* rxe_srq.c */
 #define IB_SRQ_INIT_MASK (~IB_SRQ_LIMIT)
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 00bda9380a2e..4469592b839d 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -275,8 +275,8 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	qp->qp_timeout_jiffies = 0; /* Can't be set for UD/UC in modify_qp */
 	if (init->qp_type == IB_QPT_RC) {
-		setup_timer(&qp->rnr_nak_timer, rnr_nak_timer, (unsigned long)qp);
-		setup_timer(&qp->retrans_timer, retransmit_timer, (unsigned long)qp);
+		timer_setup(&qp->rnr_nak_timer, rnr_nak_timer, 0);
+		timer_setup(&qp->retrans_timer, retransmit_timer, 0);
 	}
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index d84222f9d5d2..26a7f923045b 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -118,9 +118,9 @@ static void req_retry(struct rxe_qp *qp)
 	}
 }
 
-void rnr_nak_timer(unsigned long data)
+void rnr_nak_timer(struct timer_list *t)
 {
-	struct rxe_qp *qp = (struct rxe_qp *)data;
+	struct rxe_qp *qp = from_timer(qp, t, rnr_nak_timer);
 
 	pr_debug("qp#%d rnr nak timer fired\n", qp_num(qp));
 	rxe_run_task(&qp->req.task, 1);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
