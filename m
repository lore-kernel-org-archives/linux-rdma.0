From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/16] IB/hfi1: Remove blind constants from 16B
 update
Date: Fri, 26 Jan 2018 06:31:51 -0800
Message-ID: <20180126143148.6868.7572.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These values were introduced as part of the 16B code to
account for the varying size of the LRH between the differing
packet formats.

Replace the blind constants with defines based on FIELD_SIZEOF()
calls.

Fixes: 5b6cabb0db77 ("IB/hfi1: Add 16B RC/UC support")
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    6 ++++--
 drivers/infiniband/hw/hfi1/ruc.c    |   13 ++++++-------
 drivers/infiniband/hw/hfi1/ud.c     |   15 ++++++++++-----
 drivers/infiniband/hw/hfi1/verbs.h  |    5 +++++
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 067b29f..e6a318c 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1492,8 +1492,10 @@ static int hfi1_setup_bypass_packet(struct hfi1_packet *packet)
 
 	/* Query commonly used fields from packet header */
 	packet->opcode = ib_bth_get_opcode(packet->ohdr);
-	packet->hlen = hdr_len_by_opcode[packet->opcode] + 8 + grh_len;
-	packet->payload = packet->ebuf + packet->hlen - (4 * sizeof(u32));
+	/* hdr_len_by_opcode already has an IB LRH factored in */
+	packet->hlen = hdr_len_by_opcode[packet->opcode] +
+		(LRH_16B_BYTES - LRH_9B_BYTES) + grh_len;
+	packet->payload = packet->ebuf + packet->hlen - LRH_16B_BYTES;
 	packet->slid = hfi1_16B_get_slid(packet->hdr);
 	packet->dlid = hfi1_16B_get_dlid(packet->hdr);
 	if (unlikely(hfi1_is_16B_mcast(packet->dlid)))
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 0cced9a..1033068 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -769,8 +769,6 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 		struct ib_grh *grh;
 		struct ib_global_route *grd =
 			rdma_ah_retrieve_grh(&qp->remote_ah_attr);
-		int hdrwords;
-
 		/*
 		 * Ensure OPA GIDs are transformed to IB gids
 		 * before creating the GRH.
@@ -779,9 +777,10 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 			grd->sgid_index = 0;
 		grh = &ps->s_txreq->phdr.hdr.opah.u.l.grh;
 		l4 = OPA_16B_L4_IB_GLOBAL;
-		hdrwords = ps->s_txreq->hdr_dwords - 4;
-		ps->s_txreq->hdr_dwords += hfi1_make_grh(ibp, grh, grd,
-							 hdrwords, nwords);
+		ps->s_txreq->hdr_dwords +=
+			hfi1_make_grh(ibp, grh, grd,
+				      ps->s_txreq->hdr_dwords - LRH_16B_DWORDS,
+				      nwords);
 		middle = 0;
 	}
 
@@ -835,13 +834,13 @@ static inline void hfi1_make_ruc_header_9B(struct rvt_qp *qp,
 
 	if (unlikely(rdma_ah_get_ah_flags(&qp->remote_ah_attr) & IB_AH_GRH)) {
 		struct ib_grh *grh = &ps->s_txreq->phdr.hdr.ibh.u.l.grh;
-		int hdrwords = ps->s_txreq->hdr_dwords - 2;
 
 		lrh0 = HFI1_LRH_GRH;
 		ps->s_txreq->hdr_dwords +=
 			hfi1_make_grh(ibp, grh,
 				      rdma_ah_read_grh(&qp->remote_ah_attr),
-				      hdrwords, nwords);
+				      ps->s_txreq->hdr_dwords - LRH_9B_DWORDS,
+				      nwords);
 		middle = 0;
 	}
 	lrh0 |= (priv->s_sc & 0xf) << 12 |
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 6b5cd3a..f1ba510 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -348,7 +348,8 @@ void hfi1_make_ud_req_9B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		grh = &ps->s_txreq->phdr.hdr.ibh.u.l.grh;
 		ps->s_txreq->hdr_dwords +=
 			hfi1_make_grh(ibp, grh, rdma_ah_read_grh(ah_attr),
-				      ps->s_txreq->hdr_dwords - 2, nwords);
+				      ps->s_txreq->hdr_dwords - LRH_9B_DWORDS,
+				      nwords);
 		lrh0 = HFI1_LRH_GRH;
 		ohdr = &ps->s_txreq->phdr.hdr.ibh.u.l.oth;
 	} else {
@@ -428,8 +429,10 @@ void hfi1_make_ud_req_16B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			grd->sgid_index = 0;
 		}
 		grh = &ps->s_txreq->phdr.hdr.opah.u.l.grh;
-		ps->s_txreq->hdr_dwords += hfi1_make_grh(ibp, grh, grd,
-					ps->s_txreq->hdr_dwords - 4, nwords);
+		ps->s_txreq->hdr_dwords += hfi1_make_grh(
+			ibp, grh, grd,
+			ps->s_txreq->hdr_dwords - LRH_16B_DWORDS,
+			nwords);
 		ohdr = &ps->s_txreq->phdr.hdr.opah.u.l.oth;
 		l4 = OPA_16B_L4_IB_GLOBAL;
 	} else {
@@ -648,7 +651,8 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 		struct ib_grh *grh = &hdr.u.l.grh;
 
 		grh->version_tclass_flow = old_grh->version_tclass_flow;
-		grh->paylen = cpu_to_be16((hwords - 4 + nwords) << 2);
+		grh->paylen = cpu_to_be16(
+			(hwords - LRH_16B_DWORDS + nwords) << 2);
 		grh->hop_limit = 0xff;
 		grh->sgid = old_grh->dgid;
 		grh->dgid = old_grh->sgid;
@@ -702,7 +706,8 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 		struct ib_grh *grh = &hdr.u.l.grh;
 
 		grh->version_tclass_flow = old_grh->version_tclass_flow;
-		grh->paylen = cpu_to_be16((hwords - 2 + SIZE_OF_CRC) << 2);
+		grh->paylen = cpu_to_be16(
+			(hwords - LRH_9B_DWORDS + SIZE_OF_CRC) << 2);
 		grh->hop_limit = 0xff;
 		grh->sgid = old_grh->dgid;
 		grh->dgid = old_grh->sgid;
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index c2aeb32..26c1ed6 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -105,6 +105,11 @@ enum {
 	HFI1_HAS_GRH = (1 << 0),
 };
 
+#define LRH_16B_BYTES (FIELD_SIZEOF(struct hfi1_16b_header, lrh))
+#define LRH_16B_DWORDS (LRH_16B_BYTES / sizeof(u32))
+#define LRH_9B_BYTES (FIELD_SIZEOF(struct ib_header, lrh))
+#define LRH_9B_DWORDS (LRH_9B_BYTES / sizeof(u32))
+
 struct hfi1_16b_header {
 	u32 lrh[4];
 	union {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
