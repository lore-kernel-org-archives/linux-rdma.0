From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 11/21] IB/srpt: Fix srpt_handle_cmd() error paths
Date: Thu, 4 Feb 2016 14:51:13 -0800
Message-ID: <56B3D5E1.3030308@sandisk.com>
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

The target core function that should be called if target_submit_cmd()
fails is target_put_sess_cmd(). Additionally, change the return type
of srpt_handle_cmd() from int into void.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 88013ca..569820a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -91,6 +91,7 @@ MODULE_PARM_DESC(srpt_service_guid,
 		 " instead of using the node_guid of the first HCA.");
 
 static struct ib_client srpt_client;
+static void srpt_release_cmd(struct se_cmd *se_cmd);
 static void srpt_release_channel(struct srpt_rdma_ch *ch);
 static int srpt_queue_status(struct se_cmd *cmd);
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -1492,15 +1493,14 @@ static int srpt_check_stop_free(struct se_cmd *cmd)
 /**
  * srpt_handle_cmd() - Process SRP_CMD.
  */
-static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
-			   struct srpt_recv_ioctx *recv_ioctx,
-			   struct srpt_send_ioctx *send_ioctx)
+static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
+			    struct srpt_recv_ioctx *recv_ioctx,
+			    struct srpt_send_ioctx *send_ioctx)
 {
 	struct se_cmd *cmd;
 	struct srp_cmd *srp_cmd;
 	u64 data_len;
 	enum dma_data_direction dir;
-	sense_reason_t ret;
 	int rc;
 
 	BUG_ON(!send_ioctx);
@@ -1528,8 +1528,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 	if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
 		pr_err("0x%llx: parsing SRP descriptor table failed.\n",
 		       srp_cmd->tag);
-		ret = TCM_INVALID_CDB_FIELD;
-		goto send_sense;
+		goto release_ioctx;
 	}
 
 	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
@@ -1537,14 +1536,15 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			       scsilun_to_int(&srp_cmd->lun), data_len,
 			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
-		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		goto send_sense;
+		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
+			 srp_cmd->tag);
+		goto release_ioctx;
 	}
-	return 0;
+	return;
 
-send_sense:
-	transport_send_check_condition_and_sense(cmd, ret, 0);
-	return -1;
+release_ioctx:
+	send_ioctx->state = SRPT_STATE_DONE;
+	srpt_release_cmd(cmd);
 }
 
 static int srp_tmr_to_tcm(int fn)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
