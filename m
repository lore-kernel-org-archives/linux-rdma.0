From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 17/22] staging/rdma/hfi1: Thread the receive interrupt.
Date: Mon, 19 Oct 2015 22:11:32 -0400
Message-ID: <1445307097-8244-18-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When under heavy load, the receive interrupt handler can run too long with IRQs
disabled.  Add a mixed-mode threading scheme.  Initially process packets in the
handler for quick responses (latency).  If there are too many packets to
process move to a thread to continue (bandwidth).

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   | 104 +++++++++++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/driver.c |  72 ++++++++++++++-----------
 drivers/staging/rdma/hfi1/hfi.h    |  20 +++++--
 drivers/staging/rdma/hfi1/sdma.c   |   4 +-
 4 files changed, 154 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 0be37e9430af..352b0d089ae1 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -4426,7 +4426,7 @@ static void is_rcv_avail_int(struct hfi1_devdata *dd, unsigned int source)
 		rcd = dd->rcd[source];
 		if (rcd) {
 			if (source < dd->first_user_ctxt)
-				rcd->do_interrupt(rcd);
+				rcd->do_interrupt(rcd, 0);
 			else
 				handle_user_interrupt(rcd);
 			return;	/* OK */
@@ -4592,23 +4592,106 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
 }
 
 /*
- * NOTE: this routine expects to be on its own MSI-X interrupt.  If
- * multiple receive contexts share the same MSI-X interrupt, then this
- * routine must check for who received it.
+ * Clear the receive interrupt, forcing the write and making sure
+ * we have data from the chip, pushing everything in front of it
+ * back to the host.
+ */
+static inline void clear_recv_intr(struct hfi1_ctxtdata *rcd)
+{
+	struct hfi1_devdata *dd = rcd->dd;
+	u32 addr = CCE_INT_CLEAR + (8 * rcd->ireg);
+
+	mmiowb();	/* make sure everything before is written */
+	write_csr(dd, addr, rcd->imask);
+	/* force the above write on the chip and get a value back */
+	(void)read_csr(dd, addr);
+}
+
+/* force the receive interrupt */
+static inline void force_recv_intr(struct hfi1_ctxtdata *rcd)
+{
+	write_csr(rcd->dd, CCE_INT_FORCE + (8 * rcd->ireg), rcd->imask);
+}
+
+/* return non-zero if a packet is present */
+static inline int check_packet_present(struct hfi1_ctxtdata *rcd)
+{
+	if (!HFI1_CAP_IS_KSET(DMA_RTAIL))
+		return (rcd->seq_cnt ==
+				rhf_rcv_seq(rhf_to_cpu(get_rhf_addr(rcd))));
+
+	/* else is RDMA rtail */
+	return (rcd->head != get_rcvhdrtail(rcd));
+}
+
+/*
+ * Receive packet IRQ handler.  This routine expects to be on its own IRQ.
+ * This routine will try to handle packets immediately (latency), but if
+ * it finds too many, it will invoke the thread handler (bandwitdh).  The
+ * chip receive interupt is *not* cleared down until this or the thread (if
+ * invoked) is finished.  The intent is to avoid extra interrupts while we
+ * are processing packets anyway.
  */
 static irqreturn_t receive_context_interrupt(int irq, void *data)
 {
 	struct hfi1_ctxtdata *rcd = data;
 	struct hfi1_devdata *dd = rcd->dd;
+	int disposition;
+	int present;
 
 	trace_hfi1_receive_interrupt(dd, rcd->ctxt);
 	this_cpu_inc(*dd->int_counter);
 
-	/* clear the interrupt */
-	write_csr(rcd->dd, CCE_INT_CLEAR + (8*rcd->ireg), rcd->imask);
+	/* receive interrupt remains blocked while processing packets */
+	disposition = rcd->do_interrupt(rcd, 0);
 
-	/* handle the interrupt */
-	rcd->do_interrupt(rcd);
+	/*
+	 * Too many packets were seen while processing packets in this
+	 * IRQ handler.  Invoke the handler thread.  The receive interrupt
+	 * remains blocked.
+	 */
+	if (disposition == RCV_PKT_LIMIT)
+		return IRQ_WAKE_THREAD;
+
+	/*
+	 * The packet processor detected no more packets.  Clear the receive
+	 * interrupt and recheck for a packet packet that may have arrived
+	 * after the previous check and interrupt clear.  If a packet arrived,
+	 * force another interrupt.
+	 */
+	clear_recv_intr(rcd);
+	present = check_packet_present(rcd);
+	if (present)
+		force_recv_intr(rcd);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Receive packet thread handler.  This expects to be invoked with the
+ * receive interrupt still blocked.
+ */
+static irqreturn_t receive_context_thread(int irq, void *data)
+{
+	struct hfi1_ctxtdata *rcd = data;
+	int present;
+
+	/* receive interrupt is still blocked from the IRQ handler */
+	(void)rcd->do_interrupt(rcd, 1);
+
+	/*
+	 * The packet processor will only return if it detected no more
+	 * packets.  Hold IRQs here so we can safely clear the interrupt and
+	 * recheck for a packet that may have arrived after the previous
+	 * check and the interrupt clear.  If a packet arrived, force another
+	 * interrupt.
+	 */
+	local_irq_disable();
+	clear_recv_intr(rcd);
+	present = check_packet_present(rcd);
+	if (present)
+		force_recv_intr(rcd);
+	local_irq_enable();
 
 	return IRQ_HANDLED;
 }
@@ -8861,6 +8944,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		struct hfi1_msix_entry *me = &dd->msix_entries[i];
 		const char *err_info;
 		irq_handler_t handler;
+		irq_handler_t thread = NULL;
 		void *arg;
 		int idx;
 		struct hfi1_ctxtdata *rcd = NULL;
@@ -8897,6 +8981,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			rcd->imask = ((u64)1) <<
 					((IS_RCVAVAIL_START+idx) % 64);
 			handler = receive_context_interrupt;
+			thread = receive_context_thread;
 			arg = rcd;
 			snprintf(me->name, sizeof(me->name),
 				DRIVER_NAME"_%d kctxt%d", dd->unit, idx);
@@ -8915,7 +9000,8 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		/* make sure the name is terminated */
 		me->name[sizeof(me->name)-1] = 0;
 
-		ret = request_irq(me->msix.vector, handler, 0, me->name, arg);
+		ret = request_threaded_irq(me->msix.vector, handler, thread, 0,
+						me->name, arg);
 		if (ret) {
 			dd_dev_err(dd,
 				"unable to allocate %s interrupt, vector %d, index %d, err %d\n",
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ce1e4d102993..24af4aba0b7b 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -427,8 +427,7 @@ static inline void init_packet(struct hfi1_ctxtdata *rcd,
 	packet->rcd = rcd;
 	packet->updegr = 0;
 	packet->etail = -1;
-	packet->rhf_addr = (__le32 *) rcd->rcvhdrq + rcd->head +
-			   rcd->dd->rhf_offset;
+	packet->rhf_addr = get_rhf_addr(rcd);
 	packet->rhf = rhf_to_cpu(packet->rhf_addr);
 	packet->rhqoff = rcd->head;
 	packet->numpkt = 0;
@@ -619,10 +618,7 @@ next:
 }
 #endif /* CONFIG_PRESCAN_RXQ */
 
-#define RCV_PKT_OK 0x0
-#define RCV_PKT_MAX 0x1
-
-static inline int process_rcv_packet(struct hfi1_packet *packet)
+static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 {
 	int ret = RCV_PKT_OK;
 
@@ -664,9 +660,13 @@ static inline int process_rcv_packet(struct hfi1_packet *packet)
 	if (packet->rhqoff >= packet->maxcnt)
 		packet->rhqoff = 0;
 
-	if (packet->numpkt == MAX_PKT_RECV) {
-		ret = RCV_PKT_MAX;
-		this_cpu_inc(*packet->rcd->dd->rcv_limit);
+	if (unlikely((packet->numpkt & (MAX_PKT_RECV - 1)) == 0)) {
+		if (thread) {
+			cond_resched();
+		} else {
+			ret = RCV_PKT_LIMIT;
+			this_cpu_inc(*packet->rcd->dd->rcv_limit);
+		}
 	}
 
 	packet->rhf_addr = (__le32 *) packet->rcd->rcvhdrq + packet->rhqoff +
@@ -743,57 +743,63 @@ static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 /*
  * Handle receive interrupts when using the no dma rtail option.
  */
-void handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd)
+int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 {
 	u32 seq;
-	int last = 0;
+	int last = RCV_PKT_OK;
 	struct hfi1_packet packet;
 
 	init_packet(rcd, &packet);
 	seq = rhf_rcv_seq(packet.rhf);
-	if (seq != rcd->seq_cnt)
+	if (seq != rcd->seq_cnt) {
+		last = RCV_PKT_DONE;
 		goto bail;
+	}
 
 	prescan_rxq(&packet);
 
-	while (!last) {
-		last = process_rcv_packet(&packet);
+	while (last == RCV_PKT_OK) {
+		last = process_rcv_packet(&packet, thread);
 		seq = rhf_rcv_seq(packet.rhf);
 		if (++rcd->seq_cnt > 13)
 			rcd->seq_cnt = 1;
 		if (seq != rcd->seq_cnt)
-			last = 1;
+			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
 	}
 	process_rcv_qp_work(&packet);
 bail:
 	finish_packet(&packet);
+	return last;
 }
 
-void handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd)
+int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 {
 	u32 hdrqtail;
-	int last = 0;
+	int last = RCV_PKT_OK;
 	struct hfi1_packet packet;
 
 	init_packet(rcd, &packet);
 	hdrqtail = get_rcvhdrtail(rcd);
-	if (packet.rhqoff == hdrqtail)
+	if (packet.rhqoff == hdrqtail) {
+		last = RCV_PKT_DONE;
 		goto bail;
+	}
 	smp_rmb();  /* prevent speculative reads of dma'ed hdrq */
 
 	prescan_rxq(&packet);
 
-	while (!last) {
-		last = process_rcv_packet(&packet);
+	while (last == RCV_PKT_OK) {
+		last = process_rcv_packet(&packet, thread);
+		hdrqtail = get_rcvhdrtail(rcd);
 		if (packet.rhqoff == hdrqtail)
-			last = 1;
+			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
 	}
 	process_rcv_qp_work(&packet);
 bail:
 	finish_packet(&packet);
-
+	return last;
 }
 
 static inline void set_all_nodma_rtail(struct hfi1_devdata *dd)
@@ -821,12 +827,11 @@ static inline void set_all_dma_rtail(struct hfi1_devdata *dd)
  * Called from interrupt handler for errors or receive interrupt.
  * This is the slow path interrupt handler.
  */
-void handle_receive_interrupt(struct hfi1_ctxtdata *rcd)
+int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 {
-
 	struct hfi1_devdata *dd = rcd->dd;
 	u32 hdrqtail;
-	int last = 0, needset = 1;
+	int last = RCV_PKT_OK, needset = 1;
 	struct hfi1_packet packet;
 
 	init_packet(rcd, &packet);
@@ -834,19 +839,23 @@ void handle_receive_interrupt(struct hfi1_ctxtdata *rcd)
 	if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
 		u32 seq = rhf_rcv_seq(packet.rhf);
 
-		if (seq != rcd->seq_cnt)
+		if (seq != rcd->seq_cnt) {
+			last = RCV_PKT_DONE;
 			goto bail;
+		}
 		hdrqtail = 0;
 	} else {
 		hdrqtail = get_rcvhdrtail(rcd);
-		if (packet.rhqoff == hdrqtail)
+		if (packet.rhqoff == hdrqtail) {
+			last = RCV_PKT_DONE;
 			goto bail;
+		}
 		smp_rmb();  /* prevent speculative reads of dma'ed hdrq */
 	}
 
 	prescan_rxq(&packet);
 
-	while (!last) {
+	while (last == RCV_PKT_OK) {
 
 		if (unlikely(dd->do_drop && atomic_xchg(&dd->drop_packet,
 			DROP_PACKET_OFF) == DROP_PACKET_ON)) {
@@ -860,7 +869,7 @@ void handle_receive_interrupt(struct hfi1_ctxtdata *rcd)
 			packet.rhf = rhf_to_cpu(packet.rhf_addr);
 
 		} else {
-			last = process_rcv_packet(&packet);
+			last = process_rcv_packet(&packet, thread);
 		}
 
 		if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
@@ -869,7 +878,7 @@ void handle_receive_interrupt(struct hfi1_ctxtdata *rcd)
 			if (++rcd->seq_cnt > 13)
 				rcd->seq_cnt = 1;
 			if (seq != rcd->seq_cnt)
-				last = 1;
+				last = RCV_PKT_DONE;
 			if (needset) {
 				dd_dev_info(dd,
 					"Switching to NO_DMA_RTAIL\n");
@@ -878,7 +887,7 @@ void handle_receive_interrupt(struct hfi1_ctxtdata *rcd)
 			}
 		} else {
 			if (packet.rhqoff == hdrqtail)
-				last = 1;
+				last = RCV_PKT_DONE;
 			if (needset) {
 				dd_dev_info(dd,
 					    "Switching to DMA_RTAIL\n");
@@ -898,6 +907,7 @@ bail:
 	 * if no packets were processed.
 	 */
 	finish_packet(&packet);
+	return last;
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 550d72356fd9..578f13b8f4fb 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -313,7 +313,7 @@ struct hfi1_ctxtdata {
 	 * be valid. Worst case is we process an extra interrupt and up to 64
 	 * packets with the wrong interrupt handler.
 	 */
-	void (*do_interrupt)(struct hfi1_ctxtdata *rcd);
+	int (*do_interrupt)(struct hfi1_ctxtdata *rcd, int threaded);
 };
 
 /*
@@ -1151,9 +1151,21 @@ void hfi1_init_pportdata(struct pci_dev *, struct hfi1_pportdata *,
 			 struct hfi1_devdata *, u8, u8);
 void hfi1_free_ctxtdata(struct hfi1_devdata *, struct hfi1_ctxtdata *);
 
-void handle_receive_interrupt(struct hfi1_ctxtdata *);
-void handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd);
-void handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd);
+int handle_receive_interrupt(struct hfi1_ctxtdata *, int);
+int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *, int);
+int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *, int);
+
+/* receive packet handler dispositions */
+#define RCV_PKT_OK      0x0 /* keep going */
+#define RCV_PKT_LIMIT   0x1 /* stop, hit limit, start thread */
+#define RCV_PKT_DONE    0x2 /* stop, no more packets detected */
+
+/* calculate the current RHF address */
+static inline __le32 *get_rhf_addr(struct hfi1_ctxtdata *rcd)
+{
+	return (__le32 *)rcd->rcvhdrq + rcd->head + rcd->dd->rhf_offset;
+}
+
 int hfi1_reset_device(int);
 
 /* return the driver's idea of the logical OPA port state */
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 54c146afe52f..16b1edf2a5cc 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -2096,9 +2096,9 @@ unlock_noconn:
 	tx->sn = sde->tail_sn++;
 	trace_hfi1_sdma_in_sn(sde, tx->sn);
 #endif
-	spin_lock_irqsave(&sde->flushlist_lock, flags);
+	spin_lock(&sde->flushlist_lock);
 	list_add_tail(&tx->list, &sde->flushlist);
-	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
+	spin_unlock(&sde->flushlist_lock);
 	if (wait) {
 		wait->tx_count++;
 		wait->count += tx->num_desc;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
