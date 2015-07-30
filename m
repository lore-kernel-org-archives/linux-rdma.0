From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 30 Jul 2015 04:46:04 -0700
Message-ID: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This enhancement suggest the usage of IB CRC instead of CSUM in IPoIB CM.
IPoIB CM uses RC (Reliable Connection) which guarantees the corruption free
delivery of the packet.

InfiniBand uses 32b CRC which provides stronger data integrity protection
compare to 16b IP Checksum. So, there is no added value that IP/TCP
Checksum provides in the IB world.

The proposal is to tell network stack that IPoIB-CM supports IP Checksum
offload. This enables the kernel to save the time of checksum calculation
of IPoIB CM packets. Network sends the IP packet without adding the IP
Checksum to the header. On the receive side, IPoIB driver again tells the
network stack that IP Checksum is good for the incoming packets and network
stack avoids the IP Checksum calculations.

During connection establishment the driver determine if peer supports
IB CRC as checksum. This is done so driver will be able to calculate
checksum before transmiting the packet in case the peer does not support
this feature.

With this enhancement throughput is increased by 60%.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |   26 ++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   46 +++++++++++++++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   20 ++++++++++--
 3 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 79859c4..67e6f05 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -92,6 +92,7 @@ enum {
 	IPOIB_FLAG_UMCAST	  = 10,
 	IPOIB_STOP_NEIGH_GC	  = 11,
 	IPOIB_NEIGH_TBL_FLUSH	  = 12,
+	IPOIB_FLAG_CSUM		  = 15,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
@@ -183,9 +184,20 @@ struct ipoib_cm_tx_buf {
 
 struct ib_cm_id;
 
+/* Signature so driver can make sure ipoib_cm_data.caps is valid */
+#define IPOIB_CM_PROTO_SIG	0x2211
+/* Current driver ipoib_cm_data version */
+#define IPOIB_CM_PROTO_VER	(1UL << 12)
+
+enum ipoib_cm_data_caps {
+	IPOIB_CM_CAPS_IBCRC_AS_CSUM	= 1UL << 0,
+};
+
 struct ipoib_cm_data {
 	__be32 qpn; /* High byte MUST be ignored on receive */
 	__be32 mtu;
+	__be16 sig; /* must be IPOIB_CM_PROTO_SIG */
+	__be16 caps; /* 4 bits proto ver and 12 bits capabilities */
 };
 
 /*
@@ -230,6 +242,7 @@ struct ipoib_cm_rx {
 	unsigned long		jiffies;
 	enum ipoib_cm_state	state;
 	int			recv_count;
+	u16			caps;
 };
 
 struct ipoib_cm_tx {
@@ -244,6 +257,7 @@ struct ipoib_cm_tx {
 	unsigned	     tx_tail;
 	unsigned long	     flags;
 	u32		     mtu;
+	u16		     caps;
 };
 
 struct ipoib_cm_rx_buf {
@@ -452,8 +466,20 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid);
 
 extern struct workqueue_struct *ipoib_workqueue;
 
+extern int cm_ibcrc_as_csum;
+
 /* functions */
 
+static inline int ipoib_cm_check_proto_sig(u16 proto_sig)
+{
+	return (proto_sig == IPOIB_CM_PROTO_SIG);
+}
+
+static inline int ipoib_cm_check_proto_ver(u16 caps)
+{
+	return ((caps & 0xF000) == IPOIB_CM_PROTO_VER);
+}
+
 int ipoib_poll(struct napi_struct *napi, int budget);
 void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr);
 void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index ee39be6..5578c69 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -423,9 +423,16 @@ static int ipoib_cm_send_rep(struct net_device *dev, struct ib_cm_id *cm_id,
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_data data = {};
 	struct ib_cm_rep_param rep = {};
+	u16 caps = 0;
+
+	caps |= IPOIB_CM_PROTO_VER;
+	if (cm_ibcrc_as_csum && test_bit(IPOIB_FLAG_CSUM, &priv->flags))
+		caps |= IPOIB_CM_CAPS_IBCRC_AS_CSUM;
 
 	data.qpn = cpu_to_be32(priv->qp->qp_num);
 	data.mtu = cpu_to_be32(IPOIB_CM_BUF_SIZE);
+	data.sig = cpu_to_be16(IPOIB_CM_PROTO_SIG);
+	data.caps = cpu_to_be16(caps);
 
 	rep.private_data = &data;
 	rep.private_data_len = sizeof data;
@@ -444,6 +451,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 	struct ipoib_cm_rx *p;
 	unsigned psn;
 	int ret;
+	struct ipoib_cm_data *cm_data;
 
 	ipoib_dbg(priv, "REQ arrived\n");
 	p = kzalloc(sizeof *p, GFP_KERNEL);
@@ -462,6 +470,13 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 		goto err_qp;
 	}
 
+	cm_data = (struct ipoib_cm_data *)event->private_data;
+	ipoib_dbg(priv, "Otherend sig=0x%x\n", be16_to_cpu(cm_data->sig));
+	if (ipoib_cm_check_proto_sig(be16_to_cpu(cm_data->sig)) &&
+	    ipoib_cm_check_proto_ver(be16_to_cpu(cm_data->caps)))
+		p->caps = be16_to_cpu(cm_data->caps);
+	ipoib_dbg(priv, "Otherend caps=0x%x\n", p->caps);
+
 	psn = prandom_u32() & 0xffffff;
 	ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
 	if (ret)
@@ -672,6 +687,10 @@ copied:
 	skb->dev = dev;
 	/* XXX get correct PACKET_ type here */
 	skb->pkt_type = PACKET_HOST;
+
+	if (cm_ibcrc_as_csum && test_bit(IPOIB_FLAG_CSUM, &priv->flags))
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
 	netif_receive_skb(skb);
 
 repost:
@@ -733,6 +752,18 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	tx_req = &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)];
 	tx_req->skb = skb;
 
