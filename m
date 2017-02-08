From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/27] IB/hfi1: Ensure read of producer s_head is correct
Date: Wed, 08 Feb 2017 05:26:08 -0800
Message-ID: <20170208132607.16442.4562.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The read of s_head in the hfi1_make_rc_req() and
qib_make_rc_req() lack the necesary barrier instuctions.

Correct other ACCESS_ONCE() warnings in the same file.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |    7 ++++---
 drivers/infiniband/hw/qib/qib_rc.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 1dd999e..6446179 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -414,7 +414,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		smp_read_barrier_depends(); /* see post_one_send() */
-		if (qp->s_last == ACCESS_ONCE(qp->s_head))
+		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (iowait_sdma_pending(&priv->s_iowait)) {
@@ -457,7 +457,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		newreq = 0;
 		if (qp->s_cur == qp->s_tail) {
 			/* Check if send work queue is empty. */
-			if (qp->s_tail == qp->s_head) {
+			smp_read_barrier_depends(); /* see post_one_send() */
+			if (qp->s_tail == READ_ONCE(qp->s_head)) {
 				clear_ahg(qp);
 				goto bail;
 			}
@@ -1590,7 +1591,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 
 	/* Ignore invalid responses. */
 	smp_read_barrier_depends(); /* see post_one_send */
-	if (cmp_psn(psn, ACCESS_ONCE(qp->s_next_psn)) >= 0)
+	if (cmp_psn(psn, READ_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
 	/* Ignore duplicate responses. */
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 031433c..696bcd0 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -257,7 +257,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		smp_read_barrier_depends(); /* see post_one_send() */
-		if (qp->s_last == ACCESS_ONCE(qp->s_head))
+		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
@@ -303,7 +303,8 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		newreq = 0;
 		if (qp->s_cur == qp->s_tail) {
 			/* Check if send work queue is empty. */
-			if (qp->s_tail == qp->s_head)
+			smp_read_barrier_depends(); /* see post_one_send() */
+			if (qp->s_tail == READ_ONCE(qp->s_head))
 				goto bail;
 			/*
 			 * If a fence is requested, wait for previous
@@ -1390,7 +1391,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 
 	/* Ignore invalid responses. */
 	smp_read_barrier_depends(); /* see post_one_send */
-	if (qib_cmp24(psn, ACCESS_ONCE(qp->s_next_psn)) >= 0)
+	if (qib_cmp24(psn, READ_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
 	/* Ignore duplicate responses. */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
