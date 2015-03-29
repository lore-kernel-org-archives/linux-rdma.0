From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/18] IB/iser: Handle fastreg/local_inv completion errors
Date: Sun, 29 Mar 2015 15:45:16 +0300
Message-ID: <1427633132-23910-3-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fast registration and local invalidate work requests can
also fail. We should call error completion handler for them.

Reported-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 070c5af..7ee4926 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1210,6 +1210,9 @@ iser_handle_comp_error(struct ib_conn *ib_conn,
 			iscsi_conn_failure(iser_conn->iscsi_conn,
 					   ISCSI_ERR_CONN_FAILED);
 
+	if (wc->wr_id == ISER_FASTREG_LI_WRID)
+		return;
+
 	if (is_iser_tx_desc(iser_conn, wr_id)) {
 		struct iser_tx_desc *desc = wr_id;
 
@@ -1254,13 +1257,11 @@ static void iser_handle_wc(struct ib_wc *wc)
 		else
 			iser_dbg("flush error: wr id %llx\n", wc->wr_id);
 
-		if (wc->wr_id != ISER_FASTREG_LI_WRID &&
-		    wc->wr_id != ISER_BEACON_WRID)
-			iser_handle_comp_error(ib_conn, wc);
-
-		/* complete in case all flush errors were consumed */
 		if (wc->wr_id == ISER_BEACON_WRID)
+			/* all flush errors were consumed */
 			complete(&ib_conn->flush_comp);
+		else
+			iser_handle_comp_error(ib_conn, wc);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
