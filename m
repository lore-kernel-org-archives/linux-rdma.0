From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 14/19 V4] mlx4_core: Managing common port configuration by
	master function
Date: Thu, 10 Jun 2010 22:05:35 +0300
Message-ID: <4C11377F.9060608@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Multicast filter configuration is done by the master,
that manages the filter which is common for all the functions.
The master holds a list of multicast addresses for all the
slaves, and adds them to the filter.
In case some slave wishes to flush the filter, only his addresses
are removed.
The VLAN filter is a bitwise OR of all the VLAN filters for all functions,
the result is a false-positive filter.
All port configuration is moved to the mlx4_core module

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/cmd.c      |   41 +++++--
 drivers/net/mlx4/en_port.c  |  105 --------------
 drivers/net/mlx4/en_port.h  |   47 ------
 drivers/net/mlx4/mlx4.h     |   63 +++++++++
 drivers/net/mlx4/mlx4_en.h  |    1 -
 drivers/net/mlx4/port.c     |  326 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/mlx4/device.h |    6 +
 7 files changed, 416 insertions(+), 173 deletions(-)

diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index 0f45fde..4cfa407 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -926,7 +926,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL,
-		.wrapper = NULL /* need wrapper*/
+		.wrapper = mlx4_SET_VLAN_FLTR_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_SET_MCAST_FLTR,
@@ -934,7 +934,7 @@ static struct mlx4_cmd_info {
 		.has_outbox = false,
 		.out_is_imm = false,
 		.verify = NULL,
-		.wrapper = NULL /* need wrapper*/
+		.wrapper = mlx4_SET_MCAST_FLTR_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_DUMP_ETH_STATS,
@@ -1170,7 +1170,8 @@ static void mlx4_master_poll_comm(struct work_struct *work)
 int mlx4_multi_func_init(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	int i;
+	struct mlx4_slave_state *s_state;
+	int i, port;
 
 	priv->mfunc.vhcr = dma_alloc_coherent(&(dev->pdev->dev), PAGE_SIZE,
 					    &priv->mfunc.vhcr_dma,
@@ -1202,16 +1203,27 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 			goto err_comm;
 
 		for (i = 0; i < dev->num_slaves; ++i) {
-			priv->mfunc.master.slave_state[i].last_cmd = MLX4_COMM_CMD_RESET;
-			spin_lock_init(&priv->mfunc.master.slave_state[i].lock);
+			s_state = &priv->mfunc.master.slave_state[i];
+			s_state->last_cmd = MLX4_COMM_CMD_RESET;
+			for (port = 1; port <= MLX4_MAX_PORTS; port++) {
+				s_state->vlan_filter[port] =
+					kzalloc(sizeof(struct mlx4_vlan_fltr),
+						GFP_KERNEL);
+				if (!s_state->vlan_filter[port]) {
+					if (--port)
+						kfree(s_state->vlan_filter[port]);
+					goto err_slaves;
+				}
+				INIT_LIST_HEAD(&s_state->mcast_filters[port]);
+			}
+			spin_lock_init(&s_state->lock);
 		}
 
 		INIT_DELAYED_WORK(&priv->mfunc.comm_work, mlx4_master_poll_comm);
 		priv->mfunc.comm_wq = create_singlethread_workqueue("mlx4_comm");
-		if (!priv->mfunc.comm_wq) {
-			kfree(priv->mfunc.master.slave_state);
-			goto err_comm;
-		}
+		if (!priv->mfunc.comm_wq)
+			goto err_slaves;
+
 	} else {
 		priv->cmd.comm_toggle = 0;
 		INIT_DELAYED_WORK(&priv->mfunc.comm_work, mlx4_slave_async_eq_poll);
@@ -1221,6 +1233,12 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 	}
 	return 0;
 
+err_slaves:
+	while (--i) {
+		for (port = 1; port <= MLX4_MAX_PORTS; port++)
+			kfree(priv->mfunc.master.slave_state[i].vlan_filter[port]);
+	}
+	kfree(priv->mfunc.master.slave_state);
 err_comm:
 	iounmap(priv->mfunc.comm);
 err_vhcr:
@@ -1269,9 +1287,14 @@ err_hcr:
 void mlx4_multi_func_cleanup(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
+	int i, port;
 
 	if (priv->mfunc.vhcr) {
 		destroy_workqueue(priv->mfunc.comm_wq);
+		for (i = 0; i < dev->num_slaves; i++) {
+			for (port = 1; port <= MLX4_MAX_PORTS; port++)
+				kfree(priv->mfunc.master.slave_state[i].vlan_filter[port]);
+		}
 		kfree(priv->mfunc.master.slave_state);
 		iounmap(priv->mfunc.comm);
 		dma_free_coherent(&(dev->pdev->dev), PAGE_SIZE,
diff --git a/drivers/net/mlx4/en_port.c b/drivers/net/mlx4/en_port.c
index 32a9943..2863a30 100644
--- a/drivers/net/mlx4/en_port.c
+++ b/drivers/net/mlx4/en_port.c
@@ -41,111 +41,6 @@
 #include "mlx4_en.h"
 
 
-int mlx4_SET_MCAST_FLTR(struct mlx4_dev *dev, u8 port,
-			u64 mac, u64 clear, u8 mode)
-{
-	return mlx4_cmd(dev, (mac | (clear << 63)), port, mode,
-			MLX4_CMD_SET_MCAST_FLTR, MLX4_CMD_TIME_CLASS_B);
-}
-
-int mlx4_SET_VLAN_FLTR(struct mlx4_dev *dev, u8 port, struct vlan_group *grp)
-{
-	struct mlx4_cmd_mailbox *mailbox;
-	struct mlx4_set_vlan_fltr_mbox *filter;
-	int i;
-	int j;
-	int index = 0;
-	u32 entry;
-	int err = 0;
-
-	mailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(mailbox))
-		return PTR_ERR(mailbox);
-
-	filter = mailbox->buf;
-	if (grp) {
-		memset(filter, 0, sizeof *filter);
-		for (i = VLAN_FLTR_SIZE - 1; i >= 0; i--) {
-			entry = 0;
-			for (j = 0; j < 32; j++)
-				if (vlan_group_get_device(grp, index++))
-					entry |= 1 << j;
-			filter->entry[i] = cpu_to_be32(entry);
-		}
-	} else {
-		/* When no vlans are configured we block all vlans */
-		memset(filter, 0, sizeof(*filter));
-	}
-	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_VLAN_FLTR,
-		       MLX4_CMD_TIME_CLASS_B);
-	mlx4_free_cmd_mailbox(dev, mailbox);
-	return err;
-}
-
-
-int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
-			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx)
-{
-	struct mlx4_cmd_mailbox *mailbox;
-	struct mlx4_set_port_general_context *context;
-	int err;
-	u32 in_mod;
-
-	mailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(mailbox))
-		return PTR_ERR(mailbox);
-	context = mailbox->buf;
-	memset(context, 0, sizeof *context);
-
-	context->flags = SET_PORT_GEN_ALL_VALID;
-	context->mtu = cpu_to_be16(mtu);
-	context->pptx = (pptx * (!pfctx)) << 7;
-	context->pfctx = pfctx;
-	context->pprx = (pprx * (!pfcrx)) << 7;
-	context->pfcrx = pfcrx;
-
-	in_mod = MLX4_SET_PORT_GENERAL << 8 | port;
-	err = mlx4_cmd(dev, mailbox->dma, in_mod, 1, MLX4_CMD_SET_PORT,
-		       MLX4_CMD_TIME_CLASS_B);
-
-	mlx4_free_cmd_mailbox(dev, mailbox);
-	return err;
-}
-
-int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
-			   u8 promisc)
-{
-	struct mlx4_cmd_mailbox *mailbox;
-	struct mlx4_set_port_rqp_calc_context *context;
-	int err;
-	u32 in_mod;
-	u32 m_promisc = (dev->caps.vep_mc_steering) ? MCAST_DIRECT : MCAST_DEFAULT;
-
-	mailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(mailbox))
-		return PTR_ERR(mailbox);
-	context = mailbox->buf;
-	memset(context, 0, sizeof *context);
-
-	context->base_qpn = cpu_to_be32(base_qpn);
-	context->n_mac = 0x7;
-	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_SHIFT | base_qpn);
-	context->mcast = cpu_to_be32((m_promisc << SET_PORT_MC_PROMISC_SHIFT) |
-				     base_qpn);
-	context->intra_no_vlan = 0;
-	context->no_vlan = MLX4_NO_VLAN_IDX;
-	context->intra_vlan_miss = 0;
-	context->vlan_miss = MLX4_VLAN_MISS_IDX;
-
-	in_mod = MLX4_SET_PORT_RQP_CALC << 8 | port;
-	err = mlx4_cmd(dev, mailbox->dma, in_mod, 1, MLX4_CMD_SET_PORT,
-		       MLX4_CMD_TIME_CLASS_B);
-
-	mlx4_free_cmd_mailbox(dev, mailbox);
-	return err;
-}
-
-
 int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
 {
 	struct mlx4_en_stat_out_mbox *mlx4_en_stats;
diff --git a/drivers/net/mlx4/en_port.h b/drivers/net/mlx4/en_port.h
index beaddff..40918ab 100644
--- a/drivers/net/mlx4/en_port.h
+++ b/drivers/net/mlx4/en_port.h
@@ -35,53 +35,6 @@
 #define _MLX4_EN_PORT_H_
 
 
-#define SET_PORT_GEN_ALL_VALID	0x7
-#define SET_PORT_PROMISC_SHIFT		31
-#define SET_PORT_MC_PROMISC_SHIFT	30
-
-enum {
-	MCAST_DIRECT_ONLY       = 0,
-	MCAST_DIRECT            = 1,
-	MCAST_DEFAULT           = 2
-};
-
-struct mlx4_set_port_general_context {
-	u8 reserved[3];
-	u8 flags;
-	u16 reserved2;
-	__be16 mtu;
-	u8 pptx;
-	u8 pfctx;
-	u16 reserved3;
-	u8 pprx;
-	u8 pfcrx;
-	u16 reserved4;
-};
-
-struct mlx4_set_port_rqp_calc_context {
-	__be32 base_qpn;
-	u8 rererved;
-	u8 n_mac;
-	u8 n_vlan;
-	u8 n_prio;
-	u8 reserved2[3];
-	u8 mac_miss;
-	u8 intra_no_vlan;
-	u8 no_vlan;
-	u8 intra_vlan_miss;
-	u8 vlan_miss;
-	u8 reserved3[3];
-	u8 no_vlan_prio;
-	__be32 promisc;
-	__be32 mcast;
-};
-
-#define VLAN_FLTR_SIZE	128
-struct mlx4_set_vlan_fltr_mbox {
-	__be32 entry[VLAN_FLTR_SIZE];
-};
-
-
 enum {
 	MLX4_MCAST_CONFIG       = 0,
 	MLX4_MCAST_DISABLE      = 1,
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 56b23f0..d722467 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -224,6 +224,16 @@ struct mlx4_slave_eqe {
 	u32 param;
 };
 
+struct mlx4_mcast_entry {
+	struct list_head list;
+	u64 addr;
+};
+
+#define VLAN_FLTR_SIZE	128
+struct mlx4_vlan_fltr {
+	__be32 entry[VLAN_FLTR_SIZE];
+};
+
 struct mlx4_slave_state {
 	u8 comm_toggle;
 	u8 last_cmd;
@@ -234,6 +244,8 @@ struct mlx4_slave_state {
 	u16 mtu[MLX4_MAX_PORTS + 1];
 	__be32 ib_cap_mask[MLX4_MAX_PORTS + 1];
 	struct mlx4_slave_eqe eq[MLX4_MFUNC_MAX_EQES];
+	struct list_head mcast_filters[MLX4_MAX_PORTS + 1];
+	struct mlx4_vlan_fltr *vlan_filter[MLX4_MAX_PORTS + 1];
 	u16 eq_pi;
 	u16 eq_ci;
 	spinlock_t lock;
@@ -243,6 +255,7 @@ struct mlx4_mfunc_master_ctx {
 	struct mlx4_slave_state *slave_state;
 	int			init_port_ref[MLX4_MAX_PORTS + 1];
 	u16			max_mtu[MLX4_MAX_PORTS + 1];
+	int			disable_mcast_ref[MLX4_MAX_PORTS + 1];
 };
 
 struct mlx4_vhcr {
@@ -369,6 +382,50 @@ struct mlx4_vlan_table {
 	int			max;
 };
 
+
+#define SET_PORT_GEN_ALL_VALID		0x7
+#define SET_PORT_PROMISC_SHIFT		31
+#define SET_PORT_MC_PROMISC_SHIFT	30
+
+enum {
+	MCAST_DIRECT_ONLY	= 0,
+	MCAST_DIRECT		= 1,
+	MCAST_DEFAULT		= 2
+};
+
+
+struct mlx4_set_port_general_context {
+	u8 reserved[3];
+	u8 flags;
+	u16 reserved2;
+	__be16 mtu;
+	u8 pptx;
+	u8 pfctx;
+	u16 reserved3;
+	u8 pprx;
+	u8 pfcrx;
+	u16 reserved4;
+};
+
+struct mlx4_set_port_rqp_calc_context {
+	__be32 base_qpn;
+	u8 rererved;
+	u8 n_mac;
+	u8 n_vlan;
+	u8 n_prio;
+	u8 reserved2[3];
+	u8 mac_miss;
+	u8 intra_no_vlan;
+	u8 no_vlan;
+	u8 intra_vlan_miss;
+	u8 vlan_miss;
+	u8 reserved3[3];
+	u8 no_vlan_prio;
+	__be32 promisc;
+	__be32 mcast;
+};
+
+
 struct mlx4_port_info {
 	struct mlx4_dev	       *dev;
 	int			port;
@@ -553,5 +610,11 @@ int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
 int mlx4_MCAST_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
 						     struct mlx4_cmd_mailbox *inbox,
 						     struct mlx4_cmd_mailbox *outbox);
+int mlx4_SET_MCAST_FLTR_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+				struct mlx4_cmd_mailbox *inbox,
+				struct mlx4_cmd_mailbox *outbox);
+int mlx4_SET_VLAN_FLTR_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+				struct mlx4_cmd_mailbox *inbox,
+				struct mlx4_cmd_mailbox *outbox);
 
 #endif /* MLX4_H */
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index b55e46c..2204ec3 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -555,7 +555,6 @@ void mlx4_en_release_rss_steer(struct mlx4_en_priv *priv);
 int mlx4_en_free_tx_buf(struct net_device *dev, struct mlx4_en_tx_ring *ring);
 void mlx4_en_rx_irq(struct mlx4_cq *mcq);
 
-int mlx4_SET_MCAST_FLTR(struct mlx4_dev *dev, u8 port, u64 mac, u64 clear, u8 mode);
 int mlx4_SET_VLAN_FLTR(struct mlx4_dev *dev, u8 port, struct vlan_group *grp);
 int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx);
diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index b67aadd..2437720 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -32,6 +32,7 @@
 
 #include <linux/errno.h>
 #include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 
 #include <linux/mlx4/cmd.h>
 
@@ -348,9 +349,8 @@ int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps)
 	return err;
 }
 
