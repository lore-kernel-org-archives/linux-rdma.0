From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/54] staging/rdma/hfi1: Fix per-VL transmit discard counts
Date: Wed, 03 Feb 2016 14:31:49 -0800
Message-ID: <20160203223145.5923.63961.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Implement per-VL transmit counters.  Not all errors can be
attributed to a particular VL, so make a best attempt.
o Extend the egress error bits used to count toward transmit
  discard.
o When an egress error or send error occur, try to map back
  to a VL.
o Implement a SDMA engine to VL (back) map.
o Add per-VL port transmit counters

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |  138 +++++++++++++++++++++++++++++++-------
 drivers/staging/rdma/hfi1/hfi.h  |    3 +
 drivers/staging/rdma/hfi1/sdma.c |    6 ++
 drivers/staging/rdma/hfi1/sdma.h |    2 +
 4 files changed, 123 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 41af05e..108cd48 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -510,6 +510,12 @@ static struct flag_table sdma_err_status_flags[] = {
 		| SEND_DMA_ERR_STATUS_SDMA_CSR_PARITY_ERR_SMASK \
 		| SEND_DMA_ERR_STATUS_SDMA_PCIE_REQ_TRACKING_UNC_ERR_SMASK)
 
+/* SendEgressErrInfo bits that correspond to a PortXmitDiscard counter */
+#define PORT_DISCARD_EGRESS_ERRS \
+	(SEND_EGRESS_ERR_INFO_TOO_LONG_IB_PACKET_ERR_SMASK \
+	| SEND_EGRESS_ERR_INFO_VL_MAPPING_ERR_SMASK \
+	| SEND_EGRESS_ERR_INFO_VL_ERR_SMASK)
+
 /*
  * TXE Egress Error flags
  */
@@ -1481,12 +1487,18 @@ static u64 access_sw_unknown_frame_cnt(const struct cntr_entry *entry,
 static u64 access_sw_xmit_discards(const struct cntr_entry *entry,
 				    void *context, int vl, int mode, u64 data)
 {
-	struct hfi1_pportdata *ppd = context;
+	struct hfi1_pportdata *ppd = (struct hfi1_pportdata *)context;
+	u64 zero = 0;
+	u64 *counter;
 
-	if (vl != CNTR_INVALID_VL)
-		return 0;
+	if (vl == CNTR_INVALID_VL)
+		counter = &ppd->port_xmit_discards;
+	else if (vl >= 0 && vl < C_VL_COUNT)
+		counter = &ppd->port_xmit_discards_vl[vl];
+	else
+		counter = &zero;
 
-	return read_write_sw(ppd->dd, &ppd->port_xmit_discards, mode, data);
+	return read_write_sw(ppd->dd, counter, mode, data);
 }
 
 static u64 access_xmit_constraint_errs(const struct cntr_entry *entry,
@@ -5508,12 +5520,14 @@ static void handle_sdma_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	}
 }
 
-static void count_port_inactive(struct hfi1_devdata *dd)
+static inline void __count_port_discards(struct hfi1_pportdata *ppd)
 {
-	struct hfi1_pportdata *ppd = dd->pport;
+	incr_cntr64(&ppd->port_xmit_discards);
+}
 
-	if (ppd->port_xmit_discards < ~(u64)0)
-		ppd->port_xmit_discards++;
+static void count_port_inactive(struct hfi1_devdata *dd)
+{
+	__count_port_discards(dd->pport);
 }
 
 /*
@@ -5525,7 +5539,8 @@ static void count_port_inactive(struct hfi1_devdata *dd)
  * egress error if more than one packet fails the same integrity check
  * since we cleared the corresponding bit in SEND_EGRESS_ERR_INFO.
  */
-static void handle_send_egress_err_info(struct hfi1_devdata *dd)
+static void handle_send_egress_err_info(struct hfi1_devdata *dd,
+					int vl)
 {
 	struct hfi1_pportdata *ppd = dd->pport;
 	u64 src = read_csr(dd, SEND_EGRESS_ERR_SOURCE); /* read first */
@@ -5540,10 +5555,24 @@ static void handle_send_egress_err_info(struct hfi1_devdata *dd)
 		info, egress_err_info_string(buf, sizeof(buf), info), src);
 
 	/* Eventually add other counters for each bit */
