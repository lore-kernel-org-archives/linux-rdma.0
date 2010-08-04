From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fix misindented code
Date: Wed, 04 Aug 2010 14:33:31 -0700
Message-ID: <aday6cm5ahg.fsf@roland-alpha.cisco.com>
References: <adabp9i6p63.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabp9i6p63.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org> (Roland Dreier's message
	of "Wed, 04 Aug 2010 14:31:00 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In nes_probe(), a bit of code is indented one tab stop too far.  Fix this.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index d53480e..0c9f0aa 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -661,23 +661,21 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 	nes_notifiers_registered++;
 
 	/* Initialize network devices */
-		if ((netdev = nes_netdev_init(nesdev, mmio_regs)) == NULL) {
-			goto bail7;
-		}
-
-		/* Register network device */
-		ret = register_netdev(netdev);
-		if (ret) {
-			printk(KERN_ERR PFX "Unable to register netdev, ret = %d\n", ret);
-			nes_netdev_destroy(netdev);
-			goto bail7;
-		}
+	if ((netdev = nes_netdev_init(nesdev, mmio_regs)) == NULL)
+		goto bail7;
 
-		nes_print_macaddr(netdev);
+	/* Register network device */
+	ret = register_netdev(netdev);
+	if (ret) {
+		printk(KERN_ERR PFX "Unable to register netdev, ret = %d\n", ret);
+		nes_netdev_destroy(netdev);
+		goto bail7;
+	}
 
-		nesdev->netdev_count++;
-		nesdev->nesadapter->netdev_count++;
+	nes_print_macaddr(netdev);
 
+	nesdev->netdev_count++;
+	nesdev->nesadapter->netdev_count++;
 
 	printk(KERN_ERR PFX "%s: NetEffect RNIC driver successfully loaded.\n",
 			pci_name(pcidev));
-- 
1.7.2


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
