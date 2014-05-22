From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/5] IB/mlx5: Set QP offsets and parameters for user QPs and not just for kernel QPs
Date: Thu, 22 May 2014 14:50:11 +0300
Message-ID: <1400759412-13205-5-git-send-email-haggaie@mellanox.com>
References: <1400759412-13205-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400759412-13205-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For user QPs, the creation process does not currently initialize the fields:
* qp->rq.offset
* qp->sq.offset
* qp->sq.wqe_shift

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index a89f704..d13ddf1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -574,6 +574,10 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	uar_index = uuarn_to_uar_index(&context->uuari, uuarn);
 	mlx5_ib_dbg(dev, "uuarn 0x%x, uar_index 0x%x\n", uuarn, uar_index);
 
+	qp->rq.offset = 0;
+	qp->sq.wqe_shift = ilog2(MLX5_SEND_WQE_BB);
+	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+
 	err = set_user_buf_size(dev, qp, &ucmd);
 	if (err)
 		goto err_uuar;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
