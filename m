From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-2.6.38 1/2] IB/ipoib: remove LRO support
Date: Wed, 15 Dec 2010 13:24:21 +0200
Message-ID: <Pine.LNX.4.64.1012151321250.24022@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Ben Hutchings <bhutchings-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

towards moving from LRO to GRO, revert commit af40da894e9 "IPoIB: add
LRO support". Also elimiate the ethtool set_flags callback which isn't
needed anymore, and have the declaration of restart_syscall to be
imported through direct inclusion of linux/sched.h

CC: Ben Hutchings <bhutchings-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>
CC: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
CC: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---

I took the approach of two patches, i.e first to remove LRO,
next add GRO, to ease with future debugging, bisection, etc

 drivers/infiniband/ulp/ipoib/Kconfig         |    1
 drivers/infiniband/ulp/ipoib/ipoib.h         |   12 -----
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |   51 ----------------------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    8 ---
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   62 ---------------------------
 5 files changed, 2 insertions(+), 132 deletions(-)

Index: b/drivers/infiniband/ulp/ipoib/Kconfig
===================================================================
--- a/drivers/infiniband/ulp/ipoib/Kconfig
+++ b/drivers/infiniband/ulp/ipoib/Kconfig
@@ -1,7 +1,6 @@
 config INFINIBAND_IPOIB
 	tristate "IP-over-InfiniBand"
 	depends on NETDEVICES && INET && (IPV6 || IPV6=n)
-	select INET_LRO
 	---help---
 	  Support for the IP-over-InfiniBand protocol (IPoIB). This
 	  transports IP packets over InfiniBand so you can use your IB
Index: b/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -50,7 +50,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_sa.h>
-#include <linux/inet_lro.h>
+#include <linux/sched.h>

 /* constants */

@@ -100,9 +100,6 @@ enum {
 	IPOIB_MCAST_FLAG_BUSY	  = 2,	/* joining or already joined */
 	IPOIB_MCAST_FLAG_ATTACHED = 3,

-	IPOIB_MAX_LRO_DESCRIPTORS = 8,
-	IPOIB_LRO_MAX_AGGR 	  = 64,
-
 	MAX_SEND_CQE		  = 16,
 	IPOIB_CM_COPYBREAK	  = 256,
 };
@@ -262,11 +259,6 @@ struct ipoib_ethtool_st {
 	u16     max_coalesced_frames;
 };

