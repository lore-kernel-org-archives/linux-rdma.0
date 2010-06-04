From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Fri, 4 Jun 2010 12:14:06 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an update to the previous version of the patch, based on feedback from Hal.

----
Currently, if a user application calls umad_register() or umad_register_oui() with an rmpp_version of zero, incoming rmpp messages are discarded and if the rmpp_version is 1, incoming rmpp packets are collected by the kernel layer and passed as a group to the user application.

This patch changes this behavior so that rmpp_version of 255 causes incoming rmpp packets to be passed through without alteration, instead.

There are IB users who have requested the ability to perform RMPP transaction handling in user space.  This was an option in old proprietary stacks and this is useful to migrate old applications to OFED while containing the scope of their application changes.  

Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

-------

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ef1304f..efca783 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -207,12 +207,18 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	int ret2, qpn;
 	unsigned long flags;
 	u8 mgmt_class, vclass;
+	u8 rmpp_passthru = 0;
 
 	/* Validate parameters */
 	qpn = get_spl_qp_index(qp_type);
 	if (qpn == -1)
 		goto error1;
 
+	if (rmpp_version == IB_MGMT_RMPP_PASSTHRU) {
+		rmpp_passthru = 255;
+		rmpp_version = 0;
+	}
+	
 	if (rmpp_version && rmpp_version != IB_MGMT_RMPP_VERSION)
 		goto error1;
 
@@ -244,6 +250,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 			if (!is_vendor_oui(mad_reg_req->oui))
 				goto error1;
 		}
+		
 		/* Make sure class supplied is consistent with RMPP */
 		if (!ib_is_mad_class_rmpp(mad_reg_req->mgmt_class)) {
 			if (rmpp_version)
@@ -302,6 +309,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	mad_agent_priv->qp_info = &port_priv->qp_info[qpn];
 	mad_agent_priv->reg_req = reg_req;
 	mad_agent_priv->agent.rmpp_version = rmpp_version;
+	mad_agent_priv->agent.rmpp_passthru = rmpp_passthru;
 	mad_agent_priv->agent.device = device;
 	mad_agent_priv->agent.recv_handler = recv_handler;
 	mad_agent_priv->agent.send_handler = send_handler;
@@ -1792,7 +1800,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
 	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
-	if (mad_agent_priv->agent.rmpp_version) {
+	if (mad_agent_priv->agent.rmpp_version && !mad_agent_priv->agent.rmpp_passthru) {
 		mad_recv_wc = ib_process_rmpp_recv_wc(mad_agent_priv,
 						      mad_recv_wc);
 		if (!mad_recv_wc) {
@@ -1801,29 +1809,47 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 		}
 	}
 
+	/*
+	 * At this point, the MAD is either not an RMPP or we are passing RMPPs thru to
+	 * the client.
+	 */
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
-		if (!mad_send_wr) {
+		if (mad_send_wr) {
+			ib_mark_mad_done(mad_send_wr);
 			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
-			ib_free_recv_mad(mad_recv_wc);
-			deref_mad_agent(mad_agent_priv);
-			return;
-		}
-		ib_mark_mad_done(mad_send_wr);
-		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 
-		/* Defined behavior is to complete response before request */
-		mad_recv_wc->wc->wr_id = (unsigned long) &mad_send_wr->send_buf;
-		mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
-						   mad_recv_wc);
-		atomic_dec(&mad_agent_priv->refcount);
+			/* Defined behavior is to complete response before request */
+			mad_recv_wc->wc->wr_id = (unsigned long) &mad_send_wr->send_buf;
+			mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
+							   mad_recv_wc);
+			atomic_dec(&mad_agent_priv->refcount);
 
-		mad_send_wc.status = IB_WC_SUCCESS;
-		mad_send_wc.vendor_err = 0;
-		mad_send_wc.send_buf = &mad_send_wr->send_buf;
-		ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
+			mad_send_wc.status = IB_WC_SUCCESS;
+			mad_send_wc.vendor_err = 0;
+			mad_send_wc.send_buf = &mad_send_wr->send_buf;
+			ib_mad_complete_send_wr(mad_send_wr, &mad_send_wc);
+		} else {
+			if (mad_agent_priv->agent.rmpp_passthru
+			   && ib_is_mad_class_rmpp(mad_recv_wc->recv_buf.mad->mad_hdr.mgmt_class)
+			   && (ib_get_rmpp_flags(&((struct ib_rmpp_mad *)mad_recv_wc->recv_buf.mad)->rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
+				// user rmpp is in effect
+				spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+
+				mad_recv_wc->wc->wr_id = 0;
+				mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
+								   mad_recv_wc);
+				atomic_dec(&mad_agent_priv->refcount);
+			} else {
+				// not user rmpp, revert to normal behavior and drop the mad
+				spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+				ib_free_recv_mad(mad_recv_wc);
+				deref_mad_agent(mad_agent_priv);
+				return;
+			}
+		}
 	} else {
 		mad_agent_priv->agent.recv_handler(&mad_agent_priv->agent,
 						   mad_recv_wc);
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 6babb72..baa11ae 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -501,7 +501,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 
 	rmpp_mad = (struct ib_rmpp_mad *) packet->mad.data;
 	hdr_len = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
-	if (!ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
+	if (!agent->rmpp_version || !ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
 		copy_offset = IB_MGMT_MAD_HDR;
 		rmpp_active = 0;
 	} else {
@@ -553,14 +553,22 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		rmpp_mad->mad_hdr.tid = *tid;
 	}
 
-	spin_lock_irq(&file->send_lock);
-	ret = is_duplicate(file, packet);
-	if (!ret)
+	if (agent->rmpp_passthru
+	   && ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)
+	   && (ib_get_rmpp_flags(&rmpp_mad->rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
+		spin_lock_irq(&file->send_lock);
 		list_add_tail(&packet->list, &file->send_list);
-	spin_unlock_irq(&file->send_lock);
-	if (ret) {
-		ret = -EINVAL;
-		goto err_msg;
+		spin_unlock_irq(&file->send_lock);
+	} else {
+		spin_lock_irq(&file->send_lock);
+		ret = is_duplicate(file, packet);
+		if (!ret)
+			list_add_tail(&packet->list, &file->send_list);
+		spin_unlock_irq(&file->send_lock);
+		if (ret) {
+			ret = -EINVAL;
+			goto err_msg;
+		}
 	}
 
 	ret = ib_post_send_mad(packet->msg, NULL);
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..2651e93 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -79,6 +79,7 @@
 
 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION			1
+#define IB_MGMT_RMPP_PASSTHRU			255
 
 #define IB_MGMT_RMPP_TYPE_DATA			1
 #define IB_MGMT_RMPP_TYPE_ACK			2
@@ -360,6 +361,7 @@ struct ib_mad_agent {
 	u32			hi_tid;
 	u8			port_num;
 	u8			rmpp_version;
+	u8			rmpp_passthru;
 };
 
 /**
@@ -436,7 +438,9 @@ struct ib_mad_reg_req {
  *   wishes to receive solicited responses.
  * @rmpp_version: If set, indicates that the client will send
  *   and receive MADs that contain the RMPP header for the given version.
- *   If set to 0, indicates that RMPP is not used by this client.
+ *   If set to 0, indicates that RMPP is not used by this client. If
+ *   set to 255, incoming RMPP MADs are passed through to the client.
+ *   Otherwise, RMPP MADs are handled according to the version #.
  * @send_handler: The completion callback routine invoked after a send
  *   request has completed.
  * @recv_handler: The completion callback routine invoked for a received
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
