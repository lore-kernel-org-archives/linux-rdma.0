From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 12/19 V4] mlx4_core: slave multicast support
Date: Thu, 10 Jun 2010 22:04:19 +0300
Message-ID: <4C113733.5030706@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Multicast table processing requires multiple related commands.
To keep things simple, low-level multicast handling is done only by the master;
a new virtual command is added to allow slaves to attach/detach QPs to mulitcast
groups at a higher abstraction level.
The multicast attachment mechanism is used both by IB and Ethernet,
so we need to specify for each multicast address (whether it is gid or mac)
its protocol.
For ethernet addresses, their VEP number should be specified. This field is
set according device capabilities. Search and hash calculation is also done
according to this field.
A Ethernet ports now need to register to the multicast groups, we can not longer
use the default multicast queue per port because of the multiple "clients" per port.

Signed-off-by: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    6 +-
 drivers/net/mlx4/cmd.c            |    8 +++
 drivers/net/mlx4/en_netdev.c      |   42 ++++++++++++-
 drivers/net/mlx4/en_port.c        |    4 +-
 drivers/net/mlx4/en_port.h        |    5 ++
 drivers/net/mlx4/fw.c             |    4 +
 drivers/net/mlx4/fw.h             |    2 +
 drivers/net/mlx4/main.c           |    2 +
 drivers/net/mlx4/mcg.c            |  127 +++++++++++++++++++++++++++++++-----
 drivers/net/mlx4/mlx4.h           |    4 +
 drivers/net/mlx4/port.c           |    4 +-
 include/linux/mlx4/cmd.h          |    1 +
 include/linux/mlx4/device.h       |   14 ++++-
 13 files changed, 196 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4e94e36..2c28f98 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -452,13 +452,15 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	return mlx4_multicast_attach(to_mdev(ibqp->device)->dev,
 				     &to_mqp(ibqp)->mqp, gid->raw,
 				     !!(to_mqp(ibqp)->flags &
-					MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK));
+					MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
+				     MLX4_PROT_IB_IPV6);
 }
 
 static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
 	return mlx4_multicast_detach(to_mdev(ibqp->device)->dev,
-				     &to_mqp(ibqp)->mqp, gid->raw);
+				     &to_mqp(ibqp)->mqp, gid->raw,
+				     MLX4_PROT_IB_IPV6);
 }
 
 static int init_node_data(struct mlx4_ib_dev *dev)
diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index b25e40e..0f45fde 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -903,6 +903,14 @@ static struct mlx4_cmd_info {
 
 	/* Native multicast commands are not available for guests */
 	{
+		.opcode = MLX4_CMD_MCAST_ATTACH,
+		.has_inbox = true,
+		.has_outbox = false,
+		.out_is_imm = false,
+		.verify = NULL,
+		.wrapper = mlx4_MCAST_wrapper
+	},
+	{
 		.opcode = MLX4_CMD_DIAG_RPRT,
 		.has_inbox = false,
 		.has_outbox = true,
diff --git a/drivers/net/mlx4/en_netdev.c b/drivers/net/mlx4/en_netdev.c
index 7389fa2..5ebe135 100644
--- a/drivers/net/mlx4/en_netdev.c
+++ b/drivers/net/mlx4/en_netdev.c
@@ -173,6 +173,7 @@ static void mlx4_en_cache_mclist(struct net_device *dev)
 	int mc_addrs_cnt = netdev_mc_count(dev);
 	int i;
 
+	mlx4_en_clear_list(dev);
 	mc_addrs = kmalloc(mc_addrs_cnt * ETH_ALEN, GFP_ATOMIC);
 	if (!mc_addrs) {
 		en_err(priv, "failed to allocate multicast list\n");
@@ -203,6 +204,7 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct net_device *dev = priv->dev;
 	u64 mcast_addr = 0;
+	u8 mc_list[16] = {0};
 	int err;
 
 	mutex_lock(&mdev->state_lock);
@@ -284,6 +286,14 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 		if (err)
 			en_err(priv, "Failed disabling multicast filter\n");
 
+		/* Detach our qp from all the multicast addresses */
+		for (i = 0; i < priv->mc_addrs_cnt; i++) {
+			memcpy(&mc_list[10], priv->mc_addrs + i * ETH_ALEN,
+			       ETH_ALEN);
+			mc_list[7] = (priv->port - 1) << 4;
+			mlx4_multicast_detach(mdev->dev, &priv->rss_map.indir_qp,
+					      mc_list, MLX4_PROT_ETH);
+		}
 		/* Flush mcast filter and init it with broadcast address */
 		mlx4_SET_MCAST_FLTR(mdev->dev, priv->port, ETH_BCAST,
 				    1, MLX4_MCAST_CONFIG);
@@ -294,6 +304,11 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 		mlx4_en_cache_mclist(dev);
 		netif_tx_unlock_bh(dev);
 		for (i = 0; i < priv->mc_addrs_cnt; i++) {
+			memcpy(&mc_list[10], priv->mc_addrs + i * ETH_ALEN,
+			       ETH_ALEN);
+			mc_list[7] = (priv->port - 1) << 4;
+			mlx4_multicast_attach(mdev->dev, &priv->rss_map.indir_qp,
+					      mc_list, 0, MLX4_PROT_ETH);
 			mcast_addr =
 			      mlx4_en_mac_to_u64(priv->mc_addrs + i * ETH_ALEN);
 			mlx4_SET_MCAST_FLTR(mdev->dev, priv->port,
@@ -303,8 +318,6 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 					  0, MLX4_MCAST_ENABLE);
 		if (err)
 			en_err(priv, "Failed enabling multicast filter\n");
-
-		mlx4_en_clear_list(dev);
 	}
 out:
 	mutex_unlock(&mdev->state_lock);
@@ -550,6 +563,7 @@ int mlx4_en_start_port(struct net_device *dev)
 	int err = 0;
 	int i;
 	int j;
+	u8 mc_list[16] = {0};
 
 	if (priv->port_up) {
 		en_dbg(DRV, priv, "start port called while port already up\n");
@@ -662,6 +676,13 @@ int mlx4_en_start_port(struct net_device *dev)
 		goto tx_err;
 	}
 
+	/* Attach rx QP to bradcast address */
+	memset(&mc_list[10], 0xff, ETH_ALEN);
+	mc_list[7] = (priv->port - 1) << 4;
+	if (mlx4_multicast_attach(mdev->dev, &priv->rss_map.indir_qp, mc_list,
+				  0, MLX4_PROT_ETH))
+		mlx4_warn(mdev, "Failed Attaching Broadcast\n");
+
 	/* Schedule multicast task to populate multicast list */
 	queue_work(mdev->workqueue, &priv->mcast_task);
 
@@ -693,6 +714,7 @@ void mlx4_en_stop_port(struct net_device *dev)
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	int i;
+	u8 mc_list[16] = {0};
 
 	if (!priv->port_up) {
 		en_dbg(DRV, priv, "stop port called while port already down\n");
@@ -708,6 +730,22 @@ void mlx4_en_stop_port(struct net_device *dev)
 	priv->port_up = false;
 	mlx4_CLOSE_PORT(mdev->dev, priv->port);
 
+	/* Detach All multicasts */
+	memset(&mc_list[10], 0xff, ETH_ALEN);
+	mc_list[7] = (priv->port - 1) << 4;
+	mlx4_multicast_detach(mdev->dev, &priv->rss_map.indir_qp, mc_list,
+			      MLX4_PROT_ETH);
+	for (i = 0; i < priv->mc_addrs_cnt; i++) {
+		memcpy(&mc_list[10], priv->mc_addrs + i * ETH_ALEN,
+		       ETH_ALEN);
+		mc_list[7] = (priv->port - 1) << 4;
+		mlx4_multicast_detach(mdev->dev, &priv->rss_map.indir_qp,
+				      mc_list, MLX4_PROT_ETH);
+	}
+	mlx4_en_clear_list(dev);
+	/* Flush multicast filter */
+	mlx4_SET_MCAST_FLTR(mdev->dev, priv->port, 0, 1, MLX4_MCAST_CONFIG);
+
 	/* Unregister Mac address for the port */
 	mlx4_unregister_mac(mdev->dev, priv->port, priv->base_qpn);
 
diff --git a/drivers/net/mlx4/en_port.c b/drivers/net/mlx4/en_port.c
index c099cb4..32a9943 100644
--- a/drivers/net/mlx4/en_port.c
+++ b/drivers/net/mlx4/en_port.c
@@ -119,6 +119,7 @@ int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
 	struct mlx4_set_port_rqp_calc_context *context;
 	int err;
 	u32 in_mod;
+	u32 m_promisc = (dev->caps.vep_mc_steering) ? MCAST_DIRECT : MCAST_DEFAULT;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
@@ -129,7 +130,8 @@ int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
 	context->base_qpn = cpu_to_be32(base_qpn);
 	context->n_mac = 0x7;
 	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_SHIFT | base_qpn);
-	context->mcast = cpu_to_be32(1 << SET_PORT_PROMISC_SHIFT | base_qpn);
+	context->mcast = cpu_to_be32((m_promisc << SET_PORT_MC_PROMISC_SHIFT) |
+				     base_qpn);
 	context->intra_no_vlan = 0;
 	context->no_vlan = MLX4_NO_VLAN_IDX;
 	context->intra_vlan_miss = 0;
diff --git a/drivers/net/mlx4/en_port.h b/drivers/net/mlx4/en_port.h
index 80e6269..beaddff 100644
--- a/drivers/net/mlx4/en_port.h
+++ b/drivers/net/mlx4/en_port.h
@@ -39,6 +39,11 @@
 #define SET_PORT_PROMISC_SHIFT		31
 #define SET_PORT_MC_PROMISC_SHIFT	30
 
+enum {
+	MCAST_DIRECT_ONLY       = 0,
+	MCAST_DIRECT            = 1,
+	MCAST_DEFAULT           = 2
+};
 
 struct mlx4_set_port_general_context {
 	u8 reserved[3];
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 55377c0..e53a392 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -229,6 +229,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAX_GID_OFFSET		0x3b
 #define QUERY_DEV_CAP_RATE_SUPPORT_OFFSET	0x3c
 #define QUERY_DEV_CAP_MAX_PKEY_OFFSET		0x3f
+#define QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET	0x43
 #define QUERY_DEV_CAP_FLAGS_OFFSET		0x44
 #define QUERY_DEV_CAP_RSVD_UAR_OFFSET		0x48
 #define QUERY_DEV_CAP_UAR_SZ_OFFSET		0x49
@@ -323,6 +324,9 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev_cap->max_msg_sz = 1 << (field & 0x1f);
 	MLX4_GET(stat_rate, outbox, QUERY_DEV_CAP_RATE_SUPPORT_OFFSET);
 	dev_cap->stat_rate_support = stat_rate;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET);
+	dev_cap->vep_uc_steering = field & 0x4;
+	dev_cap->vep_mc_steering = field & 0x8;
 	MLX4_GET(dev_cap->flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_UAR_OFFSET);
 	dev_cap->reserved_uars = field >> 4;
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index 9fd15f1..d5c17cf 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -76,6 +76,8 @@ struct mlx4_dev_cap {
 	u16 eth_mtu[MLX4_MAX_PORTS + 1];
 	u16 stat_rate_support;
 	u32 flags;
+	int vep_uc_steering;
+	int vep_mc_steering;
 	int reserved_uars;
 	int uar_size;
 	int min_page_sz;
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index e670aa0..b1eb69e 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -245,6 +245,8 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.bmme_flags	     = dev_cap->bmme_flags;
 	dev->caps.reserved_lkey	     = dev_cap->reserved_lkey;
 	dev->caps.stat_rate_support  = dev_cap->stat_rate_support;
+	dev->caps.vep_uc_steering    = dev_cap->vep_uc_steering;
+	dev->caps.vep_mc_steering    = dev_cap->vep_mc_steering;
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;
 
 	dev->caps.log_num_macs  = log_num_mac;
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index b8c7a72..e3dc486 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -65,12 +65,12 @@ static int mlx4_WRITE_MCG(struct mlx4_dev *dev, int index,
 }
 
 static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
-			  u16 *hash)
+			  u16 *hash, u8 op_mod)
 {
 	u64 imm;
 	int err;
 
-	err = mlx4_cmd_imm(dev, mailbox->dma, &imm, 0, 0, MLX4_CMD_MGID_HASH,
+	err = mlx4_cmd_imm(dev, mailbox->dma, &imm, 0, op_mod, MLX4_CMD_MGID_HASH,
 			   MLX4_CMD_TIME_CLASS_A);
 
 	if (!err)
@@ -95,13 +95,15 @@ static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
  * entry in hash chain and *mgm holds end of hash chain.
  */
 static int find_mgm(struct mlx4_dev *dev,
-		    u8 *gid, struct mlx4_cmd_mailbox *mgm_mailbox,
+		    u8 *gid, enum mlx4_protocol prot,
+		    struct mlx4_cmd_mailbox *mgm_mailbox,
 		    u16 *hash, int *prev, int *index)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	struct mlx4_mgm *mgm = mgm_mailbox->buf;
 	u8 *mgid;
 	int err;
+	u8 op_mod = (prot == MLX4_PROT_ETH) ? !!(dev->caps.vep_mc_steering) : 0;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
@@ -110,7 +112,7 @@ static int find_mgm(struct mlx4_dev *dev,
 
 	memcpy(mgid, gid, 16);
 
-	err = mlx4_MGID_HASH(dev, mailbox, hash);
+	err = mlx4_MGID_HASH(dev, mailbox, hash, op_mod);
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	if (err)
 		return err;
@@ -134,8 +136,9 @@ static int find_mgm(struct mlx4_dev *dev,
 			return err;
 		}
 
-		if (!memcmp(mgm->gid, gid, 16))
-			return err;
+		if (!memcmp(mgm->gid, gid, 16) &&
+				(prot == be32_to_cpu(mgm->members_count) >> 30))
+				return err;
 
 		*prev = *index;
 		*index = be32_to_cpu(mgm->next_gid_index) >> 6;
@@ -145,8 +148,10 @@ static int find_mgm(struct mlx4_dev *dev,
 	return err;
 }
 
-int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
-			  int block_mcast_loopback)
+static int mlx4_multicast_attach_common(struct mlx4_dev *dev,
+					struct mlx4_qp *qp, u8 gid[16],
+					int block_mcast_loopback,
+					enum mlx4_protocol prot)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
@@ -165,7 +170,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	mutex_lock(&priv->mcg_table.mutex);
 
-	err = find_mgm(dev, gid, mailbox, &hash, &prev, &index);
+	err = find_mgm(dev, gid, prot, mailbox, &hash, &prev, &index);
 	if (err)
 		goto out;
 
@@ -207,7 +212,8 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 
-	mgm->members_count       = cpu_to_be32(members_count);
+	mgm->members_count       = cpu_to_be32(members_count | ((u32) prot << 30));
+	mgm->next_gid_index	 = cpu_to_be32(!!(dev->caps.vep_mc_steering) << 4);
 
 	err = mlx4_WRITE_MCG(dev, index, mailbox);
 	if (err)
@@ -220,7 +226,8 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	if (err)
 		goto out;
 
-	mgm->next_gid_index = cpu_to_be32(index << 6);
+	mgm->next_gid_index = cpu_to_be32((index << 6) |
+					  (!!(dev->caps.vep_mc_steering) << 4));
 
 	err = mlx4_WRITE_MCG(dev, prev, mailbox);
 	if (err)
@@ -240,9 +247,10 @@ out:
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return err;
 }
-EXPORT_SYMBOL_GPL(mlx4_multicast_attach);
 
-int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
+static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
+					struct mlx4_qp *qp, u8 gid[16],
+					enum mlx4_protocol prot)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
@@ -252,6 +260,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 	int prev, index;
 	int i, loc;
 	int err;
+	u8 pf_num = gid[7] >> 4;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
@@ -260,7 +269,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 
 	mutex_lock(&priv->mcg_table.mutex);
 
-	err = find_mgm(dev, gid, mailbox, &hash, &prev, &index);
+	err = find_mgm(dev, gid, prot, mailbox, &hash, &prev, &index);
 	if (err)
 		goto out;
 
@@ -282,7 +291,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 	}
 
 
-	mgm->members_count = cpu_to_be32(--members_count);
+	mgm->members_count = cpu_to_be32(--members_count | ((u32) prot << 30));
 	mgm->qp[loc]       = mgm->qp[i - 1];
 	mgm->qp[i - 1]     = 0;
 
@@ -298,8 +307,11 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 			err = mlx4_READ_MCG(dev, amgm_index, mailbox);
 			if (err)
 				goto out;
-		} else
+		} else {
 			memset(mgm->gid, 0, 16);
+			if (prot == MLX4_PROT_ETH)
+				mgm->gid[7] = pf_num << 4;
+		}
 
 		err = mlx4_WRITE_MCG(dev, index, mailbox);
 		if (err)
