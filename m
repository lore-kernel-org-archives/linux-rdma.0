From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Mon, 28 Dec 2015 18:51:30 +0200
Message-ID: <20151228165130.GA13150@x-vnc01.mtx.labs.mlnx>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449784350-30214-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 04:52:30PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
>  
> @@ -2555,6 +2567,7 @@ static void ib_mad_completion_handler(struct work_struct *work)
>  {
>  	struct ib_mad_port_private *port_priv;
>  	struct ib_wc wc;
> +	int count = 0;
>  
>  	port_priv = container_of(work, struct ib_mad_port_private, work);
>  	ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);

I think you shoudld push the call to ib_req_notify_cq outside the
while loop. You don't need to arm the CQ if you re-queued the work.
Only when you have drained the CQ should you re-arm.

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
