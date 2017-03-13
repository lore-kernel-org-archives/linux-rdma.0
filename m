From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/3] mlx4: Optimize post_send barriers
Date: Mon, 13 Mar 2017 16:53:48 +0200
Message-ID: <1489416829-15467-3-git-send-email-yishaih@mellanox.com>
References: <1489416829-15467-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489416829-15467-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch optimize current implementation as follow:
- Drop the leading barrier which affects non X86 ARCH(s)
  till making further optimization to prevent performance
  degradation.
- In ARCH(s) that spinlock() serves also as SFENCE prevent
  an another explicit SFENCE. (e.g. X86).

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/qp.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index e9a59f9..a8eb8e2 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -203,7 +203,7 @@ static void set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ibv_sge *sg)
 	 * chunk and get a valid (!= * 0xffffffff) byte count but
 	 * stale data, and end up sending the wrong data.
 	 */
-	udma_ordering_write_barrier();
+	udma_to_device_barrier();
 
 	if (likely(sg->length))
 		dseg->byte_count = htobe32(sg->length);
@@ -227,9 +227,6 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 	pthread_spin_lock(&qp->sq.lock);
 
-	/* Get all user DMA buffers ready to go */
-	udma_to_device_barrier();
-
 	/* XXX check that state is OK to post send */
 
 	ind = qp->sq.head;
@@ -402,7 +399,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 					wqe += to_copy;
 					addr += to_copy;
 					seg_len += to_copy;
-					udma_ordering_write_barrier(); /* see comment below */
+					udma_to_device_barrier(); /* see comment below */
 					seg->byte_count = htobe32(MLX4_INLINE_SEG | seg_len);
 					seg_len = 0;
 					seg = wqe;
@@ -430,7 +427,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				 * data, and end up sending the wrong
 				 * data.
 				 */
-				udma_ordering_write_barrier();
+				udma_to_device_barrier();
 				seg->byte_count = htobe32(MLX4_INLINE_SEG | seg_len);
 			}
 
@@ -452,7 +449,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		 * setting ownership bit (because HW can start
 		 * executing as soon as we do).
 		 */
-		udma_ordering_write_barrier();
+		udma_to_device_barrier();
 
 		ctrl->owner_opcode = htobe32(mlx4_ib_opcode[wr->opcode]) |
 			(ind & qp->sq.wqe_cnt ? htobe32(1 << 31) : 0);
@@ -476,18 +473,16 @@ out:
 		ctrl->owner_opcode |= htobe32((qp->sq.head & 0xffff) << 8);
 
 		ctrl->bf_qpn |= qp->doorbell_qpn;
+		++qp->sq.head;
 		/*
 		 * Make sure that descriptor is written to memory
 		 * before writing to BlueFlame page.
 		 */
-		mmio_wc_start();
-
-		++qp->sq.head;
-
-		pthread_spin_lock(&ctx->bf_lock);
+		mmio_wc_spinlock(&ctx->bf_lock);
 
 		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
 			     align(size * 16, 64));
+		/* Flush before toggling bf_offset to be latency oriented */
 		mmio_flush_writes();
 
 		ctx->bf_offset ^= ctx->bf_buf_size;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