@@ -315,12 +327,12 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 		}
 	} else {
 		/* Remove entry from AMGM */
-		int cur_next_index = be32_to_cpu(mgm->next_gid_index) >> 6;
+		int cur_next_index = be32_to_cpu(mgm->next_gid_index);
 		err = mlx4_READ_MCG(dev, prev, mailbox);
 		if (err)
 			goto out;
 
-		mgm->next_gid_index = cpu_to_be32(cur_next_index << 6);
+		mgm->next_gid_index = cpu_to_be32(cur_next_index);
 
 		err = mlx4_WRITE_MCG(dev, prev, mailbox);
 		if (err)
@@ -340,6 +352,85 @@ out:
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return err;
 }
+
+int mlx4_MCAST_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+						     struct mlx4_cmd_mailbox *inbox,
+						     struct mlx4_cmd_mailbox *outbox)
+{
+	struct mlx4_qp qp; /* dummy for calling attach/detach */
+	u8 *gid = inbox->buf;
+	enum mlx4_protocol prot = (vhcr->in_modifier >> 28) & 0x7;
+
+	if (prot == MLX4_PROT_ETH)
+		gid[7] |= slave << 4;
+
+	qp.qpn = vhcr->in_modifier & 0xffffff;
+	if (vhcr->op_modifier)
+		return mlx4_multicast_attach_common(dev, &qp, gid,
+					     vhcr->in_modifier >> 31, prot);
+	else
+		return mlx4_multicast_detach_common(dev, &qp, gid, prot);
+}
+
+static int mlx4_MCAST(struct mlx4_dev *dev, struct mlx4_qp *qp,
+		      u8 gid[16], u8 attach, u8 block_loopback,
+		      enum mlx4_protocol prot)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+	int qpn;
+
+	if (!mlx4_is_slave(dev))
+		return -EBADF;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	memcpy(mailbox->buf, gid, 16);
+	qpn = qp->qpn;
+	qpn |= (prot << 28);
+	if (attach && block_loopback)
+		qpn |= (1 << 31);
+
+	err = mlx4_cmd(dev, mailbox->dma, qpn, attach, MLX4_CMD_MCAST_ATTACH,
+						       MLX4_CMD_TIME_CLASS_A);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+
+int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+			  int block_mcast_loopback, enum mlx4_protocol prot)
+{
+	if (prot == MLX4_PROT_ETH && !dev->caps.vep_mc_steering)
+		return 0;
+
+	if (mlx4_is_slave(dev))
+		return mlx4_MCAST(dev, qp, gid, 1, block_mcast_loopback, prot);
+
+	if (mlx4_is_master(dev) && prot == MLX4_PROT_ETH)
+		gid[7] |= dev->caps.function << 4;
+
+	return mlx4_multicast_attach_common(dev, qp, gid,
+					    block_mcast_loopback, prot);
+}
+EXPORT_SYMBOL_GPL(mlx4_multicast_attach);
+
+int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+						enum mlx4_protocol prot)
+{
+	if (prot == MLX4_PROT_ETH && !dev->caps.vep_mc_steering)
+		return 0;
+
+	if (mlx4_is_slave(dev))
+		return mlx4_MCAST(dev, qp, gid, 0, 0, prot);
+
+	if (mlx4_is_master(dev) && prot == MLX4_PROT_ETH)
+		gid[7] |= dev->caps.function << 4;
+
+	return mlx4_multicast_detach_common(dev, qp, gid, prot);
+}
 EXPORT_SYMBOL_GPL(mlx4_multicast_detach);
 
 int mlx4_init_mcg_table(struct mlx4_dev *dev)
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 1a37f63..56b23f0 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -550,4 +550,8 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *v
 							  struct mlx4_cmd_mailbox *outbox);
 int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
 
