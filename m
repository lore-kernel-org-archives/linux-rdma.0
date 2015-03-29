From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 11/18] iser-target: Rename rend/recv completion routines
Date: Sun, 29 Mar 2015 15:52:13 +0300
Message-ID: <1427633540-30352-12-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Make receive/send completion handling routines symmetrical.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 0bab74b..f015023 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1543,8 +1543,9 @@ isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
 }
 
 static void
-isert_rx_completion(struct iser_rx_desc *desc, struct isert_conn *isert_conn,
-		    u32 xfer_len)
+isert_rcv_completion(struct iser_rx_desc *desc,
+		     struct isert_conn *isert_conn,
+		     u32 xfer_len)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct iscsi_hdr *hdr;
@@ -1969,7 +1970,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 }
 
 static void
-isert_send_completion(struct iser_tx_desc *tx_desc,
+isert_snd_completion(struct iser_tx_desc *tx_desc,
 		      struct isert_conn *isert_conn)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
@@ -2061,10 +2062,10 @@ isert_handle_wc(struct ib_wc *wc)
 	if (likely(wc->status == IB_WC_SUCCESS)) {
 		if (wc->opcode == IB_WC_RECV) {
 			rx_desc = (struct iser_rx_desc *)(uintptr_t)wc->wr_id;
-			isert_rx_completion(rx_desc, isert_conn, wc->byte_len);
+			isert_rcv_completion(rx_desc, isert_conn, wc->byte_len);
 		} else {
 			tx_desc = (struct iser_tx_desc *)(uintptr_t)wc->wr_id;
-			isert_send_completion(tx_desc, isert_conn);
+			isert_snd_completion(tx_desc, isert_conn);
 		}
 	} else {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-- 
1.7.1
