From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/12] iser-target: Add new state ISER_CONN_BOUND to isert_conn
Date: Wed, 24 Feb 2016 19:23:59 +0200
Message-ID: <1456334649-21437-3-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We need an indication that isert_conn->iscsi_conn binding has
happened so we'll know not to invoke a connection reinstatement
on an unbound connection which will lead to a bogus isert_conn->conn
dereferece.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 7 +++++--
 drivers/infiniband/ulp/isert/ib_isert.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 09ded3c704e5..320d3a55249c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -825,7 +825,7 @@ isert_put_conn(struct isert_conn *isert_conn)
  * @isert_conn: isert connection struct
  *
  * Notes:
- * In case the connection state is FULL_FEATURE, move state
+ * In case the connection state is BOUND, move state
  * to TEMINATING and start teardown sequence (rdma_disconnect).
  * In case the connection state is UP, complete flush as well.
  *
@@ -841,6 +841,7 @@ isert_conn_terminate(struct isert_conn *isert_conn)
 	case ISER_CONN_TERMINATING:
 		break;
 	case ISER_CONN_UP:
+	case ISER_CONN_BOUND:
 	case ISER_CONN_FULL_FEATURE: /* FALLTHRU */
 		isert_info("Terminating conn %p state %d\n",
 			   isert_conn, isert_conn->state);
@@ -2075,7 +2076,8 @@ isert_cq_comp_err(struct isert_conn *isert_conn, struct ib_wc *wc)
 			isert_completion_put(desc, isert_cmd, ib_dev, true);
 	} else {
 		isert_conn->post_recv_buf_count--;
-		if (!isert_conn->post_recv_buf_count)
+		if (!isert_conn->post_recv_buf_count &&
+		    isert_conn->state >= ISER_CONN_BOUND)
 			iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
 	}
 }
@@ -3215,6 +3217,7 @@ accept_wait:
 
 	conn->context = isert_conn;
 	isert_conn->conn = conn;
+	isert_conn->state = ISER_CONN_BOUND;
 
 	isert_set_conn_info(np, conn, isert_conn);
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 8d50453eef66..b80ec44fb4e1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -84,6 +84,7 @@ enum iser_ib_op_code {
 enum iser_conn_state {
 	ISER_CONN_INIT,
 	ISER_CONN_UP,
+	ISER_CONN_BOUND,
 	ISER_CONN_FULL_FEATURE,
 	ISER_CONN_TERMINATING,
 	ISER_CONN_DOWN,
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
