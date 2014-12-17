From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx4: Fix wrong usage of IPv4 protocol for multicast attach/detach
Date: Wed, 17 Dec 2014 16:17:34 +0200
Message-ID: <1418825854-30022-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MLX4_PROT_IB_IPV4 protocol should only be used with RoCEv2 and such.
Removing this wrong usage allows to run multicast applications over RoCE.

Fixes: d487ee77740c ('IB/mlx4: Use IBoE (RoCE) IP based GIDs in the port GID table')
Reported-by: Carol Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e861330..ea69975 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1221,8 +1221,7 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
 	u64 reg_id;
 	struct mlx4_ib_steering *ib_steering = NULL;
-	enum mlx4_protocol prot = (gid->raw[1] == 0x0e) ?
-		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
+	enum mlx4_protocol prot = MLX4_PROT_IB_IPV6;
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
@@ -1235,8 +1234,10 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 				    !!(mqp->flags &
 				       MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
 				    prot, &reg_id);
-	if (err)
+	if (err) {
+		pr_err("multicast attach op failed, err %d\n", err);
 		goto err_malloc;
+	}
 
 	err = add_gid_entry(ibqp, gid);
 	if (err)
@@ -1284,8 +1285,7 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct net_device *ndev;
 	struct mlx4_ib_gid_entry *ge;
 	u64 reg_id = 0;
-	enum mlx4_protocol prot = (gid->raw[1] == 0x0e) ?
-		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
+	enum mlx4_protocol prot =  MLX4_PROT_IB_IPV6;
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
