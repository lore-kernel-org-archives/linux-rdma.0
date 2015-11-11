From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] staging/rdma/hfi1: Reduce number of parameters passed to send handlers
Date: Wed, 11 Nov 2015 00:34:37 -0500
Message-ID: <1447220077-8325-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current send function handlers are passed a bunch of parameters that are
already part of the data structure that is passed in first (qp). This patch
removes all of this and just passes the QP.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c  | 27 ++++++++++---------
 drivers/staging/rdma/hfi1/hfi.h   | 20 ++++++--------
 drivers/staging/rdma/hfi1/ruc.c   | 15 ++++++-----
 drivers/staging/rdma/hfi1/verbs.c | 55 ++++++++++++++++++---------------------
 drivers/staging/rdma/hfi1/verbs.h | 23 ++++++++++------
 5 files changed, 71 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 88414d720469..0aaad7412842 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1618,14 +1618,12 @@ int snoop_recv_handler(struct hfi1_packet *packet)
 /*
  * Handle snooping and capturing packets when sdma is being used.
  */
-int snoop_send_dma_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			   u32 plen, u32 dwords, u64 pbc)
+int snoop_send_dma_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			   u64 pbc)
 {
-	pr_alert("Snooping/Capture of  Send DMA Packets Is Not Supported!\n");
+	pr_alert("Snooping/Capture of Send DMA Packets Is Not Supported!\n");
 	snoop_dbg("Unsupported Operation");
-	return hfi1_verbs_send_dma(qp, ibhdr, hdrwords, ss, len, plen, dwords,
-				  0);
+	return hfi1_verbs_send_dma(qp, ps, 0);
 }
 
 /*
@@ -1633,12 +1631,16 @@ int snoop_send_dma_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
  * bypass packets. The only way to send a bypass packet currently is to use the
  * diagpkt interface. When that interface is enable snoop/capture is not.
  */
-int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			   u32 plen, u32 dwords, u64 pbc)
+int snoop_send_pio_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			   u64 pbc)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct ahg_ib_header *ahdr = qp->s_hdr;
+	u32 hdrwords = qp->s_hdrwords;
+	struct hfi1_sge_state *ss = qp->s_cur_sge;
+	u32 len = qp->s_cur_size;
+	u32 dwords = (len + 3) >> 2;
+	u32 plen = hdrwords + dwords + 2; /* includes pbc */
+	struct hfi1_pportdata *ppd = ps->ppd;
 	struct snoop_packet *s_packet = NULL;
 	u32 *hdr = (u32 *)&ahdr->ibh;
 	u32 length = 0;
@@ -1783,8 +1785,7 @@ int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 		break;
 	}
 out:
