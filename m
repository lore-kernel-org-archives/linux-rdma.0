From: Parav Pandit <parav@mellanox.com>
Subject: RE: IB on s390 broken with commit 99db94940 "IB/core: Remove
 ib_device.dma_device"
Date: Tue, 28 Feb 2017 19:53:10 +0000
Message-ID: <VI1PR0502MB30082C037BEE60367954ED0FD1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
         <1488233058.2597.1.camel@sandisk.com>
         <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
 <1488300599.2370.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488300599.2370.5.camel@sandisk.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "sebott@linux.vnet.ibm.com" <sebott@linux.vnet.ibm.com>
Cc: "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

I am using Linux-block tree testing on x86_64.
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git

Commit ac1820fb286b552b6885d40ab34f1e59b815f1f1 introduced dma_ops related =
change that you made.
With this change I am hitting below error in mlx5_ib driver.
"DMAR: Allocating domain for mlx5_0 failed"

I revert back to commit edccb59429657b09806146339e2b27594c1d1da0.
With revert I do not hit the error.

I do not have cycles to debug/fix this currently. Do you think this might b=
e related to your change?

Parav

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Bart Van Assche
> Sent: Tuesday, February 28, 2017 10:50 AM
> To: sebott@linux.vnet.ibm.com
> Cc: gerald.schaefer@de.ibm.com; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; dledford@redhat.com
> Subject: Re: IB on s390 broken with commit 99db94940 "IB/core: Remove
> ib_device.dma_device"
>=20
> On Tue, 2017-02-28 at 09:53 +0100, Sebastian Ott wrote:
> > On Mon, 27 Feb 2017, Bart Van Assche wrote:
> >
> > > On Mon, 2017-02-27 at 21:17 +0100, Sebastian Ott wrote:
> > > > commit 99db94940 "IB/core: Remove ib_device.dma_device"
> > > > breaks infiniband on s390 (and I think also other archs that do
> > > > something like to_pci_dev(dev) in one of their dma_ops callbacks).
> > > >
> > > > With this commit you use the dma_ops of the device that called
> > > > ib_register_device but you call e.g. dma_map with ib_device->dev
> > > > as an argument.
> > > >
> > > > S390's (pci specific) dma_map uses to_pci_dev(dev) to look into
> > > > the pci device (and its arch specific data) and oopses.
> > > >
> > > > Calling dma_map with ib_device->dev.parent would work but then it
> > > > wouldn't make sense to copy dma_ops and mask from
> > > > ib_device->dev.parent to ib_device->dev..
> > >
> > > How about something like the untested patch below?
> >
> > It works but it doesn't feel right (why should all pci devices have
> > this duplicated data).
> >
> > Frankly I don't get the usecase of infiniband (sometimes) using
> > device->dev.dma_ops instead of parent->dma_ops. Also that these values
> > device->are
> > selectively copied from the parent looks weird (opposed to all or nothi=
ng).
> >
> > What about reintroducing dma_device (as an infiniband internal) and
> > set it to &ib_device->dev if you have to and to parent in all other cas=
es?
>=20
> Hello Sebastian,
>=20
> There are three kinds of RDMA drivers:
> - RDMA drivers that always use DMA for transferring data between memory
> and
>   HCA (e.g. mlx4, mlx5, ...). These drivers make the ULP call the PCI DMA
>   mapping functions directly.
> - RDMA drivers that never use DMA directly but use another driver for
>   transferring data (e.g. rdma_rxe). This driver makes the ULP store virt=
ual
>   addresses in .dma_address.
> - RDMA drivers that decide whether to use PIO or DMA depending on e.g.
> the
>   QP type and the amount of data to be transferred (qib, hfi1). These dri=
vers
>   also make the ULP store virtual addresses in .dma_address and decide
>   internally whether or not to invoke the PCI DMA mapping functions.
>=20
> This is why a custom DMA mapping API was introduced in the RDMA
> subsystem.
> Until recently the Linux RDMA subsystem not only had its own DMA mapping
> operations but also its own template for DMA mapping operations (struct
> ib_dma_mapping_ops). This is not only confusing but also led to a multitu=
de
> of incomplete and RDMA driver DMA mapping operations of which
> additionally the behavior is slightly different of other DMA mapping
> operations. That's why we want to evolve towards a single DMA mapping
> API. Reintroducing the dma_device pointer in struct ib_device would make =
it
> impossible to use the standard DMA mapping API for RDMA devices.
>=20
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
