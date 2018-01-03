From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 23/28] IB/srpt: Fix login-related race conditions
Date: Wed,  3 Jan 2018 13:39:33 -0800
Message-ID: <20180103213938.11664-24-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make sure that sport->mutex is not released between the duplicate
channel check, adding a channel to the channel list and performing
the sport enabled check. Avoid that srpt_disconnect_ch() can be
invoked concurrently with the ib_send_cm_rep() call by
srpt_cm_req_recv().

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 195 +++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 84 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3a25eca81871..b6544112a321 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1975,7 +1975,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srpt_rdma_ch *ch;
 	char *ini_guid, i_port_id[36];
 	u32 it_iu_len;
-	int i, ret = 0;
+	int i, ret;
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -1998,69 +1998,43 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto out;
 	}
 
+	ret = -ENOMEM;
 	rsp = kzalloc(sizeof(*rsp), GFP_KERNEL);
 	rej = kzalloc(sizeof(*rej), GFP_KERNEL);
 	rep_param = kzalloc(sizeof(*rep_param), GFP_KERNEL);
-
-	if (!rsp || !rej || !rep_param) {
-		ret = -ENOMEM;
+	if (!rsp || !rej || !rep_param)
 		goto out;
-	}
 
+	ret = -EINVAL;
 	if (it_iu_len > srp_max_req_size || it_iu_len < 64) {
 		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE);
-		ret = -EINVAL;
-		pr_err("rejected SRP_LOGIN_REQ because its"
-		       " length (%d bytes) is out of range (%d .. %d)\n",
+				SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE);
+		pr_err("rejected SRP_LOGIN_REQ because its length (%d bytes) is out of range (%d .. %d)\n",
 		       it_iu_len, 64, srp_max_req_size);
 		goto reject;
 	}
 
 	if (!sport->enabled) {
-		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		ret = -EINVAL;
-		pr_err("rejected SRP_LOGIN_REQ because the target port"
-		       " has not yet been enabled\n");
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_info("rejected SRP_LOGIN_REQ because target port %s_%d has not yet been enabled\n",
+			sport->sdev->device->name, param->port);
 		goto reject;
 	}
 
-	if ((req->req_flags & SRP_MTCH_ACTION) == SRP_MULTICHAN_SINGLE) {
-		struct srpt_rdma_ch *ch2;
-
-		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_NO_CHAN;
-
-		mutex_lock(&sport->mutex);
-		list_for_each_entry(ch2, &nexus->ch_list, list) {
-			if (srpt_disconnect_ch(ch2) < 0)
-				continue;
-			pr_info("Relogin - closed existing channel %s\n",
-				ch2->sess_name);
-			rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
-		}
-		mutex_unlock(&sport->mutex);
-	} else {
-		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_MAINTAINED;
-	}
-
 	if (*(__be64 *)req->target_port_id != cpu_to_be64(srpt_service_guid)
 	    || *(__be64 *)(req->target_port_id + 8) !=
 	       cpu_to_be64(srpt_service_guid)) {
 		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL);
-		ret = -ENOMEM;
-		pr_err("rejected SRP_LOGIN_REQ because it"
-		       " has an invalid target port identifier.\n");
+				SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL);
+		pr_err("rejected SRP_LOGIN_REQ because it has an invalid target port identifier.\n");
 		goto reject;
 	}
 
+	ret = -ENOMEM;
 	ch = kzalloc(sizeof(*ch), GFP_KERNEL);
 	if (!ch) {
-		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_err("rejected SRP_LOGIN_REQ because no memory.\n");
-		ret = -ENOMEM;
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_err("rejected SRP_LOGIN_REQ because out of memory.\n");
 		goto reject;
 	}
 
@@ -2088,8 +2062,11 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
 				      sizeof(*ch->ioctx_ring[0]),
 				      ch->max_rsp_size, DMA_TO_DEVICE);
