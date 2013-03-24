From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 4/5] IB/ipoib: Add RSS and TSS support for datagram mode
Date: Sun, 24 Mar 2013 14:43:31 +0200
Message-ID: <1364129012-12198-5-git-send-email-ogerlitz@mellanox.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364129012-12198-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch add RSS (Receive Side Scaling) and TSS (multi-queue transmit)
support for IPoIB. The RSS and TSS implementation utilizes the new QP
groups concept.

The number of RSS and TSS rings is a function of the number of cores,
and the low level driver capability to support QP groups and RSS.

If the low level driver doesn't support QP groups, then only one RX
and one TX rings are created and only one QP, such both rings use it.

If the HW supports RSS then additional receive QP are created, and each
is assigned to a separate receive ring. The number of additional receive
rings is equal to the number of CPU cores rounded to the next power of two.

If the HW doesn't support RSS then only one receive ring is created
and the parent QP is assigned as its QP.

When TSS is used, additional send QPs are created, and each is assigned to
a separate send ring. The number of additional send rings is equal to the
number of CPU cores rounded to the next power of two.

It turns out that there are IPoIB drivers used by some operating-systems
and/or Hypervisors in a para-virtualization (PV) scheme which extract the
source QPN from the CQ WC associated with an incoming packets in order to
generate the source MAC address in the emulated MAC header they build.

With TSS, different packets targeted for the same entity (e.g VM using
PV IPoIB instance) could be potentially sent through different TX rings
which map to different UD QPs, each with its own QPN. This may break some
assumptions made the receiving entity (e.g rules related to security,
monitoring, etc).

If the HW supports TSS, it is capable of over-riding the source UD QPN
present in the IB datagram header (DTH) of sent packets with the parent's
QPN which is part of the device HW address as advertized to the Linux network
stack and hence carried in ARP requests/responses. Thus the above mentioned
problem doesn't exist.

When HW doesn't support TSS, but QP groups are supported which mean the
low level driver can create set of QPs with contiguous QP numbers, TSS
can still be used, this is called "SW TSS".

In this case, the low level drive provides IPoIB with a mask when the
parent QP is created. This mask is later written into the reserved field
of the IPoIB header so receivers of SW TSS packets can mask the QPN of
a received packet and discover the parent QPN.

In order not to possibly breaks inter-operability with the PV IPoIB drivers
which were not yet enhanced to apply this masking from incoming packets,
SW TSS will only be used if the peer advertised its willingness to accept
SW TSS frames, otherwise the parent QP will be used.

