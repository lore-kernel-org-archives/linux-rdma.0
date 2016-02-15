From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/21] staging/rdma/hfi1: Fix code alignment
Date: Sun, 14 Feb 2016 20:21:52 -0800
Message-ID: <20160215042148.351.58844.stgit@scvm10.sc.intel.com>
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

Fix code alignment to fix checkpatch check:
CHECK: Alignment should match open parenthesis

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |  921 ++++++++++++------------
 drivers/staging/rdma/hfi1/debugfs.c   |   34 -
 drivers/staging/rdma/hfi1/driver.c    |   32 -
 drivers/staging/rdma/hfi1/eprom.c     |   39 -
 drivers/staging/rdma/hfi1/file_ops.c  |    8 
 drivers/staging/rdma/hfi1/firmware.c  |  124 ++-
 drivers/staging/rdma/hfi1/hfi.h       |    5 
 drivers/staging/rdma/hfi1/init.c      |   24 -
 drivers/staging/rdma/hfi1/intr.c      |   12 
 drivers/staging/rdma/hfi1/mad.c       |  141 ++--
 drivers/staging/rdma/hfi1/pcie.c      |   99 +--
 drivers/staging/rdma/hfi1/pio.c       |   71 +-
 drivers/staging/rdma/hfi1/pio.h       |    4 
 drivers/staging/rdma/hfi1/pio_copy.c  |   14 
 drivers/staging/rdma/hfi1/qsfp.c      |    2 
 drivers/staging/rdma/hfi1/rc.c        |    4 
 drivers/staging/rdma/hfi1/ruc.c       |   14 
 drivers/staging/rdma/hfi1/sdma.c      |  178 ++---
 drivers/staging/rdma/hfi1/sysfs.c     |   36 -
 drivers/staging/rdma/hfi1/trace.c     |   47 +
 drivers/staging/rdma/hfi1/trace.h     | 1280 ++++++++++++++++-----------------
 drivers/staging/rdma/hfi1/twsi.c      |    2 
 drivers/staging/rdma/hfi1/uc.c        |    2 
 drivers/staging/rdma/hfi1/ud.c        |    7 
 drivers/staging/rdma/hfi1/user_sdma.c |    2 
 drivers/staging/rdma/hfi1/verbs.c     |    3 
 26 files changed, 1508 insertions(+), 1597 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 8e84060..ce61883 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -944,7 +944,7 @@ static struct flag_table dc8051_err_flags[] = {
 	FLAG_ENTRY0("IRAM_MBE", D8E(IRAM_MBE)),
 	FLAG_ENTRY0("IRAM_SBE", D8E(IRAM_SBE)),
 	FLAG_ENTRY0("UNMATCHED_SECURE_MSG_ACROSS_BCC_LANES",
-		D8E(UNMATCHED_SECURE_MSG_ACROSS_BCC_LANES)),
+		    D8E(UNMATCHED_SECURE_MSG_ACROSS_BCC_LANES)),
 	FLAG_ENTRY0("INVALID_CSR_ADDR", D8E(INVALID_CSR_ADDR)),
 };
 
@@ -958,7 +958,7 @@ static struct flag_table dc8051_info_err_flags[] = {
 	FLAG_ENTRY0("Unknown frame received",  UNKNOWN_FRAME),
 	FLAG_ENTRY0("Target BER not met",      TARGET_BER_NOT_MET),
 	FLAG_ENTRY0("Serdes internal loopback failure",
-					FAILED_SERDES_INTERNAL_LOOPBACK),
+		    FAILED_SERDES_INTERNAL_LOOPBACK),
 	FLAG_ENTRY0("Failed SerDes init",      FAILED_SERDES_INIT),
 	FLAG_ENTRY0("Failed LNI(Polling)",     FAILED_LNI_POLLING),
 	FLAG_ENTRY0("Failed LNI(Debounce)",    FAILED_LNI_DEBOUNCE),
@@ -1147,11 +1147,8 @@ struct cntr_entry {
 	/*
 	 * accessor for stat element, context either dd or ppd
 	 */
-	u64 (*rw_cntr)(const struct cntr_entry *,
-			       void *context,
-			       int vl,
-			       int mode,
-			       u64 data);
+	u64 (*rw_cntr)(const struct cntr_entry *, void *context, int vl,
+		       int mode, u64 data);
 };
 
 #define C_RCV_HDR_OVF_FIRST C_RCV_HDR_OVF_0
@@ -1300,7 +1297,7 @@ static inline u64 read_write_csr(const struct hfi1_devdata *dd, u32 csr,
 
 /* Dev Access */
 static u64 dev_access_u32_csr(const struct cntr_entry *entry,
-			    void *context, int vl, int mode, u64 data)
+			      void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_devdata *dd = context;
 	u64 csr = entry->csr;
@@ -1358,7 +1355,7 @@ static u64 access_sde_progress_int_cnt(const struct cntr_entry *entry,
 }
 
 static u64 dev_access_u64_csr(const struct cntr_entry *entry, void *context,
-			    int vl, int mode, u64 data)
+			      int vl, int mode, u64 data)
 {
 	struct hfi1_devdata *dd = context;
 
@@ -1379,7 +1376,7 @@ static u64 dev_access_u64_csr(const struct cntr_entry *entry, void *context,
 }
 
 static u64 dc_access_lcb_cntr(const struct cntr_entry *entry, void *context,
-			    int vl, int mode, u64 data)
+			      int vl, int mode, u64 data)
 {
 	struct hfi1_devdata *dd = context;
 	u32 csr = entry->csr;
@@ -1403,7 +1400,7 @@ static u64 dc_access_lcb_cntr(const struct cntr_entry *entry, void *context,
 
 /* Port Access */
 static u64 port_access_u32_csr(const struct cntr_entry *entry, void *context,
-			     int vl, int mode, u64 data)
+			       int vl, int mode, u64 data)
 {
 	struct hfi1_pportdata *ppd = context;
 
@@ -1413,7 +1410,7 @@ static u64 port_access_u32_csr(const struct cntr_entry *entry, void *context,
 }
 
 static u64 port_access_u64_csr(const struct cntr_entry *entry,
-			     void *context, int vl, int mode, u64 data)
+			       void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_pportdata *ppd = context;
 	u64 val;
@@ -1453,7 +1450,7 @@ static inline u64 read_write_sw(struct hfi1_devdata *dd, u64 *cntr, int mode,
 }
 
 static u64 access_sw_link_dn_cnt(const struct cntr_entry *entry, void *context,
-			       int vl, int mode, u64 data)
+				 int vl, int mode, u64 data)
 {
 	struct hfi1_pportdata *ppd = context;
 
@@ -1463,7 +1460,7 @@ static u64 access_sw_link_dn_cnt(const struct cntr_entry *entry, void *context,
 }
 
 static u64 access_sw_link_up_cnt(const struct cntr_entry *entry, void *context,
-			       int vl, int mode, u64 data)
+				 int vl, int mode, u64 data)
 {
 	struct hfi1_pportdata *ppd = context;
 
@@ -1484,7 +1481,7 @@ static u64 access_sw_unknown_frame_cnt(const struct cntr_entry *entry,
 }
 
 static u64 access_sw_xmit_discards(const struct cntr_entry *entry,
-				    void *context, int vl, int mode, u64 data)
+				   void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_pportdata *ppd = (struct hfi1_pportdata *)context;
 	u64 zero = 0;
@@ -1501,7 +1498,8 @@ static u64 access_sw_xmit_discards(const struct cntr_entry *entry,
 }
 
 static u64 access_xmit_constraint_errs(const struct cntr_entry *entry,
-				     void *context, int vl, int mode, u64 data)
+				       void *context, int vl, int mode,
+				       u64 data)
 {
 	struct hfi1_pportdata *ppd = context;
 
@@ -1513,7 +1511,7 @@ static u64 access_xmit_constraint_errs(const struct cntr_entry *entry,
 }
 
 static u64 access_rcv_constraint_errs(const struct cntr_entry *entry,
-				     void *context, int vl, int mode, u64 data)
+				      void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_pportdata *ppd = context;
 
@@ -1569,7 +1567,7 @@ static u64 access_sw_cpu_intr(const struct cntr_entry *entry,
 }
 
 static u64 access_sw_cpu_rcv_limit(const struct cntr_entry *entry,
-			      void *context, int vl, int mode, u64 data)
+				   void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_devdata *dd = context;
 
@@ -1610,7 +1608,7 @@ static u64 access_sw_kmem_wait(const struct cntr_entry *entry,
 }
 
 static u64 access_sw_send_schedule(const struct cntr_entry *entry,
-			       void *context, int vl, int mode, u64 data)
+				   void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
 
@@ -4965,28 +4963,28 @@ static struct cntr_entry port_cntrs[PORT_CNTR_LAST] = {
 [C_TX_WORDS] = TXE64_PORT_CNTR_ELEM(TxWords, SEND_DWORD_CNT, CNTR_NORMAL),
 [C_TX_WAIT] = TXE64_PORT_CNTR_ELEM(TxWait, SEND_WAIT_CNT, CNTR_SYNTH),
 [C_TX_FLIT_VL] = TXE64_PORT_CNTR_ELEM(TxFlitVL, SEND_DATA_VL0_CNT,
-			CNTR_SYNTH | CNTR_VL),
+				      CNTR_SYNTH | CNTR_VL),
 [C_TX_PKT_VL] = TXE64_PORT_CNTR_ELEM(TxPktVL, SEND_DATA_PKT_VL0_CNT,
-			CNTR_SYNTH | CNTR_VL),
+				     CNTR_SYNTH | CNTR_VL),
 [C_TX_WAIT_VL] = TXE64_PORT_CNTR_ELEM(TxWaitVL, SEND_WAIT_VL0_CNT,
-			CNTR_SYNTH | CNTR_VL),
+				      CNTR_SYNTH | CNTR_VL),
 [C_RX_PKT] = RXE64_PORT_CNTR_ELEM(RxPkt, RCV_DATA_PKT_CNT, CNTR_NORMAL),
 [C_RX_WORDS] = RXE64_PORT_CNTR_ELEM(RxWords, RCV_DWORD_CNT, CNTR_NORMAL),
 [C_SW_LINK_DOWN] = CNTR_ELEM("SwLinkDown", 0, 0, CNTR_SYNTH | CNTR_32BIT,
-			access_sw_link_dn_cnt),
+			     access_sw_link_dn_cnt),
 [C_SW_LINK_UP] = CNTR_ELEM("SwLinkUp", 0, 0, CNTR_SYNTH | CNTR_32BIT,
-			access_sw_link_up_cnt),
+			   access_sw_link_up_cnt),
 [C_SW_UNKNOWN_FRAME] = CNTR_ELEM("UnknownFrame", 0, 0, CNTR_NORMAL,
 				 access_sw_unknown_frame_cnt),
 [C_SW_XMIT_DSCD] = CNTR_ELEM("XmitDscd", 0, 0, CNTR_SYNTH | CNTR_32BIT,
-			access_sw_xmit_discards),
+			     access_sw_xmit_discards),
 [C_SW_XMIT_DSCD_VL] = CNTR_ELEM("XmitDscdVl", 0, 0,
-			CNTR_SYNTH | CNTR_32BIT | CNTR_VL,
-			access_sw_xmit_discards),
+				CNTR_SYNTH | CNTR_32BIT | CNTR_VL,
+				access_sw_xmit_discards),
 [C_SW_XMIT_CSTR_ERR] = CNTR_ELEM("XmitCstrErr", 0, 0, CNTR_SYNTH,
-			access_xmit_constraint_errs),
+				 access_xmit_constraint_errs),
 [C_SW_RCV_CSTR_ERR] = CNTR_ELEM("RcvCstrErr", 0, 0, CNTR_SYNTH,
-			access_rcv_constraint_errs),
+				access_rcv_constraint_errs),
 [C_SW_IBP_LOOP_PKTS] = SW_IBP_CNTR(LoopPkts, loop_pkts),
 [C_SW_IBP_RC_RESENDS] = SW_IBP_CNTR(RcResend, rc_resends),
 [C_SW_IBP_RNR_NAKS] = SW_IBP_CNTR(RnrNak, rnr_naks),
@@ -5002,9 +5000,9 @@ static struct cntr_entry port_cntrs[PORT_CNTR_LAST] = {
 [C_SW_CPU_RC_ACKS] = CNTR_ELEM("RcAcks", 0, 0, CNTR_NORMAL,
 			       access_sw_cpu_rc_acks),
 [C_SW_CPU_RC_QACKS] = CNTR_ELEM("RcQacks", 0, 0, CNTR_NORMAL,
-			       access_sw_cpu_rc_qacks),
+				access_sw_cpu_rc_qacks),
 [C_SW_CPU_RC_DELAYED_COMP] = CNTR_ELEM("RcDelayComp", 0, 0, CNTR_NORMAL,
-			       access_sw_cpu_rc_delayed_comp),
+				       access_sw_cpu_rc_delayed_comp),
 [OVR_LBL(0)] = OVR_ELM(0), [OVR_LBL(1)] = OVR_ELM(1),
 [OVR_LBL(2)] = OVR_ELM(2), [OVR_LBL(3)] = OVR_ELM(3),
 [OVR_LBL(4)] = OVR_ELM(4), [OVR_LBL(5)] = OVR_ELM(5),
@@ -5153,7 +5151,7 @@ done:
  * the buffer.  End in '*' if the buffer is too short.
  */
 static char *flag_string(char *buf, int buf_len, u64 flags,
-				struct flag_table *table, int table_size)
+			 struct flag_table *table, int table_size)
 {
 	char extra[32];
 	char *p = buf;
@@ -5214,10 +5212,8 @@ static char *is_misc_err_name(char *buf, size_t bsize, unsigned int source)
 	if (source < ARRAY_SIZE(cce_misc_names))
 		strncpy(buf, cce_misc_names[source], bsize);
 	else
-		snprintf(buf,
-			bsize,
-			"Reserved%u",
-			source + IS_GENERAL_ERR_START);
+		snprintf(buf, bsize, "Reserved%u",
+			 source + IS_GENERAL_ERR_START);
 
 	return buf;
 }
@@ -5341,51 +5337,56 @@ static char *is_reserved_name(char *buf, size_t bsize, unsigned int source)
 static char *cce_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-			cce_err_status_flags, ARRAY_SIZE(cce_err_status_flags));
+			   cce_err_status_flags,
+			   ARRAY_SIZE(cce_err_status_flags));
 }
 
 static char *rxe_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-			rxe_err_status_flags, ARRAY_SIZE(rxe_err_status_flags));
+			   rxe_err_status_flags,
+			   ARRAY_SIZE(rxe_err_status_flags));
 }
 
 static char *misc_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags, misc_err_status_flags,
-			ARRAY_SIZE(misc_err_status_flags));
+			   ARRAY_SIZE(misc_err_status_flags));
 }
 
 static char *pio_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-			pio_err_status_flags, ARRAY_SIZE(pio_err_status_flags));
+			   pio_err_status_flags,
+			   ARRAY_SIZE(pio_err_status_flags));
 }
 
 static char *sdma_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-			sdma_err_status_flags,
-			ARRAY_SIZE(sdma_err_status_flags));
+			   sdma_err_status_flags,
+			   ARRAY_SIZE(sdma_err_status_flags));
 }
 
 static char *egress_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-		egress_err_status_flags, ARRAY_SIZE(egress_err_status_flags));
+			   egress_err_status_flags,
+			   ARRAY_SIZE(egress_err_status_flags));
 }
 
 static char *egress_err_info_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-		egress_err_info_flags, ARRAY_SIZE(egress_err_info_flags));
+			   egress_err_info_flags,
+			   ARRAY_SIZE(egress_err_info_flags));
 }
 
 static char *send_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-			send_err_status_flags,
-			ARRAY_SIZE(send_err_status_flags));
+			   send_err_status_flags,
+			   ARRAY_SIZE(send_err_status_flags));
 }
 
 static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -5398,7 +5399,7 @@ static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	 * report or record it.
 	 */
 	dd_dev_info(dd, "CCE Error: %s\n",
-		cce_err_status_string(buf, sizeof(buf), reg));
+		    cce_err_status_string(buf, sizeof(buf), reg));
 
 	if ((reg & CCE_ERR_STATUS_CCE_CLI2_ASYNC_FIFO_PARITY_ERR_SMASK) &&
 	    is_ax(dd) && (dd->icode != ICODE_FUNCTIONAL_SIMULATOR)) {
@@ -5428,11 +5429,11 @@ static void update_rcverr_timer(unsigned long opaque)
 	u32 cur_ovfl_cnt = read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL);
 
 	if (dd->rcv_ovfl_cnt < cur_ovfl_cnt &&
-		ppd->port_error_action & OPA_PI_MASK_EX_BUFFER_OVERRUN) {
+	    ppd->port_error_action & OPA_PI_MASK_EX_BUFFER_OVERRUN) {
 		dd_dev_info(dd, "%s: PortErrorAction bounce\n", __func__);
-		set_link_down_reason(ppd,
-		  OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN, 0,
-			OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN);
+		set_link_down_reason(
+		ppd, OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN, 0,
+		OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN);
 		queue_work(ppd->hfi1_wq, &ppd->link_bounce_work);
 	}
 	dd->rcv_ovfl_cnt = (u32)cur_ovfl_cnt;
@@ -5461,7 +5462,7 @@ static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	int i = 0;
 
 	dd_dev_info(dd, "Receive Error: %s\n",
-		rxe_err_status_string(buf, sizeof(buf), reg));
+		    rxe_err_status_string(buf, sizeof(buf), reg));
 
 	if (reg & ALL_RXE_FREEZE_ERR) {
 		int flags = 0;
@@ -5488,7 +5489,7 @@ static void handle_misc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	int i = 0;
 
 	dd_dev_info(dd, "Misc Error: %s",
-		misc_err_status_string(buf, sizeof(buf), reg));
+		    misc_err_status_string(buf, sizeof(buf), reg));
 	for (i = 0; i < NUM_MISC_ERR_STATUS_COUNTERS; i++) {
 		if (reg & (1ull << i))
 			incr_cntr64(&dd->misc_err_status_cnt[i]);
@@ -5501,7 +5502,7 @@ static void handle_pio_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	int i = 0;
 
 	dd_dev_info(dd, "PIO Error: %s\n",
-		pio_err_status_string(buf, sizeof(buf), reg));
+		    pio_err_status_string(buf, sizeof(buf), reg));
 
 	if (reg & ALL_PIO_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
@@ -5518,7 +5519,7 @@ static void handle_sdma_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	int i = 0;
 
 	dd_dev_info(dd, "SDMA Error: %s\n",
-		sdma_err_status_string(buf, sizeof(buf), reg));
+		    sdma_err_status_string(buf, sizeof(buf), reg));
 
 	if (reg & ALL_SDMA_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
@@ -5560,8 +5561,8 @@ static void handle_send_egress_err_info(struct hfi1_devdata *dd,
 	write_csr(dd, SEND_EGRESS_ERR_INFO, info);
 
 	dd_dev_info(dd,
-		"Egress Error Info: 0x%llx, %s Egress Error Src 0x%llx\n",
-		info, egress_err_info_string(buf, sizeof(buf), info), src);
+		    "Egress Error Info: 0x%llx, %s Egress Error Src 0x%llx\n",
+		    info, egress_err_info_string(buf, sizeof(buf), info), src);
 
 	/* Eventually add other counters for each bit */
 	if (info & PORT_DISCARD_EGRESS_ERRS) {
@@ -5699,7 +5700,7 @@ static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 
 	if (reg)
 		dd_dev_info(dd, "Egress Error: %s\n",
-			egress_err_status_string(buf, sizeof(buf), reg));
+			    egress_err_status_string(buf, sizeof(buf), reg));
 
 	for (i = 0; i < NUM_SEND_EGRESS_ERR_STATUS_COUNTERS; i++) {
 		if (reg & (1ull << i))
@@ -5713,7 +5714,7 @@ static void handle_txe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	int i = 0;
 
 	dd_dev_info(dd, "Send Error: %s\n",
-		send_err_status_string(buf, sizeof(buf), reg));
+		    send_err_status_string(buf, sizeof(buf), reg));
 
 	for (i = 0; i < NUM_SEND_ERR_STATUS_COUNTERS; i++) {
 		if (reg & (1ull << i))
@@ -5759,7 +5760,7 @@ static void interrupt_clear_down(struct hfi1_devdata *dd,
 			u64 mask;
 
 			dd_dev_err(dd, "Repeating %s bits 0x%llx - masking\n",
-				eri->desc, reg);
+				   eri->desc, reg);
 			/*
 			 * Read-modify-write so any other masked bits
 			 * remain masked.
@@ -5783,14 +5784,15 @@ static void is_misc_err_int(struct hfi1_devdata *dd, unsigned int source)
 		interrupt_clear_down(dd, 0, eri);
 	} else {
 		dd_dev_err(dd, "Unexpected misc interrupt (%u) - reserved\n",
-			source);
+			   source);
 	}
 }
 
 static char *send_context_err_status_string(char *buf, int buf_len, u64 flags)
 {
 	return flag_string(buf, buf_len, flags,
-			sc_err_status_flags, ARRAY_SIZE(sc_err_status_flags));
+			   sc_err_status_flags,
+			   ARRAY_SIZE(sc_err_status_flags));
 }
 
 /*
@@ -5815,15 +5817,15 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 	sw_index = dd->hw_to_sw[hw_context];
 	if (sw_index >= dd->num_send_contexts) {
 		dd_dev_err(dd,
-			"out of range sw index %u for send context %u\n",
-			sw_index, hw_context);
+			   "out of range sw index %u for send context %u\n",
+			   sw_index, hw_context);
 		return;
 	}
 	sci = &dd->send_contexts[sw_index];
 	sc = sci->sc;
 	if (!sc) {
 		dd_dev_err(dd, "%s: context %u(%u): no sc?\n", __func__,
-			sw_index, hw_context);
+			   sw_index, hw_context);
 		return;
 	}
 
@@ -5833,7 +5835,8 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 	status = read_kctxt_csr(dd, hw_context, SEND_CTXT_ERR_STATUS);
 
 	dd_dev_info(dd, "Send Context %u(%u) Error: %s\n", sw_index, hw_context,
-		send_context_err_status_string(flags, sizeof(flags), status));
+		    send_context_err_status_string(flags, sizeof(flags),
+						   status));
 
 	if (status & SEND_CTXT_ERR_STATUS_PIO_DISALLOWED_PACKET_ERR_SMASK)
 		handle_send_egress_err_info(dd, sc_to_vl(dd, sw_index));
@@ -5918,8 +5921,8 @@ static void is_various_int(struct hfi1_devdata *dd, unsigned int source)
 		interrupt_clear_down(dd, 0, eri);
 	else
 		dd_dev_info(dd,
-			"%s: Unimplemented/reserved interrupt %d\n",
-			__func__, source);
+			    "%s: Unimplemented/reserved interrupt %d\n",
+			    __func__, source);
 }
 
 static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
@@ -5931,7 +5934,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 
 	if (reg & QSFP_HFI0_MODPRST_N) {
 		dd_dev_info(dd, "%s: ModPresent triggered QSFP interrupt\n",
-				__func__);
+			    __func__);
 
 		if (!qsfp_mod_present(ppd)) {
 			ppd->driver_link_ready = 0;
@@ -5949,7 +5952,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 			ppd->qsfp_info.reset_needed = 0;
 			ppd->qsfp_info.limiting_active = 0;
 			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
-						flags);
+					       flags);
 			/* Invert the ModPresent pin now to detect plug-in */
 			write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_INVERT :
 				  ASIC_QSFP1_INVERT, qsfp_int_mgmt);
@@ -5977,7 +5980,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 			ppd->qsfp_info.cache_valid = 0;
 			ppd->qsfp_info.cache_refresh_required = 1;
 			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
-						flags);
+					       flags);
 
 			/*
 			 * Stop inversion of ModPresent pin to detect
@@ -5994,7 +5997,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 
 	if (reg & QSFP_HFI0_INT_N) {
 		dd_dev_info(dd, "%s: IntN triggered QSFP interrupt\n",
-				__func__);
+			    __func__);
 		spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 		ppd->qsfp_info.check_interrupt_flags = 1;
 		spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
@@ -6010,11 +6013,11 @@ static int request_host_lcb_access(struct hfi1_devdata *dd)
 	int ret;
 
 	ret = do_8051_command(dd, HCMD_MISC,
-		(u64)HCMD_MISC_REQUEST_LCB_ACCESS << LOAD_DATA_FIELD_ID_SHIFT,
-		NULL);
+			      (u64)HCMD_MISC_REQUEST_LCB_ACCESS <<
+			      LOAD_DATA_FIELD_ID_SHIFT, NULL);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd, "%s: command failed with error %d\n",
-			__func__, ret);
+			   __func__, ret);
 	}
 	return ret == HCMD_SUCCESS ? 0 : -EBUSY;
 }
@@ -6024,11 +6027,11 @@ static int request_8051_lcb_access(struct hfi1_devdata *dd)
 	int ret;
 
 	ret = do_8051_command(dd, HCMD_MISC,
-		(u64)HCMD_MISC_GRANT_LCB_ACCESS << LOAD_DATA_FIELD_ID_SHIFT,
-		NULL);
+			      (u64)HCMD_MISC_GRANT_LCB_ACCESS <<
+			      LOAD_DATA_FIELD_ID_SHIFT, NULL);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd, "%s: command failed with error %d\n",
-			__func__, ret);
+			   __func__, ret);
 	}
 	return ret == HCMD_SUCCESS ? 0 : -EBUSY;
 }
@@ -6040,8 +6043,8 @@ static int request_8051_lcb_access(struct hfi1_devdata *dd)
 static inline void set_host_lcb_access(struct hfi1_devdata *dd)
 {
 	write_csr(dd, DC_DC8051_CFG_CSR_ACCESS_SEL,
-				DC_DC8051_CFG_CSR_ACCESS_SEL_DCC_SMASK
-				| DC_DC8051_CFG_CSR_ACCESS_SEL_LCB_SMASK);
+		  DC_DC8051_CFG_CSR_ACCESS_SEL_DCC_SMASK |
+		  DC_DC8051_CFG_CSR_ACCESS_SEL_LCB_SMASK);
 }
 
 /*
@@ -6051,7 +6054,7 @@ static inline void set_host_lcb_access(struct hfi1_devdata *dd)
 static inline void set_8051_lcb_access(struct hfi1_devdata *dd)
 {
 	write_csr(dd, DC_DC8051_CFG_CSR_ACCESS_SEL,
-				DC_DC8051_CFG_CSR_ACCESS_SEL_DCC_SMASK);
+		  DC_DC8051_CFG_CSR_ACCESS_SEL_DCC_SMASK);
 }
 
 /*
@@ -6085,7 +6088,7 @@ int acquire_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 	/* this access is valid only when the link is up */
 	if ((ppd->host_link_state & HLS_UP) == 0) {
 		dd_dev_info(dd, "%s: link state %s not up\n",
-			__func__, link_state_name(ppd->host_link_state));
+			    __func__, link_state_name(ppd->host_link_state));
 		ret = -EBUSY;
 		goto done;
 	}
@@ -6094,8 +6097,8 @@ int acquire_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 		ret = request_host_lcb_access(dd);
 		if (ret) {
 			dd_dev_err(dd,
-				"%s: unable to acquire LCB access, err %d\n",
-				__func__, ret);
+				   "%s: unable to acquire LCB access, err %d\n",
+				   __func__, ret);
 			goto done;
 		}
 		set_host_lcb_access(dd);
@@ -6132,7 +6135,7 @@ int release_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 
 	if (dd->lcb_access_count == 0) {
 		dd_dev_err(dd, "%s: LCB access count is zero.  Skipping.\n",
-			__func__);
+			   __func__);
 		goto done;
 	}
 
@@ -6141,8 +6144,8 @@ int release_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 		ret = request_8051_lcb_access(dd);
 		if (ret) {
 			dd_dev_err(dd,
-				"%s: unable to release LCB access, err %d\n",
-				__func__, ret);
+				   "%s: unable to release LCB access, err %d\n",
+				   __func__, ret);
 			/* restore host access if the grant didn't work */
 			set_host_lcb_access(dd);
 			goto done;
@@ -6174,9 +6177,10 @@ static void init_lcb_access(struct hfi1_devdata *dd)
 static void hreq_response(struct hfi1_devdata *dd, u8 return_code, u16 rsp_data)
 {
 	write_csr(dd, DC_DC8051_CFG_EXT_DEV_0,
-		DC_DC8051_CFG_EXT_DEV_0_COMPLETED_SMASK
-		| (u64)return_code << DC_DC8051_CFG_EXT_DEV_0_RETURN_CODE_SHIFT
-		| (u64)rsp_data << DC_DC8051_CFG_EXT_DEV_0_RSP_DATA_SHIFT);
+		  DC_DC8051_CFG_EXT_DEV_0_COMPLETED_SMASK |
+		  (u64)return_code <<
+		  DC_DC8051_CFG_EXT_DEV_0_RETURN_CODE_SHIFT |
+		  (u64)rsp_data << DC_DC8051_CFG_EXT_DEV_0_RSP_DATA_SHIFT);
 }
 
 /*
@@ -6214,7 +6218,7 @@ void handle_8051_request(struct work_struct *work)
 	case HREQ_SET_TX_EQ_ABS:
 	case HREQ_SET_TX_EQ_REL:
 		dd_dev_info(dd, "8051 request: request 0x%x not supported\n",
-			type);
+			    type);
 		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
 		break;
 
@@ -6272,11 +6276,11 @@ static void write_global_credit(struct hfi1_devdata *dd,
 				u8 vau, u16 total, u16 shared)
 {
 	write_csr(dd, SEND_CM_GLOBAL_CREDIT,
-		((u64)total
-			<< SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT)
-		| ((u64)shared
-			<< SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT)
-		| ((u64)vau << SEND_CM_GLOBAL_CREDIT_AU_SHIFT));
+		  ((u64)total <<
+		   SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT) |
+		  ((u64)shared <<
+		   SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT) |
+		  ((u64)vau << SEND_CM_GLOBAL_CREDIT_AU_SHIFT));
 }
 
 /*
@@ -6355,14 +6359,13 @@ static void lcb_shutdown(struct hfi1_devdata *dd, int abort)
 	write_csr(dd, DC_LCB_CFG_RUN, 0);
 	/* set tx fifo reset: LCB_CFG_TX_FIFOS_RESET.VAL = 1 */
 	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET,
-		1ull << DC_LCB_CFG_TX_FIFOS_RESET_VAL_SHIFT);
+		  1ull << DC_LCB_CFG_TX_FIFOS_RESET_VAL_SHIFT);
 	/* set dcc reset csr: DCC_CFG_RESET.{reset_lcb,reset_rx_fpe} = 1 */
 	dd->lcb_err_en = read_csr(dd, DC_LCB_ERR_EN);
 	reg = read_csr(dd, DCC_CFG_RESET);
-	write_csr(dd, DCC_CFG_RESET,
-		reg
-		| (1ull << DCC_CFG_RESET_RESET_LCB_SHIFT)
-		| (1ull << DCC_CFG_RESET_RESET_RX_FPE_SHIFT));
+	write_csr(dd, DCC_CFG_RESET, reg |
+		  (1ull << DCC_CFG_RESET_RESET_LCB_SHIFT) |
+		  (1ull << DCC_CFG_RESET_RESET_RX_FPE_SHIFT));
 	(void)read_csr(dd, DCC_CFG_RESET); /* make sure the write completed */
 	if (!abort) {
 		udelay(1);    /* must hold for the longer of 16cclks or 20ns */
@@ -6419,7 +6422,7 @@ static void dc_start(struct hfi1_devdata *dd)
 	ret = wait_fm_ready(dd, TIMEOUT_8051_START);
 	if (ret) {
 		dd_dev_err(dd, "%s: timeout starting 8051 firmware\n",
-			__func__);
+			   __func__);
 	}
 	/* Take away reset for LCB and RX FPE (set in lcb_shutdown). */
 	write_csr(dd, DCC_CFG_RESET, 0x10);
@@ -6512,7 +6515,7 @@ static void adjust_lcb_for_fpga_serdes(struct hfi1_devdata *dd)
 	write_csr(dd, DC_LCB_CFG_RX_FIFOS_RADR, rx_radr);
 	/* LCB_CFG_IGNORE_LOST_RCLK.EN = 1 */
 	write_csr(dd, DC_LCB_CFG_IGNORE_LOST_RCLK,
-		DC_LCB_CFG_IGNORE_LOST_RCLK_EN_SMASK);
+		  DC_LCB_CFG_IGNORE_LOST_RCLK_EN_SMASK);
 	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RADR, tx_radr);
 }
 
@@ -6571,8 +6574,8 @@ void handle_sma_message(struct work_struct *work)
 		break;
 	default:
 		dd_dev_err(dd,
-			"%s: received unexpected SMA idle message 0x%llx\n",
-			__func__, msg);
+			   "%s: received unexpected SMA idle message 0x%llx\n",
+			   __func__, msg);
 		break;
 	}
 }
@@ -6664,10 +6667,9 @@ static void wait_for_freeze_status(struct hfi1_devdata *dd, int freeze)
 
 		if (time_after(jiffies, timeout)) {
 			dd_dev_err(dd,
-				"Time out waiting for SPC %sfreeze, bits 0x%llx, expecting 0x%llx, continuing",
-				freeze ? "" : "un",
-				reg & ALL_FROZE,
-				freeze ? ALL_FROZE : 0ull);
+				   "Time out waiting for SPC %sfreeze, bits 0x%llx, expecting 0x%llx, continuing",
+				   freeze ? "" : "un", reg & ALL_FROZE,
+				   freeze ? ALL_FROZE : 0ull);
 			return;
 		}
 		usleep_range(80, 120);
@@ -6792,7 +6794,7 @@ void handle_freeze(struct work_struct *work)
 void handle_link_up(struct work_struct *work)
 {
 	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
-								link_up_work);
+						  link_up_work);
 	set_link_state(ppd, HLS_UP_INIT);
 
 	/* cache the read of DC_LCB_STS_ROUND_TRIP_LTP_CNT */
