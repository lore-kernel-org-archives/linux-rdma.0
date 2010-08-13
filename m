From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 1/3 v4] IB/srp: Preparation for transmit ring response
 allocation
Date: Fri, 13 Aug 2010 14:24:49 -0400
Message-ID: <1281723889.2437.52.camel@lap75545.ornl.gov>
References: <201008102033.29588.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008102033.29588.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-10 at 20:33 +0200, Bart Van Assche wrote:
> @@ -820,9 +820,11 @@ static int srp_post_recv(struct srp_target_port *target)
>  	unsigned int next;
>  	int ret;
>  
> +	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_RQ_MASK + 1);
> +

Please put this together with the other build bug in the module init
section. If it trips, it informs the user that made the broken change
about both restrictions in the same place. Also, don't use SRP_RQ_MASK +
1, use SRP_RQ_SIZE.


> @@ -989,19 +991,23 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
>  static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
>  					enum srp_request_type req_type)
>  {
> -	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;
> +	s32 rsv;
> +
> +	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_SQ_MASK + 1);

As above.

> +
> +	rsv = (req_type == SRP_REQ_NORMAL) ? SRP_TSK_MGMT_RSV : 0;
>  
>  	srp_send_completion(target->send_cq, target);
>  
> -	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
> +	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE - rsv)
>  		return NULL;

This isn't needed per my previous message. It is just a guard to make
sure we don't use more buffers than are on the ring. The real limiter is
the number of credits. Perhaps swapping it with the req_limit check
below and adding a WARN_ONCE() may be a good idea, since I don't think
we should ever hit it.

> -	if (target->req_lim < min) {
> +	if (target->req_lim <= rsv) {
>  		++target->zero_req_lim;
>  		return NULL;
>  	}


> @@ -1626,9 +1632,9 @@ static struct scsi_host_template srp_template = {
>  	.eh_abort_handler		= srp_abort,
>  	.eh_device_reset_handler	= srp_reset_device,
>  	.eh_host_reset_handler		= srp_reset_host,
> -	.can_queue			= SRP_SQ_SIZE,
> +	.can_queue			= SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_RSV,

I don't like the naming here and the duplicate math in several places.
Pick a name for this and use it. Since this is just the template and is
overridden when we actually connect to a host, I'm not sure there is a
much of a reason to change things here anyways. Same for the next two...

>  	.this_id			= -1,
> -	.cmd_per_lun			= SRP_SQ_SIZE,
> +	.cmd_per_lun			= SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_RSV,
>  	.use_clustering			= ENABLE_CLUSTERING,
>  	.shost_attrs			= srp_host_attrs
>  };

> -			target->scsi_host->cmd_per_lun = min(token, SRP_SQ_SIZE);
> +			target->scsi_host->cmd_per_lun = min(token,
> +							     SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_RSV);
>  			break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
