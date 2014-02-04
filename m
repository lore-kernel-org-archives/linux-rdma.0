From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14] IB/iser: Avoid dereferncing iscsi_iser conn object when not bound to iser connection
Date: Tue,  4 Feb 2014 16:54:54 +0200
Message-ID: <1391525694-29455-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix possible NULL pointer dereference in disconnection flow. This can
happen if the target disconnected/rejected the connection request, e.g
before the binding stage between iscsi connection to the transport connection.

Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index afe9567..ca37ede 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -652,9 +652,13 @@ static int iser_disconnected_handler(struct rdma_cm_id *cma_id)
 	/* getting here when the state is UP means that the conn is being *
 	 * terminated asynchronously from the iSCSI layer's perspective.  */
 	if (iser_conn_state_comp_exch(ib_conn, ISER_CONN_UP,
-				      ISER_CONN_TERMINATING))
-		iscsi_conn_failure(ib_conn->iser_conn->iscsi_conn,
-				   ISCSI_ERR_CONN_FAILED);
+					ISER_CONN_TERMINATING)){
+		if (ib_conn->iser_conn)
+			iscsi_conn_failure(ib_conn->iser_conn->iscsi_conn,
+					   ISCSI_ERR_CONN_FAILED);
+		else
+			iser_err("iscsi_iser connection isn't bound\n");
+	}
 
 	/* Complete the termination process if no posts are pending */
 	if (ib_conn->post_recv_buf_count == 0 &&
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
