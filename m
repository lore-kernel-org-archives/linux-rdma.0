From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/4] IB/mlx4: Fix potential deadlock when sending mad to wire
Date: Thu, 30 Jul 2015 17:34:21 +0300
Message-ID: <1438266864-3584-2-git-send-email-ogerlitz@mellanox.com>
References: <1438266864-3584-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438266864-3584-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

send_mad_to_wire takes the same spinlock that is taken in
the interrupt context.  Therefore, it needs irqsave/restore.

Fixes: b9c5d6a64358 ('IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV')
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index ed327e6..a0559a8 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -206,15 +206,16 @@ static int send_mad_to_wire(struct mlx4_ib_demux_ctx *ctx, struct ib_mad *mad)
 {
 	struct mlx4_ib_dev *dev = ctx->dev;
 	struct ib_ah_attr	ah_attr;
+	unsigned long flags;
 
-	spin_lock(&dev->sm_lock);
+	spin_lock_irqsave(&dev->sm_lock, flags);
 	if (!dev->sm_ah[ctx->port - 1]) {
 		/* port is not yet Active, sm_ah not ready */
-		spin_unlock(&dev->sm_lock);
+		spin_unlock_irqrestore(&dev->sm_lock, flags);
 		return -EAGAIN;
 	}
 	mlx4_ib_query_ah(dev->sm_ah[ctx->port - 1], &ah_attr);
-	spin_unlock(&dev->sm_lock);
+	spin_unlock_irqrestore(&dev->sm_lock, flags);
 	return mlx4_ib_send_to_wire(dev, mlx4_master_func_num(dev->dev),
 				    ctx->port, IB_QPT_GSI, 0, 1, IB_QP1_QKEY,
 				    &ah_attr, NULL, mad);
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
