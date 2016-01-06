From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] IB/rdmavt: Add R and S flags for queue pairs
Date: Wed, 06 Jan 2016 10:15:06 -0800
Message-ID: <20160106181505.3238.26444.stgit@scvm10.sc.intel.com>
References: <20160106181226.3238.98769.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106181226.3238.98769.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the flags originally provided for hfi1 in the rdmavt driver. These will
be made available to drivers in the qp header file.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdmavt_qp.h |   80 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index e6a7d17..1aa8b5b 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -48,6 +48,86 @@
  *
  */
 
+#include <rdma/ib_pack.h>
+/*
+ * Atomic bit definitions for r_aflags.
+ */
+#define RVT_R_WRID_VALID        0
+#define RVT_R_REWIND_SGE        1
+
+/*
+ * Bit definitions for r_flags.
+ */
+#define RVT_R_REUSE_SGE 0x01
+#define RVT_R_RDMAR_SEQ 0x02
+#define RVT_R_RSP_NAK   0x04
+#define RVT_R_RSP_SEND  0x08
+#define RVT_R_COMM_EST  0x10
+
+/*
+ * Bit definitions for s_flags.
+ *
+ * RVT_S_SIGNAL_REQ_WR - set if QP send WRs contain completion signaled
+ * RVT_S_BUSY - send tasklet is processing the QP
+ * RVT_S_TIMER - the RC retry timer is active
+ * RVT_S_ACK_PENDING - an ACK is waiting to be sent after RDMA read/atomics
+ * RVT_S_WAIT_FENCE - waiting for all prior RDMA read or atomic SWQEs
+ *                         before processing the next SWQE
+ * RVT_S_WAIT_RDMAR - waiting for a RDMA read or atomic SWQE to complete
+ *                         before processing the next SWQE
+ * RVT_S_WAIT_RNR - waiting for RNR timeout
+ * RVT_S_WAIT_SSN_CREDIT - waiting for RC credits to process next SWQE
+ * RVT_S_WAIT_DMA - waiting for send DMA queue to drain before generating
+ *                  next send completion entry not via send DMA
+ * RVT_S_WAIT_PIO - waiting for a send buffer to be available
+ * RVT_S_WAIT_TX - waiting for a struct verbs_txreq to be available
+ * RVT_S_WAIT_DMA_DESC - waiting for DMA descriptors to be available
+ * RVT_S_WAIT_KMEM - waiting for kernel memory to be available
+ * RVT_S_WAIT_PSN - waiting for a packet to exit the send DMA queue
+ * RVT_S_WAIT_ACK - waiting for an ACK packet before sending more requests
+ * RVT_S_SEND_ONE - send one packet, request ACK, then wait for ACK
+ * RVT_S_ECN - a BECN was queued to the send engine
+ */
+#define RVT_S_SIGNAL_REQ_WR	0x0001
+#define RVT_S_BUSY		0x0002
+#define RVT_S_TIMER		0x0004
+#define RVT_S_RESP_PENDING	0x0008
+#define RVT_S_ACK_PENDING	0x0010
+#define RVT_S_WAIT_FENCE	0x0020
+#define RVT_S_WAIT_RDMAR	0x0040
+#define RVT_S_WAIT_RNR		0x0080
+#define RVT_S_WAIT_SSN_CREDIT	0x0100
+#define RVT_S_WAIT_DMA		0x0200
+#define RVT_S_WAIT_PIO		0x0400
+#define RVT_S_WAIT_TX		0x0800
+#define RVT_S_WAIT_DMA_DESC	0x1000
+#define RVT_S_WAIT_KMEM		0x2000
+#define RVT_S_WAIT_PSN		0x4000
+#define RVT_S_WAIT_ACK		0x8000
+#define RVT_S_SEND_ONE		0x10000
+#define RVT_S_UNLIMITED_CREDIT	0x20000
+#define RVT_S_AHG_VALID		0x40000
+#define RVT_S_AHG_CLEAR		0x80000
+#define RVT_S_ECN		0x100000
+
+/*
+ * Wait flags that would prevent any packet type from being sent.
+ */
+#define RVT_S_ANY_WAIT_IO (RVT_S_WAIT_PIO | RVT_S_WAIT_TX | \
+	RVT_S_WAIT_DMA_DESC | RVT_S_WAIT_KMEM)
+
+/*
+ * Wait flags that would prevent send work requests from making progress.
+ */
+#define RVT_S_ANY_WAIT_SEND (RVT_S_WAIT_FENCE | RVT_S_WAIT_RDMAR | \
+	RVT_S_WAIT_RNR | RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_DMA | \
+	RVT_S_WAIT_PSN | RVT_S_WAIT_ACK)
+
+#define RVT_S_ANY_WAIT (RVT_S_ANY_WAIT_IO | RVT_S_ANY_WAIT_SEND)
+
+/* Number of bits to pay attention to in the opcode for checking qp type */
+#define RVT_OPCODE_QP_MASK 0xE0
+
 /*
  * Send work request queue entry.
  * The size of the sg_list is determined when the QP is created and stored

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
