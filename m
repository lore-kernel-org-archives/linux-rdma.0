From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 10/14] mthca: Update to use new mmio write barriers
Date: Thu, 16 Feb 2017 12:23:05 -0700
Message-ID: <1487272989-8215-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

- The barrier after set_ci_db is upgraded to wc_wmb()
- The barrier in mthca_write_db_rec is switched to wc_wmb()

I am guessing that these two locations are trying to strongly order
writes, but I suspect barriers are missing in this driver it doesn't
really make too much sense..

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mthca/cq.c       | 10 +++++-----
 providers/mthca/doorbell.h |  2 +-
 providers/mthca/qp.c       | 20 +++++++++++---------
 providers/mthca/srq.c      |  6 +++---
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/providers/mthca/cq.c b/providers/mthca/cq.c
index aa08e065f2757b..f41b3750f37746 100644
--- a/providers/mthca/cq.c
+++ b/providers/mthca/cq.c
@@ -152,7 +152,7 @@ static inline void update_cons_index(struct mthca_cq *cq, int incr)
 
 	if (mthca_is_memfree(cq->ibv_cq.context)) {
 		*cq->set_ci_db = htonl(cq->cons_index);
-		wmb();
+		mmio_ordered_writes_hack();
 	} else {
 		doorbell[0] = htonl(MTHCA_TAVOR_CQ_DB_INC_CI | cq->cqn);
 		doorbell[1] = htonl(incr - 1);
@@ -310,7 +310,7 @@ static inline int mthca_poll_one(struct mthca_cq *cq,
 	 * Make sure we read CQ entry contents after we've checked the
 	 * ownership bit.
 	 */
-	rmb();
+	udma_from_device_barrier();
 
 	qpn = ntohl(cqe->my_qpn);
 
@@ -472,7 +472,7 @@ int mthca_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	}
 
 	if (freed) {
-		wmb();
+		udma_to_device_barrier();
 		update_cons_index(cq, freed);
 	}
 
@@ -516,7 +516,7 @@ int mthca_arbel_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 * Make sure that the doorbell record in host memory is
 	 * written before ringing the doorbell via PCI MMIO.
 	 */
-	wmb();
+	udma_to_device_barrier();
 
 	doorbell[0] = htonl((sn << 28)                       |
 			    (solicited ?
@@ -582,7 +582,7 @@ void __mthca_cq_clean(struct mthca_cq *cq, uint32_t qpn, struct mthca_srq *srq)
 	if (nfreed) {
 		for (i = 0; i < nfreed; ++i)
 			set_cqe_hw(get_cqe(cq, (cq->cons_index + i) & cq->ibv_cq.cqe));
-		wmb();
+		udma_to_device_barrier();
 		cq->cons_index += nfreed;
 		update_cons_index(cq, nfreed);
 	}
diff --git a/providers/mthca/doorbell.h b/providers/mthca/doorbell.h
index a3aa42a9c8ba27..0f5a67e0ac7a63 100644
--- a/providers/mthca/doorbell.h
+++ b/providers/mthca/doorbell.h
@@ -98,7 +98,7 @@ static inline void mthca_write64(uint32_t val[2], struct mthca_context *ctx, int
 static inline void mthca_write_db_rec(uint32_t val[2], uint32_t *db)
 {
 	*(volatile uint32_t *) db       = val[0];
-	mb();
+	mmio_ordered_writes_hack();
 	*(volatile uint32_t *) (db + 1) = val[1];
 }
 
diff --git a/providers/mthca/qp.c b/providers/mthca/qp.c
index d221bb19bfa67c..c6a22372c7d809 100644
--- a/providers/mthca/qp.c
+++ b/providers/mthca/qp.c
@@ -112,6 +112,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	uint32_t uninitialized_var(op0);
 
 	pthread_spin_lock(&qp->sq.lock);
+	udma_to_device_barrier();
 
 	ind = qp->sq.next_ind;
 
@@ -287,7 +288,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		/*
 		 * Make sure that nda_op is written before setting ee_nds.
 		 */
-		wmb();
+		udma_ordering_write_barrier();
 		((struct mthca_next_seg *) prev_wqe)->ee_nds =
 			htonl((size0 ? 0 : MTHCA_NEXT_DBD) | size |
 			((wr->send_flags & IBV_SEND_FENCE) ?
@@ -313,6 +314,7 @@ out:
 				     qp->send_wqe_offset) | f0 | op0);
 		doorbell[1] = htonl((ibqp->qp_num << 8) | size0);
 
+		udma_to_device_barrier();
 		mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_SEND_DOORBELL);
 	}
 
@@ -400,7 +402,7 @@ int mthca_tavor_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			 * Make sure that descriptors are written
 			 * before doorbell is rung.
 			 */
-			wmb();
+			udma_to_device_barrier();
 
 			mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_RECV_DOORBELL);
 
@@ -419,7 +421,7 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell is rung.
 		 */
-		wmb();
+		udma_to_device_barrier();
 
 		mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_RECV_DOORBELL);
 	}
