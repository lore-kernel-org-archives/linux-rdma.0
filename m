From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/hfi1: Add 16B rcvhdr trace support
Date: Thu, 01 Feb 2018 12:38:48 -0800
Message-ID: <20180201203845.14095.14729.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add trace_hfi1_rcvhdr support for bypass packets.
While here, remove the etype argument as it is available
in struct hfi1_packet.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c   |    4 +++-
 drivers/infiniband/hw/hfi1/trace_rx.h |    6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index c7e6b67..addc68e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1559,7 +1559,7 @@ int process_receive_ib(struct hfi1_packet *packet)
 	if (hfi1_setup_9B_packet(packet))
 		return RHF_RCV_CONTINUE;
 
-	trace_hfi1_rcvhdr(packet, RHF_RCV_TYPE_IB);
+	trace_hfi1_rcvhdr(packet);
 
 	if (unlikely(rhf_err_flags(packet->rhf))) {
 		handle_eflags(packet);
@@ -1595,6 +1595,8 @@ int process_receive_bypass(struct hfi1_packet *packet)
 	if (hfi1_setup_bypass_packet(packet))
 		return RHF_RCV_CONTINUE;
 
+	trace_hfi1_rcvhdr(packet);
+
 	if (unlikely(rhf_err_flags(packet->rhf))) {
 		handle_eflags(packet);
 		return RHF_RCV_CONTINUE;
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index f768415..7eceb57 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -63,8 +63,8 @@
 #define TRACE_SYSTEM hfi1_rx
 
 TRACE_EVENT(hfi1_rcvhdr,
-	    TP_PROTO(struct hfi1_packet *packet, u32 etype),
-	    TP_ARGS(packet, etype),
+	    TP_PROTO(struct hfi1_packet *packet),
+	    TP_ARGS(packet),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(packet->rcd->dd)
 			     __field(u64, eflags)
 			     __field(u32, ctxt)
@@ -77,7 +77,7 @@
 	     TP_fast_assign(DD_DEV_ASSIGN(packet->rcd->dd);
 			    __entry->eflags = rhf_err_flags(packet->rhf);
 			    __entry->ctxt = packet->rcd->ctxt;
-			    __entry->etype = etype;
+			    __entry->etype = packet->etype;
 			    __entry->hlen = packet->hlen;
 			    __entry->tlen = packet->tlen;
 			    __entry->updegr = packet->updegr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
