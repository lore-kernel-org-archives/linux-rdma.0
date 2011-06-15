From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/9] mlx4: align current extended capabilities to use the
 flags field
Date: Wed, 15 Jun 2011 17:42:56 +0300
Message-ID: <alpine.LRH.2.00.1106151742330.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Query another dword containing up to 32 extended device capabilities,
such that the 64 bit dev cap flags field contains both the extended
and the non-extended device flags. Align the code which handles the
current extended device capabilities (e.g udp rss, wol, vep steering,
etc) to use the extended device cap flags field instead of a field per
extended capability. Initial patch done by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>


Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

---
 drivers/net/mlx4/en_ethtool.c  |    9 +++++----
 drivers/net/mlx4/en_main.c     |    3 ++-
 drivers/net/mlx4/en_netdev.c   |    5 +++--
 drivers/net/mlx4/en_port.c     |    6 ++++--
 drivers/net/mlx4/en_selftest.c |    3 ++-
 drivers/net/mlx4/fw.c          |   24 +++++++++++-------------
 drivers/net/mlx4/fw.h          |    5 -----
 drivers/net/mlx4/main.c        |    5 -----
 drivers/net/mlx4/mcg.c         |   17 ++++++++++-------
 drivers/net/mlx4/port.c        |    8 ++++----
 include/linux/mlx4/device.h    |   12 ++++++------
 11 files changed, 47 insertions(+), 50 deletions(-)

Index: b/drivers/net/mlx4/fw.c
===================================================================
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -99,7 +99,12 @@ static void dump_dev_cap_flags(struct ml
 		[21] = "UD multicast support",
 		[24] = "Demand paging support",
 		[25] = "Router support",
-		[30] = "IBoE support"
+		[30] = "IBoE support",
+		[32] = "Unicast loopback support",
+		[38] = "Wake On LAN support",
+		[40] = "UDP RSS support",
+		[41] = "Unicast VEP steering support",
+		[42] = "Multicast VEP steering support"
 	};
 	int i;

@@ -142,7 +147,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 	struct mlx4_cmd_mailbox *mailbox;
 	u32 *outbox;
 	u8 field;
-	u32 field32, flags;
+	u32 field32, flags, ext_flags;
 	u16 size;
 	u16 stat_rate;
 	int err;
@@ -180,8 +185,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 #define QUERY_DEV_CAP_MAX_GID_OFFSET		0x3b
 #define QUERY_DEV_CAP_RATE_SUPPORT_OFFSET	0x3c
 #define QUERY_DEV_CAP_MAX_PKEY_OFFSET		0x3f
-#define QUERY_DEV_CAP_UDP_RSS_OFFSET		0x42
-#define QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET	0x43
+#define QUERY_DEV_CAP_EXT_FLAGS_OFFSET		0x40
 #define QUERY_DEV_CAP_FLAGS_OFFSET		0x44
 #define QUERY_DEV_CAP_RSVD_UAR_OFFSET		0x48
 #define QUERY_DEV_CAP_UAR_SZ_OFFSET		0x49
@@ -272,15 +276,9 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 	dev_cap->max_msg_sz = 1 << (field & 0x1f);
 	MLX4_GET(stat_rate, outbox, QUERY_DEV_CAP_RATE_SUPPORT_OFFSET);
 	dev_cap->stat_rate_support = stat_rate;
-	MLX4_GET(field, outbox, QUERY_DEV_CAP_UDP_RSS_OFFSET);
-	dev_cap->udp_rss = field & 0x1;
-	dev_cap->vep_uc_steering = field & 0x2;
-	dev_cap->vep_mc_steering = field & 0x4;
-	MLX4_GET(field, outbox, QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET);
-	dev_cap->loopback_support = field & 0x1;
-	dev_cap->wol = field & 0x40;
+	MLX4_GET(ext_flags, outbox, QUERY_DEV_CAP_EXT_FLAGS_OFFSET);
 	MLX4_GET(flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
-	dev_cap->flags = flags;
+	dev_cap->flags = flags | (u64)ext_flags << 32;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_UAR_OFFSET);
 	dev_cap->reserved_uars = field >> 4;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_UAR_SZ_OFFSET);
