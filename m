From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/hfi1: Remove unnecessary fecn and becn
 fields
Date: Thu, 01 Feb 2018 10:46:38 -0800
Message-ID: <20180201184636.5918.85341.stgit@scvm10.sc.intel.com>
References: <20180201184446.5918.46068.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201184446.5918.46068.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

packet->fecn and packet->becn are calculated in the hot path
and are never used. Remove these fields as they show to be
costly in a profile. Also, remove initialization for
becn and fecn in process_ecn() as they're unconditionally
assigned in the function and ensure fecn and becn variables
use a boolean type.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c       |    4 ----
 drivers/infiniband/hw/hfi1/hfi.h          |   16 +++++-----------
 drivers/infiniband/hw/hfi1/rc.c           |    2 +-
 drivers/infiniband/hw/hfi1/ruc.c          |    4 ++--
 drivers/infiniband/hw/hfi1/trace.c        |    8 ++++----
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   16 ++++++++--------
 include/rdma/ib_hdrs.h                    |   10 ++++------
 7 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 0de4654..0a9bc18 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1440,8 +1440,6 @@ static int hfi1_setup_9B_packet(struct hfi1_packet *packet)
 	packet->sc = hfi1_9B_get_sc5(hdr, packet->rhf);
 	packet->pad = ib_bth_get_pad(packet->ohdr);
 	packet->extra_byte = 0;
-	packet->fecn = ib_bth_get_fecn(packet->ohdr);
-	packet->becn = ib_bth_get_becn(packet->ohdr);
 	packet->pkey = ib_bth_get_pkey(packet->ohdr);
 	packet->migrated = ib_bth_is_migration(packet->ohdr);
 
@@ -1508,8 +1506,6 @@ static int hfi1_setup_bypass_packet(struct hfi1_packet *packet)
 	packet->sl = ibp->sc_to_sl[packet->sc];
 	packet->pad = hfi1_16B_bth_get_pad(packet->ohdr);
 	packet->extra_byte = SIZE_OF_LT;
-	packet->fecn = hfi1_16B_get_fecn(packet->hdr);
-	packet->becn = hfi1_16B_get_becn(packet->hdr);
 	packet->pkey = hfi1_16B_get_pkey(packet->hdr);
 	packet->migrated = opa_bth_is_migration(packet->ohdr);
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2c257ac..105d11d 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -352,8 +352,6 @@ struct hfi1_packet {
 	u8 sc;
 	u8 sl;
 	u8 opcode;
-	bool becn;
-	bool fecn;
 	bool migrated;
 };
 
