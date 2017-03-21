From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 17/20] IB/hfi1: Add transmit fault injection feature
Date: Mon, 20 Mar 2017 17:26:20 -0700
Message-ID: <20170321002619.28538.31428.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add ability to fault packets on transmit by opcode.
Dropping by packet can be achieved by setting the mask to 0.

In order to drop non-verbs traffic we set PbcInsertHrc
to NONE (0x2). The packet will still be delivered to
the receiving node but a KHdrHCRCErr (KDETH packet
with a bad HCRC) will be triggered and the packet will
not be delivered to the correct context.

In order to drop regular verbs traffic we set the
PbcTestEbp flag. The packet will still be delivered
to the receiving node but a 'late ebp error' will
be triggered and will be dropped.

A global toggle (/sys/kernel/debug/hfi1/hfi1_X/fault_suppress_err)
has been added to suppress the error messages on the receive
node when a packet was faulted on the sending node.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c    |    4 +++
 drivers/infiniband/hw/hfi1/debugfs.c |    8 ++++++
 drivers/infiniband/hw/hfi1/debugfs.h |   11 ++++++++
 drivers/infiniband/hw/hfi1/driver.c  |   11 ++++++++
 drivers/infiniband/hw/hfi1/verbs.c   |   49 +++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/hfi1/verbs.h   |    1 +
 include/rdma/ib_pack.h               |    2 +
 7 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 77f4b41..79a316a 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -64,6 +64,7 @@
 #include "platform.h"
 #include "aspm.h"
 #include "affinity.h"
+#include "debugfs.h"
 
 #define NUM_IB_PORTS 1
 
@@ -7898,6 +7899,9 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		reg &= ~DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_HOST_SMASK;
 	}
 
+	if (unlikely(hfi1_dbg_fault_suppress_err(&dd->verbs_dev)))
+		reg &= ~DCC_ERR_FLG_LATE_EBP_ERR_SMASK;
+
 	/* report any remaining errors */
 	if (reg)
 		dd_dev_info_ratelimited(dd, "DCC Error: %s\n",
diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index cac6d52..dc2c1c9 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -1240,6 +1240,11 @@ static int fault_init_debugfs(struct hfi1_ibdev *ibd)
 	return ret;
 }
 
+bool hfi1_dbg_fault_suppress_err(struct hfi1_ibdev *ibd)
+{
+	return ibd->fault_suppress_err;
+}
+
 bool hfi1_dbg_fault_opcode(struct rvt_qp *qp, u32 opcode, bool rx)
 {
 	bool ret = false;
@@ -1329,6 +1334,9 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 		}
 
 #ifdef CONFIG_FAULT_INJECTION
+	debugfs_create_bool("fault_suppress_err", 0600,
+			    ibd->hfi1_ibdev_dbg,
+			    &ibd->fault_suppress_err);
 	fault_init_debugfs(ibd);
 #endif
 }
