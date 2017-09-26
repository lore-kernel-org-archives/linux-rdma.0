From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/12] IB/hfi1: Extend input hdr tracing for packet
 type
Date: Tue, 26 Sep 2017 07:01:09 -0700
Message-ID: <20170926140108.15601.52603.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The etype field from the rhf can have more values than just
IB and BYPASS.

Extend the current tracing to report a symbolic for the etype
field for non-bypass packets.  Bypass packets will continue to
report the l2.

As part of this fix the etype and the l2 are added to the tracing
struct and are available for trigger and filter operations.

Fixes: Commit 863cf89d472f ("IB/hfi1: Add 16B trace support")
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace.c        |   23 +++++++--------
 drivers/infiniband/hw/hfi1/trace.h        |   10 +++++++
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   44 +++++++++++++++--------------
 drivers/infiniband/hw/hfi1/trace_rx.h     |   11 +------
 4 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 9938bb9..ce5a43f 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -91,12 +91,17 @@ u8 hfi1_trace_opa_hdr_len(struct hfi1_opa_header *opa_hdr)
 		return __get_16b_hdr_len(&opa_hdr->opah);
 }
 
-const char *hfi1_trace_get_packet_str(struct hfi1_packet *packet)
+const char *hfi1_trace_get_packet_l4_str(u8 l4)
 {
-	if (packet->etype != RHF_RCV_TYPE_BYPASS)
-		return "IB";
+	if (l4)
+		return "16B";
+	else
+		return "9B";
+}
 