-int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
-							struct mlx4_cmd_mailbox *inbox,
-							struct mlx4_cmd_mailbox *outbox)
+static int mlx4_common_set_port(struct mlx4_dev *dev, int slave, u32 in_mod,
+				u8 op_mod, struct mlx4_cmd_mailbox *inbox)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_port_info *port_info;
@@ -370,9 +370,9 @@ int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhc
 	__be32 slave_cap_mask;
 	__be32 new_cap_mask;
 
-	port = vhcr->in_modifier & 0xff;
-	in_modifier = vhcr->in_modifier >> 8;
-	is_eth = vhcr->op_modifier;
+	port = in_mod & 0xff;
+	in_modifier = in_mod >> 8;
+	is_eth = op_mod;
 	port_info = &priv->port[port];
 
 	/* All slaves can perform SET_PORT operations, just need to verify
@@ -417,10 +417,8 @@ int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhc
 			gen_context->mtu = cpu_to_be16(master->max_mtu[port]);
 			break;
 		}
-		return mlx4_cmd(dev, inbox->dma, vhcr->in_modifier,
-						 vhcr->op_modifier,
-						 MLX4_CMD_SET_PORT,
-						 MLX4_CMD_TIME_CLASS_B);
+		return mlx4_cmd(dev, inbox->dma, in_mod, op_mod,
+				MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B);
 	}
 
 	/* For IB, we only consider:
@@ -471,6 +469,16 @@ int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhc
 	return err;
 }
 
+int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave,
+			  struct mlx4_vhcr *vhcr,
+			  struct mlx4_cmd_mailbox *inbox,
+			  struct mlx4_cmd_mailbox *outbox)
+{
+	return mlx4_common_set_port(dev, slave, vhcr->in_modifier,
+				    vhcr->op_modifier, inbox);
+}
+
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -486,9 +494,305 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 	memset(mailbox->buf, 0, 256);
 
 	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
-	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
+
+	if (mlx4_is_master(dev))
+		err = mlx4_common_set_port(dev, dev->caps.function, port, 0, mailbox);
+	else
+		err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
+			       MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+
+int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
+			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_set_port_general_context *context;
+	int err;
+	u32 in_mod;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	context = mailbox->buf;
+	memset(context, 0, sizeof *context);
+
+	context->flags = SET_PORT_GEN_ALL_VALID;
+	context->mtu = cpu_to_be16(mtu);
+	context->pptx = (pptx * (!pfctx)) << 7;
+	context->pfctx = pfctx;
+	context->pprx = (pprx * (!pfcrx)) << 7;
+	context->pfcrx = pfcrx;
+
+	in_mod = MLX4_SET_PORT_GENERAL << 8 | port;
+	if (mlx4_is_master(dev))
+		err = mlx4_common_set_port(dev, dev->caps.function, in_mod, 1, mailbox);
+	else
+		err = mlx4_cmd(dev, mailbox->dma, in_mod, 1, MLX4_CMD_SET_PORT,
+			       MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+EXPORT_SYMBOL(mlx4_SET_PORT_general);
+
+int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
+			   u8 promisc)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_set_port_rqp_calc_context *context;
+	int err;
+	u32 in_mod;
+	u32 m_promisc = (dev->caps.vep_mc_steering) ? MCAST_DIRECT : MCAST_DEFAULT;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	context = mailbox->buf;
+	memset(context, 0, sizeof *context);
+
+	context->base_qpn = cpu_to_be32(base_qpn);
+	context->n_mac = 0x7;
+	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_SHIFT |
+				       base_qpn);
+	context->mcast = cpu_to_be32(m_promisc << SET_PORT_MC_PROMISC_SHIFT |
+				     base_qpn);
+	context->intra_no_vlan = 0;
+	context->no_vlan = MLX4_NO_VLAN_IDX;
+	context->intra_vlan_miss = 0;
+	context->vlan_miss = MLX4_VLAN_MISS_IDX;
+
+	in_mod = MLX4_SET_PORT_RQP_CALC << 8 | port;
+	if (mlx4_is_master(dev))
+		err = mlx4_common_set_port(dev, dev->caps.function, in_mod, 1, mailbox);
+	else
+		err = mlx4_cmd(dev, mailbox->dma, in_mod, 1, MLX4_CMD_SET_PORT,
+			       MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+EXPORT_SYMBOL(mlx4_SET_PORT_qpn_calc);
+
+static int mlx4_common_set_mcast_fltr(struct mlx4_dev *dev, int function,
+				      int port, u64 addr, u64 clear, u8 mode)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err = 0;
+	struct mlx4_mcast_entry *entry, *tmp;
+	struct mlx4_slave_state *s_state = &priv->mfunc.master.slave_state[function];
+	int i;
+
+	switch (mode) {
+	case MLX4_MCAST_DISABLE:
+		/* The multicast filter is disabled only once,
+		 * If some other function already done it, operation
+		 * is ignored */
+		if (!(priv->mfunc.master.disable_mcast_ref[port]++))
+			err = mlx4_cmd(dev, 0, port, MLX4_MCAST_DISABLE,
+					MLX4_CMD_SET_MCAST_FLTR,
+					MLX4_CMD_TIME_CLASS_B);
+		break;
+	case MLX4_MCAST_ENABLE:
+		/* We enable the muticast filter only if all functions
+		 * have the filter enabled */
+		if (!(--priv->mfunc.master.disable_mcast_ref[port]))
+			err = mlx4_cmd(dev, 0, port, MLX4_MCAST_ENABLE,
+					MLX4_CMD_SET_MCAST_FLTR,
+					MLX4_CMD_TIME_CLASS_B);
+		break;
+	case MLX4_MCAST_CONFIG:
+		if (clear) {
+			/* Disable the muticast filter while updating it */
+			if (!priv->mfunc.master.disable_mcast_ref[port]) {
+				err = mlx4_cmd(dev, 0, port, MLX4_MCAST_DISABLE,
+						MLX4_CMD_SET_MCAST_FLTR,
+						MLX4_CMD_TIME_CLASS_B);
+				if (err) {
+					mlx4_warn(dev, "Failed to disable multicast "
+						       "filter\n");
+					goto out;
+				}
+			}
+			/* Clear the multicast filter */
+			err = mlx4_cmd(dev, clear << 63, port,
+				       MLX4_MCAST_CONFIG,
+				       MLX4_CMD_SET_MCAST_FLTR,
+				       MLX4_CMD_TIME_CLASS_B);
+			if (err) {
+				mlx4_warn(dev, "Failed clearing the multicast filter\n");
+				goto out;
+			}
+
+			/* Clear the multicast addresses for the given slave */
+			list_for_each_entry_safe(entry, tmp,
+						 &s_state->mcast_filters[port],
+						 list) {
+				list_del(&entry->list);
+				kfree(entry);
+			}
+
+			/* Assign all the multicast addresses that still exist */
+			for (i = 0; i < dev->num_slaves; i++) {
+				list_for_each_entry(entry,
+					&priv->mfunc.master.slave_state[function].mcast_filters[port],
+					list) {
+					if (mlx4_cmd(dev, entry->addr, port,
+						     MLX4_MCAST_CONFIG,
+						     MLX4_CMD_SET_MCAST_FLTR,
+						     MLX4_CMD_TIME_CLASS_B))
+						mlx4_warn(dev, "Failed to reconfigure "
+							  "multicast address: 0x%llx\n",
+							  entry->addr);
+				}
+			}
+			/* Enable the filter */
+			if (!priv->mfunc.master.disable_mcast_ref[port]) {
+				err = mlx4_cmd(dev, 0, port, MLX4_MCAST_ENABLE,
+						MLX4_CMD_SET_MCAST_FLTR,
+						MLX4_CMD_TIME_CLASS_B);
+				if (err) {
+					mlx4_warn(dev, "Failed to enable multicast "
+						       "filter\n");
+					goto out;
+				}
+			}
+		}
+		/* Add the new address if exists */
+		if (addr) {
+			entry = kzalloc(sizeof (struct mlx4_mcast_entry),
+					GFP_KERNEL);
+			if (!entry) {
+				mlx4_warn(dev, "Failed to allocate entry for "
+					       "muticast address\n");
+				err = -ENOMEM;
+				goto out;
+			}
+			INIT_LIST_HEAD(&entry->list);
+			entry->addr = addr;
+			list_add_tail(&entry->list, &s_state->mcast_filters[port]);
+			err = mlx4_cmd(dev, addr, port, MLX4_MCAST_CONFIG,
+				       MLX4_CMD_SET_MCAST_FLTR,
+				       MLX4_CMD_TIME_CLASS_B);
+			if (err)
+				mlx4_warn(dev, "Failed to add the new address:"
+					       "0x%llx\n", addr);
+		}
+		break;
+	default:
+		mlx4_warn(dev, "SET_MCAST_FILTER called with illegal modifier\n");
+		err = -EINVAL;
+	}
+out:
+	return err;
+}
+
+int mlx4_SET_MCAST_FLTR_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+				struct mlx4_cmd_mailbox *inbox,
+				struct mlx4_cmd_mailbox *outbox)
+{
+	int port = vhcr->in_modifier;
+	u64 addr = vhcr->in_param & 0xffffffffffffULL;
+	u64 clear = vhcr->in_param >> 63;
+	u8 mode = vhcr->op_modifier;
+
+	return mlx4_common_set_mcast_fltr(dev, slave, port, addr, clear, mode);
+}
+
+int mlx4_SET_MCAST_FLTR(struct mlx4_dev *dev, u8 port,
+			u64 mac, u64 clear, u8 mode)
+{
+	if (mlx4_is_master(dev))
+		return mlx4_common_set_mcast_fltr(dev, dev->caps.function,
+						  port, mac, clear, mode);
+	else
+		return mlx4_cmd(dev, (mac | (clear << 63)), port, mode,
+				MLX4_CMD_SET_MCAST_FLTR, MLX4_CMD_TIME_CLASS_B);
+}
+EXPORT_SYMBOL(mlx4_SET_MCAST_FLTR);
+
+
+static int mlx4_common_set_vlan_fltr(struct mlx4_dev *dev, int function,
+				     int port, void *buf)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_vlan_fltr *filter;
+	struct mlx4_slave_state *s_state = &priv->mfunc.master.slave_state[function];
+	int i, j, err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	/* Update slave's Vlan filter */
+	memcpy(s_state->vlan_filter[port]->entry, buf,
+	       sizeof(struct mlx4_vlan_fltr));
+
+	/* We configure the Vlan filter to allow the vlans of
+	 * all slaves */
+	filter = mailbox->buf;
+	memset(filter, 0, sizeof(*filter));
+	for (i = VLAN_FLTR_SIZE - 1; i >= 0; i--) {
+		for (j = 0; j < dev->num_slaves; j++) {
+			s_state = &priv->mfunc.master.slave_state[j];
+			filter->entry[i] |= s_state->vlan_filter[port]->entry[i];
+		}
+	}
+	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_VLAN_FLTR,
 		       MLX4_CMD_TIME_CLASS_B);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+int mlx4_SET_VLAN_FLTR_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+			       struct mlx4_cmd_mailbox *inbox,
