From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Mon, 15 Sep 2014 11:45:13 -0600
Message-ID: <20140915174513.GA3074@obsidianresearch.com>
References: <20140914184621.GA4283@yuval-lab>
 <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw@mail.gmail.com>
 <20140915165820.GB12397@obsidianresearch.com>
 <CAJ3xEMir_FgqS7j+fuhugocawdZXHG9hAK-jpArZ_5vkzVjZeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMir_FgqS7j+fuhugocawdZXHG9hAK-jpArZ_5vkzVjZeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 15, 2014 at 08:20:25PM +0300, Or Gerlitz wrote:
> On Mon, Sep 15, 2014 at 7:58 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > To do this, you need to transfer the offload state across the wire, so
> > on receive you inject the packet with the proper tag that the csum is
> > not computed but ready for offload. A node receiving a packet like
> > this would have to compute the csum before sending it onwards, so no,
> > if done properly it will not break gateways.
> >
> > All the core infrastructure is there, all the virtualization drivers
> > work like this - the guest side does not compute the csum, and the
> > hyperviser side receives the packet with that flag, and the csum
> > ultimately is offloaded to the physical NIC. Look at the xen net
> > driver for an example.
> 
> But is done on the xmitting hypervisor, isn't it? if this is the case,
> I don't see
> the similarity to the IPoIB CM case.

I'm not sure what you mean?

You raised the concern about gateways, which is identical to the
hypervisor case:

G-LINUX --(NO CSUM)--> ring buffer --> H-LINUX --(NO CSUM)--> NIC->WIRE

A-LINUX --(NO CSUM)-->     RC QP   --> B-LINUX --(NO CSUM)--> NIC->WIRE

The key is that csum state is placed in the ring buffer/RC QP with
every packet. Basically, you serialize the entire offload state the
IPoIB send receives from the kernel net stack, dump that onto the
wire, and restore that exact same semantic state on the receive side.

The NIC sees the same packet, with the same offload meta data, as
though it were directly connected to the sending Linux kernel.

The *typical* IPoIB CM case is similar to a guest talking to another
guest:

G1 --(NO CSUM)--> ring buffer --> H-LINUX --(NO CSUM)--> ring buffer --(NO CSUM)--> G2

Here the packet is never csum'd - the 2nd guest simply accepts the
packet with an uncsum'd tag. If you flatten the above it looks
identical to the typical IPoIB case.

Hypervisors are now also doing the same trick with GSO, they send
large packets without a high MTU, because they can take then GSO
master packet state from the sending guest and shuttle the whole thing
without segmentation to the receiving guest (or NIC). IPoIB should do
the same.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