-	return hfi1_verbs_send_pio(qp, ahdr, hdrwords, ss, len, plen, dwords,
-				  md.u.pbc);
+	return hfi1_verbs_send_pio(qp, ps, md.u.pbc);
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index b1655be34851..f633ca2a6ee4 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1048,12 +1048,10 @@ struct hfi1_devdata {
 	 * Handlers for outgoing data so that snoop/capture does not
 	 * have to have its hooks in the send path
 	 */
-	int (*process_pio_send)(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-				u32 hdrwords, struct hfi1_sge_state *ss,
-				u32 len, u32 plen, u32 dwords, u64 pbc);
-	int (*process_dma_send)(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-				u32 hdrwords, struct hfi1_sge_state *ss,
-				u32 len, u32 plen, u32 dwords, u64 pbc);
+	int (*process_pio_send)(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+				u64 pbc);
+	int (*process_dma_send)(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+				u64 pbc);
 	void (*pio_inline_send)(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 				u64 pbc, const void *from, size_t count);
 
@@ -1401,12 +1399,10 @@ void reset_link_credits(struct hfi1_devdata *dd);
 void assign_remote_cm_au_table(struct hfi1_devdata *dd, u8 vcu);
 
 int snoop_recv_handler(struct hfi1_packet *packet);
-int snoop_send_dma_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			   u32 plen, u32 dwords, u64 pbc);
-int snoop_send_pio_handler(struct hfi1_qp *qp, struct ahg_ib_header *ibhdr,
-			   u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			   u32 plen, u32 dwords, u64 pbc);
+int snoop_send_dma_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			   u64 pbc);
+int snoop_send_pio_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			   u64 pbc);
 void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 			   u64 pbc, const void *from, size_t count);
 
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 7b11c61ac5d6..5751c551b5f4 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -809,16 +809,20 @@ void hfi1_do_send(struct work_struct *work)
 {
 	struct iowait *wait = container_of(work, struct iowait, iowork);
 	struct hfi1_qp *qp = container_of(wait, struct hfi1_qp, s_iowait);
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct hfi1_pkt_state ps;
 	int (*make_req)(struct hfi1_qp *qp);
 	unsigned long flags;
 	unsigned long timeout;
 
+	ps.dev = to_idev(qp->ibqp.device);
+	ps.ibp = to_iport(qp->ibqp.device, qp->port_num);
+	ps.ppd = ppd_from_ibp(ps.ibp);
+
 	if ((qp->ibqp.qp_type == IB_QPT_RC ||
 	     qp->ibqp.qp_type == IB_QPT_UC) &&
 	    !loopback &&
-	    (qp->remote_ah_attr.dlid & ~((1 << ppd->lmc) - 1)) == ppd->lid) {
+	    (qp->remote_ah_attr.dlid & ~((1 << ps.ppd->lmc) - 1)) ==
+	    ps.ppd->lid) {
 		ruc_loopback(qp);
 		return;
 	}
@@ -850,8 +854,7 @@ void hfi1_do_send(struct work_struct *work)
 			 * If the packet cannot be sent now, return and
 			 * the send tasklet will be woken up later.
 			 */
-			if (hfi1_verbs_send(qp, qp->s_hdr, qp->s_hdrwords,
-					    qp->s_cur_sge, qp->s_cur_size))
+			if (hfi1_verbs_send(qp, &ps))
 				break;
 			/* Record that s_hdr is empty. */
 			qp->s_hdrwords = 0;
@@ -860,7 +863,7 @@ void hfi1_do_send(struct work_struct *work)
 		/* allow other tasks to run */
 		if (unlikely(time_after(jiffies, timeout))) {
 			cond_resched();
-			ppd->dd->verbs_dev.n_send_schedule++;
+			ps.ppd->dd->verbs_dev.n_send_schedule++;
 			timeout = jiffies + SEND_RESCHED_TIMEOUT;
 		}
 	} while (make_req(qp));
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index e344ab997fff..67c96cad7dd5 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -989,13 +989,16 @@ bail_txadd:
 	return ret;
 }
 
-int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			u32 plen, u32 dwords, u64 pbc)
+int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			u64 pbc)
 {
-	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct ahg_ib_header *ahdr = qp->s_hdr;
+	u32 hdrwords = qp->s_hdrwords;
+	struct hfi1_sge_state *ss = qp->s_cur_sge;
+	u32 len = qp->s_cur_size;
+	u32 plen = hdrwords + ((len + 3) >> 2) + 2; /* includes pbc */
+	struct hfi1_ibdev *dev = ps->dev;
+	struct hfi1_pportdata *ppd = ps->ppd;
 	struct verbs_txreq *tx;
 	struct sdma_txreq *stx;
 	u64 pbc_flags = 0;
@@ -1108,12 +1111,16 @@ struct send_context *qp_to_send_context(struct hfi1_qp *qp, u8 sc5)
 	return dd->vld[vl].sc;
 }
 
-int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			u32 plen, u32 dwords, u64 pbc)
+int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			u64 pbc)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct ahg_ib_header *ahdr = qp->s_hdr;
+	u32 hdrwords = qp->s_hdrwords;
+	struct hfi1_sge_state *ss = qp->s_cur_sge;
+	u32 len = qp->s_cur_size;
+	u32 dwords = (len + 3) >> 2;
+	u32 plen = hdrwords + dwords + 2; /* includes pbc */
+	struct hfi1_pportdata *ppd = ps->ppd;
 	u32 *hdr = (u32 *)&ahdr->ibh;
 	u64 pbc_flags = 0;
 	u32 sc5;
