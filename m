From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in destroy qp flow
Date: Sun, 27 Nov 2016 15:18:19 +0200
Message-ID: <1480252702-8005-2-git-send-email-leon@kernel.org>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480252702-8005-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

For non-special QPs, the port value becomes non-zero only at the
RESET-to-INIT transition. If the QP has not undergone that transition,
its port number value is still zero.

If such a QP is destroyed before being moved out of the RESET state,
subtracting one from the qp port number results in a negative value.
Using that negative value as an index into the qp1_proxy array
results in an out-of-bounds array reference.

Fix this by testing that the QP type is one that uses qp1_proxy before
using the port number. For special QPs of all types, the port number is
specified at QP creation time.

Fixes: 9433c188915c ("IB/mlx4: Invoke UPDATE_QP for proxy QP1 on MAC changes")
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 570bc86..6973947 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1280,7 +1280,8 @@ static int _mlx4_ib_destroy_qp(struct ib_qp *qp)
 	if (is_qp0(dev, mqp))
 		mlx4_CLOSE_PORT(dev->dev, mqp->port);
 
-	if (dev->qp1_proxy[mqp->port - 1] == mqp) {
+	if (mqp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI &&
+	    dev->qp1_proxy[mqp->port - 1] == mqp) {
 		mutex_lock(&dev->qp1_proxy_lock[mqp->port - 1]);
 		dev->qp1_proxy[mqp->port - 1] = NULL;
 		mutex_unlock(&dev->qp1_proxy_lock[mqp->port - 1]);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
