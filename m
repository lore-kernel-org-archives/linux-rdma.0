From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 05/26] IB/ipoib: Support ipoib acceleration options callbacks
Date: Wed,  1 Mar 2017 16:02:13 +0200
Message-ID: <1488376954-8346-6-git-send-email-erezsh@mellanox.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IPoIB driver now uses the new set of callback functions.
If the HW provider supports the new ipoib_options implementation, the
driver uses the callbacks in its datapath flows, otherwise it uses the
driver default implementation for all data flows in its code.
The default implementation is exactly the driver implementation as it
was without HW vendor support.

TODO: We added remote qkey to ipoib_send in order to match send op
signature.
In accel mode this param will be used but in regular mode this param is
redundant. Need to think about better solution.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           | 18 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 10 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 89 ++++++++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 13 ++--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     | 14 +++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |  5 +-
 6 files changed, 112 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index d94a7a953338..7b158090c1ac 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -51,8 +51,8 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_sa.h>
+#include <rdma/ib_ipoib_accel_ops.h>
 #include <linux/sched.h>
-
 /* constants */
 
 enum ipoib_flush_level {
@@ -357,6 +357,7 @@ struct ipoib_dev_priv {
 	struct ib_cq	 *recv_cq;
 	struct ib_cq	 *send_cq;
 	struct ib_qp	 *qp;
+	u32		  qp_num;
 	u32		  qkey;
 
 	union ib_gid local_gid;
@@ -402,6 +403,7 @@ struct ipoib_dev_priv {
 	u64	hca_caps;
 	struct ipoib_ethtool_st ethtool;
 	struct timer_list poll_timer;
+	struct ib_ipoib_accel_ops *ipoib_accel_ops;
 	unsigned max_send_sge;
 	bool sm_fullmember_sendonly_support;
 };
@@ -483,14 +485,16 @@ static inline void ipoib_put_ah(struct ipoib_ah *ah)
 int ipoib_add_umcast_attr(struct net_device *dev);
 
 void ipoib_send(struct net_device *dev, struct sk_buff *skb,
-		struct ipoib_ah *address, u32 dqpn);
+		struct ipoib_ah *address, u32 dqpn, u32 dqkey);
 void ipoib_reap_ah(struct work_struct *work);
 
 struct ipoib_path *__path_find(struct net_device *dev, void *gid);
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
 int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv);
-struct ipoib_dev_priv *ipoib_intf_alloc(const char *format);
+struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca,
+					const char *format,
+					struct ib_ipoib_accel_ops *ipoib_accel_ops);
 void ipoib_ib_tx_timer_func(unsigned long ctx);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
 void ipoib_ib_dev_flush_normal(struct work_struct *work);
@@ -498,7 +502,10 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 void ipoib_pkey_event(struct work_struct *work);
 void ipoib_ib_dev_cleanup(struct net_device *dev);
 void ipoib_dev_uninit_default(struct net_device *dev);
+int ipoib_ib_dev_open_default(struct net_device *dev);
+int ipoib_ib_dev_stop_default(struct net_device *dev);
 int ipoib_ib_dev_open(struct net_device *dev);
+int ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_ib_dev_up(struct net_device *dev);
 void ipoib_ib_dev_down(struct net_device *dev);
 int ipoib_ib_dev_stop_default(struct net_device *dev);
@@ -561,8 +568,9 @@ void ipoib_path_iter_read(struct ipoib_path_iter *iter,
 			  struct ipoib_path *path);
 #endif
 
