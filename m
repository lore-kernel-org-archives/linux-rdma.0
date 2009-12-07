From: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Date: Mon, 7 Dec 2009 17:42:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912071741450.15109@ask.diku.dk>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F-uLM7Qlg6Mbekrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 7 Dec 2009, Tung, Chien Tin wrote:

> >> > 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
> >> >-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
> >> >+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
> >> >+				    sizeof(*mmio_regs));
> >> > 	if (mmio_regs == NULL) {
> >> > 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
> >> > 		ret = -EIO;
> >>
> >> mmio_regs is initialized to NULL at the top of the function so
> >> *mmio_regs wouldn't be a good idea.  Instead of sizeof(*mmio_regs) use
> >> pci_resource_len(pcidev, BAR_0).  If you can recreate the patch with
> >> this change I will ack it.
> >
> >When you say that it isn't a good idea, do you mean that the result is
> >wrong, or that it looks odd?  I didn't think sizeof looked at the value,
> >but only at the type?
> 
> 
> I misspoke on the problem.  Mmio_regs is declared as a void pointer:
> 
>         void __iomem *mmio_regs = NULL;
> 
> Thus pci_resource_len(pcidev, BAR_0) is the correct fix.

OK, thanks for the clarification.  I will make another patch later today.

julia
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