The advertisement to accept TSS frames is done using a dedicated bit in
the reserved byte of the IPoIB HW address (e.g similar to CM).

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h       |   15 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   10 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |  169 +++++++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  621 ++++++++++++++++++++++++----
 4 files changed, 721 insertions(+), 94 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 9bf96db..1b214f1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -123,7 +123,7 @@ enum {
 
 struct ipoib_header {
 	__be16	proto;
-	u16	reserved;
+	__be16	tss_qpn_mask_sz;
 };
 
 struct ipoib_cb {
@@ -383,9 +383,7 @@ struct ipoib_dev_priv {
 	u16		  pkey_index;
 	struct ib_pd	 *pd;
 	struct ib_mr	 *mr;
-	struct ib_cq	 *recv_cq;
-	struct ib_cq	 *send_cq;
-	struct ib_qp	 *qp;
+	struct ib_qp	 *qp; /* also parent QP for TSS & RSS */
 	u32		  qkey;
 
 	union ib_gid local_gid;
@@ -418,8 +416,11 @@ struct ipoib_dev_priv {
 	struct timer_list poll_timer;
 	struct ipoib_recv_ring *recv_ring;
 	struct ipoib_send_ring *send_ring;
-	unsigned int num_rx_queues;
-	unsigned int num_tx_queues;
+	unsigned int rss_qp_num; /* No RSS HW support 0 */
+	unsigned int tss_qp_num; /* No TSS (HW or SW) used 0 */
+	unsigned int num_rx_queues; /* No RSS HW support 1 */
+	unsigned int num_tx_queues; /* No TSS HW support tss_qp_num + 1 */
+	__be16 tss_qpn_mask_sz; /* Put in ipoib header reserved */
 };
 
 struct ipoib_ah {
@@ -587,9 +588,11 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
 
 #define IPOIB_FLAGS_RC		0x80
 #define IPOIB_FLAGS_UC		0x40
+#define IPOIB_FLAGS_TSS		0x20
 
 /* We don't support UC connections at the moment */
 #define IPOIB_CM_SUPPORTED(ha)   (ha[0] & (IPOIB_FLAGS_RC))
+#define IPOIB_TSS_SUPPORTED(ha)   (ha[0] & (IPOIB_FLAGS_TSS))
 
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 4871dc9..01ce5e9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -286,6 +286,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev,
 	/*
 	 * Drop packets that this interface sent, ie multicast packets
 	 * that the HCA has replicated.
+	 * Note with SW TSS MC were sent using priv->qp so no need to mask
 	 */
 	if (wc->slid == priv->local_lid && wc->src_qp == priv->qp->qp_num)
 		goto repost;
@@ -1058,6 +1059,15 @@ static void set_rx_rings_qp_state(struct ipoib_dev_priv *priv,
 static void set_rings_qp_state(struct ipoib_dev_priv *priv,
 				enum ib_qp_state new_state)
 {
+	if (priv->hca_caps & IB_DEVICE_UD_TSS) {
+		/* TSS HW is supported, parent QP has no ring (send_ring) */
+		struct ib_qp_attr qp_attr;
+		qp_attr.qp_state = new_state;
+		if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv, "Failed to modify QP to state(%d)\n",
+				   new_state);
+	}
+
 	set_tx_rings_qp_state(priv, new_state);
 
 	if (priv->num_rx_queues > 1)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 51bebca..8089137 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -747,7 +747,9 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ipoib_cb *cb = (struct ipoib_cb *) skb->cb;
 	struct ipoib_header *header;
 	unsigned long flags;
+	struct ipoib_send_ring *send_ring;
 
+	send_ring = priv->send_ring + skb_get_queue_mapping(skb);
 	header = (struct ipoib_header *) skb->data;
 
 	if (unlikely(cb->hwaddr[4] == 0xff)) {
@@ -757,7 +759,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		    (header->proto != htons(ETH_P_ARP)) &&
 		    (header->proto != htons(ETH_P_RARP))) {
 			/* ethertype not supported by IPoIB */
-			++dev->stats.tx_dropped;
+			++send_ring->stats.tx_dropped;
 			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
@@ -795,7 +797,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	default:
 		/* ethertype not supported by IPoIB */
-		++dev->stats.tx_dropped;
+		++send_ring->stats.tx_dropped;
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
@@ -803,11 +805,19 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 send_using_neigh:
 	/* note we now hold a ref to neigh */
 	if (ipoib_cm_get(neigh)) {
+		/* in select queue cm wasn't enabled ring is likely wrong */
+		if (!IPOIB_CM_SUPPORTED(cb->hwaddr))
+			goto drop;
+
 		if (ipoib_cm_up(neigh)) {
 			ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
 			goto unref;
 		}
 	} else if (neigh->ah) {
+		/* in select queue cm was enabled ring is likely wrong */
+		if (IPOIB_CM_SUPPORTED(cb->hwaddr) && priv->num_tx_queues > 1)
+			goto drop;
+
 		ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(cb->hwaddr));
 		goto unref;
 	}
@@ -816,20 +826,78 @@ send_using_neigh:
 		spin_lock_irqsave(&priv->lock, flags);
 		__skb_queue_tail(&neigh->queue, skb);
 		spin_unlock_irqrestore(&priv->lock, flags);
-	} else {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
+		goto unref;
 	}
 
+drop:
+	++send_ring->stats.tx_dropped;
+	dev_kfree_skb_any(skb);
+
 unref:
 	ipoib_neigh_put(neigh);
 
 	return NETDEV_TX_OK;
 }
 
-static u16 ipoib_select_queue_null(struct net_device *dev, struct sk_buff *skb)
+static u16 ipoib_select_queue_hw(struct net_device *dev, struct sk_buff *skb)
 {
-	return 0;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_cb *cb = (struct ipoib_cb *)skb->cb;
+
+	/* (BC/MC), stay on this core */
+	if (unlikely(cb->hwaddr[4] == 0xff))
+		return smp_processor_id() % priv->tss_qp_num;
+
+	/* is CM in use */
+	if (IPOIB_CM_SUPPORTED(cb->hwaddr)) {
+		if (ipoib_cm_admin_enabled(dev)) {
+			/* use remote QP for hash, so we use the same ring */
+			u32 *d32 = (u32 *)cb->hwaddr;
+			u32 hv = jhash_1word(*d32 & IPOIB_QPN_MASK, 0);
+			return hv % priv->tss_qp_num;
+		} else
+			/* the ADMIN CM might be up until transmit, and
+			 * we might transmit on CM QP not from it's
+			 * designated ring */
+			cb->hwaddr[0] &= ~IPOIB_FLAGS_RC;
+	}
+	return skb_tx_hash(dev, skb);
+}
+
+static u16 ipoib_select_queue_sw(struct net_device *dev, struct sk_buff *skb)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_cb *cb = (struct ipoib_cb *)skb->cb;
+	struct ipoib_header *header;
+
+	/* (BC/MC) use designated QDISC -> parent QP */
+	if (unlikely(cb->hwaddr[4] == 0xff))
+		return priv->tss_qp_num;
+
+	/* is CM in use */
+	if (IPOIB_CM_SUPPORTED(cb->hwaddr)) {
+		if (ipoib_cm_admin_enabled(dev)) {
+			/* use remote QP for hash, so we use the same ring */
+			u32 *d32 = (u32 *)cb->hwaddr;
+			u32 hv = jhash_1word(*d32 & IPOIB_QPN_MASK, 0);
+			return hv % priv->tss_qp_num;
+		} else
+			/* the ADMIN CM might be up until transmit, and
+			 * we might transmit on CM QP not from it's
+			 * designated ring */
+			cb->hwaddr[0] &= ~IPOIB_FLAGS_RC;
+	}
+
+	/* Did neighbour advertise TSS support */
+	if (unlikely(!IPOIB_TSS_SUPPORTED(cb->hwaddr)))
+		return priv->tss_qp_num;
+
+	/* We are after ipoib_hard_header so skb->data is O.K. */
+	header = (struct ipoib_header *)skb->data;
+	header->tss_qpn_mask_sz |= priv->tss_qpn_mask_sz;
+
+	/* don't use special ring in TX */
+	return __skb_tx_hash(dev, skb, priv->tss_qp_num);
 }
 
 static void ipoib_timeout(struct net_device *dev)
@@ -902,7 +970,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
 	header = (struct ipoib_header *) skb_push(skb, sizeof *header);
 
 	header->proto = htons(type);
-	header->reserved = 0;
+	header->tss_qpn_mask_sz = 0;
 
 	/*
 	 * we don't rely on dst_entry structure,  always stuff the
@@ -961,7 +1029,8 @@ struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
 	for (neigh = rcu_dereference_bh(htbl->buckets[hash_val]);
 	     neigh != NULL;
 	     neigh = rcu_dereference_bh(neigh->hnext)) {
-		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
+		/* don't use flags for the comapre */
+		if (memcmp(daddr+1, neigh->daddr+1, INFINIBAND_ALEN-1) == 0) {
 			/* found, take one ref on behalf of the caller */
 			if (!atomic_inc_not_zero(&neigh->refcnt)) {
 				/* deleted */
@@ -1088,7 +1157,8 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 	     neigh != NULL;
 	     neigh = rcu_dereference_protected(neigh->hnext,
 					       lockdep_is_held(&priv->lock))) {
-		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
+		/* don't use flags for the comapre */
+		if (memcmp(daddr+1, neigh->daddr+1, INFINIBAND_ALEN-1) == 0) {
 			/* found, take one ref on behalf of the caller */
 			if (!atomic_inc_not_zero(&neigh->refcnt)) {
 				/* deleted */
@@ -1466,25 +1536,52 @@ static const struct header_ops ipoib_header_ops = {
 	.create	= ipoib_hard_header,
 };
 
-static const struct net_device_ops ipoib_netdev_ops = {
+static const struct net_device_ops ipoib_netdev_ops_no_tss = {
 	.ndo_uninit		 = ipoib_uninit,
 	.ndo_open		 = ipoib_open,
 	.ndo_stop		 = ipoib_stop,
 	.ndo_change_mtu		 = ipoib_change_mtu,
 	.ndo_fix_features	 = ipoib_fix_features,
-	.ndo_start_xmit	 	 = ipoib_start_xmit,
-	.ndo_select_queue	 = ipoib_select_queue_null,
+	.ndo_start_xmit		 = ipoib_start_xmit,
 	.ndo_tx_timeout		 = ipoib_timeout,
 	.ndo_get_stats		 = ipoib_get_stats,
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 };
 
+static const struct net_device_ops ipoib_netdev_ops_hw_tss = {
+	.ndo_uninit		 = ipoib_uninit,
+	.ndo_open		 = ipoib_open,
+	.ndo_stop		 = ipoib_stop,
+	.ndo_change_mtu		 = ipoib_change_mtu,
+	.ndo_fix_features	 = ipoib_fix_features,
+	.ndo_start_xmit		 = ipoib_start_xmit,
+	.ndo_select_queue	 = ipoib_select_queue_hw,
+	.ndo_tx_timeout		 = ipoib_timeout,
+	.ndo_get_stats		 = ipoib_get_stats,
+	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
+};
+
+static const struct net_device_ops ipoib_netdev_ops_sw_tss = {
+	.ndo_uninit		 = ipoib_uninit,
+	.ndo_open		 = ipoib_open,
+	.ndo_stop		 = ipoib_stop,
+	.ndo_change_mtu		 = ipoib_change_mtu,
+	.ndo_fix_features	 = ipoib_fix_features,
+	.ndo_start_xmit		 = ipoib_start_xmit,
+	.ndo_select_queue	 = ipoib_select_queue_sw,
+	.ndo_tx_timeout		 = ipoib_timeout,
+	.ndo_get_stats		 = ipoib_get_stats,
+	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
+};
+
+static const struct net_device_ops *ipoib_netdev_ops;
+
 void ipoib_setup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	/* Use correct ops (ndo_select_queue) */
-	dev->netdev_ops		 = &ipoib_netdev_ops;
+	dev->netdev_ops		 = ipoib_netdev_ops;
 	dev->header_ops		 = &ipoib_header_ops;
 
 	ipoib_set_ethtool_ops(dev);
@@ -1532,6 +1629,16 @@ struct ipoib_dev_priv *ipoib_intf_alloc(const char *name,
 {
 	struct net_device *dev;
 
+	/* Use correct ops (ndo_select_queue) pass to ipoib_setup */
+	if (template_priv->num_tx_queues > 1) {
+		if (template_priv->hca_caps & IB_DEVICE_UD_TSS)
+			ipoib_netdev_ops = &ipoib_netdev_ops_hw_tss;
+		else
+			ipoib_netdev_ops = &ipoib_netdev_ops_sw_tss;
+	} else
+		ipoib_netdev_ops = &ipoib_netdev_ops_no_tss;
+
+
 	dev = alloc_netdev_mqs((int) sizeof(struct ipoib_dev_priv), name,
 			   ipoib_setup,
 			   template_priv->num_tx_queues,
@@ -1645,6 +1752,7 @@ static int ipoib_get_hca_features(struct ipoib_dev_priv *priv,
 				  struct ib_device *hca)
 {
 	struct ib_device_attr *device_attr;
+	int num_cores;
 	int result = -ENOMEM;
 
 	device_attr = kmalloc(sizeof *device_attr, GFP_KERNEL);
@@ -1663,10 +1771,39 @@ static int ipoib_get_hca_features(struct ipoib_dev_priv *priv,
 	}
 	priv->hca_caps = device_attr->device_cap_flags;
 
+	num_cores = num_online_cpus();
+	if (num_cores == 1 || !(priv->hca_caps & IB_DEVICE_QPG)) {
+		/* No additional QP, only one QP for RX & TX */
+		priv->rss_qp_num = 0;
+		priv->tss_qp_num = 0;
+		priv->num_rx_queues = 1;
+		priv->num_tx_queues = 1;
+		kfree(device_attr);
+		return 0;
+	}
+	num_cores = roundup_pow_of_two(num_cores);
+	if (priv->hca_caps & IB_DEVICE_UD_RSS) {
+		int max_rss_tbl_sz;
+		max_rss_tbl_sz = device_attr->max_rss_tbl_sz;
+		max_rss_tbl_sz = min(num_cores, max_rss_tbl_sz);
+		max_rss_tbl_sz = rounddown_pow_of_two(max_rss_tbl_sz);
+		priv->rss_qp_num    = max_rss_tbl_sz;
+		priv->num_rx_queues = max_rss_tbl_sz;
+	} else {
+		/* No additional QP, only the parent QP for RX */
+		priv->rss_qp_num = 0;
+		priv->num_rx_queues = 1;
+	}
+
 	kfree(device_attr);
 
-	priv->num_rx_queues = 1;
-	priv->num_tx_queues = 1;
+	priv->tss_qp_num = num_cores;
+	if (priv->hca_caps & IB_DEVICE_UD_TSS)
+		/* TSS is supported by HW */
+		priv->num_tx_queues = priv->tss_qp_num;
+	else
+		/* If TSS is not support by HW use the parent QP for ARP */
+		priv->num_tx_queues = priv->tss_qp_num + 1;
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 4be626f..3917d3c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -35,6 +35,31 @@
 
 #include "ipoib.h"
 
+static int set_qps_qkey(struct ipoib_dev_priv *priv)
+{
+	struct ib_qp_attr *qp_attr;
+	struct ipoib_recv_ring *recv_ring;
+	int ret = -ENOMEM;
+	int i;
+
+	qp_attr = kmalloc(sizeof(*qp_attr), GFP_KERNEL);
+	if (!qp_attr)
+		return -ENOMEM;
+
+	qp_attr->qkey = priv->qkey;
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; ++i) {
+		ret = ib_modify_qp(recv_ring->recv_qp, qp_attr, IB_QP_QKEY);
+		if (ret)
+			break;
+		recv_ring++;
+	}
+
+	kfree(qp_attr);
+
+	return ret;
+}
+
 int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int set_qkey)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -50,18 +75,9 @@ int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int
 	set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 
 	if (set_qkey) {
-		ret = -ENOMEM;
-		qp_attr = kmalloc(sizeof *qp_attr, GFP_KERNEL);
-		if (!qp_attr)
-			goto out;
-
-		/* set correct QKey for QP */
-		qp_attr->qkey = priv->qkey;
-		ret = ib_modify_qp(priv->qp, qp_attr, IB_QP_QKEY);
-		if (ret) {
-			ipoib_warn(priv, "failed to modify QP, ret = %d\n", ret);
+		ret = set_qps_qkey(priv);
+		if (ret)
 			goto out;
-		}
 	}
 
 	/* attach QP to multicast group */
@@ -74,16 +90,13 @@ out:
 	return ret;
 }
 
-int ipoib_init_qp(struct net_device *dev)
+static int ipoib_init_one_qp(struct ipoib_dev_priv *priv, struct ib_qp *qp,
+				int init_attr)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret;
 	struct ib_qp_attr qp_attr;
 	int attr_mask;
 
-	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
-		return -1;
-
 	qp_attr.qp_state = IB_QPS_INIT;
 	qp_attr.qkey = 0;
 	qp_attr.port_num = priv->port;
@@ -92,17 +105,18 @@ int ipoib_init_qp(struct net_device *dev)
 	    IB_QP_QKEY |
 	    IB_QP_PORT |
 	    IB_QP_PKEY_INDEX |
-	    IB_QP_STATE;
-	ret = ib_modify_qp(priv->qp, &qp_attr, attr_mask);
+	    IB_QP_STATE | init_attr;
+
+	ret = ib_modify_qp(qp, &qp_attr, attr_mask);
 	if (ret) {
-		ipoib_warn(priv, "failed to modify QP to init, ret = %d\n", ret);
+		ipoib_warn(priv, "failed to modify QP to INT, ret = %d\n", ret);
 		goto out_fail;
 	}
 
 	qp_attr.qp_state = IB_QPS_RTR;
 	/* Can't set this in a INIT->RTR transition */
-	attr_mask &= ~IB_QP_PORT;
-	ret = ib_modify_qp(priv->qp, &qp_attr, attr_mask);
+	attr_mask &= ~(IB_QP_PORT | init_attr);
+	ret = ib_modify_qp(qp, &qp_attr, attr_mask);
 	if (ret) {
 		ipoib_warn(priv, "failed to modify QP to RTR, ret = %d\n", ret);
 		goto out_fail;
@@ -112,40 +126,417 @@ int ipoib_init_qp(struct net_device *dev)
 	qp_attr.sq_psn = 0;
 	attr_mask |= IB_QP_SQ_PSN;
 	attr_mask &= ~IB_QP_PKEY_INDEX;
-	ret = ib_modify_qp(priv->qp, &qp_attr, attr_mask);
+	ret = ib_modify_qp(qp, &qp_attr, attr_mask);
 	if (ret) {
 		ipoib_warn(priv, "failed to modify QP to RTS, ret = %d\n", ret);
 		goto out_fail;
 	}
 
-	/* Only one ring currently */
-	priv->recv_ring[0].recv_qp = priv->qp;
-	priv->send_ring[0].send_qp = priv->qp;
-
 	return 0;
 
 out_fail:
 	qp_attr.qp_state = IB_QPS_RESET;
-	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
+	if (ib_modify_qp(qp, &qp_attr, IB_QP_STATE))
 		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
 
 	return ret;
 }
 
-int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
+static int ipoib_init_rss_qps(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	struct ib_qp_attr qp_attr;
+	int i;
+	int ret;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->rss_qp_num; i++) {
+		ret = ipoib_init_one_qp(priv, recv_ring->recv_qp, 0);
+		if (ret) {
+			ipoib_warn(priv,
+				   "failed to init rss qp, ind = %d, ret=%d\n",
+				   i, ret);
+			goto out_free_reset_qp;
+		}
+		recv_ring++;
+	}
+
+	return 0;
+
+out_free_reset_qp:
+	for (--i; i >= 0; --i) {
+		qp_attr.qp_state = IB_QPS_RESET;
+		if (ib_modify_qp(priv->recv_ring[i].recv_qp,
+				 &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv,
+				   "Failed to modify QP to RESET state\n");
+	}
+
+	return ret;
+}
+
+static int ipoib_init_tss_qps(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	struct ib_qp_attr qp_attr;
+	int i;
+	int ret;
+
+	send_ring = priv->send_ring;
+	/*
+	 * Note if priv->tss_qdisc_num > priv->tss_qp_num then since
+	 * the last QP is the parent QP and it will be initialize later
+	 */
+	for (i = 0; i < priv->tss_qp_num; i++) {
+		ret = ipoib_init_one_qp(priv, send_ring->send_qp, 0);
+		if (ret) {
+			ipoib_warn(priv,
+				   "failed to init tss qp, ind = %d, ret=%d\n",
+				   i, ret);
+			goto out_free_reset_qp;
+		}
+		send_ring++;
+	}
+
+	return 0;
+
+out_free_reset_qp:
+	for (--i; i >= 0; --i) {
+		qp_attr.qp_state = IB_QPS_RESET;
+		if (ib_modify_qp(priv->send_ring[i].send_qp,
+				 &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv,
+				   "Failed to modify QP to RESET state\n");
+	}
+
+	return ret;
+}
+
+int ipoib_init_qp(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ib_qp_attr qp_attr;
+	int ret, i, attr;
+
+	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
+		ipoib_warn(priv, "PKEY not assigned\n");
+		return -1;
+	}
+
+	/* Init parent QP */
+	/* If rss_qp_num = 0 then the parent QP is the RX QP */
+	ret = ipoib_init_rss_qps(dev);
+	if (ret)
+		return ret;
+
+	ret = ipoib_init_tss_qps(dev);
+	if (ret)
+		goto out_reset_tss_qp;
+
+	/* Init the parent QP which can be the only QP */
+	attr = priv->rss_qp_num > 0 ? IB_QP_GROUP_RSS : 0;
+	ret = ipoib_init_one_qp(priv, priv->qp, attr);
+	if (ret) {
+		ipoib_warn(priv, "failed to init parent qp, ret=%d\n", ret);
+		goto out_reset_rss_qp;
+	}
+
+	return 0;
+
+out_reset_rss_qp:
+	for (i = 0; i < priv->rss_qp_num; i++) {
+		qp_attr.qp_state = IB_QPS_RESET;
+		if (ib_modify_qp(priv->recv_ring[i].recv_qp,
+				 &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv,
+				   "Failed to modify QP to RESET state\n");
+	}
+
+out_reset_tss_qp:
+	for (i = 0; i < priv->tss_qp_num; i++) {
+		qp_attr.qp_state = IB_QPS_RESET;
+		if (ib_modify_qp(priv->send_ring[i].send_qp,
+				 &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv,
+				   "Failed to modify QP to RESET state\n");
+	}
+
+	return ret;
+}
+
+static int ipoib_transport_cq_init(struct net_device *dev,
+							int size)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	struct ipoib_send_ring *send_ring;
+	struct ib_cq *cq;
+	int i, allocated_rx, allocated_tx, req_vec;
+
+	allocated_rx = 0;
+	allocated_tx = 0;
+
+	/* We over subscribed the CPUS, ports start from 1 */
+	req_vec = (priv->port - 1) * roundup_pow_of_two(num_online_cpus());
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		/* Try to spread vectors based on port and ring numbers */
+		cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
+				  recv_ring, size,
+				  req_vec % priv->ca->num_comp_vectors);
+		if (IS_ERR(cq)) {
+			pr_warn("%s: failed to create recv CQ\n",
+				priv->ca->name);
+			goto out_free_recv_cqs;
+		}
+		recv_ring->recv_cq = cq;
+		allocated_rx++;
+		req_vec++;
+		if (ib_req_notify_cq(recv_ring->recv_cq, IB_CQ_NEXT_COMP)) {
+			pr_warn("%s: req notify recv CQ\n",
+				priv->ca->name);
+			goto out_free_recv_cqs;
+		}
+		recv_ring++;
+	}
+
+	/* We over subscribed the CPUS, ports start from 1 */
+	req_vec = (priv->port - 1) * roundup_pow_of_two(num_online_cpus());
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		cq = ib_create_cq(priv->ca,
+				  ipoib_send_comp_handler, NULL,
+				  send_ring, ipoib_sendq_size,
+				  req_vec % priv->ca->num_comp_vectors);
+		if (IS_ERR(cq)) {
+			pr_warn("%s: failed to create send CQ\n",
+				priv->ca->name);
+			goto out_free_send_cqs;
+		}
+		send_ring->send_cq = cq;
+		allocated_tx++;
+		req_vec++;
+		send_ring++;
+	}
+
+	return 0;
+
+out_free_send_cqs:
+	for (i = 0; i < allocated_tx; i++) {
+		ib_destroy_cq(priv->send_ring[i].send_cq);
+		priv->send_ring[i].send_cq = NULL;
+	}
+
+out_free_recv_cqs:
+	for (i = 0; i < allocated_rx; i++) {
+		ib_destroy_cq(priv->recv_ring[i].recv_cq);
+		priv->recv_ring[i].recv_cq = NULL;
+	}
+
+	return -ENODEV;
+}
+
+static int ipoib_create_parent_qp(struct net_device *dev,
+				  struct ib_device *ca)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ib_qp_init_attr init_attr = {
+		.sq_sig_type = IB_SIGNAL_ALL_WR,
+		.qp_type     = IB_QPT_UD
+	};
+	struct ib_qp *qp;
+
+	if (priv->hca_caps & IB_DEVICE_UD_TSO)
+		init_attr.create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
+
+	if (priv->hca_caps & IB_DEVICE_BLOCK_MULTICAST_LOOPBACK)
+		init_attr.create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
+
+	if (dev->features & NETIF_F_SG)
+		init_attr.cap.max_send_sge = MAX_SKB_FRAGS + 1;
+
+	if (priv->tss_qp_num == 0 && priv->rss_qp_num == 0)
+		/* Legacy mode */
+		init_attr.qpg_type = IB_QPG_NONE;
+	else {
+		init_attr.qpg_type = IB_QPG_PARENT;
+		init_attr.parent_attrib.tss_child_count = priv->tss_qp_num;
+		init_attr.parent_attrib.rss_child_count = priv->rss_qp_num;
+	}
+
+	/*
+	 * NO TSS (tss_qp_num = 0 priv->num_tx_queues  == 1)
+	 * OR TSS is not supported in HW in this case
+	 * parent QP is used for ARR and friend transmission
+	 */
+	if (priv->num_tx_queues > priv->tss_qp_num) {
+		init_attr.cap.max_send_wr  = ipoib_sendq_size;
+		init_attr.cap.max_send_sge = 1;
+	}
+
+	/* No RSS parent QP will be used for RX */
+	if (priv->rss_qp_num == 0) {
+		init_attr.cap.max_recv_wr  = ipoib_recvq_size;
+		init_attr.cap.max_recv_sge = IPOIB_UD_RX_SG;
+	}
+
+	/* Note that if parent QP is not used for RX/TX then this is harmless */
+	init_attr.recv_cq = priv->recv_ring[0].recv_cq;
+	init_attr.send_cq = priv->send_ring[priv->tss_qp_num].send_cq;
+
+	qp = ib_create_qp(priv->pd, &init_attr);
+	if (IS_ERR(qp)) {
+		pr_warn("%s: failed to create parent QP\n", ca->name);
+		return -ENODEV; /* qp is an error value and will be checked */
+	}
+
+	priv->qp = qp;
+
+	/* TSS is not supported in HW or NO TSS (tss_qp_num = 0) */
+	if (priv->num_tx_queues > priv->tss_qp_num)
+		priv->send_ring[priv->tss_qp_num].send_qp = qp;
+
+	/* No RSS parent QP will be used for RX */
+	if (priv->rss_qp_num == 0)
+		priv->recv_ring[0].recv_qp = qp;
+
+	/* only with SW TSS there is a need for a mask */
+	if ((priv->hca_caps & IB_DEVICE_UD_TSS) || (priv->tss_qp_num == 0))
+		/* TSS is supported by HW or no TSS at all */
+		priv->tss_qpn_mask_sz = 0;
+	else {
+		/* SW TSS, get mask back from HW, put in the upper nibble */
+		u16 tmp = (u16)init_attr.cap.qpg_tss_mask_sz;
+		priv->tss_qpn_mask_sz = cpu_to_be16((tmp << 12));
+	}
+	return 0;
+}
+
+static struct ib_qp *ipoib_create_tss_qp(struct net_device *dev,
+					 struct ib_device *ca,
+					 int ind)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_init_attr init_attr = {
 		.cap = {
 			.max_send_wr  = ipoib_sendq_size,
-			.max_recv_wr  = ipoib_recvq_size,
 			.max_send_sge = 1,
+		},
+		.sq_sig_type = IB_SIGNAL_ALL_WR,
+		.qp_type     = IB_QPT_UD
+	};
+	struct ib_qp *qp;
+
+	if (priv->hca_caps & IB_DEVICE_UD_TSO)
+		init_attr.create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
+
+	if (dev->features & NETIF_F_SG)
+		init_attr.cap.max_send_sge = MAX_SKB_FRAGS + 1;
+
+	init_attr.qpg_type = IB_QPG_CHILD_TX;
+	init_attr.qpg_parent = priv->qp;
+
+	init_attr.recv_cq = priv->send_ring[ind].send_cq;
+	init_attr.send_cq = init_attr.recv_cq;
+
+	qp = ib_create_qp(priv->pd, &init_attr);
+	if (IS_ERR(qp)) {
+		pr_warn("%s: failed to create TSS QP(%d)\n", ca->name, ind);
+		return qp; /* qp is an error value and will be checked */
+	}
+
+	return qp;
+}
+
+static struct ib_qp *ipoib_create_rss_qp(struct net_device *dev,
+					 struct ib_device *ca,
+					 int ind)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ib_qp_init_attr init_attr = {
+		.cap = {
+			.max_recv_wr  = ipoib_recvq_size,
 			.max_recv_sge = IPOIB_UD_RX_SG
 		},
 		.sq_sig_type = IB_SIGNAL_ALL_WR,
 		.qp_type     = IB_QPT_UD
 	};
+	struct ib_qp *qp;
+
+	init_attr.qpg_type = IB_QPG_CHILD_RX;
+	init_attr.qpg_parent = priv->qp;
+
+	init_attr.recv_cq = priv->recv_ring[ind].recv_cq;
+	init_attr.send_cq = init_attr.recv_cq;
+
+	qp = ib_create_qp(priv->pd, &init_attr);
+	if (IS_ERR(qp)) {
+		pr_warn("%s: failed to create RSS QP(%d)\n", ca->name, ind);
+		return qp; /* qp is an error value and will be checked */
+	}
 
+	return qp;
+}
+
+static int ipoib_create_other_qps(struct net_device *dev,
+				  struct ib_device *ca)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	struct ipoib_recv_ring *recv_ring;
+	int i, rss_created, tss_created;
+	struct ib_qp *qp;
+
+	tss_created = 0;
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->tss_qp_num; i++) {
+		qp = ipoib_create_tss_qp(dev, ca, i);
+		if (IS_ERR(qp)) {
+			pr_warn("%s: failed to create QP\n",
+				ca->name);
+			goto out_free_send_qp;
+		}
+		send_ring->send_qp = qp;
+		send_ring++;
+		tss_created++;
+	}
+
+	rss_created = 0;
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->rss_qp_num; i++) {
+		qp = ipoib_create_rss_qp(dev, ca, i);
+		if (IS_ERR(qp)) {
+			pr_warn("%s: failed to create QP\n",
+				ca->name);
+			goto out_free_recv_qp;
+		}
+		recv_ring->recv_qp = qp;
+		recv_ring++;
+		rss_created++;
+	}
+
+	return 0;
+
+out_free_recv_qp:
+	for (i = 0; i < rss_created; i++) {
+		ib_destroy_qp(priv->recv_ring[i].recv_qp);
+		priv->recv_ring[i].recv_qp = NULL;
+	}
+
+out_free_send_qp:
+	for (i = 0; i < tss_created; i++) {
+		ib_destroy_qp(priv->send_ring[i].send_qp);
+		priv->send_ring[i].send_qp = NULL;
+	}
+
+	return -ENODEV;
+}
+
+int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_send_ring *send_ring;
 	struct ipoib_recv_ring *recv_ring, *first_recv_ring;
 	int ret, size;
