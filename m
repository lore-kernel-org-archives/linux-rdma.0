From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 14/33] IB/cma: Add configfs for rdma_cm
Date: Thu, 26 Mar 2015 02:50:03 +0530
Message-ID: <4bc944ef-4976-408a-8006-e43a449706a7@CMEXHTCAS2.ad.emulex.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427318422-12004-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Users would like to control the behaviour of rdma_cm.
For example, old applications which doesn't set the
required RoCE gid type could be executed on RoCE V2
network types. In order to support this configuration,
we implement a configfs for rdma_cm.

In order to use the configfs, one needs to mount it and
mkdir <IB device name> inside rdma_cm directory.

The patch adds support for a single configuration file,
default_roce_mode. The mode can either be IB & RoCEv1 or
RoCEv2.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig               |   5 +
 drivers/infiniband/core/Makefile         |   2 +
 drivers/infiniband/core/cma.c            |  54 +++++++-
 drivers/infiniband/core/cma_configfs.c   | 222 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h      |  15 +++
 drivers/infiniband/core/roce_gid_cache.c |  13 ++
 6 files changed, 307 insertions(+), 4 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_configfs.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b899531..20bda60 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -54,6 +54,11 @@ config INFINIBAND_ADDR_TRANS
 	depends on INFINIBAND
 	default y
 
+config CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS
+	bool
+	depends on INFINIBAND_ADDR_TRANS && CONFIGFS_FS
+	default y
+
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/ipath/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 2c94963..f6bc8c5 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -24,6 +24,8 @@ iw_cm-y :=			iwcm.o iwpm_util.o iwpm_msg.o
 
 rdma_cm-y :=			cma.o
 
+rdma_cm-$(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS) += cma_configfs.o
+
 rdma_ucm-y :=			ucma.o
 
 ib_addr-y :=			addr.o
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9afa410..8dec040 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -55,6 +55,7 @@
 #include <rdma/ib_cm.h>
 #include <rdma/ib_sa.h>
 #include <rdma/iw_cm.h>
