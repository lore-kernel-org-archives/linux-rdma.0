From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/21] staging/rdma/hfi1: Fix block comments
Date: Sun, 14 Feb 2016 20:21:43 -0800
Message-ID: <20160215042139.351.66309.stgit@scvm10.sc.intel.com>
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

Fix block comments with proper formatting to fix checkpatch warnings:
WARNING: Block comments use * on subsequent lines
WARNING: Block comments use a trailing */ on a separate line

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |   87 ++++++++++++++++++++++-----------
 drivers/staging/rdma/hfi1/chip.h      |   12 +++--
 drivers/staging/rdma/hfi1/file_ops.c  |    6 ++
 drivers/staging/rdma/hfi1/firmware.c  |   18 +++++--
 drivers/staging/rdma/hfi1/hfi.h       |    6 ++
 drivers/staging/rdma/hfi1/init.c      |   12 +++--
 drivers/staging/rdma/hfi1/mad.c       |   62 +++++++++++++++---------
 drivers/staging/rdma/hfi1/mad.h       |    6 ++
 drivers/staging/rdma/hfi1/pcie.c      |    6 ++
 drivers/staging/rdma/hfi1/pio.c       |   12 +++--
 drivers/staging/rdma/hfi1/pio_copy.c  |   30 ++++++++---
 drivers/staging/rdma/hfi1/platform.h  |    8 ++-
 drivers/staging/rdma/hfi1/sdma.c      |    3 +
 drivers/staging/rdma/hfi1/user_sdma.c |   42 +++++++++++-----
 14 files changed, 203 insertions(+), 107 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 53e3273..8e84060 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6392,14 +6392,18 @@ static void dc_shutdown(struct hfi1_devdata *dd)
 	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
 	/* Shutdown the LCB */
 	lcb_shutdown(dd, 1);
-	/* Going to OFFLINE would have causes the 8051 to put the
+	/*
+	 * Going to OFFLINE would have causes the 8051 to put the
 	 * SerDes into reset already. Just need to shut down the 8051,
-	 * itself. */
+	 * itself.
+	 */
 	write_csr(dd, DC_DC8051_CFG_RST, 0x1);
 }
 
-/* Calling this after the DC has been brought out of reset should not
- * do any damage. */
+/*
+ * Calling this after the DC has been brought out of reset should not
+ * do any damage.
+ */
 static void dc_start(struct hfi1_devdata *dd)
 {
 	unsigned long flags;
@@ -6525,8 +6529,10 @@ void handle_sma_message(struct work_struct *work)
 	u64 msg;
 	int ret;
 
-	/* msg is bytes 1-4 of the 40-bit idle message - the command code
-	   is stripped off */
+	/*
+	 * msg is bytes 1-4 of the 40-bit idle message - the command code
+	 * is stripped off
+	 */
 	ret = read_idle_sma(dd, &msg);
 	if (ret)
 		return;
@@ -6815,8 +6821,10 @@ void handle_link_up(struct work_struct *work)
 	}
 }
 
