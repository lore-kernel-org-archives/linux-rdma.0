From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 24/26] IB/ocrdma: One jump label less in ocrdma_alloc_ucontext_pd()
Date: Wed, 8 Mar 2017 20:47:53 +0530
Message-ID: <CANjDDBhWJrSfRTYeassC4pW3tVNe3c4X6VTJarRf5B3kw2D-RQ@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <3954cbe9-a265-bcb8-2dac-daade1a5e967@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3954cbe9-a265-bcb8-2dac-daade1a5e967-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Wed, Mar 8, 2017 at 7:00 PM, SF Markus Elfring
<elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org> wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Wed, 8 Mar 2017 11:11:35 +0100
>
> This issue was detected by using the Coccinelle software.
>
> 1. Return directly if a call of the function "_ocrdma_alloc_pd" failed.
>
> 2. Reduce the scope for the local variable "status" to one case
>    of an if statement.
>
> 3. Delete the jump label "err" then.
>
> 4. Return zero as a constant at the end.
>
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index ae0d343d1731..d3cb8e2f099f 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -484,19 +484,17 @@ static int ocrdma_alloc_ucontext_pd(struct ocrdma_dev *dev,
>                                     struct ocrdma_ucontext *uctx,
>                                     struct ib_udata *udata)
>  {
> -       int status = 0;
> -
>         uctx->cntxt_pd = _ocrdma_alloc_pd(dev, uctx, udata);
>         if (IS_ERR(uctx->cntxt_pd)) {
> -               status = PTR_ERR(uctx->cntxt_pd);
> +               int status = PTR_ERR(uctx->cntxt_pd);
> +
>                 uctx->cntxt_pd = NULL;
> -               goto err;
> +               return status;
>         }
>
>         uctx->cntxt_pd->uctx = uctx;
>         uctx->cntxt_pd->ibpd.device = &dev->ibdev;
> -err:
> -       return status;
> +       return 0;
>  }
>
>  static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
> --
> 2.12.0
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
