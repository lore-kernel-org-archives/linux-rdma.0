From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH 19/26] IB/ocrdma: Improve another size determination in ocrdma_alloc_mr()
Date: Wed, 8 Mar 2017 20:37:51 +0530
Message-ID: <CANjDDBg7pKiKBiwuR=8s0_m9FTqVvjURtTMax+NxJaF=ybdGMg@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <efefdc96-2db5-dd80-3cc4-e88537fe2d49@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <efefdc96-2db5-dd80-3cc4-e88537fe2d49@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>

On Wed, Mar 8, 2017 at 6:50 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Mar 2017 09:54:42 +0100
>
> Replace the specification of a data type by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 330617e1ef75..05d55d361cfe 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -3030,7 +3030,7 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
>         if (!mr)
>                 return ERR_PTR(-ENOMEM);
>
> -       mr->pages = kcalloc(max_num_sg, sizeof(u64), GFP_KERNEL);
> +       mr->pages = kcalloc(max_num_sg, sizeof(*mr->pages), GFP_KERNEL);
>         if (!mr->pages) {
>                 status = -ENOMEM;
>                 goto pl_err;
> --
> 2.12.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
