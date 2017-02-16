From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 07/14] mlx4: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:23:02 -0700
Message-ID: <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The mlx4 comments are good so these translate fairly directly.

- Added barrier at the top of mlx4_post_send, this makes the driver
  ready for a change to a stronger udma_to_device_barrier /
  weaker udma_order_write_barrier() which  would make the post loop a bit
  faster. No change on x86-64
- The wmb() directly before the BF copy is upgraded to a wc_wmb(),
  this is consistent with what mlx5 does and makes sense.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/cq.c  |  6 +++---
 providers/mlx4/qp.c  | 19 +++++++++++--------
 providers/mlx4/srq.c |  2 +-
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 6a5cf8be218892..14f8cbce6d75ed 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -222,7 +222,7 @@ static inline int mlx4_get_next_cqe(struct mlx4_cq *cq,
 	 * Make sure we read CQ entry contents after we've checked the
 	 * ownership bit.
 	 */
-	rmb();
+	udma_from_device_barrier();
 
 	*pcqe = cqe;
 
@@ -698,7 +698,7 @@ int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 * Make sure that the doorbell record in host memory is
 	 * written before ringing the doorbell via PCI MMIO.
 	 */
-	wmb();
+	udma_to_device_barrier();
 
 	doorbell[0] = htonl(sn << 28 | cmd | cq->cqn);
 	doorbell[1] = htonl(ci);
@@ -764,7 +764,7 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 		 * Make sure update of buffer contents is done before
 		 * updating consumer index.
 		 */
-		wmb();
+		udma_to_device_barrier();
 		mlx4_update_cons_index(cq);
 	}
 }
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index a607326c7c452c..77a4a34576cb69 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -204,7 +204,7 @@ static void set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ibv_sge *sg)
 	 * chunk and get a valid (!= * 0xffffffff) byte count but
 	 * stale data, and end up sending the wrong data.
 	 */
-	wmb();
+	udma_ordering_write_barrier();
 
 	if (likely(sg->length))
 		dseg->byte_count = htonl(sg->length);
@@ -228,6 +228,9 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 	pthread_spin_lock(&qp->sq.lock);
 
+	/* Get all user DMA buffers ready to go */
+	udma_to_device_barrier();
+
 	/* XXX check that state is OK to post send */
 
 	ind = qp->sq.head;
@@ -400,7 +403,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 					wqe += to_copy;
 					addr += to_copy;
 					seg_len += to_copy;
-					wmb(); /* see comment below */
+					udma_ordering_write_barrier(); /* see comment below */
 					seg->byte_count = htonl(MLX4_INLINE_SEG | seg_len);
 					seg_len = 0;
 					seg = wqe;
@@ -428,7 +431,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				 * data, and end up sending the wrong
 				 * data.
 				 */
-				wmb();
+				udma_ordering_write_barrier();
 				seg->byte_count = htonl(MLX4_INLINE_SEG | seg_len);
 			}
 
@@ -450,7 +453,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		 * setting ownership bit (because HW can start
 		 * executing as soon as we do).
 		 */
-		wmb();
+		udma_ordering_write_barrier();
 
 		ctrl->owner_opcode = htonl(mlx4_ib_opcode[wr->opcode]) |
 			(ind & qp->sq.wqe_cnt ? htonl(1 << 31) : 0);
@@ -478,7 +481,7 @@ out:
 		 * Make sure that descriptor is written to memory
 		 * before writing to BlueFlame page.
 		 */
-		wmb();
+		mmio_wc_start();
 
 		++qp->sq.head;
 
@@ -486,7 +489,7 @@ out:
 
 		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
 			     align(size * 16, 64));
-		wc_wmb();
+		mmio_flush_writes();
 
 		ctx->bf_offset ^= ctx->bf_buf_size;
 
@@ -498,7 +501,7 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
 
 		mmio_writel((unsigned long)(ctx->uar + MLX4_SEND_DOORBELL),
 			    qp->doorbell_qpn);
@@ -566,7 +569,7 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
 
 		*qp->db = htonl(qp->rq.head & 0xffff);
 	}
diff --git a/providers/mlx4/srq.c b/providers/mlx4/srq.c
index 4f90efdf927209..6e4ff5663d019b 100644
--- a/providers/mlx4/srq.c
+++ b/providers/mlx4/srq.c
@@ -113,7 +113,7 @@ int mlx4_post_srq_recv(struct ibv_srq *ibsrq,
 		 * Make sure that descriptors are written before
 		 * we write doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
 
 		*srq->db = htonl(srq->counter);
 	}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
