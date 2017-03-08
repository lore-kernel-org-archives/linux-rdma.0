From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH 23/26] IB/ocrdma: Delete an unnecessary variable in ocrdma_dealloc_pd()
Date: Wed, 8 Mar 2017 20:46:50 +0530
Message-ID: <CANjDDBgKiLaM0qoLzZDHv-Qv6-M-QGPjRNk_2dQ60jGREQ_oEQ@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <0e667a69-3afa-6122-ed3b-d313bc5909ad@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0e667a69-3afa-6122-ed3b-d313bc5909ad@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>

On Wed, Mar 8, 2017 at 6:58 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Mar 2017 10:58:34 +0100
>
> 1. Return zero in one case directly.
>
> 2. Return the value from a call of the function "_ocrdma_dealloc_pd"
>    without using an extra assignment for the local variable.
>
> 3. Remove the variable "status" in this function then.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 1d25512416f5..ae0d343d1731 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -755,7 +755,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
>         struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
>         struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
>         struct ocrdma_ucontext *uctx = NULL;
> -       int status = 0;
>         u64 usr_db;
>
>         uctx = pd->uctx;
> @@ -769,11 +768,10 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
>
>                 if (is_ucontext_pd(uctx, pd)) {
>                         ocrdma_release_ucontext_pd(uctx);
> -                       return status;
> +                       return 0;
>                 }
>         }
> -       status = _ocrdma_dealloc_pd(dev, pd);
> -       return status;
> +       return _ocrdma_dealloc_pd(dev, pd);
>  }
>
>  static int ocrdma_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
> --
> 2.12.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
