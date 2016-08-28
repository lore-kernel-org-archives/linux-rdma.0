From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 6/9] IB/mlx5: Simplify code by removing return variable
Date: Sun, 28 Aug 2016 10:58:35 +0300
Message-ID: <1472371118-8260-7-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Return variable was set in a line before the
actual return was called in begin_wqe function.

This patch removes such variable and simplifies the code.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index acb3b72..174d09b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3658,12 +3658,8 @@ static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
 		     struct ib_send_wr *wr, unsigned *idx,
 		     int *size, int nreq)
 {
-	int err = 0;
-
-	if (unlikely(mlx5_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq))) {
-		err = -ENOMEM;
-		return err;
-	}
+	if (unlikely(mlx5_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq)))
+		return -ENOMEM;

 	*idx = qp->sq.cur_post & (qp->sq.wqe_cnt - 1);
 	*seg = mlx5_get_send_wqe(qp, *idx);
@@ -3679,7 +3675,7 @@ static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
 	*seg += sizeof(**ctrl);
 	*size = sizeof(**ctrl) / 16;

-	return err;
+	return 0;
 }

 static void finish_wqe(struct mlx5_ib_qp *qp,
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
