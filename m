From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 04/49] IB/hfi1: add chip specific support part3
Date: Wed, 17 Jun 2015 08:28:57 -0400
Message-ID: <20150617122857.8744.51697.stgit@phlsvslse11.ph.intel.com>
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
 drivers/infiniband/hw/hfi1/chip.c | 2981 +++++++++++++++++++++++++++++++++++++
 1 file changed, 2981 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ed03311..7019499 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5030,3 +5030,2984 @@ static int read_idle_message(struct hfi1_devdata *dd, u64 type, u64 *data_out)
 static int read_idle_sma(struct hfi1_devdata *dd, u64 *data)
 {
 	return read_idle_message(dd,
+			(u64)IDLE_SMA << IDLE_MSG_TYPE_SHIFT, data);
+}
+
+/*
+ * Send an idle LCB message.
+ *
+ * Returns 0 on success, -EINVAL on error
+ */
+static int send_idle_message(struct hfi1_devdata *dd, u64 data)
+{
+	int ret;
+
+	dd_dev_info(dd, "%s: sending idle message 0x%llx\n", __func__, data);
+	ret = do_8051_command(dd, HCMD_SEND_LCB_IDLE_MSG, data, NULL);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd, "send idle message: data 0x%llx, err %d\n",
+			data, ret);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Send an idle SMA message.
+ *
+ * Returns 0 on success, -EINVAL on error
+ */
+int send_idle_sma(struct hfi1_devdata *dd, u64 message)
+{
+	u64 data;
+
+	data = ((message & IDLE_PAYLOAD_MASK) << IDLE_PAYLOAD_SHIFT)
+		| ((u64)IDLE_SMA << IDLE_MSG_TYPE_SHIFT);
+	return send_idle_message(dd, data);
+}
+
+/*
+ * Initialize the LCB then do a quick link up.  This may or may not be
+ * in loopback.
+ *
+ * return 0 on success, -errno on error
+ */
+static int do_quick_linkup(struct hfi1_devdata *dd)
+{
+	u64 reg;
+	unsigned long timeout;
+	int ret;
+
+	lcb_shutdown(dd, 0);
+
+	if (loopback) {
+		/* LCB_CFG_LOOPBACK.VAL = 2 */
+		/* LCB_CFG_LANE_WIDTH.VAL = 0 */
+		write_csr(dd, DC_LCB_CFG_LOOPBACK,
+			IB_PACKET_TYPE << DC_LCB_CFG_LOOPBACK_VAL_SHIFT);
+		write_csr(dd, DC_LCB_CFG_LANE_WIDTH, 0);
+	}
+
+	/* start the LCBs */
+	/* LCB_CFG_TX_FIFOS_RESET.VAL = 0 */
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 0);
+
+	/* simulator only loopback steps */
+	if (loopback && dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
+		/* LCB_CFG_RUN.EN = 1 */
+		write_csr(dd, DC_LCB_CFG_RUN,
+			1ull << DC_LCB_CFG_RUN_EN_SHIFT);
+
+		/* watch LCB_STS_LINK_TRANSFER_ACTIVE */
+		timeout = jiffies + msecs_to_jiffies(10);
+		while (1) {
+			reg = read_csr(dd,
+				DC_LCB_STS_LINK_TRANSFER_ACTIVE);
+			if (reg)
+				break;
+			if (time_after(jiffies, timeout)) {
+				dd_dev_err(dd,
+					"timeout waiting for LINK_TRANSFER_ACTIVE\n");
+				return -ETIMEDOUT;
+			}
+			udelay(2);
+		}
+
+		write_csr(dd, DC_LCB_CFG_ALLOW_LINK_UP,
+			1ull << DC_LCB_CFG_ALLOW_LINK_UP_VAL_SHIFT);
+	}
+
+	if (!loopback) {
+		/*
+		 * When doing quick linkup and not in loopback, both
+		 * sides must be done with LCB set-up before either
+		 * starts the quick linkup.  Put a delay here so that
+		 * both sides can be started and have a chance to be
+		 * done with LCB set up before resuming.
+		 */
+		dd_dev_err(dd,
+			"Pausing for peer to be finished with LCB set up\n");
+		msleep(5000);
+		dd_dev_err(dd,
+			"Continuing with quick linkup\n");
+	}
+
+	write_csr(dd, DC_LCB_ERR_EN, 0); /* mask LCB errors */
+	set_8051_lcb_access(dd);
+
+	/*
+	 * State "quick" LinkUp request sets the physical link state to
+	 * LinkUp without a verify capability sequence.
+	 * This state is in simulator v37 and later.
+	 */
+	ret = set_physical_link_state(dd, PLS_QUICK_LINKUP);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd,
+			"%s: set physical link state to quick LinkUp failed with return %d\n",
+			__func__, ret);
+
+		set_host_lcb_access(dd);
+		write_csr(dd, DC_LCB_ERR_EN, ~0ull); /* watch LCB errors */
+
+		if (ret >= 0)
+			ret = -EINVAL;
+		return ret;
+	}
+
+	return 0; /* success */
+}
+
+/*
+ * Set the SerDes to internal loopback mode.
+ * Returns 0 on success, -errno on error.
+ */
+static int set_serdes_loopback_mode(struct hfi1_devdata *dd)
+{
+	int ret;
+
+	ret = set_physical_link_state(dd, PLS_INTERNAL_SERDES_LOOPBACK);
+	if (ret == HCMD_SUCCESS)
+		return 0;
+	dd_dev_err(dd,
+		"Set physical link state to SerDes Loopback failed with return %d\n",
+		ret);
+	if (ret >= 0)
+		ret = -EINVAL;
+	return ret;
+}
+
+/*
+ * Do all special steps to set up loopback.
+ */
+static int init_loopback(struct hfi1_devdata *dd)
+{
+	dd_dev_info(dd, "Entering loopback mode\n");
+
+	/* all loopbacks should disable self GUID check */
+	write_csr(dd, DC_DC8051_CFG_MODE,
+		(read_csr(dd, DC_DC8051_CFG_MODE) | DISABLE_SELF_GUID_CHECK));
+
+	/*
+	 * The simulator has only one loopback option - LCB.  Switch
+	 * to that option, which includes quick link up.
+	 *
+	 * Accept all valid loopback values.
+	 */
+	if ((dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
+		&& (loopback == LOOPBACK_SERDES
+			|| loopback == LOOPBACK_LCB
+			|| loopback == LOOPBACK_CABLE)) {
+		loopback = LOOPBACK_LCB;
+		quick_linkup = 1;
+		return 0;
+	}
+
+	/* handle serdes loopback */
+	if (loopback == LOOPBACK_SERDES) {
+		/* internal serdes loopack needs quick linkup on RTL */
+		if (dd->icode == ICODE_RTL_SILICON)
+			quick_linkup = 1;
+		return set_serdes_loopback_mode(dd);
+	}
+
+	/* LCB loopback - handled at poll time */
+	if (loopback == LOOPBACK_LCB) {
+		quick_linkup = 1; /* LCB is always quick linkup */
+
+		/* not supported in emulation due to emulation RTL changes */
+		if (dd->icode == ICODE_FPGA_EMULATION) {
+			dd_dev_err(dd,
+				"LCB loopback not supported in emulation\n");
+			return -EINVAL;
+		}
+		return 0;
+	}
+
+	/* external cable loopback requires no extra steps */
+	if (loopback == LOOPBACK_CABLE)
+		return 0;
+
+	dd_dev_err(dd, "Invalid loopback mode %d\n", loopback);
+	return -EINVAL;
+}
+
+/*
+ * Translate from the OPA_LINK_WIDTH handed to us by the FM to bits
+ * used in the Verify Capability link width attribute.
+ */
+static u16 opa_to_vc_link_widths(u16 opa_widths)
+{
+	int i;
+	u16 result = 0;
+
+	static const struct link_bits {
+		u16 from;
+		u16 to;
+	} opa_link_xlate[] = {
+		{ OPA_LINK_WIDTH_1X, 1 << (1-1)  },
+		{ OPA_LINK_WIDTH_2X, 1 << (2-1)  },
+		{ OPA_LINK_WIDTH_3X, 1 << (3-1)  },
+		{ OPA_LINK_WIDTH_4X, 1 << (4-1)  },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(opa_link_xlate); i++) {
+		if (opa_widths & opa_link_xlate[i].from)
+			result |= opa_link_xlate[i].to;
+	}
+	return result;
+}
+
+/*
+ * Set link attributes before moving to polling.
+ */
+static int set_local_link_attributes(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u8 enable_lane_tx;
+	u8 tx_polarity_inversion;
+	u8 rx_polarity_inversion;
+	u8 max_rate;
+	int ret;
+
+	/* reset our fabric serdes to clear any lingering problems */
+	fabric_serdes_reset(dd);
+
+	/* set the max rate - need to read-modify-write */
+	ret = read_tx_settings(dd, &enable_lane_tx, &tx_polarity_inversion,
+		&rx_polarity_inversion, &max_rate);
+	if (ret != HCMD_SUCCESS)
+		goto set_local_link_attributes_fail;
+
+	/* set the max rate to the fastest enabled */
+	if (ppd->link_speed_enabled & OPA_LINK_SPEED_25G)
+		max_rate = 1;
+	else
+		max_rate = 0;
+	ret = write_tx_settings(dd, enable_lane_tx, tx_polarity_inversion,
+		     rx_polarity_inversion, max_rate);
+	if (ret != HCMD_SUCCESS)
+		goto set_local_link_attributes_fail;
+
+	/*
+	 * DC supports continuous updates.
+	 */
+	ret = write_vc_local_phy(dd, 0 /* no power management */,
+				     1 /* continuous updates */);
+	if (ret != HCMD_SUCCESS)
+		goto set_local_link_attributes_fail;
+
+	/* z=1 in the next call: AU of 0 is not supported by the hardware */
+	ret = write_vc_local_fabric(dd, dd->vau, 1, dd->vcu, dd->vl15_init,
+				    ppd->port_crc_mode_enabled);
+	if (ret != HCMD_SUCCESS)
+		goto set_local_link_attributes_fail;
+
+	ret = write_vc_local_link_width(dd, 0, 0,
+		     opa_to_vc_link_widths(ppd->link_width_enabled));
+	if (ret != HCMD_SUCCESS)
+		goto set_local_link_attributes_fail;
+
+	/* let peer know who we are */
+	ret = write_local_device_id(dd, dd->pcidev->device, dd->minrev);
+	if (ret == HCMD_SUCCESS)
+		return 0;
+
+set_local_link_attributes_fail:
+	dd_dev_err(dd,
+		"Failed to set local link attributes, return 0x%x\n",
+		ret);
+	return ret;
+}
+
+/*
+ * Call this to start the link.  Schedule a retry if the cable is not
+ * present or if unable to start polling.  Do not do anything if the
+ * link is disabled.  Returns 0 if link is disabled or moved to polling
+ */
+int start_link(struct hfi1_pportdata *ppd)
+{
+	if (!ppd->link_enabled) {
+		dd_dev_info(ppd->dd,
+			"%s: stopping link start because link is disabled\n",
+			__func__);
+		return 0;
+	}
+	if (!ppd->driver_link_ready) {
+		dd_dev_info(ppd->dd,
+			"%s: stopping link start because driver is not ready\n",
+			__func__);
+		return 0;
+	}
+
+	if (qsfp_mod_present(ppd) || loopback == LOOPBACK_SERDES ||
+			loopback == LOOPBACK_LCB ||
+			ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
+		return set_link_state(ppd, HLS_DN_POLL);
+
+	dd_dev_info(ppd->dd,
+		"%s: stopping link start because no cable is present\n",
+		__func__);
+	return -EAGAIN;
+}
+
+static void reset_qsfp(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 mask, qsfp_mask;
+
+	mask = (u64)QSFP_HFI0_RESET_N;
+	qsfp_mask = read_csr(dd,
+		dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE);
+	qsfp_mask |= mask;
+	write_csr(dd,
+		dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE,
+		qsfp_mask);
+
+	qsfp_mask = read_csr(dd,
+		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT);
+	qsfp_mask &= ~mask;
+	write_csr(dd,
+		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT,
+		qsfp_mask);
+	udelay(10);
+	qsfp_mask |= mask;
+	write_csr(dd,
+		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT,
+		qsfp_mask);
+}
+
+static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
+					u8 *qsfp_interrupt_status)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if ((qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_ALARM) ||
+		(qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_WARNING))
+		dd_dev_info(dd,
+			"%s: QSFP cable on fire\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[0] & QSFP_LOW_TEMP_ALARM) ||
+		(qsfp_interrupt_status[0] & QSFP_LOW_TEMP_WARNING))
+		dd_dev_info(dd,
+			"%s: QSFP cable temperature too low\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[1] & QSFP_HIGH_VCC_ALARM) ||
+		(qsfp_interrupt_status[1] & QSFP_HIGH_VCC_WARNING))
+		dd_dev_info(dd,
+			"%s: QSFP supply voltage too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[1] & QSFP_LOW_VCC_ALARM) ||
+		(qsfp_interrupt_status[1] & QSFP_LOW_VCC_WARNING))
+		dd_dev_info(dd,
+			"%s: QSFP supply voltage too low\n",
+			__func__);
+
+	/* Byte 2 is vendor specific */
+
+	if ((qsfp_interrupt_status[3] & QSFP_HIGH_POWER_ALARM) ||
+		(qsfp_interrupt_status[3] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable RX channel 1/2 power too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[3] & QSFP_LOW_POWER_ALARM) ||
+		(qsfp_interrupt_status[3] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable RX channel 1/2 power too low\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[4] & QSFP_HIGH_POWER_ALARM) ||
+		(qsfp_interrupt_status[4] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable RX channel 3/4 power too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[4] & QSFP_LOW_POWER_ALARM) ||
+		(qsfp_interrupt_status[4] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable RX channel 3/4 power too low\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_ALARM) ||
+		(qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 1/2 bias too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[5] & QSFP_LOW_BIAS_ALARM) ||
+		(qsfp_interrupt_status[5] & QSFP_LOW_BIAS_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 1/2 bias too low\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_ALARM) ||
+		(qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 3/4 bias too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[6] & QSFP_LOW_BIAS_ALARM) ||
+		(qsfp_interrupt_status[6] & QSFP_LOW_BIAS_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 3/4 bias too low\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[7] & QSFP_HIGH_POWER_ALARM) ||
+		(qsfp_interrupt_status[7] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 1/2 power too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[7] & QSFP_LOW_POWER_ALARM) ||
+		(qsfp_interrupt_status[7] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 1/2 power too low\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[8] & QSFP_HIGH_POWER_ALARM) ||
+		(qsfp_interrupt_status[8] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 3/4 power too high\n",
+			__func__);
+
+	if ((qsfp_interrupt_status[8] & QSFP_LOW_POWER_ALARM) ||
+		(qsfp_interrupt_status[8] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd,
+			"%s: Cable TX channel 3/4 power too low\n",
+			__func__);
+
+	/* Bytes 9-10 and 11-12 are reserved */
+	/* Bytes 13-15 are vendor specific */
+
+	return 0;
+}
+
+static int do_pre_lni_host_behaviors(struct hfi1_pportdata *ppd)
+{
+	refresh_qsfp_cache(ppd, &ppd->qsfp_info);
+
+	return 0;
+}
+
+static int do_qsfp_intr_fallback(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u8 qsfp_interrupt_status = 0;
+
+	if (qsfp_read(ppd, dd->hfi1_id, 2, &qsfp_interrupt_status, 1)
+		!= 1) {
+		dd_dev_info(dd,
+			"%s: Failed to read status of QSFP module\n",
+			__func__);
+		return -EIO;
+	}
+
+	/* We don't care about alarms & warnings with a non-functional INT_N */
+	if (!(qsfp_interrupt_status & QSFP_DATA_NOT_READY))
+		do_pre_lni_host_behaviors(ppd);
+
+	return 0;
+}
+
+/* This routine will only be scheduled if the QSFP module is present */
+static void qsfp_event(struct work_struct *work)
+{
+	struct qsfp_data *qd;
+	struct hfi1_pportdata *ppd;
+	struct hfi1_devdata *dd;
+
+	qd = container_of(work, struct qsfp_data, qsfp_work);
+	ppd = qd->ppd;
+	dd = ppd->dd;
+
+	/* Sanity check */
+	if (!qsfp_mod_present(ppd))
+		return;
+
+	/*
+	 * Turn DC back on after cables has been
+	 * re-inserted. Up until now, the DC has been in
+	 * reset to save power.
+	 */
+	dc_start(dd);
+
+	if (qd->cache_refresh_required) {
+		msleep(3000);
+		reset_qsfp(ppd);
+
+		/* Check for QSFP interrupt after t_init (SFF 8679)
+		 * + extra
+		 */
+		msleep(3000);
+		if (!qd->qsfp_interrupt_functional) {
+			if (do_qsfp_intr_fallback(ppd) < 0)
+				dd_dev_info(dd, "%s: QSFP fallback failed\n",
+					__func__);
+			ppd->driver_link_ready = 1;
+			start_link(ppd);
+		}
+	}
+
+	if (qd->check_interrupt_flags) {
+		u8 qsfp_interrupt_status[16] = {0,};
+
+		if (qsfp_read(ppd, dd->hfi1_id, 6,
+			      &qsfp_interrupt_status[0], 16) != 16) {
+			dd_dev_info(dd,
+				"%s: Failed to read status of QSFP module\n",
+				__func__);
+		} else {
+			unsigned long flags;
+			u8 data_status;
+
+			spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
+			ppd->qsfp_info.check_interrupt_flags = 0;
+			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
+								flags);
+
+			if (qsfp_read(ppd, dd->hfi1_id, 2, &data_status, 1)
+				 != 1) {
+				dd_dev_info(dd,
+				"%s: Failed to read status of QSFP module\n",
+					__func__);
+			}
+			if (!(data_status & QSFP_DATA_NOT_READY)) {
+				do_pre_lni_host_behaviors(ppd);
+				start_link(ppd);
+			} else
+				handle_qsfp_error_conditions(ppd,
+						qsfp_interrupt_status);
+		}
+	}
+}
+
+void init_qsfp(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 qsfp_mask;
+
+	if (loopback == LOOPBACK_SERDES || loopback == LOOPBACK_LCB ||
+			ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
+			!HFI1_CAP_IS_KSET(QSFP_ENABLED)) {
+		ppd->driver_link_ready = 1;
+		return;
+	}
+
+	ppd->qsfp_info.ppd = ppd;
+	INIT_WORK(&ppd->qsfp_info.qsfp_work, qsfp_event);
+
+	qsfp_mask = (u64)(QSFP_HFI0_INT_N | QSFP_HFI0_MODPRST_N);
+	/* Clear current status to avoid spurious interrupts */
+	write_csr(dd,
+			dd->hfi1_id ?
+				ASIC_QSFP2_CLEAR :
+				ASIC_QSFP1_CLEAR,
+		qsfp_mask);
+
+	/* Handle active low nature of INT_N and MODPRST_N pins */
+	if (qsfp_mod_present(ppd))
+		qsfp_mask &= ~(u64)QSFP_HFI0_MODPRST_N;
+	write_csr(dd,
+		  dd->hfi1_id ? ASIC_QSFP2_INVERT : ASIC_QSFP1_INVERT,
+		  qsfp_mask);
+
+	/* Allow only INT_N and MODPRST_N to trigger QSFP interrupts */
+	qsfp_mask |= (u64)QSFP_HFI0_MODPRST_N;
+	write_csr(dd,
+		dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK,
+		qsfp_mask);
+
+	if (qsfp_mod_present(ppd)) {
+		msleep(3000);
+		reset_qsfp(ppd);
+
+		/* Check for QSFP interrupt after t_init (SFF 8679)
+		 * + extra
+		 */
+		msleep(3000);
+		if (!ppd->qsfp_info.qsfp_interrupt_functional) {
+			if (do_qsfp_intr_fallback(ppd) < 0)
+				dd_dev_info(dd,
+					"%s: QSFP fallback failed\n",
+					__func__);
+			ppd->driver_link_ready = 1;
+		}
+	}
+}
+
+int bringup_serdes(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 guid;
+	int ret;
+
+	if (HFI1_CAP_IS_KSET(EXTENDED_PSN))
+		add_rcvctrl(dd, RCV_CTRL_RCV_EXTENDED_PSN_ENABLE_SMASK);
+
+	guid = be64_to_cpu(ppd->guid);
+	if (!guid) {
+		if (dd->base_guid)
+			guid = be64_to_cpu(dd->base_guid) + ppd->port - 1;
+		ppd->guid = cpu_to_be64(guid);
+	}
+
+	/* the link defaults to enabled */
+	ppd->link_enabled = 1;
+	/* Set linkinit_reason on power up per OPA spec */
+	ppd->linkinit_reason = OPA_LINKINIT_REASON_LINKUP;
+
+	if (loopback) {
+		ret = init_loopback(dd);
+		if (ret < 0)
+			return ret;
+	}
+
+	return start_link(ppd);
+}
+
+void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+
+	/*
+	 * Shut down the link and keep it down.   First turn off that the
+	 * driver wants to allow the link to be up (driver_link_ready).
+	 * Then make sure the link is not automatically restarted
+	 * (link_enabled).  Cancel any pending restart.  And finally
+	 * go offline.
+	 */
+	ppd->driver_link_ready = 0;
+	ppd->link_enabled = 0;
+
+	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SMA_DISABLED, 0,
+	  OPA_LINKDOWN_REASON_SMA_DISABLED);
+	set_link_state(ppd, HLS_DN_OFFLINE);
+
+	/* disable the port */
+	clear_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+}
+
+static inline int init_cpu_counters(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd;
+	int i;
+
+	ppd = (struct hfi1_pportdata *)(dd + 1);
+	for (i = 0; i < dd->num_pports; i++, ppd++) {
+		ppd->ibport_data.rc_acks = NULL;
+		ppd->ibport_data.rc_qacks = NULL;
+		ppd->ibport_data.rc_acks = alloc_percpu(u64);
+		ppd->ibport_data.rc_qacks = alloc_percpu(u64);
+		ppd->ibport_data.rc_delayed_comp = alloc_percpu(u64);
+		if ((ppd->ibport_data.rc_acks == NULL) ||
+		    (ppd->ibport_data.rc_delayed_comp == NULL) ||
+		    (ppd->ibport_data.rc_qacks == NULL))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static const char * const pt_names[] = {
+	"expected",
+	"eager",
+	"invalid"
+};
+
+static const char *pt_name(u32 type)
+{
+	return type >= ARRAY_SIZE(pt_names) ? "unknown" : pt_names[type];
+}
+
+/*
+ * index is the index into the receive array
+ */
+void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
+		  u32 type, unsigned long pa, u16 order)
+{
+	u64 reg;
+	void __iomem *base = (dd->rcvarray_wc ? dd->rcvarray_wc :
+			      (dd->kregbase + RCV_ARRAY));
+
+	if (!(dd->flags & HFI1_PRESENT))
+		goto done;
+
+	if (type == PT_INVALID) {
+		pa = 0;
+	} else if (type > PT_INVALID) {
+		dd_dev_err(dd,
+			"unexpected receive array type %u for index %u, not handled\n",
+			type, index);
+		goto done;
+	}
+
+	hfi1_cdbg(TID, "type %s, index 0x%x, pa 0x%lx, bsize 0x%lx",
+		  pt_name(type), index, pa, (unsigned long)order);
+
+#define RT_ADDR_SHIFT 12	/* 4KB kernel address boundary */
+	reg = RCV_ARRAY_RT_WRITE_ENABLE_SMASK
+		| (u64)order << RCV_ARRAY_RT_BUF_SIZE_SHIFT
+		| ((pa >> RT_ADDR_SHIFT) & RCV_ARRAY_RT_ADDR_MASK)
+					<< RCV_ARRAY_RT_ADDR_SHIFT;
+	writeq(reg, base + (index * 8));
+
+	if (type == PT_EAGER)
+		/*
+		 * Eager entries are written one-by-one so we have to push them
+		 * after we write the entry.
+		 */
+		flush_wc();
+done:
+	return;
+}
+
+void hfi1_clear_tids(struct hfi1_ctxtdata *rcd)
+{
+	struct hfi1_devdata *dd = rcd->dd;
+	u32 i;
+
+	/* this could be optimized */
+	for (i = rcd->eager_base; i < rcd->eager_base +
+		     rcd->egrbufs.alloced; i++)
+		hfi1_put_tid(dd, i, PT_INVALID, 0, 0);
+
+	for (i = rcd->expected_base;
+			i < rcd->expected_base + rcd->expected_count; i++)
+		hfi1_put_tid(dd, i, PT_INVALID, 0, 0);
+}
+
+int hfi1_get_base_kinfo(struct hfi1_ctxtdata *rcd,
+			struct hfi1_ctxt_info *kinfo)
+{
+	kinfo->runtime_flags = (HFI1_MISC_GET() << HFI1_CAP_USER_SHIFT) |
+		HFI1_CAP_UGET(MASK) | HFI1_CAP_KGET(K2U);
+	return 0;
+}
+
+struct hfi1_message_header *hfi1_get_msgheader(
+				struct hfi1_devdata *dd, __le32 *rhf_addr)
+{
+	u32 offset = rhf_hdrq_offset(rhf_to_cpu(rhf_addr));
+
+	return (struct hfi1_message_header *)
+		(rhf_addr - dd->rhf_offset + offset);
+}
+
+static const char * const ib_cfg_name_strings[] = {
+	"HFI1_IB_CFG_LIDLMC",
+	"HFI1_IB_CFG_LWID_DG_ENB",
+	"HFI1_IB_CFG_LWID_ENB",
+	"HFI1_IB_CFG_LWID",
+	"HFI1_IB_CFG_SPD_ENB",
+	"HFI1_IB_CFG_SPD",
+	"HFI1_IB_CFG_RXPOL_ENB",
+	"HFI1_IB_CFG_LREV_ENB",
+	"HFI1_IB_CFG_LINKLATENCY",
+	"HFI1_IB_CFG_HRTBT",
+	"HFI1_IB_CFG_OP_VLS",
+	"HFI1_IB_CFG_VL_HIGH_CAP",
+	"HFI1_IB_CFG_VL_LOW_CAP",
+	"HFI1_IB_CFG_OVERRUN_THRESH",
+	"HFI1_IB_CFG_PHYERR_THRESH",
+	"HFI1_IB_CFG_LINKDEFAULT",
+	"HFI1_IB_CFG_PKEYS",
+	"HFI1_IB_CFG_MTU",
+	"HFI1_IB_CFG_LSTATE",
+	"HFI1_IB_CFG_VL_HIGH_LIMIT",
+	"HFI1_IB_CFG_PMA_TICKS",
+	"HFI1_IB_CFG_PORT"
+};
+
+static const char *ib_cfg_name(int which)
+{
+	if (which < 0 || which >= ARRAY_SIZE(ib_cfg_name_strings))
+		return "invalid";
+	return ib_cfg_name_strings[which];
+}
+
+int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	int val = 0;
+
+	switch (which) {
+	case HFI1_IB_CFG_LWID_ENB: /* allowed Link-width */
+		val = ppd->link_width_enabled;
+		break;
+	case HFI1_IB_CFG_LWID: /* currently active Link-width */
+		val = ppd->link_width_active;
+		break;
+	case HFI1_IB_CFG_SPD_ENB: /* allowed Link speeds */
+		val = ppd->link_speed_enabled;
+		break;
+	case HFI1_IB_CFG_SPD: /* current Link speed */
+		val = ppd->link_speed_active;
+		break;
+
+	case HFI1_IB_CFG_RXPOL_ENB: /* Auto-RX-polarity enable */
+	case HFI1_IB_CFG_LREV_ENB: /* Auto-Lane-reversal enable */
+	case HFI1_IB_CFG_LINKLATENCY:
+		goto unimplemented;
+
+	case HFI1_IB_CFG_OP_VLS:
+		val = ppd->vls_operational;
+		break;
+	case HFI1_IB_CFG_VL_HIGH_CAP: /* VL arb high priority table size */
+		val = VL_ARB_HIGH_PRIO_TABLE_SIZE;
+		break;
+	case HFI1_IB_CFG_VL_LOW_CAP: /* VL arb low priority table size */
+		val = VL_ARB_LOW_PRIO_TABLE_SIZE;
+		break;
+	case HFI1_IB_CFG_OVERRUN_THRESH: /* IB overrun threshold */
+		val = ppd->overrun_threshold;
+		break;
+	case HFI1_IB_CFG_PHYERR_THRESH: /* IB PHY error threshold */
+		val = ppd->phy_error_threshold;
+		break;
+	case HFI1_IB_CFG_LINKDEFAULT: /* IB link default (sleep/poll) */
+		val = dd->link_default;
+		break;
+
+	case HFI1_IB_CFG_HRTBT: /* Heartbeat off/enable/auto */
+	case HFI1_IB_CFG_PMA_TICKS:
+	default:
+unimplemented:
+		if (HFI1_CAP_IS_KSET(PRINT_UNIMPL))
+			dd_dev_info(
+				dd,
+				"%s: which %s: not implemented\n",
+				__func__,
+				ib_cfg_name(which));
+		break;
+	}
+
+	return val;
+}
+
+/*
+ * The largest MAD packet size.
+ */
+#define MAX_MAD_PACKET 2048
+
+/*
+ * Return the maximum header bytes that can go on the _wire_
+ * for this device. This count includes the ICRC which is
+ * not part of the packet held in memory but it is appended
+ * by the HW.
+ * This is dependent on the device's receive header entry size.
+ * HFI allows this to be set per-receive context, but the
+ * driver presently enforces a global value.
+ */
+u32 lrh_max_header_bytes(struct hfi1_devdata *dd)
+{
+	/*
+	 * The maximum non-payload (MTU) bytes in LRH.PktLen are
+	 * the Receive Header Entry Size minus the PBC (or RHF) size
+	 * plus one DW for the ICRC appended by HW.
+	 *
+	 * dd->rcd[0].rcvhdrqentsize is in DW.
+	 * We use rcd[0] as all context will have the same value. Also,
+	 * the first kernel context would have been allocated by now so
+	 * we are guaranteed a valid value.
+	 */
+	return (dd->rcd[0]->rcvhdrqentsize - 2/*PBC/RHF*/ + 1/*ICRC*/) << 2;
+}
+
+/*
+ * Set Send Length
+ * @ppd - per port data
+ *
+ * Set the MTU by limiting how many DWs may be sent.  The SendLenCheck*
+ * registers compare against LRH.PktLen, so use the max bytes included
+ * in the LRH.
+ *
+ * This routine changes all VL values except VL15, which it maintains at
+ * the same value.
+ */
+static void set_send_length(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u32 max_hb = lrh_max_header_bytes(dd), maxvlmtu = 0, dcmtu;
+	u64 len1 = 0, len2 = (((dd->vld[15].mtu + max_hb) >> 2)
+			      & SEND_LEN_CHECK1_LEN_VL15_MASK) <<
+		SEND_LEN_CHECK1_LEN_VL15_SHIFT;
+	int i;
+
+	for (i = 0; i < hfi1_num_vls(ppd->vls_supported); i++) {
+		if (dd->vld[i].mtu > maxvlmtu)
+			maxvlmtu = dd->vld[i].mtu;
+		if (i <= 3)
+			len1 |= (((dd->vld[i].mtu + max_hb) >> 2)
+				 & SEND_LEN_CHECK0_LEN_VL0_MASK) <<
+				((i % 4) * SEND_LEN_CHECK0_LEN_VL1_SHIFT);
+		else
+			len2 |= (((dd->vld[i].mtu + max_hb) >> 2)
+				 & SEND_LEN_CHECK1_LEN_VL4_MASK) <<
+				((i % 4) * SEND_LEN_CHECK1_LEN_VL5_SHIFT);
+	}
+	write_csr(dd, SEND_LEN_CHECK0, len1);
+	write_csr(dd, SEND_LEN_CHECK1, len2);
+	/* adjust kernel credit return thresholds based on new MTUs */
+	/* all kernel receive contexts have the same hdrqentsize */
+	for (i = 0; i < hfi1_num_vls(ppd->vls_supported); i++) {
+		sc_set_cr_threshold(dd->vld[i].sc,
+			sc_mtu_to_threshold(dd->vld[i].sc, dd->vld[i].mtu,
+				dd->rcd[0]->rcvhdrqentsize));
+	}
+	sc_set_cr_threshold(dd->vld[15].sc,
+		sc_mtu_to_threshold(dd->vld[15].sc, dd->vld[15].mtu,
+			dd->rcd[0]->rcvhdrqentsize));
+
+	/* Adjust maximum MTU for the port in DC */
+	dcmtu = maxvlmtu == 10240 ? DCC_CFG_PORT_MTU_CAP_10240 :
+		(ilog2(maxvlmtu >> 8) + 1);
+	len1 = read_csr(ppd->dd, DCC_CFG_PORT_CONFIG);
+	len1 &= ~DCC_CFG_PORT_CONFIG_MTU_CAP_SMASK;
+	len1 |= ((u64)dcmtu & DCC_CFG_PORT_CONFIG_MTU_CAP_MASK) <<
+		DCC_CFG_PORT_CONFIG_MTU_CAP_SHIFT;
+	write_csr(ppd->dd, DCC_CFG_PORT_CONFIG, len1);
+}
+
+static void set_lidlmc(struct hfi1_pportdata *ppd)
+{
+	int i;
+	u64 sreg = 0;
+	struct hfi1_devdata *dd = ppd->dd;
+	u32 mask = ~((1U << ppd->lmc) - 1);
+	u64 c1 = read_csr(ppd->dd, DCC_CFG_PORT_CONFIG1);
+
+	if (dd->hfi1_snoop.mode_flag)
+		dd_dev_info(dd, "Set lid/lmc while snooping");
+
+	c1 &= ~(DCC_CFG_PORT_CONFIG1_TARGET_DLID_SMASK
+		| DCC_CFG_PORT_CONFIG1_DLID_MASK_SMASK);
+	c1 |= ((ppd->lid & DCC_CFG_PORT_CONFIG1_TARGET_DLID_MASK)
+			<< DCC_CFG_PORT_CONFIG1_TARGET_DLID_SHIFT)|
+	      ((mask & DCC_CFG_PORT_CONFIG1_DLID_MASK_MASK)
+			<< DCC_CFG_PORT_CONFIG1_DLID_MASK_SHIFT);
+	write_csr(ppd->dd, DCC_CFG_PORT_CONFIG1, c1);
+
+	/*
+	 * Iterate over all the send contexts and set their SLID check
+	 */
+	sreg = ((mask & SEND_CTXT_CHECK_SLID_MASK_MASK) <<
+			SEND_CTXT_CHECK_SLID_MASK_SHIFT) |
+	       (((ppd->lid & mask) & SEND_CTXT_CHECK_SLID_VALUE_MASK) <<
+			SEND_CTXT_CHECK_SLID_VALUE_SHIFT);
+
+	for (i = 0; i < dd->chip_send_contexts; i++) {
+		hfi1_cdbg(LINKVERB, "SendContext[%d].SLID_CHECK = 0x%x",
+			  i, (u32)sreg);
+		write_kctxt_csr(dd, i, SEND_CTXT_CHECK_SLID, sreg);
+	}
+
+	/* Now we have to do the same thing for the sdma engines */
+	sdma_update_lmc(dd, mask, ppd->lid);
+}
+
+static int wait_phy_linkstate(struct hfi1_devdata *dd, u32 state, u32 msecs)
+{
+	unsigned long timeout;
+	u32 curr_state;
+
+	timeout = jiffies + msecs_to_jiffies(msecs);
+	while (1) {
+		curr_state = read_physical_state(dd);
+		if (curr_state == state)
+			break;
+		if (time_after(jiffies, timeout)) {
+			dd_dev_err(dd,
+				"timeout waiting for phy link state 0x%x, current state is 0x%x\n",
+				state, curr_state);
+			return -ETIMEDOUT;
+		}
+		usleep_range(1950, 2050); /* sleep 2ms-ish */
+	}
+
+	return 0;
+}
+
+/*
+ * Helper for set_link_state().  Do not call except from that routine.
+ * Expects ppd->hls_mutex to be held.
+ *
+ * @rem_reason value to be sent to the neighbor
+ *
+ * LinkDownReasons only set if transition succeeds.
+ */
+static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u32 pstate, previous_state;
+	u32 last_local_state;
+	u32 last_remote_state;
+	int ret;
+	int do_transition;
+	int do_wait;
+
+	previous_state = ppd->host_link_state;
+	ppd->host_link_state = HLS_GOING_OFFLINE;
+	pstate = read_physical_state(dd);
+	if (pstate == PLS_OFFLINE) {
+		do_transition = 0;	/* in right state */
+		do_wait = 0;		/* ...no need to wait */
+	} else if ((pstate & 0xff) == PLS_OFFLINE) {
+		do_transition = 0;	/* in an offline transient state */
+		do_wait = 1;		/* ...wait for it to settle */
+	} else {
+		do_transition = 1;	/* need to move to offline */
+		do_wait = 1;		/* ...will need to wait */
+	}
+
+	if (do_transition) {
+		ret = set_physical_link_state(dd,
+			PLS_OFFLINE | (rem_reason << 8));
+
+		if (ret != HCMD_SUCCESS) {
+			dd_dev_err(dd,
+				"Failed to transition to Offline link state, return %d\n",
+				ret);
+			return -EINVAL;
+		}
+		if (ppd->offline_disabled_reason == OPA_LINKDOWN_REASON_NONE)
+			ppd->offline_disabled_reason =
+			OPA_LINKDOWN_REASON_TRANSIENT;
+	}
+
+	if (do_wait) {
+		/* it can take a while for the link to go down */
+		ret = wait_phy_linkstate(dd, PLS_OFFLINE, 5000);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* make sure the logical state is also down */
+	wait_logical_linkstate(ppd, IB_PORT_DOWN, 1000);
+
+	/*
+	 * Now in charge of LCB - must be after the physical state is
+	 * offline.quiet and before host_link_state is changed.
+	 */
+	set_host_lcb_access(dd);
+	write_csr(dd, DC_LCB_ERR_EN, ~0ull); /* watch LCB errors */
+	ppd->host_link_state = HLS_LINK_COOLDOWN; /* LCB access allowed */
+
+	/*
+	 * The LNI has a mandatory wait time after the physical state
+	 * moves to Offline.Quiet.  The wait time may be different
+	 * depending on how the link went down.  The 8051 firmware
+	 * will observe the needed wait time and only move to ready
+	 * when that is completed.  The largest of the quiet timeouts
+	 * is 2.5s, so wait that long and then a bit more.
+	 */
+	ret = wait_fm_ready(dd, 3000);
+	if (ret) {
+		dd_dev_err(dd,
+			"After going offline, timed out waiting for the 8051 to become ready to accept host requests\n");
+		/* state is really offline, so make it so */
+		ppd->host_link_state = HLS_DN_OFFLINE;
+		return ret;
+	}
+
+	/*
+	 * The state is now offline and the 8051 is ready to accept host
+	 * requests.
+	 *	- change our state
+	 *	- notify others if we were previously in a linkup state
+	 */
+	ppd->host_link_state = HLS_DN_OFFLINE;
+	if (previous_state & HLS_UP) {
+		/* went down while link was up */
+		handle_linkup_change(dd, 0);
+	} else if (previous_state
+			& (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) {
+		/* went down while attempting link up */
+		/* byte 1 of last_*_state is the failure reason */
+		read_last_local_state(dd, &last_local_state);
+		read_last_remote_state(dd, &last_remote_state);
+		dd_dev_err(dd,
+			"LNI failure last states: local 0x%08x, remote 0x%08x\n",
+			last_local_state, last_remote_state);
+	}
+
+	/* the active link width (downgrade) is 0 on link down */
+	ppd->link_width_active = 0;
+	ppd->link_width_downgrade_tx_active = 0;
+	ppd->link_width_downgrade_rx_active = 0;
+	ppd->current_egress_rate = 0;
+	return 0;
+}
+
+/* return the link state name */
+static const char *link_state_name(u32 state)
+{
+	const char *name;
+	int n = ilog2(state);
+	static const char * const names[] = {
+		[__HLS_UP_INIT_BP]	 = "INIT",
+		[__HLS_UP_ARMED_BP]	 = "ARMED",
+		[__HLS_UP_ACTIVE_BP]	 = "ACTIVE",
+		[__HLS_DN_DOWNDEF_BP]	 = "DOWNDEF",
+		[__HLS_DN_POLL_BP]	 = "POLL",
+		[__HLS_DN_DISABLE_BP]	 = "DISABLE",
+		[__HLS_DN_OFFLINE_BP]	 = "OFFLINE",
+		[__HLS_VERIFY_CAP_BP]	 = "VERIFY_CAP",
+		[__HLS_GOING_UP_BP]	 = "GOING_UP",
+		[__HLS_GOING_OFFLINE_BP] = "GOING_OFFLINE",
+		[__HLS_LINK_COOLDOWN_BP] = "LINK_COOLDOWN"
+	};
+
+	name = n < ARRAY_SIZE(names) ? names[n] : NULL;
+	return name ? name : "unknown";
+}
+
+/* return the link state reason name */
+static const char *link_state_reason_name(struct hfi1_pportdata *ppd, u32 state)
+{
+	if (state == HLS_UP_INIT) {
+		switch (ppd->linkinit_reason) {
+		case OPA_LINKINIT_REASON_LINKUP:
+			return "(LINKUP)";
+		case OPA_LINKINIT_REASON_FLAPPING:
+			return "(FLAPPING)";
+		case OPA_LINKINIT_OUTSIDE_POLICY:
+			return "(OUTSIDE_POLICY)";
+		case OPA_LINKINIT_QUARANTINED:
+			return "(QUARANTINED)";
+		case OPA_LINKINIT_INSUFIC_CAPABILITY:
+			return "(INSUFIC_CAPABILITY)";
+		default:
+			break;
+		}
+	}
+	return "";
+}
+
+void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
+			  u8 neigh_reason, u8 rem_reason)
+{
+	if (ppd->local_link_down_reason.latest == 0 &&
+	    ppd->neigh_link_down_reason.latest == 0) {
+		ppd->local_link_down_reason.latest = lcl_reason;
+		ppd->neigh_link_down_reason.latest = neigh_reason;
+		ppd->remote_link_down_reason = rem_reason;
+	}
+}
+
+/*
+ * Change the physical and/or logical link state.
+ *
+ * Returns 0 on success, -errno on failure.
+ */
+int set_link_state(struct hfi1_pportdata *ppd, u32 state)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	struct ib_event event = {.device = NULL};
+	int ret1, ret = 0;
+	int was_up, is_down;
+	int orig_new_state, poll_bounce;
+
+	mutex_lock(&ppd->hls_lock);
+
+	orig_new_state = state;
+	if (state == HLS_DN_DOWNDEF)
+		state = dd->link_default;
+
+	/* interpret poll -> poll as a link bounce */
+	poll_bounce = ppd->host_link_state == HLS_DN_POLL
+				&& state == HLS_DN_POLL;
+
+	dd_dev_info(dd, "%s: current %s, new %s %s%s\n", __func__,
+		link_state_name(ppd->host_link_state),
+		link_state_name(orig_new_state),
+		poll_bounce ? "(bounce) " : "",
+		link_state_reason_name(ppd, state));
+
+	was_up = !!(ppd->host_link_state & HLS_UP);
+
+	/*
+	 * If we're going to a (HLS_*) link state that implies the logical
+	 * link state is neither of (IB_PORT_ARMED, IB_PORT_ACTIVE), then
+	 * reset is_sm_config_started to 0.
+	 */
+	if (!(state & (HLS_UP_ARMED | HLS_UP_ACTIVE)))
+		ppd->is_sm_config_started = 0;
+
+	/*
+	 * Do nothing if the states match.  Let a poll to poll link bounce
+	 * go through.
+	 */
+	if (ppd->host_link_state == state && !poll_bounce)
+		goto done;
+
+	switch (state) {
+	case HLS_UP_INIT:
+		if (ppd->host_link_state == HLS_DN_POLL && (quick_linkup
+			    || dd->icode == ICODE_FUNCTIONAL_SIMULATOR)) {
+			/*
+			 * Quick link up jumps from polling to here.
+			 *
+			 * Whether in normal or loopback mode, the
+			 * simulator jumps from polling to link up.
+			 * Accept that here.
+			 */
+			/* OK */;
+		} else if (ppd->host_link_state != HLS_GOING_UP) {
+			goto unexpected;
+		}
+
+		ppd->host_link_state = HLS_UP_INIT;
+		ret = wait_logical_linkstate(ppd, IB_PORT_INIT, 1000);
+		if (ret) {
+			/* logical state didn't change, stay at going_up */
+			ppd->host_link_state = HLS_GOING_UP;
+			dd_dev_err(dd,
+				"%s: logical state did not change to INIT\n",
+				__func__);
+		} else {
+			/* clear old transient LINKINIT_REASON code */
+			if (ppd->linkinit_reason >= OPA_LINKINIT_REASON_CLEAR)
+				ppd->linkinit_reason =
+					OPA_LINKINIT_REASON_LINKUP;
+
+			/* enable the port */
+			add_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+
+			handle_linkup_change(dd, 1);
+		}
+		break;
+	case HLS_UP_ARMED:
+		if (ppd->host_link_state != HLS_UP_INIT)
+			goto unexpected;
+
+		ppd->host_link_state = HLS_UP_ARMED;
+		set_logical_state(dd, LSTATE_ARMED);
+		ret = wait_logical_linkstate(ppd, IB_PORT_ARMED, 1000);
+		if (ret) {
+			/* logical state didn't change, stay at init */
+			ppd->host_link_state = HLS_UP_INIT;
+			dd_dev_err(dd,
+				"%s: logical state did not change to ARMED\n",
+				__func__);
+		}
+		/*
+		 * The simulator does not currently implement SMA messages,
+		 * so neighbor_normal is not set.  Set it here when we first
+		 * move to Armed.
+		 */
+		if (dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
+			ppd->neighbor_normal = 1;
+		break;
+	case HLS_UP_ACTIVE:
+		if (ppd->host_link_state != HLS_UP_ARMED)
+			goto unexpected;
+
+		ppd->host_link_state = HLS_UP_ACTIVE;
+		set_logical_state(dd, LSTATE_ACTIVE);
+		ret = wait_logical_linkstate(ppd, IB_PORT_ACTIVE, 1000);
+		if (ret) {
+			/* logical state didn't change, stay at armed */
+			ppd->host_link_state = HLS_UP_ARMED;
+			dd_dev_err(dd,
+				"%s: logical state did not change to ACTIVE\n",
+				__func__);
+		} else {
+
+			/* tell all engines to go running */
+			sdma_all_running(dd);
+
+			/* Signal the IB layer that the port has went active */
+			event.device = &dd->verbs_dev.ibdev;
+			event.element.port_num = ppd->port;
+			event.event = IB_EVENT_PORT_ACTIVE;
+		}
+		break;
+	case HLS_DN_POLL:
+		if ((ppd->host_link_state == HLS_DN_DISABLE ||
+		     ppd->host_link_state == HLS_DN_OFFLINE) &&
+		    dd->dc_shutdown)
+			dc_start(dd);
+		/* Hand LED control to the DC */
+		write_csr(dd, DCC_CFG_LED_CNTRL, 0);
+
+		if (ppd->host_link_state != HLS_DN_OFFLINE) {
+			u8 tmp = ppd->link_enabled;
+
+			ret = goto_offline(ppd, ppd->remote_link_down_reason);
+			if (ret) {
+				ppd->link_enabled = tmp;
+				break;
+			}
+			ppd->remote_link_down_reason = 0;
+
+			if (ppd->driver_link_ready)
+				ppd->link_enabled = 1;
+		}
+
+		ret = set_local_link_attributes(ppd);
+		if (ret)
+			break;
+
+		ppd->port_error_action = 0;
+		ppd->host_link_state = HLS_DN_POLL;
+
+		if (quick_linkup) {
+			/* quick linkup does not go into polling */
+			ret = do_quick_linkup(dd);
+		} else {
+			ret1 = set_physical_link_state(dd, PLS_POLLING);
+			if (ret1 != HCMD_SUCCESS) {
+				dd_dev_err(dd,
+					"Failed to transition to Polling link state, return 0x%x\n",
+					ret1);
+				ret = -EINVAL;
+			}
+		}
+		ppd->offline_disabled_reason = OPA_LINKDOWN_REASON_NONE;
+		/*
+		 * If an error occurred above, go back to offline.  The
+		 * caller may reschedule another attempt.
+		 */
+		if (ret)
+			goto_offline(ppd, 0);
+		break;
+	case HLS_DN_DISABLE:
+		/* link is disabled */
+		ppd->link_enabled = 0;
+
+		/* allow any state to transition to disabled */
+
+		/* must transition to offline first */
+		if (ppd->host_link_state != HLS_DN_OFFLINE) {
+			ret = goto_offline(ppd, ppd->remote_link_down_reason);
+			if (ret)
+				break;
+			ppd->remote_link_down_reason = 0;
+		}
+
+		ret1 = set_physical_link_state(dd, PLS_DISABLED);
+		if (ret1 != HCMD_SUCCESS) {
+			dd_dev_err(dd,
+				"Failed to transition to Disabled link state, return 0x%x\n",
+				ret1);
+			ret = -EINVAL;
+			break;
+		}
+		ppd->host_link_state = HLS_DN_DISABLE;
+		dc_shutdown(dd);
+		break;
+	case HLS_DN_OFFLINE:
+		if (ppd->host_link_state == HLS_DN_DISABLE)
+			dc_start(dd);
+
+		/* allow any state to transition to offline */
+		ret = goto_offline(ppd, ppd->remote_link_down_reason);
+		if (!ret)
+			ppd->remote_link_down_reason = 0;
+		break;
+	case HLS_VERIFY_CAP:
+		if (ppd->host_link_state != HLS_DN_POLL)
+			goto unexpected;
+		ppd->host_link_state = HLS_VERIFY_CAP;
+		break;
+	case HLS_GOING_UP:
+		if (ppd->host_link_state != HLS_VERIFY_CAP)
+			goto unexpected;
+
+		ret1 = set_physical_link_state(dd, PLS_LINKUP);
+		if (ret1 != HCMD_SUCCESS) {
+			dd_dev_err(dd,
+				"Failed to transition to link up state, return 0x%x\n",
+				ret1);
+			ret = -EINVAL;
+			break;
+		}
+		ppd->host_link_state = HLS_GOING_UP;
+		break;
+
+	case HLS_GOING_OFFLINE:		/* transient within goto_offline() */
+	case HLS_LINK_COOLDOWN:		/* transient within goto_offline() */
+	default:
+		dd_dev_info(dd, "%s: state 0x%x: not supported\n",
+			__func__, state);
+		ret = -EINVAL;
+		break;
+	}
+
+	is_down = !!(ppd->host_link_state & (HLS_DN_POLL |
+			HLS_DN_DISABLE | HLS_DN_OFFLINE));
+
+	if (was_up && is_down && ppd->local_link_down_reason.sma == 0 &&
+	    ppd->neigh_link_down_reason.sma == 0) {
+		ppd->local_link_down_reason.sma =
+		  ppd->local_link_down_reason.latest;
+		ppd->neigh_link_down_reason.sma =
+		  ppd->neigh_link_down_reason.latest;
+	}
+
+	goto done;
+
+unexpected:
+	dd_dev_err(dd, "%s: unexpected state transition from %s to %s\n",
+		__func__, link_state_name(ppd->host_link_state),
+		link_state_name(state));
+	ret = -EINVAL;
+
+done:
+	mutex_unlock(&ppd->hls_lock);
+
+	if (event.device)
+		ib_dispatch_event(&event);
+
+	return ret;
+}
+
+int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val)
+{
+	u64 reg;
+	int ret = 0;
+
+	switch (which) {
+	case HFI1_IB_CFG_LIDLMC:
+		set_lidlmc(ppd);
+		break;
+	case HFI1_IB_CFG_VL_HIGH_LIMIT:
+		/*
+		 * The VL Arbitrator high limit is sent in units of 4k
+		 * bytes, while HFI stores it in units of 64 bytes.
+		 */
+		val *= 4096/64;
+		reg = ((u64)val & SEND_HIGH_PRIORITY_LIMIT_LIMIT_MASK)
+			<< SEND_HIGH_PRIORITY_LIMIT_LIMIT_SHIFT;
+		write_csr(ppd->dd, SEND_HIGH_PRIORITY_LIMIT, reg);
+		break;
+	case HFI1_IB_CFG_LINKDEFAULT: /* IB link default (sleep/poll) */
+		/* HFI only supports POLL as the default link down state */
+		if (val != HLS_DN_POLL)
+			ret = -EINVAL;
+		break;
+	case HFI1_IB_CFG_OP_VLS:
+		if (ppd->vls_operational != val) {
+			ppd->vls_operational = val;
+			BUG_ON(!ppd->port);
+			ret = sdma_map_init(
+				ppd->dd,
+				ppd->port - 1,
+				hfi1_num_vls(val),
+				NULL);
+		}
+		break;
+	/*
+	 * For link width, link width downgrade, and speed enable, always AND
+	 * the setting with what is actually supported.  This has two benefits.
+	 * First, enabled can't have unsupported values, no matter what the
+	 * SM or FM might want.  Second, the ALL_SUPPORTED wildcards that mean
+	 * "fill in with your supported value" have all the bits in the
+	 * field set, so simply ANDing with supported has the desired result.
+	 */
+	case HFI1_IB_CFG_LWID_ENB: /* set allowed Link-width */
+		ppd->link_width_enabled = val & ppd->link_width_supported;
+		break;
+	case HFI1_IB_CFG_LWID_DG_ENB: /* set allowed link width downgrade */
+		ppd->link_width_downgrade_enabled =
+				val & ppd->link_width_downgrade_supported;
+		break;
+	case HFI1_IB_CFG_SPD_ENB: /* allowed Link speeds */
+		ppd->link_speed_enabled = val & ppd->link_speed_supported;
+		break;
+	case HFI1_IB_CFG_OVERRUN_THRESH: /* IB overrun threshold */
+		/*
+		 * HFI does not follow IB specs, save this value
+		 * so we can report it, if asked.
+		 */
+		ppd->overrun_threshold = val;
+		break;
+	case HFI1_IB_CFG_PHYERR_THRESH: /* IB PHY error threshold */
+		/*
+		 * HFI does not follow IB specs, save this value
+		 * so we can report it, if asked.
+		 */
+		ppd->phy_error_threshold = val;
+		break;
+
+	case HFI1_IB_CFG_MTU:
+		set_send_length(ppd);
+		break;
+
+	case HFI1_IB_CFG_PKEYS:
+		if (HFI1_CAP_IS_KSET(PKEY_CHECK))
+			set_partition_keys(ppd);
+		break;
+
+	default:
+		if (HFI1_CAP_IS_KSET(PRINT_UNIMPL))
+			dd_dev_info(ppd->dd,
+			  "%s: which %s, val 0x%x: not implemented\n",
+			  __func__, ib_cfg_name(which), val);
+		break;
+	}
+	return ret;
+}
+
+/* begin functions related to vl arbitration table caching */
+static void init_vl_arb_caches(struct hfi1_pportdata *ppd)
+{
+	int i;
+
+	BUILD_BUG_ON(VL_ARB_TABLE_SIZE !=
+			VL_ARB_LOW_PRIO_TABLE_SIZE);
+	BUILD_BUG_ON(VL_ARB_TABLE_SIZE !=
+			VL_ARB_HIGH_PRIO_TABLE_SIZE);
+
+	/*
+	 * Note that we always return values directly from the
+	 * 'vl_arb_cache' (and do no CSR reads) in response to a
+	 * 'Get(VLArbTable)'. This is obviously correct after a
+	 * 'Set(VLArbTable)', since the cache will then be up to
+	 * date. But it's also correct prior to any 'Set(VLArbTable)'
+	 * since then both the cache, and the relevant h/w registers
+	 * will be zeroed.
+	 */
+
+	for (i = 0; i < MAX_PRIO_TABLE; i++)
+		spin_lock_init(&ppd->vl_arb_cache[i].lock);
+}
+
+/*
+ * vl_arb_lock_cache
+ *
+ * All other vl_arb_* functions should be called only after locking
+ * the cache.
+ */
+static inline struct vl_arb_cache *
+vl_arb_lock_cache(struct hfi1_pportdata *ppd, int idx)
+{
+	if (idx != LO_PRIO_TABLE && idx != HI_PRIO_TABLE)
+		return NULL;
+	spin_lock(&ppd->vl_arb_cache[idx].lock);
+	return &ppd->vl_arb_cache[idx];
+}
+
+static inline void vl_arb_unlock_cache(struct hfi1_pportdata *ppd, int idx)
+{
+	spin_unlock(&ppd->vl_arb_cache[idx].lock);
+}
+
+static void vl_arb_get_cache(struct vl_arb_cache *cache,
+			     struct ib_vl_weight_elem *vl)
+{
+	memcpy(vl, cache->table, VL_ARB_TABLE_SIZE * sizeof(*vl));
+}
+
+static void vl_arb_set_cache(struct vl_arb_cache *cache,
+			     struct ib_vl_weight_elem *vl)
+{
+	memcpy(cache->table, vl, VL_ARB_TABLE_SIZE * sizeof(*vl));
+}
+
+static int vl_arb_match_cache(struct vl_arb_cache *cache,
+			      struct ib_vl_weight_elem *vl)
+{
+	return !memcmp(cache->table, vl, VL_ARB_TABLE_SIZE * sizeof(*vl));
+}
+/* end functions related to vl arbitration table caching */
+
+static int set_vl_weights(struct hfi1_pportdata *ppd, u32 target,
+			  u32 size, struct ib_vl_weight_elem *vl)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 reg;
+	unsigned int i, is_up = 0;
+	int drain, ret = 0;
+
+	mutex_lock(&ppd->hls_lock);
+
+	if (ppd->host_link_state & HLS_UP)
+		is_up = 1;
+
+	drain = !is_ax(dd) && is_up;
+
+	if (drain)
+		/*
+		 * Before adjusting VL arbitration weights, empty per-VL
+		 * FIFOs, otherwise a packet whose VL weight is being
+		 * set to 0 could get stuck in a FIFO with no chance to
+		 * egress.
+		 */
+		ret = stop_drain_data_vls(dd);
+
+	if (ret) {
+		dd_dev_err(
+			dd,
+			"%s: cannot stop/drain VLs - refusing to change VL arbitration weights\n",
+			__func__);
+		goto err;
+	}
+
+	for (i = 0; i < size; i++, vl++) {
+		/*
+		 * NOTE: The low priority shift and mask are used here, but
+		 * they are the same for both the low and high registers.
+		 */
+		reg = (((u64)vl->vl & SEND_LOW_PRIORITY_LIST_VL_MASK)
+				<< SEND_LOW_PRIORITY_LIST_VL_SHIFT)
+		      | (((u64)vl->weight
+				& SEND_LOW_PRIORITY_LIST_WEIGHT_MASK)
+				<< SEND_LOW_PRIORITY_LIST_WEIGHT_SHIFT);
+		write_csr(dd, target + (i * 8), reg);
+	}
+	pio_send_control(dd, PSC_GLOBAL_VLARB_ENABLE);
+
+	if (drain)
+		open_fill_data_vls(dd); /* reopen all VLs */
+
+err:
+	mutex_unlock(&ppd->hls_lock);
+
+	return ret;
+}
+
+/*
+ * Read one credit merge VL register.
+ */
+static void read_one_cm_vl(struct hfi1_devdata *dd, u32 csr,
+			   struct vl_limit *vll)
+{
+	u64 reg = read_csr(dd, csr);
+
+	vll->dedicated = cpu_to_be16(
+		(reg >> SEND_CM_CREDIT_VL_DEDICATED_LIMIT_VL_SHIFT)
+		& SEND_CM_CREDIT_VL_DEDICATED_LIMIT_VL_MASK);
+	vll->shared = cpu_to_be16(
+		(reg >> SEND_CM_CREDIT_VL_SHARED_LIMIT_VL_SHIFT)
+		& SEND_CM_CREDIT_VL_SHARED_LIMIT_VL_MASK);
+}
+
+/*
+ * Read the current credit merge limits.
+ */
+static int get_buffer_control(struct hfi1_devdata *dd,
+			      struct buffer_control *bc, u16 *overall_limit)
+{
+	u64 reg;
+	int i;
+
+	/* not all entries are filled in */
+	memset(bc, 0, sizeof(*bc));
+
+	/* OPA and HFI have a 1-1 mapping */
+	for (i = 0; i < TXE_NUM_DATA_VL; i++)
+		read_one_cm_vl(dd, SEND_CM_CREDIT_VL + (8*i), &bc->vl[i]);
+
+	/* NOTE: assumes that VL* and VL15 CSRs are bit-wise identical */
+	read_one_cm_vl(dd, SEND_CM_CREDIT_VL15, &bc->vl[15]);
+
+	reg = read_csr(dd, SEND_CM_GLOBAL_CREDIT);
+	bc->overall_shared_limit = cpu_to_be16(
+		(reg >> SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT)
+		& SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_MASK);
+	if (overall_limit)
+		*overall_limit = (reg
+			>> SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT)
+			& SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_MASK;
+	return sizeof(struct buffer_control);
+}
+
+static int get_sc2vlnt(struct hfi1_devdata *dd, struct sc2vlnt *dp)
+{
+	u64 reg;
+	int i;
+
+	/* each register contains 16 SC->VLnt mappings, 4 bits each */
+	reg = read_csr(dd, DCC_CFG_SC_VL_TABLE_15_0);
+	for (i = 0; i < sizeof(u64); i++) {
+		u8 byte = *(((u8 *)&reg) + i);
+
+		dp->vlnt[2 * i] = byte & 0xf;
+		dp->vlnt[(2 * i) + 1] = (byte & 0xf0) >> 4;
+	}
+
+	reg = read_csr(dd, DCC_CFG_SC_VL_TABLE_31_16);
+	for (i = 0; i < sizeof(u64); i++) {
+		u8 byte = *(((u8 *)&reg) + i);
+
+		dp->vlnt[16 + (2 * i)] = byte & 0xf;
+		dp->vlnt[16 + (2 * i) + 1] = (byte & 0xf0) >> 4;
+	}
+	return sizeof(struct sc2vlnt);
+}
+
+static void get_vlarb_preempt(struct hfi1_devdata *dd, u32 nelems,
+			      struct ib_vl_weight_elem *vl)
+{
+	unsigned int i;
+
+	for (i = 0; i < nelems; i++, vl++) {
+		vl->vl = 0xf;
+		vl->weight = 0;
+	}
+}
+
+static void set_sc2vlnt(struct hfi1_devdata *dd, struct sc2vlnt *dp)
+{
+	write_csr(dd, DCC_CFG_SC_VL_TABLE_15_0,
+		DC_SC_VL_VAL(15_0,
+		0, dp->vlnt[0] & 0xf,
+		1, dp->vlnt[1] & 0xf,
+		2, dp->vlnt[2] & 0xf,
+		3, dp->vlnt[3] & 0xf,
+		4, dp->vlnt[4] & 0xf,
+		5, dp->vlnt[5] & 0xf,
+		6, dp->vlnt[6] & 0xf,
+		7, dp->vlnt[7] & 0xf,
+		8, dp->vlnt[8] & 0xf,
+		9, dp->vlnt[9] & 0xf,
+		10, dp->vlnt[10] & 0xf,
+		11, dp->vlnt[11] & 0xf,
+		12, dp->vlnt[12] & 0xf,
+		13, dp->vlnt[13] & 0xf,
+		14, dp->vlnt[14] & 0xf,
+		15, dp->vlnt[15] & 0xf));
+	write_csr(dd, DCC_CFG_SC_VL_TABLE_31_16,
+		DC_SC_VL_VAL(31_16,
+		16, dp->vlnt[16] & 0xf,
+		17, dp->vlnt[17] & 0xf,
+		18, dp->vlnt[18] & 0xf,
+		19, dp->vlnt[19] & 0xf,
+		20, dp->vlnt[20] & 0xf,
+		21, dp->vlnt[21] & 0xf,
+		22, dp->vlnt[22] & 0xf,
+		23, dp->vlnt[23] & 0xf,
+		24, dp->vlnt[24] & 0xf,
+		25, dp->vlnt[25] & 0xf,
+		26, dp->vlnt[26] & 0xf,
+		27, dp->vlnt[27] & 0xf,
+		28, dp->vlnt[28] & 0xf,
+		29, dp->vlnt[29] & 0xf,
+		30, dp->vlnt[30] & 0xf,
+		31, dp->vlnt[31] & 0xf));
+}
+
+static void nonzero_msg(struct hfi1_devdata *dd, int idx, const char *what,
+			u16 limit)
+{
+	if (limit != 0)
+		dd_dev_info(dd, "Invalid %s limit %d on VL %d, ignoring\n",
+			what, (int)limit, idx);
+}
+
+/* change only the shared limit portion of SendCmGLobalCredit */
+static void set_global_shared(struct hfi1_devdata *dd, u16 limit)
+{
+	u64 reg;
+
+	reg = read_csr(dd, SEND_CM_GLOBAL_CREDIT);
+	reg &= ~SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SMASK;
+	reg |= (u64)limit << SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT;
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT, reg);
+}
+
+/* change only the total credit limit portion of SendCmGLobalCredit */
+static void set_global_limit(struct hfi1_devdata *dd, u16 limit)
+{
+	u64 reg;
+
+	reg = read_csr(dd, SEND_CM_GLOBAL_CREDIT);
+	reg &= ~SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SMASK;
+	reg |= (u64)limit << SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT;
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT, reg);
+}
+
+/* set the given per-VL shared limit */
+static void set_vl_shared(struct hfi1_devdata *dd, int vl, u16 limit)
+{
+	u64 reg;
+	u32 addr;
+
+	if (vl < TXE_NUM_DATA_VL)
+		addr = SEND_CM_CREDIT_VL + (8 * vl);
+	else
+		addr = SEND_CM_CREDIT_VL15;
+
+	reg = read_csr(dd, addr);
+	reg &= ~SEND_CM_CREDIT_VL_SHARED_LIMIT_VL_SMASK;
+	reg |= (u64)limit << SEND_CM_CREDIT_VL_SHARED_LIMIT_VL_SHIFT;
+	write_csr(dd, addr, reg);
+}
+
+/* set the given per-VL dedicated limit */
+static void set_vl_dedicated(struct hfi1_devdata *dd, int vl, u16 limit)
+{
+	u64 reg;
+	u32 addr;
+
+	if (vl < TXE_NUM_DATA_VL)
+		addr = SEND_CM_CREDIT_VL + (8 * vl);
+	else
+		addr = SEND_CM_CREDIT_VL15;
+
+	reg = read_csr(dd, addr);
+	reg &= ~SEND_CM_CREDIT_VL_DEDICATED_LIMIT_VL_SMASK;
+	reg |= (u64)limit << SEND_CM_CREDIT_VL_DEDICATED_LIMIT_VL_SHIFT;
+	write_csr(dd, addr, reg);
+}
+
+/* spin until the given per-VL status mask bits clear */
+static void wait_for_vl_status_clear(struct hfi1_devdata *dd, u64 mask,
+				     const char *which)
+{
+	unsigned long timeout;
+	u64 reg;
+
+	timeout = jiffies + msecs_to_jiffies(VL_STATUS_CLEAR_TIMEOUT);
+	while (1) {
+		reg = read_csr(dd, SEND_CM_CREDIT_USED_STATUS) & mask;
+
+		if (reg == 0)
+			return;	/* success */
+		if (time_after(jiffies, timeout))
+			break;		/* timed out */
+		udelay(1);
+	}
+
+	dd_dev_err(dd,
+		"%s credit change status not clearing after %dms, mask 0x%llx, not clear 0x%llx\n",
+		which, VL_STATUS_CLEAR_TIMEOUT, mask, reg);
+	/*
+	 * If this occurs, it is likely there was a credit loss on the link.
+	 * The only recovery from that is a link bounce.
+	 */
+	dd_dev_err(dd,
+		"Continuing anyway.  A credit loss may occur.  Suggest a link bounce\n");
+}
+
+/*
+ * The number of credits on the VLs may be changed while everything
+ * is "live", but the following algorithm must be followed due to
+ * how the hardware is actually implemented.  In particular,
+ * Return_Credit_Status[] is the only correct status check.
+ *
+ * if (reducing Global_Shared_Credit_Limit or any shared limit changing)
+ *     set Global_Shared_Credit_Limit = 0
+ *     use_all_vl = 1
+ * mask0 = all VLs that are changing either dedicated or shared limits
+ * set Shared_Limit[mask0] = 0
+ * spin until Return_Credit_Status[use_all_vl ? all VL : mask0] == 0
+ * if (changing any dedicated limit)
+ *     mask1 = all VLs that are lowering dedicated limits
+ *     lower Dedicated_Limit[mask1]
+ *     spin until Return_Credit_Status[mask1] == 0
+ *     raise Dedicated_Limits
+ * raise Shared_Limits
+ * raise Global_Shared_Credit_Limit
+ *
+ * lower = if the new limit is lower, set the limit to the new value
+ * raise = if the new limit is higher than the current value (may be changed
+ *	earlier in the algorithm), set the new limit to the new value
+ */
+static int set_buffer_control(struct hfi1_devdata *dd,
+			      struct buffer_control *new_bc)
+{
+	u64 changing_mask, ld_mask, stat_mask;
+	int change_count;
+	int i, use_all_mask;
+	int this_shared_changing;
+	/*
+	 * A0: add the variable any_shared_limit_changing below and in the
+	 * algorithm above.  If removing A0 support, it can be removed.
+	 */
+	int any_shared_limit_changing;
+	struct buffer_control cur_bc;
+	u8 changing[OPA_MAX_VLS];
+	u8 lowering_dedicated[OPA_MAX_VLS];
+	u16 cur_total;
+	u32 new_total = 0;
+	const u64 all_mask =
+	SEND_CM_CREDIT_USED_STATUS_VL0_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL1_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL2_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL3_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL4_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL5_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL6_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL7_RETURN_CREDIT_STATUS_SMASK
+	 | SEND_CM_CREDIT_USED_STATUS_VL15_RETURN_CREDIT_STATUS_SMASK;
+
+#define valid_vl(idx) ((idx) < TXE_NUM_DATA_VL || (idx) == 15)
+#define NUM_USABLE_VLS 16	/* look at VL15 and less */
+
+
+	/* find the new total credits, do sanity check on unused VLs */
+	for (i = 0; i < OPA_MAX_VLS; i++) {
+		if (valid_vl(i)) {
+			new_total += be16_to_cpu(new_bc->vl[i].dedicated);
+			continue;
+		}
+		nonzero_msg(dd, i, "dedicated",
+			be16_to_cpu(new_bc->vl[i].dedicated));
+		nonzero_msg(dd, i, "shared",
+			be16_to_cpu(new_bc->vl[i].shared));
+		new_bc->vl[i].dedicated = 0;
+		new_bc->vl[i].shared = 0;
+	}
+	new_total += be16_to_cpu(new_bc->overall_shared_limit);
+	if (new_total > (u32)dd->link_credits)
+		return -EINVAL;
+	/* fetch the current values */
+	get_buffer_control(dd, &cur_bc, &cur_total);
+
+	/*
+	 * Create the masks we will use.
+	 */
+	memset(changing, 0, sizeof(changing));
+	memset(lowering_dedicated, 0, sizeof(lowering_dedicated));
+	/* NOTE: Assumes that the individual VL bits are adjacent and in
+	   increasing order */
+	stat_mask =
+		SEND_CM_CREDIT_USED_STATUS_VL0_RETURN_CREDIT_STATUS_SMASK;
+	changing_mask = 0;
+	ld_mask = 0;
+	change_count = 0;
+	any_shared_limit_changing = 0;
+	for (i = 0; i < NUM_USABLE_VLS; i++, stat_mask <<= 1) {
+		if (!valid_vl(i))
+			continue;
+		this_shared_changing = new_bc->vl[i].shared
+						!= cur_bc.vl[i].shared;
+		if (this_shared_changing)
+			any_shared_limit_changing = 1;
+		if (new_bc->vl[i].dedicated != cur_bc.vl[i].dedicated
+				|| this_shared_changing) {
+			changing[i] = 1;
+			changing_mask |= stat_mask;
+			change_count++;
+		}
+		if (be16_to_cpu(new_bc->vl[i].dedicated) <
+					be16_to_cpu(cur_bc.vl[i].dedicated)) {
+			lowering_dedicated[i] = 1;
+			ld_mask |= stat_mask;
+		}
+	}
+
+	/* bracket the credit change with a total adjustment */
+	if (new_total > cur_total)
+		set_global_limit(dd, new_total);
+
+	/*
+	 * Start the credit change algorithm.
+	 */
+	use_all_mask = 0;
+	if ((be16_to_cpu(new_bc->overall_shared_limit) <
+				be16_to_cpu(cur_bc.overall_shared_limit))
+			|| (is_a0(dd) && any_shared_limit_changing)) {
+		set_global_shared(dd, 0);
+		cur_bc.overall_shared_limit = 0;
+		use_all_mask = 1;
+	}
+
+	for (i = 0; i < NUM_USABLE_VLS; i++) {
+		if (!valid_vl(i))
+			continue;
+
+		if (changing[i]) {
+			set_vl_shared(dd, i, 0);
+			cur_bc.vl[i].shared = 0;
+		}
+	}
+
+	wait_for_vl_status_clear(dd, use_all_mask ? all_mask : changing_mask,
+		"shared");
+
+	if (change_count > 0) {
+		for (i = 0; i < NUM_USABLE_VLS; i++) {
+			if (!valid_vl(i))
+				continue;
+
+			if (lowering_dedicated[i]) {
+				set_vl_dedicated(dd, i,
+					be16_to_cpu(new_bc->vl[i].dedicated));
+				cur_bc.vl[i].dedicated =
+						new_bc->vl[i].dedicated;
+			}
+		}
+
+		wait_for_vl_status_clear(dd, ld_mask, "dedicated");
+
+		/* now raise all dedicated that are going up */
+		for (i = 0; i < NUM_USABLE_VLS; i++) {
+			if (!valid_vl(i))
+				continue;
+
+			if (be16_to_cpu(new_bc->vl[i].dedicated) >
+					be16_to_cpu(cur_bc.vl[i].dedicated))
+				set_vl_dedicated(dd, i,
+					be16_to_cpu(new_bc->vl[i].dedicated));
+		}
+	}
+
+	/* next raise all shared that are going up */
+	for (i = 0; i < NUM_USABLE_VLS; i++) {
+		if (!valid_vl(i))
+			continue;
+
+		if (be16_to_cpu(new_bc->vl[i].shared) >
+				be16_to_cpu(cur_bc.vl[i].shared))
+			set_vl_shared(dd, i, be16_to_cpu(new_bc->vl[i].shared));
+	}
+
+	/* finally raise the global shared */
+	if (be16_to_cpu(new_bc->overall_shared_limit) >
+			be16_to_cpu(cur_bc.overall_shared_limit))
+		set_global_shared(dd,
+			be16_to_cpu(new_bc->overall_shared_limit));
+
+	/* bracket the credit change with a total adjustment */
+	if (new_total < cur_total)
+		set_global_limit(dd, new_total);
+	return 0;
+}
+
+/*
+ * Read the given fabric manager table. Return the size of the
+ * table (in bytes) on success, and a negative error code on
+ * failure.
+ */
+int fm_get_table(struct hfi1_pportdata *ppd, int which, void *t)
+
+{
+	int size;
+	struct vl_arb_cache *vlc;
+
+	switch (which) {
+	case FM_TBL_VL_HIGH_ARB:
+		size = 256;
+		/*
+		 * OPA specifies 128 elements (of 2 bytes each), though
+		 * HFI supports only 16 elements in h/w.
+		 */
+		vlc = vl_arb_lock_cache(ppd, HI_PRIO_TABLE);
+		vl_arb_get_cache(vlc, t);
+		vl_arb_unlock_cache(ppd, HI_PRIO_TABLE);
+		break;
+	case FM_TBL_VL_LOW_ARB:
+		size = 256;
+		/*
+		 * OPA specifies 128 elements (of 2 bytes each), though
+		 * HFI supports only 16 elements in h/w.
+		 */
+		vlc = vl_arb_lock_cache(ppd, LO_PRIO_TABLE);
+		vl_arb_get_cache(vlc, t);
+		vl_arb_unlock_cache(ppd, LO_PRIO_TABLE);
+		break;
+	case FM_TBL_BUFFER_CONTROL:
+		size = get_buffer_control(ppd->dd, t, NULL);
+		break;
+	case FM_TBL_SC2VLNT:
+		size = get_sc2vlnt(ppd->dd, t);
+		break;
+	case FM_TBL_VL_PREEMPT_ELEMS:
+		size = 256;
+		/* OPA specifies 128 elements, of 2 bytes each */
+		get_vlarb_preempt(ppd->dd, OPA_MAX_VLS, t);
+		break;
+	case FM_TBL_VL_PREEMPT_MATRIX:
+		size = 256;
+		/*
+		 * OPA specifies that this is the same size as the VL
+		 * arbitration tables (i.e., 256 bytes).
+		 */
+		break;
+	default:
+		return -EINVAL;
+	}
+	return size;
+}
+
+/*
+ * Write the given fabric manager table.
+ */
+int fm_set_table(struct hfi1_pportdata *ppd, int which, void *t)
+{
+	int ret = 0;
+	struct vl_arb_cache *vlc;
+
+	switch (which) {
+	case FM_TBL_VL_HIGH_ARB:
+		vlc = vl_arb_lock_cache(ppd, HI_PRIO_TABLE);
+		if (vl_arb_match_cache(vlc, t)) {
+			vl_arb_unlock_cache(ppd, HI_PRIO_TABLE);
+			break;
+		}
+		vl_arb_set_cache(vlc, t);
+		vl_arb_unlock_cache(ppd, HI_PRIO_TABLE);
+		ret = set_vl_weights(ppd, SEND_HIGH_PRIORITY_LIST,
+				     VL_ARB_HIGH_PRIO_TABLE_SIZE, t);
+		break;
+	case FM_TBL_VL_LOW_ARB:
+		vlc = vl_arb_lock_cache(ppd, LO_PRIO_TABLE);
+		if (vl_arb_match_cache(vlc, t)) {
+			vl_arb_unlock_cache(ppd, LO_PRIO_TABLE);
+			break;
+		}
+		vl_arb_set_cache(vlc, t);
+		vl_arb_unlock_cache(ppd, LO_PRIO_TABLE);
+		ret = set_vl_weights(ppd, SEND_LOW_PRIORITY_LIST,
+				     VL_ARB_LOW_PRIO_TABLE_SIZE, t);
+		break;
+	case FM_TBL_BUFFER_CONTROL:
+		ret = set_buffer_control(ppd->dd, t);
+		break;
+	case FM_TBL_SC2VLNT:
+		set_sc2vlnt(ppd->dd, t);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/*
+ * Disable all data VLs.
+ *
+ * Return 0 if disabled, non-zero if the VLs cannot be disabled.
+ */
+static int disable_data_vls(struct hfi1_devdata *dd)
+{
+	if (is_a0(dd))
+		return 1;
+
+	pio_send_control(dd, PSC_DATA_VL_DISABLE);
+
+	return 0;
+}
+
+/*
+ * open_fill_data_vls() - the counterpart to stop_drain_data_vls().
+ * Just re-enables all data VLs (the "fill" part happens
+ * automatically - the name was chosen for symmetry with
+ * stop_drain_data_vls()).
+ *
+ * Return 0 if successful, non-zero if the VLs cannot be enabled.
+ */
+int open_fill_data_vls(struct hfi1_devdata *dd)
+{
+	if (is_a0(dd))
+		return 1;
+
+	pio_send_control(dd, PSC_DATA_VL_ENABLE);
+
+	return 0;
+}
+
+/*
+ * drain_data_vls() - assumes that disable_data_vls() has been called,
+ * wait for occupancy (of per-VL FIFOs) for all contexts, and SDMA
+ * engines to drop to 0.
+ */
+static void drain_data_vls(struct hfi1_devdata *dd)
+{
+	sc_wait(dd);
+	sdma_wait(dd);
+	pause_for_credit_return(dd);
+}
+
+/*
+ * stop_drain_data_vls() - disable, then drain all per-VL fifos.
+ *
+ * Use open_fill_data_vls() to resume using data VLs.  This pair is
+ * meant to be used like this:
+ *
+ * stop_drain_data_vls(dd);
+ * // do things with per-VL resources
+ * open_fill_data_vls(dd);
+ */
+int stop_drain_data_vls(struct hfi1_devdata *dd)
+{
+	int ret;
+
+	ret = disable_data_vls(dd);
+	if (ret == 0)
+		drain_data_vls(dd);
+
+	return ret;
+}
+
+/*
+ * Convert a nanosecond time to a cclock count.  No matter how slow
+ * the cclock, a non-zero ns will always have a non-zero result.
+ */
+u32 ns_to_cclock(struct hfi1_devdata *dd, u32 ns)
+{
+	u32 cclocks;
+
+	if (dd->icode == ICODE_FPGA_EMULATION)
+		cclocks = (ns * 1000) / FPGA_CCLOCK_PS;
+	else  /* simulation pretends to be ASIC */
+		cclocks = (ns * 1000) / ASIC_CCLOCK_PS;
+	if (ns && !cclocks)	/* if ns nonzero, must be at least 1 */
+		cclocks = 1;
+	return cclocks;
+}
+
+/*
+ * Convert a cclock count to nanoseconds. Not matter how slow
+ * the cclock, a non-zero cclocks will always have a non-zero result.
+ */
+u32 cclock_to_ns(struct hfi1_devdata *dd, u32 cclocks)
+{
+	u32 ns;
+
+	if (dd->icode == ICODE_FPGA_EMULATION)
+		ns = (cclocks * FPGA_CCLOCK_PS) / 1000;
+	else  /* simulation pretends to be ASIC */
+		ns = (cclocks * ASIC_CCLOCK_PS) / 1000;
+	if (cclocks && !ns)
+		ns = 1;
+	return ns;
+}
+
+/*
+ * Dynamically adjust the receive interrupt timeout for a context based on
+ * incoming packet rate.
+ *
+ * NOTE: Dynamic adjustment does not allow rcv_intr_count to be zero.
+ */
+static void adjust_rcv_timeout(struct hfi1_ctxtdata *rcd, u32 npkts)
+{
+	struct hfi1_devdata *dd = rcd->dd;
+	u32 timeout = rcd->rcvavail_timeout;
+
+	/*
+	 * This algorithm doubles or halves the timeout depending on whether
+	 * the number of packets received in this interrupt were less than or
+	 * greater equal the interrupt count.
+	 *
+	 * The calculations below do not allow a steady state to be achieved.
+	 * Only at the endpoints it is possible to have an unchanging
+	 * timeout.
+	 */
+	if (npkts < rcv_intr_count) {
+		/*
+		 * Not enough packets arrived before the timeout, adjust
+		 * timeout downward.
+		 */
+		if (timeout < 2) /* already at minimum? */
+			return;
+		timeout >>= 1;
+	} else {
+		/*
+		 * More than enough packets arrived before the timeout, adjust
+		 * timeout upward.
+		 */
+		if (timeout >= dd->rcv_intr_timeout_csr) /* already at max? */
+			return;
+		timeout = min(timeout << 1, dd->rcv_intr_timeout_csr);
+	}
+
+	rcd->rcvavail_timeout = timeout;
+	/* timeout cannot be larger than rcv_intr_timeout_csr which has already
+	   been verified to be in range */
+	write_kctxt_csr(dd, rcd->ctxt, RCV_AVAIL_TIME_OUT,
+		(u64)timeout << RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_SHIFT);
+}
+
+void update_usrhead(struct hfi1_ctxtdata *rcd, u32 hd, u32 updegr, u32 egrhd,
+		    u32 intr_adjust, u32 npkts)
+{
+	struct hfi1_devdata *dd = rcd->dd;
+	u64 reg;
+	u32 ctxt = rcd->ctxt;
+
+	/*
+	 * Need to write timeout register before updating RcvHdrHead to ensure
+	 * that a new value is used when the HW decides to restart counting.
+	 */
+	if (intr_adjust)
+		adjust_rcv_timeout(rcd, npkts);
+	if (updegr) {
+		reg = (egrhd & RCV_EGR_INDEX_HEAD_HEAD_MASK)
+			<< RCV_EGR_INDEX_HEAD_HEAD_SHIFT;
+		write_uctxt_csr(dd, ctxt, RCV_EGR_INDEX_HEAD, reg);
+	}
+	mmiowb();
+	reg = ((u64)rcv_intr_count << RCV_HDR_HEAD_COUNTER_SHIFT) |
+		(((u64)hd & RCV_HDR_HEAD_HEAD_MASK)
+			<< RCV_HDR_HEAD_HEAD_SHIFT);
+	write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, reg);
+	mmiowb();
+}
+
+u32 hdrqempty(struct hfi1_ctxtdata *rcd)
+{
+	u32 head, tail;
+
+	head = (read_uctxt_csr(rcd->dd, rcd->ctxt, RCV_HDR_HEAD)
+		& RCV_HDR_HEAD_HEAD_SMASK) >> RCV_HDR_HEAD_HEAD_SHIFT;
+
+	if (rcd->rcvhdrtail_kvaddr)
+		tail = get_rcvhdrtail(rcd);
+	else
+		tail = read_uctxt_csr(rcd->dd, rcd->ctxt, RCV_HDR_TAIL);
+
+	return head == tail;
+}
+
+/*
+ * Context Control and Receive Array encoding for buffer size:
+ *	0x0 invalid
+ *	0x1   4 KB
+ *	0x2   8 KB
+ *	0x3  16 KB
+ *	0x4  32 KB
+ *	0x5  64 KB
+ *	0x6 128 KB
+ *	0x7 256 KB
+ *	0x8 512 KB (Receive Array only)
+ *	0x9   1 MB (Receive Array only)
+ *	0xa   2 MB (Receive Array only)
+ *
+ *	0xB-0xF - reserved (Receive Array only)
+ *
+ *
+ * This routine assumes that the value has already been sanity checked.
+ */
+static u32 encoded_size(u32 size)
+{
+	switch (size) {
+	case   4*1024: return 0x1;
+	case   8*1024: return 0x2;
+	case  16*1024: return 0x3;
+	case  32*1024: return 0x4;
+	case  64*1024: return 0x5;
+	case 128*1024: return 0x6;
+	case 256*1024: return 0x7;
+	case 512*1024: return 0x8;
+	case   1*1024*1024: return 0x9;
+	case   2*1024*1024: return 0xa;
+	}
+	return 0x1;	/* if invalid, go with the minimum size */
+}
+
+void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
+{
+	struct hfi1_ctxtdata *rcd;
+	u64 rcvctrl, reg;
+	int did_enable = 0;
+
+	rcd = dd->rcd[ctxt];
+	if (!rcd)
+		return;
+
+	hfi1_cdbg(RCVCTRL, "ctxt %d op 0x%x", ctxt, op);
+
+	rcvctrl = read_kctxt_csr(dd, ctxt, RCV_CTXT_CTRL);
+	/* if the context already enabled, don't do the extra steps */
+	if ((op & HFI1_RCVCTRL_CTXT_ENB)
+			&& !(rcvctrl & RCV_CTXT_CTRL_ENABLE_SMASK)) {
+		/* reset the tail and hdr addresses, and sequence count */
+		write_kctxt_csr(dd, ctxt, RCV_HDR_ADDR,
+				rcd->rcvhdrq_phys);
+		if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL))
+			write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR,
+					rcd->rcvhdrqtailaddr_phys);
+		rcd->seq_cnt = 1;
+
+		/* reset the cached receive header queue head value */
+		rcd->head = 0;
+
+		/*
+		 * Zero the receive header queue so we don't get false
+		 * positives when checking the sequence number.  The
+		 * sequence numbers could land exactly on the same spot.
+		 * E.g. a rcd restart before the receive header wrapped.
+		 */
+		memset(rcd->rcvhdrq, 0, rcd->rcvhdrq_size);
+
+		/* starting timeout */
+		rcd->rcvavail_timeout = dd->rcv_intr_timeout_csr;
+
+		/* enable the context */
+		rcvctrl |= RCV_CTXT_CTRL_ENABLE_SMASK;
+
+		/* clean the egr buffer size first */
+		rcvctrl &= ~RCV_CTXT_CTRL_EGR_BUF_SIZE_SMASK;
+		rcvctrl |= ((u64)encoded_size(rcd->egrbufs.rcvtid_size)
+				& RCV_CTXT_CTRL_EGR_BUF_SIZE_MASK)
+					<< RCV_CTXT_CTRL_EGR_BUF_SIZE_SHIFT;
+
+		/* zero RcvHdrHead - set RcvHdrHead.Counter after enable */
+		write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, 0);
+		did_enable = 1;
+
+		/* zero RcvEgrIndexHead */
+		write_uctxt_csr(dd, ctxt, RCV_EGR_INDEX_HEAD, 0);
+
+		/* set eager count and base index */
+		reg = (((u64)(rcd->egrbufs.alloced >> RCV_SHIFT)
+			& RCV_EGR_CTRL_EGR_CNT_MASK)
+		       << RCV_EGR_CTRL_EGR_CNT_SHIFT) |
+			(((rcd->eager_base >> RCV_SHIFT)
+			  & RCV_EGR_CTRL_EGR_BASE_INDEX_MASK)
+			 << RCV_EGR_CTRL_EGR_BASE_INDEX_SHIFT);
+		write_kctxt_csr(dd, ctxt, RCV_EGR_CTRL, reg);
+
+		/*
+		 * Set TID (expected) count and base index.
+		 * rcd->expected_count is set to individual RcvArray entries,
+		 * not pairs, and the CSR takes a pair-count in groups of
+		 * four, so divide by 8.
+		 */
+		reg = (((rcd->expected_count >> RCV_SHIFT)
+					& RCV_TID_CTRL_TID_PAIR_CNT_MASK)
+				<< RCV_TID_CTRL_TID_PAIR_CNT_SHIFT) |
+		      (((rcd->expected_base >> RCV_SHIFT)
+					& RCV_TID_CTRL_TID_BASE_INDEX_MASK)
+				<< RCV_TID_CTRL_TID_BASE_INDEX_SHIFT);
+		write_kctxt_csr(dd, ctxt, RCV_TID_CTRL, reg);
+		if (ctxt == VL15CTXT)
+			write_csr(dd, RCV_VL15, VL15CTXT);
+	}
+	if (op & HFI1_RCVCTRL_CTXT_DIS) {
+		write_csr(dd, RCV_VL15, 0);
+		rcvctrl &= ~RCV_CTXT_CTRL_ENABLE_SMASK;
+	}
+	if (op & HFI1_RCVCTRL_INTRAVAIL_ENB)
+		rcvctrl |= RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
+	if (op & HFI1_RCVCTRL_INTRAVAIL_DIS)
+		rcvctrl &= ~RCV_CTXT_CTRL_INTR_AVAIL_SMASK;
+	if (op & HFI1_RCVCTRL_TAILUPD_ENB && rcd->rcvhdrqtailaddr_phys)
+		rcvctrl |= RCV_CTXT_CTRL_TAIL_UPD_SMASK;
+	if (op & HFI1_RCVCTRL_TAILUPD_DIS)
+		rcvctrl &= ~RCV_CTXT_CTRL_TAIL_UPD_SMASK;
+	if (op & HFI1_RCVCTRL_TIDFLOW_ENB)
+		rcvctrl |= RCV_CTXT_CTRL_TID_FLOW_ENABLE_SMASK;
+	if (op & HFI1_RCVCTRL_TIDFLOW_DIS)
+		rcvctrl &= ~RCV_CTXT_CTRL_TID_FLOW_ENABLE_SMASK;
+	if (op & HFI1_RCVCTRL_ONE_PKT_EGR_ENB) {
+		/* In one-packet-per-eager mode, the size comes from
+		   the RcvArray entry. */
+		rcvctrl &= ~RCV_CTXT_CTRL_EGR_BUF_SIZE_SMASK;
+		rcvctrl |= RCV_CTXT_CTRL_ONE_PACKET_PER_EGR_BUFFER_SMASK;
+	}
+	if (op & HFI1_RCVCTRL_ONE_PKT_EGR_DIS)
+		rcvctrl &= ~RCV_CTXT_CTRL_ONE_PACKET_PER_EGR_BUFFER_SMASK;
+	if (op & HFI1_RCVCTRL_NO_RHQ_DROP_ENB)
+		rcvctrl |= RCV_CTXT_CTRL_DONT_DROP_RHQ_FULL_SMASK;
+	if (op & HFI1_RCVCTRL_NO_RHQ_DROP_DIS)
+		rcvctrl &= ~RCV_CTXT_CTRL_DONT_DROP_RHQ_FULL_SMASK;
+	if (op & HFI1_RCVCTRL_NO_EGR_DROP_ENB)
+		rcvctrl |= RCV_CTXT_CTRL_DONT_DROP_EGR_FULL_SMASK;
+	if (op & HFI1_RCVCTRL_NO_EGR_DROP_DIS)
+		rcvctrl &= ~RCV_CTXT_CTRL_DONT_DROP_EGR_FULL_SMASK;
+	rcd->rcvctrl = rcvctrl;
+	hfi1_cdbg(RCVCTRL, "ctxt %d rcvctrl 0x%llx\n", ctxt, rcvctrl);
+	write_kctxt_csr(dd, ctxt, RCV_CTXT_CTRL, rcd->rcvctrl);
+
+	/* work around sticky RcvCtxtStatus.BlockedRHQFull */
+	if (did_enable
+	    && (rcvctrl & RCV_CTXT_CTRL_DONT_DROP_RHQ_FULL_SMASK)) {
+		reg = read_kctxt_csr(dd, ctxt, RCV_CTXT_STATUS);
+		if (reg != 0) {
+			dd_dev_info(dd, "ctxt %d status %lld (blocked)\n",
+				ctxt, reg);
+			read_uctxt_csr(dd, ctxt, RCV_HDR_HEAD);
+			write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, 0x10);
+			write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, 0x00);
+			read_uctxt_csr(dd, ctxt, RCV_HDR_HEAD);
+			reg = read_kctxt_csr(dd, ctxt, RCV_CTXT_STATUS);
+			dd_dev_info(dd, "ctxt %d status %lld (%s blocked)\n",
+				ctxt, reg, reg == 0 ? "not" : "still");
+		}
+	}
+
+	if (did_enable) {
+		/*
+		 * The interrupt timeout and count must be set after
+		 * the context is enabled to take effect.
+		 */
+		/* set interrupt timeout */
+		write_kctxt_csr(dd, ctxt, RCV_AVAIL_TIME_OUT,
+			(u64)rcd->rcvavail_timeout <<
+				RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_SHIFT);
+
+		/* set RcvHdrHead.Counter, zero RcvHdrHead.Head (again) */
+		reg = (u64)rcv_intr_count << RCV_HDR_HEAD_COUNTER_SHIFT;
+		write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, reg);
+	}
+
+	if (op & (HFI1_RCVCTRL_TAILUPD_DIS | HFI1_RCVCTRL_CTXT_DIS))
+		/*
+		 * If the context has been disabled and the Tail Update has
+		 * been cleared, clear the RCV_HDR_TAIL_ADDR CSR so
+		 * it doesn't contain an address that is invalid.
+		 */
+		write_kctxt_csr(dd, ctxt, RCV_HDR_TAIL_ADDR, 0);
+}
+
+u32 hfi1_read_cntrs(struct hfi1_devdata *dd, loff_t pos, char **namep,
+		    u64 **cntrp)
+{
+	int ret;
+	u64 val = 0;
+
+	if (namep) {
+		ret = dd->cntrnameslen;
+		if (pos != 0) {
+			dd_dev_err(dd, "read_cntrs does not support indexing");
+			return 0;
+		}
+		*namep = dd->cntrnames;
+	} else {
+		const struct cntr_entry *entry;
+		int i, j;
+
+		ret = (dd->ndevcntrs) * sizeof(u64);
+		if (pos != 0) {
+			dd_dev_err(dd, "read_cntrs does not support indexing");
+			return 0;
+		}
+
+		/* Get the start of the block of counters */
+		*cntrp = dd->cntrs;
+
+		/*
+		 * Now go and fill in each counter in the block.
+		 */
+		for (i = 0; i < DEV_CNTR_LAST; i++) {
+			entry = &dev_cntrs[i];
+			hfi1_cdbg(CNTR, "reading %s", entry->name);
+			if (entry->flags & CNTR_DISABLED) {
+				/* Nothing */
+				hfi1_cdbg(CNTR, "\tDisabled\n");
+			} else {
+				if (entry->flags & CNTR_VL) {
+					hfi1_cdbg(CNTR, "\tPer VL\n");
+					for (j = 0; j < C_VL_COUNT; j++) {
+						val = entry->rw_cntr(entry,
+								  dd, j,
+								  CNTR_MODE_R,
+								  0);
+						hfi1_cdbg(
+						   CNTR,
+						   "\t\tRead 0x%llx for %d\n",
+						   val, j);
+						dd->cntrs[entry->offset + j] =
+									    val;
+					}
+				} else {
+					val = entry->rw_cntr(entry, dd,
+							CNTR_INVALID_VL,
+							CNTR_MODE_R, 0);
+					dd->cntrs[entry->offset] = val;
+					hfi1_cdbg(CNTR, "\tRead 0x%llx", val);
+				}
+			}
+		}
+	}
+	return ret;
+}
+
+/*
+ * Used by sysfs to create files for hfi stats to read
+ */
+u32 hfi1_read_portcntrs(struct hfi1_devdata *dd, loff_t pos, u32 port,
+			char **namep, u64 **cntrp)
+{
+	int ret;
+	u64 val = 0;
+
+	if (namep) {
+		ret = dd->portcntrnameslen;
+		if (pos != 0) {
+			dd_dev_err(dd, "index not supported");
+			return 0;
+		}
+		*namep = dd->portcntrnames;
+	} else {
+		const struct cntr_entry *entry;
+		struct hfi1_pportdata *ppd;
+		int i, j;
+
+		ret = (dd->nportcntrs) * sizeof(u64);
+		if (pos != 0) {
+			dd_dev_err(dd, "indexing not supported");
+			return 0;
+		}
+		ppd = (struct hfi1_pportdata *)(dd + 1 + port);
+		*cntrp = ppd->cntrs;
+
+		for (i = 0; i < PORT_CNTR_LAST; i++) {
+			entry = &port_cntrs[i];
+			hfi1_cdbg(CNTR, "reading %s", entry->name);
+			if (entry->flags & CNTR_DISABLED) {
+				/* Nothing */
+				hfi1_cdbg(CNTR, "\tDisabled\n");
+				continue;
+			}
+
+			if (entry->flags & CNTR_VL) {
+				hfi1_cdbg(CNTR, "\tPer VL");
+				for (j = 0; j < C_VL_COUNT; j++) {
+					val = entry->rw_cntr(entry, ppd, j,
+							       CNTR_MODE_R,
+							       0);
+					hfi1_cdbg(
+					   CNTR,
+					   "\t\tRead 0x%llx for %d",
+					   val, j);
+					ppd->cntrs[entry->offset + j] = val;
+				}
+			} else {
+				val = entry->rw_cntr(entry, ppd,
+						       CNTR_INVALID_VL,
+						       CNTR_MODE_R,
+						       0);
+				ppd->cntrs[entry->offset] = val;
+				hfi1_cdbg(CNTR, "\tRead 0x%llx", val);
+			}
+		}
+	}
+	return ret;
+}
+
+static void free_cntrs(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd;
+	int i;
+
+	if (dd->synth_stats_timer.data)
+		del_timer_sync(&dd->synth_stats_timer);
+	dd->synth_stats_timer.data = 0;
+	ppd = (struct hfi1_pportdata *)(dd + 1);
+	for (i = 0; i < dd->num_pports; i++, ppd++) {
+		kfree(ppd->cntrs);
+		kfree(ppd->scntrs);
+		free_percpu(ppd->ibport_data.rc_acks);
+		free_percpu(ppd->ibport_data.rc_qacks);
+		free_percpu(ppd->ibport_data.rc_delayed_comp);
+		ppd->cntrs = NULL;
+		ppd->scntrs = NULL;
+		ppd->ibport_data.rc_acks = NULL;
+		ppd->ibport_data.rc_qacks = NULL;
+		ppd->ibport_data.rc_delayed_comp = NULL;
+	}
+	kfree(dd->portcntrnames);
+	dd->portcntrnames = NULL;
+	kfree(dd->cntrs);
+	dd->cntrs = NULL;
+	kfree(dd->scntrs);
+	dd->scntrs = NULL;
+	kfree(dd->cntrnames);
+	dd->cntrnames = NULL;
+}
+
+#define CNTR_MAX 0xFFFFFFFFFFFFFFFFULL
+#define CNTR_32BIT_MAX 0x00000000FFFFFFFF
+
+static u64 read_dev_port_cntr(struct hfi1_devdata *dd, struct cntr_entry *entry,
+			      u64 *psval, void *context, int vl)
+{
+	u64 val;
+	u64 sval = *psval;
+
+	if (entry->flags & CNTR_DISABLED) {
+		dd_dev_err(dd, "Counter %s not enabled", entry->name);
+		return 0;
+	}
+
+	hfi1_cdbg(CNTR, "cntr: %s vl %d psval 0x%llx", entry->name, vl, *psval);
+
+	val = entry->rw_cntr(entry, context, vl, CNTR_MODE_R, 0);
+
+	/* If its a synthetic counter there is more work we need to do */
+	if (entry->flags & CNTR_SYNTH) {
+		if (sval == CNTR_MAX) {
+			/* No need to read already saturated */
+			return CNTR_MAX;
+		}
+
+		if (entry->flags & CNTR_32BIT) {
+			/* 32bit counters can wrap multiple times */
+			u64 upper = sval >> 32;
+			u64 lower = (sval << 32) >> 32;
+
+			if (lower > val) { /* hw wrapped */
+				if (upper == CNTR_32BIT_MAX)
+					val = CNTR_MAX;
+				else
+					upper++;
+			}
+
+			if (val != CNTR_MAX)
+				val = (upper << 32) | val;
+
+		} else {
+			/* If we rolled we are saturated */
+			if ((val < sval) || (val > CNTR_MAX))
+				val = CNTR_MAX;
+		}
+	}
+
+	*psval = val;
+
+	hfi1_cdbg(CNTR, "\tNew val=0x%llx", val);
+
+	return val;
+}
+
+static u64 write_dev_port_cntr(struct hfi1_devdata *dd,
+			       struct cntr_entry *entry,
+			       u64 *psval, void *context, int vl, u64 data)
+{
+	u64 val;
+
+	if (entry->flags & CNTR_DISABLED) {
+		dd_dev_err(dd, "Counter %s not enabled", entry->name);
+		return 0;
+	}
+
+	hfi1_cdbg(CNTR, "cntr: %s vl %d psval 0x%llx", entry->name, vl, *psval);
+
+	if (entry->flags & CNTR_SYNTH) {
+		*psval = data;
+		if (entry->flags & CNTR_32BIT) {
+			val = entry->rw_cntr(entry, context, vl, CNTR_MODE_W,
+					     (data << 32) >> 32);
+			val = data; /* return the full 64bit value */
+		} else {
+			val = entry->rw_cntr(entry, context, vl, CNTR_MODE_W,
+					     data);
+		}
+	} else {
+		val = entry->rw_cntr(entry, context, vl, CNTR_MODE_W, data);
+	}
+
+	*psval = val;
+
+	hfi1_cdbg(CNTR, "\tNew val=0x%llx", val);
+
+	return val;
+}
+
+u64 read_dev_cntr(struct hfi1_devdata *dd, int index, int vl)
+{
+	struct cntr_entry *entry;
+	u64 *sval;
+
+	entry = &dev_cntrs[index];
+	sval = dd->scntrs + entry->offset;
+
+	if (vl != CNTR_INVALID_VL)
+		sval += vl;
+
+	return read_dev_port_cntr(dd, entry, sval, dd, vl);
+}
+
+u64 write_dev_cntr(struct hfi1_devdata *dd, int index, int vl, u64 data)
+{
+	struct cntr_entry *entry;
+	u64 *sval;
+
+	entry = &dev_cntrs[index];
+	sval = dd->scntrs + entry->offset;
+
+	if (vl != CNTR_INVALID_VL)
+		sval += vl;
+
+	return write_dev_port_cntr(dd, entry, sval, dd, vl, data);
+}
+
+u64 read_port_cntr(struct hfi1_pportdata *ppd, int index, int vl)
+{
+	struct cntr_entry *entry;
+	u64 *sval;
+
+	entry = &port_cntrs[index];
+	sval = ppd->scntrs + entry->offset;
+
+	if (vl != CNTR_INVALID_VL)
+		sval += vl;
+
+	if ((index >= C_RCV_HDR_OVF_FIRST + ppd->dd->num_rcv_contexts) &&
+	    (index <= C_RCV_HDR_OVF_LAST)) {
+		/* We do not want to bother for disabled contexts */
+		return 0;
+	}
+
+	return read_dev_port_cntr(ppd->dd, entry, sval, ppd, vl);
+}
+
+u64 write_port_cntr(struct hfi1_pportdata *ppd, int index, int vl, u64 data)
+{
+	struct cntr_entry *entry;
+	u64 *sval;
+
+	entry = &port_cntrs[index];
+	sval = ppd->scntrs + entry->offset;
+
+	if (vl != CNTR_INVALID_VL)
+		sval += vl;
+
+	if ((index >= C_RCV_HDR_OVF_FIRST + ppd->dd->num_rcv_contexts) &&
+	    (index <= C_RCV_HDR_OVF_LAST)) {
+		/* We do not want to bother for disabled contexts */
+		return 0;
+	}
+
+	return write_dev_port_cntr(ppd->dd, entry, sval, ppd, vl, data);
+}
+
+static void update_synth_timer(unsigned long opaque)
+{
+	u64 cur_tx;
+	u64 cur_rx;
+	u64 total_flits;
+	u8 update = 0;
+	int i, j, vl;
+	struct hfi1_pportdata *ppd;
+	struct cntr_entry *entry;
+
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)opaque;
+
+	/*
+	 * Rather than keep beating on the CSRs pick a minimal set that we can
+	 * check to watch for potential roll over. We can do this by looking at
+	 * the number of flits sent/recv. If the total flits exceeds 32bits then
+	 * we have to iterate all the counters and update.
+	 */
+	entry = &dev_cntrs[C_DC_RCV_FLITS];
+	cur_rx = entry->rw_cntr(entry, dd, CNTR_INVALID_VL, CNTR_MODE_R, 0);
+
+	entry = &dev_cntrs[C_DC_XMIT_FLITS];
+	cur_tx = entry->rw_cntr(entry, dd, CNTR_INVALID_VL, CNTR_MODE_R, 0);
+
+	hfi1_cdbg(
+	    CNTR,
+	    "[%d] curr tx=0x%llx rx=0x%llx :: last tx=0x%llx rx=0x%llx\n",
+	    dd->unit, cur_tx, cur_rx, dd->last_tx, dd->last_rx);
+
+	if ((cur_tx < dd->last_tx) || (cur_rx < dd->last_rx)) {
+		/*
+		 * May not be strictly necessary to update but it won't hurt and
+		 * simplifies the logic here.
+		 */
+		update = 1;
+		hfi1_cdbg(CNTR, "[%d] Tripwire counter rolled, updating",
+			  dd->unit);
+	} else {
+		total_flits = (cur_tx - dd->last_tx) + (cur_rx - dd->last_rx);
+		hfi1_cdbg(CNTR,
+			  "[%d] total flits 0x%llx limit 0x%llx\n", dd->unit,
+			  total_flits, (u64)CNTR_32BIT_MAX);
+		if (total_flits >= CNTR_32BIT_MAX) {
+			hfi1_cdbg(CNTR, "[%d] 32bit limit hit, updating",
+				  dd->unit);
+			update = 1;
+		}
+	}
+
+	if (update) {
+		hfi1_cdbg(CNTR, "[%d] Updating dd and ppd counters", dd->unit);
+		for (i = 0; i < DEV_CNTR_LAST; i++) {
+			entry = &dev_cntrs[i];
+			if (entry->flags & CNTR_VL) {
+				for (vl = 0; vl < C_VL_COUNT; vl++)
+					read_dev_cntr(dd, i, vl);
+			} else {
+				read_dev_cntr(dd, i, CNTR_INVALID_VL);
+			}
+		}
+		ppd = (struct hfi1_pportdata *)(dd + 1);
+		for (i = 0; i < dd->num_pports; i++, ppd++) {
+			for (j = 0; j < PORT_CNTR_LAST; j++) {
+				entry = &port_cntrs[j];
+				if (entry->flags & CNTR_VL) {
+					for (vl = 0; vl < C_VL_COUNT; vl++)
+						read_port_cntr(ppd, j, vl);
+				} else {
+					read_port_cntr(ppd, j, CNTR_INVALID_VL);
+				}
+			}
+		}
+
+		/*
+		 * We want the value in the register. The goal is to keep track
+		 * of the number of "ticks" not the counter value. In other
+		 * words if the register rolls we want to notice it and go ahead
+		 * and force an update.
+		 */
+		entry = &dev_cntrs[C_DC_XMIT_FLITS];
+		dd->last_tx = entry->rw_cntr(entry, dd, CNTR_INVALID_VL,
+						CNTR_MODE_R, 0);
+
+		entry = &dev_cntrs[C_DC_RCV_FLITS];
+		dd->last_rx = entry->rw_cntr(entry, dd, CNTR_INVALID_VL,
+						CNTR_MODE_R, 0);
+
+		hfi1_cdbg(CNTR, "[%d] setting last tx/rx to 0x%llx 0x%llx",
+			  dd->unit, dd->last_tx, dd->last_rx);
+
+	} else {
+		hfi1_cdbg(CNTR, "[%d] No update necessary", dd->unit);
+	}
+
+mod_timer(&dd->synth_stats_timer, jiffies + HZ * SYNTH_CNT_TIME);
+}
+
+#define C_MAX_NAME 13 /* 12 chars + one for /0 */
+static int init_cntrs(struct hfi1_devdata *dd)
+{
+	int i, rcv_ctxts, index, j;
+	size_t sz;
+	char *p;
+	char name[C_MAX_NAME];
+	struct hfi1_pportdata *ppd;
+
+	/* set up the stats timer; the add_timer is done at the end */
+	init_timer(&dd->synth_stats_timer);
+	dd->synth_stats_timer.function = update_synth_timer;
+	dd->synth_stats_timer.data = (unsigned long) dd;
+
+	/***********************/
+	/* per device counters */
+	/***********************/
+
+	/* size names and determine how many we have*/
+	dd->ndevcntrs = 0;
+	sz = 0;
+	index = 0;
+
+	for (i = 0; i < DEV_CNTR_LAST; i++) {
+		hfi1_dbg_early("Init cntr %s\n", dev_cntrs[i].name);
+		if (dev_cntrs[i].flags & CNTR_DISABLED) {
+			hfi1_dbg_early("\tSkipping %s\n", dev_cntrs[i].name);
+			continue;
+		}
+
+		if (dev_cntrs[i].flags & CNTR_VL) {
+			hfi1_dbg_early("\tProcessing VL cntr\n");
+			dev_cntrs[i].offset = index;
+			for (j = 0; j < C_VL_COUNT; j++) {
+				memset(name, '\0', C_MAX_NAME);
+				snprintf(name, C_MAX_NAME, "%s%d",
+					dev_cntrs[i].name,
+					vl_from_idx(j));
+				sz += strlen(name);
+				sz++;
+				hfi1_dbg_early("\t\t%s\n", name);
+				dd->ndevcntrs++;
+				index++;
+			}
+		} else {
+			/* +1 for newline  */
+			sz += strlen(dev_cntrs[i].name) + 1;
+			dd->ndevcntrs++;
+			dev_cntrs[i].offset = index;
+			index++;
+			hfi1_dbg_early("\tAdding %s\n", dev_cntrs[i].name);
+		}
+	}
+

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
