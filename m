From: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: IB on s390 broken with commit 99db94940 "IB/core: Remove
 ib_device.dma_device"
Date: Tue, 28 Feb 2017 10:20:00 +0100 (CET)
Message-ID: <alpine.LFD.2.20.1702281011220.2045@schleppi.fritz.box>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box> <1488233058.2597.1.camel@sandisk.com> <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.20.1702280950380.2045-+lzQMq5bIdMXU02nzanrWNbf9cGiqdzd@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 28 Feb 2017, Sebastian Ott wrote:
> On Mon, 27 Feb 2017, Bart Van Assche wrote:
> > On Mon, 2017-02-27 at 21:17 +0100, Sebastian Ott wrote:
> > > commit 99db94940 "IB/core: Remove ib_device.dma_device"
> > > breaks infiniband on s390 (and I think also other archs that do something
> > > like to_pci_dev(dev) in one of their dma_ops callbacks).
> > > 
> > > With this commit you use the dma_ops of the device that called
> > > ib_register_device but you call e.g. dma_map with ib_device->dev
> > > as an argument.
> > > 
> > > S390's (pci specific) dma_map uses to_pci_dev(dev) to look into the
> > > pci device (and its arch specific data) and oopses.
> > > 
> > > Calling dma_map with ib_device->dev.parent would work but then it
> > > wouldn't make sense to copy dma_ops and mask from ib_device->dev.parent
> > > to ib_device->dev..
> > 
> > How about something like the untested patch below?
> 
> It works but it doesn't feel right (why should all pci devices have this
> duplicated data).
> 
> Frankly I don't get the usecase of infiniband (sometimes) using
> device->dev.dma_ops instead of parent->dma_ops.

Ok, some drivers in drivers/infiniband/sw/ set dma_ops to &dma_virt_ops .

So instead of copying the dma_ops you could do

if (!device->dev.dma_ops) /*or use some new flag for ib_register_device*/
	device->dma_device = parent;
else
	device->dma_device = &device->dev;

Sebastian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