-int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
-		       union ib_gid *mgid, int set_qkey);
+int ipoib_mcast_attach(struct net_device *dev, union ib_gid *mgid, u16 mlid,
+		       int set_qkey);
+int ipoib_mcast_detach(struct net_device *dev, union ib_gid *mgid, u16 mlid);
 void ipoib_mcast_remove_list(struct list_head *remove_list);
 void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
 				struct list_head *remove_list);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index dd5fb2964e63..44f6a3d5b672 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -539,7 +539,7 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 }
 
 void ipoib_send(struct net_device *dev, struct sk_buff *skb,
-		struct ipoib_ah *address, u32 dqpn)
+		struct ipoib_ah *address, u32 dqpn, u32 dqkey)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_tx_buf *tx_req;
@@ -783,7 +783,9 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 
 int ipoib_ib_dev_stop(struct net_device *dev)
 {
-	ipoib_ib_dev_stop_default(dev);
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	priv->ipoib_accel_ops->ib_dev_stop(dev);
 
 	ipoib_flush_ah(dev);
 
@@ -845,7 +847,7 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	queue_delayed_work(priv->wq, &priv->ah_reap_task,
 			   round_jiffies_relative(HZ));
 
-	if (ipoib_ib_dev_open_default(dev)) {
+	if (priv->ipoib_accel_ops->ib_dev_open(dev)) {
 		pr_warn("%s: Failed to open dev\n", dev->name);
 		goto stop_ah_reap;
 	}
@@ -1239,7 +1241,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 
 	clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 
-	ipoib_dev_uninit_default(dev);
+	priv->ipoib_accel_ops->ib_dev_cleanup(dev);
 
 	if (priv->pd) {
 		ib_dealloc_pd(priv->pd);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index be8dcea252f9..9946693270a3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -166,7 +166,7 @@ static int ipoib_stop(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	ipoib_ib_dev_down(dev);
-	ipoib_ib_dev_stop_default(dev);
+	ipoib_ib_dev_stop(dev);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
 		struct ipoib_dev_priv *cpriv;
@@ -964,7 +964,9 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 			}
 		} else {
 			spin_unlock_irqrestore(&priv->lock, flags);
-			ipoib_send(dev, skb, path->ah, IPOIB_QPN(daddr));
+			priv->ipoib_accel_ops->send(dev, skb, path->ah,
+						    IPOIB_QPN(daddr),
+						    priv->tx_wr.remote_qkey);
 			ipoib_neigh_put(neigh);
 			return;
 		}
@@ -1042,7 +1044,9 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			  be16_to_cpu(path->pathrec.dlid));
 
 		spin_unlock_irqrestore(&priv->lock, flags);
-		ipoib_send(dev, skb, path->ah, IPOIB_QPN(phdr->hwaddr));
+		priv->ipoib_accel_ops->send(dev, skb, path->ah,
+					    IPOIB_QPN(phdr->hwaddr),
+					    priv->tx_wr.remote_qkey);
 		return;
 	} else if ((path->query || !path_rec_start(dev, path)) &&
 		   skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
@@ -1122,7 +1126,9 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto unref;
 		}
 	} else if (neigh->ah) {
-		ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(phdr->hwaddr));
+		priv->ipoib_accel_ops->send(dev, skb, neigh->ah,
+					    IPOIB_QPN(phdr->hwaddr),
+					    priv->tx_wr.remote_qkey);
 		goto unref;
 	}
 
@@ -1637,8 +1643,7 @@ void ipoib_dev_uninit_default(struct net_device *dev)
 	priv->tx_ring = NULL;
 }
 
-static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
-				  int port)
+static int ipoib_dev_init_default(struct net_device *dev, int *qp_num)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
@@ -1651,14 +1656,14 @@ static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
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
 
@@ -1703,16 +1708,16 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		goto clean_wq;
 	}
 
-	ret = ipoib_dev_init_default(dev, ca, port);
+	ret = priv->ipoib_accel_ops->ib_dev_init(dev, &priv->qp_num);
 	if (ret) {
 		pr_warn("%s failed to init HW resource\n", dev->name);
 		goto out_free_pd;
 	}
 
 	/* after qp created set dev address */
