From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 6/6] IB/IPoIB: Support acceleration options callbacks
Date: Wed,  5 Apr 2017 17:09:13 +0300
Message-ID: <20170405140913.2551-7-leon@kernel.org>
References: <20170405140913.2551-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405140913.2551-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IPoIB driver now uses the new set of callback functions.

If the hardware provider supports the new ipoib_options implementation,
the driver uses the callbacks in its data path flows, otherwise it uses the
driver default implementation for all data flows in its code.

The default implementation wasn't change and it is exactly as it was before
introduction of acceleration support.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  29 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  52 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 136 ++++++++++++++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  15 ++-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  16 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   5 +-
 7 files changed, 187 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 9a912830c8e0..2ae1f0883c9b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -52,7 +52,6 @@
 #include <rdma/ib_pack.h>
 #include <rdma/ib_sa.h>
 #include <linux/sched.h>
-
 /* constants */
 
 enum ipoib_flush_level {
@@ -153,8 +152,12 @@ static inline void skb_add_pseudo_hdr(struct sk_buff *skb)
 	skb_pull(skb, IPOIB_HARD_LEN);
 }
 
-/* Keep the refactoring compile able */
-#define ipoib_priv netdev_priv
+static inline struct ipoib_dev_priv *ipoib_priv(const struct net_device *dev)
+{
+	struct rdma_netdev *rn = netdev_priv(dev);
+
+	return rn->clnt_priv;
+}
 
 /* Used for all multicast joins (broadcast, IPv4 mcast and IPv6 mcast) */
 struct ipoib_mcast {
@@ -407,6 +410,7 @@ struct ipoib_dev_priv {
 	struct timer_list poll_timer;
 	unsigned max_send_sge;
 	bool sm_fullmember_sendonly_support;
+	const struct net_device_ops	*rn_ops;
 };
 
 struct ipoib_ah {
@@ -485,16 +489,16 @@ int ipoib_open(struct net_device *dev);
 int ipoib_add_pkey_attr(struct net_device *dev);
 int ipoib_add_umcast_attr(struct net_device *dev);
 
-void ipoib_send(struct net_device *dev, struct sk_buff *skb,
-		struct ipoib_ah *address, u32 dqpn);
+int ipoib_send(struct net_device *dev, struct sk_buff *skb,
+	       struct ib_ah *address, u32 dqpn);
 void ipoib_reap_ah(struct work_struct *work);
 
 struct ipoib_path *__path_find(struct net_device *dev, void *gid);
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
 int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv);
-struct ipoib_dev_priv *ipoib_intf_alloc(const char *format);
-
+struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
+					const char *format);
 void ipoib_ib_tx_timer_func(unsigned long ctx);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
 void ipoib_ib_dev_flush_normal(struct work_struct *work);
@@ -502,8 +506,9 @@ void ipoib_ib_dev_flush_heavy(struct work_struct *work);
 void ipoib_pkey_event(struct work_struct *work);
 void ipoib_ib_dev_cleanup(struct net_device *dev);
 
-void ipoib_dev_uninit_default(struct net_device *dev);
+int ipoib_ib_dev_open_default(struct net_device *dev);
 int ipoib_ib_dev_open(struct net_device *dev);
+int ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_ib_dev_up(struct net_device *dev);
 void ipoib_ib_dev_down(struct net_device *dev);
 int ipoib_ib_dev_stop_default(struct net_device *dev);
@@ -566,8 +571,10 @@ void ipoib_path_iter_read(struct ipoib_path_iter *iter,
 			  struct ipoib_path *path);
 #endif
 
-int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
-		       union ib_gid *mgid, int set_qkey);
+int ipoib_mcast_attach(struct net_device *dev, struct ib_device *hca,
+		       union ib_gid *mgid, u16 mlid, int set_qkey, u32 qkey);
+int ipoib_mcast_detach(struct net_device *dev, struct ib_device *hca,
+		       union ib_gid *mgid, u16 mlid);
 void ipoib_mcast_remove_list(struct list_head *remove_list);
 void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
 				struct list_head *remove_list);
@@ -591,7 +598,7 @@ void __exit ipoib_netlink_fini(void);
 void ipoib_set_umcast(struct net_device *ndev, int umcast_val);
 int  ipoib_set_mode(struct net_device *dev, const char *buf);
 
-void ipoib_setup(struct net_device *dev);
+void ipoib_setup_common(struct net_device *dev);
 
 void ipoib_pkey_open(struct ipoib_dev_priv *priv);
 void ipoib_drain_cq(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 23227a0cb0f1..0fe52da3526c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -537,8 +537,8 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 	return ib_post_send(priv->qp, &priv->tx_wr.wr, &bad_wr);
 }
 
