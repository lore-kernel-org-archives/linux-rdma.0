From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/mlx4: Fix memory leak in __mlx4_ib_modify_qp
Date: Thu, 29 Jan 2015 10:41:41 +0200
Message-ID: <1422520903-22007-2-git-send-email-ogerlitz@mellanox.com>
References: <1422520903-22007-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422520903-22007-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case handle_eth_ud_smac_index fails, we need to free the allocated resources.

Fixes: 2f5bb473 ('mlx4: Add ref counting to port MAC table for RoCE')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index cf000b7..c880329 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1674,8 +1674,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI ||
 			    qp->mlx4_ib_qp_type == MLX4_IB_QPT_TUN_GSI) {
 				err = handle_eth_ud_smac_index(dev, qp, (u8 *)attr->smac, context);
-				if (err)
-					return -EINVAL;
+				if (err) {
+					err = -EINVAL;
+					goto out;
+				}
 				if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI)
 					dev->qp1_proxy[qp->port - 1] = qp;
 			}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
