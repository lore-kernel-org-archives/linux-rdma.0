From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/13] IB/qib,IB/hfi: Use core common header file
Date: Tue, 06 Sep 2016 04:35:05 -0700
Message-ID: <20160906113454.27413.78226.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use common header file structs, defines, and accessors
in the drivers.  The old declarations are removed.

The repositioning of the includes allows for the removal
of hfi1_message_header and replaces its use with ib_header.

Also corrected are two issues with set_armed_to_active():
- The "packet" parameter is now a pointer as it should have been
- The etype is validated to insure that the header is correct

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c         |    6 +-
 drivers/infiniband/hw/hfi1/chip.h         |    2 -
 drivers/infiniband/hw/hfi1/common.h       |    8 --
 drivers/infiniband/hw/hfi1/driver.c       |   35 +++++------
 drivers/infiniband/hw/hfi1/hfi.h          |    7 +-
 drivers/infiniband/hw/hfi1/rc.c           |   87 ++++++++++++---------------
 drivers/infiniband/hw/hfi1/ruc.c          |    4 +
 drivers/infiniband/hw/hfi1/trace.c        |   27 ++------
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   14 ++--
 drivers/infiniband/hw/hfi1/trace_rx.h     |    4 +
 drivers/infiniband/hw/hfi1/uc.c           |    6 +-
 drivers/infiniband/hw/hfi1/ud.c           |   12 ++--
 drivers/infiniband/hw/hfi1/verbs.c        |   14 ++--
 drivers/infiniband/hw/hfi1/verbs.h        |   90 ++--------------------------
 drivers/infiniband/hw/qib/qib.h           |    1 
 drivers/infiniband/hw/qib/qib_driver.c    |    4 +
 drivers/infiniband/hw/qib/qib_iba7322.c   |    2 -
 drivers/infiniband/hw/qib/qib_rc.c        |   61 ++++++++-----------
 drivers/infiniband/hw/qib/qib_ruc.c       |    4 +
 drivers/infiniband/hw/qib/qib_uc.c        |    6 +-
 drivers/infiniband/hw/qib/qib_ud.c        |    6 +-
 drivers/infiniband/hw/qib/qib_verbs.c     |   14 ++--
 drivers/infiniband/hw/qib/qib_verbs.h     |   94 +++--------------------------
 23 files changed, 162 insertions(+), 346 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index cc38004..8e657db 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9718,12 +9718,12 @@ void hfi1_clear_tids(struct hfi1_ctxtdata *rcd)
 		hfi1_put_tid(dd, i, PT_INVALID, 0, 0);
 }
 