-/* Several pieces of LNI information were cached for SMA in ppd.
- * Reset these on link down */
+/*
+ * Several pieces of LNI information were cached for SMA in ppd.
+ * Reset these on link down
+ */
 static void reset_neighbor_info(struct hfi1_pportdata *ppd)
 {
 	ppd->neighbor_guid = 0;
@@ -6862,8 +6870,10 @@ void handle_link_down(struct work_struct *work)
 	/* disable the port */
 	clear_rcvctrl(ppd->dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
 
-	/* If there is no cable attached, turn the DC off. Otherwise,
-	 * start the link bring up. */
+	/*
+	 * If there is no cable attached, turn the DC off. Otherwise,
+	 * start the link bring up.
+	 */
 	if (!qsfp_mod_present(ppd)) {
 		dc_shutdown(ppd->dd);
 	} else {
@@ -7564,8 +7574,10 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	}
 
 	if (queue_link_down) {
-		/* if the link is already going down or disabled, do not
-		 * queue another */
+		/*
+		 * if the link is already going down or disabled, do not
+		 * queue another
+		 */
 		if ((ppd->host_link_state &
 		    (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN)) ||
 		    ppd->link_enabled == 0) {
@@ -7712,8 +7724,10 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			/* set status bit */
 			dd->err_info_rcvport.status_and_code |=
 				OPA_EI_STATUS_SMASK;
-			/* save first 2 flits in the packet that caused
-			 * the error */
+			/*
+			 * save first 2 flits in the packet that caused
+			 * the error
+			 */
 			 dd->err_info_rcvport.packet_flit1 = hdr0;
 			 dd->err_info_rcvport.packet_flit2 = hdr1;
 		}
@@ -7913,8 +7927,10 @@ static void is_reserved_int(struct hfi1_devdata *dd, unsigned int source)
 }
 
 static const struct is_table is_table[] = {
-/* start		     end
-				name func		interrupt func */
+/*
+ * start		 end
+ *				name func		interrupt func
+ */
 { IS_GENERAL_ERR_START,  IS_GENERAL_ERR_END,
 				is_misc_err_name,	is_misc_err_int },
 { IS_SDMAENG_ERR_START,  IS_SDMAENG_ERR_END,
@@ -10763,8 +10779,10 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 	 */
 	memset(changing, 0, sizeof(changing));
 	memset(lowering_dedicated, 0, sizeof(lowering_dedicated));
-	/* NOTE: Assumes that the individual VL bits are adjacent and in
-	   increasing order */
+	/*
+	 * NOTE: Assumes that the individual VL bits are adjacent and in
+	 * increasing order
+	 */
 	stat_mask =
 		SEND_CM_CREDIT_USED_STATUS_VL0_RETURN_CREDIT_STATUS_SMASK;
 	changing_mask = 0;
@@ -11129,8 +11147,10 @@ static void adjust_rcv_timeout(struct hfi1_ctxtdata *rcd, u32 npkts)
 	}
 
 	rcd->rcvavail_timeout = timeout;
-	/* timeout cannot be larger than rcv_intr_timeout_csr which has already
-	   been verified to be in range */
+	/*
+	 * timeout cannot be larger than rcv_intr_timeout_csr which has already
+	 * been verified to be in range
+	 */
 	write_kctxt_csr(dd, rcd->ctxt, RCV_AVAIL_TIME_OUT,
 		(u64)timeout << RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_SHIFT);
 }
@@ -11323,8 +11343,10 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 	if (op & HFI1_RCVCTRL_TIDFLOW_DIS)
 		rcvctrl &= ~RCV_CTXT_CTRL_TID_FLOW_ENABLE_SMASK;
 	if (op & HFI1_RCVCTRL_ONE_PKT_EGR_ENB) {
-		/* In one-packet-per-eager mode, the size comes from
-		   the RcvArray entry. */
+		/*
+		 * In one-packet-per-eager mode, the size comes from
+		 * the RcvArray entry.
+		 */
 		rcvctrl &= ~RCV_CTXT_CTRL_EGR_BUF_SIZE_SMASK;
 		rcvctrl |= RCV_CTXT_CTRL_ONE_PACKET_PER_EGR_BUFFER_SMASK;
 	}
@@ -12524,7 +12546,8 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			me->type = IRQ_RCVCTXT;
 		} else {
 			/* not in our expected range - complain, then
-			   ignore it */
+			 * ignore it
+			 */
 			dd_dev_err(dd,
 				"Unexpected extra MSI-X interrupt %d\n", i);
 			continue;
@@ -12830,8 +12853,10 @@ static void write_uninitialized_csrs_and_memories(struct hfi1_devdata *dd)
 
 	/* PIO Send buffers */
 	/* SDMA Send buffers */
-	/* These are not normally read, and (presently) have no method
-	   to be read, so are not pre-initialized */
+	/*
+	 * These are not normally read, and (presently) have no method
+	 * to be read, so are not pre-initialized
+	 */
 
 	/* RcvHdrAddr */
 	/* RcvHdrTailAddr */
@@ -13026,8 +13051,10 @@ static void reset_misc_csrs(struct hfi1_devdata *dd)
 		write_csr(dd, MISC_CFG_RSA_SIGNATURE + (8 * i), 0);
 		write_csr(dd, MISC_CFG_RSA_MODULUS + (8 * i), 0);
 	}
-	/* MISC_CFG_SHA_PRELOAD leave alone - always reads 0 and can
-	   only be written 128-byte chunks */
+	/*
+	 * MISC_CFG_SHA_PRELOAD leave alone - always reads 0 and can
+	 * only be written 128-byte chunks
+	 */
 	/* init RSA engine to clear lingering errors */
 	write_csr(dd, MISC_CFG_RSA_CMD, 1);
 	write_csr(dd, MISC_CFG_RSA_MU, 0);
@@ -14045,8 +14072,10 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	dd->minrev = (dd->revision >> CCE_REVISION_CHIP_REV_MINOR_SHIFT)
 			& CCE_REVISION_CHIP_REV_MINOR_MASK;
 
-	/* obtain the hardware ID - NOT related to unit, which is a
-	   software enumeration */
+	/*
+	 * obtain the hardware ID - NOT related to unit, which is a
+	 * software enumeration
+	 */
 	reg = read_csr(dd, CCE_REVISION2);
 	dd->hfi1_id = (reg >> CCE_REVISION2_HFI_ID_SHIFT)
 					& CCE_REVISION2_HFI_ID_MASK;
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 32e91e7..0b7055b 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -79,8 +79,10 @@
 #define PIO_CMASK 0x7ff	/* counter mask for free and fill counters */
 #define MAX_EAGER_ENTRIES    2048	/* max receive eager entries */
 #define MAX_TID_PAIR_ENTRIES 1024	/* max receive expected pairs */
-/* Virtual? Allocation Unit, defined as AU = 8*2^vAU, 64 bytes, AU is fixed
-   at 64 bytes for all generation one devices */
+/*
+ * Virtual? Allocation Unit, defined as AU = 8*2^vAU, 64 bytes, AU is fixed
+ * at 64 bytes for all generation one devices
+ */
 #define CM_VAU 3
 /* HFI link credit count, AKA receive buffer depth (RBUF_DEPTH) */
 #define CM_GLOBAL_CREDITS 0x940
@@ -518,8 +520,10 @@ enum {
 #define LCB_CRC_48B			0x2	/* 48b CRC */
 #define LCB_CRC_12B_16B_PER_LANE	0x3	/* 12b-16b per lane CRC */
 
-/* the following enum is (almost) a copy/paste of the definition
- * in the OPA spec, section 20.2.2.6.8 (PortInfo) */
+/*
+ * the following enum is (almost) a copy/paste of the definition
+ * in the OPA spec, section 20.2.2.6.8 (PortInfo)
+ */
 enum {
 	PORT_LTP_CRC_MODE_NONE = 0,
 	PORT_LTP_CRC_MODE_14 = 1, /* 14-bit LTP CRC mode (optional) */
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 5077ee0..c4b9dd4 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -388,8 +388,10 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 				break;
 			}
 			if (dd->flags & HFI1_FORCED_FREEZE) {
-				/* Don't allow context reset if we are into
-				 * forced freeze */
+				/*
+				 * Don't allow context reset if we are into
+				 * forced freeze
+				 */
 				ret = -ENODEV;
 				break;
 			}
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 16c9dc7..3a7163d 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1294,8 +1294,10 @@ static int load_pcie_serdes_firmware(struct hfi1_devdata *dd,
 	/* step 3: enable XDMEM access */
 	sbus_request(dd, ra, 0x01, WRITE_SBUS_RECEIVER, 0x00000d40);
 	/* step 4: load firmware into SBus Master XDMEM */
-	/* NOTE: the dmem address, write_en, and wdata are all pre-packed,
-	   we only need to pick up the bytes and write them */
+	/*
+	 * NOTE: the dmem address, write_en, and wdata are all pre-packed,
+	 * we only need to pick up the bytes and write them
+	 */
 	for (i = 0; i < fdet->firmware_len; i += 4) {
 		sbus_request(dd, ra, 0x04, WRITE_SBUS_RECEIVER,
 					*(u32 *)&fdet->firmware_ptr[i]);
@@ -1305,8 +1307,10 @@ static int load_pcie_serdes_firmware(struct hfi1_devdata *dd,
 	/* step 6: allow SBus Spico to run */
 	sbus_request(dd, ra, 0x05, WRITE_SBUS_RECEIVER, 0x00000000);
 
-	/* steps 7-11: run RSA, if it succeeds, firmware is available to
-	   be swapped */
+	/*
+	 * steps 7-11: run RSA, if it succeeds, firmware is available to
+	 * be swapped
+	 */
 	return run_rsa(dd, "PCIe serdes", fdet->signature);
 }
 
@@ -1744,8 +1748,10 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 
 			src_ptr = (u32 *)((u8 *)src_ptr + seek);
 
-			/* We expect the field to be byte aligned and whole byte
-			 * lengths if we are here */
+			/*
+			 * We expect the field to be byte aligned and whole byte
+			 * lengths if we are here
+			 */
 			memcpy(data, src_ptr, wlen);
 			return 0;
 		}
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 774d8ff..4db5ad9 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -718,8 +718,10 @@ struct hfi1_pportdata {
 	/* CA's max number of 64 entry units in the congestion control table */
 	u8 cc_max_table_entries;
 
-	/* begin congestion log related entries
-	 * cc_log_lock protects all congestion log related data */
+	/*
+	 * begin congestion log related entries
+	 * cc_log_lock protects all congestion log related data
+	 */
 	spinlock_t cc_log_lock ____cacheline_aligned_in_smp;
 	u8 threshold_cong_event_map[OPA_MAX_SLS / 8];
 	u16 threshold_event_counter;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index aabdc3d..f794604 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -790,8 +790,10 @@ done:
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			ppd = dd->pport + pidx;
 
-			/* start the serdes - must be after interrupts are
-			   enabled so we are notified when the link goes up */
+			/*
+			 * start the serdes - must be after interrupts are
+			 * enabled so we are notified when the link goes up
+			 */
 			lastfail = bringup_serdes(ppd);
 			if (lastfail)
 				dd_dev_info(dd,
@@ -1188,8 +1190,10 @@ static int __init hfi1_mod_init(void)
 		user_credit_return_threshold = 100;
 
 	compute_krcvqs();
-	/* sanitize receive interrupt count, time must wait until after
-	   the hardware type is known */
+	/*
+	 * sanitize receive interrupt count, time must wait until after
+	 * the hardware type is known
+	 */
 	if (rcv_intr_count > RCV_HDR_HEAD_COUNTER_MASK)
 		rcv_intr_count = RCV_HDR_HEAD_COUNTER_MASK;
 	/* reject invalid combinations */
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 118a09e..13cf66f 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -696,8 +696,10 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	/* read the cached value of DC_LCB_STS_ROUND_TRIP_LTP_CNT */
 	read_lcb_cache(DC_LCB_STS_ROUND_TRIP_LTP_CNT, &tmp);
 
-	/* this counter is 16 bits wide, but the replay_depth.wire
-	 * variable is only 8 bits */
+	/*
+	 * this counter is 16 bits wide, but the replay_depth.wire
+	 * variable is only 8 bits
+	 */
 	if (tmp > 0xff)
 		tmp = 0xff;
 	pi->replay_depth.wire = tmp;
@@ -1621,8 +1623,10 @@ static int __subn_set_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
 	/* IB numbers ports from 1, hw from 0 */
 	ppd = dd->pport + (port - 1);
 	lstate = driver_lstate(ppd);
-	/* it's known that async_update is 0 by this point, but include
-	 * the explicit check for clarity */
+	/*
+	 * it's known that async_update is 0 by this point, but include
+	 * the explicit check for clarity
+	 */
 	if (!async_update &&
 	    (lstate == IB_PORT_ARMED || lstate == IB_PORT_ACTIVE)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
@@ -1797,8 +1801,10 @@ static int __subn_get_opa_cable_info(struct opa_smp *smp, u32 am, u8 *data,
 #define __CI_PAGE_MASK ~(__CI_PAGE_SIZE - 1)
 #define __CI_PAGE_NUM(a) ((a) & __CI_PAGE_MASK)
 
-	/* check that addr is within spec, and
-	 * addr and (addr + len - 1) are on the same "page" */
+	/*
+	 * check that addr is within spec, and
+	 * addr and (addr + len - 1) are on the same "page"
+	 */
 	if (addr >= 4096 ||
 		(__CI_PAGE_NUM(addr) != __CI_PAGE_NUM(addr + len - 1))) {
 		smp->status |= IB_SMP_INVALID_FIELD;
@@ -1935,8 +1941,10 @@ static int __subn_set_opa_vl_arb(struct opa_smp *smp, u32 am, u8 *data,
 	case OPA_VLARB_HIGH_ELEMENTS:
 		(void)fm_set_table(ppd, FM_TBL_VL_HIGH_ARB, p);
 		break;
-	/* neither OPA_VLARB_PREEMPT_ELEMENTS, or OPA_VLARB_PREEMPT_MATRIX
-	 * can be changed from the default values */
+	/*
+	 * neither OPA_VLARB_PREEMPT_ELEMENTS, or OPA_VLARB_PREEMPT_MATRIX
+	 * can be changed from the default values
+	 */
 	case OPA_VLARB_PREEMPT_ELEMENTS:
 		/* FALLTHROUGH */
 	case OPA_VLARB_PREEMPT_MATRIX:
@@ -2148,8 +2156,10 @@ struct opa_port_data_counters_msg {
 };
 
 struct opa_port_error_counters64_msg {
-	/* Request contains first two fields, response contains the
-	 * whole magilla */
+	/*
+	 * Request contains first two fields, response contains the
+	 * whole magilla
+	 */
 	__be64 port_select_mask[4];
 	__be32 vl_select_mask;
 
@@ -2673,11 +2683,12 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		/* rsp->port_vl_xmit_time_cong is 0 for HFIs */
 		/* rsp->port_vl_xmit_wasted_bw ??? */
 		/* port_vl_xmit_wait_data - TXE (table 13-9 HFI spec) ???
-		 * does this differ from rsp->vls[vfi].port_vl_xmit_wait */
+		 * does this differ from rsp->vls[vfi].port_vl_xmit_wait
+		 */
 		/*rsp->vls[vfi].port_vl_mark_fecn =
-			cpu_to_be64(read_csr(dd, DCC_PRF_PORT_VL_MARK_FECN_CNT
-				+ offset));
-		*/
+		 *	cpu_to_be64(read_csr(dd, DCC_PRF_PORT_VL_MARK_FECN_CNT
+		 *		+ offset));
+		 */
 		vlinfo++;
 		vfi++;
 	}
@@ -2996,8 +3007,10 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	/* ExcessiverBufferOverrunInfo */
 	reg = read_csr(dd, RCV_ERR_INFO);
 	if (reg & RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SMASK) {
-		/* if the RcvExcessBufferOverrun bit is set, save SC of
-		 * first pkt that encountered an excess buffer overrun */
+		/*
+		 * if the RcvExcessBufferOverrun bit is set, save SC of
+		 * first pkt that encountered an excess buffer overrun
+		 */
 		u8 tmp = (u8)reg;
 
 		tmp &=  RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SC_SMASK;
@@ -3093,8 +3106,9 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 		write_dev_cntr(dd, C_DC_RCV_BBL, CNTR_INVALID_VL, 0);
 
 	/* Only applicable for switch */
-	/*if (counter_select & CS_PORT_MARK_FECN)
-		write_csr(dd, DCC_PRF_PORT_MARK_FECN_CNT, 0);*/
+	/* if (counter_select & CS_PORT_MARK_FECN)
+	 *	write_csr(dd, DCC_PRF_PORT_MARK_FECN_CNT, 0);
+	 */
 
 	if (counter_select & CS_PORT_RCV_CONSTRAINT_ERRORS)
 		write_port_cntr(ppd, C_SW_RCV_CSTR_ERR, CNTR_INVALID_VL, 0);
@@ -3167,9 +3181,9 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 		if (counter_select & CS_PORT_RCV_BUBBLE)
 			write_dev_cntr(dd, C_DC_RCV_BBL_VL, idx_from_vl(vl), 0);
 
-		/*if (counter_select & CS_PORT_MARK_FECN)
-		     write_csr(dd, DCC_PRF_PORT_VL_MARK_FECN_CNT + offset, 0);
-		*/
+		/* if (counter_select & CS_PORT_MARK_FECN)
+		 *     write_csr(dd, DCC_PRF_PORT_VL_MARK_FECN_CNT + offset, 0);
+		 */
 		/* port_vl_xmit_discards ??? */
 	}
 
@@ -3226,8 +3240,10 @@ static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
 
 	/* ExcessiverBufferOverrunInfo */
 	if (error_info_select & ES_EXCESSIVE_BUFFER_OVERRUN_INFO)
-		/* status bit is essentially kept in the h/w - bit 5 of
-		 * RCV_ERR_INFO */
+		/*
+		 * status bit is essentially kept in the h/w - bit 5 of
+		 * RCV_ERR_INFO
+		 */
 		write_csr(dd, RCV_ERR_INFO,
 			  RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SMASK);
 
diff --git a/drivers/staging/rdma/hfi1/mad.h b/drivers/staging/rdma/hfi1/mad.h
index f9e93c0..9ebaaf9 100644
--- a/drivers/staging/rdma/hfi1/mad.h
+++ b/drivers/staging/rdma/hfi1/mad.h
@@ -51,8 +51,10 @@
 #define _HFI1_MAD_H
 
 #include <rdma/ib_pma.h>
-#define USE_PI_LED_ENABLE	1 /* use led enabled bit in struct
-				   * opa_port_states, if available */
+#define USE_PI_LED_ENABLE	1 /*
+				   * use led enabled bit in struct
+				   * opa_port_states, if available
+				   */
 #include <rdma/opa_smi.h>
 #include <rdma/opa_port_info.h>
 #ifndef PI_LED_ENABLE_SUP
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index b169166..4d9fd3b 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -284,9 +284,11 @@ static void msix_setup(struct hfi1_devdata *dd, int pos, u32 *msixcnt,
 	struct msix_entry *msix_entry;
 	int i;
 
-	/* We can't pass hfi1_msix_entry array to msix_setup
+	/*
+	 * We can't pass hfi1_msix_entry array to msix_setup
 	 * so use a dummy msix_entry array and copy the allocated
-	 * irq back to the hfi1_msix_entry array. */
+	 * irq back to the hfi1_msix_entry array.
+	 */
 	msix_entry = kmalloc_array(nvec, sizeof(*msix_entry), GFP_KERNEL);
 	if (!msix_entry) {
 		ret = -ENOMEM;
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index b0a2a45..191b260 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -177,8 +177,10 @@ static struct mem_pool_config sc_mem_pool_config[NUM_SC_POOLS] = {
 
 /* memory pool information, used when calculating final sizes */
 struct mem_pool_info {
-	int centipercent;	/* 100th of 1% of memory to use, -1 if blocks
-				   already set */
+	int centipercent;	/*
+				 * 100th of 1% of memory to use, -1 if blocks
+				 * already set
+				 */
 	int count;		/* count of contexts in the pool */
 	int blocks;		/* block size of the pool */
 	int size;		/* context size, in blocks */
@@ -1429,8 +1431,10 @@ retry:
 	next = head + 1;
 	if (next >= sc->sr_size)
 		next = 0;
-	/* update the head - must be last! - the releaser can look at fields
-	   in pbuf once we move the head */
+	/*
+	 * update the head - must be last! - the releaser can look at fields
+	 * in pbuf once we move the head
+	 */
 	smp_wmb();
 	sc->sr_head = next;
 	spin_unlock_irqrestore(&sc->alloc_lock, flags);
diff --git a/drivers/staging/rdma/hfi1/pio_copy.c b/drivers/staging/rdma/hfi1/pio_copy.c
index dc0c178..6f97d22 100644
--- a/drivers/staging/rdma/hfi1/pio_copy.c
+++ b/drivers/staging/rdma/hfi1/pio_copy.c
@@ -86,8 +86,10 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 	dend = dest + ((count >> 1) * sizeof(u64));
 
 	if (dend < send) {
-		/* all QWORD data is within the SOP block, does *not*
-		   reach the end of the SOP block */
+		/*
+		 * all QWORD data is within the SOP block, does *not*
+		 * reach the end of the SOP block
+		 */
 
 		while (dest < dend) {
 			writeq(*(u64 *)from, dest);
@@ -152,8 +154,10 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 		writeq(val.val64, dest);
 		dest += sizeof(u64);
 	}
-	/* fill in rest of block, no need to check pbuf->end
-	   as we only wrap on a block boundary */
+	/*
+	 * fill in rest of block, no need to check pbuf->end
+	 * as we only wrap on a block boundary
+	 */
 	while (((unsigned long)dest & PIO_BLOCK_MASK) != 0) {
 		writeq(0, dest);
 		dest += sizeof(u64);
@@ -466,8 +470,10 @@ void seg_pio_copy_start(struct pio_buf *pbuf, u64 pbc,
 	dend = dest + ((nbytes >> 3) * sizeof(u64));
 
 	if (dend < send) {
-		/* all QWORD data is within the SOP block, does *not*
-		   reach the end of the SOP block */
+		/*
+		 * all QWORD data is within the SOP block, does *not*
+		 * reach the end of the SOP block
+		 */
 
 		while (dest < dend) {
 			writeq(*(u64 *)from, dest);
@@ -562,8 +568,10 @@ static void mid_copy_mix(struct pio_buf *pbuf, const void *from, size_t nbytes)
 		void __iomem *send;		/* SOP end */
 		void __iomem *xend;
 
-		/* calculate the end of data or end of block, whichever
-		   comes first */
+		/*
+		 * calculate the end of data or end of block, whichever
+		 * comes first
+		 */
 		send = pbuf->start + PIO_BLOCK_SIZE;
 		xend = send < dend ? send : dend;
 
@@ -656,8 +664,10 @@ static void mid_copy_straight(struct pio_buf *pbuf,
 		void __iomem *send;		/* SOP end */
 		void __iomem *xend;
 
-		/* calculate the end of data or end of block, whichever
-		   comes first */
+		/*
+		 * calculate the end of data or end of block, whichever
+		 * comes first
+		 */
 		send = pbuf->start + PIO_BLOCK_SIZE;
 		xend = send < dend ? send : dend;
 
diff --git a/drivers/staging/rdma/hfi1/platform.h b/drivers/staging/rdma/hfi1/platform.h
index cc280cc..1f41bdc 100644
--- a/drivers/staging/rdma/hfi1/platform.h
+++ b/drivers/staging/rdma/hfi1/platform.h
@@ -186,9 +186,9 @@ static const u32 platform_config_table_limits[PLATFORM_CONFIG_TABLE_MAX] = {
  */
 
 /*
- *=====================================================
+ * =====================================================
  *  System table encodings
- *====================================================
+ * =====================================================
  */
 #define PLATFORM_CONFIG_MAGIC_NUM		0x3d4f5041
 #define PLATFORM_CONFIG_MAGIC_NUMBER_LEN	4
@@ -208,9 +208,9 @@ enum platform_config_qsfp_power_class_encoding {
 };
 
 /*
- *=====================================================
+ * ====================================================
  *  Port table encodings
- *====================================================
+ * ====================================================
  */
 enum platform_config_port_type_encoding {
 	PORT_TYPE_UNKNOWN,
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 59627b7..9ffeeda 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -2220,7 +2220,8 @@ static void __sdma_process_event(struct sdma_engine *sde,
 			 * of link up, then we need to start up.
 			 * This can happen when hw down is requested while
 			 * bringing the link up with traffic active on
-			 * 7220, e.g. */
+			 * 7220, e.g.
+			 */
 			ss->go_s99_running = 1;
 			/* fall through and start dma engine */
 		case sdma_event_e10_go_hw_start:
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 097d278..b6d0926 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -179,8 +179,10 @@ struct user_sdma_iovec {
 	unsigned npages;
 	/* array of pinned pages for this vector */
 	struct page **pages;
-	/* offset into the virtual address space of the vector at
-	 * which we last left off. */
+	/*
+	 * offset into the virtual address space of the vector at
+	 * which we last left off.
+	 */
 	u64 offset;
 };
 
@@ -596,8 +598,10 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	}
 
 	req->koffset = le32_to_cpu(req->hdr.kdeth.swdata[6]);
-	/* Calculate the initial TID offset based on the values of
-	   KDETH.OFFSET and KDETH.OM that are passed in. */
+	/*
+	 * Calculate the initial TID offset based on the values of
+	 * KDETH.OFFSET and KDETH.OM that are passed in.
+	 */
 	req->tidoffset = KDETH_GET(req->hdr.kdeth.ver_tid_offset, OFFSET) *
 		(KDETH_GET(req->hdr.kdeth.ver_tid_offset, OM) ?
 		 KDETH_OM_LARGE : KDETH_OM_SMALL);
@@ -742,8 +746,10 @@ static inline u32 compute_data_length(struct user_sdma_request *req,
 	} else if (req_opcode(req->info.ctrl) == EXPECTED) {
 		u32 tidlen = EXP_TID_GET(req->tids[req->tididx], LEN) *
 			PAGE_SIZE;
-		/* Get the data length based on the remaining space in the
-		 * TID pair. */
+		/*
+		 * Get the data length based on the remaining space in the
+		 * TID pair.
+		 */
 		len = min(tidlen - req->tidoffset, (u32)req->info.fragsize);
 		/* If we've filled up the TID pair, move to the next one. */
 		if (unlikely(!len) && ++req->tididx < req->n_tids &&
@@ -753,9 +759,11 @@ static inline u32 compute_data_length(struct user_sdma_request *req,
 			req->tidoffset = 0;
 			len = min_t(u32, tidlen, req->info.fragsize);
 		}
-		/* Since the TID pairs map entire pages, make sure that we
+		/*
+		 * Since the TID pairs map entire pages, make sure that we
 		 * are not going to try to send more data that we have
-		 * remaining. */
+		 * remaining.
+		 */
 		len = min(len, req->data_len - req->sent);
 	} else
 		len = min(req->data_len - req->sent, (u32)req->info.fragsize);
@@ -979,8 +987,10 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		req->sent += data_sent;
 		if (req->data_len) {
 			tx->iovecs[tx->idx].vec->offset += iov_offset;
-			/* If we've reached the end of the io vector, mark it
-			 * so the callback can unpin the pages and free it. */
+			/*
+			 * If we've reached the end of the io vector, mark it
+			 * so the callback can unpin the pages and free it.
+			 */
 			if (tx->iovecs[tx->idx].vec->offset ==
 			    tx->iovecs[tx->idx].vec->iov.iov_len)
 				tx->iovecs[tx->idx].flags |=
@@ -1216,8 +1226,10 @@ static int set_txreq_header(struct user_sdma_request *req,
 		if ((req->tidoffset) == (EXP_TID_GET(tidval, LEN) *
 					 PAGE_SIZE)) {
 			req->tidoffset = 0;
-			/* Since we don't copy all the TIDs, all at once,
-			 * we have to check again. */
+			/*
+			 * Since we don't copy all the TIDs, all at once,
+			 * we have to check again.
+			 */
 			if (++req->tididx > req->n_tids - 1 ||
 			    !req->tids[req->tididx]) {
 				return -EINVAL;
@@ -1298,8 +1310,10 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 		if ((req->tidoffset) == (EXP_TID_GET(tidval, LEN) *
 					 PAGE_SIZE)) {
 			req->tidoffset = 0;
-			/* Since we don't copy all the TIDs, all at once,
-			 * we have to check again. */
+			/*
+			 * Since we don't copy all the TIDs, all at once,
+			 * we have to check again.
+			 */
 			if (++req->tididx > req->n_tids - 1 ||
 			    !req->tids[req->tididx]) {
 				return -EINVAL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
