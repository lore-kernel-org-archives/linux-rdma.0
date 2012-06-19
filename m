From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 26/29] net/mlx4_core: INIT/CLOSE port logic for IB ports in SRIOV mode
Date: Tue, 19 Jun 2012 11:21:58 +0300
Message-ID: <1340094121-14858-27-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Normally, INIT_PORT and CLOSE_PORT are invoked when special QP0
transitions to RTR, or transitions to ERR/RESET respectively.

In SRIOV mode, however, the master is also paravirtualized.
This in turn requires that we not do INIT_PORT until the
entire QP0 path (real QP0 and proxy QP0) is ready to receive.
When the real QP0 goes down, we indicate that the port is not active.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |   71 +++++++++++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx4/qp.c |   38 +++++++++++++++--
 2 files changed, 92 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 5d19750..d72595f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1316,6 +1316,19 @@ out:
 	return err;
 }
 
+/* for IB-type ports only in SRIOV mode. Checks that both proxy QP0
+ * and real QP0 are active, so that the paravirtualized QP0 is ready
+ * to operate */
+static int check_qp0_state(struct mlx4_dev *dev, int function, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	/* irrelevant if not infiniband */
+	if (priv->mfunc.master.qp0_state[port].proxy_qp0_active &&
+	    priv->mfunc.master.qp0_state[port].qp0_active)
+		return 1;
+	return 0;
+}
+
 int mlx4_INIT_PORT_wrapper(struct mlx4_dev *dev, int slave,
 			   struct mlx4_vhcr *vhcr,
 			   struct mlx4_cmd_mailbox *inbox,
@@ -1332,14 +1345,29 @@ int mlx4_INIT_PORT_wrapper(struct mlx4_dev *dev, int slave,
 	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_IB)
 		return -ENODEV;
 
-	/* Enable port only if it was previously disabled */
-	if (!priv->mfunc.master.init_port_ref[port]) {
-		err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_INIT_PORT,
-			       MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
-		if (err)
-			return err;
+	if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB) {
+		/* Enable port only if it was previously disabled */
+		if (!priv->mfunc.master.init_port_ref[port]) {
+			err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_INIT_PORT,
+				       MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
+			if (err)
+				return err;
+		}
+		priv->mfunc.master.slave_state[slave].init_port_mask |= (1 << port);
+	} else {
+		if (slave == mlx4_master_func_num(dev)) {
+			if (check_qp0_state(dev, slave, port) &&
+			    !priv->mfunc.master.qp0_state[port].port_active) {
+				err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_INIT_PORT,
+					       MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
+				if (err)
+					return err;
+				priv->mfunc.master.qp0_state[port].port_active = 1;
+				priv->mfunc.master.slave_state[slave].init_port_mask |= (1 << port);
+			}
+		} else
+			priv->mfunc.master.slave_state[slave].init_port_mask |= (1 << port);
 	}
-	priv->mfunc.master.slave_state[slave].init_port_mask |= (1 << port);
 	++priv->mfunc.master.init_port_ref[port];
 	return 0;
 }
@@ -1414,13 +1442,30 @@ int mlx4_CLOSE_PORT_wrapper(struct mlx4_dev *dev, int slave,
 
 	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_IB)
 		return -ENODEV;
-	if (priv->mfunc.master.init_port_ref[port] == 1) {
-		err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT, 1000,
-			       MLX4_CMD_NATIVE);
-		if (err)
-			return err;
+
+	if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB) {
+		if (priv->mfunc.master.init_port_ref[port] == 1) {
+			err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT,
+				       1000, MLX4_CMD_NATIVE);
+			if (err)
+				return err;
+		}
+		priv->mfunc.master.slave_state[slave].init_port_mask &= ~(1 << port);
+	} else {
+		/* infiniband port */
+		if (slave == mlx4_master_func_num(dev)) {
+			if (!priv->mfunc.master.qp0_state[port].qp0_active &&
+			    priv->mfunc.master.qp0_state[port].port_active) {
+				err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT,
+					       1000, MLX4_CMD_NATIVE);
+				if (err)
+					return err;
+				priv->mfunc.master.slave_state[slave].init_port_mask &= ~(1 << port);
+				priv->mfunc.master.qp0_state[port].port_active = 0;
+			}
+		} else
+			priv->mfunc.master.slave_state[slave].init_port_mask &= ~(1 << port);
 	}
-	priv->mfunc.master.slave_state[slave].init_port_mask &= ~(1 << port);
 	--priv->mfunc.master.init_port_ref[port];
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index b8da72b..436ef6c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -67,10 +67,18 @@ void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
 		complete(&qp->free);
 }
 
-static int is_qp0(struct mlx4_dev *dev, struct mlx4_qp *qp)
+/* used for INIT/CLOSE port logic */
+static int is_qp0(struct mlx4_dev *dev, struct mlx4_qp *qp, int *real_qp0, int *proxy_qp0)
 {
-	return qp->qpn >= dev->caps.sqp_start &&
+	/* qp0 is either the proxy qp0, or the real qp0 */
+	*proxy_qp0 = qp->qpn >= dev->caps.sqp_start &&
 		qp->qpn <= dev->caps.sqp_start + 1;
+
+	*real_qp0 = mlx4_is_master(dev) &&
+		qp->qpn >= dev->caps.base_sqpn &&
+		qp->qpn <= dev->caps.base_sqpn + 1;
+
+	return *real_qp0 || *proxy_qp0;
 }
 
 static int __mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
@@ -122,6 +130,8 @@ static int __mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
 	int ret = 0;
+	int real_qp0 = 0;
+	int proxy_qp0 = 0;
 	u8 port;
 
 	if (cur_state >= MLX4_QP_NUM_STATE || new_state >= MLX4_QP_NUM_STATE ||
@@ -133,9 +143,12 @@ static int __mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 			MLX4_CMD_2RST_QP, MLX4_CMD_TIME_CLASS_A, native);
 		if (mlx4_is_master(dev) && cur_state != MLX4_QP_STATE_ERR &&
 		    cur_state != MLX4_QP_STATE_RST &&
-		    is_qp0(dev, qp)) {
+		    is_qp0(dev, qp, &real_qp0, &proxy_qp0)) {
 			port = (qp->qpn & 1) + 1;
-			priv->mfunc.master.qp0_state[port].qp0_active = 0;
+			if (proxy_qp0)
+				priv->mfunc.master.qp0_state[port].proxy_qp0_active = 0;
+			else
+				priv->mfunc.master.qp0_state[port].qp0_active = 0;
 		}
 		return ret;
 	}
@@ -162,6 +175,23 @@ static int __mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 		       new_state == MLX4_QP_STATE_RST ? 2 : 0,
 		       op[cur_state][new_state], MLX4_CMD_TIME_CLASS_C, native);
 
+	if (mlx4_is_master(dev) && is_qp0(dev, qp, &real_qp0, &proxy_qp0)) {
+		port = (qp->qpn & 1) + 1;
+		if (cur_state != MLX4_QP_STATE_ERR &&
+		    cur_state != MLX4_QP_STATE_RST &&
+		    new_state == MLX4_QP_STATE_ERR) {
+			if (proxy_qp0)
+				priv->mfunc.master.qp0_state[port].proxy_qp0_active = 0;
+			else
+				priv->mfunc.master.qp0_state[port].qp0_active = 0;
+		} else if (new_state == MLX4_QP_STATE_RTR) {
+			if (proxy_qp0)
+				priv->mfunc.master.qp0_state[port].proxy_qp0_active = 1;
+			else
+				priv->mfunc.master.qp0_state[port].qp0_active = 1;
+		}
+	}
+
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return ret;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
