From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Add exponential backoff + random delay to MADs when retrying
 after timeout.
Date: Thu, 28 Oct 2010 09:12:44 -0400
Message-ID: <4CC976CC.1080009@dev.mellanox.co.il>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DEB@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DEB-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/26/2010 2:33 PM, Mike Heinz wrote:
> Resending. Didn't get any reply after the last posting.
>
> -----Original Message-----
> From: Mike Heinz
> Sent: Monday, October 11, 2010 11:34 AM
> To: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
> Subject: [PATCH] Add exponential backoff + random delay to MADs when retrying after timeout.
>
> This patch builds upon a discussion we had earlier this year on adding a backoff function when retrying MAD sends after a timeout.

Agreed that the fixed timer retry strategy is b0rken for some scenarios 
(e.g. BUSY handling). I think a description of this should be added to 
the description as background/motivation. You had previously written:

"The current behavior is to simply return the BUSY to the client or ULP, 
which  is either treated as a permanent error or causes an immediate 
retry. This can be a big problem with, for example, ipoib which sets 
retries to 15 and (as I understand it) immediately retries to connect 
when getting an error response from the SA. Other ulps have similar 
settings. Without some kind of delay, starting up ipoib on a large 
fabric (at boot time, for example) can cause a real packet storm.

By treating BUSY replies identically to timeouts, this patch at least 
introduces a delay between attempts. In the case of the ULPs, the delay 
is typically 4 seconds.

This approach encourages applications to adjust their timeouts 
appropriately by treating BUSY responses as non-events and forcing the 
applications to wait for their request to time out.

Depending on the application developers to take BUSY responses into 
account seems to be asking for trouble - it allows one rogue app to 
bring the SA to its knees, for example. By enforcing this timeout model 
in the kernel, we guarantee that there will be at least some delay 
between each message when the SA is reporting a busy status."

Maybe some shorter version of the above should be part of this and/or 
your subsequent busy handling patch.

> This patch does NOT implement the ABI/API changes that would be needed to take advantage of the new features, but it lays the groundwork for doing so. In addition, it provides a new module parameter that allow the administrator to coerce existing code into using the new capability.
>
> First, I've added a new field called "randomized_wait" to the ib_mad_send_buf structure. If this parameter is set, each time the WR times out, the the timeout for the next retry is set to (send_wr->timeout_ms + 511<<(send_wr->retries) - random32()&511). In other words, on the first retry, the randomization code will add between 0 and 1/2 second to the timeout. On the second retry, it will add between 1 and 1.5 seconds to the timeout, on the 3rd, between 2 and 2.5 seconds, on the 4th, between 4 and 4.5, et cetera.

What experience/confidence is there in this (specific) randomization 
policy ? On what (how large) IB cluster sizes has this policy been tried 
? Is this specific policy modeled from other policies in use elsewhere ?

Also, is this randomized timeout used on RMPP packets if this parameter 
is not 0 ?

> In addition, a new field, total_timeout has been added to the ib_mad_send_wr_private and is initialized to (send_wr->timeout * send_wr->max_retries). Retries cannot exceed this total time, even though that will mean a lower number of retry attempts.

Why is the total timeout more important than number of retries in terms 
of terminating the transaction ?

Shouldn't there be another parameter as to whether this limits the 
retries or whether the number of retries should be the limiting factor ? 
I'm not sure about reducing the number of retries on a large fabric. I 
think the typical number used is 3 so this would be at most 2 depending 
on the per retry timeout. I think the default policy should be to 
preserve the number of retries rather than the total timeout.

> Finally, I've added a module parameter to coerce all mad work requests to use this feature if desired.

On one hand, I don't want to introduce unneeded parameters/complexity 
but I'm wondering whether more granularity is useful on which requests 
(classes ?) this applies to. For example, should SM requests be 
randomized ? This feature is primarily an SA thing although busy can be 
used for other management classes but it's use is mainly GS related.

