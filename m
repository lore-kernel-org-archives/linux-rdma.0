From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Handling BUSY responses from the SM.
Date: Tue, 26 Oct 2010 13:33:43 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DED@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Resending. Didn't get any reply after sending the last time.

-----Original Message-----
From: Mike Heinz 
Sent: Monday, October 11, 2010 1:24 PM
To: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'Hefty, Sean'
Cc: Todd Rimmer
Subject: [PATCH] Handling BUSY responses from the SM.

This patch builds upon feedback received earlier this year to add a "treat BUSY as timeout" feature to ib_mad. It does NOT implement the ABI/API changes that would be needed in user space to take advantage of the new feature, but it lays the groundwork for doing so. In addition, it provides a new module parameter that allow the administrator to coerce existing code into using the new capability.

The patch builds upon the randomization/backoff patch I sent earlier today to add a random factor to timeouts to prevent synchronized storms of MAD queries. I chose to build upon the existing timeout handling because it seemed the best way to add the functionality without 

Initially, I had tried to completely separate BUSY retries from timeout handling, but that seemed difficult due to the way the timeout code is structured. As a result, true timeouts and busy handling still use the same timeout values, but I was still able to address the idea of randomizing the retry timeout if desired.

By default, the behavior of ib_mad with respect to BUSY responses is unchanged. If, however, a send work request is provided that has the new "busy_wait" parameter set, ib_mad will ignore BUSY responses to that WR, allowing it to timeout and retry as if no response had been received. 

Finally, I've added a module parameter to coerce all mad work requests to use this new feature:

parm:           treat_busy_as_timeout:When true, treat BUSY responses as if they were timeouts. (int)

As I mentioned in the past, this change solves a problem we see in the real world all the time (the SM being pounded by "unintelligent" queries) so I strongly hope this meets your concerns.

----

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 3b03f1c..9e5e566 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -60,6 +60,10 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
+int mad_wait_on_busy = 0;
+module_param_named(treat_busy_as_timeout, mad_wait_on_busy, int, 0444);
+MODULE_PARM_DESC(treat_busy_as_timeout, "When true, treat BUSY responses as if they were timeouts.");
+
 int mad_randomized_wait = 0;
 module_param_named(randomized_wait, mad_randomized_wait, int, 0444);
 MODULE_PARM_DESC(randomized_wait, "When true, use a randomized backoff algorithm to control retries for timeouts.");
@@ -1120,6 +1124,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 
 		mad_send_wr->max_retries = send_buf->retries;
 		mad_send_wr->retries_left = send_buf->retries;
+		mad_send_wr->wait_on_busy = send_buf->wait_on_busy || mad_wait_on_busy;
 		
 		send_buf->retries = 0;
 		
@@ -1819,6 +1824,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+		u16 busy = __be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.status) &
+						IB_MGMT_MAD_STATUS_BUSY;
 
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
@@ -1829,6 +1836,17 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 			return;
 		}
 
+		printk(KERN_DEBUG PFX "Completing recv %p: busy = %d, retries_left = %d, wait_on_busy = %d\n",
+			mad_send_wr, busy, mad_send_wr->retries_left, mad_send_wr->wait_on_busy);
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
index 01fb7ed..1d0629e 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -135,6 +135,7 @@ struct ib_mad_send_wr_private {
 	unsigned long total_timeout;
 	int max_retries;
 	int retries_left;
+	int wait_on_busy;
 	int randomized_wait;
 	int retry;
 	int refcount;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index c3d6efb..3da55c3 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -255,6 +255,7 @@ struct ib_mad_send_buf {
 	int			seg_count;
 	int			seg_size;
 	int			timeout_ms;
+	int			wait_on_busy;
 	int			randomized_wait;
 	int			retries;
 };
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
