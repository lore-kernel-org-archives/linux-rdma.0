From: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Better handling of PCI BAR assignments
Date: Mon, 8 May 2017 14:45:48 -0500
Message-ID: <20170508194548.GA9962@oc1783850105.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Ominpath adapter driver fails to load the ppc64le platform due to invalid PCI setup.
I am recommending this patch to pcie.c which better aligns configuration with linux PCI subsystem functions.  It also fixes the issue.
Hopefully, this motivates a change.  I am new to the group, so if I am short content, I may need more direction than your experienced members.

--- a/opa-hfi1/pcie.c	2017-05-05 16:59:29.875421435 -0500
+++ b/opa-hfi1/pcie.c	2017-05-05 17:00:16.745169904 -0500
@@ -208,8 +208,10 @@
 	/*
 	 * Save BARs and command to rewrite after device reset.
 	 */
-	dd->pcibar0 = addr;
-	dd->pcibar1 = addr >> 32;
+         pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
+         pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
+/*      dd->pcibar0 = addr;
+ *      dd->pcibar1 = addr >> 32;*/
 	pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
 	pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &dd->pcie_devctl);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