-struct hfi1_message_header *hfi1_get_msgheader(
-				struct hfi1_devdata *dd, __le32 *rhf_addr)
+struct ib_header *hfi1_get_msgheader(
+	struct hfi1_devdata *dd, __le32 *rhf_addr)
 {
 	u32 offset = rhf_hdrq_offset(rhf_to_cpu(rhf_addr));
 
-	return (struct hfi1_message_header *)
+	return (struct ib_header *)
 		(rhf_addr - dd->rhf_offset + offset);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index e295737..35a7855 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1336,7 +1336,7 @@ enum {
 u64 get_all_cpu_total(u64 __percpu *cntr);
 void hfi1_start_cleanup(struct hfi1_devdata *dd);
 void hfi1_clear_tids(struct hfi1_ctxtdata *rcd);
-struct hfi1_message_header *hfi1_get_msgheader(
+struct ib_header *hfi1_get_msgheader(
 				struct hfi1_devdata *dd, __le32 *rhf_addr);
 int hfi1_init_ctxt(struct send_context *sc);
 void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
diff --git a/drivers/infiniband/hw/hfi1/common.h b/drivers/infiniband/hw/hfi1/common.h
index fcc9c21..da7be21 100644
--- a/drivers/infiniband/hw/hfi1/common.h
+++ b/drivers/infiniband/hw/hfi1/common.h
@@ -320,14 +320,6 @@ struct diag_pkt {
 /* RHF receive type error - bypass packet errors */
 #define RHF_RTE_BYPASS_NO_ERR		0x0
 
-/*
- * This structure contains the first field common to all protocols
- * that employ this chip.
- */
-struct hfi1_message_header {
-	__be16 lrh[4];
-};
-
 /* IB - LRH header constants */
 #define HFI1_LRH_GRH 0x0003      /* 1. word of IB LRH - next header: GRH */
 #define HFI1_LRH_BTH 0x0002      /* 1. word of IB LRH - next header: BTH */
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 303f105..6563e4d 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -276,7 +276,7 @@ inline int hfi1_rcvbuf_validate(u32 size, u8 type, u16 *encoded)
 static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		       struct hfi1_packet *packet)
 {
-	struct hfi1_message_header *rhdr = packet->hdr;
+	struct ib_header *rhdr = packet->hdr;
 	u32 rte = rhf_rcv_type_err(packet->rhf);
 	int lnh = be16_to_cpu(rhdr->lrh[0]) & 3;
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
@@ -288,10 +288,9 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 
 	if (packet->rhf & RHF_TID_ERR) {
 		/* For TIDERR and RC QPs preemptively schedule a NAK */
-		struct hfi1_ib_header *hdr = (struct hfi1_ib_header *)rhdr;
-		struct hfi1_other_headers *ohdr = NULL;
+		struct ib_other_headers *ohdr = NULL;
 		u32 tlen = rhf_pkt_len(packet->rhf); /* in bytes */
-		u16 lid  = be16_to_cpu(hdr->lrh[1]);
+		u16 lid  = be16_to_cpu(rhdr->lrh[1]);
 		u32 qp_num;
 		u32 rcv_flags = 0;
 
@@ -301,14 +300,14 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 
 		/* Check for GRH */
 		if (lnh == HFI1_LRH_BTH) {
-			ohdr = &hdr->u.oth;
+			ohdr = &rhdr->u.oth;
 		} else if (lnh == HFI1_LRH_GRH) {
 			u32 vtf;
 
-			ohdr = &hdr->u.l.oth;
-			if (hdr->u.l.grh.next_hdr != IB_GRH_NEXT_HDR)
+			ohdr = &rhdr->u.l.oth;
+			if (rhdr->u.l.grh.next_hdr != IB_GRH_NEXT_HDR)
 				goto drop;
-			vtf = be32_to_cpu(hdr->u.l.grh.version_tclass_flow);
+			vtf = be32_to_cpu(rhdr->u.l.grh.version_tclass_flow);
 			if ((vtf >> IB_GRH_VERSION_SHIFT) != IB_GRH_VERSION)
 				goto drop;
 			rcv_flags |= HFI1_HAS_GRH;
@@ -344,7 +343,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			case IB_QPT_RC:
 				hfi1_rc_hdrerr(
 					rcd,
-					hdr,
+					rhdr,
 					rcv_flags,
 					qp);
 				break;
@@ -452,8 +451,8 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 			       bool do_cnp)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_ib_header *hdr = pkt->hdr;
-	struct hfi1_other_headers *ohdr = pkt->ohdr;
+	struct ib_header *hdr = pkt->hdr;
+	struct ib_other_headers *ohdr = pkt->ohdr;
 	struct ib_grh *grh = NULL;
 	u32 rqpn = 0, bth1;
 	u16 rlid, dlid = be16_to_cpu(hdr->lrh[1]);
@@ -487,7 +486,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 		return;
 	}
 
-	sc = hdr2sc((struct hfi1_message_header *)hdr, pkt->rhf);
+	sc = hdr2sc(hdr, pkt->rhf);
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
 	if (do_cnp && (bth1 & HFI1_FECN_SMASK)) {
@@ -599,8 +598,8 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		__le32 *rhf_addr = (__le32 *)rcd->rcvhdrq + mdata.ps_head +
 					 dd->rhf_offset;
 		struct rvt_qp *qp;
-		struct hfi1_ib_header *hdr;
-		struct hfi1_other_headers *ohdr;
+		struct ib_header *hdr;
+		struct ib_other_headers *ohdr;
 		struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 		u64 rhf = rhf_to_cpu(rhf_addr);
 		u32 etype = rhf_rcv_type(rhf), qpn, bth1;
@@ -616,8 +615,8 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		if (etype != RHF_RCV_TYPE_IB)
 			goto next;
 
-		hdr = (struct hfi1_ib_header *)
-			hfi1_get_msgheader(dd, rhf_addr);
+		hdr = hfi1_get_msgheader(dd, rhf_addr);
+
 		lnh = be16_to_cpu(hdr->lrh[0]) & 3;
 
 		if (lnh == HFI1_LRH_BTH)
@@ -892,8 +891,8 @@ static inline int set_armed_to_active(struct hfi1_ctxtdata *rcd,
 				      struct hfi1_devdata *dd)
 {
 	struct work_struct *lsaw = &rcd->ppd->linkstate_active_work;
-	struct hfi1_message_header *hdr = hfi1_get_msgheader(packet->rcd->dd,
-							     packet->rhf_addr);
+	struct ib_header *hdr = hfi1_get_msgheader(packet->rcd->dd,
+						   packet->rhf_addr);
 	u8 etype = rhf_rcv_type(packet->rhf);
 
 	if (etype == RHF_RCV_TYPE_IB && hdr2sc(hdr, packet->rhf) != 0xf) {
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 325ec21..791d7a2 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -64,6 +64,7 @@
 #include <linux/kthread.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
+#include <rdma/ib_hdrs.h>
 #include <rdma/rdma_vt.h>
 
 #include "chip_registers.h"
@@ -350,7 +351,7 @@ struct hfi1_packet {
 	struct hfi1_ctxtdata *rcd;
 	__le32 *rhf_addr;
 	struct rvt_qp *qp;
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	u64 rhf;
 	u32 maxcnt;
 	u32 rhqoff;
@@ -1268,7 +1269,7 @@ static inline u32 driver_lstate(struct hfi1_pportdata *ppd)
 void receive_interrupt_work(struct work_struct *work);
 
 /* extract service channel from header and rhf */
-static inline int hdr2sc(struct hfi1_message_header *hdr, u64 rhf)
+static inline int hdr2sc(struct ib_header *hdr, u64 rhf)
 {
 	return ((be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf) |
 	       ((!!(rhf_dc_info(rhf))) << 4);
@@ -1603,7 +1604,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
 			       bool do_cnp)
 {
-	struct hfi1_other_headers *ohdr = pkt->ohdr;
+	struct ib_other_headers *ohdr = pkt->ohdr;
 	u32 bth1;
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index acf0eb8..9f7900f 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -216,7 +216,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
  * Note the QP s_lock must be held.
  */
 static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
-		       struct hfi1_other_headers *ohdr,
+		       struct ib_other_headers *ohdr,
 		       struct hfi1_pkt_state *ps)
 {
 	struct rvt_ack_entry *e;
@@ -299,10 +299,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 			len = 0;
 			qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
 			ohdr->u.at.aeth = hfi1_compute_aeth(qp);
-			ohdr->u.at.atomic_ack_eth[0] =
-				cpu_to_be32(e->atomic_data >> 32);
-			ohdr->u.at.atomic_ack_eth[1] =
-				cpu_to_be32(e->atomic_data);
+			ib_u64_put(e->atomic_data, &ohdr->u.at.atomic_ack_eth);
 			hwords += sizeof(ohdr->u.at) / sizeof(u32);
 			bth2 = mask_psn(e->psn);
 			e->sent = 1;
@@ -390,7 +387,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_sge_state *ss;
 	struct rvt_swqe *wqe;
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
@@ -566,8 +563,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
-			ohdr->u.rc.reth.vaddr =
-				cpu_to_be64(wqe->rdma_wr.remote_addr);
+			put_ib_reth_vaddr(
+				wqe->rdma_wr.remote_addr,
+				&ohdr->u.rc.reth);
 			ohdr->u.rc.reth.rkey =
 				cpu_to_be32(wqe->rdma_wr.rkey);
 			ohdr->u.rc.reth.length = cpu_to_be32(len);
@@ -608,8 +606,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
 			}
-			ohdr->u.rc.reth.vaddr =
-				cpu_to_be64(wqe->rdma_wr.remote_addr);
+			put_ib_reth_vaddr(
+				wqe->rdma_wr.remote_addr,
+				&ohdr->u.rc.reth);
 			ohdr->u.rc.reth.rkey =
 				cpu_to_be32(wqe->rdma_wr.rkey);
 			ohdr->u.rc.reth.length = cpu_to_be32(len);
@@ -640,20 +639,18 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			}
 			if (wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
 				qp->s_state = OP(COMPARE_SWAP);
-				ohdr->u.atomic_eth.swap_data = cpu_to_be64(
-					wqe->atomic_wr.swap);
-				ohdr->u.atomic_eth.compare_data = cpu_to_be64(
-					wqe->atomic_wr.compare_add);
+				put_ib_ateth_swap(wqe->atomic_wr.swap,
+						  &ohdr->u.atomic_eth);
+				put_ib_ateth_compare(wqe->atomic_wr.compare_add,
+						     &ohdr->u.atomic_eth);
 			} else {
 				qp->s_state = OP(FETCH_ADD);
-				ohdr->u.atomic_eth.swap_data = cpu_to_be64(
-					wqe->atomic_wr.compare_add);
-				ohdr->u.atomic_eth.compare_data = 0;
+				put_ib_ateth_swap(wqe->atomic_wr.compare_add,
+						  &ohdr->u.atomic_eth);
+				put_ib_ateth_compare(0, &ohdr->u.atomic_eth);
 			}
-			ohdr->u.atomic_eth.vaddr[0] = cpu_to_be32(
-				wqe->atomic_wr.remote_addr >> 32);
-			ohdr->u.atomic_eth.vaddr[1] = cpu_to_be32(
-				wqe->atomic_wr.remote_addr);
+			put_ib_ateth_vaddr(wqe->atomic_wr.remote_addr,
+					   &ohdr->u.atomic_eth);
 			ohdr->u.atomic_eth.rkey = cpu_to_be32(
 				wqe->atomic_wr.rkey);
 			hwords += sizeof(struct ib_atomic_eth) / sizeof(u32);
@@ -779,8 +776,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		 * See restart_rc().
 		 */
 		len = (delta_psn(qp->s_psn, wqe->psn)) * pmtu;
-		ohdr->u.rc.reth.vaddr =
-			cpu_to_be64(wqe->rdma_wr.remote_addr + len);
+		put_ib_reth_vaddr(
+			wqe->rdma_wr.remote_addr + len,
+			&ohdr->u.rc.reth);
 		ohdr->u.rc.reth.rkey =
 			cpu_to_be32(wqe->rdma_wr.rkey);
 		ohdr->u.rc.reth.length = cpu_to_be32(wqe->length - len);
@@ -856,8 +854,8 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	u32 vl, plen;
 	struct send_context *sc;
 	struct pio_buf *pbuf;
-	struct hfi1_ib_header hdr;
-	struct hfi1_other_headers *ohdr;
+	struct ib_header hdr;
+	struct ib_other_headers *ohdr;
 	unsigned long flags;
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
@@ -1141,9 +1139,9 @@ static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 /*
  * This should be called with the QP s_lock held and interrupts disabled.
  */
-void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
+void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 {
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
 	struct ib_wc wc;
 	unsigned i;
@@ -1595,7 +1593,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
  * Called at interrupt level.
  */
 static void rc_rcv_resp(struct hfi1_ibport *ibp,
-			struct hfi1_other_headers *ohdr,
+			struct ib_other_headers *ohdr,
 			void *data, u32 tlen, struct rvt_qp *qp,
 			u32 opcode, u32 psn, u32 hdrsize, u32 pmtu,
 			struct hfi1_ctxtdata *rcd)
@@ -1649,14 +1647,10 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 	case OP(ATOMIC_ACKNOWLEDGE):
 	case OP(RDMA_READ_RESPONSE_FIRST):
 		aeth = be32_to_cpu(ohdr->u.aeth);
-		if (opcode == OP(ATOMIC_ACKNOWLEDGE)) {
-			__be32 *p = ohdr->u.at.atomic_ack_eth;
-
-			val = ((u64)be32_to_cpu(p[0]) << 32) |
-				be32_to_cpu(p[1]);
-		} else {
+		if (opcode == OP(ATOMIC_ACKNOWLEDGE))
+			val = ib_u64_get(&ohdr->u.at.atomic_ack_eth);
+		else
 			val = 0;
-		}
 		if (!do_rc_ack(qp, aeth, psn, opcode, val, rcd) ||
 		    opcode != OP(RDMA_READ_RESPONSE_FIRST))
 			goto ack_done;
@@ -1814,7 +1808,7 @@ static inline void rc_cancel_ack(struct rvt_qp *qp)
  * Return 1 if no more processing is needed; otherwise return 0 to
  * schedule a response to be sent.
  */
-static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
+static noinline int rc_rcv_error(struct ib_other_headers *ohdr, void *data,
 				 struct rvt_qp *qp, u32 opcode, u32 psn,
 				 int diff, struct hfi1_ctxtdata *rcd)
 {
@@ -1922,7 +1916,7 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 		}
 		if (len != 0) {
 			u32 rkey = be32_to_cpu(reth->rkey);
-			u64 vaddr = be64_to_cpu(reth->vaddr);
+			u64 vaddr = get_ib_reth_vaddr(reth);
 			int ok;
 
 			ok = rvt_rkey_ok(qp, &e->rdma_sge, len, vaddr, rkey,
@@ -2122,13 +2116,13 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 void hfi1_rc_rcv(struct hfi1_packet *packet)
 {
 	struct hfi1_ctxtdata *rcd = packet->rcd;
-	struct hfi1_ib_header *hdr = packet->hdr;
+	struct ib_header *hdr = packet->hdr;
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_other_headers *ohdr = packet->ohdr;
+	struct ib_other_headers *ohdr = packet->ohdr;
 	u32 bth0, opcode;
 	u32 hdrsize = packet->hlen;
 	u32 psn;
@@ -2341,7 +2335,7 @@ send_last:
 		qp->r_sge.sg_list = NULL;
 		if (qp->r_len != 0) {
 			u32 rkey = be32_to_cpu(reth->rkey);
-			u64 vaddr = be64_to_cpu(reth->vaddr);
+			u64 vaddr = get_ib_reth_vaddr(reth);
 			int ok;
 
 			/* Check rkey & NAK */
@@ -2396,7 +2390,7 @@ send_last:
 		len = be32_to_cpu(reth->length);
 		if (len) {
 			u32 rkey = be32_to_cpu(reth->rkey);
-			u64 vaddr = be64_to_cpu(reth->vaddr);
+			u64 vaddr = get_ib_reth_vaddr(reth);
 			int ok;
 
 			/* Check rkey & NAK */
@@ -2468,8 +2462,7 @@ send_last:
 			e->rdma_sge.mr = NULL;
 		}
 		ateth = &ohdr->u.atomic_eth;
-		vaddr = ((u64)be32_to_cpu(ateth->vaddr[0]) << 32) |
-			be32_to_cpu(ateth->vaddr[1]);
+		vaddr = get_ib_ateth_vaddr(ateth);
 		if (unlikely(vaddr & (sizeof(u64) - 1)))
 			goto nack_inv_unlck;
 		rkey = be32_to_cpu(ateth->rkey);
@@ -2480,11 +2473,11 @@ send_last:
 			goto nack_acc_unlck;
 		/* Perform atomic OP and save result. */
 		maddr = (atomic64_t *)qp->r_sge.sge.vaddr;
-		sdata = be64_to_cpu(ateth->swap_data);
+		sdata = get_ib_ateth_swap(ateth);
 		e->atomic_data = (opcode == OP(FETCH_ADD)) ?
 			(u64)atomic64_add_return(sdata, maddr) - sdata :
 			(u64)cmpxchg((u64 *)qp->r_sge.sge.vaddr,
-				      be64_to_cpu(ateth->compare_data),
+				      get_ib_ateth_compare(ateth),
 				      sdata);
 		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
@@ -2574,12 +2567,12 @@ send_ack:
 
 void hfi1_rc_hdrerr(
 	struct hfi1_ctxtdata *rcd,
-	struct hfi1_ib_header *hdr,
+	struct ib_header *hdr,
 	u32 rcv_flags,
 	struct rvt_qp *qp)
 {
 	int has_grh = rcv_flags & HFI1_HAS_GRH;
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	int diff;
 	u32 opcode;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 48d5094..7ce2b3c 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -262,7 +262,7 @@ static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
  *
  * The s_lock will be acquired around the hfi1_migrate_qp() call.
  */
-int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
+int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct ib_header *hdr,
 		       int has_grh, struct rvt_qp *qp, u32 bth0)
 {
 	__be64 guid;
@@ -765,7 +765,7 @@ static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 	}
 }
 
-void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
+void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle,
 			  struct hfi1_pkt_state *ps)
 {
diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 4cfb137..4a0221f 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -47,9 +47,9 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
-u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr)
+u8 ibhdr_exhdr_len(struct ib_header *hdr)
 {
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	u8 opcode;
 	u8 lnh = (u8)(be16_to_cpu(hdr->lrh[0]) & 3);
 
@@ -72,11 +72,6 @@ u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr)
 
 #define OP(transport, op) IB_OPCODE_## transport ## _ ## op
 
-static u64 ib_u64_get(__be32 *p)
-{
-	return ((u64)be32_to_cpu(p[0]) << 32) | be32_to_cpu(p[1]);
-}
-
 static const char *parse_syndrome(u8 syndrome)
 {
 	switch (syndrome >> 5) {
@@ -113,8 +108,7 @@ const char *parse_everbs_hdrs(
 	case OP(RC, RDMA_WRITE_ONLY_WITH_IMMEDIATE):
 	case OP(UC, RDMA_WRITE_ONLY_WITH_IMMEDIATE):
 		trace_seq_printf(p, RETH_PRN " " IMM_PRN,
-				 (unsigned long long)ib_u64_get(
-				 (__be32 *)&eh->rc.reth.vaddr),
+				 get_ib_reth_vaddr(&eh->rc.reth),
 				 be32_to_cpu(eh->rc.reth.rkey),
 				 be32_to_cpu(eh->rc.reth.length),
 				 be32_to_cpu(eh->rc.imm_data));
@@ -126,8 +120,7 @@ const char *parse_everbs_hdrs(
 	case OP(RC, RDMA_WRITE_ONLY):
 	case OP(UC, RDMA_WRITE_ONLY):
 		trace_seq_printf(p, RETH_PRN,
-				 (unsigned long long)ib_u64_get(
-				 (__be32 *)&eh->rc.reth.vaddr),
+				 get_ib_reth_vaddr(&eh->rc.reth),
 				 be32_to_cpu(eh->rc.reth.rkey),
 				 be32_to_cpu(eh->rc.reth.length));
 		break;
@@ -145,20 +138,16 @@ const char *parse_everbs_hdrs(
 				 be32_to_cpu(eh->at.aeth) >> 24,
 				 parse_syndrome(be32_to_cpu(eh->at.aeth) >> 24),
 				 be32_to_cpu(eh->at.aeth) & HFI1_MSN_MASK,
-				 (unsigned long long)
-				 ib_u64_get(eh->at.atomic_ack_eth));
+				 ib_u64_get(&eh->at.atomic_ack_eth));
 		break;
 	/* atomiceth */
 	case OP(RC, COMPARE_SWAP):
 	case OP(RC, FETCH_ADD):
 		trace_seq_printf(p, ATOMICETH_PRN,
-				 (unsigned long long)ib_u64_get(
-				 eh->atomic_eth.vaddr),
+				 get_ib_ateth_vaddr(&eh->atomic_eth),
 				 eh->atomic_eth.rkey,
-				 (unsigned long long)ib_u64_get(
-				 (__be32 *)&eh->atomic_eth.swap_data),
-				 (unsigned long long)ib_u64_get(
-				 (__be32 *)&eh->atomic_eth.compare_data));
+				 get_ib_ateth_swap(&eh->atomic_eth),
+				 get_ib_ateth_compare(&eh->atomic_eth));
 		break;
 	/* deth */
 	case OP(UD, SEND_ONLY):
diff --git a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
index c3e41ae..382fcda 100644
--- a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
+++ b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
@@ -55,7 +55,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_ibhdrs
 
-u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr);
+u8 ibhdr_exhdr_len(struct ib_header *hdr);
 const char *parse_everbs_hdrs(struct trace_seq *p, u8 opcode, void *ehdrs);
 
 #define __parse_ib_ehdrs(op, ehdrs) parse_everbs_hdrs(p, op, ehdrs)
@@ -74,7 +74,7 @@ __print_symbolic(lrh,                    \
 
 DECLARE_EVENT_CLASS(hfi1_ibhdr_template,
 		    TP_PROTO(struct hfi1_devdata *dd,
-			     struct hfi1_ib_header *hdr),
+			     struct ib_header *hdr),
 		    TP_ARGS(dd, hdr),
 		    TP_STRUCT__entry(
 			DD_DEV_ENTRY(dd)
@@ -102,7 +102,7 @@ DECLARE_EVENT_CLASS(hfi1_ibhdr_template,
 			__dynamic_array(u8, ehdrs, ibhdr_exhdr_len(hdr))
 			),
 		      TP_fast_assign(
-			struct hfi1_other_headers *ohdr;
+			struct ib_other_headers *ohdr;
 
 			DD_DEV_ASSIGN(dd);
 			/* LRH */
@@ -185,19 +185,19 @@ DECLARE_EVENT_CLASS(hfi1_ibhdr_template,
 );
 
 DEFINE_EVENT(hfi1_ibhdr_template, input_ibhdr,
-	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
+	     TP_PROTO(struct hfi1_devdata *dd, struct ib_header *hdr),
 	     TP_ARGS(dd, hdr));
 
 DEFINE_EVENT(hfi1_ibhdr_template, pio_output_ibhdr,
-	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
+	     TP_PROTO(struct hfi1_devdata *dd, struct ib_header *hdr),
 	     TP_ARGS(dd, hdr));
 
 DEFINE_EVENT(hfi1_ibhdr_template, ack_output_ibhdr,
-	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
+	     TP_PROTO(struct hfi1_devdata *dd, struct ib_header *hdr),
 	     TP_ARGS(dd, hdr));
 
 DEFINE_EVENT(hfi1_ibhdr_template, sdma_output_ibhdr,
-	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
+	     TP_PROTO(struct hfi1_devdata *dd, struct ib_header *hdr),
 	     TP_ARGS(dd, hdr));
 
 #endif /* __HFI1_TRACE_IBHDRS_H */
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index 9ba1f61..11e02b2 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -260,7 +260,7 @@ TRACE_EVENT(hfi1_mmu_invalidate,
 TRACE_EVENT(snoop_capture,
 	    TP_PROTO(struct hfi1_devdata *dd,
 		     int hdr_len,
-		     struct hfi1_ib_header *hdr,
+		     struct ib_header *hdr,
 		     int data_len,
 		     void *data),
 	    TP_ARGS(dd, hdr_len, hdr, data_len, data),
@@ -279,7 +279,7 @@ TRACE_EVENT(snoop_capture,
 			     __dynamic_array(u8, raw_pkt, data_len)
 			     ),
 	    TP_fast_assign(
-		struct hfi1_other_headers *ohdr;
+		struct ib_other_headers *ohdr;
 
 		__entry->lnh = (u8)(be16_to_cpu(hdr->lrh[0]) & 3);
 		if (__entry->lnh == HFI1_LRH_BTH)
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index a726d96..e7fa176 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -70,7 +70,7 @@ const u32 uc_only_opcode =
 int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
 	u32 hwords = 5;
 	u32 bth0 = 0;
@@ -304,12 +304,12 @@ bail_no_tx:
 void hfi1_uc_rcv(struct hfi1_packet *packet)
 {
 	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
-	struct hfi1_ib_header *hdr = packet->hdr;
+	struct ib_header *hdr = packet->hdr;
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
-	struct hfi1_other_headers *ohdr = packet->ohdr;
+	struct ib_other_headers *ohdr = packet->ohdr;
 	u32 bth0, opcode;
 	u32 hdrsize = packet->hlen;
 	u32 psn;
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index f01e8e1..090e716 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -271,7 +271,7 @@ drop:
 int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct ib_ah_attr *ah_attr;
 	struct hfi1_pportdata *ppd;
 	struct hfi1_ibport *ibp;
@@ -510,8 +510,8 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	u32 bth0, plen, vl, hwords = 5;
 	u16 lrh0;
 	u8 sl = ibp->sc_to_sl[sc5];
-	struct hfi1_ib_header hdr;
-	struct hfi1_other_headers *ohdr;
+	struct ib_header hdr;
+	struct ib_other_headers *ohdr;
 	struct pio_buf *pbuf;
 	struct send_context *ctxt = qp_to_send_context(qp, sc5);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -665,7 +665,7 @@ static int opa_smp_check(struct hfi1_ibport *ibp, u16 pkey, u8 sc5,
  */
 void hfi1_ud_rcv(struct hfi1_packet *packet)
 {
-	struct hfi1_other_headers *ohdr = packet->ohdr;
+	struct ib_other_headers *ohdr = packet->ohdr;
 	int opcode;
 	u32 hdrsize = packet->hlen;
 	struct ib_wc wc;
@@ -675,13 +675,13 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	int mgmt_pkey_idx = -1;
 	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_ib_header *hdr = packet->hdr;
+	struct ib_header *hdr = packet->hdr;
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
 	bool has_grh = rcv_flags & HFI1_HAS_GRH;
-	u8 sc5 = hdr2sc((struct hfi1_message_header *)hdr, packet->rhf);
+	u8 sc5 = hdr2sc(hdr, packet->rhf);
 	u32 bth1;
 	u8 sl_from_sc, sl;
 	u16 slid;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 92a61c4..d502ba0 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -567,7 +567,7 @@ static inline opcode_handler qp_ok(int opcode, struct hfi1_packet *packet)
 void hfi1_ib_rcv(struct hfi1_packet *packet)
 {
 	struct hfi1_ctxtdata *rcd = packet->rcd;
-	struct hfi1_ib_header *hdr = packet->hdr;
+	struct ib_header *hdr = packet->hdr;
 	u32 tlen = packet->tlen;
 	struct hfi1_pportdata *ppd = rcd->ppd;
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
@@ -719,7 +719,7 @@ static void verbs_sdma_complete(
 	if (tx->wqe) {
 		hfi1_send_complete(qp, tx->wqe, IB_WC_SUCCESS);
 	} else if (qp->ibqp.qp_type == IB_QPT_RC) {
-		struct hfi1_ib_header *hdr;
+		struct ib_header *hdr;
 
 		hdr = &tx->phdr.hdr;
 		hfi1_rc_send_complete(qp, hdr);
@@ -1200,7 +1200,7 @@ static inline send_routine get_send_routine(struct rvt_qp *qp,
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_ib_header *h = &tx->phdr.hdr;
+	struct ib_header *h = &tx->phdr.hdr;
 
 	if (unlikely(!(dd->flags & HFI1_HAS_SEND_DMA)))
 		return dd->process_pio_send;
@@ -1244,8 +1244,8 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_other_headers *ohdr;
-	struct hfi1_ib_header *hdr;
+	struct ib_other_headers *ohdr;
+	struct ib_header *hdr;
 	send_routine sr;
 	int ret;
 	u8 lnh;
@@ -1754,7 +1754,7 @@ void hfi1_cnp_rcv(struct hfi1_packet *packet)
 {
 	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_ib_header *hdr = packet->hdr;
+	struct ib_header *hdr = packet->hdr;
 	struct rvt_qp *qp = packet->qp;
 	u32 lqpn, rqpn = 0;
 	u16 rlid = 0;
@@ -1781,7 +1781,7 @@ void hfi1_cnp_rcv(struct hfi1_packet *packet)
 		return;
 	}
 
-	sc5 = hdr2sc((struct hfi1_message_header *)hdr, packet->rhf);
+	sc5 = hdr2sc(hdr, packet->rhf);
 	sl = ibp->sc_to_sl[sc5];
 	lqpn = qp->ibqp.qp_num;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index d1b101c..0dd65eb 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -60,6 +60,7 @@
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_mad.h>
+#include <rdma/ib_hdrs.h>
 #include <rdma/rdma_vt.h>
 #include <rdma/rdmavt_qp.h>
 #include <rdma/rdmavt_cq.h>
@@ -80,16 +81,6 @@ struct hfi1_packet;
  */
 #define HFI1_UVERBS_ABI_VERSION       2
 
-#define IB_SEQ_NAK	(3 << 29)
-
-/* AETH NAK opcode values */
-#define IB_RNR_NAK                      0x20
-#define IB_NAK_PSN_ERROR                0x60
-#define IB_NAK_INVALID_REQUEST          0x61
-#define IB_NAK_REMOTE_ACCESS_ERROR      0x62
-#define IB_NAK_REMOTE_OPERATIONAL_ERROR 0x63
-#define IB_NAK_INVALID_RD_REQUEST       0x64
-
 /* IB Performance Manager status values */
 #define IB_PMA_SAMPLE_STATUS_DONE       0x00
 #define IB_PMA_SAMPLE_STATUS_STARTED    0x01
@@ -104,19 +95,6 @@ struct hfi1_packet;
 
 #define HFI1_VENDOR_IPG		cpu_to_be16(0xFFA0)
 
-#define IB_BTH_REQ_ACK		BIT(31)
-#define IB_BTH_SOLICITED	BIT(23)
-#define IB_BTH_MIG_REQ		BIT(22)
-
-#define IB_GRH_VERSION		6
-#define IB_GRH_VERSION_MASK	0xF
-#define IB_GRH_VERSION_SHIFT	28
-#define IB_GRH_TCLASS_MASK	0xFF
-#define IB_GRH_TCLASS_SHIFT	20
-#define IB_GRH_FLOW_MASK	0xFFFFF
-#define IB_GRH_FLOW_SHIFT	0
-#define IB_GRH_NEXT_HDR		0x1B
-
 #define IB_DEFAULT_GID_PREFIX	cpu_to_be64(0xfe80000000000000ULL)
 
 /* flags passed by hfi1_ib_rcv() */
@@ -124,60 +102,6 @@ enum {
 	HFI1_HAS_GRH = (1 << 0),
 };
 
-struct ib_reth {
-	__be64 vaddr;
-	__be32 rkey;
-	__be32 length;
-} __packed;
-
-struct ib_atomic_eth {
-	__be32 vaddr[2];        /* unaligned so access as 2 32-bit words */
-	__be32 rkey;
-	__be64 swap_data;
-	__be64 compare_data;
-} __packed;
-
-union ib_ehdrs {
-	struct {
-		__be32 deth[2];
-		__be32 imm_data;
-	} ud;
-	struct {
-		struct ib_reth reth;
-		__be32 imm_data;
-	} rc;
-	struct {
-		__be32 aeth;
-		__be32 atomic_ack_eth[2];
-	} at;
-	__be32 imm_data;
-	__be32 aeth;
-	__be32 ieth;
-	struct ib_atomic_eth atomic_eth;
-}  __packed;
-
-struct hfi1_other_headers {
-	__be32 bth[3];
-	union ib_ehdrs u;
-} __packed;
-
-/*
- * Note that UD packets with a GRH header are 8+40+12+8 = 68 bytes
- * long (72 w/ imm_data).  Only the first 56 bytes of the IB header
- * will be in the eager header buffer.  The remaining 12 or 16 bytes
- * are in the data buffer.
- */
-struct hfi1_ib_header {
-	__be16 lrh[4];
-	union {
-		struct {
-			struct ib_grh grh;
-			struct hfi1_other_headers oth;
-		} l;
-		struct hfi1_other_headers oth;
-	} u;
-} __packed;
-
 struct hfi1_ahg_info {
 	u32 ahgdesc[2];
 	u16 tx_flags;
@@ -187,7 +111,7 @@ struct hfi1_ahg_info {
 
 struct hfi1_sdma_header {
 	__le64 pbc;
-	struct hfi1_ib_header hdr;
+	struct ib_header hdr;
 } __packed;
 
 /*
@@ -386,7 +310,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet);
 
 void hfi1_rc_hdrerr(
 	struct hfi1_ctxtdata *rcd,
-	struct hfi1_ib_header *hdr,
+	struct ib_header *hdr,
 	u32 rcv_flags,
 	struct rvt_qp *qp);
 
@@ -400,7 +324,7 @@ void hfi1_rc_timeout(unsigned long arg);
 void hfi1_del_timers_sync(struct rvt_qp *qp);
 void hfi1_stop_rc_timers(struct rvt_qp *qp);
 
-void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr);
+void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr);
 
 void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
 
@@ -423,7 +347,7 @@ int hfi1_check_send_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe);
 extern const u32 rc_only_opcode;
 extern const u32 uc_only_opcode;
 
-static inline u8 get_opcode(struct hfi1_ib_header *h)
+static inline u8 get_opcode(struct ib_header *h)
 {
 	u16 lnh = be16_to_cpu(h->lrh[0]) & 3;
 
@@ -433,13 +357,13 @@ static inline u8 get_opcode(struct hfi1_ib_header *h)
 		return be32_to_cpu(h->u.l.oth.bth[0]) >> 24;
 }
 
-int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
+int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct ib_header *hdr,
 		       int has_grh, struct rvt_qp *qp, u32 bth0);
 
 u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 		  struct ib_global_route *grh, u32 hwords, u32 nwords);
 
-void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
+void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle,
 			  struct hfi1_pkt_state *ps);
 
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index bbf0a16..bebc9a5 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -52,6 +52,7 @@
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
+#include <rdma/ib_hdrs.h>
 #include <rdma/rdma_vt.h>
 
 #include "qib_common.h"
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index df77d5f..728e0a0 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -319,8 +319,8 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		ret = 1;
 	else if (eflags == QLOGIC_IB_RHF_H_TIDERR) {
 		/* For TIDERR and RC QPs premptively schedule a NAK */
-		struct qib_ib_header *hdr = (struct qib_ib_header *) rhdr;
-		struct qib_other_headers *ohdr = NULL;
+		struct ib_header *hdr = (struct ib_header *)rhdr;
+		struct ib_other_headers *ohdr = NULL;
 		struct qib_ibport *ibp = &ppd->ibport_data;
 		struct qib_devdata *dd = ppd->dd;
 		struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index ce40340..ded2717 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1415,7 +1415,7 @@ static void flush_fifo(struct qib_pportdata *ppd)
 	u32 *hdr;
 	u64 pbc;
 	const unsigned hdrwords = 7;
-	static struct qib_ib_header ibhdr = {
+	static struct ib_header ibhdr = {
 		.lrh[0] = cpu_to_be16(0xF000 | QIB_LRH_BTH),
 		.lrh[1] = IB_LID_PERMISSIVE,
 		.lrh[2] = cpu_to_be16(hdrwords + SIZE_OF_CRC),
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 38cd871..2097512 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -75,7 +75,7 @@ static void start_timer(struct rvt_qp *qp)
  * Note the QP s_lock must be held.
  */
 static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
-			   struct qib_other_headers *ohdr, u32 pmtu)
+			   struct ib_other_headers *ohdr, u32 pmtu)
 {
 	struct rvt_ack_entry *e;
 	u32 hwords;
@@ -154,10 +154,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 			len = 0;
 			qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
 			ohdr->u.at.aeth = qib_compute_aeth(qp);
-			ohdr->u.at.atomic_ack_eth[0] =
-				cpu_to_be32(e->atomic_data >> 32);
-			ohdr->u.at.atomic_ack_eth[1] =
-				cpu_to_be32(e->atomic_data);
+			ib_u64_put(e->atomic_data, &ohdr->u.at.atomic_ack_eth);
 			hwords += sizeof(ohdr->u.at) / sizeof(u32);
 			bth2 = e->psn & QIB_PSN_MASK;
 			e->sent = 1;
@@ -234,7 +231,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_sge_state *ss;
 	struct rvt_swqe *wqe;
 	u32 hwords;
@@ -444,20 +441,18 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 			}
 			if (wqe->atomic_wr.wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
 				qp->s_state = OP(COMPARE_SWAP);
-				ohdr->u.atomic_eth.swap_data = cpu_to_be64(
-					wqe->atomic_wr.swap);
-				ohdr->u.atomic_eth.compare_data = cpu_to_be64(
-					wqe->atomic_wr.compare_add);
+				put_ib_ateth_swap(wqe->atomic_wr.swap,
+						  &ohdr->u.atomic_eth);
+				put_ib_ateth_swap(wqe->atomic_wr.compare_add,
+						  &ohdr->u.atomic_eth);
 			} else {
 				qp->s_state = OP(FETCH_ADD);
-				ohdr->u.atomic_eth.swap_data = cpu_to_be64(
-					wqe->atomic_wr.compare_add);
-				ohdr->u.atomic_eth.compare_data = 0;
+				put_ib_ateth_swap(wqe->atomic_wr.compare_add,
+						  &ohdr->u.atomic_eth);
+				put_ib_ateth_swap(0, &ohdr->u.atomic_eth);
 			}
-			ohdr->u.atomic_eth.vaddr[0] = cpu_to_be32(
-				wqe->atomic_wr.remote_addr >> 32);
-			ohdr->u.atomic_eth.vaddr[1] = cpu_to_be32(
-				wqe->atomic_wr.remote_addr);
+			put_ib_ateth_vaddr(wqe->atomic_wr.remote_addr,
+					   &ohdr->u.atomic_eth);
 			ohdr->u.atomic_eth.rkey = cpu_to_be32(
 				wqe->atomic_wr.rkey);
 			hwords += sizeof(struct ib_atomic_eth) / sizeof(u32);
@@ -632,8 +627,8 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 	u32 hwords;
 	u32 pbufn;
 	u32 __iomem *piobuf;
-	struct qib_ib_header hdr;
-	struct qib_other_headers *ohdr;
+	struct ib_header hdr;
+	struct ib_other_headers *ohdr;
 	u32 control;
 	unsigned long flags;
 
@@ -942,9 +937,9 @@ static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 /*
  * This should be called with the QP s_lock held and interrupts disabled.
  */
-void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
+void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 {
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
 	struct ib_wc wc;
 	unsigned i;
@@ -1383,7 +1378,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
  * Called at interrupt level.
  */
 static void qib_rc_rcv_resp(struct qib_ibport *ibp,
-			    struct qib_other_headers *ohdr,
+			    struct ib_other_headers *ohdr,
 			    void *data, u32 tlen,
 			    struct rvt_qp *qp,
 			    u32 opcode,
@@ -1463,12 +1458,9 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 	case OP(ATOMIC_ACKNOWLEDGE):
 	case OP(RDMA_READ_RESPONSE_FIRST):
 		aeth = be32_to_cpu(ohdr->u.aeth);
-		if (opcode == OP(ATOMIC_ACKNOWLEDGE)) {
-			__be32 *p = ohdr->u.at.atomic_ack_eth;
-
-			val = ((u64) be32_to_cpu(p[0]) << 32) |
-				be32_to_cpu(p[1]);
-		} else
+		if (opcode == OP(ATOMIC_ACKNOWLEDGE))
+			val = ib_u64_get(&ohdr->u.at.atomic_ack_eth);
+		else
 			val = 0;
 		if (!do_rc_ack(qp, aeth, psn, opcode, val, rcd) ||
 		    opcode != OP(RDMA_READ_RESPONSE_FIRST))
@@ -1608,7 +1600,7 @@ bail:
  * Return 1 if no more processing is needed; otherwise return 0 to
  * schedule a response to be sent.
  */
-static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
+static int qib_rc_rcv_error(struct ib_other_headers *ohdr,
 			    void *data,
 			    struct rvt_qp *qp,
 			    u32 opcode,
@@ -1848,11 +1840,11 @@ static inline void qib_update_ack_queue(struct rvt_qp *qp, unsigned n)
  * for the given QP.
  * Called at interrupt level.
  */
-void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
+void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
 	struct qib_ibport *ibp = &rcd->ppd->ibport_data;
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	u32 opcode;
 	u32 hdrsize;
 	u32 psn;
@@ -2177,8 +2169,7 @@ send_last:
 			e->rdma_sge.mr = NULL;
 		}
 		ateth = &ohdr->u.atomic_eth;
-		vaddr = ((u64) be32_to_cpu(ateth->vaddr[0]) << 32) |
-			be32_to_cpu(ateth->vaddr[1]);
+		vaddr = get_ib_ateth_vaddr(ateth);
 		if (unlikely(vaddr & (sizeof(u64) - 1)))
 			goto nack_inv_unlck;
 		rkey = be32_to_cpu(ateth->rkey);
@@ -2189,11 +2180,11 @@ send_last:
 			goto nack_acc_unlck;
 		/* Perform atomic OP and save result. */
 		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
-		sdata = be64_to_cpu(ateth->swap_data);
+		sdata = get_ib_ateth_swap(ateth);
 		e->atomic_data = (opcode == OP(FETCH_ADD)) ?
 			(u64) atomic64_add_return(sdata, maddr) - sdata :
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
-				      be64_to_cpu(ateth->compare_data),
+				      get_ib_ateth_compare(ateth),
 				      sdata);
 		rvt_put_mr(qp->r_sge.sge.mr);
 		qp->r_sge.num_sge = 0;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index b677792..de1bde5 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -265,7 +265,7 @@ static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
  *
  * The s_lock will be acquired around the qib_migrate_qp() call.
  */
-int qib_ruc_check_hdr(struct qib_ibport *ibp, struct qib_ib_header *hdr,
+int qib_ruc_check_hdr(struct qib_ibport *ibp, struct ib_header *hdr,
 		      int has_grh, struct rvt_qp *qp, u32 bth0)
 {
 	__be64 guid;
@@ -680,7 +680,7 @@ u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 	return sizeof(struct ib_grh) / sizeof(u32);
 }
 
-void qib_make_ruc_header(struct rvt_qp *qp, struct qib_other_headers *ohdr,
+void qib_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 			 u32 bth0, u32 bth2)
 {
 	struct qib_qp_priv *priv = qp->priv;
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 1d61bd0..5b2d483 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -48,7 +48,7 @@
 int qib_make_uc_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
 	u32 hwords;
 	u32 bth0;
@@ -236,10 +236,10 @@ bail:
  * for the given QP.
  * Called at interrupt level.
  */
-void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
+void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	u32 opcode;
 	u32 hdrsize;
 	u32 psn;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 10d0625..f45cad1 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -245,7 +245,7 @@ drop:
 int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct ib_ah_attr *ah_attr;
 	struct qib_pportdata *ppd;
 	struct qib_ibport *ibp;
@@ -435,10 +435,10 @@ static unsigned qib_lookup_pkey(struct qib_ibport *ibp, u16 pkey)
  * for the given QP.
  * Called at interrupt level.
  */
-void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
+void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	int opcode;
 	u32 hdrsize;
 	u32 pad;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index fd1dfbc..c12ec8f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -313,7 +313,7 @@ static void qib_copy_from_sge(void *data, struct rvt_sge_state *ss, u32 length)
  * for the given QP.
  * Called at interrupt level.
  */
-static void qib_qp_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
+static void qib_qp_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		       int has_grh, void *data, u32 tlen, struct rvt_qp *qp)
 {
 	struct qib_ibport *ibp = &rcd->ppd->ibport_data;
@@ -366,10 +366,10 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 {
 	struct qib_pportdata *ppd = rcd->ppd;
 	struct qib_ibport *ibp = &ppd->ibport_data;
-	struct qib_ib_header *hdr = rhdr;
+	struct ib_header *hdr = rhdr;
 	struct qib_devdata *dd = ppd->dd;
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
-	struct qib_other_headers *ohdr;
+	struct ib_other_headers *ohdr;
 	struct rvt_qp *qp;
 	u32 qp_num;
 	int lnh;
@@ -841,7 +841,7 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 	if (tx->wqe)
 		qib_send_complete(qp, tx->wqe, IB_WC_SUCCESS);
 	else if (qp->ibqp.qp_type == IB_QPT_RC) {
-		struct qib_ib_header *hdr;
+		struct ib_header *hdr;
 
 		if (tx->txreq.flags & QIB_SDMA_TXREQ_F_FREEBUF)
 			hdr = &tx->align_buf->hdr;
@@ -889,7 +889,7 @@ static int wait_kmem(struct qib_ibdev *dev, struct rvt_qp *qp)
 	return ret;
 }
 
-static int qib_verbs_send_dma(struct rvt_qp *qp, struct qib_ib_header *hdr,
+static int qib_verbs_send_dma(struct rvt_qp *qp, struct ib_header *hdr,
 			      u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			      u32 plen, u32 dwords)
 {
@@ -1025,7 +1025,7 @@ static int no_bufs_available(struct rvt_qp *qp)
 	return ret;
 }
 
-static int qib_verbs_send_pio(struct rvt_qp *qp, struct qib_ib_header *ibhdr,
+static int qib_verbs_send_pio(struct rvt_qp *qp, struct ib_header *ibhdr,
 			      u32 hdrwords, struct rvt_sge_state *ss, u32 len,
 			      u32 plen, u32 dwords)
 {
@@ -1133,7 +1133,7 @@ done:
  * Return zero if packet is sent or queued OK.
  * Return non-zero and clear qp->s_flags RVT_S_BUSY otherwise.
  */
-int qib_verbs_send(struct rvt_qp *qp, struct qib_ib_header *hdr,
+int qib_verbs_send(struct rvt_qp *qp, struct ib_header *hdr,
 		   u32 hdrwords, struct rvt_sge_state *ss, u32 len)
 {
 	struct qib_devdata *dd = dd_from_ibdev(qp->ibqp.device);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 736ced6..94fd30f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -45,6 +45,7 @@
 #include <linux/completion.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_hdrs.h>
 #include <rdma/rdma_vt.h>
 #include <rdma/rdmavt_cq.h>
 
@@ -63,16 +64,6 @@ struct qib_verbs_txreq;
  */
 #define QIB_UVERBS_ABI_VERSION       2
 
-#define IB_SEQ_NAK	(3 << 29)
-
-/* AETH NAK opcode values */
-#define IB_RNR_NAK                      0x20
-#define IB_NAK_PSN_ERROR                0x60
-#define IB_NAK_INVALID_REQUEST          0x61
-#define IB_NAK_REMOTE_ACCESS_ERROR      0x62
-#define IB_NAK_REMOTE_OPERATIONAL_ERROR 0x63
-#define IB_NAK_INVALID_RD_REQUEST       0x64
-
 /* IB Performance Manager status values */
 #define IB_PMA_SAMPLE_STATUS_DONE       0x00
 #define IB_PMA_SAMPLE_STATUS_STARTED    0x01
@@ -87,22 +78,9 @@ struct qib_verbs_txreq;
 
 #define QIB_VENDOR_IPG		cpu_to_be16(0xFFA0)
 
-#define IB_BTH_REQ_ACK		(1 << 31)
-#define IB_BTH_SOLICITED	(1 << 23)
-#define IB_BTH_MIG_REQ		(1 << 22)
-
 /* XXX Should be defined in ib_verbs.h enum ib_port_cap_flags */
 #define IB_PORT_OTHER_LOCAL_CHANGES_SUP (1 << 26)
 
-#define IB_GRH_VERSION		6
-#define IB_GRH_VERSION_MASK	0xF
-#define IB_GRH_VERSION_SHIFT	28
-#define IB_GRH_TCLASS_MASK	0xFF
-#define IB_GRH_TCLASS_SHIFT	20
-#define IB_GRH_FLOW_MASK	0xFFFFF
-#define IB_GRH_FLOW_SHIFT	0
-#define IB_GRH_NEXT_HDR		0x1B
-
 #define IB_DEFAULT_GID_PREFIX	cpu_to_be64(0xfe80000000000000ULL)
 
 /* Values for set/get portinfo VLCap OperationalVLs */
@@ -129,61 +107,9 @@ static inline int qib_num_vls(int vls)
 	}
 }
 
-struct ib_reth {
-	__be64 vaddr;
-	__be32 rkey;
-	__be32 length;
-} __packed;
-
-struct ib_atomic_eth {
-	__be32 vaddr[2];        /* unaligned so access as 2 32-bit words */
-	__be32 rkey;
-	__be64 swap_data;
-	__be64 compare_data;
-} __packed;
-
-struct qib_other_headers {
-	__be32 bth[3];
-	union {
-		struct {
-			__be32 deth[2];
-			__be32 imm_data;
-		} ud;
-		struct {
-			struct ib_reth reth;
-			__be32 imm_data;
-		} rc;
-		struct {
-			__be32 aeth;
-			__be32 atomic_ack_eth[2];
-		} at;
-		__be32 imm_data;
-		__be32 aeth;
-		__be32 ieth;
-		struct ib_atomic_eth atomic_eth;
-	} u;
-} __packed;
-
-/*
- * Note that UD packets with a GRH header are 8+40+12+8 = 68 bytes
- * long (72 w/ imm_data).  Only the first 56 bytes of the IB header
- * will be in the eager header buffer.  The remaining 12 or 16 bytes
- * are in the data buffer.
- */
-struct qib_ib_header {
-	__be16 lrh[4];
-	union {
-		struct {
-			struct ib_grh grh;
-			struct qib_other_headers oth;
-		} l;
-		struct qib_other_headers oth;
-	} u;
-} __packed;
-
 struct qib_pio_header {
 	__le32 pbc[2];
-	struct qib_ib_header hdr;
+	struct ib_header hdr;
 } __packed;
 
 /*
@@ -191,7 +117,7 @@ struct qib_pio_header {
  * is made common.
  */
 struct qib_qp_priv {
-	struct qib_ib_header *s_hdr;    /* next packet header to send */
+	struct ib_header *s_hdr;        /* next packet header to send */
 	struct list_head iowait;        /* link for wait PIO buf */
 	atomic_t s_dma_busy;
 	struct qib_verbs_txreq *s_tx;
@@ -376,7 +302,7 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail);
 
 void qib_put_txreq(struct qib_verbs_txreq *tx);
 
-int qib_verbs_send(struct rvt_qp *qp, struct qib_ib_header *hdr,
+int qib_verbs_send(struct rvt_qp *qp, struct ib_header *hdr,
 		   u32 hdrwords, struct rvt_sge_state *ss, u32 len);
 
 void qib_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
@@ -384,10 +310,10 @@ void qib_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
 
 void qib_skip_sge(struct rvt_sge_state *ss, u32 length, int release);
 
-void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
+void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
-void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
+void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
@@ -398,13 +324,13 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid);
 
 void qib_rc_rnr_retry(unsigned long arg);
 
-void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr);
+void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr);
 
 void qib_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
 
 int qib_post_ud_send(struct rvt_qp *qp, struct ib_send_wr *wr);
 
-void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
+void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
 void mr_rcu_callback(struct rcu_head *list);
@@ -413,13 +339,13 @@ int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only);
 
 void qib_migrate_qp(struct rvt_qp *qp);
 
-int qib_ruc_check_hdr(struct qib_ibport *ibp, struct qib_ib_header *hdr,
+int qib_ruc_check_hdr(struct qib_ibport *ibp, struct ib_header *hdr,
 		      int has_grh, struct rvt_qp *qp, u32 bth0);
 
 u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 		 struct ib_global_route *grh, u32 hwords, u32 nwords);
 
-void qib_make_ruc_header(struct rvt_qp *qp, struct qib_other_headers *ohdr,
+void qib_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 			 u32 bth0, u32 bth2);
 
 void _qib_do_send(struct work_struct *work);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
