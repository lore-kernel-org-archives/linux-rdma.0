From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 01/9] ib/iser: revert commit bba7ebb "avoid recv buffer
 exhaustion"
Date: Mon, 8 Feb 2010 15:17:11 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002081515370.16288@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002081509400.16288@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002081509400.16288-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

towards a major change in the recv buffer posting logic, with which
the problem commit bba7ebb "avoid recv buffer exhaustion caused by
unexpected PDUs" comes to solve doesn't exist any more, revert it.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    3
 drivers/infiniband/ulp/iser/iser_initiator.c |  144 ++++++++-------------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |    1
 3 files changed, 47 insertions(+), 101 deletions(-)

Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -252,9 +252,6 @@ struct iser_conn {
 	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
 	atomic_t                     post_recv_buf_count; /* posted rx count   */
 	atomic_t                     post_send_buf_count; /* posted tx count   */
-	atomic_t                     unexpected_pdu_count;/* count of received *
-							   * unexpected pdus   *
-							   * not yet retired   */
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct iser_page_vec         *page_vec;     /* represents SG to fmr maps*
 						     * maps serialized as tx is*/
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -183,8 +183,14 @@ static int iser_post_receive_control(str
 	struct iser_regd_buf *regd_data;
 	struct iser_dto      *recv_dto = NULL;
 	struct iser_device  *device = iser_conn->ib_conn->device;
-	int rx_data_size, err;
-	int posts, outstanding_unexp_pdus;
+	int rx_data_size, err = 0;
+
+	rx_desc = kmem_cache_alloc(ig.desc_cache, GFP_NOIO);
+	if (rx_desc == NULL) {
+		iser_err("Failed to alloc desc for post recv\n");
+		return -ENOMEM;
+	}
+	rx_desc->type = ISCSI_RX;

 	/* for the login sequence we must support rx of upto 8K; login is done
 	 * after conn create/bind (connect) and conn stop/bind (reconnect),
@@ -195,80 +201,46 @@ static int iser_post_receive_control(str
 	else /* FIXME till user space sets conn->max_recv_dlength correctly */
 		rx_data_size = 128;

-	outstanding_unexp_pdus =
-		atomic_xchg(&iser_conn->ib_conn->unexpected_pdu_count, 0);
+	rx_desc->data = kmalloc(rx_data_size, GFP_NOIO);
+	if (rx_desc->data == NULL) {
+		iser_err("Failed to alloc data buf for post recv\n");
+		err = -ENOMEM;
+		goto post_rx_kmalloc_failure;
+	}

-	/*
-	 * in addition to the response buffer, replace those consumed by
-	 * unexpected pdus.
-	 */
-	for (posts = 0; posts < 1 + outstanding_unexp_pdus; posts++) {
-		rx_desc = kmem_cache_alloc(ig.desc_cache, GFP_NOIO);
-		if (rx_desc == NULL) {
-			iser_err("Failed to alloc desc for post recv %d\n",
-				 posts);
-			err = -ENOMEM;
-			goto post_rx_cache_alloc_failure;
-		}
-		rx_desc->type = ISCSI_RX;
-		rx_desc->data = kmalloc(rx_data_size, GFP_NOIO);
-		if (rx_desc->data == NULL) {
-			iser_err("Failed to alloc data buf for post recv %d\n",
-				 posts);
-			err = -ENOMEM;
-			goto post_rx_kmalloc_failure;
-		}
+	recv_dto = &rx_desc->dto;
+	recv_dto->ib_conn = iser_conn->ib_conn;
+	recv_dto->regd_vector_len = 0;

-		recv_dto = &rx_desc->dto;
-		recv_dto->ib_conn = iser_conn->ib_conn;
-		recv_dto->regd_vector_len = 0;
-
-		regd_hdr = &rx_desc->hdr_regd_buf;
-		memset(regd_hdr, 0, sizeof(struct iser_regd_buf));
-		regd_hdr->device  = device;
-		regd_hdr->virt_addr  = rx_desc; /* == &rx_desc->iser_header */
-		regd_hdr->data_size  = ISER_TOTAL_HEADERS_LEN;
-
-		iser_reg_single(device, regd_hdr, DMA_FROM_DEVICE);
-
-		iser_dto_add_regd_buff(recv_dto, regd_hdr, 0, 0);
-
-		regd_data = &rx_desc->data_regd_buf;
-		memset(regd_data, 0, sizeof(struct iser_regd_buf));
-		regd_data->device  = device;
-		regd_data->virt_addr  = rx_desc->data;
-		regd_data->data_size  = rx_data_size;
-
-		iser_reg_single(device, regd_data, DMA_FROM_DEVICE);
-
-		iser_dto_add_regd_buff(recv_dto, regd_data, 0, 0);
-
-		err = iser_post_recv(rx_desc);
-		if (err) {
-			iser_err("Failed iser_post_recv for post %d\n", posts);
-			goto post_rx_post_recv_failure;
-		}
-	}
-	/* all posts successful */
-	return 0;
+	regd_hdr = &rx_desc->hdr_regd_buf;
+	memset(regd_hdr, 0, sizeof(struct iser_regd_buf));
+	regd_hdr->device  = device;
+	regd_hdr->virt_addr  = rx_desc; /* == &rx_desc->iser_header */
+	regd_hdr->data_size  = ISER_TOTAL_HEADERS_LEN;
+
+	iser_reg_single(device, regd_hdr, DMA_FROM_DEVICE);
+
+	iser_dto_add_regd_buff(recv_dto, regd_hdr, 0, 0);
+
+	regd_data = &rx_desc->data_regd_buf;
+	memset(regd_data, 0, sizeof(struct iser_regd_buf));
+	regd_data->device  = device;
+	regd_data->virt_addr  = rx_desc->data;
+	regd_data->data_size  = rx_data_size;
+
+	iser_reg_single(device, regd_data, DMA_FROM_DEVICE);

-post_rx_post_recv_failure:
+	iser_dto_add_regd_buff(recv_dto, regd_data, 0, 0);
+
+	err = iser_post_recv(rx_desc);
+	if (!err)
+		return 0;
+
+	/* iser_post_recv failed */
 	iser_dto_buffs_release(recv_dto);
 	kfree(rx_desc->data);
 post_rx_kmalloc_failure:
 	kmem_cache_free(ig.desc_cache, rx_desc);
-post_rx_cache_alloc_failure:
-	if (posts > 0) {
-		/*
-		 * response buffer posted, but did not replace all unexpected
-		 * pdu recv bufs. Ignore error, retry occurs next send
-		 */
-		outstanding_unexp_pdus -= (posts - 1);
-		err = 0;
-	}
-	atomic_add(outstanding_unexp_pdus,
-		   &iser_conn->ib_conn->unexpected_pdu_count);
-
 	return err;
 }

@@ -302,10 +274,8 @@ int iser_conn_set_full_featured_mode(str
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;

 	int i;
-	/*
-	 * FIXME this value should be declared to the target during login with
-	 * the MaxOutstandingUnexpectedPDUs key when supported
-	 */
+	/* no need to keep it in a var, we are after login so if this should
+	 * be negotiated, by now the result should be available here */
 	int initial_post_recv_bufs_num = ISER_MAX_RX_MISC_PDUS;

 	iser_dbg("Initially post: %d\n", initial_post_recv_bufs_num);
@@ -507,7 +477,6 @@ int iser_send_control(struct iscsi_conn
 	int err = 0;
 	struct iser_regd_buf *regd_buf;
 	struct iser_device *device;
-	unsigned char opcode;

 	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
 		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
@@ -542,15 +511,10 @@ int iser_send_control(struct iscsi_conn
 				       data_seg_len);
 	}

-	opcode = task->hdr->opcode & ISCSI_OPCODE_MASK;
-
-	/* post recv buffer for response if one is expected */
-	if (!(opcode == ISCSI_OP_NOOP_OUT && task->hdr->itt == RESERVED_ITT)) {
-		if (iser_post_receive_control(conn) != 0) {
-			iser_err("post_rcv_buff failed!\n");
-			err = -ENOMEM;
-			goto send_control_error;
-		}
+	if (iser_post_receive_control(conn) != 0) {
+		iser_err("post_rcv_buff failed!\n");
+		err = -ENOMEM;
+		goto send_control_error;
 	}

 	err = iser_post_send(mdesc);
@@ -621,20 +585,6 @@ void iser_rcv_completion(struct iser_des
 	 * parallel to the execution of iser_conn_term. So the code that waits *
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	atomic_dec(&conn->ib_conn->post_recv_buf_count);
-
-	/*
-	 * if an unexpected PDU was received then the recv wr consumed must
-	 * be replaced, this is done in the next send of a control-type PDU
-	 */
-	if (opcode == ISCSI_OP_NOOP_IN && hdr->itt == RESERVED_ITT) {
-		/* nop-in with itt = 0xffffffff */
-		atomic_inc(&conn->ib_conn->unexpected_pdu_count);
-	}
-	else if (opcode == ISCSI_OP_ASYNC_EVENT) {
-		/* asyncronous message */
-		atomic_inc(&conn->ib_conn->unexpected_pdu_count);
-	}
-	/* a reject PDU consumes the recv buf posted for the response */
 }

 void iser_snd_completion(struct iser_desc *tx_desc)
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -491,7 +491,6 @@ void iser_conn_init(struct iser_conn *ib
 	init_waitqueue_head(&ib_conn->wait);
 	atomic_set(&ib_conn->post_recv_buf_count, 0);
 	atomic_set(&ib_conn->post_send_buf_count, 0);
-	atomic_set(&ib_conn->unexpected_pdu_count, 0);
 	atomic_set(&ib_conn->refcount, 1);
 	INIT_LIST_HEAD(&ib_conn->conn_list);
 	spin_lock_init(&ib_conn->lock);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
