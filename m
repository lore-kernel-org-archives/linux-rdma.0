From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH v2 01/12] IB/ocrdma: Use kcalloc() in ocrdma_mbx_alloc_pd_range()
Date: Mon, 24 Apr 2017 21:57:34 +0530
Message-ID: <CANjDDBgOa=8d5747AdTAZdwueGYrZNVZBe6zSPKOC1qzyDiheg@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com> <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
 <21442d70-e77b-8338-30f7-9c41d048a665@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <21442d70-e77b-8338-30f7-9c41d048a665@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>

On Sat, Apr 22, 2017 at 8:00 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 22 Apr 2017 11:33:25 +0200
>
> * Multiplications for the size determination of memory allocations
>   indicated that array data structures should be processed.
>   Thus reuse the corresponding function "kcalloc".
>
>   This issue was detected by using the Coccinelle software.
>
> * Delete the local variable "pd_bitmap_size" which became unnecessary
>   with this refactoring.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index aa6967197620..c868314222b9 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1505,7 +1505,6 @@ int ocrdma_mbx_dealloc_pd(struct ocrdma_dev *dev, struct ocrdma_pd *pd)
>  static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
>  {
>         int status = -ENOMEM;
> -       size_t pd_bitmap_size;
>         struct ocrdma_alloc_pd_range *cmd;
>         struct ocrdma_alloc_pd_range_rsp *rsp;
>
> @@ -1527,10 +1526,10 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
>                         dev->pd_mgr->pd_dpp_start = rsp->dpp_page_pdid &
>                                         OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
>                         dev->pd_mgr->max_dpp_pd = rsp->pd_count;
> -                       pd_bitmap_size =
> -                               BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
> -                       dev->pd_mgr->pd_dpp_bitmap = kzalloc(pd_bitmap_size,
> -                                                            GFP_KERNEL);
> +                       dev->pd_mgr->pd_dpp_bitmap
> +                               = kcalloc(BITS_TO_LONGS(rsp->pd_count),
> +                                                       sizeof(long),
> +                                                       GFP_KERNEL);
>                 }
>                 kfree(cmd);
>         }
> @@ -1546,9 +1545,10 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
>                 dev->pd_mgr->pd_norm_start = rsp->dpp_page_pdid &
>                                         OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
>                 dev->pd_mgr->max_normal_pd = rsp->pd_count;
> -               pd_bitmap_size = BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
> -               dev->pd_mgr->pd_norm_bitmap = kzalloc(pd_bitmap_size,
> -                                                     GFP_KERNEL);
> +               dev->pd_mgr->pd_norm_bitmap
> +                       = kcalloc(BITS_TO_LONGS(rsp->pd_count),
> +                                               sizeof(long),
> +                                               GFP_KERNEL);
>         }
>         kfree(cmd);
>
> --
> 2.12.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
