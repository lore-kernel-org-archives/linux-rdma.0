From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rdmavt: Eliminate redundant opcode test in mr ref clear
Date: Wed, 27 Jul 2016 21:07:36 -0400
Message-ID: <20160728010735.GB3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


The use of the specific opcode test is redundant since
all ack entry users correctly manipulate the mr pointer
to selectively trigger the reference clearing.

The overly specific test hinders the use of implementation
specific operations.

The change needs to get rid of the union to insure that
an atomic value is not seen as an MR pointer.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |  3 +--
 include/rdma/rdmavt_qp.h          | 10 ++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 8ccf1b970b2c..bdb540f25a88 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -435,8 +435,7 @@ static void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 	for (n = 0; n < rvt_max_atomic(rdi); n++) {
 		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
 
-		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
-		    e->rdma_sge.mr) {
+		if (e->rdma_sge.mr) {
 			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 13902dd319a9..bd34d0b56bf7 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -222,14 +222,12 @@ struct rvt_mmap_info {
  * to send a RDMA read response or atomic operation.
  */
 struct rvt_ack_entry {
-	u8 opcode;
-	u8 sent;
+	struct rvt_sge rdma_sge;
+	u64 atomic_data;
 	u32 psn;
 	u32 lpsn;
-	union {
-		struct rvt_sge rdma_sge;
-		u64 atomic_data;
-	};
+	u8 opcode;
+	u8 sent;
 };
 
 #define	RC_QP_SCALING_INTERVAL	5
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
