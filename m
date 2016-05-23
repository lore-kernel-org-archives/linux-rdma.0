From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 1/1] Staging: rdma: hfi1: rc.c: Fixed coding style issues
Date: Mon, 23 May 2016 12:06:01 +0530
Message-ID: <1463985362-8429-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: infinipath@intel.com, dledford@redhat.com, sean.hefty@intel.com, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Fixed following checkpatch.pl warnings:
  Prefer 'unsigned int' to bare use of 'unsigned'
  Prefer READ_ONCE(<FOO>) over ACCESS_ONCE(<FOO>)

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/staging/rdma/hfi1/rc.c  | 12 ++++++------
 drivers/staging/rdma/hfi1/ruc.c |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 792f15e..fb3a6c1 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -421,7 +421,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		smp_read_barrier_depends(); /* see post_one_send() */
-		if (qp->s_last == ACCESS_ONCE(qp->s_head))
+		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (iowait_sdma_pending(&priv->s_iowait)) {
@@ -1103,7 +1103,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	struct hfi1_other_headers *ohdr;
 	struct rvt_swqe *wqe;
 	struct ib_wc wc;
-	unsigned i;
+	unsigned int i;
 	u32 opcode;
 	u32 psn;
 
@@ -1196,7 +1196,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 					 struct hfi1_ibport *ibp)
 {
 	struct ib_wc wc;
-	unsigned i;
+	unsigned int i;
 
 	/*
 	 * Don't decrement refcount and don't generate a
@@ -1571,7 +1571,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 
 	/* Ignore invalid responses. */
 	smp_read_barrier_depends(); /* see post_one_send */
-	if (cmp_psn(psn, ACCESS_ONCE(qp->s_next_psn)) >= 0)
+	if (cmp_psn(psn, READ_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
 	/* Ignore duplicate responses. */
@@ -1970,9 +1970,9 @@ void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
 	}
 }
 
-static inline void update_ack_queue(struct rvt_qp *qp, unsigned n)
+static inline void update_ack_queue(struct rvt_qp *qp, unsigned int n)
 {
-	unsigned next;
+	unsigned int next;
 
 	next = n + 1;
 	if (next > HFI1_MAX_RDMA_ATOMIC)
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index a659aec..cb64c80 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -239,7 +239,7 @@ bail:
 	return ret;
 }
 
-static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned index)
+static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned int index)
 {
 	if (!index) {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -393,7 +393,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 
 again:
 	smp_read_barrier_depends(); /* see post_one_send() */
-	if (sqp->s_last == ACCESS_ONCE(sqp->s_head))
+	if (sqp->s_last == READ_ONCE(sqp->s_head))
 		goto clr_busy;
 	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
 
@@ -929,7 +929,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status)
 {
 	u32 old_last, last;
-	unsigned i;
+	unsigned int i;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
-- 
1.9.1
