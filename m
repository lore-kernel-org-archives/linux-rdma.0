From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 for-next 4/7] net/mlx4_en: Implement mcast loopback prevention for ETH qps
Date: Thu, 15 Oct 2015 14:44:39 +0300
Message-ID: <1444909482-17113-5-git-send-email-eranbe@mellanox.com>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444909482-17113-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set the mcast loopback prevention bit in the QPC for ETH MLX QPs (not
RSS QPs), when the firmware supports this feature. In addition, all rx
ring QPs need to be updated in order not to enforce loopback checks.
This prevents getting packets we sent both from the network stack and
the HCA. Loopback prevention is done by comparing the counter indices of
the sent and receiving QPs. If they're equal, packets aren't
loopback-ed.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_main.c      | 22 ++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/en_resources.c | 25 +++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h      |  3 ++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index a946e4b..005f910 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -123,6 +123,28 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	 */
 	if (mlx4_is_mfunc(priv->mdev->dev) || priv->validate_loopback)
 		priv->flags |= MLX4_EN_FLAG_ENABLE_HW_LOOPBACK;
+
+	mutex_lock(&priv->mdev->state_lock);
+	if (priv->mdev->dev->caps.flags2 &
+	    MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB &&
+	    priv->rss_map.indir_qp.qpn) {
+		int i;
+		int err = 0;
+		int loopback = !!(features & NETIF_F_LOOPBACK);
+
+		for (i = 0; i < priv->rx_ring_num; i++) {
+			int ret;
+
+			ret = mlx4_en_change_mcast_lb(priv,
+						      &priv->rss_map.qps[i],
+						      loopback);
+			if (!err)
+				err = ret;
+		}
+		if (err)
+			mlx4_warn(priv->mdev, "failed to change mcast loopback\n");
+	}
+	mutex_unlock(&priv->mdev->state_lock);
 }
 
 static int mlx4_en_get_profile(struct mlx4_en_dev *mdev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_resources.c b/drivers/net/ethernet/mellanox/mlx4/en_resources.c
index e482fa1b..12aab5a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_resources.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_resources.c
@@ -69,6 +69,15 @@ void mlx4_en_fill_qp_context(struct mlx4_en_priv *priv, int size, int stride,
 	context->pri_path.counter_index = priv->counter_index;
 	context->cqn_send = cpu_to_be32(cqn);
 	context->cqn_recv = cpu_to_be32(cqn);
+	if (!rss &&
+	    (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_LB_SRC_CHK) &&
+	    context->pri_path.counter_index !=
+			    MLX4_SINK_COUNTER_INDEX(mdev->dev)) {
+		/* disable multicast loopback to qp with same counter */
+		if (!(dev->features & NETIF_F_LOOPBACK))
+			context->pri_path.fl |= MLX4_FL_ETH_SRC_CHECK_MC_LB;
+		context->pri_path.control |= MLX4_CTRL_ETH_SRC_CHECK_IF_COUNTER;
+	}
 	context->db_rec_addr = cpu_to_be64(priv->res.db.dma << 2);
 	if (!(dev->features & NETIF_F_HW_VLAN_CTAG_RX))
 		context->param3 |= cpu_to_be32(1 << 30);
@@ -80,6 +89,22 @@ void mlx4_en_fill_qp_context(struct mlx4_en_priv *priv, int size, int stride,
 	}
 }
 
+int mlx4_en_change_mcast_lb(struct mlx4_en_priv *priv, struct mlx4_qp *qp,
+			    int loopback)
+{
+	int ret;
+	struct mlx4_update_qp_params qp_params;
+
+	memset(&qp_params, 0, sizeof(qp_params));
+	if (!loopback)
+		qp_params.flags = MLX4_UPDATE_QP_PARAMS_FLAGS_ETH_CHECK_MC_LB;
+
+	ret = mlx4_update_qp(priv->mdev->dev, qp->qpn,
+			     MLX4_UPDATE_QP_ETH_SRC_CHECK_MC_LB,
+			     &qp_params);
+
+	return ret;
+}
 
 int mlx4_en_map_buffer(struct mlx4_buf *buf)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index defcf8c..c41f151 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -798,7 +798,8 @@ void mlx4_en_fill_qp_context(struct mlx4_en_priv *priv, int size, int stride,
 void mlx4_en_sqp_event(struct mlx4_qp *qp, enum mlx4_event event);
 int mlx4_en_map_buffer(struct mlx4_buf *buf);
 void mlx4_en_unmap_buffer(struct mlx4_buf *buf);
-
+int mlx4_en_change_mcast_lb(struct mlx4_en_priv *priv, struct mlx4_qp *qp,
+			    int loopback);
 void mlx4_en_calc_rx_buf(struct net_device *dev);
 int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv);
 void mlx4_en_release_rss_steer(struct mlx4_en_priv *priv);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