> parm:           randomized_wait:When true, use a randomized backoff algorithm to control retries for timeouts. (int)
>
> --------
>
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c index ef1304f..3b03f1c 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -42,6 +42,11 @@
>   #include "smi.h"
>   #include "agent.h"
>
> +#include "linux/random.h"
> +
> +#define MAD_MIN_TIMEOUT_MS 511
> +#define MAD_RAND_TIMEOUT_MS 511
> +
>   MODULE_LICENSE("Dual BSD/GPL");
>   MODULE_DESCRIPTION("kernel IB MAD API");  MODULE_AUTHOR("Hal Rosenstock"); @@ -55,6 +60,10 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
>
> +int mad_randomized_wait = 0;
> +module_param_named(randomized_wait, mad_randomized_wait, int, 0444);
> +MODULE_PARM_DESC(randomized_wait, "When true, use a randomized backoff
> +algorithm to control retries for timeouts.");
> +
>   static struct kmem_cache *ib_mad_cache;
>
>   static struct list_head ib_mad_port_list; @@ -1102,11 +1111,18 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
>   		}
>
>   		mad_send_wr->tid = ((struct ib_mad_hdr *) send_buf->mad)->tid;
> +
> +		mad_send_wr->randomized_wait = mad_randomized_wait || send_buf->randomized_wait;
> +		mad_send_wr->total_timeout = msecs_to_jiffies(send_buf->timeout_ms) *
> +send_buf->retries;
> +		
>   		/* Timeout will be updated after send completes */
>   		mad_send_wr->timeout = msecs_to_jiffies(send_buf->timeout_ms);
> +
>   		mad_send_wr->max_retries = send_buf->retries;
>   		mad_send_wr->retries_left = send_buf->retries;
> +		
>   		send_buf->retries = 0;
> +		
>   		/* Reference for work request to QP + response */
>   		mad_send_wr->refcount = 1 + (mad_send_wr->timeout>  0);
>   		mad_send_wr->status = IB_WC_SUCCESS;
> @@ -1803,6 +1819,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>
>   	/* Complete corresponding request */
>   	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
> +
>   		spin_lock_irqsave(&mad_agent_priv->lock, flags);
>   		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
>   		if (!mad_send_wr) {
> @@ -1811,6 +1828,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
>   			deref_mad_agent(mad_agent_priv);
>   			return;
>   		}
> +

Nit: no need for extra lines in this and above.

>   		ib_mark_mad_done(mad_send_wr);
>   		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
>
> @@ -2429,14 +2447,33 @@ static int retry_send(struct ib_mad_send_wr_private *mad_send_wr)  {
>   	int ret;
>
> -	if (!mad_send_wr->retries_left)
> +	if (!mad_send_wr->retries_left || (mad_send_wr->total_timeout == 0))
>   		return -ETIMEDOUT;
>
>   	mad_send_wr->retries_left--;
>   	mad_send_wr->send_buf.retries++;
>
> -	mad_send_wr->timeout = msecs_to_jiffies(mad_send_wr->send_buf.timeout_ms);
> +	if (mad_send_wr->randomized_wait) {
> +		mad_send_wr->timeout = msecs_to_jiffies(mad_send_wr->send_buf.timeout_ms +
> +			(MAD_MIN_TIMEOUT_MS<<mad_send_wr->send_buf.retries) -
> +			(random32()&MAD_RAND_TIMEOUT_MS));
> +		if (mad_send_wr->timeout>  mad_send_wr->total_timeout) {
> +			mad_send_wr->timeout = mad_send_wr->total_timeout;
> +			mad_send_wr->total_timeout = 0;
> +		} else {
> +			mad_send_wr->total_timeout -= mad_send_wr->timeout;
> +		}
> +	} else {
> +		mad_send_wr->timeout = msecs_to_jiffies(mad_send_wr->send_buf.timeout_ms);
> +	}
>
> +	printk(KERN_DEBUG PFX "Retrying send %p: retries: %u, retries_left: %u, timeout: %lu, total_timeout: %lu\n",
> +		mad_send_wr,
> +		mad_send_wr->send_buf.retries,
> +		mad_send_wr->retries_left,
> +		mad_send_wr->timeout,
> +		mad_send_wr->total_timeout);
> +		
>   	if (mad_send_wr->mad_agent_priv->agent.rmpp_version) {
>   		ret = ib_retry_rmpp(mad_send_wr);
>   		switch (ret) {
> diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
> index 9430ab4..01fb7ed 100644
> --- a/drivers/infiniband/core/mad_priv.h
> +++ b/drivers/infiniband/core/mad_priv.h
> @@ -132,8 +132,10 @@ struct ib_mad_send_wr_private {
>   	struct ib_sge sg_list[IB_MAD_SEND_REQ_MAX_SG];
>   	__be64 tid;
>   	unsigned long timeout;
> +	unsigned long total_timeout;
>   	int max_retries;
>   	int retries_left;
> +	int randomized_wait;
>   	int retry;
>   	int refcount;
>   	enum ib_wc_status status;
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h index d3b9401..c3d6efb 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -77,6 +77,15 @@
>
>   #define IB_MGMT_MAX_METHODS			128
>
> +/* MAD Status field bit masks */
> +#define IB_MGMT_MAD_STATUS_SUCCESS						0x0000
> +#define IB_MGMT_MAD_STATUS_BUSY							0x0001
> +#define IB_MGMT_MAD_STATUS_REDIRECT_REQD				0x0002
> +#define IB_MGMT_MAD_STATUS_BAD_VERERSION				0x0004	
> +#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD			0x0008	
> +#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB	0x000c
> +#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE			0x001c
> +

Another nit: Although this does no harm, these don't look needed/used in 
this patch so I don't think they should be part of this and moved to 
your subsequent busy patch.

-- Hal

>   /* RMPP information */
>   #define IB_MGMT_RMPP_VERSION			1
>
> @@ -246,6 +255,7 @@ struct ib_mad_send_buf {
>   	int			seg_count;
>   	int			seg_size;
>   	int			timeout_ms;
> +	int			randomized_wait;
>   	int			retries;
>   };
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
