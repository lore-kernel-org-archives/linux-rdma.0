From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Handling BUSY responses from the SM.
Date: Thu, 4 Nov 2010 08:12:08 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B6A3@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DED@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DED-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 3b03f1c..9e5e566 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -60,6 +60,10 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in
> number of work requests
>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work
> requests");
> 
> +int mad_wait_on_busy = 0;
> +module_param_named(treat_busy_as_timeout, mad_wait_on_busy, int, 0444);
> +MODULE_PARM_DESC(treat_busy_as_timeout, "When true, treat BUSY responses
> as if they were timeouts.");

I'd prefer to avoid adding a module parameter and just have the mad layer do what's right.

> +
>  int mad_randomized_wait = 0;
>  module_param_named(randomized_wait, mad_randomized_wait, int, 0444);
>  MODULE_PARM_DESC(randomized_wait, "When true, use a randomized backoff
> algorithm to control retries for timeouts.");
> @@ -1120,6 +1124,7 @@ int ib_post_send_mad(struct ib_mad_send_buf
> *send_buf,
> 
>  		mad_send_wr->max_retries = send_buf->retries;
>  		mad_send_wr->retries_left = send_buf->retries;
> +		mad_send_wr->wait_on_busy = send_buf->wait_on_busy ||
> mad_wait_on_busy;
> 
>  		send_buf->retries = 0;
> 
> @@ -1819,6 +1824,8 @@ static void ib_mad_complete_recv(struct
> ib_mad_agent_private *mad_agent_priv,
> 
>  	/* Complete corresponding request */
>  	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
> +		u16 busy = __be16_to_cpu(mad_recv_wc->recv_buf.mad-
> >mad_hdr.status) &
> +						IB_MGMT_MAD_STATUS_BUSY;
> 
>  		spin_lock_irqsave(&mad_agent_priv->lock, flags);
>  		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
> @@ -1829,6 +1836,17 @@ static void ib_mad_complete_recv(struct
> ib_mad_agent_private *mad_agent_priv,
>  			return;
>  		}
> 
> +		printk(KERN_DEBUG PFX "Completing recv %p: busy = %d,
> retries_left = %d, wait_on_busy = %d\n",
> +			mad_send_wr, busy, mad_send_wr->retries_left,
> mad_send_wr->wait_on_busy);
> +		if (busy && mad_send_wr->retries_left && mad_send_wr-
> >wait_on_busy) {
> +			/* Just let the query timeout and have it requeued later
> */
> +			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
> +			ib_free_recv_mad(mad_recv_wc);
> +			deref_mad_agent(mad_agent_priv);
> +			printk(KERN_INFO PFX "SA/SM responded MAD_STATUS_BUSY.
> Allowing request to time out.\n");
> +			return;
> +		}
> +
>  		ib_mark_mad_done(mad_send_wr);
>  		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
> 
> diff --git a/drivers/infiniband/core/mad_priv.h
> b/drivers/infiniband/core/mad_priv.h
> index 01fb7ed..1d0629e 100644
> --- a/drivers/infiniband/core/mad_priv.h
> +++ b/drivers/infiniband/core/mad_priv.h
> @@ -135,6 +135,7 @@ struct ib_mad_send_wr_private {
>  	unsigned long total_timeout;
>  	int max_retries;
>  	int retries_left;
> +	int wait_on_busy;
>  	int randomized_wait;
>  	int retry;
>  	int refcount;
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index c3d6efb..3da55c3 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -255,6 +255,7 @@ struct ib_mad_send_buf {
>  	int			seg_count;
>  	int			seg_size;
>  	int			timeout_ms;
> +	int			wait_on_busy;

I don't see where this is ever set.

>  	int			randomized_wait;
>  	int			retries;
>  };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
