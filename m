From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/16] IB/iser: Fix possible SQ overflow
Date: Sun,  7 Dec 2014 16:09:56 +0200
Message-ID: <1417961407-10139-6-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix a regression was introduced in commit 6df5a128f0fd.

The sig_count was wrongly set to be static variable, thus it is
possible that we won't reach to (sig_count % ISER_SIGNAL_BATCH) == 0
condition (due to races) and the send queue will be overflowed.

Instead keep sig_count per connection. We don't need it to be atomic
as we are safe under the iscsi session frwd_lock taken by libiscsi on
the queuecommand path.

Fixes: 6df5a128f0fd ('IB/iser: Suppress scsi command send completions')
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 ++
 drivers/infiniband/ulp/iser/iser_initiator.c |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 44d64b7..8a5663d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -437,6 +437,7 @@ struct fast_reg_descriptor {
  * @cma_id:              rdma_cm connection maneger handle
  * @qp:                  Connection Queue-pair
  * @post_recv_buf_count: post receive counter
+ * @sig_count:           send work request signal count
  * @rx_wr:               receive work request for batch posts
  * @device:              reference to iser device
  * @comp:                iser completion context
@@ -457,6 +458,7 @@ struct ib_conn {
 	struct rdma_cm_id           *cma_id;
 	struct ib_qp	            *qp;
 	int                          post_recv_buf_count;
+	u8                           sig_count;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 	struct iser_device          *device;
 	struct iser_comp	    *comp;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 5a489ea..3821633 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -369,7 +369,7 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 	return 0;
 }
 
-static inline bool iser_signal_comp(int sig_count)
+static inline bool iser_signal_comp(u8 sig_count)
 {
 	return ((sig_count % ISER_SIGNAL_CMD_COUNT) == 0);
 }
@@ -388,7 +388,7 @@ int iser_send_command(struct iscsi_conn *conn,
 	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)task->hdr;
 	struct scsi_cmnd *sc  =  task->sc;
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
-	static unsigned sig_count;
+	u8 sig_count = ++iser_conn->ib_conn.sig_count;
 
 	edtl = ntohl(hdr->data_length);
 
@@ -435,7 +435,7 @@ int iser_send_command(struct iscsi_conn *conn,
 	iser_task->status = ISER_TASK_STATUS_STARTED;
 
 	err = iser_post_send(&iser_conn->ib_conn, tx_desc,
-			     iser_signal_comp(++sig_count));
+			     iser_signal_comp(sig_count));
 	if (!err)
 		return 0;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
