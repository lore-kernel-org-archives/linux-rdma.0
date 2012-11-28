From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] ib_srpt: Convert TMR path to target_submit_tmr
Date: Wed, 28 Nov 2012 19:31:22 +0000
Message-ID: <1354131082-17884-3-git-send-email-nab@linux-iscsi.org>
References: <1354131082-17884-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1354131082-17884-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the TMR path in srpt_handle_tsk_mgmt() to use
target_submit_tmr() with TARGET_SCF_ACK_KREF flag usage.

v2: Drop ununused res in target_submit_tmr (Fengguang.Wu)

Cc: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   37 ++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 77b6368..c09d41b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1825,9 +1825,11 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 {
 	struct srp_tsk_mgmt *srp_tsk;
 	struct se_cmd *cmd;
+	struct se_session *sess = ch->sess;
 	uint64_t unpacked_lun;
+	uint32_t tag = 0;
 	int tcm_tmr;
-	int res;
+	int rc;
 
 	BUG_ON(!send_ioctx);
 
@@ -1846,28 +1848,25 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		goto fail;
 	}
-	transport_init_se_cmd(&send_ioctx->cmd, &srpt_target->tf_ops, ch->sess,
-			0, DMA_NONE, MSG_SIMPLE_TAG, send_ioctx->sense_data);
-
-	res = core_tmr_alloc_req(cmd, NULL, tcm_tmr, GFP_KERNEL);
-	if (res < 0) {
-		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
-		goto fail;
-	}
-
 	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_tsk->lun,
 				       sizeof(srp_tsk->lun));
-	res = transport_lookup_tmr_lun(&send_ioctx->cmd, unpacked_lun);
-	if (res) {
-		pr_debug("rejecting TMR for LUN %lld\n", unpacked_lun);
-		send_ioctx->cmd.se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
+
+	if (srp_tsk->tsk_mgmt_func == SRP_TSK_ABORT_TASK) {
+		rc = srpt_rx_mgmt_fn_tag(send_ioctx, srp_tsk->task_tag);
+		if (rc < 0) {
+			send_ioctx->cmd.se_tmr_req->response =
+					TMR_TASK_DOES_NOT_EXIST;
+			goto fail;
+		}
+		tag = srp_tsk->task_tag;
+	}
+	rc = target_submit_tmr(&send_ioctx->cmd, sess, NULL, unpacked_lun,
+				srp_tsk, tcm_tmr, GFP_KERNEL, tag,
+				TARGET_SCF_ACK_KREF);
+	if (rc != 0) {
+		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
 		goto fail;
 	}
-
-	if (srp_tsk->tsk_mgmt_func == SRP_TSK_ABORT_TASK)
-		srpt_rx_mgmt_fn_tag(send_ioctx, srp_tsk->task_tag);
-
-	transport_generic_handle_tmr(&send_ioctx->cmd);
 	return;
 fail:
 	transport_send_check_condition_and_sense(cmd, 0, 0); // XXX:
-- 
1.7.2.5
