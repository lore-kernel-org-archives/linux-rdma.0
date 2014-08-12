From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/8] ib/srpt: Enhance printk output
Date: Tue, 12 Aug 2014 19:20:09 -0400
Message-ID: <17d91e94768e30db6846a41c9ec66b217659fd28.1407885084.git.dledford@redhat.com>
References: <cover.1407885084.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ib_srpt module has a metric ton of printks for debugging and
warnings and such.  And it never prefaces a single one of them with
information to allow an admin to know what errant module is spewing
garbage all through their dmesg output.  Fix that.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 201 +++++++++++++++++-----------------
 1 file changed, 101 insertions(+), 100 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8a8311e35cb..238dfe2d8fb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -182,7 +182,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 	if (!sdev || sdev->device != event->device)
 		return;
 
-	pr_debug("ASYNC event= %d on device= %s\n", event->event,
+	pr_debug("ib_srpt: ASYNC event= %d on device= %s\n", event->event,
 		 srpt_sdev_name(sdev));
 
 	switch (event->event) {
@@ -206,7 +206,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 		}
 		break;
 	default:
-		printk(KERN_ERR "received unrecognized IB event %d\n",
+		printk(KERN_ERR "ib_srpt: received unrecognized IB event %d\n",
 		       event->event);
 		break;
 	}
@@ -217,7 +217,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
  */
 static void srpt_srq_event(struct ib_event *event, void *ctx)
 {
-	printk(KERN_INFO "SRQ event %d\n", event->event);
+	printk(KERN_INFO "ib_srpt: SRQ event %d\n", event->event);
 }
 
 /**
@@ -225,7 +225,7 @@ static void srpt_srq_event(struct ib_event *event, void *ctx)
  */
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
-	pr_debug("QP event %d on cm_id=%p sess_name=%s state=%d\n",
+	pr_debug("ib_srpt: QP event %d on cm_id=%p sess_name=%s state=%d\n",
 		 event->event, ch->cm_id, ch->sess_name, srpt_get_ch_state(ch));
 
 	switch (event->event) {
@@ -237,11 +237,11 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 					       CH_RELEASING))
 			srpt_release_channel(ch);
 		else
-			pr_debug("%s: state %d - ignored LAST_WQE.\n",
+			pr_debug("ib_srpt: %s: state %d - ignored LAST_WQE.\n",
 				 ch->sess_name, srpt_get_ch_state(ch));
 		break;
 	default:
-		printk(KERN_ERR "received unrecognized IB QP event %d\n",
+		printk(KERN_ERR "ib_srpt: received unrecognized IB QP event %d\n",
 		       event->event);
 		break;
 	}
@@ -601,7 +601,7 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 		sport = &sdev->port[i - 1];
 		WARN_ON(sport->port != i);
 		if (ib_modify_port(sdev->device, i, 0, &port_modify) < 0)
-			printk(KERN_ERR "disabling MAD processing failed.\n");
+			printk(KERN_ERR "ib_srpt: disabling MAD processing failed.\n");
 		if (sport->mad_agent) {
 			ib_unregister_mad_agent(sport->mad_agent);
 			sport->mad_agent = NULL;
@@ -809,7 +809,7 @@ static int srpt_post_send(struct srpt_rdma_ch *ch,
 
 	ret = -ENOMEM;
 	if (unlikely(atomic_dec_return(&ch->sq_wr_avail) < 0)) {
-		printk(KERN_WARNING "IB send queue full (needed 1)\n");
+		printk(KERN_WARNING "ib_srpt: IB send queue full (needed 1)\n");
 		goto out;
 	}
 
@@ -911,7 +911,7 @@ static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
 
 		if (ioctx->n_rbuf >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
-			printk(KERN_ERR "received unsupported SRP_CMD request"
+			printk(KERN_ERR "ib_srpt: received unsupported SRP_CMD request"
 			       " type (%u out + %u in != %u / %zu)\n",
 			       srp_cmd->data_out_desc_cnt,
 			       srp_cmd->data_in_desc_cnt,
@@ -1338,7 +1338,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		goto out;
 	}
 
-	pr_debug("Aborting cmd with state %d and tag %lld\n", state,
+	pr_debug("ib_srpt: Aborting cmd with state %d and tag %lld\n", state,
 		 ioctx->tag);
 
 	switch (state) {
@@ -1372,7 +1372,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		target_put_sess_cmd(ioctx->ch->sess, &ioctx->cmd);
 		break;
 	default:
-		WARN(1, "Unexpected command state (%d)", state);
+		WARN(1, "ib_srpt: Unexpected command state (%d)", state);
 		break;
 	}
 
@@ -1425,14 +1425,15 @@ static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
 	if (WARN_ON(state != SRPT_STATE_CMD_RSP_SENT
 		    && state != SRPT_STATE_MGMT_RSP_SENT
 		    && state != SRPT_STATE_DONE))
-		pr_debug("state = %d\n", state);
+		pr_debug("ib_srpt: bad state in srpt_handle_send_comp, "
+			 "state = %d\n", state);
 
 	if (state != SRPT_STATE_DONE) {
 		srpt_unmap_sg_to_ib_sge(ch, ioctx);
 		transport_generic_free_cmd(&ioctx->cmd, 0);
 	} else {
-		printk(KERN_ERR "IB completion has been received too late for"
-		       " wr_id = %u.\n", ioctx->ioctx.index);
+		printk(KERN_ERR "ib_srpt: IB completion has been received too "
+		       "late for wr_id = %u.\n", ioctx->ioctx.index);
 	}
 }
 
@@ -1461,7 +1462,7 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
 	} else if (opcode == SRPT_RDMA_ABORT) {
 		ioctx->rdma_aborted = true;
 	} else {
-		WARN(true, "unexpected opcode %d\n", opcode);
+		WARN(true, "ib_srpt: unexpected opcode %d\n", opcode);
 	}
 }
 
@@ -1480,7 +1481,7 @@ static void srpt_handle_rdma_err_comp(struct srpt_rdma_ch *ch,
 	switch (opcode) {
 	case SRPT_RDMA_READ_LAST:
 		if (ioctx->n_rdma <= 0) {
-			printk(KERN_ERR "Received invalid RDMA read"
+			printk(KERN_ERR "ib_srpt: Received invalid RDMA read"
 			       " error completion with idx %d\n",
 			       ioctx->ioctx.index);
 			break;
@@ -1548,7 +1549,7 @@ static int srpt_build_cmd_rsp(struct srpt_rdma_ch *ch,
 		BUILD_BUG_ON(MIN_MAX_RSP_SIZE <= sizeof(*srp_rsp));
 		max_sense_len = ch->max_ti_iu_len - sizeof(*srp_rsp);
 		if (sense_data_len > max_sense_len) {
-			printk(KERN_WARNING "truncated sense data from %d to %d"
+			printk(KERN_WARNING "ib_srpt: truncated sense data from %d to %d"
 			       " bytes\n", sense_data_len, max_sense_len);
 			sense_data_len = max_sense_len;
 		}
@@ -1627,7 +1628,7 @@ static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
 	int addressing_method;
 
 	if (unlikely(len < 2)) {
-		printk(KERN_ERR "Illegal LUN length %d, expected 2 bytes or "
+		printk(KERN_ERR "ib_srpt: Illegal LUN length %d, expected 2 bytes or "
 		       "more", len);
 		goto out;
 	}
@@ -1662,7 +1663,7 @@ static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
 
 	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
 	default:
-		printk(KERN_ERR "Unimplemented LUN addressing method %u",
+		printk(KERN_ERR "ib_srpt: Unimplemented LUN addressing method %u",
 		       addressing_method);
 		break;
 	}
@@ -1671,7 +1672,7 @@ out:
 	return res;
 
 out_err:
-	printk(KERN_ERR "Support for multi-level LUNs has not yet been"
+	printk(KERN_ERR "ib_srpt: Support for multi-level LUNs has not yet been"
 	       " implemented");
 	goto out;
 }
@@ -1722,7 +1723,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 	}
 
 	if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
-		printk(KERN_ERR "0x%llx: parsing SRP descriptor table failed.\n",
+		printk(KERN_ERR "ib_srpt: 0x%llx: parsing SRP descriptor table failed.\n",
 		       srp_cmd->tag);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto send_sense;
@@ -1828,7 +1829,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	srp_tsk = recv_ioctx->ioctx.buf;
 	cmd = &send_ioctx->cmd;
 
-	pr_debug("recv tsk_mgmt fn %d for task_tag %lld and cmd tag %lld"
+	pr_debug("ib_srpt: recv tsk_mgmt fn %d for task_tag %lld and cmd tag %lld"
 		 " cm_id %p sess %p\n", srp_tsk->tsk_mgmt_func,
 		 srp_tsk->task_tag, srp_tsk->tag, ch->cm_id, ch->sess);
 
@@ -1911,19 +1912,19 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 		srpt_handle_tsk_mgmt(ch, recv_ioctx, send_ioctx);
 		break;
 	case SRP_I_LOGOUT:
-		printk(KERN_ERR "Not yet implemented: SRP_I_LOGOUT\n");
+		printk(KERN_ERR "ib_srpt: Not yet implemented: SRP_I_LOGOUT\n");
 		break;
 	case SRP_CRED_RSP:
-		pr_debug("received SRP_CRED_RSP\n");
+		pr_debug("ib_srpt: received SRP_CRED_RSP\n");
 		break;
 	case SRP_AER_RSP:
-		pr_debug("received SRP_AER_RSP\n");
+		pr_debug("ib_srpt: received SRP_AER_RSP\n");
 		break;
 	case SRP_RSP:
-		printk(KERN_ERR "Received SRP_RSP\n");
+		printk(KERN_ERR "ib_srpt: Received SRP_RSP\n");
 		break;
 	default:
-		printk(KERN_ERR "received IU with unknown opcode 0x%x\n",
+		printk(KERN_ERR "ib_srpt: received IU with unknown opcode 0x%x\n",
 		       srp_cmd->opcode);
 		break;
 	}
@@ -1947,11 +1948,11 @@ static void srpt_process_rcv_completion(struct ib_cq *cq,
 
 		req_lim = atomic_dec_return(&ch->req_lim);
 		if (unlikely(req_lim < 0))
-			printk(KERN_ERR "req_lim = %d < 0\n", req_lim);
+			printk(KERN_ERR "ib_srpt: req_lim = %d < 0\n", req_lim);
 		ioctx = sdev->ioctx_ring[index];
 		srpt_handle_new_iu(ch, ioctx, NULL);
 	} else {
-		printk(KERN_INFO "receiving failed for idx %u with status %d\n",
+		printk(KERN_INFO "ib_srpt: receiving failed for idx %u with status %d\n",
 		       index, wc->status);
 	}
 }
@@ -1992,11 +1993,11 @@ static void srpt_process_send_completion(struct ib_cq *cq,
 		}
 	} else {
 		if (opcode == SRPT_SEND) {
-			printk(KERN_INFO "sending response for idx %u failed"
+			printk(KERN_INFO "ib_srpt: sending response for idx %u failed"
 			       " with status %d\n", index, wc->status);
 			srpt_handle_send_err_comp(ch, wc->wr_id);
 		} else if (opcode != SRPT_RDMA_MID) {
-			printk(KERN_INFO "RDMA t %d for idx %u failed with"
+			printk(KERN_INFO "ib_srpt: RDMA t %d for idx %u failed with"
 				" status %d", opcode, index, wc->status);
 			srpt_handle_rdma_err_comp(ch, send_ioctx, opcode);
 		}
@@ -2061,14 +2062,14 @@ static int srpt_compl_thread(void *arg)
 
 	ch = arg;
 	BUG_ON(!ch);
-	printk(KERN_INFO "Session %s: kernel thread %s (PID %d) started\n",
+	printk(KERN_INFO "ib_srpt: Session %s: kernel thread %s (PID %d) started\n",
 	       ch->sess_name, ch->thread->comm, current->pid);
 	while (!kthread_should_stop()) {
 		wait_event_interruptible(ch->wait_queue,
 			(srpt_process_completion(ch->cq, ch),
 			 kthread_should_stop()));
 	}
-	printk(KERN_INFO "Session %s: kernel thread %s (PID %d) stopped\n",
+	printk(KERN_INFO "ib_srpt: Session %s: kernel thread %s (PID %d) stopped\n",
 	       ch->sess_name, ch->thread->comm, current->pid);
 	return 0;
 }
@@ -2095,7 +2096,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
-		printk(KERN_ERR "failed to create CQ cqe= %d ret= %d\n",
+		printk(KERN_ERR "ib_srpt: failed to create CQ cqe= %d ret= %d\n",
 		       ch->rq_size + srp_sq_size, ret);
 		goto out;
 	}
@@ -2114,13 +2115,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
 	if (IS_ERR(ch->qp)) {
 		ret = PTR_ERR(ch->qp);
-		printk(KERN_ERR "failed to create_qp ret= %d\n", ret);
+		printk(KERN_ERR "ib_srpt: failed to create_qp ret= %d\n", ret);
 		goto err_destroy_cq;
 	}
 
 	atomic_set(&ch->sq_wr_avail, qp_init->cap.max_send_wr);
 
-	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
+	pr_debug("ib_srpt: %s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
 		 __func__, ch->cq->cqe, qp_init->cap.max_send_sge,
 		 qp_init->cap.max_send_wr, ch->cm_id);
 
@@ -2130,11 +2131,11 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 
 	init_waitqueue_head(&ch->wait_queue);
 
-	pr_debug("creating thread for session %s\n", ch->sess_name);
+	pr_debug("ib_srpt: creating thread for session %s\n", ch->sess_name);
 
 	ch->thread = kthread_run(srpt_compl_thread, ch, "ib_srpt_compl");
 	if (IS_ERR(ch->thread)) {
-		printk(KERN_ERR "failed to create kernel thread %ld\n",
+		printk(KERN_ERR "ib_srpt: failed to create kernel thread %ld\n",
 		       PTR_ERR(ch->thread));
 		ch->thread = NULL;
 		goto err_destroy_qp;
@@ -2195,7 +2196,7 @@ static void __srpt_close_ch(struct srpt_rdma_ch *ch)
 		/* fall through */
 	case CH_LIVE:
 		if (ib_send_cm_dreq(ch->cm_id, NULL, 0) < 0)
-			printk(KERN_ERR "sending CM DREQ failed.\n");
+			printk(KERN_ERR "ib_srpt: sending CM DREQ failed.\n");
 		break;
 	case CH_DISCONNECTING:
 		break;
@@ -2282,7 +2283,7 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
 
 		ret = srpt_ch_qp_err(ch);
 		if (ret < 0)
-			printk(KERN_ERR "Setting queue pair in error state"
+			printk(KERN_ERR "ib_srpt: Setting queue pair in error state"
 			       " failed: %d\n", ret);
 	}
 }
@@ -2335,7 +2336,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	struct se_session *se_sess;
 
 	ch = container_of(w, struct srpt_rdma_ch, release_work);
-	pr_debug("ch = %p; ch->sess = %p; release_done = %p\n", ch, ch->sess,
+	pr_debug("ib_srpt: ch = %p; ch->sess = %p; release_done = %p\n", ch, ch->sess,
 		 ch->release_done);
 
 	sdev = ch->sport->sdev;
@@ -2426,7 +2427,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
-	printk(KERN_INFO "Received SRP_LOGIN_REQ with i_port_id 0x%llx:0x%llx,"
+	printk(KERN_INFO "ib_srpt: Received SRP_LOGIN_REQ with i_port_id 0x%llx:0x%llx,"
 	       " t_port_id 0x%llx:0x%llx and it_iu_len %d on port %d"
 	       " (guid=0x%llx:0x%llx)\n",
 	       be64_to_cpu(*(__be64 *)&req->initiator_port_id[0]),
@@ -2451,7 +2452,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE);
 		ret = -EINVAL;
-		printk(KERN_ERR "rejected SRP_LOGIN_REQ because its"
+		printk(KERN_ERR "ib_srpt: rejected SRP_LOGIN_REQ because its"
 		       " length (%d bytes) is out of range (%d .. %d)\n",
 		       it_iu_len, 64, srp_max_req_size);
 		goto reject;
@@ -2461,7 +2462,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 			     SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		ret = -EINVAL;
-		printk(KERN_ERR "rejected SRP_LOGIN_REQ because the target port"
+		printk(KERN_ERR "ib_srpt: rejected SRP_LOGIN_REQ because the target port"
 		       " has not yet been enabled\n");
 		goto reject;
 	}
@@ -2485,7 +2486,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 					continue;
 
 				/* found an existing channel */
-				pr_debug("Found existing channel %s"
+				pr_debug("ib_srpt: Found existing channel %s"
 					 " cm_id= %p state= %d\n",
 					 ch->sess_name, ch->cm_id, ch_state);
 
@@ -2507,7 +2508,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL);
 		ret = -ENOMEM;
-		printk(KERN_ERR "rejected SRP_LOGIN_REQ because it"
+		printk(KERN_ERR "ib_srpt: rejected SRP_LOGIN_REQ because it"
 		       " has an invalid target port identifier.\n");
 		goto reject;
 	}
@@ -2516,7 +2517,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (!ch) {
 		rej->reason = __constant_cpu_to_be32(
 					SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		printk(KERN_ERR "rejected SRP_LOGIN_REQ because no memory.\n");
+		printk(KERN_ERR "ib_srpt: rejected SRP_LOGIN_REQ because no memory.\n");
 		ret = -ENOMEM;
 		goto reject;
 	}
@@ -2553,7 +2554,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (ret) {
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		printk(KERN_ERR "rejected SRP_LOGIN_REQ because creating"
+		printk(KERN_ERR "ib_srpt: rejected SRP_LOGIN_REQ because creating"
 		       " a new RDMA channel failed.\n");
 		goto free_ring;
 	}
@@ -2562,7 +2563,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (ret) {
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		printk(KERN_ERR "rejected SRP_LOGIN_REQ because enabling"
+		printk(KERN_ERR "ib_srpt: rejected SRP_LOGIN_REQ because enabling"
 		       " RTR failed (error code = %d)\n", ret);
 		goto destroy_ib;
 	}
@@ -2573,11 +2574,11 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
 
-	pr_debug("registering session %s\n", ch->sess_name);
+	pr_debug("ib_srpt: registering session %s\n", ch->sess_name);
 
 	nacl = srpt_lookup_acl(sport, ch->i_port_id);
 	if (!nacl) {
-		printk(KERN_INFO "Rejected login because no ACL has been"
+		printk(KERN_INFO "ib_srpt: Rejected login because no ACL has been"
 		       " configured yet for initiator %s.\n", ch->sess_name);
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
@@ -2588,13 +2589,13 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (IS_ERR(ch->sess)) {
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_debug("Failed to create session\n");
+		pr_debug("ib_srpt: Failed to create session\n");
 		goto deregister_session;
 	}
 	ch->sess->se_node_acl = &nacl->nacl;
 	transport_register_session(&sport->port_tpg_1, &nacl->nacl, ch->sess, ch);
 
-	pr_debug("Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
+	pr_debug("ib_srpt: Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
 		 ch->sess_name, ch->cm_id);
 
 	/* create srp_login_response */
@@ -2622,7 +2623,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	ret = ib_send_cm_rep(cm_id, rep_param);
 	if (ret) {
-		printk(KERN_ERR "sending SRP_LOGIN_REQ response failed"
+		printk(KERN_ERR "ib_srpt: sending SRP_LOGIN_REQ response failed"
 		       " (error code = %d)\n", ret);
 		goto release_channel;
 	}
@@ -2670,7 +2671,7 @@ out:
 
 static void srpt_cm_rej_recv(struct ib_cm_id *cm_id)
 {
-	printk(KERN_INFO "Received IB REJ for cm_id %p.\n", cm_id);
+	printk(KERN_INFO "ib_srpt: Received IB REJ for cm_id %p.\n", cm_id);
 	srpt_drain_channel(cm_id);
 }
 
@@ -2705,13 +2706,13 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 
 static void srpt_cm_timewait_exit(struct ib_cm_id *cm_id)
 {
-	printk(KERN_INFO "Received IB TimeWait exit for cm_id %p.\n", cm_id);
+	printk(KERN_INFO "ib_srpt: Received IB TimeWait exit for cm_id %p.\n", cm_id);
 	srpt_drain_channel(cm_id);
 }
 
 static void srpt_cm_rep_error(struct ib_cm_id *cm_id)
 {
-	printk(KERN_INFO "Received IB REP error for cm_id %p.\n", cm_id);
+	printk(KERN_INFO "ib_srpt: Received IB REP error for cm_id %p.\n", cm_id);
 	srpt_drain_channel(cm_id);
 }
 
@@ -2727,7 +2728,7 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 	ch = srpt_find_channel(cm_id->context, cm_id);
 	BUG_ON(!ch);
 
-	pr_debug("cm_id= %p ch->state= %d\n", cm_id, srpt_get_ch_state(ch));
+	pr_debug("ib_srpt: cm_id= %p ch->state= %d\n", cm_id, srpt_get_ch_state(ch));
 
 	spin_lock_irqsave(&ch->spinlock, flags);
 	switch (ch->state) {
@@ -2739,15 +2740,15 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 	case CH_DISCONNECTING:
 	case CH_DRAINING:
 	case CH_RELEASING:
-		WARN(true, "unexpected channel state %d\n", ch->state);
+		WARN(true, "ib_srpt: unexpected channel state %d\n", ch->state);
 		break;
 	}
 	spin_unlock_irqrestore(&ch->spinlock, flags);
 
 	if (send_drep) {
 		if (ib_send_cm_drep(ch->cm_id, NULL, 0) < 0)
-			printk(KERN_ERR "Sending IB DREP failed.\n");
-		printk(KERN_INFO "Received DREQ and sent DREP for session %s.\n",
+			printk(KERN_ERR "ib_srpt: Sending IB DREP failed.\n");
+		printk(KERN_INFO "ib_srpt: Received DREQ and sent DREP for session %s.\n",
 		       ch->sess_name);
 	}
 }
@@ -2757,7 +2758,7 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
  */
 static void srpt_cm_drep_recv(struct ib_cm_id *cm_id)
 {
-	printk(KERN_INFO "Received InfiniBand DREP message for cm_id %p.\n",
+	printk(KERN_INFO "ib_srpt: Received InfiniBand DREP message for cm_id %p.\n",
 	       cm_id);
 	srpt_drain_channel(cm_id);
 }
@@ -2802,13 +2803,13 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		srpt_cm_rep_error(cm_id);
 		break;
 	case IB_CM_DREQ_ERROR:
-		printk(KERN_INFO "Received IB DREQ ERROR event.\n");
+		printk(KERN_INFO "ib_srpt: Received IB DREQ ERROR event.\n");
 		break;
 	case IB_CM_MRA_RECEIVED:
-		printk(KERN_INFO "Received IB MRA event\n");
+		printk(KERN_INFO "ib_srpt: Received IB MRA event\n");
 		break;
 	default:
-		printk(KERN_ERR "received unrecognized IB CM event %d\n",
+		printk(KERN_ERR "ib_srpt: received unrecognized IB CM event %d\n",
 		       event->event);
 		break;
 	}
@@ -2839,7 +2840,7 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 		ret = -ENOMEM;
 		sq_wr_avail = atomic_sub_return(n_rdma, &ch->sq_wr_avail);
 		if (sq_wr_avail < 0) {
-			printk(KERN_WARNING "IB send queue full (needed %d)\n",
+			printk(KERN_WARNING "ib_srpt: IB send queue full (needed %d)\n",
 			       n_rdma);
 			goto out;
 		}
@@ -2888,12 +2889,12 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 		wr.send_flags = IB_SEND_SIGNALED;
 		while (ch->state == CH_LIVE &&
 			ib_post_send(ch->qp, &wr, &bad_wr) != 0) {
-			printk(KERN_INFO "Trying to abort failed RDMA transfer [%d]",
+			printk(KERN_INFO "ib_srpt: Trying to abort failed RDMA transfer [%d]",
 				ioctx->ioctx.index);
 			msleep(1000);
 		}
 		while (ch->state != CH_RELEASING && !ioctx->rdma_aborted) {
-			printk(KERN_INFO "Waiting until RDMA abort finished [%d]",
+			printk(KERN_INFO "ib_srpt: Waiting until RDMA abort finished [%d]",
 				ioctx->ioctx.index);
 			msleep(1000);
 		}
@@ -2966,7 +2967,7 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	ch_state = srpt_get_ch_state(ch);
 	switch (ch_state) {
 	case CH_CONNECTING:
-		WARN(true, "unexpected channel state %d\n", ch_state);
+		WARN(true, "ib_srpt: unexpected channel state %d\n", ch_state);
 		ret = -EINVAL;
 		goto out;
 	case CH_LIVE:
@@ -2974,7 +2975,7 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	case CH_DISCONNECTING:
 	case CH_DRAINING:
 	case CH_RELEASING:
-		pr_debug("cmd with tag %lld: channel disconnecting\n",
+		pr_debug("ib_srpt: cmd with tag %lld: channel disconnecting\n",
 			 ioctx->tag);
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DATA_IN);
 		ret = -EINVAL;
@@ -3029,7 +3030,7 @@ static void srpt_queue_response(struct se_cmd *cmd)
 		ioctx->state = SRPT_STATE_MGMT_RSP_SENT;
 		break;
 	default:
-		WARN(true, "ch %p; cmd %d: unexpected command state %d\n",
+		WARN(true, "ib_srpt: ch %p; cmd %d: unexpected command state %d\n",
 			ch, ioctx->ioctx.index, ioctx->state);
 		break;
 	}
@@ -3049,7 +3050,7 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	    !ioctx->queue_status_only) {
 		ret = srpt_xfer_data(ch, ioctx);
 		if (ret) {
-			printk(KERN_ERR "xfer_data failed for tag %llu\n",
+			printk(KERN_ERR "ib_srpt: xfer_data failed for tag %llu\n",
 			       ioctx->tag);
 			return;
 		}
@@ -3066,7 +3067,7 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	}
 	ret = srpt_post_send(ch, ioctx, resp_len);
 	if (ret) {
-		printk(KERN_ERR "sending cmd response failed for tag %llu\n",
+		printk(KERN_ERR "ib_srpt: sending cmd response failed for tag %llu\n",
 		       ioctx->tag);
 		srpt_unmap_sg_to_ib_sge(ch, ioctx);
 		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
@@ -3194,7 +3195,7 @@ static void srpt_add_one(struct ib_device *device)
 	struct ib_srq_init_attr srq_attr;
 	int i;
 
-	pr_debug("device = %p, device->dma_ops = %p\n", device,
+	pr_debug("ib_srpt: device = %p, device->dma_ops = %p\n", device,
 		 device->dma_ops);
 
 	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
@@ -3230,7 +3231,7 @@ static void srpt_add_one(struct ib_device *device)
 	if (IS_ERR(sdev->srq))
 		goto err_mr;
 
-	pr_debug("%s: create SRQ #wr= %d max_allow=%d dev= %s\n",
+	pr_debug("ib_srpt: %s: create SRQ #wr= %d max_allow=%d dev= %s\n",
 		 __func__, sdev->srq_size, sdev->dev_attr.max_srq_wr,
 		 device->name);
 
@@ -3242,7 +3243,7 @@ static void srpt_add_one(struct ib_device *device)
 		goto err_srq;
 
 	/* print out target login information */
-	pr_debug("Target login info: id_ext=%016llx,ioc_guid=%016llx,"
+	pr_debug("ib_srpt: Target login info: id_ext=%016llx,ioc_guid=%016llx,"
 		 "pkey=ffff,service_id=%016llx\n", srpt_service_guid,
 		 srpt_service_guid, srpt_service_guid);
 
@@ -3284,7 +3285,7 @@ static void srpt_add_one(struct ib_device *device)
 		spin_lock_init(&sport->port_acl_lock);
 
 		if (srpt_refresh_port(sport)) {
-			printk(KERN_ERR "MAD registration failed for %s-%d.\n",
+			printk(KERN_ERR "ib_srpt: MAD registration failed for %s-%d.\n",
 			       srpt_sdev_name(sdev), i);
 			goto err_ring;
 		}
@@ -3300,7 +3301,7 @@ static void srpt_add_one(struct ib_device *device)
 
 out:
 	ib_set_client_data(device, &srpt_client, sdev);
-	pr_debug("added %s.\n", device->name);
+	pr_debug("ib_srpt: added %s.\n", device->name);
 	return;
 
 err_ring:
@@ -3455,7 +3456,7 @@ static struct se_node_acl *srpt_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct srpt_node_acl), GFP_KERNEL);
 	if (!nacl) {
-		printk(KERN_ERR "Unable to allocate struct srpt_node_acl\n");
+		printk(KERN_ERR "ib_srpt: Unable to allocate struct srpt_node_acl\n");
 		return NULL;
 	}
 
@@ -3514,7 +3515,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	ch = se_sess->fabric_sess_ptr;
 	WARN_ON(ch->sess != se_sess);
 
-	pr_debug("ch %p state %d\n", ch, srpt_get_ch_state(ch));
+	pr_debug("ib_srpt: ch %p state %d\n", ch, srpt_get_ch_state(ch));
 
 	sdev = ch->sport->sdev;
 	spin_lock_irq(&sdev->spinlock);
@@ -3584,7 +3585,7 @@ static int srpt_parse_i_port_id(u8 i_port_id[16], const char *name)
 	memset(i_port_id, 0, leading_zero_bytes);
 	rc = hex2bin(i_port_id + leading_zero_bytes, p, count);
 	if (rc < 0)
-		pr_debug("hex2bin failed for srpt_parse_i_port_id: %d\n", rc);
+		pr_debug("ib_srpt: hex2bin failed for srpt_parse_i_port_id: %d\n", rc);
 	ret = 0;
 out:
 	return ret;
@@ -3606,7 +3607,7 @@ static struct se_node_acl *srpt_make_nodeacl(struct se_portal_group *tpg,
 	u8 i_port_id[16];
 
 	if (srpt_parse_i_port_id(i_port_id, name) < 0) {
-		printk(KERN_ERR "invalid initiator port ID %s\n", name);
+		printk(KERN_ERR "ib_srpt: invalid initiator port ID %s\n", name);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -3680,16 +3681,16 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rdma_size(
 
 	ret = kstrtoul(page, 0, &val);
 	if (ret < 0) {
-		pr_err("kstrtoul() failed with ret: %d\n", ret);
+		pr_err("ib_srpt: kstrtoul() failed with ret: %d\n", ret);
 		return -EINVAL;
 	}
 	if (val > MAX_SRPT_RDMA_SIZE) {
-		pr_err("val: %lu exceeds MAX_SRPT_RDMA_SIZE: %d\n", val,
+		pr_err("ib_srpt: val: %lu exceeds MAX_SRPT_RDMA_SIZE: %d\n", val,
 			MAX_SRPT_RDMA_SIZE);
 		return -EINVAL;
 	}
 	if (val < DEFAULT_MAX_RDMA_SIZE) {
-		pr_err("val: %lu smaller than DEFAULT_MAX_RDMA_SIZE: %d\n",
+		pr_err("ib_srpt: val: %lu smaller than DEFAULT_MAX_RDMA_SIZE: %d\n",
 			val, DEFAULT_MAX_RDMA_SIZE);
 		return -EINVAL;
 	}
@@ -3720,16 +3721,16 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
 
 	ret = kstrtoul(page, 0, &val);
 	if (ret < 0) {
-		pr_err("kstrtoul() failed with ret: %d\n", ret);
+		pr_err("ib_srpt: kstrtoul() failed with ret: %d\n", ret);
 		return -EINVAL;
 	}
 	if (val > MAX_SRPT_RSP_SIZE) {
-		pr_err("val: %lu exceeds MAX_SRPT_RSP_SIZE: %d\n", val,
+		pr_err("ib_srpt: val: %lu exceeds MAX_SRPT_RSP_SIZE: %d\n", val,
 			MAX_SRPT_RSP_SIZE);
 		return -EINVAL;
 	}
 	if (val < MIN_MAX_RSP_SIZE) {
-		pr_err("val: %lu smaller than MIN_MAX_RSP_SIZE: %d\n", val,
+		pr_err("ib_srpt: val: %lu smaller than MIN_MAX_RSP_SIZE: %d\n", val,
 			MIN_MAX_RSP_SIZE);
 		return -EINVAL;
 	}
@@ -3760,16 +3761,16 @@ static ssize_t srpt_tpg_attrib_store_srp_sq_size(
 
 	ret = kstrtoul(page, 0, &val);
 	if (ret < 0) {
-		pr_err("kstrtoul() failed with ret: %d\n", ret);
+		pr_err("ib_srpt: kstrtoul() failed with ret: %d\n", ret);
 		return -EINVAL;
 	}
 	if (val > MAX_SRPT_SRQ_SIZE) {
-		pr_err("val: %lu exceeds MAX_SRPT_SRQ_SIZE: %d\n", val,
+		pr_err("ib_srpt: val: %lu exceeds MAX_SRPT_SRQ_SIZE: %d\n", val,
 			MAX_SRPT_SRQ_SIZE);
 		return -EINVAL;
 	}
 	if (val < MIN_SRPT_SRQ_SIZE) {
-		pr_err("val: %lu smaller than MIN_SRPT_SRQ_SIZE: %d\n", val,
+		pr_err("ib_srpt: val: %lu smaller than MIN_SRPT_SRQ_SIZE: %d\n", val,
 			MIN_SRPT_SRQ_SIZE);
 		return -EINVAL;
 	}
@@ -3807,12 +3808,12 @@ static ssize_t srpt_tpg_store_enable(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract srpt_tpg_store_enable\n");
+		printk(KERN_ERR "ib_srpt: Unable to extract srpt_tpg_store_enable\n");
 		return -EINVAL;
 	}
 
 	if ((tmp != 0) && (tmp != 1)) {
-		printk(KERN_ERR "Illegal value for srpt_tpg_store_enable: %lu\n", tmp);
+		printk(KERN_ERR "ib_srpt: Illegal value for srpt_tpg_store_enable: %lu\n", tmp);
 		return -EINVAL;
 	}
 	if (tmp == 1)
@@ -3875,7 +3876,7 @@ static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
 	int ret;
 
 	sport = srpt_lookup_port(name);
-	pr_debug("make_tport(%s)\n", name);
+	pr_debug("ib_srpt: make_tport(%s)\n", name);
 	ret = -EINVAL;
 	if (!sport)
 		goto err;
@@ -3894,7 +3895,7 @@ static void srpt_drop_tport(struct se_wwn *wwn)
 {
 	struct srpt_port *sport = container_of(wwn, struct srpt_port, port_wwn);
 
-	pr_debug("drop_tport(%s\n", config_item_name(&sport->port_wwn.wwn_group.cg_item));
+	pr_debug("ib_srpt: drop_tport(%s\n", config_item_name(&sport->port_wwn.wwn_group.cg_item));
 }
 
 static ssize_t srpt_wwn_show_attr_version(struct target_fabric_configfs *tf,
@@ -3971,7 +3972,7 @@ static int __init srpt_init_module(void)
 
 	ret = -EINVAL;
 	if (srp_max_req_size < MIN_MAX_REQ_SIZE) {
-		printk(KERN_ERR "invalid value %d for kernel module parameter"
+		printk(KERN_ERR "ib_srpt: invalid value %d for kernel module parameter"
 		       " srp_max_req_size -- must be at least %d.\n",
 		       srp_max_req_size, MIN_MAX_REQ_SIZE);
 		goto out;
@@ -3979,7 +3980,7 @@ static int __init srpt_init_module(void)
 
 	if (srpt_srq_size < MIN_SRPT_SRQ_SIZE
 	    || srpt_srq_size > MAX_SRPT_SRQ_SIZE) {
-		printk(KERN_ERR "invalid value %d for kernel module parameter"
+		printk(KERN_ERR "ib_srpt: invalid value %d for kernel module parameter"
 		       " srpt_srq_size -- must be in the range [%d..%d].\n",
 		       srpt_srq_size, MIN_SRPT_SRQ_SIZE, MAX_SRPT_SRQ_SIZE);
 		goto out;
@@ -3987,7 +3988,7 @@ static int __init srpt_init_module(void)
 
 	srpt_target = target_fabric_configfs_init(THIS_MODULE, "srpt");
 	if (IS_ERR(srpt_target)) {
-		printk(KERN_ERR "couldn't register\n");
+		printk(KERN_ERR "ib_srpt: couldn't register\n");
 		ret = PTR_ERR(srpt_target);
 		goto out;
 	}
@@ -4009,13 +4010,13 @@ static int __init srpt_init_module(void)
 
 	ret = target_fabric_configfs_register(srpt_target);
 	if (ret < 0) {
-		printk(KERN_ERR "couldn't register\n");
+		printk(KERN_ERR "ib_srpt: couldn't register\n");
 		goto out_free_target;
 	}
 
 	ret = ib_register_client(&srpt_client);
 	if (ret) {
-		printk(KERN_ERR "couldn't register IB client\n");
+		printk(KERN_ERR "ib_srpt: couldn't register IB client\n");
 		goto out_unregister_target;
 	}
 
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
