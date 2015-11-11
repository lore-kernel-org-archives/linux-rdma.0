From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] staging/rdma/hfi1: Handle packets with invalid RHF on context 0
Date: Wed, 11 Nov 2015 00:35:19 -0500
Message-ID: <1447220119-8638-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Context 0 (which handles the error packets) can potentially receive an invalid
rhf. Hence, it can not depend on RHF sequence number and can only use DMA_RTAIL
mechanism. Detect such packets with invalid rhf using rhf sequence counting
mechanism and drop them.

As DMA_RTAIL mechanism has performance penalties, do not use context 0 for
performance critical verbs path. Use context 0 for VL15 (MAD), multicast and
error packets.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   |  74 ++++++++++++-------------
 drivers/staging/rdma/hfi1/driver.c | 108 ++++++++++++++++++++++++++++++++-----
 drivers/staging/rdma/hfi1/hfi.h    |   8 ++-
 drivers/staging/rdma/hfi1/init.c   |   9 +++-
 4 files changed, 146 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b7c7d1cac4e1..ca411386026b 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -121,8 +121,8 @@ struct flag_table {
 #define SEC_SC_HALTED		0x4	/* per-context only */
 #define SEC_SPC_FREEZE		0x8	/* per-HFI only */
 
-#define VL15CTXT                  1
 #define MIN_KERNEL_KCTXTS         2
+#define FIRST_KERNEL_KCTXT        1
 #define NUM_MAP_REGS             32
 
 /* Bit offset into the GUID which carries HFI id information */
@@ -7748,8 +7748,8 @@ void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
 					& RCV_TID_CTRL_TID_BASE_INDEX_MASK)
 				<< RCV_TID_CTRL_TID_BASE_INDEX_SHIFT);
 		write_kctxt_csr(dd, ctxt, RCV_TID_CTRL, reg);
-		if (ctxt == VL15CTXT)
-			write_csr(dd, RCV_VL15, VL15CTXT);
+		if (ctxt == HFI1_CTRL_CTXT)
+			write_csr(dd, RCV_VL15, HFI1_CTRL_CTXT);
 	}
 	if (op & HFI1_RCVCTRL_CTXT_DIS) {
 		write_csr(dd, RCV_VL15, 0);
@@ -8870,7 +8870,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 	int first_general, last_general;
 	int first_sdma, last_sdma;
 	int first_rx, last_rx;
-	int first_cpu, restart_cpu, curr_cpu;
+	int first_cpu, curr_cpu;
 	int rcv_cpu, sdma_cpu;
 	int i, ret = 0, possible;
 	int ht;
@@ -8909,22 +8909,19 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			topology_sibling_cpumask(cpumask_first(local_mask)));
 	for (i = possible/ht; i < possible; i++)
 		cpumask_clear_cpu(i, def);
-	/* reset possible */
-	possible = cpumask_weight(def);
 	/* def now has full cores on chosen node*/
 	first_cpu = cpumask_first(def);
 	if (nr_cpu_ids >= first_cpu)
 		first_cpu++;
-	restart_cpu = first_cpu;
-	curr_cpu = restart_cpu;
+	curr_cpu = first_cpu;
 