-void ipoib_send(struct net_device *dev, struct sk_buff *skb,
-		struct ipoib_ah *address, u32 dqpn)
+int ipoib_send(struct net_device *dev, struct sk_buff *skb,
+	       struct ib_ah *address, u32 dqpn)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_tx_buf *tx_req;
@@ -554,7 +554,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 			++dev->stats.tx_dropped;
 			++dev->stats.tx_errors;
 			dev_kfree_skb_any(skb);
-			return;
+			return -1;
 		}
 	} else {
 		if (unlikely(skb->len > priv->mcast_mtu + IPOIB_ENCAP_LEN)) {
@@ -563,7 +563,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 			++dev->stats.tx_dropped;
 			++dev->stats.tx_errors;
 			ipoib_cm_skb_too_long(dev, skb, priv->mcast_mtu);
-			return;
+			return -1;
 		}
 		phead = NULL;
 		hlen  = 0;
@@ -574,7 +574,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 			++dev->stats.tx_dropped;
 			++dev->stats.tx_errors;
 			dev_kfree_skb_any(skb);
-			return;
+			return -1;
 		}
 		/* Does skb_linearize return ok without reducing nr_frags? */
 		if (skb_shinfo(skb)->nr_frags > usable_sge) {
@@ -582,7 +582,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 			++dev->stats.tx_dropped;
 			++dev->stats.tx_errors;
 			dev_kfree_skb_any(skb);
-			return;
+			return -1;
 		}
 	}
 
@@ -601,7 +601,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
 		++dev->stats.tx_errors;
 		dev_kfree_skb_any(skb);
-		return;
+		return -1;
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
@@ -620,7 +620,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	skb_dst_drop(skb);
 
 	rc = post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
-		       address->ah, dqpn, tx_req, phead, hlen);
+		       address, dqpn, tx_req, phead, hlen);
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
@@ -629,16 +629,19 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		dev_kfree_skb_any(skb);
 		if (netif_queue_stopped(dev))
 			netif_wake_queue(dev);
+		rc = 0;
 	} else {
 		netif_trans_update(dev);
 
-		address->last_send = priv->tx_head;
+		rc = priv->tx_head;
 		++priv->tx_head;
 	}
 
 	if (unlikely(priv->tx_outstanding > MAX_SEND_CQE))
 		while (poll_tx(priv))
 			; /* nothing */
+
+	return rc;
 }
 
 static void __ipoib_reap_ah(struct net_device *dev)
@@ -713,7 +716,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 	struct ipoib_tx_buf *tx_req;
 	int i;
 
-	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
+	if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 		napi_disable(&priv->napi);
 
 	ipoib_cm_dev_stop(dev);
@@ -782,8 +785,11 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 
 int ipoib_ib_dev_stop(struct net_device *dev)
 {
-	ipoib_ib_dev_stop_default(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+
+	priv->rn_ops->ndo_stop(dev);
 
+	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 	ipoib_flush_ah(dev);
 
 	return 0;
@@ -808,23 +814,20 @@ int ipoib_ib_dev_open_default(struct net_device *dev)
 	ret = ipoib_ib_post_receives(dev);
 	if (ret) {
 		ipoib_warn(priv, "ipoib_ib_post_receives returned %d\n", ret);
-		goto dev_stop;
+		goto out;
 	}
 
 	ret = ipoib_cm_dev_open(dev);
 	if (ret) {
 		ipoib_warn(priv, "ipoib_cm_dev_open returned %d\n", ret);
-		goto dev_stop;
+		goto out;
 	}
 
-	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
+	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 		napi_enable(&priv->napi);
 
 	return 0;
-dev_stop:
-	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
-		napi_enable(&priv->napi);
-	ipoib_ib_dev_stop(dev);
+out:
 	return -1;
 }
 
@@ -844,16 +847,21 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	queue_delayed_work(priv->wq, &priv->ah_reap_task,
 			   round_jiffies_relative(HZ));
 
-	if (ipoib_ib_dev_open_default(dev)) {
+	if (priv->rn_ops->ndo_open(dev)) {
 		pr_warn("%s: Failed to open dev\n", dev->name);
-		goto stop_ah_reap;
+		goto dev_stop;
 	}
 
+	set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
+
 	return 0;
 
-stop_ah_reap:
+dev_stop:
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
 	cancel_delayed_work(&priv->ah_reap_task);
+	set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
+	napi_enable(&priv->napi);
+	ipoib_ib_dev_stop(dev);
 	return -1;
 }
 
@@ -1238,7 +1246,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 
 	clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 
-	ipoib_dev_uninit_default(dev);
+	priv->rn_ops->ndo_uninit(dev);
 
 	if (priv->pd) {
 		ib_dealloc_pd(priv->pd);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3a479fb590cd..08c1b361acfc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -166,7 +166,7 @@ static int ipoib_stop(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	ipoib_ib_dev_down(dev);
-	ipoib_ib_dev_stop_default(dev);
+	ipoib_ib_dev_stop(dev);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
 		struct ipoib_dev_priv *cpriv;
@@ -918,6 +918,7 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 			   struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
 	struct ipoib_path *path;
 	struct ipoib_neigh *neigh;
 	unsigned long flags;
@@ -964,7 +965,8 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 			}
 		} else {
 			spin_unlock_irqrestore(&priv->lock, flags);
-			ipoib_send(dev, skb, path->ah, IPOIB_QPN(daddr));
+			path->ah->last_send = rn->send(dev, skb, path->ah->ah,
+						       IPOIB_QPN(daddr));
 			ipoib_neigh_put(neigh);
 			return;
 		}
@@ -999,6 +1001,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			     struct ipoib_pseudo_header *phdr)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
 	struct ipoib_path *path;
 	unsigned long flags;
 
