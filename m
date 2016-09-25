From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/13] IB/hfi1: Consolidate pio control masks into single
 definition
Date: Sun, 25 Sep 2016 07:40:58 -0700
Message-ID: <20160925144054.10261.31958.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This allows for adding additional pages of adaptive pio
opcode control including manufacturer specific ones.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |   14 +-------------
 drivers/infiniband/hw/hfi1/uc.c    |    9 +--------
 drivers/infiniband/hw/hfi1/verbs.c |   36 +++++++++++++++++++++++++++---------
 drivers/infiniband/hw/hfi1/verbs.h |    3 +++
 4 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index db63967..d32f0c8 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -55,7 +55,7 @@
 #include "trace.h"
 
 /* cut down ridiculously long IB macro names */
-#define OP(x) IB_OPCODE_RC_##x
+#define OP(x) RC_OP(x)
 
 /**
  * hfi1_add_retry_timer - add/start a retry timer
@@ -184,18 +184,6 @@ void hfi1_del_timers_sync(struct rvt_qp *qp)
 	del_timer_sync(&priv->s_rnr_timer);
 }
 
-/* only opcode mask for adaptive pio */
-const u32 rc_only_opcode =
-	BIT(OP(SEND_ONLY) & 0x1f) |
-	BIT(OP(SEND_ONLY_WITH_IMMEDIATE & 0x1f)) |
-	BIT(OP(RDMA_WRITE_ONLY & 0x1f)) |
-	BIT(OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE & 0x1f)) |
-	BIT(OP(RDMA_READ_REQUEST & 0x1f)) |
-	BIT(OP(ACKNOWLEDGE & 0x1f)) |
-	BIT(OP(ATOMIC_ACKNOWLEDGE & 0x1f)) |
-	BIT(OP(COMPARE_SWAP & 0x1f)) |
-	BIT(OP(FETCH_ADD & 0x1f));
-
 static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
 {
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index e7fa176..5e6d1ba 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -50,14 +50,7 @@
 #include "qp.h"
 
 /* cut down ridiculously long IB macro names */
-#define OP(x) IB_OPCODE_UC_##x
-
-/* only opcode mask for adaptive pio */
-const u32 uc_only_opcode =
-	BIT(OP(SEND_ONLY) & 0x1f) |
-	BIT(OP(SEND_ONLY_WITH_IMMEDIATE & 0x1f)) |
-	BIT(OP(RDMA_WRITE_ONLY & 0x1f)) |
-	BIT(OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE & 0x1f));
+#define OP(x) UC_OP(x)
 
 /**
  * hfi1_make_uc_req - construct a request packet (SEND, RDMA write)
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index d502ba0..0a0e93e 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -403,6 +403,28 @@ static const opcode_handler opcode_handler_tbl[256] = {
 	[IB_OPCODE_CNP]				      = &hfi1_cnp_rcv
 };
 
+#define OPMASK 0x1f
+
+static const u32 pio_opmask[BIT(3)] = {
+	/* RC */
+	[IB_OPCODE_RC >> 5] =
+		BIT(RC_OP(SEND_ONLY) & OPMASK) |
+		BIT(RC_OP(SEND_ONLY_WITH_IMMEDIATE) & OPMASK) |
+		BIT(RC_OP(RDMA_WRITE_ONLY) & OPMASK) |
+		BIT(RC_OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE) & OPMASK) |
+		BIT(RC_OP(RDMA_READ_REQUEST) & OPMASK) |
+		BIT(RC_OP(ACKNOWLEDGE) & OPMASK) |
+		BIT(RC_OP(ATOMIC_ACKNOWLEDGE) & OPMASK) |
+		BIT(RC_OP(COMPARE_SWAP) & OPMASK) |
+		BIT(RC_OP(FETCH_ADD) & OPMASK),
+	/* UC */
+	[IB_OPCODE_UC >> 5] =
+		BIT(UC_OP(SEND_ONLY) & OPMASK) |
+		BIT(UC_OP(SEND_ONLY_WITH_IMMEDIATE) & OPMASK) |
+		BIT(UC_OP(RDMA_WRITE_ONLY) & OPMASK) |
+		BIT(UC_OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE) & OPMASK),
+};
+
 /*
  * System image GUID.
  */
@@ -1210,22 +1232,18 @@ static inline send_routine get_send_routine(struct rvt_qp *qp,
 	case IB_QPT_GSI:
 	case IB_QPT_UD:
 		break;
-	case IB_QPT_RC:
-		if (piothreshold &&
-		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
-		    (BIT(get_opcode(h) & 0x1f) & rc_only_opcode) &&
-		    iowait_sdma_pending(&priv->s_iowait) == 0 &&
-		    !sdma_txreq_built(&tx->txreq))
-			return dd->process_pio_send;
-		break;
 	case IB_QPT_UC:
+	case IB_QPT_RC: {
+		u8 op = get_opcode(h);
+
 		if (piothreshold &&
 		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
-		    (BIT(get_opcode(h) & 0x1f) & uc_only_opcode) &&
+		    (BIT(op & OPMASK) & pio_opmask[op >> 5]) &&
 		    iowait_sdma_pending(&priv->s_iowait) == 0 &&
 		    !sdma_txreq_built(&tx->txreq))
 			return dd->process_pio_send;
 		break;
+	}
 	default:
 		break;
 	}
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 0dd65eb..1c3815d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -97,6 +97,9 @@ struct hfi1_packet;
 
 #define IB_DEFAULT_GID_PREFIX	cpu_to_be64(0xfe80000000000000ULL)
 
+#define RC_OP(x) IB_OPCODE_RC_##x
+#define UC_OP(x) IB_OPCODE_UC_##x
+
 /* flags passed by hfi1_ib_rcv() */
 enum {
 	HFI1_HAS_GRH = (1 << 0),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
