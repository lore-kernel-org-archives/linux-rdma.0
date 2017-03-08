From: Devesh Sharma <devesh.sharma@broadcom.com>
Subject: Re: [PATCH 15/26] IB/ocrdma: Delete an error message for a failed
 memory allocation in ocrdma_add()
Date: Wed, 8 Mar 2017 20:33:04 +0530
Message-ID: <CANjDDBj_8OYNqshrqBy25TdzaSdCGBaYkApBJG+jjHmx5O0DKA@mail.gmail.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net> <20d97719-3d3a-62f6-a249-f39cf528c5e9@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20d97719-3d3a-62f6-a249-f39cf528c5e9@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh sharma <devesh.sharma@broadcom.com>

On Wed, Mar 8, 2017 at 6:43 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 7 Mar 2017 22:23:17 +0100
>
> Omit an extra message for a memory allocation failure in this function.
>
> Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index c49b4491d4e7..93113feeb2d5 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -304,10 +304,9 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
>         struct ocrdma_dev *dev;
>
>         dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(*dev));
> -       if (!dev) {
> -               pr_err("Unable to allocate ib device\n");
> +       if (!dev)
>                 return NULL;
> -       }
> +
>         dev->mbx_cmd = kzalloc(sizeof(struct ocrdma_mqe_emb_cmd), GFP_KERNEL);
>         if (!dev->mbx_cmd)
>                 goto idr_err;
> --
> 2.12.0
>
