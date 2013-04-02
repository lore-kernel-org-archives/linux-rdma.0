From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Tue, 2 Apr 2013 10:00:40 -0700
Message-ID: <CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364496315-7588-1-git-send-email-klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 35cced2..0fa4f72 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -2216,6 +2216,9 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>         __be32 blh;
>         int i;
>
> +       if (pci_channel_offline(to_mdev(ibqp->device)->dev->pdev))
> +               return -EIO;
> +
>         spin_lock_irqsave(&qp->sq.lock, flags);
>
>         ind = qp->sq_next_wqe;

To pile on to what Or and Jack asked, why here?  Why not in post_recv?
 Why not in mlx4_en?  What about userspace consumers?  What if the
error condition triggers just after the pci_channel_offline() check?
What if a command is queued but a PCI error occurs before the
completion can be returned?

Is there some practical scenario where this change makes a difference?

I would assume that in case of a PCI error, the driver would notice a
catastrophic error and send that asynchronous event to consumers, who
would know that commands might have been lost.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