@@ -466,14 +468,14 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			 * Make sure that descriptors are written before
 			 * doorbell record.
 			 */
-			wmb();
+			udma_to_device_barrier();
 			*qp->sq.db = htonl(qp->sq.head & 0xffff);
 
 			/*
 			 * Make sure doorbell record is written before we
 			 * write MMIO send doorbell.
 			 */
-			wmb();
+			mmio_ordered_writes_hack();
 			mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_SEND_DOORBELL);
 
 			size0 = 0;
@@ -643,7 +645,7 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			htonl(((ind << qp->sq.wqe_shift) +
 			       qp->send_wqe_offset) |
 			      mthca_opcode[wr->opcode]);
-		wmb();
+		udma_ordering_write_barrier();
 		((struct mthca_next_seg *) prev_wqe)->ee_nds =
 			htonl(MTHCA_NEXT_DBD | size |
 			      ((wr->send_flags & IBV_SEND_FENCE) ?
@@ -674,14 +676,14 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
 		*qp->sq.db = htonl(qp->sq.head & 0xffff);
 
 		/*
 		 * Make sure doorbell record is written before we
 		 * write MMIO send doorbell.
 		 */
-		wmb();
+		mmio_ordered_writes_hack();
 		mthca_write64(doorbell, to_mctx(ibqp->context), MTHCA_SEND_DOORBELL);
 	}
 
@@ -754,7 +756,7 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
 		*qp->rq.db = htonl(qp->rq.head & 0xffff);
 	}
 
diff --git a/providers/mthca/srq.c b/providers/mthca/srq.c
index 66ac924a720c84..95b79020fc6a62 100644
--- a/providers/mthca/srq.c
+++ b/providers/mthca/srq.c
@@ -152,7 +152,7 @@ int mthca_tavor_post_srq_recv(struct ibv_srq *ibsrq,
 			 * Make sure that descriptors are written
 			 * before doorbell is rung.
 			 */
-			wmb();
+			udma_to_device_barrier();
 
 			mthca_write64(doorbell, to_mctx(ibsrq->context), MTHCA_RECV_DOORBELL);
 
@@ -168,7 +168,7 @@ int mthca_tavor_post_srq_recv(struct ibv_srq *ibsrq,
 		 * Make sure that descriptors are written before
 		 * doorbell is rung.
 		 */
-		wmb();
+		udma_to_device_barrier();
 
 		mthca_write64(doorbell, to_mctx(ibsrq->context), MTHCA_RECV_DOORBELL);
 	}
@@ -240,7 +240,7 @@ int mthca_arbel_post_srq_recv(struct ibv_srq *ibsrq,
 		 * Make sure that descriptors are written before
 		 * we write doorbell record.
 		 */
-		wmb();
+		udma_ordering_write_barrier();
 		*srq->db = htonl(srq->counter);
 	}
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
