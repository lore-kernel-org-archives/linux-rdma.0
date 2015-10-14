From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/6] IB/mad: Create multiple QPs for supporting different P_Keys
Date: Wed, 14 Oct 2015 11:29:47 +0300
Message-ID: <1444811388-22486-6-git-send-email-haggaie@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On devices that do not support sending different P_Keys on a single GSI QP,
create a different UD QP for each non-zero P_Key in the P_Key table. When
transmitting a MAD with a specified P_Key, send it using the right QP.
Receive packets from all the QPs through the common SRQ.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 404 +++++++++++++++++++++++++++----------
 drivers/infiniband/core/mad_priv.h |   4 +-
 2 files changed, 299 insertions(+), 109 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2d4457239908..02977942574c 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -84,6 +84,8 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			      u8 mgmt_class);
 static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			   struct ib_mad_agent_private *agent_priv);
+static void report_mad_completion(struct ib_mad_qp_info *qp_info,
+				  struct ib_mad_send_wr_private *mad_send_wr);
 
 /*
  * Returns a ib_mad_port_private structure or NULL for a device/port
@@ -353,7 +355,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	mad_agent_priv->agent.recv_handler = recv_handler;
 	mad_agent_priv->agent.send_handler = send_handler;
 	mad_agent_priv->agent.context = context;
-	mad_agent_priv->agent.pd = port_priv->qp_info[qpn].qp->pd;
+	mad_agent_priv->agent.pd = port_priv->pd;
 	mad_agent_priv->agent.port_num = port_num;
 	mad_agent_priv->agent.flags = registration_flags;
 	spin_lock_init(&mad_agent_priv->lock);
@@ -518,7 +520,7 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	mad_snoop_priv->agent.recv_handler = recv_handler;
 	mad_snoop_priv->agent.snoop_handler = snoop_handler;
 	mad_snoop_priv->agent.context = context;
-	mad_snoop_priv->agent.pd = port_priv->qp_info[qpn].qp->pd;
+	mad_snoop_priv->agent.pd = port_priv->pd;
 	mad_snoop_priv->agent.port_num = port_num;
 	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
 	init_completion(&mad_snoop_priv->comp);
@@ -829,10 +831,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		goto out;
 	}
 
-	build_smp_wc(mad_agent_priv->qp_info->qp,
+	read_lock_irqsave(&mad_agent_priv->qp_info->qp_lock, flags);
+	build_smp_wc(mad_agent_priv->qp_info->qp[0],
 		     send_wr->wr_id, drslid,
 		     send_wr->wr.ud.pkey_index,
 		     send_wr->wr.ud.port_num, &mad_wc);
+	read_unlock_irqrestore(&mad_agent_priv->qp_info->qp_lock, flags);
 
 	if (opa && smp->base_version == OPA_MGMT_BASE_VERSION) {
 		mad_wc.byte_len = mad_send_wr->send_buf.hdr_len
@@ -1141,6 +1145,46 @@ void ib_free_send_mad(struct ib_mad_send_buf *send_buf)
 }
 EXPORT_SYMBOL(ib_free_send_mad);
 
+static int ib_mad_post_send(struct ib_mad_qp_info *qp_info,
+			    struct ib_mad_send_wr_private *mad_send_wr,
+			    struct ib_send_wr **bad_send_wr)
+{
+	struct ib_qp *qp;
+	u16 pkey_index;
+	unsigned long flags;
+	struct ib_wc;
+	int ret;
+
+	read_lock_irqsave(&qp_info->qp_lock, flags);
+
+	if (!qp_info->srq)
+		pkey_index = 0;
+	else
+		pkey_index = mad_send_wr->send_wr.wr.ud.pkey_index;
+
+	if (pkey_index >= qp_info->num_qps)
+		goto error;
+
+	qp = qp_info->qp[pkey_index];
+	if (!qp)
+		goto error;
+
+	ret = ib_post_send(qp, &mad_send_wr->send_wr, bad_send_wr);
+	read_unlock_irqrestore(&qp_info->qp_lock, flags);
+
+	return ret;
+
+error:
+	read_unlock_irqrestore(&qp_info->qp_lock, flags);
+	dev_dbg(&qp_info->port_priv->device->dev,
+		"ib_mad: failed to send MAD with pkey_index=%d. dropping.\n",
+		pkey_index);
+
+	report_mad_completion(qp_info, mad_send_wr);
+
+	return 0;
+}
+
 int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 {
 	struct ib_mad_qp_info *qp_info;
@@ -1183,8 +1227,7 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 
 	spin_lock_irqsave(&qp_info->send_queue.lock, flags);
 	if (qp_info->send_queue.count < qp_info->send_queue.max_active) {
-		ret = ib_post_send(qp_info->qp, &mad_send_wr->send_wr,
-				   &bad_send_wr);
+		ret = ib_mad_post_send(qp_info, mad_send_wr, &bad_send_wr);
 		list = &qp_info->send_queue.list;
 	} else {
 		ret = 0;
@@ -1795,7 +1838,7 @@ out:
 }
 
 static int validate_mad(const struct ib_mad_hdr *mad_hdr,
-			const struct ib_mad_qp_info *qp_info,
+			struct ib_mad_qp_info *qp_info,
 			bool opa)
 {
 	int valid = 0;
@@ -2461,8 +2504,7 @@ retry:
 	ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
 
 	if (queued_send_wr) {
-		ret = ib_post_send(qp_info->qp, &queued_send_wr->send_wr,
-				   &bad_send_wr);
+		ret = ib_mad_post_send(qp_info, queued_send_wr, &bad_send_wr);
 		if (ret) {
 			dev_err(&port_priv->device->dev,
 				"ib_post_send failed: %d\n", ret);
@@ -2473,6 +2515,18 @@ retry:
 	}
 }
 
+/* Report a successful completion in order to silently drop a MAD. */
+static void report_mad_completion(struct ib_mad_qp_info *qp_info,
+				  struct ib_mad_send_wr_private *mad_send_wr)
+{
+	struct ib_mad_port_private *port_priv = qp_info->port_priv;
+	struct ib_wc wc;
+
+	memset(&wc, 0, sizeof(wc));
+	wc.wr_id = (unsigned long)&mad_send_wr->mad_list;
+	ib_mad_send_done_handler(port_priv, &wc);
+}
+
 static void mark_sends_for_retry(struct ib_mad_qp_info *qp_info)
 {
 	struct ib_mad_send_wr_private *mad_send_wr;
@@ -2519,8 +2573,8 @@ static void mad_error_handler(struct ib_mad_port_private *port_priv,
 			struct ib_send_wr *bad_send_wr;
 
 			mad_send_wr->retry = 0;
-			ret = ib_post_send(qp_info->qp, &mad_send_wr->send_wr,
-					&bad_send_wr);
+			ret = ib_mad_post_send(qp_info, mad_send_wr,
+					       &bad_send_wr);
 			if (ret)
 				ib_mad_send_done_handler(port_priv, wc);
 		} else
@@ -2533,7 +2587,7 @@ static void mad_error_handler(struct ib_mad_port_private *port_priv,
 		if (attr) {
 			attr->qp_state = IB_QPS_RTS;
 			attr->cur_qp_state = IB_QPS_SQE;
-			ret = ib_modify_qp(qp_info->qp, attr,
+			ret = ib_modify_qp(wc->qp, attr,
 					   IB_QP_STATE | IB_QP_CUR_STATE);
 			kfree(attr);
 			if (ret)
@@ -2680,6 +2734,7 @@ static void local_completions(struct work_struct *work)
 	struct ib_mad_agent_private *mad_agent_priv;
 	struct ib_mad_local_private *local;
 	struct ib_mad_agent_private *recv_mad_agent;
+	struct ib_mad_qp_info *qp_info;
 	unsigned long flags;
 	int free_mad;
 	struct ib_wc wc;
@@ -2715,11 +2770,14 @@ static void local_completions(struct work_struct *work)
 			 * Defined behavior is to complete response
 			 * before request
 			 */
-			build_smp_wc(recv_mad_agent->qp_info->qp,
+			qp_info = recv_mad_agent->qp_info;
+			read_lock_irqsave(&qp_info->qp_lock, flags);
+			build_smp_wc(qp_info->qp[0],
 				     (unsigned long) local->mad_send_wr,
 				     be16_to_cpu(IB_LID_PERMISSIVE),
 				     local->mad_send_wr->send_wr.wr.ud.pkey_index,
 				     recv_mad_agent->agent.port_num, &wc);
+			read_unlock_irqrestore(&qp_info->qp_lock, flags);
 
 			local->mad_priv->header.recv_wc.wc = &wc;
 
@@ -2738,9 +2796,9 @@ static void local_completions(struct work_struct *work)
 			local->mad_priv->header.recv_wc.recv_buf.grh = NULL;
 			local->mad_priv->header.recv_wc.recv_buf.mad =
 						(struct ib_mad *)local->mad_priv->mad;
-			if (atomic_read(&recv_mad_agent->qp_info->snoop_count))
-				snoop_recv(recv_mad_agent->qp_info,
-					  &local->mad_priv->header.recv_wc,
+			if (atomic_read(&qp_info->snoop_count))
+				snoop_recv(qp_info,
+					   &local->mad_priv->header.recv_wc,
 					   IB_MAD_SNOOP_RECVS);
 			recv_mad_agent->agent.recv_handler(
 						&recv_mad_agent->agent,
@@ -2925,7 +2983,8 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			ret = ib_post_srq_recv(qp_info->srq, &recv_wr,
 					       &bad_recv_wr);
 		else
-			ret = ib_post_recv(qp_info->qp, &recv_wr, &bad_recv_wr);
+			ret = ib_post_recv(qp_info->qp[0], &recv_wr,
+					   &bad_recv_wr);
 
 		if (ret) {
 			spin_lock_irqsave(&recv_queue->lock, flags);
@@ -2955,9 +3014,6 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 	struct ib_mad_private *recv;
 	struct ib_mad_list_head *mad_list;
 
-	if (!qp_info->qp)
-		return;
-
 	while (!list_empty(&qp_info->recv_queue.list)) {
 
 		mad_list = list_entry(qp_info->recv_queue.list.next,
@@ -2981,6 +3037,57 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 	qp_info->recv_queue.count = 0;
 }
 
+/* Called with qp_rwsem locked for write */
+static int setup_qp(struct ib_mad_port_private *port_priv, struct ib_qp *qp,
+		    u16 pkey_index, struct ib_qp_attr *attr)
+{
+	int mask;
+	int ret;
+
+	/*
+	 * PKey index for QP1 is irrelevant on devices with
+	 * gsi_pkey_index_in_qp=0, but one is needed for the Reset to
+	 * Init transition. On devices with gsi_pkey_index_in_qp=1,
+	 * pkey index determines the pkey to be used for all GMPs.
+	 */
+	mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_QKEY;
+	attr->qp_state = IB_QPS_INIT;
+	attr->pkey_index = pkey_index;
+	attr->qkey = (qp->qp_num == 0) ? 0 : IB_QP1_QKEY;
+	if (qp->qp_type == IB_QPT_UD) {
+		attr->port_num = port_priv->port_num;
+		mask |= IB_QP_PORT;
+	}
+	ret = ib_modify_qp(qp, attr, mask);
+	if (ret) {
+		dev_err(&qp->device->dev,
+			"Couldn't change QP%d state to INIT: %d\n",
+			qp->qp_num, ret);
+		return ret;
+	}
+
+	attr->qp_state = IB_QPS_RTR;
+	ret = ib_modify_qp(qp, attr, IB_QP_STATE);
+	if (ret) {
+		dev_err(&qp->device->dev,
+			"Couldn't change QP%d state to RTR: %d\n",
+			qp->qp_num, ret);
+		return ret;
+	}
+
+	attr->qp_state = IB_QPS_RTS;
+	attr->sq_psn = IB_MAD_SEND_Q_PSN;
+	ret = ib_modify_qp(qp, attr, IB_QP_STATE | IB_QP_SQ_PSN);
+	if (ret) {
+		dev_err(&qp->device->dev,
+			"Couldn't change QP%d state to RTS: %d\n",
+			qp->qp_num, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
 /*
  * Start the port
  */
@@ -2988,8 +3095,6 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 {
 	int ret, i;
 	struct ib_qp_attr *attr;
-	struct ib_qp *qp;
-	u16 pkey_index;
 
 	attr = kmalloc(sizeof *attr, GFP_KERNEL);
 	if (!attr) {
@@ -2998,53 +3103,6 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		return -ENOMEM;
 	}
 
-	ret = ib_find_pkey(port_priv->device, port_priv->port_num,
-			   IB_DEFAULT_PKEY_FULL, &pkey_index);
-	if (ret)
-		pkey_index = 0;
-
-	for (i = 0; i < IB_MAD_QPS_CORE; i++) {
-		qp = port_priv->qp_info[i].qp;
-		if (!qp)
-			continue;
-
-		/*
-		 * PKey index for QP1 is irrelevant but
-		 * one is needed for the Reset to Init transition
-		 */
-		attr->qp_state = IB_QPS_INIT;
-		attr->pkey_index = pkey_index;
-		attr->qkey = (port_priv->qp_info[i].qp_num == 0) ? 0 :
-			     IB_QP1_QKEY;
-		ret = ib_modify_qp(qp, attr, IB_QP_STATE |
-					     IB_QP_PKEY_INDEX | IB_QP_QKEY);
-		if (ret) {
-			dev_err(&port_priv->device->dev,
-				"Couldn't change QP%d state to INIT: %d\n",
-				i, ret);
-			goto out;
-		}
-
-		attr->qp_state = IB_QPS_RTR;
-		ret = ib_modify_qp(qp, attr, IB_QP_STATE);
-		if (ret) {
-			dev_err(&port_priv->device->dev,
-				"Couldn't change QP%d state to RTR: %d\n",
-				i, ret);
-			goto out;
-		}
-
-		attr->qp_state = IB_QPS_RTS;
-		attr->sq_psn = IB_MAD_SEND_Q_PSN;
-		ret = ib_modify_qp(qp, attr, IB_QP_STATE | IB_QP_SQ_PSN);
-		if (ret) {
-			dev_err(&port_priv->device->dev,
-				"Couldn't change QP%d state to RTS: %d\n",
-				i, ret);
-			goto out;
-		}
-	}
-
 	ret = ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
 	if (ret) {
 		dev_err(&port_priv->device->dev,
@@ -3076,17 +3134,23 @@ static void qp_event_handler(struct ib_event *event, void *qp_context)
 	/* It's worse than that! He's dead, Jim! */
 	dev_err(&qp_info->port_priv->device->dev,
 		"Fatal error (%d) on MAD QP (%d)\n",
-		event->event, qp_info->qp->qp_num);
+		event->event, event->element.qp->qp_num);
 }
 
 static void srq_event_handler(struct ib_event *event, void *srq_context)
 {
 	struct ib_mad_qp_info	*qp_info = srq_context;
+	int qp_num;
+	unsigned long flags;
+
+	read_lock_irqsave(&qp_info->qp_lock, flags);
+	qp_num = qp_info->qp[0]->qp_num;
+	read_unlock_irqrestore(&qp_info->qp_lock, flags);
 
 	/* We aren't expecting limit reached events, so this must be an error */
 	dev_err(&qp_info->port_priv->device->dev,
 		"Fatal error (%d) on MAD SRQ (QP%d)\n",
-		event->event, qp_info->qp->qp_num);
+		event->event, qp_num);
 }
 
 static void init_mad_queue(struct ib_mad_qp_info *qp_info,
@@ -3102,6 +3166,7 @@ static void init_mad_qp(struct ib_mad_port_private *port_priv,
 			struct ib_mad_qp_info *qp_info)
 {
 	qp_info->port_priv = port_priv;
+	rwlock_init(&qp_info->qp_lock);
 	init_mad_queue(qp_info, &qp_info->send_queue);
 	init_mad_queue(qp_info, &qp_info->recv_queue);
 	INIT_LIST_HEAD(&qp_info->overflow_list);
@@ -3111,12 +3176,161 @@ static void init_mad_qp(struct ib_mad_port_private *port_priv,
 	atomic_set(&qp_info->snoop_count, 0);
 }
 
+static struct ib_qp *create_qp(struct ib_mad_qp_info *qp_info,
+			       enum ib_qp_type qp_type)
+{
+	struct ib_qp_init_attr	qp_init_attr;
+	struct ib_qp *qp;
+
+	memset(&qp_init_attr, 0, sizeof(qp_init_attr));
+	qp_init_attr.send_cq = qp_info->port_priv->cq;
+	qp_init_attr.recv_cq = qp_info->port_priv->cq;
+	qp_init_attr.srq = qp_info->srq;
+	qp_init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
+	qp_init_attr.cap.max_send_wr = mad_sendq_size;
+	qp_init_attr.cap.max_send_sge = IB_MAD_SEND_REQ_MAX_SG;
+	if (!qp_info->srq) {
+		qp_init_attr.cap.max_recv_wr = mad_recvq_size;
+		qp_init_attr.cap.max_recv_sge = IB_MAD_RECV_REQ_MAX_SG;
+	}
+	qp_init_attr.qp_type = qp_type;
+	qp_init_attr.port_num = qp_info->port_priv->port_num;
+	qp_init_attr.qp_context = qp_info;
+	qp_init_attr.event_handler = qp_event_handler;
+
+	qp = ib_create_qp(qp_info->port_priv->pd, &qp_init_attr);
+	if (IS_ERR(qp)) {
+		dev_err(&qp_info->port_priv->device->dev,
+			"Couldn't create ib_mad QP%d\n",
+			get_spl_qp_index(qp_type));
+	}
+
+	return qp;
+}
+
+static u16 max_pkeys(struct ib_mad_port_private *port_priv)
+{
+	struct ib_device *device = port_priv->device;
+	struct ib_device_attr attr;
+	int ret;
+
+	ret = ib_query_device(device, &attr);
+	if (ret) {
+		WARN_ONCE(1, "ib_query_device failed");
+		return 0;
+	}
+
+	return attr.max_pkeys;
+}
+
+/* Return 0 if the QP should be created with the pkey_index set. Returns an
+ * error if the QP should not be created (a zero P_Key or qp_index >0 for
+ * SMI).
+ */
+static int get_pkey_index(struct ib_mad_qp_info *qp_info, u16 qp_index,
+			  u16 *pkey_index)
+{
+	struct ib_device *device = qp_info->port_priv->device;
+	const int port_num = qp_info->port_priv->port_num;
+	u16 pkey;
+	int ret;
+
+	if (qp_info->qp_type == IB_QPT_SMI) {
+		if (qp_index > 0)
+			return -ENOENT;
+
+		ret = ib_find_pkey(device, port_num, IB_DEFAULT_PKEY_FULL,
+				   pkey_index);
+		if (ret)
+			*pkey_index = 0;
+
+		return 0;
+	}
+
+	*pkey_index = qp_index;
+	ret = ib_query_pkey(device, port_num, *pkey_index, &pkey);
+	if (!ret && !pkey)
+		ret = -ENOENT;
+	return ret;
+}
+
+static int update_pkey_table(struct ib_mad_qp_info *qp_info)
+{
+	struct ib_device *device = qp_info->port_priv->device;
+	const int num_qps = qp_info->num_qps;
+	struct ib_qp *qp;
+	struct ib_qp_attr attr;
+	u16 pkey_index;
+	u16 qp_index;
+	unsigned long flags;
+	int ret = 0;
+
+	for (qp_index = 0; qp_index < num_qps; ++qp_index) {
+		const enum ib_qp_type qp_type = qp_index == 0 ?
+			qp_info->qp_type : IB_QPT_UD;
+
+		ret = get_pkey_index(qp_info, qp_index, &pkey_index);
+		if (ret)
+			/* TODO it would be nice to destroy unused QPs */
+			continue;
+
+		read_lock_irqsave(&qp_info->qp_lock, flags);
+		if (qp_info->qp[qp_index]) {
+			dev_dbg(&device->dev, "Skipping creation of already existing QP at index %d\n",
+				qp_index);
+			read_unlock_irqrestore(&qp_info->qp_lock, flags);
+			continue;
+		}
+		read_unlock_irqrestore(&qp_info->qp_lock, flags);
+
+		qp = create_qp(qp_info, qp_type);
+		if (IS_ERR(qp))
+			return PTR_ERR(qp);
+
+		dev_dbg(&device->dev, "ib_mad: setting up QP%d, qp_index=%hu, pkey_index=%hu, port_num=%d\n",
+			qp->qp_num, qp_index, pkey_index,
+			qp_info->port_priv->port_num);
+
+		ret = setup_qp(qp_info->port_priv, qp, pkey_index, &attr);
+		if (ret) {
+			WARN_ON_ONCE(ib_destroy_qp(qp));
+			return ret;
+		}
+
+		write_lock_irqsave(&qp_info->qp_lock, flags);
+		WARN_ON(qp_info->qp[qp_index]);
+		qp_info->qp[qp_index] = qp;
+		write_unlock_irqrestore(&qp_info->qp_lock, flags);
+	}
+
+	return 0;
+}
+
+static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
+{
+	u16 qp_index;
+
+	if (!qp_info->qp)
+		return;
+
+	for (qp_index = 0; qp_index < qp_info->num_qps; ++qp_index) {
+		if (qp_info->qp[qp_index])
+			WARN_ON_ONCE(ib_destroy_qp(qp_info->qp[qp_index]));
+	}
+	kfree(qp_info->qp);
+	qp_info->qp = NULL;
+	if (qp_info->srq) {
+		WARN_ON(ib_destroy_srq(qp_info->srq));
+		qp_info->srq = NULL;
+	}
+	kfree(qp_info->snoop_table);
+}
+
 static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 			 enum ib_qp_type qp_type)
 {
 	struct ib_device *device = qp_info->port_priv->device;
 	struct ib_srq_init_attr srq_init_attr;
-	struct ib_qp_init_attr	qp_init_attr;
 	struct ib_srq *srq = NULL;
 	const bool multiple_qps = qp_type == IB_QPT_GSI &&
 				  device->gsi_pkey_index_in_qp;
@@ -3142,55 +3356,29 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 	}
 	qp_info->srq = srq;
 
-	memset(&qp_init_attr, 0, sizeof qp_init_attr);
-	qp_init_attr.send_cq = qp_info->port_priv->cq;
-	qp_init_attr.recv_cq = qp_info->port_priv->cq;
-	qp_init_attr.srq = srq;
-	qp_init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
-	qp_init_attr.cap.max_send_wr = mad_sendq_size;
-	qp_init_attr.cap.max_send_sge = IB_MAD_SEND_REQ_MAX_SG;
-	if (!srq) {
-		qp_init_attr.cap.max_recv_wr = mad_recvq_size;
-		qp_init_attr.cap.max_recv_sge = IB_MAD_RECV_REQ_MAX_SG;
-	}
-	qp_init_attr.qp_type = qp_type;
-	qp_init_attr.port_num = qp_info->port_priv->port_num;
-	qp_init_attr.qp_context = qp_info;
-	qp_init_attr.event_handler = qp_event_handler;
-	qp_info->qp = ib_create_qp(qp_info->port_priv->pd, &qp_init_attr);
-	if (IS_ERR(qp_info->qp)) {
-		dev_err(&qp_info->port_priv->device->dev,
-			"Couldn't create ib_mad QP%d\n",
-			get_spl_qp_index(qp_type));
-		ret = PTR_ERR(qp_info->qp);
+	qp_info->num_qps = multiple_qps ? max_pkeys(qp_info->port_priv) : 1;
+	qp_info->qp = kcalloc(qp_info->num_qps, sizeof(*qp_info->qp),
+			      GFP_KERNEL);
+	if (!qp_info->qp) {
+		ret = -ENOMEM;
 		goto error_qp;
 	}
+	ret = update_pkey_table(qp_info);
+	if (ret)
+		goto error_qp;
+
 	/* Use minimum queue sizes unless the CQ is resized */
 	qp_info->send_queue.max_active = mad_sendq_size;
 	qp_info->recv_queue.max_active = mad_recvq_size;
-	qp_info->qp_num = qp_info->qp->qp_num;
+	qp_info->qp_num = qp_info->qp[0]->qp_num;
 	return 0;
 
 error_qp:
-	if (srq) {
-		WARN_ON(ib_destroy_srq(srq));
-		qp_info->srq = NULL;
-	}
+	destroy_mad_qp(qp_info);
 error_srq:
 	return ret;
 }
 
-static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
-{
-	if (!qp_info->qp)
-		return;
-
-	ib_destroy_qp(qp_info->qp);
-	if (qp_info->srq)
-		WARN_ON(ib_destroy_srq(qp_info->srq));
-	kfree(qp_info->snoop_table);
-}
-
 /*
  * Open the port
  * Create the QP, PD, MR, and CQ if needed
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 0c3b7c576f3a..32b9532c7868 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -183,7 +183,9 @@ struct ib_mad_queue {
 
 struct ib_mad_qp_info {
 	struct ib_mad_port_private *port_priv;
-	struct ib_qp *qp;
+	rwlock_t qp_lock; /* Protects the contents of the qp array */
+	struct ib_qp **qp;
+	int num_qps;
 	struct ib_srq *srq;
 	struct ib_mad_queue send_queue;
 	struct ib_mad_queue recv_queue;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
