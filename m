From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core User RMPP patch
Date: Wed, 26 May 2010 15:14:28 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D528@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, if a user application calls umad_register() or umad_register_oui() with an rmpp_version of zero, incoming rmpp messages are discarded.

This patch changes this behavior so that rmpp_version of zero causes incoming rmpp packets to be passed through without alteration, instead. 

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
----

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 80282f1..b3457ae 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1830,25 +1830,39 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
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
+			if (  !mad_agent_priv->agent.rmpp_version
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
index 36f815c..f9cacbc 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -508,7 +508,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 
 	rmpp_mad = (struct ib_rmpp_mad *) packet->mad.data;
 	hdr_len = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
-	if (!ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
+	if (!agent->rmpp_version || !ib_is_mad_class_rmpp(rmpp_mad->mad_hdr.mgmt_class)) {
 		copy_offset = IB_MGMT_MAD_HDR;
 		rmpp_active = 0;
 	} else {
@@ -560,14 +560,22 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		rmpp_mad->mad_hdr.tid = *tid;
 	}
 
-	spin_lock_irq(&file->send_lock);
-	ret = is_duplicate(file, packet);
-	if (!ret)
+	if (  !agent->rmpp_version
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


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