@@ -1285,23 +1292,18 @@ bad:
 /**
  * hfi1_verbs_send - send a packet
  * @qp: the QP to send on
- * @ahdr: the packet header
- * @hdrwords: the number of 32-bit words in the header
- * @ss: the SGE to send
- * @len: the length of the packet in bytes
+ * @ps: the state of the packet to send
  *
  * Return zero if packet is sent or queued OK.
  * Return non-zero and clear qp->s_flags HFI1_S_BUSY otherwise.
  */
-int hfi1_verbs_send(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-		    u32 hdrwords, struct hfi1_sge_state *ss, u32 len)
+int hfi1_verbs_send(struct hfi1_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
-	u32 plen;
+	struct ahg_ib_header *ahdr = qp->s_hdr;
 	int ret;
 	int pio = 0;
 	unsigned long flags = 0;
-	u32 dwords = (len + 3) >> 2;
 
 	/*
 	 * VL15 packets (IB_QPT_SMI) will always use PIO, so we
@@ -1332,23 +1334,16 @@ int hfi1_verbs_send(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 		return -EINVAL;
 	}
 
-	/*
-	 * Calculate the send buffer trigger address.
-	 * The +2 counts for the pbc control qword
-	 */
-	plen = hdrwords + dwords + 2;
-
 	if (pio) {
-		ret = dd->process_pio_send(
-			qp, ahdr, hdrwords, ss, len, plen, dwords, 0);
+		ret = dd->process_pio_send(qp, ps, 0);
 	} else {
 #ifdef CONFIG_SDMA_VERBOSITY
 		dd_dev_err(dd, "CONFIG SDMA %s:%d %s()\n",
 			   slashstrip(__FILE__), __LINE__, __func__);
-		dd_dev_err(dd, "SDMA hdrwords = %u, len = %u\n", hdrwords, len);
+		dd_dev_err(dd, "SDMA hdrwords = %u, len = %u\n", qp->s_hdrwords,
+			   qp->s_cur_size);
 #endif
-		ret = dd->process_dma_send(
-			qp, ahdr, hdrwords, ss, len, plen, dwords, 0);
+		ret = dd->process_dma_send(qp, ps, 0);
 	}
 
 	return ret;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 62c6e38cca45..54c1da940f08 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -540,6 +540,16 @@ struct hfi1_qp {
 };
 
 /*
+ * This structure is used to hold commonly lookedup and computed values during
+ * the send engine progress.
+ */
+struct hfi1_pkt_state {
+	struct hfi1_ibdev *dev;
+	struct hfi1_ibport *ibp;
+	struct hfi1_pportdata *ppd;
+};
+
+/*
  * Atomic bit definitions for r_aflags.
  */
 #define HFI1_R_WRID_VALID        0
@@ -922,8 +932,7 @@ int hfi1_mcast_tree_empty(struct hfi1_ibport *ibp);
 struct verbs_txreq;
 void hfi1_put_txreq(struct verbs_txreq *tx);
 
-int hfi1_verbs_send(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
-		    u32 hdrwords, struct hfi1_sge_state *ss, u32 len);
+int hfi1_verbs_send(struct hfi1_qp *qp, struct hfi1_pkt_state *ps);
 
 void hfi1_copy_sge(struct hfi1_sge_state *ss, void *data, u32 length,
 		   int release);
@@ -1101,13 +1110,11 @@ void hfi1_ib_rcv(struct hfi1_packet *packet);
 
 unsigned hfi1_get_npkeys(struct hfi1_devdata *);
 
-int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *hdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			u32 plen, u32 dwords, u64 pbc);
+int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			u64 pbc);
 
-int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct ahg_ib_header *hdr,
-			u32 hdrwords, struct hfi1_sge_state *ss, u32 len,
-			u32 plen, u32 dwords, u64 pbc);
+int hfi1_verbs_send_pio(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
+			u64 pbc);
 
 struct send_context *qp_to_send_context(struct hfi1_qp *qp, u8 sc5);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
