From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] SA Busy handling
Date: Wed, 1 Dec 2010 12:06:42 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF198@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a re-send of the final version of the patch for adding the option to treat BUSY responses to MAD requests as time outs. It has been tweaked to remove references to the randomized backoff patch (which is still under discussion) and to ensure that all feedback has been incorporated. I tested it today against OFED 1.5.2 and linux 2.6.34 to verify that it applies correctly to those source trees.
---

This patch provides a new module parameter for ib_mad that tells ib_mad to treat BUSY responses as timeouts.

parm:           treat_busy_as_timeout:When true, treat BUSY responses as if they were timeouts. (int)

When this parameter is true, ib_mad will unilaterally treat BUSY responses as timeouts regardless of the desired behavior of the caller.

In addition, this patch also provides changes to ib_mad_send_buf to allow senders of MAD requests to request this behavior even if the parameter is not set. The patch does NOT provide changes to ib_umad to allow user apps to select this functionality.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/core/mad.c      |   20 ++++++++++++++++++++
 drivers/infiniband/core/mad_priv.h |    1 +
 include/rdma/ib_mad.h              |   10 ++++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 64e660c..1d42819 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -54,6 +54,10 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
+int mad_wait_on_busy = 0;
+module_param_named(treat_busy_as_timeout, mad_wait_on_busy, int, 0444);
+MODULE_PARM_DESC(treat_busy_as_timeout, "When true, treat BUSY responses as if they were timeouts.");
+
 static struct kmem_cache *ib_mad_cache;
 
 static struct list_head ib_mad_port_list;
@@ -1120,6 +1124,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 		mad_send_wr->timeout = msecs_to_jiffies(send_buf->timeout_ms);
 		mad_send_wr->max_retries = send_buf->retries;
 		mad_send_wr->retries_left = send_buf->retries;
+		mad_send_wr->wait_on_busy = send_buf->wait_on_busy || mad_wait_on_busy;
 		send_buf->retries = 0;
 		/* Reference for work request to QP + response */
 		mad_send_wr->refcount = 1 + (mad_send_wr->timeout > 0);
@@ -1828,6 +1833,9 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+		u16 busy = be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.status) &
+							   IB_MGMT_MAD_STATUS_BUSY;
+
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
 		if (!mad_send_wr) {
@@ -1836,6 +1844,18 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 			deref_mad_agent(mad_agent_priv);
 			return;
 		}
+
+		printk(KERN_DEBUG PFX "Completing recv %p: busy = %d, retries_left = %d, wait_on_busy = %d\n",
+			   mad_send_wr, busy, mad_send_wr->retries_left, mad_send_wr->wait_on_busy);
+		if (busy && mad_send_wr->retries_left && mad_send_wr->wait_on_busy) {
+			/* Just let the query timeout and have it requeued later */
+			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+			ib_free_recv_mad(mad_recv_wc);
+			deref_mad_agent(mad_agent_priv);
+			printk(KERN_INFO PFX "SA/SM responded MAD_STATUS_BUSY. Allowing request to time out.\n");
+			return;
+		}
+
 		ib_mark_mad_done(mad_send_wr);
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 8b4df0a..b6477cf 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -135,6 +135,7 @@ struct ib_mad_send_wr_private {
 	unsigned long timeout;
 	int max_retries;
 	int retries_left;
+	int wait_on_busy;
 	int retry;
 	int refcount;
 	enum ib_wc_status status;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..fadc2c3 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -77,6 +77,15 @@
 
 #define IB_MGMT_MAX_METHODS			128
 
+/* MAD Status field bit masks */
+#define IB_MGMT_MAD_STATUS_SUCCESS                      0x0000
+#define IB_MGMT_MAD_STATUS_BUSY                         0x0001
+#define IB_MGMT_MAD_STATUS_REDIRECT_REQD                0x0002
+#define IB_MGMT_MAD_STATUS_BAD_VERERSION                0x0004
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD           0x0008
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB    0x000c
+#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE         0x001c
+
 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION			1
 
@@ -246,6 +255,7 @@ struct ib_mad_send_buf {
 	int			seg_count;
 	int			seg_size;
 	int			timeout_ms;
+	int			wait_on_busy;
 	int			retries;
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
