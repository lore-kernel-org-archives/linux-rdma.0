From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] staging/rdma/hfi1: Avoid using upstream component if it
 is not accessible
Date: Fri, 26 Feb 2016 13:33:18 -0800
Message-ID: <20160226213318.16535.45900.stgit@scvm10.sc.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226213022.16535.8149.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the hfi1 device is assigned to a VM (eg KVM), the hfi1 driver has
no access to the upstream component and therefore cannot use it to perform
some operations, such as secondary bus reset. As a result, the hfi1 driver
cannot perform the pcie Gen3 transition. Instead, those operation should
be done in the host environment, preferrably done during the Option ROM
initialization. Similarly, the hfi1 driver cannot support ASPM and tune
the pcie capability under this circumstance.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/aspm.h |   19 +++++++++++++++++--
 drivers/staging/rdma/hfi1/pcie.c |   22 +++++++++++++++++++---
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/aspm.h b/drivers/staging/rdma/hfi1/aspm.h
index 3aac802..0d58fe3 100644
--- a/drivers/staging/rdma/hfi1/aspm.h
+++ b/drivers/staging/rdma/hfi1/aspm.h
@@ -72,6 +72,13 @@ static inline bool aspm_hw_l1_supported(struct hfi1_devdata *dd)
 	struct pci_dev *parent = dd->pcidev->bus->self;
 	u32 up, dn;
 
+	/*
+	 * If the driver does not have access to the upstream component,
+	 * it cannot support ASPM L1 at all.
+	 */
+	if (!parent)
+		return false;
+
 	pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &dn);
 	dn = ASPM_L1_SUPPORTED(dn);
 
@@ -98,6 +105,13 @@ static inline void aspm_hw_enable_l1(struct hfi1_devdata *dd)
 {
 	struct pci_dev *parent = dd->pcidev->bus->self;
 
+	/*
+	 * If the driver does not have access to the upstream component,
+	 * it cannot support ASPM L1 at all.
+	 */
+	if (!parent)
+		return;
+
 	/* Enable ASPM L1 first in upstream component and then downstream */
 	pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
 					   PCI_EXP_LNKCTL_ASPMC,
@@ -114,8 +128,9 @@ static inline void aspm_hw_disable_l1(struct hfi1_devdata *dd)
 	/* Disable ASPM L1 first in downstream component and then upstream */
 	pcie_capability_clear_and_set_word(dd->pcidev, PCI_EXP_LNKCTL,
 					   PCI_EXP_LNKCTL_ASPMC, 0x0);
-	pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
-					   PCI_EXP_LNKCTL_ASPMC, 0x0);
+	if (parent)
+		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
+						   PCI_EXP_LNKCTL_ASPMC, 0x0);
 }
 
 static inline void aspm_enable(struct hfi1_devdata *dd)
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 7855962..1adfa8b 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -362,6 +362,7 @@ static void update_lbus_info(struct hfi1_devdata *dd)
 int pcie_speeds(struct hfi1_devdata *dd)
 {
 	u32 linkcap;
+	struct pci_dev *parent = dd->pcidev->bus->self;
 
 	if (!pci_is_pcie(dd->pcidev)) {
 		dd_dev_err(dd, "Can't find PCI Express capability!\n");
@@ -382,7 +383,7 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	/*
 	 * bus->max_bus_speed is set from the bridge's linkcap Max Link Speed
 	 */
-	if (dd->pcidev->bus->max_bus_speed != PCIE_SPEED_8_0GT) {
+	if (parent && dd->pcidev->bus->max_bus_speed != PCIE_SPEED_8_0GT) {
 		dd_dev_info(dd, "Parent PCIe bridge does not support Gen3\n");
 		dd->link_gen3_capable = 0;
 	}
@@ -471,6 +472,12 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 	}
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
+	/*
+	 * The driver cannot perform the tuning if it does not have
+	 * access to the upstream component.
+	 */
+	if (!parent)
+		return;
 	if (!pci_is_root_bus(parent->bus)) {
 		dd_dev_info(dd, "Parent not root\n");
 		return;
@@ -939,7 +946,7 @@ static void write_xmt_margin(struct hfi1_devdata *dd, const char *fname)
  */
 int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 {
-	struct pci_dev *parent;
+	struct pci_dev *parent = dd->pcidev->bus->self;
 	u64 fw_ctrl;
 	u64 reg, therm;
 	u32 reg32, fs, lf;
@@ -982,6 +989,16 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	}
 
 	/*
+	 * The driver cannot do the transition if it has no access to the
+	 * upstream component
+	 */
+	if (!parent) {
+		dd_dev_info(dd, "%s: No upstream, Can't do gen3 transition\n",
+			    __func__);
+		return 0;
+	}
+
+	/*
 	 * Do the Gen3 transition.  Steps are those of the PCIe Gen3
 	 * recipe.
 	 */
@@ -1157,7 +1174,6 @@ retry:
 	 * that it is Gen3 capable earlier.
 	 */
 	dd_dev_info(dd, "%s: setting parent target link speed\n", __func__);
-	parent = dd->pcidev->bus->self;
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL2, &lnkctl2);
 	dd_dev_info(dd, "%s: ..old link control2: 0x%x\n", __func__,
 		    (u32)lnkctl2);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