@@ -1042,7 +1045,8 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			  be16_to_cpu(path->pathrec.dlid));
 
 		spin_unlock_irqrestore(&priv->lock, flags);
-		ipoib_send(dev, skb, path->ah, IPOIB_QPN(phdr->hwaddr));
+		path->ah->last_send = rn->send(dev, skb, path->ah->ah,
+					       IPOIB_QPN(phdr->hwaddr));
 		return;
 	} else if ((path->query || !path_rec_start(dev, path)) &&
 		   skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
@@ -1059,6 +1063,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
 	struct ipoib_neigh *neigh;
 	struct ipoib_pseudo_header *phdr;
 	struct ipoib_header *header;
@@ -1122,7 +1127,8 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto unref;
 		}
 	} else if (neigh->ah) {
-		ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(phdr->hwaddr));
+		neigh->ah->last_send = rn->send(dev, skb, neigh->ah->ah,
+						IPOIB_QPN(phdr->hwaddr));
 		goto unref;
 	}
 
@@ -1637,11 +1643,12 @@ void ipoib_dev_uninit_default(struct net_device *dev)
 	priv->tx_ring = NULL;
 }
 
-static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
-				  int port)
+static int ipoib_dev_init_default(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
+	netif_napi_add(dev, &priv->napi, ipoib_poll, NAPI_POLL_WEIGHT);
+
 	/* Allocate RX/TX "rings" to hold queued skbs */
 	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
 				GFP_KERNEL);
@@ -1651,17 +1658,22 @@ static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
 	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
 	if (!priv->tx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate TX ring (%d entries)\n",
-		       ca->name, ipoib_sendq_size);
+		       priv->ca->name, ipoib_sendq_size);
 		goto out_rx_ring_cleanup;
 	}
 
 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
 
-	if (ipoib_transport_dev_init(dev, ca)) {
-		pr_warn("%s: ipoib_transport_dev_init failed\n", ca->name);
+	if (ipoib_transport_dev_init(dev, priv->ca)) {
+		pr_warn("%s: ipoib_transport_dev_init failed\n", priv->ca->name);
 		goto out_tx_ring_cleanup;
 	}
 
+	/* after qp created set dev address */
+	priv->dev->dev_addr[1] = (priv->qp->qp_num >> 16) & 0xff;
+	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
+	priv->dev->dev_addr[3] = (priv->qp->qp_num) & 0xff;
+
 	setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
 		    (unsigned long)dev);
 
@@ -1703,17 +1715,12 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		goto clean_wq;
 	}
 
-	ret = ipoib_dev_init_default(dev, ca, port);
+	ret = priv->rn_ops->ndo_init(dev);
 	if (ret) {
 		pr_warn("%s failed to init HW resource\n", dev->name);
 		goto out_free_pd;
 	}
 
