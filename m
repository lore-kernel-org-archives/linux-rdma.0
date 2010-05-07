From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 52/52] IB/core: allow HCAs to create IB port sysfs files
Date: Thu, 06 May 2010 17:03:25 -0700
Message-ID: <20100507000325.3441.85248.stgit@chromite.mv.qlogic.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506235849.3441.85930.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds a new parameter to ib_register_device() so that
HCAs can create files in /sys/class/infiniband/<hca>/ports/<N>/.
There is no need for an unregister function since the kobject
reference will go to zero when ib_unregister_device() is called.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/core/core_priv.h          |    2 +-
 drivers/infiniband/core/device.c             |    4 ++--
 drivers/infiniband/core/sysfs.c              |   24 +++++++++++++++++++++++-
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 include/rdma/ib_verbs.h                      |    5 ++++-
 11 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 05ac36e..e70c809 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,7 +38,7 @@
 
 #include <rdma/ib_verbs.h>
 
-int  ib_device_register_sysfs(struct ib_device *device);
+int  ib_device_register_sysfs(struct ib_device *device, sysfs_cb cb);
 void ib_device_unregister_sysfs(struct ib_device *device);
 
 int  ib_sysfs_setup(void);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d1fba41..9ef8093 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -267,7 +267,7 @@ out:
  * callback for each device that is added. @device must be allocated
  * with ib_alloc_device().
  */
-int ib_register_device(struct ib_device *device)
+int ib_register_device(struct ib_device *device, sysfs_cb cb)
 {
 	int ret;
 
@@ -296,7 +296,7 @@ int ib_register_device(struct ib_device *device)
 		goto out;
 	}
 
-	ret = ib_device_register_sysfs(device);
+	ret = ib_device_register_sysfs(device, cb);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index f901957..a47bac8 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -754,7 +754,23 @@ static struct attribute_group iw_stats_group = {
 	.attrs	= iw_proto_stats_attrs,
 };
 
-int ib_device_register_sysfs(struct ib_device *device)
+static int sysfs_create_port_files(struct ib_device *device, sysfs_cb cb)
+{
+	struct kobject *p;
+	struct ib_port *port;
+	int ret = 0;
+
+	list_for_each_entry(p, &device->port_list, entry) {
+		port = container_of(p, struct ib_port, kobj);
+		ret = cb(device, port->port_num, &port->kobj);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+int ib_device_register_sysfs(struct ib_device *device, sysfs_cb cb)
 {
 	struct device *class_dev = &device->dev;
 	int ret;
@@ -802,6 +818,12 @@ int ib_device_register_sysfs(struct ib_device *device)
 			goto err_put;
 	}
 
+	if (cb) {
+		ret = sysfs_create_port_files(device, cb);
+		if (ret)
+			goto err_put;
+	}
+
 	return 0;
 
 err_put:
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index ad723bd..d128386 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -864,7 +864,7 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.iwcm->create_listen = c2_service_create;
 	dev->ibdev.iwcm->destroy_listen = c2_service_destroy;
 
-	ret = ib_register_device(&dev->ibdev);
+	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
 		goto out_free_iwcm;
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 47b35c6..26f22ec 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1427,7 +1427,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.iwcm->rem_ref = iwch_qp_rem_ref;
 	dev->ibdev.iwcm->get_qp = iwch_get_qp;
 
-	ret = ib_register_device(&dev->ibdev);
+	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
 		goto bail1;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 129a6be..d1a9278 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -798,7 +798,7 @@ static int __devinit ehca_probe(struct of_device *dev,
 		goto probe5;
 	}
 
-	ret = ib_register_device(&shca->ib_device);
+	ret = ib_register_device(&shca->ib_device, NULL);
 	if (ret) {
 		ehca_err(&shca->ib_device,
 			 "ib_register_device() failed ret=%i", ret);
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 9289ab4..055e7fd 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2181,7 +2181,7 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	snprintf(dev->node_desc, sizeof(dev->node_desc),
 		 IPATH_IDSTR " %s", init_utsname()->nodename);
 
-	ret = ib_register_device(dev);
+	ret = ib_register_device(dev, NULL);
 	if (ret)
 		goto err_reg;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e596537..76dcd81 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -660,7 +660,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	spin_lock_init(&ibdev->sm_lock);
 	mutex_init(&ibdev->cap_mask_mutex);
 
-	if (ib_register_device(&ibdev->ib_dev))
+	if (ib_register_device(&ibdev->ib_dev, NULL))
 		goto err_map;
 
 	if (mlx4_ib_mad_init(ibdev))
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index bcf7a40..e53a773 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1402,7 +1402,7 @@ int mthca_register_device(struct mthca_dev *dev)
 
 	mutex_init(&dev->cap_mask_mutex);
 
-	ret = ib_register_device(&dev->ib_dev);
+	ret = ib_register_device(&dev->ib_dev, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 36348bf..a45c749 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3961,7 +3961,7 @@ int nes_register_ofa_device(struct nes_ib_device *nesibdev)
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	int i, ret;
 
-	ret = ib_register_device(&nesvnic->nesibdev->ibdev);
+	ret = ib_register_device(&nesvnic->nesibdev->ibdev, NULL);
 	if (ret) {
 		return ret;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6ecd85c..c36a0bd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1189,7 +1189,10 @@ struct ib_client {
 struct ib_device *ib_alloc_device(size_t size);
 void ib_dealloc_device(struct ib_device *device);
 
-int ib_register_device   (struct ib_device *device);
+typedef int (*sysfs_cb)(struct ib_device *dev, u8 port_num,
+			struct kobject *kobj);
+
+int ib_register_device(struct ib_device *device, sysfs_cb cb);
 void ib_unregister_device(struct ib_device *device);
 
 int ib_register_client   (struct ib_client *client);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