-	for (i = first_cpu; i < dd->n_krcv_queues + first_cpu; i++) {
+	/*  One context is reserved as control context */
+	for (i = first_cpu; i < dd->n_krcv_queues + first_cpu - 1; i++) {
 		cpumask_clear_cpu(curr_cpu, def);
 		cpumask_set_cpu(curr_cpu, rcv);
-		if (curr_cpu >= possible)
-			curr_cpu = restart_cpu;
-		else
-			curr_cpu++;
+		curr_cpu = cpumask_next(curr_cpu, def);
+		if (curr_cpu >= nr_cpu_ids)
+			break;
 	}
 	/* def mask has non-rcv, rcv has recv mask */
 	rcv_cpu = cpumask_first(rcv);
@@ -9024,12 +9021,20 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			if (sdma_cpu >= nr_cpu_ids)
 				sdma_cpu = cpumask_first(def);
 		} else if (handler == receive_context_interrupt) {
-			dd_dev_info(dd, "rcv ctxt %d cpu %d\n",
-				rcd->ctxt, rcv_cpu);
-			cpumask_set_cpu(rcv_cpu, dd->msix_entries[i].mask);
-			rcv_cpu = cpumask_next(rcv_cpu, rcv);
-			if (rcv_cpu >= nr_cpu_ids)
-				rcv_cpu = cpumask_first(rcv);
+			dd_dev_info(dd, "rcv ctxt %d cpu %d\n", rcd->ctxt,
+				    (rcd->ctxt == HFI1_CTRL_CTXT) ?
+					    cpumask_first(def) : rcv_cpu);
+			if (rcd->ctxt == HFI1_CTRL_CTXT) {
+				/* map to first default */
+				cpumask_set_cpu(cpumask_first(def),
+						dd->msix_entries[i].mask);
+			} else {
+				cpumask_set_cpu(rcv_cpu,
+						dd->msix_entries[i].mask);
+				rcv_cpu = cpumask_next(rcv_cpu, rcv);
+				if (rcv_cpu >= nr_cpu_ids)
+					rcv_cpu = cpumask_first(rcv);
+			}
 		} else {
 			/* otherwise first def */
 			dd_dev_info(dd, "%s cpu %d\n",
@@ -9162,11 +9167,18 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	/*
 	 * Kernel contexts: (to be fixed later):
 	 * - min or 2 or 1 context/numa
-	 * - Context 0 - default/errors
-	 * - Context 1 - VL15
+	 * - Context 0 - control context (VL15/multicast/error)
+	 * - Context 1 - default context
 	 */
 	if (n_krcvqs)
-		num_kernel_contexts = n_krcvqs + MIN_KERNEL_KCTXTS;
+		/*
+		 * Don't count context 0 in n_krcvqs since
+		 * is isn't used for normal verbs traffic.
+		 *
+		 * krcvqs will reflect number of kernel
+		 * receive contexts above 0.
+		 */
+		num_kernel_contexts = n_krcvqs + MIN_KERNEL_KCTXTS - 1;
 	else
 		num_kernel_contexts = num_online_nodes();
 	num_kernel_contexts =
@@ -10018,12 +10030,6 @@ static void init_qpmap_table(struct hfi1_devdata *dd,
 	u64 ctxt = first_ctxt;
 
 	for (i = 0; i < 256;) {
-		if (ctxt == VL15CTXT) {
-			ctxt++;
-			if (ctxt > last_ctxt)
-				ctxt = first_ctxt;
-			continue;
-		}
 		reg |= ctxt << (8 * (i % 8));
 		i++;
 		ctxt++;
@@ -10136,19 +10142,13 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	/* Enable RSM */
 	add_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
 	kfree(rsmmap);
-	/* map everything else (non-VL15) to context 0 */
-	init_qpmap_table(
-		dd,
-		0,
-		0);
+	/* map everything else to first context */
+	init_qpmap_table(dd, FIRST_KERNEL_KCTXT, MIN_KERNEL_KCTXTS - 1);
 	dd->qos_shift = n + 1;
 	return;
 bail:
 	dd->qos_shift = 1;
-	init_qpmap_table(
-		dd,
-		dd->n_krcv_queues > MIN_KERNEL_KCTXTS ? MIN_KERNEL_KCTXTS : 0,
-		dd->n_krcv_queues - 1);
+	init_qpmap_table(dd, FIRST_KERNEL_KCTXT, dd->n_krcv_queues - 1);
 }
 
 static void init_rxe(struct hfi1_devdata *dd)
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 145ac3061f5d..ecb81da95c6f 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -510,28 +510,49 @@ static inline void init_ps_mdata(struct ps_mdata *mdata,
 	mdata->maxcnt = packet->maxcnt;
 	mdata->ps_head = packet->rhqoff;
 
-	if (HFI1_CAP_IS_KSET(DMA_RTAIL)) {
+	if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL)) {
 		mdata->ps_tail = get_rcvhdrtail(rcd);
-		mdata->ps_seq = 0; /* not used with DMA_RTAIL */
+		if (rcd->ctxt == HFI1_CTRL_CTXT)
+			mdata->ps_seq = rcd->seq_cnt;
+		else
+			mdata->ps_seq = 0; /* not used with DMA_RTAIL */
 	} else {
 		mdata->ps_tail = 0; /* used only with DMA_RTAIL*/
 		mdata->ps_seq = rcd->seq_cnt;
 	}
 }
 
-static inline int ps_done(struct ps_mdata *mdata, u64 rhf)
+static inline int ps_done(struct ps_mdata *mdata, u64 rhf,
+			  struct hfi1_ctxtdata *rcd)
 {
-	if (HFI1_CAP_IS_KSET(DMA_RTAIL))
+	if (HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL))
 		return mdata->ps_head == mdata->ps_tail;
 	return mdata->ps_seq != rhf_rcv_seq(rhf);
 }
 
-static inline void update_ps_mdata(struct ps_mdata *mdata)
+static inline int ps_skip(struct ps_mdata *mdata, u64 rhf,
+			  struct hfi1_ctxtdata *rcd)
+{
+	/*
+	 * Control context can potentially receive an invalid rhf.
+	 * Drop such packets.
+	 */
+	if ((rcd->ctxt == HFI1_CTRL_CTXT) && (mdata->ps_head != mdata->ps_tail))
+		return mdata->ps_seq != rhf_rcv_seq(rhf);
+
+	return 0;
+}
+
+static inline void update_ps_mdata(struct ps_mdata *mdata,
+				   struct hfi1_ctxtdata *rcd)
 {
 	mdata->ps_head += mdata->rsize;
 	if (mdata->ps_head >= mdata->maxcnt)
 		mdata->ps_head = 0;
-	if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
+
+	/* Control context must do seq counting */
+	if (!HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL) ||
+	    (rcd->ctxt == HFI1_CTRL_CTXT)) {
 		if (++mdata->ps_seq > 13)
 			mdata->ps_seq = 1;
 	}
@@ -571,9 +592,12 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		int is_ecn = 0;
 		u8 lnh;
 
-		if (ps_done(&mdata, rhf))
+		if (ps_done(&mdata, rhf, rcd))
 			break;
 
+		if (ps_skip(&mdata, rhf, rcd))
+			goto next;
+
 		if (etype != RHF_RCV_TYPE_IB)
 			goto next;
 
@@ -611,8 +635,34 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		bth1 &= ~(HFI1_FECN_SMASK | HFI1_BECN_SMASK);
 		ohdr->bth[1] = cpu_to_be32(bth1);
 next:
-		update_ps_mdata(&mdata);
+		update_ps_mdata(&mdata, rcd);
+	}
+}
+
+static inline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
+{
+	int ret = RCV_PKT_OK;
+
+	/* Set up for the next packet */
+	packet->rhqoff += packet->rsize;
+	if (packet->rhqoff >= packet->maxcnt)
+		packet->rhqoff = 0;
+
+	packet->numpkt++;
+	if (unlikely((packet->numpkt & (MAX_PKT_RECV - 1)) == 0)) {
+		if (thread) {
+			cond_resched();
+		} else {
+			ret = RCV_PKT_LIMIT;
+			this_cpu_inc(*packet->rcd->dd->rcv_limit);
+		}
 	}
+
+	packet->rhf_addr = (__le32 *)packet->rcd->rcvhdrq + packet->rhqoff +
+				     packet->rcd->dd->rhf_offset;
+	packet->rhf = rhf_to_cpu(packet->rhf_addr);
+
+	return ret;
 }
 
 static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