@@ -6811,10 +6813,10 @@ void handle_link_up(struct work_struct *work)
 	if ((ppd->link_speed_active & ppd->link_speed_enabled) == 0) {
 		/* oops - current speed is not enabled, bounce */
 		dd_dev_err(ppd->dd,
-			"Link speed active 0x%x is outside enabled 0x%x, downing link\n",
-			ppd->link_speed_active, ppd->link_speed_enabled);
+			   "Link speed active 0x%x is outside enabled 0x%x, downing link\n",
+			   ppd->link_speed_active, ppd->link_speed_enabled);
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SPEED_POLICY, 0,
-			OPA_LINKDOWN_REASON_SPEED_POLICY);
+				     OPA_LINKDOWN_REASON_SPEED_POLICY);
 		set_link_state(ppd, HLS_DN_OFFLINE);
 		tune_serdes(ppd);
 		start_link(ppd);
@@ -6896,7 +6898,7 @@ void handle_link_bounce(struct work_struct *work)
 		start_link(ppd);
 	} else {
 		dd_dev_info(ppd->dd, "%s: link not up (%s), nothing to do\n",
-			__func__, link_state_name(ppd->host_link_state));
+			    __func__, link_state_name(ppd->host_link_state));
 	}
 }
 
@@ -6993,7 +6995,7 @@ static u16 link_width_to_bits(struct hfi1_devdata *dd, u16 width)
 	case 3: return OPA_LINK_WIDTH_3X;
 	default:
 		dd_dev_info(dd, "%s: invalid width %d, using 4\n",
-			__func__, width);
+			    __func__, width);
 		/* fall through */
 	case 4: return OPA_LINK_WIDTH_4X;
 	}
@@ -7031,7 +7033,7 @@ static void get_link_widths(struct hfi1_devdata *dd, u16 *tx_width,
 
 	/* read the active lanes */
 	read_tx_settings(dd, &enable_lane_tx, &tx_polarity_inversion,
-				&rx_polarity_inversion, &max_rate);
+			 &rx_polarity_inversion, &max_rate);
 	read_local_lni(dd, &enable_lane_rx);
 
 	/* convert to counts */
@@ -7052,8 +7054,8 @@ static void get_link_widths(struct hfi1_devdata *dd, u16 *tx_width,
 			break;
 		default:
 			dd_dev_err(dd,
-				"%s: unexpected max rate %d, using 25Gb\n",
-				__func__, (int)max_rate);
+				   "%s: unexpected max rate %d, using 25Gb\n",
+				   __func__, (int)max_rate);
 			/* fall through */
 		case 1:
 			dd->pport[0].link_speed_active = OPA_LINK_SPEED_25G;
@@ -7062,8 +7064,8 @@ static void get_link_widths(struct hfi1_devdata *dd, u16 *tx_width,
 	}
 
 	dd_dev_info(dd,
-		"Fabric active lanes (width): tx 0x%x (%d), rx 0x%x (%d)\n",
-		enable_lane_tx, tx, enable_lane_rx, rx);
+		    "Fabric active lanes (width): tx 0x%x (%d), rx 0x%x (%d)\n",
+		    enable_lane_tx, tx, enable_lane_rx, rx);
 	*tx_width = link_width_to_bits(dd, tx);
 	*rx_width = link_width_to_bits(dd, rx);
 }
@@ -7166,13 +7168,8 @@ void handle_verify_cap(struct work_struct *work)
 	 */
 
 	read_vc_remote_phy(dd, &power_management, &continious);
-	read_vc_remote_fabric(
-		dd,
-		&vau,
-		&z,
-		&vcu,
-		&vl15buf,
-		&partner_supported_crc);
+	read_vc_remote_fabric(dd, &vau, &z, &vcu, &vl15buf,
+			      &partner_supported_crc);
 	read_vc_remote_link_width(dd, &remote_tx_rate, &link_widths);
 	read_remote_device_id(dd, &device_id, &device_rev);
 	/*
@@ -7183,19 +7180,16 @@ void handle_verify_cap(struct work_struct *work)
 	/* print the active widths */
 	get_link_widths(dd, &active_tx, &active_rx);
 	dd_dev_info(dd,
-		"Peer PHY: power management 0x%x, continuous updates 0x%x\n",
-		(int)power_management, (int)continious);
+		    "Peer PHY: power management 0x%x, continuous updates 0x%x\n",
+		    (int)power_management, (int)continious);
 	dd_dev_info(dd,
-		"Peer Fabric: vAU %d, Z %d, vCU %d, vl15 credits 0x%x, CRC sizes 0x%x\n",
-		(int)vau,
-		(int)z,
-		(int)vcu,
-		(int)vl15buf,
-		(int)partner_supported_crc);
+		    "Peer Fabric: vAU %d, Z %d, vCU %d, vl15 credits 0x%x, CRC sizes 0x%x\n",
+		    (int)vau, (int)z, (int)vcu, (int)vl15buf,
+		    (int)partner_supported_crc);
 	dd_dev_info(dd, "Peer Link Width: tx rate 0x%x, widths 0x%x\n",
-		(u32)remote_tx_rate, (u32)link_widths);
+		    (u32)remote_tx_rate, (u32)link_widths);
 	dd_dev_info(dd, "Peer Device ID: 0x%04x, Revision 0x%02x\n",
-		(u32)device_id, (u32)device_rev);
+		    (u32)device_id, (u32)device_rev);
 	/*
 	 * The peer vAU value just read is the peer receiver value.  HFI does
 	 * not support a transmit vAU of 0 (AU == 8).  We advertised that
@@ -7230,10 +7224,10 @@ void handle_verify_cap(struct work_struct *work)
 	reg = read_csr(dd, SEND_CM_CTRL);
 	if (crc_val == LCB_CRC_14B && crc_14b_sideband) {
 		write_csr(dd, SEND_CM_CTRL,
-			reg | SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK);
+			  reg | SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK);
 	} else {
 		write_csr(dd, SEND_CM_CTRL,
-			reg & ~SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK);
+			  reg & ~SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK);
 	}
 
 	ppd->link_speed_active = 0;	/* invalid value */
@@ -7258,7 +7252,7 @@ void handle_verify_cap(struct work_struct *work)
 	}
 	if (ppd->link_speed_active == 0) {
 		dd_dev_err(dd, "%s: unexpected remote tx rate %d, using 25Gb\n",
-			__func__, (int)remote_tx_rate);
+			   __func__, (int)remote_tx_rate);
 		ppd->link_speed_active = OPA_LINK_SPEED_25G;
 	}
 
@@ -7314,9 +7308,9 @@ void handle_verify_cap(struct work_struct *work)
 		read_csr(dd, DC_DC8051_STS_REMOTE_FM_SECURITY) &
 		DC_DC8051_STS_LOCAL_FM_SECURITY_DISABLED_MASK;
 	dd_dev_info(dd,
-		"Neighbor Guid: %llx Neighbor type %d MgmtAllowed %d FM security bypass %d\n",
-		ppd->neighbor_guid, ppd->neighbor_type,
-		ppd->mgmt_allowed, ppd->neighbor_fm_security);
+		    "Neighbor Guid: %llx Neighbor type %d MgmtAllowed %d FM security bypass %d\n",
+		    ppd->neighbor_guid, ppd->neighbor_type,
+		    ppd->mgmt_allowed, ppd->neighbor_fm_security);
 	if (ppd->mgmt_allowed)
 		add_full_mgmt_pkey(ppd);
 
@@ -7369,27 +7363,28 @@ retry:
 		/* downgrade is disabled */
 
 		/* bounce if not at starting active width */
-		if ((ppd->link_width_active != ppd->link_width_downgrade_tx_active) ||
-		    (ppd->link_width_active != ppd->link_width_downgrade_rx_active)) {
+		if ((ppd->link_width_active !=
+		     ppd->link_width_downgrade_tx_active) ||
+		    (ppd->link_width_active !=
+		     ppd->link_width_downgrade_rx_active)) {
 			dd_dev_err(ppd->dd,
-				"Link downgrade is disabled and link has downgraded, downing link\n");
+				   "Link downgrade is disabled and link has downgraded, downing link\n");
 			dd_dev_err(ppd->dd,
-				"  original 0x%x, tx active 0x%x, rx active 0x%x\n",
-				ppd->link_width_active,
-				ppd->link_width_downgrade_tx_active,
-				ppd->link_width_downgrade_rx_active);
+				   "  original 0x%x, tx active 0x%x, rx active 0x%x\n",
+				   ppd->link_width_active,
+				   ppd->link_width_downgrade_tx_active,
+				   ppd->link_width_downgrade_rx_active);
 			do_bounce = 1;
 		}
 	} else if ((lwde & ppd->link_width_downgrade_tx_active) == 0 ||
 		   (lwde & ppd->link_width_downgrade_rx_active) == 0) {
 		/* Tx or Rx is outside the enabled policy */
 		dd_dev_err(ppd->dd,
-			"Link is outside of downgrade allowed, downing link\n");
+			   "Link is outside of downgrade allowed, downing link\n");
 		dd_dev_err(ppd->dd,
-			"  enabled 0x%x, tx active 0x%x, rx active 0x%x\n",
-			lwde,
-			ppd->link_width_downgrade_tx_active,
-			ppd->link_width_downgrade_rx_active);
+			   "  enabled 0x%x, tx active 0x%x, rx active 0x%x\n",
+			   lwde, ppd->link_width_downgrade_tx_active,
+			   ppd->link_width_downgrade_rx_active);
 		do_bounce = 1;
 	}
 
@@ -7398,7 +7393,7 @@ done:
 
 	if (do_bounce) {
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_WIDTH_POLICY, 0,
-		  OPA_LINKDOWN_REASON_WIDTH_POLICY);
+				     OPA_LINKDOWN_REASON_WIDTH_POLICY);
 		set_link_state(ppd, HLS_DN_OFFLINE);
 		tune_serdes(ppd);
 		start_link(ppd);
@@ -7481,9 +7476,10 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			    & (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) {
 				queue_link_down = 1;
 				dd_dev_info(dd, "Link error: %s\n",
-					dc8051_info_err_string(buf,
-						sizeof(buf),
-						err & FAILED_LNI));
+					    dc8051_info_err_string(buf,
+								   sizeof(buf),
+								   err &
+								   FAILED_LNI));
 			}
 			err &= ~(u64)FAILED_LNI;
 		}
@@ -7495,7 +7491,8 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		if (err) {
 			/* report remaining errors, but do not do anything */
 			dd_dev_err(dd, "8051 info error: %s\n",
-				dc8051_info_err_string(buf, sizeof(buf), err));
+				   dc8051_info_err_string(buf, sizeof(buf),
+							  err));
 		}
 
 		/*
@@ -7548,8 +7545,9 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		if (host_msg) {
 			/* report remaining messages, but do not do anything */
 			dd_dev_info(dd, "8051 info host message: %s\n",
-				dc8051_info_host_msg_string(buf, sizeof(buf),
-					host_msg));
+				    dc8051_info_host_msg_string(buf,
+								sizeof(buf),
+								host_msg));
 		}
 
 		reg &= ~DC_DC8051_ERR_FLG_SET_BY_8051_SMASK;
@@ -7562,15 +7560,15 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		 */
 		dd_dev_err(dd, "Lost 8051 heartbeat\n");
 		write_csr(dd, DC_DC8051_ERR_EN,
-			read_csr(dd, DC_DC8051_ERR_EN)
-			  & ~DC_DC8051_ERR_EN_LOST_8051_HEART_BEAT_SMASK);
+			  read_csr(dd, DC_DC8051_ERR_EN) &
+			  ~DC_DC8051_ERR_EN_LOST_8051_HEART_BEAT_SMASK);
 
 		reg &= ~DC_DC8051_ERR_FLG_LOST_8051_HEART_BEAT_SMASK;
 	}
 	if (reg) {
 		/* report the error, but do not do anything */
 		dd_dev_err(dd, "8051 error: %s\n",
-			dc8051_err_string(buf, sizeof(buf), reg));
+			   dc8051_err_string(buf, sizeof(buf), reg));
 	}
 
 	if (queue_link_down) {
@@ -7582,7 +7580,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		    (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN)) ||
 		    ppd->link_enabled == 0) {
 			dd_dev_info(dd, "%s: not queuing link down\n",
-				__func__);
+				    __func__);
 		} else {
 			queue_work(ppd->hfi1_wq, &ppd->link_down_work);
 		}
@@ -7760,7 +7758,7 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		/* just report this */
 		dd_dev_info(dd, "DCC Error: PortRcv error: %s\n", extra);
 		dd_dev_info(dd, "           hdr0 0x%llx, hdr1 0x%llx\n",
-			hdr0, hdr1);
+			    hdr0, hdr1);
 
 		reg &= ~DCC_ERR_FLG_RCVPORT_ERR_SMASK;
 	}
@@ -7779,7 +7777,7 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	/* report any remaining errors */
 	if (reg)
 		dd_dev_info(dd, "DCC Error: %s\n",
-			dcc_err_string(buf, sizeof(buf), reg));
+			    dcc_err_string(buf, sizeof(buf), reg));
 
 	if (lcl_reason == 0)
 		lcl_reason = OPA_LINKDOWN_REASON_UNKNOWN;
@@ -7796,7 +7794,7 @@ static void handle_lcb_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	char buf[96];
 
 	dd_dev_info(dd, "LCB Error: %s\n",
-		lcb_err_string(buf, sizeof(buf), reg));
+		    lcb_err_string(buf, sizeof(buf), reg));
 }
 
 /*
@@ -7886,7 +7884,7 @@ static void is_rcv_avail_int(struct hfi1_devdata *dd, unsigned int source)
 		err_detail = "out of range";
 	}
 	dd_dev_err(dd, "unexpected %s receive available context interrupt %u\n",
-		err_detail, source);
+		   err_detail, source);
 }
 
 /*
@@ -7912,7 +7910,7 @@ static void is_rcv_urgent_int(struct hfi1_devdata *dd, unsigned int source)
 		err_detail = "out of range";
 	}
 	dd_dev_err(dd, "unexpected %s receive urgent context interrupt %u\n",
-		err_detail, source);
+		   err_detail, source);
 }
 
 /*
@@ -7923,7 +7921,7 @@ static void is_reserved_int(struct hfi1_devdata *dd, unsigned int source)
 	char name[64];
 
 	dd_dev_err(dd, "unexpected %s interrupt\n",
-				is_reserved_name(name, sizeof(name), source));
+		   is_reserved_name(name, sizeof(name), source));
 }
 
 static const struct is_table is_table[] = {
@@ -8001,7 +7999,7 @@ static irqreturn_t general_interrupt(int irq, void *data)
 
 	/* phase 2: call the appropriate handler */
 	for_each_set_bit(bit, (unsigned long *)&regs[0],
-						CCE_NUM_INT_CSRS * 64) {
+			 CCE_NUM_INT_CSRS * 64) {
 		is_interrupt(dd, bit);
 	}
 
@@ -8024,19 +8022,19 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
 
 	/* This read_csr is really bad in the hot path */
 	status = read_csr(dd,
-			CCE_INT_STATUS + (8 * (IS_SDMA_START / 64)))
-			& sde->imask;
+			  CCE_INT_STATUS + (8 * (IS_SDMA_START / 64)))
+			  & sde->imask;
 	if (likely(status)) {
 		/* clear the interrupt(s) */
 		write_csr(dd,
-			CCE_INT_CLEAR + (8 * (IS_SDMA_START / 64)),
-			status);
+			  CCE_INT_CLEAR + (8 * (IS_SDMA_START / 64)),
+			  status);
 
 		/* handle the interrupt(s) */
 		sdma_engine_interrupt(sde, status);
 	} else
 		dd_dev_err(dd, "SDMA engine %u interrupt, but no status bits set\n",
-			sde->this_idx);
+			   sde->this_idx);
 
 	return IRQ_HANDLED;
 }
@@ -8436,8 +8434,8 @@ int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
 	ret = do_8051_command(dd, HCMD_LOAD_CONFIG_DATA, data, NULL);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd,
-			"load 8051 config: field id %d, lane %d, err %d\n",
-			(int)field_id, (int)lane_id, ret);
+			   "load 8051 config: field id %d, lane %d, err %d\n",
+			   (int)field_id, (int)lane_id, ret);
 	}
 	return ret;
 }
@@ -8474,7 +8472,7 @@ int read_8051_config(struct hfi1_devdata *dd, u8 field_id, u8 lane_id,
 	} else {
 		*result = 0;
 		dd_dev_err(dd, "%s: direct read failed, lane %d, field %d!\n",
-			__func__, lane_id, field_id);
+			   __func__, lane_id, field_id);
 	}
 
 	return ret;
@@ -8511,7 +8509,7 @@ static void read_vc_local_link_width(struct hfi1_devdata *dd, u8 *misc_bits,
 	u32 frame;
 
 	read_8051_config(dd, VERIFY_CAP_LOCAL_LINK_WIDTH, GENERAL_CONFIG,
-				&frame);
+			 &frame);
 	*misc_bits = (frame >> MISC_CONFIG_BITS_SHIFT) & MISC_CONFIG_BITS_MASK;
 	*flag_bits = (frame >> LOCAL_FLAG_BITS_SHIFT) & LOCAL_FLAG_BITS_MASK;
 	*link_widths = (frame >> LINK_WIDTH_SHIFT) & LINK_WIDTH_MASK;
@@ -8593,7 +8591,7 @@ static void read_vc_remote_link_width(struct hfi1_devdata *dd,
 	u32 frame;
 
 	read_8051_config(dd, VERIFY_CAP_REMOTE_LINK_WIDTH, GENERAL_CONFIG,
-				&frame);
+			 &frame);
 	*remote_tx_rate = (frame >> REMOTE_TX_RATE_SHIFT)
 				& REMOTE_TX_RATE_MASK;
 	*link_widths = (frame >> LINK_WIDTH_SHIFT) & LINK_WIDTH_MASK;
@@ -8633,7 +8631,7 @@ void hfi1_read_link_quality(struct hfi1_devdata *dd, u8 *link_quality)
 	*link_quality = 0;
 	if (dd->pport->host_link_state & HLS_UP) {
 		ret = read_8051_config(dd, LINK_QUALITY_INFO, GENERAL_CONFIG,
-					&frame);
+				       &frame);
 		if (ret == 0)
 			*link_quality = (frame >> LINK_QUALITY_SHIFT)
 						& LINK_QUALITY_MASK;
@@ -8693,10 +8691,9 @@ static void check_fabric_firmware_versions(struct hfi1_devdata *dd)
 	for (lane = 0; lane < 4; lane++) {
 		ret = read_8051_config(dd, SPICO_FW_VERSION, lane, &frame);
 		if (ret) {
-			dd_dev_err(
-				dd,
-				"Unable to read lane %d firmware details\n",
-				lane);
+			dd_dev_err(dd,
+				   "Unable to read lane %d firmware details\n",
+				   lane);
 			continue;
 		}
 		version = (frame >> SPICO_ROM_VERSION_SHIFT)
@@ -8704,8 +8701,8 @@ static void check_fabric_firmware_versions(struct hfi1_devdata *dd)
 		prod_id = (frame >> SPICO_ROM_PROD_ID_SHIFT)
 					& SPICO_ROM_PROD_ID_MASK;
 		dd_dev_info(dd,
-			"Lane %d firmware: version 0x%04x, prod_id 0x%04x\n",
-			lane, version, prod_id);
+			    "Lane %d firmware: version 0x%04x, prod_id 0x%04x\n",
+			    lane, version, prod_id);
 	}
 }
 
@@ -8718,11 +8715,10 @@ static int read_idle_message(struct hfi1_devdata *dd, u64 type, u64 *data_out)
 {
 	int ret;
 
-	ret = do_8051_command(dd, HCMD_READ_LCB_IDLE_MSG,
-		type, data_out);
+	ret = do_8051_command(dd, HCMD_READ_LCB_IDLE_MSG, type, data_out);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd, "read idle message: type %d, err %d\n",
-			(u32)type, ret);
+			   (u32)type, ret);
 		return -EINVAL;
 	}
 	dd_dev_info(dd, "%s: read idle message 0x%llx\n", __func__, *data_out);
@@ -8739,8 +8735,8 @@ static int read_idle_message(struct hfi1_devdata *dd, u64 type, u64 *data_out)
  */
 static int read_idle_sma(struct hfi1_devdata *dd, u64 *data)
 {
-	return read_idle_message(dd,
-			(u64)IDLE_SMA << IDLE_MSG_TYPE_SHIFT, data);
+	return read_idle_message(dd, (u64)IDLE_SMA << IDLE_MSG_TYPE_SHIFT,
+				 data);
 }
 
 /*
@@ -8756,7 +8752,7 @@ static int send_idle_message(struct hfi1_devdata *dd, u64 data)
 	ret = do_8051_command(dd, HCMD_SEND_LCB_IDLE_MSG, data, NULL);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd, "send idle message: data 0x%llx, err %d\n",
-			data, ret);
+			   data, ret);
 		return -EINVAL;
 	}
 	return 0;
@@ -8771,8 +8767,8 @@ int send_idle_sma(struct hfi1_devdata *dd, u64 message)
 {
 	u64 data;
 
-	data = ((message & IDLE_PAYLOAD_MASK) << IDLE_PAYLOAD_SHIFT)
-		| ((u64)IDLE_SMA << IDLE_MSG_TYPE_SHIFT);
+	data = ((message & IDLE_PAYLOAD_MASK) << IDLE_PAYLOAD_SHIFT) |
+		((u64)IDLE_SMA << IDLE_MSG_TYPE_SHIFT);
 	return send_idle_message(dd, data);
 }
 
@@ -8794,7 +8790,7 @@ static int do_quick_linkup(struct hfi1_devdata *dd)
 		/* LCB_CFG_LOOPBACK.VAL = 2 */
 		/* LCB_CFG_LANE_WIDTH.VAL = 0 */
 		write_csr(dd, DC_LCB_CFG_LOOPBACK,
-			IB_PACKET_TYPE << DC_LCB_CFG_LOOPBACK_VAL_SHIFT);
+			  IB_PACKET_TYPE << DC_LCB_CFG_LOOPBACK_VAL_SHIFT);
 		write_csr(dd, DC_LCB_CFG_LANE_WIDTH, 0);
 	}
 
@@ -8806,25 +8802,24 @@ static int do_quick_linkup(struct hfi1_devdata *dd)
 	if (loopback && dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
 		/* LCB_CFG_RUN.EN = 1 */
 		write_csr(dd, DC_LCB_CFG_RUN,
-			1ull << DC_LCB_CFG_RUN_EN_SHIFT);
+			  1ull << DC_LCB_CFG_RUN_EN_SHIFT);
 
 		/* watch LCB_STS_LINK_TRANSFER_ACTIVE */
 		timeout = jiffies + msecs_to_jiffies(10);
 		while (1) {
-			reg = read_csr(dd,
-				DC_LCB_STS_LINK_TRANSFER_ACTIVE);
+			reg = read_csr(dd, DC_LCB_STS_LINK_TRANSFER_ACTIVE);
 			if (reg)
 				break;
 			if (time_after(jiffies, timeout)) {
 				dd_dev_err(dd,
-					"timeout waiting for LINK_TRANSFER_ACTIVE\n");
+					   "timeout waiting for LINK_TRANSFER_ACTIVE\n");
 				return -ETIMEDOUT;
 			}
 			udelay(2);
 		}
 
 		write_csr(dd, DC_LCB_CFG_ALLOW_LINK_UP,
-			1ull << DC_LCB_CFG_ALLOW_LINK_UP_VAL_SHIFT);
+			  1ull << DC_LCB_CFG_ALLOW_LINK_UP_VAL_SHIFT);
 	}
 
 	if (!loopback) {
@@ -8836,10 +8831,9 @@ static int do_quick_linkup(struct hfi1_devdata *dd)
 		 * done with LCB set up before resuming.
 		 */
 		dd_dev_err(dd,
-			"Pausing for peer to be finished with LCB set up\n");
+			   "Pausing for peer to be finished with LCB set up\n");
 		msleep(5000);
-		dd_dev_err(dd,
-			"Continuing with quick linkup\n");
+		dd_dev_err(dd, "Continuing with quick linkup\n");
 	}
 
 	write_csr(dd, DC_LCB_ERR_EN, 0); /* mask LCB errors */
@@ -8853,8 +8847,8 @@ static int do_quick_linkup(struct hfi1_devdata *dd)
 	ret = set_physical_link_state(dd, PLS_QUICK_LINKUP);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd,
-			"%s: set physical link state to quick LinkUp failed with return %d\n",
-			__func__, ret);
+			   "%s: set physical link state to quick LinkUp failed with return %d\n",
+			   __func__, ret);
 
 		set_host_lcb_access(dd);
 		write_csr(dd, DC_LCB_ERR_EN, ~0ull); /* watch LCB errors */
@@ -8879,8 +8873,8 @@ static int set_serdes_loopback_mode(struct hfi1_devdata *dd)
 	if (ret == HCMD_SUCCESS)
 		return 0;
 	dd_dev_err(dd,
-		"Set physical link state to SerDes Loopback failed with return %d\n",
-		ret);
+		   "Set physical link state to SerDes Loopback failed with return %d\n",
+		   ret);
 	if (ret >= 0)
 		ret = -EINVAL;
 	return ret;
@@ -8895,7 +8889,7 @@ static int init_loopback(struct hfi1_devdata *dd)
 
 	/* all loopbacks should disable self GUID check */
 	write_csr(dd, DC_DC8051_CFG_MODE,
-		(read_csr(dd, DC_DC8051_CFG_MODE) | DISABLE_SELF_GUID_CHECK));
+		  (read_csr(dd, DC_DC8051_CFG_MODE) | DISABLE_SELF_GUID_CHECK));
 
 	/*
 	 * The simulator has only one loopback option - LCB.  Switch
@@ -8926,7 +8920,7 @@ static int init_loopback(struct hfi1_devdata *dd)
 		/* not supported in emulation due to emulation RTL changes */
 		if (dd->icode == ICODE_FPGA_EMULATION) {
 			dd_dev_err(dd,
-				"LCB loopback not supported in emulation\n");
+				   "LCB loopback not supported in emulation\n");
 			return -EINVAL;
 		}
 		return 0;
@@ -8982,7 +8976,7 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 
 	/* set the local tx rate - need to read-modify-write */
 	ret = read_tx_settings(dd, &enable_lane_tx, &tx_polarity_inversion,
-		&rx_polarity_inversion, &ppd->local_tx_rate);
+			       &rx_polarity_inversion, &ppd->local_tx_rate);
 	if (ret)
 		goto set_local_link_attributes_fail;
 
@@ -9003,15 +8997,16 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 
 	enable_lane_tx = 0xF; /* enable all four lanes */
 	ret = write_tx_settings(dd, enable_lane_tx, tx_polarity_inversion,
-		     rx_polarity_inversion, ppd->local_tx_rate);
+				rx_polarity_inversion, ppd->local_tx_rate);
 	if (ret != HCMD_SUCCESS)
 		goto set_local_link_attributes_fail;
 
 	/*
 	 * DC supports continuous updates.
 	 */
-	ret = write_vc_local_phy(dd, 0 /* no power management */,
-				     1 /* continuous updates */);
+	ret = write_vc_local_phy(dd,
+				 0 /* no power management */,
+				 1 /* continuous updates */);
 	if (ret != HCMD_SUCCESS)
 		goto set_local_link_attributes_fail;
 
@@ -9022,7 +9017,8 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 		goto set_local_link_attributes_fail;
 
 	ret = write_vc_local_link_width(dd, 0, 0,
-		     opa_to_vc_link_widths(ppd->link_width_enabled));
+					opa_to_vc_link_widths(
+						ppd->link_width_enabled));
 	if (ret != HCMD_SUCCESS)
 		goto set_local_link_attributes_fail;
 
@@ -9033,8 +9029,8 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 
 set_local_link_attributes_fail:
 	dd_dev_err(dd,
-		"Failed to set local link attributes, return 0x%x\n",
-		ret);
+		   "Failed to set local link attributes, return 0x%x\n",
+		   ret);
 	return ret;
 }
 
@@ -9047,25 +9043,25 @@ int start_link(struct hfi1_pportdata *ppd)
 {
 	if (!ppd->link_enabled) {
 		dd_dev_info(ppd->dd,
-			"%s: stopping link start because link is disabled\n",
-			__func__);
+			    "%s: stopping link start because link is disabled\n",
+			    __func__);
 		return 0;
 	}
 	if (!ppd->driver_link_ready) {
 		dd_dev_info(ppd->dd,
-			"%s: stopping link start because driver is not ready\n",
-			__func__);
+			    "%s: stopping link start because driver is not ready\n",
+			    __func__);
 		return 0;
 	}
 
 	if (qsfp_mod_present(ppd) || loopback == LOOPBACK_SERDES ||
-			loopback == LOOPBACK_LCB ||
-			ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
+	    loopback == LOOPBACK_LCB ||
+	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
 		return set_link_state(ppd, HLS_DN_POLL);
 
 	dd_dev_info(ppd->dd,
-		"%s: stopping link start because no cable is present\n",
-		__func__);
+		    "%s: stopping link start because no cable is present\n",
+		    __func__);
 	return -EAGAIN;
 }
 
@@ -9121,20 +9117,19 @@ void reset_qsfp(struct hfi1_pportdata *ppd)
 	mask = (u64)QSFP_HFI0_RESET_N;
 	qsfp_mask = read_csr(dd, dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE);
 	qsfp_mask |= mask;
-	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE, qsfp_mask);
+	write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE, qsfp_mask);
 
-	qsfp_mask = read_csr(dd, dd->hfi1_id ?
-				ASIC_QSFP2_OUT : ASIC_QSFP1_OUT);
+	qsfp_mask = read_csr(dd,
+			     dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT);
 	qsfp_mask &= ~mask;
 	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT, qsfp_mask);
+		  dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT, qsfp_mask);
 
 	udelay(10);
 
 	qsfp_mask |= mask;
 	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT, qsfp_mask);
+		  dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT, qsfp_mask);
 
 	wait_for_qsfp_init(ppd);
 
@@ -9151,102 +9146,86 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 	struct hfi1_devdata *dd = ppd->dd;
 
 	if ((qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_ALARM) ||
-		(qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_WARNING))
-		dd_dev_info(dd,
-			"%s: QSFP cable on fire\n",
-			__func__);
+	    (qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_WARNING))
+		dd_dev_info(dd, "%s: QSFP cable on fire\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[0] & QSFP_LOW_TEMP_ALARM) ||
-		(qsfp_interrupt_status[0] & QSFP_LOW_TEMP_WARNING))
-		dd_dev_info(dd,
-			"%s: QSFP cable temperature too low\n",
-			__func__);
+	    (qsfp_interrupt_status[0] & QSFP_LOW_TEMP_WARNING))
+		dd_dev_info(dd, "%s: QSFP cable temperature too low\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[1] & QSFP_HIGH_VCC_ALARM) ||
-		(qsfp_interrupt_status[1] & QSFP_HIGH_VCC_WARNING))
-		dd_dev_info(dd,
-			"%s: QSFP supply voltage too high\n",
-			__func__);
+	    (qsfp_interrupt_status[1] & QSFP_HIGH_VCC_WARNING))
+		dd_dev_info(dd, "%s: QSFP supply voltage too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[1] & QSFP_LOW_VCC_ALARM) ||
-		(qsfp_interrupt_status[1] & QSFP_LOW_VCC_WARNING))
-		dd_dev_info(dd,
-			"%s: QSFP supply voltage too low\n",
-			__func__);
+	    (qsfp_interrupt_status[1] & QSFP_LOW_VCC_WARNING))
+		dd_dev_info(dd, "%s: QSFP supply voltage too low\n",
+			    __func__);
 
 	/* Byte 2 is vendor specific */
 
 	if ((qsfp_interrupt_status[3] & QSFP_HIGH_POWER_ALARM) ||
-		(qsfp_interrupt_status[3] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable RX channel 1/2 power too high\n",
-			__func__);
+	    (qsfp_interrupt_status[3] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable RX channel 1/2 power too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[3] & QSFP_LOW_POWER_ALARM) ||
-		(qsfp_interrupt_status[3] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable RX channel 1/2 power too low\n",
-			__func__);
+	    (qsfp_interrupt_status[3] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable RX channel 1/2 power too low\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[4] & QSFP_HIGH_POWER_ALARM) ||
-		(qsfp_interrupt_status[4] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable RX channel 3/4 power too high\n",
-			__func__);
+	    (qsfp_interrupt_status[4] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable RX channel 3/4 power too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[4] & QSFP_LOW_POWER_ALARM) ||
-		(qsfp_interrupt_status[4] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable RX channel 3/4 power too low\n",
-			__func__);
+	    (qsfp_interrupt_status[4] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable RX channel 3/4 power too low\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_ALARM) ||
-		(qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 1/2 bias too high\n",
-			__func__);
+	    (qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 1/2 bias too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[5] & QSFP_LOW_BIAS_ALARM) ||
-		(qsfp_interrupt_status[5] & QSFP_LOW_BIAS_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 1/2 bias too low\n",
-			__func__);
+	    (qsfp_interrupt_status[5] & QSFP_LOW_BIAS_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 1/2 bias too low\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_ALARM) ||
-		(qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 3/4 bias too high\n",
-			__func__);
+	    (qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 3/4 bias too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[6] & QSFP_LOW_BIAS_ALARM) ||
-		(qsfp_interrupt_status[6] & QSFP_LOW_BIAS_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 3/4 bias too low\n",
-			__func__);
+	    (qsfp_interrupt_status[6] & QSFP_LOW_BIAS_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 3/4 bias too low\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[7] & QSFP_HIGH_POWER_ALARM) ||
-		(qsfp_interrupt_status[7] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 1/2 power too high\n",
-			__func__);
+	    (qsfp_interrupt_status[7] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 1/2 power too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[7] & QSFP_LOW_POWER_ALARM) ||
-		(qsfp_interrupt_status[7] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 1/2 power too low\n",
-			__func__);
+	    (qsfp_interrupt_status[7] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 1/2 power too low\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[8] & QSFP_HIGH_POWER_ALARM) ||
-		(qsfp_interrupt_status[8] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 3/4 power too high\n",
-			__func__);
+	    (qsfp_interrupt_status[8] & QSFP_HIGH_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 3/4 power too high\n",
+			    __func__);
 
 	if ((qsfp_interrupt_status[8] & QSFP_LOW_POWER_ALARM) ||
-		(qsfp_interrupt_status[8] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd,
-			"%s: Cable TX channel 3/4 power too low\n",
-			__func__);
+	    (qsfp_interrupt_status[8] & QSFP_LOW_POWER_WARNING))
+		dd_dev_info(dd, "%s: Cable TX channel 3/4 power too low\n",
+			    __func__);
 
 	/* Bytes 9-10 and 11-12 are reserved */
 	/* Bytes 13-15 are vendor specific */
@@ -9298,8 +9277,8 @@ void qsfp_event(struct work_struct *work)
 		if (qsfp_read(ppd, dd->hfi1_id, 6,
 			      &qsfp_interrupt_status[0], 16) != 16) {
 			dd_dev_info(dd,
-				"%s: Failed to read status of QSFP module\n",
-				__func__);
+				    "%s: Failed to read status of QSFP module\n",
+				    __func__);
 		} else {
 			unsigned long flags;
 
@@ -9308,7 +9287,7 @@ void qsfp_event(struct work_struct *work)
 			spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 			ppd->qsfp_info.check_interrupt_flags = 0;
 			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
-								flags);
+					       flags);
 		}
 	}
 }
