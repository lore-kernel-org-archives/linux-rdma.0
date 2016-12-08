From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/23] IB/rdmavt: Add a send completion helper
Date: Wed, 07 Dec 2016 19:34:06 -0800
Message-ID: <20161208033405.21135.16717.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This is for use by client drivers to drive
send completions into a CQ.

A new exported table allows for the mapping
of ib_wr_opcode into a ib_wc_opcode.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   17 ++++++++++++++++
 include/rdma/rdmavt_qp.h          |   40 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 6500c3b..9e14add 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -76,6 +76,23 @@
 };
 EXPORT_SYMBOL(ib_rvt_state_ops);
 
+/*
+ * Translate ib_wr_opcode into ib_wc_opcode.
+ */
+const enum ib_wc_opcode ib_rvt_wc_opcode[] = {
+	[IB_WR_RDMA_WRITE] = IB_WC_RDMA_WRITE,
+	[IB_WR_RDMA_WRITE_WITH_IMM] = IB_WC_RDMA_WRITE,
+	[IB_WR_SEND] = IB_WC_SEND,
+	[IB_WR_SEND_WITH_IMM] = IB_WC_SEND,
+	[IB_WR_RDMA_READ] = IB_WC_RDMA_READ,
+	[IB_WR_ATOMIC_CMP_AND_SWP] = IB_WC_COMP_SWAP,
+	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD,
+	[IB_WR_SEND_WITH_INV] = IB_WC_SEND,
+	[IB_WR_LOCAL_INV] = IB_WC_LOCAL_INV,
+	[IB_WR_REG_MR] = IB_WC_REG_MR
+};
+EXPORT_SYMBOL(ib_rvt_wc_opcode);
+
 static void get_map_page(struct rvt_qpn_table *qpt,
 			 struct rvt_qpn_map *map,
 			 gfp_t gfp)
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 2c5183e..d78e99c 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -51,6 +51,7 @@
 #include <rdma/rdma_vt.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_verbs.h>
+#include <rdma/rdmavt_cq.h>
 /*
  * Atomic bit definitions for r_aflags.
  */
@@ -527,7 +528,44 @@ static inline void rvt_qp_wqe_unreserve(
 	}
 }
 
-extern const int  ib_rvt_state_ops[];
+extern const enum ib_wc_opcode ib_rvt_wc_opcode[];
+
+/**
+ * rvt_qp_swqe_complete() - insert send completion
+ * @qp - the qp
+ * @wqe - the send wqe
+ * @status - completion status
+ *
+ * Insert a send completion into the completion
+ * queue if the qp indicates it should be done.
+ *
+ * See IBTA 10.7.3.1 for info on completion
+ * control.
+ */
+static inline void rvt_qp_swqe_complete(
+	struct rvt_qp *qp,
+	struct rvt_swqe *wqe,
+	enum ib_wc_status status)
+{
+	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED))
+		return;
+	if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
+	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
+	     status != IB_WC_SUCCESS) {
+		struct ib_wc wc;
+
+		memset(&wc, 0, sizeof(wc));
+		wc.wr_id = wqe->wr.wr_id;
+		wc.status = status;
+		wc.opcode = ib_rvt_wc_opcode[wqe->wr.opcode];
+		wc.qp = &qp->ibqp;
+		wc.byte_len = wqe->length;
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,
+			     status != IB_WC_SUCCESS);
+	}
+}
+
+extern const int ib_rvt_state_ops[];
 
 struct rvt_dev_info;
 int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
