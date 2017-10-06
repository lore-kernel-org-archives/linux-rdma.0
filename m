From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 44/47] RDMA/rxe: Suppress gcc 7 fall-through complaints
Date: Fri,  6 Oct 2017 14:33:30 -0700
Message-ID: <20171006213333.6721-45-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c  | 4 ++--
 drivers/infiniband/sw/rxe/rxe_task.c  | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 9eb12c2e3c74..ff64875e3d15 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -270,8 +270,8 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 		if ((syn & AETH_TYPE_MASK) != AETH_ACK)
 			return COMPST_ERROR;
 
-		/* Fall through (IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE
-		 * doesn't have an AETH)
+		/* fall through */
+		/* (IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE doesn't have an AETH)
 		 */
 	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
 		if (wqe->wr.opcode != IB_WR_RDMA_READ &&
diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index ea3810b29273..08f05ac5f5d5 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -71,7 +71,7 @@ void rxe_do_task(unsigned long data)
 
 	case TASK_STATE_BUSY:
 		task->state = TASK_STATE_ARMED;
-		/* fall through to */
+		/* fall through */
 	case TASK_STATE_ARMED:
 		spin_unlock_irqrestore(&task->state_lock, flags);
 		return;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 0b362f49a10a..ff77f4f66970 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -644,6 +644,7 @@ static void init_send_wr(struct rxe_qp *qp, struct rxe_send_wr *wr,
 		switch (wr->opcode) {
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			wr->ex.imm_data = ibwr->ex.imm_data;
+			/* fall through */
 		case IB_WR_RDMA_READ:
 		case IB_WR_RDMA_WRITE:
 			wr->wr.rdma.remote_addr = rdma_wr(ibwr)->remote_addr;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
