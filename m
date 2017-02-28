From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: IB on s390 broken with commit 99db94940 "IB/core: Remove
 ib_device.dma_device"
Date: Tue, 28 Feb 2017 16:50:13 +0000
Message-ID: <1488300599.2370.5.camel@sandisk.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
         <1488233058.2597.1.camel@sandisk.com>
         <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.20.1702280950380.2045-+lzQMq5bIdMXU02nzanrWNbf9cGiqdzd@public.gmane.org>
Content-Language: en-US
Content-ID: <2C8ED9D82ADF5644BB1BDD313A99A1EA-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-28 at 09:53 +0100, Sebastian Ott wrote:
> On Mon, 27 Feb 2017, Bart Van Assche wrote:
>=20
> > On Mon, 2017-02-27 at 21:17 +0100, Sebastian Ott wrote:
> > > commit 99db94940 "IB/core: Remove ib_device.dma_device"
> > > breaks infiniband on s390 (and I think also other archs that do somet=
hing
> > > like to_pci_dev(dev) in one of their dma_ops callbacks).
> > >=20
> > > With this commit you use the dma_ops of the device that called
> > > ib_register_device but you call e.g. dma_map with ib_device->dev
> > > as an argument.
> > >=20
> > > S390's (pci specific) dma_map uses to_pci_dev(dev) to look into the
> > > pci device (and its arch specific data) and oopses.
> > >=20
> > > Calling dma_map with ib_device->dev.parent would work but then it
> > > wouldn't make sense to copy dma_ops and mask from ib_device->dev.pare=
nt
> > > to ib_device->dev..
> >=20
> > How about something like the untested patch below?
>=20
> It works but it doesn't feel right (why should all pci devices have this
> duplicated data).
>=20
> Frankly I don't get the usecase of infiniband (sometimes) using
> device->dev.dma_ops instead of parent->dma_ops. Also that these values ar=
e
> selectively copied from the parent looks weird (opposed to all or nothing=
).
>=20
> What about reintroducing dma_device (as an infiniband internal) and set i=
t
> to &ib_device->dev if you have to and to parent in all other cases?

Hello Sebastian,

There are three kinds of RDMA drivers:
- RDMA drivers that always use DMA for transferring data between memory and
  HCA (e.g. mlx4, mlx5, ...). These drivers make the ULP call the PCI DMA
  mapping functions directly.
- RDMA drivers that never use DMA directly but use another driver for
  transferring data (e.g. rdma_rxe). This driver makes the ULP store virtua=
l
  addresses in .dma_address.
- RDMA drivers that decide whether to use PIO or DMA depending on e.g. the
  QP type and the amount of data to be transferred (qib, hfi1). These drive=
rs
  also make the ULP store virtual addresses in .dma_address and decide
  internally whether or not to invoke the PCI DMA mapping functions.

This is why a custom DMA mapping API was introduced in the RDMA subsystem.
Until recently the Linux RDMA subsystem not only had its own DMA mapping
operations but also its own template for DMA mapping operations (struct
ib_dma_mapping_ops). This is not only confusing but also led to a multitude
of incomplete and RDMA driver DMA mapping operations of which additionally
the behavior is slightly different of other DMA mapping operations. That's
why we want to evolve towards a single DMA mapping API. Reintroducing the
dma_device pointer in struct ib_device would make it impossible to use the
standard DMA mapping API for RDMA devices.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
