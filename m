From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/7] RDMA/netdev: Fix netlink support in IPoIB
Date: Wed, 10 Oct 2018 18:24:39 -0700
Message-ID: <20181011012444.28194-3-saeedm@mellanox.com>
References: <20181011012444.28194-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181011012444.28194-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Denis Drozdov <denisd@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Denis Drozdov <denisd@mellanox.com>

IPoIB netlink support was broken by the below commit since integrating
the rdma_netdev support relies on an allocation flow for netdevs that
was controlled by the ipoib driver while netdev's rtnl_newlink
implementation assumes that the netdev will be allocated by netlink.
Such situation leads to crash in __ipoib_device_add, once trying to
reuse netlink device.

This patch fixes the kernel oops for both mlx4 and mlx5
devices triggered by the following command:

Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
Signed-off-by: Denis Drozdov <denisd@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/core/verbs.c              |  28 +++--
 drivers/infiniband/ulp/ipoib/ipoib.h         |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    | 123 +++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |  23 +++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    |  19 +--
 include/rdma/ib_verbs.h                      |   7 ++
 6 files changed, 136 insertions(+), 72 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2f34d3412097..8ec7418e99f0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2643,13 +2643,27 @@ struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
 	if (!netdev)
 		return ERR_PTR(-ENOMEM);
 
-	rc = params.initialize_rdma_netdev(device, port_num, netdev,
-					   params.param);
-	if (rc) {
-		free_netdev(netdev);
-		return ERR_PTR(rc);
-	}
-
 	return netdev;
 }
 EXPORT_SYMBOL(rdma_alloc_netdev);
+
+int rdma_init_netdev(struct ib_device *device, u8 port_num,
+		     enum rdma_netdev_t type, const char *name,
+		     unsigned char name_assign_type,
+		     void (*setup)(struct net_device *),
+		     struct net_device *netdev)
+{
+	struct rdma_netdev_alloc_params params;
+	int rc;
+
+	if (!device->rdma_netdev_get_params)
+		return -EOPNOTSUPP;
+
+	rc = device->rdma_netdev_get_params(device, port_num, type, &params);
+	if (rc)
+		return rc;
+
+	return params.initialize_rdma_netdev(device, port_num,
+					     netdev, params.param);
+}
+EXPORT_SYMBOL(rdma_init_netdev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 1abe3c62f106..1da119d901a9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -499,8 +499,10 @@ void ipoib_reap_ah(struct work_struct *work);
 struct ipoib_path *__path_find(struct net_device *dev, void *gid);
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
-struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
-					const char *format);
+struct net_device *ipoib_intf_alloc(struct ib_device *hca, u8 port,
+				    const char *format);
+int ipoib_intf_init(struct ib_device *hca, u8 port, const char *format,
+		    struct net_device *dev);
 void ipoib_ib_tx_timer_func(struct timer_list *t);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
 void ipoib_ib_dev_flush_normal(struct work_struct *work);
@@ -531,6 +533,8 @@ int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req);
 void ipoib_dma_unmap_tx(struct ipoib_dev_priv *priv,
 			struct ipoib_tx_buf *tx_req);
 
+struct rtnl_link_ops *ipoib_get_link_ops(void);
+
 static inline void ipoib_build_sge(struct ipoib_dev_priv *priv,
 				   struct ipoib_tx_buf *tx_req)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9c816cd41724..8baa75a705c5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2115,77 +2115,58 @@ static const struct net_device_ops ipoib_netdev_default_pf = {
 	.ndo_stop		 = ipoib_ib_dev_stop_default,
 };
 
-static struct net_device
-*ipoib_create_netdev_default(struct ib_device *hca,
-			     const char *name,
-			     unsigned char name_assign_type,
-			     void (*setup)(struct net_device *))
-{
-	struct net_device *dev;
-	struct rdma_netdev *rn;
-
-	dev = alloc_netdev((int)sizeof(struct rdma_netdev),
-			   name,
-			   name_assign_type, setup);
-	if (!dev)
-		return NULL;
-
-	rn = netdev_priv(dev);
-
-	rn->send = ipoib_send;
-	rn->attach_mcast = ipoib_mcast_attach;
-	rn->detach_mcast = ipoib_mcast_detach;
-	rn->hca = hca;
-	dev->netdev_ops = &ipoib_netdev_default_pf;
-
-	return dev;
-}
-
-static struct net_device *ipoib_get_netdev(struct ib_device *hca, u8 port,
-					   const char *name)
+static struct net_device *ipoib_alloc_netdev(struct ib_device *hca, u8 port,
+					     const char *name)
 {
 	struct net_device *dev;
 
 	dev = rdma_alloc_netdev(hca, port, RDMA_NETDEV_IPOIB, name,
 				NET_NAME_UNKNOWN, ipoib_setup_common);
-	if (!IS_ERR(dev))
+	if (!IS_ERR(dev) || PTR_ERR(dev) != -EOPNOTSUPP)
 		return dev;
-	if (PTR_ERR(dev) != -EOPNOTSUPP)
-		return NULL;
 
-	return ipoib_create_netdev_default(hca, name, NET_NAME_UNKNOWN,
-					   ipoib_setup_common);
+	dev = alloc_netdev(sizeof(struct rdma_netdev), name, NET_NAME_UNKNOWN,
+			   ipoib_setup_common);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+	return dev;
 }
 
-struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
-					const char *name)
+int ipoib_intf_init(struct ib_device *hca, u8 port, const char *name,
+		    struct net_device *dev)
 {
-	struct net_device *dev;
+	struct rdma_netdev *rn = netdev_priv(dev);
 	struct ipoib_dev_priv *priv;
-	struct rdma_netdev *rn;
+	int rc;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-		return NULL;
+		return -ENOMEM;
 
 	priv->ca = hca;
 	priv->port = port;
 
-	dev = ipoib_get_netdev(hca, port, name);
-	if (!dev)
-		goto free_priv;
+	rc = rdma_init_netdev(hca, port, RDMA_NETDEV_IPOIB, name,
+			      NET_NAME_UNKNOWN, ipoib_setup_common, dev);
+	if (rc) {
+		if (rc != -EOPNOTSUPP)
+			goto out;
+
+		dev->netdev_ops = &ipoib_netdev_default_pf;
+		rn->send = ipoib_send;
+		rn->attach_mcast = ipoib_mcast_attach;
+		rn->detach_mcast = ipoib_mcast_detach;
+		rn->hca = hca;
+	}
 
 	priv->rn_ops = dev->netdev_ops;
 
-	/* fixme : should be after the query_cap */
-	if (priv->hca_caps & IB_DEVICE_VIRTUAL_FUNCTION)
+	if (hca->attrs.device_cap_flags & IB_DEVICE_VIRTUAL_FUNCTION)
 		dev->netdev_ops	= &ipoib_netdev_ops_vf;
 	else
 		dev->netdev_ops	= &ipoib_netdev_ops_pf;
 
-	rn = netdev_priv(dev);
 	rn->clnt_priv = priv;
-
 	/*
 	 * Only the child register_netdev flows can handle priv_destructor
 	 * being set, so we force it to NULL here and handle manually until it
@@ -2196,10 +2177,35 @@ struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
 
 	ipoib_build_priv(dev);
 
-	return priv;
-free_priv:
+	return 0;
+
+out:
 	kfree(priv);
-	return NULL;
+	return rc;
+}
+
+struct net_device *ipoib_intf_alloc(struct ib_device *hca, u8 port,
+				    const char *name)
+{
+	struct net_device *dev;
+	int rc;
+
+	dev = ipoib_alloc_netdev(hca, port, name);
+	if (IS_ERR(dev))
+		return dev;
+
+	rc = ipoib_intf_init(hca, port, name, dev);
+	if (rc) {
+		free_netdev(dev);
+		return ERR_PTR(rc);
+	}
+
+	/*
+	 * Upon success the caller must ensure ipoib_intf_free is called or
+	 * register_netdevice succeed'd and priv_destructor is set to
+	 * ipoib_intf_free.
+	 */
+	return dev;
 }
 
 void ipoib_intf_free(struct net_device *dev)