@@ -788,7 +838,6 @@ int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 
 	while (last == RCV_PKT_OK) {
 		last = process_rcv_packet(&packet, thread);
-		hdrqtail = get_rcvhdrtail(rcd);
 		if (packet.rhqoff == hdrqtail)
 			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
@@ -803,7 +852,7 @@ static inline void set_all_nodma_rtail(struct hfi1_devdata *dd)
 {
 	int i;
 
-	for (i = 0; i < dd->first_user_ctxt; i++)
+	for (i = HFI1_CTRL_CTXT + 1; i < dd->first_user_ctxt; i++)
 		dd->rcd[i]->do_interrupt =
 			&handle_receive_interrupt_nodma_rtail;
 }
@@ -812,7 +861,7 @@ static inline void set_all_dma_rtail(struct hfi1_devdata *dd)
 {
 	int i;
 
-	for (i = 0; i < dd->first_user_ctxt; i++)
+	for (i = HFI1_CTRL_CTXT + 1; i < dd->first_user_ctxt; i++)
 		dd->rcd[i]->do_interrupt =
 			&handle_receive_interrupt_dma_rtail;
 }
@@ -828,12 +877,16 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 {
 	struct hfi1_devdata *dd = rcd->dd;
 	u32 hdrqtail;
-	int last = RCV_PKT_OK, needset = 1;
+	int needset, last = RCV_PKT_OK;
 	struct hfi1_packet packet;
+	int skip_pkt = 0;
+
+	/* Control context will always use the slow path interrupt handler */
+	needset = (rcd->ctxt == HFI1_CTRL_CTXT) ? 0 : 1;
 
 	init_packet(rcd, &packet);
 
-	if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
+	if (!HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL)) {
 		u32 seq = rhf_rcv_seq(packet.rhf);
 
 		if (seq != rcd->seq_cnt) {
@@ -848,6 +901,17 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 			goto bail;
 		}
 		smp_rmb();  /* prevent speculative reads of dma'ed hdrq */
+
+		/*
+		 * Control context can potentially receive an invalid
+		 * rhf. Drop such packets.
+		 */
+		if (rcd->ctxt == HFI1_CTRL_CTXT) {
+			u32 seq = rhf_rcv_seq(packet.rhf);
+
+			if (seq != rcd->seq_cnt)
+				skip_pkt = 1;
+		}
 	}
 
 	prescan_rxq(&packet);
@@ -865,11 +929,14 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 					  dd->rhf_offset;
 			packet.rhf = rhf_to_cpu(packet.rhf_addr);
 
+		} else if (skip_pkt) {
+			last = skip_rcv_packet(&packet, thread);
+			skip_pkt = 0;
 		} else {
 			last = process_rcv_packet(&packet, thread);
 		}
 
