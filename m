From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/27] IB/hfi1: Access hfi1_ibport through rcd pointer
Date: Wed, 08 Feb 2017 05:26:25 -0800
Message-ID: <20170208132625.16442.9.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Receive code paths use the QP's device and port
number to access the struct hfi1_ibport. When an
instance of struct hfi1_ctxtdata is present, it can
be used to access struct hfi1_ibport through a pointer.
This makes struct hfi1_ibport lookup time faster as an
array doesn't have to be indexed and access fields in
other cache-lines.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    4 ++--
 drivers/infiniband/hw/hfi1/hfi.h    |    5 +++++
 drivers/infiniband/hw/hfi1/rc.c     |   10 +++++-----
 drivers/infiniband/hw/hfi1/uc.c     |    2 +-
 drivers/infiniband/hw/hfi1/ud.c     |    2 +-
 drivers/infiniband/hw/hfi1/verbs.c  |    4 ++--
 6 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 29db673..3881c95 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -284,7 +284,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 	struct ib_header *rhdr = packet->hdr;
 	u32 rte = rhf_rcv_type_err(packet->rhf);
 	int lnh = be16_to_cpu(rhdr->lrh[0]) & 3;
-	struct hfi1_ibport *ibp = &ppd->ibport_data;
+	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct hfi1_devdata *dd = ppd->dd;
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 
@@ -599,7 +599,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 
 	while (1) {
 		struct hfi1_devdata *dd = rcd->dd;
-		struct hfi1_ibport *ibp = &rcd->ppd->ibport_data;
+		struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 		__le32 *rhf_addr = (__le32 *)rcd->rcvhdrq + mdata.ps_head +
 					 dd->rhf_offset;
 		struct rvt_qp *qp;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 751a0fb..1d08739 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1584,6 +1584,11 @@ static inline int valid_opa_max_mtu(unsigned int mtu)
 	return &dd->pport[pidx].ibport_data;
 }
 
+static inline struct hfi1_ibport *rcd_to_iport(struct hfi1_ctxtdata *rcd)
+{
+	return &rcd->ppd->ibport_data;
+}
+
 void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 			       bool do_cnp);
 static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 6446179..abea4b7 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -841,7 +841,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 		      int is_fecn)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	u64 pbc, pbc_flags = 0;
 	u16 lrh0;
@@ -1326,7 +1326,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	if (aeth >> 29)
 		ack_psn--;
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
-	ibp = to_iport(qp->ibqp.device, qp->port_num);
+	ibp = rcd_to_iport(rcd);
 
 	/*
 	 * The MSN might be for a later WQE than the PSN indicates so
@@ -1791,7 +1791,7 @@ static noinline int rc_rcv_error(struct ib_other_headers *ohdr, void *data,
 				 struct rvt_qp *qp, u32 opcode, u32 psn,
 				 int diff, struct hfi1_ctxtdata *rcd)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct rvt_ack_entry *e;
 	unsigned long flags;
 	u8 i, prev;
@@ -2100,7 +2100,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	void *data = packet->ebuf;
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct ib_other_headers *ohdr = packet->ohdr;
 	u32 bth0, opcode;
 	u32 hdrsize = packet->hlen;
@@ -2552,7 +2552,7 @@ void hfi1_rc_hdrerr(
 {
 	int has_grh = rcv_flags & HFI1_HAS_GRH;
 	struct ib_other_headers *ohdr;
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	int diff;
 	u32 opcode;
 	u32 psn, bth0;
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index b141a78..74b7b2b 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -296,7 +296,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
  */
 void hfi1_uc_rcv(struct hfi1_packet *packet)
 {
-	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
+	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
 	struct ib_header *hdr = packet->hdr;
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index c071955..6d81d79 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -672,7 +672,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	u32 src_qp;
 	u16 dlid, pkey;
 	int mgmt_pkey_idx = -1;
-	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
+	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct ib_header *hdr = packet->hdr;
 	u32 rcv_flags = packet->rcv_flags;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 95ed4d6..b937a23 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -576,7 +576,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	struct ib_header *hdr = packet->hdr;
 	u32 tlen = packet->tlen;
 	struct hfi1_pportdata *ppd = rcd->ppd;
-	struct hfi1_ibport *ibp = &ppd->ibport_data;
+	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct rvt_dev_info *rdi = &ppd->dd->verbs_dev.rdi;
 	opcode_handler packet_handler;
 	unsigned long flags;
@@ -1910,7 +1910,7 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 
 void hfi1_cnp_rcv(struct hfi1_packet *packet)
 {
-	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
+	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct ib_header *hdr = packet->hdr;
 	struct rvt_qp *qp = packet->qp;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
