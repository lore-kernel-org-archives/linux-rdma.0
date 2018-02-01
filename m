From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/hfi1: Compute BTH only for
 RDMA_WRITE_LAST/SEND_LAST packet
Date: Thu, 01 Feb 2018 10:46:15 -0800
Message-ID: <20180201184613.5918.8419.stgit@scvm10.sc.intel.com>
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

In hfi1_rc_rcv(), BTH is computed for all packets received.
However, it's only used for packets received with opcodes
RDMA_WRITE_LAST and SEND_LAST, and it is a costly operation.

Compute BTH only in the RDMA_WRITE_LAST/SEND_LAST code path
and let the compiler handle endianness conversion for bitwise
operations.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |    3 +--
 drivers/infiniband/hw/hfi1/uc.c    |    3 +--
 drivers/infiniband/hw/hfi1/ud.c    |    3 +--
 drivers/infiniband/hw/qib/qib_rc.c |    3 +--
 drivers/infiniband/hw/qib/qib_uc.c |    3 +--
 drivers/infiniband/hw/qib/qib_ud.c |    3 +--
 include/rdma/ib_hdrs.h             |    4 ++++
 7 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 524c12f..70aa82b 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2035,7 +2035,6 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	struct rvt_qp *qp = packet->qp;
 	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct ib_other_headers *ohdr = packet->ohdr;
-	u32 bth0 = be32_to_cpu(ohdr->bth[0]);
 	u32 opcode = packet->opcode;
 	u32 hdrsize = packet->hlen;
 	u32 psn = ib_bth_get_psn(packet->ohdr);
@@ -2233,7 +2232,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
 		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
-			     (bth0 & IB_BTH_SOLICITED) != 0);
+			     ib_bth_is_solicited(ohdr));
 		break;
 
 	case OP(RDMA_WRITE_ONLY):
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index fef69d9..8030c38 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -478,8 +478,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
 		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
-			     (ohdr->bth[0] &
-			      cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+			     ib_bth_is_solicited(ohdr));
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 6b5cd3a..cff2fd8 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -1045,8 +1045,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
 	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
-		     (ohdr->bth[0] &
-		      cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+		     ib_bth_is_solicited(ohdr));
 	return;
 
 drop:
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index e4a9ba1..61d3bc6 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1916,8 +1916,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
 		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
-			     (ohdr->bth[0] &
-			      cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+			     ib_bth_is_solicited(ohdr));
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index bddcc37..d311db6 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -403,8 +403,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
 		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
-			     (ohdr->bth[0] &
-				cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+			     ib_bth_is_solicited(ohdr));
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 15962ed..59a4f03 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -581,8 +581,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
 	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
-		     (ohdr->bth[0] &
-			cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+		     ib_bth_is_solicited(ohdr));
 	return;
 
 drop:
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index c124d51..6a86d14 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -331,4 +331,8 @@ static inline u8 ib_bth_get_tver(struct ib_other_headers *ohdr)
 		    IB_BTH_TVER_MASK);
 }
 
+static inline bool ib_bth_is_solicited(struct ib_other_headers *ohdr)
+{
+	return !!(ohdr->bth[0] & cpu_to_be32(IB_BTH_SOLICITED));
+}
 #endif                          /* IB_HDRS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
