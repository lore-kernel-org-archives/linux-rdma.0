From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH][next] RDMA/bnxt_re: fix or'ing of data into an
 uninitialized struct member
Date: Mon, 11 Feb 2019 19:11:31 +0530
Message-ID: <CANjDDBj=kzvaWZfwe6rrJki9crfCGxUaBi2Pc+Cb3+MSWYtAVA@mail.gmail.com>
References: <20190211133415.9020-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211133415.9020-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 7:04 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The struct member comp_mask has not been initialized however a bit
> pattern is being bitwise or'd into the member and hence other bit
> fields in comp_mask may contain any garbage from the stack. Fix this
> by making the bitwise or into an assignment.
>
> Fixes: 95b86d1c91ad ("RDMA/bnxt_re: Update kernel user abi to pass chip context")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 1d7469e23cde..de5cb9a61a78 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -3720,7 +3720,7 @@ struct ib_ucontext *bnxt_re_alloc_ucontext(struct ib_device *ibdev,
>         }
>         spin_lock_init(&uctx->sh_lock);
>
> -       resp.comp_mask |= BNXT_RE_UCNTX_CMASK_HAVE_CCTX;
> +       resp.comp_mask = BNXT_RE_UCNTX_CMASK_HAVE_CCTX;
>         chip_met_rev_num = rdev->chip_ctx.chip_num;
>         chip_met_rev_num |= ((u32)rdev->chip_ctx.chip_rev & 0xFF) <<
>                              BNXT_RE_CHIP_ID0_CHIP_REV_SFT;
> --
> 2.20.1
>
Thanks  that was missed!

Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>
