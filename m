From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/6] IB/mlx4: Preparation for VFs to issue/receive SMI (QP0) requests/responses
Date: Thu, 29 May 2014 16:31:02 +0300
Message-ID: <1401370264-4818-5-git-send-email-ogerlitz@mellanox.com>
References: <1401370264-4818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401370264-4818-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Currently, VFs in SRIOV settings are denied QP0 access. The main reason for
this decision is security, since Subnet Management Datagrams  SMPs  are not
restricted by network partitioning and may affect the physical network topology.
Moreover, even the SM may be denied access from portions of the network by
setting management keys unknown to the SM.

However, it is desirable to grant SMI access to certain privileged VFs, so that
certain network management activities may be conducted within virtual machines
instead of the hypervisor.

This commit does the following:
1. Create QP0 tunnel QPs for all VFs.

2. Discard SMI mads sent-from/received-for non-privileged VFs in the Hypervisor
   MAD multiplex/demultiplex logic.  SMI mads from/for privileged VFs are
   allowed to pass.

3. MAD_IFC wrapper changes/fixes.
   For non-privileged VFs, only host-view MAD_IFC commands are allowed, and
   only for SMI LID-Routed GET mads.
   For privileged VFs, there are no restrictions.

This commit does not allow privileged VFs as yet. To determine if a VF is
privileged, it calls function mlx4_vf_smi_enabled(). This function returns 0
unconditionally for now.

The next two commits allow defining and activating privileged VFs.


Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c         |   40 +++++++++++++++----------
 drivers/infiniband/hw/mlx4/qp.c          |   16 +++++-----
 drivers/net/ethernet/mellanox/mlx4/cmd.c |   47 +++++++++++++++++++++---------
 include/linux/mlx4/device.h              |    1 +
 4 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index fd36ec6..287ad05 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -478,10 +478,6 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	if (!tun_ctx || tun_ctx->state != DEMUX_PV_STATE_ACTIVE)
 		return -EAGAIN;
 
-	/* QP0 forwarding only for Dom0 */
-	if (!dest_qpt && (mlx4_master_func_num(dev->dev) != slave))
-		return -EINVAL;
-
 	if (!dest_qpt)
 		tun_qp = &tun_ctx->qp[0];
 	else
@@ -667,6 +663,21 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 	}
 	/* Class-specific handling */
 	switch (mad->mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
+	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
+		/* 255 indicates the dom0 */
+		if (slave != 255 && slave != mlx4_master_func_num(dev->dev)) {
+			if (!mlx4_vf_smi_enabled(dev->dev, slave, port))
+				return -EPERM;
+			/* for a VF. drop unsolicited MADs */
+			if (!(mad->mad_hdr.method & IB_MGMT_METHOD_RESP)) {
+				mlx4_ib_warn(ibdev, "demux QP0. rejecting unsolicited mad for slave %d class 0x%x, method 0x%x\n",
+					     slave, mad->mad_hdr.mgmt_class,
+					     mad->mad_hdr.method);
+				return -EINVAL;
+			}
+		}
+		break;
 	case IB_MGMT_CLASS_SUBN_ADM:
 		if (mlx4_ib_demux_sa_handler(ibdev, port, slave,
 					     (struct ib_sa_mad *) mad))
@@ -1165,10 +1176,6 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	if (!sqp_ctx || sqp_ctx->state != DEMUX_PV_STATE_ACTIVE)
 		return -EAGAIN;
 
-	/* QP0 forwarding only for Dom0 */
-	if (dest_qpt == IB_QPT_SMI && (mlx4_master_func_num(dev->dev) != slave))
-		return -EINVAL;
-
 	if (dest_qpt == IB_QPT_SMI) {
 		src_qpnum = 0;
 		sqp = &sqp_ctx->qp[0];
@@ -1285,11 +1292,6 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 			     "belongs to another slave\n", wc->src_qp);
 		return;
 	}
