From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [PATCH 3/3] iser-target: Fix queue-full response handling
Date: Mon, 31 Oct 2016 05:25:54 +0000
Message-ID: <1477891554-26222-4-git-send-email-nab@linux-iscsi.org>
References: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477891554-26222-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

This patch addresses two queue-full handling bugs in iser-target.

The first is propagating isert_rdma_rw_ctx_post() return back
to target-core via isert_put_datain() + isert_get_dataout()
callbacks, in order to trigger queue-full logic in target-core.
Note target-core expects -EAGAIN or -ENOMEM error to signal
RDMA WRITE/READ data-transfer callbacks should be retried,
after queue-full logic been invoked.

Other types of errors propagated up from RDMA RW API will result
in target-core generating internal CHECK_CONDITION status,
avoiding subsequent isert_put_datain() and isert_get_dataout()
iscsit_transport callback retry attempts.

The second is to use transport_generic_request_failure()
during T10-PI hw-offload errors in isert_rdma_write_done()
and isert_rdma_read_done(), so CHECK_CONDITION queue-full
is handled internally by target-core.

Also add isert_put_response() T10-PI failure case fixme in
isert_rdma_write_done(), which is currently not internally
retried or released until session reinstatement.

Reported-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 53 ++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f6..e658248 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1666,10 +1666,23 @@
 	ret = isert_check_pi_status(cmd, isert_cmd->rw.sig->sig_mr);
 	isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
 
-	if (ret)
-		transport_send_check_condition_and_sense(cmd, cmd->pi_err, 0);
-	else
-		isert_put_response(isert_conn->conn, isert_cmd->iscsi_cmd);
+	if (ret) {
+		/*
+		 * transport_generic_request_failure() expects to have
+		 * plus two references to handle queue-full, so re-add
+		 * one here as target-core will have already dropped
+		 * it after the first isert_put_datain() callback.
+		 */
+		kref_get(&cmd->cmd_kref);
+		transport_generic_request_failure(cmd, cmd->pi_err);
+	} else {
+		/*
+		 * XXX: isert_put_response() failure is not retried.
+		 */
+		ret = isert_put_response(isert_conn->conn, isert_cmd->iscsi_cmd);
+		if (ret)
+			pr_warn_ratelimited("isert_put_response() ret: %d\n", ret);
+	}
 }
 
 static void
@@ -1706,13 +1719,15 @@
 	cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
 	spin_unlock_bh(&cmd->istate_lock);
 
-	if (ret) {
-		target_put_sess_cmd(se_cmd);
-		transport_send_check_condition_and_sense(se_cmd,
-							 se_cmd->pi_err, 0);
-	} else {
+	/*
+	 * transport_generic_request_failure() will drop the extra
+	 * se_cmd->cmd_kref reference after T10-PI error, and handle
+	 * any non-zero ->queue_status() callback error retries.
+	 */
+	if (ret)
+		transport_generic_request_failure(se_cmd, se_cmd->pi_err);
+	else
 		target_execute_cmd(se_cmd);
-	}
 }
 
 static void
@@ -2172,26 +2187,28 @@
 		chain_wr = &isert_cmd->tx_desc.send_wr;
 	}
 
-	isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
-	isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ\n", isert_cmd);
-	return 1;
+	rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
+	isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ rc: %d\n",
+		  isert_cmd, rc);
+	return rc;
 }
 
 static int
 isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
+	int ret;
 
 	isert_dbg("Cmd: %p RDMA_READ data_length: %u write_data_done: %u\n",
 		 isert_cmd, cmd->se_cmd.data_length, cmd->write_data_done);
 
 	isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
-	isert_rdma_rw_ctx_post(isert_cmd, conn->context,
-			&isert_cmd->tx_desc.tx_cqe, NULL);
+	ret = isert_rdma_rw_ctx_post(isert_cmd, conn->context,
+				     &isert_cmd->tx_desc.tx_cqe, NULL);
 
-	isert_dbg("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
-		 isert_cmd);
-	return 0;
+	isert_dbg("Cmd: %p posted RDMA_READ memory for ISER Data WRITE rc: %d\n",
+		 isert_cmd, ret);
+	return ret;
 }
 
 static int
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