diff --git a/drivers/infiniband/hw/hfi1/debugfs.h b/drivers/infiniband/hw/hfi1/debugfs.h
index 70be5ca..38c38a9 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.h
+++ b/drivers/infiniband/hw/hfi1/debugfs.h
@@ -75,6 +75,7 @@ struct fault_packet {
 
 bool hfi1_dbg_fault_opcode(struct rvt_qp *qp, u32 opcode, bool rx);
 bool hfi1_dbg_fault_packet(struct hfi1_packet *packet);
+bool hfi1_dbg_fault_suppress_err(struct hfi1_ibdev *ibd);
 #else
 static inline bool hfi1_dbg_fault_packet(struct hfi1_packet *packet)
 {
@@ -86,6 +87,11 @@ static inline bool hfi1_dbg_fault_opcode(struct rvt_qp *qp,
 {
 	return false;
 }
+
+static inline bool hfi1_dbg_fault_suppress_err(struct hfi1_ibdev *ibd)
+{
+	return false;
+}
 #endif
 
 #else
@@ -115,6 +121,11 @@ static inline bool hfi1_dbg_fault_opcode(struct rvt_qp *qp,
 {
 	return false;
 }
+
+static inline bool hfi1_dbg_fault_suppress_err(struct hfi1_ibdev *ibd)
+{
+	return false;
+}
 #endif
 
 #endif                          /* _HFI1_DEBUGFS_H */
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index c0b012f..64bdbce 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1367,6 +1367,11 @@ int process_receive_ib(struct hfi1_packet *packet)
 			  packet->updegr,
 			  rhf_egr_index(packet->rhf));
 
+	if (unlikely(
+		 (hfi1_dbg_fault_suppress_err(&packet->rcd->dd->verbs_dev) &&
+		 (packet->rhf & RHF_DC_ERR))))
+		return RHF_RCV_CONTINUE;
+
 	if (unlikely(rhf_err_flags(packet->rhf))) {
 		handle_eflags(packet);
 		return RHF_RCV_CONTINUE;
@@ -1402,6 +1407,12 @@ int process_receive_bypass(struct hfi1_packet *packet)
 
 int process_receive_error(struct hfi1_packet *packet)
 {
+	/* KHdrHCRCErr -- KDETH packet with a bad HCRC */
+	if (unlikely(
+		 hfi1_dbg_fault_suppress_err(&packet->rcd->dd->verbs_dev) &&
+		 rhf_rcv_type_err(packet->rhf) == 3))
+		return RHF_RCV_CONTINUE;
+
 	handle_eflags(packet);
 
 	if (unlikely(rhf_err_flags(packet->rhf)))
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 9f016da..5e7e577 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -518,6 +518,35 @@ static inline opcode_handler qp_ok(int opcode, struct hfi1_packet *packet)
 	return NULL;
 }
 
+static u64 hfi1_fault_tx(struct rvt_qp *qp, u8 opcode, u64 pbc)
+{
+#ifdef CONFIG_HFI1_FAULT_INJECTION
+	if ((opcode & IB_OPCODE_MSP) == IB_OPCODE_MSP)
+		/*
+		 * In order to drop non-IB traffic we
+		 * set PbcInsertHrc to NONE (0x2).
+		 * The packet will still be delivered
+		 * to the receiving node but a
+		 * KHdrHCRCErr (KDETH packet with a bad
+		 * HCRC) will be triggered and the
+		 * packet will not be delivered to the
+		 * correct context.
+		 */
+		pbc |= (u64)PBC_IHCRC_NONE << PBC_INSERT_HCRC_SHIFT;
+	else
+		/*
+		 * In order to drop regular verbs
+		 * traffic we set the PbcTestEbp
+		 * flag. The packet will still be
+		 * delivered to the receiving node but
+		 * a 'late ebp error' will be
+		 * triggered and will be dropped.
+		 */
+		pbc |= PBC_TEST_EBP;
+#endif
+	return pbc;
+}
+
 /**
  * hfi1_ib_rcv - process an incoming packet
  * @packet: data packet information
@@ -803,7 +832,6 @@ static int build_verbs_tx_desc(
 		if (ret)
 			goto bail_txadd;
 	}
-
 	/* add the ulp payload - if any. tx->ss can be NULL for acks */
 	if (tx->ss)
 		ret = build_verbs_ulp_payload(sde, length, tx);
@@ -822,7 +850,6 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct hfi1_ibdev *dev = ps->dev;
 	struct hfi1_pportdata *ppd = ps->ppd;
 	struct verbs_txreq *tx;
-	u64 pbc_flags = 0;
 	u8 sc5 = priv->s_sc;
 
 	int ret;
@@ -831,12 +858,16 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	if (!sdma_txreq_built(&tx->txreq)) {
 		if (likely(pbc == 0)) {
 			u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
+			u8 opcode = get_opcode(&tx->phdr.hdr);
+
 			/* No vl15 here */
 			/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
-			pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
+			pbc |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
 
+			if (unlikely(hfi1_dbg_fault_opcode(qp, opcode, false)))
+				pbc = hfi1_fault_tx(qp, opcode, pbc);
 			pbc = create_pbc(ppd,
-					 pbc_flags,
+					 pbc,
 					 qp->srate_mbps,
 					 vl,
 					 plen);
@@ -939,7 +970,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	u32 plen = hdrwords + dwords + 2; /* includes pbc */
 	struct hfi1_pportdata *ppd = ps->ppd;
 	u32 *hdr = (u32 *)&ps->s_txreq->phdr.hdr;
-	u64 pbc_flags = 0;
 	u8 sc5;
 	unsigned long flags = 0;
 	struct send_context *sc;
@@ -964,9 +994,14 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 
 	if (likely(pbc == 0)) {
 		u8 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
+		struct verbs_txreq *tx = ps->s_txreq;
+		u8 opcode = get_opcode(&tx->phdr.hdr);
+
 		/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
-		pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
-		pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
+		pbc |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
+		if (unlikely(hfi1_dbg_fault_opcode(qp, opcode, false)))
+			pbc = hfi1_fault_tx(qp, opcode, pbc);
+		pbc = create_pbc(ppd, pbc, qp->srate_mbps, vl, plen);
 	}
 	if (cb)
 		iowait_pio_inc(&priv->s_iowait);
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 2756ec3..6c549e7 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -198,6 +198,7 @@ struct hfi1_ibdev {
 #ifdef CONFIG_FAULT_INJECTION
 	struct fault_opcode *fault_opcode;
 	struct fault_packet *fault_packet;
+	bool fault_suppress_err;
 #endif
 #endif
 };
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index b13419c..3665589 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -80,6 +80,8 @@ enum {
 	IB_OPCODE_UD                                = 0x60,
 	/* per IBTA 1.3 vol 1 Table 38, A10.3.2 */
 	IB_OPCODE_CNP                               = 0x80,
+	/* Manufacturer specific */
+	IB_OPCODE_MSP                               = 0xe0,
 
 	/* operations -- just used to define real constants */
 	IB_OPCODE_SEND_FIRST                        = 0x00,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