@@ -9430,7 +9409,7 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 	ppd->offline_disabled_reason =
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED);
 	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SMA_DISABLED, 0,
-	  OPA_LINKDOWN_REASON_SMA_DISABLED);
+			     OPA_LINKDOWN_REASON_SMA_DISABLED);
 	set_link_state(ppd, HLS_DN_OFFLINE);
 
 	/* disable the port */
@@ -9486,8 +9465,8 @@ void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		pa = 0;
 	} else if (type > PT_INVALID) {
 		dd_dev_err(dd,
-			"unexpected receive array type %u for index %u, not handled\n",
-			type, index);
+			   "unexpected receive array type %u for index %u, not handled\n",
+			   type, index);
 		goto done;
 	}
 
@@ -9702,12 +9681,15 @@ static void set_send_length(struct hfi1_pportdata *ppd)
 	/* all kernel receive contexts have the same hdrqentsize */
 	for (i = 0; i < ppd->vls_supported; i++) {
 		sc_set_cr_threshold(dd->vld[i].sc,
-			sc_mtu_to_threshold(dd->vld[i].sc, dd->vld[i].mtu,
-				dd->rcd[0]->rcvhdrqentsize));
+				    sc_mtu_to_threshold(dd->vld[i].sc,
+							dd->vld[i].mtu,
+							dd->rcd[0]->
+							rcvhdrqentsize));
 	}
 	sc_set_cr_threshold(dd->vld[15].sc,
-		sc_mtu_to_threshold(dd->vld[15].sc, dd->vld[15].mtu,
-			dd->rcd[0]->rcvhdrqentsize));
+			    sc_mtu_to_threshold(dd->vld[15].sc,
+						dd->vld[15].mtu,
+						dd->rcd[0]->rcvhdrqentsize));
 
 	/* Adjust maximum MTU for the port in DC */
 	dcmtu = maxvlmtu == 10240 ? DCC_CFG_PORT_MTU_CAP_10240 :
@@ -9768,8 +9750,8 @@ static int wait_phy_linkstate(struct hfi1_devdata *dd, u32 state, u32 msecs)
 			break;
 		if (time_after(jiffies, timeout)) {
 			dd_dev_err(dd,
-				"timeout waiting for phy link state 0x%x, current state is 0x%x\n",
-				state, curr_state);
+				   "timeout waiting for phy link state 0x%x, current state is 0x%x\n",
+				   state, curr_state);
 			return -ETIMEDOUT;
 		}
 		usleep_range(1950, 2050); /* sleep 2ms-ish */
@@ -9812,12 +9794,12 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 
 	if (do_transition) {
 		ret = set_physical_link_state(dd,
-			PLS_OFFLINE | (rem_reason << 8));
+					      PLS_OFFLINE | (rem_reason << 8));
 
 		if (ret != HCMD_SUCCESS) {
 			dd_dev_err(dd,
-				"Failed to transition to Offline link state, return %d\n",
-				ret);
+				   "Failed to transition to Offline link state, return %d\n",
+				   ret);
 			return -EINVAL;
 		}
 		if (ppd->offline_disabled_reason ==
@@ -9862,7 +9844,7 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 	ret = wait_fm_ready(dd, 7000);
 	if (ret) {
 		dd_dev_err(dd,
-			"After going offline, timed out waiting for the 8051 to become ready to accept host requests\n");
+			   "After going offline, timed out waiting for the 8051 to become ready to accept host requests\n");
 		/* state is really offline, so make it so */
 		ppd->host_link_state = HLS_DN_OFFLINE;
 		return ret;
@@ -9885,8 +9867,8 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 		read_last_local_state(dd, &last_local_state);
 		read_last_remote_state(dd, &last_remote_state);
 		dd_dev_err(dd,
-			"LNI failure last states: local 0x%08x, remote 0x%08x\n",
-			last_local_state, last_remote_state);
+			   "LNI failure last states: local 0x%08x, remote 0x%08x\n",
+			   last_local_state, last_remote_state);
 	}
 
 	/* the active link width (downgrade) is 0 on link down */
@@ -10038,10 +10020,10 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		      state == HLS_DN_POLL;
 
 	dd_dev_info(dd, "%s: current %s, new %s %s%s\n", __func__,
-		link_state_name(ppd->host_link_state),
-		link_state_name(orig_new_state),
-		poll_bounce ? "(bounce) " : "",
-		link_state_reason_name(ppd, state));
+		    link_state_name(ppd->host_link_state),
+		    link_state_name(orig_new_state),
+		    poll_bounce ? "(bounce) " : "",
+		    link_state_reason_name(ppd, state));
 
 	was_up = !!(ppd->host_link_state & HLS_UP);
 
@@ -10071,7 +10053,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			 * simulator jumps from polling to link up.
 			 * Accept that here.
 			 */
-			/* OK */;
+			/* OK */
 		} else if (ppd->host_link_state != HLS_GOING_UP) {
 			goto unexpected;
 		}
@@ -10082,8 +10064,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			/* logical state didn't change, stay at going_up */
 			ppd->host_link_state = HLS_GOING_UP;
 			dd_dev_err(dd,
-				"%s: logical state did not change to INIT\n",
-				__func__);
+				   "%s: logical state did not change to INIT\n",
+				   __func__);
 		} else {
 			/* clear old transient LINKINIT_REASON code */
 			if (ppd->linkinit_reason >= OPA_LINKINIT_REASON_CLEAR)
@@ -10107,8 +10089,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			/* logical state didn't change, stay at init */
 			ppd->host_link_state = HLS_UP_INIT;
 			dd_dev_err(dd,
-				"%s: logical state did not change to ARMED\n",
-				__func__);
+				   "%s: logical state did not change to ARMED\n",
+				   __func__);
 		}
 		/*
 		 * The simulator does not currently implement SMA messages,
@@ -10129,8 +10111,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			/* logical state didn't change, stay at armed */
 			ppd->host_link_state = HLS_UP_ARMED;
 			dd_dev_err(dd,
-				"%s: logical state did not change to ACTIVE\n",
-				__func__);
+				   "%s: logical state did not change to ACTIVE\n",
+				   __func__);
 		} else {
 			/* tell all engines to go running */
 			sdma_all_running(dd);
@@ -10178,8 +10160,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			ret1 = set_physical_link_state(dd, PLS_POLLING);
 			if (ret1 != HCMD_SUCCESS) {
 				dd_dev_err(dd,
-					"Failed to transition to Polling link state, return 0x%x\n",
-					ret1);
+					   "Failed to transition to Polling link state, return 0x%x\n",
+					   ret1);
 				ret = -EINVAL;
 			}
 		}
@@ -10209,8 +10191,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		ret1 = set_physical_link_state(dd, PLS_DISABLED);
 		if (ret1 != HCMD_SUCCESS) {
 			dd_dev_err(dd,
-				"Failed to transition to Disabled link state, return 0x%x\n",
-				ret1);
+				   "Failed to transition to Disabled link state, return 0x%x\n",
+				   ret1);
 			ret = -EINVAL;
 			break;
 		}
@@ -10238,8 +10220,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		ret1 = set_physical_link_state(dd, PLS_LINKUP);
 		if (ret1 != HCMD_SUCCESS) {
 			dd_dev_err(dd,
-				"Failed to transition to link up state, return 0x%x\n",
-				ret1);
+				   "Failed to transition to link up state, return 0x%x\n",
+				   ret1);
 			ret = -EINVAL;
 			break;
 		}
@@ -10250,7 +10232,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 	case HLS_LINK_COOLDOWN:		/* transient within goto_offline() */
 	default:
 		dd_dev_info(dd, "%s: state 0x%x: not supported\n",
-			__func__, state);
+			    __func__, state);
 		ret = -EINVAL;
 		break;
 	}
@@ -10270,8 +10252,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 
 unexpected:
 	dd_dev_err(dd, "%s: unexpected state transition from %s to %s\n",
-		__func__, link_state_name(ppd->host_link_state),
-		link_state_name(state));
+		   __func__, link_state_name(ppd->host_link_state),
+		   link_state_name(state));
 	ret = -EINVAL;
 
 done:
@@ -10359,8 +10341,8 @@ int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val)
 	default:
 		if (HFI1_CAP_IS_KSET(PRINT_UNIMPL))
 			dd_dev_info(ppd->dd,
-			  "%s: which %s, val 0x%x: not implemented\n",
-			  __func__, ib_cfg_name(which), val);
+				    "%s: which %s, val 0x%x: not implemented\n",
+				    __func__, ib_cfg_name(which), val);
 		break;
 	}
 	return ret;
@@ -10569,41 +10551,41 @@ static void get_vlarb_preempt(struct hfi1_devdata *dd, u32 nelems,
 static void set_sc2vlnt(struct hfi1_devdata *dd, struct sc2vlnt *dp)
 {
 	write_csr(dd, DCC_CFG_SC_VL_TABLE_15_0,
-		DC_SC_VL_VAL(15_0,
-		0, dp->vlnt[0] & 0xf,
-		1, dp->vlnt[1] & 0xf,
-		2, dp->vlnt[2] & 0xf,
-		3, dp->vlnt[3] & 0xf,
-		4, dp->vlnt[4] & 0xf,
-		5, dp->vlnt[5] & 0xf,
-		6, dp->vlnt[6] & 0xf,
-		7, dp->vlnt[7] & 0xf,
-		8, dp->vlnt[8] & 0xf,
-		9, dp->vlnt[9] & 0xf,
-		10, dp->vlnt[10] & 0xf,
-		11, dp->vlnt[11] & 0xf,
-		12, dp->vlnt[12] & 0xf,
-		13, dp->vlnt[13] & 0xf,
-		14, dp->vlnt[14] & 0xf,
-		15, dp->vlnt[15] & 0xf));
+		  DC_SC_VL_VAL(15_0,
+			       0, dp->vlnt[0] & 0xf,
+			       1, dp->vlnt[1] & 0xf,
+			       2, dp->vlnt[2] & 0xf,
+			       3, dp->vlnt[3] & 0xf,
+			       4, dp->vlnt[4] & 0xf,
+			       5, dp->vlnt[5] & 0xf,
+			       6, dp->vlnt[6] & 0xf,
+			       7, dp->vlnt[7] & 0xf,
+			       8, dp->vlnt[8] & 0xf,
+			       9, dp->vlnt[9] & 0xf,
+			       10, dp->vlnt[10] & 0xf,
+			       11, dp->vlnt[11] & 0xf,
+			       12, dp->vlnt[12] & 0xf,
+			       13, dp->vlnt[13] & 0xf,
+			       14, dp->vlnt[14] & 0xf,
+			       15, dp->vlnt[15] & 0xf));
 	write_csr(dd, DCC_CFG_SC_VL_TABLE_31_16,
-		DC_SC_VL_VAL(31_16,
-		16, dp->vlnt[16] & 0xf,
-		17, dp->vlnt[17] & 0xf,
-		18, dp->vlnt[18] & 0xf,
-		19, dp->vlnt[19] & 0xf,
-		20, dp->vlnt[20] & 0xf,
-		21, dp->vlnt[21] & 0xf,
-		22, dp->vlnt[22] & 0xf,
-		23, dp->vlnt[23] & 0xf,
-		24, dp->vlnt[24] & 0xf,
-		25, dp->vlnt[25] & 0xf,
-		26, dp->vlnt[26] & 0xf,
-		27, dp->vlnt[27] & 0xf,
-		28, dp->vlnt[28] & 0xf,
-		29, dp->vlnt[29] & 0xf,
-		30, dp->vlnt[30] & 0xf,
-		31, dp->vlnt[31] & 0xf));
+		  DC_SC_VL_VAL(31_16,
+			       16, dp->vlnt[16] & 0xf,
+			       17, dp->vlnt[17] & 0xf,
+			       18, dp->vlnt[18] & 0xf,
+			       19, dp->vlnt[19] & 0xf,
+			       20, dp->vlnt[20] & 0xf,
+			       21, dp->vlnt[21] & 0xf,
+			       22, dp->vlnt[22] & 0xf,
+			       23, dp->vlnt[23] & 0xf,
+			       24, dp->vlnt[24] & 0xf,
+			       25, dp->vlnt[25] & 0xf,
+			       26, dp->vlnt[26] & 0xf,
+			       27, dp->vlnt[27] & 0xf,
+			       28, dp->vlnt[28] & 0xf,
+			       29, dp->vlnt[29] & 0xf,
+			       30, dp->vlnt[30] & 0xf,
+			       31, dp->vlnt[31] & 0xf));
 }
 
 static void nonzero_msg(struct hfi1_devdata *dd, int idx, const char *what,
@@ -10611,7 +10593,7 @@ static void nonzero_msg(struct hfi1_devdata *dd, int idx, const char *what,
 {
 	if (limit != 0)
 		dd_dev_info(dd, "Invalid %s limit %d on VL %d, ignoring\n",
-			what, (int)limit, idx);
+			    what, (int)limit, idx);
 }
 
 /* change only the shared limit portion of SendCmGLobalCredit */
@@ -10689,14 +10671,14 @@ static void wait_for_vl_status_clear(struct hfi1_devdata *dd, u64 mask,
 	}
 
 	dd_dev_err(dd,
-		"%s credit change status not clearing after %dms, mask 0x%llx, not clear 0x%llx\n",
-		which, VL_STATUS_CLEAR_TIMEOUT, mask, reg);
+		   "%s credit change status not clearing after %dms, mask 0x%llx, not clear 0x%llx\n",
+		   which, VL_STATUS_CLEAR_TIMEOUT, mask, reg);
 	/*
 	 * If this occurs, it is likely there was a credit loss on the link.
 	 * The only recovery from that is a link bounce.
 	 */
 	dd_dev_err(dd,
-		"Continuing anyway.  A credit loss may occur.  Suggest a link bounce\n");
+		   "Continuing anyway.  A credit loss may occur.  Suggest a link bounce\n");
 }
 
 /*
@@ -10763,9 +10745,9 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 			continue;
 		}
 		nonzero_msg(dd, i, "dedicated",
-			be16_to_cpu(new_bc->vl[i].dedicated));
+			    be16_to_cpu(new_bc->vl[i].dedicated));
 		nonzero_msg(dd, i, "shared",
-			be16_to_cpu(new_bc->vl[i].shared));
+			    be16_to_cpu(new_bc->vl[i].shared));
 		new_bc->vl[i].dedicated = 0;
 		new_bc->vl[i].shared = 0;
 	}
@@ -10836,7 +10818,7 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 	}
 
 	wait_for_vl_status_clear(dd, use_all_mask ? all_mask : changing_mask,
-		"shared");
+				 "shared");
 
 	if (change_count > 0) {
 		for (i = 0; i < NUM_USABLE_VLS; i++) {
@@ -10845,7 +10827,8 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 
 			if (lowering_dedicated[i]) {
 				set_vl_dedicated(dd, i,
-					be16_to_cpu(new_bc->vl[i].dedicated));
+						 be16_to_cpu(new_bc->
+							     vl[i].dedicated));
 				cur_bc.vl[i].dedicated =
 						new_bc->vl[i].dedicated;
 			}
@@ -10861,7 +10844,8 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 			if (be16_to_cpu(new_bc->vl[i].dedicated) >
 					be16_to_cpu(cur_bc.vl[i].dedicated))
 				set_vl_dedicated(dd, i,
-					be16_to_cpu(new_bc->vl[i].dedicated));
+						 be16_to_cpu(new_bc->
+							     vl[i].dedicated));
 		}
 	}
 
@@ -10877,9 +10861,9 @@ int set_buffer_control(struct hfi1_pportdata *ppd,
 
 	/* finally raise the global shared */
 	if (be16_to_cpu(new_bc->overall_shared_limit) >
-			be16_to_cpu(cur_bc.overall_shared_limit))
+	    be16_to_cpu(cur_bc.overall_shared_limit))
 		set_global_shared(dd,
-			be16_to_cpu(new_bc->overall_shared_limit));
+				  be16_to_cpu(new_bc->overall_shared_limit));
 
 	/* bracket the credit change with a total adjustment */
 	if (new_total < cur_total)
@@ -11152,7 +11136,8 @@ static void adjust_rcv_timeout(struct hfi1_ctxtdata *rcd, u32 npkts)
 	 * been verified to be in range
 	 */
 	write_kctxt_csr(dd, rcd->ctxt, RCV_AVAIL_TIME_OUT,
-		(u64)timeout << RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_SHIFT);
+			(u64)timeout <<
+			RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_SHIFT);
 }
 
 void update_usrhead(struct hfi1_ctxtdata *rcd, u32 hd, u32 updegr, u32 egrhd,
@@ -11370,14 +11355,14 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		reg = read_kctxt_csr(dd, ctxt, RCV_CTXT_STATUS);
 		if (reg != 0) {
 			dd_dev_info(dd, "ctxt %d status %lld (blocked)\n",
-				ctxt, reg);
+				    ctxt, reg);
 			read_uctxt_csr(dd, ctxt, RCV_HDR_HEAD);
 			write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, 0x10);
 			write_uctxt_csr(dd, ctxt, RCV_HDR_HEAD, 0x00);
 			read_uctxt_csr(dd, ctxt, RCV_HDR_HEAD);
 			reg = read_kctxt_csr(dd, ctxt, RCV_CTXT_STATUS);
 			dd_dev_info(dd, "ctxt %d status %lld (%s blocked)\n",
-				ctxt, reg, reg == 0 ? "not" : "still");
+				    ctxt, reg, reg == 0 ? "not" : "still");
 		}
 	}
 
@@ -11388,7 +11373,7 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 		 */
 		/* set interrupt timeout */
 		write_kctxt_csr(dd, ctxt, RCV_AVAIL_TIME_OUT,
-			(u64)rcd->rcvavail_timeout <<
+				(u64)rcd->rcvavail_timeout <<
 				RCV_AVAIL_TIME_OUT_TIME_OUT_RELOAD_SHIFT);
 
 		/* set RcvHdrHead.Counter, zero RcvHdrHead.Head (again) */
@@ -11863,8 +11848,7 @@ static int init_cntrs(struct hfi1_devdata *dd)
 			dev_cntrs[i].offset = dd->ndevcntrs;
 			for (j = 0; j < C_VL_COUNT; j++) {
 				snprintf(name, C_MAX_NAME, "%s%d",
-					dev_cntrs[i].name,
-					vl_from_idx(j));
+					 dev_cntrs[i].name, vl_from_idx(j));
 				sz += strlen(name);
 				/* Add ",32" for 32-bit counters */
 				if (dev_cntrs[i].flags & CNTR_32BIT)
@@ -11987,8 +11971,7 @@ static int init_cntrs(struct hfi1_devdata *dd)
 			port_cntrs[i].offset = dd->nportcntrs;
 			for (j = 0; j < C_VL_COUNT; j++) {
 				snprintf(name, C_MAX_NAME, "%s%d",
-					port_cntrs[i].name,
-					vl_from_idx(j));
+					 port_cntrs[i].name, vl_from_idx(j));
 				sz += strlen(name);
 				/* Add ",32" for 32-bit counters */
 				if (port_cntrs[i].flags & CNTR_32BIT)
@@ -12021,8 +12004,7 @@ static int init_cntrs(struct hfi1_devdata *dd)
 		if (port_cntrs[i].flags & CNTR_VL) {
 			for (j = 0; j < C_VL_COUNT; j++) {
 				snprintf(name, C_MAX_NAME, "%s%d",
-					port_cntrs[i].name,
-					vl_from_idx(j));
+					 port_cntrs[i].name, vl_from_idx(j));
 				memcpy(p, name, strlen(name));
 				p += strlen(name);
 
@@ -12077,8 +12059,8 @@ static u32 chip_to_opa_lstate(struct hfi1_devdata *dd, u32 chip_lstate)
 	switch (chip_lstate) {
 	default:
 		dd_dev_err(dd,
-			 "Unknown logical state 0x%x, reporting IB_PORT_DOWN\n",
-			 chip_lstate);
+			   "Unknown logical state 0x%x, reporting IB_PORT_DOWN\n",
+			   chip_lstate);
 		/* fall through */
 	case LSTATE_DOWN:
 		return IB_PORT_DOWN;
@@ -12097,7 +12079,7 @@ u32 chip_to_opa_pstate(struct hfi1_devdata *dd, u32 chip_pstate)
 	switch (chip_pstate & 0xf0) {
 	default:
 		dd_dev_err(dd, "Unexpected chip physical state of 0x%x\n",
-			chip_pstate);
+			   chip_pstate);
 		/* fall through */
 	case PLS_DISABLED:
 		return IB_PORTPHYSSTATE_DISABLED;
@@ -12163,7 +12145,7 @@ u32 get_logical_state(struct hfi1_pportdata *ppd)
 	new_state = chip_to_opa_lstate(ppd->dd, read_logical_state(ppd->dd));
 	if (new_state != ppd->lstate) {
 		dd_dev_info(ppd->dd, "logical state changed to %s (0x%x)\n",
-			opa_lstate_name(new_state), new_state);
+			    opa_lstate_name(new_state), new_state);
 		ppd->lstate = new_state;
 	}
 	/*
@@ -12229,9 +12211,9 @@ u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd)
 	ib_pstate = chip_to_opa_pstate(ppd->dd, pstate);
 	if (ppd->last_pstate != ib_pstate) {
 		dd_dev_info(ppd->dd,
-			"%s: physical state changed to %s (0x%x), phy 0x%x\n",
-			__func__, opa_pstate_name(ib_pstate), ib_pstate,
-			pstate);
+			    "%s: physical state changed to %s (0x%x), phy 0x%x\n",
+			    __func__, opa_pstate_name(ib_pstate), ib_pstate,
+			    pstate);
 		ppd->last_pstate = ib_pstate;
 	}
 	return ib_pstate;
@@ -12449,11 +12431,11 @@ static void remap_sdma_interrupts(struct hfi1_devdata *dd,
 	 *	SDMAIdle
 	 */
 	remap_intr(dd, IS_SDMA_START + 0 * TXE_NUM_SDMA_ENGINES + engine,
-		msix_intr);
+		   msix_intr);
 	remap_intr(dd, IS_SDMA_START + 1 * TXE_NUM_SDMA_ENGINES + engine,
-		msix_intr);
+		   msix_intr);
 	remap_intr(dd, IS_SDMA_START + 2 * TXE_NUM_SDMA_ENGINES + engine,
-		msix_intr);
+		   msix_intr);
 }
 
 static int request_intx_irq(struct hfi1_devdata *dd)
@@ -12463,10 +12445,10 @@ static int request_intx_irq(struct hfi1_devdata *dd)
 	snprintf(dd->intx_name, sizeof(dd->intx_name), DRIVER_NAME "_%d",
 		 dd->unit);
 	ret = request_irq(dd->pcidev->irq, general_interrupt,
-				  IRQF_SHARED, dd->intx_name, dd);
+			  IRQF_SHARED, dd->intx_name, dd);
 	if (ret)
 		dd_dev_err(dd, "unable to request INTx interrupt, err %d\n",
-				ret);
+			   ret);
 	else
 		dd->requested_intx_irq = 1;
 	return ret;
@@ -12549,7 +12531,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			 * ignore it
 			 */
 			dd_dev_err(dd,
-				"Unexpected extra MSI-X interrupt %d\n", i);
+				   "Unexpected extra MSI-X interrupt %d\n", i);
 			continue;
 		}
 		/* no argument, no interrupt */
@@ -12559,11 +12541,11 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		me->name[sizeof(me->name) - 1] = 0;
 
 		ret = request_threaded_irq(me->msix.vector, handler, thread, 0,
-						me->name, arg);
+					   me->name, arg);
 		if (ret) {
 			dd_dev_err(dd,
-				"unable to allocate %s interrupt, vector %d, index %d, err %d\n",
-				 err_info, me->msix.vector, idx, ret);
+				   "unable to allocate %s interrupt, vector %d, index %d, err %d\n",
+				   err_info, me->msix.vector, idx, ret);
 			return ret;
 		}
 		/*
@@ -12748,11 +12730,11 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	dd->num_user_contexts = num_user_contexts;
 	dd->freectxts = num_user_contexts;
 	dd_dev_info(dd,
-		"rcv contexts: chip %d, used %d (kernel %d, user %d)\n",
-		(int)dd->chip_rcv_contexts,
-		(int)dd->num_rcv_contexts,
-		(int)dd->n_krcv_queues,
-		(int)dd->num_rcv_contexts - dd->n_krcv_queues);
+		    "rcv contexts: chip %d, used %d (kernel %d, user %d)\n",
+		    (int)dd->chip_rcv_contexts,
+		    (int)dd->num_rcv_contexts,
+		    (int)dd->n_krcv_queues,
+		    (int)dd->num_rcv_contexts - dd->n_krcv_queues);
 
 	/*
 	 * Receive array allocation:
@@ -12778,8 +12760,8 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		dd->rcv_entries.ngroups = (MAX_EAGER_ENTRIES * 2) /
 			dd->rcv_entries.group_size;
 		dd_dev_info(dd,
-		   "RcvArray group count too high, change to %u\n",
-		   dd->rcv_entries.ngroups);
+			    "RcvArray group count too high, change to %u\n",
+			    dd->rcv_entries.ngroups);
 		dd->rcv_entries.nctxt_extra = 0;
 	}
 	/*
@@ -12871,7 +12853,7 @@ static void write_uninitialized_csrs_and_memories(struct hfi1_devdata *dd)
 	/* RcvArray */
 	for (i = 0; i < dd->chip_rcv_array_count; i++)
 		write_csr(dd, RCV_ARRAY + (8 * i),
-					RCV_ARRAY_RT_WRITE_ENABLE_SMASK);
+			  RCV_ARRAY_RT_WRITE_ENABLE_SMASK);
 
 	/* RcvQPMapTable */
 	for (i = 0; i < 32; i++)
@@ -12903,8 +12885,8 @@ static void clear_cce_status(struct hfi1_devdata *dd, u64 status_bits,
 			return;
 		if (time_after(jiffies, timeout)) {
 			dd_dev_err(dd,
-				"Timeout waiting for CceStatus to clear bits 0x%llx, remaining 0x%llx\n",
-				status_bits, reg & status_bits);
+				   "Timeout waiting for CceStatus to clear bits 0x%llx, remaining 0x%llx\n",
+				   status_bits, reg & status_bits);
 			return;
 		}
 		udelay(1);
@@ -12936,7 +12918,7 @@ static void reset_cce_csrs(struct hfi1_devdata *dd)
 	for (i = 0; i < CCE_NUM_MSIX_VECTORS; i++) {
 		write_csr(dd, CCE_MSIX_TABLE_LOWER + (8 * i), 0);
 		write_csr(dd, CCE_MSIX_TABLE_UPPER + (8 * i),
-					CCE_MSIX_TABLE_UPPER_RESETCSR);
+			  CCE_MSIX_TABLE_UPPER_RESETCSR);
 	}
 	for (i = 0; i < CCE_NUM_MSIX_PBAS; i++) {
 		/* CCE_MSIX_PBA read-only */
@@ -13120,8 +13102,7 @@ static void reset_txe_csrs(struct hfi1_devdata *dd)
 	for (i = 0; i < TXE_NUM_64_BIT_COUNTER; i++)
 		write_csr(dd, SEND_COUNTER_ARRAY64 + (8 * i), 0);
 	write_csr(dd, SEND_CM_CTRL, SEND_CM_CTRL_RESETCSR);
-	write_csr(dd, SEND_CM_GLOBAL_CREDIT,
-					SEND_CM_GLOBAL_CREDIT_RESETCSR);
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT, SEND_CM_GLOBAL_CREDIT_RESETCSR);
 	/* SEND_CM_CREDIT_USED_STATUS read-only */
 	write_csr(dd, SEND_CM_TIMER_CTRL, 0);
 	write_csr(dd, SEND_CM_LOCAL_AU_TABLE0_TO3, 0);
@@ -13215,8 +13196,8 @@ static void init_rbufs(struct hfi1_devdata *dd)
 		 */
 		if (count++ > 500) {
 			dd_dev_err(dd,
-				"%s: in-progress DMA not clearing: RcvStatus 0x%llx, continuing\n",
-				__func__, reg);
+				   "%s: in-progress DMA not clearing: RcvStatus 0x%llx, continuing\n",
+				   __func__, reg);
 			break;
 		}
 		udelay(2); /* do not busy-wait the CSR */
@@ -13245,8 +13226,8 @@ static void init_rbufs(struct hfi1_devdata *dd)
 		/* give up after 100us - slowest possible at 33MHz is 73us */
 		if (count++ > 50) {
 			dd_dev_err(dd,
-				"%s: RcvStatus.RxRbufInit not set, continuing\n",
-				__func__);
+				   "%s: RcvStatus.RxRbufInit not set, continuing\n",
+				   __func__);
 			break;
 		}
 	}
@@ -13272,7 +13253,7 @@ static void reset_rxe_csrs(struct hfi1_devdata *dd)
 	write_csr(dd, RCV_VL15, 0);
 	/* this is a clear-down */
 	write_csr(dd, RCV_ERR_INFO,
-			RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SMASK);
+		  RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SMASK);
 	/* RCV_ERR_STATUS read-only */
 	write_csr(dd, RCV_ERR_MASK, 0);
 	write_csr(dd, RCV_ERR_CLEAR, ~0ull);
@@ -13318,8 +13299,8 @@ static void reset_rxe_csrs(struct hfi1_devdata *dd)
 		write_uctxt_csr(dd, i, RCV_EGR_INDEX_HEAD, 0);
 		/* RCV_EGR_OFFSET_TAIL read-only */
 		for (j = 0; j < RXE_NUM_TID_FLOWS; j++) {
-			write_uctxt_csr(dd, i, RCV_TID_FLOW_TABLE + (8 * j),
-				0);
+			write_uctxt_csr(dd, i,
+					RCV_TID_FLOW_TABLE + (8 * j), 0);
 		}
 	}
 }
@@ -13519,12 +13500,12 @@ static void init_kdeth_qp(struct hfi1_devdata *dd)
 		kdeth_qp = DEFAULT_KDETH_QP;
 
 	write_csr(dd, SEND_BTH_QP,
-			(kdeth_qp & SEND_BTH_QP_KDETH_QP_MASK)
-				<< SEND_BTH_QP_KDETH_QP_SHIFT);
+		  (kdeth_qp & SEND_BTH_QP_KDETH_QP_MASK) <<
+		  SEND_BTH_QP_KDETH_QP_SHIFT);
 
 	write_csr(dd, RCV_BTH_QP,
-			(kdeth_qp & RCV_BTH_QP_KDETH_QP_MASK)
-				<< RCV_BTH_QP_KDETH_QP_SHIFT);
+		  (kdeth_qp & RCV_BTH_QP_KDETH_QP_MASK) <<
+		  RCV_BTH_QP_KDETH_QP_SHIFT);
 }
 
 /**
@@ -13649,22 +13630,21 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 		write_csr(dd, RCV_RSM_MAP_TABLE + (8 * i), rsmmap[i]);
 	/* add rule0 */
 	write_csr(dd, RCV_RSM_CFG /* + (8 * 0) */,
-		RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK
-			<< RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
-		2ull << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
+		  RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK <<
+		  RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
+		  2ull << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
 	write_csr(dd, RCV_RSM_SELECT /* + (8 * 0) */,
-		LRH_BTH_MATCH_OFFSET
-			<< RCV_RSM_SELECT_FIELD1_OFFSET_SHIFT |
-		LRH_SC_MATCH_OFFSET << RCV_RSM_SELECT_FIELD2_OFFSET_SHIFT |
-		LRH_SC_SELECT_OFFSET << RCV_RSM_SELECT_INDEX1_OFFSET_SHIFT |
-		((u64)n) << RCV_RSM_SELECT_INDEX1_WIDTH_SHIFT |
-		QPN_SELECT_OFFSET << RCV_RSM_SELECT_INDEX2_OFFSET_SHIFT |
-		((u64)m + (u64)n) << RCV_RSM_SELECT_INDEX2_WIDTH_SHIFT);
+		  LRH_BTH_MATCH_OFFSET << RCV_RSM_SELECT_FIELD1_OFFSET_SHIFT |
+		  LRH_SC_MATCH_OFFSET << RCV_RSM_SELECT_FIELD2_OFFSET_SHIFT |
+		  LRH_SC_SELECT_OFFSET << RCV_RSM_SELECT_INDEX1_OFFSET_SHIFT |
+		  ((u64)n) << RCV_RSM_SELECT_INDEX1_WIDTH_SHIFT |
+		  QPN_SELECT_OFFSET << RCV_RSM_SELECT_INDEX2_OFFSET_SHIFT |
+		  ((u64)m + (u64)n) << RCV_RSM_SELECT_INDEX2_WIDTH_SHIFT);
 	write_csr(dd, RCV_RSM_MATCH /* + (8 * 0) */,
-		LRH_BTH_MASK << RCV_RSM_MATCH_MASK1_SHIFT |
-		LRH_BTH_VALUE << RCV_RSM_MATCH_VALUE1_SHIFT |
-		LRH_SC_MASK << RCV_RSM_MATCH_MASK2_SHIFT |
-		LRH_SC_VALUE << RCV_RSM_MATCH_VALUE2_SHIFT);
+		  LRH_BTH_MASK << RCV_RSM_MATCH_MASK1_SHIFT |
+		  LRH_BTH_VALUE << RCV_RSM_MATCH_VALUE1_SHIFT |
+		  LRH_SC_MASK << RCV_RSM_MATCH_MASK2_SHIFT |
+		  LRH_SC_VALUE << RCV_RSM_MATCH_VALUE2_SHIFT);
 	/* Enable RSM */
 	add_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
 	kfree(rsmmap);
