From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 11/12] IB/isert: Accept RDMA_WRITE completions
Date: Sun, 16 Feb 2014 19:38:16 +0200
Message-ID: <1392572297-5333-12-git-send-email-sagig@mellanox.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In case of protected transactions, we will need to check the
protection status of the transaction before sending SCSI response.
So be ready for RDMA_WRITE completions. currently we don't ask
for these completions, but for T10-PI we will.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 64d5f06..50c7948 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -51,6 +51,8 @@ isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
 isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr);
+static int
+isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd);
 
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
@@ -1652,6 +1654,18 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 }
 
 static void
+isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
+			    struct isert_cmd *isert_cmd)
+{
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
+	struct isert_conn *isert_conn = isert_cmd->conn;
+	struct isert_device *device = isert_conn->conn_device;
+
+	device->unreg_rdma_mem(isert_cmd, isert_conn);
+	isert_put_response(isert_conn->conn, cmd);
+}
+
+static void
 isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 			   struct isert_cmd *isert_cmd)
 {
@@ -1771,8 +1785,9 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
 					  isert_conn, ib_dev);
 		break;
 	case ISER_IB_RDMA_WRITE:
-		pr_err("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
-		dump_stack();
+		pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
+		atomic_dec(&isert_conn->post_send_buf_count);
+		isert_completion_rdma_write(tx_desc, isert_cmd);
 		break;
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
