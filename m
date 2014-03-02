From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 09/20] IB/mlx5: Set QP offsets and parameters for user QPs and not just for kernel QPs
Date: Sun,  2 Mar 2014 12:49:27 +0200
Message-ID: <1393757378-16412-10-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For user QPs, the creation process does not currently initialize the fields:
* qp->rq.offset
* qp->sq.offset
* qp->sq.wqe_shift

These fields are used for handling page faults to calculate where to read the
faulting WQE from.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index b5cf2c4..335bcbe 100644
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
