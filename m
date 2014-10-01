From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/21] IB/iser: Signal iSCSI layer that transport is broken in error completions
Date: Wed,  1 Oct 2014 14:02:05 +0300
Message-ID: <1412161337-25285-10-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Previously we notified iscsi layer about the connection layer when
we consumed all of our flush errors. This was racy as there
was no guarentee that iscsi_conn wasn't terminated by then (which ends
up in an invalid memory access). In case we got a non FLUSH error
completion, we are guarenteed that iscsi_conn is still alive. We should
notify iSCSI layer with iscsi_conn_failure to initiate error handling.

While we are at it, add a nice kernel-doc style documentation.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6ce20fd..35f53a3 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1159,9 +1159,30 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 	return ib_ret;
 }
 
-static void iser_handle_comp_error(struct iser_tx_desc *desc,
-				   struct ib_conn *ib_conn)
+/**
+ * iser_handle_comp_error() - Handle error completion
+ * @desc:      iser TX descriptor
+ * @ib_conn:   connection RDMA resources
+ * @wc:        work completion
+ *
+ * Notes: We may handle a FLUSH error completion and in this case
+ *        we only cleanup in case TX type was DATAOUT. For non-FLUSH
+ *        error completion we should also notify iscsi layer that
+ *        connection is failed (in case we passed bind stage).
+ */
+static void
+iser_handle_comp_error(struct iser_tx_desc *desc,
+		       struct ib_conn *ib_conn,
+		       struct ib_wc *wc)
 {
+	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
+						   ib_conn);
+
+	if (wc->status != IB_WC_WR_FLUSH_ERR)
+		if (iser_conn->iscsi_conn)
+			iscsi_conn_failure(iser_conn->iscsi_conn,
+					   ISCSI_ERR_CONN_FAILED);
+
 	if (desc && desc->type == ISCSI_TX_DATAOUT)
 		kmem_cache_free(ig.desc_cache, desc);
 }
@@ -1188,7 +1209,7 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 				 wc.wr_id, wc.status, wc.vendor_err);
 			if (wc.wr_id != ISER_FASTREG_LI_WRID) {
 				atomic_dec(&ib_conn->post_send_buf_count);
-				iser_handle_comp_error(tx_desc, ib_conn);
+				iser_handle_comp_error(tx_desc, ib_conn, &wc);
 			}
 		}
 		completed_tx++;
@@ -1230,7 +1251,7 @@ static void iser_cq_tasklet_fn(unsigned long data)
 				iser_err("rx id %llx status %d vend_err %x\n",
 					wc.wr_id, wc.status, wc.vendor_err);
 			ib_conn->post_recv_buf_count--;
-			iser_handle_comp_error(NULL, ib_conn);
+			iser_handle_comp_error(NULL, ib_conn, &wc);
 		}
 		completed_rx++;
 		if (!(completed_rx & 63))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
