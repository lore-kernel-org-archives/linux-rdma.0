From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/qib: remove duplicate code
Date: Thu, 8 Jun 2017 09:14:44 -0400
Message-ID: <e5d9e8ea-460c-5318-e218-44449e6a3af7@intel.com>
References: <20170607204202.GA29640@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170607204202.GA29640@embeddedgus>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/7/2017 4:42 PM, Gustavo A. R. Silva wrote:
> Remove duplicate code.
> 
> Addresses-Coverity-ID: 1226951
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> ---
>   drivers/infiniband/hw/qib/qib_mad.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
> index da295e0..c5eaa3c 100644
> --- a/drivers/infiniband/hw/qib/qib_mad.c
> +++ b/drivers/infiniband/hw/qib/qib_mad.c
> @@ -874,8 +874,6 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
>   		ib_dispatch_event(&event);
>   	}
>   
> -	ret = subn_get_portinfo(smp, ibdev, port);
> -
>   	/* restore re-reg bit per o14-12.2.1 */
>   	pip->clientrereg_resv_subnetto |= clientrereg;
>   
> 

Would be nice to see a few more words in the commit message rather than 
having to go look for Coverity.

Regardless, patch seems fine to me code wise.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