+	if (info & PORT_DISCARD_EGRESS_ERRS) {
+		int weight, i;
 
-	if (info & SEND_EGRESS_ERR_INFO_TOO_LONG_IB_PACKET_ERR_SMASK) {
-		if (ppd->port_xmit_discards < ~(u64)0)
-			ppd->port_xmit_discards++;
+		/*
+		 * Count all, in case multiple bits are set.  Reminder:
+		 * since there is only one info register for many sources,
+		 * these may be attributed to the wrong VL if they occur
+		 * too close together.
+		 */
+		weight = hweight64(info);
+		for (i = 0; i < weight; i++) {
+			__count_port_discards(ppd);
+			if (vl >= 0 && vl < TXE_NUM_DATA_VL)
+				incr_cntr64(&ppd->port_xmit_discards_vl[vl]);
+			else if (vl == 15)
+				incr_cntr64(&ppd->port_xmit_discards_vl
+					    [C_VL_15]);
+		}
 	}
 }
 
@@ -5561,12 +5590,71 @@ static inline int port_inactive_err(u64 posn)
  * Input value is a bit position within the SEND_EGRESS_ERR_STATUS
  * register. Does it represent a 'disallowed packet' error?
  */
-static inline int disallowed_pkt_err(u64 posn)
+static inline int disallowed_pkt_err(int posn)
 {
 	return (posn >= SEES(TX_SDMA0_DISALLOWED_PACKET) &&
 		posn <= SEES(TX_SDMA15_DISALLOWED_PACKET));
 }
 
+/*
+ * Input value is a bit position of one of the SDMA engine disallowed
+ * packet errors.  Return which engine.  Use of this must be guarded by
+ * disallowed_pkt_err().
+ */
+static inline int disallowed_pkt_engine(int posn)
+{
+	return posn - SEES(TX_SDMA0_DISALLOWED_PACKET);
+}
+
+/*
+ * Translate an SDMA engine to a VL.  Return -1 if the tranlation cannot
+ * be done.
+ */
+static int engine_to_vl(struct hfi1_devdata *dd, int engine)
+{
+	struct sdma_vl_map *m;
+	int vl;
+
+	/* range check */
+	if (engine < 0 || engine >= TXE_NUM_SDMA_ENGINES)
+		return -1;
+
+	rcu_read_lock();
+	m = rcu_dereference(dd->sdma_map);
+	vl = m->engine_to_vl[engine];
+	rcu_read_unlock();
+
+	return vl;
+}
+
+/*
+ * Translate the send context (sofware index) into a VL.  Return -1 if the
+ * translation cannot be done.
+ */
+static int sc_to_vl(struct hfi1_devdata *dd, int sw_index)
+{
+	struct send_context_info *sci;
+	struct send_context *sc;
+	int i;
+
+	sci = &dd->send_contexts[sw_index];
+
+	/* there is no information for user (PSM) and ack contexts */
+	if (sci->type != SC_KERNEL)
+		return -1;
+
+	sc = sci->sc;
+	if (!sc)
+		return -1;
+	if (dd->vld[15].sc == sc)
+		return 15;
+	for (i = 0; i < num_vls; i++)
+		if (dd->vld[i].sc == sc)
+			return i;
+
+	return -1;
+}
+
 static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	u64 reg_copy = reg, handled = 0;
