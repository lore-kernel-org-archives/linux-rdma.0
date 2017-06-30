From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/3] IB/hfi1: Check return values from PCI config
 API calls
Date: Fri, 30 Jun 2017 13:14:40 -0700
Message-ID: <20170630201439.5213.38102.stgit@scvm10.sc.intel.com>
References: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170630201236.5213.72919.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Ensure that return values from kernel PCI config access
API calls in HFI driver are checked and react properly if
they are not expected (i.e. not successful).

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   22 +++
 drivers/infiniband/hw/hfi1/hfi.h  |    2 
 drivers/infiniband/hw/hfi1/pcie.c |  238 ++++++++++++++++++++++++++++++-------
 3 files changed, 215 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 937350d..efc8481 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13846,9 +13846,10 @@ static void init_sc2vl_tables(struct hfi1_devdata *dd)
  * a reset following the (possible) FLR in this routine.
  *
  */
-static void init_chip(struct hfi1_devdata *dd)
+static int init_chip(struct hfi1_devdata *dd)
 {
 	int i;
+	int ret = 0;
 
 	/*
 	 * Put the HFI CSRs in a known state.
@@ -13896,12 +13897,22 @@ static void init_chip(struct hfi1_devdata *dd)
 		pcie_flr(dd->pcidev);
 
 		/* restore command and BARs */
-		restore_pci_variables(dd);
+		ret = restore_pci_variables(dd);
+		if (ret) {
+			dd_dev_err(dd, "%s: Could not restore PCI variables\n",
+				   __func__);
+			return ret;
+		}
 
 		if (is_ax(dd)) {
 			dd_dev_info(dd, "Resetting CSRs with FLR\n");
 			pcie_flr(dd->pcidev);
-			restore_pci_variables(dd);
+			ret = restore_pci_variables(dd);
+			if (ret) {
+				dd_dev_err(dd, "%s: Could not restore PCI variables\n",
+					   __func__);
+				return ret;
+			}
 		}
 	} else {
 		dd_dev_info(dd, "Resetting CSRs with writes\n");
@@ -13929,6 +13940,7 @@ static void init_chip(struct hfi1_devdata *dd)
 	write_csr(dd, ASIC_QSFP1_OUT, 0x1f);
 	write_csr(dd, ASIC_QSFP2_OUT, 0x1f);
 	init_chip_resources(dd);
+	return ret;
 }
 
 static void init_early_variables(struct hfi1_devdata *dd)
@@ -14914,7 +14926,9 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		goto bail_cleanup;
 
 	/* obtain chip sizes, reset chip CSRs */
-	init_chip(dd);
+	ret = init_chip(dd);
+	if (ret)
+		goto bail_cleanup;
 
 	/* read in the PCIe link speed information */
 	ret = pcie_speeds(dd);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1a33a50..62f843d 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1854,7 +1854,7 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 void hfi1_pcie_ddcleanup(struct hfi1_devdata *);
 int pcie_speeds(struct hfi1_devdata *dd);
 int request_msix(struct hfi1_devdata *dd, u32 msireq);
-void restore_pci_variables(struct hfi1_devdata *dd);
+int restore_pci_variables(struct hfi1_devdata *dd);
 int do_pcie_gen3_transition(struct hfi1_devdata *dd);
 int parse_platform_config(struct hfi1_devdata *dd);
 int get_platform_config_field(struct hfi1_devdata *dd,
diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index f01841b..676efdf 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -68,7 +68,7 @@
 /*
  * Code to adjust PCIe capabilities.
  */
-static void tune_pcie_caps(struct hfi1_devdata *);
+static int tune_pcie_caps(struct hfi1_devdata *);
 
 /*
  * Do all the common PCIe setup and initialization.
@@ -161,6 +161,7 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev)
 {
 	unsigned long len;
 	resource_size_t addr;
+	int ret = 0;
 
 	dd->pcidev = pdev;
 	pci_set_drvdata(pdev, dd);
@@ -207,19 +208,56 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev)
 	/*
 	 * Save BARs and command to rewrite after device reset.
 	 */
-	pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
-	pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
-	pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
-	pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &dd->pcie_devctl);
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL, &dd->pcie_lnkctl);
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL2,
-				  &dd->pcie_devctl2);
-	pci_read_config_dword(dd->pcidev, PCI_CFG_MSIX0, &dd->pci_msix0);
-	pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1, &dd->pci_lnkctl3);
-	pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2, &dd->pci_tph2);
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, &dd->pcibar0);
+	if (ret)
+		goto read_error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, &dd->pcibar1);
+	if (ret)
+		goto read_error;
+	
+	ret = pci_read_config_dword(dd->pcidev, PCI_ROM_ADDRESS, &dd->pci_rom);
+	if (ret)
+		goto read_error;
+
+	ret = pci_read_config_word(dd->pcidev, PCI_COMMAND, &dd->pci_command);
+	if (ret)
+		goto read_error;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL,
+					&dd->pcie_devctl);
+	if (ret)
+		goto read_error;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL,
+					&dd->pcie_lnkctl);
+	if (ret)
+		goto read_error;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL2,
+					&dd->pcie_devctl2);
+	if (ret)
+		goto read_error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCI_CFG_MSIX0, &dd->pci_msix0);
+	if (ret)
+		goto read_error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
+				    &dd->pci_lnkctl3);
+	if (ret)
+		goto read_error;
+
+	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2, &dd->pci_tph2);
+	if (ret)
+		goto read_error;
 
 	return 0;
