From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 07/13] staging/rdma/hfi1: rework is_a0() and is_bx()
Date: Mon, 16 Nov 2015 21:59:29 -0500
Message-ID: <1447729175-28745-8-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current is_bx() will incorrectly match on other steppings.

is_a0() is removed in favor of is_ax().

Reviewed-by: Mark Debbage <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |   44 ++++++++++++++--------------------
 drivers/staging/rdma/hfi1/chip.h     |    1 -
 drivers/staging/rdma/hfi1/firmware.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h      |    4 +-
 drivers/staging/rdma/hfi1/init.c     |    2 +-
 drivers/staging/rdma/hfi1/pcie.c     |    4 +-
 6 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 7c58c7b..af59d23 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1871,13 +1871,6 @@ static struct cntr_entry port_cntrs[PORT_CNTR_LAST] = {
 
 /* ======================================================================== */
 
-/* return true if this is chip revision revision a0 */
-int is_a0(struct hfi1_devdata *dd)
-{
-	return ((dd->revision >> CCE_REVISION_CHIP_REV_MINOR_SHIFT)
-			& CCE_REVISION_CHIP_REV_MINOR_MASK) == 0;
-}
-
 /* return true if this is chip revision revision a */
 int is_ax(struct hfi1_devdata *dd)
 {
@@ -1893,7 +1886,7 @@ int is_bx(struct hfi1_devdata *dd)
 	u8 chip_rev_minor =
 		dd->revision >> CCE_REVISION_CHIP_REV_MINOR_SHIFT
 			& CCE_REVISION_CHIP_REV_MINOR_MASK;
-	return !!(chip_rev_minor & 0x10);
+	return (chip_rev_minor & 0xF0) == 0x10;
 }
 
 /*
@@ -2188,9 +2181,8 @@ static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	dd_dev_info(dd, "CCE Error: %s\n",
 		cce_err_status_string(buf, sizeof(buf), reg));
 
-	if ((reg & CCE_ERR_STATUS_CCE_CLI2_ASYNC_FIFO_PARITY_ERR_SMASK)
-			&& is_a0(dd)
-			&& (dd->icode != ICODE_FUNCTIONAL_SIMULATOR)) {
+	if ((reg & CCE_ERR_STATUS_CCE_CLI2_ASYNC_FIFO_PARITY_ERR_SMASK) &&
+	    is_ax(dd) && (dd->icode != ICODE_FUNCTIONAL_SIMULATOR)) {
 		/* this error requires a manual drop into SPC freeze mode */
 		/* then a fix up */
 		start_freeze_handling(dd->pport, FREEZE_SELF);
@@ -2250,7 +2242,7 @@ static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		 * Freeze mode recovery is disabled for the errors
 		 * in RXE_FREEZE_ABORT_MASK
 		 */
-		if (is_a0(dd) && (reg & RXE_FREEZE_ABORT_MASK))
+		if (is_ax(dd) && (reg & RXE_FREEZE_ABORT_MASK))
 			flags = FREEZE_ABORT;
 
 		start_freeze_handling(dd->pport, flags);
@@ -2353,7 +2345,7 @@ static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 
 	if (reg & ALL_TXE_EGRESS_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
-	if (is_a0(dd) && (reg &
+	if (is_ax(dd) && (reg &
 		    SEND_EGRESS_ERR_STATUS_TX_CREDIT_RETURN_VL_ERR_SMASK)
 		    && (dd->icode != ICODE_FUNCTIONAL_SIMULATOR))
 		start_freeze_handling(dd->pport, 0);
@@ -3048,7 +3040,7 @@ static void adjust_lcb_for_fpga_serdes(struct hfi1_devdata *dd)
 	/* else this is _p */
 
 	version = emulator_rev(dd);
-	if (!is_a0(dd))
+	if (!is_ax(dd))
 		version = 0x2d;	/* all B0 use 0x2d or higher settings */
 
 	if (version <= 0x12) {
@@ -3334,7 +3326,7 @@ void handle_freeze(struct work_struct *work)
 	write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_UNFREEZE_SMASK);
 	wait_for_freeze_status(dd, 0);
 
-	if (is_a0(dd)) {
+	if (is_ax(dd)) {
 		write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_FREEZE_SMASK);
 		wait_for_freeze_status(dd, 1);
 		write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_UNFREEZE_SMASK);
@@ -3862,7 +3854,7 @@ void handle_verify_cap(struct work_struct *work)
 	 *	REPLAY_BUF_MBE_SMASK
 	 *	FLIT_INPUT_BUF_MBE_SMASK
 	 */
-	if (is_a0(dd)) {			/* fixed in B0 */
+	if (is_ax(dd)) {			/* fixed in B0 */
 		reg = read_csr(dd, DC_LCB_CFG_LINK_KILL_EN);
 		reg |= DC_LCB_CFG_LINK_KILL_EN_REPLAY_BUF_MBE_SMASK
 			| DC_LCB_CFG_LINK_KILL_EN_FLIT_INPUT_BUF_MBE_SMASK;
@@ -7329,8 +7321,8 @@ static int set_buffer_control(struct hfi1_devdata *dd,
 	 */
 	use_all_mask = 0;
 	if ((be16_to_cpu(new_bc->overall_shared_limit) <
-				be16_to_cpu(cur_bc.overall_shared_limit))
-			|| (is_a0(dd) && any_shared_limit_changing)) {
+	     be16_to_cpu(cur_bc.overall_shared_limit)) ||
+	    (is_ax(dd) && any_shared_limit_changing)) {
 		set_global_shared(dd, 0);
 		cur_bc.overall_shared_limit = 0;
 		use_all_mask = 1;
@@ -7504,7 +7496,7 @@ int fm_set_table(struct hfi1_pportdata *ppd, int which, void *t)
  */
 static int disable_data_vls(struct hfi1_devdata *dd)
 {
-	if (is_a0(dd))
+	if (is_ax(dd))
 		return 1;
 
 	pio_send_control(dd, PSC_DATA_VL_DISABLE);
@@ -7522,7 +7514,7 @@ static int disable_data_vls(struct hfi1_devdata *dd)
  */
 int open_fill_data_vls(struct hfi1_devdata *dd)
 {
-	if (is_a0(dd))
+	if (is_ax(dd))
 		return 1;
 
 	pio_send_control(dd, PSC_DATA_VL_ENABLE);
@@ -9947,7 +9939,7 @@ static void init_chip(struct hfi1_devdata *dd)
 		/* restore command and BARs */
 		restore_pci_variables(dd);
 
-		if (is_a0(dd)) {
+		if (is_ax(dd)) {
 			dd_dev_info(dd, "Resetting CSRs with FLR\n");
 			hfi1_pcie_flr(dd);
 			restore_pci_variables(dd);
@@ -9966,7 +9958,7 @@ static void init_chip(struct hfi1_devdata *dd)
 	write_csr(dd, CCE_DC_CTRL, 0);
 
 	/* Set the LED off */
-	if (is_a0(dd))
+	if (is_ax(dd))
 		setextled(dd, 0);
 	/*
 	 * Clear the QSFP reset.
@@ -9989,7 +9981,7 @@ static void init_early_variables(struct hfi1_devdata *dd)
 	/* assign link credit variables */
 	dd->vau = CM_VAU;
 	dd->link_credits = CM_GLOBAL_CREDITS;
-	if (is_a0(dd))
+	if (is_ax(dd))
 		dd->link_credits--;
 	dd->vcu = cu_to_vcu(hfi1_cu);
 	/* enough room for 8 MAD packets plus header - 17K */
@@ -10103,7 +10095,7 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
 	u64 *rsmmap;
 	u64 reg;
-	u8  rxcontext = is_a0(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
+	u8  rxcontext = is_ax(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
 
 	/* validate */
 	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
@@ -10314,7 +10306,7 @@ int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
 	 * Enable send-side J_KEY integrity check, unless this is A0 h/w
 	 * (due to A0 erratum).
 	 */
-	if (!is_a0(dd)) {
+	if (!is_ax(dd)) {
 		reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
 		reg |= SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
 		write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
@@ -10347,7 +10339,7 @@ int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt)
 	 * This check would not have been enabled for A0 h/w, see
 	 * set_ctxt_jkey().
 	 */
-	if (!is_a0(dd)) {
+	if (!is_ax(dd)) {
 		reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
 		reg &= ~SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
 		write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index d7f3f81..05d90ce 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -664,7 +664,6 @@ void get_linkup_link_widths(struct hfi1_pportdata *ppd);
 void read_ltp_rtt(struct hfi1_devdata *dd);
 void clear_linkup_counters(struct hfi1_devdata *dd);
 u32 hdrqempty(struct hfi1_ctxtdata *rcd);
-int is_a0(struct hfi1_devdata *dd);
 int is_ax(struct hfi1_devdata *dd);
 int is_bx(struct hfi1_devdata *dd);
 u32 read_physical_state(struct hfi1_devdata *dd);
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index f311282..938b97c 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -951,7 +951,7 @@ void sbus_request(struct hfi1_devdata *dd,
 static void turn_off_spicos(struct hfi1_devdata *dd, int flags)
 {
 	/* only needed on A0 */
-	if (!is_a0(dd))
+	if (!is_ax(dd))
 		return;
 
 	dd_dev_info(dd, "Turning off spicos:%s%s\n",
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 488aa34..fe751bb 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1687,7 +1687,7 @@ static inline u64 hfi1_pkt_default_send_ctxt_mask(struct hfi1_devdata *dd,
 	else
 		base_sc_integrity |= HFI1_PKT_KERNEL_SC_INTEGRITY;
 
-	if (is_a0(dd))
+	if (is_ax(dd))
 		/* turn off send-side job key checks - A0 erratum */
 		return base_sc_integrity &
 		       ~SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
@@ -1714,7 +1714,7 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	| SEND_DMA_CHECK_ENABLE_CHECK_VL_SMASK
 	| SEND_DMA_CHECK_ENABLE_CHECK_ENABLE_SMASK;
 
-	if (is_a0(dd))
+	if (is_ax(dd))
 		/* turn off send-side job key checks - A0 erratum */
 		return base_sdma_integrity &
 		       ~SEND_DMA_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 5fdd9dd..3f5a409 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -672,7 +672,7 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 	dd->process_dma_send = hfi1_verbs_send_dma;
 	dd->pio_inline_send = pio_copy;
 
-	if (is_a0(dd)) {
+	if (is_ax(dd)) {
 		atomic_set(&dd->drop_packet, DROP_PACKET_ON);
 		dd->do_drop = 1;
 	} else {
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 0b7eafb..8317b07 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -917,7 +917,7 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	/*
 	 * A0 needs an additional SBR
 	 */
-	if (is_a0(dd))
+	if (is_ax(dd))
 		nsbr++;
 
 	/*
@@ -1193,7 +1193,7 @@ retry:
 	write_csr(dd, CCE_DC_CTRL, 0);
 
 	/* Set the LED off */
-	if (is_a0(dd))
+	if (is_ax(dd))
 		setextled(dd, 0);
 
 	/* check for any per-lane errors */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
