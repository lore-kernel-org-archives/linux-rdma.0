From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc2 V1 3/5] IB/mlx5: Fix use of null pointer PD
Date: Thu, 28 Jan 2016 17:51:48 +0200
Message-ID: <1453996310-3360-4-git-send-email-matanb@mellanox.com>
References: <1453996310-3360-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453996310-3360-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a Raw Ethernet QP is created, a NULL pointer PD could be used.
Fixing that by only using the PD after validating it's valid.
smatch also reported this error:
drivers/infiniband/hw/mlx5/qp.c:1629 mlx5_ib_create_qp()
	 error: we previously assumed 'pd' could be null (see line 1616)

Fixes: 0fb2ed66a14c ('IB/mlx5: Add create and destroy functionality for Raw Packet QP')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8fb9c27..40bbe96 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1615,15 +1615,6 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 
 	if (pd) {
 		dev = to_mdev(pd->device);
-	} else {
-		/* being cautious here */
-		if (init_attr->qp_type != IB_QPT_XRC_TGT &&
-		    init_attr->qp_type != MLX5_IB_QPT_REG_UMR) {
-			pr_warn("%s: no PD for transport %s\n", __func__,
-				ib_qp_type_str(init_attr->qp_type));
-			return ERR_PTR(-EINVAL);
-		}
-		dev = to_mdev(to_mxrcd(init_attr->xrcd)->ibxrcd.device);
 
 		if (init_attr->qp_type == IB_QPT_RAW_PACKET) {
 			if (!pd->uobject) {
@@ -1634,6 +1625,15 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 				return ERR_PTR(-EINVAL);
 			}
 		}
+	} else {
+		/* being cautious here */
+		if (init_attr->qp_type != IB_QPT_XRC_TGT &&
+		    init_attr->qp_type != MLX5_IB_QPT_REG_UMR) {
+			pr_warn("%s: no PD for transport %s\n", __func__,
+				ib_qp_type_str(init_attr->qp_type));
+			return ERR_PTR(-EINVAL);
+		}
+		dev = to_mdev(to_mxrcd(init_attr->xrcd)->ibxrcd.device);
 	}
 
 	switch (init_attr->qp_type) {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