+
+read_error:
+	dd_dev_err(dd, "Unable to read from PCI config\n");
+	return ret;
 }
 
 /*
@@ -270,8 +308,14 @@ static u32 extract_width(u16 linkstat)
 static void update_lbus_info(struct hfi1_devdata *dd)
 {
 	u16 linkstat;
+	int ret;
+
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKSTA, &linkstat);
+	if (ret) {
+		dd_dev_err(dd, "Unable to read from PCI config\n");
+		return;
+	}
 
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKSTA, &linkstat);
 	dd->lbus_width = extract_width(linkstat);
 	dd->lbus_speed = extract_speed(linkstat);
 	snprintf(dd->lbus_info, sizeof(dd->lbus_info),
@@ -286,6 +330,7 @@ int pcie_speeds(struct hfi1_devdata *dd)
 {
 	u32 linkcap;
 	struct pci_dev *parent = dd->pcidev->bus->self;
+	int ret;
 
 	if (!pci_is_pcie(dd->pcidev)) {
 		dd_dev_err(dd, "Can't find PCI Express capability!\n");
@@ -295,7 +340,12 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	/* find if our max speed is Gen3 and parent supports Gen3 speeds */
 	dd->link_gen3_capable = 1;
 
-	pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &linkcap);
+	ret = pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &linkcap);
+	if (ret) {
+		dd_dev_err(dd, "Unable to read from PCI config\n");
+		return ret;
+	}
+
 	if ((linkcap & PCI_EXP_LNKCAP_SLS) != GEN3_SPEED_VECTOR) {
 		dd_dev_info(dd,
 			    "This HFI is not Gen3 capable, max speed 0x%x, need 0x3\n",
@@ -327,7 +377,7 @@ int pcie_speeds(struct hfi1_devdata *dd)
  */
 int request_msix(struct hfi1_devdata *dd, u32 msireq)
 {
-	int nvec;
+	int nvec, ret;
 
 	nvec = pci_alloc_irq_vectors(dd->pcidev, 1, msireq,
 				     PCI_IRQ_MSIX | PCI_IRQ_LEGACY);
@@ -336,7 +386,12 @@ int request_msix(struct hfi1_devdata *dd, u32 msireq)
 		return nvec;
 	}
 
-	tune_pcie_caps(dd);
+	ret = tune_pcie_caps(dd);
+	if (ret) {
+		dd_dev_err(dd, "tune_pcie_caps() failed: %d\n", ret);
+		pci_free_irq_vectors(dd->pcidev);
+		return ret;
+	}
 
 	/* check for legacy IRQ */
 	if (nvec == 1 && !dd->pcidev->msix_enabled)
@@ -346,19 +401,61 @@ int request_msix(struct hfi1_devdata *dd, u32 msireq)
 }
 
 /* restore command and BARs after a reset has wiped them out */
-void restore_pci_variables(struct hfi1_devdata *dd)
+int restore_pci_variables(struct hfi1_devdata *dd)
 {
-	pci_write_config_word(dd->pcidev, PCI_COMMAND, dd->pci_command);
-	pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, dd->pcibar0);
-	pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, dd->pcibar1);
-	pci_write_config_dword(dd->pcidev, PCI_ROM_ADDRESS, dd->pci_rom);
-	pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL, dd->pcie_devctl);
-	pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL, dd->pcie_lnkctl);
-	pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL2,
-				   dd->pcie_devctl2);
-	pci_write_config_dword(dd->pcidev, PCI_CFG_MSIX0, dd->pci_msix0);
-	pci_write_config_dword(dd->pcidev, PCIE_CFG_SPCIE1, dd->pci_lnkctl3);
-	pci_write_config_dword(dd->pcidev, PCIE_CFG_TPH2, dd->pci_tph2);
+	int ret = 0;
+
+	ret = pci_write_config_word(dd->pcidev, PCI_COMMAND, dd->pci_command);
+	if (ret)
+		goto error;
+
+	ret = pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0,
+				     dd->pcibar0);
+	if (ret)
+		goto error;
+
+	ret = pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1,
+				     dd->pcibar1);
+	if (ret)
+		goto error;
+
+	ret = pci_write_config_dword(dd->pcidev, PCI_ROM_ADDRESS, dd->pci_rom);
+	if (ret)
+		goto error;
+
+	ret = pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL,
+					 dd->pcie_devctl);
+	if (ret)
+		goto error;
+
+	ret = pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL,
+					 dd->pcie_lnkctl);
+	if (ret)
+		goto error;
+
+	ret = pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL2,
+					 dd->pcie_devctl2);
+	if (ret)
+		goto error;
+
+	ret = pci_write_config_dword(dd->pcidev, PCI_CFG_MSIX0, dd->pci_msix0);
+	if (ret)
+		goto error;
+
+	ret = pci_write_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
+				     dd->pci_lnkctl3);
+	if (ret)
+		goto error;
+
+	ret = pci_write_config_dword(dd->pcidev, PCIE_CFG_TPH2, dd->pci_tph2);
+	if (ret)
+		goto error;
+
+	return 0;
+
+error:
+	dd_dev_err(dd, "Unable to write to PCI config\n");
+	return ret;
 }
 
 /*
@@ -373,21 +470,33 @@ void restore_pci_variables(struct hfi1_devdata *dd)
 module_param_named(aspm, aspm_mode, uint, S_IRUGO);
 MODULE_PARM_DESC(aspm, "PCIe ASPM: 0: disable, 1: enable, 2: dynamic");
 
-static void tune_pcie_caps(struct hfi1_devdata *dd)
+static int tune_pcie_caps(struct hfi1_devdata *dd)
 {
 	struct pci_dev *parent;
 	u16 rc_mpss, rc_mps, ep_mpss, ep_mps;
 	u16 rc_mrrs, ep_mrrs, max_mrrs, ectl;
+	int ret;
 
 	/*
 	 * Turn on extended tags in DevCtl in case the BIOS has turned it off
 	 * to improve WFR SDMA bandwidth
 	 */
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &ectl);
+	ret = pcie_capability_read_word(dd->pcidev,
+					PCI_EXP_DEVCTL, &ectl);
+	if (ret) {
+		dd_dev_err(dd, "Unable to read from PCI config\n");
+		return ret;
+	}
+
 	if (!(ectl & PCI_EXP_DEVCTL_EXT_TAG)) {
 		dd_dev_info(dd, "Enabling PCIe extended tags\n");
 		ectl |= PCI_EXP_DEVCTL_EXT_TAG;
-		pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL, ectl);
+		ret = pcie_capability_write_word(dd->pcidev,
+						 PCI_EXP_DEVCTL, ectl);
+		if (ret) {
+			dd_dev_err(dd, "Unable to write to PCI config\n");
+			return ret;
+		}
 	}
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
@@ -396,14 +505,14 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 	 * access to the upstream component.
 	 */
 	if (!parent)
