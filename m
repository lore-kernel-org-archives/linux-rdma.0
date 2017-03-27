From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/IPoIB: ibX: failed to create mcg debug file
Date: Mon, 27 Mar 2017 03:02:21 -0400
Message-ID: <1490598141-12408-1-git-send-email-shamir.rabinovitch@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When udev renames the netdev devices, ipoib debugfs entries does not
get renamed. As a reason, if subsequent probe of ipoib device reuse the
name then creating a debugfs entry for the new device would fail.

Also, moved ipoib_create_debug_files and ipoib_delete_debug_files as part
of ipoib event handling in order to avoid any race condition between these.

Full credit for this fix to Vijay Kumar.

Signed-off-by: Vijay Kumar <vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

v1->v2:
- Review comment from Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
  Verified again and NETDEV_UNREGISTER is claled correctly and debug
  files are removed. Thanks.
- Fix compile warning when CONFIG_INFINIBAND_IPOIB_DEBUG is not set

---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_fs.c   |   28 +++++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   41 ++++++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index da12717..95a457f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -770,6 +770,7 @@ static inline void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *w
 void ipoib_delete_debug_files(struct net_device *dev);
 int ipoib_register_debugfs(void);
 void ipoib_unregister_debugfs(void);
+void ipoib_debugfs_rename(struct net_device *dev);
 #else
 static inline void ipoib_create_debug_files(struct net_device *dev) { }
 static inline void ipoib_delete_debug_files(struct net_device *dev) { }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 6bd5740..d849b1d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -259,6 +259,34 @@ static int ipoib_path_open(struct inode *inode, struct file *file)
 	.release = seq_release
 };
 
+void ipoib_debugfs_rename(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	char name[IFNAMSIZ + sizeof "_path"];
+
+	if (!ipoib_root)
+		return;
+
+	if (priv->mcg_dentry) {
+		snprintf(name, sizeof(name), "%s_mcg", dev->name);
+		priv->mcg_dentry = debugfs_rename(ipoib_root, priv->mcg_dentry,
+						  ipoib_root, name);
+		if (!priv->mcg_dentry)
+			ipoib_warn(priv, "failed to rename debug file %s to %s\n",
+				   priv->mcg_dentry->d_iname, name);
+	}
+
+	if (priv->path_dentry) {
+		snprintf(name, sizeof(name), "%s_path", dev->name);
+		priv->path_dentry = debugfs_rename(ipoib_root,
+						   priv->path_dentry,
+						   ipoib_root, name);
+		if (!priv->path_dentry)
+			ipoib_warn(priv, "failed to rename debug file %s to %s\n",
+				   priv->mcg_dentry->d_iname, name);
+	}
+}
+
 void ipoib_create_debug_files(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b58d9dc..c84b8ee 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -108,6 +108,32 @@ struct ipoib_path_iter {
 	.get_net_dev_by_params = ipoib_get_net_dev_by_params,
 };
 
+#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
+static int ipoib_netdev_event(struct notifier_block *this,
+			      unsigned long event, void *ptr)
+{
+	struct netdev_notifier_info *ni = ptr;
+	struct net_device *dev = ni->dev;
+
+	if (dev->netdev_ops->ndo_open != ipoib_open)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		ipoib_create_debug_files(dev);
+		break;
+	case NETDEV_CHANGENAME:
+		ipoib_debugfs_rename(dev);
+		break;
+	case NETDEV_UNREGISTER:
+		ipoib_delete_debug_files(dev);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+#endif
+
 int ipoib_open(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -2072,8 +2098,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 		goto register_failed;
 	}
 
-	ipoib_create_debug_files(priv->dev);
-
 	if (ipoib_cm_add_mode_attr(priv->dev))
 		goto sysfs_failed;
 	if (ipoib_add_pkey_attr(priv->dev))
@@ -2088,7 +2112,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 	return priv->dev;
 
 sysfs_failed:
-	ipoib_delete_debug_files(priv->dev);
 	unregister_netdev(priv->dev);
 
 register_failed:
@@ -2173,6 +2196,12 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 	kfree(dev_list);
 }
 
+#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
+static struct notifier_block ipoib_netdev_notifier = {
+	.notifier_call = ipoib_netdev_event,
+};
+#endif
+
 static int __init ipoib_init_module(void)
 {
 	int ret;
@@ -2225,6 +2254,9 @@ static int __init ipoib_init_module(void)
 	if (ret)
 		goto err_client;
 
+#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
+	register_netdevice_notifier(&ipoib_netdev_notifier);
+#endif
 	return 0;
 
 err_client:
@@ -2242,6 +2274,9 @@ static int __init ipoib_init_module(void)
 
 static void __exit ipoib_cleanup_module(void)
 {
+#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
+	unregister_netdevice_notifier(&ipoib_netdev_notifier);
+#endif
 	ipoib_netlink_fini();
 	ib_unregister_client(&ipoib_client);
 	ib_sa_unregister_client(&ipoib_sa_client);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
