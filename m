From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/28] IB/hfi1: Add static PCIe Gen3 CTLE tuning
Date: Mon, 25 Jul 2016 13:39:21 -0700
Message-ID: <20160725203919.4800.75949.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Enhance the PCIe Gen3 recipe to support static CTLE tuning,
and add a switch to choose between static and dynamic
approaches.  Make discrete chips default to static CTLE
tuning.

Reviewed-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c |   68 +++++++++++++++++++++++++++++++++++--
 1 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 0bac21e..89c68da 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -679,6 +679,10 @@ static uint pcie_pset = UNSET_PSET;
 module_param(pcie_pset, uint, S_IRUGO);
 MODULE_PARM_DESC(pcie_pset, "PCIe Eq Pset value to use, range is 0-10");
 
+static uint pcie_ctle = 1; /* discrete on, integrated off */
+module_param(pcie_ctle, uint, S_IRUGO);
+MODULE_PARM_DESC(pcie_ctle, "PCIe static CTLE mode, bit 0 - discrete on/off, bit 1 - integrated on/off");
+
 /* equalization columns */
 #define PREC 0
 #define ATTN 1
@@ -716,6 +720,36 @@ static const u8 integrated_preliminary_eq[11][3] = {
 	{  0x00,  0x1e,  0x0a },	/* p10 */
 };
 
+static const u8 discrete_ctle_tunings[11][4] = {
+	/* DC     LF     HF     BW */
+	{  0x48,  0x0b,  0x04,  0x04 },	/* p0 */
+	{  0x60,  0x05,  0x0f,  0x0a },	/* p1 */
+	{  0x50,  0x09,  0x06,  0x06 },	/* p2 */
+	{  0x68,  0x05,  0x0f,  0x0a },	/* p3 */
+	{  0x80,  0x05,  0x0f,  0x0a },	/* p4 */
+	{  0x70,  0x05,  0x0f,  0x0a },	/* p5 */
+	{  0x68,  0x05,  0x0f,  0x0a },	/* p6 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p7 */
+	{  0x48,  0x09,  0x06,  0x06 },	/* p8 */
+	{  0x60,  0x05,  0x0f,  0x0a },	/* p9 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p10 */
+};
+
+static const u8 integrated_ctle_tunings[11][4] = {
+	/* DC     LF     HF     BW */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p0 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p1 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p2 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p3 */
+	{  0x58,  0x0a,  0x05,  0x05 },	/* p4 */
+	{  0x48,  0x0a,  0x05,  0x05 },	/* p5 */
+	{  0x40,  0x0a,  0x05,  0x05 },	/* p6 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p7 */
+	{  0x38,  0x0f,  0x00,  0x00 },	/* p8 */
+	{  0x38,  0x09,  0x06,  0x06 },	/* p9 */
+	{  0x38,  0x0e,  0x01,  0x01 },	/* p10 */
+};
+
 /* helper to format the value to write to hardware */
 #define eq_value(pre, curr, post) \
 	((((u32)(pre)) << \
@@ -951,11 +985,14 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	u32 status, err;
 	int ret;
 	int do_retry, retry_count = 0;
+	int intnum = 0;
 	uint default_pset;
 	u16 target_vector, target_speed;
 	u16 lnkctl2, vendor;
 	u8 div;
 	const u8 (*eq)[3];
+	const u8 (*ctle_tunings)[4];
+	uint static_ctle_mode;
 	int return_error = 0;
 
 	/* PCIe Gen3 is for the ASIC only */
@@ -1089,6 +1126,9 @@ retry:
 		div = 3;
 		eq = discrete_preliminary_eq;
 		default_pset = DEFAULT_DISCRETE_PSET;
+		ctle_tunings = discrete_ctle_tunings;
+		/* bit 0 - discrete on/off */
+		static_ctle_mode = pcie_ctle & 0x1;
 	} else {
 		/* 400mV, FS=29, LF = 9 */
 		fs = 29;
@@ -1096,6 +1136,9 @@ retry:
 		div = 1;
 		eq = integrated_preliminary_eq;
 		default_pset = DEFAULT_MCP_PSET;
+		ctle_tunings = integrated_ctle_tunings;
+		/* bit 1 - integrated on/off */
+		static_ctle_mode = (pcie_ctle >> 1) & 0x1;
 	}
 	pci_write_config_dword(dd->pcidev, PCIE_CFG_REG_PL101,
 			       (fs <<
@@ -1135,16 +1178,33 @@ retry:
 	 * step 5c: Program gasket interrupts
 	 */
 	/* set the Rx Bit Rate to REFCLK ratio */
-	write_gasket_interrupt(dd, 0, 0x0006, 0x0050);
+	write_gasket_interrupt(dd, intnum++, 0x0006, 0x0050);
 	/* disable pCal for PCIe Gen3 RX equalization */
-	write_gasket_interrupt(dd, 1, 0x0026, 0x5b01);
+	/* select adaptive or static CTLE */
+	write_gasket_interrupt(dd, intnum++, 0x0026,
+			       0x5b01 | (static_ctle_mode << 3));
 	/*
 	 * Enable iCal for PCIe Gen3 RX equalization, and set which
 	 * evaluation of RX_EQ_EVAL will launch the iCal procedure.
 	 */
-	write_gasket_interrupt(dd, 2, 0x0026, 0x5202);
+	write_gasket_interrupt(dd, intnum++, 0x0026, 0x5202);
+
+	if (static_ctle_mode) {
+		/* apply static CTLE tunings */
+		u8 pcie_dc, pcie_lf, pcie_hf, pcie_bw;
+
+		pcie_dc = ctle_tunings[pcie_pset][0];
+		pcie_lf = ctle_tunings[pcie_pset][1];
+		pcie_hf = ctle_tunings[pcie_pset][2];
+		pcie_bw = ctle_tunings[pcie_pset][3];
+		write_gasket_interrupt(dd, intnum++, 0x0026, 0x0200 | pcie_dc);
+		write_gasket_interrupt(dd, intnum++, 0x0026, 0x0100 | pcie_lf);
+		write_gasket_interrupt(dd, intnum++, 0x0026, 0x0000 | pcie_hf);
+		write_gasket_interrupt(dd, intnum++, 0x0026, 0x5500 | pcie_bw);
+	}
+
 	/* terminate list */
-	write_gasket_interrupt(dd, 3, 0x0000, 0x0000);
+	write_gasket_interrupt(dd, intnum++, 0x0000, 0x0000);
 
 	/*
 	 * step 5d: program XMT margin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