-	if (slave != mlx4_master_func_num(dev->dev) && !(wc->src_qp & 0x2)) {
-		mlx4_ib_warn(ctx->ib_dev, "can't multiplex bad sqp:%d: "
-			     "non-master trying to send QP0 packets\n", wc->src_qp);
-		return;
-	}
 
 	/* Map transaction ID */
 	ib_dma_sync_single_for_cpu(ctx->ib_dev, tun_qp->ring[wr_ix].map,
@@ -1317,6 +1319,12 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 
 	/* Class-specific handling */
 	switch (tunnel->mad.mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
+	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
+		if (slave != mlx4_master_func_num(dev->dev) &&
+		    !mlx4_vf_smi_enabled(dev->dev, slave, ctx->port))
+			return;
+		break;
 	case IB_MGMT_CLASS_SUBN_ADM:
 		if (mlx4_ib_multiplex_sa_handler(ctx->ib_dev, ctx->port, slave,
 			      (struct ib_sa_mad *) &tunnel->mad))
@@ -1749,9 +1757,9 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		return -EEXIST;
 
 	ctx->state = DEMUX_PV_STATE_STARTING;
-	/* have QP0 only on port owner, and only if link layer is IB */
-	if (ctx->slave == mlx4_master_func_num(to_mdev(ctx->ib_dev)->dev) &&
-	    rdma_port_get_link_layer(ibdev, ctx->port) == IB_LINK_LAYER_INFINIBAND)
+	/* have QP0 only if link layer is IB */
+	if (rdma_port_get_link_layer(ibdev, ctx->port) ==
+	    IB_LINK_LAYER_INFINIBAND)
 		ctx->has_smi = 1;
 
 	if (ctx->has_smi) {
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 41308af..2e8c588 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2370,7 +2370,8 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 
 static void set_tunnel_datagram_seg(struct mlx4_ib_dev *dev,
 				    struct mlx4_wqe_datagram_seg *dseg,
-				    struct ib_send_wr *wr, enum ib_qp_type qpt)
+				    struct ib_send_wr *wr,
+				    enum mlx4_ib_qp_type qpt)
 {
 	union mlx4_ext_av *av = &to_mah(wr->wr.ud.ah)->av;
 	struct mlx4_av sqp_av = {0};
@@ -2383,8 +2384,10 @@ static void set_tunnel_datagram_seg(struct mlx4_ib_dev *dev,
 			cpu_to_be32(0xf0000000);
 
 	memcpy(dseg->av, &sqp_av, sizeof (struct mlx4_av));
-	/* This function used only for sending on QP1 proxies */
-	dseg->dqpn = cpu_to_be32(dev->dev->caps.qp1_tunnel[port - 1]);
+	if (qpt == MLX4_IB_QPT_PROXY_GSI)
+		dseg->dqpn = cpu_to_be32(dev->dev->caps.qp1_tunnel[port - 1]);
+	else
+		dseg->dqpn = cpu_to_be32(dev->dev->caps.qp0_tunnel[port - 1]);
 	/* Use QKEY from the QP context, which is set by master */
 	dseg->qkey = cpu_to_be32(IB_QP_SET_QKEY);
 }
@@ -2700,16 +2703,13 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			size += seglen / 16;
 			break;
 		case MLX4_IB_QPT_PROXY_SMI:
-			/* don't allow QP0 sends on guests */
-			err = -ENOSYS;
-			*bad_wr = wr;
-			goto out;
 		case MLX4_IB_QPT_PROXY_GSI:
 			/* If we are tunneling special qps, this is a UD qp.
 			 * In this case we first add a UD segment targeting
 			 * the tunnel qp, and then add a header with address
 			 * information */
-			set_tunnel_datagram_seg(to_mdev(ibqp->device), wqe, wr, ibqp->qp_type);
+			set_tunnel_datagram_seg(to_mdev(ibqp->device), wqe, wr,
+						qp->mlx4_ib_qp_type);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
 			build_tunnel_header(wr, wqe, &seglen);
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 78099ea..b0e48d4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -705,20 +705,28 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 	struct ib_smp *smp = inbox->buf;
 	u32 index;
 	u8 port;
+	u8 opcode_modifier;
 	u16 *table;
 	int err;
 	int vidx, pidx;
+	int network_view;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct ib_smp *outsmp = outbox->buf;
 	__be16 *outtab = (__be16 *)(outsmp->data);
 	__be32 slave_cap_mask;
 	__be64 slave_node_guid;
+
 	port = vhcr->in_modifier;
 
+	/* network-view bit is for driver use only, and should not be passed to FW */
+	opcode_modifier = vhcr->op_modifier & ~0x8; /* clear netw view bit */
+	network_view = !!(vhcr->op_modifier & 0x8);
+
 	if (smp->base_version == 1 &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED &&
 	    smp->class_version == 1) {
-		if (smp->method	== IB_MGMT_METHOD_GET) {
+		/* host view is paravirtualized */
+		if (!network_view && smp->method == IB_MGMT_METHOD_GET) {
 			if (smp->attr_id == IB_SMP_ATTR_PKEY_TABLE) {
 				index = be32_to_cpu(smp->attr_mod);
 				if (port < 1 || port > dev->caps.num_ports)
@@ -743,7 +751,7 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 				/*get the slave specific caps:*/
 				/*do the command */
 				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
-					    vhcr->in_modifier, vhcr->op_modifier,
+					    vhcr->in_modifier, opcode_modifier,
 					    vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
 				/* modify the response for slaves */
 				if (!err && slave != mlx4_master_func_num(dev)) {
@@ -760,7 +768,7 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 				smp->attr_mod = cpu_to_be32(slave / 8);
 				/* execute cmd */
 				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
-					     vhcr->in_modifier, vhcr->op_modifier,
+					     vhcr->in_modifier, opcode_modifier,
 					     vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
 				if (!err) {
 					/* if needed, move slave gid to index 0 */
@@ -774,7 +782,7 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 			}
 			if (smp->attr_id == IB_SMP_ATTR_NODE_INFO) {
 				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
-					     vhcr->in_modifier, vhcr->op_modifier,
+					     vhcr->in_modifier, opcode_modifier,
 					     vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
 				if (!err) {
 					slave_node_guid =  mlx4_get_slave_node_guid(dev, slave);
@@ -784,19 +792,24 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 			}
 		}
 	}
+
+	/* Non-privileged VFs are only allowed "host" view LID-routed 'Get' MADs.
+	 * These are the MADs used by ib verbs (such as ib_query_gids).
+	 */
 	if (slave != mlx4_master_func_num(dev) &&
-	    ((smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) ||
-	     (smp->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED &&
-	      smp->method == IB_MGMT_METHOD_SET))) {
-		mlx4_err(dev, "slave %d is trying to execute a Subnet MGMT MAD, "
-			 "class 0x%x, method 0x%x for attr 0x%x. Rejecting\n",
-			 slave, smp->method, smp->mgmt_class,
-			 be16_to_cpu(smp->attr_id));
-		return -EPERM;
+	    !mlx4_vf_smi_enabled(dev, slave, port)) {
+		if (!(smp->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED &&
+		      smp->method == IB_MGMT_METHOD_GET) || network_view) {
+			mlx4_err(dev, "Unprivileged slave %d is trying to execute a Subnet MGMT MAD, class 0x%x, method 0x%x, view=%s for attr 0x%x. Rejecting\n",
+				 slave, smp->method, smp->mgmt_class,
+				 network_view ? "Network" : "Host",
+				 be16_to_cpu(smp->attr_id));
+			return -EPERM;
+		}
 	}
-	/*default:*/
+
 	return mlx4_cmd_box(dev, inbox->dma, outbox->dma,
-				    vhcr->in_modifier, vhcr->op_modifier,
+				    vhcr->in_modifier, opcode_modifier,
 				    vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
 }
 
@@ -2537,3 +2550,9 @@ int mlx4_set_vf_link_state(struct mlx4_dev *dev, int port, int vf, int link_stat
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx4_set_vf_link_state);
+
+int mlx4_vf_smi_enabled(struct mlx4_dev *dev, int slave, int port)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_vf_smi_enabled);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index ba87bd2..83612fa 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1234,4 +1234,5 @@ int mlx4_phys_to_slave_port(struct mlx4_dev *dev, int slave, int port);
 int mlx4_get_base_gid_ix(struct mlx4_dev *dev, int slave, int port);
 
 int mlx4_config_vxlan_port(struct mlx4_dev *dev, __be16 udp_port);
+int mlx4_vf_smi_enabled(struct mlx4_dev *dev, int slave, int port);
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
