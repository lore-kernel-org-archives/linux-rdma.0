From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 05/49] IB/hfi1: add chip specific support part4
Date: Mon, 15 Jun 2015 09:26:25 -0400
Message-ID: <20150615132625.29741.42281.stgit@phlsvslse11.ph.intel.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615132434.29741.35258.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
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
 drivers/infiniband/hw/hfi1/chip.c | 2613 +++++++++++++++++++++++++++++++++++++
 1 file changed, 2613 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 7019499..bf40a14 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8011,3 +8011,2616 @@ static int init_cntrs(struct hfi1_devdata *dd)
 		}
 	}
 
+	/* allocate space for the counter values */
+	dd->cntrs = kcalloc(index, sizeof(u64), GFP_KERNEL);
+	if (!dd->cntrs)
+		goto bail;
+
+	dd->scntrs = kcalloc(index, sizeof(u64), GFP_KERNEL);
+	if (!dd->scntrs)
+		goto bail;
+
+
+	/* allocate space for the counter names */
+	dd->cntrnameslen = sz;
+	dd->cntrnames = kmalloc(sz, GFP_KERNEL);
+	if (!dd->cntrnames)
+		goto bail;
+
+	/* fill in the names */
+	for (p = dd->cntrnames, i = 0, index = 0; i < DEV_CNTR_LAST; i++) {
+		if (dev_cntrs[i].flags & CNTR_DISABLED) {
+			/* Nothing */
+		} else {
+			if (dev_cntrs[i].flags & CNTR_VL) {
+				for (j = 0; j < C_VL_COUNT; j++) {
+					memset(name, '\0', C_MAX_NAME);
+					snprintf(name, C_MAX_NAME, "%s%d",
+						dev_cntrs[i].name,
+						vl_from_idx(j));
+					memcpy(p, name, strlen(name));
+					p += strlen(name);
+					*p++ = '\n';
+				}
+			} else {
+				memcpy(p, dev_cntrs[i].name,
+				       strlen(dev_cntrs[i].name));
+				p += strlen(dev_cntrs[i].name);
+				*p++ = '\n';
+			}
+			index++;
+		}
+	}
+
+	/*********************/
+	/* per port counters */
+	/*********************/
+
+	/*
+	 * Go through the counters for the overflows and disable the ones we
+	 * don't need. This varies based on platform so we need to do it
+	 * dynamically here.
+	 */
+	rcv_ctxts = dd->num_rcv_contexts;
+	for (i = C_RCV_HDR_OVF_FIRST + rcv_ctxts;
+	     i <= C_RCV_HDR_OVF_LAST; i++) {
+		port_cntrs[i].flags |= CNTR_DISABLED;
+	}
+
+	/* size port counter names and determine how many we have*/
+	sz = 0;
+	dd->nportcntrs = 0;
+	for (i = 0; i < PORT_CNTR_LAST; i++) {
+		hfi1_dbg_early("Init pcntr %s\n", port_cntrs[i].name);
+		if (port_cntrs[i].flags & CNTR_DISABLED) {
+			hfi1_dbg_early("\tSkipping %s\n", port_cntrs[i].name);
+			continue;
+		}
+
+		if (port_cntrs[i].flags & CNTR_VL) {
+			hfi1_dbg_early("\tProcessing VL cntr\n");
+			port_cntrs[i].offset = dd->nportcntrs;
+			for (j = 0; j < C_VL_COUNT; j++) {
+				memset(name, '\0', C_MAX_NAME);
+				snprintf(name, C_MAX_NAME, "%s%d",
+					port_cntrs[i].name,
+					vl_from_idx(j));
+				sz += strlen(name);
+				sz++;
+				hfi1_dbg_early("\t\t%s\n", name);
+				dd->nportcntrs++;
+			}
+		} else {
+			/* +1 for newline  */
+			sz += strlen(port_cntrs[i].name) + 1;
+			port_cntrs[i].offset = dd->nportcntrs;
+			dd->nportcntrs++;
+			hfi1_dbg_early("\tAdding %s\n", port_cntrs[i].name);
+		}
+	}
+
+	/* allocate space for the counter names */
+	dd->portcntrnameslen = sz;
+	dd->portcntrnames = kmalloc(sz, GFP_KERNEL);
+	if (!dd->portcntrnames)
+		goto bail;
+
+	/* fill in port cntr names */
+	for (p = dd->portcntrnames, i = 0; i < PORT_CNTR_LAST; i++) {
+		if (port_cntrs[i].flags & CNTR_DISABLED)
+			continue;
+
+		if (port_cntrs[i].flags & CNTR_VL) {
+			for (j = 0; j < C_VL_COUNT; j++) {
+				memset(name, '\0', C_MAX_NAME);
+				snprintf(name, C_MAX_NAME, "%s%d",
+					port_cntrs[i].name,
+					vl_from_idx(j));
+				memcpy(p, name, strlen(name));
+				p += strlen(name);
+				*p++ = '\n';
+			}
+		} else {
+			memcpy(p, port_cntrs[i].name,
+			       strlen(port_cntrs[i].name));
+			p += strlen(port_cntrs[i].name);
+			*p++ = '\n';
+		}
+	}
+
+	/* allocate per port storage for counter values */
+	ppd = (struct hfi1_pportdata *)(dd + 1);
+	for (i = 0; i < dd->num_pports; i++, ppd++) {
+		ppd->cntrs = kcalloc(dd->nportcntrs, sizeof(u64), GFP_KERNEL);
+		if (!ppd->cntrs)
+			goto bail;
+
+		ppd->scntrs = kcalloc(dd->nportcntrs, sizeof(u64), GFP_KERNEL);
+		if (!ppd->scntrs)
+			goto bail;
+	}
+
+	/* CPU counters need to be allocated and zeroed */
+	if (init_cpu_counters(dd))
+		goto bail;
+
+	mod_timer(&dd->synth_stats_timer, jiffies + HZ * SYNTH_CNT_TIME);
+	return 0;
+bail:
+	free_cntrs(dd);
+	return -ENOMEM;
+}
+
+
+static u32 chip_to_opa_lstate(struct hfi1_devdata *dd, u32 chip_lstate)
+{
+	switch (chip_lstate) {
+	default:
+		dd_dev_err(dd,
+			 "Unknown logical state 0x%x, reporting IB_PORT_DOWN\n",
+			 chip_lstate);
+		/* fall through */
+	case LSTATE_DOWN:
+		return IB_PORT_DOWN;
+	case LSTATE_INIT:
+		return IB_PORT_INIT;
+	case LSTATE_ARMED:
+		return IB_PORT_ARMED;
+	case LSTATE_ACTIVE:
+		return IB_PORT_ACTIVE;
+	}
+}
+
+static u32 chip_to_opa_pstate(struct hfi1_devdata *dd, u32 chip_pstate)
+{
+	/* look at the HFI meta-states only */
+	switch (chip_pstate & 0xf0) {
+	default:
+		dd_dev_err(dd, "Unexpected chip physical state of 0x%x\n",
+			chip_pstate);
+		/* fall through */
+	case PLS_DISABLED:
+		return IB_PORTPHYSSTATE_DISABLED;
+	case PLS_OFFLINE:
+		return OPA_PORTPHYSSTATE_OFFLINE;
+	case PLS_POLLING:
+		return IB_PORTPHYSSTATE_POLLING;
+	case PLS_CONFIGPHY:
+		return IB_PORTPHYSSTATE_TRAINING;
+	case PLS_LINKUP:
+		return IB_PORTPHYSSTATE_LINKUP;
+	case PLS_PHYTEST:
+		return IB_PORTPHYSSTATE_PHY_TEST;
+	}
+}
+
+/* return the OPA port logical state name */
+static const char *opa_lstate_name(u32 lstate)
+{
+	static const char * const port_logical_names[] = {
+		"PORT_NOP",
+		"PORT_DOWN",
+		"PORT_INIT",
+		"PORT_ARMED",
+		"PORT_ACTIVE",
+		"PORT_ACTIVE_DEFER",
+	};
+	if (lstate < ARRAY_SIZE(port_logical_names))
+		return port_logical_names[lstate];
+	return "unknown";
+}
+
+/* return the OPA port physical state name */
+static const char *opa_pstate_name(u32 pstate)
+{
+	static const char * const port_physical_names[] = {
+		"PHYS_NOP",
+		"reserved1",
+		"PHYS_POLL",
+		"PHYS_DISABLED",
+		"PHYS_TRAINING",
+		"PHYS_LINKUP",
+		"PHYS_LINK_ERR_RECOVER",
+		"PHYS_PHY_TEST",
+		"reserved8",
+		"PHYS_OFFLINE",
+		"PHYS_GANGED",
+		"PHYS_TEST",
+	};
+	if (pstate < ARRAY_SIZE(port_physical_names))
+		return port_physical_names[pstate];
+	return "unknown";
+}
+
+/*
+ * Read the hardware link state and set the driver's cached value of it.
+ * Return the (new) current value.
+ */
+static u32 get_logical_state(struct hfi1_pportdata *ppd)
+{
+	u32 new_state;
+
+	new_state = chip_to_opa_lstate(ppd->dd, read_logical_state(ppd->dd));
+	if (new_state != ppd->lstate) {
+		dd_dev_info(ppd->dd, "logical state changed to %s (0x%x)\n",
+			opa_lstate_name(new_state), new_state);
+		ppd->lstate = new_state;
+	}
+	/*
+	 * Set port status flags in the page mapped into userspace
+	 * memory. Do it here to ensure a reliable state - this is
+	 * the only function called by all state handling code.
+	 * Always set the flags due to the fact that the cache value
+	 * might have been changed explicitly outside of this
+	 * function.
+	 */
+	if (ppd->statusp) {
+		switch (ppd->lstate) {
+		case IB_PORT_DOWN:
+		case IB_PORT_INIT:
+			*ppd->statusp &= ~(HFI1_STATUS_IB_CONF |
+					   HFI1_STATUS_IB_READY);
+			break;
+		case IB_PORT_ARMED:
+			*ppd->statusp |= HFI1_STATUS_IB_CONF;
+			break;
+		case IB_PORT_ACTIVE:
+			*ppd->statusp |= HFI1_STATUS_IB_READY;
+			break;
+		}
+	}
+	return ppd->lstate;
+}
+
+/**
+ * wait_logical_linkstate - wait for an IB link state change to occur
+ * @ppd: port device
+ * @state: the state to wait for
+ * @msecs: the number of milliseconds to wait
+ *
+ * Wait up to msecs milliseconds for IB link state change to occur.
+ * For now, take the easy polling route.
+ * Returns 0 if state reached, otherwise -ETIMEDOUT.
+ */
+static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
+				  int msecs)
+{
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(msecs);
+	while (1) {
+		if (get_logical_state(ppd) == state)
+			return 0;
+		if (time_after(jiffies, timeout))
+			break;
+		msleep(20);
+	}
+	dd_dev_err(ppd->dd, "timeout waiting for link state 0x%x\n", state);
+
+	return -ETIMEDOUT;
+}
+
+u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd)
+{
+	static u32 remembered_state = 0xff;
+	u32 pstate;
+	u32 ib_pstate;
+
+	pstate = read_physical_state(ppd->dd);
+	ib_pstate = chip_to_opa_pstate(ppd->dd, pstate);
+	if (remembered_state != ib_pstate) {
+		dd_dev_info(ppd->dd,
+			"%s: physical state changed to %s (0x%x), phy 0x%x\n",
+			__func__, opa_pstate_name(ib_pstate), ib_pstate,
+			pstate);
+		remembered_state = ib_pstate;
+	}
+	return ib_pstate;
+}
+
+/*
+ * Read/modify/write ASIC_QSFP register bits as selected by mask
+ * data: 0 or 1 in the positions depending on what needs to be written
+ * dir: 0 for read, 1 for write
+ * mask: select by setting
+ *      I2CCLK  (bit 0)
+ *      I2CDATA (bit 1)
+ */
+u64 hfi1_gpio_mod(struct hfi1_devdata *dd, u32 target, u32 data, u32 dir,
+		  u32 mask)
+{
+	u64 qsfp_oe, target_oe;
+
+	target_oe = target ? ASIC_QSFP2_OE : ASIC_QSFP1_OE;
+	if (mask) {
+		/* We are writing register bits, so lock access */
+		dir &= mask;
+		data &= mask;
+
+		qsfp_oe = read_csr(dd, target_oe);
+		qsfp_oe = (qsfp_oe & ~(u64)mask) | (u64)dir;
+		write_csr(dd, target_oe, qsfp_oe);
+	}
+	/* We are exclusively reading bits here, but it is unlikely
+	 * we'll get valid data when we set the direction of the pin
+	 * in the same call, so read should call this function again
+	 * to get valid data
+	 */
+	return read_csr(dd, target ? ASIC_QSFP2_IN : ASIC_QSFP1_IN);
+}
+
+#define CLEAR_STATIC_RATE_CONTROL_SMASK(r) \
+(r &= ~SEND_CTXT_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
+
+#define SET_STATIC_RATE_CONTROL_SMASK(r) \
+(r |= SEND_CTXT_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
+
+int hfi1_init_ctxt(struct send_context *sc)
+{
+	if (sc != NULL) {
+		struct hfi1_devdata *dd = sc->dd;
+		u64 reg;
+		u8 set = (sc->type == SC_USER ?
+			  HFI1_CAP_IS_USET(STATIC_RATE_CTRL) :
+			  HFI1_CAP_IS_KSET(STATIC_RATE_CTRL));
+		reg = read_kctxt_csr(dd, sc->hw_context,
+				     SEND_CTXT_CHECK_ENABLE);
+		if (set)
+			CLEAR_STATIC_RATE_CONTROL_SMASK(reg);
+		else
+			SET_STATIC_RATE_CONTROL_SMASK(reg);
+		write_kctxt_csr(dd, sc->hw_context,
+				SEND_CTXT_CHECK_ENABLE, reg);
+	}
+	return 0;
+}
+
+int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp)
+{
+	int ret = 0;
+	u64 reg;
+
+	if (dd->icode != ICODE_RTL_SILICON) {
+		if (HFI1_CAP_IS_KSET(PRINT_UNIMPL))
+			dd_dev_info(dd, "%s: tempsense not supported by HW\n",
+				    __func__);
+		return -EINVAL;
+	}
+	reg = read_csr(dd, ASIC_STS_THERM);
+	temp->curr = ((reg >> ASIC_STS_THERM_CURR_TEMP_SHIFT) &
+		      ASIC_STS_THERM_CURR_TEMP_MASK);
+	temp->lo_lim = ((reg >> ASIC_STS_THERM_LO_TEMP_SHIFT) &
+			ASIC_STS_THERM_LO_TEMP_MASK);
+	temp->hi_lim = ((reg >> ASIC_STS_THERM_HI_TEMP_SHIFT) &
+			ASIC_STS_THERM_HI_TEMP_MASK);
+	temp->crit_lim = ((reg >> ASIC_STS_THERM_CRIT_TEMP_SHIFT) &
+			  ASIC_STS_THERM_CRIT_TEMP_MASK);
+	/* triggers is a 3-bit value - 1 bit per trigger. */
+	temp->triggers = (u8)((reg >> ASIC_STS_THERM_LOW_SHIFT) & 0x7);
+
+	return ret;
+}
+
+/* ========================================================================= */
+
+/*
+ * Enable/disable chip from delivering interrupts.
+ */
+void set_intr_state(struct hfi1_devdata *dd, u32 enable)
+{
+	int i;
+
+	/*
+	 * In HFI, the mask needs to be 1 to allow interrupts.
+	 */
+	if (enable) {
+		u64 cce_int_mask;
+		const int qsfp1_int_smask = QSFP1_INT % 64;
+		const int qsfp2_int_smask = QSFP2_INT % 64;
+
+		/* enable all interrupts */
+		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
+			write_csr(dd, CCE_INT_MASK + (8*i), ~(u64)0);
+
+		/*
+		 * disable QSFP1 interrupts for HFI1, QSFP2 interrupts for HFI0
+		 * Qsfp1Int and Qsfp2Int are adjacent bits in the same CSR,
+		 * therefore just one of QSFP1_INT/QSFP2_INT can be used to find
+		 * the index of the appropriate CSR in the CCEIntMask CSR array
+		 */
+		cce_int_mask = read_csr(dd, CCE_INT_MASK +
+						(8*(QSFP1_INT/64)));
+		if (dd->hfi1_id) {
+			cce_int_mask &= ~((u64)1 << qsfp1_int_smask);
+			write_csr(dd, CCE_INT_MASK + (8*(QSFP1_INT/64)),
+					cce_int_mask);
+		} else {
+			cce_int_mask &= ~((u64)1 << qsfp2_int_smask);
+			write_csr(dd, CCE_INT_MASK + (8*(QSFP2_INT/64)),
+					cce_int_mask);
+		}
+	} else {
+		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
+			write_csr(dd, CCE_INT_MASK + (8*i), 0ull);
+	}
+}
+
+/*
+ * Clear all interrupt sources on the chip.
+ */
+static void clear_all_interrupts(struct hfi1_devdata *dd)
+{
+	int i;
+
+	for (i = 0; i < CCE_NUM_INT_CSRS; i++)
+		write_csr(dd, CCE_INT_CLEAR + (8*i), ~(u64)0);
+
+	write_csr(dd, CCE_ERR_CLEAR, ~(u64)0);
+	write_csr(dd, MISC_ERR_CLEAR, ~(u64)0);
+	write_csr(dd, RCV_ERR_CLEAR, ~(u64)0);
+	write_csr(dd, SEND_ERR_CLEAR, ~(u64)0);
+	write_csr(dd, SEND_PIO_ERR_CLEAR, ~(u64)0);
+	write_csr(dd, SEND_DMA_ERR_CLEAR, ~(u64)0);
+	write_csr(dd, SEND_EGRESS_ERR_CLEAR, ~(u64)0);
+	for (i = 0; i < dd->chip_send_contexts; i++)
+		write_kctxt_csr(dd, i, SEND_CTXT_ERR_CLEAR, ~(u64)0);
+	for (i = 0; i < dd->chip_sdma_engines; i++)
+		write_kctxt_csr(dd, i, SEND_DMA_ENG_ERR_CLEAR, ~(u64)0);
+
+	write_csr(dd, DCC_ERR_FLG_CLR, ~(u64)0);
+	write_csr(dd, DC_LCB_ERR_CLR, ~(u64)0);
+	write_csr(dd, DC_DC8051_ERR_CLR, ~(u64)0);
+}
+
+/* Move to pcie.c? */
+static void disable_intx(struct pci_dev *pdev)
+{
+	pci_intx(pdev, 0);
+}
+
+static void clean_up_interrupts(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* remove irqs - must happen before disabling/turning off */
+	if (dd->num_msix_entries) {
+		/* MSI-X */
+		struct hfi1_msix_entry *me = dd->msix_entries;
+
+		for (i = 0; i < dd->num_msix_entries; i++, me++) {
+			if (me->arg == NULL) /* => no irq, no affinity */
+				break;
+			irq_set_affinity_hint(dd->msix_entries[i].msix.vector,
+					NULL);
+			free_irq(me->msix.vector, me->arg);
+		}
+	} else {
+		/* INTx */
+		if (dd->requested_intx_irq) {
+			free_irq(dd->pcidev->irq, dd);
+			dd->requested_intx_irq = 0;
+		}
+	}
+
+	/* turn off interrupts */
+	if (dd->num_msix_entries) {
+		/* MSI-X */
+		hfi1_nomsix(dd);
+	} else {
+		/* INTx */
+		disable_intx(dd->pcidev);
+	}
+
+	/* clean structures */
+	for (i = 0; i < dd->num_msix_entries; i++)
+		free_cpumask_var(dd->msix_entries[i].mask);
+	kfree(dd->msix_entries);
+	dd->msix_entries = NULL;
+	dd->num_msix_entries = 0;
+}
+
+/*
+ * Remap the interrupt source from the general handler to the given MSI-X
+ * interrupt.
+ */
+static void remap_intr(struct hfi1_devdata *dd, int isrc, int msix_intr)
+{
+	u64 reg;
+	int m, n;
+
+	/* clear from the handled mask of the general interrupt */
+	m = isrc / 64;
+	n = isrc % 64;
+	dd->gi_mask[m] &= ~((u64)1 << n);
+
+	/* direct the chip source to the given MSI-X interrupt */
+	m = isrc / 8;
+	n = isrc % 8;
+	reg = read_csr(dd, CCE_INT_MAP + (8*m));
+	reg &= ~((u64)0xff << (8*n));
+	reg |= ((u64)msix_intr & 0xff) << (8*n);
+	write_csr(dd, CCE_INT_MAP + (8*m), reg);
+}
+
+static void remap_sdma_interrupts(struct hfi1_devdata *dd,
+				  int engine, int msix_intr)
+{
+	/*
+	 * SDMA engine interrupt sources grouped by type, rather than
+	 * engine.  Per-engine interrupts are as follows:
+	 *	SDMA
+	 *	SDMAProgress
+	 *	SDMAIdle
+	 */
+	remap_intr(dd, IS_SDMA_START + 0*TXE_NUM_SDMA_ENGINES + engine,
+		msix_intr);
+	remap_intr(dd, IS_SDMA_START + 1*TXE_NUM_SDMA_ENGINES + engine,
+		msix_intr);
+	remap_intr(dd, IS_SDMA_START + 2*TXE_NUM_SDMA_ENGINES + engine,
+		msix_intr);
+}
+
+static void remap_receive_available_interrupt(struct hfi1_devdata *dd,
+					      int rx, int msix_intr)
+{
+	remap_intr(dd, IS_RCVAVAIL_START + rx, msix_intr);
+}
+
+static int request_intx_irq(struct hfi1_devdata *dd)
+{
+	int ret;
+
+	snprintf(dd->intx_name, sizeof(dd->intx_name), DRIVER_NAME"%d",
+		dd->unit);
+	ret = request_irq(dd->pcidev->irq, general_interrupt,
+				  IRQF_SHARED, dd->intx_name, dd);
+	if (ret)
+		dd_dev_err(dd, "unable to request INTx interrupt, err %d\n",
+				ret);
+	else
+		dd->requested_intx_irq = 1;
+	return ret;
+}
+
+static int request_msix_irqs(struct hfi1_devdata *dd)
+{
+	const struct cpumask *local_mask;
+	cpumask_var_t def, rcv;
+	bool def_ret, rcv_ret;
+	int first_general, last_general;
+	int first_sdma, last_sdma;
+	int first_rx, last_rx;
+	int first_cpu, restart_cpu, curr_cpu;
+	int rcv_cpu, sdma_cpu;
+	int i, ret = 0, possible;
+	int ht;
+
+	/* calculate the ranges we are going to use */
+	first_general = 0;
+	first_sdma = last_general = first_general + 1;
+	first_rx = last_sdma = first_sdma + dd->num_sdma;
+	last_rx = first_rx + dd->n_krcv_queues;
+
+	/*
+	 * Interrupt affinity.
+	 *
+	 * non-rcv avail gets a default mask that
+	 * starts as possible cpus with threads reset
+	 * and each rcv avail reset.
+	 *
+	 * rcv avail gets node relative 1 wrapping back
+	 * to the node relative 1 as necessary.
+	 *
+	 */
+	local_mask = cpumask_of_pcibus(dd->pcidev->bus);
+	/* if first cpu is invalid, use NUMA 0 */
+	if (cpumask_first(local_mask) >= nr_cpu_ids)
+		local_mask = topology_core_cpumask(0);
+
+	def_ret = zalloc_cpumask_var(&def, GFP_KERNEL);
+	rcv_ret = zalloc_cpumask_var(&rcv, GFP_KERNEL);
+	if (!def_ret || !rcv_ret)
+		goto bail;
+	/* use local mask as default */
+	cpumask_copy(def, local_mask);
+	possible = cpumask_weight(def);
+	/* disarm threads from default */
+	ht = cpumask_weight(cpu_sibling_mask(cpumask_first(local_mask)));
+	for (i = possible/ht; i < possible; i++)
+		cpumask_clear_cpu(i, def);
+	/* reset possible */
+	possible = cpumask_weight(def);
+	/* def now has full cores on chosen node*/
+	first_cpu = cpumask_first(def);
+	if (nr_cpu_ids >= first_cpu)
+		first_cpu++;
+	restart_cpu = first_cpu;
+	curr_cpu = restart_cpu;
+
+	for (i = first_cpu; i < dd->n_krcv_queues + first_cpu; i++) {
+		cpumask_clear_cpu(curr_cpu, def);
+		cpumask_set_cpu(curr_cpu, rcv);
+		if (curr_cpu >= possible)
+			curr_cpu = restart_cpu;
+		else
+			curr_cpu++;
+	}
+	/* def mask has non-rcv, rcv has recv mask */
+	rcv_cpu = cpumask_first(rcv);
+	sdma_cpu = cpumask_first(def);
+
+	/*
+	 * Sanity check - the code expects all SDMA chip source
+	 * interrupts to be in the same CSR, starting at bit 0.  Verify
+	 * that this is true by checking the bit location of the start.
+	 */
+	BUILD_BUG_ON(IS_SDMA_START % 64);
+
+	for (i = 0; i < dd->num_msix_entries; i++) {
+		struct hfi1_msix_entry *me = &dd->msix_entries[i];
+		const char *err_info;
+		irq_handler_t handler;
+		void *arg;
+		int idx;
+		struct hfi1_ctxtdata *rcd = NULL;
+		struct sdma_engine *sde = NULL;
+
+		/* obtain the arguments to request_irq */
+		if (first_general <= i && i < last_general) {
+			idx = i - first_general;
+			handler = general_interrupt;
+			arg = dd;
+			snprintf(me->name, sizeof(me->name),
+				DRIVER_NAME"%d", dd->unit);
+			err_info = "general";
+		} else if (first_sdma <= i && i < last_sdma) {
+			idx = i - first_sdma;
+			sde = &dd->per_sdma[idx];
+			handler = sdma_interrupt;
+			arg = sde;
+			snprintf(me->name, sizeof(me->name),
+				DRIVER_NAME"%d sdma%d", dd->unit, idx);
+			err_info = "sdma";
+			remap_sdma_interrupts(dd, idx, i);
+		} else if (first_rx <= i && i < last_rx) {
+			idx = i - first_rx;
+			rcd = dd->rcd[idx];
+			/* no interrupt if no rcd */
+			if (!rcd)
+				continue;
+			/*
+			 * Set the interrupt register and mask for this
+			 * context's interrupt.
+			 */
+			rcd->ireg = (IS_RCVAVAIL_START+idx) / 64;
+			rcd->imask = ((u64)1) <<
+					((IS_RCVAVAIL_START+idx) % 64);
+			handler = receive_context_interrupt;
+			arg = rcd;
+			snprintf(me->name, sizeof(me->name),
+				DRIVER_NAME"%d kctxt%d", dd->unit, idx);
+			err_info = "receive context";
+			remap_receive_available_interrupt(dd, idx, i);
+		} else {
+			/* not in our expected range - complain, then
+			   ignore it */
+			dd_dev_err(dd,
+				"Unexpected extra MSI-X interrupt %d\n", i);
+			continue;
+		}
+		/* no argument, no interrupt */
+		if (arg == NULL)
+			continue;
+		/* make sure the name is terminated */
+		me->name[sizeof(me->name)-1] = 0;
+
+		ret = request_irq(me->msix.vector, handler, 0, me->name, arg);
+		if (ret) {
+			dd_dev_err(dd,
+				"unable to allocate %s interrupt, vector %d, index %d, err %d\n",
+				 err_info, me->msix.vector, idx, ret);
+			return ret;
+		}
+		/*
+		 * assign arg after request_irq call, so it will be
+		 * cleaned up
+		 */
+		me->arg = arg;
+
+		if (!zalloc_cpumask_var(
+			&dd->msix_entries[i].mask,
+			GFP_KERNEL))
+			goto bail;
+		if (handler == sdma_interrupt) {
+			dd_dev_info(dd, "sdma engine %d cpu %d\n",
+				sde->this_idx, sdma_cpu);
+			cpumask_set_cpu(sdma_cpu, dd->msix_entries[i].mask);
+			sdma_cpu = cpumask_next(sdma_cpu, def);
+			if (sdma_cpu >= nr_cpu_ids)
+				sdma_cpu = cpumask_first(def);
+		} else if (handler == receive_context_interrupt) {
+			dd_dev_info(dd, "rcv ctxt %d cpu %d\n",
+				rcd->ctxt, rcv_cpu);
+			cpumask_set_cpu(rcv_cpu, dd->msix_entries[i].mask);
+			rcv_cpu = cpumask_next(rcv_cpu, rcv);
+			if (rcv_cpu >= nr_cpu_ids)
+				rcv_cpu = cpumask_first(rcv);
+		} else {
+			/* otherwise first def */
+			dd_dev_info(dd, "%s cpu %d\n",
+				err_info, cpumask_first(def));
+			cpumask_set_cpu(
+				cpumask_first(def), dd->msix_entries[i].mask);
+		}
+		irq_set_affinity_hint(
+			dd->msix_entries[i].msix.vector,
+			dd->msix_entries[i].mask);
+	}
+
+out:
+	free_cpumask_var(def);
+	free_cpumask_var(rcv);
+	return ret;
+bail:
+	ret = -ENOMEM;
+	goto  out;
+}
+
+/*
+ * Set the general handler to accept all interrupts, remap all
+ * chip interrupts back to MSI-X 0.
+ */
+static void reset_interrupts(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* all interrupts handled by the general handler */
+	for (i = 0; i < CCE_NUM_INT_CSRS; i++)
+		dd->gi_mask[i] = ~(u64)0;
+
+	/* all chip interrupts map to MSI-X 0 */
+	for (i = 0; i < CCE_NUM_INT_MAP_CSRS; i++)
+		write_csr(dd, CCE_INT_MAP + (8*i), 0);
+}
+
+static int set_up_interrupts(struct hfi1_devdata *dd)
+{
+	struct hfi1_msix_entry *entries;
+	u32 total, request;
+	int i, ret;
+	int single_interrupt = 0; /* we expect to have all the interrupts */
+
+	/*
+	 * Interrupt count:
+	 *	1 general, "slow path" interrupt (includes the SDMA engines
+	 *		slow source, SDMACleanupDone)
+	 *	N interrupts - one per used SDMA engine
+	 *	M interrupt - one per kernel receive context
+	 */
+	total = 1 + dd->num_sdma + dd->n_krcv_queues;
+
+	entries = kcalloc(total, sizeof(*entries), GFP_KERNEL);
+	if (!entries) {
+		dd_dev_err(dd, "cannot allocate msix table\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+	/* 1-1 MSI-X entry assignment */
+	for (i = 0; i < total; i++)
+		entries[i].msix.entry = i;
+
+	/* ask for MSI-X interrupts */
+	request = total;
+	request_msix(dd, &request, entries);
+
+	if (request == 0) {
+		/* using INTx */
+		/* dd->num_msix_entries already zero */
+		kfree(entries);
+		single_interrupt = 1;
+		dd_dev_err(dd, "MSI-X failed, using INTx interrupts\n");
+	} else {
+		/* using MSI-X */
+		dd->num_msix_entries = request;
+		dd->msix_entries = entries;
+
+		if (request != total) {
+			/* using MSI-X, with reduced interrupts */
+			dd_dev_err(
+				dd,
+				"cannot handle reduced interrupt case, want %u, got %u\n",
+				total, request);
+			ret = -EINVAL;
+			goto fail;
+		}
+		dd_dev_info(dd, "%u MSI-X interrupts allocated\n", total);
+	}
+
+	/* mask all interrupts */
+	set_intr_state(dd, 0);
+	/* clear all pending interrupts */
+	clear_all_interrupts(dd);
+
+	/* reset general handler mask, chip MSI-X mappings */
+	reset_interrupts(dd);
+
+	if (single_interrupt)
+		ret = request_intx_irq(dd);
+	else
+		ret = request_msix_irqs(dd);
+	if (ret)
+		goto fail;
+
+	return 0;
+
+fail:
+	clean_up_interrupts(dd);
+	return ret;
+}
+
+/*
+ * Set up context values in dd.  Sets:
+ *
+ *	num_rcv_contexts - number of contexts being used
+ *	n_krcv_queues - number of kernel contexts
+ *	first_user_ctxt - first non-kernel context in array of contexts
+ *	freectxts  - number of free user contexts
+ *	num_send_contexts - number of PIO send contexts being used
+ */
+static int set_up_context_variables(struct hfi1_devdata *dd)
+{
+	int num_kernel_contexts;
+	int num_user_contexts;
+	int total_contexts;
+	int ret;
+	unsigned ngroups;
+
+	/*
+	 * Kernel contexts: (to be fixed later):
+	 * - min or 2 or 1 context/numa
+	 * - Context 0 - default/errors
+	 * - Context 1 - VL15
+	 */
+	if (n_krcvqs)
+		num_kernel_contexts = n_krcvqs + MIN_KERNEL_KCTXTS;
+	else
+		num_kernel_contexts = num_online_nodes();
+	num_kernel_contexts =
+		max_t(int, MIN_KERNEL_KCTXTS, num_kernel_contexts);
+
+	/*
+	 * User contexts: (to be fixed later)
+	 *	- default to 1 user context per CPU
+	 */
+	num_user_contexts = num_online_cpus();
+
+	total_contexts = num_kernel_contexts + num_user_contexts;
+
+	/*
+	 * Adjust the counts given a global max.
+	 *	- always cut out user contexts before kernel contexts
+	 *	- only extend user contexts
+	 */
+	if (num_rcv_contexts) {
+		if (num_rcv_contexts < total_contexts) {
+			/* cut back, user first */
+			if (num_rcv_contexts < num_kernel_contexts) {
+				num_kernel_contexts = num_rcv_contexts;
+				num_user_contexts = 0;
+			} else {
+				num_user_contexts = num_rcv_contexts
+							- num_kernel_contexts;
+			}
+		} else {
+			/* extend the user context count */
+			num_user_contexts = num_rcv_contexts
+							- num_kernel_contexts;
+		}
+		/* recalculate */
+		total_contexts = num_kernel_contexts + num_user_contexts;
+	}
+
+	if (total_contexts > dd->chip_rcv_contexts) {
+		/* don't silently adjust, complain and fail */
+		dd_dev_err(dd,
+			"not enough physical contexts: want %d, have %d\n",
+			(int)total_contexts, (int)dd->chip_rcv_contexts);
+		return -ENOSPC;
+	}
+
+	/* the first N are kernel contexts, the rest are user contexts */
+	dd->num_rcv_contexts = total_contexts;
+	dd->n_krcv_queues = num_kernel_contexts;
+	dd->first_user_ctxt = num_kernel_contexts;
+	dd->freectxts = num_user_contexts;
+	dd_dev_info(dd,
+		"rcv contexts: chip %d, used %d (kernel %d, user %d)\n",
+		(int)dd->chip_rcv_contexts,
+		(int)dd->num_rcv_contexts,
+		(int)dd->n_krcv_queues,
+		(int)dd->num_rcv_contexts - dd->n_krcv_queues);
+
+	/*
+	 * Receive array allocation:
+	 *   All RcvArray entries are divided into groups of 8. This
+	 *   is required by the hardware and will speed up writes to
+	 *   consecutive entries by using write-combining of the entire
+	 *   cacheline.
+	 *
+	 *   The number of groups are evenly divided among all contexts.
+	 *   any left over groups will be given to the first N user
+	 *   contexts.
+	 */
+	dd->rcv_entries.group_size = RCV_INCREMENT;
+	ngroups = dd->chip_rcv_array_count / dd->rcv_entries.group_size;
+	dd->rcv_entries.ngroups = ngroups / dd->num_rcv_contexts;
+	dd->rcv_entries.nctxt_extra = ngroups -
+		(dd->num_rcv_contexts * dd->rcv_entries.ngroups);
+	dd_dev_info(dd, "RcvArray groups %u, ctxts extra %u\n",
+		    dd->rcv_entries.ngroups,
+		    dd->rcv_entries.nctxt_extra);
+	if (dd->rcv_entries.ngroups * dd->rcv_entries.group_size >
+	    MAX_EAGER_ENTRIES * 2) {
+		dd->rcv_entries.ngroups = (MAX_EAGER_ENTRIES * 2) /
+			dd->rcv_entries.group_size;
+		dd_dev_info(dd,
+		   "RcvArray group count too high, change to %u\n",
+		   dd->rcv_entries.ngroups);
+		dd->rcv_entries.nctxt_extra = 0;
+	}
+	/*
+	 * PIO send contexts
+	 */
+	ret = init_sc_pools_and_sizes(dd);
+	if (ret >= 0) {	/* success */
+		dd->num_send_contexts = ret;
+		dd_dev_info(
+			dd,
+			"send contexts: chip %d, used %d (kernel %d, ack %d, user %d)\n",
+			dd->chip_send_contexts,
+			dd->num_send_contexts,
+			dd->sc_sizes[SC_KERNEL].count,
+			dd->sc_sizes[SC_ACK].count,
+			dd->sc_sizes[SC_USER].count);
+		ret = 0;	/* success */
+	}
+
+	return ret;
+}
+
+/*
+ * Set the device/port partition key table. The MAD code
+ * will ensure that, at least, the partial management
+ * partition key is present in the table.
+ */
+static void set_partition_keys(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 reg = 0;
+	int i;
+
+	dd_dev_info(dd, "Setting partition keys\n");
+	for (i = 0; i < hfi1_get_npkeys(dd); i++) {
+		reg |= (ppd->pkeys[i] &
+			RCV_PARTITION_KEY_PARTITION_KEY_A_MASK) <<
+			((i % 4) *
+			 RCV_PARTITION_KEY_PARTITION_KEY_B_SHIFT);
+		/* Each register holds 4 PKey values. */
+		if ((i % 4) == 3) {
+			write_csr(dd, RCV_PARTITION_KEY +
+				  ((i - 3) * 2), reg);
+			reg = 0;
+		}
+	}
+
+	add_rcvctrl(dd, RCV_CTRL_RCV_PARTITION_KEY_ENABLE_SMASK);
+}
+
+/*
+ * These CSRs and memories are uninitialized on reset and must be
+ * written before reading to set the ECC/parity bits.
+ *
+ * NOTE: All user context CSRs that are not mmaped write-only
+ * (e.g. the TID flows) must be initialized even if the driver never
+ * reads them.
+ */
+static void write_uninitialized_csrs_and_memories(struct hfi1_devdata *dd)
+{
+	int i, j;
+
+	/* CceIntMap */
+	for (i = 0; i < CCE_NUM_INT_MAP_CSRS; i++)
+		write_csr(dd, CCE_INT_MAP+(8*i), 0);
+
+	/* SendCtxtCreditReturnAddr */
+	for (i = 0; i < dd->chip_send_contexts; i++)
+		write_kctxt_csr(dd, i, SEND_CTXT_CREDIT_RETURN_ADDR, 0);
+
+	/* PIO Send buffers */
+	/* SDMA Send buffers */
+	/* These are not normally read, and (presently) have no method
+	   to be read, so are not pre-initialized */
+
+	/* RcvHdrAddr */
+	/* RcvHdrTailAddr */
+	/* RcvTidFlowTable */
+	for (i = 0; i < dd->chip_rcv_contexts; i++) {
+		write_kctxt_csr(dd, i, RCV_HDR_ADDR, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_TAIL_ADDR, 0);
+		for (j = 0; j < RXE_NUM_TID_FLOWS; j++)
+			write_uctxt_csr(dd, i, RCV_TID_FLOW_TABLE+(8*j), 0);
+	}
+
+	/* RcvArray */
+	for (i = 0; i < dd->chip_rcv_array_count; i++)
+		write_csr(dd, RCV_ARRAY + (8*i),
+					RCV_ARRAY_RT_WRITE_ENABLE_SMASK);
+
+	/* RcvQPMapTable */
+	for (i = 0; i < 32; i++)
+		write_csr(dd, RCV_QP_MAP_TABLE + (8 * i), 0);
+}
+
+/*
+ * Use the ctrl_bits in CceCtrl to clear the status_bits in CceStatus.
+ */
+static void clear_cce_status(struct hfi1_devdata *dd, u64 status_bits,
+			     u64 ctrl_bits)
+{
+	unsigned long timeout;
+	u64 reg;
+
+	/* is the condition present? */
+	reg = read_csr(dd, CCE_STATUS);
+	if ((reg & status_bits) == 0)
+		return;
+
+	/* clear the condition */
+	write_csr(dd, CCE_CTRL, ctrl_bits);
+
+	/* wait for the condition to clear */
+	timeout = jiffies + msecs_to_jiffies(CCE_STATUS_TIMEOUT);
+	while (1) {
+		reg = read_csr(dd, CCE_STATUS);
+		if ((reg & status_bits) == 0)
+			return;
+		if (time_after(jiffies, timeout)) {
+			dd_dev_err(dd,
+				"Timeout waiting for CceStatus to clear bits 0x%llx, remaining 0x%llx\n",
+				status_bits, reg & status_bits);
+			return;
+		}
+		udelay(1);
+	}
+}
+
+/* set CCE CSRs to chip reset defaults */
+static void reset_cce_csrs(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* CCE_REVISION read-only */
+	/* CCE_REVISION2 read-only */
+	/* CCE_CTRL - bits clear automatically */
+	/* CCE_STATUS read-only, use CceCtrl to clear */
+	clear_cce_status(dd, ALL_FROZE, CCE_CTRL_SPC_UNFREEZE_SMASK);
+	clear_cce_status(dd, ALL_TXE_PAUSE, CCE_CTRL_TXE_RESUME_SMASK);
+	clear_cce_status(dd, ALL_RXE_PAUSE, CCE_CTRL_RXE_RESUME_SMASK);
+	for (i = 0; i < CCE_NUM_SCRATCH; i++)
+		write_csr(dd, CCE_SCRATCH + (8 * i), 0);
+	/* CCE_ERR_STATUS read-only */
+	write_csr(dd, CCE_ERR_MASK, 0);
+	write_csr(dd, CCE_ERR_CLEAR, ~0ull);
+	/* CCE_ERR_FORCE leave alone */
+	for (i = 0; i < CCE_NUM_32_BIT_COUNTERS; i++)
+		write_csr(dd, CCE_COUNTER_ARRAY32 + (8 * i), 0);
+	write_csr(dd, CCE_DC_CTRL, CCE_DC_CTRL_RESETCSR);
+	/* CCE_PCIE_CTRL leave alone */
+	for (i = 0; i < CCE_NUM_MSIX_VECTORS; i++) {
+		write_csr(dd, CCE_MSIX_TABLE_LOWER + (8 * i), 0);
+		write_csr(dd, CCE_MSIX_TABLE_UPPER + (8 * i),
+					CCE_MSIX_TABLE_UPPER_RESETCSR);
+	}
+	for (i = 0; i < CCE_NUM_MSIX_PBAS; i++) {
+		/* CCE_MSIX_PBA read-only */
+		write_csr(dd, CCE_MSIX_INT_GRANTED, ~0ull);
+		write_csr(dd, CCE_MSIX_VEC_CLR_WITHOUT_INT, ~0ull);
+	}
+	for (i = 0; i < CCE_NUM_INT_MAP_CSRS; i++)
+		write_csr(dd, CCE_INT_MAP, 0);
+	for (i = 0; i < CCE_NUM_INT_CSRS; i++) {
+		/* CCE_INT_STATUS read-only */
+		write_csr(dd, CCE_INT_MASK + (8 * i), 0);
+		write_csr(dd, CCE_INT_CLEAR + (8 * i), ~0ull);
+		/* CCE_INT_FORCE leave alone */
+		/* CCE_INT_BLOCKED read-only */
+	}
+	for (i = 0; i < CCE_NUM_32_BIT_INT_COUNTERS; i++)
+		write_csr(dd, CCE_INT_COUNTER_ARRAY32 + (8 * i), 0);
+}
+
+/* set ASIC CSRs to chip reset defaults */
+static void reset_asic_csrs(struct hfi1_devdata *dd)
+{
+	static DEFINE_MUTEX(asic_mutex);
+	static int called;
+	int i;
+
+	/*
+	 * If the HFIs are shared between separate nodes or VMs,
+	 * then more will need to be done here.  One idea is a module
+	 * parameter that returns early, letting the first power-on or
+	 * a known first load do the reset and blocking all others.
+	 */
+
+	/*
+	 * These CSRs should only be reset once - the first one here will
+	 * do the work.  Use a mutex so that a non-first caller waits until
+	 * the first is finished before it can proceed.
+	 */
+	mutex_lock(&asic_mutex);
+	if (called)
+		goto done;
+	called = 1;
+
+	if (dd->icode != ICODE_FPGA_EMULATION) {
+		/* emulation does not have an SBus - leave these alone */
+		/*
+		 * All writes to ASIC_CFG_SBUS_REQUEST do something.
+		 * Notes:
+		 * o The reset is not zero if aimed at the core.  See the
+		 *   SBus documentation for details.
+		 * o If the SBus firmware has been updated (e.g. by the BIOS),
+		 *   will the reset revert that?
+		 */
+		/* ASIC_CFG_SBUS_REQUEST leave alone */
+		write_csr(dd, ASIC_CFG_SBUS_EXECUTE, 0);
+	}
+	/* ASIC_SBUS_RESULT read-only */
+	write_csr(dd, ASIC_STS_SBUS_COUNTERS, 0);
+	for (i = 0; i < ASIC_NUM_SCRATCH; i++)
+		write_csr(dd, ASIC_CFG_SCRATCH + (8 * i), 0);
+	write_csr(dd, ASIC_CFG_MUTEX, 0);	/* this will clear it */
+	write_csr(dd, ASIC_CFG_DRV_STR, 0);
+	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0);
+	/* ASIC_STS_THERM read-only */
+	/* ASIC_CFG_RESET leave alone */
+
+	write_csr(dd, ASIC_PCIE_SD_HOST_CMD, 0);
+	/* ASIC_PCIE_SD_HOST_STATUS read-only */
+	write_csr(dd, ASIC_PCIE_SD_INTRPT_DATA_CODE, 0);
+	write_csr(dd, ASIC_PCIE_SD_INTRPT_ENABLE, 0);
+	/* ASIC_PCIE_SD_INTRPT_PROGRESS read-only */
+	write_csr(dd, ASIC_PCIE_SD_INTRPT_STATUS, ~0ull); /* clear */
+	/* ASIC_HFI0_PCIE_SD_INTRPT_RSPD_DATA read-only */
+	/* ASIC_HFI1_PCIE_SD_INTRPT_RSPD_DATA read-only */
+	for (i = 0; i < 16; i++)
+		write_csr(dd, ASIC_PCIE_SD_INTRPT_LIST + (8 * i), 0);
+
+	/* ASIC_GPIO_IN read-only */
+	write_csr(dd, ASIC_GPIO_OE, 0);
+	write_csr(dd, ASIC_GPIO_INVERT, 0);
+	write_csr(dd, ASIC_GPIO_OUT, 0);
+	write_csr(dd, ASIC_GPIO_MASK, 0);
+	/* ASIC_GPIO_STATUS read-only */
+	write_csr(dd, ASIC_GPIO_CLEAR, ~0ull);
+	/* ASIC_GPIO_FORCE leave alone */
+
+	/* ASIC_QSFP1_IN read-only */
+	write_csr(dd, ASIC_QSFP1_OE, 0);
+	write_csr(dd, ASIC_QSFP1_INVERT, 0);
+	write_csr(dd, ASIC_QSFP1_OUT, 0);
+	write_csr(dd, ASIC_QSFP1_MASK, 0);
+	/* ASIC_QSFP1_STATUS read-only */
+	write_csr(dd, ASIC_QSFP1_CLEAR, ~0ull);
+	/* ASIC_QSFP1_FORCE leave alone */
+
+	/* ASIC_QSFP2_IN read-only */
+	write_csr(dd, ASIC_QSFP2_OE, 0);
+	write_csr(dd, ASIC_QSFP2_INVERT, 0);
+	write_csr(dd, ASIC_QSFP2_OUT, 0);
+	write_csr(dd, ASIC_QSFP2_MASK, 0);
+	/* ASIC_QSFP2_STATUS read-only */
+	write_csr(dd, ASIC_QSFP2_CLEAR, ~0ull);
+	/* ASIC_QSFP2_FORCE leave alone */
+
+	write_csr(dd, ASIC_EEP_CTL_STAT, ASIC_EEP_CTL_STAT_RESETCSR);
+	/* this also writes a NOP command, clearing paging mode */
+	write_csr(dd, ASIC_EEP_ADDR_CMD, 0);
+	write_csr(dd, ASIC_EEP_DATA, 0);
+
+done:
+	mutex_unlock(&asic_mutex);
+}
+
+/* set MISC CSRs to chip reset defaults */
+static void reset_misc_csrs(struct hfi1_devdata *dd)
+{
+	int i;
+
+	for (i = 0; i < 32; i++) {
+		write_csr(dd, MISC_CFG_RSA_R2 + (8 * i), 0);
+		write_csr(dd, MISC_CFG_RSA_SIGNATURE + (8 * i), 0);
+		write_csr(dd, MISC_CFG_RSA_MODULUS + (8 * i), 0);
+	}
+	/* MISC_CFG_SHA_PRELOAD leave alone - always reads 0 and can
+	   only be written 128-byte chunks */
+	/* init RSA engine to clear lingering errors */
+	write_csr(dd, MISC_CFG_RSA_CMD, 1);
+	write_csr(dd, MISC_CFG_RSA_MU, 0);
+	write_csr(dd, MISC_CFG_FW_CTRL, 0);
+	/* MISC_STS_8051_DIGEST read-only */
+	/* MISC_STS_SBM_DIGEST read-only */
+	/* MISC_STS_PCIE_DIGEST read-only */
+	/* MISC_STS_FAB_DIGEST read-only */
+	/* MISC_ERR_STATUS read-only */
+	write_csr(dd, MISC_ERR_MASK, 0);
+	write_csr(dd, MISC_ERR_CLEAR, ~0ull);
+	/* MISC_ERR_FORCE leave alone */
+}
+
+/* set TXE CSRs to chip reset defaults */
+static void reset_txe_csrs(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/*
+	 * TXE Kernel CSRs
+	 */
+	write_csr(dd, SEND_CTRL, 0);
+	__cm_reset(dd, 0);	/* reset CM internal state */
+	/* SEND_CONTEXTS read-only */
+	/* SEND_DMA_ENGINES read-only */
+	/* SEND_PIO_MEM_SIZE read-only */
+	/* SEND_DMA_MEM_SIZE read-only */
+	write_csr(dd, SEND_HIGH_PRIORITY_LIMIT, 0);
+	pio_reset_all(dd);	/* SEND_PIO_INIT_CTXT */
+	/* SEND_PIO_ERR_STATUS read-only */
+	write_csr(dd, SEND_PIO_ERR_MASK, 0);
+	write_csr(dd, SEND_PIO_ERR_CLEAR, ~0ull);
+	/* SEND_PIO_ERR_FORCE leave alone */
+	/* SEND_DMA_ERR_STATUS read-only */
+	write_csr(dd, SEND_DMA_ERR_MASK, 0);
+	write_csr(dd, SEND_DMA_ERR_CLEAR, ~0ull);
+	/* SEND_DMA_ERR_FORCE leave alone */
+	/* SEND_EGRESS_ERR_STATUS read-only */
+	write_csr(dd, SEND_EGRESS_ERR_MASK, 0);
+	write_csr(dd, SEND_EGRESS_ERR_CLEAR, ~0ull);
+	/* SEND_EGRESS_ERR_FORCE leave alone */
+	write_csr(dd, SEND_BTH_QP, 0);
+	write_csr(dd, SEND_STATIC_RATE_CONTROL, 0);
+	write_csr(dd, SEND_SC2VLT0, 0);
+	write_csr(dd, SEND_SC2VLT1, 0);
+	write_csr(dd, SEND_SC2VLT2, 0);
+	write_csr(dd, SEND_SC2VLT3, 0);
+	write_csr(dd, SEND_LEN_CHECK0, 0);
+	write_csr(dd, SEND_LEN_CHECK1, 0);
+	/* SEND_ERR_STATUS read-only */
+	write_csr(dd, SEND_ERR_MASK, 0);
+	write_csr(dd, SEND_ERR_CLEAR, ~0ull);
+	/* SEND_ERR_FORCE read-only */
+	for (i = 0; i < VL_ARB_LOW_PRIO_TABLE_SIZE; i++)
+		write_csr(dd, SEND_LOW_PRIORITY_LIST + (8*i), 0);
+	for (i = 0; i < VL_ARB_HIGH_PRIO_TABLE_SIZE; i++)
+		write_csr(dd, SEND_HIGH_PRIORITY_LIST + (8*i), 0);
+	for (i = 0; i < dd->chip_send_contexts/NUM_CONTEXTS_PER_SET; i++)
+		write_csr(dd, SEND_CONTEXT_SET_CTRL + (8*i), 0);
+	for (i = 0; i < TXE_NUM_32_BIT_COUNTER; i++)
+		write_csr(dd, SEND_COUNTER_ARRAY32 + (8*i), 0);
+	for (i = 0; i < TXE_NUM_64_BIT_COUNTER; i++)
+		write_csr(dd, SEND_COUNTER_ARRAY64 + (8*i), 0);
+	write_csr(dd, SEND_CM_CTRL, SEND_CM_CTRL_RESETCSR);
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT,
+					SEND_CM_GLOBAL_CREDIT_RESETCSR);
+	/* SEND_CM_CREDIT_USED_STATUS read-only */
+	write_csr(dd, SEND_CM_TIMER_CTRL, 0);
+	write_csr(dd, SEND_CM_LOCAL_AU_TABLE0_TO3, 0);
+	write_csr(dd, SEND_CM_LOCAL_AU_TABLE4_TO7, 0);
+	write_csr(dd, SEND_CM_REMOTE_AU_TABLE0_TO3, 0);
+	write_csr(dd, SEND_CM_REMOTE_AU_TABLE4_TO7, 0);
+	for (i = 0; i < TXE_NUM_DATA_VL; i++)
+		write_csr(dd, SEND_CM_CREDIT_VL + (8*i), 0);
+	write_csr(dd, SEND_CM_CREDIT_VL15, 0);
+	/* SEND_CM_CREDIT_USED_VL read-only */
+	/* SEND_CM_CREDIT_USED_VL15 read-only */
+	/* SEND_EGRESS_CTXT_STATUS read-only */
+	/* SEND_EGRESS_SEND_DMA_STATUS read-only */
+	write_csr(dd, SEND_EGRESS_ERR_INFO, ~0ull);
+	/* SEND_EGRESS_ERR_INFO read-only */
+	/* SEND_EGRESS_ERR_SOURCE read-only */
+
+	/*
+	 * TXE Per-Context CSRs
+	 */
+	for (i = 0; i < dd->chip_send_contexts; i++) {
+		write_kctxt_csr(dd, i, SEND_CTXT_CTRL, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CREDIT_CTRL, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CREDIT_RETURN_ADDR, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CREDIT_FORCE, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_ERR_MASK, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_ERR_CLEAR, ~0ull);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_ENABLE, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_VL, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_JOB_KEY, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_PARTITION_KEY, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_SLID, 0);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_OPCODE, 0);
+	}
+
+	/*
+	 * TXE Per-SDMA CSRs
+	 */
+	for (i = 0; i < dd->chip_sdma_engines; i++) {
+		write_kctxt_csr(dd, i, SEND_DMA_CTRL, 0);
+		/* SEND_DMA_STATUS read-only */
+		write_kctxt_csr(dd, i, SEND_DMA_BASE_ADDR, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_LEN_GEN, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_TAIL, 0);
+		/* SEND_DMA_HEAD read-only */
+		write_kctxt_csr(dd, i, SEND_DMA_HEAD_ADDR, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_PRIORITY_THLD, 0);
+		/* SEND_DMA_IDLE_CNT read-only */
+		write_kctxt_csr(dd, i, SEND_DMA_RELOAD_CNT, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_DESC_CNT, 0);
+		/* SEND_DMA_DESC_FETCHED_CNT read-only */
+		/* SEND_DMA_ENG_ERR_STATUS read-only */
+		write_kctxt_csr(dd, i, SEND_DMA_ENG_ERR_MASK, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_ENG_ERR_CLEAR, ~0ull);
+		/* SEND_DMA_ENG_ERR_FORCE leave alone */
+		write_kctxt_csr(dd, i, SEND_DMA_CHECK_ENABLE, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_CHECK_VL, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_CHECK_JOB_KEY, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_CHECK_PARTITION_KEY, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_CHECK_SLID, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_CHECK_OPCODE, 0);
+		write_kctxt_csr(dd, i, SEND_DMA_MEMORY, 0);
+	}
+}
+
+/*
+ * Expect on entry:
+ * o Packet ingress is disabled, i.e. RcvCtrl.RcvPortEnable == 0
+ */
+static void init_rbufs(struct hfi1_devdata *dd)
+{
+	u64 reg;
+	int count;
+
+	/*
+	 * Wait for DMA to stop: RxRbufPktPending and RxPktInProgress are
+	 * clear.
+	 */
+	count = 0;
+	while (1) {
+		reg = read_csr(dd, RCV_STATUS);
+		if ((reg & (RCV_STATUS_RX_RBUF_PKT_PENDING_SMASK
+			    | RCV_STATUS_RX_PKT_IN_PROGRESS_SMASK)) == 0)
+			break;
+		/*
+		 * Give up after 1ms - maximum wait time.
+		 *
+		 * RBuf size is 148KiB.  Slowest possible is PCIe Gen1 x1 at
+		 * 250MB/s bandwidth.  Lower rate to 66% for overhead to get:
+		 *	148 KB / (66% * 250MB/s) = 920us
+		 */
+		if (count++ > 500) {
+			dd_dev_err(dd,
+				"%s: in-progress DMA not clearing: RcvStatus 0x%llx, continuing\n",
+				__func__, reg);
+			break;
+		}
+		udelay(2); /* do not busy-wait the CSR */
+	}
+
+	/* start the init - expect RcvCtrl to be 0 */
+	write_csr(dd, RCV_CTRL, RCV_CTRL_RX_RBUF_INIT_SMASK);
+
+	/*
+	 * Read to force the write of Rcvtrl.RxRbufInit.  There is a brief
+	 * period after the write before RcvStatus.RxRbufInitDone is valid.
+	 * The delay in the first run through the loop below is sufficient and
+	 * required before the first read of RcvStatus.RxRbufInintDone.
+	 */
+	read_csr(dd, RCV_CTRL);
+
+	/* wait for the init to finish */
+	count = 0;
+	while (1) {
+		/* delay is required first time through - see above */
+		udelay(2); /* do not busy-wait the CSR */
+		reg = read_csr(dd, RCV_STATUS);
+		if (reg & (RCV_STATUS_RX_RBUF_INIT_DONE_SMASK))
+			break;
+
+		/* give up after 100us - slowest possible at 33MHz is 73us */
+		if (count++ > 50) {
+			dd_dev_err(dd,
+				"%s: RcvStatus.RxRbufInit not set, continuing\n",
+				__func__);
+			break;
+		}
+	}
+}
+
+/* set RXE CSRs to chip reset defaults */
+static void reset_rxe_csrs(struct hfi1_devdata *dd)
+{
+	int i, j;
+
+	/*
+	 * RXE Kernel CSRs
+	 */
+	write_csr(dd, RCV_CTRL, 0);
+	init_rbufs(dd);
+	/* RCV_STATUS read-only */
+	/* RCV_CONTEXTS read-only */
+	/* RCV_ARRAY_CNT read-only */
+	/* RCV_BUF_SIZE read-only */
+	write_csr(dd, RCV_BTH_QP, 0);
+	write_csr(dd, RCV_MULTICAST, 0);
+	write_csr(dd, RCV_BYPASS, 0);
+	write_csr(dd, RCV_VL15, 0);
+	/* this is a clear-down */
+	write_csr(dd, RCV_ERR_INFO,
+			RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SMASK);
+	/* RCV_ERR_STATUS read-only */
+	write_csr(dd, RCV_ERR_MASK, 0);
+	write_csr(dd, RCV_ERR_CLEAR, ~0ull);
+	/* RCV_ERR_FORCE leave alone */
+	for (i = 0; i < 32; i++)
+		write_csr(dd, RCV_QP_MAP_TABLE + (8 * i), 0);
+	for (i = 0; i < 4; i++)
+		write_csr(dd, RCV_PARTITION_KEY + (8 * i), 0);
+	for (i = 0; i < RXE_NUM_32_BIT_COUNTERS; i++)
+		write_csr(dd, RCV_COUNTER_ARRAY32 + (8 * i), 0);
+	for (i = 0; i < RXE_NUM_64_BIT_COUNTERS; i++)
+		write_csr(dd, RCV_COUNTER_ARRAY64 + (8 * i), 0);
+	for (i = 0; i < RXE_NUM_RSM_INSTANCES; i++) {
+		write_csr(dd, RCV_RSM_CFG + (8 * i), 0);
+		write_csr(dd, RCV_RSM_SELECT + (8 * i), 0);
+		write_csr(dd, RCV_RSM_MATCH + (8 * i), 0);
+	}
+	for (i = 0; i < 32; i++)
+		write_csr(dd, RCV_RSM_MAP_TABLE + (8 * i), 0);
+
+	/*
+	 * RXE Kernel and User Per-Context CSRs
+	 */
+	for (i = 0; i < dd->chip_rcv_contexts; i++) {
+		/* kernel */
+		write_kctxt_csr(dd, i, RCV_CTXT_CTRL, 0);
+		/* RCV_CTXT_STATUS read-only */
+		write_kctxt_csr(dd, i, RCV_EGR_CTRL, 0);
+		write_kctxt_csr(dd, i, RCV_TID_CTRL, 0);
+		write_kctxt_csr(dd, i, RCV_KEY_CTRL, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_ADDR, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_CNT, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_ENT_SIZE, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_SIZE, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_TAIL_ADDR, 0);
+		write_kctxt_csr(dd, i, RCV_AVAIL_TIME_OUT, 0);
+		write_kctxt_csr(dd, i, RCV_HDR_OVFL_CNT, 0);
+
+		/* user */
+		/* RCV_HDR_TAIL read-only */
+		write_uctxt_csr(dd, i, RCV_HDR_HEAD, 0);
+		/* RCV_EGR_INDEX_TAIL read-only */
+		write_uctxt_csr(dd, i, RCV_EGR_INDEX_HEAD, 0);
+		/* RCV_EGR_OFFSET_TAIL read-only */
+		for (j = 0; j < RXE_NUM_TID_FLOWS; j++) {
+			write_uctxt_csr(dd, i, RCV_TID_FLOW_TABLE + (8 * j),
+				0);
+		}
+	}
+}
+
+/*
+ * Set sc2vl tables.
+ *
+ * They power on to zeros, so to avoid send context errors
+ * they need to be set:
+ *
+ * SC 0-7 -> VL 0-7 (respectively)
+ * SC 15  -> VL 15
+ * otherwise
+ *        -> VL 0
+ */
+static void init_sc2vl_tables(struct hfi1_devdata *dd)
+{
+	int i;
+	/* init per architecture spec, constrained by hardware capability */
+
+	/* HFI maps sent packets */
+	write_csr(dd, SEND_SC2VLT0, SC2VL_VAL(
+		0,
+		0, 0, 1, 1,
+		2, 2, 3, 3,
+		4, 4, 5, 5,
+		6, 6, 7, 7));
+	write_csr(dd, SEND_SC2VLT1, SC2VL_VAL(
+		1,
+		8, 0, 9, 0,
+		10, 0, 11, 0,
+		12, 0, 13, 0,
+		14, 0, 15, 15));
+	write_csr(dd, SEND_SC2VLT2, SC2VL_VAL(
+		2,
+		16, 0, 17, 0,
+		18, 0, 19, 0,
+		20, 0, 21, 0,
+		22, 0, 23, 0));
+	write_csr(dd, SEND_SC2VLT3, SC2VL_VAL(
+		3,
+		24, 0, 25, 0,
+		26, 0, 27, 0,
+		28, 0, 29, 0,
+		30, 0, 31, 0));
+
+	/* DC maps received packets */
+	write_csr(dd, DCC_CFG_SC_VL_TABLE_15_0, DC_SC_VL_VAL(
+		15_0,
+		0, 0, 1, 1,  2, 2,  3, 3,  4, 4,  5, 5,  6, 6,  7,  7,
+		8, 0, 9, 0, 10, 0, 11, 0, 12, 0, 13, 0, 14, 0, 15, 15));
+	write_csr(dd, DCC_CFG_SC_VL_TABLE_31_16, DC_SC_VL_VAL(
+		31_16,
+		16, 0, 17, 0, 18, 0, 19, 0, 20, 0, 21, 0, 22, 0, 23, 0,
+		24, 0, 25, 0, 26, 0, 27, 0, 28, 0, 29, 0, 30, 0, 31, 0));
+
+	/* initialize the cached sc2vl values consistently with h/w */
+	for (i = 0; i < 32; i++) {
+		if (i < 8 || i == 15)
+			*((u8 *)(dd->sc2vl) + i) = (u8)i;
+		else
+			*((u8 *)(dd->sc2vl) + i) = 0;
+	}
+}
+
+/*
+ * Read chip sizes and then reset parts to sane, disabled, values.  We cannot
+ * depend on the chip going through a power-on reset - a driver may be loaded
+ * and unloaded many times.
+ *
+ * Do not write any CSR values to the chip in this routine - there may be
+ * a reset following the (possible) FLR in this routine.
+ *
+ */
+static void init_chip(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/*
+	 * Put the HFI CSRs in a known state.
+	 * Combine this with a DC reset.
+	 *
+	 * Stop the device from doing anything while we do a
+	 * reset.  We know there are no other active users of
+	 * the device since we are now in charge.  Turn off
+	 * off all outbound and inbound traffic and make sure
+	 * the device does not generate any interrupts.
+	 */
+
+	/* disable send contexts and SDMA engines */
+	write_csr(dd, SEND_CTRL, 0);
+	for (i = 0; i < dd->chip_send_contexts; i++)
+		write_kctxt_csr(dd, i, SEND_CTXT_CTRL, 0);
+	for (i = 0; i < dd->chip_sdma_engines; i++)
+		write_kctxt_csr(dd, i, SEND_DMA_CTRL, 0);
+	/* disable port (turn off RXE inbound traffic) and contexts */
+	write_csr(dd, RCV_CTRL, 0);
+	for (i = 0; i < dd->chip_rcv_contexts; i++)
+		write_csr(dd, RCV_CTXT_CTRL, 0);
+	/* mask all interrupt sources */
+	for (i = 0; i < CCE_NUM_INT_CSRS; i++)
+		write_csr(dd, CCE_INT_MASK + (8*i), 0ull);
+
+	/*
+	 * DC Reset: do a full DC reset before the register clear.
+	 * A recommended length of time to hold is one CSR read,
+	 * so reread the CceDcCtrl.  Then, hold the DC in reset
+	 * across the clear.
+	 */
+	write_csr(dd, CCE_DC_CTRL, CCE_DC_CTRL_DC_RESET_SMASK);
+	(void) read_csr(dd, CCE_DC_CTRL);
+
+	if (use_flr) {
+		/*
+		 * A FLR will reset the SPC core and part of the PCIe.
+		 * The parts that need to be restored have already been
+		 * saved.
+		 */
+		dd_dev_info(dd, "Resetting CSRs with FLR\n");
+
+		/* do the FLR, the DC reset will remain */
+		hfi1_pcie_flr(dd);
+
+		/* restore command and BARs */
+		restore_pci_variables(dd);
+
+		if (is_a0(dd)) {
+			dd_dev_info(dd, "Resetting CSRs with FLR\n");
+			hfi1_pcie_flr(dd);
+			restore_pci_variables(dd);
+		}
+
+	} else {
+		dd_dev_info(dd, "Resetting CSRs with writes\n");
+		reset_cce_csrs(dd);
+		reset_txe_csrs(dd);
+		reset_rxe_csrs(dd);
+		reset_asic_csrs(dd);
+		reset_misc_csrs(dd);
+	}
+	/* clear the DC reset */
+	write_csr(dd, CCE_DC_CTRL, 0);
+	/* Set the LED off */
+	if (is_a0(dd))
+		setextled(dd, 0);
+	/*
+	 * Clear the QSFP reset.
+	 * A0 leaves the out lines floating on power on, then on an FLR
+	 * enforces a 0 on all out pins.  The driver does not touch
+	 * ASIC_QSFPn_OUT otherwise.  This leaves RESET_N low and
+	 * anything  plugged constantly in reset, if it pays attention
+	 * to RESET_N.
+	 * A prime example of this is SiPh. For now, set all pins high.
+	 * I2CCLK and I2CDAT will change per direction, and INT_N and
+	 * MODPRS_N are input only and their value is ignored.
+	 */
+	if (is_a0(dd)) {
+		write_csr(dd, ASIC_QSFP1_OUT, 0x1f);
+		write_csr(dd, ASIC_QSFP2_OUT, 0x1f);
+	}
+}
+
+static void init_early_variables(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* assign link credit variables */
+	dd->vau = CM_VAU;
+	dd->link_credits = CM_GLOBAL_CREDITS;
+	if (is_a0(dd))
+		dd->link_credits--;
+	dd->vcu = cu_to_vcu(hfi1_cu);
+	/* enough room for 8 MAD packets plus header - 17K */
+	dd->vl15_init = (8 * (2048 + 128)) / vau_to_au(dd->vau);
+	if (dd->vl15_init > dd->link_credits)
+		dd->vl15_init = dd->link_credits;
+
+	write_uninitialized_csrs_and_memories(dd);
+
+	if (HFI1_CAP_IS_KSET(PKEY_CHECK))
+		for (i = 0; i < dd->num_pports; i++) {
+			struct hfi1_pportdata *ppd = &dd->pport[i];
+
+			set_partition_keys(ppd);
+		}
+	init_sc2vl_tables(dd);
+}
+
+static void init_kdeth_qp(struct hfi1_devdata *dd)
+{
+	/* user changed the KDETH_QP */
+	if (kdeth_qp != 0 && kdeth_qp >= 0xff) {
+		/* out of range or illegal value */
+		dd_dev_err(dd, "Invalid KDETH queue pair prefix, ignoring");
+		kdeth_qp = 0;
+	}
+	if (kdeth_qp == 0)	/* not set, or failed range check */
+		kdeth_qp = DEFAULT_KDETH_QP;
+
+	write_csr(dd, SEND_BTH_QP,
+			(kdeth_qp & SEND_BTH_QP_KDETH_QP_MASK)
+				<< SEND_BTH_QP_KDETH_QP_SHIFT);
+
+	write_csr(dd, RCV_BTH_QP,
+			(kdeth_qp & RCV_BTH_QP_KDETH_QP_MASK)
+				<< RCV_BTH_QP_KDETH_QP_SHIFT);
+}
+
+/**
+ * init_qpmap_table
+ * @dd - device data
+ * @first_ctxt - first context
+ * @last_ctxt - first context
+ *
+ * This return sets the qpn mapping table that
+ * is indexed by qpn[8:1].
+ *
+ * The routine will round robin the 256 settings
+ * from first_ctxt to last_ctxt.
+ *
+ * The first/last looks ahead to having specialized
+ * receive contexts for mgmt and bypass.  Normal
+ * verbs traffic will assumed to be on a range
+ * of receive contexts.
+ */
+static void init_qpmap_table(struct hfi1_devdata *dd,
+			     u32 first_ctxt,
+			     u32 last_ctxt)
+{
+	u64 reg = 0;
+	u64 regno = RCV_QP_MAP_TABLE;
+	int i;
+	u64 ctxt = first_ctxt;
+
+	for (i = 0; i < 256;) {
+		if (ctxt == VL15CTXT) {
+			ctxt++;
+			if (ctxt > last_ctxt)
+				ctxt = first_ctxt;
+			continue;
+		}
+		reg |= ctxt << (8 * (i % 8));
+		i++;
+		ctxt++;
+		if (ctxt > last_ctxt)
+			ctxt = first_ctxt;
+		if (i % 8 == 0) {
+			write_csr(dd, regno, reg);
+			reg = 0;
+			regno += 8;
+		}
+	}
+	if (i % 8)
+		write_csr(dd, regno, reg);
+
+	add_rcvctrl(dd, RCV_CTRL_RCV_QP_MAP_ENABLE_SMASK
+			| RCV_CTRL_RCV_BYPASS_ENABLE_SMASK);
+}
+
+/**
+ * init_qos - init RX qos
+ * @dd - device data
+ * @first_context
+ *
+ * This routine initializes Rule 0 and the
+ * RSM map table to implement qos.
+ *
+ * If all of the limit tests succeed,
+ * qos is applied based on the array
+ * interpretation of krcvqs where
+ * entry 0 is VL0.
+ *
+ * The number of vl bits (n) and the number of qpn
+ * bits (m) are computed to feed both the RSM map table
+ * and the single rule.
+ *
+ */
+static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
+{
+	u8 max_by_vl = 0;
+	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
+	u64 *rsmmap;
+	u64 reg;
+	u8  rxcontext = is_a0(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
+
+	/* validate */
+	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
+	    num_vls == 1 ||
+	    krcvqsset <= 1)
+		goto bail;
+	for (i = 0; i < min_t(unsigned, num_vls, krcvqsset); i++)
+		if (krcvqs[i] > max_by_vl)
+			max_by_vl = krcvqs[i];
+	if (max_by_vl > 32)
+		goto bail;
+	qpns_per_vl = __roundup_pow_of_two(max_by_vl);
+	/* determine bits vl */
+	n = ilog2(num_vls);
+	/* determine bits for qpn */
+	m = ilog2(qpns_per_vl);
+	if ((m + n) > 7)
+		goto bail;
+	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
+		goto bail;
+	rsmmap = kmalloc_array(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
+	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
+	/* init the local copy of the table */
+	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
+		unsigned tctxt;
+
+		for (qpn = 0, tctxt = ctxt;
+		     krcvqs[i] && qpn < qpns_per_vl; qpn++) {
+			unsigned idx, regoff, regidx;
+
+			/* generate index <= 128 */
+			idx = (qpn << n) ^ i;
+			regoff = (idx % 8) * 8;
+			regidx = idx / 8;
+			reg = rsmmap[regidx];
+			/* replace 0xff with context number */
+			reg &= ~(RCV_RSM_MAP_TABLE_RCV_CONTEXT_A_MASK
+				<< regoff);
+			reg |= (u64)(tctxt++) << regoff;
+			rsmmap[regidx] = reg;
+			if (tctxt == ctxt + krcvqs[i])
+				tctxt = ctxt;
+		}
+		ctxt += krcvqs[i];
+	}
+	/* flush cached copies to chip */
+	for (i = 0; i < NUM_MAP_REGS; i++)
+		write_csr(dd, RCV_RSM_MAP_TABLE + (8 * i), rsmmap[i]);
+	/* add rule0 */
+	write_csr(dd, RCV_RSM_CFG /* + (8 * 0) */,
+		RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK
+			<< RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
+		2ull << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
+	write_csr(dd, RCV_RSM_SELECT /* + (8 * 0) */,
+		LRH_BTH_MATCH_OFFSET
+			<< RCV_RSM_SELECT_FIELD1_OFFSET_SHIFT |
+		LRH_SC_MATCH_OFFSET << RCV_RSM_SELECT_FIELD2_OFFSET_SHIFT |
+		LRH_SC_SELECT_OFFSET << RCV_RSM_SELECT_INDEX1_OFFSET_SHIFT |
+		((u64)n) << RCV_RSM_SELECT_INDEX1_WIDTH_SHIFT |
+		QPN_SELECT_OFFSET << RCV_RSM_SELECT_INDEX2_OFFSET_SHIFT |
+		((u64)m + (u64)n) << RCV_RSM_SELECT_INDEX2_WIDTH_SHIFT);
+	write_csr(dd, RCV_RSM_MATCH /* + (8 * 0) */,
+		LRH_BTH_MASK << RCV_RSM_MATCH_MASK1_SHIFT |
+		LRH_BTH_VALUE << RCV_RSM_MATCH_VALUE1_SHIFT |
+		LRH_SC_MASK << RCV_RSM_MATCH_MASK2_SHIFT |
+		LRH_SC_VALUE << RCV_RSM_MATCH_VALUE2_SHIFT);
+	/* Enable RSM */
+	add_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
+	kfree(rsmmap);
+	/* map everything else (non-VL15) to context 0 */
+	init_qpmap_table(
+		dd,
+		0,
+		0);
+	dd->qos_shift = n + 1;
+	return;
+bail:
+	dd->qos_shift = 1;
+	init_qpmap_table(
+		dd,
+		dd->n_krcv_queues > MIN_KERNEL_KCTXTS ? MIN_KERNEL_KCTXTS : 0,
+		dd->n_krcv_queues - 1);
+}
+
+static void init_rxe(struct hfi1_devdata *dd)
+{
+	/* enable all receive errors */
+	write_csr(dd, RCV_ERR_MASK, ~0ull);
+	/* setup QPN map table - start where VL15 context leaves off */
+	init_qos(
+		dd,
+		dd->n_krcv_queues > MIN_KERNEL_KCTXTS ? MIN_KERNEL_KCTXTS : 0);
+	/*
+	 * make sure RcvCtrl.RcvWcb <= PCIe Device Control
+	 * Register Max_Payload_Size (PCI_EXP_DEVCTL in Linux PCIe config
+	 * space, PciCfgCap2.MaxPayloadSize in HFI).  There is only one
+	 * invalid configuration: RcvCtrl.RcvWcb set to its max of 256 and
+	 * Max_PayLoad_Size set to its minimum of 128.
+	 *
+	 * Presently, RcvCtrl.RcvWcb is not modified from its default of 0
+	 * (64 bytes).  Max_Payload_Size is possibly modified upward in
+	 * tune_pcie_caps() which is called after this routine.
+	 */
+}
+
+static void init_other(struct hfi1_devdata *dd)
+{
+	/* enable all CCE errors */
+	write_csr(dd, CCE_ERR_MASK, ~0ull);
+	/* enable *some* Misc errors */
+	write_csr(dd, MISC_ERR_MASK, DRIVER_MISC_MASK);
+	/* enable all DC errors, except LCB */
+	write_csr(dd, DCC_ERR_FLG_EN, ~0ull);
+	write_csr(dd, DC_DC8051_ERR_EN, ~0ull);
+}
+
+/*
+ * Fill out the given AU table using the given CU.  A CU is defined in terms
+ * AUs.  The table is a an encoding: given the index, how many AUs does that
+ * represent?
+ *
+ * NOTE: Assumes that the register layout is the same for the
+ * local and remote tables.
+ */
+static void assign_cm_au_table(struct hfi1_devdata *dd, u32 cu,
+			       u32 csr0to3, u32 csr4to7)
+{
+	write_csr(dd, csr0to3,
+		   0ull <<
+			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE0_SHIFT
+		|  1ull <<
+			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE1_SHIFT
+		|  2ull * cu <<
+			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE2_SHIFT
+		|  4ull * cu <<
+			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE3_SHIFT);
+	write_csr(dd, csr4to7,
+		   8ull * cu <<
+			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE4_SHIFT
+		| 16ull * cu <<
+			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE5_SHIFT
+		| 32ull * cu <<
+			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE6_SHIFT
+		| 64ull * cu <<
+			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE7_SHIFT);
+
+}
+
+static void assign_local_cm_au_table(struct hfi1_devdata *dd, u8 vcu)
+{
+	assign_cm_au_table(dd, vcu_to_cu(vcu), SEND_CM_LOCAL_AU_TABLE0_TO3,
+					SEND_CM_LOCAL_AU_TABLE4_TO7);
+}
+
+void assign_remote_cm_au_table(struct hfi1_devdata *dd, u8 vcu)
+{
+	assign_cm_au_table(dd, vcu_to_cu(vcu), SEND_CM_REMOTE_AU_TABLE0_TO3,
+					SEND_CM_REMOTE_AU_TABLE4_TO7);
+}
+
+static void init_txe(struct hfi1_devdata *dd)
+{
+	int i;
+
+	/* enable all PIO, SDMA, general, and Egress errors */
+	write_csr(dd, SEND_PIO_ERR_MASK, ~0ull);
+	write_csr(dd, SEND_DMA_ERR_MASK, ~0ull);
+	write_csr(dd, SEND_ERR_MASK, ~0ull);
+	write_csr(dd, SEND_EGRESS_ERR_MASK, ~0ull);
+
+	/* enable all per-context and per-SDMA engine errors */
+	for (i = 0; i < dd->chip_send_contexts; i++)
+		write_kctxt_csr(dd, i, SEND_CTXT_ERR_MASK, ~0ull);
+	for (i = 0; i < dd->chip_sdma_engines; i++)
+		write_kctxt_csr(dd, i, SEND_DMA_ENG_ERR_MASK, ~0ull);
+
+	/* set the local CU to AU mapping */
+	assign_local_cm_au_table(dd, dd->vcu);
+}
+
+int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
+{
+	struct hfi1_ctxtdata *rcd = dd->rcd[ctxt];
+	unsigned sctxt;
+	int ret = 0;
+	u64 reg;
+
+	if (!rcd || !rcd->sc) {
+		ret = -EINVAL;
+		goto done;
+	}
+	sctxt = rcd->sc->hw_context;
+	reg = SEND_CTXT_CHECK_JOB_KEY_MASK_SMASK | /* mask is always 1's */
+		((jkey & SEND_CTXT_CHECK_JOB_KEY_VALUE_MASK) <<
+		 SEND_CTXT_CHECK_JOB_KEY_VALUE_SHIFT);
+	/* JOB_KEY_ALLOW_PERMISSIVE is not allowed by default */
+	if (HFI1_CAP_KGET_MASK(rcd->flags, ALLOW_PERM_JKEY))
+		reg |= SEND_CTXT_CHECK_JOB_KEY_ALLOW_PERMISSIVE_SMASK;
+	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_JOB_KEY, reg);
+	/*
+	 * Enable send-side J_KEY integrity check, unless this is A0 h/w
+	 * (due to A0 erratum).
+	 */
+	if (!is_a0(dd)) {
+		reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
+		reg |= SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
+		write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
+	}
+
+	/* Enable J_KEY check on receive context. */
+	reg = RCV_KEY_CTRL_JOB_KEY_ENABLE_SMASK |
+		((jkey & RCV_KEY_CTRL_JOB_KEY_VALUE_MASK) <<
+		 RCV_KEY_CTRL_JOB_KEY_VALUE_SHIFT);
+	write_kctxt_csr(dd, ctxt, RCV_KEY_CTRL, reg);
+done:
+	return ret;
+}
+
+int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt)
+{
+	struct hfi1_ctxtdata *rcd = dd->rcd[ctxt];
+	unsigned sctxt;
+	int ret = 0;
+	u64 reg;
+
+	if (!rcd || !rcd->sc) {
+		ret = -EINVAL;
+		goto done;
+	}
+	sctxt = rcd->sc->hw_context;
+	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_JOB_KEY, 0);
+	/*
+	 * Disable send-side J_KEY integrity check, unless this is A0 h/w.
+	 * This check would not have been enabled for A0 h/w, see
+	 * set_ctxt_jkey().
+	 */
+	if (!is_a0(dd)) {
+		reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
+		reg &= ~SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
+		write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
+	}
+	/* Turn off the J_KEY on the receive side */
+	write_kctxt_csr(dd, ctxt, RCV_KEY_CTRL, 0);
+done:
+	return ret;
+}
+
+int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey)
+{
+	struct hfi1_ctxtdata *rcd;
+	unsigned sctxt;
+	int ret = 0;
+	u64 reg;
+
+	if (ctxt < dd->num_rcv_contexts)
+		rcd = dd->rcd[ctxt];
+	else {
+		ret = -EINVAL;
+		goto done;
+	}
+	if (!rcd || !rcd->sc) {
+		ret = -EINVAL;
+		goto done;
+	}
+	sctxt = rcd->sc->hw_context;
+	reg = ((u64)pkey & SEND_CTXT_CHECK_PARTITION_KEY_VALUE_MASK) <<
+		SEND_CTXT_CHECK_PARTITION_KEY_VALUE_SHIFT;
+	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_PARTITION_KEY, reg);
+	reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
+	reg |= SEND_CTXT_CHECK_ENABLE_CHECK_PARTITION_KEY_SMASK;
+	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
+done:
+	return ret;
+}
+
+int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt)
+{
+	struct hfi1_ctxtdata *rcd;
+	unsigned sctxt;
+	int ret = 0;
+	u64 reg;
+
+	if (ctxt < dd->num_rcv_contexts)
+		rcd = dd->rcd[ctxt];
+	else {
+		ret = -EINVAL;
+		goto done;
+	}
+	if (!rcd || !rcd->sc) {
+		ret = -EINVAL;
+		goto done;
+	}
+	sctxt = rcd->sc->hw_context;
+	reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
+	reg &= ~SEND_CTXT_CHECK_ENABLE_CHECK_PARTITION_KEY_SMASK;
+	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
+	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_PARTITION_KEY, 0);
+done:
+	return ret;
+}
+
+/*
+ * Start doing the clean up the the chip. Our clean up happens in multiple
+ * stages and this is just the first.
+ */
+void hfi1_start_cleanup(struct hfi1_devdata *dd)
+{
+	free_cntrs(dd);
+	free_rcverr(dd);
+	clean_up_interrupts(dd);
+}
+
+#define HFI_BASE_GUID(dev) \
+	(be64_to_cpu((dev)->base_guid) & ~(1ULL << GUID_HFI_INDEX_SHIFT))
+
+/*
+ * Certain chip functions need to be initialized only once per asic
+ * instead of per-device. This function finds the peer device and
+ * checks whether that chip initialization needs to be done by this
+ * device.
+ */
+static void asic_should_init(struct hfi1_devdata *dd)
+{
+	unsigned long flags;
+	struct hfi1_devdata *tmp, *peer = NULL;
+
+	spin_lock_irqsave(&hfi1_devs_lock, flags);
+	/* Find our peer device */
+	list_for_each_entry(tmp, &hfi1_dev_list, list) {
+		if ((HFI_BASE_GUID(dd) == HFI_BASE_GUID(tmp)) &&
+		    dd->unit != tmp->unit) {
+			peer = tmp;
+			break;
+		}
+	}
+
+	/*
+	 * "Claim" the ASIC for initialization if it hasn't been
+	 " "claimed" yet.
+	 */
+	if (!peer || !(peer->flags & HFI1_DO_INIT_ASIC))
+		dd->flags |= HFI1_DO_INIT_ASIC;
+	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+}
+
+/**
+ * Allocate an initialize the device structure for the hfi.
+ * @dev: the pci_dev for hfi1_ib device
+ * @ent: pci_device_id struct for this dev
+ *
+ * Also allocates, initializes, and returns the devdata struct for this
+ * device instance
+ *
+ * This is global, and is called directly at init to set up the
+ * chip-specific function pointers for later use.
+ */
+struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
+				  const struct pci_device_id *ent)
+{
+	struct hfi1_devdata *dd;
+	struct hfi1_pportdata *ppd;
+	u64 reg;
+	int i, ret;
+	static const char * const inames[] = { /* implementation names */
+		"RTL silicon",
+		"RTL VCS simulation",
+		"RTL FPGA emulation",
+		"Functional simulator"
+	};
+
+	dd = hfi1_alloc_devdata(pdev,
+		NUM_IB_PORTS * sizeof(struct hfi1_pportdata));
+	if (IS_ERR(dd))
+		goto bail;
+	ppd = dd->pport;
+	for (i = 0; i < dd->num_pports; i++, ppd++) {
+		int vl;
+		/* init common fields */
+		hfi1_init_pportdata(pdev, ppd, dd, 0, 1);
+		/* DC supports 4 link widths */
+		ppd->link_width_supported =
+			OPA_LINK_WIDTH_1X | OPA_LINK_WIDTH_2X |
+			OPA_LINK_WIDTH_3X | OPA_LINK_WIDTH_4X;
+		ppd->link_width_downgrade_supported =
+			ppd->link_width_supported;
+		/* start out enabling only 4X */
+		ppd->link_width_enabled = OPA_LINK_WIDTH_4X;
+		ppd->link_width_downgrade_enabled =
+					ppd->link_width_downgrade_supported;
+		/* link width active is 0 when link is down */
+		/* link width downgrade active is 0 when link is down */
+
+		switch (num_vls) {
+		case 1:
+			ppd->vls_supported = IB_VL_VL0;
+			break;
+		case 2:
+			ppd->vls_supported = IB_VL_VL0_1;
+			break;
+		default:
+			hfi1_early_err(&pdev->dev,
+				       "Invalid num_vls %u, using 4 VLs\n",
+				    num_vls);
+			num_vls = 4;
+			/* fall through */
+		case 4:
+			ppd->vls_supported = IB_VL_VL0_3;
+			break;
+		case 8:
+			ppd->vls_supported = IB_VL_VL0_7;
+			break;
+		}
+		ppd->vls_operational = ppd->vls_supported;
+		/* Set the default MTU. */
+		for (vl = 0; vl < num_vls; vl++)
+			dd->vld[vl].mtu = hfi1_max_mtu;
+		dd->vld[15].mtu = MAX_MAD_PACKET;
+		/*
+		 * Set the initial values to reasonable default, will be set
+		 * for real when link is up.
+		 */
+		ppd->lstate = IB_PORT_DOWN;
+		ppd->overrun_threshold = 0x4;
+		ppd->phy_error_threshold = 0xf;
+		ppd->port_crc_mode_enabled = link_crc_mask;
+		/* initialize supported LTP CRC mode */
+		ppd->port_ltp_crc_mode = cap_to_port_ltp(link_crc_mask) << 8;
+		/* initialize enabled LTP CRC mode */
+		ppd->port_ltp_crc_mode |= cap_to_port_ltp(link_crc_mask) << 4;
+		/* start in offline */
+		ppd->host_link_state = HLS_DN_OFFLINE;
+		init_vl_arb_caches(ppd);
+	}
+
+	dd->link_default = HLS_DN_POLL;
+
+	/*
+	 * Do remaining PCIe setup and save PCIe values in dd.
+	 * Any error printing is already done by the init code.
+	 * On return, we have the chip mapped.
+	 */
+	ret = hfi1_pcie_ddinit(dd, pdev, ent);
+	if (ret < 0)
+		goto bail_free;
+
+	/* verify that reads actually work, save revision for reset check */
+	dd->revision = read_csr(dd, CCE_REVISION);
+	if (dd->revision == ~(u64)0) {
+		dd_dev_err(dd, "cannot read chip CSRs\n");
+		ret = -EINVAL;
+		goto bail_cleanup;
+	}
+	dd->majrev = (dd->revision >> CCE_REVISION_CHIP_REV_MAJOR_SHIFT)
+			& CCE_REVISION_CHIP_REV_MAJOR_MASK;
+	dd->minrev = (dd->revision >> CCE_REVISION_CHIP_REV_MINOR_SHIFT)
+			& CCE_REVISION_CHIP_REV_MINOR_MASK;
+
+	/* obtain the hardware ID - NOT related to unit, which is a
+	   software enumeration */
+	reg = read_csr(dd, CCE_REVISION2);
+	dd->hfi1_id = (reg >> CCE_REVISION2_HFI_ID_SHIFT)
+					& CCE_REVISION2_HFI_ID_MASK;
+	/* the variable size will remove unwanted bits */
+	dd->icode = reg >> CCE_REVISION2_IMPL_CODE_SHIFT;
+	dd->irev = reg >> CCE_REVISION2_IMPL_REVISION_SHIFT;
+	dd_dev_info(dd, "Implementation: %s, revision 0x%x\n",
+		dd->icode < ARRAY_SIZE(inames) ? inames[dd->icode] : "unknown",
+		(int)dd->irev);
+
+	/* speeds the hardware can support */
+	dd->pport->link_speed_supported = OPA_LINK_SPEED_25G;
+	/* speeds allowed to run at */
+	dd->pport->link_speed_enabled = dd->pport->link_speed_supported;
+	/* give a reasonable active value, will be set on link up */
+	dd->pport->link_speed_active = OPA_LINK_SPEED_25G;
+
+	dd->chip_rcv_contexts = read_csr(dd, RCV_CONTEXTS);
+	dd->chip_send_contexts = read_csr(dd, SEND_CONTEXTS);
+	dd->chip_sdma_engines = read_csr(dd, SEND_DMA_ENGINES);
+	dd->chip_pio_mem_size = read_csr(dd, SEND_PIO_MEM_SIZE);
+	dd->chip_sdma_mem_size = read_csr(dd, SEND_DMA_MEM_SIZE);
+	/* fix up link widths for emulation _p */
+	ppd = dd->pport;
+	if (dd->icode == ICODE_FPGA_EMULATION && is_emulator_p(dd)) {
+		ppd->link_width_supported =
+			ppd->link_width_enabled =
+			ppd->link_width_downgrade_supported =
+			ppd->link_width_downgrade_enabled =
+				OPA_LINK_WIDTH_1X;
+	}
+	/* insure num_vls isn't larger than number of sdma engines */
+	if (HFI1_CAP_IS_KSET(SDMA) && num_vls > dd->chip_sdma_engines) {
+		dd_dev_err(dd, "num_vls %u too large, using 4 VLs\n",
+				num_vls);
+		num_vls = 4;
+		ppd->vls_supported = IB_VL_VL0_3;
+		ppd->vls_operational = ppd->vls_supported;
+	}
+
+	/*
+	 * Convert the ns parameter to the 64 * cclocks used in the CSR.
+	 * Limit the max if larger than the field holds.  If timeout is
+	 * non-zero, then the calculated field will be at least 1.
+	 *
+	 * Must be after icode is set up - the cclock rate depends
+	 * on knowing the hardware being used.
+	 */
+	dd->rcv_intr_timeout_csr = ns_to_cclock(dd, rcv_intr_timeout) / 64;
+	if (dd->rcv_intr_timeout_csr >
+			RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_MASK)
+		dd->rcv_intr_timeout_csr =
+			RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_MASK;
+	else if (dd->rcv_intr_timeout_csr == 0 && rcv_intr_timeout)
+		dd->rcv_intr_timeout_csr = 1;
+
+	/* obtain chip sizes, reset chip CSRs */
+	init_chip(dd);
+
+	/* read in the PCIe link speed information */
+	ret = pcie_speeds(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	/* needs to be done before we look for the peer device */
+	read_guid(dd);
+
+	asic_should_init(dd);
+
+	/* read in firmware */
+	ret = hfi1_firmware_init(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	/*
+	 * In general, the PCIe Gen3 transition must occur after the
+	 * chip has been idled (so it won't initiate any PCIe transactions
+	 * e.g. an interrupt) and before the driver changes any registers
+	 * (the transition will reset the registers).
+	 *
+	 * In particular, place this call after:
+	 * - init_chip()     - the chip will not initiate any PCIe transactions
+	 * - pcie_speeds()   - reads the current link speed
+	 * - hfi1_firmware_init() - the needed firmware is ready to be
+	 *			    downloaded
+	 */
+	ret = do_pcie_gen3_transition(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	/* start setting dd values and adjusting CSRs */
+	init_early_variables(dd);
+
+	parse_platform_config(dd);
+
+	/* add board names as they are defined */
+	dd->boardname = kmalloc(64, GFP_KERNEL);
+	if (!dd->boardname)
+		goto bail_cleanup;
+	snprintf(dd->boardname, 64, "Board ID 0x%llx",
+		 dd->revision >> CCE_REVISION_BOARD_ID_LOWER_NIBBLE_SHIFT
+		    & CCE_REVISION_BOARD_ID_LOWER_NIBBLE_MASK);
+
+	snprintf(dd->boardversion, BOARD_VERS_MAX,
+		 "ChipABI %u.%u, %s, ChipRev %u.%u, SW Compat %llu\n",
+		 HFI1_CHIP_VERS_MAJ, HFI1_CHIP_VERS_MIN,
+		 dd->boardname,
+		 (u32)dd->majrev,
+		 (u32)dd->minrev,
+		 (dd->revision >> CCE_REVISION_SW_SHIFT)
+		    & CCE_REVISION_SW_MASK);
+
+	ret = set_up_context_variables(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	/* set initial RXE CSRs */
+	init_rxe(dd);
+	/* set initial TXE CSRs */
+	init_txe(dd);
+	/* set initial non-RXE, non-TXE CSRs */
+	init_other(dd);
+	/* set up KDETH QP prefix in both RX and TX CSRs */
+	init_kdeth_qp(dd);
+
+	/* send contexts must be set up before receive contexts */
+	ret = init_send_contexts(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	ret = hfi1_create_ctxts(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	dd->rcvhdrsize = DEFAULT_RCVHDRSIZE;
+	/*
+	 * rcd[0] is guaranteed to be valid by this point. Also, all
+	 * context are using the same value, as per the module parameter.
+	 */
+	dd->rhf_offset = dd->rcd[0]->rcvhdrqentsize - sizeof(u64) / sizeof(u32);
+
+	ret = init_pervl_scs(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	/* sdma init */
+	for (i = 0; i < dd->num_pports; ++i) {
+		ret = sdma_init(dd, i);
+		if (ret)
+			goto bail_cleanup;
+	}
+
+	/* use contexts created by hfi1_create_ctxts */
+	ret = set_up_interrupts(dd);
+	if (ret)
+		goto bail_cleanup;
+
+	/* set up LCB access - must be after set_up_interrupts() */
+	init_lcb_access(dd);
+
+	/*
+	 * GUID is now stored in big endian by the function above, swap it.
+	 *
+	 * Despite the multiple uses here there are more uses of the GUID in big
+	 * endian format, mostly in the mad layer. At some point we should
+	 * convert to host byte order and convert to network when we want to
+	 * stuff it into a packet.
+	 */
+	snprintf(dd->serial, SERIAL_MAX, "0x%08llx\n",
+		 be64_to_cpu(dd->base_guid) & 0xFFFFFF);
+
+	dd->oui1 = be64_to_cpu(dd->base_guid) >> 56 & 0xFF;
+	dd->oui2 = be64_to_cpu(dd->base_guid) >> 48 & 0xFF;
+	dd->oui3 = be64_to_cpu(dd->base_guid) >> 40 & 0xFF;
+
+	ret = load_firmware(dd); /* asymmetric with dispose_firmware() */
+	if (ret)
+		goto bail_clear_intr;
+	check_fabric_firmware_versions(dd);
+
+	thermal_init(dd);
+
+	ret = init_cntrs(dd);
+	if (ret)
+		goto bail_clear_intr;
+
+	ret = init_rcverr(dd);
+	if (ret)
+		goto bail_free_cntrs;
+
+	ret = eprom_init(dd);
+	if (ret)
+		goto bail_free_rcverr;
+
+	goto bail;
+
+bail_free_rcverr:
+	free_rcverr(dd);
+bail_free_cntrs:
+	free_cntrs(dd);
+bail_clear_intr:
+	clean_up_interrupts(dd);
+bail_cleanup:
+	hfi1_pcie_ddcleanup(dd);
+bail_free:
+	hfi1_free_devdata(dd);
+	dd = ERR_PTR(ret);
+bail:
+	return dd;
+}
+
+static u16 delay_cycles(struct hfi1_pportdata *ppd, u32 desired_egress_rate,
+			u32 dw_len)
+{
+	u32 delta_cycles;
+	u32 current_egress_rate = ppd->current_egress_rate;
+	/* rates here are in units of 10^6 bits/sec */
+
+	if (desired_egress_rate == -1)
+		return 0; /* shouldn't happen */
+
+	if (desired_egress_rate >= current_egress_rate)
+		return 0; /* we can't help go faster, only slower */
+
+	delta_cycles = egress_cycles(dw_len * 4, desired_egress_rate) -
+			egress_cycles(dw_len * 4, current_egress_rate);
+
+	return (u16)delta_cycles;
+}
+
+
+/**
+ * create_pbc - build a pbc for transmission
+ * @flags: special case flags or-ed in built pbc
+ * @srate: static rate
+ * @vl: vl
+ * @dwlen: dword length (header words + data words + pbc words)
+ *
+ * Create a PBC with the given flags, rate, VL, and length.
+ *
+ * NOTE: The PBC created will not insert any HCRC - all callers but one are
+ * for verbs, which does not use this PSM feature.  The lone other caller
+ * is for the diagnostic interface which calls this if the user does not
+ * supply their own PBC.
+ */
+u64 create_pbc(struct hfi1_pportdata *ppd, u64 flags, int srate_mbs, u32 vl,
+	       u32 dw_len)
+{
+	u64 pbc, delay = 0;
+
+	if (unlikely(srate_mbs))
+		delay = delay_cycles(ppd, srate_mbs, dw_len);
+
+	pbc = flags
+		| (delay << PBC_STATIC_RATE_CONTROL_COUNT_SHIFT)
+		| ((u64)PBC_IHCRC_NONE << PBC_INSERT_HCRC_SHIFT)
+		| (vl & PBC_VL_MASK) << PBC_VL_SHIFT
+		| (dw_len & PBC_LENGTH_DWS_MASK)
+			<< PBC_LENGTH_DWS_SHIFT;
+
+	return pbc;
+}
+
+#define SBUS_THERMAL    0x4f
+#define SBUS_THERM_MONITOR_MODE 0x1
+
+#define THERM_FAILURE(dev, ret, reason) \
+	dd_dev_err((dd),						\
+		   "Thermal sensor initialization failed: %s (%d)\n",	\
+		   (reason), (ret))
+
+/*
+ * Initialize the Avago Thermal sensor.
+ *
+ * After initialization, enable polling of thermal sensor through
+ * SBus interface. In order for this to work, the SBus Master
+ * firmware has to be loaded due to the fact that the HW polling
+ * logic uses SBus interrupts, which are not supported with
+ * default firmware. Otherwise, no data will be returned through
+ * the ASIC_STS_THERM CSR.
+ */
+static int thermal_init(struct hfi1_devdata *dd)
+{
+	int ret = 0;
+
+	if (dd->icode != ICODE_RTL_SILICON ||
+	    !(dd->flags & HFI1_DO_INIT_ASIC))
+		return ret;
+
+	acquire_hw_mutex(dd);
+	dd_dev_info(dd, "Initializing thermal sensor\n");
+	/* Thermal Sensor Initialization */
+	/*    Step 1: Reset the Thermal SBus Receiver */
+	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x0,
+				RESET_SBUS_RECEIVER, 0);
+	if (ret) {
+		THERM_FAILURE(dd, ret, "Bus Reset");
+		goto done;
+	}
+	/*    Step 2: Set Reset bit in Thermal block */
+	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x0,
+				WRITE_SBUS_RECEIVER, 0x1);
+	if (ret) {
+		THERM_FAILURE(dd, ret, "Therm Block Reset");
+		goto done;
+	}
+	/*    Step 3: Write clock divider value (100MHz -> 2MHz) */
+	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x1,
+				WRITE_SBUS_RECEIVER, 0x32);
+	if (ret) {
+		THERM_FAILURE(dd, ret, "Write Clock Div");
+		goto done;
+	}
+	/*    Step 4: Select temperature mode */
+	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x3,
+				WRITE_SBUS_RECEIVER,
+				SBUS_THERM_MONITOR_MODE);
+	if (ret) {
+		THERM_FAILURE(dd, ret, "Write Mode Sel");
+		goto done;
+	}
+	/*    Step 5: De-assert block reset and start conversion */
+	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x0,
+				WRITE_SBUS_RECEIVER, 0x2);
+	if (ret) {
+		THERM_FAILURE(dd, ret, "Write Reset Deassert");
+		goto done;
+	}
+	/*    Step 5.1: Wait for first conversion (21.5ms per spec) */
+	msleep(22);
+
+	/* Enable polling of thermal readings */
+	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0x1);
+done:
+	release_hw_mutex(dd);
+	return ret;
+}
+
+static void handle_temp_err(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd = &dd->pport[0];
+	/*
+	 * Thermal Critical Interrupt
+	 * Put the device into forced freeze mode, take link down to
+	 * offline, and put DC into reset.
+	 */
+	dd_dev_emerg(dd,
+		     "Critical temperature reached! Forcing device into freeze mode!\n");
+	dd->flags |= HFI1_FORCED_FREEZE;
+	start_freeze_handling(ppd, FREEZE_SELF|FREEZE_ABORT);
+	/*
+	 * Shut DC down as much and as quickly as possible.
+	 *
+	 * Step 1: Take the link down to OFFLINE. This will cause the
+	 *         8051 to put the Serdes in reset. However, we don't want to
+	 *         go through the entire link state machine since we want to
+	 *         shutdown ASAP. Furthermore, this is not a graceful shutdown
+	 *         but rather an attempt to save the chip.
+	 *         Code below is almost the same as quiet_serdes() but avoids
+	 *         all the extra work and the sleeps.
+	 */
+	ppd->driver_link_ready = 0;
+	ppd->link_enabled = 0;
+	set_physical_link_state(dd, PLS_OFFLINE |
+				(OPA_LINKDOWN_REASON_SMA_DISABLED << 8));
+	/*
+	 * Step 2: Shutdown LCB and 8051
+	 *         After shutdown, do not restore DC_CFG_RESET value.
+	 */
+	dc_shutdown(dd);
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