+#include "core_priv.h"
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
@@ -91,6 +92,7 @@ struct cma_device {
 	struct completion	comp;
 	atomic_t		refcount;
 	struct list_head	id_list;
+	enum ib_gid_type	default_gid_type;
 };
 
 struct rdma_bind_list {
@@ -103,6 +105,42 @@ enum {
 	CMA_OPTION_AFONLY,
 };
 
+void cma_ref_dev(struct cma_device *cma_dev)
+{
+	atomic_inc(&cma_dev->refcount);
+}
+
+struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter	filter,
+					     void		*cookie)
+{
+	struct cma_device *cma_dev;
+	struct cma_device *found_cma_dev = NULL;
+
+	mutex_lock(&lock);
+
+	list_for_each_entry(cma_dev, &dev_list, list)
+		if (filter(cma_dev->device, cookie)) {
+			found_cma_dev = cma_dev;
+			break;
+		}
+
+	if (found_cma_dev)
+		cma_ref_dev(found_cma_dev);
+	mutex_unlock(&lock);
+	return found_cma_dev;
+}
+
+enum ib_gid_type cma_get_default_gid_type(struct cma_device *cma_dev)
+{
+	return cma_dev->default_gid_type;
+}
+
+void cma_set_default_gid_type(struct cma_device *cma_dev,
+			      enum ib_gid_type default_gid_type)
+{
+	cma_dev->default_gid_type = default_gid_type;
+}
+
 /*
  * Device removal can occur at anytime, so we need extra handling to
  * serialize notifying the user of device removal with other callbacks.
@@ -248,15 +286,16 @@ static inline void cma_set_ip_ver(struct cma_hdr *hdr, u8 ip_ver)
 static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 			      struct cma_device *cma_dev)
 {
-	atomic_inc(&cma_dev->refcount);
+	cma_ref_dev(cma_dev);
 	id_priv->cma_dev = cma_dev;
+	id_priv->gid_type = cma_dev->default_gid_type;
 	id_priv->id.device = cma_dev->device;
 	id_priv->id.route.addr.dev_addr.transport =
 		rdma_node_get_transport(cma_dev->device->node_type);
 	list_add_tail(&id_priv->list, &cma_dev->id_list);
 }
 
-static inline void cma_deref_dev(struct cma_device *cma_dev)
+void cma_deref_dev(struct cma_device *cma_dev)
 {
 	if (atomic_dec_and_test(&cma_dev->refcount))
 		complete(&cma_dev->comp);
@@ -385,7 +424,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 
 			ret = ib_find_cached_gid_by_port(cma_dev->device,
 							 &iboe_gid,
-							 IB_GID_TYPE_IB,
+							 cma_dev->default_gid_type,
 							 port,
 							 &init_net,
 							 if_index,
@@ -418,7 +457,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 
 					ret = ib_find_cached_gid_by_port(cma_dev->device,
 									 &iboe_gid,
-									 IB_GID_TYPE_IB,
+									 cma_dev->default_gid_type,
 									 port,
 									 &init_net,
 									 if_index,
@@ -3521,6 +3560,7 @@ static void cma_add_one(struct ib_device *device)
 		return;
 
 	cma_dev->device = device;
+	cma_dev->default_gid_type = IB_GID_TYPE_IB;
 
 	init_completion(&cma_dev->comp);
 	atomic_set(&cma_dev->refcount, 1);
@@ -3701,6 +3741,9 @@ static int __init cma_init(void)
 
 	if (ibnl_add_client(RDMA_NL_RDMA_CM, RDMA_NL_RDMA_CM_NUM_OPS, cma_cb_table))
 		printk(KERN_WARNING "RDMA CMA: failed to add netlink callback\n");
+#if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
+	cma_configfs_init();
+#endif
 
 	return 0;
 
@@ -3714,6 +3757,9 @@ err:
 
 static void __exit cma_cleanup(void)
 {
+#if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
+	cma_configfs_exit();
+#endif
 	ibnl_remove_client(RDMA_NL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
new file mode 100644
index 0000000..9a87210
--- /dev/null
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -0,0 +1,222 @@
+/*
+ * Copyright (c) 2015, Mellanox Technologies inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/configfs.h>
+#include <rdma/ib_verbs.h>
+#include "core_priv.h"
+
+struct cma_device;
+
+struct cma_dev_group {
+	struct config_item	item;
+};
+
+struct cma_configfs_attr {
+	struct configfs_attribute	attr;
+	ssize_t				(*show)(struct cma_device *cma_dev,
+						struct cma_dev_group *group,
+						char *buf);
+	ssize_t				(*store)(struct cma_device *cma_dev,
+						 struct cma_dev_group *group,
+						 const char *buf, size_t count);
+};
+
+static struct cma_dev_group *to_dev_group(struct config_item *item)
+{
+	return item ?
+		container_of(item, struct cma_dev_group, item) :
+		NULL;
+}
+
+static ssize_t show_default_roce_mode(struct cma_device *cma_dev,
+				      struct cma_dev_group *group,
+				      char *buf)
+{
+	return sprintf(buf, "%s",
+		       roce_gid_cache_type_str(cma_get_default_gid_type(cma_dev)));
+}
+
+static ssize_t store_default_roce_mode(struct cma_device *cma_dev,
+				       struct cma_dev_group *group,
+				       const char *buf, size_t count)
+{
+	int gid_type = roce_gid_cache_parse_gid_str(buf);
+
+	if (gid_type < 0)
+		return -EINVAL;
+
+	cma_set_default_gid_type(cma_dev, gid_type);
+
+	return strnlen(buf, count);
+}
+
+#define CMA_PARAM_ATTR_RW(_name)				\
+static struct cma_configfs_attr cma_configfs_attr_##_name =	\
+	__CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR, show_##_name, store_##_name)
+
+CMA_PARAM_ATTR_RW(default_roce_mode);
+
+static bool filter_by_name(struct ib_device *ib_dev, void *cookie)
+{
+	return !strcmp(ib_dev->name, cookie);
+}
+
+static ssize_t cma_configfs_attr_show(struct config_item *item,
+				      struct configfs_attribute *attr,
+				      char *buf)
+{
+	ssize_t ret = -EINVAL;
+	struct cma_device *cma_dev =
+		cma_enum_devices_by_ibdev(filter_by_name, config_item_name(item));
+	struct cma_dev_group *group = to_dev_group(item);
+	struct cma_configfs_attr *ca =
+		container_of(attr, struct cma_configfs_attr, attr);
+
+	if (!cma_dev)
+		return -ENODEV;
+
+	if (ca->show)
+		ret = ca->show(cma_dev, group, buf);
+
+	cma_deref_dev(cma_dev);
+	return ret;
+}
+
+static ssize_t cma_configfs_attr_store(struct config_item *item,
+				       struct configfs_attribute *attr,
+				       const char *buf, size_t count)
+{
+	ssize_t ret = -EINVAL;
+	struct cma_device *cma_dev =
+		cma_enum_devices_by_ibdev(filter_by_name, config_item_name(item));
+	struct cma_dev_group *group = to_dev_group(item);
+	struct cma_configfs_attr *ca =
+		container_of(attr, struct cma_configfs_attr, attr);
+
+	if (!cma_dev)
+		return -ENODEV;
+
+	if (ca->store)
+		ret = ca->store(cma_dev, group, buf, count);
+
+	cma_deref_dev(cma_dev);
+	return ret;
+}
+
+static struct configfs_attribute *cma_configfs_attributes[] = {
+	&cma_configfs_attr_default_roce_mode.attr,
+	NULL,
+};
+
+static void cma_configfs_attr_release(struct config_item *item)
+{
+	kfree(to_dev_group(item));
+}
+
+static struct configfs_item_operations cma_item_ops = {
+	.show_attribute		= cma_configfs_attr_show,
+	.store_attribute	= cma_configfs_attr_store,
+	.release		= cma_configfs_attr_release,
+};
+
+static struct config_item_type cma_item_type = {
+	.ct_attrs	= cma_configfs_attributes,
+	.ct_item_ops	= &cma_item_ops,
+	.ct_owner	= THIS_MODULE
+};
+
+static struct config_item *make_cma_dev(struct config_group *group,
+					const char *name)
+{
+	int err = -EINVAL;
+	struct cma_device *cma_dev = cma_enum_devices_by_ibdev(filter_by_name,
+							       (void *)name);
+	struct cma_dev_group *cma_dev_group = NULL;
+
+	if (!cma_dev)
+		goto fail;
+
+	cma_dev_group = kzalloc(sizeof(*cma_dev_group), GFP_KERNEL);
+
+	if (!cma_dev_group) {
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	config_item_init_type_name(&cma_dev_group->item, name, &cma_item_type);
+
+	cma_deref_dev(cma_dev);
+	return &cma_dev_group->item;
+
+fail:
+	if (cma_dev)
+		cma_deref_dev(cma_dev);
+	kfree(cma_dev_group);
+	return ERR_PTR(err);
+}
+
+static void drop_cma_dev(struct config_group *group,
+			 struct config_item *item)
+{
+	config_item_put(item);
+}
+
+static struct configfs_group_operations cma_subsys_group_ops = {
+	.make_item	= make_cma_dev,
+	.drop_item	= drop_cma_dev,
+};
+
+static struct config_item_type cma_subsys_type = {
+	.ct_group_ops	= &cma_subsys_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct configfs_subsystem cma_subsys = {
+	.su_group	= {
+		.cg_item	= {
+			.ci_namebuf	= "rdma_cm",
+			.ci_type	= &cma_subsys_type,
+		},
+	},
+};
+
+int __init cma_configfs_init(void)
+{
+	config_group_init(&cma_subsys.su_group);
+	mutex_init(&cma_subsys.su_mutex);
+	return configfs_register_subsystem(&cma_subsys);
+}
+
+void __exit cma_configfs_exit(void)
+{
+	configfs_unregister_subsystem(&cma_subsys);
+}
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 94db13d..2d9ebe1 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -39,6 +39,20 @@
 
 #include <rdma/ib_verbs.h>
 
+#if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
+int cma_configfs_init(void);
+void cma_configfs_exit(void);
+#endif
+struct cma_device;
+typedef bool (*cma_device_filter)(struct ib_device *, void *);
+struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter	filter,
+					     void		*cookie);
+enum ib_gid_type cma_get_default_gid_type(struct cma_device *cma_dev);
+void cma_set_default_gid_type(struct cma_device *cma_dev,
+			      enum ib_gid_type default_gid_type);
+void cma_ref_dev(struct cma_device *cma_dev);
+void cma_deref_dev(struct cma_device *cma_dev);
+
 extern struct workqueue_struct *roce_gid_mgmt_wq;
 
 int  ib_device_register_sysfs(struct ib_device *device,
@@ -72,6 +86,7 @@ void ib_enum_roce_ports_of_netdev(roce_netdev_filter filter,
 				  void *cookie);
 
 const char *roce_gid_cache_type_str(enum ib_gid_type gid_type);
+int roce_gid_cache_parse_gid_str(const char *buf);
 
 int roce_gid_cache_get_gid(struct ib_device *ib_dev, u8 port, int index,
 			   union ib_gid *gid, struct ib_gid_attr *attr);
diff --git a/drivers/infiniband/core/roce_gid_cache.c b/drivers/infiniband/core/roce_gid_cache.c
index bd51d97..f02215b 100644
--- a/drivers/infiniband/core/roce_gid_cache.c
+++ b/drivers/infiniband/core/roce_gid_cache.c
@@ -72,6 +72,19 @@ const char *roce_gid_cache_type_str(enum ib_gid_type gid_type)
 
 	return "Invalid GID type";
 }
+EXPORT_SYMBOL_GPL(roce_gid_cache_type_str);
+
+int roce_gid_cache_parse_gid_str(const char *buf)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(gid_type_str); ++i)
+		if (gid_type_str[i] && !strcmp(buf, gid_type_str[i]))
+			return i;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(roce_gid_cache_parse_gid_str);
 
 static void put_ndev(struct rcu_head *rcu)
 {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
