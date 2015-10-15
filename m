From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 7/9] IB/cma: Add configfs for rdma_cm
Date: Thu, 15 Oct 2015 19:07:10 +0300
Message-ID: <1444925232-13598-8-git-send-email-matanb@mellanox.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444925232-13598-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Users would like to control the behaviour of rdma_cm.
For example, old applications which don't set the
required RoCE gid type could be executed on RoCE V2
network types. In order to support this configuration,
we implement a configfs for rdma_cm.

In order to use the configfs, one needs to mount it and
mkdir <IB device name> inside rdma_cm directory.

The patch adds support for a single configuration file,
default_roce_mode. The mode can either be "IB/RoCE v1" or
"RoCE v2".

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig             |   9 +
 drivers/infiniband/core/Makefile       |   2 +
 drivers/infiniband/core/cache.c        |  24 +++
 drivers/infiniband/core/cma.c          |  95 ++++++++-
 drivers/infiniband/core/cma_configfs.c | 353 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h    |  24 +++
 6 files changed, 503 insertions(+), 4 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_configfs.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index aa26f3c..2568af6 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -54,6 +54,15 @@ config INFINIBAND_ADDR_TRANS
 	depends on INFINIBAND
 	default y
 
+config INFINIBAND_ADDR_TRANS_CONFIGFS
+	bool
+	depends on INFINIBAND_ADDR_TRANS && CONFIGFS_FS
+	default y
+	---help---
+	  ConfigFS support for RDMA communication manager (CM).
+	  This allows the user to config the default GID type that the CM
+	  uses for each device, when initiaing new connections.
+
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index d43a899..7922fa7 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -24,6 +24,8 @@ iw_cm-y :=			iwcm.o iwpm_util.o iwpm_msg.o
 
 rdma_cm-y :=			cma.o
 
+rdma_cm-$(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS) += cma_configfs.o
+
 rdma_ucm-y :=			ucma.o
 
 ib_addr-y :=			addr.o
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index cb34b06..9e02f3c 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -127,6 +127,30 @@ const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
 }
 EXPORT_SYMBOL(ib_cache_gid_type_str);
 
