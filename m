From: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 1/1] IB/mlx5: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  1 Jul 2014 21:58:44 +0200
Message-ID: <1404244724-24528-1-git-send-email-fabf@skynet.be>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

use macro definition

Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d13ddf1..e9a3250 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2501,7 +2501,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
 	for (nreq = 0; wr; nreq++, wr = wr->next) {
-		if (unlikely(wr->opcode >= sizeof(mlx5_ib_opcode) / sizeof(mlx5_ib_opcode[0]))) {
+		if (unlikely(wr->opcode >= ARRAY_SIZE(mlx5_ib_opcode))) {
 			mlx5_ib_warn(dev, "\n");
 			err = -EINVAL;
 			*bad_wr = wr;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
