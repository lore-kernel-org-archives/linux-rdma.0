From: Selvin Xavier <selvin.xavier@avagotech.com>
Subject: Re: [PATCH v2 1/6] InfiniBand-ocrdma: One jump label less in ocrdma_alloc_ucontext_pd()
Date: Mon, 11 Jan 2016 18:41:07 +0530
Message-ID: <CA+sbYW31rf614mozAmNHbTH=a06WWZ7D4fkBD+jaa=zCyqj2XA@mail.gmail.com>
References: <201512270304.PMbiMdOa%fengguang.wu@intel.com>
	<567F068C.9060507@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <567F068C.9060507@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

This patch series looks good to me

Thanks,

Acked-by: Selvin Xavier <selvin.xavier@avagotech.com>



On Sun, Dec 27, 2015 at 2:58 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 26 Dec 2015 22:18:38 +0100
>
> This issue was detected by using the Coccinelle software.
>
> * Let us return directly if a call of the _ocrdma_alloc_pd()
>   function failed.
>
> * Reduce the scope for the local variable "status" to one case
>   of an if statement.
>
> * Delete the jump label "err" then.
>
> * Return zero as a constant at the end.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 583001b..7f10cc47 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -483,19 +483,16 @@ static int ocrdma_alloc_ucontext_pd(struct ocrdma_dev *dev,
>                                     struct ocrdma_ucontext *uctx,
>                                     struct ib_udata *udata)
>  {
> -       int status = 0;
> -
>         uctx->cntxt_pd = _ocrdma_alloc_pd(dev, uctx, udata);
>         if (IS_ERR(uctx->cntxt_pd)) {
> -               status = PTR_ERR(uctx->cntxt_pd);
> +               int status = PTR_ERR(uctx->cntxt_pd);
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
> 2.6.3
>