@@ -2382,16 +2388,19 @@ int ipoib_add_pkey_attr(struct net_device *dev)
 static struct net_device *ipoib_add_port(const char *format,
 					 struct ib_device *hca, u8 port)
 {
+	struct rtnl_link_ops *ops = ipoib_get_link_ops();
+	struct rdma_netdev_alloc_params params;
 	struct ipoib_dev_priv *priv;
 	struct net_device *ndev;
 	int result;
 
-	priv = ipoib_intf_alloc(hca, port, format);
-	if (!priv) {
-		pr_warn("%s, %d: ipoib_intf_alloc failed\n", hca->name, port);
-		return ERR_PTR(-ENOMEM);
+	ndev = ipoib_intf_alloc(hca, port, format);
+	if (IS_ERR(ndev)) {
+		pr_warn("%s, %d: ipoib_intf_alloc failed %ld\n", hca->name, port,
+			PTR_ERR(ndev));
+		return ndev;
 	}
-	ndev = priv->dev;
+	priv = ipoib_priv(ndev);
 
 	INIT_IB_EVENT_HANDLER(&priv->event_handler,
 			      priv->ca, ipoib_event);
@@ -2412,6 +2421,14 @@ static struct net_device *ipoib_add_port(const char *format,
 		return ERR_PTR(result);
 	}
 
+	if (hca->rdma_netdev_get_params) {
+		int rc = hca->rdma_netdev_get_params(hca, port,
+						     RDMA_NETDEV_IPOIB,
+						     &params);
+
+		if (!rc && ops->priv_size < params.sizeof_priv)
+			ops->priv_size = params.sizeof_priv;
+	}
 	/*
 	 * We cannot set priv_destructor before register_netdev because we
 	 * need priv to be always valid during the error flow to execute
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index d4d553a51fa9..38c984d16996 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -122,12 +122,26 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	} else
 		child_pkey  = nla_get_u16(data[IFLA_IPOIB_PKEY]);
 
+	err = ipoib_intf_init(ppriv->ca, ppriv->port, dev->name, dev);
+	if (err) {
+		ipoib_warn(ppriv, "failed to initialize pkey device\n");
+		return err;
+	}
+
 	err = __ipoib_vlan_add(ppriv, ipoib_priv(dev),
 			       child_pkey, IPOIB_RTNL_CHILD);
+	if (err)
+		return err;
 
-	if (!err && data)
+	if (data) {
 		err = ipoib_changelink(dev, tb, data, extack);
-	return err;
+		if (err) {
+			unregister_netdevice(dev);
+			return err;
+		}
+	}
+
+	return 0;
 }
 
 static size_t ipoib_get_size(const struct net_device *dev)
@@ -149,6 +163,11 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.fill_info	= ipoib_fill_info,
 };
 
+struct rtnl_link_ops *ipoib_get_link_ops(void)
+{
+	return &ipoib_link_ops;
+}
+
 int __init ipoib_netlink_init(void)
 {
 	return rtnl_link_register(&ipoib_link_ops);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 341753fbda54..8ac8e18fbe0c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -85,7 +85,7 @@ static bool is_child_unique(struct ipoib_dev_priv *ppriv,
 
 /*
  * NOTE: If this function fails then the priv->dev will remain valid, however
- * priv can have been freed and must not be touched by caller in the error
+ * priv will have been freed and must not be touched by caller in the error
  * case.
  *
  * If (ndev->reg_state == NETREG_UNINITIALIZED) then it is up to the caller to
@@ -100,6 +100,12 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 
 	ASSERT_RTNL();
 
+	/*
+	 * We do not need to touch priv if register_netdevice fails, so just
+	 * always use this flow.
+	 */
+	ndev->priv_destructor = ipoib_intf_free;
+
 	/*
 	 * Racing with unregister of the parent must be prevented by the
 	 * caller.
@@ -120,9 +126,6 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 		goto out_early;
 	}
 
-	/* We do not need to touch priv if register_netdevice fails */
-	ndev->priv_destructor = ipoib_intf_free;
-
 	result = register_netdevice(ndev);
 	if (result) {
 		ipoib_warn(priv, "failed to initialize; error %i", result);
@@ -182,12 +185,12 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	snprintf(intf_name, sizeof(intf_name), "%s.%04x",
 		 ppriv->dev->name, pkey);
 
-	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
-	if (!priv) {
-		result = -ENOMEM;
+	ndev = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
+	if (IS_ERR(ndev)) {
+		result = PTR_ERR(ndev);
 		goto out;
 	}
-	ndev = priv->dev;
+	priv = ipoib_priv(ndev);
 
 	result = __ipoib_vlan_add(ppriv, priv, pkey, IPOIB_LEGACY_CHILD);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 020216cee8f1..0ed5d913a492 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4198,4 +4198,11 @@ struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
 				     enum rdma_netdev_t type, const char *name,
 				     unsigned char name_assign_type,
 				     void (*setup)(struct net_device *));
+
+int rdma_init_netdev(struct ib_device *device, u8 port_num,
+		     enum rdma_netdev_t type, const char *name,
+		     unsigned char name_assign_type,
+		     void (*setup)(struct net_device *),
+		     struct net_device *netdev);
+
 #endif /* IB_VERBS_H */
-- 
2.17.1
