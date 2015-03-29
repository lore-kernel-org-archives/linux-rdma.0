From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 07/18] iser-target: Remove redundant casting on void pointers
Date: Sun, 29 Mar 2015 15:52:09 +0300
Message-ID: <1427633540-30352-8-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

No need to cast void pointers.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   32 +++++++++++++++---------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index ae09561..1b13337 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -76,7 +76,7 @@ isert_prot_cmd(struct isert_conn *conn, struct se_cmd *cmd)
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)context;
+	struct isert_conn *isert_conn = context;
 
 	isert_err("conn %p event: %d\n", isert_conn, e->event);
 	switch (e->event) {
@@ -1200,7 +1200,7 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 static struct iscsi_cmd
 *isert_allocate_cmd(struct iscsi_conn *conn)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct isert_cmd *isert_cmd;
 	struct iscsi_cmd *cmd;
 
@@ -2085,7 +2085,7 @@ static int
 isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 	struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)
 				&isert_cmd->tx_desc.iscsi_header;
@@ -2134,7 +2134,7 @@ static void
 isert_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct isert_device *device = isert_conn->conn_device;
 
 	spin_lock_bh(&conn->cmd_lock);
@@ -2151,7 +2151,7 @@ isert_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 static enum target_prot_op
 isert_get_sup_prot_ops(struct iscsi_conn *conn)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct isert_device *device = isert_conn->conn_device;
 
 	if (conn->tpg->tpg_attrib.t10_pi) {
@@ -2173,7 +2173,7 @@ isert_put_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		bool nopout_response)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
@@ -2192,7 +2192,7 @@ static int
 isert_put_logout_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
@@ -2210,7 +2210,7 @@ static int
 isert_put_tm_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 
 	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
@@ -2228,7 +2228,7 @@ static int
 isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 	struct isert_device *device = isert_conn->conn_device;
 	struct ib_device *ib_dev = device->ib_device;
@@ -2261,7 +2261,7 @@ static int
 isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 	struct iscsi_text_rsp *hdr =
 		(struct iscsi_text_rsp *)&isert_cmd->tx_desc.iscsi_header;
@@ -2352,7 +2352,7 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct isert_data_buf *data = &wr->data;
 	struct ib_send_wr *send_wr;
 	struct ib_sge *ib_sge;
@@ -2836,7 +2836,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct isert_device *device = isert_conn->conn_device;
 	struct ib_send_wr *wr_failed;
 	int rc;
@@ -2886,7 +2886,7 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	struct isert_device *device = isert_conn->conn_device;
 	struct ib_send_wr *wr_failed;
 	int rc;
@@ -3074,7 +3074,7 @@ isert_rdma_accept(struct isert_conn *isert_conn)
 static int
 isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 {
-	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
+	struct isert_conn *isert_conn = conn->context;
 	int ret;
 
 	isert_info("before login_req comp conn: %p\n", isert_conn);
@@ -3144,7 +3144,7 @@ isert_set_conn_info(struct iscsi_np *np, struct iscsi_conn *conn,
 static int
 isert_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
 {
-	struct isert_np *isert_np = (struct isert_np *)np->np_context;
+	struct isert_np *isert_np = np->np_context;
 	struct isert_conn *isert_conn;
 	int max_accept = 0, ret;
 
@@ -3191,7 +3191,7 @@ accept_wait:
 static void
 isert_free_np(struct iscsi_np *np)
 {
-	struct isert_np *isert_np = (struct isert_np *)np->np_context;
+	struct isert_np *isert_np = np->np_context;
 	struct isert_conn *isert_conn, *n;
 
 	if (isert_np->np_cm_id)
-- 
1.7.1
