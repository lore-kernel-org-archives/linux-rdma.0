From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 03/11] staging/rdma/hfi1: Enable WFR PCIe extended tags from the driver
Date: Fri,  6 Nov 2015 20:06:58 -0500
Message-ID: <1446858426-30509-4-git-send-email-jubin.john@intel.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446858426-30509-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some BIOS implementations turn off extended tags in DevCtl (a RW
field) even though it was originally set and is advertised in DevCap
Fix is to set it in the driver

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/pcie.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index a956044..430e95a 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -475,8 +475,18 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 {
 	struct pci_dev *parent;
 	u16 rc_mpss, rc_mps, ep_mpss, ep_mps;
-	u16 rc_mrrs, ep_mrrs, max_mrrs;
+	u16 rc_mrrs, ep_mrrs, max_mrrs, ectl;
 
+	/*
+	 * Turn on extended tags in DevCtl in case the BIOS has turned it off
+	 * to improve WFR SDMA bandwidth
+	 */
+	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &ectl);
+	if (!(ectl & PCI_EXP_DEVCTL_EXT_TAG)) {
+		dd_dev_info(dd, "Enabling PCIe extended tags\n");
+		ectl |= PCI_EXP_DEVCTL_EXT_TAG;
+		pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL, ectl);
+	}
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
 	if (!pci_is_root_bus(parent->bus)) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
