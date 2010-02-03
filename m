From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/9] ib/iser: remove atomic counter for posted recv buffers
Date: Wed, 3 Feb 2010 17:35:32 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002031733250.11944@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With both the posting and reaping of recv buffers being in the
completion path, their outstanding number counter need not be atomic.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    6 +++---
 drivers/infiniband/ulp/iser/iser_verbs.c     |   16 ++++++++--------
 3 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -266,7 +266,7 @@ struct iser_conn {
 	struct ib_fmr_pool           *fmr_pool;     /* pool of IB FMRs         */
 	int                          disc_evt_flag; /* disconn event delivered */
 	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
-	atomic_t                     post_recv_buf_count; /* posted rx count   */
+	int                          post_recv_buf_count; /* posted rx count  */
 	atomic_t                     post_send_buf_count; /* posted tx count   */
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct iser_page_vec         *page_vec;     /* represents SG to fmr maps*
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -268,7 +268,7 @@ int iser_conn_set_full_featured_mode(str

 	/* Check that there is no posted recv or send buffers left - */
 	/* they must be consumed during the login phase */
-	BUG_ON(atomic_read(&iser_conn->ib_conn->post_recv_buf_count) != 0);
+	BUG_ON(iser_conn->ib_conn->post_recv_buf_count != 0);
 	BUG_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) != 0);

 	if (iser_alloc_rx_descriptors(iser_conn->ib_conn))
@@ -569,12 +569,12 @@ void iser_rcv_completion(struct iser_rx_
 	 * task eliminates the need to worry on tasks which are completed in   *
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
-	atomic_dec(&conn->ib_conn->post_recv_buf_count);
+	conn->ib_conn->post_recv_buf_count--;

 	if (rx_dma == ib_conn->login_dma)
 		return;

-	outstanding = atomic_read(&ib_conn->post_recv_buf_count);
+	outstanding = ib_conn->post_recv_buf_count;
 	if (outstanding + ISER_MIN_POSTED_RX <= ISER_QP_MAX_RECV_DTOS) {
 		count = min(ISER_QP_MAX_RECV_DTOS - outstanding,
 						ISER_MIN_POSTED_RX);
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -453,7 +453,7 @@ static void iser_disconnected_handler(st
 				   ISCSI_ERR_CONN_FAILED);

 	/* Complete the termination process if no posts are pending */
-	if ((atomic_read(&ib_conn->post_recv_buf_count) == 0) &&
+	if (ib_conn->post_recv_buf_count == 0 &&
 	    (atomic_read(&ib_conn->post_send_buf_count) == 0)) {
 		ib_conn->state = ISER_CONN_DOWN;
 		wake_up_interruptible(&ib_conn->wait);
@@ -500,7 +500,7 @@ void iser_conn_init(struct iser_conn *ib
 {
 	ib_conn->state = ISER_CONN_INIT;
 	init_waitqueue_head(&ib_conn->wait);
-	atomic_set(&ib_conn->post_recv_buf_count, 0);
+	ib_conn->post_recv_buf_count = 0;
 	atomic_set(&ib_conn->post_send_buf_count, 0);
 	atomic_set(&ib_conn->refcount, 1);
 	INIT_LIST_HEAD(&ib_conn->conn_list);
@@ -651,11 +651,11 @@ int iser_post_recvl(struct iser_conn *ib
 	rx_wr.num_sge = 1;
 	rx_wr.next    = NULL;

-	atomic_inc(&ib_conn->post_recv_buf_count);
+	ib_conn->post_recv_buf_count++;
 	ib_ret	= ib_post_recv(ib_conn->qp, &rx_wr, &rx_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		atomic_dec(&ib_conn->post_recv_buf_count);
+		ib_conn->post_recv_buf_count--;
 	}
 	return ib_ret;
 }
@@ -679,11 +679,11 @@ int iser_post_recvm(struct iser_conn *ib
 	rx_wr--;
 	rx_wr->next = NULL; /* mark end of work requests list */

-	atomic_add(count, &ib_conn->post_recv_buf_count);
+	ib_conn->post_recv_buf_count += count;
 	ib_ret	= ib_post_recv(ib_conn->qp, ib_conn->rx_wr, &rx_wr_failed);
 	if (ib_ret) {
 		iser_err("ib_post_recv failed ret=%d\n", ib_ret);
-		atomic_sub(count, &ib_conn->post_recv_buf_count);
+		ib_conn->post_recv_buf_count -= count;
 	} else
 		ib_conn->rx_desc_head = my_rx_head;
 	return ib_ret;
@@ -778,14 +778,14 @@ static void iser_handle_comp_error(struc

 	if ((char *)desc == ib_conn->login_buf ||
 			(rx_first <= rx && rx <= rx_last))
-		atomic_dec(&ib_conn->post_recv_buf_count);
+		ib_conn->post_recv_buf_count--;
 	 else { /* type is TX control/command/dataout */
 		if (desc->type == ISCSI_TX_DATAOUT)
 			kmem_cache_free(ig.desc_cache, desc);
 		atomic_dec(&ib_conn->post_send_buf_count);
 	}

-	if (atomic_read(&ib_conn->post_recv_buf_count) == 0 &&
+	if (ib_conn->post_recv_buf_count == 0 &&
 	    atomic_read(&ib_conn->post_send_buf_count) == 0) {
 		/* getting here when the state is UP means that the conn is *
 		 * being terminated asynchronously from the iSCSI layer's   *
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
