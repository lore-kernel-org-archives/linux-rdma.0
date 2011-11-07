From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 11/11] mthca: use the new cache in mthca driver
Date: Mon, 7 Nov 2011 14:21:15 +0530
Message-ID: <20111107085111.GA11498@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sample usage of the new caching functions incorporated in the mthca driver.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cache.c              |    7 +++++++
 drivers/infiniband/hw/mthca/mthca_av.c       |    1 -
 drivers/infiniband/hw/mthca/mthca_dev.h      |    1 +
 drivers/infiniband/hw/mthca/mthca_eq.c       |    2 ++
 drivers/infiniband/hw/mthca/mthca_main.c     |    5 +++++
 drivers/infiniband/hw/mthca/mthca_provider.c |   21 ++++++++++++++++++---
 drivers/infiniband/hw/mthca/mthca_qp.c       |    1 -
 include/rdma/ib_cache.h                      |    7 +++++++
 8 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 09b0586..86a2502 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -258,6 +258,13 @@ int ib_cache_gid_drop(struct ib_cache *cache, u8 port_num)
 }
 EXPORT_SYMBOL(ib_cache_gid_drop);
 
+int ib_cache_drop(struct ib_cache *cache, u8 port)
+{
+	ib_cache_gid_drop(cache, port);
+	ib_cache_pkey_drop(cache, port);
+}
+EXPORT_SYMBOL(ib_cache_drop);
+
 int ib_cache_init(struct ib_cache *cache,
 		  struct ib_device *device)
 {
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 6249b5f..a14d7e8 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -35,7 +35,6 @@
 #include <linux/slab.h>
 
 #include <rdma/ib_verbs.h>
-#include <rdma/ib_cache.h>
 
 #include "mthca_dev.h"
 
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7e6a6d6..fd2b7f6 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -289,6 +289,7 @@ extern struct mutex mthca_device_mutex;
 struct mthca_dev {
 	struct ib_device  ib_dev;
 	struct pci_dev   *pdev;
+	struct ib_cache  cache;
 
 	int          	 hca_type;
 	unsigned long	 mthca_flags;
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 7c9d35f..f52ca63 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <rdma/ib_cache.h>
 
 #include "mthca_dev.h"
 #include "mthca_cmd.h"
@@ -254,6 +255,7 @@ static void port_change(struct mthca_dev *dev, int port, int active)
 	record.event  = active ? IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
 	record.element.port_num = port;
 
+	ib_cache_drop(&dev->cache, port);
 	ib_dispatch_event(&record);
 }
 
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index aa12a53..25e77b2 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -38,6 +38,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/gfp.h>
+#include <rdma/ib_cache.h>
 
 #include "mthca_dev.h"
 #include "mthca_config_reg.h"
@@ -1039,6 +1040,10 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 	if (err)
 		goto err_unregister;
 
+	err = ib_cache_init(&mdev->cache, &mdev->ib_dev);
+	if (err)
+		goto err_unregister;
+
 	pci_set_drvdata(pdev, mdev);
 	mdev->hca_type = hca_type;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 5b71d43..2e7705b 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -37,6 +37,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_cache.h>
 
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -230,8 +231,14 @@ static int mthca_query_pkey(struct ib_device *ibdev,
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
-	int err = -ENOMEM;
+	int err;
+	struct mthca_dev *mdev = to_mdev(ibdev);
 
+	err = ib_get_cached_pkey(&mdev->cache, port, index, pkey);
+	if (!err)
+		return 0;
+
+	err = -ENOMEM;
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 	if (!in_mad || !out_mad)
@@ -247,6 +254,7 @@ static int mthca_query_pkey(struct ib_device *ibdev,
 		goto out;
 
 	*pkey = be16_to_cpu(((__be16 *) out_mad->data)[index % 32]);
+	ib_update_cached_pkey(&mdev->cache, port, index, *pkey);
 
  out:
 	kfree(in_mad);
@@ -259,8 +267,14 @@ static int mthca_query_gid(struct ib_device *ibdev, u8 port,
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
-	int err = -ENOMEM;
+	int err;
+	struct mthca_dev *mdev = to_mdev(ibdev);
+
+	err = ib_get_cached_gid(&mdev->cache, port, index, gid);
+	if (!err)
+		return 0;
 
+	err = -ENOMEM;
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 	if (!in_mad || !out_mad)
@@ -270,7 +284,7 @@ static int mthca_query_gid(struct ib_device *ibdev, u8 port,
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
 	in_mad->attr_mod = cpu_to_be32(port);
 
-	err = mthca_MAD_IFC(to_mdev(ibdev), 1, 1,
+	err = mthca_MAD_IFC(mdev, 1, 1,
 			    port, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
@@ -287,6 +301,7 @@ static int mthca_query_gid(struct ib_device *ibdev, u8 port,
 		goto out;
 
 	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
+	ib_update_cached_gid(&mdev->cache, port, index, *gid);
 
  out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index b40429f..0ba5c20 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -40,7 +40,6 @@
 #include <asm/io.h>
 
 #include <rdma/ib_verbs.h>
-#include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
 
 #include "mthca_dev.h"
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index a290070..a63280b 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -119,4 +119,11 @@ int ib_cache_pkey_drop(struct ib_cache *cache, u8 port_num);
  * @port_num: port number entry in the cache
  */
 int ib_cache_gid_drop(struct ib_cache *cache, u8 port_num);
+
+/**
+ * ib_cache_drop - drop both gid and pkey cache entry associated with port
+ * @cache: The cache to free
+ * @port_num: port number entry in the cache
+ */
+int ib_cache_drop(struct ib_cache *cache, u8 port_num);
 #endif /* _IB_CACHE_H */
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
