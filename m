From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 21/29] net/mlx4_core: Add IB port-state machine, and port mgmt event propagation infrastructure
Date: Tue, 19 Jun 2012 11:21:53 +0300
Message-ID: <1340094121-14858-22-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For an IB port, a slave should not show port active until that
slave has a valid alias-guid (provided by the subnet manager).
Therefore the port-up event should be passed to a slave only after
both the port is up, and the slave's alias-guid has been set.

Also, provide the infrastructure for propagating port-management
events (client-reregister, etc) to slaves.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c   |  237 +++++++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 +
 include/linux/mlx4/device.h               |   28 ++++
 3 files changed, 250 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 9b15d02..5d1de71 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -199,6 +199,196 @@ static void mlx4_slave_event(struct mlx4_dev *dev, int slave,
 	slave_event(dev, slave, eqe);
 }
 
+int mlx4_gen_pkey_eqe(struct mlx4_dev *dev, int slave, u8 port)
+{
+	struct mlx4_eqe eqe;
+
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_state *s_slave = &priv->mfunc.master.slave_state[slave];
+
+	if (!s_slave->active)
+		return 0;
+
+	memset(&eqe, 0, sizeof eqe);
+
+	eqe.type = MLX4_EVENT_TYPE_PORT_MNG_CHG_EVENT;
+	eqe.subtype = MLX4_DEV_PMC_SUBTYPE_PKEY_TABLE;
+	eqe.event.port_mgmt_change.port = port;
+
+	return mlx4_GEN_EQE(dev, slave, &eqe);
+}
+EXPORT_SYMBOL(mlx4_gen_pkey_eqe);
+
+int mlx4_gen_guid_change_eqe(struct mlx4_dev *dev, int slave, u8 port)
+{
+	struct mlx4_eqe eqe;
+
+	/*don't send if we don't have the that slave */
+	if (dev->num_vfs < slave)
+		return 0;
+	memset(&eqe, 0, sizeof eqe);
+
+	eqe.type = MLX4_EVENT_TYPE_PORT_MNG_CHG_EVENT;
+	eqe.subtype = MLX4_DEV_PMC_SUBTYPE_GUID_INFO;
+	eqe.event.port_mgmt_change.port = port;
+
+	return mlx4_GEN_EQE(dev, slave, &eqe);
+}
+EXPORT_SYMBOL(mlx4_gen_guid_change_eqe);
+
+int mlx4_gen_port_state_change_eqe(struct mlx4_dev *dev, int slave, u8 port,
+				   u8 port_subtype_change)
+{
+	struct mlx4_eqe eqe;
+
+	/*don't send if we don't have the that slave */
+	if (dev->num_vfs < slave)
+		return 0;
+	memset(&eqe, 0, sizeof eqe);
+
+	eqe.type = MLX4_EVENT_TYPE_PORT_CHANGE;
+	eqe.subtype = port_subtype_change;
+	eqe.event.port_change.port = cpu_to_be32(port << 28);
+
+	mlx4_dbg(dev, "%s: sending: %d to slave: %d on port: %d\n", __func__,
+		 port_subtype_change, slave, port);
+	return mlx4_GEN_EQE(dev, slave, &eqe);
+}
+EXPORT_SYMBOL(mlx4_gen_port_state_change_eqe);
+
+enum slave_port_state mlx4_get_slave_port_state(struct mlx4_dev *dev, int slave, u8 port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_state *s_state = priv->mfunc.master.slave_state;
+	if (slave >= dev->num_slaves || port > MLX4_MAX_PORTS) {
+		pr_err("%s: Error: asking for slave:%d, port:%d\n",
+		       __func__, slave, port);
+		return SLAVE_PORT_DOWN;
+	}
+	return s_state[slave].port_state[port];
+}
+EXPORT_SYMBOL(mlx4_get_slave_port_state);
+
+static int mlx4_set_slave_port_state(struct mlx4_dev *dev, int slave, u8 port,
+				     enum slave_port_state state)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_state *s_state = priv->mfunc.master.slave_state;
+
+	if (slave >= dev->num_slaves || port > MLX4_MAX_PORTS || port == 0) {
+		pr_err("%s: Error: asking for slave:%d, port:%d\n",
+		       __func__, slave, port);
+		return -1;
+	}
+	s_state[slave].port_state[port] = state;
+
+	return 0;
+}
+
+static void set_all_slave_state(struct mlx4_dev *dev, u8 port, int event)
+{
+	int i;
+	enum slave_port_gen_event gen_event;
+
+	for (i = 0; i < dev->num_slaves; i++)
+		set_and_calc_slave_port_state(dev, i, port, event, &gen_event);
+}
+/**************************************************************************
+	The function get as input the new event to that port,
+	and according to the prev state change the slave's port state.
+	The events are:
+		MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN,
+		MLX4_PORT_STATE_DEV_EVENT_PORT_UP
+		MLX4_PORT_STATE_IB_EVENT_GID_VALID
+		MLX4_PORT_STATE_IB_EVENT_GID_INVALID
+***************************************************************************/
+int set_and_calc_slave_port_state(struct mlx4_dev *dev, int slave,
+				  u8 port, int event,
+				  enum slave_port_gen_event *gen_event)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_slave_state *ctx = NULL;
+	unsigned long flags;
+	int ret = -1;
+	enum slave_port_state cur_state =
+		mlx4_get_slave_port_state(dev, slave, port);
+
+	*gen_event = SLAVE_PORT_GEN_EVENT_NONE;
+
+	if (slave >= dev->num_slaves || port > MLX4_MAX_PORTS || port == 0) {
+		pr_err("%s: Error: asking for slave:%d, port:%d\n",
+		       __func__, slave, port);
+		return ret;
+	}
+
+	ctx = &priv->mfunc.master.slave_state[slave];
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	mlx4_dbg(dev, "%s: slave: %d, current state: %d new event :%d\n",
+		 __func__, slave, cur_state, event);
+
+	switch (cur_state) {
+	case SLAVE_PORT_DOWN:
+		if (MLX4_PORT_STATE_DEV_EVENT_PORT_UP == event)
+			mlx4_set_slave_port_state(dev, slave, port,
+						  SLAVE_PENDING_UP);
+		break;
+	case SLAVE_PENDING_UP:
+		if (MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN == event)
+			mlx4_set_slave_port_state(dev, slave, port,
+						  SLAVE_PORT_DOWN);
+		else if (MLX4_PORT_STATE_IB_PORT_STATE_EVENT_GID_VALID == event) {
+			mlx4_set_slave_port_state(dev, slave, port,
+						  SLAVE_PORT_UP);
+			*gen_event = SLAVE_PORT_GEN_EVENT_UP;
+		}
+		break;
+	case SLAVE_PORT_UP:
+		if (MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN == event) {
+			mlx4_set_slave_port_state(dev, slave, port,
+						  SLAVE_PORT_DOWN);
+			*gen_event = SLAVE_PORT_GEN_EVENT_DOWN;
+		} else if (MLX4_PORT_STATE_IB_EVENT_GID_INVALID ==
+				event) {
+			mlx4_set_slave_port_state(dev, slave, port,
+						  SLAVE_PENDING_UP);
+			*gen_event = SLAVE_PORT_GEN_EVENT_DOWN;
+		}
+		break;
+	default:
+		pr_err("%s: BUG!!! UNKNOWN state: "
+		       "slave:%d, port:%d\n", __func__, slave, port);
+			goto out;
+	}
+	ret = mlx4_get_slave_port_state(dev, slave, port);
+	mlx4_dbg(dev, "%s: slave: %d, current state: %d new event"
+		 " :%d gen_event: %d\n",
+		 __func__, slave, cur_state, event, *gen_event);
+
+out:
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	return ret;
+}
+
+EXPORT_SYMBOL(set_and_calc_slave_port_state);
+
+int mlx4_gen_slaves_port_mgt_ev(struct mlx4_dev *dev, u8 port, int attr)
+{
+	struct mlx4_eqe eqe;
+
+	memset(&eqe, 0, sizeof eqe);
+
+	eqe.type = MLX4_EVENT_TYPE_PORT_MNG_CHG_EVENT;
+	eqe.subtype = MLX4_DEV_PMC_SUBTYPE_PORT_INFO;
+	eqe.event.port_mgmt_change.port = port;
+	eqe.event.port_mgmt_change.params.port_info.changed_attr =
+		cpu_to_be32((u32) attr);
+
+	slave_event(dev, ALL_SLAVES, &eqe);
+	return 0;
+}
+EXPORT_SYMBOL(mlx4_gen_slaves_port_mgt_ev);
+
 void mlx4_master_handle_slave_flr(struct work_struct *work)
 {
 	struct mlx4_mfunc_master_ctx *master =
@@ -250,6 +440,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 	u32 flr_slave;
 	u8 update_slave_state;
 	int i;
+	enum slave_port_gen_event gen_event;
 
 	while ((eqe = next_eqe_sw(eq))) {
 		/*
@@ -346,35 +537,49 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 		case MLX4_EVENT_TYPE_PORT_CHANGE:
 			port = be32_to_cpu(eqe->event.port_change.port) >> 28;
 			if (eqe->subtype == MLX4_PORT_CHANGE_SUBTYPE_DOWN) {
-				mlx4_dispatch_event(dev,
-						    MLX4_DEV_EVENT_PORT_DOWN,
+				mlx4_dispatch_event(dev, MLX4_DEV_EVENT_PORT_DOWN,
 						    port);
 				mlx4_priv(dev)->sense.do_sense_port[port] = 1;
-				if (mlx4_is_master(dev))
-					/*change the state of all slave's port
-					* to down:*/
-					for (i = 0; i < dev->num_slaves; i++) {
-						mlx4_dbg(dev, "%s: Sending "
-							 "MLX4_PORT_CHANGE_SUBTYPE_DOWN"
+				if (!mlx4_is_master(dev))
+					break;
+				for (i = 0; i < dev->num_slaves; i++) {
+					if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH) {
+						if (i == mlx4_master_func_num(dev))
+							continue;
+						mlx4_dbg(dev, "%s: Sending MLX4_PORT_CHANGE_SUBTYPE_DOWN"
 							 " to slave: %d, port:%d\n",
 							 __func__, i, port);
-						if (i == dev->caps.function)
-							continue;
 						mlx4_slave_event(dev, i, eqe);
+					} else {  /* IB port */
+						set_and_calc_slave_port_state(dev, i, port,
+									      MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN,
+									      &gen_event);
+						/*we can be in pending state, then do not send port_down event*/
+						if (SLAVE_PORT_GEN_EVENT_DOWN ==  gen_event) {
+							if (i == mlx4_master_func_num(dev))
+								continue;
+							mlx4_slave_event(dev, i, eqe);
+						}
 					}
+				}
 			} else {
-				mlx4_dispatch_event(dev,
-						    MLX4_DEV_EVENT_PORT_UP,
-						    port);
+				mlx4_dispatch_event(dev, MLX4_DEV_EVENT_PORT_UP, port);
+
 				mlx4_priv(dev)->sense.do_sense_port[port] = 0;
 
-				if (mlx4_is_master(dev)) {
+				if (!mlx4_is_master(dev))
+					break;
+				if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
 					for (i = 0; i < dev->num_slaves; i++) {
-						if (i == dev->caps.function)
+						if (i == mlx4_master_func_num(dev))
 							continue;
 						mlx4_slave_event(dev, i, eqe);
 					}
-				}
+				else /* IB port */
+					/* port-up event will be sent to a slave when the
+					 * slave's alias-guid is set. This is done in alias_GUID.c
+					 */
+					set_all_slave_state(dev, port, MLX4_DEV_EVENT_PORT_UP);
 			}
 			break;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 87cc0d8..5b25412 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -439,6 +439,7 @@ struct mlx4_slave_state {
 	/*initialized via the kzalloc*/
 	u8 is_slave_going_down;
 	u32 cookie;
+	enum slave_port_state port_state[MLX4_MAX_PORTS + 1];
 };
 
 struct slave_list {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index bb878a9..05846a3 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -161,6 +161,25 @@ enum {
 	MLX4_FATAL_WARNING_SUBTYPE_WARMING = 0,
 };
 
+enum slave_port_state {
+	SLAVE_PORT_DOWN = 0,
+	SLAVE_PENDING_UP,
+	SLAVE_PORT_UP,
+};
+
+enum slave_port_gen_event {
+	SLAVE_PORT_GEN_EVENT_DOWN = 0,
+	SLAVE_PORT_GEN_EVENT_UP,
+	SLAVE_PORT_GEN_EVENT_NONE,
+};
+
+enum slave_port_state_event {
+	MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN,
+	MLX4_PORT_STATE_DEV_EVENT_PORT_UP,
+	MLX4_PORT_STATE_IB_PORT_STATE_EVENT_GID_VALID,
+	MLX4_PORT_STATE_IB_EVENT_GID_INVALID,
+};
+
 enum {
 	MLX4_PERM_LOCAL_READ	= 1 << 10,
 	MLX4_PERM_LOCAL_WRITE	= 1 << 11,
@@ -802,4 +821,13 @@ void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port,
 
 int mlx4_get_parav_qkey(struct mlx4_dev *dev, u32 qpn, u32 *qkey);
 
+int mlx4_is_slave_active(struct mlx4_dev *dev, int slave);
+int mlx4_gen_pkey_eqe(struct mlx4_dev *dev, int slave, u8 port);
+int mlx4_gen_guid_change_eqe(struct mlx4_dev *dev, int slave, u8 port);
+int mlx4_gen_slaves_port_mgt_ev(struct mlx4_dev *dev, u8 port, int attr);
+int mlx4_gen_port_state_change_eqe(struct mlx4_dev *dev, int slave, u8 port, u8 port_subtype_change);
+enum slave_port_state mlx4_get_slave_port_state(struct mlx4_dev *dev, int slave, u8 port);
+int set_and_calc_slave_port_state(struct mlx4_dev *dev, int slave, u8 port, int event, enum slave_port_gen_event *gen_event);
+
+
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
