From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 27/28] IB/srpt: Avoid that wait list processing triggers command reordering
Date: Wed,  3 Jan 2018 13:39:37 -0800
Message-ID: <20180103213938.11664-28-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a receive I/O context is removed from the wait list and
srpt_handle_new_iu() fails to allocate a send I/O context then
re-adding the receive I/O context to the wait list can cause
reordering. Avoid this by only removing a receive I/O context
from the wait list after allocating a send I/O context succeeded.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 82 ++++++++++++++++++++---------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 +
 2 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a509e0d0df0b..00e959fe4bac 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1467,39 +1467,39 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
  * srpt_handle_new_iu() - Process a newly received information unit.
  * @ch:    RDMA channel through which the information unit has been received.
  * @recv_ioctx: Receive I/O context associated with the information unit.
- * @send_ioctx: Send I/O context associated with the information unit.
  */
-static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
-			       struct srpt_recv_ioctx *recv_ioctx,
-			       struct srpt_send_ioctx *send_ioctx)
+static bool
+srpt_handle_new_iu(struct srpt_rdma_ch *ch, struct srpt_recv_ioctx *recv_ioctx)
 {
+	struct srpt_send_ioctx *send_ioctx = NULL;
 	struct srp_cmd *srp_cmd;
+	bool res = false;
+	u8 opcode;
 
 	BUG_ON(!ch);
 	BUG_ON(!recv_ioctx);
 
+	if (unlikely(ch->state == CH_CONNECTING))
+		goto push;
+
 	ib_dma_sync_single_for_cpu(ch->sport->sdev->device,
 				   recv_ioctx->ioctx.dma, srp_max_req_size,
 				   DMA_FROM_DEVICE);
 
-	if (unlikely(ch->state == CH_CONNECTING))
-		goto out_wait;
-
-	if (unlikely(ch->state != CH_LIVE))
-		return;
-
 	srp_cmd = recv_ioctx->ioctx.buf;
-	if (srp_cmd->opcode == SRP_CMD || srp_cmd->opcode == SRP_TSK_MGMT) {
-		if (!send_ioctx) {
-			if (!list_empty(&ch->cmd_wait_list))
-				goto out_wait;
-			send_ioctx = srpt_get_send_ioctx(ch);
-		}
+	opcode = srp_cmd->opcode;
+	if (opcode == SRP_CMD || opcode == SRP_TSK_MGMT) {
+		send_ioctx = srpt_get_send_ioctx(ch);
 		if (unlikely(!send_ioctx))
-			goto out_wait;
+			goto push;
+	}
+
+	if (!list_empty(&recv_ioctx->wait_list)) {
+		WARN_ON_ONCE(!ch->processing_wait_list);
+		list_del_init(&recv_ioctx->wait_list);
 	}
 
-	switch (srp_cmd->opcode) {
+	switch (opcode) {
 	case SRP_CMD:
 		srpt_handle_cmd(ch, recv_ioctx, send_ioctx);
 		break;
@@ -1519,16 +1519,22 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		pr_err("Received SRP_RSP\n");
 		break;
 	default:
-		pr_err("received IU with unknown opcode 0x%x\n",
-		       srp_cmd->opcode);
+		pr_err("received IU with unknown opcode 0x%x\n", opcode);
 		break;
 	}
 
 	srpt_post_recv(ch->sport->sdev, ch, recv_ioctx);
-	return;
+	res = true;
 
-out_wait:
-	list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
+out:
+	return res;
+
+push:
+	if (list_empty(&recv_ioctx->wait_list)) {
+		WARN_ON_ONCE(ch->processing_wait_list);
+		list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
+	}
+	goto out;
 }
 
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -1543,7 +1549,7 @@ static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		req_lim = atomic_dec_return(&ch->req_lim);
 		if (unlikely(req_lim < 0))
 			pr_err("req_lim = %d < 0\n", req_lim);
-		srpt_handle_new_iu(ch, ioctx, NULL);
+		srpt_handle_new_iu(ch, ioctx);
 	} else {
 		pr_info_ratelimited("receiving failed for ioctx %p with status %d\n",
 				    ioctx, wc->status);
@@ -1557,19 +1563,21 @@ static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
  */
 static void srpt_process_wait_list(struct srpt_rdma_ch *ch)
 {
-	struct srpt_send_ioctx *ioctx;
+	struct srpt_recv_ioctx *recv_ioctx, *tmp;
 
-	while (!list_empty(&ch->cmd_wait_list) &&
-	       ch->state >= CH_LIVE &&
-	       (ioctx = srpt_get_send_ioctx(ch)) != NULL) {
-		struct srpt_recv_ioctx *recv_ioctx;
+	WARN_ON_ONCE(ch->state == CH_CONNECTING);
 
-		recv_ioctx = list_first_entry(&ch->cmd_wait_list,
-					      struct srpt_recv_ioctx,
-					      wait_list);
-		list_del(&recv_ioctx->wait_list);
-		srpt_handle_new_iu(ch, recv_ioctx, ioctx);
+	if (list_empty(&ch->cmd_wait_list))
+		return;
+
+	WARN_ON_ONCE(ch->processing_wait_list);
+	ch->processing_wait_list = true;
+	list_for_each_entry_safe(recv_ioctx, tmp, &ch->cmd_wait_list,
+				 wait_list) {
+		if (!srpt_handle_new_iu(ch, recv_ioctx))
+			break;
 	}
+	ch->processing_wait_list = false;
 }
 
 /*
@@ -2082,6 +2090,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			    cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 			goto free_ring;
 		}
+		for (i = 0; i < ch->rq_size; i++)
+			INIT_LIST_HEAD(&ch->ioctx_recv_ring[i]->wait_list);
 	}
 
 	ret = srpt_create_ch_ib(ch);
@@ -2714,8 +2724,10 @@ static int srpt_alloc_srq(struct srpt_device *sdev)
 	sdev->use_srq = true;
 	sdev->srq = srq;
 
-	for (i = 0; i < sdev->srq_size; ++i)
+	for (i = 0; i < sdev->srq_size; ++i) {
+		INIT_LIST_HEAD(&sdev->ioctx_ring[i]->wait_list);
 		srpt_post_recv(sdev, NULL, sdev->ioctx_ring[i]);
+	}
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 2e40e6574dca..5a7eee561c2f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -261,6 +261,7 @@ enum rdma_ch_state {
  * @spinlock:      Protects free_list and state.
  * @free_list:     Head of list with free send I/O contexts.
  * @state:         channel state. See also enum rdma_ch_state.
+ * @processing_wait_list: Whether or not cmd_wait_list is being processed.
  * @ioctx_ring:    Send ring.
  * @ioctx_recv_ring: Receive I/O context ring.
  * @list:          Node in srpt_nexus.ch_list.
@@ -299,6 +300,7 @@ struct srpt_rdma_ch {
 	struct list_head	list;
 	struct list_head	cmd_wait_list;
 	uint16_t		pkey;
+	bool			processing_wait_list;
 	struct se_session	*sess;
 	u8			sess_name[24];
 	struct work_struct	release_work;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
