From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/4] IB/srpt: Convert to percpu_ida tag allocation
Date: Wed, 6 Apr 2016 11:57:41 -0700
Message-ID: <57055C25.4060304@sandisk.com>
References: <57055BC6.7070402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57055BC6.7070402-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just like other target drivers, use percpu_ida_alloc() and
percpu_ida_free() for I/O context management.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 135 ++++++++++++++++++----------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |   6 +-
 2 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index cce6c46..ae56287 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1293,28 +1293,31 @@ free_mem:
 	return -ENOMEM;
 }
 
+static struct srpt_send_ioctx *srpt_tag_to_ioctx(struct srpt_rdma_ch *ch,
+						 int tag)
+{
+	return &((struct srpt_send_ioctx *)ch->sess->sess_cmd_map)[tag];
+}
+
+static int srpt_ioctx_to_tag(struct srpt_rdma_ch *ch,
+			     struct srpt_send_ioctx *ioctx)
+{
+	return ioctx - (struct srpt_send_ioctx *)ch->sess->sess_cmd_map;
+}
+
 /**
  * srpt_get_send_ioctx() - Obtain an I/O context for sending to the initiator.
  */
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 {
+	struct se_session *sess = ch->sess;
 	struct srpt_send_ioctx *ioctx;
-	unsigned long flags;
-
-	BUG_ON(!ch);
-
-	ioctx = NULL;
-	spin_lock_irqsave(&ch->spinlock, flags);
-	if (!list_empty(&ch->free_list)) {
-		ioctx = list_first_entry(&ch->free_list,
-					 struct srpt_send_ioctx, free_list);
-		list_del(&ioctx->free_list);
-	}
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-
-	if (!ioctx)
-		return ioctx;
+	int tag;
 
+	tag = percpu_ida_alloc(&sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0)
+		return NULL;
+	ioctx = srpt_tag_to_ioctx(ch, tag);
 	BUG_ON(ioctx->ch != ch);
 	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
@@ -2006,6 +2009,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	struct srpt_rdma_ch *ch;
 	struct srpt_device *sdev;
 	struct se_session *se_sess;
+	int i;
 
 	ch = container_of(w, struct srpt_rdma_ch, release_work);
 	pr_debug("%s: %s-%d; release_done = %p\n", __func__, ch->sess_name,
@@ -2020,6 +2024,14 @@ static void srpt_release_channel_work(struct work_struct *w)
 	target_sess_cmd_list_set_waiting(se_sess);
 	target_wait_for_sess_cmds(se_sess);
 
+	for (i = 0; i < ch->rq_size; i++) {
+		struct srpt_send_ioctx *ioctx = srpt_tag_to_ioctx(ch, i);
+
+		srpt_cleanup_ioctx(sdev, &ioctx->ioctx,
+				   ch->rsp_size,
+				   DMA_TO_DEVICE);
+	}
+
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 	ch->sess = NULL;
@@ -2028,10 +2040,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	srpt_destroy_ch_ib(ch);
 
-	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
-			     ch->sport->sdev, ch->rq_size,
-			     ch->rsp_size, DMA_TO_DEVICE);
-
 	mutex_lock(&sdev->mutex);
 	list_del_init(&ch->list);
 	if (ch->release_done)
@@ -2175,36 +2183,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
 	ch->rsp_size = ch->sport->port_attrib.srp_max_rsp_size;
 
-	ch->ioctx_ring = (struct srpt_send_ioctx **)
-		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
-				      sizeof(*ch->ioctx_ring[0]),
-				      ch->rsp_size, DMA_TO_DEVICE);
-	if (!ch->ioctx_ring)
-		goto free_ch;
-
-	INIT_LIST_HEAD(&ch->free_list);
-	for (i = 0; i < ch->rq_size; i++) {
-		ch->ioctx_ring[i]->ch = ch;
-		list_add_tail(&ch->ioctx_ring[i]->free_list, &ch->free_list);
-	}
-
-	ret = srpt_create_ch_ib(ch);
-	if (ret) {
-		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_err("rejected SRP_LOGIN_REQ because creating"
-		       " a new RDMA channel failed.\n");
-		goto free_ring;
-	}
-
-	ret = srpt_ch_qp_rtr(ch, ch->qp);
-	if (ret) {
-		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_err("rejected SRP_LOGIN_REQ because enabling"
-		       " RTR failed (error code = %d)\n", ret);
-		goto destroy_ib;
-	}
-
 	/*
 	 * Use the initator port identifier as the session name, when
 	 * checking against se_node_acl->initiatorname[] this can be
@@ -2216,12 +2194,14 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	pr_debug("registering session %s\n", ch->sess_name);
 
-	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+	ch->sess = target_alloc_session(&sport->port_tpg_1, ch->rq_size,
+					sizeof(struct srpt_send_ioctx),
 					TARGET_PROT_NORMAL, ch->sess_name, ch,
 					NULL);
 	/* Retry without leading "0x" */
 	if (IS_ERR(ch->sess))
