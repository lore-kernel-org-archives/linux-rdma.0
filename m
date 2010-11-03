From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] ib/mad: Simplify snooping interface
Date: Wed, 3 Nov 2010 15:31:12 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B2E9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In preparation for exporting the kernel mad snooping capability
to user space, remove all code originally inserted as place holders
and simplify the mad snooping interface.

For performance reasons, we want to filter which mads are reported
to clients of the snooping interface at the lowest level, but we
also don't want to perform complex filtering at that level.
As a trade-off, we allow filtering based on mgmt_class, attr_id,
and mad request status.

The reasoning behind these choices are to allow a user to filter
traffic to a specific service (the SA or CM), for a well known
purpose (path record queries or multicast joins), or view only
operations that have failed.

To support snooping only failed send operations, we need to add
another snoop check when processing send timeouts.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
changes from RFC:
Fix snooping send errors.

 drivers/infiniband/core/mad.c      |  114 ++++++++++++++++++++++--------------
 drivers/infiniband/core/mad_priv.h |    2 -
 include/rdma/ib_mad.h              |   54 +++++++++--------
 3 files changed, 97 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ef1304f..dd92293 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -381,22 +381,6 @@ error1:
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
 static int register_snoop_agent(struct ib_mad_qp_info *qp_info,
 				struct ib_mad_snoop_private *mad_snoop_priv)
 {
@@ -434,8 +418,8 @@ out:
 struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 					   u8 port_num,
 					   enum ib_qp_type qp_type,
-					   int mad_snoop_flags,
-					   ib_mad_snoop_handler snoop_handler,
+					   struct ib_mad_snoop_reg_req *snoop_reg_req,
+					   ib_mad_send_handler send_handler,
 					   ib_mad_recv_handler recv_handler,
 					   void *context)
 {
@@ -444,12 +428,6 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	struct ib_mad_snoop_private *mad_snoop_priv;
 	int qpn;
 
-	/* Validate parameters */
-	if ((is_snooping_sends(mad_snoop_flags) && !snoop_handler) ||
-	    (is_snooping_recvs(mad_snoop_flags) && !recv_handler)) {
-		ret = ERR_PTR(-EINVAL);
-		goto error1;
-	}
 	qpn = get_spl_qp_index(qp_type);
 	if (qpn == -1) {
 		ret = ERR_PTR(-EINVAL);
@@ -471,11 +449,11 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
 	mad_snoop_priv->agent.device = device;
 	mad_snoop_priv->agent.recv_handler = recv_handler;
-	mad_snoop_priv->agent.snoop_handler = snoop_handler;
+	mad_snoop_priv->agent.send_handler = send_handler;
+	mad_snoop_priv->reg_req = *snoop_reg_req;
 	mad_snoop_priv->agent.context = context;
 	mad_snoop_priv->agent.qp = port_priv->qp_info[qpn].qp;
 	mad_snoop_priv->agent.port_num = port_num;
-	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
 	init_completion(&mad_snoop_priv->comp);
 	mad_snoop_priv->snoop_index = register_snoop_agent(
 						&port_priv->qp_info[qpn],
@@ -592,26 +570,66 @@ static void dequeue_mad(struct ib_mad_list_head *mad_list)
 	spin_unlock_irqrestore(&mad_queue->lock, flags);
 }
 
+static int snoop_check_filter(struct ib_mad_snoop_reg_req *reg,
+			      struct ib_mad_hdr *mad_hdr)
+{
+	if (reg->mgmt_class) {
+		if (reg->mgmt_class != mad_hdr->mgmt_class)
+			return 0;
+
+		if (reg->attr_id && reg->attr_id != mad_hdr->attr_id)
+			return 0;
+
+		if (reg->mgmt_class_version &&
+		    reg->mgmt_class_version != mad_hdr->class_version)
+			return 0;
+
+		if (is_vendor_class(reg->mgmt_class) && is_vendor_oui(reg->oui) &&
+		    memcmp(reg->oui, ((struct ib_vendor_mad *) mad_hdr)->oui, 3))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * We report sends as soon as the send work request completes.
+ * If the send request expects a response, we cannot report
+ * any failure until after it has timed out.  But we don't
+ * want to report a send twice - once after it has been posted to
+ * the QP, and again after it times out.  If error_only is true,
+ * then a send is only reported to clients registered for errors.
+ */
 static void snoop_send(struct ib_mad_qp_info *qp_info,
-		       struct ib_mad_send_buf *send_buf,
-		       struct ib_mad_send_wc *mad_send_wc,
-		       int mad_snoop_flags)
+		       struct ib_mad_send_wc *mad_send_wc, int error_only)
 {
 	struct ib_mad_snoop_private *mad_snoop_priv;
+	struct ib_mad_snoop_reg_req *reg;
+	struct ib_mad_hdr *mad_hdr;
 	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&qp_info->snoop_lock, flags);
 	for (i = 0; i < qp_info->snoop_table_size; i++) {
 		mad_snoop_priv = qp_info->snoop_table[i];
-		if (!mad_snoop_priv ||
-		    !(mad_snoop_priv->mad_snoop_flags & mad_snoop_flags))
+		if (!mad_snoop_priv)
+			continue;
+
+		reg = &mad_snoop_priv->reg_req;
+		if (error_only && !reg->errors)
+			continue;
+
+		mad_hdr = mad_send_wc->send_buf->mad;
+		if ((reg->errors && !mad_hdr->status &&
+		     (mad_send_wc->status == IB_WC_SUCCESS ||
+		      mad_send_wc->status == IB_WC_WR_FLUSH_ERR)) ||
+		     !snoop_check_filter(reg, mad_hdr))
 			continue;
 
 		atomic_inc(&mad_snoop_priv->refcount);
 		spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
-		mad_snoop_priv->agent.snoop_handler(&mad_snoop_priv->agent,
-						    send_buf, mad_send_wc);
+		mad_snoop_priv->agent.send_handler(&mad_snoop_priv->agent,
+						   mad_send_wc);
 		deref_snoop_agent(mad_snoop_priv);
 		spin_lock_irqsave(&qp_info->snoop_lock, flags);
 	}
@@ -619,18 +637,24 @@ static void snoop_send(struct ib_mad_qp_info *qp_info,
 }
 
 static void snoop_recv(struct ib_mad_qp_info *qp_info,
-		       struct ib_mad_recv_wc *mad_recv_wc,
-		       int mad_snoop_flags)
+		       struct ib_mad_recv_wc *mad_recv_wc)
 {
 	struct ib_mad_snoop_private *mad_snoop_priv;
+	struct ib_mad_snoop_reg_req *reg;
+	struct ib_mad_hdr *mad_hdr;
 	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&qp_info->snoop_lock, flags);
 	for (i = 0; i < qp_info->snoop_table_size; i++) {
 		mad_snoop_priv = qp_info->snoop_table[i];
-		if (!mad_snoop_priv ||
-		    !(mad_snoop_priv->mad_snoop_flags & mad_snoop_flags))
+		if (!mad_snoop_priv)
+			continue;
+
+		reg = &mad_snoop_priv->reg_req;
+		mad_hdr = &mad_recv_wc->recv_buf.mad->mad_hdr;
+		if ((reg->errors && !mad_hdr->status) ||
+		    !snoop_check_filter(reg, mad_hdr))
 			continue;
 
 		atomic_inc(&mad_snoop_priv->refcount);
@@ -1862,7 +1886,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	recv->header.recv_wc.recv_buf.grh = &recv->grh;
 
 	if (atomic_read(&qp_info->snoop_count))
-		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
+		snoop_recv(qp_info, &recv->header.recv_wc);
 
 	/* Validate MAD */
 	if (!validate_mad(&recv->mad.mad, qp_info->qp->qp_num))
@@ -2129,8 +2153,7 @@ retry:
 	mad_send_wc.status = wc->status;
 	mad_send_wc.vendor_err = wc->vendor_err;
 	if (atomic_read(&qp_info->snoop_count))
-		snoop_send(qp_info, &mad_send_wr->send_buf, &mad_send_wc,
-			   IB_MAD_SNOOP_SEND_COMPLETIONS);
+		snoop_send(qp_info, &mad_send_wc, 0);
 	ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
 
 	if (queued_send_wr) {
@@ -2394,8 +2417,7 @@ static void local_completions(struct work_struct *work)
 						&local->mad_priv->mad.mad;
 			if (atomic_read(&recv_mad_agent->qp_info->snoop_count))
 				snoop_recv(recv_mad_agent->qp_info,
-					  &local->mad_priv->header.recv_wc,
-					   IB_MAD_SNOOP_RECVS);
+					  &local->mad_priv->header.recv_wc);
 			recv_mad_agent->agent.recv_handler(
 						&recv_mad_agent->agent,
 						&local->mad_priv->header.recv_wc);
@@ -2410,9 +2432,7 @@ local_send_completion:
 		mad_send_wc.vendor_err = 0;
 		mad_send_wc.send_buf = &local->mad_send_wr->send_buf;
 		if (atomic_read(&mad_agent_priv->qp_info->snoop_count))
-			snoop_send(mad_agent_priv->qp_info,
-				   &local->mad_send_wr->send_buf,
-				   &mad_send_wc, IB_MAD_SNOOP_SEND_COMPLETIONS);
+			snoop_send(mad_agent_priv->qp_info, &mad_send_wc, 0);
 		mad_agent_priv->agent.send_handler(&mad_agent_priv->agent,
 						   &mad_send_wc);
 
@@ -2500,6 +2520,10 @@ static void timeout_sends(struct work_struct *work)
 		else
 			mad_send_wc.status = mad_send_wr->status;
 		mad_send_wc.send_buf = &mad_send_wr->send_buf;
+
+		if (atomic_read(&mad_agent_priv->qp_info->snoop_count))
+			snoop_send(mad_agent_priv->qp_info, &mad_send_wc, 1);
+
 		mad_agent_priv->agent.send_handler(&mad_agent_priv->agent,
 						   &mad_send_wc);
 
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 9430ab4..e1074fc 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -116,7 +116,7 @@ struct ib_mad_snoop_private {
 	struct ib_mad_agent agent;
 	struct ib_mad_qp_info *qp_info;
 	int snoop_index;
-	int mad_snoop_flags;
+	struct ib_mad_snoop_reg_req reg_req;
 	atomic_t refcount;
 	struct completion comp;
 };
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..c86d433 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -307,20 +307,6 @@ typedef void (*ib_mad_send_handler)(struct ib_mad_agent *mad_agent,
 				    struct ib_mad_send_wc *mad_send_wc);
 
 /**
- * ib_mad_snoop_handler - Callback handler for snooping sent MADs.
- * @mad_agent: MAD agent that snooped the MAD.
- * @send_wr: Work request information on the sent MAD.
- * @mad_send_wc: Work completion information on the sent MAD.  Valid
- *   only for snooping that occurs on a send completion.
- *
- * Clients snooping MADs should not modify data referenced by the @send_wr
- * or @mad_send_wc.
- */
-typedef void (*ib_mad_snoop_handler)(struct ib_mad_agent *mad_agent,
-				     struct ib_mad_send_buf *send_buf,
-				     struct ib_mad_send_wc *mad_send_wc);
-
-/**
  * ib_mad_recv_handler - callback handler for a received MAD.
  * @mad_agent: MAD agent requesting the received MAD.
  * @mad_recv_wc: Received work completion information on the received MAD.
@@ -341,7 +327,6 @@ typedef void (*ib_mad_recv_handler)(struct ib_mad_agent *mad_agent,
  * @mr: Memory region for system memory usable for DMA.
  * @recv_handler: Callback handler for a received MAD.
  * @send_handler: Callback handler for a sent MAD.
- * @snoop_handler: Callback handler for snooped sent MADs.
  * @context: User-specified context associated with this registration.
  * @hi_tid: Access layer assigned transaction ID for this client.
  *   Unsolicited MADs sent by this client will have the upper 32-bits
@@ -355,7 +340,6 @@ struct ib_mad_agent {
 	struct ib_mr		*mr;
 	ib_mad_recv_handler	recv_handler;
 	ib_mad_send_handler	send_handler;
-	ib_mad_snoop_handler	snoop_handler;
 	void			*context;
 	u32			hi_tid;
 	u8			port_num;
@@ -452,14 +436,27 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					   ib_mad_recv_handler recv_handler,
 					   void *context);
 
-enum ib_mad_snoop_flags {
-	/*IB_MAD_SNOOP_POSTED_SENDS	   = 1,*/
-	/*IB_MAD_SNOOP_RMPP_SENDS	   = (1<<1),*/
-	IB_MAD_SNOOP_SEND_COMPLETIONS	   = (1<<2),
-	/*IB_MAD_SNOOP_RMPP_SEND_COMPLETIONS = (1<<3),*/
-	IB_MAD_SNOOP_RECVS		   = (1<<4)
-	/*IB_MAD_SNOOP_RMPP_RECVS	   = (1<<5),*/
-	/*IB_MAD_SNOOP_REDIRECTED_QPS	   = (1<<6)*/
+/**
+ * ib_mad_snoop_reg_req - registration request to snoop MADs
+ * @mgmt_class: If non-zero, specifies which management class of MADs
+ *   the caller is interested in viewing.
+ * @mgmt_class_version: If non-zero, indicates which version of MADs
+ *   for the given management class to receive.
+ * @oui: If non-zero, specifies the IEEE OUI for vendor management classes
+ *   in the range from 0x30 to 0x4f.
+ * @errors: If non-zero, indicates that the caller only wishes to
+ *   view sent MADs which complete in error, or received responses
+ *   which contain a non-zero status value.  MADs that complete as
+ *   canceled are not reported if errors is non-zero.
+ * @attr_id: If non-zero, specifies that the reported MADs must
+ *   reference the indicated attribute identifier.
+ */
+struct ib_mad_snoop_reg_req {
+	u8	mgmt_class;
+	u8	mgmt_class_version;
+	u8	oui[3];
+	u8	errors;
+	__be16	attr_id;
 };
 
 /**
@@ -468,16 +465,19 @@ enum ib_mad_snoop_flags {
  * @port_num: The port on the specified device to use.
  * @qp_type: Specifies which QP traffic to snoop.  Must be either
  *   IB_QPT_SMI or IB_QPT_GSI.
- * @mad_snoop_flags: Specifies information where snooping occurs.
+ * @snoop_req_req: Specifies filtering criteria for reported MADs.
  * @send_handler: The callback routine invoked for a snooped send.
  * @recv_handler: The callback routine invoked for a snooped receive.
  * @context: User specified context associated with the registration.
+ *
+ * Snoops MADs are reported to the user after any RMPP segmentation
+ * and before any reassembly has occurred.
  */
 struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 					   u8 port_num,
 					   enum ib_qp_type qp_type,
-					   int mad_snoop_flags,
-					   ib_mad_snoop_handler snoop_handler,
+					   struct ib_mad_snoop_reg_req *snoop_reg_req,
+					   ib_mad_send_handler send_handler,
 					   ib_mad_recv_handler recv_handler,
 					   void *context);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