@@ -173,49 +564,38 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 			size += ipoib_recvq_size * ipoib_max_conn_qp;
 	}
 
-	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
-				     priv->recv_ring, size, 0);
-	if (IS_ERR(priv->recv_cq)) {
-		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
+	/* Create CQ(s) */
+	ret = ipoib_transport_cq_init(dev, size);
+	if (ret) {
+		pr_warn("%s: ipoib_transport_cq_init failed\n", ca->name);
 		goto out_free_mr;
 	}
 
-	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
-				     priv->send_ring, ipoib_sendq_size, 0);
-	if (IS_ERR(priv->send_cq)) {
-		printk(KERN_WARNING "%s: failed to create send CQ\n", ca->name);
-		goto out_free_recv_cq;
-	}
-
-	/* Only one ring */
-	priv->recv_ring[0].recv_cq = priv->recv_cq;
-	priv->send_ring[0].send_cq = priv->send_cq;
-
-	if (ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP))
-		goto out_free_send_cq;
-
-	init_attr.send_cq = priv->send_cq;
-	init_attr.recv_cq = priv->recv_cq;
-
-	if (priv->hca_caps & IB_DEVICE_UD_TSO)
-		init_attr.create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
-
-	if (priv->hca_caps & IB_DEVICE_BLOCK_MULTICAST_LOOPBACK)
-		init_attr.create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
-
-	if (dev->features & NETIF_F_SG)
-		init_attr.cap.max_send_sge = MAX_SKB_FRAGS + 1;
-
-	priv->qp = ib_create_qp(priv->pd, &init_attr);
-	if (IS_ERR(priv->qp)) {
-		printk(KERN_WARNING "%s: failed to create QP\n", ca->name);
-		goto out_free_send_cq;
+	/* Init the parent QP */
+	ret = ipoib_create_parent_qp(dev, ca);
+	if (ret) {
+		pr_warn("%s: failed to create parent QP\n", ca->name);
+		goto out_free_cqs;
 	}
 
+	/*
+	* advetize that we are willing to accept from TSS sender
+	* note that this only indicates that this side is willing to accept
+	* TSS frames, it doesn't implies that it will use TSS since for
+	* transmission the peer should advertize TSS as well
+	*/
+	priv->dev->dev_addr[0] |= IPOIB_FLAGS_TSS;
 	priv->dev->dev_addr[1] = (priv->qp->qp_num >> 16) & 0xff;
 	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
 	priv->dev->dev_addr[3] = (priv->qp->qp_num      ) & 0xff;
 
+	/* create TSS & RSS QPs */
+	ret = ipoib_create_other_qps(dev, ca);
+	if (ret) {
+		pr_warn("%s: failed to create QP(s)\n", ca->name);
+		goto out_free_parent_qp;
+	}
+
 	send_ring = priv->send_ring;
 	for (j = 0; j < priv->num_tx_queues; j++) {
 		for (i = 0; i < MAX_SKB_FRAGS + 1; ++i)
@@ -256,11 +636,20 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 
 	return 0;
 
-out_free_send_cq:
-	ib_destroy_cq(priv->send_cq);
+out_free_parent_qp:
+	ib_destroy_qp(priv->qp);
+	priv->qp = NULL;
+
+out_free_cqs:
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		ib_destroy_cq(priv->recv_ring[i].recv_cq);
+		priv->recv_ring[i].recv_cq = NULL;
+	}
 
-out_free_recv_cq:
-	ib_destroy_cq(priv->recv_cq);
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		ib_destroy_cq(priv->send_ring[i].send_cq);
+		priv->send_ring[i].send_cq = NULL;
+	}
 
 out_free_mr:
 	ib_dereg_mr(priv->mr);
