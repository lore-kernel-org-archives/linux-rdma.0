From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 16/23] IB/mlx4: Fix RSS QP type in creation verb
Date: Tue, 15 Aug 2017 11:54:45 +0300
Message-ID: <20170815085452.3546-17-leon@kernel.org>
References: <20170815085452.3546-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085452.3546-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 was designed to support QP type of MLX4_IB_QPT_RAW_PACKET.

Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 793d77f29d3e..603a0bf49576 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -749,7 +749,7 @@ static int create_qp_rss(struct mlx4_ib_dev *dev, struct ib_pd *ibpd,
 	INIT_LIST_HEAD(&qp->gid_list);
 	INIT_LIST_HEAD(&qp->steering_rules);
 
-	qp->mlx4_ib_qp_type = MLX4_IB_QPT_RAW_ETHERTYPE;
+	qp->mlx4_ib_qp_type = MLX4_IB_QPT_RAW_PACKET;
 	qp->state = IB_QPS_RESET;
 
 	/* Set dummy send resources to be compatible with HV and PRM */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
