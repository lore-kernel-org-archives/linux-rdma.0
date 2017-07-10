From: Selvin Xavier <selvin.xavier@broadcom.com>
Subject: Re: [PATCH] RDMA/bnxt_re: checking for NULL instead of IS_ERR()
Date: Mon, 10 Jul 2017 15:04:13 +0530
Message-ID: <CA+sbYW10-MzZz=4kaq27xucVYVWKhvFd-aNVBEMnAgwVdJvAPQ@mail.gmail.com>
References: <20170710072247.6eczlwcxu5mt5jry@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170710072247.6eczlwcxu5mt5jry@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>

Thanks

On Mon, Jul 10, 2017 at 12:52 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> bnxt_re_alloc_mw() doesn't return NULL, it returns error pointers.
>
> Fixes: 9152e0b722b2 ("RDMA/bnxt_re: HW workarounds for handling specific conditions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index c7bd68311d0c..e794b0fa4ae6 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -588,10 +588,10 @@ static int bnxt_re_create_fence_mr(struct bnxt_re_pd *pd)
>
>         /* Create a fence MW only for kernel consumers */
>         mw = bnxt_re_alloc_mw(&pd->ib_pd, IB_MW_TYPE_1, NULL);
> -       if (!mw) {
> +       if (IS_ERR(mw)) {
>                 dev_err(rdev_to_dev(rdev),
>                         "Failed to create fence-MW for PD: %p\n", pd);
> -               rc = -EINVAL;
> +               rc = PTR_ERR(mw);
>                 goto fail;
>         }
>         fence->mw = mw;
