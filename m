From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Thu, 4 Apr 2013 17:00:40 +0300
Message-ID: <201304041700.40349.jackm@dev.mellanox.co.il>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com> <CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com> <515D79B3.4090808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515D79B3.4090808-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 04 April 2013 16:01, Kleber Sacilotto de Souza wrote:
> On 04/02/2013 02:00 PM, Roland Dreier wrote:
> >> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> >> index 35cced2..0fa4f72 100644
> >> --- a/drivers/infiniband/hw/mlx4/qp.c
> >> +++ b/drivers/infiniband/hw/mlx4/qp.c
> >> @@ -2216,6 +2216,9 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> >>         __be32 blh;
> >>         int i;
> >>
> >> +       if (pci_channel_offline(to_mdev(ibqp->device)->dev->pdev))
> >> +               return -EIO;
> >> +
> >>         spin_lock_irqsave(&qp->sq.lock, flags);
> >>
> >>         ind = qp->sq_next_wqe;
> > 
> > To pile on to what Or and Jack asked, why here?  Why not in post_recv?
> >  Why not in mlx4_en?  What about userspace consumers?  What if the
> > error condition triggers just after the pci_channel_offline() check?
> > What if a command is queued but a PCI error occurs before the
> > completion can be returned?
> > 
> > Is there some practical scenario where this change makes a difference?
> > 
> > I would assume that in case of a PCI error, the driver would notice a
> > catastrophic error and send that asynchronous event to consumers, who
> > would know that commands might have been lost.
> > 
> 
> The problem that I'm trying to solve is that some IB core modules are
> hanging waiting on completion queues on their remove path during error
> recovery. I've added the pci offline check in post_send, which seemed to
> have to solved the problem, but while running other tests I was able to
> hit the bug again. Adding the check in post_recv also only hid the
> problem for a few testcases.
> 
> Adding any check in mlx4_en doesn't make sense in this case, because the
> problem is only with IB adapters. The ethernet/RoCE adapters are
> recovering fine, the check has been added already on the relevant places
> in mlx4_core.
> 
> What async event should be sent to consumers before calling the remove
> functions? IB_EVENT_DEVICE_FATAL, which is currently sent by mlx4_core
> in case of catastrophic error (but not in PCI error recovery), doesn't
> seem to be handled by most of the event handlers registered. Sending
> IB_EVENT_PORT_ERR seems to solve the problem for most modules, but
> rdma_cm, which doesn't have an event handler, is still hanging. Should
> we implement an event handler for rdma_cm?
>

This won't really help unless ALL userspace apps respond by calling ibv_close_device.
You can check this by running ibv_asyncwatch  (in libibverbs/examples). Until ibv_asyncwatch
is exited the low-level device restart won't work.

-Jack
> 
> Thanks!
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