-	priv->dev->dev_addr[1] = (priv->qp->qp_num >> 16) & 0xff;
-	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
-	priv->dev->dev_addr[3] = (priv->qp->qp_num) & 0xff;
+	priv->dev->dev_addr[1] = (priv->qp_num >> 16) & 0xff;
+	priv->dev->dev_addr[2] = (priv->qp_num >>  8) & 0xff;
+	priv->dev->dev_addr[3] = (priv->qp_num) & 0xff;
 
 	if (ipoib_neigh_hash_init(priv) < 0) {
 		pr_warn("%s failed to init neigh hash\n", dev->name);
@@ -1851,21 +1856,19 @@ static int ipoib_get_vf_stats(struct net_device *dev, int vf,
 	.ndo_get_iflink		 = ipoib_get_iflink,
 };
 
-void ipoib_setup(struct net_device *dev)
+void ipoib_setup_common(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+	dev->header_ops		 = &ipoib_header_ops;
+
 	if (priv->hca_caps & IB_DEVICE_VIRTUAL_FUNCTION)
 		dev->netdev_ops	= &ipoib_netdev_ops_vf;
 	else
 		dev->netdev_ops	= &ipoib_netdev_ops_pf;
 
-	dev->header_ops		 = &ipoib_header_ops;
-
 	ipoib_set_ethtool_ops(dev);
 
-	netif_napi_add(dev, &priv->napi, ipoib_poll, NAPI_POLL_WEIGHT);
-
 	dev->watchdog_timeo	 = HZ;
 
 	dev->flags		|= IFF_BROADCAST | IFF_MULTICAST;
@@ -1901,12 +1904,47 @@ void ipoib_setup(struct net_device *dev)
 	INIT_DELAYED_WORK(&priv->neigh_reap_task, ipoib_reap_neigh);
 }
 
-struct ipoib_dev_priv *ipoib_intf_alloc(const char *name)
+void ipoib_setup(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	netif_napi_add(dev, &priv->napi, ipoib_poll, NAPI_POLL_WEIGHT);
+}
+
+static struct net_device *ipoib_create_netdev_default(struct ib_device *hca,
+						      const char *name,
+						      void (*setup)(struct net_device *))
 {
 	struct net_device *dev;
 
 	dev = alloc_netdev((int)sizeof(struct ipoib_dev_priv), name,
-			   NET_NAME_UNKNOWN, ipoib_setup);
+			   NET_NAME_UNKNOWN, setup);
+	if (!dev)
+		return NULL;
+
+	ipoib_setup(dev);
+
+	return dev;
+}
+
+struct ib_ipoib_accel_ops default_ipoib_accel_ops = {
+	.ib_dev_init = ipoib_dev_init_default,
+	.ib_dev_cleanup = ipoib_dev_uninit_default,
+	.ib_dev_open = ipoib_ib_dev_open_default,
+	.ib_dev_stop = ipoib_ib_dev_stop_default,
+	.send = ipoib_send,
+	.create_netdev = ipoib_create_netdev_default,
+	.attach_mcast = ipoib_mcast_attach,
+	.detach_mcast = ipoib_mcast_detach,
+};
+
+struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca,
+					const char *name,
+					struct ib_ipoib_accel_ops *ipoib_accel_ops)
+{
+	struct net_device *dev;
+
+	dev = ipoib_accel_ops->create_netdev(hca, name, ipoib_setup_common);
 	if (!dev)
 		return NULL;
 
@@ -2093,11 +2131,20 @@ static struct net_device *ipoib_add_port(const char *format,
 	struct ipoib_dev_priv *priv;
 	struct ib_port_attr attr;
 	int result = -ENOMEM;
+	struct ib_ipoib_accel_ops *cur_ipoib_accel_ops;
 
-	priv = ipoib_intf_alloc(format);
+	cur_ipoib_accel_ops = ib_get_ipoib_accel_ops(hca);
+	if (!cur_ipoib_accel_ops) {
+		pr_debug("default ipoib_ops for %s\n", hca->name);
+		cur_ipoib_accel_ops = &default_ipoib_accel_ops;
+	}
+
+	priv = ipoib_intf_alloc(hca, format, cur_ipoib_accel_ops);
 	if (!priv)
 		goto alloc_mem_failed;
 
+	priv->ipoib_accel_ops = cur_ipoib_accel_ops;
+
 	SET_NETDEV_DEV(priv->dev, hca->dma_device);
 	priv->dev->dev_id = port - 1;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 69e146cdc306..cf38e7a256de 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -260,8 +260,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			return 0;
 		}
 
-		ret = ipoib_mcast_attach(dev, be16_to_cpu(mcast->mcmember.mlid),
-					 &mcast->mcmember.mgid, set_qkey);
+		ret = priv->ipoib_accel_ops->attach_mcast(dev, &mcast->mcmember.mgid,
+						    be16_to_cpu(mcast->mcmember.mlid),
+						    set_qkey);
 		if (ret < 0) {
 			ipoib_warn(priv, "couldn't attach QP to multicast group %pI6\n",
 				   mcast->mcmember.mgid.raw);
@@ -720,8 +721,9 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 				mcast->mcmember.mgid.raw);
 
 		/* Remove ourselves from the multicast group */
-		ret = ib_detach_mcast(priv->qp, &mcast->mcmember.mgid,
-				      be16_to_cpu(mcast->mcmember.mlid));
+		ret = priv->ipoib_accel_ops->detach_mcast(dev,
+						     &mcast->mcmember.mgid,
+						     be16_to_cpu(mcast->mcmember.mlid));
 		if (ret)
 			ipoib_warn(priv, "ib_detach_mcast failed (result = %d)\n", ret);
 	} else if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
@@ -825,7 +827,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 			}
 		}
 		spin_unlock_irqrestore(&priv->lock, flags);
-		ipoib_send(dev, skb, mcast->ah, IB_MULTICAST_QPN);
+		priv->ipoib_accel_ops->send(dev, skb, mcast->ah,
+				IB_MULTICAST_QPN, priv->tx_wr.remote_qkey);
 		if (neigh)
 			ipoib_neigh_put(neigh);
 		return;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 529b9509a2c4..476d4cf917b5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -35,7 +35,7 @@
 
 #include "ipoib.h"
 
-int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int set_qkey)
+int ipoib_mcast_attach(struct net_device *dev, union ib_gid *mgid, u16 mlid, int set_qkey)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_attr *qp_attr = NULL;
@@ -74,6 +74,16 @@ int ipoib_mcast_attach(struct net_device *dev, u16 mlid, union ib_gid *mgid, int
 	return ret;
 }
 
+int ipoib_mcast_detach(struct net_device *dev, union ib_gid *mgid, u16 mlid)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int ret;
+
+	ret = ib_detach_mcast(priv->qp, mgid, mlid);
+
+	return ret;
+}
+
 int ipoib_init_qp(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -196,6 +206,8 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		goto out_free_send_cq;
 	}
 
+	priv->qp_num = priv->qp->qp_num;
+
 	for (i = 0; i < MAX_SKB_FRAGS + 1; ++i)
 		priv->tx_sge[i].lkey = priv->pd->local_dma_lkey;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index deedb6fc1b05..e303bad8c067 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -134,10 +134,13 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 	snprintf(intf_name, sizeof intf_name, "%s.%04x",
 		 ppriv->dev->name, pkey);
-	priv = ipoib_intf_alloc(intf_name);
+
+	priv = ipoib_intf_alloc(ppriv->ca, intf_name, ppriv->ipoib_accel_ops);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->ipoib_accel_ops = ppriv->ipoib_accel_ops;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
