From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Kernel BUG at include/linux/timer.h:82
Date: Thu, 10 Feb 2011 09:11:28 -0500
Message-ID: <20110210141128.27961.88988.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following panic BUG_ON occurs during qib testing:

Kernel BUG at include/linux/timer.h:82

RIP  [<ffffffff881f7109>] :ib_qib:start_timer+0x73/0x89
 RSP <ffffffff80425bd0>
 <0>Kernel panic - not syncing: Fatal exception
 <0>Dumping qib trace buffer from panic
qib_set_lid INFO: IB0:1 got a lid: 0xf8
Done dumping qib trace buffer
BUG: warning at kernel/panic.c:137/panic() (Tainted: G

The flaw is due to a missing state test when processing responses that results
in an add_timer() call when the same timer is already queued.  This code was
executing in parallel with a QP destroy on another CPU that had changed the state
to reset, but the missing test caused to response handling code to run on into
the panic.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 8245237..25ddb5b 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1439,6 +1439,9 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 	}
 
 	spin_lock_irqsave(&qp->s_lock, flags);
+	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
+		goto ack_done;
+
 
 	/* Ignore invalid responses. */
 	if (qib_cmp24(psn, qp->s_next_psn) >= 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
