From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/iser: post initial receive buffers before sending the
 final login request
Date: Mon, 5 Mar 2012 18:21:44 +0200
Message-ID: <alpine.LRH.2.00.1203051816590.22329@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

An iser target may send iscsi NO-OP PDUs as soon as it marks the iser
iscsi session as fully operative. This means that there is window in time,
where there are no posted receive buffers in the initiator side, such that
its possible for the iser RC connection to break as of RNR NAK / retry errors.
To solve that, rely on the flags bits in the login request to have FFP (0x3)
in the lower nibble, as a marker for the final login request, and post an
initial chunk of receive buffers before sending that login request instead
of after getting the login response.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Roland, this bug is around for a while and isn't a regression from 3.2, so
I don't see how we can push it now to 3.3, still, please add CC to -stable
so it will eventually go to 3.3 stable and the rest of the stable series.

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   18 +++------------
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    1 +
 drivers/infiniband/ulp/iser/iser_initiator.c |   30 ++++++++++++++-----------
 3 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9a43cb0..db43b31 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -364,6 +364,9 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	}
 	ib_conn = ep->dd_data;

+	if (iser_alloc_rx_descriptors(ib_conn))
+		return -ENOMEM;
+
 	/* binds the iSER connection retrieved from the previously
 	 * connected ep_handle to the iSCSI layer connection. exchanges
 	 * connection pointers */
@@ -398,19 +401,6 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	iser_conn->ib_conn = NULL;
 }

-static int
-iscsi_iser_conn_start(struct iscsi_cls_conn *cls_conn)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	int err;
-
-	err = iser_conn_set_full_featured_mode(conn);
-	if (err)
-		return err;
-
-	return iscsi_conn_start(cls_conn);
-}
-
 static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
@@ -724,7 +714,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.get_conn_param		= iscsi_conn_get_param,
 	.get_ep_param		= iscsi_iser_get_ep_param,
 	.get_session_param	= iscsi_session_get_param,
-	.start_conn             = iscsi_iser_conn_start,
+	.start_conn             = iscsi_conn_start,
 	.stop_conn              = iscsi_iser_conn_stop,
 	/* iscsi host params */
 	.get_host_param		= iscsi_host_get_param,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index db7ea37..296be43 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -366,4 +366,5 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task);
 int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
+int iser_alloc_rx_descriptors(struct iser_conn *ib_conn);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index a607542..738a149 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -170,7 +170,7 @@ static void iser_create_send_desc(struct iser_conn	*ib_conn,
 }


-static int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
+int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
 {
 	int i, j;
 	u64 dma_addr;
@@ -242,23 +242,24 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 	kfree(ib_conn->rx_descs);
 }

-/**
- *  iser_conn_set_full_featured_mode - (iSER API)
- */
-int iser_conn_set_full_featured_mode(struct iscsi_conn *conn)
+static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;

-	iser_dbg("Initially post: %d\n", ISER_MIN_POSTED_RX);
-
-	/* Check that there is no posted recv or send buffers left - */
-	/* they must be consumed during the login phase */
-	BUG_ON(iser_conn->ib_conn->post_recv_buf_count != 0);
-	BUG_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) != 0);
+	iser_dbg("req op %x flags %x\n", req->opcode, req->flags);
+	/* check if this is the last login - going to full feature phase */
+	if ((req->flags & ISCSI_FULL_FEATURE_PHASE) != ISCSI_FULL_FEATURE_PHASE)
+		return 0;

-	if (iser_alloc_rx_descriptors(iser_conn->ib_conn))
-		return -ENOMEM;
+	/*
+	 * Check that there is one posted recv buffer (for the last login
+	 * response) and no posted send buffers left - they must have been
+	 * consumed during previous login phases.
+	 */
+	WARN_ON(iser_conn->ib_conn->post_recv_buf_count != 1);
+	WARN_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) != 0);

+	iser_dbg("Initially post: %d\n", ISER_MIN_POSTED_RX);
 	/* Initial post receive buffers */
 	if (iser_post_recvm(iser_conn->ib_conn, ISER_MIN_POSTED_RX))
 		return -ENOMEM;
@@ -438,6 +439,9 @@ int iser_send_control(struct iscsi_conn *conn,
 		err = iser_post_recvl(iser_conn->ib_conn);
 		if (err)
 			goto send_control_error;
+		err = iser_post_rx_bufs(conn, task->hdr);
+		if (err)
+			goto send_control_error;
 	}

 	err = iser_post_send(iser_conn->ib_conn, mdesc);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
