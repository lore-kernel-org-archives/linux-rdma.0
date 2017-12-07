From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma: Remove unneeded conversions to bool
Date: Thu, 7 Dec 2017 09:32:00 +0530
Message-ID: <CANjDDBjaqTqZq-pSYRNGt_DA+2kh=jBs+C8_Yc8XHqBuAUfs4Q@mail.gmail.com>
References: <20171205191553.21770-1-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205191553.21770-1-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

looks good, Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Wed, Dec 6, 2017 at 12:45 AM, Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org> wrote:
> Found with scripts/coccinelle/misc/boolconv.cocci.
>
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 7866fd8051f6..b5f1dd33b73e 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -461,7 +461,7 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
>  static inline int is_ucontext_pd(struct ocrdma_ucontext *uctx,
>                                  struct ocrdma_pd *pd)
>  {
> -       return (uctx->cntxt_pd == pd ? true : false);
> +       return (uctx->cntxt_pd == pd);
>  }
>
>  static int _ocrdma_dealloc_pd(struct ocrdma_dev *dev,
> --
> 2.15.0
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
