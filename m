From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 6/6] infiniband/nes: Disable ASPM
Date: Fri, 11 Nov 2011 11:14:24 -0500
Message-ID: <1321028064-644-7-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321028064-644-1-git-send-email-mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Windows driver .inf disables ASPM on hpsa devices. Do the same.

Signed-off-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/nes/nes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 5965b3d..ea320f5 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -45,6 +45,7 @@
 #include <linux/if_arp.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
+#include <linux/pci-aspm.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -463,6 +464,9 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 	printk(KERN_INFO PFX "NetEffect RNIC driver v%s loading. (%s)\n",
 			DRV_VERSION, pci_name(pcidev));
 
+	pci_disable_link_state(pcidev, PCIE_LINK_STATE_L0S |
+			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
+
 	ret = pci_enable_device(pcidev);
 	if (ret) {
 		printk(KERN_ERR PFX "Unable to enable PCI device. (%s)\n", pci_name(pcidev));
-- 
1.7.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
