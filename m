From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Fix return value of mlx5_post_recv/srq_recv to be aligned with man page
Date: Wed, 10 Aug 2016 15:09:16 +0300
Message-ID: <1470830956-7832-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix return code upon an error to be errno instead of -1, no reason to touch
errno internally.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/qp.c  | 6 ++----
 src/srq.c | 4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 12191be..86b23c9 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -982,16 +982,14 @@ int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (unlikely(mlx5_wq_overflow(&qp->rq, nreq,
 					      to_mcq(qp->ibv_qp->recv_cq)))) {
-			errno = ENOMEM;
+			err = ENOMEM;
 			*bad_wr = wr;
-			err = -1;
 			goto out;
 		}
 
 		if (unlikely(wr->num_sge > qp->rq.max_gs)) {
-			errno = EINVAL;
+			err = EINVAL;
 			*bad_wr = wr;
-			err = -1;
 			goto out;
 		}
 
diff --git a/src/srq.c b/src/srq.c
index ab3df70..dbf53df 100644
--- a/src/srq.c
+++ b/src/srq.c
@@ -101,14 +101,14 @@ int mlx5_post_srq_recv(struct ibv_srq *ibsrq,
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (wr->num_sge > srq->max_gs) {
-			err = -1;
+			err = EINVAL;
 			*bad_wr = wr;
 			break;
 		}
 
 		if (srq->head == srq->tail) {
 			/* SRQ is full*/
-			err = -1;
+			err = ENOMEM;
 			*bad_wr = wr;
 			break;
 		}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
