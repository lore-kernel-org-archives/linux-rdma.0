From: Denis Drozdov <denisd@mellanox.com>
Subject: [PATCH v2 net 2/2] IB/ipoib: Fix netlink support in IPoIB
Date: Tue,  9 Jan 2018 23:42:47 +0200
Message-ID: <1515534167-13062-3-git-send-email-denisd@mellanox.com>
References: <20180101224347.xdxguvvr4g7jrxq4@inn>
 <1515534167-13062-1-git-send-email-denisd@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1515534167-13062-1-git-send-email-denisd@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: jgg@mellanox.com, dledford@redhat.com, leonro@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, gerlitz.or@gmail.com, Denis Drozdov <denisd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

IPoIB netlink support was broken by commit cd565b4b51e5
("IB/IPoIB: Support acceleration options callbacks"),
that added flow which allocates netdev rdma structures
after netlink object is already created. Such situation leads
to crash in __ipoib_device_add, once trying to reuse netlink
device.
This commit restores the netlink support.

Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
Signed-off-by: Denis Drozdov <denisd@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h         |  2 ++
 drivers/infiniband/ulp/ipoib/ipoib_main.c    | 23 ++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 39 +++++++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 20 ++++----------
 4 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 8033a00..aa7a02f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -607,6 +607,8 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 void ipoib_set_ethtool_ops(struct net_device *dev);
 void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
 
+void ipoib_free_rdma_netdev(struct net_device *dev);
+
 #define IPOIB_FLAGS_RC		0x80
 #define IPOIB_FLAGS_UC		0x40
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 8880351d..6e7548e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2022,6 +2022,14 @@ struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
 	return NULL;
 }
 
+void ipoib_free_rdma_netdev(struct net_device *dev)
+{
+	struct rdma_netdev *rn = netdev_priv(dev);
+
+	rn->free_rdma_netdev(dev);
+	kfree(ipoib_priv(dev));
+}
+
 static ssize_t show_pkey(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
@@ -2203,7 +2211,6 @@ static struct net_device *ipoib_add_port(const char *format,
 {
 	struct ipoib_dev_priv *priv;
 	struct ib_port_attr attr;
-	struct rdma_netdev *rn;
 	int result = -ENOMEM;
 
 	priv = ipoib_intf_alloc(hca, port, format);
@@ -2303,9 +2310,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	ipoib_dev_cleanup(priv->dev);
 
 device_init_failed:
-	rn = netdev_priv(priv->dev);
-	rn->free_rdma_netdev(priv->dev);
-	kfree(priv);
+	ipoib_free_rdma_netdev(priv->dev);
 
 alloc_mem_failed:
 	return ERR_PTR(result);
@@ -2378,13 +2383,9 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 
 		parent_rn->free_rdma_netdev(priv->dev);
 
-		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
-			struct rdma_netdev *child_rn;
-
-			child_rn = netdev_priv(cpriv->dev);
-			child_rn->free_rdma_netdev(cpriv->dev);
-			kfree(cpriv);
-		}
+		list_for_each_entry_safe(cpriv, tcpriv,
+					 &priv->child_intfs, list)
+			ipoib_free_rdma_netdev(cpriv->dev);
 
 		kfree(priv);
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index 3e44087..f5cbb7a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -93,12 +93,38 @@ static int ipoib_changelink(struct net_device *dev, struct nlattr *tb[],
 	return ret;
 }
 
+static struct net_device *ipoib_alloc_link(struct net *src_net,
+					   const char *dev_name,
+					   struct nlattr *tb[])
+{
+	struct net_device *pdev;
+	struct ipoib_dev_priv *ppriv, *priv;
+
+	if (!tb[IFLA_LINK])
+		return ERR_PTR(-EINVAL);
+
+	ASSERT_RTNL();
+	pdev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
+	if (!pdev || pdev->type != ARPHRD_INFINIBAND)
+		return ERR_PTR(-ENODEV);
+
+	ppriv = ipoib_priv(pdev);
+
+	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, dev_name);
+	if (!priv) {
+		ipoib_warn(ppriv, "failed to allocate pkey device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return priv->dev;
+}
+
 static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 				struct nlattr *tb[], struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
 	struct net_device *pdev;
-	struct ipoib_dev_priv *ppriv;
+	struct ipoib_dev_priv *ppriv, *priv;
 	u16 child_pkey;
 	int err;
 
@@ -131,11 +157,15 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	 */
 	child_pkey |= 0x8000;
 
-	err = __ipoib_vlan_add(ppriv, ipoib_priv(dev),
-			       child_pkey, IPOIB_RTNL_CHILD);
+	down_write(&ppriv->vlan_rwsem);
+
+	priv = ipoib_priv(dev);
+	err = __ipoib_vlan_add(ppriv, priv, child_pkey, IPOIB_RTNL_CHILD);
+	up_write(&ppriv->vlan_rwsem);
 
 	if (!err && data)
 		err = ipoib_changelink(dev, tb, data, extack);
+
 	return err;
 }
 
@@ -163,13 +193,14 @@ static size_t ipoib_get_size(const struct net_device *dev)
 	.kind		= "ipoib",
 	.maxtype	= IFLA_IPOIB_MAX,
 	.policy		= ipoib_policy,
-	.priv_size	= sizeof(struct ipoib_dev_priv),
 	.setup		= ipoib_setup_common,
 	.newlink	= ipoib_new_child_link,
 	.changelink	= ipoib_changelink,
 	.dellink	= ipoib_unregister_child_dev,
 	.get_size	= ipoib_get_size,
 	.fill_info	= ipoib_fill_info,
+	.alloc_link     = ipoib_alloc_link,
+	.free_link	= ipoib_free_rdma_netdev
 };
 
 int __init ipoib_netlink_init(void)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 55a9b71..3ebf6de 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -162,29 +162,23 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		result = -ENOTUNIQ;
 		goto out;
 	}
-
 	list_for_each_entry(tpriv, &ppriv->child_intfs, list) {
 		if (tpriv->pkey == pkey &&
-		    tpriv->child_type == IPOIB_LEGACY_CHILD) {
+		    (tpriv->child_type == IPOIB_LEGACY_CHILD ||
+		     tpriv->child_type == IPOIB_RTNL_CHILD)) {
 			result = -ENOTUNIQ;
 			goto out;
 		}
 	}
 
 	result = __ipoib_vlan_add(ppriv, priv, pkey, IPOIB_LEGACY_CHILD);
-
 out:
 	up_write(&ppriv->vlan_rwsem);
 	rtnl_unlock();
 	mutex_unlock(&ppriv->sysfs_mutex);
 
-	if (result && priv) {
-		struct rdma_netdev *rn;
-
-		rn = netdev_priv(priv->dev);
-		rn->free_rdma_netdev(priv->dev);
-		kfree(priv);
-	}
+	if (result && priv)
+		ipoib_free_rdma_netdev(priv->dev);
 
 	return result;
 }
@@ -235,11 +229,7 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	mutex_unlock(&ppriv->sysfs_mutex);
 
 	if (dev) {
-		struct rdma_netdev *rn;
-
-		rn = netdev_priv(dev);
-		rn->free_rdma_netdev(priv->dev);
-		kfree(priv);
+		ipoib_free_rdma_netdev(dev);
 		return 0;
 	}
 
-- 
1.8.3.1
