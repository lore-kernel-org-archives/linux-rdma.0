From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] ib_isert: Add support for completion interrupt coalescing
Date: Wed,  6 Nov 2013 20:32:07 +0000
Message-ID: <1383769927-29870-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Kent Overstreet <kmo@daterainc.com>, Roland Dreier <roland@purestorage.com>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for completion interrupt coalescing that
allows only every ISERT_COMP_BATCH_COUNT (8) to set IB_SEND_SIGNALED,
thus avoiding completion interrupts for every posted iser_tx_desc.

The batch processing is done using a per isert_conn llist that once
IB_SEND_SIGNALED has been set is saved to tx_desc->comp_llnode_batch,
and completion processing of previously posted iser_tx_descs is done
in a single shot from within isert_send_completion() code.

Note this is only done for response PDUs from ISCSI_OP_SCSI_CMD, and
all other control type of PDU responses will force an implicit batch
drain to occur.

Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   63 +++++++++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h |    6 +++
 2 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3591855..27708c3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -22,6 +22,7 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/llist.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
 #include <target/target_core_base.h>
@@ -489,6 +490,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	kref_init(&isert_conn->conn_kref);
 	kref_get(&isert_conn->conn_kref);
 	mutex_init(&isert_conn->conn_mutex);
+	mutex_init(&isert_conn->conn_comp_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
 
 	cma_id->context = isert_conn;
@@ -843,14 +845,32 @@ isert_init_tx_hdrs(struct isert_conn *isert_conn,
 }
 
 static void
-isert_init_send_wr(struct isert_cmd *isert_cmd, struct ib_send_wr *send_wr)
+isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
+		   struct ib_send_wr *send_wr, bool coalesce)
 {
+	struct iser_tx_desc *tx_desc = &isert_cmd->tx_desc;
+
 	isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;
 	send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
 	send_wr->opcode = IB_WR_SEND;
-	send_wr->send_flags = IB_SEND_SIGNALED;
-	send_wr->sg_list = &isert_cmd->tx_desc.tx_sg[0];
+	send_wr->sg_list = &tx_desc->tx_sg[0];
 	send_wr->num_sge = isert_cmd->tx_desc.num_sge;
+	/*
+	 * Coalesce send completion interrupts by only setting IB_SEND_SIGNALED
+	 * bit for every ISERT_COMP_BATCH_COUNT number of ib_post_send() calls.
+	 */
+	mutex_lock(&isert_conn->conn_comp_mutex);
+	if (coalesce &&
+	    ++isert_conn->conn_comp_batch < ISERT_COMP_BATCH_COUNT) {
+		llist_add(&tx_desc->comp_llnode, &isert_conn->conn_comp_llist);
+		mutex_unlock(&isert_conn->conn_comp_mutex);
+		return;
+	}
+	isert_conn->conn_comp_batch = 0;
+	tx_desc->comp_llnode_batch = llist_del_all(&isert_conn->conn_comp_llist);
+	mutex_unlock(&isert_conn->conn_comp_mutex);
+
+	send_wr->send_flags = IB_SEND_SIGNALED;
 }
 
 static int
@@ -1582,8 +1602,8 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 }
 
 static void
-isert_send_completion(struct iser_tx_desc *tx_desc,
-		      struct isert_conn *isert_conn)
+__isert_send_completion(struct iser_tx_desc *tx_desc,
+		        struct isert_conn *isert_conn)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
@@ -1624,6 +1644,24 @@ isert_send_completion(struct iser_tx_desc *tx_desc,
 }
 
 static void
+isert_send_completion(struct iser_tx_desc *tx_desc,
+		      struct isert_conn *isert_conn)
+{
+	struct llist_node *llnode = tx_desc->comp_llnode_batch;
+	struct iser_tx_desc *t;
+	/*
+	 * Drain coalesced completion llist starting from comp_llnode_batch
+	 * setup in isert_init_send_wr(), and then complete trailing tx_desc.
+	 */
+	while (llnode) {
+		t = llist_entry(llnode, struct iser_tx_desc, comp_llnode);
+		llnode = llist_next(llnode);
+		__isert_send_completion(t, isert_conn);
+	}
+	__isert_send_completion(tx_desc, isert_conn);
+}
+
+static void
 isert_cq_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
@@ -1793,7 +1831,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
-	isert_init_send_wr(isert_cmd, send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
 
 	pr_debug("Posting SCSI Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -1813,7 +1851,7 @@ isert_put_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 			       &isert_cmd->tx_desc.iscsi_header,
 			       nopout_response);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-	isert_init_send_wr(isert_cmd, send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting NOPIN Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -1831,7 +1869,7 @@ isert_put_logout_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	iscsit_build_logout_rsp(cmd, conn, (struct iscsi_logout_rsp *)
 				&isert_cmd->tx_desc.iscsi_header);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-	isert_init_send_wr(isert_cmd, send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting Logout Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -1849,7 +1887,7 @@ isert_put_tm_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	iscsit_build_task_mgt_rsp(cmd, conn, (struct iscsi_tm_rsp *)
 				  &isert_cmd->tx_desc.iscsi_header);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-	isert_init_send_wr(isert_cmd, send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting Task Management Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -1881,7 +1919,7 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	tx_dsg->lkey	= isert_conn->conn_mr->lkey;
 	isert_cmd->tx_desc.num_sge = 2;
 
-	isert_init_send_wr(isert_cmd, send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting Reject IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -1921,7 +1959,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 		tx_dsg->lkey	= isert_conn->conn_mr->lkey;
 		isert_cmd->tx_desc.num_sge = 2;
 	}
-	isert_init_send_wr(isert_cmd, send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting Text Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -2309,7 +2347,8 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
 			     &isert_cmd->tx_desc.iscsi_header);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-	isert_init_send_wr(isert_cmd, &isert_cmd->tx_desc.send_wr);
+	isert_init_send_wr(isert_conn, isert_cmd,
+			   &isert_cmd->tx_desc.send_wr, true);
 
 	atomic_inc(&isert_conn->post_send_buf_count);
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 631f209..691f90f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -43,6 +43,8 @@ struct iser_tx_desc {
 	struct ib_sge	tx_sg[2];
 	int		num_sge;
 	struct isert_cmd *isert_cmd;
+	struct llist_node *comp_llnode_batch;
+	struct llist_node comp_llnode;
 	struct ib_send_wr send_wr;
 } __packed;
 
@@ -121,6 +123,10 @@ struct isert_conn {
 	int			conn_frwr_pool_size;
 	/* lock to protect frwr_pool */
 	spinlock_t		conn_lock;
+#define ISERT_COMP_BATCH_COUNT	8
+	int			conn_comp_batch;
+	struct llist_head	conn_comp_llist;
+	struct mutex		conn_comp_mutex;
 };
 
 #define ISERT_MAX_CQ 64
-- 
1.7.10.4