@@ -271,10 +660,101 @@ out_free_pd:
 	return -ENODEV;
 }
 
+static void ipoib_destroy_tx_qps(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	int i;
+
+	if (NULL == priv->send_ring)
+		return;
+
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->tss_qp_num; i++) {
+		if (send_ring->send_qp) {
+			if (ib_destroy_qp(send_ring->send_qp))
+				ipoib_warn(priv, "ib_destroy_qp (send) failed\n");
+			send_ring->send_qp = NULL;
+		}
+		send_ring++;
+	}
+
+	/*
+	 * No support of TSS in HW
+	 * so there is an extra QP but it is freed later
+	 */
+	if (priv->num_tx_queues > priv->tss_qp_num)
+		send_ring->send_qp = NULL;
+}
+
+static void ipoib_destroy_rx_qps(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	int i;
+
+	if (NULL == priv->recv_ring)
+		return;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->rss_qp_num; i++) {
+		if (recv_ring->recv_qp) {
+			if (ib_destroy_qp(recv_ring->recv_qp))
+				ipoib_warn(priv, "ib_destroy_qp (recv) failed\n");
+			recv_ring->recv_qp = NULL;
+		}
+		recv_ring++;
+	}
+}
+
+static void ipoib_destroy_tx_cqs(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	int i;
+
+	if (NULL == priv->send_ring)
+		return;
+
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		if (send_ring->send_cq) {
+			if (ib_destroy_cq(send_ring->send_cq))
+				ipoib_warn(priv, "ib_destroy_cq (send) failed\n");
+			send_ring->send_cq = NULL;
+		}
+		send_ring++;
+	}
+}
+
+static void ipoib_destroy_rx_cqs(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	int i;
+
+	if (NULL == priv->recv_ring)
+		return;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		if (recv_ring->recv_cq) {
+			if (ib_destroy_cq(recv_ring->recv_cq))
+				ipoib_warn(priv, "ib_destroy_cq (recv) failed\n");
+			recv_ring->recv_cq = NULL;
+		}
+		recv_ring++;
+	}
+}
+
 void ipoib_transport_dev_cleanup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+	ipoib_destroy_rx_qps(dev);
+	ipoib_destroy_tx_qps(dev);
+
+	/* Destroy parent or only QP */
 	if (priv->qp) {
 		if (ib_destroy_qp(priv->qp))
 			ipoib_warn(priv, "ib_qp_destroy failed\n");
@@ -283,11 +763,8 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
 		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 	}
 
-	if (ib_destroy_cq(priv->send_cq))
-		ipoib_warn(priv, "ib_cq_destroy (send) failed\n");
-
-	if (ib_destroy_cq(priv->recv_cq))
-		ipoib_warn(priv, "ib_cq_destroy (recv) failed\n");
+	ipoib_destroy_rx_cqs(dev);
+	ipoib_destroy_tx_cqs(dev);
 
 	ipoib_cm_dev_cleanup(dev);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