@@ -13682,9 +13662,8 @@ static void init_rxe(struct hfi1_devdata *dd)
 	/* enable all receive errors */
 	write_csr(dd, RCV_ERR_MASK, ~0ull);
 	/* setup QPN map table - start where VL15 context leaves off */
-	init_qos(
-		dd,
-		dd->n_krcv_queues > MIN_KERNEL_KCTXTS ? MIN_KERNEL_KCTXTS : 0);
+	init_qos(dd, dd->n_krcv_queues > MIN_KERNEL_KCTXTS ?
+		 MIN_KERNEL_KCTXTS : 0);
 	/*
 	 * make sure RcvCtrl.RcvWcb <= PCIe Device Control
 	 * Register Max_Payload_Size (PCI_EXP_DEVCTL in Linux PCIe config
@@ -13721,35 +13700,33 @@ static void assign_cm_au_table(struct hfi1_devdata *dd, u32 cu,
 			       u32 csr0to3, u32 csr4to7)
 {
 	write_csr(dd, csr0to3,
-		   0ull <<
-			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE0_SHIFT
-		|  1ull <<
-			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE1_SHIFT
-		|  2ull * cu <<
-			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE2_SHIFT
-		|  4ull * cu <<
-			SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE3_SHIFT);
+		  0ull << SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE0_SHIFT |
+		  1ull << SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE1_SHIFT |
+		  2ull * cu <<
+		  SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE2_SHIFT |
+		  4ull * cu <<
+		  SEND_CM_LOCAL_AU_TABLE0_TO3_LOCAL_AU_TABLE3_SHIFT);
 	write_csr(dd, csr4to7,
-		   8ull * cu <<
-			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE4_SHIFT
-		| 16ull * cu <<
-			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE5_SHIFT
-		| 32ull * cu <<
-			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE6_SHIFT
-		| 64ull * cu <<
-			SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE7_SHIFT);
+		  8ull * cu <<
+		  SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE4_SHIFT |
+		  16ull * cu <<
+		  SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE5_SHIFT |
+		  32ull * cu <<
+		  SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE6_SHIFT |
+		  64ull * cu <<
+		  SEND_CM_LOCAL_AU_TABLE4_TO7_LOCAL_AU_TABLE7_SHIFT);
 }
 
 static void assign_local_cm_au_table(struct hfi1_devdata *dd, u8 vcu)
 {
 	assign_cm_au_table(dd, vcu_to_cu(vcu), SEND_CM_LOCAL_AU_TABLE0_TO3,
-					SEND_CM_LOCAL_AU_TABLE4_TO7);
+			   SEND_CM_LOCAL_AU_TABLE4_TO7);
 }
 
 void assign_remote_cm_au_table(struct hfi1_devdata *dd, u8 vcu)
 {
 	assign_cm_au_table(dd, vcu_to_cu(vcu), SEND_CM_REMOTE_AU_TABLE0_TO3,
-					SEND_CM_REMOTE_AU_TABLE4_TO7);
+			   SEND_CM_REMOTE_AU_TABLE4_TO7);
 }
 
 static void init_txe(struct hfi1_devdata *dd)
@@ -13995,8 +13972,8 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		"Functional simulator"
 	};
 
-	dd = hfi1_alloc_devdata(pdev,
-		NUM_IB_PORTS * sizeof(struct hfi1_pportdata));
+	dd = hfi1_alloc_devdata(pdev, NUM_IB_PORTS *
+				sizeof(struct hfi1_pportdata));
 	if (IS_ERR(dd))
 		goto bail;
 	ppd = dd->pport;
@@ -14083,8 +14060,8 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	dd->icode = reg >> CCE_REVISION2_IMPL_CODE_SHIFT;
 	dd->irev = reg >> CCE_REVISION2_IMPL_REVISION_SHIFT;
 	dd_dev_info(dd, "Implementation: %s, revision 0x%x\n",
-		dd->icode < ARRAY_SIZE(inames) ? inames[dd->icode] : "unknown",
-		(int)dd->irev);
+		    dd->icode < ARRAY_SIZE(inames) ?
+		    inames[dd->icode] : "unknown", (int)dd->irev);
 
 	/* speeds the hardware can support */
 	dd->pport->link_speed_supported = OPA_LINK_SPEED_25G;
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index e02c527..0b0fd8a 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -150,8 +150,8 @@ static int _opcode_stats_seq_show(struct seq_file *s, void *v)
 	if (!n_packets && !n_bytes)
 		return SEQ_SKIP;
 	seq_printf(s, "%02llx %llu/%llu\n", i,
-		(unsigned long long)n_packets,
-		(unsigned long long)n_bytes);
+		   (unsigned long long)n_packets,
+		   (unsigned long long)n_bytes);
 
 	return 0;
 }
@@ -246,7 +246,7 @@ __acquires(RCU)
 }
 
 static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
-				   loff_t *pos)
+				loff_t *pos)
 {
 	struct qp_iter *iter = iter_ptr;
 
@@ -392,7 +392,7 @@ static ssize_t portnames_read(struct file *file, char __user *buf,
 
 /* read the per-port counters */
 static ssize_t portcntrs_debugfs_read(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+				      size_t count, loff_t *ppos)
 {
 	u64 *counters;
 	size_t avail;
@@ -413,7 +413,7 @@ static ssize_t portcntrs_debugfs_read(struct file *file, char __user *buf,
  * read the per-port QSFP data for ppd
  */
 static ssize_t qsfp_debugfs_dump(struct file *file, char __user *buf,
-			   size_t count, loff_t *ppos)
+				 size_t count, loff_t *ppos)
 {
 	struct hfi1_pportdata *ppd;
 	char *tmp;
@@ -437,7 +437,7 @@ static ssize_t qsfp_debugfs_dump(struct file *file, char __user *buf,
 
 /* Do an i2c write operation on the chain for the given HFI. */
 static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos, u32 target)
+				   size_t count, loff_t *ppos, u32 target)
 {
 	struct hfi1_pportdata *ppd;
 	char *buff;
@@ -484,21 +484,21 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 
 /* Do an i2c write operation on chain for HFI 0. */
 static ssize_t i2c1_debugfs_write(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos)
+				  size_t count, loff_t *ppos)
 {
 	return __i2c_debugfs_write(file, buf, count, ppos, 0);
 }
 
 /* Do an i2c write operation on chain for HFI 1. */
 static ssize_t i2c2_debugfs_write(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos)
+				  size_t count, loff_t *ppos)
 {
 	return __i2c_debugfs_write(file, buf, count, ppos, 1);
 }
 
 /* Do an i2c read operation on the chain for the given HFI. */
 static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos, u32 target)
+				  size_t count, loff_t *ppos, u32 target)
 {
 	struct hfi1_pportdata *ppd;
 	char *buff;
@@ -545,21 +545,21 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 
 /* Do an i2c read operation on chain for HFI 0. */
 static ssize_t i2c1_debugfs_read(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos)
+				 size_t count, loff_t *ppos)
 {
 	return __i2c_debugfs_read(file, buf, count, ppos, 0);
 }
 
 /* Do an i2c read operation on chain for HFI 1. */
 static ssize_t i2c2_debugfs_read(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos)
+				 size_t count, loff_t *ppos)
 {
 	return __i2c_debugfs_read(file, buf, count, ppos, 1);
 }
 
 /* Do a QSFP write operation on the i2c chain for the given HFI. */
 static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos, u32 target)
+				    size_t count, loff_t *ppos, u32 target)
 {
 	struct hfi1_pportdata *ppd;
 	char *buff;
@@ -605,21 +605,21 @@ static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
 
 /* Do a QSFP write operation on i2c chain for HFI 0. */
 static ssize_t qsfp1_debugfs_write(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos)
+				   size_t count, loff_t *ppos)
 {
 	return __qsfp_debugfs_write(file, buf, count, ppos, 0);
 }
 
 /* Do a QSFP write operation on i2c chain for HFI 1. */
 static ssize_t qsfp2_debugfs_write(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos)
+				   size_t count, loff_t *ppos)
 {
 	return __qsfp_debugfs_write(file, buf, count, ppos, 1);
 }
 
 /* Do a QSFP read operation on the i2c chain for the given HFI. */
 static ssize_t __qsfp_debugfs_read(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos, u32 target)
+				   size_t count, loff_t *ppos, u32 target)
 {
 	struct hfi1_pportdata *ppd;
 	char *buff;
@@ -665,14 +665,14 @@ static ssize_t __qsfp_debugfs_read(struct file *file, char __user *buf,
 
 /* Do a QSFP read operation on i2c chain for HFI 0. */
 static ssize_t qsfp1_debugfs_read(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos)
+				  size_t count, loff_t *ppos)
 {
 	return __qsfp_debugfs_read(file, buf, count, ppos, 0);
 }
 
 /* Do a QSFP read operation on i2c chain for HFI 1. */
 static ssize_t qsfp2_debugfs_read(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos)
+				  size_t count, loff_t *ppos)
 {
 	return __qsfp_debugfs_read(file, buf, count, ppos, 1);
 }
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 3ef297e..50a3b5a 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -438,7 +438,7 @@ drop:
 }
 
 static inline void init_packet(struct hfi1_ctxtdata *rcd,
-			      struct hfi1_packet *packet)
+			       struct hfi1_packet *packet)
 {
 	packet->rsize = rcd->rcvhdrqentsize; /* words */
 	packet->maxcnt = rcd->rcvhdrq_cnt * packet->rsize; /* words */
@@ -700,8 +700,9 @@ static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 		 * The +2 is the size of the RHF.
 		 */
 		prefetch_range(packet->ebuf,
-			packet->tlen - ((packet->rcd->rcvhdrqentsize -
-				  (rhf_hdrq_offset(packet->rhf) + 2)) * 4));
+			       packet->tlen - ((packet->rcd->rcvhdrqentsize -
+					       (rhf_hdrq_offset(packet->rhf)
+						+ 2)) * 4));
 	}
 
 	/*
@@ -958,9 +959,9 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 	prescan_rxq(rcd, &packet);
 
 	while (last == RCV_PKT_OK) {
-
-		if (unlikely(dd->do_drop && atomic_xchg(&dd->drop_packet,
-			DROP_PACKET_OFF) == DROP_PACKET_ON)) {
+		if (unlikely(dd->do_drop &&
+			     atomic_xchg(&dd->drop_packet, DROP_PACKET_OFF) ==
+			     DROP_PACKET_ON)) {
 			dd->do_drop = 0;
 
 			/* On to the next packet */
@@ -990,8 +991,7 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 			if (seq != rcd->seq_cnt)
 				last = RCV_PKT_DONE;
 			if (needset) {
-				dd_dev_info(dd,
-					"Switching to NO_DMA_RTAIL\n");
+				dd_dev_info(dd, "Switching to NO_DMA_RTAIL\n");
 				set_all_nodma_rtail(dd);
 				needset = 0;
 			}
@@ -1234,7 +1234,7 @@ void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
 	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
 		/* Need to start timer */
 		setup_timer(&ppd->led_override_timer, run_led_override,
-				(unsigned long)ppd);
+			    (unsigned long)ppd);
 
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
@@ -1271,8 +1271,8 @@ int hfi1_reset_device(int unit)
 
 	if (!dd->kregbase || !(dd->flags & HFI1_PRESENT)) {
 		dd_dev_info(dd,
-			"Invalid unit number %u or not initialized or not present\n",
-			unit);
+			    "Invalid unit number %u or not initialized or not present\n",
+			    unit);
 		ret = -ENXIO;
 		goto bail;
 	}
@@ -1302,11 +1302,11 @@ int hfi1_reset_device(int unit)
 
 	if (ret)
 		dd_dev_err(dd,
-			"Reinitialize unit %u after reset failed with %d\n",
-			unit, ret);
+			   "Reinitialize unit %u after reset failed with %d\n",
+			   unit, ret);
 	else
 		dd_dev_info(dd, "Reinitialized unit %u after resetting\n",
-			unit);
+			    unit);
 
 bail:
 	return ret;
@@ -1363,7 +1363,7 @@ int process_receive_bypass(struct hfi1_packet *packet)
 		handle_eflags(packet);
 
 	dd_dev_err(packet->rcd->dd,
-	   "Bypass packets are not supported in normal operation. Dropping\n");
+		   "Bypass packets are not supported in normal operation. Dropping\n");
 	return RHF_RCV_CONTINUE;
 }
 
@@ -1401,6 +1401,6 @@ int kdeth_process_eager(struct hfi1_packet *packet)
 int process_receive_invalid(struct hfi1_packet *packet)
 {
 	dd_dev_err(packet->rcd->dd, "Invalid packet type %d. Dropping\n",
-		rhf_rcv_type(packet->rhf));
+		   rhf_rcv_type(packet->rhf));
 	return RHF_RCV_CONTINUE;
 }
diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index d7250af..f36d06b 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -115,11 +115,9 @@ static DEFINE_MUTEX(eprom_mutex);
 static void write_enable(struct hfi1_devdata *dd)
 {
 	/* raise signal */
-	write_csr(dd, ASIC_GPIO_OUT,
-		read_csr(dd, ASIC_GPIO_OUT) | EPROM_WP_N);
+	write_csr(dd, ASIC_GPIO_OUT, read_csr(dd, ASIC_GPIO_OUT) | EPROM_WP_N);
 	/* raise enable */
-	write_csr(dd, ASIC_GPIO_OE,
-		read_csr(dd, ASIC_GPIO_OE) | EPROM_WP_N);
+	write_csr(dd, ASIC_GPIO_OE, read_csr(dd, ASIC_GPIO_OE) | EPROM_WP_N);
 }
 
 /*
@@ -128,11 +126,9 @@ static void write_enable(struct hfi1_devdata *dd)
 static void write_disable(struct hfi1_devdata *dd)
 {
 	/* lower signal */
-	write_csr(dd, ASIC_GPIO_OUT,
-		read_csr(dd, ASIC_GPIO_OUT) & ~EPROM_WP_N);
+	write_csr(dd, ASIC_GPIO_OUT, read_csr(dd, ASIC_GPIO_OUT) & ~EPROM_WP_N);
 	/* lower enable */
-	write_csr(dd, ASIC_GPIO_OE,
-		read_csr(dd, ASIC_GPIO_OE) & ~EPROM_WP_N);
+	write_csr(dd, ASIC_GPIO_OE, read_csr(dd, ASIC_GPIO_OE) & ~EPROM_WP_N);
 }
 
 /*
@@ -210,8 +206,8 @@ static int erase_range(struct hfi1_devdata *dd, u32 start, u32 len)
 	/* check the end points for the minimum erase */
 	if ((start & MASK_4KB) || (end & MASK_4KB)) {
 		dd_dev_err(dd,
-			"%s: non-aligned range (0x%x,0x%x) for a 4KB erase\n",
-			__func__, start, end);
+			   "%s: non-aligned range (0x%x,0x%x) for a 4KB erase\n",
+			   __func__, start, end);
 		return -EINVAL;
 	}
 
@@ -275,7 +271,7 @@ static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
 	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
 		read_page(dd, start + offset, buffer);
 		if (copy_to_user((void __user *)(addr + offset),
-						buffer, EP_PAGE_SIZE)) {
+				 buffer, EP_PAGE_SIZE)) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -319,7 +315,7 @@ static int write_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
 
 	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
 		if (copy_from_user(buffer, (void __user *)(addr + offset),
-						EP_PAGE_SIZE)) {
+				   EP_PAGE_SIZE)) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -385,13 +381,13 @@ int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 	ret = acquire_hw_mutex(dd);
 	if (ret) {
 		dd_dev_err(dd,
-			"%s: unable to acquire hw mutex, no EPROM support\n",
-			__func__);
+			   "%s: unable to acquire hw mutex, no EPROM support\n",
+			   __func__);
 		goto done_asic;
 	}
 
 	dd_dev_info(dd, "%s: cmd: type %d, len 0x%x, addr 0x%016llx\n",
-		__func__, cmd->type, cmd->len, cmd->addr);
+		    __func__, cmd->type, cmd->len, cmd->addr);
 
 	switch (cmd->type) {
 	case HFI1_CMD_EP_INFO:
@@ -402,7 +398,7 @@ int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 		dev_id = read_device_id(dd);
 		/* addr points to a u32 user buffer */
 		if (copy_to_user((void __user *)cmd->addr, &dev_id,
-								sizeof(u32)))
+				 sizeof(u32)))
 			ret = -EFAULT;
 		break;
 
@@ -430,7 +426,7 @@ int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 
 	default:
 		dd_dev_err(dd, "%s: unexpected command %d\n",
-			__func__, cmd->type);
+			   __func__, cmd->type);
 		ret = -EINVAL;
 		break;
 	}
@@ -464,19 +460,18 @@ int eprom_init(struct hfi1_devdata *dd)
 	ret = acquire_hw_mutex(dd);
 	if (ret) {
 		dd_dev_err(dd,
-			"%s: unable to acquire hw mutex, no EPROM support\n",
-			__func__);
+			   "%s: unable to acquire hw mutex, no EPROM support\n",
+			   __func__);
 		goto done_asic;
 	}
 
 	/* reset EPROM to be sure it is in a good state */
 
 	/* set reset */
-	write_csr(dd, ASIC_EEP_CTL_STAT,
-					ASIC_EEP_CTL_STAT_EP_RESET_SMASK);
+	write_csr(dd, ASIC_EEP_CTL_STAT, ASIC_EEP_CTL_STAT_EP_RESET_SMASK);
 	/* clear reset, set speed */
 	write_csr(dd, ASIC_EEP_CTL_STAT,
-			EP_SPEED_FULL << ASIC_EEP_CTL_STAT_RATE_SPI_SHIFT);
+		  EP_SPEED_FULL << ASIC_EEP_CTL_STAT_RATE_SPI_SHIFT);
 
 	/* wake the device with command "release powerdown NoID" */
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_RELEASE_POWERDOWN_NOID);
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index c4b9dd4..1bd1545 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1145,9 +1145,9 @@ static int user_init(struct file *fp)
 	 * has done it.
 	 */
 	if (fd->subctxt) {
-		ret = wait_event_interruptible(uctxt->wait,
-			!test_bit(HFI1_CTXT_MASTER_UNINIT,
-			&uctxt->event_flags));
+		ret = wait_event_interruptible(uctxt->wait, !test_bit(
+					       HFI1_CTXT_MASTER_UNINIT,
+					       &uctxt->event_flags));
 		goto expected;
 	}
 
@@ -1592,7 +1592,7 @@ static loff_t ui_lseek(struct file *filp, loff_t offset, int whence)
 
 /* NOTE: assumes unsigned long is 8 bytes */
 static ssize_t ui_read(struct file *filp, char __user *buf, size_t count,
-			loff_t *f_pos)
+		       loff_t *f_pos)
 {
 	struct hfi1_devdata *dd = filp->private_data;
 	void __iomem *base = dd->kregbase;
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 3a7163d..52a3e8c 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -382,8 +382,8 @@ static int invalid_header(struct hfi1_devdata *dd, const char *what,
 		return 0;
 
 	dd_dev_err(dd,
-		"invalid firmware header field %s: expected 0x%x, actual 0x%x\n",
-		what, expected, actual);
+		   "invalid firmware header field %s: expected 0x%x, actual 0x%x\n",
+		   what, expected, actual);
 	return 1;
 }
 
@@ -393,13 +393,19 @@ static int invalid_header(struct hfi1_devdata *dd, const char *what,
 static int verify_css_header(struct hfi1_devdata *dd, struct css_header *css)
 {
 	/* verify CSS header fields (most sizes are in DW, so add /4) */
-	if (invalid_header(dd, "module_type", css->module_type, CSS_MODULE_TYPE) ||
-	    invalid_header(dd, "header_len", css->header_len, (sizeof(struct firmware_file) / 4)) ||
-	    invalid_header(dd, "header_version", css->header_version, CSS_HEADER_VERSION) ||
-	    invalid_header(dd, "module_vendor", css->module_vendor, CSS_MODULE_VENDOR) ||
+	if (invalid_header(dd, "module_type", css->module_type,
+			   CSS_MODULE_TYPE) ||
+	    invalid_header(dd, "header_len", css->header_len,
+			   (sizeof(struct firmware_file) / 4)) ||
+	    invalid_header(dd, "header_version", css->header_version,
+			   CSS_HEADER_VERSION) ||
+	    invalid_header(dd, "module_vendor", css->module_vendor,
+			   CSS_MODULE_VENDOR) ||
 	    invalid_header(dd, "key_size", css->key_size, KEY_SIZE / 4) ||
-	    invalid_header(dd, "modulus_size", css->modulus_size, KEY_SIZE / 4) ||
-	    invalid_header(dd, "exponent_size", css->exponent_size, EXPONENT_SIZE / 4)) {
+	    invalid_header(dd, "modulus_size", css->modulus_size,
+			   KEY_SIZE / 4) ||
+	    invalid_header(dd, "exponent_size", css->exponent_size,
+			   EXPONENT_SIZE / 4)) {
 		return -EINVAL;
 	}
 	return 0;
@@ -414,8 +420,8 @@ static int payload_check(struct hfi1_devdata *dd, const char *name,
 	/* make sure we have some payload */
 	if (prefix_size >= file_size) {
 		dd_dev_err(dd,
-			"firmware \"%s\", size %ld, must be larger than %ld bytes\n",
-			name, file_size, prefix_size);
+			   "firmware \"%s\", size %ld, must be larger than %ld bytes\n",
+			   name, file_size, prefix_size);
 		return -EINVAL;
 	}
 
@@ -491,7 +497,7 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 
 		/* make sure there are bytes in the payload */
 		ret = payload_check(dd, name, fdet->fw->size,
-						sizeof(struct firmware_file));
+				    sizeof(struct firmware_file));
 		if (ret == 0) {
 			fdet->css_header = css;
 			fdet->modulus = ff->modulus;
@@ -516,7 +522,7 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 
 		/* make sure there are bytes in the payload */
 		ret = payload_check(dd, name, fdet->fw->size,
-					sizeof(struct augmented_firmware_file));
+				    sizeof(struct augmented_firmware_file));
 		if (ret == 0) {
 			fdet->css_header = css;
 			fdet->modulus = aff->modulus;
@@ -531,9 +537,10 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 	} else {
 		/* css->size check failed */
 		dd_dev_err(dd,
-			"invalid firmware header field size: expected 0x%lx or 0x%lx, actual 0x%x\n",
-			fdet->fw->size / 4, (fdet->fw->size - AUGMENT_SIZE) / 4,
-			css->size);
+			   "invalid firmware header field size: expected 0x%lx or 0x%lx, actual 0x%x\n",
+			   fdet->fw->size / 4,
+			   (fdet->fw->size - AUGMENT_SIZE) / 4,
+			   css->size);
 
 		ret = -EINVAL;
 	}
@@ -696,7 +703,7 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 	if (platform_config_load) {
 		platform_config = NULL;
 		err = request_firmware(&platform_config, platform_config_name,
-						&dd->pcidev->dev);
+				       &dd->pcidev->dev);
 		if (err) {
 			platform_config = NULL;
 			goto done;
@@ -837,7 +844,7 @@ static int run_rsa(struct hfi1_devdata *dd, const char *who,
 			     >> MISC_CFG_FW_CTRL_RSA_STATUS_SHIFT;
 	if (status != RSA_STATUS_IDLE) {
 		dd_dev_err(dd, "%s security engine not idle - giving up\n",
-			who);
+			   who);
 		return -EBUSY;
 	}
 
@@ -874,7 +881,7 @@ static int run_rsa(struct hfi1_devdata *dd, const char *who,
 		if (status == RSA_STATUS_IDLE) {
 			/* should not happen */
 			dd_dev_err(dd, "%s firmware security bad idle state\n",
-				who);
+				   who);
 			ret = -EINVAL;
 			break;
 		} else if (status == RSA_STATUS_DONE) {
@@ -908,8 +915,8 @@ static int run_rsa(struct hfi1_devdata *dd, const char *who,
 	 * is not keeping the error high.
 	 */
 	write_csr(dd, MISC_ERR_CLEAR,
-			MISC_ERR_STATUS_MISC_FW_AUTH_FAILED_ERR_SMASK
-			| MISC_ERR_STATUS_MISC_KEY_MISMATCH_ERR_SMASK);
+		  MISC_ERR_STATUS_MISC_FW_AUTH_FAILED_ERR_SMASK |
+		  MISC_ERR_STATUS_MISC_KEY_MISMATCH_ERR_SMASK);
 	/*
 	 * All that is left are the current errors.  Print warnings on
 	 * authorization failure details, if any.  Firmware authorization
@@ -938,7 +945,8 @@ static void load_security_variables(struct hfi1_devdata *dd,
 	write_rsa_data(dd, MISC_CFG_RSA_MU, fdet->mu, MU_SIZE);
 	/* Security variables d.  Write the header */
 	write_streamed_rsa_data(dd, MISC_CFG_SHA_PRELOAD,
-			(u8 *)fdet->css_header, sizeof(struct css_header));
+				(u8 *)fdet->css_header,
+				sizeof(struct css_header));
 }
 
 /* return the 8051 firmware state */
@@ -1018,7 +1026,7 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 
 	/* Firmware load steps 3-5 */
 	ret = write_8051(dd, 1/*code*/, 0, fdet->firmware_ptr,
-							fdet->firmware_len);
+			 fdet->firmware_len);
 	if (ret)
 		return ret;
 
@@ -1045,13 +1053,13 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 	ret = wait_fm_ready(dd, TIMEOUT_8051_START);
 	if (ret) { /* timed out */
 		dd_dev_err(dd, "8051 start timeout, current state 0x%x\n",
-			get_firmware_state(dd));
+			   get_firmware_state(dd));
 		return -ETIMEDOUT;
 	}
 
 	read_misc_status(dd, &ver_a, &ver_b);
 	dd_dev_info(dd, "8051 firmware version %d.%d\n",
-		(int)ver_b, (int)ver_a);
+		    (int)ver_b, (int)ver_a);
 	dd->dc8051_ver = dc8051_ver(ver_b, ver_a);
 
 	return 0;
@@ -1066,11 +1074,11 @@ void sbus_request(struct hfi1_devdata *dd,
 		  u8 receiver_addr, u8 data_addr, u8 command, u32 data_in)
 {
 	write_csr(dd, ASIC_CFG_SBUS_REQUEST,
-		((u64)data_in << ASIC_CFG_SBUS_REQUEST_DATA_IN_SHIFT)
-		| ((u64)command << ASIC_CFG_SBUS_REQUEST_COMMAND_SHIFT)
-		| ((u64)data_addr << ASIC_CFG_SBUS_REQUEST_DATA_ADDR_SHIFT)
-		| ((u64)receiver_addr
-			<< ASIC_CFG_SBUS_REQUEST_RECEIVER_ADDR_SHIFT));
+		  ((u64)data_in << ASIC_CFG_SBUS_REQUEST_DATA_IN_SHIFT) |
+		  ((u64)command << ASIC_CFG_SBUS_REQUEST_COMMAND_SHIFT) |
+		  ((u64)data_addr << ASIC_CFG_SBUS_REQUEST_DATA_ADDR_SHIFT) |
+		  ((u64)receiver_addr <<
+		   ASIC_CFG_SBUS_REQUEST_RECEIVER_ADDR_SHIFT));
 }
 
 /*
@@ -1088,14 +1096,14 @@ static void turn_off_spicos(struct hfi1_devdata *dd, int flags)
 		return;
 
 	dd_dev_info(dd, "Turning off spicos:%s%s\n",
-		flags & SPICO_SBUS ? " SBus" : "",
-		flags & SPICO_FABRIC ? " fabric" : "");
+		    flags & SPICO_SBUS ? " SBus" : "",
+		    flags & SPICO_FABRIC ? " fabric" : "");
 
 	write_csr(dd, MISC_CFG_FW_CTRL, ENABLE_SPICO_SMASK);
 	/* disable SBus spico */
 	if (flags & SPICO_SBUS)
 		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
-			WRITE_SBUS_RECEIVER, 0x00000040);
+			     WRITE_SBUS_RECEIVER, 0x00000040);
 
 	/* disable the fabric serdes spicos */
 	if (flags & SPICO_FABRIC)
@@ -1222,7 +1230,7 @@ static int load_fabric_serdes_firmware(struct hfi1_devdata *dd,
 	/* step 5: download SerDes machine code */
 	for (i = 0; i < fdet->firmware_len; i += 4) {
 		sbus_request(dd, ra, 0x0a, WRITE_SBUS_RECEIVER,
-					*(u32 *)&fdet->firmware_ptr[i]);
+			     *(u32 *)&fdet->firmware_ptr[i]);
 	}
 	/* step 6: IMEM override off */
 	sbus_request(dd, ra, 0x00, WRITE_SBUS_RECEIVER, 0x00000000);
@@ -1261,7 +1269,7 @@ static int load_sbus_firmware(struct hfi1_devdata *dd,
 	/* step 5: download the SBus Master machine code */
 	for (i = 0; i < fdet->firmware_len; i += 4) {
 		sbus_request(dd, ra, 0x14, WRITE_SBUS_RECEIVER,
-					*(u32 *)&fdet->firmware_ptr[i]);
+			     *(u32 *)&fdet->firmware_ptr[i]);
 	}
 	/* step 6: set IMEM_CNTL_EN off */
 	sbus_request(dd, ra, 0x01, WRITE_SBUS_RECEIVER, 0x00000040);
@@ -1300,7 +1308,7 @@ static int load_pcie_serdes_firmware(struct hfi1_devdata *dd,
 	 */
 	for (i = 0; i < fdet->firmware_len; i += 4) {
 		sbus_request(dd, ra, 0x04, WRITE_SBUS_RECEIVER,
-					*(u32 *)&fdet->firmware_ptr[i]);
+			     *(u32 *)&fdet->firmware_ptr[i]);
 	}
 	/* step 5: disable XDMEM access */
 	sbus_request(dd, ra, 0x01, WRITE_SBUS_RECEIVER, 0x00000140);
@@ -1334,7 +1342,7 @@ static void set_serdes_broadcast(struct hfi1_devdata *dd, u8 bg1, u8 bg2,
 		 *	23:16	BROADCAST_GROUP_2 (default 0xff)
 		 */
 		sbus_request(dd, addrs[count], 0xfd, WRITE_SBUS_RECEIVER,
-				(u32)bg1 << 4 | (u32)bg2 << 16);
+			     (u32)bg1 << 4 | (u32)bg2 << 16);
 	}
 }
 
@@ -1359,8 +1367,8 @@ retry:
 
 	/* timed out */
 	dd_dev_err(dd,
-		"Unable to acquire hardware mutex, mutex mask %u, my mask %u (%s)\n",
-		(u32)user, (u32)mask, (try == 0) ? "retrying" : "giving up");
+		   "Unable to acquire hardware mutex, mutex mask %u, my mask %u (%s)\n",
+		   (u32)user, (u32)mask, (try == 0) ? "retrying" : "giving up");
 
 	if (try == 0) {
 		/* break mutex and retry */
@@ -1380,7 +1388,7 @@ void release_hw_mutex(struct hfi1_devdata *dd)
 void set_sbus_fast_mode(struct hfi1_devdata *dd)
 {
 	write_csr(dd, ASIC_CFG_SBUS_EXECUTE,
-				ASIC_CFG_SBUS_EXECUTE_FAST_MODE_SMASK);
+		  ASIC_CFG_SBUS_EXECUTE_FAST_MODE_SMASK);
 }
 
 void clear_sbus_fast_mode(struct hfi1_devdata *dd)
@@ -1410,9 +1418,9 @@ int load_firmware(struct hfi1_devdata *dd)
 		set_sbus_fast_mode(dd);
 
 		set_serdes_broadcast(dd, all_fabric_serdes_broadcast,
-				fabric_serdes_broadcast[dd->hfi1_id],
-				fabric_serdes_addrs[dd->hfi1_id],
-				NUM_FABRIC_SERDES);
+				     fabric_serdes_broadcast[dd->hfi1_id],
+				     fabric_serdes_addrs[dd->hfi1_id],
+				     NUM_FABRIC_SERDES);
 		turn_off_spicos(dd, SPICO_FABRIC);
 		do {
 			ret = load_fabric_serdes_firmware(dd, &fw_fabric);
@@ -1551,8 +1559,8 @@ int parse_platform_config(struct hfi1_devdata *dd)
 		header2 = *(ptr + 1);
 		if (header1 != ~header2) {
 			dd_dev_info(dd, "%s: Failed validation at offset %ld\n",
-				__func__, (ptr -
-					   (u32 *)dd->platform_config.data));
+				    __func__, (ptr - (u32 *)
+					       dd->platform_config.data));
 			goto bail;
 		}
 
@@ -1595,9 +1603,10 @@ int parse_platform_config(struct hfi1_devdata *dd)
 				break;
 			default:
 				dd_dev_info(dd,
-				      "%s: Unknown data table %d, offset %ld\n",
-					__func__, table_type,
-				       (ptr - (u32 *)dd->platform_config.data));
+					    "%s: Unknown data table %d, offset %ld\n",
+					    __func__, table_type,
+					    (ptr - (u32 *)
+					     dd->platform_config.data));
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table = ptr;
@@ -1630,7 +1639,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 
 		/* Calculate and check table crc */
 		crc = crc32_le(~(u32)0, (unsigned char const *)ptr,
-				(table_length_dwords * 4));
+			       (table_length_dwords * 4));
 		crc ^= ~(u32)0;
 
 		/* Jump the table */
