From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 8/8] infiniband: ipoib: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:18:00 +0100
Message-ID: <20190122151800.15092-9-gregkh@linuxfoundation.org>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Leon Romanovsky <leon@kernel.org>, Kamal Heib <kamalheib1@gmail.com>, Denis Drozdov <denisd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Alaa Hleihel <alaa@mellanox.com>, Parav Pandit <parav@mellanox.com>, Kees Cook <keescook@chromium.org>, Arseny Maslennikov <ar@cs.msu.ru>, Evgenii Smirnov <evgenii.smirnov@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Kamal Heib <kamalheib1@gmail.com>
Cc: Denis Drozdov <denisd@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Erez Shitrit <erezsh@mellanox.com>
Cc: Yuval Shaia <yuval.shaia@oracle.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Alaa Hleihel <alaa@mellanox.com>
Cc: Parav Pandit <parav@mellanox.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arseny Maslennikov <ar@cs.msu.ru>
Cc: Evgenii Smirnov <evgenii.smirnov@profitbricks.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_fs.c   | 7 +------
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 1da119d901a9..5941d660add1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -781,12 +781,12 @@ static inline void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *w
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
 void ipoib_create_debug_files(struct net_device *dev);
 void ipoib_delete_debug_files(struct net_device *dev);
-int ipoib_register_debugfs(void);
+void ipoib_register_debugfs(void);
 void ipoib_unregister_debugfs(void);
 #else
 static inline void ipoib_create_debug_files(struct net_device *dev) { }
 static inline void ipoib_delete_debug_files(struct net_device *dev) { }
-static inline int ipoib_register_debugfs(void) { return 0; }
+static inline void ipoib_register_debugfs(void) { }
 static inline void ipoib_unregister_debugfs(void) { }
 #endif
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 178488028734..64c19f6fa931 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -267,14 +267,10 @@ void ipoib_create_debug_files(struct net_device *dev)
 	snprintf(name, sizeof(name), "%s_mcg", dev->name);
 	priv->mcg_dentry = debugfs_create_file(name, S_IFREG | S_IRUGO,
 					       ipoib_root, dev, &ipoib_mcg_fops);
-	if (!priv->mcg_dentry)
-		ipoib_warn(priv, "failed to create mcg debug file\n");
 
 	snprintf(name, sizeof(name), "%s_path", dev->name);
 	priv->path_dentry = debugfs_create_file(name, S_IFREG | S_IRUGO,
 						ipoib_root, dev, &ipoib_path_fops);
-	if (!priv->path_dentry)
-		ipoib_warn(priv, "failed to create path debug file\n");
 }
 
 void ipoib_delete_debug_files(struct net_device *dev)
@@ -286,10 +282,9 @@ void ipoib_delete_debug_files(struct net_device *dev)
 	priv->mcg_dentry = priv->path_dentry = NULL;
 }
 
-int ipoib_register_debugfs(void)
+void ipoib_register_debugfs(void)
 {
 	ipoib_root = debugfs_create_dir("ipoib", NULL);
-	return ipoib_root ? 0 : -ENOMEM;
 }
 
 void ipoib_unregister_debugfs(void)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index d932f99201d1..45ef3b0f03c5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2577,9 +2577,7 @@ static int __init ipoib_init_module(void)
 	 */
 	BUILD_BUG_ON(IPOIB_CM_COPYBREAK > IPOIB_CM_HEAD_SIZE);
 
-	ret = ipoib_register_debugfs();
-	if (ret)
-		return ret;
+	ipoib_register_debugfs();
 
 	/*
 	 * We create a global workqueue here that is used for all flush
-- 
2.20.1
