From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/qib: Log all SDMA errors unconditionally.
Date: Fri, 12 Jul 2013 09:03:34 -0400
Message-ID: <20130712130334.16637.10968.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds code to log SDMA errors for
supportability purposes.

Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h         |    2 -
 drivers/infiniband/hw/qib/qib_iba7322.c |  116 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_sdma.c    |   56 +++++++++++++++
 3 files changed, 173 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 5453e2b..4a9af79 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1348,7 +1348,7 @@ static inline int __qib_sdma_running(struct qib_pportdata *ppd)
 	return ppd->sdma_state.current_state == qib_sdma_state_s99_running;
 }
 int qib_sdma_running(struct qib_pportdata *);
-
+void dump_sdma_state(struct qib_pportdata *ppd);
 void __qib_sdma_process_event(struct qib_pportdata *, enum qib_sdma_events);
 void qib_sdma_process_event(struct qib_pportdata *, enum qib_sdma_events);
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index f7c4b44..b3b33f3 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -83,6 +83,7 @@ static void ibsd_wr_allchans(struct qib_pportdata *, int, unsigned, unsigned);
 static void serdes_7322_los_enable(struct qib_pportdata *, int);
 static int serdes_7322_init_old(struct qib_pportdata *);
 static int serdes_7322_init_new(struct qib_pportdata *);
+static void dump_sdma_7322_state(struct qib_pportdata *);
 
 #define BMASK(msb, lsb) (((1 << ((msb) + 1 - (lsb))) - 1) << (lsb))
 
