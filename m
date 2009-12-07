From: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Date: Mon, 7 Dec 2009 20:57:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912072056160.1202@ask.diku.dk>
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

From: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>

The size argument to ioremap_nocache should be the size of desired
information, not the pointer to it.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression *x;
@@

x =
 <+...
*sizeof(x)
...+>// </smpl>

Signed-off-by: Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>

---
 drivers/infiniband/hw/nes/nes.c     |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index cbde0cf..95db98f 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -521,7 +521,8 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 	spin_lock_init(&nesdev->indexed_regs_lock);
 
 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
+				    pci_resource_len(pcidev, BAR_0));
 	if (mmio_regs == NULL) {
 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
 		ret = -EIO;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