@@ -1781,19 +1779,15 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
 			       bool do_cnp)
 {
-	struct ib_other_headers *ohdr = pkt->ohdr;
-
-	u32 bth1;
-	bool becn = false;
-	bool fecn = false;
+	bool becn;
+	bool fecn;
 
 	if (pkt->etype == RHF_RCV_TYPE_BYPASS) {
 		fecn = hfi1_16B_get_fecn(pkt->hdr);
 		becn = hfi1_16B_get_becn(pkt->hdr);
 	} else {
-		bth1 = be32_to_cpu(ohdr->bth[1]);
-		fecn = bth1 & IB_FECN_SMASK;
-		becn = bth1 & IB_BECN_SMASK;
+		fecn = ib_bth_get_fecn(pkt->ohdr);
+		becn = ib_bth_get_becn(pkt->ohdr);
 	}
 	if (unlikely(fecn || becn)) {
 		hfi1_process_ecn_slowpath(qp, pkt, do_cnp);
@@ -2419,7 +2413,7 @@ static inline void hfi1_make_ib_hdr(struct ib_header *hdr,
 static inline void hfi1_make_16b_hdr(struct hfi1_16b_header *hdr,
 				     u32 slid, u32 dlid,
 				     u16 len, u16 pkey,
-				     u8 becn, u8 fecn, u8 l4,
+				     bool becn, bool fecn, u8 l4,
 				     u8 sc)
 {
 	u32 lrh0 = 0;
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index daf50cc..93ea03c 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -814,7 +814,7 @@ static inline void hfi1_make_rc_ack_16B(struct hfi1_packet *packet,
 	struct ib_other_headers *ohdr;
 	u32 bth0, bth1 = 0;
 	u16 len, pkey;
-	u8 becn = !!is_fecn;
+	bool becn = is_fecn;
 	u8 l4 = OPA_16B_L4_IB_LOCAL;
 	u8 extra_bytes;
 
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 6434207..4252722 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -751,7 +751,7 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 				ps->s_txreq->s_cur_size);
 	u32 nwords = SIZE_OF_CRC + ((ps->s_txreq->s_cur_size +
 				 extra_bytes + SIZE_OF_LT) >> 2);
-	u8 becn = 0;
+	bool becn = false;
 
 	if (unlikely(rdma_ah_get_ah_flags(&qp->remote_ah_attr) & IB_AH_GRH) &&
 	    hfi1_check_mcast(rdma_ah_get_dlid(&qp->remote_ah_attr))) {
@@ -789,7 +789,7 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 	if (qp->s_flags & RVT_S_ECN) {
 		qp->s_flags &= ~RVT_S_ECN;
 		/* we recently received a FECN, so return a BECN */
-		becn = 1;
+		becn = true;
 	}
 	hfi1_make_ruc_bth(qp, ohdr, bth0, bth1, bth2);
 
diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 959a804..89bd985 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -138,7 +138,7 @@ u8 hfi1_trace_opa_hdr_len(struct hfi1_opa_header *opa_hdr)
 }
 
 void hfi1_trace_parse_9b_bth(struct ib_other_headers *ohdr,
-			     u8 *ack, u8 *becn, u8 *fecn, u8 *mig,
+			     u8 *ack, bool *becn, bool *fecn, u8 *mig,
 			     u8 *se, u8 *pad, u8 *opcode, u8 *tver,
 			     u16 *pkey, u32 *psn, u32 *qpn)
 {
@@ -184,7 +184,7 @@ void hfi1_trace_parse_9b_hdr(struct ib_header *hdr, bool sc5,
 }
 
 void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
-			      u8 *age, u8 *becn, u8 *fecn,
+			      u8 *age, bool *becn, bool *fecn,
 			      u8 *l4, u8 *rc, u8 *sc,
 			      u16 *entropy, u16 *len, u16 *pkey,
 			      u32 *dlid, u32 *slid)
@@ -207,7 +207,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 #define LRH_16B_PRN "age:%d becn:%d fecn:%d l4:%d " \
 		    "rc:%d sc:%d pkey:0x%.4x entropy:0x%.4x"
 const char *hfi1_trace_fmt_lrh(struct trace_seq *p, bool bypass,
-			       u8 age, u8 becn, u8 fecn, u8 l4,
+			       u8 age, bool becn, bool fecn, u8 l4,
 			       u8 lnh, const char *lnh_name, u8 lver,
 			       u8 rc, u8 sc, u8 sl, u16 entropy,
 			       u16 len, u16 pkey, u32 dlid, u32 slid)
@@ -235,7 +235,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 	"op:0x%.2x,%s se:%d m:%d pad:%d tver:%d " \
 	"qpn:0x%.6x a:%d psn:0x%.8x"
 const char *hfi1_trace_fmt_bth(struct trace_seq *p, bool bypass,
-			       u8 ack, u8 becn, u8 fecn, u8 mig,
+			       u8 ack, bool becn, bool fecn, u8 mig,
 			       u8 se, u8 pad, u8 opcode, const char *opname,
 			       u8 tver, u16 pkey, u32 psn, u32 qpn)
 {
diff --git a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
index fb63127..2847626 100644
--- a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
+++ b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
@@ -101,7 +101,7 @@
 u8 hfi1_trace_packet_hdr_len(struct hfi1_packet *packet);
 const char *hfi1_trace_get_packet_l4_str(u8 l4);
 void hfi1_trace_parse_9b_bth(struct ib_other_headers *ohdr,
-			     u8 *ack, u8 *becn, u8 *fecn, u8 *mig,
+			     u8 *ack, bool *becn, bool *fecn, u8 *mig,
 			     u8 *se, u8 *pad, u8 *opcode, u8 *tver,
 			     u16 *pkey, u32 *psn, u32 *qpn);
 void hfi1_trace_parse_9b_hdr(struct ib_header *hdr, bool sc5,
@@ -112,19 +112,19 @@ void hfi1_trace_parse_16b_bth(struct ib_other_headers *ohdr,
 			      u8 *pad, u8 *se, u8 *tver,
 			      u32 *psn, u32 *qpn);
 void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
-			      u8 *age, u8 *becn, u8 *fecn,
+			      u8 *age, bool *becn, bool *fecn,
 			      u8 *l4, u8 *rc, u8 *sc,
 			      u16 *entropy, u16 *len, u16 *pkey,
 			      u32 *dlid, u32 *slid);
 
 const char *hfi1_trace_fmt_lrh(struct trace_seq *p, bool bypass,
-			       u8 age, u8 becn, u8 fecn, u8 l4,
+			       u8 age, bool becn, bool fecn, u8 l4,
 			       u8 lnh, const char *lnh_name, u8 lver,
 			       u8 rc, u8 sc, u8 sl, u16 entropy,
 			       u16 len, u16 pkey, u32 dlid, u32 slid);
 
 const char *hfi1_trace_fmt_bth(struct trace_seq *p, bool bypass,
-			       u8 ack, u8 becn, u8 fecn, u8 mig,
+			       u8 ack, bool becn, bool fecn, u8 mig,
 			       u8 se, u8 pad, u8 opcode, const char *opname,
 			       u8 tver, u16 pkey, u32 psn, u32 qpn);
 
@@ -148,8 +148,8 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 			__field(u8, etype)
 			__field(u8, ack)
 			__field(u8, age)
-			__field(u8, becn)
-			__field(u8, fecn)
+			__field(bool, becn)
+			__field(bool, fecn)
 			__field(u8, l2)
 			__field(u8, l4)
 			__field(u8, lnh)
@@ -290,8 +290,8 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 			__field(u8, hdr_type)
 			__field(u8, ack)
 			__field(u8, age)
-			__field(u8, becn)
-			__field(u8, fecn)
+			__field(bool, becn)
+			__field(bool, fecn)
 			__field(u8, l4)
 			__field(u8, lnh)
 			__field(u8, lver)
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 2aa19ec..710c8be 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -313,16 +313,14 @@ static inline u32 ib_bth_get_qpn(struct ib_other_headers *ohdr)
 	return (u32)((be32_to_cpu(ohdr->bth[1])) & IB_QPN_MASK);
 }
 
-static inline u8 ib_bth_get_becn(struct ib_other_headers *ohdr)
+static inline bool ib_bth_get_becn(struct ib_other_headers *ohdr)
 {
-	return (u8)((be32_to_cpu(ohdr->bth[1]) >> IB_BECN_SHIFT) &
-		     IB_BECN_MASK);
+	return !!((ohdr->bth[1]) & cpu_to_be32(IB_BECN_SMASK));
 }
 
-static inline u8 ib_bth_get_fecn(struct ib_other_headers *ohdr)
+static inline bool ib_bth_get_fecn(struct ib_other_headers *ohdr)
 {
-	return (u8)((be32_to_cpu(ohdr->bth[1]) >> IB_FECN_SHIFT) &
-		    IB_FECN_MASK);
+	return !!((ohdr->bth[1]) & cpu_to_be32(IB_FECN_SMASK));
 }
 
 static inline u8 ib_bth_get_tver(struct ib_other_headers *ohdr)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
