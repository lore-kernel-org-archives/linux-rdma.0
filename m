From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 13/22] IB/srpt: Fix how aborted commands are processed
Date: Fri, 29 Jan 2016 15:15:52 -0800
Message-ID: <56ABF2A8.5060200@sandisk.com>
References: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF16E.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

srpt_abort_cmd() must not be called in state SRPT_STATE_DATA_IN. Issue
a warning if this occurs.

srpt_abort_cmd() must not invoke target_put_sess_cmd() for commands
in state SRPT_STATE_DONE because the srpt_abort_cmd() callers already
do this when necessary. Hence remove this call.

If an RDMA read fails the corresponding SCSI command must fail. Hence
add a transport_generic_request_failure() call.

Remove an incorrect srpt_abort_cmd() call from srpt_rdma_write_done().

Avoid that srpt_send_done() calls srpt_abort_cmd() for finished SCSI
commands.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 49 ++++++++++++-----------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8ab431f..652e1ef 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1267,10 +1267,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 
 	/*
 	 * If the command is in a state where the target core is waiting for
-	 * the ib_srpt driver, change the state to the next state. Changing
-	 * the state of the command from SRPT_STATE_NEED_DATA to
-	 * SRPT_STATE_DATA_IN ensures that srpt_xmit_response() will call this
-	 * function a second time.
+	 * the ib_srpt driver, change the state to the next state.
 	 */
 
 	spin_lock_irqsave(&ioctx->spinlock, flags);
@@ -1279,25 +1276,17 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 	case SRPT_STATE_NEED_DATA:
 		ioctx->state = SRPT_STATE_DATA_IN;
 		break;
-	case SRPT_STATE_DATA_IN:
 	case SRPT_STATE_CMD_RSP_SENT:
 	case SRPT_STATE_MGMT_RSP_SENT:
 		ioctx->state = SRPT_STATE_DONE;
 		break;
 	default:
+		WARN_ONCE(true, "%s: unexpected I/O context state %d\n",
+			  __func__, state);
 		break;
 	}
 	spin_unlock_irqrestore(&ioctx->spinlock, flags);
 
-	if (state == SRPT_STATE_DONE) {
-		struct srpt_rdma_ch *ch = ioctx->ch;
-
-		BUG_ON(ch->sess == NULL);
-
-		target_put_sess_cmd(&ioctx->cmd);
-		goto out;
-	}
-
 	pr_debug("Aborting cmd with state %d and tag %lld\n", state,
 		 ioctx->cmd.tag);
 
@@ -1305,19 +1294,16 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 	case SRPT_STATE_NEW:
 	case SRPT_STATE_DATA_IN:
 	case SRPT_STATE_MGMT:
+	case SRPT_STATE_DONE:
 		/*
 		 * Do nothing - defer abort processing until
 		 * srpt_queue_response() is invoked.
 		 */
-		WARN_ON(!transport_check_aborted_status(&ioctx->cmd, false));
 		break;
 	case SRPT_STATE_NEED_DATA:
-		/* DMA_TO_DEVICE (write) - RDMA read error. */
-
-		/* XXX(hch): this is a horrible layering violation.. */
-		spin_lock_irqsave(&ioctx->cmd.t_state_lock, flags);
-		ioctx->cmd.transport_state &= ~CMD_T_ACTIVE;
-		spin_unlock_irqrestore(&ioctx->cmd.t_state_lock, flags);
+		pr_debug("tag %#llx: RDMA read error\n", ioctx->cmd.tag);
+		transport_generic_request_failure(&ioctx->cmd,
+					TCM_CHECK_CONDITION_ABORT_CMD);
 		break;
 	case SRPT_STATE_CMD_RSP_SENT:
 		/*
@@ -1325,18 +1311,16 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		 * not been received in time.
 		 */
 		srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
-		target_put_sess_cmd(&ioctx->cmd);
+		transport_generic_free_cmd(&ioctx->cmd, 0);
 		break;
 	case SRPT_STATE_MGMT_RSP_SENT:
-		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
-		target_put_sess_cmd(&ioctx->cmd);
+		transport_generic_free_cmd(&ioctx->cmd, 0);
 		break;
 	default:
 		WARN(1, "Unexpected command state (%d)", state);
 		break;
 	}
 
-out:
 	return state;
 }
 
@@ -1376,9 +1360,14 @@ static void srpt_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		/*
+		 * Note: if an RDMA write error completion is received that
+		 * means that a SEND also has been posted. Defer further
+		 * processing of the associated command until the send error
+		 * completion has been received.
+		 */
 		pr_info("RDMA_WRITE for ioctx 0x%p failed with status %d\n",
 			ioctx, wc->status);
-		srpt_abort_cmd(ioctx);
 	}
 }
 
@@ -1721,15 +1710,10 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	atomic_inc(&ch->sq_wr_avail);
 
-	if (wc->status != IB_WC_SUCCESS) {
+	if (wc->status != IB_WC_SUCCESS)
 		pr_info("sending response for ioctx 0x%p failed"
 			" with status %d\n", ioctx, wc->status);
 
-		atomic_dec(&ch->req_lim);
-		srpt_abort_cmd(ioctx);
-		goto out;
-	}
-
 	if (state != SRPT_STATE_DONE) {
 		srpt_unmap_sg_to_ib_sge(ch, ioctx);
 		transport_generic_free_cmd(&ioctx->cmd, 0);
@@ -1738,7 +1722,6 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 		       " wr_id = %u.\n", ioctx->ioctx.index);
 	}
 
-out:
 	while (!list_empty(&ch->cmd_wait_list) &&
 	       ch->state == CH_LIVE &&
 	       (ioctx = srpt_get_send_ioctx(ch)) != NULL) {
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