+int mlx4_MCAST_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
+						     struct mlx4_cmd_mailbox *inbox,
+						     struct mlx4_cmd_mailbox *outbox);
+
 #endif /* MLX4_H */
diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 902bd94..b67aadd 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -389,9 +389,9 @@ int mlx4_SET_PORT_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhc
 				promisc << SET_PORT_PROMISC_SHIFT |
 				port_info->base_qpn);
 			promisc = be32_to_cpu(qpn_context->mcast) >>
-				SET_PORT_PROMISC_SHIFT;
+				SET_PORT_MC_PROMISC_SHIFT;
 			qpn_context->mcast = cpu_to_be32(
-				promisc << SET_PORT_PROMISC_SHIFT |
+				promisc << SET_PORT_MC_PROMISC_SHIFT |
 				port_info->base_qpn);
 			break;
 		case MLX4_SET_PORT_GENERAL:
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 01a1873..236e03f 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -131,6 +131,7 @@ enum {
 	MLX4_CMD_REPLACE_RES	 = 0xf02,
 	MLX4_CMD_GET_EVENT	 = 0xf03,
 	MLX4_CMD_QUERY_SLAVE_CAP = 0xf04,
+	MLX4_CMD_MCAST_ATTACH    = 0xf05,
 
 	/* debug commands */
 	MLX4_CMD_QUERY_DEBUG_MSG = 0x2a,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 0765845..5911dc0 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -148,6 +148,13 @@ enum {
 	MLX4_STAT_RATE_OFFSET	= 5
 };
 
+enum mlx4_protocol {
+	MLX4_PROT_IB_IPV6 = 0,
+	MLX4_PROT_ETH,
+	MLX4_PROT_IB_IPV4,
+	MLX4_PROT_FCOE
+};
+
 enum {
 	MLX4_MTT_FLAG_PRESENT		= 1
 };
@@ -240,6 +247,8 @@ struct mlx4_caps {
 	u32			bmme_flags;
 	u32			reserved_lkey;
 	u16			stat_rate_support;
+	int			vep_uc_steering;
+	int			vep_mc_steering;
 	u8			port_width_cap[MLX4_MAX_PORTS + 1];
 	int			max_gso_sz;
 	int                     reserved_qps_cnt[MLX4_NUM_QP_REGION];
@@ -488,8 +497,9 @@ int mlx4_INIT_PORT(struct mlx4_dev *dev, int port);
 int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port);
 
 int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
-			  int block_mcast_loopback);
-int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16]);
+			  int block_mcast_loopback, enum mlx4_protocol prot);
+int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+			  enum mlx4_protocol prot);
 
 int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn);
 void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int qpn);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
