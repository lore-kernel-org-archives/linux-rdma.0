From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
 embedded in struct pci_dev
Date: Wed, 08 Mar 2017 12:52:37 +1100
Message-ID: <1488937957.2870.164.camel@kernel.crashing.org>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
         <20170307003549.3872-2-bart.vanassche@sandisk.com>
         <20170307045236.GC3913@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307045236.GC3913-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-03-07 at 05:52 +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 06, 2017 at 04:35:48PM -0800, Bart Van Assche wrote:
> > The dma mapping operations of several architectures and also of
> > several I/O MMU implementations need to translate a struct
> > device pointer into a struct pci_dev pointer. This translation
> > is performed by to_pci_dev(). That macro assumes that struct
> > device is embedded in struct pci_dev. However, that is not the
> > case for the device structure in struct ib_device.
> 
> Then don't blindly cast it backwards!  Fix that up, an ib device should
> have access to the dma structures that the PCI device it depends on has.
> If not, you need to set that up properly in the IB core, don't mess with
> the driver core for this at all.
> 
> Somehow all other subsystems work just fine, don't instantly think that
> the driver core needs to bend to the will of the IB code, because you
> are somehow "special".  Hint, you aren't :)

Right, in his case, Bart, you can either pass the the struct device for
use for DMA to the ib devices, which is easy but a bit gross, or have
the ib core provide a set of dma_ops for the ib_device that are
"wrappers" calling back to the "parent" device.

Any struct device whose dma_ops haven't been setup by the architecture
core cannot be used for DMA as-is without such "reflector" dma_ops
provided by the creator of that struct device.

The architecture core only knows about some "directly" attached things
like PCI, some cases of platform devices etc... and has no way of
setting things up for subsystem specific thigns like ib_device.

Thus the subsystem must take care of it and provide its own dma_ops
that "reflect" the calls to the original parent device that was setup
by the architecture.

Cheers,
Ben.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
