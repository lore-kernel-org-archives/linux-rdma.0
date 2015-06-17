From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 03/49] IB/hfi1: add chip specific support part2
Date: Wed, 17 Jun 2015 08:28:51 -0400
Message-ID: <20150617122851.8744.80472.stgit@phlsvslse11.ph.intel.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122755.8744.44665.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Friedley <andrew.friedley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Gregor <john.a.gregor-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kevin Pine <kevin.pine-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kyle Liddell <kyle.liddell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ravi Krishnaswamy <ravi.krishnaswamy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sanath Kumar <sanath.s.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vlad Danushevsky <vladimir.danusevsky-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 2890 +++++++++++++++++++++++++++++++++++++
 1 file changed, 2890 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 2bb026d..ed03311 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -2140,3 +2140,2893 @@ static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	}
 }
 
+/*
+ * Check counters for receive errors that do not have an interrupt
+ * associated with them.
+ */
+#define RCVERR_CHECK_TIME 10
+static void update_rcverr_timer(unsigned long opaque)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)opaque;
+	struct hfi1_pportdata *ppd = dd->pport;
+	u32 cur_ovfl_cnt = read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL);
+
+	if (dd->rcv_ovfl_cnt < cur_ovfl_cnt &&
+		ppd->port_error_action & OPA_PI_MASK_EX_BUFFER_OVERRUN) {
+		dd_dev_info(dd, "%s: PortErrorAction bounce\n", __func__);
+		set_link_down_reason(ppd,
+		  OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN, 0,
+			OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN);
+		start_link(ppd);
+	}
+	dd->rcv_ovfl_cnt = (u32) cur_ovfl_cnt;
+
+	mod_timer(&dd->rcverr_timer, jiffies + HZ * RCVERR_CHECK_TIME);
+}
+
+static int init_rcverr(struct hfi1_devdata *dd)
+{
+	init_timer(&dd->rcverr_timer);
+	dd->rcverr_timer.function = update_rcverr_timer;
+	dd->rcverr_timer.data = (unsigned long) dd;
+	/* Assume the hardware counter has been reset */
+	dd->rcv_ovfl_cnt = 0;
+	return mod_timer(&dd->rcverr_timer, jiffies + HZ * RCVERR_CHECK_TIME);
+}
+
+static void free_rcverr(struct hfi1_devdata *dd)
+{
+	if (dd->rcverr_timer.data)
+		del_timer_sync(&dd->rcverr_timer);
+	dd->rcverr_timer.data = 0;
+}
+
+static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	char buf[96];
+
+	dd_dev_info(dd, "Receive Error: %s\n",
+		rxe_err_status_string(buf, sizeof(buf), reg));
+
+	if (reg & ALL_RXE_FREEZE_ERR) {
+		int flags = 0;
+
+		/*
+		 * Freeze mode recovery is disabled for the errors
+		 * in RXE_FREEZE_ABORT_MASK
+		 */
+		if (is_a0(dd) && (reg & RXE_FREEZE_ABORT_MASK))
+			flags = FREEZE_ABORT;
+
+		start_freeze_handling(dd->pport, flags);
+	}
+}
+
+static void handle_misc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	char buf[96];
+
+	dd_dev_info(dd, "Misc Error: %s",
+		misc_err_status_string(buf, sizeof(buf), reg));
+}
+
+static void handle_pio_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	char buf[96];
+
+	dd_dev_info(dd, "PIO Error: %s\n",
+		pio_err_status_string(buf, sizeof(buf), reg));
+
+	if (reg & ALL_PIO_FREEZE_ERR)
+		start_freeze_handling(dd->pport, 0);
+}
+
+static void handle_sdma_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	char buf[96];
+
+	dd_dev_info(dd, "SDMA Error: %s\n",
+		sdma_err_status_string(buf, sizeof(buf), reg));
+
+	if (reg & ALL_SDMA_FREEZE_ERR)
+		start_freeze_handling(dd->pport, 0);
+}
+
+static void count_port_inactive(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+
+	if (ppd->port_xmit_discards < ~(u64)0)
+		ppd->port_xmit_discards++;
+}
+
+/*
+ * We have had a "disallowed packet" error during egress. Determine the
+ * integrity check which failed, and update relevant error counter, etc.
+ *
+ * Note that the SEND_EGRESS_ERR_INFO register has only a single
+ * bit of state per integrity check, and so we can miss the reason for an
+ * egress error if more than one packet fails the same integrity check
+ * since we cleared the corresponding bit in SEND_EGRESS_ERR_INFO.
+ */
+static void handle_send_egress_err_info(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+	u64 src = read_csr(dd, SEND_EGRESS_ERR_SOURCE); /* read first */
+	u64 info = read_csr(dd, SEND_EGRESS_ERR_INFO);
+	char buf[96];
+
+	/* clear down all observed info as quickly as possible after read */
+	write_csr(dd, SEND_EGRESS_ERR_INFO, info);
+
+	dd_dev_info(dd,
+		"Egress Error Info: 0x%llx, %s Egress Error Src 0x%llx\n",
+		info, egress_err_info_string(buf, sizeof(buf), info), src);
+
+	/* Eventually add other counters for each bit */
+
+	if (info & SEND_EGRESS_ERR_INFO_TOO_LONG_IB_PACKET_ERR_SMASK) {
+		if (ppd->port_xmit_discards < ~(u64)0)
+			ppd->port_xmit_discards++;
+	}
+}
+
+/*
+ * Input value is a bit position within the SEND_EGRESS_ERR_STATUS
+ * register. Does it represent a 'port inactive' error?
+ */
+static inline int port_inactive_err(u64 posn)
+{
+	return (posn >= SEES(TX_LINKDOWN) &&
+		posn <= SEES(TX_INCORRECT_LINK_STATE));
+}
+
+/*
+ * Input value is a bit position within the SEND_EGRESS_ERR_STATUS
+ * register. Does it represent a 'disallowed packet' error?
+ */
+static inline int disallowed_pkt_err(u64 posn)
+{
+	return (posn >= SEES(TX_SDMA0_DISALLOWED_PACKET) &&
+		posn <= SEES(TX_SDMA15_DISALLOWED_PACKET));
+}
+
+static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	u64 reg_copy = reg, handled = 0;
+	char buf[96];
+
+	if (reg & ALL_TXE_EGRESS_FREEZE_ERR)
+		start_freeze_handling(dd->pport, 0);
+	if (is_a0(dd) && (reg &
+		    SEND_EGRESS_ERR_STATUS_TX_CREDIT_RETURN_VL_ERR_SMASK)
+		    && (dd->icode != ICODE_FUNCTIONAL_SIMULATOR))
+		start_freeze_handling(dd->pport, 0);
+
+	while (reg_copy) {
+		int posn = fls64(reg_copy);
+		/*
+		 * fls64() returns a 1-based offset, but we generally
+		 * want 0-based offsets.
+		 */
+		int shift = posn - 1;
+
+		if (port_inactive_err(shift)) {
+			count_port_inactive(dd);
+			handled |= (1ULL << shift);
+		} else if (disallowed_pkt_err(shift)) {
+			handle_send_egress_err_info(dd);
+			handled |= (1ULL << shift);
+		}
+		clear_bit(shift, (unsigned long *)&reg_copy);
+	}
+
+	reg &= ~handled;
+
+	if (reg)
+		dd_dev_info(dd, "Egress Error: %s\n",
+			egress_err_status_string(buf, sizeof(buf), reg));
+}
+
+static void handle_txe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	char buf[96];
+
+	dd_dev_info(dd, "Send Error: %s\n",
+		send_err_status_string(buf, sizeof(buf), reg));
+
+}
+
+/*
+ * The maximum number of times the error clear down will loop before
+ * blocking a repeating error.  This value is arbitrary.
+ */
+#define MAX_CLEAR_COUNT 20
+
+/*
+ * Clear and handle an error register.  All error interrupts are funneled
+ * through here to have a central location to correctly handle single-
+ * or multi-shot errors.
+ *
+ * For non per-context registers, call this routine with a context value
+ * of 0 so the per-context offset is zero.
+ *
+ * If the handler loops too many times, assume that something is wrong
+ * and can't be fixed, so mask the error bits.
+ */
+static void interrupt_clear_down(struct hfi1_devdata *dd,
+				 u32 context,
+				 const struct err_reg_info *eri)
+{
+	u64 reg;
+	u32 count;
+
+	/* read in a loop until no more errors are seen */
+	count = 0;
+	while (1) {
+		reg = read_kctxt_csr(dd, context, eri->status);
+		if (reg == 0)
+			break;
+		write_kctxt_csr(dd, context, eri->clear, reg);
+		if (likely(eri->handler))
+			eri->handler(dd, context, reg);
+		count++;
+		if (count > MAX_CLEAR_COUNT) {
+			u64 mask;
+
+			dd_dev_err(dd, "Repeating %s bits 0x%llx - masking\n",
+				eri->desc, reg);
+			/*
+			 * Read-modify-write so any other masked bits
+			 * remain masked.
+			 */
+			mask = read_kctxt_csr(dd, context, eri->mask);
+			mask &= ~reg;
+			write_kctxt_csr(dd, context, eri->mask, mask);
+			break;
+		}
+	}
+}
+
+/*
+ * CCE block "misc" interrupt.  Source is < 16.
+ */
+static void is_misc_err_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	const struct err_reg_info *eri = &misc_errs[source];
+
+	if (eri->handler) {
+		interrupt_clear_down(dd, 0, eri);
+	} else {
+		dd_dev_err(dd, "Unexpected misc interrupt (%u) - reserved\n",
+			source);
+	}
+}
+
+static char *send_context_err_status_string(char *buf, int buf_len, u64 flags)
+{
+	return flag_string(buf, buf_len, flags,
+			sc_err_status_flags, ARRAY_SIZE(sc_err_status_flags));
+}
+
+/*
+ * Send context error interrupt.  Source (hw_context) is < 160.
+ *
+ * All send context errors cause the send context to halt.  The normal
+ * clear-down mechanism cannot be used because we cannot clear the
+ * error bits until several other long-running items are done first.
+ * This is OK because with the context halted, nothing else is going
+ * to happen on it anyway.
+ */
+static void is_sendctxt_err_int(struct hfi1_devdata *dd,
+				unsigned int hw_context)
+{
+	struct send_context_info *sci;
+	struct send_context *sc;
+	char flags[96];
+	u64 status;
+	u32 sw_index;
+
+	sw_index = dd->hw_to_sw[hw_context];
+	if (sw_index >= dd->num_send_contexts) {
+		dd_dev_err(dd,
+			"out of range sw index %u for send context %u\n",
+			sw_index, hw_context);
+		return;
+	}
+	sci = &dd->send_contexts[sw_index];
+	sc = sci->sc;
+	if (!sc) {
+		dd_dev_err(dd, "%s: context %u(%u): no sc?\n", __func__,
+			sw_index, hw_context);
+		return;
+	}
+
+	/* tell the software that a halt has begun */
+	sc_stop(sc, SCF_HALTED);
+
+	status = read_kctxt_csr(dd, hw_context, SEND_CTXT_ERR_STATUS);
+
+	dd_dev_info(dd, "Send Context %u(%u) Error: %s\n", sw_index, hw_context,
+		send_context_err_status_string(flags, sizeof(flags), status));
+
+	if (status & SEND_CTXT_ERR_STATUS_PIO_DISALLOWED_PACKET_ERR_SMASK)
+		handle_send_egress_err_info(dd);
+
+	/*
+	 * Automatically restart halted kernel contexts out of interrupt
+	 * context.  User contexts must ask the driver to restart the context.
+	 */
+	if (sc->type != SC_USER)
+		queue_work(dd->pport->hfi1_wq, &sc->halt_work);
+}
+
+static void handle_sdma_eng_err(struct hfi1_devdata *dd,
+				unsigned int source, u64 status)
+{
+	struct sdma_engine *sde;
+
+	sde = &dd->per_sdma[source];
+	/* BUG_ON(source != 0); */
+#ifdef CONFIG_SDMA_VERBOSITY
+	dd_dev_err(sde->dd, "CONFIG SDMA(%u) %s:%d %s()\n", sde->this_idx,
+		   slashstrip(__FILE__), __LINE__, __func__);
+	dd_dev_err(sde->dd, "CONFIG SDMA(%u) source: %u status 0x%llx\n",
+		   sde->this_idx, source, (unsigned long long)status);
+#endif
+	sdma_engine_error(sde, status);
+}
+
+/*
+ * CCE block SDMA error interrupt.  Source is < 16.
+ */
+static void is_sdma_eng_err_int(struct hfi1_devdata *dd, unsigned int source)
+{
+#ifdef CONFIG_SDMA_VERBOSITY
+	struct sdma_engine *sde = &dd->per_sdma[source];
+
+	dd_dev_err(dd, "CONFIG SDMA(%u) %s:%d %s()\n", sde->this_idx,
+		   slashstrip(__FILE__), __LINE__, __func__);
+	dd_dev_err(dd, "CONFIG SDMA(%u) source: %u\n", sde->this_idx,
+		   source);
+	sdma_dumpstate(sde);
+#endif
+	interrupt_clear_down(dd, source, &sdma_eng_err);
+}
+
+/*
+ * CCE block "various" interrupt.  Source is < 8.
+ */
+static void is_various_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	const struct err_reg_info *eri = &various_err[source];
+
+	/*
+	 * TCritInt cannot go through interrupt_clear_down()
+	 * because it is not a second tier interrupt. The handler
+	 * should be called directly.
+	 */
+	if (source == TCRIT_INT_SOURCE)
+		handle_temp_err(dd);
+	else if (eri->handler)
+		interrupt_clear_down(dd, 0, eri);
+	else
+		dd_dev_info(dd,
+			"%s: Unimplemented/reserved interrupt %d\n",
+			__func__, source);
+}
+
+static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
+{
+	/* source is always zero */
+	struct hfi1_pportdata *ppd = dd->pport;
+	unsigned long flags;
+	u64 qsfp_int_mgmt = (u64)(QSFP_HFI0_INT_N | QSFP_HFI0_MODPRST_N);
+
+	if (reg & QSFP_HFI0_MODPRST_N) {
+
+		dd_dev_info(dd, "%s: ModPresent triggered QSFP interrupt\n",
+				__func__);
+
+		if (!qsfp_mod_present(ppd)) {
+			ppd->driver_link_ready = 0;
+			/*
+			 * Cable removed, reset all our information about the
+			 * cache and cable capabilities
+			 */
+
+			spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
+			/*
+			 * We don't set cache_refresh_required here as we expect
+			 * an interrupt when a cable is inserted
+			 */
+			ppd->qsfp_info.cache_valid = 0;
+			ppd->qsfp_info.qsfp_interrupt_functional = 0;
+			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
+						flags);
+			write_csr(dd,
+					dd->hfi1_id ?
+						ASIC_QSFP2_INVERT :
+						ASIC_QSFP1_INVERT,
+				qsfp_int_mgmt);
+			if (ppd->host_link_state == HLS_DN_POLL) {
+				/*
+				 * The link is still in POLL. This means
+				 * that the normal link down processing
+				 * will not happen. We have to do it here
+				 * before turning the DC off.
+				 */
+				queue_work(ppd->hfi1_wq, &ppd->link_down_work);
+			}
+		} else {
+			spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
+			ppd->qsfp_info.cache_valid = 0;
+			ppd->qsfp_info.cache_refresh_required = 1;
+			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
+						flags);
+
+			qsfp_int_mgmt &= ~(u64)QSFP_HFI0_MODPRST_N;
+			write_csr(dd,
+					dd->hfi1_id ?
+						ASIC_QSFP2_INVERT :
+						ASIC_QSFP1_INVERT,
+				qsfp_int_mgmt);
+		}
+	}
+
+	if (reg & QSFP_HFI0_INT_N) {
+
+		dd_dev_info(dd, "%s: IntN triggered QSFP interrupt\n",
+				__func__);
+		spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
+		ppd->qsfp_info.check_interrupt_flags = 1;
+		ppd->qsfp_info.qsfp_interrupt_functional = 1;
+		spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
+	}
+
+	/* Schedule the QSFP work only if there is a cable attached. */
+	if (qsfp_mod_present(ppd))
+		queue_work(ppd->hfi1_wq, &ppd->qsfp_info.qsfp_work);
+}
+
+static int request_host_lcb_access(struct hfi1_devdata *dd)
+{
+	int ret;
+
+	ret = do_8051_command(dd, HCMD_MISC,
+		(u64)HCMD_MISC_REQUEST_LCB_ACCESS << LOAD_DATA_FIELD_ID_SHIFT,
+		NULL);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd, "%s: command failed with error %d\n",
+			__func__, ret);
+	}
+	return ret == HCMD_SUCCESS ? 0 : -EBUSY;
+}
+
+static int request_8051_lcb_access(struct hfi1_devdata *dd)
+{
+	int ret;
+
+	ret = do_8051_command(dd, HCMD_MISC,
+		(u64)HCMD_MISC_GRANT_LCB_ACCESS << LOAD_DATA_FIELD_ID_SHIFT,
+		NULL);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd, "%s: command failed with error %d\n",
+			__func__, ret);
+	}
+	return ret == HCMD_SUCCESS ? 0 : -EBUSY;
+}
+
+/*
+ * Set the LCB selector - allow host access.  The DCC selector always
+ * points to the host.
+ */
+static inline void set_host_lcb_access(struct hfi1_devdata *dd)
+{
+	write_csr(dd, DC_DC8051_CFG_CSR_ACCESS_SEL,
+				DC_DC8051_CFG_CSR_ACCESS_SEL_DCC_SMASK
+				| DC_DC8051_CFG_CSR_ACCESS_SEL_LCB_SMASK);
+}
+
+/*
+ * Clear the LCB selector - allow 8051 access.  The DCC selector always
+ * points to the host.
+ */
+static inline void set_8051_lcb_access(struct hfi1_devdata *dd)
+{
+	write_csr(dd, DC_DC8051_CFG_CSR_ACCESS_SEL,
+				DC_DC8051_CFG_CSR_ACCESS_SEL_DCC_SMASK);
+}
+
+/*
+ * Acquire LCB access from the 8051.  If the host already has access,
+ * just increment a counter.  Otherwise, inform the 8051 that the
+ * host is taking access.
+ *
+ * Returns:
+ *	0 on success
+ *	-EBUSY if the 8051 has control and cannot be disturbed
+ *	-errno if unable to acquire access from the 8051
+ */
+int acquire_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+	int ret = 0;
+
+	/*
+	 * Use the host link state lock so the operation of this routine
+	 * { link state check, selector change, count increment } can occur
+	 * as a unit against a link state change.  Otherwise there is a
+	 * race between the state change and the count increment.
+	 */
+	if (sleep_ok) {
+		mutex_lock(&ppd->hls_lock);
+	} else {
+		while (mutex_trylock(&ppd->hls_lock) == EBUSY)
+			udelay(1);
+	}
+
+	/* this access is valid only when the link is up */
+	if ((ppd->host_link_state & HLS_UP) == 0) {
+		dd_dev_info(dd, "%s: link state %s not up\n",
+			__func__, link_state_name(ppd->host_link_state));
+		ret = -EBUSY;
+		goto done;
+	}
+
+	if (dd->lcb_access_count == 0) {
+		ret = request_host_lcb_access(dd);
+		if (ret) {
+			dd_dev_err(dd,
+				"%s: unable to acquire LCB access, err %d\n",
+				__func__, ret);
+			goto done;
+		}
+		set_host_lcb_access(dd);
+	}
+	dd->lcb_access_count++;
+done:
+	mutex_unlock(&ppd->hls_lock);
+	return ret;
+}
+
+/*
+ * Release LCB access by decrementing the use count.  If the count is moving
+ * from 1 to 0, inform 8051 that it has control back.
+ *
+ * Returns:
+ *	0 on success
+ *	-errno if unable to release access to the 8051
+ */
+int release_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
+{
+	int ret = 0;
+
+	/*
+	 * Use the host link state lock because the acquire needed it.
+	 * Here, we only need to keep { selector change, count decrement }
+	 * as a unit.
+	 */
+	if (sleep_ok) {
+		mutex_lock(&dd->pport->hls_lock);
+	} else {
+		while (mutex_trylock(&dd->pport->hls_lock) == EBUSY)
+			udelay(1);
+	}
+
+	if (dd->lcb_access_count == 0) {
+		dd_dev_err(dd, "%s: LCB access count is zero.  Skipping.\n",
+			__func__);
+		goto done;
+	}
+
+	if (dd->lcb_access_count == 1) {
+		set_8051_lcb_access(dd);
+		ret = request_8051_lcb_access(dd);
+		if (ret) {
+			dd_dev_err(dd,
+				"%s: unable to release LCB access, err %d\n",
+				__func__, ret);
+			/* restore host access if the grant didn't work */
+			set_host_lcb_access(dd);
+			goto done;
+		}
+	}
+	dd->lcb_access_count--;
+done:
+	mutex_unlock(&dd->pport->hls_lock);
+	return ret;
+}
+
+/*
+ * Initialize LCB access variables and state.  Called during driver load,
+ * after most of the initialization is finished.
+ *
+ * The DC default is LCB access on for the host.  The driver defaults to
+ * leaving access to the 8051.  Assign access now - this constrains the call
+ * to this routine to be after all LCB set-up is done.  In particular, after
+ * hf1_init_dd() -> set_up_interrupts() -> clear_all_interrupts()
+ */
+static void init_lcb_access(struct hfi1_devdata *dd)
+{
+	dd->lcb_access_count = 0;
+}
+
+/*
+ * Write a response back to a 8051 request.
+ */
+static void hreq_response(struct hfi1_devdata *dd, u8 return_code, u16 rsp_data)
+{
+	write_csr(dd, DC_DC8051_CFG_EXT_DEV_0,
+		DC_DC8051_CFG_EXT_DEV_0_COMPLETED_SMASK
+		| (u64)return_code << DC_DC8051_CFG_EXT_DEV_0_RETURN_CODE_SHIFT
+		| (u64)rsp_data << DC_DC8051_CFG_EXT_DEV_0_RSP_DATA_SHIFT);
+}
+
+/*
+ * Handle requests from the 8051.
+ */
+static void handle_8051_request(struct hfi1_devdata *dd)
+{
+	u64 reg;
+	u16 data;
+	u8 type;
+
+	reg = read_csr(dd, DC_DC8051_CFG_EXT_DEV_1);
+	if ((reg & DC_DC8051_CFG_EXT_DEV_1_REQ_NEW_SMASK) == 0)
+		return;	/* no request */
+
+	/* zero out COMPLETED so the response is seen */
+	write_csr(dd, DC_DC8051_CFG_EXT_DEV_0, 0);
+
+	/* extract request details */
+	type = (reg >> DC_DC8051_CFG_EXT_DEV_1_REQ_TYPE_SHIFT)
+			& DC_DC8051_CFG_EXT_DEV_1_REQ_TYPE_MASK;
+	data = (reg >> DC_DC8051_CFG_EXT_DEV_1_REQ_DATA_SHIFT)
+			& DC_DC8051_CFG_EXT_DEV_1_REQ_DATA_MASK;
+
+	switch (type) {
+	case HREQ_LOAD_CONFIG:
+	case HREQ_SAVE_CONFIG:
+	case HREQ_READ_CONFIG:
+	case HREQ_SET_TX_EQ_ABS:
+	case HREQ_SET_TX_EQ_REL:
+	case HREQ_ENABLE:
+		dd_dev_info(dd, "8051 request: request 0x%x not supported\n",
+			type);
+		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
+		break;
+
+	case HREQ_CONFIG_DONE:
+		hreq_response(dd, HREQ_SUCCESS, 0);
+		break;
+
+	case HREQ_INTERFACE_TEST:
+		hreq_response(dd, HREQ_SUCCESS, data);
+		break;
+
+	default:
+		dd_dev_err(dd, "8051 request: unknown request 0x%x\n", type);
+		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
+		break;
+	}
+}
+
+static void write_global_credit(struct hfi1_devdata *dd,
+				u8 vau, u16 total, u16 shared)
+{
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT,
+		((u64)total
+			<< SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT)
+		| ((u64)shared
+			<< SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT)
+		| ((u64)vau << SEND_CM_GLOBAL_CREDIT_AU_SHIFT));
+}
+
+/*
+ * Set up initial VL15 credits of the remote.  Assumes the rest of
+ * the CM credit registers are zero from a previous global or credit reset .
+ */
+void set_up_vl15(struct hfi1_devdata *dd, u8 vau, u16 vl15buf)
+{
+	/* leave shared count at zero for both global and VL15 */
+	write_global_credit(dd, vau, vl15buf, 0);
+	write_csr(dd, SEND_CM_CREDIT_VL15, (u64)vl15buf
+		    << SEND_CM_CREDIT_VL15_DEDICATED_LIMIT_VL_SHIFT);
+}
+
+/*
+ * Zero all credit details from the previous connection and
+ * reset the CM manager's internal counters.
+ */
+void reset_link_credits(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* remove all previous VL credit limits */
+	for (i = 0; i < TXE_NUM_DATA_VL; i++)
+		write_csr(dd, SEND_CM_CREDIT_VL + (8*i), 0);
+	write_csr(dd, SEND_CM_CREDIT_VL15, 0);
+	write_global_credit(dd, 0, 0, 0);
+	/* reset the CM block */
+	pio_send_control(dd, PSC_CM_RESET);
+}
+
+/* convert a vCU to a CU */
+static u32 vcu_to_cu(u8 vcu)
+{
+	return 1 << vcu;
+}
+
+/* convert a CU to a vCU */
+static u8 cu_to_vcu(u32 cu)
+{
+	return ilog2(cu);
+}
+
+/* convert a vAU to an AU */
+static u32 vau_to_au(u8 vau)
+{
+	return 8 * (1 << vau);
+}
+
+static void set_linkup_defaults(struct hfi1_pportdata *ppd)
+{
+	ppd->sm_trap_qp = 0x0;
+	ppd->sa_qp = 0x1;
+}
+
+/*
+ * Graceful LCB shutdown.  This leaves the LCB FIFOs in reset.
+ */
+static void lcb_shutdown(struct hfi1_devdata *dd, int abort)
+{
+	u64 reg;
+
+	/* clear lcb run: LCB_CFG_RUN.EN = 0 */
+	write_csr(dd, DC_LCB_CFG_RUN, 0);
+	/* set tx fifo reset: LCB_CFG_TX_FIFOS_RESET.VAL = 1 */
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET,
+		1ull << DC_LCB_CFG_TX_FIFOS_RESET_VAL_SHIFT);
+	/* set dcc reset csr: DCC_CFG_RESET.{reset_lcb,reset_rx_fpe} = 1 */
+	dd->lcb_err_en = read_csr(dd, DC_LCB_ERR_EN);
+	reg = read_csr(dd, DCC_CFG_RESET);
+	write_csr(dd, DCC_CFG_RESET,
+		reg
+		| (1ull << DCC_CFG_RESET_RESET_LCB_SHIFT)
+		| (1ull << DCC_CFG_RESET_RESET_RX_FPE_SHIFT));
+	(void) read_csr(dd, DCC_CFG_RESET); /* make sure the write completed */
+	if (!abort) {
+		udelay(1);    /* must hold for the longer of 16cclks or 20ns */
+		write_csr(dd, DCC_CFG_RESET, reg);
+		write_csr(dd, DC_LCB_ERR_EN, dd->lcb_err_en);
+	}
+}
+
+/*
+ * This routine should be called after the link has been transitioned to
+ * OFFLINE (OFFLINE state has the side effect of putting the SerDes into
+ * reset).
+ *
+ * The expectation is that the caller of this routine would have taken
+ * care of properly transitioning the link into the correct state.
+ */
+static void dc_shutdown(struct hfi1_devdata *dd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->dc8051_lock, flags);
+	if (dd->dc_shutdown) {
+		spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+		return;
+	}
+	dd->dc_shutdown = 1;
+	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+	/* Shutdown the LCB */
+	lcb_shutdown(dd, 1);
+	/* Going to OFFLINE would have causes the 8051 to put the
+	 * SerDes into reset already. Just need to shut down the 8051,
+	 * itself. */
+	write_csr(dd, DC_DC8051_CFG_RST, 0x1);
+}
+
+/* Calling this after the DC has been brought out of reset should not
+ * do any damage. */
+static void dc_start(struct hfi1_devdata *dd)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&dd->dc8051_lock, flags);
+	if (!dd->dc_shutdown)
+		goto done;
+	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+	/* Take the 8051 out of reset */
+	write_csr(dd, DC_DC8051_CFG_RST, 0ull);
+	/* Wait until 8051 is ready */
+	ret = wait_fm_ready(dd, TIMEOUT_8051_START);
+	if (ret) {
+		dd_dev_err(dd, "%s: timeout starting 8051 firmware\n",
+			__func__);
+	}
+	/* Take away reset for LCB and RX FPE (set in lcb_shutdown). */
+	write_csr(dd, DCC_CFG_RESET, 0x10);
+	/* lcb_shutdown() with abort=1 does not restore these */
+	write_csr(dd, DC_LCB_ERR_EN, dd->lcb_err_en);
+	spin_lock_irqsave(&dd->dc8051_lock, flags);
+	dd->dc_shutdown = 0;
+done:
+	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+}
+
+/*
+ * These LCB adjustments are for the Aurora SerDes core in the FPGA.
+ */
+static void adjust_lcb_for_fpga_serdes(struct hfi1_devdata *dd)
+{
+	u64 rx_radr, tx_radr;
+	u32 version;
+
+	if (dd->icode != ICODE_FPGA_EMULATION)
+		return;
+
+	/*
+	 * These LCB defaults on emulator _s are good, nothing to do here:
+	 *	LCB_CFG_TX_FIFOS_RADR
+	 *	LCB_CFG_RX_FIFOS_RADR
+	 *	LCB_CFG_LN_DCLK
+	 *	LCB_CFG_IGNORE_LOST_RCLK
+	 */
+	if (is_emulator_s(dd))
+		return;
+	/* else this is _p */
+
+	version = emulator_rev(dd);
+	if (!is_a0(dd))
+		version = 0x2d;	/* all B0 use 0x2d or higher settings */
+
+	if (version <= 0x12) {
+		/* release 0x12 and below */
+
+		/*
+		 * LCB_CFG_RX_FIFOS_RADR.RST_VAL = 0x9
+		 * LCB_CFG_RX_FIFOS_RADR.OK_TO_JUMP_VAL = 0x9
+		 * LCB_CFG_RX_FIFOS_RADR.DO_NOT_JUMP_VAL = 0xa
+		 */
+		rx_radr =
+		      0xaull << DC_LCB_CFG_RX_FIFOS_RADR_DO_NOT_JUMP_VAL_SHIFT
+		    | 0x9ull << DC_LCB_CFG_RX_FIFOS_RADR_OK_TO_JUMP_VAL_SHIFT
+		    | 0x9ull << DC_LCB_CFG_RX_FIFOS_RADR_RST_VAL_SHIFT;
+		/*
+		 * LCB_CFG_TX_FIFOS_RADR.ON_REINIT = 0 (default)
+		 * LCB_CFG_TX_FIFOS_RADR.RST_VAL = 6
+		 */
+		tx_radr = 6ull << DC_LCB_CFG_TX_FIFOS_RADR_RST_VAL_SHIFT;
+	} else if (version <= 0x18) {
+		/* release 0x13 up to 0x18 */
+		/* LCB_CFG_RX_FIFOS_RADR = 0x988 */
+		rx_radr =
+		      0x9ull << DC_LCB_CFG_RX_FIFOS_RADR_DO_NOT_JUMP_VAL_SHIFT
+		    | 0x8ull << DC_LCB_CFG_RX_FIFOS_RADR_OK_TO_JUMP_VAL_SHIFT
+		    | 0x8ull << DC_LCB_CFG_RX_FIFOS_RADR_RST_VAL_SHIFT;
+		tx_radr = 7ull << DC_LCB_CFG_TX_FIFOS_RADR_RST_VAL_SHIFT;
+	} else if (version == 0x19) {
+		/* release 0x19 */
+		/* LCB_CFG_RX_FIFOS_RADR = 0xa99 */
+		rx_radr =
+		      0xAull << DC_LCB_CFG_RX_FIFOS_RADR_DO_NOT_JUMP_VAL_SHIFT
+		    | 0x9ull << DC_LCB_CFG_RX_FIFOS_RADR_OK_TO_JUMP_VAL_SHIFT
+		    | 0x9ull << DC_LCB_CFG_RX_FIFOS_RADR_RST_VAL_SHIFT;
+		tx_radr = 3ull << DC_LCB_CFG_TX_FIFOS_RADR_RST_VAL_SHIFT;
+	} else if (version == 0x1a) {
+		/* release 0x1a */
+		/* LCB_CFG_RX_FIFOS_RADR = 0x988 */
+		rx_radr =
+		      0x9ull << DC_LCB_CFG_RX_FIFOS_RADR_DO_NOT_JUMP_VAL_SHIFT
+		    | 0x8ull << DC_LCB_CFG_RX_FIFOS_RADR_OK_TO_JUMP_VAL_SHIFT
+		    | 0x8ull << DC_LCB_CFG_RX_FIFOS_RADR_RST_VAL_SHIFT;
+		tx_radr = 7ull << DC_LCB_CFG_TX_FIFOS_RADR_RST_VAL_SHIFT;
+		write_csr(dd, DC_LCB_CFG_LN_DCLK, 1ull);
+	} else {
+		/* release 0x1b and higher */
+		/* LCB_CFG_RX_FIFOS_RADR = 0x877 */
+		rx_radr =
+		      0x8ull << DC_LCB_CFG_RX_FIFOS_RADR_DO_NOT_JUMP_VAL_SHIFT
+		    | 0x7ull << DC_LCB_CFG_RX_FIFOS_RADR_OK_TO_JUMP_VAL_SHIFT
+		    | 0x7ull << DC_LCB_CFG_RX_FIFOS_RADR_RST_VAL_SHIFT;
+		tx_radr = 3ull << DC_LCB_CFG_TX_FIFOS_RADR_RST_VAL_SHIFT;
+	}
+
+	write_csr(dd, DC_LCB_CFG_RX_FIFOS_RADR, rx_radr);
+	/* LCB_CFG_IGNORE_LOST_RCLK.EN = 1 */
+	write_csr(dd, DC_LCB_CFG_IGNORE_LOST_RCLK,
+		DC_LCB_CFG_IGNORE_LOST_RCLK_EN_SMASK);
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RADR, tx_radr);
+}
+
+/*
+ * Handle a SMA idle message
+ *
+ * This is a work-queue function outside of the interrupt.
+ */
+void handle_sma_message(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+							sma_message_work);
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 msg;
+	int ret;
+
+	/* msg is bytes 1-4 of the 40-bit idle message - the command code
+	   is stripped off */
+	ret = read_idle_sma(dd, &msg);
+	if (ret)
+		return;
+	dd_dev_info(dd, "%s: SMA message 0x%llx\n", __func__, msg);
+	/*
+	 * React to the SMA message.  Byte[1] (0 for us) is the command.
+	 */
+	switch (msg & 0xff) {
+	case SMA_IDLE_ARM:
+		/*
+		 * See OPAv1 table 9-14 - HFI and External Switch Ports Key
+		 * State Transitions
+		 *
+		 * Only expected in INIT or ARMED, discard otherwise.
+		 */
+		if (ppd->host_link_state & (HLS_UP_INIT | HLS_UP_ARMED))
+			ppd->neighbor_normal = 1;
+		break;
+	case SMA_IDLE_ACTIVE:
+		/*
+		 * See OPAv1 table 9-14 - HFI and External Switch Ports Key
+		 * State Transitions
+		 *
+		 * Can activate the node.  Discard otherwise.
+		 */
+		if (ppd->host_link_state == HLS_UP_ARMED
+					&& ppd->is_active_optimize_enabled) {
+			ppd->neighbor_normal = 1;
+			ret = set_link_state(ppd, HLS_UP_ACTIVE);
+			if (ret)
+				dd_dev_err(
+					dd,
+					"%s: received Active SMA idle message, couldn't set link to Active\n",
+					__func__);
+		}
+		break;
+	default:
+		dd_dev_err(dd,
+			"%s: received unexpected SMA idle message 0x%llx\n",
+			__func__, msg);
+		break;
+	}
+}
+
+static void adjust_rcvctrl(struct hfi1_devdata *dd, u64 add, u64 clear)
+{
+	u64 rcvctrl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->rcvctrl_lock, flags);
+	rcvctrl = read_csr(dd, RCV_CTRL);
+	rcvctrl |= add;
+	rcvctrl &= ~clear;
+	write_csr(dd, RCV_CTRL, rcvctrl);
+	spin_unlock_irqrestore(&dd->rcvctrl_lock, flags);
+}
+
+static inline void add_rcvctrl(struct hfi1_devdata *dd, u64 add)
+{
+	adjust_rcvctrl(dd, add, 0);
+}
+
+static inline void clear_rcvctrl(struct hfi1_devdata *dd, u64 clear)
+{
+	adjust_rcvctrl(dd, 0, clear);
+}
+
+/*
+ * Called from all interrupt handlers to start handling an SPC freeze.
+ */
+void start_freeze_handling(struct hfi1_pportdata *ppd, int flags)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	struct send_context *sc;
+	int i;
+
+	if (flags & FREEZE_SELF)
+		write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_FREEZE_SMASK);
+
+	/* enter frozen mode */
+	dd->flags |= HFI1_FROZEN;
+
+	/* notify all SDMA engines that they are going into a freeze */
+	sdma_freeze_notify(dd, !!(flags & FREEZE_LINK_DOWN));
+
+	/* do halt pre-handling on all enabled send contexts */
+	for (i = 0; i < dd->num_send_contexts; i++) {
+		sc = dd->send_contexts[i].sc;
+		if (sc && (sc->flags & SCF_ENABLED))
+			sc_stop(sc, SCF_FROZEN | SCF_HALTED);
+	}
+
+	/* Send context are frozen. Notify user space */
+	hfi1_set_uevent_bits(ppd, _HFI1_EVENT_FROZEN_BIT);
+
+	if (flags & FREEZE_ABORT) {
+		dd_dev_err(dd,
+			   "Aborted freeze recovery. Please REBOOT system\n");
+		return;
+	}
+	/* queue non-interrupt handler */
+	queue_work(ppd->hfi1_wq, &ppd->freeze_work);
+}
+
+/*
+ * Wait until all 4 sub-blocks indicate that they have frozen or unfrozen,
+ * depending on the "freeze" parameter.
+ *
+ * No need to return an error if it times out, our only option
+ * is to proceed anyway.
+ */
+static void wait_for_freeze_status(struct hfi1_devdata *dd, int freeze)
+{
+	unsigned long timeout;
+	u64 reg;
+
+	timeout = jiffies + msecs_to_jiffies(FREEZE_STATUS_TIMEOUT);
+	while (1) {
+		reg = read_csr(dd, CCE_STATUS);
+		if (freeze) {
+			/* waiting until all indicators are set */
+			if ((reg & ALL_FROZE) == ALL_FROZE)
+				return;	/* all done */
+		} else {
+			/* waiting until all indicators are clear */
+			if ((reg & ALL_FROZE) == 0)
+				return; /* all done */
+		}
+
+		if (time_after(jiffies, timeout)) {
+			dd_dev_err(dd,
+				"Time out waiting for SPC %sfreeze, bits 0x%llx, expecting 0x%llx, continuing",
+				freeze ? "" : "un",
+				reg & ALL_FROZE,
+				freeze ? ALL_FROZE : 0ull);
+			return;
+		}
+		usleep_range(80, 120);
+	}
+}
+
+/*
+ * Do all freeze handling for the RXE block.
+ */
+static void rxe_freeze(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* disable port */
+	clear_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+
+	/* disable all receive contexts */
+	for (i = 0; i < dd->num_rcv_contexts; i++)
+		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_DIS, i);
+}
+
+/*
+ * Unfreeze handling for the RXE block - kernel contexts only.
+ * This will also enable the port.  User contexts will do unfreeze
+ * handling on a per-context basis as they call into the driver.
+ *
+ */
+static void rxe_kernel_unfreeze(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* enable all kernel contexts */
+	for (i = 0; i < dd->n_krcv_queues; i++)
+		hfi1_rcvctrl(dd, HFI1_RCVCTRL_CTXT_ENB, i);
+
+	/* enable port */
+	add_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+}
+
+/*
+ * Non-interrupt SPC freeze handling.
+ *
+ * This is a work-queue function outside of the triggering interrupt.
+ */
+void handle_freeze(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+								freeze_work);
+	struct hfi1_devdata *dd = ppd->dd;
+
+	/* wait for freeze indicators on all affected blocks */
+	dd_dev_info(dd, "Entering SPC freeze\n");
+	wait_for_freeze_status(dd, 1);
+
+	/* SPC is now frozen */
+
+	/* do send PIO freeze steps */
+	pio_freeze(dd);
+
+	/* do send DMA freeze steps */
+	sdma_freeze(dd);
+
+	/* do send egress freeze steps - nothing to do */
+
+	/* do receive freeze steps */
+	rxe_freeze(dd);
+
+	/*
+	 * Unfreeze the hardware - clear the freeze, wait for each
+	 * block's frozen bit to clear, then clear the frozen flag.
+	 */
+	write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_UNFREEZE_SMASK);
+	wait_for_freeze_status(dd, 0);
+
+	if (is_a0(dd)) {
+		write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_FREEZE_SMASK);
+		wait_for_freeze_status(dd, 1);
+		write_csr(dd, CCE_CTRL, CCE_CTRL_SPC_UNFREEZE_SMASK);
+		wait_for_freeze_status(dd, 0);
+	}
+
+	/* do send PIO unfreeze steps for kernel contexts */
+	pio_kernel_unfreeze(dd);
+
+	/* do send DMA unfreeze steps */
+	sdma_unfreeze(dd);
+
+	/* do send egress unfreeze steps - nothing to do */
+
+	/* do receive unfreeze steps for kernel contexts */
+	rxe_kernel_unfreeze(dd);
+
+	/*
+	 * The unfreeze procedure touches global device registers when
+	 * it disables and re-enables RXE. Mark the device unfrozen
+	 * after all that is done so other parts of the driver waiting
+	 * for the device to unfreeze don't do things out of order.
+	 *
+	 * The above implies that the meaning of HFI1_FROZEN flag is
+	 * "Device has gone into freeze mode and freeze mode handling
+	 * is still in progress."
+	 *
+	 * The flag will be removed when freeze mode processing has
+	 * completed.
+	 */
+	dd->flags &= ~HFI1_FROZEN;
+	wake_up(&dd->event_queue);
+
+	/* no longer frozen */
+	dd_dev_err(dd, "Exiting SPC freeze\n");
+}
+
+/*
+ * Handle a link up interrupt from the 8051.
+ *
+ * This is a work-queue function outside of the interrupt.
+ */
+void handle_link_up(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+								link_up_work);
+	set_link_state(ppd, HLS_UP_INIT);
+
+	/* cache the read of DC_LCB_STS_ROUND_TRIP_LTP_CNT */
+	read_ltp_rtt(ppd->dd);
+	/*
+	 * OPA specifies that certain counters are cleared on a transition
+	 * to link up, so do that.
+	 */
+	clear_linkup_counters(ppd->dd);
+	/*
+	 * And (re)set link up default values.
+	 */
+	set_linkup_defaults(ppd);
+
+	/* enforce link speed enabled */
+	if ((ppd->link_speed_active & ppd->link_speed_enabled) == 0) {
+		/* oops - current speed is not enabled, bounce */
+		dd_dev_err(ppd->dd,
+			"Link speed active 0x%x is outside enabled 0x%x, downing link\n",
+			ppd->link_speed_active, ppd->link_speed_enabled);
+		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SPEED_POLICY, 0,
+			OPA_LINKDOWN_REASON_SPEED_POLICY);
+		set_link_state(ppd, HLS_DN_OFFLINE);
+		start_link(ppd);
+	}
+}
+
+/*
+ * Handle a link down interrupt from the 8051.
+ *
+ * This is a work-queue function outside of the interrupt.
+ */
+void handle_link_down(struct work_struct *work)
+{
+	u8 lcl_reason, neigh_reason = 0;
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+								link_down_work);
+	lcl_reason = 0;
+
+	read_planned_down_reason_code(ppd->dd, &neigh_reason);
+
+	/*
+	 * If no reason, assume peer-initiated but missed
+	 * LinkGoingDown idle flits.
+	 */
+	if (neigh_reason == 0)
+		lcl_reason = OPA_LINKDOWN_REASON_NEIGHBOR_UNKNOWN;
+
+	set_link_down_reason(ppd, lcl_reason, neigh_reason, 0);
+	set_link_state(ppd, HLS_DN_OFFLINE);
+
+	/* disable the port */
+	clear_rcvctrl(ppd->dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+
+	/* If there is no cable attached, turn the DC off. Otherwise,
+	 * start the link bring up. */
+	if (!qsfp_mod_present(ppd))
+		dc_shutdown(ppd->dd);
+	else
+		start_link(ppd);
+}
+
+/*
+ * Mask conversion: Capability exchange to Port LTP.  The capability
+ * exchange has an implicit 16b CRC that is mandatory.
+ */
+static int cap_to_port_ltp(int cap)
+{
+	int port_ltp = PORT_LTP_CRC_MODE_16; /* this mode is mandatory */
+
+	if (cap & CAP_CRC_14B)
+		port_ltp |= PORT_LTP_CRC_MODE_14;
+	if (cap & CAP_CRC_48B)
+		port_ltp |= PORT_LTP_CRC_MODE_48;
+	if (cap & CAP_CRC_12B_16B_PER_LANE)
+		port_ltp |= PORT_LTP_CRC_MODE_PER_LANE;
+
+	return port_ltp;
+}
+
+/*
+ * Convert an OPA Port LTP mask to capability mask
+ */
+int port_ltp_to_cap(int port_ltp)
+{
+	int cap_mask = 0;
+
+	if (port_ltp & PORT_LTP_CRC_MODE_14)
+		cap_mask |= CAP_CRC_14B;
+	if (port_ltp & PORT_LTP_CRC_MODE_48)
+		cap_mask |= CAP_CRC_48B;
+	if (port_ltp & PORT_LTP_CRC_MODE_PER_LANE)
+		cap_mask |= CAP_CRC_12B_16B_PER_LANE;
+
+	return cap_mask;
+}
+
+/*
+ * Convert a single DC LCB CRC mode to an OPA Port LTP mask.
+ */
+static int lcb_to_port_ltp(int lcb_crc)
+{
+	int port_ltp = 0;
+
+	if (lcb_crc == LCB_CRC_12B_16B_PER_LANE)
+		port_ltp = PORT_LTP_CRC_MODE_PER_LANE;
+	else if (lcb_crc == LCB_CRC_48B)
+		port_ltp = PORT_LTP_CRC_MODE_48;
+	else if (lcb_crc == LCB_CRC_14B)
+		port_ltp = PORT_LTP_CRC_MODE_14;
+	else
+		port_ltp = PORT_LTP_CRC_MODE_16;
+
+	return port_ltp;
+}
+
+static int neigh_is_hfi(struct hfi1_pportdata *ppd)
+{
+	return (ppd->neighbor_type & OPA_PI_MASK_NEIGH_NODE_TYPE) == 0;
+}
+
+/*
+ * Our neighbor has indicated that we are allowed to act as a fabric
+ * manager, so place the full management partition key in the second
+ * (0-based) pkey array position (see OPAv1, section 20.2.2.6.8). Note
+ * that we should already have the limited management partition key in
+ * array element 1, and also that the port is not yet up when
+ * add_full_mgmt_pkey() is invoked.
+ */
+static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+
+	/* Sanity check - ppd->pkeys[2] should be 0 */
+	if (ppd->pkeys[2] != 0)
+		dd_dev_err(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
+			   __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
+	ppd->pkeys[2] = FULL_MGMT_P_KEY;
+	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+}
+
+/*
+ * Convert the given link width to the OPA link width bitmask.
+ */
+static u16 link_width_to_bits(struct hfi1_devdata *dd, u16 width)
+{
+	switch (width) {
+	case 1: return OPA_LINK_WIDTH_1X;
+	case 2: return OPA_LINK_WIDTH_2X;
+	case 3: return OPA_LINK_WIDTH_3X;
+	default:
+		/* NOTE: 0 in simulation */
+		dd_dev_info(dd, "%s: invalid width %d, using 4\n",
+			__func__, width);
+		/* fall through */
+	case 4: return OPA_LINK_WIDTH_4X;
+	}
+}
+
+/*
+ * Do a population count on the bottom nibble.
+ */
+static const u8 bit_counts[16] = {
+	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
+};
+static inline u8 nibble_to_count(u8 nibble)
+{
+	return bit_counts[nibble & 0xf];
+}
+
+/*
+ * Read the active lane information from the 8051 registers and return
+ * their widths.
+ *
+ * Active lane information is found in these 8051 registers:
+ *	enable_lane_tx
+ *	enable_lane_rx
+ */
+static void get_link_widths(struct hfi1_devdata *dd, u16 *tx_width,
+			    u16 *rx_width)
+{
+	u16 tx, rx;
+	u8 enable_lane_rx;
+	u8 enable_lane_tx;
+	u8 tx_polarity_inversion;
+	u8 rx_polarity_inversion;
+	u8 max_rate;
+
+	/* read the active lanes */
+	read_tx_settings(dd, &enable_lane_tx, &tx_polarity_inversion,
+				&rx_polarity_inversion, &max_rate);
+	read_local_lni(dd, &enable_lane_rx);
+
+	/* convert to counts */
+	tx = nibble_to_count(enable_lane_tx);
+	rx = nibble_to_count(enable_lane_rx);
+
+	/*
+	 * Remove the setting of link_speed_active in this routine
+	 * when the 8051 firmware is using the "real" LNI and not the
+	 * "engineering" LNI.
+	 *
+	 * Set link_speed_active here, overriding what was set in
+	 * handle_verify_cap().  This is because the 8051 firmware using
+	 * the "engineering" LNI does not correctly set the max_speed field.
+	 * For now, to find the speed, look at max_rate after link up.  This
+	 * routine is called in handle_verify_cap(),after linkup, and during
+	 * a downgrade.  max_rate should not change after linkup so
+	 * re-setting link_speed_active here should not matter.
+	 */
+	if (dd->icode == ICODE_RTL_SILICON) {
+		/* max_rate: 0 = 12.5G, 1 = 25G */
+		switch (max_rate) {
+		case 0:
+			dd->pport[0].link_speed_active = OPA_LINK_SPEED_12_5G;
+			break;
+		default:
+			dd_dev_err(dd,
+				"%s: unexpected max rate %d, using 25Gb\n",
+				__func__, (int)max_rate);
+			/* fall through */
+		case 1:
+			dd->pport[0].link_speed_active = OPA_LINK_SPEED_25G;
+			break;
+		}
+	}
+
+	dd_dev_info(dd,
+		"Fabric active lanes (width): tx 0x%x (%d), rx 0x%x (%d)\n",
+		enable_lane_tx, tx, enable_lane_rx, rx);
+	*tx_width = link_width_to_bits(dd, tx);
+	*rx_width = link_width_to_bits(dd, rx);
+}
+
+/*
+ * Read verify_cap_local_fm_link_width[1] to obtain the link widths.
+ * Valid after the end of VerifyCap and during LinkUp.  Does not change
+ * after link up.  I.e. look elsewhere for downgrade information.
+ *
+ * Bits are:
+ *	+ bits [7:4] contain the number of active transmitters
+ *	+ bits [3:0] contain the number of active receivers
+ * These are numbers 1 through 4 and can be different values if the
+ * link is asymmetric.
+ *
+ * verify_cap_local_fm_link_width[0] retains its original value.
+ */
+static void get_linkup_widths(struct hfi1_devdata *dd, u16 *tx_width,
+			      u16 *rx_width)
+{
+	u16 widths, tx, rx;
+	u8 misc_bits, local_flags;
+	u16 active_tx, active_rx;
+
+	read_vc_local_link_width(dd, &misc_bits, &local_flags, &widths);
+	tx = widths >> 12;
+	rx = (widths >> 8) & 0xf;
+	dd_dev_info(dd, "%s: active tx %d, active rx %d\n", __func__, tx, rx);
+
+	*tx_width = link_width_to_bits(dd, tx);
+	*rx_width = link_width_to_bits(dd, rx);
+
+	/* print the active widths */
+	get_link_widths(dd, &active_tx, &active_rx);
+}
+
+/*
+ * Set ppd->link_width_active and ppd->link_width_downgrade_active using
+ * hardware information when the link first comes up.
+ *
+ * The link width is not available until after VerifyCap.AllFramesReceived
+ * (the trigger for handle_verify_cap), so this is outside that routine
+ * and should be called when the 8051 signals linkup.
+ */
+void get_linkup_link_widths(struct hfi1_pportdata *ppd)
+{
+	u16 tx_width, rx_width;
+
+	/* get end-of-LNI link widths */
+	get_linkup_widths(ppd->dd, &tx_width, &rx_width);
+
+	/* use tx_width as the link is supposed to be symmetric on link up */
+	ppd->link_width_active = tx_width;
+	/* link width downgrade active (LWD.A) starts out matching LW.A */
+	ppd->link_width_downgrade_tx_active = ppd->link_width_active;
+	ppd->link_width_downgrade_rx_active = ppd->link_width_active;
+	/* per OPA spec, on link up LWD.E resets to LWD.S */
+	ppd->link_width_downgrade_enabled = ppd->link_width_downgrade_supported;
+	/* cache the active egress rate (units {10^6 bits/sec]) */
+	ppd->current_egress_rate = active_egress_rate(ppd);
+}
+
+/*
+ * Handle a verify capabilities interrupt from the 8051.
+ *
+ * This is a work-queue function outside of the interrupt.
+ */
+void handle_verify_cap(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+								link_vc_work);
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 reg;
+	u8 power_management;
+	u8 continious;
+	u8 vcu;
+	u8 vau;
+	u8 z;
+	u16 vl15buf;
+	u16 link_widths;
+	u16 crc_mask;
+	u16 crc_val;
+	u16 device_id;
+	u16 active_tx, active_rx;
+	u8 partner_supported_crc;
+	u8 remote_tx_rate;
+	u8 device_rev;
+
+	set_link_state(ppd, HLS_VERIFY_CAP);
+
+	lcb_shutdown(dd, 0);
+	adjust_lcb_for_fpga_serdes(dd);
+
+	/*
+	 * These are now valid:
+	 *	remote VerifyCap fields in the general LNI config
+	 *	CSR DC8051_STS_REMOTE_GUID
+	 *	CSR DC8051_STS_REMOTE_NODE_TYPE
+	 *	CSR DC8051_STS_REMOTE_FM_SECURITY
+	 */
+	read_vc_remote_phy(dd, &power_management, &continious);
+	read_vc_remote_fabric(
+		dd,
+		&vau,
+		&z,
+		&vcu,
+		&vl15buf,
+		&partner_supported_crc);
+	read_vc_remote_link_width(dd, &remote_tx_rate, &link_widths);
+	read_remote_device_id(dd, &device_id, &device_rev);
+	/*
+	 * And the 'MgmtAllowed' information, which is exchanged during
+	 * LNI, is also be available at this point.
+	 */
+	read_mgmt_allowed(dd, &ppd->mgmt_allowed);
+	/* print the active widths */
+	get_link_widths(dd, &active_tx, &active_rx);
+	dd_dev_info(dd,
+		"Peer PHY: power management 0x%x, continuous updates 0x%x\n",
+		(int)power_management, (int)continious);
+	dd_dev_info(dd,
+		"Peer Fabric: vAU %d, Z %d, vCU %d, vl15 credits 0x%x, CRC sizes 0x%x\n",
+		(int)vau,
+		(int)z,
+		(int)vcu,
+		(int)vl15buf,
+		(int)partner_supported_crc);
+	dd_dev_info(dd, "Peer Link Width: tx rate 0x%x, widths 0x%x\n",
+		(u32)remote_tx_rate, (u32)link_widths);
+	dd_dev_info(dd, "Peer Device ID: 0x%04x, Revision 0x%02x\n",
+		(u32)device_id, (u32)device_rev);
+	/*
+	 * The peer vAU value just read is the peer receiver value.  HFI does
+	 * not support a transmit vAU of 0 (AU == 8).  We advertised that
+	 * with Z=1 in the fabric capabilities sent to the peer.  The peer
+	 * will see our Z=1, and, if it advertised a vAU of 0, will move its
+	 * receive to vAU of 1 (AU == 16).  Do the same here.  We do not care
+	 * about the peer Z value - our sent vAU is 3 (hardwired) and is not
+	 * subject to the Z value exception.
+	 */
+	if (vau == 0)
+		vau = 1;
+	set_up_vl15(dd, vau, vl15buf);
+
+	/* set up the LCB CRC mode */
+	crc_mask = ppd->port_crc_mode_enabled & partner_supported_crc;
+
+	/* order is important: use the lowest bit in common */
+	if (crc_mask & CAP_CRC_14B)
+		crc_val = LCB_CRC_14B;
+	else if (crc_mask & CAP_CRC_48B)
+		crc_val = LCB_CRC_48B;
+	else if (crc_mask & CAP_CRC_12B_16B_PER_LANE)
+		crc_val = LCB_CRC_12B_16B_PER_LANE;
+	else
+		crc_val = LCB_CRC_16B;
+
+	dd_dev_info(dd, "Final LCB CRC mode: %d\n", (int)crc_val);
+	write_csr(dd, DC_LCB_CFG_CRC_MODE,
+		  (u64)crc_val << DC_LCB_CFG_CRC_MODE_TX_VAL_SHIFT);
+
+	/* set (14b only) or clear sideband credit */
+	reg = read_csr(dd, SEND_CM_CTRL);
+	if (crc_val == LCB_CRC_14B && crc_14b_sideband) {
+		write_csr(dd, SEND_CM_CTRL,
+			reg | SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK);
+	} else {
+		write_csr(dd, SEND_CM_CTRL,
+			reg & ~SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK);
+	}
+
+	/* remote_tx_rate: 0 = 12.5G, 1 = 25G */
+	switch (remote_tx_rate) {
+	case 0:
+		ppd->link_speed_active = OPA_LINK_SPEED_12_5G;
+		break;
+	default:
+		dd_dev_err(dd, "%s: unexpected remote tx rate %d, using 25Gb\n",
+			__func__, (int)remote_tx_rate);
+		/* fall through */
+	case 1:
+		ppd->link_speed_active = OPA_LINK_SPEED_25G;
+		break;
+	}
+
+	/*
+	 * Cache the values of the supported, enabled, and active
+	 * LTP CRC modes to return in 'portinfo' queries. But the bit
+	 * flags that are returned in the portinfo query differ from
+	 * what's in the link_crc_mask, crc_sizes, and crc_val
+	 * variables. Convert these here.
+	 */
+	ppd->port_ltp_crc_mode = cap_to_port_ltp(link_crc_mask) << 8;
+		/* supported crc modes */
+	ppd->port_ltp_crc_mode |=
+		cap_to_port_ltp(ppd->port_crc_mode_enabled) << 4;
+		/* enabled crc modes */
+	ppd->port_ltp_crc_mode |= lcb_to_port_ltp(crc_val);
+		/* active crc mode */
+
+	/* set up the remote credit return table */
+	assign_remote_cm_au_table(dd, vcu);
+
+	/*
+	 * The LCB is reset on entry to handle_verify_cap(), so this must
+	 * be applied on every link up.
+	 *
+	 * Adjust LCB error kill enable to kill the link if
+	 * these RBUF errors are seen:
+	 *	REPLAY_BUF_MBE_SMASK
+	 *	FLIT_INPUT_BUF_MBE_SMASK
+	 */
+	if (is_a0(dd)) {			/* fixed in B0 */
+		reg = read_csr(dd, DC_LCB_CFG_LINK_KILL_EN);
+		reg |= DC_LCB_CFG_LINK_KILL_EN_REPLAY_BUF_MBE_SMASK
+			| DC_LCB_CFG_LINK_KILL_EN_FLIT_INPUT_BUF_MBE_SMASK;
+		write_csr(dd, DC_LCB_CFG_LINK_KILL_EN, reg);
+	}
+
+	/* pull LCB fifos out of reset - all fifo clocks must be stable */
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 0);
+
+	/* give 8051 access to the LCB CSRs */
+	write_csr(dd, DC_LCB_ERR_EN, 0); /* mask LCB errors */
+	set_8051_lcb_access(dd);
+
+	ppd->neighbor_guid =
+		cpu_to_be64(read_csr(dd, DC_DC8051_STS_REMOTE_GUID));
+	ppd->neighbor_type =
+		read_csr(dd, DC_DC8051_STS_REMOTE_NODE_TYPE) &
+		DC_DC8051_STS_REMOTE_NODE_TYPE_VAL_MASK;
+	ppd->neighbor_fm_security =
+		read_csr(dd, DC_DC8051_STS_REMOTE_FM_SECURITY) &
+		DC_DC8051_STS_LOCAL_FM_SECURITY_DISABLED_MASK;
+	dd_dev_info(dd, "Neighbor Guid: %llx Neighbor type %d MgmtAllowed %d FM security bypass %d\n",
+		be64_to_cpu(ppd->neighbor_guid), ppd->neighbor_type,
+		ppd->mgmt_allowed, ppd->neighbor_fm_security);
+	if (neigh_is_hfi(ppd))
+		ppd->part_enforce =
+			HFI1_PART_ENFORCE_IN | HFI1_PART_ENFORCE_OUT;
+	if (ppd->mgmt_allowed)
+		add_full_mgmt_pkey(ppd);
+
+	/* tell the 8051 to go to LinkUp */
+	set_link_state(ppd, HLS_GOING_UP);
+}
+
+/*
+ * Apply the link width downgrade enabled policy against the current active
+ * link widths.
+ *
+ * Called when the enabled policy changes or the active link widths change.
+ */
+void apply_link_downgrade_policy(struct hfi1_pportdata *ppd, int refresh_widths)
+{
+	int skip = 1;
+	int do_bounce = 0;
+	u16 lwde = ppd->link_width_downgrade_enabled;
+	u16 tx, rx;
+
+	mutex_lock(&ppd->hls_lock);
+	/* only apply if the link is up */
+	if (ppd->host_link_state & HLS_UP)
+		skip = 0;
+	mutex_unlock(&ppd->hls_lock);
+	if (skip)
+		return;
+
+	if (refresh_widths) {
+		get_link_widths(ppd->dd, &tx, &rx);
+		ppd->link_width_downgrade_tx_active = tx;
+		ppd->link_width_downgrade_rx_active = rx;
+	}
+
+	if (lwde == 0) {
+		/* downgrade is disabled */
+
+		/* bounce if not at starting active width */
+		if ((ppd->link_width_active !=
+					ppd->link_width_downgrade_tx_active)
+				|| (ppd->link_width_active !=
+					ppd->link_width_downgrade_rx_active)) {
+			dd_dev_err(ppd->dd,
+				"Link downgrade is disabled and link has downgraded, downing link\n");
+			dd_dev_err(ppd->dd,
+				"  original 0x%x, tx active 0x%x, rx active 0x%x\n",
+				ppd->link_width_active,
+				ppd->link_width_downgrade_tx_active,
+				ppd->link_width_downgrade_rx_active);
+			do_bounce = 1;
+		}
+	} else if ((lwde & ppd->link_width_downgrade_tx_active) == 0
+		|| (lwde & ppd->link_width_downgrade_rx_active) == 0) {
+		/* Tx or Rx is outside the enabled policy */
+		dd_dev_err(ppd->dd,
+			"Link is outside of downgrade allowed, downing link\n");
+		dd_dev_err(ppd->dd,
+			"  enabled 0x%x, tx active 0x%x, rx active 0x%x\n",
+			lwde,
+			ppd->link_width_downgrade_tx_active,
+			ppd->link_width_downgrade_rx_active);
+		do_bounce = 1;
+	}
+
+	if (do_bounce) {
+		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_WIDTH_POLICY, 0,
+		  OPA_LINKDOWN_REASON_WIDTH_POLICY);
+		set_link_state(ppd, HLS_DN_OFFLINE);
+		start_link(ppd);
+	}
+}
+
+/*
+ * Handle a link downgrade interrupt from the 8051.
+ *
+ * This is a work-queue function outside of the interrupt.
+ */
+void handle_link_downgrade(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+							link_downgrade_work);
+
+	dd_dev_info(ppd->dd, "8051: Link width downgrade\n");
+	apply_link_downgrade_policy(ppd, 1);
+}
+
+static char *dcc_err_string(char *buf, int buf_len, u64 flags)
+{
+	return flag_string(buf, buf_len, flags, dcc_err_flags,
+		ARRAY_SIZE(dcc_err_flags));
+}
+
+static char *lcb_err_string(char *buf, int buf_len, u64 flags)
+{
+	return flag_string(buf, buf_len, flags, lcb_err_flags,
+		ARRAY_SIZE(lcb_err_flags));
+}
+
+static char *dc8051_err_string(char *buf, int buf_len, u64 flags)
+{
+	return flag_string(buf, buf_len, flags, dc8051_err_flags,
+		ARRAY_SIZE(dc8051_err_flags));
+}
+
+static char *dc8051_info_err_string(char *buf, int buf_len, u64 flags)
+{
+	return flag_string(buf, buf_len, flags, dc8051_info_err_flags,
+		ARRAY_SIZE(dc8051_info_err_flags));
+}
+
+static char *dc8051_info_host_msg_string(char *buf, int buf_len, u64 flags)
+{
+	return flag_string(buf, buf_len, flags, dc8051_info_host_msg_flags,
+		ARRAY_SIZE(dc8051_info_host_msg_flags));
+}
+
+static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+	u64 info, err, host_msg;
+	int queue_link_down = 0;
+	char buf[96];
+
+	/* look at the flags */
+	if (reg & DC_DC8051_ERR_FLG_SET_BY_8051_SMASK) {
+		/* 8051 information set by firmware */
+		/* read DC8051_DBG_ERR_INFO_SET_BY_8051 for details */
+		info = read_csr(dd, DC_DC8051_DBG_ERR_INFO_SET_BY_8051);
+		err = (info >> DC_DC8051_DBG_ERR_INFO_SET_BY_8051_ERROR_SHIFT)
+			& DC_DC8051_DBG_ERR_INFO_SET_BY_8051_ERROR_MASK;
+		host_msg = (info >>
+			DC_DC8051_DBG_ERR_INFO_SET_BY_8051_HOST_MSG_SHIFT)
+			& DC_DC8051_DBG_ERR_INFO_SET_BY_8051_HOST_MSG_MASK;
+
+		/*
+		 * Handle error flags.
+		 */
+		if (err & FAILED_LNI) {
+			/*
+			 * LNI error indications are cleared by the 8051
+			 * only when starting polling.  Only pay attention
+			 * to them when in the states that occur during
+			 * LNI.
+			 */
+			if (ppd->host_link_state
+			    & (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) {
+				queue_link_down = 1;
+				dd_dev_info(dd, "Link error: %s\n",
+					dc8051_info_err_string(buf,
+						sizeof(buf),
+						err & FAILED_LNI));
+			}
+			err &= ~(u64)FAILED_LNI;
+		}
+		if (err) {
+			/* report remaining errors, but do not do anything */
+			dd_dev_err(dd, "8051 info error: %s\n",
+				dc8051_info_err_string(buf, sizeof(buf), err));
+		}
+
+		/*
+		 * Handle host message flags.
+		 */
+		if (host_msg & HOST_REQ_DONE) {
+			/*
+			 * Presently, the driver does a busy wait for
+			 * host requests to complete.  This is only an
+			 * informational message.
+			 * NOTE: The 8051 clears the host message
+			 * information *on the next 8051 command*.
+			 * Therefore, when linkup is achieved,
+			 * this flag will still be set.
+			 */
+			host_msg &= ~(u64)HOST_REQ_DONE;
+		}
+		if (host_msg & BC_SMA_MSG) {
+			queue_work(ppd->hfi1_wq, &ppd->sma_message_work);
+			host_msg &= ~(u64)BC_SMA_MSG;
+		}
+		if (host_msg & LINKUP_ACHIEVED) {
+			dd_dev_info(dd, "8051: Link up\n");
+			queue_work(ppd->hfi1_wq, &ppd->link_up_work);
+			host_msg &= ~(u64)LINKUP_ACHIEVED;
+		}
+		if (host_msg & EXT_DEVICE_CFG_REQ) {
+			handle_8051_request(dd);
+			host_msg &= ~(u64)EXT_DEVICE_CFG_REQ;
+		}
+		if (host_msg & VERIFY_CAP_FRAME) {
+			queue_work(ppd->hfi1_wq, &ppd->link_vc_work);
+			host_msg &= ~(u64)VERIFY_CAP_FRAME;
+		}
+		if (host_msg & LINK_GOING_DOWN) {
+			const char *extra = "";
+			/* no downgrade action needed if going down */
+			if (host_msg & LINK_WIDTH_DOWNGRADED) {
+				host_msg &= ~(u64)LINK_WIDTH_DOWNGRADED;
+				extra = " (ignoring downgrade)";
+			}
+			dd_dev_info(dd, "8051: Link down%s\n", extra);
+			queue_link_down = 1;
+			host_msg &= ~(u64)LINK_GOING_DOWN;
+		}
+		if (host_msg & LINK_WIDTH_DOWNGRADED) {
+			queue_work(ppd->hfi1_wq, &ppd->link_downgrade_work);
+			host_msg &= ~(u64)LINK_WIDTH_DOWNGRADED;
+		}
+		if (host_msg) {
+			/* report remaining messages, but do not do anything */
+			dd_dev_info(dd, "8051 info host message: %s\n",
+				dc8051_info_host_msg_string(buf, sizeof(buf),
+					host_msg));
+		}
+
+		reg &= ~DC_DC8051_ERR_FLG_SET_BY_8051_SMASK;
+	}
+	if (reg & DC_DC8051_ERR_FLG_LOST_8051_HEART_BEAT_SMASK) {
+		/*
+		 * Lost the 8051 heartbeat.  If this happens, we
+		 * receive constant interrupts about it.  Disable
+		 * the interrupt after the first.
+		 */
+		dd_dev_err(dd, "Lost 8051 heartbeat\n");
+		write_csr(dd, DC_DC8051_ERR_EN,
+			read_csr(dd, DC_DC8051_ERR_EN)
+			  & ~DC_DC8051_ERR_EN_LOST_8051_HEART_BEAT_SMASK);
+
+		reg &= ~DC_DC8051_ERR_FLG_LOST_8051_HEART_BEAT_SMASK;
+	}
+	if (reg) {
+		/* report the error, but do not do anything */
+		dd_dev_err(dd, "8051 error: %s\n",
+			dc8051_err_string(buf, sizeof(buf), reg));
+	}
+
+	if (queue_link_down) {
+		/* if the link is already going down or disabled, do not
+		 * queue another */
+		if ((ppd->host_link_state
+				    & (HLS_GOING_OFFLINE|HLS_LINK_COOLDOWN))
+				|| ppd->link_enabled == 0) {
+			dd_dev_info(dd, "%s: not queuing link down\n",
+				__func__);
+		} else {
+			queue_work(ppd->hfi1_wq, &ppd->link_down_work);
+		}
+	}
+}
+
+static const char * const fm_config_txt[] = {
+[0] =
+	"BadHeadDist: Distance violation between two head flits",
+[1] =
+	"BadTailDist: Distance violation between two tail flits",
+[2] =
+	"BadCtrlDist: Distance violation between two credit control flits",
+[3] =
+	"BadCrdAck: Credits return for unsupported VL",
+[4] =
+	"UnsupportedVLMarker: Received VL Marker",
+[5] =
+	"BadPreempt: Exceeded the preemption nesting level",
+[6] =
+	"BadControlFlit: Received unsupported control flit",
+/* no 7 */
+[8] =
+	"UnsupportedVLMarker: Received VL Marker for unconfigured or disabled VL",
+};
+
+static const char * const port_rcv_txt[] = {
+[1] =
+	"BadPktLen: Illegal PktLen",
+[2] =
+	"PktLenTooLong: Packet longer than PktLen",
+[3] =
+	"PktLenTooShort: Packet shorter than PktLen",
+[4] =
+	"BadSLID: Illegal SLID (0, using multicast as SLID, does not include security validation of SLID)",
+[5] =
+	"BadDLID: Illegal DLID (0, doesn't match HFI)",
+[6] =
+	"BadL2: Illegal L2 opcode",
+[7] =
+	"BadSC: Unsupported SC",
+[9] =
+	"BadRC: Illegal RC",
+[11] =
+	"PreemptError: Preempting with same VL",
+[12] =
+	"PreemptVL15: Preempting a VL15 packet",
+[13] =
+	"BadVLMarker: VL Marker for an unpreempted VL",
+};
+
+#define OPA_LDR_FMCONFIG_OFFSET 16
+#define OPA_LDR_PORTRCV_OFFSET 0
+static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	u64 info, hdr0, hdr1;
+	const char *extra;
+	char buf[96];
+	struct hfi1_pportdata *ppd = dd->pport;
+	u8 lcl_reason = 0;
+	int do_bounce = 0;
+
+	if (reg & DCC_ERR_FLG_UNCORRECTABLE_ERR_SMASK) {
+		if (!(dd->err_info_uncorrectable & OPA_EI_STATUS_SMASK)) {
+			info = read_csr(dd, DCC_ERR_INFO_UNCORRECTABLE);
+			dd->err_info_uncorrectable = info & OPA_EI_CODE_SMASK;
+			/* set status bit */
+			dd->err_info_uncorrectable |= OPA_EI_STATUS_SMASK;
+		}
+		reg &= ~DCC_ERR_FLG_UNCORRECTABLE_ERR_SMASK;
+	}
+
+	if (reg & DCC_ERR_FLG_LINK_ERR_SMASK) {
+		struct hfi1_pportdata *ppd = dd->pport;
+		/* this counter saturates at (2^32) - 1 */
+		if (ppd->link_downed < (u32)UINT_MAX)
+			ppd->link_downed++;
+		reg &= ~DCC_ERR_FLG_LINK_ERR_SMASK;
+	}
+
+	if (reg & DCC_ERR_FLG_FMCONFIG_ERR_SMASK) {
+		u8 reason_valid = 1;
+
+		info = read_csr(dd, DCC_ERR_INFO_FMCONFIG);
+		if (!(dd->err_info_fmconfig & OPA_EI_STATUS_SMASK)) {
+			dd->err_info_fmconfig = info & OPA_EI_CODE_SMASK;
+			/* set status bit */
+			dd->err_info_fmconfig |= OPA_EI_STATUS_SMASK;
+		}
+		switch (info) {
+		case 0:
+		case 1:
+		case 2:
+		case 3:
+		case 4:
+		case 5:
+		case 6:
+			extra = fm_config_txt[info];
+			break;
+		case 8:
+			extra = fm_config_txt[info];
+			if (!do_bounce && ppd->port_error_action &
+			    OPA_PI_MASK_FM_CFG_UNSUPPORTED_VL_MARKER) {
+				do_bounce = 1;
+				/*
+				 * lcl_reason cannot be derived from info
+				 * for this error
+				 */
+				lcl_reason =
+				  OPA_LINKDOWN_REASON_UNSUPPORTED_VL_MARKER;
+			}
+			break;
+		default:
+			reason_valid = 0;
+			snprintf(buf, sizeof(buf), "reserved%lld", info);
+			extra = buf;
+			break;
+		}
+
+		if (reason_valid && !do_bounce) {
+			do_bounce = ppd->port_error_action &
+			(1 << (OPA_LDR_FMCONFIG_OFFSET + info));
+			lcl_reason = (lcl_reason ? lcl_reason :
+			  info + OPA_LINKDOWN_REASON_BAD_HEAD_DIST);
+		}
+
+		/* just report this */
+		dd_dev_info(dd, "DCC Error: fmconfig error: %s\n", extra);
+		reg &= ~DCC_ERR_FLG_FMCONFIG_ERR_SMASK;
+	}
+
+	if (reg & DCC_ERR_FLG_RCVPORT_ERR_SMASK) {
+		u8 reason_valid = 1;
+
+		info = read_csr(dd, DCC_ERR_INFO_PORTRCV);
+		hdr0 = read_csr(dd, DCC_ERR_INFO_PORTRCV_HDR0);
+		hdr1 = read_csr(dd, DCC_ERR_INFO_PORTRCV_HDR1);
+		if (!(dd->err_info_rcvport.status_and_code &
+		      OPA_EI_STATUS_SMASK)) {
+			dd->err_info_rcvport.status_and_code =
+				info & OPA_EI_CODE_SMASK;
+			/* set status bit */
+			dd->err_info_rcvport.status_and_code |=
+				OPA_EI_STATUS_SMASK;
+			/* save first 2 flits in the packet that caused
+			 * the error */
+			 dd->err_info_rcvport.packet_flit1 = hdr0;
+			 dd->err_info_rcvport.packet_flit2 = hdr1;
+		}
+		switch (info & 0xf) {
+		case 1:
+		case 2:
+		case 3:
+		case 4:
+		case 5:
+		case 6:
+		case 7:
+		case 9:
+		case 11:
+		case 12:
+		case 13:
+			extra = port_rcv_txt[info & 0xf];
+			break;
+		default:
+			reason_valid = 0;
+			snprintf(buf, sizeof(buf), "reserved%lld", info);
+			extra = buf;
+			break;
+		}
+
+		if (reason_valid && !do_bounce) {
+			do_bounce = ppd->port_error_action &
+			  (1 << ((info & 0xf) + OPA_LDR_PORTRCV_OFFSET));
+			lcl_reason =
+			  (info & 0xf) + OPA_LINKDOWN_REASON_RCV_ERROR_0;
+		}
+
+		/* just report this */
+		dd_dev_info(dd, "DCC Error: PortRcv error: %s\n", extra);
+		dd_dev_info(dd, "           hdr0 0x%llx, hdr1 0x%llx\n",
+			hdr0, hdr1);
+
+		reg &= ~DCC_ERR_FLG_RCVPORT_ERR_SMASK;
+	}
+
+	if (reg & DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_UC_SMASK) {
+		/* informative only */
+		dd_dev_info(dd, "8051 access to LCB blocked\n");
+		reg &= ~DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_UC_SMASK;
+	}
+	if (reg & DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_HOST_SMASK) {
+		/* informative only */
+		dd_dev_info(dd, "host access to LCB blocked\n");
+		reg &= ~DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_HOST_SMASK;
+	}
+
+	/* report any remaining errors */
+	if (reg)
+		dd_dev_info(dd, "DCC Error: %s\n",
+			dcc_err_string(buf, sizeof(buf), reg));
+
+	if (lcl_reason == 0)
+		lcl_reason = OPA_LINKDOWN_REASON_UNKNOWN;
+
+	if (do_bounce) {
+		dd_dev_info(dd, "%s: PortErrorAction bounce\n", __func__);
+		set_link_down_reason(ppd, lcl_reason, 0, lcl_reason);
+		start_link(ppd);
+	}
+}
+
+static void handle_lcb_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
+{
+	char buf[96];
+
+	dd_dev_info(dd, "LCB Error: %s\n",
+		lcb_err_string(buf, sizeof(buf), reg));
+}
+
+/*
+ * CCE block DC interrupt.  Source is < 8.
+ */
+static void is_dc_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	const struct err_reg_info *eri = &dc_errs[source];
+
+	if (eri->handler) {
+		interrupt_clear_down(dd, 0, eri);
+	} else if (source == 3 /* dc_lbm_int */) {
+		/*
+		 * This indicates that a parity error has occurred on the
+		 * address/control lines presented to the LBM.  The error
+		 * is a single pulse, there is no associated error flag,
+		 * and it is non-maskable.  This is because if a parity
+		 * error occurs on the request the request is dropped.
+		 * This should never occur, but it is nice to know if it
+		 * ever does.
+		 */
+		dd_dev_err(dd, "Parity error in DC LBM block\n");
+	} else {
+		dd_dev_err(dd, "Invalid DC interrupt %u\n", source);
+	}
+}
+
+/*
+ * TX block send credit interrupt.  Source is < 160.
+ */
+static void is_send_credit_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	sc_group_release_update(dd, source);
+}
+
+/*
+ * TX block SDMA interrupt.  Source is < 48.
+ *
+ * SDMA interrupts are grouped by type:
+ *
+ *	 0 -  N-1 = SDma
+ *	 N - 2N-1 = SDmaProgress
+ *	2N - 3N-1 = SDmaIdle
+ */
+static void is_sdma_eng_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	/* what interrupt */
+	unsigned int what  = source / TXE_NUM_SDMA_ENGINES;
+	/* which engine */
+	unsigned int which = source % TXE_NUM_SDMA_ENGINES;
+
+#ifdef CONFIG_SDMA_VERBOSITY
+	dd_dev_err(dd, "CONFIG SDMA(%u) %s:%d %s()\n", which,
+		   slashstrip(__FILE__), __LINE__, __func__);
+	sdma_dumpstate(&dd->per_sdma[which]);
+#endif
+
+	if (likely(what < 3 && which < dd->num_sdma)) {
+		sdma_engine_interrupt(&dd->per_sdma[which], 1ull << source);
+	} else {
+		/* should not happen */
+		dd_dev_err(dd, "Invalid SDMA interrupt 0x%x\n", source);
+	}
+}
+
+/*
+ * RX block receive available interrupt.  Source is < 160.
+ */
+static void is_rcv_avail_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	struct hfi1_ctxtdata *rcd;
+	char *err_detail;
+
+	if (likely(source < dd->num_rcv_contexts)) {
+		rcd = dd->rcd[source];
+		if (rcd) {
+			if (source < dd->first_user_ctxt)
+				rcd->do_interrupt(rcd);
+			else
+				handle_user_interrupt(rcd);
+			return;	/* OK */
+		}
+		/* received an interrupt, but no rcd */
+		err_detail = "dataless";
+	} else {
+		/* received an interrupt, but are not using that context */
+		err_detail = "out of range";
+	}
+	dd_dev_err(dd, "unexpected %s receive available context interrupt %u\n",
+		err_detail, source);
+}
+
+/*
+ * RX block receive urgent interrupt.  Source is < 160.
+ */
+static void is_rcv_urgent_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	struct hfi1_ctxtdata *rcd;
+	char *err_detail;
+
+	if (likely(source < dd->num_rcv_contexts)) {
+		rcd = dd->rcd[source];
+		if (rcd) {
+			/* only pay attention to user urgent interrupts */
+			if (source >= dd->first_user_ctxt)
+				handle_user_interrupt(rcd);
+			return;	/* OK */
+		}
+		/* received an interrupt, but no rcd */
+		err_detail = "dataless";
+	} else {
+		/* received an interrupt, but are not using that context */
+		err_detail = "out of range";
+	}
+	dd_dev_err(dd, "unexpected %s receive urgent context interrupt %u\n",
+		err_detail, source);
+}
+
+/*
+ * Reserved range interrupt.  Should not be called in normal operation.
+ */
+static void is_reserved_int(struct hfi1_devdata *dd, unsigned int source)
+{
+	char name[64];
+
+	dd_dev_err(dd, "unexpected %s interrupt\n",
+				is_reserved_name(name, sizeof(name), source));
+}
+
+static const struct is_table is_table[] = {
+/* start		     end
+				name func		interrupt func */
+{ IS_GENERAL_ERR_START,  IS_GENERAL_ERR_END,
+				is_misc_err_name,	is_misc_err_int },
+{ IS_SDMAENG_ERR_START,  IS_SDMAENG_ERR_END,
+				is_sdma_eng_err_name,	is_sdma_eng_err_int },
+{ IS_SENDCTXT_ERR_START, IS_SENDCTXT_ERR_END,
+				is_sendctxt_err_name,	is_sendctxt_err_int },
+{ IS_SDMA_START,	     IS_SDMA_END,
+				is_sdma_eng_name,	is_sdma_eng_int },
+{ IS_VARIOUS_START,	     IS_VARIOUS_END,
+				is_various_name,	is_various_int },
+{ IS_DC_START,	     IS_DC_END,
+				is_dc_name,		is_dc_int },
+{ IS_RCVAVAIL_START,     IS_RCVAVAIL_END,
+				is_rcv_avail_name,	is_rcv_avail_int },
+{ IS_RCVURGENT_START,    IS_RCVURGENT_END,
+				is_rcv_urgent_name,	is_rcv_urgent_int },
+{ IS_SENDCREDIT_START,   IS_SENDCREDIT_END,
+				is_send_credit_name,	is_send_credit_int},
+{ IS_RESERVED_START,     IS_RESERVED_END,
+				is_reserved_name,	is_reserved_int},
+};
+
+/*
+ * Interrupt source interrupt - called when the given source has an interrupt.
+ * Source is a bit index into an array of 64-bit integers.
+ */
+static void is_interrupt(struct hfi1_devdata *dd, unsigned int source)
+{
+	const struct is_table *entry;
+
+	/* avoids a double compare by walking the table in-order */
+	for (entry = &is_table[0]; entry->is_name; entry++) {
+		if (source < entry->end) {
+			trace_hfi1_interrupt(dd, entry, source);
+			entry->is_int(dd, source - entry->start);
+			return;
+		}
+	}
+	/* fell off the end */
+	dd_dev_err(dd, "invalid interrupt source %u\n", source);
+}
+
+/*
+ * General interrupt handler.  This is able to correctly handle
+ * all interrupts in case INTx is used.
+ */
+static irqreturn_t general_interrupt(int irq, void *data)
+{
+	struct hfi1_devdata *dd = data;
+	u64 regs[CCE_NUM_INT_CSRS];
+	u32 bit;
+	int i;
+
+	this_cpu_inc(*dd->int_counter);
+
+	/* phase 1: scan and clear all handled interrupts */
+	for (i = 0; i < CCE_NUM_INT_CSRS; i++) {
+		if (dd->gi_mask[i] == 0) {
+			regs[i] = 0;	/* used later */
+			continue;
+		}
+		regs[i] = read_csr(dd, CCE_INT_STATUS + (8 * i)) &
+				dd->gi_mask[i];
+		/* only clear if anything is set */
+		if (regs[i])
+			write_csr(dd, CCE_INT_CLEAR + (8 * i), regs[i]);
+	}
+
+	/* phase 2: call the appropriate handler */
+	for_each_set_bit(bit, (unsigned long *)&regs[0],
+						CCE_NUM_INT_CSRS*64) {
+		is_interrupt(dd, bit);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t sdma_interrupt(int irq, void *data)
+{
+	struct sdma_engine *sde = data;
+	struct hfi1_devdata *dd = sde->dd;
+	u64 status;
+
+#ifdef CONFIG_SDMA_VERBOSITY
+	dd_dev_err(dd, "CONFIG SDMA(%u) %s:%d %s()\n", sde->this_idx,
+		   slashstrip(__FILE__), __LINE__, __func__);
+	sdma_dumpstate(sde);
+#endif
+
+	this_cpu_inc(*dd->int_counter);
+
+	/* This read_csr is really bad in the hot path */
+	status = read_csr(dd,
+			CCE_INT_STATUS + (8*(IS_SDMA_START/64)))
+			& sde->imask;
+	if (likely(status)) {
+		/* clear the interrupt(s) */
+		write_csr(dd,
+			CCE_INT_CLEAR + (8*(IS_SDMA_START/64)),
+			status);
+
+		/* handle the interrupt(s) */
+		sdma_engine_interrupt(sde, status);
+	} else
+		dd_dev_err(dd, "SDMA engine %u interrupt, but no status bits set\n",
+			sde->this_idx);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * NOTE: this routine expects to be on its own MSI-X interrupt.  If
+ * multiple receive contexts share the same MSI-X interrupt, then this
+ * routine must check for who received it.
+ */
+static irqreturn_t receive_context_interrupt(int irq, void *data)
+{
+	struct hfi1_ctxtdata *rcd = data;
+	struct hfi1_devdata *dd = rcd->dd;
+
+	trace_hfi1_receive_interrupt(dd, rcd->ctxt);
+	this_cpu_inc(*dd->int_counter);
+
+	/* clear the interrupt */
+	write_csr(rcd->dd, CCE_INT_CLEAR + (8*rcd->ireg), rcd->imask);
+
+	/* handle the interrupt */
+	rcd->do_interrupt(rcd);
+
+	return IRQ_HANDLED;
+}
+
+/* ========================================================================= */
+
+static u32 read_physical_state(struct hfi1_devdata *dd)
+{
+	u64 reg;
+
+	reg = read_csr(dd, DC_DC8051_STS_CUR_STATE);
+	return (reg >> DC_DC8051_STS_CUR_STATE_PORT_SHIFT)
+				& DC_DC8051_STS_CUR_STATE_PORT_MASK;
+}
+
+static u32 read_logical_state(struct hfi1_devdata *dd)
+{
+	u64 reg;
+
+	reg = read_csr(dd, DCC_CFG_PORT_CONFIG);
+	return (reg >> DCC_CFG_PORT_CONFIG_LINK_STATE_SHIFT)
+				& DCC_CFG_PORT_CONFIG_LINK_STATE_MASK;
+}
+
+static void set_logical_state(struct hfi1_devdata *dd, u32 chip_lstate)
+{
+	u64 reg;
+
+	reg = read_csr(dd, DCC_CFG_PORT_CONFIG);
+	/* clear current state, set new state */
+	reg &= ~DCC_CFG_PORT_CONFIG_LINK_STATE_SMASK;
+	reg |= (u64)chip_lstate << DCC_CFG_PORT_CONFIG_LINK_STATE_SHIFT;
+	write_csr(dd, DCC_CFG_PORT_CONFIG, reg);
+}
+
+/*
+ * Use the 8051 to read a LCB CSR.
+ */
+static int read_lcb_via_8051(struct hfi1_devdata *dd, u32 addr, u64 *data)
+{
+	u32 regno;
+	int ret;
+
+	if (dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
+		if (acquire_lcb_access(dd, 0) == 0) {
+			*data = read_csr(dd, addr);
+			release_lcb_access(dd, 0);
+			return 0;
+		}
+		return -EBUSY;
+	}
+
+	/* register is an index of LCB registers: (offset - base) / 8 */
+	regno = (addr - DC_LCB_CFG_RUN) >> 3;
+	ret = do_8051_command(dd, HCMD_READ_LCB_CSR, regno, data);
+	if (ret != HCMD_SUCCESS)
+		return -EBUSY;
+	return 0;
+}
+
+/*
+ * Read an LCB CSR.  Access may not be in host control, so check.
+ * Return 0 on success, -EBUSY on failure.
+ */
+int read_lcb_csr(struct hfi1_devdata *dd, u32 addr, u64 *data)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+
+	/* if up, go through the 8051 for the value */
+	if (ppd->host_link_state & HLS_UP)
+		return read_lcb_via_8051(dd, addr, data);
+	/* if going up or down, no access */
+	if (ppd->host_link_state & (HLS_GOING_UP | HLS_GOING_OFFLINE))
+		return -EBUSY;
+	/* otherwise, host has access */
+	*data = read_csr(dd, addr);
+	return 0;
+}
+
+/*
+ * Use the 8051 to write a LCB CSR.
+ */
+static int write_lcb_via_8051(struct hfi1_devdata *dd, u32 addr, u64 data)
+{
+
+	if (acquire_lcb_access(dd, 0) == 0) {
+		write_csr(dd, addr, data);
+		release_lcb_access(dd, 0);
+		return 0;
+	}
+	return -EBUSY;
+}
+
+/*
+ * Write an LCB CSR.  Access may not be in host control, so check.
+ * Return 0 on success, -EBUSY on failure.
+ */
+int write_lcb_csr(struct hfi1_devdata *dd, u32 addr, u64 data)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+
+	/* if up, go through the 8051 for the value */
+	if (ppd->host_link_state & HLS_UP)
+		return write_lcb_via_8051(dd, addr, data);
+	/* if going up or down, no access */
+	if (ppd->host_link_state & (HLS_GOING_UP | HLS_GOING_OFFLINE))
+		return -EBUSY;
+	/* otherwise, host has access */
+	write_csr(dd, addr, data);
+	return 0;
+}
+
+/*
+ * Returns:
+ *	< 0 = Linux error, not able to get access
+ *	> 0 = 8051 command RETURN_CODE
+ */
+static int do_8051_command(
+	struct hfi1_devdata *dd,
+	u32 type,
+	u64 in_data,
+	u64 *out_data)
+{
+	u64 reg, completed;
+	int return_code;
+	unsigned long flags;
+	unsigned long timeout;
+
+	hfi1_cdbg(DC8051, "type %d, data 0x%012llx", type, in_data);
+
+	/*
+	 * Alternative to holding the lock for a long time:
+	 * - keep busy wait - have other users bounce off
+	 */
+	spin_lock_irqsave(&dd->dc8051_lock, flags);
+
+
+	/* We can't send any commands to the 8051 if it's in reset */
+	if (dd->dc_shutdown) {
+		return_code = -ENODEV;
+		goto fail;
+	}
+
+	/*
+	 * If an 8051 host command timed out previously, then the 8051 is
+	 * stuck.
+	 *
+	 * On first timeout, attempt to reset and restart the entire DC
+	 * block (including 8051). (Is this too big of a hammer?)
+	 *
+	 * If the 8051 times out a second time, the reset did not bring it
+	 * back to healthy life. In that case, fail any subsequent commands.
+	 */
+	if (dd->dc8051_timed_out) {
+		if (dd->dc8051_timed_out > 1) {
+			dd_dev_err(dd,
+				   "Previous 8051 host command timed out, skipping command %u\n",
+				   type);
+			return_code = -ENXIO;
+			goto fail;
+		}
+		spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+		dc_shutdown(dd);
+		dc_start(dd);
+		spin_lock_irqsave(&dd->dc8051_lock, flags);
+	}
+
+	/*
+	 * If there is no timeout, then the 8051 command interface is
+	 * waiting for a command.
+	 */
+
+	/*
+	 * Do two writes: the first to stabilize the type and req_data, the
+	 * second to activate.
+	 */
+	reg = ((u64)type & DC_DC8051_CFG_HOST_CMD_0_REQ_TYPE_MASK)
+			<< DC_DC8051_CFG_HOST_CMD_0_REQ_TYPE_SHIFT
+		| (in_data & DC_DC8051_CFG_HOST_CMD_0_REQ_DATA_MASK)
+			<< DC_DC8051_CFG_HOST_CMD_0_REQ_DATA_SHIFT;
+	write_csr(dd, DC_DC8051_CFG_HOST_CMD_0, reg);
+	reg |= DC_DC8051_CFG_HOST_CMD_0_REQ_NEW_SMASK;
+	write_csr(dd, DC_DC8051_CFG_HOST_CMD_0, reg);
+
+	/* wait for completion, alternate: interrupt */
+	timeout = jiffies + msecs_to_jiffies(
+				quick_linkup ? 20000 : DC8051_COMMAND_TIMEOUT);
+	while (1) {
+		reg = read_csr(dd, DC_DC8051_CFG_HOST_CMD_1);
+		completed = reg & DC_DC8051_CFG_HOST_CMD_1_COMPLETED_SMASK;
+		if (completed)
+			break;
+		if (time_after(jiffies, timeout)) {
+			dd->dc8051_timed_out++;
+			dd_dev_err(dd, "8051 host command %u timeout\n", type);
+			if (out_data)
+				*out_data = 0;
+			return_code = -ETIMEDOUT;
+			goto fail;
+		}
+		udelay(2);
+	}
+
+	if (out_data) {
+		*out_data = (reg >> DC_DC8051_CFG_HOST_CMD_1_RSP_DATA_SHIFT)
+				& DC_DC8051_CFG_HOST_CMD_1_RSP_DATA_MASK;
+		if (type == HCMD_READ_LCB_CSR) {
+			/* top 16 bits are in a different register */
+			*out_data |= (read_csr(dd, DC_DC8051_CFG_EXT_DEV_1)
+				& DC_DC8051_CFG_EXT_DEV_1_REQ_DATA_SMASK)
+				<< (48
+				    - DC_DC8051_CFG_EXT_DEV_1_REQ_DATA_SHIFT);
+		}
+	}
+	return_code = (reg >> DC_DC8051_CFG_HOST_CMD_1_RETURN_CODE_SHIFT)
+				& DC_DC8051_CFG_HOST_CMD_1_RETURN_CODE_MASK;
+	dd->dc8051_timed_out = 0;
+	/*
+	 * Clear command for next user.
+	 */
+	write_csr(dd, DC_DC8051_CFG_HOST_CMD_0, 0);
+
+fail:
+	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+
+	return return_code;
+}
+
+static int set_physical_link_state(struct hfi1_devdata *dd, u64 state)
+{
+	return do_8051_command(dd, HCMD_CHANGE_PHY_STATE, state, NULL);
+}
+
+static int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
+			    u8 lane_id, u32 config_data)
+{
+	u64 data;
+	int ret;
+
+	data = (u64)field_id << LOAD_DATA_FIELD_ID_SHIFT
+		| (u64)lane_id << LOAD_DATA_LANE_ID_SHIFT
+		| (u64)config_data << LOAD_DATA_DATA_SHIFT;
+	ret = do_8051_command(dd, HCMD_LOAD_CONFIG_DATA, data, NULL);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd,
+			"load 8051 config: field id %d, lane %d, err %d\n",
+			(int)field_id, (int)lane_id, ret);
+	}
+	return ret;
+}
+
+static int read_8051_config(struct hfi1_devdata *dd, u8 field_id,
+			    u8 lane_id, u32 *config_data)
+{
+	u64 in_data;
+	u64 out_data;
+	int ret;
+
+	in_data = (u64)field_id << READ_DATA_FIELD_ID_SHIFT
+			| (u64)lane_id << READ_DATA_LANE_ID_SHIFT;
+	ret = do_8051_command(dd, HCMD_READ_CONFIG_DATA, in_data,
+				&out_data);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd,
+			"read 8051 config: field id %d, lane %d, err %d failed\n",
+			(int)field_id, (int)lane_id, ret);
+		out_data = 0;
+	}
+	*config_data = (out_data >> READ_DATA_DATA_SHIFT) & READ_DATA_DATA_MASK;
+	return ret;
+}
+
+static int write_vc_local_phy(struct hfi1_devdata *dd, u8 power_management,
+			      u8 continuous)
+{
+	u32 frame;
+
+	frame = continuous << CONTINIOUS_REMOTE_UPDATE_SUPPORT_SHIFT
+		| power_management << POWER_MANAGEMENT_SHIFT;
+	return load_8051_config(dd, VERIFY_CAP_LOCAL_PHY,
+				GENERAL_CONFIG, frame);
+}
+
+static int write_vc_local_fabric(struct hfi1_devdata *dd, u8 vau, u8 z, u8 vcu,
+				 u16 vl15buf, u8 crc_sizes)
+{
+	u32 frame;
+
+	frame = (u32)vau << VAU_SHIFT
+		| (u32)z << Z_SHIFT
+		| (u32)vcu << VCU_SHIFT
+		| (u32)vl15buf << VL15BUF_SHIFT
+		| (u32)crc_sizes << CRC_SIZES_SHIFT;
+	return load_8051_config(dd, VERIFY_CAP_LOCAL_FABRIC,
+				GENERAL_CONFIG, frame);
+}
+
+static void read_vc_local_link_width(struct hfi1_devdata *dd, u8 *misc_bits,
+				     u8 *flag_bits, u16 *link_widths)
+{
+	u32 frame;
+
+	read_8051_config(dd, VERIFY_CAP_LOCAL_LINK_WIDTH, GENERAL_CONFIG,
+				&frame);
+	*misc_bits = (frame >> MISC_CONFIG_BITS_SHIFT) & MISC_CONFIG_BITS_MASK;
+	*flag_bits = (frame >> LOCAL_FLAG_BITS_SHIFT) & LOCAL_FLAG_BITS_MASK;
+	*link_widths = (frame >> LINK_WIDTH_SHIFT) & LINK_WIDTH_MASK;
+}
+
+static int write_vc_local_link_width(struct hfi1_devdata *dd,
+				     u8 misc_bits,
+				     u8 flag_bits,
+				     u16 link_widths)
+{
+	u32 frame;
+
+	frame = (u32)misc_bits << MISC_CONFIG_BITS_SHIFT
+		| (u32)flag_bits << LOCAL_FLAG_BITS_SHIFT
+		| (u32)link_widths << LINK_WIDTH_SHIFT;
+	return load_8051_config(dd, VERIFY_CAP_LOCAL_LINK_WIDTH, GENERAL_CONFIG,
+		     frame);
+}
+
+static int write_local_device_id(struct hfi1_devdata *dd, u16 device_id,
+				 u8 device_rev)
+{
+	u32 frame;
+
+	frame = ((u32)device_id << LOCAL_DEVICE_ID_SHIFT)
+		| ((u32)device_rev << LOCAL_DEVICE_REV_SHIFT);
+	return load_8051_config(dd, LOCAL_DEVICE_ID, GENERAL_CONFIG, frame);
+}
+
+static void read_remote_device_id(struct hfi1_devdata *dd, u16 *device_id,
+				  u8 *device_rev)
+{
+	u32 frame;
+
+	read_8051_config(dd, REMOTE_DEVICE_ID, GENERAL_CONFIG, &frame);
+	*device_id = (frame >> REMOTE_DEVICE_ID_SHIFT) & REMOTE_DEVICE_ID_MASK;
+	*device_rev = (frame >> REMOTE_DEVICE_REV_SHIFT)
+			& REMOTE_DEVICE_REV_MASK;
+}
+
+void read_misc_status(struct hfi1_devdata *dd, u8 *ver_a, u8 *ver_b)
+{
+	u32 frame;
+
+	read_8051_config(dd, MISC_STATUS, GENERAL_CONFIG, &frame);
+	*ver_a = (frame >> STS_FM_VERSION_A_SHIFT) & STS_FM_VERSION_A_MASK;
+	*ver_b = (frame >> STS_FM_VERSION_B_SHIFT) & STS_FM_VERSION_B_MASK;
+}
+
+static void read_vc_remote_phy(struct hfi1_devdata *dd, u8 *power_management,
+			       u8 *continuous)
+{
+	u32 frame;
+
+	read_8051_config(dd, VERIFY_CAP_REMOTE_PHY, GENERAL_CONFIG, &frame);
+	*power_management = (frame >> POWER_MANAGEMENT_SHIFT)
+					& POWER_MANAGEMENT_MASK;
+	*continuous = (frame >> CONTINIOUS_REMOTE_UPDATE_SUPPORT_SHIFT)
+					& CONTINIOUS_REMOTE_UPDATE_SUPPORT_MASK;
+}
+
+static void read_vc_remote_fabric(struct hfi1_devdata *dd, u8 *vau, u8 *z,
+				  u8 *vcu, u16 *vl15buf, u8 *crc_sizes)
+{
+	u32 frame;
+
+	read_8051_config(dd, VERIFY_CAP_REMOTE_FABRIC, GENERAL_CONFIG, &frame);
+	*vau = (frame >> VAU_SHIFT) & VAU_MASK;
+	*z = (frame >> Z_SHIFT) & Z_MASK;
+	*vcu = (frame >> VCU_SHIFT) & VCU_MASK;
+	*vl15buf = (frame >> VL15BUF_SHIFT) & VL15BUF_MASK;
+	*crc_sizes = (frame >> CRC_SIZES_SHIFT) & CRC_SIZES_MASK;
+}
+
+static void read_vc_remote_link_width(struct hfi1_devdata *dd,
+				      u8 *remote_tx_rate,
+				      u16 *link_widths)
+{
+	u32 frame;
+
+	read_8051_config(dd, VERIFY_CAP_REMOTE_LINK_WIDTH, GENERAL_CONFIG,
+				&frame);
+	*remote_tx_rate = (frame >> REMOTE_TX_RATE_SHIFT)
+				& REMOTE_TX_RATE_MASK;
+	*link_widths = (frame >> LINK_WIDTH_SHIFT) & LINK_WIDTH_MASK;
+}
+
+static void read_local_lni(struct hfi1_devdata *dd, u8 *enable_lane_rx)
+{
+	u32 frame;
+
+	read_8051_config(dd, LOCAL_LNI_INFO, GENERAL_CONFIG, &frame);
+	*enable_lane_rx = (frame >> ENABLE_LANE_RX_SHIFT) & ENABLE_LANE_RX_MASK;
+}
+
+static void read_mgmt_allowed(struct hfi1_devdata *dd, u8 *mgmt_allowed)
+{
+	u32 frame;
+
+	read_8051_config(dd, REMOTE_LNI_INFO, GENERAL_CONFIG, &frame);
+	*mgmt_allowed = (frame >> MGMT_ALLOWED_SHIFT) & MGMT_ALLOWED_MASK;
+}
+
+static void read_last_local_state(struct hfi1_devdata *dd, u32 *lls)
+{
+	read_8051_config(dd, LAST_LOCAL_STATE_COMPLETE, GENERAL_CONFIG, lls);
+}
+
+static void read_last_remote_state(struct hfi1_devdata *dd, u32 *lrs)
+{
+	read_8051_config(dd, LAST_REMOTE_STATE_COMPLETE, GENERAL_CONFIG, lrs);
+}
+
+void hfi1_read_link_quality(struct hfi1_devdata *dd, u8 *link_quality)
+{
+	u32 frame;
+
+	read_8051_config(dd, LINK_QUALITY_INFO, GENERAL_CONFIG, &frame);
+	*link_quality = (frame >> LINK_QUALITY_SHIFT) & LINK_QUALITY_MASK;
+}
+
+static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc)
+{
+	u32 frame;
+
+	read_8051_config(dd, LINK_QUALITY_INFO, GENERAL_CONFIG, &frame);
+	*pdrrc = (frame >> DOWN_REMOTE_REASON_SHIFT) & DOWN_REMOTE_REASON_MASK;
+}
+
+static int read_tx_settings(struct hfi1_devdata *dd,
+			    u8 *enable_lane_tx,
+			    u8 *tx_polarity_inversion,
+			    u8 *rx_polarity_inversion,
+			    u8 *max_rate)
+{
+	u32 frame;
+	int ret;
+
+	ret = read_8051_config(dd, TX_SETTINGS, GENERAL_CONFIG, &frame);
+	*enable_lane_tx = (frame >> ENABLE_LANE_TX_SHIFT)
+				& ENABLE_LANE_TX_MASK;
+	*tx_polarity_inversion = (frame >> TX_POLARITY_INVERSION_SHIFT)
+				& TX_POLARITY_INVERSION_MASK;
+	*rx_polarity_inversion = (frame >> RX_POLARITY_INVERSION_SHIFT)
+				& RX_POLARITY_INVERSION_MASK;
+	*max_rate = (frame >> MAX_RATE_SHIFT) & MAX_RATE_MASK;
+	return ret;
+}
+
+static int write_tx_settings(struct hfi1_devdata *dd,
+			     u8 enable_lane_tx,
+			     u8 tx_polarity_inversion,
+			     u8 rx_polarity_inversion,
+			     u8 max_rate)
+{
+	u32 frame;
+
+	/* no need to mask, all variable sizes match field widths */
+	frame = enable_lane_tx << ENABLE_LANE_TX_SHIFT
+		| tx_polarity_inversion << TX_POLARITY_INVERSION_SHIFT
+		| rx_polarity_inversion << RX_POLARITY_INVERSION_SHIFT
+		| max_rate << MAX_RATE_SHIFT;
+	return load_8051_config(dd, TX_SETTINGS, GENERAL_CONFIG, frame);
+}
+
+static void check_fabric_firmware_versions(struct hfi1_devdata *dd)
+{
+	u32 frame, version, prod_id;
+	int ret, lane;
+
+	/* 4 lanes */
+	for (lane = 0; lane < 4; lane++) {
+		ret = read_8051_config(dd, SPICO_FW_VERSION, lane, &frame);
+		if (ret != HCMD_SUCCESS) {
+			dd_dev_err(
+				dd,
+				"Unable to read lane %d firmware details\n",
+				lane);
+			continue;
+		}
+		version = (frame >> SPICO_ROM_VERSION_SHIFT)
+					& SPICO_ROM_VERSION_MASK;
+		prod_id = (frame >> SPICO_ROM_PROD_ID_SHIFT)
+					& SPICO_ROM_PROD_ID_MASK;
+		dd_dev_info(dd,
+			"Lane %d firmware: version 0x%04x, prod_id 0x%04x\n",
+			lane, version, prod_id);
+	}
+}
+
+/*
+ * Read an idle LCB message.
+ *
+ * Returns 0 on success, -EINVAL on error
+ */
+static int read_idle_message(struct hfi1_devdata *dd, u64 type, u64 *data_out)
+{
+	int ret;
+
+	ret = do_8051_command(dd, HCMD_READ_LCB_IDLE_MSG,
+		type, data_out);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd, "read idle message: type %d, err %d\n",
+			(u32)type, ret);
+		return -EINVAL;
+	}
+	dd_dev_info(dd, "%s: read idle message 0x%llx\n", __func__, *data_out);
+	/* return only the payload as we already know the type */
+	*data_out >>= IDLE_PAYLOAD_SHIFT;
+	return 0;
+}
+
+/*
+ * Read an idle SMA message.  To be done in response to a notification from
+ * the 8051.
+ *
+ * Returns 0 on success, -EINVAL on error
+ */
+static int read_idle_sma(struct hfi1_devdata *dd, u64 *data)
+{
+	return read_idle_message(dd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
