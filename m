From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 07/22] IB/srpt: Simplify srpt_handle_tsk_mgmt()
Date: Fri, 29 Jan 2016 15:13:32 -0800
Message-ID: <56ABF21C.5070409@sandisk.com>
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

Let the target core check task existence instead of the SRP target
driver. Additionally, let the target core check the validity of the
task management request instead of the ib_srpt driver.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Fixes: 3e4f574857ee ("ib_srpt: Convert TMR path to target_submit_tmr")
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 61 ++---------------------------------
 include/target/target_core_base.h     |  1 +
 2 files changed, 4 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b38372b..64820a2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1560,47 +1560,6 @@ send_sense:
 	return -1;
 }
 
-/**
- * srpt_rx_mgmt_fn_tag() - Process a task management function by tag.
- * @ch: RDMA channel of the task management request.
- * @fn: Task management function to perform.
- * @req_tag: Tag of the SRP task management request.
- * @mgmt_ioctx: I/O context of the task management request.
- *
- * Returns zero if the target core will process the task management
- * request asynchronously.
- *
- * Note: It is assumed that the initiator serializes tag-based task management
- * requests.
- */
-static int srpt_rx_mgmt_fn_tag(struct srpt_send_ioctx *ioctx, u64 tag)
-{
-	struct srpt_device *sdev;
-	struct srpt_rdma_ch *ch;
-	struct srpt_send_ioctx *target;
-	int ret, i;
-
-	ret = -EINVAL;
-	ch = ioctx->ch;
-	BUG_ON(!ch);
-	BUG_ON(!ch->sport);
-	sdev = ch->sport->sdev;
-	BUG_ON(!sdev);
-	spin_lock_irq(&sdev->spinlock);
-	for (i = 0; i < ch->rq_size; ++i) {
-		target = ch->ioctx_ring[i];
-		if (target->cmd.se_lun == ioctx->cmd.se_lun &&
-		    target->cmd.tag == tag &&
-		    srpt_get_cmd_state(target) != SRPT_STATE_DONE) {
-			ret = 0;
-			/* now let the target core abort &target->cmd; */
-			break;
-		}
-	}
-	spin_unlock_irq(&sdev->spinlock);
-	return ret;
-}
-
 static int srp_tmr_to_tcm(int fn)
 {
 	switch (fn) {
@@ -1615,7 +1574,7 @@ static int srp_tmr_to_tcm(int fn)
 	case SRP_TSK_CLEAR_ACA:
 		return TMR_CLEAR_ACA;
 	default:
-		return -1;
+		return UNKNOWN_TMR;
 	}
 }
 
@@ -1634,7 +1593,6 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	struct srp_tsk_mgmt *srp_tsk;
 	struct se_cmd *cmd;
 	struct se_session *sess = ch->sess;
-	uint32_t tag = 0;
 	int tcm_tmr;
 	int rc;
 
@@ -1650,23 +1608,10 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	srpt_set_cmd_state(send_ioctx, SRPT_STATE_MGMT);
 	send_ioctx->cmd.tag = srp_tsk->tag;
 	tcm_tmr = srp_tmr_to_tcm(srp_tsk->tsk_mgmt_func);
-	if (tcm_tmr < 0) {
-		send_ioctx->cmd.se_tmr_req->response =
-			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
-		goto fail;
-	}
-	if (srp_tsk->tsk_mgmt_func == SRP_TSK_ABORT_TASK) {
-		rc = srpt_rx_mgmt_fn_tag(send_ioctx, srp_tsk->task_tag);
-		if (rc < 0) {
-			send_ioctx->cmd.se_tmr_req->response =
-					TMR_TASK_DOES_NOT_EXIST;
-			goto fail;
-		}
-		tag = srp_tsk->task_tag;
-	}
 	rc = target_submit_tmr(&send_ioctx->cmd, sess, NULL,
 			       scsilun_to_int(&srp_tsk->lun), srp_tsk, tcm_tmr,
-			       GFP_KERNEL, tag, TARGET_SCF_ACK_KREF);
+			       GFP_KERNEL, srp_tsk->task_tag,
+			       TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
 		goto fail;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5d82816..cffe66d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -191,6 +191,7 @@ enum target_sc_flags_table {
 
 /* fabric independent task management function values */
 enum tcm_tmreq_table {
+	UNKNOWN_TMR		= 0,
 	TMR_ABORT_TASK		= 1,
 	TMR_ABORT_TASK_SET	= 2,
 	TMR_CLEAR_ACA		= 3,
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
