From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 25/30] IB/mlx4: Configure device to work in RoCEv2
Date: Fri, 20 Feb 2015 03:32:40 +0530
Message-ID: <9a076007-e02a-4a12-9453-5a2573a79b99@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some mlx4 adapters are RoCEv2 capable. To enable this feature some
hardware configuration is required. This is

1. Set port general parameters
2. Configure the outgoing UDP destination port
3. Configure the QP that work with RoCEv2

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c         |   10 ++++++-
 drivers/infiniband/hw/mlx4/qp.c           |   39 ++++++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx4/fw.c   |   16 +++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    3 +-
 drivers/net/ethernet/mellanox/mlx4/port.c |    9 ++++++-
 drivers/net/ethernet/mellanox/mlx4/qp.c   |   27 ++++++++++++++++++++
 include/linux/mlx4/device.h               |    3 +-
 include/linux/mlx4/qp.h                   |   15 +++++++++-
 8 files changed, 112 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ca19d1d..50612b8 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2154,7 +2154,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_init_sriov(ibdev))
 		goto err_mad;
 
-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE) {
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE ||
+	    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
 		if (!iboe->nb.notifier_call) {
 			iboe->nb.notifier_call = mlx4_ib_netdev_event;
 			err = register_netdevice_notifier(&iboe->nb);
@@ -2163,6 +2164,13 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 				goto err_notif;
 			}
 		}
+		if (!mlx4_is_slave(dev) &&
+		    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
+			err = mlx4_config_roce_v2_port(dev, ROCE_V2_UDP_DPORT);
+			if (err) {
+				goto err_notif;
+			}
+		}
 	}
 
 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9ab9156..9731c07 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1408,6 +1408,24 @@ static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev,
 	return 0;
 }
 
+enum {
+	MLX4_QPC_ROCE_MODE_1 = 0,
+	MLX4_QPC_ROCE_MODE_2 = 2,
+	MLX4_QPC_ROCE_MODE_MAX = 0xff
+};
+
+static u8 gid_type_to_qpc(enum ib_gid_type gid_type)
+{
+	switch (gid_type) {
+	case IB_GID_TYPE_IB:
+		return MLX4_QPC_ROCE_MODE_1;
+	case IB_GID_TYPE_ROCE_V2:
+		return MLX4_QPC_ROCE_MODE_2;
+	default:
+		return MLX4_QPC_ROCE_MODE_MAX;
+	}
+}
+
 static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
@@ -1532,9 +1550,12 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		u16 vlan = 0xffff;
 		u8 smac[ETH_ALEN];
 		int status = 0;
+		int is_eth = rdma_port_get_link_layer(&dev->ib_dev, qp->port) ==
+				IB_LINK_LAYER_ETHERNET;
 
-		if (rdma_port_get_link_layer(&dev->ib_dev, qp->port) ==
-				IB_LINK_LAYER_ETHERNET) {
+		if (is_eth) {
+			if (mlx4_is_bonded(dev->dev))
+				port_num  = 1;
 			rcu_read_lock();
 			status = ib_get_cached_gid(ibqp->device, port_num,
 						   index, &gid, &gid_attr);
@@ -1551,8 +1572,20 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 				  port_num, vlan, smac))
 			goto out;
 
+		if (is_eth && gid_attr.gid_type == IB_GID_TYPE_ROCE_V2)
+			context->pri_path.hop_limit = IPV6_DEFAULT_HOPLIMIT;
+
 		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
 			   MLX4_QP_OPTPAR_SCHED_QUEUE);