@@ -5575,27 +5663,27 @@ static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 
 	if (reg & ALL_TXE_EGRESS_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
-	if (is_ax(dd) && (reg &
-		    SEND_EGRESS_ERR_STATUS_TX_CREDIT_RETURN_VL_ERR_SMASK)
-		    && (dd->icode != ICODE_FUNCTIONAL_SIMULATOR))
+	else if (is_ax(dd) &&
+		 (reg & SEND_EGRESS_ERR_STATUS_TX_CREDIT_RETURN_VL_ERR_SMASK) &&
+		 (dd->icode != ICODE_FUNCTIONAL_SIMULATOR))
 		start_freeze_handling(dd->pport, 0);
 
 	while (reg_copy) {
 		int posn = fls64(reg_copy);
-		/*
-		 * fls64() returns a 1-based offset, but we generally
-		 * want 0-based offsets.
-		 */
+		/* fls64() returns a 1-based offset, we want it zero based */
 		int shift = posn - 1;
+		u64 mask = 1ULL << shift;
 
 		if (port_inactive_err(shift)) {
 			count_port_inactive(dd);
-			handled |= (1ULL << shift);
+			handled |= mask;
 		} else if (disallowed_pkt_err(shift)) {
-			handle_send_egress_err_info(dd);
-			handled |= (1ULL << shift);
+			int vl = engine_to_vl(dd, disallowed_pkt_engine(shift));
+
+			handle_send_egress_err_info(dd, vl);
+			handled |= mask;
 		}
-		clear_bit(shift, (unsigned long *)&reg_copy);
+		reg_copy &= ~mask;
 	}
 
 	reg &= ~handled;
@@ -5739,7 +5827,7 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 		send_context_err_status_string(flags, sizeof(flags), status));
 
 	if (status & SEND_CTXT_ERR_STATUS_PIO_DISALLOWED_PACKET_ERR_SMASK)
-		handle_send_egress_err_info(dd);
+		handle_send_egress_err_info(dd, sc_to_vl(dd, sw_index));
 
 	/*
 	 * Automatically restart halted kernel contexts out of interrupt
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 0fe630e..76c369a 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -709,8 +709,9 @@ struct hfi1_pportdata {
 	u64 *cntrs;
 	/* port relative synthetic counter buffer */
 	u64 *scntrs;
-	/* we synthesize port_xmit_discards from several egress errors */
+	/* port_xmit_discards are synthesized from different egress errors */
 	u64 port_xmit_discards;
+	u64 port_xmit_discards_vl[C_VL_COUNT];
 	u64 port_xmit_constraint_errors;
 	u64 port_rcv_constraint_errors;
 	/* count of 'link_err' interrupts from DC */
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index cb66bd0..52fb22d 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -890,6 +890,9 @@ int sdma_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_engines)
 	newmap->actual_vls = num_vls;
 	newmap->vls = roundup_pow_of_two(num_vls);
 	newmap->mask = (1 << ilog2(newmap->vls)) - 1;
+	/* initialize back-map */
+	for (i = 0; i < TXE_NUM_SDMA_ENGINES; i++)
+		newmap->engine_to_vl[i] = -1;
 	for (i = 0; i < newmap->vls; i++) {
 		/* save for wrap around */
 		int first_engine = engine;
@@ -913,6 +916,9 @@ int sdma_map_init(struct hfi1_devdata *dd, u8 port, u8 num_vls, u8 *vl_engines)
 					/* wrap back to first engine */
 					engine = first_engine;
 			}
+			/* assign back-map */
+			for (j = 0; j < vl_engines[i]; j++)
+				newmap->engine_to_vl[first_engine + j] = i;
 		} else {
 			/* just re-use entry without allocating */
 			newmap->map[i] = newmap->map[i % num_vls];
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 0f51c45..1d52d6e 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -1087,6 +1087,7 @@ struct sdma_map_elem {
 
 /**
  * struct sdma_map_el - mapping for a vl
+ * @engine_to_vl - map of an engine to a vl
  * @list - rcu head for free callback
  * @mask - vl mask to "mod" the vl to produce an index to map array
  * @actual_vls - number of vls
@@ -1098,6 +1099,7 @@ struct sdma_map_elem {
  * in turn point to an array of sde's for that vl.
  */
 struct sdma_vl_map {
+	s8 engine_to_vl[TXE_NUM_SDMA_ENGINES];
 	struct rcu_head list;
 	u32 mask;
 	u8 actual_vls;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
