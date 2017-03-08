From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 17/26] IB/ocrdma: Use kmalloc_array() in ocrdma_create_srq()
Date: Wed, 8 Mar 2017 20:35:47 +0530
Message-ID: <CANjDDBgRzeax=do9eLfQdfAn3zaFRwZ2NYrtfwe+oM-gg6PRsg@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <b621d28f-08b5-8d4a-e6ea-b1208f10bb85@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b621d28f-08b5-8d4a-e6ea-b1208f10bb85-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 8, 2017 at 6:47 PM, SF Markus Elfring
<elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org> wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Wed, 8 Mar 2017 08:45:31 +0100
>
> * A multiplication for the size determination of a memory allocation
>   indicated that an array data structure should be processed.
>   Thus use the corresponding function "kmalloc_array".
>
>   This issue was detected by using the Coccinelle software.
>
> * Replace the specification of a data type by a pointer dereference
>   to make the corresponding size determination a bit safer according to
>   the Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index bc9fb144e57b..ef670ac1cbe9 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1910,8 +1910,9 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
>
>                 srq->bit_fields_len = (srq->rq.max_cnt / 32) +
>                     (srq->rq.max_cnt % 32 ? 1 : 0);
> -               srq->idx_bit_fields =
> -                   kmalloc(srq->bit_fields_len * sizeof(u32), GFP_KERNEL);

Lets stick to kmalloc here?

> +               srq->idx_bit_fields = kmalloc_array(srq->bit_fields_len,
> +                                                   sizeof(*srq->idx_bit_fields),
> +                                                   GFP_KERNEL);
>                 if (srq->idx_bit_fields == NULL)
>                         goto arm_err;
>                 memset(srq->idx_bit_fields, 0xff,
> --
> 2.12.0
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