-		return;
+		return -EINVAL;
 	if (!pci_is_root_bus(parent->bus)) {
 		dd_dev_info(dd, "Parent not root\n");
-		return;
+		return -EINVAL;
 	}
 
 	if (!pci_is_pcie(parent) || !pci_is_pcie(dd->pcidev))
-		return;
+		return -EINVAL;
 	rc_mpss = parent->pcie_mpss;
 	rc_mps = ffs(pcie_get_mps(parent)) - 8;
 	/* Find out supported and configured values for endpoint (us) */
@@ -449,6 +558,8 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 		ep_mrrs = max_mrrs;
 		pcie_set_readrq(dd->pcidev, ep_mrrs);
 	}
+
+	return 0;
 }
 
 /* End of PCIe capability tuning */
@@ -680,6 +791,7 @@ static int load_eq_table(struct hfi1_devdata *dd, const u8 eq[11][3], u8 fs,
 	u32 violation;
 	u32 i;
 	u8 c_minus1, c0, c_plus1;
+	int ret;
 
 	for (i = 0; i < 11; i++) {
 		/* set index */
@@ -691,8 +803,14 @@ static int load_eq_table(struct hfi1_devdata *dd, const u8 eq[11][3], u8 fs,
 		pci_write_config_dword(pdev, PCIE_CFG_REG_PL102,
 				       eq_value(c_minus1, c0, c_plus1));
 		/* check if these coefficients violate EQ rules */
-		pci_read_config_dword(dd->pcidev, PCIE_CFG_REG_PL105,
-				      &violation);
+		ret = pci_read_config_dword(dd->pcidev,
+					    PCIE_CFG_REG_PL105, &violation);
+		if (ret) {
+			dd_dev_err(dd, "Unable to read from PCI config\n");
+			hit_error = 1;
+			break;
+		}
+
 		if (violation
 		    & PCIE_CFG_REG_PL105_GEN3_EQ_VIOLATE_COEF_RULES_SMASK){
 			if (hit_error == 0) {
@@ -1146,7 +1264,13 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	 * that it is Gen3 capable earlier.
 	 */
 	dd_dev_info(dd, "%s: setting parent target link speed\n", __func__);
-	pcie_capability_read_word(parent, PCI_EXP_LNKCTL2, &lnkctl2);
+	ret = pcie_capability_read_word(parent, PCI_EXP_LNKCTL2, &lnkctl2);
+	if (ret) {
+		dd_dev_err(dd, "Unable to read from PCI config\n");
+		return_error = 1;
+		goto done;
+	}
+
 	dd_dev_info(dd, "%s: ..old link control2: 0x%x\n", __func__,
 		    (u32)lnkctl2);
 	/* only write to parent if target is not as high as ours */
@@ -1155,20 +1279,37 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 		lnkctl2 |= target_vector;
 		dd_dev_info(dd, "%s: ..new link control2: 0x%x\n", __func__,
 			    (u32)lnkctl2);
-		pcie_capability_write_word(parent, PCI_EXP_LNKCTL2, lnkctl2);
+		ret = pcie_capability_write_word(parent,
+						 PCI_EXP_LNKCTL2, lnkctl2);
+		if (ret) {
+			dd_dev_err(dd, "Unable to write to PCI config\n");
+			return_error = 1;
+			goto done;
+		}
 	} else {
 		dd_dev_info(dd, "%s: ..target speed is OK\n", __func__);
 	}
 
 	dd_dev_info(dd, "%s: setting target link speed\n", __func__);
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL2, &lnkctl2);
+	ret = pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL2, &lnkctl2);
+	if (ret) {
+		dd_dev_err(dd, "Unable to read from PCI config\n");
+		return_error = 1;
+		goto done;
+	}
+
 	dd_dev_info(dd, "%s: ..old link control2: 0x%x\n", __func__,
 		    (u32)lnkctl2);
 	lnkctl2 &= ~LNKCTL2_TARGET_LINK_SPEED_MASK;
 	lnkctl2 |= target_vector;
 	dd_dev_info(dd, "%s: ..new link control2: 0x%x\n", __func__,
 		    (u32)lnkctl2);
-	pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL2, lnkctl2);
+	ret = pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL2, lnkctl2);
+	if (ret) {
+		dd_dev_err(dd, "Unable to write to PCI config\n");
+		return_error = 1;
+		goto done;
+	}
 
 	/* step 5h: arm gasket logic */
 	/* hold DC in reset across the SBR */
@@ -1218,7 +1359,14 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 
 	/* restore PCI space registers we know were reset */
 	dd_dev_info(dd, "%s: calling restore_pci_variables\n", __func__);
-	restore_pci_variables(dd);
+	ret = restore_pci_variables(dd);
+	if (ret) {
+		dd_dev_err(dd, "%s: Could not restore PCI variables\n",
+			   __func__);
+		return_error = 1;
+		goto done;
+	}
+
 	/* restore firmware control */
 	write_csr(dd, MISC_CFG_FW_CTRL, fw_ctrl);
 
@@ -1248,7 +1396,13 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	setextled(dd, 0);
 
 	/* check for any per-lane errors */
-	pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE2, &reg32);
+	ret = pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE2, &reg32);
+	if (ret) {
+		dd_dev_err(dd, "Unable to read from PCI config\n");
+		return_error = 1;
+		goto done;
+	}
+
 	dd_dev_info(dd, "%s: per-lane errors: 0x%x\n", __func__, reg32);
 
 	/* extract status, look for our HFI */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
