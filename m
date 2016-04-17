From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/mlx5: Fire the CQ completion handler from tasklet
Date: Sun, 17 Apr 2016 17:08:41 +0300
Message-ID: <1460902121-5567-3-git-send-email-matanb@mellanox.com>
References: <1460902121-5567-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460902121-5567-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously, mlx5_ib_cq_comp was executed from interrupt context.
Under heavy load, this could cause the CPU core to be in an interrupt
context too long.
Instead of executing the handler from the interrupt context we
execute it from a much friendly tasklet context.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index a00ba44..dabcc65 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -879,7 +879,10 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 
 	mlx5_ib_dbg(dev, "cqn 0x%x\n", cq->mcq.cqn);
 	cq->mcq.irqn = irqn;
-	cq->mcq.comp  = mlx5_ib_cq_comp;
+	if (context)
+		cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
+	else
+		cq->mcq.comp  = mlx5_ib_cq_comp;
 	cq->mcq.event = mlx5_ib_cq_event;
 
 	INIT_LIST_HEAD(&cq->wc_list);
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
