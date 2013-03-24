From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 5/5] IB/ipoib: Support changing the number of RX/TX rings with ethtool
Date: Sun, 24 Mar 2013 14:43:32 +0200
Message-ID: <1364129012-12198-6-git-send-email-ogerlitz@mellanox.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364129012-12198-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The number of RX/TX rings can now be get or changed using the ethtool
directives to get/set the number of channels of ETHTOOL_{G/S}CHANNELS.

Added ipoib_reinit() which releases all the rings and their associated
resources, and immediatly following that allocates them again according
to the new number of rings. For that end, moved code which is common to
device cleanup and device reinit from the device cleanup flow to a routine
which is called on both cases.

On some flows, the ndo_get_stats entry (which now reads the per ring
statistics for an ipoib netdevice), is called by the core networking
code without rtnl locking. To protect against such a call being made
in parallel with an ethtool call to change the number of rings --
added rwlock on the rings.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h         |    9 ++-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |   68 +++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |  133 ++++++++++++++++++++++----
 4 files changed, 192 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 1b214f1..cf6ab56 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -418,8 +418,11 @@ struct ipoib_dev_priv {
 	struct ipoib_send_ring *send_ring;
 	unsigned int rss_qp_num; /* No RSS HW support 0 */
 	unsigned int tss_qp_num; /* No TSS (HW or SW) used 0 */
-	unsigned int num_rx_queues; /* No RSS HW support 1 */
-	unsigned int num_tx_queues; /* No TSS HW support tss_qp_num + 1 */
+	unsigned int max_rx_queues; /* No RSS HW support 1 */
+	unsigned int max_tx_queues; /* No TSS HW support tss_qp_num + 1 */
+	unsigned int num_rx_queues; /* Actual */
+	unsigned int num_tx_queues; /* Actual */
+	struct rw_semaphore rings_rwsem;
 	__be16 tss_qpn_mask_sz; /* Put in ipoib header reserved */
 };
 
@@ -528,6 +531,8 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush);
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
 void ipoib_dev_cleanup(struct net_device *dev);
 
+int ipoib_reinit(struct net_device *dev, int num_rx, int num_tx);
+
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 7c56341..f79a8a4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -172,6 +172,72 @@ static void ipoib_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
+static void ipoib_get_channels(struct net_device *dev,
+			struct ethtool_channels *channel)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	channel->max_rx = priv->max_rx_queues;
+	channel->max_tx = priv->max_tx_queues;
+	channel->max_other = 0;
+	channel->max_combined = priv->max_rx_queues +
+				priv->max_tx_queues;
+	channel->rx_count = priv->num_rx_queues;
+	channel->tx_count = priv->num_tx_queues;
+	channel->other_count = 0;
+	channel->combined_count = priv->num_rx_queues +
+				priv->num_tx_queues;
+}
+
+static int ipoib_set_channels(struct net_device *dev,
+			struct ethtool_channels *channel)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	if (channel->other_count)
+		return -EINVAL;
+
+	if (channel->combined_count !=
+		priv->num_rx_queues + priv->num_tx_queues)
+		return -EINVAL;
+
+	if (channel->rx_count == 0 ||
+	    channel->rx_count > priv->max_rx_queues)
+		return -EINVAL;
+
+	if (!is_power_of_2(channel->rx_count))
+		return -EINVAL;
+
+	if (channel->tx_count  == 0 ||
+	    channel->tx_count > priv->max_tx_queues)
+		return -EINVAL;
+
+	/* Nothing to do ? */
+	if (channel->rx_count == priv->num_rx_queues &&
+	    channel->tx_count == priv->num_tx_queues)
+		return 0;
+
+	/* 1 is always O.K. */
+	if (channel->tx_count > 1) {
+		if (priv->hca_caps & IB_DEVICE_UD_TSS) {
+			/* with HW TSS tx_count is 2^N */
+			if (!is_power_of_2(channel->tx_count))
+				return -EINVAL;
+		} else {
+			/*
+			* with SW TSS tx_count = 1 + 2 ^ N,
+			* 2 is not allowed, make no sense.
+			* if want to disable TSS use 1.
+			*/
+			if (!is_power_of_2(channel->tx_count - 1) ||
+			    channel->tx_count == 2)
+				return -EINVAL;
+		}
+	}
+
+	return ipoib_reinit(dev, channel->rx_count, channel->tx_count);
+}
+
 static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_coalesce		= ipoib_get_coalesce,
@@ -179,6 +245,8 @@ static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_strings		= ipoib_get_strings,
 	.get_sset_count		= ipoib_get_sset_count,
 	.get_ethtool_stats	= ipoib_get_ethtool_stats,
