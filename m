From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 12/14] qedr: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:23:07 -0700
Message-ID: <1487272989-8215-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

qedr uses WC memory for its '.db' mmap, so all writes to it have
to be wrapped in the WC barriers. This upgrades the leading
wmb to a wc_wmb() for consistency with other drivers.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 95cd429e1b9b47..c8a0db2c9c1cfd 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -672,9 +672,9 @@ static int qelr_update_qp_state(struct qelr_qp *qp,
 			/* Update doorbell (in case post_recv was done before
 			 * move to RTR)
 			 */
-			wmb();
+			mmio_wc_start();
 			writel(qp->rq.db_data.raw, qp->rq.db);
-			wc_wmb();
+			mmio_flush_writes();
 			break;
 		case QELR_QPS_ERR:
 			break;
@@ -1096,7 +1096,7 @@ static void doorbell_edpm_qp(struct qelr_qp *qp)
 	if (!qp->edpm.is_edpm)
 		return;
 
-	wmb();
+	mmio_wc_start();
 
 	qp->edpm.msg.data.icid = qp->sq.db_data.data.icid;
 	qp->edpm.msg.data.prod_val = qp->sq.db_data.data.value;
@@ -1116,15 +1116,16 @@ static void doorbell_edpm_qp(struct qelr_qp *qp)
 		       sizeof(uint64_t));
 
 		bytes += sizeof(uint64_t);
-		/* Need to place a barrier after every 64 bytes */
+		/* Since we rewrite the buffer every 64 bytes we need to flush
+		   it here, otherwise the CPU could optimize alway the
+		   duplicate stores. */
 		if (bytes == 64) {
-			wc_wmb();
+			mmio_flush_writes();
 			bytes = 0;
 		}
 		offset++;
 	}
-
-	wc_wmb();
+	mmio_flush_writes();
 }
 
 int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
@@ -1363,11 +1364,9 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 	}
 
 	if (!qp->edpm.is_edpm) {
-		wmb();
-
+		mmio_wc_start();
 		writel(qp->sq.db_data.raw, qp->sq.db);
-
-		wc_wmb();
+		mmio_flush_writes();
 	}
 
 	pthread_spin_unlock(&qp->q_lock);
@@ -1446,14 +1445,13 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 
 		qelr_inc_sw_prod_u16(&qp->rq);
 
-		wmb();
+		mmio_wc_start();
 
 		db_val = le16toh(qp->rq.db_data.data.value) + 1;
 		qp->rq.db_data.data.value = htole16(db_val);
 
 		writel(qp->rq.db_data.raw, qp->rq.db);
-
-		wc_wmb();
+		mmio_flush_writes();
 
 		wr = wr->next;
 	}
@@ -1795,12 +1793,12 @@ static int qelr_poll_cq_resp(struct qelr_qp *qp, struct qelr_cq *cq,
 
 static void doorbell_cq(struct qelr_cq *cq, uint32_t cons, uint8_t flags)
 {
-	wmb();
+	mmio_wc_start();
 	cq->db.data.agg_flags = flags;
 	cq->db.data.value = htole32(cons);
 
 	writeq(cq->db.raw, cq->db_addr);
-	wc_wmb();
+	mmio_flush_writes();
 }
 
 int qelr_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
@@ -1816,7 +1814,7 @@ int qelr_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 		struct qelr_qp *qp;
 
 		/* prevent speculative reads of any field of CQE */
-		rmb();
+		udma_from_device_barrier();
 
 		qp = cqe_get_qp(cqe);
 		if (!qp) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