@@ -1654,7 +1663,8 @@ bail:
 }
 
 static int get_platform_fw_field_metadata(struct hfi1_devdata *dd, int table,
-		int field, u32 *field_len_bits, u32 *field_start_bits)
+					  int field, u32 *field_len_bits,
+					  u32 *field_start_bits)
 {
 	struct platform_config_cache *pcfgcache = &dd->pcfg_cache;
 	u32 *src_ptr = NULL;
@@ -1714,8 +1724,9 @@ static int get_platform_fw_field_metadata(struct hfi1_devdata *dd, int table,
  * @len: length of memory pointed by @data in bytes.
  */
 int get_platform_config_field(struct hfi1_devdata *dd,
-			enum platform_config_table_type_encoding table_type,
-			int table_index, int field_index, u32 *data, u32 len)
+			      enum platform_config_table_type_encoding
+			      table_type, int table_index, int field_index,
+			      u32 *data, u32 len)
 {
 	int ret = 0, wlen = 0, seek = 0;
 	u32 field_len_bits = 0, field_start_bits = 0, *src_ptr = NULL;
@@ -1727,7 +1738,8 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 		return -EINVAL;
 
 	ret = get_platform_fw_field_metadata(dd, table_type, field_index,
-					&field_len_bits, &field_start_bits);
+					     &field_len_bits,
+					     &field_start_bits);
 	if (ret)
 		return -EINVAL;
 
@@ -1817,9 +1829,9 @@ int load_pcie_firmware(struct hfi1_devdata *dd)
 	if (fw_pcie_serdes_load) {
 		dd_dev_info(dd, "Setting PCIe SerDes broadcast\n");
 		set_serdes_broadcast(dd, all_pcie_serdes_broadcast,
-					pcie_serdes_broadcast[dd->hfi1_id],
-					pcie_serdes_addrs[dd->hfi1_id],
-					NUM_PCIE_SERDES);
+				     pcie_serdes_broadcast[dd->hfi1_id],
+				     pcie_serdes_addrs[dd->hfi1_id],
+				     NUM_PCIE_SERDES);
 		do {
 			ret = load_pcie_serdes_firmware(dd, &fw_pcie);
 		} while (retry_firmware(dd, ret));
@@ -1844,5 +1856,5 @@ void read_guid(struct hfi1_devdata *dd)
 
 	dd->base_guid = read_csr(dd, DC_DC8051_CFG_LOCAL_GUID);
 	dd_dev_info(dd, "GUID %llx",
-		(unsigned long long)dd->base_guid);
+		    (unsigned long long)dd->base_guid);
 }
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 4db5ad9..07df515 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1715,8 +1715,9 @@ void restore_pci_variables(struct hfi1_devdata *dd);
 int do_pcie_gen3_transition(struct hfi1_devdata *dd);
 int parse_platform_config(struct hfi1_devdata *dd);
 int get_platform_config_field(struct hfi1_devdata *dd,
-			enum platform_config_table_type_encoding table_type,
-			int table_index, int field_index, u32 *data, u32 len);
+			      enum platform_config_table_type_encoding
+			      table_type, int table_index, int field_index,
+			      u32 *data, u32 len);
 
 const char *get_unit_name(int unit);
 const char *get_card_name(struct rvt_dev_info *rdi);
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index f794604..a721059 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -149,7 +149,7 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		rcd = hfi1_create_ctxtdata(ppd, i, dd->node);
 		if (!rcd) {
 			dd_dev_err(dd,
-				"Unable to allocate kernel receive context, failing\n");
+				   "Unable to allocate kernel receive context, failing\n");
 			goto nomem;
 		}
 		/*
@@ -170,7 +170,7 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		rcd->sc = sc_alloc(dd, SC_ACK, rcd->rcvhdrqentsize, dd->node);
 		if (!rcd->sc) {
 			dd_dev_err(dd,
-				"Unable to allocate kernel send context, failing\n");
+				   "Unable to allocate kernel send context, failing\n");
 			dd->rcd[rcd->ctxt] = NULL;
 			hfi1_free_ctxtdata(dd, rcd);
 			goto nomem;
@@ -741,7 +741,7 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 			lastfail = hfi1_setup_eagerbufs(rcd);
 		if (lastfail)
 			dd_dev_err(dd,
-				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
+				   "failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
 	}
 	if (lastfail)
 		ret = lastfail;
@@ -797,8 +797,8 @@ done:
 			lastfail = bringup_serdes(ppd);
 			if (lastfail)
 				dd_dev_info(dd,
-					"Failed to bring up port %u\n",
-					ppd->port);
+					    "Failed to bring up port %u\n",
+					    ppd->port);
 
 			/*
 			 * Set status even if port serdes is not initialized
@@ -1542,8 +1542,8 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 
 		if (!rcd->rcvhdrq) {
 			dd_dev_err(dd,
-				"attempt to allocate %d bytes for ctxt %u rcvhdrq failed\n",
-				amt, rcd->ctxt);
+				   "attempt to allocate %d bytes for ctxt %u rcvhdrq failed\n",
+				   amt, rcd->ctxt);
 			goto bail;
 		}
 
@@ -1587,8 +1587,8 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 
 bail_free:
 	dd_dev_err(dd,
-		"attempt to allocate 1 page for ctxt %u rcvhdrqtailaddr failed\n",
-		rcd->ctxt);
+		   "attempt to allocate 1 page for ctxt %u rcvhdrqtailaddr failed\n",
+		   rcd->ctxt);
 	vfree(rcd->user_event_mask);
 	rcd->user_event_mask = NULL;
 	dma_free_coherent(&dd->pcidev->dev, amt, rcd->rcvhdrq,
@@ -1678,7 +1678,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			if (rcd->egrbufs.rcvtid_size == round_mtu ||
 			    !HFI1_CAP_KGET_MASK(rcd->flags, MULTI_PKT_EGR)) {
 				dd_dev_err(dd, "ctxt%u: Failed to allocate eager buffers\n",
-					rcd->ctxt);
+					   rcd->ctxt);
 				goto bail_rcvegrbuf_phys;
 			}
 
@@ -1760,14 +1760,14 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 
 	for (idx = 0; idx < rcd->egrbufs.alloced; idx++) {
 		hfi1_put_tid(dd, rcd->eager_base + idx, PT_EAGER,
-			      rcd->egrbufs.rcvtids[idx].phys, order);
+			     rcd->egrbufs.rcvtids[idx].phys, order);
 		cond_resched();
 	}
 	goto bail;
 
 bail_rcvegrbuf_phys:
 	for (idx = 0; idx < rcd->egrbufs.alloced &&
-		     rcd->egrbufs.buffers[idx].addr;
+	     rcd->egrbufs.buffers[idx].addr;
 	     idx++) {
 		dma_free_coherent(&dd->pcidev->dev,
 				  rcd->egrbufs.buffers[idx].len,
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 03cebae..46eeeca 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -135,18 +135,16 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 			set_up_vl15(dd, dd->vau, dd->vl15_init);
 			assign_remote_cm_au_table(dd, dd->vcu);
 			ppd->neighbor_guid =
-				read_csr(dd,
-					DC_DC8051_STS_REMOTE_GUID);
+				read_csr(dd, DC_DC8051_STS_REMOTE_GUID);
 			ppd->neighbor_type =
 				read_csr(dd, DC_DC8051_STS_REMOTE_NODE_TYPE) &
 					DC_DC8051_STS_REMOTE_NODE_TYPE_VAL_MASK;
 			ppd->neighbor_port_number =
 				read_csr(dd, DC_DC8051_STS_REMOTE_PORT_NO) &
-					DC_DC8051_STS_REMOTE_PORT_NO_VAL_SMASK;
-			dd_dev_info(dd,
-				"Neighbor GUID: %llx Neighbor type %d\n",
-				ppd->neighbor_guid,
-				ppd->neighbor_type);
+					 DC_DC8051_STS_REMOTE_PORT_NO_VAL_SMASK;
+			dd_dev_info(dd, "Neighbor GUID: %llx Neighbor type %d\n",
+				    ppd->neighbor_guid,
+				    ppd->neighbor_type);
 		}
 
 		/* physical link went up */
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 13cf66f..7619b75 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -535,7 +535,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	ibp = &ppd->ibport_data;
 
 	if (ppd->vls_supported / 2 > ARRAY_SIZE(pi->neigh_mtu.pvlx_to_mtu) ||
-		ppd->vls_supported > ARRAY_SIZE(dd->vld)) {
+	    ppd->vls_supported > ARRAY_SIZE(dd->vld)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
@@ -981,9 +981,8 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
 			link_state = HLS_DN_DOWNDEF;
 		else if (phys_state == IB_PORTPHYSSTATE_POLLING) {
 			link_state = HLS_DN_POLL;
-			set_link_down_reason(ppd,
-			     OPA_LINKDOWN_REASON_FM_BOUNCE, 0,
-			     OPA_LINKDOWN_REASON_FM_BOUNCE);
+			set_link_down_reason(ppd, OPA_LINKDOWN_REASON_FM_BOUNCE,
+					     0, OPA_LINKDOWN_REASON_FM_BOUNCE);
 		} else if (phys_state == IB_PORTPHYSSTATE_DISABLED)
 			link_state = HLS_DN_DISABLE;
 		else {
@@ -1102,7 +1101,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 
 	/* Must be a valid unicast LID address. */
 	if ((lid == 0 && ls_old > IB_PORT_INIT) ||
-	     lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
+	    lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		pr_warn("SubnSet(OPA_PortInfo) lid invalid 0x%x\n",
 			lid);
@@ -1135,7 +1134,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 
 	/* Must be a valid unicast LID address. */
 	if ((smlid == 0 && ls_old > IB_PORT_INIT) ||
-	     smlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
+	    smlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		pr_warn("SubnSet(OPA_PortInfo) smlid invalid 0x%x\n", smlid);
 	} else if (smlid != ibp->rvp.sm_lid || msl != ibp->rvp.sm_sl) {
@@ -1185,7 +1184,9 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	if (lwe == OPA_LINK_WIDTH_RESET ||
 	    lwe == OPA_LINK_WIDTH_RESET_OLD) {
 		set_link_width_downgrade_enabled(ppd,
-				ppd->link_width_downgrade_supported);
+						 ppd->
+						 link_width_downgrade_supported
+						 );
 	} else if ((lwe & ~ppd->link_width_downgrade_supported) == 0) {
 		/* only set and apply if something changed */
 		if (lwe != ppd->link_width_downgrade_enabled) {
@@ -1210,16 +1211,17 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 				    ibp->rvp.vl_high_limit);
 
 	if (ppd->vls_supported / 2 > ARRAY_SIZE(pi->neigh_mtu.pvlx_to_mtu) ||
-		ppd->vls_supported > ARRAY_SIZE(dd->vld)) {
+	    ppd->vls_supported > ARRAY_SIZE(dd->vld)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
 	for (i = 0; i < ppd->vls_supported; i++) {
 		if ((i % 2) == 0)
-			mtu = enum_to_mtu((pi->neigh_mtu.pvlx_to_mtu[i / 2] >> 4)
-					  & 0xF);
+			mtu = enum_to_mtu((pi->neigh_mtu.pvlx_to_mtu[i / 2] >>
+					   4) & 0xF);
 		else
-			mtu = enum_to_mtu(pi->neigh_mtu.pvlx_to_mtu[i / 2] & 0xF);
+			mtu = enum_to_mtu(pi->neigh_mtu.pvlx_to_mtu[i / 2] &
+					  0xF);
 		if (mtu == 0xffff) {
 			pr_warn("SubnSet(OPA_PortInfo) mtu invalid %d (0x%x)\n",
 				mtu,
@@ -1229,8 +1231,8 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 		}
 		if (dd->vld[i].mtu != mtu) {
 			dd_dev_info(dd,
-				"MTU change on vl %d from %d to %d\n",
-				i, dd->vld[i].mtu, mtu);
+				    "MTU change on vl %d from %d to %d\n",
+				    i, dd->vld[i].mtu, mtu);
 			dd->vld[i].mtu = mtu;
 			call_set_mtu++;
 		}
@@ -1243,8 +1245,8 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 		mtu = 2048;
 	if (dd->vld[15].mtu != mtu) {
 		dd_dev_info(dd,
-			"MTU change on vl 15 from %d to %d\n",
-			dd->vld[15].mtu, mtu);
+			    "MTU change on vl 15 from %d to %d\n",
+			    dd->vld[15].mtu, mtu);
 		dd->vld[15].mtu = mtu;
 		call_set_mtu++;
 	}
@@ -1260,7 +1262,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 			smp->status |= IB_SMP_INVALID_FIELD;
 		} else {
 			if (hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_OP_VLS,
-						vls) == -EINVAL)
+					    vls) == -EINVAL)
 				smp->status |= IB_SMP_INVALID_FIELD;
 		}
 	}
@@ -1806,7 +1808,7 @@ static int __subn_get_opa_cable_info(struct opa_smp *smp, u32 am, u8 *data,
 	 * addr and (addr + len - 1) are on the same "page"
 	 */
 	if (addr >= 4096 ||
-		(__CI_PAGE_NUM(addr) != __CI_PAGE_NUM(addr + len - 1))) {
+	    (__CI_PAGE_NUM(addr) != __CI_PAGE_NUM(addr + len - 1))) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
@@ -2271,7 +2273,7 @@ enum error_info_selects {
 };
 
 static int pma_get_opa_classportinfo(struct opa_pma_mad *pmp,
-				struct ib_device *ibdev, u32 *resp_len)
+				     struct ib_device *ibdev, u32 *resp_len)
 {
 	struct opa_class_port_info *p =
 		(struct opa_class_port_info *)pmp->data;
@@ -2320,7 +2322,8 @@ static void a0_portstatus(struct hfi1_pportdata *ppd,
 }
 
 static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
-			struct ib_device *ibdev, u8 port, u32 *resp_len)
+				  struct ib_device *ibdev,
+				  u8 port, u32 *resp_len)
 {
 	struct opa_port_status_req *req =
 		(struct opa_port_status_req *)pmp->data;
@@ -2376,7 +2379,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 					 CNTR_INVALID_VL));
 	rsp->port_multicast_xmit_pkts =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_MC_XMIT_PKTS,
-					CNTR_INVALID_VL));
+					  CNTR_INVALID_VL));
 	rsp->port_multicast_rcv_pkts =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_MC_RCV_PKTS,
 					  CNTR_INVALID_VL));
@@ -2405,7 +2408,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	}
 	tmp = read_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL);
 	tmp2 = tmp + read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
-					CNTR_INVALID_VL);
+				   CNTR_INVALID_VL);
 	if (tmp2 > (u32)UINT_MAX || tmp2 < tmp) {
 		/* overflow/wrapped */
 		rsp->link_error_recovery = cpu_to_be32(~0);
@@ -2420,7 +2423,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 		cpu_to_be64(read_dev_cntr(dd, C_DC_FM_CFG_ERR,
 					  CNTR_INVALID_VL));
 	rsp->link_downed = cpu_to_be32(read_port_cntr(ppd, C_SW_LINK_DOWN,
-					  CNTR_INVALID_VL));
+						      CNTR_INVALID_VL));
 
 	/* rsp->uncorrectable_errors is 8 bits wide, and it pegs at 0xff */
 	tmp = read_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL);
@@ -2442,27 +2445,27 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 
 		rsp->vls[vfi].port_vl_rcv_pkts =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RX_PKT_VL,
-					idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_xmit_data =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_FLIT_VL,
-					idx_from_vl(vl)));
+						   idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_xmit_pkts =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_PKT_VL,
-					idx_from_vl(vl)));
+						   idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_xmit_wait =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_WAIT_VL,
-					idx_from_vl(vl)));
+						   idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_rcv_fecn =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FCN_VL,
-					idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_rcv_becn =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BCN_VL,
-					idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 
 		vlinfo++;
 		vfi++;
@@ -2492,7 +2495,7 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
 	error_counter_summary += read_port_cntr(ppd, C_SW_XMIT_CSTR_ERR,
 						CNTR_INVALID_VL);
 	error_counter_summary += read_dev_cntr(dd, C_DC_RMT_PHY_ERR,
-						CNTR_INVALID_VL);
+					       CNTR_INVALID_VL);
 	/* local link integrity must be right-shifted by the lli resolution */
 	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
 	tmp += read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
@@ -2502,10 +2505,10 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
 	tmp += read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT, CNTR_INVALID_VL);
 	error_counter_summary += (tmp >> res_ler);
 	error_counter_summary += read_dev_cntr(dd, C_DC_RCV_ERR,
-						CNTR_INVALID_VL);
+					       CNTR_INVALID_VL);
 	error_counter_summary += read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL);
 	error_counter_summary += read_dev_cntr(dd, C_DC_FM_CFG_ERR,
-						CNTR_INVALID_VL);
+					       CNTR_INVALID_VL);
 	/* ppd->link_downed is a 32-bit value */
 	error_counter_summary += read_port_cntr(ppd, C_SW_LINK_DOWN,
 						CNTR_INVALID_VL);
@@ -2563,7 +2566,8 @@ static void pma_get_opa_port_dctrs(struct ib_device *ibdev,
 }
 
 static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
-			struct ib_device *ibdev, u8 port, u32 *resp_len)
+				    struct ib_device *ibdev,
+				    u8 port, u32 *resp_len)
 {
 	struct opa_port_data_counters_msg *req =
 		(struct opa_port_data_counters_msg *)pmp->data;
@@ -2650,35 +2654,35 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	 * any additional checks for vl.
 	 */
 	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-		 8 * sizeof(req->vl_select_mask)) {
+			 8 * sizeof(req->vl_select_mask)) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		rsp->vls[vfi].port_vl_xmit_data =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_FLIT_VL,
-							idx_from_vl(vl)));
+						   idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_rcv_data =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RX_FLIT_VL,
-							idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_xmit_pkts =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_PKT_VL,
-							idx_from_vl(vl)));
+						   idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_rcv_pkts =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RX_PKT_VL,
-							idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_xmit_wait =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_WAIT_VL,
-							idx_from_vl(vl)));
+						   idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_rcv_fecn =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FCN_VL,
-							idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 		rsp->vls[vfi].port_vl_rcv_becn =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BCN_VL,
-							idx_from_vl(vl)));
+						  idx_from_vl(vl)));
 
 		/* rsp->port_vl_xmit_time_cong is 0 for HFIs */
 		/* rsp->port_vl_xmit_wasted_bw ??? */
@@ -2777,7 +2781,8 @@ static void pma_get_opa_port_ectrs(struct ib_device *ibdev,
 }
 
 static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
-			struct ib_device *ibdev, u8 port, u32 *resp_len)
+				  struct ib_device *ibdev,
+				  u8 port, u32 *resp_len)
 {
 	size_t response_data_size;
 	struct _port_ectrs *rsp;
@@ -2820,7 +2825,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	 */
 	port_mask = be64_to_cpu(req->port_select_mask[3]);
 	port_num = find_first_bit((unsigned long *)&port_mask,
-					sizeof(port_mask));
+				  sizeof(port_mask));
 
 	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
@@ -2842,7 +2847,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 					  CNTR_INVALID_VL));
 	rsp->fm_config_errors =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_FM_CFG_ERR,
-						CNTR_INVALID_VL));
+					  CNTR_INVALID_VL));
 	tmp = read_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL);
 
 	rsp->uncorrectable_errors = tmp < 0x100 ? (tmp & 0xff) : 0xff;
@@ -2950,7 +2955,8 @@ bail:
 }
 
 static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
-			struct ib_device *ibdev, u8 port, u32 *resp_len)
+				 struct ib_device *ibdev,
+				 u8 port, u32 *resp_len)
 {
 	size_t response_data_size;
 	struct _port_ei *rsp;
@@ -3000,9 +3006,9 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	rsp->port_rcv_ei.status_and_code =
 		dd->err_info_rcvport.status_and_code;
 	memcpy(&rsp->port_rcv_ei.ei.ei1to12.packet_flit1,
-		&dd->err_info_rcvport.packet_flit1, sizeof(u64));
+	       &dd->err_info_rcvport.packet_flit1, sizeof(u64));
 	memcpy(&rsp->port_rcv_ei.ei.ei1to12.packet_flit2,
-		&dd->err_info_rcvport.packet_flit2, sizeof(u64));
+	       &dd->err_info_rcvport.packet_flit2, sizeof(u64));
 
 	/* ExcessiverBufferOverrunInfo */
 	reg = read_csr(dd, RCV_ERR_INFO);
@@ -3047,7 +3053,8 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 }
 
 static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
-			struct ib_device *ibdev, u8 port, u32 *resp_len)
+				  struct ib_device *ibdev,
+				  u8 port, u32 *resp_len)
 {
 	struct opa_clear_port_status *req =
 		(struct opa_clear_port_status *)pmp->data;
@@ -3131,7 +3138,7 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 	if (counter_select & CS_LINK_ERROR_RECOVERY) {
 		write_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL, 0);
 		write_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
-						CNTR_INVALID_VL, 0);
+			       CNTR_INVALID_VL, 0);
 	}
 
 	if (counter_select & CS_PORT_RCV_ERRORS)
@@ -3194,7 +3201,8 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 }
 
 static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
-			struct ib_device *ibdev, u8 port, u32 *resp_len)
+				 struct ib_device *ibdev,
+				 u8 port, u32 *resp_len)
 {
 	struct _port_ei *rsp;
 	struct opa_port_error_info_msg *req;
@@ -3295,9 +3303,8 @@ static int __subn_get_opa_cong_info(struct opa_smp *smp, u32 am, u8 *data,
 }
 
 static int __subn_get_opa_cong_setting(struct opa_smp *smp, u32 am,
-					     u8 *data,
-					     struct ib_device *ibdev,
-					     u8 port, u32 *resp_len)
+				       u8 *data, struct ib_device *ibdev,
+				       u8 port, u32 *resp_len)
 {
 	int i;
 	struct opa_congestion_setting_attr *p =
@@ -3402,7 +3409,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 			continue;
 		memcpy(cong_log->events[i].local_qp_cn_entry, &cce->lqpn, 3);
 		memcpy(cong_log->events[i].remote_qp_number_cn_entry,
-			&cce->rqpn, 3);
+		       &cce->rqpn, 3);
 		cong_log->events[i].sl_svc_type_cn_entry =
 			((cce->sl & 0x1f) << 3) | (cce->svc_type & 0x7);
 		cong_log->events[i].remote_lid_cn_entry =
@@ -3584,8 +3591,8 @@ static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 
 	reg = read_csr(dd, DCC_CFG_LED_CNTRL);
 	if ((reg & DCC_CFG_LED_CNTRL_LED_CNTRL_SMASK) &&
-		((reg & DCC_CFG_LED_CNTRL_LED_SW_BLINK_RATE_SMASK) == 0xf))
-			p->rsvd_led_mask = cpu_to_be32(OPA_LED_MASK);
+	    ((reg & DCC_CFG_LED_CNTRL_LED_SW_BLINK_RATE_SMASK) == 0xf))
+		p->rsvd_led_mask = cpu_to_be32(OPA_LED_MASK);
 
 	if (resp_len)
 		*resp_len += sizeof(struct opa_led_info);
@@ -3653,7 +3660,7 @@ static int subn_get_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
 		break;
 	case OPA_ATTRIB_ID_SC_TO_VLNT_MAP:
 		ret = __subn_get_opa_sc_to_vlnt(smp, am, data, ibdev, port,
-					       resp_len);
+						resp_len);
 		break;
 	case OPA_ATTRIB_ID_PORT_STATE_INFO:
 		ret = __subn_get_opa_psi(smp, am, data, ibdev, port,
@@ -3735,7 +3742,7 @@ static int subn_set_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
 		break;
 	case OPA_ATTRIB_ID_SC_TO_VLNT_MAP:
 		ret = __subn_set_opa_sc_to_vlnt(smp, am, data, ibdev, port,
-					       resp_len);
+						resp_len);
 		break;
 	case OPA_ATTRIB_ID_PORT_STATE_INFO:
 		ret = __subn_set_opa_psi(smp, am, data, ibdev, port,
@@ -4092,10 +4099,10 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 		    port_num && port_num <= ibdev->phys_port_cnt &&
 		    port != port_num)
 			(void)check_mkey(to_iport(ibdev, port_num),
-					  (struct ib_mad_hdr *)smp, 0,
-					  smp->mkey,
-					  (__force __be32)smp->dr_slid,
-					  smp->return_path, smp->hop_cnt);
+					 (struct ib_mad_hdr *)smp, 0,
+					 smp->mkey,
+					 (__force __be32)smp->dr_slid,
+					 smp->return_path, smp->hop_cnt);
 		ret = IB_MAD_RESULT_FAILURE;
 		return ret;
 	}
@@ -4203,19 +4210,19 @@ static int process_perf_opa(struct ib_device *ibdev, u8 port,
 			break;
 		case OPA_PM_ATTRIB_ID_PORT_STATUS:
 			ret = pma_get_opa_portstatus(pmp, ibdev, port,
-								resp_len);
+						     resp_len);
 			break;
 		case OPA_PM_ATTRIB_ID_DATA_PORT_COUNTERS:
 			ret = pma_get_opa_datacounters(pmp, ibdev, port,
-								resp_len);
+						       resp_len);
 			break;
 		case OPA_PM_ATTRIB_ID_ERROR_PORT_COUNTERS:
 			ret = pma_get_opa_porterrors(pmp, ibdev, port,
-								resp_len);
+						     resp_len);
 			break;
 		case OPA_PM_ATTRIB_ID_ERROR_INFO:
 			ret = pma_get_opa_errorinfo(pmp, ibdev, port,
-								resp_len);
+						    resp_len);
 			break;
 		default:
 			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
@@ -4228,11 +4235,11 @@ static int process_perf_opa(struct ib_device *ibdev, u8 port,
 		switch (pmp->mad_hdr.attr_id) {
 		case OPA_PM_ATTRIB_ID_CLEAR_PORT_STATUS:
 			ret = pma_set_opa_portstatus(pmp, ibdev, port,
-								resp_len);
+						     resp_len);
 			break;
 		case OPA_PM_ATTRIB_ID_ERROR_INFO:
 			ret = pma_set_opa_errorinfo(pmp, ibdev, port,
-								resp_len);
+						    resp_len);
 			break;
 		default:
 			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 4d9fd3b..cbd61cf 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -217,10 +217,9 @@ int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev,
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &dd->pcie_devctl);
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL, &dd->pcie_lnkctl);
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL2,
-							&dd->pcie_devctl2);
+				  &dd->pcie_devctl2);
 	pci_read_config_dword(dd->pcidev, PCI_CFG_MSIX0, &dd->pci_msix0);
-	pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
-							&dd->pci_lnkctl3);
+	pci_read_config_dword(dd->pcidev, PCIE_CFG_SPCIE1, &dd->pci_lnkctl3);
 	pci_read_config_dword(dd->pcidev, PCIE_CFG_TPH2, &dd->pci_tph2);
 
 	return 0;
@@ -271,7 +270,7 @@ void hfi1_pcie_flr(struct hfi1_devdata *dd)
 
 clear:
 	pcie_capability_set_word(dd->pcidev, PCI_EXP_DEVCTL,
-						PCI_EXP_DEVCTL_BCR_FLR);
+				 PCI_EXP_DEVCTL_BCR_FLR);
 	/* PCIe spec requires the function to be back within 100ms */
 	msleep(100);
 }
@@ -377,8 +376,8 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &linkcap);
 	if ((linkcap & PCI_EXP_LNKCAP_SLS) != GEN3_SPEED_VECTOR) {
 		dd_dev_info(dd,
-			"This HFI is not Gen3 capable, max speed 0x%x, need 0x3\n",
-			linkcap & PCI_EXP_LNKCAP_SLS);
+			    "This HFI is not Gen3 capable, max speed 0x%x, need 0x3\n",
+			    linkcap & PCI_EXP_LNKCAP_SLS);
 		dd->link_gen3_capable = 0;
 	}
 
@@ -432,19 +431,15 @@ void hfi1_enable_intx(struct pci_dev *pdev)
 void restore_pci_variables(struct hfi1_devdata *dd)
 {
 	pci_write_config_word(dd->pcidev, PCI_COMMAND, dd->pci_command);
-	pci_write_config_dword(dd->pcidev,
-				PCI_BASE_ADDRESS_0, dd->pcibar0);
-	pci_write_config_dword(dd->pcidev,
-				PCI_BASE_ADDRESS_1, dd->pcibar1);
-	pci_write_config_dword(dd->pcidev,
-				PCI_ROM_ADDRESS, dd->pci_rom);
+	pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0, dd->pcibar0);
+	pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_1, dd->pcibar1);
+	pci_write_config_dword(dd->pcidev, PCI_ROM_ADDRESS, dd->pci_rom);
 	pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL, dd->pcie_devctl);
 	pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL, dd->pcie_lnkctl);
 	pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL2,
-							dd->pcie_devctl2);
+				   dd->pcie_devctl2);
 	pci_write_config_dword(dd->pcidev, PCI_CFG_MSIX0, dd->pci_msix0);
-	pci_write_config_dword(dd->pcidev, PCIE_CFG_SPCIE1,
-							dd->pci_lnkctl3);
+	pci_write_config_dword(dd->pcidev, PCIE_CFG_SPCIE1, dd->pci_lnkctl3);
 	pci_write_config_dword(dd->pcidev, PCIE_CFG_TPH2, dd->pci_tph2);
 }
 
@@ -746,21 +741,22 @@ static int load_eq_table(struct hfi1_devdata *dd, const u8 eq[11][3], u8 fs,
 		c0 = fs - (eq[i][PREC] / div) - (eq[i][POST] / div);
 		c_plus1 = eq[i][POST] / div;
 		pci_write_config_dword(pdev, PCIE_CFG_REG_PL102,
-			eq_value(c_minus1, c0, c_plus1));
+				       eq_value(c_minus1, c0, c_plus1));
 		/* check if these coefficients violate EQ rules */
 		pci_read_config_dword(dd->pcidev, PCIE_CFG_REG_PL105,
-								&violation);
+				      &violation);
 		if (violation
 		    & PCIE_CFG_REG_PL105_GEN3_EQ_VIOLATE_COEF_RULES_SMASK){
 			if (hit_error == 0) {
 				dd_dev_err(dd,
-					"Gen3 EQ Table Coefficient rule violations\n");
+					   "Gen3 EQ Table Coefficient rule violations\n");
 				dd_dev_err(dd, "         prec   attn   post\n");
 			}
 			dd_dev_err(dd, "   p%02d:   %02x     %02x     %02x\n",
-				i, (u32)eq[i][0], (u32)eq[i][1], (u32)eq[i][2]);
+				   i, (u32)eq[i][0], (u32)eq[i][1],
+				   (u32)eq[i][2]);
 			dd_dev_err(dd, "            %02x     %02x     %02x\n",
-				(u32)c_minus1, (u32)c0, (u32)c_plus1);
+				   (u32)c_minus1, (u32)c0, (u32)c_plus1);
 			hit_error = 1;
 		}
 	}
@@ -815,8 +811,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
 	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
 		if (pdev != dev) {
 			dd_dev_err(dd,
-				"%s: another device is on the same bus\n",
-				__func__);
+				   "%s: another device is on the same bus\n",
+				   __func__);
 			return -ENOTTY;
 		}
 
@@ -840,8 +836,8 @@ static void write_gasket_interrupt(struct hfi1_devdata *dd, int index,
 				   u16 code, u16 data)
 {
 	write_csr(dd, ASIC_PCIE_SD_INTRPT_LIST + (index * 8),
-	    (((u64)code << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_CODE_SHIFT)
-	    | ((u64)data << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_DATA_SHIFT)));
+		  (((u64)code << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_CODE_SHIFT) |
+		   ((u64)data << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_DATA_SHIFT)));
 }
 
 /*
@@ -851,14 +847,13 @@ static void arm_gasket_logic(struct hfi1_devdata *dd)
 {
 	u64 reg;
 
-	reg = (((u64)1 << dd->hfi1_id)
-			<< ASIC_PCIE_SD_HOST_CMD_INTRPT_CMD_SHIFT)
-		| ((u64)pcie_serdes_broadcast[dd->hfi1_id]
-			<< ASIC_PCIE_SD_HOST_CMD_SBUS_RCVR_ADDR_SHIFT
-		| ASIC_PCIE_SD_HOST_CMD_SBR_MODE_SMASK
-		| ((u64)SBR_DELAY_US & ASIC_PCIE_SD_HOST_CMD_TIMER_MASK)
-			<< ASIC_PCIE_SD_HOST_CMD_TIMER_SHIFT
-		);
+	reg = (((u64)1 << dd->hfi1_id) <<
+	       ASIC_PCIE_SD_HOST_CMD_INTRPT_CMD_SHIFT) |
+	      ((u64)pcie_serdes_broadcast[dd->hfi1_id] <<
+	       ASIC_PCIE_SD_HOST_CMD_SBUS_RCVR_ADDR_SHIFT |
+	       ASIC_PCIE_SD_HOST_CMD_SBR_MODE_SMASK |
+	       ((u64)SBR_DELAY_US & ASIC_PCIE_SD_HOST_CMD_TIMER_MASK) <<
+	       ASIC_PCIE_SD_HOST_CMD_TIMER_SHIFT);
 	write_csr(dd, ASIC_PCIE_SD_HOST_CMD, reg);
 	/* read back to push the write */
 	read_csr(dd, ASIC_PCIE_SD_HOST_CMD);
@@ -982,8 +977,8 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	/* if already at target speed, done (unless forced) */
 	if (dd->lbus_speed == target_speed) {
 		dd_dev_info(dd, "%s: PCIe already at gen%d, %s\n", __func__,
-			pcie_target,
-			pcie_force ? "re-doing anyway" : "skipping");
+			    pcie_target,
+			    pcie_force ? "re-doing anyway" : "skipping");
 		if (!pcie_force)
 			return 0;
 	}
@@ -1087,8 +1082,10 @@ retry:
 		default_pset = DEFAULT_MCP_PSET;
 	}
 	pci_write_config_dword(dd->pcidev, PCIE_CFG_REG_PL101,
-		(fs << PCIE_CFG_REG_PL101_GEN3_EQ_LOCAL_FS_SHIFT)
-		| (lf << PCIE_CFG_REG_PL101_GEN3_EQ_LOCAL_LF_SHIFT));
+			       (fs <<
+				PCIE_CFG_REG_PL101_GEN3_EQ_LOCAL_FS_SHIFT) |
+			       (lf <<
+				PCIE_CFG_REG_PL101_GEN3_EQ_LOCAL_LF_SHIFT));
 	ret = load_eq_table(dd, eq, fs, div);
 	if (ret)
 		goto done;
