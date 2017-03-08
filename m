From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH 18/26] IB/ocrdma: Use kcalloc() in three functions
Date: Wed, 8 Mar 2017 20:40:53 +0530
Message-ID: <CANjDDBjauQ3ztmsbHf9k=4xhP+j1niQvob=zX=Vb8T9xOKr6KQ@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <b90d1d62-6c0e-6f29-0ec3-58287fe87059@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <b90d1d62-6c0e-6f29-0ec3-58287fe87059@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By:Devesh Sharma <devesh.sharma@broadcom.com>

On Wed, Mar 8, 2017 at 6:49 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Mar 2017 09:19:47 +0100
>
> * Multiplications for the size determination of memory allocations
>   indicated that array data structures should be processed.
>   Thus reuse the corresponding function "kcalloc".
>
>   This issue was detected by using the Coccinelle software.
>
> * Replace the specification of data types by pointer dereferences
>   to make the corresponding size determinations a bit safer according to
>   the Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index ef670ac1cbe9..330617e1ef75 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -879,9 +879,8 @@ static int ocrdma_build_pbl_tbl(struct ocrdma_dev *dev, struct ocrdma_hw_mr *mr)
>         void *va;
>         dma_addr_t pa;
>
> -       mr->pbl_table = kzalloc(sizeof(struct ocrdma_pbl) *
> -                               mr->num_pbls, GFP_KERNEL);
> -
> +       mr->pbl_table = kcalloc(mr->num_pbls, sizeof(*mr->pbl_table),
> +                               GFP_KERNEL);
>         if (!mr->pbl_table)
>                 return -ENOMEM;
>
> @@ -1362,13 +1361,12 @@ static void ocrdma_set_qp_db(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
>
>  static int ocrdma_alloc_wr_id_tbl(struct ocrdma_qp *qp)
>  {
> -       qp->wqe_wr_id_tbl =
> -           kzalloc(sizeof(*(qp->wqe_wr_id_tbl)) * qp->sq.max_cnt,
> -                   GFP_KERNEL);
> +       qp->wqe_wr_id_tbl = kcalloc(qp->sq.max_cnt, sizeof(*qp->wqe_wr_id_tbl),
> +                                   GFP_KERNEL);
>         if (qp->wqe_wr_id_tbl == NULL)
>                 return -ENOMEM;
> -       qp->rqe_wr_id_tbl =
> -           kzalloc(sizeof(u64) * qp->rq.max_cnt, GFP_KERNEL);
> +       qp->rqe_wr_id_tbl = kcalloc(qp->rq.max_cnt, sizeof(*qp->rqe_wr_id_tbl),
> +                                   GFP_KERNEL);
>         if (qp->rqe_wr_id_tbl == NULL)
>                 return -ENOMEM;
>
> @@ -1903,8 +1901,9 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
>                 goto err;
>
>         if (udata == NULL) {
> -               srq->rqe_wr_id_tbl = kzalloc(sizeof(u64) * srq->rq.max_cnt,
> -                           GFP_KERNEL);
> +               srq->rqe_wr_id_tbl = kcalloc(srq->rq.max_cnt,
> +                                            sizeof(*srq->rqe_wr_id_tbl),
> +                                            GFP_KERNEL);
>                 if (srq->rqe_wr_id_tbl == NULL)
>                         goto arm_err;
>
> --
> 2.12.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
