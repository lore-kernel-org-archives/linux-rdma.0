From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 09/14] nes: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:23:04 -0700
Message-ID: <1487272989-8215-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This driver inexplicably uses mb() for all sorts of things, translate it to
rmb() or wmb() as appropriate based on context and comments.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/nes/nes_uverbs.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/providers/nes/nes_uverbs.c b/providers/nes/nes_uverbs.c
index 867c39e1167884..80532abdb45d75 100644
--- a/providers/nes/nes_uverbs.c
+++ b/providers/nes/nes_uverbs.c
@@ -473,7 +473,7 @@ int nes_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 			break;
 
 		/* Make sure we read CQ entry contents *after* we've checked the valid bit. */
-		mb();
+		udma_from_device_barrier();
 
 		cqe = (volatile struct nes_hw_cqe)nesucq->cqes[head];
 
@@ -638,7 +638,7 @@ int nes_upoll_cq_no_db_read(struct ibv_cq *cq, int num_entries, struct ibv_wc *e
 			break;
 
 		/* Make sure we read CQ entry contents *after* we've checked the valid bit. */
-		mb();
+		udma_from_device_barrier();
 
 		cqe = (volatile struct nes_hw_cqe)nesucq->cqes[head];
 
@@ -1125,7 +1125,7 @@ static void nes_clean_cq(struct nes_uqp *nesuqp, struct nes_ucq *nesucq)
 
 	cq_head = nesucq->head;
 	while (le32_to_cpu(nesucq->cqes[cq_head].cqe_words[NES_CQE_OPCODE_IDX]) & NES_CQE_VALID) {
-		rmb();
+		udma_from_device_barrier();
 		lo = le32_to_cpu(nesucq->cqes[cq_head].cqe_words[NES_CQE_COMP_COMP_CTX_LOW_IDX]);
 		hi = le32_to_cpu(nesucq->cqes[cq_head].cqe_words[NES_CQE_COMP_COMP_CTX_HIGH_IDX]);
 		u64temp = (((uint64_t)hi) << 32) | ((uint64_t)lo);
@@ -1205,6 +1205,7 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 	int sge_index;
 
 	pthread_spin_lock(&nesuqp->lock);
+	udma_to_device_barrier();
 
 	head = nesuqp->sq_head;
 	while (ib_wr) {
@@ -1234,7 +1235,7 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 		u64temp = (uint64_t)((uintptr_t)nesuqp);
 		wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX] = cpu_to_le32((uint32_t)u64temp);
 		wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_HIGH_IDX] = cpu_to_le32((uint32_t)(u64temp>>32));
-		mb();
+		udma_ordering_write_barrier();
 		wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX] |= cpu_to_le32(head);
 
 		switch (ib_wr->opcode) {
@@ -1360,7 +1361,7 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 	}
 
 	nesuqp->sq_head = head;
-	mb();
+	udma_to_device_barrier();
 	while (wqe_count) {
 		counter = (wqe_count<(uint32_t)255) ? wqe_count : 255;
 		wqe_count -= counter;
@@ -1400,6 +1401,7 @@ int nes_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 	}
 
 	pthread_spin_lock(&nesuqp->lock);
+	udma_to_device_barrier();
 
 	head = nesuqp->rq_head;
 	while (ib_wr) {
@@ -1427,7 +1429,7 @@ int nes_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 				cpu_to_le32((uint32_t)u64temp);
 		wqe->wqe_words[NES_IWARP_RQ_WQE_COMP_CTX_HIGH_IDX] =
 				cpu_to_le32((uint32_t)(u64temp >> 32));
-		mb();
+		udma_ordering_write_barrier();
 		wqe->wqe_words[NES_IWARP_RQ_WQE_COMP_CTX_LOW_IDX] |= cpu_to_le32(head);
 
 		total_payload_length = 0;
@@ -1452,7 +1454,7 @@ int nes_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 	}
 
 	nesuqp->rq_head = head;
-	mb();
+	udma_to_device_barrier();
 	while (wqe_count) {
 		counter = (wqe_count<(uint32_t)255) ? wqe_count : 255;
 		wqe_count -= counter;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