@@ -802,7 +800,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev,
 	MLX4_PUT(inbox, param->mc_base,		INIT_HCA_MC_BASE_OFFSET);
 	MLX4_PUT(inbox, param->log_mc_entry_sz, INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET);
 	MLX4_PUT(inbox, param->log_mc_hash_sz,  INIT_HCA_LOG_MC_HASH_SZ_OFFSET);
-	if (dev->caps.vep_mc_steering)
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		MLX4_PUT(inbox, (u8) (1 << 3),	INIT_HCA_UC_STEERING_OFFSET);
 	MLX4_PUT(inbox, param->log_mc_table_sz, INIT_HCA_LOG_MC_TABLE_SZ_OFFSET);

Index: b/include/linux/mlx4/device.h
===================================================================
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -73,7 +73,12 @@ enum {
 	MLX4_DEV_CAP_FLAG_RAW_MCAST	= 1LL << 19,
 	MLX4_DEV_CAP_FLAG_UD_AV_PORT	= 1LL << 20,
 	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1LL << 21,
-	MLX4_DEV_CAP_FLAG_IBOE		= 1LL << 30
+	MLX4_DEV_CAP_FLAG_IBOE		= 1LL << 30,
+	MLX4_DEV_CAP_FLAG_UC_LOOPBACK	= 1LL << 32,
+	MLX4_DEV_CAP_FLAG_WOL		= 1LL << 38,
+	MLX4_DEV_CAP_FLAG_UDP_RSS	= 1LL << 40,
+	MLX4_DEV_CAP_FLAG_VEP_UC_STEER	= 1LL << 41,
+	MLX4_DEV_CAP_FLAG_VEP_MC_STEER	= 1LL << 42
 };

 enum {
@@ -257,11 +262,6 @@ struct mlx4_caps {
 	u32			bmme_flags;
 	u32			reserved_lkey;
 	u16			stat_rate_support;
-	int			udp_rss;
-	int			loopback_support;
-	int			vep_uc_steering;
-	int			vep_mc_steering;
-	int			wol;
 	u8			port_width_cap[MLX4_MAX_PORTS + 1];
 	int			max_gso_sz;
 	int                     reserved_qps_cnt[MLX4_NUM_QP_REGION];
Index: b/drivers/net/mlx4/fw.h
===================================================================
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -78,11 +78,6 @@ struct mlx4_dev_cap {
 	u16 wavelength[MLX4_MAX_PORTS + 1];
 	u64 trans_code[MLX4_MAX_PORTS + 1];
 	u16 stat_rate_support;
-	int udp_rss;
-	int loopback_support;
-	int vep_uc_steering;
-	int vep_mc_steering;
-	int wol;
 	u64 flags;
 	int reserved_uars;
 	int uar_size;
Index: b/drivers/net/mlx4/main.c
===================================================================
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -226,11 +226,6 @@ static int mlx4_dev_cap(struct mlx4_dev
 	dev->caps.bmme_flags	     = dev_cap->bmme_flags;
 	dev->caps.reserved_lkey	     = dev_cap->reserved_lkey;
 	dev->caps.stat_rate_support  = dev_cap->stat_rate_support;
-	dev->caps.udp_rss	     = dev_cap->udp_rss;
-	dev->caps.loopback_support   = dev_cap->loopback_support;
-	dev->caps.vep_uc_steering    = dev_cap->vep_uc_steering;
-	dev->caps.vep_mc_steering    = dev_cap->vep_mc_steering;
-	dev->caps.wol		     = dev_cap->wol;
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;

 	dev->caps.log_num_macs  = log_num_mac;
Index: b/drivers/net/mlx4/en_main.c
===================================================================
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -106,7 +106,8 @@ static int mlx4_en_get_profile(struct ml

 	params->tcp_rss = tcp_rss;
 	params->udp_rss = udp_rss;
-	if (params->udp_rss && !mdev->dev->caps.udp_rss) {
+	if (params->udp_rss && !mdev->dev->caps.flags
+					& MLX4_DEV_CAP_FLAG_UDP_RSS) {
 		mlx4_warn(mdev, "UDP RSS is not supported on this device.\n");
 		params->udp_rss = 0;
 	}
Index: b/drivers/net/mlx4/en_ethtool.c
===================================================================
--- a/drivers/net/mlx4/en_ethtool.c
+++ b/drivers/net/mlx4/en_ethtool.c
@@ -135,7 +135,7 @@ static void mlx4_en_get_wol(struct net_d
 	int err = 0;
 	u64 config = 0;

-	if (!priv->mdev->dev->caps.wol) {
+	if (!priv->mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_WOL) {
 		wol->supported = 0;
 		wol->wolopts = 0;
 		return;
@@ -165,7 +165,7 @@ static int mlx4_en_set_wol(struct net_de
 	u64 config = 0;
 	int err = 0;

-	if (!priv->mdev->dev->caps.wol)
+	if (!priv->mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_WOL)
 		return -EOPNOTSUPP;

 	if (wol->supported & ~WAKE_MAGIC)
@@ -201,7 +201,8 @@ static int mlx4_en_get_sset_count(struct
 		return NUM_ALL_STATS +
 			(priv->tx_ring_num + priv->rx_ring_num) * 2;
 	case ETH_SS_TEST:
-		return MLX4_EN_NUM_SELF_TEST - !(priv->mdev->dev->caps.loopback_support) * 2;
+		return MLX4_EN_NUM_SELF_TEST - !(priv->mdev->dev->caps.flags
+					& MLX4_DEV_CAP_FLAG_UC_LOOPBACK) * 2;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -251,7 +252,7 @@ static void mlx4_en_get_strings(struct n
 	case ETH_SS_TEST:
 		for (i = 0; i < MLX4_EN_NUM_SELF_TEST - 2; i++)
 			strcpy(data + i * ETH_GSTRING_LEN, mlx4_en_test_names[i]);
-		if (priv->mdev->dev->caps.loopback_support)
+		if (priv->mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_UC_LOOPBACK)
 			for (; i < MLX4_EN_NUM_SELF_TEST; i++)
 				strcpy(data + i * ETH_GSTRING_LEN, mlx4_en_test_names[i]);
 		break;
Index: b/drivers/net/mlx4/en_selftest.c
===================================================================
--- a/drivers/net/mlx4/en_selftest.c
+++ b/drivers/net/mlx4/en_selftest.c
@@ -159,7 +159,8 @@ retry_tx:
 				goto retry_tx;
 		}

-		if (priv->mdev->dev->caps.loopback_support){
+		if (priv->mdev->dev->caps.flags &
+					MLX4_DEV_CAP_FLAG_UC_LOOPBACK) {
 			buf[3] = mlx4_en_test_registers(priv);
 			buf[4] = mlx4_en_test_loopback(priv);
 		}
Index: b/drivers/net/mlx4/port.c
===================================================================
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -146,7 +146,7 @@ int mlx4_register_mac(struct mlx4_dev *d
 	int i, err = 0;
 	int free = -1;

-	if (dev->caps.vep_uc_steering) {
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER) {
 		err = mlx4_uc_steer_add(dev, port, mac, qpn, 1);
 		if (!err) {
 			entry = kmalloc(sizeof *entry, GFP_KERNEL);
@@ -203,7 +203,7 @@ int mlx4_register_mac(struct mlx4_dev *d
 		goto out;
 	}

-	if (!dev->caps.vep_uc_steering)
+	if (!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER)
 		*qpn = info->base_qpn + free;
 	++table->total;
 out:
@@ -243,7 +243,7 @@ void mlx4_unregister_mac(struct mlx4_dev
 	int index = qpn - info->base_qpn;
 	struct mlx4_mac_entry *entry;

-	if (dev->caps.vep_uc_steering) {
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER) {
 		entry = radix_tree_lookup(&info->mac_tree, qpn);
 		if (entry) {
 			mlx4_uc_steer_release(dev, port, entry->mac, qpn, 1);
@@ -274,7 +274,7 @@ int mlx4_replace_mac(struct mlx4_dev *de
 	struct mlx4_mac_entry *entry;
 	int err;

-	if (dev->caps.vep_uc_steering) {
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER) {
 		entry = radix_tree_lookup(&info->mac_tree, qpn);
 		if (!entry)
 			return -EINVAL;
Index: b/drivers/net/mlx4/en_netdev.c
===================================================================
--- a/drivers/net/mlx4/en_netdev.c
+++ b/drivers/net/mlx4/en_netdev.c
@@ -239,7 +239,8 @@ static void mlx4_en_do_set_multicast(str
 			priv->flags |= MLX4_EN_FLAG_PROMISC;

 			/* Enable promiscouos mode */
-			if (!mdev->dev->caps.vep_uc_steering)
+			if (!mdev->dev->caps.flags &
+						MLX4_DEV_CAP_FLAG_VEP_UC_STEER)
 				err = mlx4_SET_PORT_qpn_calc(mdev->dev, priv->port,
 							     priv->base_qpn, 1);
 			else
@@ -285,7 +286,7 @@ static void mlx4_en_do_set_multicast(str
 		priv->flags &= ~MLX4_EN_FLAG_PROMISC;

 		/* Disable promiscouos mode */
-		if (!mdev->dev->caps.vep_uc_steering)
+		if (!mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER)
 			err = mlx4_SET_PORT_qpn_calc(mdev->dev, priv->port,
 						     priv->base_qpn, 0);
 		else
Index: b/drivers/net/mlx4/en_port.c
===================================================================
--- a/drivers/net/mlx4/en_port.c
+++ b/drivers/net/mlx4/en_port.c
@@ -119,9 +119,11 @@ int mlx4_SET_PORT_qpn_calc(struct mlx4_d
 	struct mlx4_set_port_rqp_calc_context *context;
 	int err;
 	u32 in_mod;
-	u32 m_promisc = (dev->caps.vep_mc_steering) ? MCAST_DIRECT : MCAST_DEFAULT;
+	u32 m_promisc = (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER) ?
+						MCAST_DIRECT : MCAST_DEFAULT;

-	if (dev->caps.vep_mc_steering && dev->caps.vep_uc_steering)
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER  &&
+			dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_UC_STEER)
 		return 0;

 	mailbox = mlx4_alloc_cmd_mailbox(dev);
Index: b/drivers/net/mlx4/mcg.c
===================================================================
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -559,7 +559,8 @@ static int find_entry(struct mlx4_dev *d
 	struct mlx4_mgm *mgm = mgm_mailbox->buf;
 	u8 *mgid;
 	int err;
-	u8 op_mod = (prot == MLX4_PROT_ETH) ? !!(dev->caps.vep_mc_steering) : 0;
+	u8 op_mod = (prot == MLX4_PROT_ETH) ?
+		!!(dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER) : 0;

 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
@@ -834,7 +835,8 @@ int mlx4_multicast_attach(struct mlx4_de

 	steer = (is_valid_ether_addr(&gid[10])) ? MLX4_UC_STEER : MLX4_MC_STEER;

-	if (prot == MLX4_PROT_ETH && !dev->caps.vep_mc_steering)
+	if (prot == MLX4_PROT_ETH &&
+			!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		return 0;

 	if (prot == MLX4_PROT_ETH)
@@ -853,7 +855,8 @@ int mlx4_multicast_detach(struct mlx4_de

 	steer = (is_valid_ether_addr(&gid[10])) ? MLX4_UC_STEER : MLX4_MC_STEER;

-	if (prot == MLX4_PROT_ETH && !dev->caps.vep_mc_steering)
+	if (prot == MLX4_PROT_ETH &&
+			!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		return 0;

 	if (prot == MLX4_PROT_ETH) {
@@ -867,7 +870,7 @@ EXPORT_SYMBOL_GPL(mlx4_multicast_detach)

 int mlx4_multicast_promisc_add(struct mlx4_dev *dev, u32 qpn, u8 port)
 {
-	if (!dev->caps.vep_mc_steering)
+	if (!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		return 0;


@@ -877,7 +880,7 @@ EXPORT_SYMBOL_GPL(mlx4_multicast_promisc

 int mlx4_multicast_promisc_remove(struct mlx4_dev *dev, u32 qpn, u8 port)
 {
-	if (!dev->caps.vep_mc_steering)
+	if (!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		return 0;


@@ -887,7 +890,7 @@ EXPORT_SYMBOL_GPL(mlx4_multicast_promisc

 int mlx4_unicast_promisc_add(struct mlx4_dev *dev, u32 qpn, u8 port)
 {
-	if (!dev->caps.vep_mc_steering)
+	if (!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		return 0;


@@ -897,7 +900,7 @@ EXPORT_SYMBOL_GPL(mlx4_unicast_promisc_a

 int mlx4_unicast_promisc_remove(struct mlx4_dev *dev, u32 qpn, u8 port)
 {
-	if (!dev->caps.vep_mc_steering)
+	if (!dev->caps.flags & MLX4_DEV_CAP_FLAG_VEP_MC_STEER)
 		return 0;

 	return remove_promisc_qp(dev, 0, port, MLX4_UC_STEER, qpn);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