+	/* Calculate checksum if we support ibcrc_as_csum but peer is not */
+	if ((skb->ip_summed == CHECKSUM_PARTIAL) && cm_ibcrc_as_csum &&
+	    test_bit(IPOIB_FLAG_CSUM, &priv->flags) &&
+	    !(tx->caps & IPOIB_CM_CAPS_IBCRC_AS_CSUM)) {
+		if (skb_checksum_help(skb)) {
+			ipoib_warn(priv, "Fail to csum skb\n");
+			++dev->stats.tx_errors;
+			dev_kfree_skb_any(skb);
+			return;
+		}
+	}
+
 	if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
 		++dev->stats.tx_errors;
 		dev_kfree_skb_any(skb);
@@ -954,6 +985,7 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 	struct ib_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 	struct sk_buff *skb;
+	struct ipoib_cm_data *cm_data;
 
 	p->mtu = be32_to_cpu(data->mtu);
 
@@ -963,6 +995,13 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 		return -EINVAL;
 	}
 
+	cm_data = (struct ipoib_cm_data *)event->private_data;
+	ipoib_dbg(priv, "Otherend sig=0x%x\n", be16_to_cpu(cm_data->sig));
+	if (ipoib_cm_check_proto_sig(be16_to_cpu(cm_data->sig)) &&
+	    ipoib_cm_check_proto_ver(be16_to_cpu(cm_data->caps)))
+		p->caps = be16_to_cpu(cm_data->caps);
+	ipoib_dbg(priv, "Otherend caps=0x%x\n", p->caps);
+
 	qp_attr.qp_state = IB_QPS_RTR;
 	ret = ib_cm_init_qp_attr(cm_id, &qp_attr, &qp_attr_mask);
 	if (ret) {
@@ -1051,9 +1090,16 @@ static int ipoib_cm_send_req(struct net_device *dev,
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_data data = {};
 	struct ib_cm_req_param req = {};
+	u16 caps = 0;
+
+	caps |= IPOIB_CM_PROTO_VER;
+	if (cm_ibcrc_as_csum && test_bit(IPOIB_FLAG_CSUM, &priv->flags))
+		caps |= IPOIB_CM_CAPS_IBCRC_AS_CSUM;
 
 	data.qpn = cpu_to_be32(priv->qp->qp_num);
 	data.mtu = cpu_to_be32(IPOIB_CM_BUF_SIZE);
+	data.sig = cpu_to_be16(IPOIB_CM_PROTO_SIG);
+	data.caps = cpu_to_be16(caps);
 
 	req.primary_path		= pathrec;
 	req.alternate_path		= NULL;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b2943c8..a1940e2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -73,6 +73,11 @@ module_param_named(debug_level, ipoib_debug_level, int, 0644);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
 #endif
 
+int cm_ibcrc_as_csum = 1;
+module_param_named(cm_ibcrc_as_csum, cm_ibcrc_as_csum, int, 0444);
+MODULE_PARM_DESC(cm_ibcrc_as_csum,
+		 "Indicates whether to utilize IB-CRC as CSUM in connected mode,(default: 1)");
+
 struct ipoib_path_iter {
 	struct net_device *dev;
 	struct ipoib_path  path;
@@ -189,8 +194,12 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
-	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags)) {
+		features &= ~NETIF_F_TSO;
+		if (!(cm_ibcrc_as_csum && (test_bit(IPOIB_FLAG_CSUM,
+					   &priv->flags))))
+			features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+	}
 
 	return features;
 }
@@ -234,7 +243,11 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 		netdev_update_features(dev);
 		dev_set_mtu(dev, ipoib_cm_max_mtu(dev));
 		rtnl_unlock();
-		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
+		if (cm_ibcrc_as_csum && (test_bit(IPOIB_FLAG_CSUM,
+						  &priv->flags)))
+			priv->tx_wr.send_flags |= IB_SEND_IP_CSUM;
+		else
+			priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
 
 		ipoib_flush_paths(dev);
 		rtnl_lock();
@@ -1552,6 +1565,7 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 	kfree(device_attr);
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
+		set_bit(IPOIB_FLAG_CSUM, &priv->flags);
 		priv->dev->hw_features = NETIF_F_SG |
 			NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