@@ -652,6 +653,7 @@ struct qib_chippport_specific {
 	u8 ibmalfusesnap;
 	struct qib_qsfp_data qsfp_data;
 	char epmsgbuf[192]; /* for port error interrupt msg buffer */
+	char sdmamsgbuf[192]; /* for per-port sdma error messages */
 };
 
 static struct {
@@ -1594,6 +1596,8 @@ static void sdma_7322_p_errors(struct qib_pportdata *ppd, u64 errs)
 	struct qib_devdata *dd = ppd->dd;
 
 	errs &= QIB_E_P_SDMAERRS;
+	err_decode(ppd->cpspec->sdmamsgbuf, sizeof ppd->cpspec->sdmamsgbuf,
+		   errs, qib_7322p_error_msgs);
 
 	if (errs & QIB_E_P_SDMAUNEXPDATA)
 		qib_dev_err(dd, "IB%u:%u SDmaUnexpData\n", dd->unit,
@@ -1601,6 +1605,15 @@ static void sdma_7322_p_errors(struct qib_pportdata *ppd, u64 errs)
 
 	spin_lock_irqsave(&ppd->sdma_lock, flags);
 
+	if (errs != QIB_E_P_SDMAHALT) {
+		/* SDMA errors have QIB_E_P_SDMAHALT and another bit set */
+		qib_dev_porterr(dd, ppd->port,
+			"SDMA %s 0x%016llx %s\n",
+			qib_sdma_state_names[ppd->sdma_state.current_state],
+			errs, ppd->cpspec->sdmamsgbuf);
+		dump_sdma_7322_state(ppd);
+	}
+
 	switch (ppd->sdma_state.current_state) {
 	case qib_sdma_state_s00_hw_down:
 		break;
@@ -2156,6 +2169,29 @@ static void qib_7322_handle_hwerrors(struct qib_devdata *dd, char *msg,
 
 	qib_dev_err(dd, "%s hardware error\n", msg);
 
+	if (hwerrs &
+		   (SYM_MASK(HwErrMask, SDmaMemReadErrMask_0) |
+		    SYM_MASK(HwErrMask, SDmaMemReadErrMask_1))) {
+		int pidx = 0;
+		int err;
+		unsigned long flags;
+		struct qib_pportdata *ppd = dd->pport;
+		for (; pidx < dd->num_pports; ++pidx, ppd++) {
+			err = 0;
+			if (pidx == 0 && (hwerrs &
+				SYM_MASK(HwErrMask, SDmaMemReadErrMask_0)))
+				err++;
+			if (pidx == 1 && (hwerrs &
+				SYM_MASK(HwErrMask, SDmaMemReadErrMask_1)))
+				err++;
+			if (err) {
+				spin_lock_irqsave(&ppd->sdma_lock, flags);
+				dump_sdma_7322_state(ppd);
+				spin_unlock_irqrestore(&ppd->sdma_lock, flags);
+			}
+		}
+	}
+
 	if (isfatal && !dd->diag_client) {
 		qib_dev_err(dd,
 			"Fatal Hardware Error, no longer usable, SN %.16s\n",
@@ -6753,6 +6789,86 @@ static void qib_sdma_set_7322_desc_cnt(struct qib_pportdata *ppd, unsigned cnt)
 	qib_write_kreg_port(ppd, krp_senddmadesccnt, cnt);
 }
 
+/*
+ * sdma_lock should be acquired before calling this routine
+ */
+static void dump_sdma_7322_state(struct qib_pportdata *ppd)
+{
+	u64 reg, reg1, reg2;
+
+	reg = qib_read_kreg_port(ppd, krp_senddmastatus);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmastatus: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_sendctrl);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA sendctrl: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmabase);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmabase: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmabufmask0);
+	reg1 = qib_read_kreg_port(ppd, krp_senddmabufmask1);
+	reg2 = qib_read_kreg_port(ppd, krp_senddmabufmask2);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmabufmask 0:%llx  1:%llx  2:%llx\n",
+		 reg, reg1, reg2);
+
+	/* get bufuse bits, clear them, and print them again if non-zero */
+	reg = qib_read_kreg_port(ppd, krp_senddmabuf_use0);
+	qib_write_kreg_port(ppd, krp_senddmabuf_use0, reg);
+	reg1 = qib_read_kreg_port(ppd, krp_senddmabuf_use1);
+	qib_write_kreg_port(ppd, krp_senddmabuf_use0, reg1);
+	reg2 = qib_read_kreg_port(ppd, krp_senddmabuf_use2);
+	qib_write_kreg_port(ppd, krp_senddmabuf_use0, reg2);
+	/* 0 and 1 should always be zero, so print as short form */
+	qib_dev_porterr(ppd->dd, ppd->port,
+		 "SDMA current senddmabuf_use 0:%llx  1:%llx  2:%llx\n",
+		 reg, reg1, reg2);
+	reg = qib_read_kreg_port(ppd, krp_senddmabuf_use0);
+	reg1 = qib_read_kreg_port(ppd, krp_senddmabuf_use1);
+	reg2 = qib_read_kreg_port(ppd, krp_senddmabuf_use2);
+	/* 0 and 1 should always be zero, so print as short form */
+	qib_dev_porterr(ppd->dd, ppd->port,
+		 "SDMA cleared senddmabuf_use 0:%llx  1:%llx  2:%llx\n",
+		 reg, reg1, reg2);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmatail);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmatail: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmahead);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmahead: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmaheadaddr);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmaheadaddr: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmalengen);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmalengen: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmadesccnt);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmadesccnt: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmaidlecnt);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmaidlecnt: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmaprioritythld);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmapriorityhld: 0x%016llx\n", reg);
+
+	reg = qib_read_kreg_port(ppd, krp_senddmareloadcnt);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA senddmareloadcnt: 0x%016llx\n", reg);
+
+	dump_sdma_state(ppd);
+}
+
 static struct sdma_set_state_action sdma_7322_action_table[] = {
 	[qib_sdma_state_s00_hw_down] = {
 		.go_s99_running_tofalse = 1,
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index 3fc5144..32162d3 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -708,6 +708,62 @@ unlock:
 	return ret;
 }
 
+/*
+ * sdma_lock should be acquired before calling this routine
+ */
+void dump_sdma_state(struct qib_pportdata *ppd)
+{
+	struct qib_sdma_desc *descq;
+	struct qib_sdma_txreq *txp, *txpnext;
+	__le64 *descqp;
+	u64 desc[2];
+	dma_addr_t addr;
+	u16 gen, dwlen, dwoffset;
+	u16 head, tail, cnt;
+
+	head = ppd->sdma_descq_head;
+	tail = ppd->sdma_descq_tail;
+	cnt = qib_sdma_descq_freecnt(ppd);
+	descq = ppd->sdma_descq;
+
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA ppd->sdma_descq_head: %u\n", head);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA ppd->sdma_descq_tail: %u\n", tail);
+	qib_dev_porterr(ppd->dd, ppd->port,
+		"SDMA sdma_descq_freecnt: %u\n", cnt);
+
+	/* print info for each entry in the descriptor queue */
+	while (head != tail) {
+		char flags[6] = { 'x', 'x', 'x', 'x', 'x', 0 };
+
+		descqp = &descq[head].qw[0];
+		desc[0] = le64_to_cpu(descqp[0]);
+		desc[1] = le64_to_cpu(descqp[1]);
+		flags[0] = (desc[0] & 1<<15) ? 'I' : '-';
+		flags[1] = (desc[0] & 1<<14) ? 'L' : 'S';
+		flags[2] = (desc[0] & 1<<13) ? 'H' : '-';
+		flags[3] = (desc[0] & 1<<12) ? 'F' : '-';
+		flags[4] = (desc[0] & 1<<11) ? 'L' : '-';
+		addr = (desc[1] << 32) | ((desc[0] >> 32) & 0xfffffffcULL);
+		gen = (desc[0] >> 30) & 3ULL;
+		dwlen = (desc[0] >> 14) & (0x7ffULL << 2);
+		dwoffset = (desc[0] & 0x7ffULL) << 2;
+		qib_dev_porterr(ppd->dd, ppd->port,
+			"SDMA sdmadesc[%u]: flags:%s addr:0x%016llx gen:%u len:%u bytes offset:%u bytes\n",
+			 head, flags, addr, gen, dwlen, dwoffset);
+		if (++head == ppd->sdma_descq_cnt)
+			head = 0;
+	}
+
+	/* print dma descriptor indices from the TX requests */
+	list_for_each_entry_safe(txp, txpnext, &ppd->sdma_activelist,
+				 list)
+		qib_dev_porterr(ppd->dd, ppd->port,
+			"SDMA txp->start_idx: %u txp->next_descq_idx: %u\n",
+			txp->start_idx, txp->next_descq_idx);
+}
+
 void qib_sdma_process_event(struct qib_pportdata *ppd,
 	enum qib_sdma_events event)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
