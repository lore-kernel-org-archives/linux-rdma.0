From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH RFC] IB/mad: remove obsolete snoop interface
Date: Wed, 30 Sep 2015 02:01:04 -0400
Message-ID: <1443592864-32019-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This interface has no current users and is obsolete.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

This has undergone a medium level of testing.  I have run it against
mlx4, qib, and OPA hardware and it does not seem to cause any regressions.

 drivers/infiniband/core/mad.c      | 226 +------------------------------------
 drivers/infiniband/core/mad_priv.h |  13 ---
 2 files changed, 5 insertions(+), 234 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 4b5c72311deb..08ab92604e88 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -428,132 +428,12 @@ error1:
 }
 EXPORT_SYMBOL(ib_register_mad_agent);
 
-static inline int is_snooping_sends(int mad_snoop_flags)
-{
-	return (mad_snoop_flags &
-		(/*IB_MAD_SNOOP_POSTED_SENDS |
-		 IB_MAD_SNOOP_RMPP_SENDS |*/
-		 IB_MAD_SNOOP_SEND_COMPLETIONS /*|
-		 IB_MAD_SNOOP_RMPP_SEND_COMPLETIONS*/));
-}
-
-static inline int is_snooping_recvs(int mad_snoop_flags)
-{
-	return (mad_snoop_flags &
-		(IB_MAD_SNOOP_RECVS /*|
-		 IB_MAD_SNOOP_RMPP_RECVS*/));
-}
-
-static int register_snoop_agent(struct ib_mad_qp_info *qp_info,
-				struct ib_mad_snoop_private *mad_snoop_priv)
-{
-	struct ib_mad_snoop_private **new_snoop_table;
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&qp_info->snoop_lock, flags);
-	/* Check for empty slot in array. */
-	for (i = 0; i < qp_info->snoop_table_size; i++)
-		if (!qp_info->snoop_table[i])
-			break;
-
-	if (i == qp_info->snoop_table_size) {
-		/* Grow table. */
-		new_snoop_table = krealloc(qp_info->snoop_table,
-					   sizeof mad_snoop_priv *
-					   (qp_info->snoop_table_size + 1),
-					   GFP_ATOMIC);
-		if (!new_snoop_table) {
-			i = -ENOMEM;
-			goto out;
-		}
-
-		qp_info->snoop_table = new_snoop_table;
-		qp_info->snoop_table_size++;
-	}
-	qp_info->snoop_table[i] = mad_snoop_priv;
-	atomic_inc(&qp_info->snoop_count);
-out:
-	spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-	return i;
-}
-
-struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
-					   u8 port_num,
-					   enum ib_qp_type qp_type,
-					   int mad_snoop_flags,
-					   ib_mad_snoop_handler snoop_handler,
-					   ib_mad_recv_handler recv_handler,
-					   void *context)
-{
-	struct ib_mad_port_private *port_priv;
-	struct ib_mad_agent *ret;
-	struct ib_mad_snoop_private *mad_snoop_priv;
-	int qpn;
-
-	/* Validate parameters */
-	if ((is_snooping_sends(mad_snoop_flags) && !snoop_handler) ||
-	    (is_snooping_recvs(mad_snoop_flags) && !recv_handler)) {
-		ret = ERR_PTR(-EINVAL);
-		goto error1;
-	}
-	qpn = get_spl_qp_index(qp_type);
-	if (qpn == -1) {
-		ret = ERR_PTR(-EINVAL);
-		goto error1;
-	}
-	port_priv = ib_get_mad_port(device, port_num);
-	if (!port_priv) {
-		ret = ERR_PTR(-ENODEV);
-		goto error1;
-	}
-	/* Allocate structures */
-	mad_snoop_priv = kzalloc(sizeof *mad_snoop_priv, GFP_KERNEL);
-	if (!mad_snoop_priv) {
-		ret = ERR_PTR(-ENOMEM);
-		goto error1;
-	}
-
-	/* Now, fill in the various structures */
-	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
-	mad_snoop_priv->agent.device = device;
-	mad_snoop_priv->agent.recv_handler = recv_handler;
-	mad_snoop_priv->agent.snoop_handler = snoop_handler;
-	mad_snoop_priv->agent.context = context;
-	mad_snoop_priv->agent.qp = port_priv->qp_info[qpn].qp;
-	mad_snoop_priv->agent.port_num = port_num;
-	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
-	init_completion(&mad_snoop_priv->comp);
-	mad_snoop_priv->snoop_index = register_snoop_agent(
-						&port_priv->qp_info[qpn],
-						mad_snoop_priv);
-	if (mad_snoop_priv->snoop_index < 0) {
-		ret = ERR_PTR(mad_snoop_priv->snoop_index);
-		goto error2;
-	}
-
-	atomic_set(&mad_snoop_priv->refcount, 1);
-	return &mad_snoop_priv->agent;
-
-error2:
-	kfree(mad_snoop_priv);
-error1:
-	return ret;
-}
-EXPORT_SYMBOL(ib_register_mad_snoop);
-
 static inline void deref_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 {
 	if (atomic_dec_and_test(&mad_agent_priv->refcount))
 		complete(&mad_agent_priv->comp);
 }
 