-		if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
+		if (!HFI1_CAP_KGET_MASK(rcd->flags, DMA_RTAIL)) {
 			u32 seq = rhf_rcv_seq(packet.rhf);
 
 			if (++rcd->seq_cnt > 13)
@@ -885,6 +952,19 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 		} else {
 			if (packet.rhqoff == hdrqtail)
 				last = RCV_PKT_DONE;
+			/*
+			 * Control context can potentially receive an invalid
+			 * rhf. Drop such packets.
+			 */
+			if (rcd->ctxt == HFI1_CTRL_CTXT) {
+				u32 seq = rhf_rcv_seq(packet.rhf);
+
+				if (++rcd->seq_cnt > 13)
+					rcd->seq_cnt = 1;
+				if (!last && (seq != rcd->seq_cnt))
+					skip_pkt = 1;
+			}
+
 			if (needset) {
 				dd_dev_info(dd,
 					    "Switching to DMA_RTAIL\n");
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index f633ca2a6ee4..97ce4082bdfd 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -100,6 +100,12 @@ extern unsigned long hfi1_cap_mask;
 			HFI1_CAP_MISC_MASK)
 
 /*
+ * Control context is always 0 and handles the error packets.
+ * It also handles the VL15 and multicast packets.
+ */
+#define HFI1_CTRL_CTXT    0
+
+/*
  * per driver stats, either not device nor port-specific, or
  * summed over all of the devices and ports.
  * They are described by name via ipathfs filesystem, so layout
@@ -234,7 +240,7 @@ struct hfi1_ctxtdata {
 	/* chip offset of PIO buffers for this ctxt */
 	u32 piobufs;
 	/* per-context configuration flags */
-	u16 flags;
+	u32 flags;
 	/* per-context event flags for fileops/intr communication */
 	unsigned long event_flags;
 	/* WAIT_RCV that timed out, no interrupt */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 69dfa3a65fc6..5c46c204ee56 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -89,7 +89,7 @@ MODULE_PARM_DESC(
 u8 krcvqs[RXE_NUM_DATA_VL];
 int krcvqsset;
 module_param_array(krcvqs, byte, &krcvqsset, S_IRUGO);
-MODULE_PARM_DESC(krcvqs, "Array of the number of kernel receive queues by VL");
+MODULE_PARM_DESC(krcvqs, "Array of the number of non-control kernel receive queues by VL");
 
 /* computed based on above array */
 unsigned n_krcvqs;
@@ -129,6 +129,9 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 	int ret;
 	int local_node_id = pcibus_to_node(dd->pcidev->bus);
 
+	/* Control context has to be always 0 */
+	BUILD_BUG_ON(HFI1_CTRL_CTXT != 0);
+
 	if (local_node_id < 0)
 		local_node_id = numa_node_id();
 	dd->assigned_node_id = local_node_id;
@@ -158,6 +161,10 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 			HFI1_CAP_KGET(NODROP_RHQ_FULL) |
 			HFI1_CAP_KGET(NODROP_EGR_FULL) |
 			HFI1_CAP_KGET(DMA_RTAIL);
+
+		/* Control context must use DMA_RTAIL */
+		if (rcd->ctxt == HFI1_CTRL_CTXT)
+			rcd->flags |= HFI1_CAP_DMA_RTAIL;
 		rcd->seq_cnt = 1;
 
 		rcd->sc = sc_alloc(dd, SC_ACK, rcd->rcvhdrqentsize, dd->node);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
