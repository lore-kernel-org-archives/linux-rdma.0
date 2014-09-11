From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/5] IB/mlx4: Fix VF mac handling in RoCE
Date: Thu, 11 Sep 2014 14:11:20 +0300
Message-ID: <1410433880-12439-6-git-send-email-ogerlitz@mellanox.com>
References: <1410433880-12439-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410433880-12439-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

We had several problems here. First, a race condition on QP1 mac
handling between mlx4_ib_update_qps and mlx4_ib_modify_qp, which
is fixed by taking the qp mutex in mlx4_ib_update_qps.

Also, qp->pri.smac_port was not updated in mlx4_ib_update_qps.

Last, in __mlx4_ib_modify_qp we did not properly handle the case
where the mac is zero, but port is non-zero.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   15 ++++++++++-----
 drivers/infiniband/hw/mlx4/qp.c   |   16 ++++++++++------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d4dd930..d464bb1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1664,9 +1664,11 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 	qp = ibdev->qp1_proxy[port - 1];
 	if (qp) {
 		int new_smac_index;
-		u64 old_smac = qp->pri.smac;
+		u64 old_smac;
 		struct mlx4_update_qp_params update_params;
 
+		mutex_lock(&qp->mutex);
+		old_smac = qp->pri.smac;
 		if (new_smac == old_smac)
 			goto unlock;
 
@@ -1681,17 +1683,20 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 			release_mac = new_smac;
 			goto unlock;
 		}
-
+		/* if old port was zero, no mac was yet registered for this QP */
+		if (qp->pri.smac_port)
+			release_mac = old_smac;
 		qp->pri.smac = new_smac;
+		qp->pri.smac_port = port;
 		qp->pri.smac_index = new_smac_index;
-
-		release_mac = old_smac;
 	}
 
 unlock:
-	mutex_unlock(&ibdev->qp1_proxy_lock[port - 1]);
 	if (release_mac != MLX4_IB_INVALID_MAC)
 		mlx4_unregister_mac(ibdev->dev, port, release_mac);
+	if (qp)
+		mutex_unlock(&qp->mutex);
+	mutex_unlock(&ibdev->qp1_proxy_lock[port - 1]);
 }
 
 static void mlx4_ib_get_dev_addr(struct net_device *dev,
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 393423c..577b477 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -964,9 +964,10 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 				   MLX4_QP_STATE_RST, NULL, 0, 0, &qp->mqp))
 			pr_warn("modify QP %06x to RESET failed.\n",
 			       qp->mqp.qpn);
-		if (qp->pri.smac) {
+		if (qp->pri.smac || (!qp->pri.smac && qp->pri.smac_port)) {
 			mlx4_unregister_mac(dev->dev, qp->pri.smac_port, qp->pri.smac);
 			qp->pri.smac = 0;
+			qp->pri.smac_port = 0;
 		}
 		if (qp->alt.smac) {
 			mlx4_unregister_mac(dev->dev, qp->alt.smac_port, qp->alt.smac);
@@ -1325,7 +1326,8 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		 * If one was already assigned, but the new mac differs,
 		 * unregister the old one and register the new one.
 		*/
-		if (!smac_info->smac || smac_info->smac != smac) {
+		if ((!smac_info->smac && !smac_info->smac_port) ||
+		    smac_info->smac != smac) {
 			/* register candidate now, unreg if needed, after success */
 			smac_index = mlx4_register_mac(dev->dev, port, smac);
 			if (smac_index >= 0) {
@@ -1396,7 +1398,7 @@ static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *
 	u64_mac = atomic64_read(&dev->iboe.mac[qp->port - 1]);
 
 	context->pri_path.sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE | ((qp->port - 1) << 6);
-	if (!qp->pri.smac) {
+	if (!qp->pri.smac && !qp->pri.smac_port) {
 		smac_index = mlx4_register_mac(dev->dev, qp->port, u64_mac);
 		if (smac_index >= 0) {
 			qp->pri.candidate_smac_index = smac_index;
@@ -1778,9 +1780,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			if (qp->flags & MLX4_IB_QP_NETIF)
 				mlx4_ib_steer_qp_reg(dev, qp, 0);
 		}
-		if (qp->pri.smac) {
+		if (qp->pri.smac || (!qp->pri.smac && qp->pri.smac_port)) {
 			mlx4_unregister_mac(dev->dev, qp->pri.smac_port, qp->pri.smac);
 			qp->pri.smac = 0;
+			qp->pri.smac_port = 0;
 		}
 		if (qp->alt.smac) {
 			mlx4_unregister_mac(dev->dev, qp->alt.smac_port, qp->alt.smac);
@@ -1804,11 +1807,12 @@ out:
 	if (err && steer_qp)
 		mlx4_ib_steer_qp_reg(dev, qp, 0);
 	kfree(context);
-	if (qp->pri.candidate_smac) {
+	if (qp->pri.candidate_smac ||
+	    (!qp->pri.candidate_smac && qp->pri.candidate_smac_port)) {
 		if (err) {
 			mlx4_unregister_mac(dev->dev, qp->pri.candidate_smac_port, qp->pri.candidate_smac);
 		} else {
-			if (qp->pri.smac)
+			if (qp->pri.smac || (!qp->pri.smac && qp->pri.smac_port))
 				mlx4_unregister_mac(dev->dev, qp->pri.smac_port, qp->pri.smac);
 			qp->pri.smac = qp->pri.candidate_smac;
 			qp->pri.smac_index = qp->pri.candidate_smac_index;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