@@ -1102,15 +1099,15 @@ retry:
 		pcie_pset = default_pset;
 	if (pcie_pset > 10) {	/* valid range is 0-10, inclusive */
 		dd_dev_err(dd, "%s: Invalid Eq Pset %u, setting to %d\n",
-			__func__, pcie_pset, default_pset);
+			   __func__, pcie_pset, default_pset);
 		pcie_pset = default_pset;
 	}
 	dd_dev_info(dd, "%s: using EQ Pset %u\n", __func__, pcie_pset);
 	pci_write_config_dword(dd->pcidev, PCIE_CFG_REG_PL106,
-		((1 << pcie_pset)
-			<< PCIE_CFG_REG_PL106_GEN3_EQ_PSET_REQ_VEC_SHIFT)
-		| PCIE_CFG_REG_PL106_GEN3_EQ_EVAL2MS_DISABLE_SMASK
-		| PCIE_CFG_REG_PL106_GEN3_EQ_PHASE23_EXIT_MODE_SMASK);
+			       ((1 << pcie_pset) <<
+			PCIE_CFG_REG_PL106_GEN3_EQ_PSET_REQ_VEC_SHIFT) |
+			PCIE_CFG_REG_PL106_GEN3_EQ_EVAL2MS_DISABLE_SMASK |
+			PCIE_CFG_REG_PL106_GEN3_EQ_PHASE23_EXIT_MODE_SMASK);
 
 	/*
 	 * step 5b: Do post firmware download steps via SBus
@@ -1165,13 +1162,13 @@ retry:
 	parent = dd->pcidev->bus->self;
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL2, &lnkctl2);
 	dd_dev_info(dd, "%s: ..old link control2: 0x%x\n", __func__,
-		(u32)lnkctl2);
+		    (u32)lnkctl2);
 	/* only write to parent if target is not as high as ours */
 	if ((lnkctl2 & LNKCTL2_TARGET_LINK_SPEED_MASK) < target_vector) {
 		lnkctl2 &= ~LNKCTL2_TARGET_LINK_SPEED_MASK;
 		lnkctl2 |= target_vector;
 		dd_dev_info(dd, "%s: ..new link control2: 0x%x\n", __func__,
-			(u32)lnkctl2);
+			    (u32)lnkctl2);
 		pcie_capability_write_word(parent, PCI_EXP_LNKCTL2, lnkctl2);
 	} else {
 		dd_dev_info(dd, "%s: ..target speed is OK\n", __func__);
@@ -1180,11 +1177,11 @@ retry:
 	dd_dev_info(dd, "%s: setting target link speed\n", __func__);
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL2, &lnkctl2);
 	dd_dev_info(dd, "%s: ..old link control2: 0x%x\n", __func__,
-		(u32)lnkctl2);
+		    (u32)lnkctl2);
 	lnkctl2 &= ~LNKCTL2_TARGET_LINK_SPEED_MASK;
 	lnkctl2 |= target_vector;
 	dd_dev_info(dd, "%s: ..new link control2: 0x%x\n", __func__,
-		(u32)lnkctl2);
+		    (u32)lnkctl2);
 	pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL2, lnkctl2);
 
 	/* step 5h: arm gasket logic */
@@ -1221,8 +1218,8 @@ retry:
 	ret = pci_read_config_word(dd->pcidev, PCI_VENDOR_ID, &vendor);
 	if (ret) {
 		dd_dev_info(dd,
-			"%s: read of VendorID failed after SBR, err %d\n",
-			__func__, ret);
+			    "%s: read of VendorID failed after SBR, err %d\n",
+			    __func__, ret);
 		return_error = 1;
 		goto done;
 	}
@@ -1273,8 +1270,8 @@ retry:
 			& ASIC_PCIE_SD_HOST_STATUS_FW_DNLD_STS_MASK;
 	if ((status & (1 << dd->hfi1_id)) == 0) {
 		dd_dev_err(dd,
-			"%s: gasket status 0x%x, expecting 0x%x\n",
-			__func__, status, 1 << dd->hfi1_id);
+			   "%s: gasket status 0x%x, expecting 0x%x\n",
+			   __func__, status, 1 << dd->hfi1_id);
 		ret = -EIO;
 		goto done;
 	}
@@ -1291,13 +1288,13 @@ retry:
 	/* update our link information cache */
 	update_lbus_info(dd);
 	dd_dev_info(dd, "%s: new speed and width: %s\n", __func__,
-		dd->lbus_info);
+		    dd->lbus_info);
 
 	if (dd->lbus_speed != target_speed) { /* not target */
 		/* maybe retry */
 		do_retry = retry_count < pcie_retry;
 		dd_dev_err(dd, "PCIe link speed did not switch to Gen%d%s\n",
-			pcie_target, do_retry ? ", retrying" : "");
+			   pcie_target, do_retry ? ", retrying" : "");
 		retry_count++;
 		if (do_retry) {
 			msleep(100); /* allow time to settle */
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index 191b260..a483c0a 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -511,7 +511,7 @@ static void sc_hw_free(struct hfi1_devdata *dd, u32 sw_index, u32 hw_context)
 	sci = &dd->send_contexts[sw_index];
 	if (!sci->allocated) {
 		dd_dev_err(dd, "%s: sw_index %u not allocated? hw_context %u\n",
-			__func__, sw_index, hw_context);
+			   __func__, sw_index, hw_context);
 	}
 	sci->allocated = 0;
 	dd->hw_to_sw[hw_context] = INVALID_SCI;
@@ -627,7 +627,7 @@ void sc_set_cr_threshold(struct send_context *sc, u32 new_threshold)
 				& SC(CREDIT_CTRL_THRESHOLD_MASK))
 			   << SC(CREDIT_CTRL_THRESHOLD_SHIFT));
 		write_kctxt_csr(sc->dd, sc->hw_context,
-			SC(CREDIT_CTRL), sc->credit_ctrl);
+				SC(CREDIT_CTRL), sc->credit_ctrl);
 
 		/* force a credit return on change to avoid a possible stall */
 		force_return = 1;
@@ -765,9 +765,9 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 
 	/* set the default partition key */
 	write_kctxt_csr(dd, hw_context, SC(CHECK_PARTITION_KEY),
-		(DEFAULT_PKEY &
-			SC(CHECK_PARTITION_KEY_VALUE_MASK))
-		    << SC(CHECK_PARTITION_KEY_VALUE_SHIFT));
+			(DEFAULT_PKEY &
+			 SC(CHECK_PARTITION_KEY_VALUE_MASK)) <<
+			SC(CHECK_PARTITION_KEY_VALUE_SHIFT));
 
 	/* per context type checks */
 	if (type == SC_USER) {
@@ -780,8 +780,8 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 
 	/* set the send context check opcode mask and value */
 	write_kctxt_csr(dd, hw_context, SC(CHECK_OPCODE),
-		((u64)opmask << SC(CHECK_OPCODE_MASK_SHIFT)) |
-		((u64)opval << SC(CHECK_OPCODE_VALUE_SHIFT)));
+			((u64)opmask << SC(CHECK_OPCODE_MASK_SHIFT)) |
+			((u64)opval << SC(CHECK_OPCODE_VALUE_SHIFT)));
 
 	/* set up credit return */
 	reg = pa & SC(CREDIT_RETURN_ADDR_ADDRESS_SMASK);
@@ -799,7 +799,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 		thresh = sc_percent_to_threshold(sc, 50);
 	} else if (type == SC_USER) {
 		thresh = sc_percent_to_threshold(sc,
-				user_credit_return_threshold);
+						 user_credit_return_threshold);
 	} else { /* kernel */
 		thresh = sc_mtu_to_threshold(sc, hfi1_max_mtu, hdrqentsize);
 	}
@@ -972,11 +972,11 @@ static void sc_wait_for_packet_egress(struct send_context *sc, int pause)
 		if (loop > 500) {
 			/* timed out - bounce the link */
 			dd_dev_err(dd,
-				"%s: context %u(%u) timeout waiting for packets to egress, remaining count %u, bouncing link\n",
-				__func__, sc->sw_index,
-				sc->hw_context, (u32)reg);
+				   "%s: context %u(%u) timeout waiting for packets to egress, remaining count %u, bouncing link\n",
+				   __func__, sc->sw_index,
+				   sc->hw_context, (u32)reg);
 			queue_work(dd->pport->hfi1_wq,
-				&dd->pport->link_bounce_work);
+				   &dd->pport->link_bounce_work);
 			break;
 		}
 		loop++;
@@ -1022,7 +1022,7 @@ int sc_restart(struct send_context *sc)
 		return -EINVAL;
 
 	dd_dev_info(dd, "restarting send context %u(%u)\n", sc->sw_index,
-		sc->hw_context);
+		    sc->hw_context);
 
 	/*
 	 * Step 1: Wait for the context to actually halt.
@@ -1037,7 +1037,7 @@ int sc_restart(struct send_context *sc)
 			break;
 		if (loop > 100) {
 			dd_dev_err(dd, "%s: context %u(%u) not halting, skipping\n",
-				__func__, sc->sw_index, sc->hw_context);
+				   __func__, sc->sw_index, sc->hw_context);
 			return -ETIME;
 		}
 		loop++;
@@ -1063,9 +1063,9 @@ int sc_restart(struct send_context *sc)
 				break;
 			if (loop > 100) {
 				dd_dev_err(dd,
-					"%s: context %u(%u) timeout waiting for PIO buffers to zero, remaining %d\n",
-					__func__, sc->sw_index,
-					sc->hw_context, count);
+					   "%s: context %u(%u) timeout waiting for PIO buffers to zero, remaining %d\n",
+					   __func__, sc->sw_index,
+					   sc->hw_context, count);
 			}
 			loop++;
 			udelay(1);
@@ -1178,18 +1178,18 @@ void pio_reset_all(struct hfi1_devdata *dd)
 	if (ret == -EIO) {
 		/* clear the error */
 		write_csr(dd, SEND_PIO_ERR_CLEAR,
-			SEND_PIO_ERR_CLEAR_PIO_INIT_SM_IN_ERR_SMASK);
+			  SEND_PIO_ERR_CLEAR_PIO_INIT_SM_IN_ERR_SMASK);
 	}
 
 	/* reset init all */
 	write_csr(dd, SEND_PIO_INIT_CTXT,
-			SEND_PIO_INIT_CTXT_PIO_ALL_CTXT_INIT_SMASK);
+		  SEND_PIO_INIT_CTXT_PIO_ALL_CTXT_INIT_SMASK);
 	udelay(2);
 	ret = pio_init_wait_progress(dd);
 	if (ret < 0) {
 		dd_dev_err(dd,
-			"PIO send context init %s while initializing all PIO blocks\n",
-			ret == -ETIMEDOUT ? "is stuck" : "had an error");
+			   "PIO send context init %s while initializing all PIO blocks\n",
+			   ret == -ETIMEDOUT ? "is stuck" : "had an error");
 	}
 }
 
@@ -1237,8 +1237,7 @@ int sc_enable(struct send_context *sc)
 	 */
 	reg = read_kctxt_csr(dd, sc->hw_context, SC(ERR_STATUS));
 	if (reg)
-		write_kctxt_csr(dd, sc->hw_context, SC(ERR_CLEAR),
-			reg);
+		write_kctxt_csr(dd, sc->hw_context, SC(ERR_CLEAR), reg);
 
 	/*
 	 * The HW PIO initialization engine can handle only one init
@@ -1296,7 +1295,7 @@ void sc_return_credits(struct send_context *sc)
 
 	/* a 0->1 transition schedules a credit return */
 	write_kctxt_csr(sc->dd, sc->hw_context, SC(CREDIT_FORCE),
-		SC(CREDIT_FORCE_FORCE_RETURN_SMASK));
+			SC(CREDIT_FORCE_FORCE_RETURN_SMASK));
 	/*
 	 * Ensure that the write is flushed and the credit return is
 	 * scheduled. We care more about the 0 -> 1 transition.
@@ -1322,7 +1321,7 @@ void sc_drop(struct send_context *sc)
 		return;
 
 	dd_dev_info(sc->dd, "%s: context %u(%u) - not implemented\n",
-			__func__, sc->sw_index, sc->hw_context);
+		    __func__, sc->sw_index, sc->hw_context);
 }
 
 /*
@@ -1472,7 +1471,7 @@ void sc_add_credit_return_intr(struct send_context *sc)
 	if (sc->credit_intr_count == 0) {
 		sc->credit_ctrl |= SC(CREDIT_CTRL_CREDIT_INTR_SMASK);
 		write_kctxt_csr(sc->dd, sc->hw_context,
-			SC(CREDIT_CTRL), sc->credit_ctrl);
+				SC(CREDIT_CTRL), sc->credit_ctrl);
 	}
 	sc->credit_intr_count++;
 	spin_unlock_irqrestore(&sc->credit_ctrl_lock, flags);
@@ -1494,7 +1493,7 @@ void sc_del_credit_return_intr(struct send_context *sc)
 	if (sc->credit_intr_count == 0) {
 		sc->credit_ctrl &= ~SC(CREDIT_CTRL_CREDIT_INTR_SMASK);
 		write_kctxt_csr(sc->dd, sc->hw_context,
-			SC(CREDIT_CTRL), sc->credit_ctrl);
+				SC(CREDIT_CTRL), sc->credit_ctrl);
 	}
 	spin_unlock_irqrestore(&sc->credit_ctrl_lock, flags);
 }
@@ -1667,7 +1666,7 @@ void sc_group_release_update(struct hfi1_devdata *dd, u32 hw_context)
 	sw_index = dd->hw_to_sw[hw_context];
 	if (unlikely(sw_index >= dd->num_send_contexts)) {
 		dd_dev_err(dd, "%s: invalid hw (%u) to sw (%u) mapping\n",
-			__func__, hw_context, sw_index);
+			   __func__, hw_context, sw_index);
 		goto done;
 	}
 	sc = dd->send_contexts[sw_index].sc;
@@ -1680,8 +1679,8 @@ void sc_group_release_update(struct hfi1_devdata *dd, u32 hw_context)
 		sw_index = dd->hw_to_sw[gc];
 		if (unlikely(sw_index >= dd->num_send_contexts)) {
 			dd_dev_err(dd,
-				"%s: invalid hw (%u) to sw (%u) mapping\n",
-				__func__, hw_context, sw_index);
+				   "%s: invalid hw (%u) to sw (%u) mapping\n",
+				   __func__, hw_context, sw_index);
 			continue;
 		}
 		sc_release_update(dd->send_contexts[sw_index].sc);
@@ -2009,8 +2008,8 @@ int init_credit_return(struct hfi1_devdata *dd)
 		if (!dd->cr_base[i].va) {
 			set_dev_node(&dd->pcidev->dev, dd->node);
 			dd_dev_err(dd,
-				"Unable to allocate credit return DMA range for NUMA %d\n",
-				i);
+				   "Unable to allocate credit return DMA range for NUMA %d\n",
+				   i);
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -2034,10 +2033,10 @@ void free_credit_return(struct hfi1_devdata *dd)
 	for (i = 0; i < num_numa; i++) {
 		if (dd->cr_base[i].va) {
 			dma_free_coherent(&dd->pcidev->dev,
-				TXE_NUM_CONTEXTS
-					* sizeof(struct credit_return),
-				dd->cr_base[i].va,
-				dd->cr_base[i].pa);
+					  TXE_NUM_CONTEXTS *
+					  sizeof(struct credit_return),
+					  dd->cr_base[i].va,
+					  dd->cr_base[i].pa);
 		}
 	}
 	kfree(dd->cr_base);
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index 09a5eeb..d80909a 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -289,7 +289,7 @@ void sc_flush(struct send_context *sc);
 void sc_drop(struct send_context *sc);
 void sc_stop(struct send_context *sc, int bit);
 struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
-			pio_release_cb cb, void *arg);
+				pio_release_cb cb, void *arg);
 void sc_release_update(struct send_context *sc);
 void sc_return_credits(struct send_context *sc);
 void sc_group_release_update(struct hfi1_devdata *dd, u32 hw_context);
@@ -322,7 +322,7 @@ void pio_send_control(struct hfi1_devdata *dd, int op);
 void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 	      const void *from, size_t count);
 void seg_pio_copy_start(struct pio_buf *pbuf, u64 pbc,
-					const void *from, size_t nbytes);
+			const void *from, size_t nbytes);
 void seg_pio_copy_mid(struct pio_buf *pbuf, const void *from, size_t nbytes);
 void seg_pio_copy_end(struct pio_buf *pbuf);
 
diff --git a/drivers/staging/rdma/hfi1/pio_copy.c b/drivers/staging/rdma/hfi1/pio_copy.c
index 6f97d22..998e7bc 100644
--- a/drivers/staging/rdma/hfi1/pio_copy.c
+++ b/drivers/staging/rdma/hfi1/pio_copy.c
@@ -200,7 +200,7 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
  * o nbytes must not span a QW boundary
  */
 static inline void read_low_bytes(struct pio_buf *pbuf, const void *from,
-							unsigned int nbytes)
+				  unsigned int nbytes)
 {
 	unsigned long off;
 
@@ -227,7 +227,7 @@ static inline void read_low_bytes(struct pio_buf *pbuf, const void *from,
  * o nbytes may span a QW boundary
  */
 static inline void read_extra_bytes(struct pio_buf *pbuf,
-					const void *from, unsigned int nbytes)
+				    const void *from, unsigned int nbytes)
 {
 	unsigned long off = (unsigned long)from & 0x7;
 	unsigned int room, xbytes;
@@ -366,7 +366,7 @@ static inline void jcopy(u8 *dest, const u8 *src, u32 n)
  * o from may _not_ be u64 aligned.
  */
 static inline void read_low_bytes(struct pio_buf *pbuf, const void *from,
-							unsigned int nbytes)
+				  unsigned int nbytes)
 {
 	jcopy(&pbuf->carry.val8[0], from, nbytes);
 	pbuf->carry_bytes = nbytes;
@@ -381,7 +381,7 @@ static inline void read_low_bytes(struct pio_buf *pbuf, const void *from,
  * o nbytes may span a QW boundary
  */
 static inline void read_extra_bytes(struct pio_buf *pbuf,
-					const void *from, unsigned int nbytes)
+				    const void *from, unsigned int nbytes)
 {
 	jcopy(&pbuf->carry.val8[pbuf->carry_bytes], from, nbytes);
 	pbuf->carry_bytes += nbytes;
@@ -437,7 +437,7 @@ static inline int carry_write8(struct pio_buf *pbuf, void *dest)
 		u64 zero = 0;
 
 		jcopy(&pbuf->carry.val8[pbuf->carry_bytes], (u8 *)&zero,
-						8 - pbuf->carry_bytes);
+		      8 - pbuf->carry_bytes);
 		writeq(pbuf->carry.val64, dest);
 		return 1;
 	}
@@ -457,7 +457,7 @@ static inline int carry_write8(struct pio_buf *pbuf, void *dest)
  * @nbytes: bytes to copy
  */
 void seg_pio_copy_start(struct pio_buf *pbuf, u64 pbc,
-				const void *from, size_t nbytes)
+			const void *from, size_t nbytes)
 {
 	void __iomem *dest = pbuf->start + SOP_DISTANCE;
 	void __iomem *send = dest + PIO_BLOCK_SIZE;
@@ -647,7 +647,7 @@ static void mid_copy_mix(struct pio_buf *pbuf, const void *from, size_t nbytes)
  * Must handle nbytes < 8.
  */
 static void mid_copy_straight(struct pio_buf *pbuf,
-						const void *from, size_t nbytes)
+			      const void *from, size_t nbytes)
 {
 	void __iomem *dest = pbuf->start + (pbuf->qw_written * sizeof(u64));
 	void __iomem *dend;			/* 8-byte data end */
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index bdb1504..c5e04b0 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -468,7 +468,7 @@ int get_cable_info(struct hfi1_devdata *dd, u32 port_num, u32 addr, u32 len,
 
 	if (port_num > dd->num_pports || port_num < 1) {
 		dd_dev_info(dd, "%s: Invalid port number %d\n",
-				__func__, port_num);
+			    __func__, port_num);
 		ret = -EINVAL;
 		goto set_zeroes;
 	}
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 99584f7..28ff638 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1773,8 +1773,8 @@ static inline void rc_cancel_ack(struct rvt_qp *qp)
  * schedule a response to be sent.
  */
 static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
-			struct rvt_qp *qp, u32 opcode, u32 psn, int diff,
-			struct hfi1_ctxtdata *rcd)
+				 struct rvt_qp *qp, u32 opcode, u32 psn,
+				 int diff, struct hfi1_ctxtdata *rcd)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct rvt_ack_entry *e;
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 6f0005a..e2c4f82 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -283,9 +283,10 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 			if (!gid_ok(&hdr->u.l.grh.dgid, ibp->rvp.gid_prefix,
 				    guid))
 				goto err;
-			if (!gid_ok(&hdr->u.l.grh.sgid,
-			    qp->alt_ah_attr.grh.dgid.global.subnet_prefix,
-			    qp->alt_ah_attr.grh.dgid.global.interface_id))
+			if (!gid_ok(
+				&hdr->u.l.grh.sgid,
+				qp->alt_ah_attr.grh.dgid.global.subnet_prefix,
+				qp->alt_ah_attr.grh.dgid.global.interface_id))
 				goto err;
 		}
 		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
@@ -317,9 +318,10 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 			if (!gid_ok(&hdr->u.l.grh.dgid, ibp->rvp.gid_prefix,
 				    guid))
 				goto err;
-			if (!gid_ok(&hdr->u.l.grh.sgid,
-			    qp->remote_ah_attr.grh.dgid.global.subnet_prefix,
-			    qp->remote_ah_attr.grh.dgid.global.interface_id))
+			if (!gid_ok(
+			     &hdr->u.l.grh.sgid,
+			     qp->remote_ah_attr.grh.dgid.global.subnet_prefix,
+			     qp->remote_ah_attr.grh.dgid.global.interface_id))
 				goto err;
 		}
 		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 9ffeeda..4880800 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -325,9 +325,9 @@ static void sdma_wait_for_packet_egress(struct sdma_engine *sde,
 		if (lcnt++ > 500) {
 			/* timed out - bounce the link */
 			dd_dev_err(dd, "%s: engine %u timeout waiting for packets to egress, remaining count %u, bouncing link\n",
-				  __func__, sde->this_idx, (u32)reg);
+				   __func__, sde->this_idx, (u32)reg);
 			queue_work(dd->pport->hfi1_wq,
-				&dd->pport->link_bounce_work);
+				   &dd->pport->link_bounce_work);
 			break;
 		}
 		udelay(1);
@@ -458,8 +458,8 @@ static void sdma_err_halt_wait(struct work_struct *work)
 			break;
 		if (time_after(jiffies, timeout)) {
 			dd_dev_err(sde->dd,
-				"SDMA engine %d - timeout waiting for engine to halt\n",
-				sde->this_idx);
+				   "SDMA engine %d - timeout waiting for engine to halt\n",
+				   sde->this_idx);
 			/*
 			 * Continue anyway.  This could happen if there was
 			 * an uncorrectable error in the wrong spot.
@@ -656,7 +656,7 @@ static void sdma_start_hw_clean_up(struct sdma_engine *sde)
 }
 
 static void sdma_set_state(struct sdma_engine *sde,
-	enum sdma_states next_state)
+			   enum sdma_states next_state)
 {
 	struct sdma_state *ss = &sde->state;
 	const struct sdma_set_state_action *action = sdma_action_table;
@@ -908,7 +908,7 @@ int sdma_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_engines)
 	/* newmap in hand, save old map */
 	spin_lock_irq(&dd->sde_map_lock);
 	oldmap = rcu_dereference_protected(dd->sdma_map,
-			lockdep_is_held(&dd->sde_map_lock));
+					   lockdep_is_held(&dd->sde_map_lock));
 
 	/* publish newmap */
 	rcu_assign_pointer(dd->sdma_map, newmap);
@@ -1006,16 +1006,16 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		return 0;
 	}
 	if (mod_num_sdma &&
-		/* can't exceed chip support */
-		mod_num_sdma <= dd->chip_sdma_engines &&
-		/* count must be >= vls */
-		mod_num_sdma >= num_vls)
+	    /* can't exceed chip support */
+	    mod_num_sdma <= dd->chip_sdma_engines &&
+	    /* count must be >= vls */
+	    mod_num_sdma >= num_vls)
 		num_engines = mod_num_sdma;
 
 	dd_dev_info(dd, "SDMA mod_num_sdma: %u\n", mod_num_sdma);
 	dd_dev_info(dd, "SDMA chip_sdma_engines: %u\n", dd->chip_sdma_engines);
 	dd_dev_info(dd, "SDMA chip_sdma_mem_size: %u\n",
-		dd->chip_sdma_mem_size);
+		    dd->chip_sdma_mem_size);
 
 	per_sdma_credits =
 		dd->chip_sdma_mem_size / (num_engines * SDMA_BLOCK_SIZE);
@@ -1026,7 +1026,7 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 
 	descq_cnt = sdma_get_descq_cnt();
 	dd_dev_info(dd, "SDMA engines %zu descq_cnt %u\n",
-		num_engines, descq_cnt);
+		    num_engines, descq_cnt);
 
 	/* alloc memory for array of send engines */
 	dd->per_sdma = kcalloc(num_engines, sizeof(*dd->per_sdma), GFP_KERNEL);
@@ -1087,10 +1087,10 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 				SDMA_DESC1_INT_REQ_FLAG;
 
 		tasklet_init(&sde->sdma_hw_clean_up_task, sdma_hw_clean_up_task,
-			(unsigned long)sde);
+			     (unsigned long)sde);
 
 		tasklet_init(&sde->sdma_sw_clean_up_task, sdma_sw_clean_up_task,
-			(unsigned long)sde);
+			     (unsigned long)sde);
 		INIT_WORK(&sde->err_halt_worker, sdma_err_halt_wait);
 		INIT_WORK(&sde->flush_worker, sdma_field_flush);
 
@@ -1241,7 +1241,7 @@ void sdma_exit(struct hfi1_devdata *dd)
 		sde = &dd->per_sdma[this_idx];
 		if (!list_empty(&sde->dmawait))
 			dd_dev_err(dd, "sde %u: dmawait list not empty!\n",
-				sde->this_idx);
+				   sde->this_idx);
 		sdma_process_event(sde, sdma_event_e00_go_hw_down);
 
 		del_timer_sync(&sde->err_progress_check_timer);
@@ -1371,9 +1371,9 @@ retry:
 
 		if (unlikely(!sane)) {
 			dd_dev_err(dd, "SDMA(%u) bad head (%s) hwhd=%hu swhd=%hu swtl=%hu cnt=%hu\n",
-				sde->this_idx,
-				use_dmahead ? "dma" : "kreg",
-				hwhead, swhead, swtail, cnt);
+				   sde->this_idx,
+				   use_dmahead ? "dma" : "kreg",
+				   hwhead, swhead, swtail, cnt);
 			if (use_dmahead) {
 				/* try one more time, using csr */
 				use_dmahead = 0;
@@ -1551,10 +1551,10 @@ void sdma_engine_error(struct sdma_engine *sde, u64 status)
 		__sdma_process_event(sde, sdma_event_e60_hw_halted);
 	if (status & ~SD(ENG_ERR_STATUS_SDMA_HALT_ERR_SMASK)) {
 		dd_dev_err(sde->dd,
-			"SDMA (%u) engine error: 0x%llx state %s\n",
-			sde->this_idx,
-			(unsigned long long)status,
-			sdma_state_names[sde->state.current_state]);
+			   "SDMA (%u) engine error: 0x%llx state %s\n",
+			   sde->this_idx,
+			   (unsigned long long)status,
+			   sdma_state_names[sde->state.current_state]);
 		dump_sdma_state(sde);
 	}
 	write_sequnlock(&sde->head_lock);
@@ -1598,8 +1598,8 @@ static void sdma_sendctrl(struct sdma_engine *sde, unsigned op)
 
 	if (op & SDMA_SENDCTRL_OP_CLEANUP)
 		write_sde_csr(sde, SD(CTRL),
-			sde->p_senddmactrl |
-			SD(CTRL_SDMA_CLEANUP_SMASK));
+			      sde->p_senddmactrl |
+			      SD(CTRL_SDMA_CLEANUP_SMASK));
 	else
 		write_sde_csr(sde, SD(CTRL), sde->p_senddmactrl);
 
@@ -1623,12 +1623,10 @@ static void sdma_setlengen(struct sdma_engine *sde)
 	 * generation counter.
 	 */
 	write_sde_csr(sde, SD(LEN_GEN),
-		(sde->descq_cnt / 64) << SD(LEN_GEN_LENGTH_SHIFT)
-	);
+		      (sde->descq_cnt / 64) << SD(LEN_GEN_LENGTH_SHIFT));
 	write_sde_csr(sde, SD(LEN_GEN),
-		((sde->descq_cnt / 64) << SD(LEN_GEN_LENGTH_SHIFT))
-		| (4ULL << SD(LEN_GEN_GENERATION_SHIFT))
-	);
+		      ((sde->descq_cnt / 64) << SD(LEN_GEN_LENGTH_SHIFT)) |
+		      (4ULL << SD(LEN_GEN_GENERATION_SHIFT)));
 }
 
 static inline void sdma_update_tail(struct sdma_engine *sde, u16 tail)
@@ -1708,17 +1706,16 @@ static void init_sdma_regs(
 	write_sde_csr(sde, SD(DESC_CNT), 0);
 	write_sde_csr(sde, SD(HEAD_ADDR), sde->head_phys);
 	write_sde_csr(sde, SD(MEMORY),
-		((u64)credits <<
-			SD(MEMORY_SDMA_MEMORY_CNT_SHIFT)) |
-		((u64)(credits * sde->this_idx) <<
-			SD(MEMORY_SDMA_MEMORY_INDEX_SHIFT)));
+		      ((u64)credits << SD(MEMORY_SDMA_MEMORY_CNT_SHIFT)) |
+		      ((u64)(credits * sde->this_idx) <<
+		       SD(MEMORY_SDMA_MEMORY_INDEX_SHIFT)));
 	write_sde_csr(sde, SD(ENG_ERR_MASK), ~0ull);
 	set_sdma_integrity(sde);
 	opmask = OPCODE_CHECK_MASK_DISABLED;
 	opval = OPCODE_CHECK_VAL_DISABLED;
 	write_sde_csr(sde, SD(CHECK_OPCODE),
-		(opmask << SEND_CTXT_CHECK_OPCODE_MASK_SHIFT) |
-		(opval << SEND_CTXT_CHECK_OPCODE_VALUE_SHIFT));
+		      (opmask << SEND_CTXT_CHECK_OPCODE_MASK_SHIFT) |
+		      (opval << SEND_CTXT_CHECK_OPCODE_VALUE_SHIFT));
 }
 
 #ifdef CONFIG_SDMA_VERBOSITY
@@ -1797,12 +1794,9 @@ static void dump_sdma_state(struct sdma_engine *sde)
 	descq = sde->descq;
 
 	dd_dev_err(sde->dd,
-		"SDMA (%u) descq_head: %u descq_tail: %u freecnt: %u FLE %d\n",
-		sde->this_idx,
-		head,
-		tail,
-		cnt,
-		!list_empty(&sde->flushlist));
+		   "SDMA (%u) descq_head: %u descq_tail: %u freecnt: %u FLE %d\n",
+		   sde->this_idx, head, tail, cnt,
+		   !list_empty(&sde->flushlist));
 
 	/* print info for each entry in the descriptor queue */
 	while (head != tail) {
@@ -1823,20 +1817,23 @@ static void dump_sdma_state(struct sdma_engine *sde)
 		len = (desc[0] >> SDMA_DESC0_BYTE_COUNT_SHIFT)
 			& SDMA_DESC0_BYTE_COUNT_MASK;
 		dd_dev_err(sde->dd,
-			"SDMA sdmadesc[%u]: flags:%s addr:0x%016llx gen:%u len:%u bytes\n",
-			 head, flags, addr, gen, len);
+			   "SDMA sdmadesc[%u]: flags:%s addr:0x%016llx gen:%u len:%u bytes\n",
+			   head, flags, addr, gen, len);
 		dd_dev_err(sde->dd,
-			"\tdesc0:0x%016llx desc1 0x%016llx\n",
-			 desc[0], desc[1]);
+			   "\tdesc0:0x%016llx desc1 0x%016llx\n",
+			   desc[0], desc[1]);
 		if (desc[0] & SDMA_DESC0_FIRST_DESC_FLAG)
 			dd_dev_err(sde->dd,
-				"\taidx: %u amode: %u alen: %u\n",
-				(u8)((desc[1] & SDMA_DESC1_HEADER_INDEX_SMASK)
-					>> SDMA_DESC1_HEADER_INDEX_SHIFT),
-				(u8)((desc[1] & SDMA_DESC1_HEADER_MODE_SMASK)
-					>> SDMA_DESC1_HEADER_MODE_SHIFT),
-				(u8)((desc[1] & SDMA_DESC1_HEADER_DWS_SMASK)
-					>> SDMA_DESC1_HEADER_DWS_SHIFT));
+				   "\taidx: %u amode: %u alen: %u\n",
+				   (u8)((desc[1] &
+					 SDMA_DESC1_HEADER_INDEX_SMASK) >>
+					SDMA_DESC1_HEADER_INDEX_SHIFT),
+				   (u8)((desc[1] &
+					 SDMA_DESC1_HEADER_MODE_SMASK) >>
+					SDMA_DESC1_HEADER_MODE_SHIFT),
+				   (u8)((desc[1] &
+					 SDMA_DESC1_HEADER_DWS_SMASK) >>
+					SDMA_DESC1_HEADER_DWS_SHIFT));
 		head++;
 		head &= sde->sdma_mask;
 	}