-static inline void deref_snoop_agent(struct ib_mad_snoop_private *mad_snoop_priv)
-{
-	if (atomic_dec_and_test(&mad_snoop_priv->refcount))
-		complete(&mad_snoop_priv->comp);
-}
-
 static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 {
 	struct ib_mad_port_private *port_priv;
@@ -584,43 +464,17 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	kfree(mad_agent_priv);
 }
 
-static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
-{
-	struct ib_mad_qp_info *qp_info;
-	unsigned long flags;
-
-	qp_info = mad_snoop_priv->qp_info;
-	spin_lock_irqsave(&qp_info->snoop_lock, flags);
-	qp_info->snoop_table[mad_snoop_priv->snoop_index] = NULL;
-	atomic_dec(&qp_info->snoop_count);
-	spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-
-	deref_snoop_agent(mad_snoop_priv);
-	wait_for_completion(&mad_snoop_priv->comp);
-
-	kfree(mad_snoop_priv);
-}
-
 /*
  * ib_unregister_mad_agent - Unregisters a client from using MAD services
  */
 int ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
 {
 	struct ib_mad_agent_private *mad_agent_priv;
-	struct ib_mad_snoop_private *mad_snoop_priv;
-
-	/* If the TID is zero, the agent can only snoop. */
-	if (mad_agent->hi_tid) {
-		mad_agent_priv = container_of(mad_agent,
-					      struct ib_mad_agent_private,
-					      agent);
-		unregister_mad_agent(mad_agent_priv);
-	} else {
-		mad_snoop_priv = container_of(mad_agent,
-					      struct ib_mad_snoop_private,
-					      agent);
-		unregister_mad_snoop(mad_snoop_priv);
-	}
+
+	mad_agent_priv = container_of(mad_agent,
+				      struct ib_mad_agent_private,
+				      agent);
+	unregister_mad_agent(mad_agent_priv);
 	return 0;
 }
 EXPORT_SYMBOL(ib_unregister_mad_agent);
@@ -638,57 +492,6 @@ static void dequeue_mad(struct ib_mad_list_head *mad_list)
 	spin_unlock_irqrestore(&mad_queue->lock, flags);
 }
 
-static void snoop_send(struct ib_mad_qp_info *qp_info,
-		       struct ib_mad_send_buf *send_buf,
-		       struct ib_mad_send_wc *mad_send_wc,
-		       int mad_snoop_flags)
-{
-	struct ib_mad_snoop_private *mad_snoop_priv;
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&qp_info->snoop_lock, flags);
-	for (i = 0; i < qp_info->snoop_table_size; i++) {
-		mad_snoop_priv = qp_info->snoop_table[i];
-		if (!mad_snoop_priv ||
-		    !(mad_snoop_priv->mad_snoop_flags & mad_snoop_flags))
-			continue;
-
-		atomic_inc(&mad_snoop_priv->refcount);
-		spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-		mad_snoop_priv->agent.snoop_handler(&mad_snoop_priv->agent,
-						    send_buf, mad_send_wc);
-		deref_snoop_agent(mad_snoop_priv);
-		spin_lock_irqsave(&qp_info->snoop_lock, flags);
-	}
-	spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-}
-
-static void snoop_recv(struct ib_mad_qp_info *qp_info,
-		       struct ib_mad_recv_wc *mad_recv_wc,
-		       int mad_snoop_flags)
-{
-	struct ib_mad_snoop_private *mad_snoop_priv;
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&qp_info->snoop_lock, flags);
-	for (i = 0; i < qp_info->snoop_table_size; i++) {
-		mad_snoop_priv = qp_info->snoop_table[i];
-		if (!mad_snoop_priv ||
-		    !(mad_snoop_priv->mad_snoop_flags & mad_snoop_flags))
-			continue;
-
-		atomic_inc(&mad_snoop_priv->refcount);
-		spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-		mad_snoop_priv->agent.recv_handler(&mad_snoop_priv->agent,
-						   mad_recv_wc);
-		deref_snoop_agent(mad_snoop_priv);
-		spin_lock_irqsave(&qp_info->snoop_lock, flags);
-	}
-	spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-}
-
 static void build_smp_wc(struct ib_qp *qp,
 			 u64 wr_id, u16 slid, u16 pkey_index, u8 port_num,
 			 struct ib_wc *wc)