+int ib_cache_gid_parse_type_str(const char *buf)
+{
+	unsigned int i;
+	size_t len;
+	int err = -EINVAL;
+
+	len = strlen(buf);
+	if (len == 0)
+		return -EINVAL;
+
+	if (buf[len - 1] == '\n')
+		len--;
+
+	for (i = 0; i < ARRAY_SIZE(gid_type_str); ++i)
+		if (gid_type_str[i] && !strncmp(buf, gid_type_str[i], len) &&
+		    len == strlen(gid_type_str[i])) {
+			err = i;
+			break;
+		}
+
+	return err;
+}
+EXPORT_SYMBOL(ib_cache_gid_parse_type_str);
+
 static int write_gid(struct ib_device *ib_dev, u8 port,
 		     struct ib_gid_table *table, int ix,
 		     const union ib_gid *gid,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0955690..b03099e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -139,6 +139,7 @@ struct cma_device {
 	struct completion	comp;
 	atomic_t		refcount;
 	struct list_head	id_list;
+	enum ib_gid_type	*default_gid_type;
 };
 
 struct rdma_bind_list {
@@ -178,6 +179,62 @@ void cma_ref_dev(struct cma_device *cma_dev)
 	atomic_inc(&cma_dev->refcount);
 }
 
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
+int cma_get_default_gid_type(struct cma_device *cma_dev,
+			     unsigned int port)
+{
+	if (port < rdma_start_port(cma_dev->device) ||
+	    port > rdma_end_port(cma_dev->device))
+		return -EINVAL;
+
+	return cma_dev->default_gid_type[port - rdma_start_port(cma_dev->device)];
+}
+
+int cma_set_default_gid_type(struct cma_device *cma_dev,
+			     unsigned int port,
+			     enum ib_gid_type default_gid_type)
+{
+	unsigned long supported_gids;
+
+	if (port < rdma_start_port(cma_dev->device) ||
+	    port > rdma_end_port(cma_dev->device))
+		return -EINVAL;
+
+	supported_gids = roce_gid_type_mask_support(cma_dev->device, port);
+
+	if (!(supported_gids & 1 << default_gid_type))
+		return -EINVAL;
+
+	cma_dev->default_gid_type[port - rdma_start_port(cma_dev->device)] =
+		default_gid_type;
+
+	return 0;
+}
+
+struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev)
+{
+	return cma_dev->device;
+}
+
 /*
  * Device removal can occur at anytime, so we need extra handling to
  * serialize notifying the user of device removal with other callbacks.
@@ -334,6 +391,9 @@ static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 {
 	cma_ref_dev(cma_dev);
 	id_priv->cma_dev = cma_dev;
+	id_priv->gid_type =
+		cma_dev->default_gid_type[id_priv->id.port_num -
+					  rdma_start_port(cma_dev->device)];
 	id_priv->id.device = cma_dev->device;
 	id_priv->id.route.addr.dev_addr.transport =
 		rdma_node_get_transport(cma_dev->device->node_type);
@@ -435,6 +495,7 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 }
 
 static inline int cma_validate_port(struct ib_device *device, u8 port,
+				    enum ib_gid_type gid_type,
 				      union ib_gid *gid, int dev_type,
 				      int bound_if_index)
 {
@@ -449,8 +510,10 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
 
 	if (dev_type == ARPHRD_ETHER)
 		ndev = dev_get_by_index(&init_net, bound_if_index);
+	else
+		gid_type = IB_GID_TYPE_IB;
 
-	ret = ib_find_cached_gid_by_port(device, gid, IB_GID_TYPE_IB, port,
+	ret = ib_find_cached_gid_by_port(device, gid, gid_type, port,
 					 ndev, NULL);
 
 	if (ndev)
@@ -485,7 +548,10 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 		gidp = rdma_protocol_roce(cma_dev->device, port) ?
 		       &iboe_gid : &gid;
 
-		ret = cma_validate_port(cma_dev->device, port, gidp,
+		ret = cma_validate_port(cma_dev->device, port,
+					rdma_protocol_ib(cma_dev->device, port) ?
+					IB_GID_TYPE_IB :
+					listen_id_priv->gid_type, gidp,
 					dev_addr->dev_type,
 					dev_addr->bound_dev_if);
 		if (!ret) {
@@ -504,8 +570,11 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 			gidp = rdma_protocol_roce(cma_dev->device, port) ?
 			       &iboe_gid : &gid;
 
-			ret = cma_validate_port(cma_dev->device, port, gidp,
-						dev_addr->dev_type,
+			ret = cma_validate_port(cma_dev->device, port,
+						rdma_protocol_ib(cma_dev->device, port) ?
+						IB_GID_TYPE_IB :
+						cma_dev->default_gid_type[port - 1],
+						gidp, dev_addr->dev_type,
 						dev_addr->bound_dev_if);
 			if (!ret) {
 				id_priv->id.port_num = port;
@@ -3829,12 +3898,27 @@ static void cma_add_one(struct ib_device *device)
 {
 	struct cma_device *cma_dev;
 	struct rdma_id_private *id_priv;
+	unsigned int i;
+	unsigned long supported_gids = 0;
 
 	cma_dev = kmalloc(sizeof *cma_dev, GFP_KERNEL);
 	if (!cma_dev)
 		return;
 
 	cma_dev->device = device;
+	cma_dev->default_gid_type = kcalloc(device->phys_port_cnt,
+					    sizeof(*cma_dev->default_gid_type),
+					    GFP_KERNEL);
+	if (!cma_dev->default_gid_type) {
+		kfree(cma_dev);
+		return;
+	}
+	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
+		supported_gids = roce_gid_type_mask_support(device, i);
+		WARN_ON(!supported_gids);
+		cma_dev->default_gid_type[i - rdma_start_port(device)] =
+			find_first_bit(&supported_gids, BITS_PER_LONG);
+	}
 
 	init_completion(&cma_dev->comp);
 	atomic_set(&cma_dev->refcount, 1);
@@ -3914,6 +3998,7 @@ static void cma_remove_one(struct ib_device *device, void *client_data)
 	mutex_unlock(&lock);
 
 	cma_process_remove(cma_dev);
+	kfree(cma_dev->default_gid_type);
 	kfree(cma_dev);
 }
 
@@ -4014,6 +4099,7 @@ static int __init cma_init(void)
 
 	if (ibnl_add_client(RDMA_NL_RDMA_CM, RDMA_NL_RDMA_CM_NUM_OPS, cma_cb_table))
 		printk(KERN_WARNING "RDMA CMA: failed to add netlink callback\n");
+	cma_configfs_init();
 
 	return 0;
 
@@ -4027,6 +4113,7 @@ err:
 
 static void __exit cma_cleanup(void)
 {
+	cma_configfs_exit();
 	ibnl_remove_client(RDMA_NL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
new file mode 100644
index 0000000..9911a08
--- /dev/null
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -0,0 +1,353 @@
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
+struct cma_dev_group;
+
+struct cma_dev_port_group {
+	unsigned int		port_num;
+	struct cma_dev_group	*cma_dev_group;
+	struct config_group	group;
+};
+
+struct cma_dev_group {
+	char				name[IB_DEVICE_NAME_MAX];
+	struct config_group		device_group;
+	struct config_group		ports_group;
+	struct config_group		*default_dev_group[2];
+	struct config_group		**default_ports_group;
+	struct cma_dev_port_group	*ports;
+};
+
+struct cma_configfs_attr {
+	struct configfs_attribute	attr;
+	ssize_t				(*show)(struct cma_device *cma_dev,
+						struct cma_dev_port_group *group,
+						char *buf);
+	ssize_t				(*store)(struct cma_device *cma_dev,
+						 struct cma_dev_port_group *group,
+						 const char *buf, size_t count);
+};
+
+static struct cma_dev_port_group *to_dev_port_group(struct config_item *item)
+{
+	struct config_group *group;
+
+	if (!item)
+		return NULL;
+
+	group = container_of(item, struct config_group, cg_item);
+	return container_of(group, struct cma_dev_port_group, group);
+}
+
+static ssize_t show_default_roce_mode(struct cma_device *cma_dev,
+				      struct cma_dev_port_group *group,
+				      char *buf)
+{
+	unsigned int port = group->port_num;
+	int gid_type = cma_get_default_gid_type(cma_dev, port);
+
+	if (gid_type < 0)
+		return gid_type;
+
+	return sprintf(buf, "%s\n", ib_cache_gid_type_str(gid_type));
+}
+
+static ssize_t store_default_roce_mode(struct cma_device *cma_dev,
+				       struct cma_dev_port_group *group,
+				       const char *buf, size_t count)
+{
+	int gid_type = ib_cache_gid_parse_type_str(buf);
+	unsigned int port = group->port_num;
+	int ret;
+
+	if (gid_type < 0)
+		return -EINVAL;
+
+	ret = cma_set_default_gid_type(cma_dev, port, gid_type);
+	if (ret)
+		return ret;
+
+	return strnlen(buf, count);
+}
+
+#define CMA_PARAM_PORT_ATTR_RW(_name)				\
+static struct cma_configfs_attr cma_configfs_attr_##_name =	\
+	__CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR, show_##_name, store_##_name)
+
+CMA_PARAM_PORT_ATTR_RW(default_roce_mode);
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
+	struct cma_dev_port_group *group = to_dev_port_group(item);
+	struct cma_device *cma_dev;
+	struct cma_configfs_attr *ca =
+		container_of(attr, struct cma_configfs_attr, attr);
+
+	if (!group)
+		return -ENODEV;
+
+	cma_dev = cma_enum_devices_by_ibdev(filter_by_name,
+					    group->cma_dev_group->name);
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
+	struct cma_dev_port_group *group = to_dev_port_group(item);
+	struct cma_device *cma_dev;
+	struct cma_configfs_attr *ca =
+		container_of(attr, struct cma_configfs_attr, attr);
+
+	if (!group)
+		return -ENODEV;
+
+	cma_dev = cma_enum_devices_by_ibdev(filter_by_name,
+					    group->cma_dev_group->name);
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
+static struct configfs_item_operations cma_item_ops = {
+	.show_attribute		= cma_configfs_attr_show,
+	.store_attribute	= cma_configfs_attr_store,
+};
+
+static struct config_item_type cma_port_group_type = {
+	.ct_attrs	= cma_configfs_attributes,
+	.ct_item_ops	= &cma_item_ops,
+	.ct_owner	= THIS_MODULE
+};
+
+static int make_cma_ports(struct cma_dev_group *cma_dev_group,
+			  struct cma_device *cma_dev)
+{
+	struct ib_device *ibdev;
+	unsigned int i;
+	unsigned int ports_num;
+	struct cma_dev_port_group *ports;
+	int err;
+
+	ibdev = cma_get_ib_dev(cma_dev);
+
+	if (!ibdev)
+		return -ENODEV;
+
+	ports_num = ibdev->phys_port_cnt;
+	ports = kcalloc(ports_num, sizeof(*cma_dev_group->ports),
+			GFP_KERNEL);
+
+	cma_dev_group->default_ports_group = kcalloc(ports_num + 1,
+						     sizeof(*cma_dev_group->ports),
+						     GFP_KERNEL);
+
+	if (!ports || !cma_dev_group->default_ports_group) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	for (i = 0; i < ports_num; i++) {
+		char port_str[10];
+
+		ports[i].port_num = i + 1;
+		snprintf(port_str, sizeof(port_str), "%u", i + 1);
+		ports[i].cma_dev_group = cma_dev_group;
+		config_group_init_type_name(&ports[i].group,
+					    port_str,
+					    &cma_port_group_type);
+		cma_dev_group->default_ports_group[i] = &ports[i].group;
+	}
+	cma_dev_group->default_ports_group[i] = NULL;
+	cma_dev_group->ports = ports;
+
+	return 0;
+free:
+	kfree(ports);
+	kfree(cma_dev_group->default_ports_group);
+	cma_dev_group->ports = NULL;
+	cma_dev_group->default_ports_group = NULL;
+	return err;
+}
+
+static void release_cma_dev(struct config_item  *item)
+{
+	struct config_group *group = container_of(item, struct config_group,
+						  cg_item);
+	struct cma_dev_group *cma_dev_group = container_of(group,
+							   struct cma_dev_group,
+							   device_group);
+
+	kfree(cma_dev_group);
+};
+
+static void release_cma_ports_group(struct config_item  *item)
+{
+	struct config_group *group = container_of(item, struct config_group,
+						  cg_item);
+	struct cma_dev_group *cma_dev_group = container_of(group,
+							   struct cma_dev_group,
+							   ports_group);
+
+	kfree(cma_dev_group->ports);
+	kfree(cma_dev_group->default_ports_group);
+	cma_dev_group->ports = NULL;
+	cma_dev_group->default_ports_group = NULL;
+};
+
+static struct configfs_item_operations cma_ports_item_ops = {
+	.release = release_cma_ports_group
+};
+
+static struct config_item_type cma_ports_group_type = {
+	.ct_item_ops	= &cma_ports_item_ops,
+	.ct_owner	= THIS_MODULE
+};
+
+static struct configfs_item_operations cma_device_item_ops = {
+	.release = release_cma_dev
+};
+
+static struct config_item_type cma_device_group_type = {
+	.ct_item_ops	= &cma_device_item_ops,
+	.ct_owner	= THIS_MODULE
+};
+
+static struct config_group *make_cma_dev(struct config_group *group,
+					 const char *name)
+{
+	int err = -ENODEV;
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
+	strncpy(cma_dev_group->name, name, sizeof(cma_dev_group->name));
+
+	err = make_cma_ports(cma_dev_group, cma_dev);
+	if (err)
+		goto fail;
+
+	cma_dev_group->ports_group.default_groups =
+		cma_dev_group->default_ports_group;
+	config_group_init_type_name(&cma_dev_group->ports_group, "ports",
+				    &cma_ports_group_type);
+
+	cma_dev_group->device_group.default_groups
+		= cma_dev_group->default_dev_group;
+	cma_dev_group->default_dev_group[0] = &cma_dev_group->ports_group;
+	cma_dev_group->default_dev_group[1] = NULL;
+
+	config_group_init_type_name(&cma_dev_group->device_group, name,
+				    &cma_device_group_type);
+
+	cma_deref_dev(cma_dev);
+	return &cma_dev_group->device_group;
+
+fail:
+	if (cma_dev)
+		cma_deref_dev(cma_dev);
+	kfree(cma_dev_group);
+	return ERR_PTR(err);
+}
+
+static struct configfs_group_operations cma_subsys_group_ops = {
+	.make_group	= make_cma_dev,
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
index aeb107c..09d2615 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,9 +38,31 @@
 
 #include <rdma/ib_verbs.h>
 
+#if IS_ENABLED(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)
+int cma_configfs_init(void);
+void cma_configfs_exit(void);
+#else
+static inline int cma_configfs_init(void)
+{
+	return 0;
+}
+
+static inline void cma_configfs_exit(void)
+{
+}
+#endif
 struct cma_device;
 void cma_ref_dev(struct cma_device *cma_dev);
 void cma_deref_dev(struct cma_device *cma_dev);
+typedef bool (*cma_device_filter)(struct ib_device *, void *);
+struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter	filter,
+					     void		*cookie);
+int cma_get_default_gid_type(struct cma_device *cma_dev,
+			     unsigned int port);
+int cma_set_default_gid_type(struct cma_device *cma_dev,
+			     unsigned int port,
+			     enum ib_gid_type default_gid_type);
+struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev);
 
 int  ib_device_register_sysfs(struct ib_device *device,
 			      int (*port_callback)(struct ib_device *,
@@ -74,6 +96,8 @@ enum ib_cache_gid_default_mode {
 	IB_CACHE_GID_DEFAULT_MODE_DELETE
 };
 
+int ib_cache_gid_parse_type_str(const char *buf);
+
 const char *ib_cache_gid_type_str(enum ib_gid_type gid_type);
 
 void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
