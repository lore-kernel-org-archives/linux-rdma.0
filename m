From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH 22/26] IB/ocrdma: Returning only value constants in ocrdma_resize_cq()
Date: Wed, 8 Mar 2017 20:46:03 +0530
Message-ID: <CANjDDBh0C8p4VaP+TON+ZdyBJVUjxoU7HuXBrf1-1=34DTmdbA@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <dd638070-d1d6-44e8-6c10-16919b59482c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dd638070-d1d6-44e8-6c10-16919b59482c@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-By:Devesh Sharma <devesh.sharma@broadcom.com>

On Wed, Mar 8, 2017 at 6:56 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Mar 2017 10:48:24 +0100
>
> Return constant integer values without storing them in the local
> variable "status".
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index bedc229be89d..1d25512416f5 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1123,15 +1123,12 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev,
>  int ocrdma_resize_cq(struct ib_cq *ibcq, int new_cnt,
>                      struct ib_udata *udata)
>  {
> -       int status = 0;
>         struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
>
> -       if (new_cnt < 1 || new_cnt > cq->max_hw_cqe) {
> -               status = -EINVAL;
> -               return status;
> -       }
> +       if (new_cnt < 1 || new_cnt > cq->max_hw_cqe)
> +               return -EINVAL;
>         ibcq->cqe = new_cnt;
> -       return status;
> +       return 0;
>  }
>
>  static void ocrdma_flush_cq(struct ocrdma_cq *cq)
> --
> 2.12.0
>