+
+		if (is_eth && (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR)) {
+			u8 qpc_roce_mode = gid_type_to_qpc(gid_attr.gid_type);
+
+			if (qpc_roce_mode == MLX4_QPC_ROCE_MODE_MAX)
+				goto out;
+			context->rlkey_roce_mode |= (qpc_roce_mode << 6);
+		}
+
 	}
 
 	if (attr_mask & IB_QP_TIMEOUT) {
@@ -1722,7 +1755,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		sqd_event = 0;
 
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
-		context->rlkey |= (1 << 4);
+		context->rlkey_roce_mode |= (1 << 4);
 
 	/*
 	 * Before passing a kernel QP to the HW, make sure that the
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index d573e73..0086aab 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2056,7 +2056,8 @@ struct mlx4_config_dev {
 	__be32	rsvd1[3];
 	__be16	vxlan_udp_dport;
 	__be16	rsvd2;
-	__be32	rsvd3;
+	__be16  roce_v2_entropy;
+	__be16  roce_v2_udp_dport;
 	__be32	roce_flags;
 	__be32	rsvd4[25];
 	__be16	rsvd5;
@@ -2065,6 +2066,7 @@ struct mlx4_config_dev {
 };
 
 #define MLX4_VXLAN_UDP_DPORT (1 << 0)
+#define MLX4_ROCE_V2_UDP_DPORT BIT(3)
 #define MLX4_DISABLE_RX_PORT BIT(18)
 
 static int mlx4_CONFIG_DEV_set(struct mlx4_dev *dev, struct mlx4_config_dev *config_dev)
@@ -2182,6 +2184,18 @@ int mlx4_disable_rx_port_check(struct mlx4_dev *dev, bool dis)
 	return mlx4_CONFIG_DEV_set(dev, &config_dev);
 }
 
+int mlx4_config_roce_v2_port(struct mlx4_dev *dev, u16 udp_port)
+{
+	struct mlx4_config_dev config_dev;
+
+	memset(&config_dev, 0, sizeof(config_dev));
+	config_dev.update_flags    = cpu_to_be32(MLX4_ROCE_V2_UDP_DPORT);
+	config_dev.roce_v2_udp_dport = cpu_to_be16(udp_port);
+
+	return mlx4_CONFIG_DEV_set(dev, &config_dev);
+}
+EXPORT_SYMBOL_GPL(mlx4_config_roce_v2_port);
+
 int mlx4_virt2phy_port_map(struct mlx4_dev *dev, u32 port1, u32 port2)
 {
 	struct mlx4_cmd_mailbox *mailbox;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index beb1c08..f4160a8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -763,7 +763,8 @@ enum {
 struct mlx4_set_port_general_context {
 	u8 reserved[3];
 	u8 flags;
-	u16 reserved2;
+	u8 roce_mode;
+	u8 rr_proto;
 	__be16 mtu;
 	u8 pptx;
 	u8 pfctx;
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 30eb1ea..3757b98 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -955,6 +955,8 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port, int pkey_tbl_sz)
 	return err;
 }
 
+#define SET_PORT_ROCE_2_FLAGS          0x10
+#define MLX4_SET_PORT_ROCE_V1_V2       0x2
 int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx)
 {
@@ -973,7 +975,12 @@ int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 	context->pfctx = pfctx;
 	context->pprx = (pprx * (!pfcrx)) << 7;
 	context->pfcrx = pfcrx;
-
+	if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
+		context->flags |= SET_PORT_ROCE_2_FLAGS;
+		context->roce_mode |=
+			(MLX4_SET_PORT_ROCE_V1_V2 & 7)
+			<< 4;
+	}
 	in_mod = MLX4_SET_PORT_GENERAL << 8 | port;
 	err = mlx4_cmd(dev, mailbox->dma, in_mod, 1, MLX4_CMD_SET_PORT,
 		       MLX4_CMD_TIME_CLASS_B,  MLX4_CMD_WRAPPED);
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 2bb8553..03917dd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -167,6 +167,13 @@ static int __mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 		context->log_page_size   = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
 	}
 
+	if ((cur_state == MLX4_QP_STATE_RTR) &&
+	    (new_state == MLX4_QP_STATE_RTS) &&
+	    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2 &&
+	    !mlx4_is_mfunc(dev)) {
+		context->roce_entropy = cpu_to_be16(mlx4_qp_roce_entropy(dev, qp->qpn));
+	}
+
 	*(__be32 *) mailbox->buf = cpu_to_be32(optpar);
 	memcpy(mailbox->buf + 8, context, sizeof *context);
 
@@ -898,3 +905,23 @@ int mlx4_qp_to_ready(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx4_qp_to_ready);
+
+u32 mlx4_qp_roce_entropy(struct mlx4_dev *dev, u32 qpn)
+{
+	struct mlx4_qp_context context;
+	struct mlx4_qp qp;
+	int err;
+
+	qp.qpn = qpn;
+	err = mlx4_qp_query(dev, &qp, &context);
+	if (!err) {
+		u32 dest_qpn = be32_to_cpu(context.remote_qpn) & 0xffffff;
+		u16 folded_dst = folded_qp(dest_qpn);
+		u16 folded_src = folded_qp(qpn);
+
+		return (dest_qpn != qpn) ? ((folded_dst ^ folded_src) | 0xC000) :
+			folded_src | 0xC000;
+	}
+	return 0xdead;
+}
+EXPORT_SYMBOL_GPL(mlx4_qp_roce_entropy);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index b384ce6..dd1488c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -204,7 +204,7 @@ enum {
 	MLX4_DEV_CAP_FLAG2_80_VFS		= 1LL <<  18,
 	MLX4_DEV_CAP_FLAG2_FS_A0		= 1LL <<  19,
 	MLX4_DEV_CAP_FLAG2_PORT_REMAP		= 1LL <<  21,
-+	MLX4_DEV_CAP_FLAG2_ROCE_V1_V2		= 1LL <<  22
+	MLX4_DEV_CAP_FLAG2_ROCE_V1_V2		= 1LL <<  22
 };
 
 enum {
@@ -1354,6 +1354,7 @@ int mlx4_get_base_gid_ix(struct mlx4_dev *dev, int slave, int port);
 
 int mlx4_config_vxlan_port(struct mlx4_dev *dev, __be16 udp_port);
 int mlx4_disable_rx_port_check(struct mlx4_dev *dev, bool dis);
+int mlx4_config_roce_v2_port(struct mlx4_dev *dev, u16 udp_port);
 int mlx4_virt2phy_port_map(struct mlx4_dev *dev, u32 port1, u32 port2);
 int mlx4_vf_smi_enabled(struct mlx4_dev *dev, int slave, int port);
 int mlx4_vf_get_enable_smi_admin(struct mlx4_dev *dev, int slave, int port);
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 2bbc62a..b7497b9 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -184,7 +184,7 @@ struct mlx4_qp_context {
 	u8			mtu_msgmax;
 	u8			rq_size_stride;
 	u8			sq_size_stride;
-	u8			rlkey;
+	u8			rlkey_roce_mode;
 	__be32			usr_page;
 	__be32			local_qpn;
 	__be32			remote_qpn;
@@ -194,7 +194,8 @@ struct mlx4_qp_context {
 	u32			reserved1;
 	__be32			next_send_psn;
 	__be32			cqn_send;
-	u32			reserved2[2];
+	__be16                  roce_entropy;
+	__be16                  reserved2[3];
 	__be32			last_acked_psn;
 	__be32			ssn;
 	__be32			params2;
@@ -462,4 +463,14 @@ static inline struct mlx4_qp *__mlx4_qp_lookup(struct mlx4_dev *dev, u32 qpn)
 
 void mlx4_qp_remove(struct mlx4_dev *dev, struct mlx4_qp *qp);
 
+static inline u16 folded_qp(u32 q)
+{
+	u16 res;
+
+	res = ((q & 0xff) ^ ((q & 0xff0000) >> 16)) | (q & 0xff00);
+	return res;
+}
+
+u32 mlx4_qp_roce_entropy(struct mlx4_dev *dev, u32 qpn);
+
 #endif /* MLX4_QP_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