-		ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+		ch->sess = target_alloc_session(&sport->port_tpg_1, ch->rq_size,
+						sizeof(struct srpt_send_ioctx),
 						TARGET_PROT_NORMAL,
 						ch->sess_name + 2, ch, NULL);
 	if (IS_ERR(ch->sess)) {
@@ -2230,7 +2210,35 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = cpu_to_be32((PTR_ERR(ch->sess) == -ENOMEM) ?
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES :
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
-		goto destroy_ib;
+		goto free_ch;
+	}
+
+	for (i = 0; i < ch->rq_size; i++) {
+		struct srpt_send_ioctx *ioctx = srpt_tag_to_ioctx(ch, i);
+
+		if (srpt_init_ioctx(sdev, &ioctx->ioctx, ch->rsp_size,
+				    DMA_TO_DEVICE) < 0) {
+			pr_err("Initialization of I/O context %d/%d failed\n",
+			       i, ch->rq_size);
+			goto deregister_session;
+		}
+		ioctx->ch = ch;
+	}
+
+	ret = srpt_create_ch_ib(ch);
+	if (ret) {
+		rej->reason = cpu_to_be32(
+			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_err("rejected SRP_LOGIN_REQ because creating a new RDMA channel failed.\n");
+		goto deregister_session;
+	}
+
+	ret = srpt_ch_qp_rtr(ch, ch->qp);
+	if (ret) {
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_err("rejected SRP_LOGIN_REQ because enabling RTR failed (error code = %d)\n",
+		       ret);
+		goto release_channel;
 	}
 
 	pr_debug("Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
@@ -2274,17 +2282,21 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 release_channel:
 	srpt_disconnect_ch(ch);
+	srpt_destroy_ch_ib(ch);
+
+deregister_session:
+	for (i = 0; i < ch->rq_size; i++) {
+		struct srpt_send_ioctx *ioctx = srpt_tag_to_ioctx(ch, i);
+
+		srpt_cleanup_ioctx(sdev, &ioctx->ioctx,
+				   ch->rsp_size,
+				   DMA_TO_DEVICE);
+	}
+
 	transport_deregister_session_configfs(ch->sess);
 	transport_deregister_session(ch->sess);
 	ch->sess = NULL;
 
-destroy_ib:
-	srpt_destroy_ch_ib(ch);
-
-free_ring:
-	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
-			     ch->sport->sdev, ch->rq_size,
-			     ch->rsp_size, DMA_TO_DEVICE);
 free_ch:
 	kfree(ch);
 
@@ -2922,7 +2934,6 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx = container_of(se_cmd,
 				struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
-	unsigned long flags;
 
 	WARN_ON(ioctx->state != SRPT_STATE_DONE);
 	WARN_ON(ioctx->mapped_sg_count != 0);
@@ -2933,9 +2944,7 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 		ioctx->n_rbuf = 0;
 	}
 
-	spin_lock_irqsave(&ch->spinlock, flags);
-	list_add(&ioctx->free_list, &ch->free_list);
-	spin_unlock_irqrestore(&ch->spinlock, flags);
+	percpu_ida_free(&ch->sess->sess_tag_pool, srpt_ioctx_to_tag(ch, ioctx));
 }
 
 /**
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index af9b8b5..7018981 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -179,7 +179,6 @@ struct srpt_recv_ioctx {
  * struct srpt_send_ioctx - SRPT send I/O context.
  * @ioctx:       See above.
  * @ch:          Channel pointer.
- * @free_list:   Node in srpt_rdma_ch.free_list.
  * @n_rbuf:      Number of data buffers in the received SRP command.
  * @rbufs:       Pointer to SRP data buffer array.
  * @single_rbuf: SRP data buffer if the command has only a single buffer.
@@ -202,7 +201,6 @@ struct srpt_send_ioctx {
 	struct srp_direct_buf	*rbufs;
 	struct srp_direct_buf	single_rbuf;
 	struct scatterlist	*sg;
-	struct list_head	free_list;
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
@@ -250,8 +248,7 @@ enum rdma_ch_state {
  * @req_lim:       request limit: maximum number of requests that may be sent
  *                 by the initiator without having received a response.
  * @req_lim_delta: Number of credits not yet sent back to the initiator.
- * @spinlock:      Protects free_list and state.
- * @free_list:     Head of list with free send I/O contexts.
+ * @spinlock:      Protects modifications of @state.
  * @state:         channel state. See also enum rdma_ch_state.
  * @ioctx_ring:    Send ring.
  * @list:          Node for insertion in the srpt_device.rch_list list.
@@ -279,7 +276,6 @@ struct srpt_rdma_ch {
 	atomic_t		req_lim;
 	atomic_t		req_lim_delta;
 	spinlock_t		spinlock;
-	struct list_head	free_list;
 	enum rdma_ch_state	state;
 	struct srpt_send_ioctx	**ioctx_ring;
 	struct list_head	list;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