@@ -2211,9 +2014,6 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	recv->header.recv_wc.recv_buf.mad = (struct ib_mad *)recv->mad;
 	recv->header.recv_wc.recv_buf.grh = &recv->grh;
 
-	if (atomic_read(&qp_info->snoop_count))
-		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
-
 	/* Validate MAD */
 	if (!validate_mad((const struct ib_mad_hdr *)recv->mad, qp_info, opa))
 		goto out;
@@ -2451,9 +2251,6 @@ retry:
 	mad_send_wc.send_buf = &mad_send_wr->send_buf;
 	mad_send_wc.status = wc->status;
 	mad_send_wc.vendor_err = wc->vendor_err;
-	if (atomic_read(&qp_info->snoop_count))
-		snoop_send(qp_info, &mad_send_wr->send_buf, &mad_send_wc,
-			   IB_MAD_SNOOP_SEND_COMPLETIONS);
 	ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
 
 	if (queued_send_wr) {
@@ -2733,10 +2530,6 @@ static void local_completions(struct work_struct *work)
 			local->mad_priv->header.recv_wc.recv_buf.grh = NULL;
 			local->mad_priv->header.recv_wc.recv_buf.mad =
 						(struct ib_mad *)local->mad_priv->mad;
-			if (atomic_read(&recv_mad_agent->qp_info->snoop_count))
-				snoop_recv(recv_mad_agent->qp_info,
-					  &local->mad_priv->header.recv_wc,
-					   IB_MAD_SNOOP_RECVS);
 			recv_mad_agent->agent.recv_handler(
 						&recv_mad_agent->agent,
 						&local->mad_priv->header.recv_wc);
@@ -2750,10 +2543,6 @@ local_send_completion:
 		mad_send_wc.status = IB_WC_SUCCESS;
 		mad_send_wc.vendor_err = 0;
 		mad_send_wc.send_buf = &local->mad_send_wr->send_buf;
-		if (atomic_read(&mad_agent_priv->qp_info->snoop_count))
-			snoop_send(mad_agent_priv->qp_info,
-				   &local->mad_send_wr->send_buf,
-				   &mad_send_wc, IB_MAD_SNOOP_SEND_COMPLETIONS);
 		mad_agent_priv->agent.send_handler(&mad_agent_priv->agent,
 						   &mad_send_wc);
 
@@ -3084,10 +2873,6 @@ static void init_mad_qp(struct ib_mad_port_private *port_priv,
 	init_mad_queue(qp_info, &qp_info->send_queue);
 	init_mad_queue(qp_info, &qp_info->recv_queue);
 	INIT_LIST_HEAD(&qp_info->overflow_list);
-	spin_lock_init(&qp_info->snoop_lock);
-	qp_info->snoop_table = NULL;
-	qp_info->snoop_table_size = 0;
-	atomic_set(&qp_info->snoop_count, 0);
 }
 
 static int create_mad_qp(struct ib_mad_qp_info *qp_info,
@@ -3131,7 +2916,6 @@ static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
 		return;
 
 	ib_destroy_qp(qp_info->qp);
-	kfree(qp_info->snoop_table);
 }
 
 /*
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 4a4f7aad0978..45bb73014446 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -107,15 +107,6 @@ struct ib_mad_agent_private {
 	struct completion comp;
 };
 
-struct ib_mad_snoop_private {
-	struct ib_mad_agent agent;
-	struct ib_mad_qp_info *qp_info;
-	int snoop_index;
-	int mad_snoop_flags;
-	atomic_t refcount;
-	struct completion comp;
-};
-
 struct ib_mad_send_wr_private {
 	struct ib_mad_list_head mad_list;
 	struct list_head agent_list;
@@ -187,10 +178,6 @@ struct ib_mad_qp_info {
 	struct ib_mad_queue send_queue;
 	struct ib_mad_queue recv_queue;
 	struct list_head overflow_list;
-	spinlock_t snoop_lock;
-	struct ib_mad_snoop_private **snoop_table;
-	int snoop_table_size;
-	atomic_t snoop_count;
 };
 
 struct ib_mad_port_private {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