-struct ipoib_lro {
-	struct net_lro_mgr lro_mgr;
-	struct net_lro_desc lro_desc[IPOIB_MAX_LRO_DESCRIPTORS];
-};
-
 /*
  * Device private locking: network stack tx_lock protects members used
  * in TX fast path, lock protects everything else.  lock nests inside
@@ -352,8 +344,6 @@ struct ipoib_dev_priv {
 	int	hca_caps;
 	struct ipoib_ethtool_st ethtool;
 	struct timer_list poll_timer;
-
-	struct ipoib_lro lro;
 };

 struct ipoib_ah {
Index: b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -295,10 +295,7 @@ static void ipoib_ib_handle_rx_wc(struct
 	if (test_bit(IPOIB_FLAG_CSUM, &priv->flags) && likely(wc->csum_ok))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;

-	if (dev->features & NETIF_F_LRO)
-		lro_receive_skb(&priv->lro.lro_mgr, skb, NULL);
-	else
-		netif_receive_skb(skb);
+	netif_receive_skb(skb);

 repost:
 	if (unlikely(ipoib_ib_post_receive(dev, wr_id)))
@@ -450,9 +447,6 @@ poll_more:
 	}

 	if (done < budget) {
-		if (dev->features & NETIF_F_LRO)
-			lro_flush_all(&priv->lro.lro_mgr);
-
 		napi_complete(napi);
 		if (unlikely(ib_req_notify_cq(priv->recv_cq,
 					      IB_CQ_NEXT_COMP |
Index: b/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -60,15 +60,6 @@ MODULE_PARM_DESC(send_queue_size, "Numbe
 module_param_named(recv_queue_size, ipoib_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Number of descriptors in receive queue");

-static int lro;
-module_param(lro, bool, 0444);
-MODULE_PARM_DESC(lro,  "Enable LRO (Large Receive Offload)");
-
-static int lro_max_aggr = IPOIB_LRO_MAX_AGGR;
-module_param(lro_max_aggr, int, 0644);
-MODULE_PARM_DESC(lro_max_aggr, "LRO: Max packets to be aggregated "
-		"(default = 64)");
-
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
 int ipoib_debug_level;

@@ -976,54 +967,6 @@ static const struct header_ops ipoib_hea
 	.create	= ipoib_hard_header,
 };

-static int get_skb_hdr(struct sk_buff *skb, void **iphdr,
-		       void **tcph, u64 *hdr_flags, void *priv)
-{
-	unsigned int ip_len;
-	struct iphdr *iph;
-
-	if (unlikely(skb->protocol != htons(ETH_P_IP)))
-		return -1;
-
-	/*
-	 * In the future we may add an else clause that verifies the
-	 * checksum and allows devices which do not calculate checksum
-	 * to use LRO.
-	 */
-	if (unlikely(skb->ip_summed != CHECKSUM_UNNECESSARY))
-		return -1;
-
-	/* Check for non-TCP packet */
-	skb_reset_network_header(skb);
-	iph = ip_hdr(skb);
-	if (iph->protocol != IPPROTO_TCP)
-		return -1;
-
-	ip_len = ip_hdrlen(skb);
-	skb_set_transport_header(skb, ip_len);
-	*tcph = tcp_hdr(skb);
-
-	/* check if IP header and TCP header are complete */
-	if (ntohs(iph->tot_len) < ip_len + tcp_hdrlen(skb))
-		return -1;
-
-	*hdr_flags = LRO_IPV4 | LRO_TCP;
-	*iphdr = iph;
-
-	return 0;
-}
-
-static void ipoib_lro_setup(struct ipoib_dev_priv *priv)
-{
-	priv->lro.lro_mgr.max_aggr	 = lro_max_aggr;
-	priv->lro.lro_mgr.max_desc	 = IPOIB_MAX_LRO_DESCRIPTORS;
-	priv->lro.lro_mgr.lro_arr	 = priv->lro.lro_desc;
-	priv->lro.lro_mgr.get_skb_header = get_skb_hdr;
-	priv->lro.lro_mgr.features	 = LRO_F_NAPI;
-	priv->lro.lro_mgr.dev		 = priv->dev;
-	priv->lro.lro_mgr.ip_summed_aggr = CHECKSUM_UNNECESSARY;
-}
-
 static const struct net_device_ops ipoib_netdev_ops = {
 	.ndo_open		 = ipoib_open,
 	.ndo_stop		 = ipoib_stop,
@@ -1067,8 +1010,6 @@ static void ipoib_setup(struct net_devic

 	priv->dev = dev;

-	ipoib_lro_setup(priv);
-
 	spin_lock_init(&priv->lock);

 	mutex_init(&priv->vlan_mutex);
@@ -1218,9 +1159,6 @@ int ipoib_set_dev_features(struct ipoib_
 		priv->dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM;
 	}

-	if (lro)
-		priv->dev->features |= NETIF_F_LRO;
-
 	if (priv->dev->features & NETIF_F_SG && priv->hca_caps & IB_DEVICE_UD_TSO)
 		priv->dev->features |= NETIF_F_TSO;

Index: b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -106,63 +106,12 @@ static int ipoib_set_coalesce(struct net
 	return 0;
 }

-static const char ipoib_stats_keys[][ETH_GSTRING_LEN] = {
-	"LRO aggregated", "LRO flushed",
-	"LRO avg aggr", "LRO no desc"
-};
-
-static void ipoib_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
-{
-	switch (stringset) {
-	case ETH_SS_STATS:
-		memcpy(data, *ipoib_stats_keys,	sizeof(ipoib_stats_keys));
-		break;
-	}
-}
-
-static int ipoib_get_sset_count(struct net_device *dev, int sset)
-{
-	switch (sset) {
-	case ETH_SS_STATS:
-		return ARRAY_SIZE(ipoib_stats_keys);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static void ipoib_get_ethtool_stats(struct net_device *dev,
-				struct ethtool_stats *stats, uint64_t *data)
-{
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	int index = 0;
-
-	/* Get LRO statistics */
-	data[index++] = priv->lro.lro_mgr.stats.aggregated;
-	data[index++] = priv->lro.lro_mgr.stats.flushed;
-	if (priv->lro.lro_mgr.stats.flushed)
-		data[index++] = priv->lro.lro_mgr.stats.aggregated /
-				priv->lro.lro_mgr.stats.flushed;
-	else
-		data[index++] = 0;
-	data[index++] = priv->lro.lro_mgr.stats.no_desc;
-}
-
-static int ipoib_set_flags(struct net_device *dev, u32 flags)
-{
-	return ethtool_op_set_flags(dev, flags, ETH_FLAG_LRO);
-}
-
 static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_rx_csum		= ipoib_get_rx_csum,
 	.set_tso		= ipoib_set_tso,
 	.get_coalesce		= ipoib_get_coalesce,
 	.set_coalesce		= ipoib_set_coalesce,
-	.get_flags		= ethtool_op_get_flags,
-	.set_flags		= ipoib_set_flags,
-	.get_strings		= ipoib_get_strings,
-	.get_sset_count		= ipoib_get_sset_count,
-	.get_ethtool_stats	= ipoib_get_ethtool_stats,
 };

 void ipoib_set_ethtool_ops(struct net_device *dev)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
