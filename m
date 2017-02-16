From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 08/14] mlx5: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:23:03 -0700
Message-ID: <1487272989-8215-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The mlx5 comments are good so these translate fairly directly.

There is one barrier in mlx5_arm_cq that I could not explain, it became
mmio_ordered_writes_hack()

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx5/cq.c  |  8 ++++----
 providers/mlx5/qp.c  | 18 +++++++++++-------
 providers/mlx5/srq.c |  2 +-
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 372e40bc2b6589..cc0af920c703d9 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -489,7 +489,7 @@ static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
 	 * Make sure we read CQ entry contents after we've checked the
 	 * ownership bit.
 	 */
-	rmb();
+	udma_from_device_barrier();
 
 #ifdef MLX5_DEBUG
 	{
@@ -1283,14 +1283,14 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 * Make sure that the doorbell record in host memory is
 	 * written before ringing the doorbell via PCI MMIO.
 	 */
-	wmb();
+	udma_to_device_barrier();
 
 	doorbell[0] = htonl(sn << 28 | cmd | ci);
 	doorbell[1] = htonl(cq->cqn);
 
 	mlx5_write64(doorbell, ctx->uar[0] + MLX5_CQ_DOORBELL, &ctx->lock32);
 
-	wc_wmb();
+	mmio_ordered_writes_hack();
 
 	return 0;
 }
@@ -1395,7 +1395,7 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 		 * Make sure update of buffer contents is done before
 		 * updating consumer index.
 		 */
-		wmb();
+		udma_to_device_barrier();
 		update_cons_index(cq);
 	}
 }
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index b9ae72c9827c8c..d7087d986ce79f 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -926,10 +926,13 @@ out:
 		 * Make sure that descriptors are written before
 		 * updating doorbell record and ringing the doorbell
 		 */
-		wmb();
+		udma_to_device_barrier();
 		qp->db[MLX5_SND_DBR] = htonl(qp->sq.cur_post & 0xffff);
 
-		wc_wmb();
+		/* Make sure that the doorbell write happens before the memcpy
+		 * to WC memory below */
+		mmio_wc_start();
+
 		ctx = to_mctx(ibqp->context);
 		if (bf->need_lock)
 			mlx5_spin_lock(&bf->lock);
@@ -944,15 +947,15 @@ out:
 				     &ctx->lock32);
 
 		/*
-		 * use wc_wmb() to ensure write combining buffers are flushed out
+		 * use mmio_flush_writes() to ensure write combining buffers are flushed out
 		 * of the running CPU. This must be carried inside the spinlock.
 		 * Otherwise, there is a potential race. In the race, CPU A
 		 * writes doorbell 1, which is waiting in the WC buffer. CPU B
 		 * writes doorbell 2, and it's write is flushed earlier. Since
-		 * the wc_wmb is CPU local, this will result in the HCA seeing
+		 * the mmio_flush_writes is CPU local, this will result in the HCA seeing
 		 * doorbell 2, followed by doorbell 1.
 		 */
-		wc_wmb();
+		mmio_flush_writes();
 		bf->offset ^= bf->buf_size;
 		if (bf->need_lock)
 			mlx5_spin_unlock(&bf->lock);
@@ -1119,7 +1122,7 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
 		*(rwq->recv_db) = htonl(rwq->rq.head & 0xffff);
 	}
 
@@ -1193,7 +1196,8 @@ out:
 		 * Make sure that descriptors are written before
 		 * doorbell record.
 		 */
-		wmb();
+		udma_to_device_barrier();
+
 		/*
 		 * For Raw Packet QP, avoid updating the doorbell record
 		 * as long as the QP isn't in RTR state, to avoid receiving
diff --git a/providers/mlx5/srq.c b/providers/mlx5/srq.c
index b6e1eaf26bbd0c..2c71730a40f875 100644
--- a/providers/mlx5/srq.c
+++ b/providers/mlx5/srq.c
@@ -137,7 +137,7 @@ int mlx5_post_srq_recv(struct ibv_srq *ibsrq,
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
