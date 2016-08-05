From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5] fix err return values to match ibv_post_send expectations
Date: Fri,  5 Aug 2016 13:33:59 -0400
Message-ID: <1470418439-59245-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The man page for ibv_post_send says:

   RETURN VALUE

       ibv_post_send() returns 0 on success, or the value of errno on failure
       (which indicates the failure reason).

QEMU looks for the return value, and in the ENOMEM case, waits and
retries, but with mlx5, it ends up dropping requests and hanging, because
of the unexpected -1 return instead of ENOMEM.

The fix is simple: set err = E<whatever> instead of -1, and eliminate use
of errno = in _mlx5_post_send, just have mlx5_post_send assign the return
from _mlx5_post_send in errno instead. This fix has been confirmed to
resolves the issues seen with QEMU.

Reported-by: Dr. David Alan Gilbert <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Dr. David Alan Gilbert <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/qp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 51e1176..2ad3ac0 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -590,8 +590,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		if (unlikely(wr->opcode < 0 ||
 		    wr->opcode >= sizeof mlx5_ib_opcode / sizeof mlx5_ib_opcode[0])) {
 			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "bad opcode %d\n", wr->opcode);
-			errno = EINVAL;
-			err = -1;
+			err = EINVAL;
 			*bad_wr = wr;
 			goto out;
 		}
@@ -599,8 +598,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq,
 					      to_mcq(qp->ibv_qp->send_cq)))) {
 			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "work queue overflow\n");
-			errno = ENOMEM;
-			err = -1;
+			err = ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
@@ -608,8 +606,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
 			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "max gs exceeded %d (max = %d)\n",
 				 wr->num_sge, qp->sq.max_gs);
-			errno = ENOMEM;
-			err = -1;
+			err = ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
@@ -918,7 +915,8 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	}
 #endif
 
-	return _mlx5_post_send(ibqp, wr, bad_wr);
+	errno = _mlx5_post_send(ibqp, wr, bad_wr);
+	return errno;
 }
 
 int mlx5_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
