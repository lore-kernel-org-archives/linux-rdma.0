From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/13] IB/hfi1: Fix defered ack race with qp destroy
Date: Sun, 25 Sep 2016 07:41:46 -0700
Message-ID: <20160925144144.10261.26493.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is a a bug in defered ack stuff that causes a race with the
destroy of a QP.

A packet causes a defered ack to be pended by putting the QP
into an rcd queue.

A return from the driver interrupt processing will process that rcd
queue of QPs and attempt to do a direct send of the ack.   At this
point no locks are held and the above QP could now be put in the reset
state in the qp destroy logic.   A refcount protects the QP while it
is in the rcd queue so it isn't going anywhere yet.

If the direct send fails to allocate a pio buffer,
hfi1_schedule_send() is called to trigger sending an ack from the
send engine. There is no state test in that code path.

The refcount is then dropped from the driver.c caller
potentially allowing the qp destroy to continue from its
refcount wait in parallel with the workqueue scheduling of the qp.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index d32f0c8..e9623d0 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -926,8 +926,10 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	return;
 
 queue_ack:
-	this_cpu_inc(*ibp->rvp.rc_qacks);
 	spin_lock_irqsave(&qp->s_lock, flags);
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
+		goto unlock;
+	this_cpu_inc(*ibp->rvp.rc_qacks);
 	qp->s_flags |= RVT_S_ACK_PENDING | RVT_S_RESP_PENDING;
 	qp->s_nak_state = qp->r_nak_state;
 	qp->s_ack_psn = qp->r_ack_psn;
@@ -936,6 +938,7 @@ queue_ack:
 
 	/* Schedule the send tasklet. */
 	hfi1_schedule_send(qp);
+unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