-	switch (hfi1_16B_get_l2(packet->hdr)) {
+const char *hfi1_trace_get_packet_l2_str(u8 l2)
+{
+	switch (l2) {
 	case 0:
 		return "0";
 	case 1:
@@ -109,14 +114,6 @@ u8 hfi1_trace_opa_hdr_len(struct hfi1_opa_header *opa_hdr)
 	return "";
 }
 
-const char *hfi1_trace_get_packet_type_str(u8 l4)
-{
-	if (l4)
-		return "16B";
-	else
-		return "9B";
-}
-
 #define IMM_PRN  "imm:%d"
 #define RETH_PRN "reth vaddr:0x%.16llx rkey:0x%.8x dlen:0x%.8x"
 #define AETH_PRN "aeth syn:0x%.2x %s msn:0x%.8x"
diff --git a/drivers/infiniband/hw/hfi1/trace.h b/drivers/infiniband/hw/hfi1/trace.h
index af50c07..8540463 100644
--- a/drivers/infiniband/hw/hfi1/trace.h
+++ b/drivers/infiniband/hw/hfi1/trace.h
@@ -44,6 +44,16 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
+
+#define packettype_name(etype) { RHF_RCV_TYPE_##etype, #etype }
+#define show_packettype(etype)                  \
+__print_symbolic(etype,                         \
+	packettype_name(EXPECTED),              \
+	packettype_name(EAGER),                 \
+	packettype_name(IB),                    \
+	packettype_name(ERROR),                 \
+	packettype_name(BYPASS))
+
 #include "trace_dbg.h"
 #include "trace_misc.h"
 #include "trace_ctxts.h"
diff --git a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
index 6721f84..6dd0d63 100644
--- a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
+++ b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -99,8 +99,7 @@
 const char *parse_everbs_hdrs(struct trace_seq *p, u8 opcode, void *ehdrs);
 u8 hfi1_trace_opa_hdr_len(struct hfi1_opa_header *opah);
 u8 hfi1_trace_packet_hdr_len(struct hfi1_packet *packet);
-const char *hfi1_trace_get_packet_type_str(u8 l4);
-const char *hfi1_trace_get_packet_str(struct hfi1_packet *packet);
+const char *hfi1_trace_get_packet_l4_str(u8 l4);
 void hfi1_trace_parse_9b_bth(struct ib_other_headers *ohdr,
 			     u8 *ack, u8 *becn, u8 *fecn, u8 *mig,
 			     u8 *se, u8 *pad, u8 *opcode, u8 *tver,
@@ -129,6 +128,8 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 			       u8 se, u8 pad, u8 opcode, const char *opname,
 			       u8 tver, u16 pkey, u32 psn, u32 qpn);
 
+const char *hfi1_trace_get_packet_l2_str(u8 l2);
+
 #define __parse_ib_ehdrs(op, ehdrs) parse_everbs_hdrs(p, op, ehdrs)
 
 #define lrh_name(lrh) { HFI1_##lrh, #lrh }
@@ -136,8 +137,6 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 __print_symbolic(lrh,                    \
 	lrh_name(LRH_BTH),               \
 	lrh_name(LRH_GRH))
-#define PKT_ENTRY(pkt)	__string(ptype,  hfi1_trace_get_packet_str(packet))
-#define PKT_ASSIGN(pkt) __assign_str(ptype, hfi1_trace_get_packet_str(packet))
 
 DECLARE_EVENT_CLASS(hfi1_input_ibhdr_template,
 		    TP_PROTO(struct hfi1_devdata *dd,
@@ -146,12 +145,12 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 		    TP_ARGS(dd, packet, sc5),
 		    TP_STRUCT__entry(
 			DD_DEV_ENTRY(dd)
-			PKT_ENTRY(packet)
-			__field(bool, bypass)
+			__field(u8, etype)
 			__field(u8, ack)
 			__field(u8, age)
 			__field(u8, becn)
 			__field(u8, fecn)
+			__field(u8, l2)
 			__field(u8, l4)
 			__field(u8, lnh)
 			__field(u8, lver)
@@ -176,10 +175,10 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 			),
 		    TP_fast_assign(
 			DD_DEV_ASSIGN(dd);
-			PKT_ASSIGN(packet);
 
-			if (packet->etype == RHF_RCV_TYPE_BYPASS) {
-				__entry->bypass = true;
+			__entry->etype = packet->etype;
+			__entry->l2 = hfi1_16B_get_l2(packet->hdr);
+			if (__entry->etype == RHF_RCV_TYPE_BYPASS) {
 				hfi1_trace_parse_16b_hdr(packet->hdr,
 							 &__entry->age,
 							 &__entry->becn,
@@ -203,7 +202,6 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 							   &__entry->psn,
 							   &__entry->qpn);
 			} else {
-				__entry->bypass = false;
 				hfi1_trace_parse_9b_hdr(packet->hdr, sc5,
 							&__entry->lnh,
 							&__entry->lver,
@@ -233,9 +231,13 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 			 ),
 		    TP_printk("[%s] (%s) %s %s hlen:%d %s",
 			      __get_str(dev),
-			      __get_str(ptype),
+			      __entry->etype != RHF_RCV_TYPE_BYPASS ?
+					show_packettype(__entry->etype) :
+					hfi1_trace_get_packet_l2_str(
+						__entry->l2),
 			      hfi1_trace_fmt_lrh(p,
-						 __entry->bypass,
+						 __entry->etype ==
+							RHF_RCV_TYPE_BYPASS,
 						 __entry->age,
 						 __entry->becn,
 						 __entry->fecn,
@@ -252,7 +254,8 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 						 __entry->dlid,
 						 __entry->slid),
 			      hfi1_trace_fmt_bth(p,
-						 __entry->bypass,
+						 __entry->etype ==
+							RHF_RCV_TYPE_BYPASS,
 						 __entry->ack,
 						 __entry->becn,
 						 __entry->fecn,
@@ -284,7 +287,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 		    TP_ARGS(dd, opah, sc5),
 		    TP_STRUCT__entry(
 			DD_DEV_ENTRY(dd)
-			__field(bool, bypass)
+			__field(u8, hdr_type)
 			__field(u8, ack)
 			__field(u8, age)
 			__field(u8, becn)
@@ -316,8 +319,8 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 
 			DD_DEV_ASSIGN(dd);
 
-			if (opah->hdr_type)  {
-				__entry->bypass = true;
+			__entry->hdr_type = opah->hdr_type;
+			if (__entry->hdr_type)  {
 				hfi1_trace_parse_16b_hdr(&opah->opah,
 							 &__entry->age,
 							 &__entry->becn,
@@ -345,7 +348,6 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 							 &__entry->psn,
 							 &__entry->qpn);
 			} else {
-				__entry->bypass = false;
 				hfi1_trace_parse_9b_hdr(&opah->ibh, sc5,
 							&__entry->lnh,
 							&__entry->lver,
@@ -378,9 +380,9 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 		    ),
 		    TP_printk("[%s] (%s) %s %s hlen:%d %s",
 			      __get_str(dev),
-			      hfi1_trace_get_packet_type_str(__entry->l4),
+			      hfi1_trace_get_packet_l4_str(__entry->l4),
 			      hfi1_trace_fmt_lrh(p,
-						 __entry->bypass,
+						 !!__entry->hdr_type,
 						 __entry->age,
 						 __entry->becn,
 						 __entry->fecn,
@@ -397,7 +399,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 						 __entry->dlid,
 						 __entry->slid),
 			      hfi1_trace_fmt_bth(p,
-						 __entry->bypass,
+						 !!__entry->hdr_type,
 						 __entry->ack,
 						 __entry->becn,
 						 __entry->fecn,
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index f9909d2..4d487fe 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -62,15 +62,6 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_rx
 
-#define packettype_name(etype) { RHF_RCV_TYPE_##etype, #etype }
-#define show_packettype(etype)                  \
-__print_symbolic(etype,                         \
-	packettype_name(EXPECTED),              \
-	packettype_name(EAGER),                 \
-	packettype_name(IB),                    \
-	packettype_name(ERROR),                 \
-	packettype_name(BYPASS))
-
 TRACE_EVENT(hfi1_rcvhdr,
 	    TP_PROTO(struct hfi1_devdata *dd,
 		     u32 ctxt,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
