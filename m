From: Hoang-Nam Nguyen <HNGUYEN-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 37/62] infiniband: irq: Remove IRQF_DISABLED
Date: Tue, 13 Sep 2011 10:27:16 +0200
Message-ID: <OF5F6785FA.2466AF15-ONC125790A.002E2A52-C125790A.002E8113@de.ibm.com>
References: <OF29249FB5.153CCB29-ONC1257909.00499475-C1257909.00499954@LocalDomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF29249FB5.153CCB29-ONC1257909.00499475-C1257909.00499954@LocalDomain>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yong Zhang <yong.zhang0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch looks fine to me.
Thx
Nam

> From: Yong Zhang <yong.zhang0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, Hoang-Nam Nguyen/Germany/
> IBM@IBMDE, Christoph Raisch/Germany/IBM@IBMDE, Roland Dreier
> <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal
> Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date: 09/07/2011 10:22 AM
> Subject: [PATCH 37/62] infiniband: irq: Remove IRQF_DISABLED
>
> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/ehca/ehca_eq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/
> infiniband/hw/ehca/ehca_eq.c
> index d9b1bb4..818d721 100644
> --- a/drivers/infiniband/hw/ehca/ehca_eq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_eq.c
> @@ -125,7 +125,7 @@ int ehca_create_eq(struct ehca_shca *shca,
>        tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
>
>        ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
> -                 IRQF_DISABLED, "ehca_eq",
> +                 0, "ehca_eq",
>                   (void *)shca);
>        if (ret < 0)
>           ehca_err(ib_dev, "Can't map interrupt handler.");
> @@ -133,7 +133,7 @@ int ehca_create_eq(struct ehca_shca *shca,
>        tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
>
>        ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
> -                 IRQF_DISABLED, "ehca_neq",
> +                 0, "ehca_neq",
>                   (void *)shca);
>        if (ret < 0)
>           ehca_err(ib_dev, "Can't map interrupt handler.");
> --
> 1.7.4.1
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
