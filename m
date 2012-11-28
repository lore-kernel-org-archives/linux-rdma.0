From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] ib_srpt: Convert I/O path to target_submit_cmd + drop legacy ioctx->kref
Date: Wed, 28 Nov 2012 19:31:21 +0000
Message-ID: <1354131082-17884-2-git-send-email-nab@linux-iscsi.org>
References: <1354131082-17884-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1354131082-17884-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the main srpt_handle_cmd() I/O path to use modern
target_submit_cmd() with TARGET_SCF_ACK_KREF flag usage.  This includes
dropping the original internal ioctx->kref + srpt_put_send_ioctx() usage
in favor of target_put_sess_cmd() w/ se_cmd_t->cmd_kref within ib_srpt
response callbacks.

It also updates srpt_abort_cmd() to call target_put_sess_cmd() for
completion of aborted commands, and adds target_wait_for_sess_cmds() into
srpt_release_channel_work() to allow outstanding I/O to complete during
session shutdown.

Also, go ahead and update srpt_handle_tsk_mgmt() to make the remaining
transport_init_se_cmd() to setup the ioctx->cmd with se_tmr_req.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |  122 ++++++++++++++-------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 -
 2 files changed, 52 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e6fafc6..77b6368 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1269,7 +1269,6 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 		return ioctx;
 
 	BUG_ON(ioctx->ch != ch);
-	kref_init(&ioctx->kref);
 	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
 	ioctx->n_rbuf = 0;