-	/* after qp created set dev address */
-	priv->dev->dev_addr[1] = (priv->qp->qp_num >> 16) & 0xff;
-	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
-	priv->dev->dev_addr[3] = (priv->qp->qp_num) & 0xff;
-
 	if (ipoib_neigh_hash_init(priv) < 0) {
 		pr_warn("%s failed to init neigh hash\n", dev->name);
 		goto out_dev_uninit;
@@ -1851,7 +1858,7 @@ static const struct net_device_ops ipoib_netdev_ops_vf = {
 	.ndo_get_iflink		 = ipoib_get_iflink,
 };
 
-void ipoib_setup(struct net_device *dev)
+void ipoib_setup_common(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
@@ -1879,11 +1886,14 @@ void ipoib_setup(struct net_device *dev)
 	netif_keep_dst(dev);
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
+}
 
-	priv->dev = dev;
+void ipoib_build_priv(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
+	priv->dev = dev;
 	spin_lock_init(&priv->lock);
-
 	init_rwsem(&priv->vlan_rwsem);
 
 	INIT_LIST_HEAD(&priv->path_list);
@@ -1901,22 +1911,97 @@ void ipoib_setup(struct net_device *dev)
 	INIT_DELAYED_WORK(&priv->neigh_reap_task, ipoib_reap_neigh);
 }
 
-struct ipoib_dev_priv *ipoib_intf_alloc(const char *name)
+static const struct net_device_ops ipoib_netdev_default_pf = {
+	.ndo_init		 = ipoib_dev_init_default,
+	.ndo_uninit		 = ipoib_dev_uninit_default,
+	.ndo_open		 = ipoib_ib_dev_open_default,
+	.ndo_stop		 = ipoib_ib_dev_stop_default,
+};
+
+static struct net_device *ipoib_create_netdev_default(struct ib_device *hca,
+						      const char *name,
+						      unsigned char name_assign_type,
+						      void (*setup)(struct net_device *))
 {
 	struct net_device *dev;
+	struct rdma_netdev *rn;
 
-	dev = alloc_netdev((int)sizeof(struct ipoib_dev_priv), name,
-			   NET_NAME_UNKNOWN, ipoib_setup);
+	dev = alloc_netdev((int)sizeof(struct rdma_netdev),
+			   name,
+			   name_assign_type, setup);
 	if (!dev)
 		return NULL;
 
-	return netdev_priv(dev);
+	rn = netdev_priv(dev);
+
+	rn->send = ipoib_send;
+	rn->attach_mcast = ipoib_mcast_attach;
+	rn->detach_mcast = ipoib_mcast_detach;
+	rn->hca = hca;
+
+	dev->netdev_ops = &ipoib_netdev_default_pf;
+
+	return dev;
+}
+
+static struct net_device *ipoib_get_netdev(struct ib_device *hca, u8 port,
+					   const char *name)
+{
+	struct net_device *dev;
+
+	if (hca->alloc_rdma_netdev) {
+		dev = hca->alloc_rdma_netdev(hca, port,
+					     RDMA_NETDEV_IPOIB, name,
+					     NET_NAME_UNKNOWN,
+					     ipoib_setup_common);
+		if (IS_ERR_OR_NULL(dev) && PTR_ERR(dev) != -EOPNOTSUPP)
+			return NULL;
+	}
+
+	if (!hca->alloc_rdma_netdev || PTR_ERR(dev) == -EOPNOTSUPP)
+		dev = ipoib_create_netdev_default(hca, name, NET_NAME_UNKNOWN,
+						  ipoib_setup_common);
+
+	return dev;
+}
+
+struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
+					const char *name)
+{
+	struct net_device *dev;
+	struct ipoib_dev_priv *priv;
+	struct rdma_netdev *rn;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	dev = ipoib_get_netdev(hca, port, name);
+	if (!dev)
+		goto free_priv;
+
+	priv->rn_ops = dev->netdev_ops;
+
+	/* fixme : should be after the query_cap */
+	if (priv->hca_caps & IB_DEVICE_VIRTUAL_FUNCTION)
+		dev->netdev_ops	= &ipoib_netdev_ops_vf;
+	else
+		dev->netdev_ops	= &ipoib_netdev_ops_pf;
+
+	rn = netdev_priv(dev);
+	rn->clnt_priv = priv;
+	ipoib_build_priv(dev);
+
+	return priv;
+free_priv:
+	kfree(priv);
+	return NULL;
 }
 
 static ssize_t show_pkey(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(dev));
+	struct ipoib_dev_priv *priv = ipoib_priv(to_net_dev(dev));
 
 	return sprintf(buf, "0x%04x\n", priv->pkey);
 }
@@ -2078,7 +2163,7 @@ void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 	priv->hca_caps = hca->attrs.device_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		priv->dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
 
 		if (priv->hca_caps & IB_DEVICE_UD_TSO)
 			priv->dev->hw_features |= NETIF_F_TSO;
@@ -2094,7 +2179,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	struct ib_port_attr attr;
 	int result = -ENOMEM;
 
-	priv = ipoib_intf_alloc(format);
+	priv = ipoib_intf_alloc(hca, port, format);
 	if (!priv)
 		goto alloc_mem_failed;
 
