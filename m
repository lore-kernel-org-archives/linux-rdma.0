From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/21] staging/rdma/hfi1: Fix logical continuations
Date: Sun, 14 Feb 2016 20:20:15 -0800
Message-ID: <20160215042012.351.83040.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move logical continuations to previous line to fix checkpatch check:
CHECK: Logical continuations should be on the previous line

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |   55 ++++++++++++++++------------------
 drivers/staging/rdma/hfi1/driver.c   |    6 ++--
 drivers/staging/rdma/hfi1/file_ops.c |   12 ++++---
 drivers/staging/rdma/hfi1/firmware.c |   20 ++++--------
 drivers/staging/rdma/hfi1/intr.c     |    3 +-
 drivers/staging/rdma/hfi1/mad.c      |   12 ++++---
 drivers/staging/rdma/hfi1/sdma.c     |    4 +-
 7 files changed, 51 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 51256ba..b4c017a 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6552,8 +6552,8 @@ void handle_sma_message(struct work_struct *work)
 		 *
 		 * Can activate the node.  Discard otherwise.
 		 */
-		if (ppd->host_link_state == HLS_UP_ARMED
-					&& ppd->is_active_optimize_enabled) {
+		if (ppd->host_link_state == HLS_UP_ARMED &&
+		    ppd->is_active_optimize_enabled) {
 			ppd->neighbor_normal = 1;
 			ret = set_link_state(ppd, HLS_UP_ACTIVE);
 			if (ret)
@@ -7032,8 +7032,8 @@ static void get_link_widths(struct hfi1_devdata *dd, u16 *tx_width,
 	 * handle_verify_cap().  The ASIC 8051 firmware does not correctly
 	 * set the max_rate field in handle_verify_cap until v0.19.
 	 */
-	if ((dd->icode == ICODE_RTL_SILICON)
-				&& (dd->dc8051_ver < dc8051_ver(0, 19))) {
+	if ((dd->icode == ICODE_RTL_SILICON) &&
+	    (dd->dc8051_ver < dc8051_ver(0, 19))) {
 		/* max_rate: 0 = 12.5G, 1 = 25G */
 		switch (max_rate) {
 		case 0:
@@ -7358,10 +7358,8 @@ retry:
 		/* downgrade is disabled */
 
 		/* bounce if not at starting active width */
-		if ((ppd->link_width_active !=
-					ppd->link_width_downgrade_tx_active)
-				|| (ppd->link_width_active !=
-					ppd->link_width_downgrade_rx_active)) {
+		if ((ppd->link_width_active != ppd->link_width_downgrade_tx_active) ||
+		    (ppd->link_width_active != ppd->link_width_downgrade_rx_active)) {
 			dd_dev_err(ppd->dd,
 				"Link downgrade is disabled and link has downgraded, downing link\n");
 			dd_dev_err(ppd->dd,
@@ -7371,8 +7369,8 @@ retry:
 				ppd->link_width_downgrade_rx_active);
 			do_bounce = 1;
 		}
-	} else if ((lwde & ppd->link_width_downgrade_tx_active) == 0
-		|| (lwde & ppd->link_width_downgrade_rx_active) == 0) {
+	} else if ((lwde & ppd->link_width_downgrade_tx_active) == 0 ||
+		   (lwde & ppd->link_width_downgrade_rx_active) == 0) {
 		/* Tx or Rx is outside the enabled policy */
 		dd_dev_err(ppd->dd,
 			"Link is outside of downgrade allowed, downing link\n");
@@ -7567,9 +7565,9 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	if (queue_link_down) {
 		/* if the link is already going down or disabled, do not
 		 * queue another */
-		if ((ppd->host_link_state
-				    & (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN))
-				|| ppd->link_enabled == 0) {
+		if ((ppd->host_link_state &
+		    (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN)) ||
+		    ppd->link_enabled == 0) {
 			dd_dev_info(dd, "%s: not queuing link down\n",
 				__func__);
 		} else {
@@ -8888,10 +8886,9 @@ static int init_loopback(struct hfi1_devdata *dd)
 	 *
 	 * Accept all valid loopback values.
 	 */
-	if ((dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
-		&& (loopback == LOOPBACK_SERDES
-			|| loopback == LOOPBACK_LCB
-			|| loopback == LOOPBACK_CABLE)) {
+	if ((dd->icode == ICODE_FUNCTIONAL_SIMULATOR) &&
+	    (loopback == LOOPBACK_SERDES || loopback == LOOPBACK_LCB ||
+	     loopback == LOOPBACK_CABLE)) {
 		loopback = LOOPBACK_LCB;
 		quick_linkup = 1;
 		return 0;
@@ -10020,8 +10017,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		state = dd->link_default;
 
 	/* interpret poll -> poll as a link bounce */
-	poll_bounce = ppd->host_link_state == HLS_DN_POLL
-				&& state == HLS_DN_POLL;
+	poll_bounce = ppd->host_link_state == HLS_DN_POLL &&
+		      state == HLS_DN_POLL;
 
 	dd_dev_info(dd, "%s: current %s, new %s %s%s\n", __func__,
 		link_state_name(ppd->host_link_state),
@@ -10048,8 +10045,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 
 	switch (state) {
 	case HLS_UP_INIT:
-		if (ppd->host_link_state == HLS_DN_POLL && (quick_linkup
-			    || dd->icode == ICODE_FUNCTIONAL_SIMULATOR)) {
+		if (ppd->host_link_state == HLS_DN_POLL &&
+		    (quick_linkup || dd->icode == ICODE_FUNCTIONAL_SIMULATOR)) {
 			/*
 			 * Quick link up jumps from polling to here.
 			 *
@@ -10779,8 +10776,8 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 						!= cur_bc.vl[i].shared;
 		if (this_shared_changing)
 			any_shared_limit_changing = 1;
-		if (new_bc->vl[i].dedicated != cur_bc.vl[i].dedicated
-				|| this_shared_changing) {
+		if (new_bc->vl[i].dedicated != cur_bc.vl[i].dedicated ||
+		    this_shared_changing) {
 			changing[i] = 1;
 			changing_mask |= stat_mask;
 			change_count++;
@@ -11227,8 +11224,8 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 
 	rcvctrl = read_kctxt_csr(dd, ctxt, RCV_CTXT_CTRL);
 	/* if the context already enabled, don't do the extra steps */
-	if ((op & HFI1_RCVCTRL_CTXT_ENB)
-			&& !(rcvctrl & RCV_CTXT_CTRL_ENABLE_SMASK)) {
+	if ((op & HFI1_RCVCTRL_CTXT_ENB) &&
+	    !(rcvctrl & RCV_CTXT_CTRL_ENABLE_SMASK)) {
 		/* reset the tail and hdr addresses, and sequence count */
 		write_kctxt_csr(dd, ctxt, RCV_HDR_ADDR,
 				rcd->rcvhdrq_phys);
@@ -11344,8 +11341,8 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 	write_kctxt_csr(dd, ctxt, RCV_CTXT_CTRL, rcd->rcvctrl);
 
 	/* work around sticky RcvCtxtStatus.BlockedRHQFull */
-	if (did_enable
-	    && (rcvctrl & RCV_CTXT_CTRL_DONT_DROP_RHQ_FULL_SMASK)) {
+	if (did_enable &&
+	    (rcvctrl & RCV_CTXT_CTRL_DONT_DROP_RHQ_FULL_SMASK)) {
 		reg = read_kctxt_csr(dd, ctxt, RCV_CTXT_STATUS);
 		if (reg != 0) {
 			dd_dev_info(dd, "ctxt %d status %lld (blocked)\n",
@@ -13989,8 +13986,8 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		/* link width active is 0 when link is down */
 		/* link width downgrade active is 0 when link is down */
 
-		if (num_vls < HFI1_MIN_VLS_SUPPORTED
-			|| num_vls > HFI1_MAX_VLS_SUPPORTED) {
+		if (num_vls < HFI1_MIN_VLS_SUPPORTED ||
+		    num_vls > HFI1_MAX_VLS_SUPPORTED) {
 			hfi1_early_err(&pdev->dev,
 				       "Invalid num_vls %u, using %u VLs\n",
 				    num_vls, HFI1_MAX_VLS_SUPPORTED);
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index fee5e39..3ef297e 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -1123,9 +1123,9 @@ int set_mtu(struct hfi1_pportdata *ppd)
 	ppd->ibmaxlen = ppd->ibmtu + lrh_max_header_bytes(ppd->dd);
 
 	mutex_lock(&ppd->hls_lock);
-	if (ppd->host_link_state == HLS_UP_INIT
-			|| ppd->host_link_state == HLS_UP_ARMED
-			|| ppd->host_link_state == HLS_UP_ACTIVE)
+	if (ppd->host_link_state == HLS_UP_INIT ||
+	    ppd->host_link_state == HLS_UP_ARMED ||
+	    ppd->host_link_state == HLS_UP_ACTIVE)
 		is_up = 1;
 
 	drain = !is_ax(dd) && is_up;
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index b52cb78..5077ee0 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1626,12 +1626,12 @@ static ssize_t ui_read(struct file *filp, char __user *buf, size_t count,
 		 * them.  These registers are defined as having a read value
 		 * of 0.
 		 */
-		else if (csr_off == ASIC_GPIO_CLEAR
-				|| csr_off == ASIC_GPIO_FORCE
-				|| csr_off == ASIC_QSFP1_CLEAR
-				|| csr_off == ASIC_QSFP1_FORCE
-				|| csr_off == ASIC_QSFP2_CLEAR
-				|| csr_off == ASIC_QSFP2_FORCE)
+		else if (csr_off == ASIC_GPIO_CLEAR ||
+			 csr_off == ASIC_GPIO_FORCE ||
+			 csr_off == ASIC_QSFP1_CLEAR ||
+			 csr_off == ASIC_QSFP1_FORCE ||
+			 csr_off == ASIC_QSFP2_CLEAR ||
+			 csr_off == ASIC_QSFP2_FORCE)
 			data = 0;
 		else if (csr_off >= barlen) {
 			/*
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 31550a3..1af5e34 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -391,19 +391,13 @@ static int invalid_header(struct hfi1_devdata *dd, const char *what,
 static int verify_css_header(struct hfi1_devdata *dd, struct css_header *css)
 {
 	/* verify CSS header fields (most sizes are in DW, so add /4) */
-	if (invalid_header(dd, "module_type", css->module_type, CSS_MODULE_TYPE)
-			|| invalid_header(dd, "header_len", css->header_len,
-					(sizeof(struct firmware_file) / 4))
-			|| invalid_header(dd, "header_version",
-					css->header_version, CSS_HEADER_VERSION)
-			|| invalid_header(dd, "module_vendor",
-					css->module_vendor, CSS_MODULE_VENDOR)
-			|| invalid_header(dd, "key_size",
-					css->key_size, KEY_SIZE / 4)
-			|| invalid_header(dd, "modulus_size",
-					css->modulus_size, KEY_SIZE / 4)
-			|| invalid_header(dd, "exponent_size",
-					css->exponent_size, EXPONENT_SIZE / 4)) {
+	if (invalid_header(dd, "module_type", css->module_type, CSS_MODULE_TYPE) ||
+	    invalid_header(dd, "header_len", css->header_len, (sizeof(struct firmware_file) / 4)) ||
+	    invalid_header(dd, "header_version", css->header_version, CSS_HEADER_VERSION) ||
+	    invalid_header(dd, "module_vendor", css->module_vendor, CSS_MODULE_VENDOR) ||
+	    invalid_header(dd, "key_size", css->key_size, KEY_SIZE / 4) ||
+	    invalid_header(dd, "modulus_size", css->modulus_size, KEY_SIZE / 4) ||
+	    invalid_header(dd, "exponent_size", css->exponent_size, EXPONENT_SIZE / 4)) {
 		return -EINVAL;
 	}
 	return 0;
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 685fb4d..03cebae 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -131,8 +131,7 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		 * NOTE: This uses this device's vAU, vCU, and vl15_init for
 		 * the remote values.  Both sides must be using the values.
 		 */
-		if (quick_linkup
-			    || dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
+		if (quick_linkup || dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
 			set_up_vl15(dd, dd->vau, dd->vl15_init);
 			assign_remote_cm_au_table(dd, dd->vcu);
 			ppd->neighbor_guid =
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index adfd0a9..ae594f4 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -1170,8 +1170,8 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	ppd->port_error_action = be32_to_cpu(pi->port_error_action);
 	lwe = be16_to_cpu(pi->link_width.enabled);
 	if (lwe) {
-		if (lwe == OPA_LINK_WIDTH_RESET
-				|| lwe == OPA_LINK_WIDTH_RESET_OLD)
+		if (lwe == OPA_LINK_WIDTH_RESET ||
+		    lwe == OPA_LINK_WIDTH_RESET_OLD)
 			set_link_width_enabled(ppd, ppd->link_width_supported);
 		else if ((lwe & ~ppd->link_width_supported) == 0)
 			set_link_width_enabled(ppd, lwe);
@@ -1180,8 +1180,8 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	}
 	lwe = be16_to_cpu(pi->link_width_downgrade.enabled);
 	/* LWD.E is always applied - 0 means "disabled" */
-	if (lwe == OPA_LINK_WIDTH_RESET
-			|| lwe == OPA_LINK_WIDTH_RESET_OLD) {
+	if (lwe == OPA_LINK_WIDTH_RESET ||
+	    lwe == OPA_LINK_WIDTH_RESET_OLD) {
 		set_link_width_downgrade_enabled(ppd,
 				ppd->link_width_downgrade_supported);
 	} else if ((lwe & ~ppd->link_width_downgrade_supported) == 0) {
@@ -2335,8 +2335,8 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 		return reply((struct ib_mad_hdr *)pmp);
 	}
 
-	if (nports != 1 || (port_num && port_num != port)
-	    || num_vls > OPA_MAX_VLS || (vl_select_mask & ~VL_MASK_ALL)) {
+	if (nports != 1 || (port_num && port_num != port) ||
+	    num_vls > OPA_MAX_VLS || (vl_select_mask & ~VL_MASK_ALL)) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)pmp);
 	}
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index d8edf9b..2fbdb4d 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -672,8 +672,8 @@ static void sdma_set_state(struct sdma_engine *sde,
 	ss->previous_op = ss->current_op;
 	ss->current_state = next_state;
 
-	if (ss->previous_state != sdma_state_s99_running
-		&& next_state == sdma_state_s99_running)
+	if (ss->previous_state != sdma_state_s99_running &&
+	    next_state == sdma_state_s99_running)
 		sdma_flush(sde);
 
 	if (action[next_state].op_enable)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
