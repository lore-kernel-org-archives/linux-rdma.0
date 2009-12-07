From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Date: Mon, 7 Dec 2009 09:17:14 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4__42865.638229023$1260202675$gmane$org@azsmsx501.amr.corp.intel.com>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0912061015540.20858-QfmoRoYWmW9knbxzx/v8hQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock@gmail.>
List-Id: linux-rdma@vger.kernel.org

Thanks for pointing out the bug.  

> 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
>-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
>+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
>+				    sizeof(*mmio_regs));
> 	if (mmio_regs == NULL) {
> 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
> 		ret = -EIO;

mmio_regs is initialized to NULL at the top of the function so *mmio_regs wouldn't be
a good idea.  Instead of sizeof(*mmio_regs) use pci_resource_len(pcidev, BAR_0).  If
you can recreate the patch with this change I will ack it.

Thanks,


Chien


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