@@ -1863,29 +1860,26 @@ void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *sde)
 	head = sde->descq_head & sde->sdma_mask;
 	tail = ACCESS_ONCE(sde->descq_tail) & sde->sdma_mask;
 	seq_printf(s, SDE_FMT, sde->this_idx,
-		sde->cpu,
-		sdma_state_name(sde->state.current_state),
-		(unsigned long long)read_sde_csr(sde, SD(CTRL)),
-		(unsigned long long)read_sde_csr(sde, SD(STATUS)),
-		(unsigned long long)read_sde_csr(sde,
-			SD(ENG_ERR_STATUS)),
-		(unsigned long long)read_sde_csr(sde, SD(TAIL)),
-		tail,
-		(unsigned long long)read_sde_csr(sde, SD(HEAD)),
-		head,
-		(unsigned long long)le64_to_cpu(*sde->head_dma),
-		(unsigned long long)read_sde_csr(sde, SD(MEMORY)),
-		(unsigned long long)read_sde_csr(sde, SD(LEN_GEN)),
-		(unsigned long long)read_sde_csr(sde, SD(RELOAD_CNT)),
-		(unsigned long long)sde->last_status,
-		(unsigned long long)sde->ahg_bits,
-		sde->tx_tail,
-		sde->tx_head,
-		sde->descq_tail,
-		sde->descq_head,
+		   sde->cpu,
+		   sdma_state_name(sde->state.current_state),
+		   (unsigned long long)read_sde_csr(sde, SD(CTRL)),
+		   (unsigned long long)read_sde_csr(sde, SD(STATUS)),
+		   (unsigned long long)read_sde_csr(sde, SD(ENG_ERR_STATUS)),
+		   (unsigned long long)read_sde_csr(sde, SD(TAIL)), tail,
+		   (unsigned long long)read_sde_csr(sde, SD(HEAD)), head,
+		   (unsigned long long)le64_to_cpu(*sde->head_dma),
+		   (unsigned long long)read_sde_csr(sde, SD(MEMORY)),
+		   (unsigned long long)read_sde_csr(sde, SD(LEN_GEN)),
+		   (unsigned long long)read_sde_csr(sde, SD(RELOAD_CNT)),
+		   (unsigned long long)sde->last_status,
+		   (unsigned long long)sde->ahg_bits,
+		   sde->tx_tail,
+		   sde->tx_head,
+		   sde->descq_tail,
+		   sde->descq_head,
 		   !list_empty(&sde->flushlist),
-		sde->descq_full_count,
-		(unsigned long long)read_sde_csr(sde, SEND_DMA_CHECK_SLID));
+		   sde->descq_full_count,
+		   (unsigned long long)read_sde_csr(sde, SEND_DMA_CHECK_SLID));
 
 	/* print info for each entry in the descriptor queue */
 	while (head != tail) {
@@ -1906,14 +1900,16 @@ void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *sde)
 		len = (desc[0] >> SDMA_DESC0_BYTE_COUNT_SHIFT)
 			& SDMA_DESC0_BYTE_COUNT_MASK;
 		seq_printf(s,
-			"\tdesc[%u]: flags:%s addr:0x%016llx gen:%u len:%u bytes\n",
-			head, flags, addr, gen, len);
+			   "\tdesc[%u]: flags:%s addr:0x%016llx gen:%u len:%u bytes\n",
+			   head, flags, addr, gen, len);
 		if (desc[0] & SDMA_DESC0_FIRST_DESC_FLAG)
 			seq_printf(s, "\t\tahgidx: %u ahgmode: %u\n",
-				(u8)((desc[1] & SDMA_DESC1_HEADER_INDEX_SMASK)
-					>> SDMA_DESC1_HEADER_INDEX_SHIFT),
-				(u8)((desc[1] & SDMA_DESC1_HEADER_MODE_SMASK)
-					>> SDMA_DESC1_HEADER_MODE_SHIFT));
+				   (u8)((desc[1] &
+					 SDMA_DESC1_HEADER_INDEX_SMASK) >>
+					SDMA_DESC1_HEADER_INDEX_SHIFT),
+				   (u8)((desc[1] &
+					 SDMA_DESC1_HEADER_MODE_SMASK) >>
+					SDMA_DESC1_HEADER_MODE_SHIFT));
 		head = (head + 1) & sde->sdma_mask;
 	}
 }
@@ -2109,9 +2105,8 @@ nodesc:
  * -EINVAL - sdma_txreq incomplete, -EBUSY - no space in ring (wait == NULL)
  * -EIOCBQUEUED - tx queued to iowait, -ECOMM bad sdma state
  */
-int sdma_send_txlist(struct sdma_engine *sde,
-		    struct iowait *wait,
-		    struct list_head *tx_list)
+int sdma_send_txlist(struct sdma_engine *sde, struct iowait *wait,
+		     struct list_head *tx_list)
 {
 	struct sdma_txreq *tx, *tx_next;
 	int ret = 0;
@@ -2179,8 +2174,7 @@ nodesc:
 	goto update_tail;
 }
 
-static void sdma_process_event(struct sdma_engine *sde,
-	enum sdma_events event)
+static void sdma_process_event(struct sdma_engine *sde, enum sdma_events event)
 {
 	unsigned long flags;
 
@@ -2197,7 +2191,7 @@ static void sdma_process_event(struct sdma_engine *sde,
 }
 
 static void __sdma_process_event(struct sdma_engine *sde,
-	enum sdma_events event)
+				 enum sdma_events event)
 {
 	struct sdma_state *ss = &sde->state;
 	int need_progress = 0;
@@ -2228,7 +2222,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 			/* This reference means the state machine is started */
 			sdma_get(&sde->state);
 			sdma_set_state(sde,
-				sdma_state_s10_hw_start_up_halt_wait);
+				       sdma_state_s10_hw_start_up_halt_wait);
 			break;
 		case sdma_event_e15_hw_halt_done:
 			break;
@@ -2266,7 +2260,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 			break;
 		case sdma_event_e15_hw_halt_done:
 			sdma_set_state(sde,
-				sdma_state_s15_hw_start_up_clean_wait);
+				       sdma_state_s15_hw_start_up_clean_wait);
 			sdma_start_hw_clean_up(sde);
 			break;
 		case sdma_event_e25_hw_clean_up_done:
@@ -3004,7 +2998,8 @@ void sdma_freeze(struct hfi1_devdata *dd)
 	 * continuing.
 	 */
 	ret = wait_event_interruptible(dd->sdma_unfreeze_wq,
-				atomic_read(&dd->sdma_unfreeze_count) <= 0);
+				       atomic_read(&dd->sdma_unfreeze_count) <=
+				       0);
 	/* interrupted or count is negative, then unloading - just exit */
 	if (ret || atomic_read(&dd->sdma_unfreeze_count) < 0)
 		return;
@@ -3041,7 +3036,7 @@ void sdma_unfreeze(struct hfi1_devdata *dd)
 	/* tell all engines start freeze clean up */
 	for (i = 0; i < dd->num_sdma; i++)
 		sdma_process_event(&dd->per_sdma[i],
-					sdma_event_e82_hw_unfreeze);
+				   sdma_event_e82_hw_unfreeze);
 }
 
 /**
@@ -3055,5 +3050,6 @@ void _sdma_engine_progress_schedule(
 	trace_hfi1_sdma_engine_progress(sde, sde->progress_mask);
 	/* assume we have selected a good cpu */
 	write_csr(sde->dd,
-		  CCE_INT_FORCE + (8 * (IS_SDMA_START / 64)), sde->progress_mask);
+		  CCE_INT_FORCE + (8 * (IS_SDMA_START / 64)),
+		  sde->progress_mask);
 }
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index fe232c1..3e3f180 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -61,8 +61,8 @@
  * Congestion control table size followed by table entries
  */
 static ssize_t read_cc_table_bin(struct file *filp, struct kobject *kobj,
-		struct bin_attribute *bin_attr,
-		char *buf, loff_t pos, size_t count)
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t count)
 {
 	int ret;
 	struct hfi1_pportdata *ppd =
@@ -110,8 +110,8 @@ static struct bin_attribute cc_table_bin_attr = {
  * trigger threshold and the minimum injection rate delay.
  */
 static ssize_t read_cc_setting_bin(struct file *filp, struct kobject *kobj,
-		struct bin_attribute *bin_attr,
-		char *buf, loff_t pos, size_t count)
+				   struct bin_attribute *bin_attr,
+				   char *buf, loff_t pos, size_t count)
 {
 	int ret;
 	struct hfi1_pportdata *ppd =
@@ -550,7 +550,7 @@ static ssize_t show_nctxts(struct device *device,
 }
 
 static ssize_t show_nfreectxts(struct device *device,
-			   struct device_attribute *attr, char *buf)
+			       struct device_attribute *attr, char *buf)
 {
 	struct hfi1_ibdev *dev =
 		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
@@ -660,8 +660,8 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 
 	if (!port_num || port_num > dd->num_pports) {
 		dd_dev_err(dd,
-			"Skipping infiniband class with invalid port %u\n",
-			port_num);
+			   "Skipping infiniband class with invalid port %u\n",
+			   port_num);
 		return -ENODEV;
 	}
 	ppd = &dd->pport[port_num - 1];
@@ -700,34 +700,32 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 				   kobj, "CCMgtA");
 	if (ret) {
 		dd_dev_err(dd,
-		 "Skipping Congestion Control sysfs info, (err %d) port %u\n",
-		 ret, port_num);
+			   "Skipping Congestion Control sysfs info, (err %d) port %u\n",
+			   ret, port_num);
 		goto bail_vl2mtu;
 	}
 
 	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
 
-	ret = sysfs_create_bin_file(&ppd->pport_cc_kobj,
-				&cc_setting_bin_attr);
+	ret = sysfs_create_bin_file(&ppd->pport_cc_kobj, &cc_setting_bin_attr);
 	if (ret) {
 		dd_dev_err(dd,
-		 "Skipping Congestion Control setting sysfs info, (err %d) port %u\n",
-		 ret, port_num);
+			   "Skipping Congestion Control setting sysfs info, (err %d) port %u\n",
+			   ret, port_num);
 		goto bail_cc;
 	}
 
-	ret = sysfs_create_bin_file(&ppd->pport_cc_kobj,
-				&cc_table_bin_attr);
+	ret = sysfs_create_bin_file(&ppd->pport_cc_kobj, &cc_table_bin_attr);
 	if (ret) {
 		dd_dev_err(dd,
-		 "Skipping Congestion Control table sysfs info, (err %d) port %u\n",
-		 ret, port_num);
+			   "Skipping Congestion Control table sysfs info, (err %d) port %u\n",
+			   ret, port_num);
 		goto bail_cc_entry_bin;
 	}
 
 	dd_dev_info(dd,
-		"IB%u: Congestion Control Agent enabled for port %d\n",
-		dd->unit, port_num);
+		    "IB%u: Congestion Control Agent enabled for port %d\n",
+		    dd->unit, port_num);
 
 	return 0;
 
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index 923ca55..99fd017 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -109,17 +109,17 @@ const char *parse_everbs_hdrs(
 	case OP(RC, RDMA_WRITE_LAST_WITH_IMMEDIATE):
 	case OP(UC, RDMA_WRITE_LAST_WITH_IMMEDIATE):
 		trace_seq_printf(p, IMM_PRN,
-			be32_to_cpu(eh->imm_data));
+				 be32_to_cpu(eh->imm_data));
 		break;
 	/* reth + imm */
 	case OP(RC, RDMA_WRITE_ONLY_WITH_IMMEDIATE):
 	case OP(UC, RDMA_WRITE_ONLY_WITH_IMMEDIATE):
 		trace_seq_printf(p, RETH_PRN " " IMM_PRN,
-			(unsigned long long)ib_u64_get(
-				(__be32 *)&eh->rc.reth.vaddr),
-			be32_to_cpu(eh->rc.reth.rkey),
-			be32_to_cpu(eh->rc.reth.length),
-			be32_to_cpu(eh->rc.imm_data));
+				 (unsigned long long)ib_u64_get(
+				 (__be32 *)&eh->rc.reth.vaddr),
+				 be32_to_cpu(eh->rc.reth.rkey),
+				 be32_to_cpu(eh->rc.reth.length),
+				 be32_to_cpu(eh->rc.imm_data));
 		break;
 	/* reth */
 	case OP(RC, RDMA_READ_REQUEST):
@@ -128,10 +128,10 @@ const char *parse_everbs_hdrs(
 	case OP(RC, RDMA_WRITE_ONLY):
 	case OP(UC, RDMA_WRITE_ONLY):
 		trace_seq_printf(p, RETH_PRN,
-			(unsigned long long)ib_u64_get(
-				(__be32 *)&eh->rc.reth.vaddr),
-			be32_to_cpu(eh->rc.reth.rkey),
-			be32_to_cpu(eh->rc.reth.length));
+				 (unsigned long long)ib_u64_get(
+				 (__be32 *)&eh->rc.reth.vaddr),
+				 be32_to_cpu(eh->rc.reth.rkey),
+				 be32_to_cpu(eh->rc.reth.length));
 		break;
 	case OP(RC, RDMA_READ_RESPONSE_FIRST):
 	case OP(RC, RDMA_READ_RESPONSE_LAST):
@@ -154,19 +154,20 @@ const char *parse_everbs_hdrs(
 	case OP(RC, COMPARE_SWAP):
 	case OP(RC, FETCH_ADD):
 		trace_seq_printf(p, ATOMICETH_PRN,
-			(unsigned long long)ib_u64_get(eh->atomic_eth.vaddr),
-			eh->atomic_eth.rkey,
-			(unsigned long long)ib_u64_get(
-				(__be32 *)&eh->atomic_eth.swap_data),
-			(unsigned long long)ib_u64_get(
+				 (unsigned long long)ib_u64_get(
+				 eh->atomic_eth.vaddr),
+				 eh->atomic_eth.rkey,
+				 (unsigned long long)ib_u64_get(
+				 (__be32 *)&eh->atomic_eth.swap_data),
+				 (unsigned long long)ib_u64_get(
 				 (__be32 *)&eh->atomic_eth.compare_data));
 		break;
 	/* deth */
 	case OP(UD, SEND_ONLY):
 	case OP(UD, SEND_ONLY_WITH_IMMEDIATE):
 		trace_seq_printf(p, DETH_PRN,
-			be32_to_cpu(eh->ud.deth[0]),
-			be32_to_cpu(eh->ud.deth[1]) & RVT_QPN_MASK);
+				 be32_to_cpu(eh->ud.deth[0]),
+				 be32_to_cpu(eh->ud.deth[1]) & RVT_QPN_MASK);
 		break;
 	}
 	trace_seq_putc(p, 0);
