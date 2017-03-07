From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
 embedded in struct pci_dev
Date: Tue, 7 Mar 2017 18:14:03 +0100
Message-ID: <20170307171403.GA19293@kroah.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
 <20170307003549.3872-2-bart.vanassche@sandisk.com>
 <20170307045236.GC3913@kroah.com>
 <1488905685.2739.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488905685.2739.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org" <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 07, 2017 at 04:54:58PM +0000, Bart Van Assche wrote:
> On Tue, 2017-03-07 at 05:52 +0100, Greg Kroah-Hartman wrote:
> > Somehow all other subsystems work just fine, don't instantly think that
> > the driver core needs to bend to the will of the IB code, because you
> > are somehow "special".  Hint, you aren't :)
> 
> Hi Greg,
> 
> In another e-mail Parav compared IB drivers with networking drivers.

Great, then notice that networking drivers don't need to do this type of
crud :)

> But I think that's a bad comparison: in the networking stack it's the
> network driver itself that sets up and triggers DMA while in the IB
> stack it's the upper layer protocol (ULP) driver that calls the
> functions defined in struct dma_ops. For some IB HW drivers (hfi1, qib
> and rdma_rxe) the ULP driver must
> use the DMA mapping operations from lib/dma-virt.c while for all other IB HW
> drivers the ULP driver must use the PCI DMA mapping functions. The ib_dma_*()
> functions select the right DMA mapping operations - either the PCI DMA
> mapping operations or those from lib/dma-virt.c. My question to you is how we
> should organize struct ib_device such that we can get rid of the ib_dma_*()
> helper functions. How to make sure that the to_pci_dev() translation works
> correctly for the device structure that is embedded in struct ib_device?
> Should a pointer to struct pci_dev be embedded in struct device (as done in
> patch 1/2 in this series)

I already said no to this, why do you think that it is still ok?

> or should the struct device in ib_device be changed
> into a struct pci_dev

Ick, no.

> and should the pci_dev information from /sys/devices/pci*/*/* be
> duplicated into the pci_dev information in struct ib_device
> (/sys/devices/pci*/*/*/infiniband/*)?

I don't think you really thought that one through :)

> For the latter approach, would
> there be a risk that the duplicated information becomes inconsistent?

No, it just wouldn't work :)

Why not just save off a pointer to your pci_dev in your ib_device
structure?  That way you know what the type is, and you have access to
everything you need.

But hey, I know nothing about IB and I really want to keep it that way.
You do what you want to, as long as you don't abuse the driver model,
like your patch 1/2 did.  Remember, not all the world is IB.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
