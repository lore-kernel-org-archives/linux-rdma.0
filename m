From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/hfi1: Using kfree_rcu() to simplify the code
Date: Tue, 9 Aug 2016 16:20:08 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2D09F703@fmsmsx120.amr.corp.intel.com>
References: <1470649818-30040-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470649818-30040-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Monday, August 8, 2016 5:50 AM
> To: Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Dalessandro, Dennis
> <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Hal Rosenstock
> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] IB/hfi1: Using kfree_rcu() to simplify the code
> 
> The callback function of call_rcu() just calls a kfree(), so we can use
> kfree_rcu() instead of call_rcu() + callback function.
> 
> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/mad.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/mad.c
> b/drivers/infiniband/hw/hfi1/mad.c
> index 1263abe..95c43e1 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -3398,7 +3398,7 @@ static void apply_cc_state(struct hfi1_pportdata
> *ppd)
> 
>  	spin_unlock(&ppd->cc_state_lock);
> 
> -	call_rcu(&old_cc_state->rcu, cc_state_reclaim);
> +	kfree_rcu(old_cc_state, rcu);
>  }
> 

This patch misses another call_rcu() that needs to be replaced in cleanup_device_data()
and that seems to be causing 0day issues.

Doug, have you put this anywhere to elicit the 0day issues?

Nacked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
