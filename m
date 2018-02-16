From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] vmw_pvrdma: Avoid rounding up of sge count to power of 2
Date: Fri, 16 Feb 2018 09:15:26 -0700
Message-ID: <20180216161526.GC22739@ziepe.ca>
References: <1518741592-12723-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518741592-12723-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 15, 2018 at 04:39:52PM -0800, Adit Ranadive wrote:
> Creation of resources can fail if the rounding up exceeds
> provider supported values.
> 
> Fixes: 4c8ed14eb6b7 ("vmw_pvrdma: Add SRQ support")
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
>  providers/vmw_pvrdma/qp.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
> index efcc99b..4b9f897 100644
> +++ b/providers/vmw_pvrdma/qp.c
> @@ -113,7 +113,7 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
>  	int ret;
>  
>  	attr->attr.max_wr = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_wr));
> -	attr->attr.max_sge = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_sge));
> +	attr->attr.max_sge = max_t(uint32_t, 1U, attr->attr.max_sge);

What is with all these max's? If the user provides <= 0 for these
values it should be EINVAL, not round up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