@@ -1291,39 +1290,6 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 }
 
 /**
- * srpt_put_send_ioctx() - Free up resources.
- */
-static void srpt_put_send_ioctx(struct srpt_send_ioctx *ioctx)
-{
-	struct srpt_rdma_ch *ch;
-	unsigned long flags;
-
-	BUG_ON(!ioctx);
-	ch = ioctx->ch;
-	BUG_ON(!ch);
-
-	WARN_ON(srpt_get_cmd_state(ioctx) != SRPT_STATE_DONE);
-
-	srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
-	transport_generic_free_cmd(&ioctx->cmd, 0);
-
-	if (ioctx->n_rbuf > 1) {
-		kfree(ioctx->rbufs);
-		ioctx->rbufs = NULL;
-		ioctx->n_rbuf = 0;
-	}
-
-	spin_lock_irqsave(&ch->spinlock, flags);
-	list_add(&ioctx->free_list, &ch->free_list);
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-}
-
-static void srpt_put_send_ioctx_kref(struct kref *kref)
-{
-	srpt_put_send_ioctx(container_of(kref, struct srpt_send_ioctx, kref));
-}
-
-/**
  * srpt_abort_cmd() - Abort a SCSI command.
  * @ioctx:   I/O context associated with the SCSI command.
  * @context: Preferred execution context.
@@ -1359,8 +1325,14 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 	}
 	spin_unlock_irqrestore(&ioctx->spinlock, flags);
 
-	if (state == SRPT_STATE_DONE)
+	if (state == SRPT_STATE_DONE) {
+		struct srpt_rdma_ch *ch = ioctx->ch;
+
+		BUG_ON(ch->sess == NULL);
+
+		target_put_sess_cmd(ch->sess, &ioctx->cmd);
 		goto out;
+	}
 
 	pr_debug("Aborting cmd with state %d and tag %lld\n", state,
 		 ioctx->tag);
@@ -1395,11 +1367,11 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		spin_lock_irqsave(&ioctx->cmd.t_state_lock, flags);
 		ioctx->cmd.transport_state |= CMD_T_LUN_STOP;
 		spin_unlock_irqrestore(&ioctx->cmd.t_state_lock, flags);
-		kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
+		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 		break;
 	case SRPT_STATE_MGMT_RSP_SENT:
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
-		kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
+		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 		break;
 	default:
 		WARN_ON("ERROR: unexpected command state");
@@ -1457,11 +1429,13 @@ static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
 		    && state != SRPT_STATE_DONE))
 		pr_debug("state = %d\n", state);
 
-	if (state != SRPT_STATE_DONE)
-		kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
-	else
+	if (state != SRPT_STATE_DONE) {
+		srpt_unmap_sg_to_ib_sge(ch, ioctx);
+		transport_generic_free_cmd(&ioctx->cmd, 0);
+	} else {
 		printk(KERN_ERR "IB completion has been received too late for"
 		       " wr_id = %u.\n", ioctx->ioctx.index);
+	}
 }
 
 /**
@@ -1712,10 +1686,10 @@ out_err:
 
 static int srpt_check_stop_free(struct se_cmd *cmd)
 {
-	struct srpt_send_ioctx *ioctx;
+	struct srpt_send_ioctx *ioctx = container_of(cmd,
+				struct srpt_send_ioctx, cmd);
 
-	ioctx = container_of(cmd, struct srpt_send_ioctx, cmd);
-	return kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
+	return target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 }
 
 /**
@@ -1731,11 +1705,11 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 	u64 data_len;
 	enum dma_data_direction dir;
 	sense_reason_t ret;
+	int rc;
 
 	BUG_ON(!send_ioctx);
 
 	srp_cmd = recv_ioctx->ioctx.buf;
-	kref_get(&send_ioctx->kref);
 	cmd = &send_ioctx->cmd;
 	send_ioctx->tag = srp_cmd->tag;
 
@@ -1759,30 +1733,18 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		printk(KERN_ERR "0x%llx: parsing SRP descriptor table failed.\n",
 		       srp_cmd->tag);
 		ret = TCM_INVALID_CDB_FIELD;
-		kref_put(&send_ioctx->kref, srpt_put_send_ioctx_kref);
 		goto send_sense;
 	}
 
-	cmd->data_length = data_len;
-	cmd->data_direction = dir;
 	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_cmd->lun,
 				       sizeof(srp_cmd->lun));
-	ret = transport_lookup_cmd_lun(cmd, unpacked_lun);
-	if (ret) {
-		kref_put(&send_ioctx->kref, srpt_put_send_ioctx_kref);
+	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
+			&send_ioctx->sense_data[0], unpacked_lun, data_len,
+			MSG_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
+	if (rc != 0) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto send_sense;
 	}
-	ret = target_setup_cmd_from_cdb(cmd, srp_cmd->cdb);
-	if (ret) {
-		kref_put(&send_ioctx->kref, srpt_put_send_ioctx_kref);
-		if (ret == TCM_RESERVATION_CONFLICT) {
-			srpt_queue_status(cmd);
-			return 0;
-		}
-		goto send_sense;
-	}
-
-	transport_handle_cdb_direct(cmd);
 	return 0;
 
 send_sense:
@@ -1884,6 +1846,9 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		goto fail;
 	}
+	transport_init_se_cmd(&send_ioctx->cmd, &srpt_target->tf_ops, ch->sess,
+			0, DMA_NONE, MSG_SIMPLE_TAG, send_ioctx->sense_data);
+
 	res = core_tmr_alloc_req(cmd, NULL, tcm_tmr, GFP_KERNEL);
 	if (res < 0) {
 		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
@@ -1902,11 +1867,9 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	if (srp_tsk->tsk_mgmt_func == SRP_TSK_ABORT_TASK)
 		srpt_rx_mgmt_fn_tag(send_ioctx, srp_tsk->task_tag);
 
-	kref_get(&send_ioctx->kref);
 	transport_generic_handle_tmr(&send_ioctx->cmd);
 	return;
 fail:
-	kref_get(&send_ioctx->kref);
 	transport_send_check_condition_and_sense(cmd, 0, 0); // XXX:
 }
 
@@ -1949,10 +1912,6 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		}
 	}
 
-	transport_init_se_cmd(&send_ioctx->cmd, &srpt_target->tf_ops, ch->sess,
-			      0, DMA_NONE, MSG_SIMPLE_TAG,
-			      send_ioctx->sense_data);
-
 	switch (srp_cmd->opcode) {
 	case SRP_CMD:
 		srpt_handle_cmd(ch, recv_ioctx, send_ioctx);
@@ -2358,6 +2317,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 {
 	struct srpt_rdma_ch *ch;
 	struct srpt_device *sdev;
+	struct se_session *se_sess;
 
 	ch = container_of(w, struct srpt_rdma_ch, release_work);
 	pr_debug("ch = %p; ch->sess = %p; release_done = %p\n", ch, ch->sess,
@@ -2366,8 +2326,13 @@ static void srpt_release_channel_work(struct work_struct *w)
 	sdev = ch->sport->sdev;
 	BUG_ON(!sdev);
 
-	transport_deregister_session_configfs(ch->sess);
-	transport_deregister_session(ch->sess);
+	se_sess = ch->sess;
+	BUG_ON(!se_sess);
+
+	target_wait_for_sess_cmds(se_sess, 0);
+
+	transport_deregister_session_configfs(se_sess);
+	transport_deregister_session(se_sess);
 	ch->sess = NULL;
 
 	srpt_destroy_ch_ib(ch);
@@ -3092,7 +3057,7 @@ static int srpt_queue_response(struct se_cmd *cmd)
 		       ioctx->tag);
 		srpt_unmap_sg_to_ib_sge(ch, ioctx);
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
-		kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
+		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 	}
 
 out:
@@ -3483,6 +3448,23 @@ static u32 srpt_tpg_get_inst_index(struct se_portal_group *se_tpg)
 
 static void srpt_release_cmd(struct se_cmd *se_cmd)
 {
+	struct srpt_send_ioctx *ioctx = container_of(se_cmd,
+				struct srpt_send_ioctx, cmd);
+	struct srpt_rdma_ch *ch = ioctx->ch;
+	unsigned long flags;
+
+	WARN_ON(ioctx->state != SRPT_STATE_DONE);
+	WARN_ON(ioctx->mapped_sg_count != 0);
+
+	if (ioctx->n_rbuf > 1) {
+		kfree(ioctx->rbufs);
+		ioctx->rbufs = NULL;
+		ioctx->n_rbuf = 0;
+	}
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	list_add(&ioctx->free_list, &ch->free_list);
+	spin_unlock_irqrestore(&ch->spinlock, flags);
 }
 
 /**
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 61e52b8..4caf55c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -228,7 +228,6 @@ struct srpt_recv_ioctx {
 struct srpt_send_ioctx {
 	struct srpt_ioctx	ioctx;
 	struct srpt_rdma_ch	*ch;
-	struct kref		 kref;
 	struct rdma_iu		*rdma_ius;
 	struct srp_direct_buf	*rbufs;
 	struct srp_direct_buf	single_rbuf;
-- 
1.7.2.5
