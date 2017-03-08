From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH 20/26] IB/ocrdma: Delete an unnecessary variable
 assignment in ocrdma_alloc_mr()
Date: Wed, 8 Mar 2017 20:43:51 +0530
Message-ID: <CANjDDBiQs2HJ4CRuXx=di-w+AAdYsTvVfuj0irJJs9ar_XsaiQ@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <24b6074a-f678-c367-484b-e16a0c1f9b5f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <24b6074a-f678-c367-484b-e16a0c1f9b5f@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>

On Wed, Mar 8, 2017 at 6:52 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Mar 2017 10:00:41 +0100
>
> Delete an assignment for the local variable "status" in an if branch
> because the desired failure indication is already specified by a constant
> error code at the end.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 05d55d361cfe..af8798fd35b1 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -3031,10 +3031,8 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
>                 return ERR_PTR(-ENOMEM);
>
>         mr->pages = kcalloc(max_num_sg, sizeof(*mr->pages), GFP_KERNEL);
> -       if (!mr->pages) {
> -               status = -ENOMEM;
> +       if (!mr->pages)
>                 goto pl_err;
> -       }
>
>         status = ocrdma_get_pbl_info(dev, mr, max_num_sg);
>         if (status)
> --
> 2.12.0
>