@@ -187,12 +188,12 @@ const char *parse_sdma_flags(
 	trace_seq_printf(p, "%s", flags);
 	if (desc0 & SDMA_DESC0_FIRST_DESC_FLAG)
 		trace_seq_printf(p, " amode:%u aidx:%u alen:%u",
-			(u8)((desc1 >> SDMA_DESC1_HEADER_MODE_SHIFT)
-				& SDMA_DESC1_HEADER_MODE_MASK),
-			(u8)((desc1 >> SDMA_DESC1_HEADER_INDEX_SHIFT)
-				& SDMA_DESC1_HEADER_INDEX_MASK),
-			(u8)((desc1 >> SDMA_DESC1_HEADER_DWS_SHIFT)
-				& SDMA_DESC1_HEADER_DWS_MASK));
+				 (u8)((desc1 >> SDMA_DESC1_HEADER_MODE_SHIFT) &
+				      SDMA_DESC1_HEADER_MODE_MASK),
+				 (u8)((desc1 >> SDMA_DESC1_HEADER_INDEX_SHIFT) &
+				      SDMA_DESC1_HEADER_INDEX_MASK),
+				 (u8)((desc1 >> SDMA_DESC1_HEADER_DWS_SHIFT) &
+				      SDMA_DESC1_HEADER_DWS_MASK));
 	return ret;
 }
 
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index a13215f..dfa9967 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -76,81 +76,77 @@ __print_symbolic(etype,                         \
 #define TRACE_SYSTEM hfi1_rx
 
 TRACE_EVENT(hfi1_rcvhdr,
-	TP_PROTO(struct hfi1_devdata *dd,
-		 u64 eflags,
-		 u32 ctxt,
-		 u32 etype,
-		 u32 hlen,
-		 u32 tlen,
-		 u32 updegr,
-		 u32 etail),
-	TP_ARGS(dd, ctxt, eflags, etype, hlen, tlen, updegr, etail),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd)
-		__field(u64, eflags)
-		__field(u32, ctxt)
-		__field(u32, etype)
-		__field(u32, hlen)
-		__field(u32, tlen)
-		__field(u32, updegr)
-		__field(u32, etail)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd);
-		__entry->eflags = eflags;
-		__entry->ctxt = ctxt;
-		__entry->etype = etype;
-		__entry->hlen = hlen;
-		__entry->tlen = tlen;
-		__entry->updegr = updegr;
-		__entry->etail = etail;
-	),
-	TP_printk(
-"[%s] ctxt %d eflags 0x%llx etype %d,%s hlen %d tlen %d updegr %d etail %d",
-		__get_str(dev),
-		__entry->ctxt,
-		__entry->eflags,
-		__entry->etype, show_packettype(__entry->etype),
-		__entry->hlen,
-		__entry->tlen,
-		__entry->updegr,
-		__entry->etail
-	)
+	    TP_PROTO(struct hfi1_devdata *dd,
+		     u64 eflags,
+		     u32 ctxt,
+		     u32 etype,
+		     u32 hlen,
+		     u32 tlen,
+		     u32 updegr,
+		     u32 etail
+		     ),
+	    TP_ARGS(dd, ctxt, eflags, etype, hlen, tlen, updegr, etail),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+			     __field(u64, eflags)
+			     __field(u32, ctxt)
+			     __field(u32, etype)
+			     __field(u32, hlen)
+			     __field(u32, tlen)
+			     __field(u32, updegr)
+			     __field(u32, etail)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd);
+			   __entry->eflags = eflags;
+			   __entry->ctxt = ctxt;
+			   __entry->etype = etype;
+			   __entry->hlen = hlen;
+			   __entry->tlen = tlen;
+			   __entry->updegr = updegr;
+			   __entry->etail = etail;
+			   ),
+	    TP_printk(
+		      "[%s] ctxt %d eflags 0x%llx etype %d,%s hlen %d tlen %d updegr %d etail %d",
+		      __get_str(dev),
+		      __entry->ctxt,
+		      __entry->eflags,
+		      __entry->etype, show_packettype(__entry->etype),
+		      __entry->hlen,
+		      __entry->tlen,
+		      __entry->updegr,
+		      __entry->etail
+		      )
 );
 
 TRACE_EVENT(hfi1_receive_interrupt,
-	TP_PROTO(struct hfi1_devdata *dd, u32 ctxt),
-	TP_ARGS(dd, ctxt),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd)
-		__field(u32, ctxt)
-		__field(u8, slow_path)
-		__field(u8, dma_rtail)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd);
-		__entry->ctxt = ctxt;
-		if (dd->rcd[ctxt]->do_interrupt ==
-		    &handle_receive_interrupt) {
-			__entry->slow_path = 1;
-			__entry->dma_rtail = 0xFF;
-		} else if (dd->rcd[ctxt]->do_interrupt ==
-			&handle_receive_interrupt_dma_rtail){
-			__entry->dma_rtail = 1;
-			__entry->slow_path = 0;
-		} else if (dd->rcd[ctxt]->do_interrupt ==
-			 &handle_receive_interrupt_nodma_rtail) {
-			__entry->dma_rtail = 0;
-			__entry->slow_path = 0;
-		}
-	),
-	TP_printk(
-		"[%s] ctxt %d SlowPath: %d DmaRtail: %d",
-		__get_str(dev),
-		__entry->ctxt,
-		__entry->slow_path,
-		__entry->dma_rtail
-	)
+	    TP_PROTO(struct hfi1_devdata *dd, u32 ctxt),
+	    TP_ARGS(dd, ctxt),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+			     __field(u32, ctxt)
+			     __field(u8, slow_path)
+			     __field(u8, dma_rtail)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd);
+			   __entry->ctxt = ctxt;
+			   if (dd->rcd[ctxt]->do_interrupt ==
+			       &handle_receive_interrupt) {
+				__entry->slow_path = 1;
+				__entry->dma_rtail = 0xFF;
+			   } else if (dd->rcd[ctxt]->do_interrupt ==
+				      &handle_receive_interrupt_dma_rtail){
+				__entry->dma_rtail = 1;
+				__entry->slow_path = 0;
+			   } else if (dd->rcd[ctxt]->do_interrupt ==
+				      &handle_receive_interrupt_nodma_rtail) {
+				__entry->dma_rtail = 0;
+				__entry->slow_path = 0;
+			   }
+			   ),
+	    TP_printk("[%s] ctxt %d SlowPath: %d DmaRtail: %d",
+		      __get_str(dev),
+		      __entry->ctxt,
+		      __entry->slow_path,
+		      __entry->dma_rtail
+		      )
 );
 
 TRACE_EVENT(hfi1_exp_tid_reg,
@@ -281,78 +277,72 @@ TRACE_EVENT(hfi1_mmu_invalidate,
 #define TRACE_SYSTEM hfi1_tx
 
 TRACE_EVENT(hfi1_piofree,
-	TP_PROTO(struct send_context *sc, int extra),
-	TP_ARGS(sc, extra),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sc->dd)
-		__field(u32, sw_index)
-		__field(u32, hw_context)
-		__field(int, extra)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sc->dd);
-		__entry->sw_index = sc->sw_index;
-		__entry->hw_context = sc->hw_context;
-		__entry->extra = extra;
-	),
-	TP_printk(
-		"[%s] ctxt %u(%u) extra %d",
-		__get_str(dev),
-		__entry->sw_index,
-		__entry->hw_context,
-		__entry->extra
-	)
+	    TP_PROTO(struct send_context *sc, int extra),
+	    TP_ARGS(sc, extra),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(sc->dd)
+			     __field(u32, sw_index)
+			     __field(u32, hw_context)
+			     __field(int, extra)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(sc->dd);
+			   __entry->sw_index = sc->sw_index;
+			   __entry->hw_context = sc->hw_context;
+			   __entry->extra = extra;
+			   ),
+	    TP_printk("[%s] ctxt %u(%u) extra %d",
+		      __get_str(dev),
+		      __entry->sw_index,
+		      __entry->hw_context,
+		      __entry->extra
+		      )
 );
 
 TRACE_EVENT(hfi1_wantpiointr,
-	TP_PROTO(struct send_context *sc, u32 needint, u64 credit_ctrl),
-	TP_ARGS(sc, needint, credit_ctrl),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sc->dd)
-		__field(u32, sw_index)
-		__field(u32, hw_context)
-		__field(u32, needint)
-		__field(u64, credit_ctrl)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sc->dd);
-		__entry->sw_index = sc->sw_index;
-		__entry->hw_context = sc->hw_context;
-		__entry->needint = needint;
-		__entry->credit_ctrl = credit_ctrl;
-	),
-	TP_printk(
-		"[%s] ctxt %u(%u) on %d credit_ctrl 0x%llx",
-		__get_str(dev),
-		__entry->sw_index,
-		__entry->hw_context,
-		__entry->needint,
-		(unsigned long long)__entry->credit_ctrl
-	)
+	    TP_PROTO(struct send_context *sc, u32 needint, u64 credit_ctrl),
+	    TP_ARGS(sc, needint, credit_ctrl),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(sc->dd)
+			     __field(u32, sw_index)
+			     __field(u32, hw_context)
+			     __field(u32, needint)
+			     __field(u64, credit_ctrl)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(sc->dd);
+			   __entry->sw_index = sc->sw_index;
+			   __entry->hw_context = sc->hw_context;
+			   __entry->needint = needint;
+			   __entry->credit_ctrl = credit_ctrl;
+			   ),
+	    TP_printk("[%s] ctxt %u(%u) on %d credit_ctrl 0x%llx",
+		      __get_str(dev),
+		      __entry->sw_index,
+		      __entry->hw_context,
+		      __entry->needint,
+		      (unsigned long long)__entry->credit_ctrl
+		       )
 );
 
 DECLARE_EVENT_CLASS(hfi1_qpsleepwakeup_template,
-	TP_PROTO(struct rvt_qp *qp, u32 flags),
-	TP_ARGS(qp, flags),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
-		__field(u32, qpn)
-		__field(u32, flags)
-		__field(u32, s_flags)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
-		__entry->flags = flags;
-		__entry->qpn = qp->ibqp.qp_num;
-		__entry->s_flags = qp->s_flags;
-	),
-	TP_printk(
-		"[%s] qpn 0x%x flags 0x%x s_flags 0x%x",
-		__get_str(dev),
-		__entry->qpn,
-		__entry->flags,
-		__entry->s_flags
-	)
+		    TP_PROTO(struct rvt_qp *qp, u32 flags),
+		    TP_ARGS(qp, flags),
+		    TP_STRUCT__entry(
+			    DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
+			    __field(u32, qpn)
+			    __field(u32, flags)
+			    __field(u32, s_flags)
+			    ),
+		    TP_fast_assign(
+			    DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+			    __entry->flags = flags;
+			    __entry->qpn = qp->ibqp.qp_num;
+			    __entry->s_flags = qp->s_flags;
+			    ),
+		    TP_printk(
+			    "[%s] qpn 0x%x flags 0x%x s_flags 0x%x",
+			    __get_str(dev),
+			    __entry->qpn,
+			    __entry->flags,
+			    __entry->s_flags
+			    )
 );
 
 DEFINE_EVENT(hfi1_qpsleepwakeup_template, hfi1_qpwakeup,
@@ -367,16 +357,11 @@ DEFINE_EVENT(hfi1_qpsleepwakeup_template, hfi1_qpsleep,
 #define TRACE_SYSTEM hfi1_ibhdrs
 
 u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr);
-const char *parse_everbs_hdrs(
-	struct trace_seq *p,
-	u8 opcode,
-	void *ehdrs);
+const char *parse_everbs_hdrs(struct trace_seq *p, u8 opcode, void *ehdrs);
 
 #define __parse_ib_ehdrs(op, ehdrs) parse_everbs_hdrs(p, op, ehdrs)
 
-const char *parse_sdma_flags(
-	struct trace_seq *p,
-	u64 desc0, u64 desc1);
+const char *parse_sdma_flags(struct trace_seq *p, u64 desc0, u64 desc1);
 
 #define __parse_sdma_flags(desc0, desc1) parse_sdma_flags(p, desc0, desc1)
 
@@ -433,117 +418,115 @@ __print_symbolic(opcode,                                   \
 #define EHDR_PRN "%s"
 
 DECLARE_EVENT_CLASS(hfi1_ibhdr_template,
-	TP_PROTO(struct hfi1_devdata *dd,
-		 struct hfi1_ib_header *hdr),
-	TP_ARGS(dd, hdr),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd)
-		/* LRH */
-		__field(u8, vl)
-		__field(u8, lver)
-		__field(u8, sl)
-		__field(u8, lnh)
-		__field(u16, dlid)
-		__field(u16, len)
-		__field(u16, slid)
-		/* BTH */
-		__field(u8, opcode)
-		__field(u8, se)
-		__field(u8, m)
-		__field(u8, pad)
-		__field(u8, tver)
-		__field(u16, pkey)
-		__field(u8, f)
-		__field(u8, b)
-		__field(u32, qpn)
-		__field(u8, a)
-		__field(u32, psn)
-		/* extended headers */
-		__dynamic_array(u8, ehdrs, ibhdr_exhdr_len(hdr))
-	),
-	TP_fast_assign(
-		struct hfi1_other_headers *ohdr;
-
-		DD_DEV_ASSIGN(dd);
-		/* LRH */
-		__entry->vl =
-			(u8)(be16_to_cpu(hdr->lrh[0]) >> 12);
-		__entry->lver =
-			(u8)(be16_to_cpu(hdr->lrh[0]) >> 8) & 0xf;
-		__entry->sl =
-			(u8)(be16_to_cpu(hdr->lrh[0]) >> 4) & 0xf;
-		__entry->lnh =
-			(u8)(be16_to_cpu(hdr->lrh[0]) & 3);
-		__entry->dlid =
-			be16_to_cpu(hdr->lrh[1]);
-		/* allow for larger len */
-		__entry->len =
-			be16_to_cpu(hdr->lrh[2]);
-		__entry->slid =
-			be16_to_cpu(hdr->lrh[3]);
-		/* BTH */
-		if (__entry->lnh == HFI1_LRH_BTH)
-			ohdr = &hdr->u.oth;
-		else
-			ohdr = &hdr->u.l.oth;
-		__entry->opcode =
-			(be32_to_cpu(ohdr->bth[0]) >> 24) & 0xff;
-		__entry->se =
-			(be32_to_cpu(ohdr->bth[0]) >> 23) & 1;
-		__entry->m =
-			 (be32_to_cpu(ohdr->bth[0]) >> 22) & 1;
-		__entry->pad =
-			(be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
-		__entry->tver =
-			(be32_to_cpu(ohdr->bth[0]) >> 16) & 0xf;
-		__entry->pkey =
-			be32_to_cpu(ohdr->bth[0]) & 0xffff;
-		__entry->f =
-			(be32_to_cpu(ohdr->bth[1]) >> HFI1_FECN_SHIFT)
-			& HFI1_FECN_MASK;
-		__entry->b =
-			(be32_to_cpu(ohdr->bth[1]) >> HFI1_BECN_SHIFT)
-			& HFI1_BECN_MASK;
-		__entry->qpn =
-			be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
-		__entry->a =
-			(be32_to_cpu(ohdr->bth[2]) >> 31) & 1;
-		/* allow for larger PSN */
-		__entry->psn =
-			be32_to_cpu(ohdr->bth[2]) & 0x7fffffff;
-		/* extended headers */
-		 memcpy(
-			__get_dynamic_array(ehdrs),
-			&ohdr->u,
-			ibhdr_exhdr_len(hdr));
-	),
-	TP_printk("[%s] " LRH_PRN " " BTH_PRN " " EHDR_PRN,
-		__get_str(dev),
-		/* LRH */
-		__entry->vl,
-		__entry->lver,
-		__entry->sl,
-		__entry->lnh, show_lnh(__entry->lnh),
-		__entry->dlid,
-		__entry->len,
-		__entry->slid,
-		/* BTH */
-		__entry->opcode, show_ib_opcode(__entry->opcode),
-		__entry->se,
-		__entry->m,
-		__entry->pad,
-		__entry->tver,
-		__entry->pkey,
-		__entry->f,
-		__entry->b,
-		__entry->qpn,
-		__entry->a,
-		__entry->psn,
-		/* extended headers */
-		__parse_ib_ehdrs(
-			__entry->opcode,
-			(void *)__get_dynamic_array(ehdrs))
-	)
+		    TP_PROTO(struct hfi1_devdata *dd,
+			     struct hfi1_ib_header *hdr),
+		    TP_ARGS(dd, hdr),
+		    TP_STRUCT__entry(
+			    DD_DEV_ENTRY(dd)
+			    /* LRH */
+			    __field(u8, vl)
+			    __field(u8, lver)
+			    __field(u8, sl)
+			    __field(u8, lnh)
+			    __field(u16, dlid)
+			    __field(u16, len)
+			    __field(u16, slid)
+			    /* BTH */
+			    __field(u8, opcode)
+			    __field(u8, se)
+			    __field(u8, m)
+			    __field(u8, pad)
+			    __field(u8, tver)
+			    __field(u16, pkey)
+			    __field(u8, f)
+			    __field(u8, b)
+			    __field(u32, qpn)
+			    __field(u8, a)
+			    __field(u32, psn)
+			    /* extended headers */
+			    __dynamic_array(u8, ehdrs, ibhdr_exhdr_len(hdr))
+			    ),
+		    TP_fast_assign(
+			   struct hfi1_other_headers *ohdr;
+
+			   DD_DEV_ASSIGN(dd);
+			   /* LRH */
+			   __entry->vl =
+			   (u8)(be16_to_cpu(hdr->lrh[0]) >> 12);
+			   __entry->lver =
+			   (u8)(be16_to_cpu(hdr->lrh[0]) >> 8) & 0xf;
+			   __entry->sl =
+			   (u8)(be16_to_cpu(hdr->lrh[0]) >> 4) & 0xf;
+			   __entry->lnh =
+			   (u8)(be16_to_cpu(hdr->lrh[0]) & 3);
+			   __entry->dlid =
+			   be16_to_cpu(hdr->lrh[1]);
+			   /* allow for larger len */
+			   __entry->len =
+			   be16_to_cpu(hdr->lrh[2]);
+			   __entry->slid =
+			   be16_to_cpu(hdr->lrh[3]);
+			   /* BTH */
+			   if (__entry->lnh == HFI1_LRH_BTH)
+				ohdr = &hdr->u.oth;
+			   else
+				ohdr = &hdr->u.l.oth;
+			  __entry->opcode =
+			  (be32_to_cpu(ohdr->bth[0]) >> 24) & 0xff;
+			  __entry->se =
+			  (be32_to_cpu(ohdr->bth[0]) >> 23) & 1;
+			  __entry->m =
+			  (be32_to_cpu(ohdr->bth[0]) >> 22) & 1;
+			  __entry->pad =
+			  (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+			  __entry->tver =
+			  (be32_to_cpu(ohdr->bth[0]) >> 16) & 0xf;
+			  __entry->pkey =
+			  be32_to_cpu(ohdr->bth[0]) & 0xffff;
+			  __entry->f =
+			  (be32_to_cpu(ohdr->bth[1]) >> HFI1_FECN_SHIFT) &
+			  HFI1_FECN_MASK;
+			  __entry->b =
+			  (be32_to_cpu(ohdr->bth[1]) >> HFI1_BECN_SHIFT) &
+			  HFI1_BECN_MASK;
+			  __entry->qpn =
+			  be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
+			  __entry->a =
+			  (be32_to_cpu(ohdr->bth[2]) >> 31) & 1;
+			  /* allow for larger PSN */
+			  __entry->psn =
+			  be32_to_cpu(ohdr->bth[2]) & 0x7fffffff;
+			  /* extended headers */
+			  memcpy(__get_dynamic_array(ehdrs), &ohdr->u,
+				 ibhdr_exhdr_len(hdr));
+			 ),
+		    TP_printk("[%s] " LRH_PRN " " BTH_PRN " " EHDR_PRN,
+			      __get_str(dev),
+			      /* LRH */
+			      __entry->vl,
+			      __entry->lver,
+			      __entry->sl,
+			      __entry->lnh, show_lnh(__entry->lnh),
+			      __entry->dlid,
+			      __entry->len,
+			      __entry->slid,
+			      /* BTH */
+			      __entry->opcode, show_ib_opcode(__entry->opcode),
+			      __entry->se,
+			      __entry->m,
+			      __entry->pad,
+			      __entry->tver,
+			      __entry->pkey,
+			      __entry->f,
+			      __entry->b,
+			      __entry->qpn,
+			      __entry->a,
+			      __entry->psn,
+			      /* extended headers */
+			      __parse_ib_ehdrs(
+					__entry->opcode,
+					(void *)__get_dynamic_array(ehdrs))
+			     )
 );
 
 DEFINE_EVENT(hfi1_ibhdr_template, input_ibhdr,
@@ -562,13 +545,13 @@ DEFINE_EVENT(hfi1_ibhdr_template, output_ibhdr,
 #define TRACE_SYSTEM hfi1_snoop
 
 TRACE_EVENT(snoop_capture,
-	TP_PROTO(struct hfi1_devdata *dd,
-		 int hdr_len,
-		 struct hfi1_ib_header *hdr,
-		 int data_len,
-		 void *data),
-	TP_ARGS(dd, hdr_len, hdr, data_len, data),
-	TP_STRUCT__entry(
+	    TP_PROTO(struct hfi1_devdata *dd,
+		     int hdr_len,
+		     struct hfi1_ib_header *hdr,
+		     int data_len,
+		     void *data),
+	    TP_ARGS(dd, hdr_len, hdr, data_len, data),
+	    TP_STRUCT__entry(
 		DD_DEV_ENTRY(dd)
 		__field(u16, slid)
 		__field(u16, dlid)
@@ -581,8 +564,8 @@ TRACE_EVENT(snoop_capture,
 		__field(u8, lnh)
 		__dynamic_array(u8, raw_hdr, hdr_len)
 		__dynamic_array(u8, raw_pkt, data_len)
-	),
-	TP_fast_assign(
+		),
+	    TP_fast_assign(
 		struct hfi1_other_headers *ohdr;
 
 		__entry->lnh = (u8)(be16_to_cpu(hdr->lrh[0]) & 3);
@@ -601,8 +584,9 @@ TRACE_EVENT(snoop_capture,
 		__entry->data_len = data_len;
 		memcpy(__get_dynamic_array(raw_hdr), hdr, hdr_len);
 		memcpy(__get_dynamic_array(raw_pkt), data, data_len);
-	),
-	TP_printk("[%s] " SNOOP_PRN,
+		),
+	    TP_printk(
+		"[%s] " SNOOP_PRN,
 		__get_str(dev),
 		__entry->slid,
 		__entry->dlid,
@@ -613,7 +597,7 @@ TRACE_EVENT(snoop_capture,
 		__entry->pkey,
 		__entry->hdr_len,
 		__entry->data_len
-	)
+		)
 );
 
 #undef TRACE_SYSTEM
@@ -625,41 +609,39 @@ TRACE_EVENT(snoop_capture,
 TRACE_EVENT(hfi1_uctxtdata,
 	    TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt),
 	    TP_ARGS(dd, uctxt),
-	    TP_STRUCT__entry(
-		    DD_DEV_ENTRY(dd)
-		    __field(unsigned, ctxt)
-		    __field(u32, credits)
-		    __field(u64, hw_free)
-		    __field(u64, piobase)
-		    __field(u16, rcvhdrq_cnt)
-		    __field(u64, rcvhdrq_phys)
-		    __field(u32, eager_cnt)
-		    __field(u64, rcvegr_phys)
-		    ),
-	    TP_fast_assign(
-		    DD_DEV_ASSIGN(dd);
-		    __entry->ctxt = uctxt->ctxt;
-		    __entry->credits = uctxt->sc->credits;
-		    __entry->hw_free = (u64)uctxt->sc->hw_free;
-		    __entry->piobase = (u64)uctxt->sc->base_addr;
-		    __entry->rcvhdrq_cnt = uctxt->rcvhdrq_cnt;
-		    __entry->rcvhdrq_phys = uctxt->rcvhdrq_phys;
-		    __entry->eager_cnt = uctxt->egrbufs.alloced;
-		    __entry->rcvegr_phys = uctxt->egrbufs.rcvtids[0].phys;
-		    ),
-	    TP_printk(
-		    "[%s] ctxt %u " UCTXT_FMT,
-		    __get_str(dev),
-		    __entry->ctxt,
-		    __entry->credits,
-		    __entry->hw_free,
-		    __entry->piobase,
-		    __entry->rcvhdrq_cnt,
-		    __entry->rcvhdrq_phys,
-		    __entry->eager_cnt,
-		    __entry->rcvegr_phys
-		    )
-	);
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+			     __field(unsigned, ctxt)
+			     __field(u32, credits)
+			     __field(u64, hw_free)
+			     __field(u64, piobase)
+			     __field(u16, rcvhdrq_cnt)
+			     __field(u64, rcvhdrq_phys)
+			     __field(u32, eager_cnt)
+			     __field(u64, rcvegr_phys)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd);
+			   __entry->ctxt = uctxt->ctxt;
+			   __entry->credits = uctxt->sc->credits;
+			   __entry->hw_free = (u64)uctxt->sc->hw_free;
+			   __entry->piobase = (u64)uctxt->sc->base_addr;
+			   __entry->rcvhdrq_cnt = uctxt->rcvhdrq_cnt;
+			   __entry->rcvhdrq_phys = uctxt->rcvhdrq_phys;
+			   __entry->eager_cnt = uctxt->egrbufs.alloced;
+			   __entry->rcvegr_phys =
+			   uctxt->egrbufs.rcvtids[0].phys;
+			   ),
+	    TP_printk("[%s] ctxt %u " UCTXT_FMT,
+		      __get_str(dev),
+		      __entry->ctxt,
+		      __entry->credits,
+		      __entry->hw_free,
+		      __entry->piobase,
+		      __entry->rcvhdrq_cnt,
+		      __entry->rcvhdrq_phys,
+		      __entry->eager_cnt,
+		      __entry->rcvegr_phys
+		      )
+);
 
 #define CINFO_FMT \
 	"egrtids:%u, egr_size:%u, hdrq_cnt:%u, hdrq_size:%u, sdma_ring_size:%u"
@@ -667,38 +649,35 @@ TRACE_EVENT(hfi1_ctxt_info,
 	    TP_PROTO(struct hfi1_devdata *dd, unsigned ctxt, unsigned subctxt,
 		     struct hfi1_ctxt_info cinfo),
 	    TP_ARGS(dd, ctxt, subctxt, cinfo),
-	    TP_STRUCT__entry(
-		    DD_DEV_ENTRY(dd)
-		    __field(unsigned, ctxt)
-		    __field(unsigned, subctxt)
-		    __field(u16, egrtids)
-		    __field(u16, rcvhdrq_cnt)
-		    __field(u16, rcvhdrq_size)
-		    __field(u16, sdma_ring_size)
-		    __field(u32, rcvegr_size)
-		    ),
-	    TP_fast_assign(
-		    DD_DEV_ASSIGN(dd);
-		    __entry->ctxt = ctxt;
-		    __entry->subctxt = subctxt;
-		    __entry->egrtids = cinfo.egrtids;
-		    __entry->rcvhdrq_cnt = cinfo.rcvhdrq_cnt;
-		    __entry->rcvhdrq_size = cinfo.rcvhdrq_entsize;
-		    __entry->sdma_ring_size = cinfo.sdma_ring_size;
-		    __entry->rcvegr_size = cinfo.rcvegr_size;
-		    ),
-	    TP_printk(
-		    "[%s] ctxt %u:%u " CINFO_FMT,
-		    __get_str(dev),
-		    __entry->ctxt,
-		    __entry->subctxt,
-		    __entry->egrtids,
-		    __entry->rcvegr_size,
-		    __entry->rcvhdrq_cnt,
-		    __entry->rcvhdrq_size,
-		    __entry->sdma_ring_size
-		    )
-	);
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+			     __field(unsigned, ctxt)
+			     __field(unsigned, subctxt)
+			     __field(u16, egrtids)
+			     __field(u16, rcvhdrq_cnt)
+			     __field(u16, rcvhdrq_size)
+			     __field(u16, sdma_ring_size)
+			     __field(u32, rcvegr_size)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd);
+			    __entry->ctxt = ctxt;
+			    __entry->subctxt = subctxt;
+			    __entry->egrtids = cinfo.egrtids;
+			    __entry->rcvhdrq_cnt = cinfo.rcvhdrq_cnt;
+			    __entry->rcvhdrq_size = cinfo.rcvhdrq_entsize;
+			    __entry->sdma_ring_size = cinfo.sdma_ring_size;
+			    __entry->rcvegr_size = cinfo.rcvegr_size;
+			    ),
+	    TP_printk("[%s] ctxt %u:%u " CINFO_FMT,
+		      __get_str(dev),
+		      __entry->ctxt,
+		      __entry->subctxt,
+		      __entry->egrtids,
+		      __entry->rcvegr_size,
+		      __entry->rcvhdrq_cnt,
+		      __entry->rcvhdrq_size,
+		      __entry->sdma_ring_size
+		      )
+);
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_sma
@@ -712,49 +691,46 @@ TRACE_EVENT(hfi1_ctxt_info,
 	)
 
 DECLARE_EVENT_CLASS(hfi1_bct_template,
-	TP_PROTO(struct hfi1_devdata *dd, struct buffer_control *bc),
-	TP_ARGS(dd, bc),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd)
-		__dynamic_array(u8, bct, sizeof(*bc))
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd);
-		memcpy(
-			__get_dynamic_array(bct),
-			bc,
-			sizeof(*bc));
-	),
-	TP_printk(BCT_FORMAT,
-		BCT(overall_shared_limit),
-
-		BCT(vl[0].dedicated),
-		BCT(vl[0].shared),
-
-		BCT(vl[1].dedicated),
-		BCT(vl[1].shared),
-
-		BCT(vl[2].dedicated),
-		BCT(vl[2].shared),
-
-		BCT(vl[3].dedicated),
-		BCT(vl[3].shared),
-
-		BCT(vl[4].dedicated),
-		BCT(vl[4].shared),
-
-		BCT(vl[5].dedicated),
-		BCT(vl[5].shared),
-
-		BCT(vl[6].dedicated),
-		BCT(vl[6].shared),
-
-		BCT(vl[7].dedicated),
-		BCT(vl[7].shared),
-
-		BCT(vl[15].dedicated),
-		BCT(vl[15].shared)
-	)
+		    TP_PROTO(struct hfi1_devdata *dd,
+			     struct buffer_control *bc),
+		    TP_ARGS(dd, bc),
+		    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+				     __dynamic_array(u8, bct, sizeof(*bc))
+				     ),
+		    TP_fast_assign(DD_DEV_ASSIGN(dd);
+				   memcpy(__get_dynamic_array(bct), bc,
+					  sizeof(*bc));
+				   ),
+		    TP_printk(BCT_FORMAT,
+			      BCT(overall_shared_limit),
+
+			      BCT(vl[0].dedicated),
+			      BCT(vl[0].shared),
+
+			      BCT(vl[1].dedicated),
+			      BCT(vl[1].shared),
+
+			      BCT(vl[2].dedicated),
+			      BCT(vl[2].shared),
+
+			      BCT(vl[3].dedicated),
+			      BCT(vl[3].shared),
+
+			      BCT(vl[4].dedicated),
+			      BCT(vl[4].shared),
+
+			      BCT(vl[5].dedicated),
+			      BCT(vl[5].shared),
+
+			      BCT(vl[6].dedicated),
+			      BCT(vl[6].shared),
+
+			      BCT(vl[7].dedicated),
+			      BCT(vl[7].shared),
+
+			      BCT(vl[15].dedicated),
+			      BCT(vl[15].shared)
+			      )
 );
 
 DEFINE_EVENT(hfi1_bct_template, bct_set,
@@ -769,252 +745,209 @@ DEFINE_EVENT(hfi1_bct_template, bct_get,
 #define TRACE_SYSTEM hfi1_sdma
 
 TRACE_EVENT(hfi1_sdma_descriptor,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		u64 desc0,
-		u64 desc1,
-		u16 e,
-		void *descp),
+	    TP_PROTO(struct sdma_engine *sde,
+		     u64 desc0,
+		     u64 desc1,
+		     u16 e,
+		     void *descp),
 	TP_ARGS(sde, desc0, desc1, e, descp),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__field(void *, descp)
-		__field(u64, desc0)
-		__field(u64, desc1)
-		__field(u16, e)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__entry->desc0 = desc0;
-		__entry->desc1 = desc1;
-		__entry->idx = sde->this_idx;
-		__entry->descp = descp;
-		__entry->e = e;
-	),
+	TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+			 __field(void *, descp)
+			 __field(u64, desc0)
+			 __field(u64, desc1)
+			 __field(u16, e)
+			 __field(u8, idx)
+			 ),
+	TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+		       __entry->desc0 = desc0;
+		       __entry->desc1 = desc1;
+		       __entry->idx = sde->this_idx;
+		       __entry->descp = descp;
+		       __entry->e = e;
+		       ),
 	TP_printk(
-		"[%s] SDE(%u) flags:%s addr:0x%016llx gen:%u len:%u d0:%016llx d1:%016llx to %p,%u",
-		__get_str(dev),
-		__entry->idx,
-		__parse_sdma_flags(__entry->desc0, __entry->desc1),
-		(__entry->desc0 >> SDMA_DESC0_PHY_ADDR_SHIFT)
-			& SDMA_DESC0_PHY_ADDR_MASK,
-		(u8)((__entry->desc1 >> SDMA_DESC1_GENERATION_SHIFT)
-			& SDMA_DESC1_GENERATION_MASK),
-		(u16)((__entry->desc0 >> SDMA_DESC0_BYTE_COUNT_SHIFT)
-			& SDMA_DESC0_BYTE_COUNT_MASK),
-		__entry->desc0,
-		__entry->desc1,
-		__entry->descp,
-		__entry->e
-	)
+		  "[%s] SDE(%u) flags:%s addr:0x%016llx gen:%u len:%u d0:%016llx d1:%016llx to %p,%u",
+		  __get_str(dev),
+		  __entry->idx,
+		  __parse_sdma_flags(__entry->desc0, __entry->desc1),
+		  (__entry->desc0 >> SDMA_DESC0_PHY_ADDR_SHIFT) &
+		  SDMA_DESC0_PHY_ADDR_MASK,
+		  (u8)((__entry->desc1 >> SDMA_DESC1_GENERATION_SHIFT) &
+		       SDMA_DESC1_GENERATION_MASK),
+		  (u16)((__entry->desc0 >> SDMA_DESC0_BYTE_COUNT_SHIFT) &
+			SDMA_DESC0_BYTE_COUNT_MASK),
+		  __entry->desc0,
+		  __entry->desc1,
+		  __entry->descp,
+		  __entry->e
+		  )
 );
 
 TRACE_EVENT(hfi1_sdma_engine_select,
-	TP_PROTO(struct hfi1_devdata *dd, u32 sel, u8 vl, u8 idx),
-	TP_ARGS(dd, sel, vl, idx),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd)
-		__field(u32, sel)
-		__field(u8, vl)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd);
-		__entry->sel = sel;
-		__entry->vl = vl;
-		__entry->idx = idx;
-	),
-	TP_printk(
-		"[%s] selecting SDE %u sel 0x%x vl %u",
-		__get_str(dev),
-		__entry->idx,
-		__entry->sel,
-		__entry->vl
-	)
+	    TP_PROTO(struct hfi1_devdata *dd, u32 sel, u8 vl, u8 idx),
+	    TP_ARGS(dd, sel, vl, idx),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+			     __field(u32, sel)
+			     __field(u8, vl)
+			     __field(u8, idx)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd);
+			   __entry->sel = sel;
+			   __entry->vl = vl;
+			   __entry->idx = idx;
+			   ),
+	    TP_printk("[%s] selecting SDE %u sel 0x%x vl %u",
+		      __get_str(dev),
+		      __entry->idx,
+		      __entry->sel,
+		      __entry->vl
+		      )
 );
 
 DECLARE_EVENT_CLASS(hfi1_sdma_engine_class,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		u64 status
-	),
-	TP_ARGS(sde, status),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__field(u64, status)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__entry->status = status;
-		__entry->idx = sde->this_idx;
-	),
-	TP_printk(
-		"[%s] SDE(%u) status %llx",
-		__get_str(dev),
-		__entry->idx,
-		(unsigned long long)__entry->status
-	)
+		    TP_PROTO(struct sdma_engine *sde, u64 status),
+		    TP_ARGS(sde, status),
+		    TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+				     __field(u64, status)
+				     __field(u8, idx)
+				     ),
+		    TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+				   __entry->status = status;
+				   __entry->idx = sde->this_idx;
+				   ),
+		    TP_printk("[%s] SDE(%u) status %llx",
+			      __get_str(dev),
+			      __entry->idx,
+			      (unsigned long long)__entry->status
+			      )
 );
 
 DEFINE_EVENT(hfi1_sdma_engine_class, hfi1_sdma_engine_interrupt,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		u64 status
-	),
-	TP_ARGS(sde, status)
+	     TP_PROTO(struct sdma_engine *sde, u64 status),
+	     TP_ARGS(sde, status)
 );
 
 DEFINE_EVENT(hfi1_sdma_engine_class, hfi1_sdma_engine_progress,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		u64 status
-	),
-	TP_ARGS(sde, status)
+	     TP_PROTO(struct sdma_engine *sde, u64 status),
+	     TP_ARGS(sde, status)
 );
 
 DECLARE_EVENT_CLASS(hfi1_sdma_ahg_ad,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		int aidx
-	),
-	TP_ARGS(sde, aidx),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__field(int, aidx)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__entry->idx = sde->this_idx;
-		__entry->aidx = aidx;
-	),
-	TP_printk(
-		"[%s] SDE(%u) aidx %d",
-		__get_str(dev),
-		__entry->idx,
-		__entry->aidx
-	)
+		    TP_PROTO(struct sdma_engine *sde, int aidx),
+		    TP_ARGS(sde, aidx),
+		    TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+				     __field(int, aidx)
+				     __field(u8, idx)
+				     ),
+		    TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+				   __entry->idx = sde->this_idx;
+				   __entry->aidx = aidx;
+				   ),
+		    TP_printk("[%s] SDE(%u) aidx %d",
+			      __get_str(dev),
+			      __entry->idx,
+			      __entry->aidx
+			      )
 );
 
 DEFINE_EVENT(hfi1_sdma_ahg_ad, hfi1_ahg_allocate,
-	     TP_PROTO(
-		struct sdma_engine *sde,
-		int aidx
-	     ),
+	     TP_PROTO(struct sdma_engine *sde, int aidx),
 	     TP_ARGS(sde, aidx));
 
 DEFINE_EVENT(hfi1_sdma_ahg_ad, hfi1_ahg_deallocate,
-	     TP_PROTO(
-		struct sdma_engine *sde,
-		int aidx
-	     ),
+	     TP_PROTO(struct sdma_engine *sde, int aidx),
 	     TP_ARGS(sde, aidx));
 
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
 TRACE_EVENT(hfi1_sdma_progress,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		u16 hwhead,
-		u16 swhead,
-		struct sdma_txreq *txp
-	),
-	TP_ARGS(sde, hwhead, swhead, txp),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__field(u64, sn)
-		__field(u16, hwhead)
-		__field(u16, swhead)
-		__field(u16, txnext)
-		__field(u16, tx_tail)
-		__field(u16, tx_head)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__entry->hwhead = hwhead;
-		__entry->swhead = swhead;
-		__entry->tx_tail = sde->tx_tail;
-		__entry->tx_head = sde->tx_head;
-		__entry->txnext = txp ? txp->next_descq_idx : ~0;
-		__entry->idx = sde->this_idx;
-		__entry->sn = txp ? txp->sn : ~0;
-	),
-	TP_printk(
-		"[%s] SDE(%u) sn %llu hwhead %u swhead %u next_descq_idx %u tx_head %u tx_tail %u",
-		__get_str(dev),
-		__entry->idx,
-		__entry->sn,
-		__entry->hwhead,
-		__entry->swhead,
-		__entry->txnext,
-		__entry->tx_head,
-		__entry->tx_tail
-	)
+	    TP_PROTO(struct sdma_engine *sde,
+		     u16 hwhead,
+		     u16 swhead,
+		     struct sdma_txreq *txp
+		     ),
+	    TP_ARGS(sde, hwhead, swhead, txp),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+			     __field(u64, sn)
+			     __field(u16, hwhead)
+			     __field(u16, swhead)
+			     __field(u16, txnext)
+			     __field(u16, tx_tail)
+			     __field(u16, tx_head)
+			     __field(u8, idx)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+			   __entry->hwhead = hwhead;
+			   __entry->swhead = swhead;
+			   __entry->tx_tail = sde->tx_tail;
+			   __entry->tx_head = sde->tx_head;
+			   __entry->txnext = txp ? txp->next_descq_idx : ~0;
+			   __entry->idx = sde->this_idx;
+			   __entry->sn = txp ? txp->sn : ~0;
+			   ),
+	    TP_printk(
+		      "[%s] SDE(%u) sn %llu hwhead %u swhead %u next_descq_idx %u tx_head %u tx_tail %u",
+		      __get_str(dev),
+		      __entry->idx,
+		      __entry->sn,
+		      __entry->hwhead,
+		      __entry->swhead,
+		      __entry->txnext,
+		      __entry->tx_head,
+		      __entry->tx_tail
+		      )
 );
 #else
 TRACE_EVENT(hfi1_sdma_progress,
-	    TP_PROTO(
-		struct sdma_engine *sde,
-		u16 hwhead,
-		u16 swhead,
-		struct sdma_txreq *txp
+	    TP_PROTO(struct sdma_engine *sde,
+		     u16 hwhead, u16 swhead,
+		     struct sdma_txreq *txp
 	    ),
 	TP_ARGS(sde, hwhead, swhead, txp),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__field(u16, hwhead)
-		__field(u16, swhead)
-		__field(u16, txnext)
-		__field(u16, tx_tail)
-		__field(u16, tx_head)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__entry->hwhead = hwhead;
-		__entry->swhead = swhead;
-		__entry->tx_tail = sde->tx_tail;
-		__entry->tx_head = sde->tx_head;
-		__entry->txnext = txp ? txp->next_descq_idx : ~0;
-		__entry->idx = sde->this_idx;
-	),
+	TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+			 __field(u16, hwhead)
+			 __field(u16, swhead)
+			 __field(u16, txnext)
+			 __field(u16, tx_tail)
+			 __field(u16, tx_head)
+			 __field(u8, idx)
+			 ),
+	TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+		       __entry->hwhead = hwhead;
+		       __entry->swhead = swhead;
+		       __entry->tx_tail = sde->tx_tail;
+		       __entry->tx_head = sde->tx_head;
+		       __entry->txnext = txp ? txp->next_descq_idx : ~0;
+		       __entry->idx = sde->this_idx;
+		       ),
 	TP_printk(
-		"[%s] SDE(%u) hwhead %u swhead %u next_descq_idx %u tx_head %u tx_tail %u",
-		__get_str(dev),
-		__entry->idx,
-		__entry->hwhead,
-		__entry->swhead,
-		__entry->txnext,
-		__entry->tx_head,
-		__entry->tx_tail
-	)
+		  "[%s] SDE(%u) hwhead %u swhead %u next_descq_idx %u tx_head %u tx_tail %u",
+		  __get_str(dev),
+		  __entry->idx,
+		  __entry->hwhead,
+		  __entry->swhead,
+		  __entry->txnext,
+		  __entry->tx_head,
+		  __entry->tx_tail
+		  )
 );
 #endif
 
 DECLARE_EVENT_CLASS(hfi1_sdma_sn,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		u64 sn
-	),
-	TP_ARGS(sde, sn),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__field(u64, sn)
-		__field(u8, idx)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__entry->sn = sn;
-		__entry->idx = sde->this_idx;
-	),
-	TP_printk(
-		"[%s] SDE(%u) sn %llu",
-		__get_str(dev),
-		__entry->idx,
-		__entry->sn
-	)
+		    TP_PROTO(struct sdma_engine *sde, u64 sn),
+		    TP_ARGS(sde, sn),
+		    TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+				     __field(u64, sn)
+				     __field(u8, idx)
+				     ),
+		    TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+				   __entry->sn = sn;
+				   __entry->idx = sde->this_idx;
+				   ),
+		    TP_printk("[%s] SDE(%u) sn %llu",
+			      __get_str(dev),
+			      __entry->idx,
+			      __entry->sn
+			      )
 );
 
 DEFINE_EVENT(hfi1_sdma_sn, hfi1_sdma_out_sn,
@@ -1026,10 +959,7 @@ DEFINE_EVENT(hfi1_sdma_sn, hfi1_sdma_out_sn,
 );
 
 DEFINE_EVENT(hfi1_sdma_sn, hfi1_sdma_in_sn,
-	     TP_PROTO(
-		struct sdma_engine *sde,
-		u64 sn
-	     ),
+	     TP_PROTO(struct sdma_engine *sde, u64 sn),
 	     TP_ARGS(sde, sn)
 );
 
@@ -1230,69 +1160,66 @@ TRACE_EVENT(hfi1_sdma_user_header_ahg,
 	);
 
 TRACE_EVENT(hfi1_sdma_state,
-	TP_PROTO(
-		struct sdma_engine *sde,
-		const char *cstate,
-		const char *nstate
-	),
-	TP_ARGS(sde, cstate, nstate),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(sde->dd)
-		__string(curstate, cstate)
-		__string(newstate, nstate)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(sde->dd);
-		__assign_str(curstate, cstate);
-		__assign_str(newstate, nstate);
-	),
+	    TP_PROTO(struct sdma_engine *sde,
+		     const char *cstate,
+		     const char *nstate
+		     ),
+	    TP_ARGS(sde, cstate, nstate),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(sde->dd)
+			     __string(curstate, cstate)
+			     __string(newstate, nstate)
+			     ),
+	TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
+		       __assign_str(curstate, cstate);
+		       __assign_str(newstate, nstate);
+		       ),
 	TP_printk("[%s] current state %s new state %s",
-		__get_str(dev),
-		__get_str(curstate),
-		__get_str(newstate)
-	)
+		  __get_str(dev),
+		  __get_str(curstate),
+		  __get_str(newstate)
+		  )
 );
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_rc
 
 DECLARE_EVENT_CLASS(hfi1_rc_template,
-	TP_PROTO(struct rvt_qp *qp, u32 psn),
-	TP_ARGS(qp, psn),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
-		__field(u32, qpn)
-		__field(u32, s_flags)
-		__field(u32, psn)
-		__field(u32, s_psn)
-		__field(u32, s_next_psn)
-		__field(u32, s_sending_psn)
-		__field(u32, s_sending_hpsn)
-		__field(u32, r_psn)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
-		__entry->qpn = qp->ibqp.qp_num;
-		__entry->s_flags = qp->s_flags;
-		__entry->psn = psn;
-		__entry->s_psn = qp->s_psn;
-		__entry->s_next_psn = qp->s_next_psn;
-		__entry->s_sending_psn = qp->s_sending_psn;
-		__entry->s_sending_hpsn = qp->s_sending_hpsn;
-		__entry->r_psn = qp->r_psn;
-	),
-	TP_printk(
-		"[%s] qpn 0x%x s_flags 0x%x psn 0x%x s_psn 0x%x s_next_psn 0x%x s_sending_psn 0x%x sending_hpsn 0x%x r_psn 0x%x",
-		__get_str(dev),
-		__entry->qpn,
-		__entry->s_flags,
-		__entry->psn,
-		__entry->s_psn,
-		__entry->s_next_psn,
-		__entry->s_sending_psn,
-		__entry->s_sending_hpsn,
-		__entry->r_psn
-	)
+		    TP_PROTO(struct rvt_qp *qp, u32 psn),
+		    TP_ARGS(qp, psn),
+		    TP_STRUCT__entry(
+			DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
+			__field(u32, qpn)
+			__field(u32, s_flags)
+			__field(u32, psn)
+			__field(u32, s_psn)
+			__field(u32, s_next_psn)
+			__field(u32, s_sending_psn)
+			__field(u32, s_sending_hpsn)
+			__field(u32, r_psn)
+			),
+		    TP_fast_assign(
+			DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+			__entry->qpn = qp->ibqp.qp_num;
+			__entry->s_flags = qp->s_flags;
+			__entry->psn = psn;
+			__entry->s_psn = qp->s_psn;
+			__entry->s_next_psn = qp->s_next_psn;
+			__entry->s_sending_psn = qp->s_sending_psn;
+			__entry->s_sending_hpsn = qp->s_sending_hpsn;
+			__entry->r_psn = qp->r_psn;
+			),
+		    TP_printk(
+			"[%s] qpn 0x%x s_flags 0x%x psn 0x%x s_psn 0x%x s_next_psn 0x%x s_sending_psn 0x%x sending_hpsn 0x%x r_psn 0x%x",
+			__get_str(dev),
+			__entry->qpn,
+			__entry->s_flags,
+			__entry->psn,
+			__entry->s_psn,
+			__entry->s_next_psn,
+			__entry->s_sending_psn,
+			__entry->s_sending_hpsn,
+			__entry->r_psn
+			)
 );
 
 DEFINE_EVENT(hfi1_rc_template, hfi1_rc_sendcomplete,
@@ -1319,21 +1246,20 @@ DEFINE_EVENT(hfi1_rc_template, hfi1_rc_rcv_error,
 #define TRACE_SYSTEM hfi1_misc
 
 TRACE_EVENT(hfi1_interrupt,
-	TP_PROTO(struct hfi1_devdata *dd, const struct is_table *is_entry,
-		 int src),
-	TP_ARGS(dd, is_entry, src),
-	TP_STRUCT__entry(
-		DD_DEV_ENTRY(dd)
-		__array(char, buf, 64)
-		__field(int, src)
-	),
-	TP_fast_assign(
-		DD_DEV_ASSIGN(dd)
-		is_entry->is_name(__entry->buf, 64, src - is_entry->start);
-		__entry->src = src;
-	),
-	TP_printk("[%s] source: %s [%d]", __get_str(dev), __entry->buf,
-		  __entry->src)
+	    TP_PROTO(struct hfi1_devdata *dd, const struct is_table *is_entry,
+		     int src),
+	    TP_ARGS(dd, is_entry, src),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+			     __array(char, buf, 64)
+			     __field(int, src)
+			     ),
+	    TP_fast_assign(DD_DEV_ASSIGN(dd)
+			   is_entry->is_name(__entry->buf, 64,
+					     src - is_entry->start);
+			   __entry->src = src;
+			   ),
+	    TP_printk("[%s] source: %s [%d]", __get_str(dev), __entry->buf,
+		      __entry->src)
 );
 
 /*
@@ -1348,21 +1274,21 @@ TRACE_EVENT(hfi1_interrupt,
 #define MAX_MSG_LEN 512
 
 DECLARE_EVENT_CLASS(hfi1_trace_template,
-	TP_PROTO(const char *function, struct va_format *vaf),
-	TP_ARGS(function, vaf),
-	TP_STRUCT__entry(
-		__string(function, function)
-		__dynamic_array(char, msg, MAX_MSG_LEN)
-	),
-	TP_fast_assign(
-		__assign_str(function, function);
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-		     MAX_MSG_LEN, vaf->fmt,
-		     *vaf->va) >= MAX_MSG_LEN);
-	),
-	TP_printk("(%s) %s",
-		  __get_str(function),
-		  __get_str(msg))
+		    TP_PROTO(const char *function, struct va_format *vaf),
+		    TP_ARGS(function, vaf),
+		    TP_STRUCT__entry(__string(function, function)
+				     __dynamic_array(char, msg, MAX_MSG_LEN)
+				     ),
+		    TP_fast_assign(__assign_str(function, function);
+				   WARN_ON_ONCE(vsnprintf
+						(__get_dynamic_array(msg),
+						 MAX_MSG_LEN, vaf->fmt,
+						 *vaf->va) >=
+						MAX_MSG_LEN);
+				   ),
+		    TP_printk("(%s) %s",
+			      __get_str(function),
+			      __get_str(msg))
 );
 
 /*
diff --git a/drivers/staging/rdma/hfi1/twsi.c b/drivers/staging/rdma/hfi1/twsi.c
index d7dfdd2..6c7f198 100644
--- a/drivers/staging/rdma/hfi1/twsi.c
+++ b/drivers/staging/rdma/hfi1/twsi.c
@@ -131,7 +131,7 @@ static void scl_out(struct hfi1_devdata *dd, u32 target, u8 bit)
 		}
 		if (rise_usec <= 0)
 			dd_dev_err(dd, "SCL interface stuck low > %d uSec\n",
-				    SCL_WAIT_USEC);
+				   SCL_WAIT_USEC);
 	}
 	i2c_wait_for_writes(dd, target);
 }
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 8915401..e24cb62 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -318,7 +318,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 			sl = ibp->sc_to_sl[sc5];
 
 			process_becn(ppd, sl, rlid, lqpn, rqpn,
-					IB_CC_SVCTYPE_UC);
+				     IB_CC_SVCTYPE_UC);
 		}
 
 		if (bth1 & HFI1_FECN_SMASK) {
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index c3f0697..ea8f706 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -320,9 +320,10 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	if (ah_attr->dlid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
 	    ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE)) {
 		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
-		if (unlikely(!loopback && (lid == ppd->lid ||
-		    (lid == be16_to_cpu(IB_LID_PERMISSIVE) &&
-		     qp->ibqp.qp_type == IB_QPT_GSI)))) {
+		if (unlikely(!loopback &&
+			     (lid == ppd->lid ||
+			      (lid == be16_to_cpu(IB_LID_PERMISSIVE) &&
+			      qp->ibqp.qp_type == IB_QPT_GSI)))) {
 			unsigned long flags;
 			/*
 			 * If DMAs are in progress, we can't generate
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index b6d0926..ce94cbc 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -728,7 +728,7 @@ free_req:
 }
 
 static inline u32 compute_data_length(struct user_sdma_request *req,
-					    struct user_sdma_txreq *tx)
+				      struct user_sdma_txreq *tx)
 {
 	/*
 	 * Determine the proper size of the packet data.
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index c412f1c..275af19 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -970,7 +970,8 @@ static inline int egress_pkey_check(struct hfi1_pportdata *ppd,
 
 	/* The most likely matching pkey has index qp->s_pkey_index */
 	if (unlikely(!egress_pkey_matches_entry(pkey,
-					ppd->pkeys[qp->s_pkey_index]))) {
+						ppd->pkeys
+						[qp->s_pkey_index]))) {
 		/* no match - try the entire table */
 		for (; i < MAX_PKEY_VALUES; i++) {
 			if (egress_pkey_matches_entry(pkey, ppd->pkeys[i]))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
