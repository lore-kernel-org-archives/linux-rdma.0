From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] infiniband: cxgb4: use ktime_get for timestamps
Date: Mon, 27 Nov 2017 12:44:53 +0100
Message-ID: <20171127114518.2662754-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The debugfs file prints the difference between host timestamps as a
seconds/nanoseconds tuple, along with a 64-bit nanoseconds hardware
timestamp. The host time is read using getnstimeofday() which is
deprecated because of the y2038 overflow, and it suffers from time jumps
during settimeofday() and leap seconds.

Converting to ktime_get_ts64() would solve those two, but I'm going
a little further here by changing to ktime_get() and printing 64-bit
nanoseconds on both host and hw timestamps.  This simplifies the code
further and makes the output easier to understand.

The format of the debugfs file obviously changes here, but this should
only be read by humans and not scripts, so I assume it's fine.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c   | 34 +++++++++++++++-------------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 ++--
 drivers/infiniband/hw/cxgb4/qp.c       |  6 +++---
 drivers/infiniband/hw/cxgb4/t4.h       |  4 ++--
 4 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index af77d128d242..21566228b0ba 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -108,19 +108,19 @@ void c4iw_log_wr_stats(struct t4_wq *wq, struct t4_cqe *cqe)
 	idx = (atomic_inc_return(&wq->rdev->wr_log_idx) - 1) &
 		(wq->rdev->wr_log_size - 1);
 	le.poll_sge_ts = cxgb4_read_sge_timestamp(wq->rdev->lldi.ports[0]);
-	getnstimeofday(&le.poll_host_ts);
+	le.poll_host_time = ktime_get();
 	le.valid = 1;
 	le.cqe_sge_ts = CQE_TS(cqe);
 	if (SQ_TYPE(cqe)) {
 		le.qid = wq->sq.qid;
 		le.opcode = CQE_OPCODE(cqe);
-		le.post_host_ts = wq->sq.sw_sq[wq->sq.cidx].host_ts;
+		le.post_host_time = wq->sq.sw_sq[wq->sq.cidx].host_time;
 		le.post_sge_ts = wq->sq.sw_sq[wq->sq.cidx].sge_ts;
 		le.wr_id = CQE_WRID_SQ_IDX(cqe);
 	} else {
 		le.qid = wq->rq.qid;
 		le.opcode = FW_RI_RECEIVE;
-		le.post_host_ts = wq->rq.sw_rq[wq->rq.cidx].host_ts;
+		le.post_host_time = wq->rq.sw_rq[wq->rq.cidx].host_time;
 		le.post_sge_ts = wq->rq.sw_rq[wq->rq.cidx].sge_ts;
 		le.wr_id = CQE_WRID_MSN(cqe);
 	}
@@ -130,9 +130,9 @@ void c4iw_log_wr_stats(struct t4_wq *wq, struct t4_cqe *cqe)
 static int wr_log_show(struct seq_file *seq, void *v)
 {
 	struct c4iw_dev *dev = seq->private;
-	struct timespec prev_ts = {0, 0};
+	ktime_t prev_time;
 	struct wr_log_entry *lep;
-	int prev_ts_set = 0;
+	int prev_time_set = 0;
 	int idx, end;
 
 #define ts2ns(ts) div64_u64((ts) * dev->rdev.lldi.cclk_ps, 1000)
@@ -145,33 +145,29 @@ static int wr_log_show(struct seq_file *seq, void *v)
 	lep = &dev->rdev.wr_log[idx];
 	while (idx != end) {
 		if (lep->valid) {
-			if (!prev_ts_set) {
-				prev_ts_set = 1;
-				prev_ts = lep->poll_host_ts;
+			if (!prev_time_set) {
+				prev_time_set = 1;
+				prev_time = lep->poll_host_time;
 			}
-			seq_printf(seq, "%04u: sec %lu nsec %lu qid %u opcode "
-				   "%u %s 0x%x host_wr_delta sec %lu nsec %lu "
+			seq_printf(seq, "%04u: nsec %llu qid %u opcode "
+				   "%u %s 0x%x host_wr_delta nsec %llu "
 				   "post_sge_ts 0x%llx cqe_sge_ts 0x%llx "
 				   "poll_sge_ts 0x%llx post_poll_delta_ns %llu "
 				   "cqe_poll_delta_ns %llu\n",
 				   idx,
-				   timespec_sub(lep->poll_host_ts,
-						prev_ts).tv_sec,
-				   timespec_sub(lep->poll_host_ts,
-						prev_ts).tv_nsec,
+				   ktime_to_ns(ktime_sub(lep->poll_host_time,
+							 prev_time)),
 				   lep->qid, lep->opcode,
 				   lep->opcode == FW_RI_RECEIVE ?
 							"msn" : "wrid",
 				   lep->wr_id,
-				   timespec_sub(lep->poll_host_ts,
-						lep->post_host_ts).tv_sec,
-				   timespec_sub(lep->poll_host_ts,
-						lep->post_host_ts).tv_nsec,
+				   ktime_to_ns(ktime_sub(lep->poll_host_time,
+					                 lep->post_host_time)),
 				   lep->post_sge_ts, lep->cqe_sge_ts,
 				   lep->poll_sge_ts,
 				   ts2ns(lep->poll_sge_ts - lep->post_sge_ts),
 				   ts2ns(lep->poll_sge_ts - lep->cqe_sge_ts));
-			prev_ts = lep->poll_host_ts;
+			prev_time = lep->poll_host_time;
 		}
 		idx++;
 		if (idx > (dev->rdev.wr_log_size - 1))
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 470f97a79ebb..37ff2ad8a3d4 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -153,8 +153,8 @@ struct c4iw_hw_queue {
 };
 
 struct wr_log_entry {
-	struct timespec post_host_ts;
-	struct timespec poll_host_ts;
+	ktime_t post_host_time;
+	ktime_t poll_host_time;
 	u64 post_sge_ts;
 	u64 cqe_sge_ts;
 	u64 poll_sge_ts;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 5ee7fe433136..8018533ab705 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -975,7 +975,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		if (c4iw_wr_log) {
 			swsqe->sge_ts = cxgb4_read_sge_timestamp(
 					qhp->rhp->rdev.lldi.ports[0]);
-			getnstimeofday(&swsqe->host_ts);
+			swsqe->host_time = ktime_get();
 		}
 
 		init_wr_hdr(wqe, qhp->wq.sq.pidx, fw_opcode, fw_flags, len16);
@@ -1045,8 +1045,8 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			qhp->wq.rq.sw_rq[qhp->wq.rq.pidx].sge_ts =
 				cxgb4_read_sge_timestamp(
 						qhp->rhp->rdev.lldi.ports[0]);
-			getnstimeofday(
-				&qhp->wq.rq.sw_rq[qhp->wq.rq.pidx].host_ts);
+			qhp->wq.rq.sw_rq[qhp->wq.rq.pidx].host_time =
+				ktime_get();
 		}
 
 		wqe->recv.opcode = FW_RI_RECV_WR;
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index e9ea94268d51..e12377cc024c 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -271,7 +271,7 @@ struct t4_swsqe {
 	int			signaled;
 	u16			idx;
 	int                     flushed;
-	struct timespec         host_ts;
+	ktime_t			host_time;
 	u64                     sge_ts;
 };
 
@@ -312,7 +312,7 @@ struct t4_sq {
 
 struct t4_swrqe {
 	u64 wr_id;
-	struct timespec host_ts;
+	ktime_t	host_time;
 	u64 sge_ts;
 };
 
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