+	.get_channels		= ipoib_get_channels,
+	.set_channels		= ipoib_set_channels,
 };
 
 void ipoib_set_ethtool_ops(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 01ce5e9..fa4958c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -736,8 +736,10 @@ static void ipoib_napi_disable(struct net_device *dev)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int i;
 
-	for (i = 0; i < priv->num_rx_queues; i++)
+	for (i = 0; i < priv->num_rx_queues; i++) {
 		napi_disable(&priv->recv_ring[i].napi);
+		netif_napi_del(&priv->recv_ring[i].napi);
+	}
 }
 
 int ipoib_ib_dev_open(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 8089137..a1f10b3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -928,6 +928,10 @@ static struct net_device_stats *ipoib_get_stats(struct net_device *dev)
 	struct net_device_stats local_stats;
 	int i;
 
+	/* if rings are not ready yet return last values */
+	if (!down_read_trylock(&priv->rings_rwsem))
+		return stats;
+
 	memset(&local_stats, 0, sizeof(struct net_device_stats));
 
 	for (i = 0; i < priv->num_rx_queues; i++) {
@@ -946,6 +950,8 @@ static struct net_device_stats *ipoib_get_stats(struct net_device *dev)
 		local_stats.tx_dropped += tstats->tx_dropped;
 	}
 
+	up_read(&priv->rings_rwsem);
+
 	stats->rx_packets = local_stats.rx_packets;
 	stats->rx_bytes   = local_stats.rx_bytes;
 	stats->rx_errors  = local_stats.rx_errors;
@@ -1476,6 +1482,8 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	if (ipoib_ib_dev_init(dev, ca, port))
 		goto out_send_ring_cleanup;
 
+	/* access to rings allowed */
+	up_write(&priv->rings_rwsem);
 
 	return 0;
 
@@ -1496,10 +1504,36 @@ out:
 	return -ENOMEM;
 }
 
+static void ipoib_dev_uninit(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int i;
+
+	ASSERT_RTNL();
+
+	ipoib_ib_dev_cleanup(dev);
+
+	/* no more access to rings */
+	down_write(&priv->rings_rwsem);
+
+	for (i = 0; i < priv->num_tx_queues; i++)
+		vfree(priv->send_ring[i].tx_ring);
+	kfree(priv->send_ring);
+
+	for (i = 0; i < priv->num_rx_queues; i++)
+		kfree(priv->recv_ring[i].rx_ring);
+	kfree(priv->recv_ring);
+
+	priv->recv_ring = NULL;
+	priv->send_ring = NULL;
+
+	ipoib_neigh_hash_uninit(dev);
+}
+
 void ipoib_dev_cleanup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev), *cpriv, *tcpriv;
-	int i;
+
 	LIST_HEAD(head);
 
 	ASSERT_RTNL();
@@ -1513,23 +1547,71 @@ void ipoib_dev_cleanup(struct net_device *dev)
 		cancel_delayed_work(&cpriv->neigh_reap_task);
 		unregister_netdevice_queue(cpriv->dev, &head);
 	}
+
 	unregister_netdevice_many(&head);
 
-	ipoib_ib_dev_cleanup(dev);
+	ipoib_dev_uninit(dev);
 
+	/* ipoib_dev_uninit took rings lock but can't release it when called by
+	 * ipoib_reinit, for the cleanup flow, release it here
+	 */
+	up_write(&priv->rings_rwsem);
+}
 
-	for (i = 0; i < priv->num_tx_queues; i++)
-		vfree(priv->send_ring[i].tx_ring);
-	kfree(priv->send_ring);
+int ipoib_reinit(struct net_device *dev, int num_rx, int num_tx)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int flags;
+	int ret;
 
-	for (i = 0; i < priv->num_rx_queues; i++)
-		kfree(priv->recv_ring[i].rx_ring);
-	kfree(priv->recv_ring);
+	flags = dev->flags;
+	dev_close(dev);
 
-	priv->recv_ring = NULL;
-	priv->send_ring = NULL;
+	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
+		ib_unregister_event_handler(&priv->event_handler);
 