+			       struct mlx4_cmd_mailbox *outbox)
+{
+	return mlx4_common_set_vlan_fltr(dev, slave, vhcr->in_modifier,
+					 inbox->buf);
+}
+
+
+int mlx4_SET_VLAN_FLTR(struct mlx4_dev *dev, u8 port, struct vlan_group *grp)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_vlan_fltr *filter;
+	int i;
+	int j;
+	int index = 0;
+	u32 entry;
+	int err = 0;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	filter = mailbox->buf;
+	if (grp) {
+		memset(filter, 0, sizeof *filter);
+		for (i = VLAN_FLTR_SIZE - 1; i >= 0; i--) {
+			entry = 0;
+			for (j = 0; j < 32; j++)
+				if (vlan_group_get_device(grp, index++))
+					entry |= 1 << j;
+			filter->entry[i] = cpu_to_be32(entry);
+		}
+	} else {
+		/* When no vlans are configured we block all vlans */
+		memset(filter, 0, sizeof(*filter));
+	}
+	if (mlx4_is_master(dev))
+		err = mlx4_common_set_vlan_fltr(dev, dev->caps.function,
+						port, mailbox->buf);
+	else
+		err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_VLAN_FLTR,
+			       MLX4_CMD_TIME_CLASS_B);
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return err;
 }
+EXPORT_SYMBOL(mlx4_SET_VLAN_FLTR);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 5911dc0..b999e39 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -493,6 +493,11 @@ void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq);
 int mlx4_srq_arm(struct mlx4_dev *dev, struct mlx4_srq *srq, int limit_watermark);
 int mlx4_srq_query(struct mlx4_dev *dev, struct mlx4_srq *srq, int *limit_watermark);
 
+int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
+			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx);
+int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
+			   u8 promisc);
+
 int mlx4_INIT_PORT(struct mlx4_dev *dev, int port);
 int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port);
 
@@ -500,6 +505,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  int block_mcast_loopback, enum mlx4_protocol prot);
 int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  enum mlx4_protocol prot);
+int mlx4_SET_MCAST_FLTR(struct mlx4_dev *dev, u8 port, u64 mac, u64 clear, u8 mode);
 
 int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn);
 void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int qpn);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
