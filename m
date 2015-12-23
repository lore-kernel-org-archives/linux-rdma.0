From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Wed, 23 Dec 2015 15:01:04 -0500
Message-ID: <20151223200104.GR3860@phlsvsds.ph.intel.com>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449784350-30214-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

With your email troubles I just wanted to make sure you did not lose track of
this patch.

https://patchwork.kernel.org/patch/7822511/

Thanks,
Ira

On Thu, Dec 10, 2015 at 04:52:30PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> It was found that when a process was rapidly sending MADs other processes could
> be hung in their unregister calls.
> 
> This would happen when process A was injecting packets fast enough that the
> single threaded workqueue was never exiting ib_mad_completion_handler.
> Therefore when process B called flush_workqueue via the unregister call it
> would hang until process A stopped sending MADs.
> 
> The fix is to periodically reschedule ib_mad_completion_handler after
> processing a large number of completions.  The number of completions chosen was
> decided based on the defaults for the recv queue size.  However, it was kept
> fixed such that increasing those queue sizes would not adversely affect
> fairness in the future.
> 
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 2281de122038..d4d2a618fd66 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -61,6 +61,18 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
>  
> +/*
> + * Define a limit on the number of completions which will be processed by the
> + * worker thread in a single work item.  This ensures that other work items
> + * (potentially from other users) are processed fairly.
> + *
> + * The number of completions was derived from the default queue sizes above.
> + * We use a value which is double the larger of the 2 queues (receive @ 512)
> + * but keep it fixed such that an increase in that value does not introduce
> + * unfairness.
> + */
> +#define MAD_COMPLETION_PROC_LIMIT 1024
> +
>  static struct list_head ib_mad_port_list;
>  static u32 ib_mad_client_id = 0;
>  
> @@ -2555,6 +2567,7 @@ static void ib_mad_completion_handler(struct work_struct *work)
>  {
>  	struct ib_mad_port_private *port_priv;
>  	struct ib_wc wc;
> +	int count = 0;
>  
>  	port_priv = container_of(work, struct ib_mad_port_private, work);
>  	ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
> @@ -2574,6 +2587,11 @@ static void ib_mad_completion_handler(struct work_struct *work)
>  			}
>  		} else
>  			mad_error_handler(port_priv, &wc);
> +
> +		if (++count > MAD_COMPLETION_PROC_LIMIT) {
> +			queue_work(port_priv->wq, &port_priv->work);
> +			break;
> +		}
>  	}
>  }
>  
> -- 
> 1.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