-	if (!ch->ioctx_ring)
+	if (!ch->ioctx_ring) {
+		pr_err("rejected SRP_LOGIN_REQ because creating a new QP SQ ring failed.\n");
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		goto free_ch;
+	}
 
 	INIT_LIST_HEAD(&ch->free_list);
 	for (i = 0; i < ch->rq_size; i++) {
@@ -2111,20 +2088,10 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	ret = srpt_create_ch_ib(ch);
-	if (ret) {
-		rej->reason = cpu_to_be32(
-			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_err("rejected SRP_LOGIN_REQ because creating"
-		       " a new RDMA channel failed.\n");
-		goto free_recv_ring;
-	}
-
-	ret = srpt_ch_qp_rtr(ch, ch->qp);
 	if (ret) {
 		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
-		pr_err("rejected SRP_LOGIN_REQ because enabling"
-		       " RTR failed (error code = %d)\n", ret);
-		goto destroy_ib;
+		pr_err("rejected SRP_LOGIN_REQ because creating a new RDMA channel failed.\n");
+		goto free_recv_ring;
 	}
 
 	srpt_format_guid(ch->sess_name, sizeof(ch->sess_name),
@@ -2150,11 +2117,51 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 						TARGET_PROT_NORMAL,
 						i_port_id + 2, ch, NULL);
 	if (IS_ERR_OR_NULL(ch->sess)) {
-		pr_info("Rejected login because no ACL has been configured yet for initiator %s.\n",
-			ch->sess_name);
-		rej->reason = cpu_to_be32((PTR_ERR(ch->sess) == -ENOMEM) ?
+		ret = PTR_ERR(ch->sess);
+		pr_info("Rejected login for initiator %s: ret = %d.\n",
+			ch->sess_name, ret);
+		rej->reason = cpu_to_be32(ret == -ENOMEM ?
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES :
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
+		goto reject;
+	}
+
+	mutex_lock(&sport->mutex);
+
+	if ((req->req_flags & SRP_MTCH_ACTION) == SRP_MULTICHAN_SINGLE) {
+		struct srpt_rdma_ch *ch2;
+
+		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_NO_CHAN;
+
+		list_for_each_entry(ch2, &nexus->ch_list, list) {
+			if (srpt_disconnect_ch(ch2) < 0)
+				continue;
+			pr_info("Relogin - closed existing channel %s\n",
+				ch2->sess_name);
+			rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
+		}
+	} else {
+		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_MAINTAINED;
+	}
+
+	list_add_tail_rcu(&ch->list, &nexus->ch_list);
+
+	if (!sport->enabled) {
+		rej->reason = cpu_to_be32(
+				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_info("rejected SRP_LOGIN_REQ because target %s_%d is not enabled\n",
+			sdev->device->name, param->port);
+		mutex_unlock(&sport->mutex);
+		goto reject;
+	}
+
+	mutex_unlock(&sport->mutex);
+
+	ret = srpt_ch_qp_rtr(ch, ch->qp);
+	if (ret) {
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_err("rejected SRP_LOGIN_REQ because enabling RTR failed (error code = %d)\n",
+		       ret);
 		goto destroy_ib;
 	}
 
@@ -2167,8 +2174,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	rsp->max_it_iu_len = req->req_it_iu_len;
 	rsp->max_ti_iu_len = req->req_it_iu_len;
 	ch->max_ti_iu_len = it_iu_len;
-	rsp->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT
-				   | SRP_BUF_FORMAT_INDIRECT);
+	rsp->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+				   SRP_BUF_FORMAT_INDIRECT);
 	rsp->req_lim_delta = cpu_to_be32(ch->rq_size);
 	atomic_set(&ch->req_lim, ch->rq_size);
 	atomic_set(&ch->req_lim_delta, 0);
@@ -2184,24 +2191,30 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	rep_param->responder_resources = 4;
 	rep_param->initiator_depth = 4;
 
-	ret = ib_send_cm_rep(cm_id, rep_param);
-	if (ret) {
-		pr_err("sending SRP_LOGIN_REQ response failed"
-		       " (error code = %d)\n", ret);
-		goto release_channel;
-	}
-
+	/*
+	 * Hold the sport mutex while accepting a connection to avoid that
+	 * srpt_disconnect_ch() is invoked concurrently with this code.
+	 */
 	mutex_lock(&sport->mutex);
-	list_add_tail_rcu(&ch->list, &nexus->ch_list);
+	if (sport->enabled && ch->state == CH_CONNECTING) {
+		ret = ib_send_cm_rep(cm_id, rep_param);
+	} else {
+		ret = -EINVAL;
+	}
 	mutex_unlock(&sport->mutex);
 
-	goto out;
+	switch (ret) {
+	case 0:
+		break;
+	case -EINVAL:
+		goto reject;
+	default:
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_err("sending SRP_LOGIN_REQ response failed (error code = %d)\n", ret);
+		goto reject;
+	}
 
-release_channel:
-	srpt_disconnect_ch(ch);
-	transport_deregister_session_configfs(ch->sess);
-	transport_deregister_session(ch->sess);
-	ch->sess = NULL;
+	goto out;
 
 destroy_ib:
 	srpt_destroy_ch_ib(ch);
@@ -2216,13 +2229,18 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			     ch->sport->sdev, ch->rq_size,
 			     ch->max_rsp_size, DMA_TO_DEVICE);
 free_ch:
+	cm_id->context = NULL;
 	kfree(ch);
+	ch = NULL;
+
+	WARN_ON_ONCE(ret == 0);
 
 reject:
+	pr_info("Rejecting login with reason %#x\n", be32_to_cpu(rej->reason));
 	rej->opcode = SRP_LOGIN_REJ;
 	rej->tag = req->tag;
-	rej->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT
-				   | SRP_BUF_FORMAT_INDIRECT);
+	rej->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+				   SRP_BUF_FORMAT_INDIRECT);
 
 	ib_send_cm_rej(cm_id, IB_CM_REJ_CONSUMER_DEFINED, NULL, 0,
 			     (void *)rej, sizeof(*rej));
@@ -2264,17 +2282,26 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 {
 	int ret;
 
-	if (srpt_set_ch_state(ch, CH_LIVE)) {
-		ret = srpt_ch_qp_rts(ch, ch->qp);
-
-		if (ret == 0) {
-			/* Trigger wait list processing. */
-			ret = srpt_zerolength_write(ch);
-			WARN_ONCE(ret < 0, "%d\n", ret);
-		} else {
-			srpt_close_ch(ch);
-		}
+	ret = srpt_ch_qp_rts(ch, ch->qp);
+	if (ret < 0) {
+		pr_err("%s-%d: QP transition to RTS failed\n", ch->sess_name,
+		       ch->qp->qp_num);
+		srpt_close_ch(ch);
+		return;
 	}
+
+	/* Trigger wait list processing. */
+	ret = srpt_zerolength_write(ch);
+	WARN_ONCE(ret < 0, "%d\n", ret);
+
+	/*
+	 * Note: calling srpt_close_ch() if the transition to the LIVE state
+	 * fails is not necessary since that means that that function has
+	 * already been invoked from another thread.
+	 */
+	if (!srpt_set_ch_state(ch, CH_LIVE))
+		pr_err("%s-%d: channel transition to LIVE state failed\n",
+		       ch->sess_name, ch->qp->qp_num);
 }
 
 /*
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
