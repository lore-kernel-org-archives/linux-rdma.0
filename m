From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx5: Fix mlx5_set_path for Raw Packet QP
Date: Sun,  3 Jul 2016 15:42:07 +0300
Message-ID: <1467549727-23479-4-git-send-email-leon@kernel.org>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467549727-23479-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

mlx5_set_path returns error when called without GRH in Ethernet
link layer. Since this is not mandatory for Raw Packet QP, it
shouldn't fail in this case.

Added additional check of QP type to make the decision.

Fixes: 2811ba51b049 ('IB/mlx5: Add RoCE fields to Address Vector')
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e9b3a1f..fbd94a9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2175,7 +2175,8 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
-		if (!(ah->ah_flags & IB_AH_GRH))
+		if (!(ah->ah_flags & IB_AH_GRH) &&
+		    (qp->ibqp.qp_type != IB_QPT_RAW_PACKET))
 			return -EINVAL;
 		memcpy(path->rmac, ah->dmac, sizeof(ah->dmac));
 		path->udp_sport = mlx5_get_roce_udp_sport(dev, port,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