@@ -2264,6 +2349,7 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 
 		unregister_netdev(priv->dev);
 		free_netdev(priv->dev);
+		kfree(priv);
 	}
 
 	kfree(dev_list);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 28d4713ed5ed..8da1955e0003 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -213,6 +213,7 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 {
 	struct net_device *dev = mcast->dev;
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
 	struct ipoib_ah *ah;
 	int ret;
 	int set_qkey = 0;
@@ -260,8 +261,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			return 0;
 		}
 
-		ret = ipoib_mcast_attach(dev, be16_to_cpu(mcast->mcmember.mlid),
-					 &mcast->mcmember.mgid, set_qkey);
+		ret = rn->attach_mcast(dev, priv->ca, &mcast->mcmember.mgid,
+				       be16_to_cpu(mcast->mcmember.mlid),
+				       set_qkey, priv->qkey);
 		if (ret < 0) {
 			ipoib_warn(priv, "couldn't attach QP to multicast group %pI6\n",
 				   mcast->mcmember.mgid.raw);
@@ -707,6 +709,7 @@ int ipoib_mcast_stop_thread(struct net_device *dev)
 static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
 	int ret = 0;
 
 	if (test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
@@ -720,8 +723,8 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 				mcast->mcmember.mgid.raw);
 
 		/* Remove ourselves from the multicast group */
-		ret = ib_detach_mcast(priv->qp, &mcast->mcmember.mgid,
-				      be16_to_cpu(mcast->mcmember.mlid));
+		ret = rn->detach_mcast(dev, priv->ca, &mcast->mcmember.mgid,
+				       be16_to_cpu(mcast->mcmember.mlid));
 		if (ret)
 			ipoib_warn(priv, "ib_detach_mcast failed (result = %d)\n", ret);
 	} else if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
@@ -763,6 +766,7 @@ void ipoib_mcast_remove_list(struct list_head *remove_list)
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
 	struct ipoib_mcast *mcast;
 	unsigned long flags;
 	void *mgid = daddr + 4;
@@ -825,7 +829,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 			}
 		}
 		spin_unlock_irqrestore(&priv->lock, flags);
-		ipoib_send(dev, skb, mcast->ah, IB_MULTICAST_QPN);
+		mcast->ah->last_send = rn->send(dev, skb, mcast->ah->ah,
+						IB_MULTICAST_QPN);
 		if (neigh)
 			ipoib_neigh_put(neigh);
 		return;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index 406e7b039b79..5d795aaea92c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -161,7 +161,7 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.maxtype	= IFLA_IPOIB_MAX,
 	.policy		= ipoib_policy,
 	.priv_size	= sizeof(struct ipoib_dev_priv),
-	.setup		= ipoib_setup,
+	.setup		= ipoib_setup_common,
 	.newlink	= ipoib_new_child_link,
 	.changelink	= ipoib_changelink,
 	.dellink	= ipoib_unregister_child_dev,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 87b6f205d1fc..bb64baf25309 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -35,7 +35,8 @@
 
 #include "ipoib.h"
 
-int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int set_qkey)
+int ipoib_mcast_attach(struct net_device *dev, struct ib_device *hca,
+		       union ib_gid *mgid, u16 mlid, int set_qkey, u32 qkey)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_attr *qp_attr = NULL;
@@ -56,7 +57,7 @@ int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int
 			goto out;
 
 		/* set correct QKey for QP */
-		qp_attr->qkey = priv->qkey;
+		qp_attr->qkey = qkey;
 		ret = ib_modify_qp(priv->qp, qp_attr, IB_QP_QKEY);
 		if (ret) {
 			ipoib_warn(priv, "failed to modify QP, ret = %d\n", ret);
@@ -74,6 +75,17 @@ int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int
 	return ret;
 }
 
+int ipoib_mcast_detach(struct net_device *dev, struct ib_device *hca,
+		       union ib_gid *mgid, u16 mlid)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	int ret;
+
+	ret = ib_detach_mcast(priv->qp, mgid, mlid);
+
+	return ret;
+}
+
 int ipoib_init_qp(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index b4de1737986d..b97839a803e9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -128,14 +128,15 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	ppriv = netdev_priv(pdev);
+	ppriv = ipoib_priv(pdev);
 
 	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
 		return -EPERM;
 
 	snprintf(intf_name, sizeof intf_name, "%s.%04x",
 		 ppriv->dev->name, pkey);
-	priv = ipoib_intf_alloc(intf_name);
+
+	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
 	if (!priv)
 		return -ENOMEM;
 
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
