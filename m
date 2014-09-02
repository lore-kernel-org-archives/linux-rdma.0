From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 2/3] IB/iser: Allow bind only when connection state is UP
Date: Tue,  2 Sep 2014 15:57:09 +0300
Message-ID: <1409662630-28269-3-git-send-email-ogerlitz@mellanox.com>
References: <1409662630-28269-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409662630-28269-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We need to fail the bind operation also if the iser connection state != UP
(started teardown) and this should be done under the state lock.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 61ee91d..93ce62f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -344,7 +344,6 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 		     int is_leading)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session;
 	struct iser_conn *ib_conn;
 	struct iscsi_endpoint *ep;
 	int error;
@@ -363,9 +362,17 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	}
 	ib_conn = ep->dd_data;
 
-	session = conn->session;
-	if (iser_alloc_rx_descriptors(ib_conn, session))
-		return -ENOMEM;
+	mutex_lock(&ib_conn->state_mutex);
+	if (ib_conn->state != ISER_CONN_UP) {
+		error = -EINVAL;
+		iser_err("iser_conn %p state is %d, teardown started\n",
+			 ib_conn, ib_conn->state);
+		goto out;
+	}
+
+	error = iser_alloc_rx_descriptors(ib_conn, conn->session);
+	if (error)
+		goto out;
 
 	/* binds the iSER connection retrieved from the previously
 	 * connected ep_handle to the iSCSI layer connection. exchanges
@@ -375,7 +382,9 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	conn->dd_data = ib_conn;
 	ib_conn->iscsi_conn = conn;
 
-	return 0;
+out:
+	mutex_unlock(&ib_conn->state_mutex);
+	return error;
 }
 
 static int
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
