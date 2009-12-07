From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Date: Mon, 7 Dec 2009 13:09:32 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3CE373A4@azsmsx501.amr.corp.intel.com>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912072056160.1202@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934502AbZLGUJc@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0912072056160.1202@ask.diku.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, Roland Dreier <rolandd@cisco.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>From: Julia Lawall <julia@diku.dk>
>
>The size argument to ioremap_nocache should be the size of desired
>information, not the pointer to it.
>
>The semantic match that finds this problem is as follows:
>(http://coccinelle.lip6.fr/)
>
>// <smpl>
>@expression@
>expression *x;
>@@
>
>x =
> <+...
>*sizeof(x)
>...+>// </smpl>
>
>Signed-off-by: Julia Lawall <julia@diku.dk>
>
>---
> drivers/infiniband/hw/nes/nes.c     |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
>index cbde0cf..95db98f 100644
>--- a/drivers/infiniband/hw/nes/nes.c
>+++ b/drivers/infiniband/hw/nes/nes.c
>@@ -521,7 +521,8 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
> 	spin_lock_init(&nesdev->indexed_regs_lock);
>
> 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
>-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
>+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
>+				    pci_resource_len(pcidev, BAR_0));
> 	if (mmio_regs == NULL) {
> 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
> 		ret = -EIO;

Acked-by: Chien Tung <chien.tin.tung@intel.com>
