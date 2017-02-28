From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: IB on s390 broken with commit 99db94940 "IB/core: Remove
 ib_device.dma_device"
Date: Tue, 28 Feb 2017 09:53:47 +0100 (CET)
Message-ID: <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box> <1488233058.2597.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488233058.2597.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 27 Feb 2017, Bart Van Assche wrote:

> On Mon, 2017-02-27 at 21:17 +0100, Sebastian Ott wrote:
> > commit 99db94940 "IB/core: Remove ib_device.dma_device"
> > breaks infiniband on s390 (and I think also other archs that do something
> > like to_pci_dev(dev) in one of their dma_ops callbacks).
> > 
> > With this commit you use the dma_ops of the device that called
> > ib_register_device but you call e.g. dma_map with ib_device->dev
> > as an argument.
> > 
> > S390's (pci specific) dma_map uses to_pci_dev(dev) to look into the
> > pci device (and its arch specific data) and oopses.
> > 
> > Calling dma_map with ib_device->dev.parent would work but then it
> > wouldn't make sense to copy dma_ops and mask from ib_device->dev.parent
> > to ib_device->dev..
> 
> How about something like the untested patch below?

It works but it doesn't feel right (why should all pci devices have this
duplicated data).

Frankly I don't get the usecase of infiniband (sometimes) using
device->dev.dma_ops instead of parent->dma_ops. Also that these values are
selectively copied from the parent looks weird (opposed to all or nothing).

What about reintroducing dma_device (as an infiniband internal) and set it
to &ib_device->dev if you have to and to parent in all other cases?

Sebastian
