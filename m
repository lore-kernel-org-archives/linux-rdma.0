From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 07/21] IB/srpt: Use scsilun_to_int()
Date: Thu, 4 Feb 2016 14:48:57 -0800
Message-ID: <56B3D559.6080906@sandisk.com>
References: <56B3D453.7030409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B3D453.7030409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just like other target drivers, use scsilun_to_int() to unpack SCSI
LUN numbers. This patch only changes the behavior of ib_srpt for LUN
numbers >= 16384.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 92 +++--------------------------------
 1 file changed, 7 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c50f05c..0128040 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1494,80 +1494,6 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 	return resp_len;
 }
 
-#define NO_SUCH_LUN ((uint64_t)-1LL)
-
-/*
- * SCSI LUN addressing method. See also SAM-2 and the section about
- * eight byte LUNs.
- */
-enum scsi_lun_addr_method {
-	SCSI_LUN_ADDR_METHOD_PERIPHERAL   = 0,
-	SCSI_LUN_ADDR_METHOD_FLAT         = 1,
-	SCSI_LUN_ADDR_METHOD_LUN          = 2,
-	SCSI_LUN_ADDR_METHOD_EXTENDED_LUN = 3,
-};
-
-/*
- * srpt_unpack_lun() - Convert from network LUN to linear LUN.
- *
- * Convert an 2-byte, 4-byte, 6-byte or 8-byte LUN structure in network byte
- * order (big endian) to a linear LUN. Supports three LUN addressing methods:
- * peripheral, flat and logical unit. See also SAM-2, section 4.9.4 (page 40).
- */
-static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
-{
-	uint64_t res = NO_SUCH_LUN;
-	int addressing_method;
-
-	if (unlikely(len < 2)) {
-		pr_err("Illegal LUN length %d, expected 2 bytes or more\n",
-		       len);
-		goto out;
-	}
-
-	switch (len) {
-	case 8:
-		if ((*((__be64 *)lun) &
-		     cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
-			goto out_err;
-		break;
-	case 4:
-		if (*((__be16 *)&lun[2]) != 0)
-			goto out_err;
-		break;
-	case 6:
-		if (*((__be32 *)&lun[2]) != 0)
-			goto out_err;
-		break;
-	case 2:
-		break;
-	default:
-		goto out_err;
-	}
-
-	addressing_method = (*lun) >> 6; /* highest two bits of byte 0 */
-	switch (addressing_method) {
-	case SCSI_LUN_ADDR_METHOD_PERIPHERAL:
-	case SCSI_LUN_ADDR_METHOD_FLAT:
-	case SCSI_LUN_ADDR_METHOD_LUN:
-		res = *(lun + 1) | (((*lun) & 0x3f) << 8);
-		break;
-
-	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
-	default:
-		pr_err("Unimplemented LUN addressing method %u\n",
-		       addressing_method);
-		break;
-	}
-
-out:
-	return res;
-
-out_err:
-	pr_err("Support for multi-level LUNs has not yet been implemented\n");
-	goto out;
-}
-
 static int srpt_check_stop_free(struct se_cmd *cmd)
 {
 	struct srpt_send_ioctx *ioctx = container_of(cmd,
@@ -1585,7 +1511,6 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 {
 	struct se_cmd *cmd;
 	struct srp_cmd *srp_cmd;
-	uint64_t unpacked_lun;
 	u64 data_len;
 	enum dma_data_direction dir;
 	sense_reason_t ret;
@@ -1620,11 +1545,10 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto send_sense;
 	}
 
-	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_cmd->lun,
-				       sizeof(srp_cmd->lun));
 	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
-			&send_ioctx->sense_data[0], unpacked_lun, data_len,
-			TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
+			       &send_ioctx->sense_data[0],
+			       scsilun_to_int(&srp_cmd->lun), data_len,
+			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto send_sense;
@@ -1669,7 +1593,6 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	struct srp_tsk_mgmt *srp_tsk;
 	struct se_cmd *cmd;
 	struct se_session *sess = ch->sess;
-	uint64_t unpacked_lun;
 	int tcm_tmr;
 	int rc;
 
@@ -1685,11 +1608,10 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	srpt_set_cmd_state(send_ioctx, SRPT_STATE_MGMT);
 	send_ioctx->cmd.tag = srp_tsk->tag;
 	tcm_tmr = srp_tmr_to_tcm(srp_tsk->tsk_mgmt_func);
-	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_tsk->lun,
-				       sizeof(srp_tsk->lun));
-	rc = target_submit_tmr(&send_ioctx->cmd, sess, NULL, unpacked_lun,
-				srp_tsk, tcm_tmr, GFP_KERNEL, srp_tsk->task_tag,
-				TARGET_SCF_ACK_KREF);
+	rc = target_submit_tmr(&send_ioctx->cmd, sess, NULL,
+			       scsilun_to_int(&srp_tsk->lun), srp_tsk, tcm_tmr,
+			       GFP_KERNEL, srp_tsk->task_tag,
+			       TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
 		goto fail;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
