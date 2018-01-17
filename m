From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 12/14] IB/srpt: Prepare RDMA/CM support
Date: Tue, 16 Jan 2018 16:14:16 -0800
Message-ID: <20180117001418.7852-13-bart.vanassche@wdc.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce a union in struct srpt_rdma_ch for member variables that
depend on the type of connection manager. Avoid that error messages
report the IB/CM ID.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 32 ++++++++++++++++----------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  8 ++++++--
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 5b2e74b1d808..f066fac19f13 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -215,12 +215,12 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
  */
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
-	pr_debug("QP event %d on cm_id=%p sess_name=%s state=%d\n",
-		 event->event, ch->cm_id, ch->sess_name, ch->state);
+	pr_debug("QP event %d on ch=%p sess_name=%s state=%d\n",
+		 event->event, ch, ch->sess_name, ch->state);
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
-		ib_cm_notify(ch->cm_id, event->event);
+		ib_cm_notify(ch->ib_cm.cm_id, event->event);
 		break;
 	case IB_EVENT_QP_LAST_WQE_REACHED:
 		pr_debug("%s-%d, state %s: received Last WQE event.\n",
@@ -1097,7 +1097,7 @@ static int srpt_ch_qp_rtr(struct srpt_rdma_ch *ch, struct ib_qp *qp)
 	int ret;
 
 	qp_attr.qp_state = IB_QPS_RTR;
-	ret = ib_cm_init_qp_attr(ch->cm_id, &qp_attr, &attr_mask);
+	ret = ib_cm_init_qp_attr(ch->ib_cm.cm_id, &qp_attr, &attr_mask);
 	if (ret)
 		goto out;
 
@@ -1127,7 +1127,7 @@ static int srpt_ch_qp_rts(struct srpt_rdma_ch *ch, struct ib_qp *qp)
 	int ret;
 
 	qp_attr.qp_state = IB_QPS_RTS;
-	ret = ib_cm_init_qp_attr(ch->cm_id, &qp_attr, &attr_mask);
+	ret = ib_cm_init_qp_attr(ch->ib_cm.cm_id, &qp_attr, &attr_mask);
 	if (ret)
 		goto out;
 
@@ -1509,9 +1509,9 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	srp_tsk = recv_ioctx->ioctx.buf;
 	cmd = &send_ioctx->cmd;
 
-	pr_debug("recv tsk_mgmt fn %d for task_tag %lld and cmd tag %lld"
-		 " cm_id %p sess %p\n", srp_tsk->tsk_mgmt_func,
-		 srp_tsk->task_tag, srp_tsk->tag, ch->cm_id, ch->sess);
+	pr_debug("recv tsk_mgmt fn %d for task_tag %lld and cmd tag %lld ch %p sess %p\n",
+		 srp_tsk->tsk_mgmt_func, srp_tsk->task_tag, srp_tsk->tag, ch,
+		 ch->sess);
 
 	srpt_set_cmd_state(send_ioctx, SRPT_STATE_MGMT);
 	send_ioctx->cmd.tag = srp_tsk->tag;
@@ -1762,9 +1762,9 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 
 	atomic_set(&ch->sq_wr_avail, qp_init->cap.max_send_wr);
 
-	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
+	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d ch= %p\n",
 		 __func__, ch->cq->cqe, qp_init->cap.max_send_sge,
-		 qp_init->cap.max_send_wr, ch->cm_id);
+		 qp_init->cap.max_send_wr, ch);
 
 	ret = srpt_init_ch_qp(ch, ch->qp);
 	if (ret)
@@ -1849,9 +1849,9 @@ static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 	if (!srpt_set_ch_state(ch, CH_DISCONNECTING))
 		return -ENOTCONN;
 
-	ret = ib_send_cm_dreq(ch->cm_id, NULL, 0);
+	ret = ib_send_cm_dreq(ch->ib_cm.cm_id, NULL, 0);
 	if (ret < 0)
-		ret = ib_send_cm_drep(ch->cm_id, NULL, 0);
+		ret = ib_send_cm_drep(ch->ib_cm.cm_id, NULL, 0);
 
 	if (ret < 0 && srpt_close_ch(ch))
 		ret = 0;
@@ -2003,7 +2003,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	transport_deregister_session(se_sess);
 	ch->sess = NULL;
 
-	ib_destroy_cm_id(ch->cm_id);
+	ib_destroy_cm_id(ch->ib_cm.cm_id);
 
 	srpt_destroy_ch_ib(ch);
 
@@ -2118,7 +2118,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
 	ch->sport = &sdev->port[param->port - 1];
-	ch->cm_id = cm_id;
+	ch->ib_cm.cm_id = cm_id;
 	cm_id->context = ch;
 	/*
 	 * ch->rq_size should be at least as large as the initiator queue
@@ -2239,8 +2239,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 
-	pr_debug("Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
-		 ch->sess_name, ch->cm_id);
+	pr_debug("Establish connection sess=%p name=%s ch=%p\n", ch->sess,
+		 ch->sess_name, ch);
 
 	/* create srp_login_response */
 	rsp->opcode = SRP_LOGIN_RSP;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 10f9b2667ef2..4d9199fd00dc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -243,8 +243,8 @@ enum rdma_ch_state {
 /**
  * struct srpt_rdma_ch - RDMA channel
  * @nexus:         I_T nexus this channel is associated with.
- * @cm_id:         IB CM ID associated with the channel.
  * @qp:            IB queue pair used for communicating over this channel.
+ * @cm_id:         IB CM ID associated with the channel.
  * @cq:            IB completion queue for this channel.
  * @zw_cqe:	   Zero-length write CQE.
  * @rcu:           RCU head.
@@ -275,8 +275,12 @@ enum rdma_ch_state {
  */
 struct srpt_rdma_ch {
 	struct srpt_nexus	*nexus;
-	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
+	union {
+		struct {
+			struct ib_cm_id		*cm_id;
+		} ib_cm;
+	};
 	struct ib_cq		*cq;
 	struct ib_cqe		zw_cqe;
 	struct rcu_head		rcu;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
