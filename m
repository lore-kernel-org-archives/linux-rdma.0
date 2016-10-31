From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] iscsi-target: Propigate queue_data_in + queue_status errors
Date: Mon, 31 Oct 2016 05:25:53 +0000
Message-ID: <1477891554-26222-3-git-send-email-nab@linux-iscsi.org>
References: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>, Steve Wise <swise@opengridcomputing.com>, Sagi Grimberg <sagi@grimberg.me>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes iscsi-target to propagate iscsit_transport
->iscsit_queue_data_in() and ->iscsit_queue_status() callback
errors, back up into target-core.

This allows target-core to retry failed iscsit_transport
callbacks using internal queue-full logic.

Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>
Reported-by: Steve Wise <swise@opengridcomputing.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c          |  3 +--
 drivers/target/iscsi/iscsi_target_configfs.c | 13 +++++--------
 drivers/target/iscsi/iscsi_target_util.c     |  5 +++--
 drivers/target/iscsi/iscsi_target_util.h     |  2 +-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b7d747e..1b03e85 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -482,8 +482,7 @@ int iscsit_del_np(struct iscsi_np *np)
 
 int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
-	iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
-	return 0;
+	return iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
 }
 EXPORT_SYMBOL(iscsit_queue_rsp);
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 923c032..38a72d3 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1395,11 +1395,10 @@ static u32 lio_sess_get_initiator_sid(
 static int lio_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+	struct iscsi_conn *conn = cmd->conn;
 
 	cmd->i_state = ISTATE_SEND_DATAIN;
-	cmd->conn->conn_transport->iscsit_queue_data_in(cmd->conn, cmd);
-
-	return 0;
+	return conn->conn_transport->iscsit_queue_data_in(conn, cmd);
 }
 
 static int lio_write_pending(struct se_cmd *se_cmd)
@@ -1428,16 +1427,14 @@ static int lio_write_pending_status(struct se_cmd *se_cmd)
 static int lio_queue_status(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+	struct iscsi_conn *conn = cmd->conn;
 
 	cmd->i_state = ISTATE_SEND_STATUS;
 
 	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
-		iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
-		return 0;
+		return iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 	}
-	cmd->conn->conn_transport->iscsit_queue_status(cmd->conn, cmd);
-
-	return 0;
+	return conn->conn_transport->iscsit_queue_status(conn, cmd);
 }
 
 static void lio_queue_tm_rsp(struct se_cmd *se_cmd)
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1f38177..eb9c49a 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -565,7 +565,7 @@ static void iscsit_remove_cmd_from_immediate_queue(
 	}
 }
 
-void iscsit_add_cmd_to_response_queue(
+int iscsit_add_cmd_to_response_queue(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn,
 	u8 state)
@@ -576,7 +576,7 @@ void iscsit_add_cmd_to_response_queue(
 	if (!qr) {
 		pr_err("Unable to allocate memory for"
 			" struct iscsi_queue_req\n");
-		return;
+		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
 	qr->cmd = cmd;
@@ -588,6 +588,7 @@ void iscsit_add_cmd_to_response_queue(
 	spin_unlock_bh(&conn->response_queue_lock);
 
 	wake_up(&conn->queues_wq);
+	return 0;
 }
 
 struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsi_conn *conn)
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 995f1cb..d96ec7d 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -23,7 +23,7 @@ extern int iscsit_find_cmd_for_recovery(struct iscsi_session *, struct iscsi_cmd
 			struct iscsi_conn_recovery **, itt_t);
 extern void iscsit_add_cmd_to_immediate_queue(struct iscsi_cmd *, struct iscsi_conn *, u8);
 extern struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsi_conn *);
-extern void iscsit_add_cmd_to_response_queue(struct iscsi_cmd *, struct iscsi_conn *, u8);
+extern int iscsit_add_cmd_to_response_queue(struct iscsi_cmd *, struct iscsi_conn *, u8);
 extern struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsi_conn *);
 extern void iscsit_remove_cmd_from_tx_queues(struct iscsi_cmd *, struct iscsi_conn *);
 extern bool iscsit_conn_all_queues_empty(struct iscsi_conn *);
-- 
1.9.1
