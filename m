From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 10/10] IB/ipoib: Consolidate checking of the proposed child interface
Date: Sun, 29 Jul 2018 11:35:00 +0300
Message-ID: <20180729083500.5352-11-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Move all the checking for pkey and other validity to the __ipoib_vlan_add
function. This removes the last difference from the control flow
of the __ipoib_vlan_add to make the overall design simpler to
understand.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |  3 --
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 77 +++++++++++++++++++---------
 2 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index 7e093b7aad8f..d4d553a51fa9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -122,9 +122,6 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	} else
 		child_pkey  = nla_get_u16(data[IFLA_IPOIB_PKEY]);
 
-	if (child_pkey == 0 || child_pkey == 0x8000)
-		return -EINVAL;
-
 	err = __ipoib_vlan_add(ppriv, ipoib_priv(dev),
 			       child_pkey, IPOIB_RTNL_CHILD);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index ca3a7f6c0998..341753fbda54 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -50,6 +50,39 @@ static ssize_t show_parent(struct device *d, struct device_attribute *attr,
 }
 static DEVICE_ATTR(parent, S_IRUGO, show_parent, NULL);
 
+static bool is_child_unique(struct ipoib_dev_priv *ppriv,
+			    struct ipoib_dev_priv *priv)
+{
+	struct ipoib_dev_priv *tpriv;
+
+	ASSERT_RTNL();
+
+	/*
+	 * Since the legacy sysfs interface uses pkey for deletion it cannot
+	 * support more than one interface with the same pkey, it creates
+	 * ambiguity.  The RTNL interface deletes using the netdev so it does
+	 * not have a problem to support duplicated pkeys.
+	 */
+	if (priv->child_type != IPOIB_LEGACY_CHILD)
+		return true;
+
+	/*
+	 * First ensure this isn't a duplicate. We check the parent device and
+	 * then all of the legacy child interfaces to make sure the Pkey
+	 * doesn't match.
+	 */
+	if (ppriv->pkey == priv->pkey)
+		return false;
+
+	list_for_each_entry(tpriv, &ppriv->child_intfs, list) {
+		if (tpriv->pkey == priv->pkey &&
+		    tpriv->child_type == IPOIB_LEGACY_CHILD)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * NOTE: If this function fails then the priv->dev will remain valid, however
  * priv can have been freed and must not be touched by caller in the error
@@ -73,10 +106,20 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 	 */
 	WARN_ON(ppriv->dev->reg_state != NETREG_REGISTERED);
 
+	if (pkey == 0 || pkey == 0x8000) {
+		result = -EINVAL;
+		goto out_early;
+	}
+
 	priv->parent = ppriv->dev;
 	priv->pkey = pkey;
 	priv->child_type = type;
 
+	if (!is_child_unique(ppriv, priv)) {
+		result = -ENOTUNIQ;
+		goto out_early;
+	}
+
 	/* We do not need to touch priv if register_netdevice fails */
 	ndev->priv_destructor = ipoib_intf_free;
 
@@ -88,9 +131,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 		 * register_netdevice sometimes calls priv_destructor,
 		 * sometimes not. Make sure it was done.
 		 */
-		if (ndev->priv_destructor)
-			ndev->priv_destructor(ndev);
-		return result;
+		goto out_early;
 	}
 
 	/* RTNL childs don't need proprietary sysfs entries */
@@ -111,6 +152,11 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 sysfs_failed:
 	unregister_netdevice(priv->dev);
 	return -ENOMEM;
+
+out_early:
+	if (ndev->priv_destructor)
+		ndev->priv_destructor(ndev);
+	return result;
 }
 
 int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
@@ -118,17 +164,11 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	struct ipoib_dev_priv *ppriv, *priv;
 	char intf_name[IFNAMSIZ];
 	struct net_device *ndev;
-	struct ipoib_dev_priv *tpriv;
 	int result;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	ppriv = ipoib_priv(pdev);
-
-	snprintf(intf_name, sizeof(intf_name), "%s.%04x",
-		 ppriv->dev->name, pkey);
-
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -137,23 +177,10 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		return -EPERM;
 	}
 
-	/*
-	 * First ensure this isn't a duplicate. We check the parent device and
-	 * then all of the legacy child interfaces to make sure the Pkey
-	 * doesn't match.
-	 */
-	if (ppriv->pkey == pkey) {
-		result = -ENOTUNIQ;
-		goto out;
-	}
+	ppriv = ipoib_priv(pdev);
 
-	list_for_each_entry(tpriv, &ppriv->child_intfs, list) {
-		if (tpriv->pkey == pkey &&
-		    tpriv->child_type == IPOIB_LEGACY_CHILD) {
-			result = -ENOTUNIQ;
-			goto out;
-		}
-	}
+	snprintf(intf_name, sizeof(intf_name), "%s.%04x",
+		 ppriv->dev->name, pkey);
 
 	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
 	if (!priv) {
-- 
2.14.4