-	ipoib_neigh_hash_uninit(dev);
+	ipoib_dev_uninit(dev);
+
+	priv->num_rx_queues = num_rx;
+	priv->num_tx_queues = num_tx;
+	if (num_rx == 1)
+		priv->rss_qp_num = 0;
+	else
+		priv->rss_qp_num = num_rx;
+	if (num_tx == 1 || !(priv->hca_caps & IB_DEVICE_UD_TSS))
+		priv->tss_qp_num = num_tx - 1;
+	else
+		priv->tss_qp_num = num_tx;
+
+	netif_set_real_num_tx_queues(dev, num_tx);
+	netif_set_real_num_rx_queues(dev, num_rx);
+
+	/* prevent ipoib_ib_dev_init from calling ipoib_ib_dev_open,
+	 * let ipoib_open do it
+	 */
+	dev->flags &= ~IFF_UP;
+	ret = ipoib_dev_init(dev, priv->ca, priv->port);
+	if (ret) {
+		pr_warn("%s: failed to reinitialize port %d (ret = %d)\n",
+			priv->ca->name, priv->port, ret);
+		return ret;
+	}
+
+	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
+		ret = ib_register_event_handler(&priv->event_handler);
+		if (ret)
+			pr_warn("%s: failed to rereg port %d (ret = %d)\n",
+				priv->ca->name, priv->port, ret);
+	}
+
+	/* if the device was up bring it up again */
+	if (flags & IFF_UP) {
+		ret = dev_open(dev);
+		if (ret)
+			pr_warn("%s: failed to reopen port %d (ret = %d)\n",
+				priv->ca->name, priv->port, ret);
+	}
+	return ret;
 }
 
 static const struct header_ops ipoib_header_ops = {
@@ -1608,6 +1690,10 @@ void ipoib_setup(struct net_device *dev)
 
 	mutex_init(&priv->vlan_mutex);
 
+	init_rwsem(&priv->rings_rwsem);
+	/* read access to rings is disabled */
+	down_write(&priv->rings_rwsem);
+
 	INIT_LIST_HEAD(&priv->path_list);
 	INIT_LIST_HEAD(&priv->child_intfs);
 	INIT_LIST_HEAD(&priv->dead_ahs);
@@ -1629,8 +1715,12 @@ struct ipoib_dev_priv *ipoib_intf_alloc(const char *name,
 {
 	struct net_device *dev;
 
-	/* Use correct ops (ndo_select_queue) pass to ipoib_setup */
-	if (template_priv->num_tx_queues > 1) {
+	/* Use correct ops (ndo_select_queue) pass to ipoib_setup
+	 * A child interface starts with the same number of queues as the
+	 * parent. Even if the parent currently has only one ring, the MQ
+	 * potential must be reserved.
+	 */
+	if (template_priv->max_tx_queues > 1) {
 		if (template_priv->hca_caps & IB_DEVICE_UD_TSS)
 			ipoib_netdev_ops = &ipoib_netdev_ops_hw_tss;
 		else
@@ -1641,8 +1731,8 @@ struct ipoib_dev_priv *ipoib_intf_alloc(const char *name,
 
 	dev = alloc_netdev_mqs((int) sizeof(struct ipoib_dev_priv), name,
 			   ipoib_setup,
-			   template_priv->num_tx_queues,
-			   template_priv->num_rx_queues);
+			   template_priv->max_tx_queues,
+			   template_priv->max_rx_queues);
 	if (!dev)
 		return NULL;
 
@@ -1776,6 +1866,8 @@ static int ipoib_get_hca_features(struct ipoib_dev_priv *priv,
 		/* No additional QP, only one QP for RX & TX */
 		priv->rss_qp_num = 0;
 		priv->tss_qp_num = 0;
+		priv->max_rx_queues = 1;
+		priv->max_tx_queues = 1;
 		priv->num_rx_queues = 1;
 		priv->num_tx_queues = 1;
 		kfree(device_attr);
@@ -1788,22 +1880,25 @@ static int ipoib_get_hca_features(struct ipoib_dev_priv *priv,
 		max_rss_tbl_sz = min(num_cores, max_rss_tbl_sz);
 		max_rss_tbl_sz = rounddown_pow_of_two(max_rss_tbl_sz);
 		priv->rss_qp_num    = max_rss_tbl_sz;
-		priv->num_rx_queues = max_rss_tbl_sz;
+		priv->max_rx_queues = max_rss_tbl_sz;
 	} else {
 		/* No additional QP, only the parent QP for RX */
 		priv->rss_qp_num = 0;
-		priv->num_rx_queues = 1;
+		priv->max_rx_queues = 1;
 	}
+	priv->num_rx_queues = priv->max_rx_queues;
 
 	kfree(device_attr);
 
 	priv->tss_qp_num = num_cores;
 	if (priv->hca_caps & IB_DEVICE_UD_TSS)
 		/* TSS is supported by HW */
-		priv->num_tx_queues = priv->tss_qp_num;
+		priv->max_tx_queues = priv->tss_qp_num;
 	else
 		/* If TSS is not support by HW use the parent QP for ARP */
-		priv->num_tx_queues = priv->tss_qp_num + 1;
+		priv->max_tx_queues = priv->tss_qp_num + 1;
+
+	priv->num_tx_queues = priv->max_tx_queues;
 
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
