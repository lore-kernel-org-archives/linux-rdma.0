From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/1] IB/cma: Add default RoCE TOS to CMA configfs
Date: Wed, 25 Jan 2017 16:36:17 +0200
Message-ID: <20170125143617.13104-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new entry to the RDMA-CM configfs that allows users
to select default TOS for RDMA-CM QPs.

This is useful for users that want to control the TOS for legacy
applications without changing their code.

Application that sets the TOS explicitly using the rdma_set_option
API will continue to work as expected, meaning overriding the configfs
value.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/ABI/testing/configfs-rdma_cm |  8 +++++
 drivers/infiniband/core/cma.c              | 56 +++++++++++++++++++++++++++---
 drivers/infiniband/core/cma_configfs.c     | 42 ++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h        |  3 ++
 4 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/configfs-rdma_cm b/Documentation/ABI/testing/configfs-rdma_cm
index 5c389aaf5291..89fa006ee88d 100644
--- a/Documentation/ABI/testing/configfs-rdma_cm
+++ b/Documentation/ABI/testing/configfs-rdma_cm
@@ -20,3 +20,11 @@ Description: 	RDMA-CM based connections from HCA <hca> at port <port-num>
 		will be initiated with this RoCE type as default.
 		The possible RoCE types are either "IB/RoCE v1" or "RoCE v2".
 		This parameter has RW access.
+
+What: 		/config/rdma_cm/<hca>/ports/<port-num>/default_roce_tos
+Date: 		December 20, 2016
+KernelVersion:  4.11.0
+Description: 	RDMA-CM QPs from HCA <hca> at port <port-num>
+		will be created with this TOS as default.
+		This can be overridden by using the rdma_set_option API.
+		The possible RoCE TOS values are 0-255.
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f9133c7606a8..adaac55ed9a8 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -198,6 +198,7 @@ struct cma_device {
 	atomic_t		refcount;
 	struct list_head	id_list;
 	enum ib_gid_type	*default_gid_type;
+	u8			*default_roce_tos;
 };
 
 struct rdma_bind_list {
@@ -297,6 +298,27 @@ int cma_set_default_gid_type(struct cma_device *cma_dev,
 	return 0;
 }
 
+u8 cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned int port)
+{
+	if (port < rdma_start_port(cma_dev->device) ||
+	    port > rdma_end_port(cma_dev->device))
+		return -EINVAL;
+
+	return cma_dev->default_roce_tos[port - rdma_start_port(cma_dev->device)];
+}
+
+int cma_set_default_roce_tos(struct cma_device *cma_dev, unsigned int port,
+			     u8 default_roce_tos)
+{
+	if (port < rdma_start_port(cma_dev->device) ||
+	    port > rdma_end_port(cma_dev->device))
+		return -EINVAL;
+
+	cma_dev->default_roce_tos[port - rdma_start_port(cma_dev->device)] =
+		 default_roce_tos;
+
+	return 0;
+}
 struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev)
 {
 	return cma_dev->device;
@@ -343,6 +365,7 @@ struct rdma_id_private {
 	u32			options;
 	u8			srq;
 	u8			tos;
+	bool			tos_set;
 	u8			reuseaddr;
 	u8			afonly;
 	enum ib_gid_type	gid_type;
@@ -782,6 +805,7 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
 	id_priv->id.event_handler = event_handler;
 	id_priv->id.ps = ps;
 	id_priv->id.qp_type = qp_type;
+	id_priv->tos_set = false;
 	spin_lock_init(&id_priv->lock);
 	mutex_init(&id_priv->qp_mutex);
 	init_completion(&id_priv->comp);
@@ -2273,6 +2297,7 @@ void rdma_set_service_type(struct rdma_cm_id *id, int tos)
 
 	id_priv = container_of(id, struct rdma_id_private, id);
 	id_priv->tos = (u8) tos;
+	id_priv->tos_set = true;
 }
 EXPORT_SYMBOL(rdma_set_service_type);
 
@@ -2509,6 +2534,9 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	struct cma_work *work;
 	int ret;
 	struct net_device *ndev = NULL;
+	u8 default_roce_tos = id_priv->cma_dev->default_roce_tos[id_priv->id.port_num -
+					rdma_start_port(id_priv->cma_dev->device)];
+	u8 tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
 
 
 	work = kzalloc(sizeof *work, GFP_KERNEL);
@@ -2582,7 +2610,8 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
-	route->path_rec->sl = iboe_tos_to_sl(ndev, id_priv->tos);
+	route->path_rec->sl = iboe_tos_to_sl(ndev, tos);
+	route->path_rec->traffic_class = tos;
 	route->path_rec->mtu = iboe_get_mtu(ndev->mtu);
 	route->path_rec->rate_selector = IB_SA_EQ;
 	route->path_rec->rate = iboe_get_rate(ndev);
@@ -4306,15 +4335,21 @@ static void cma_add_one(struct ib_device *device)
 	cma_dev->default_gid_type = kcalloc(device->phys_port_cnt,
 					    sizeof(*cma_dev->default_gid_type),
 					    GFP_KERNEL);
-	if (!cma_dev->default_gid_type) {
-		kfree(cma_dev);
-		return;
-	}
+	if (!cma_dev->default_gid_type)
+		goto free_cma_dev;
+
+	cma_dev->default_roce_tos = kcalloc(device->phys_port_cnt,
+					    sizeof(*cma_dev->default_roce_tos),
+					    GFP_KERNEL);
+	if (!cma_dev->default_roce_tos)
+		goto free_gid_type;
+
 	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
 		supported_gids = roce_gid_type_mask_support(device, i);
 		WARN_ON(!supported_gids);
 		cma_dev->default_gid_type[i - rdma_start_port(device)] =
 			find_first_bit(&supported_gids, BITS_PER_LONG);
+		cma_dev->default_roce_tos[i - rdma_start_port(device)] = 0;
 	}
 
 	init_completion(&cma_dev->comp);
@@ -4327,6 +4362,16 @@ static void cma_add_one(struct ib_device *device)
 	list_for_each_entry(id_priv, &listen_any_list, list)
 		cma_listen_on_dev(id_priv, cma_dev);
 	mutex_unlock(&lock);
+
+	return;
+
+free_gid_type:
+	kfree(cma_dev->default_gid_type);
+
+free_cma_dev:
+	kfree(cma_dev);
+
+	return;
 }
 
 static int cma_remove_id_dev(struct rdma_id_private *id_priv)
@@ -4395,6 +4440,7 @@ static void cma_remove_one(struct ib_device *device, void *client_data)
 	mutex_unlock(&lock);
 
 	cma_process_remove(cma_dev);
+	kfree(cma_dev->default_roce_tos);
 	kfree(cma_dev->default_gid_type);
 	kfree(cma_dev);
 }
diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index 41573df1d9fc..54076a3e8007 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -139,8 +139,50 @@ static ssize_t default_roce_mode_store(struct config_item *item,
 
 CONFIGFS_ATTR(, default_roce_mode);
 
+static ssize_t default_roce_tos_show(struct config_item *item, char *buf)
+{
+	struct cma_device *cma_dev;
+	struct cma_dev_port_group *group;
+	ssize_t ret;
+	u8 tos;
+
+	ret = cma_configfs_params_get(item, &cma_dev, &group);
+	if (ret)
+		return ret;
+
+	tos = cma_get_default_roce_tos(cma_dev, group->port_num);
+	cma_configfs_params_put(cma_dev);
+
+	return sprintf(buf, "%u\n", tos);
+}
+
+static ssize_t default_roce_tos_store(struct config_item *item,
+				      const char *buf, size_t count)
+{
+	struct cma_device *cma_dev;
+	struct cma_dev_port_group *group;
+	ssize_t ret;
+	u8 tos;
+
+	ret = kstrtou8(buf, 0, &tos);
+	if (ret)
+		return ret;
+
+	ret = cma_configfs_params_get(item, &cma_dev, &group);
+	if (ret)
+		return ret;
+
+	ret = cma_set_default_roce_tos(cma_dev, group->port_num, tos);
+	cma_configfs_params_put(cma_dev);
+
+	return ret ? ret : strnlen(buf, count);
+}
+
+CONFIGFS_ATTR(, default_roce_tos);
+
 static struct configfs_attribute *cma_configfs_attributes[] = {
 	&attr_default_roce_mode,
+	&attr_default_roce_tos,
 	NULL,
 };
 
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index d29372624f3a..b9ebea6da8b9 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -62,6 +62,9 @@ int cma_get_default_gid_type(struct cma_device *cma_dev,
 int cma_set_default_gid_type(struct cma_device *cma_dev,
 			     unsigned int port,
 			     enum ib_gid_type default_gid_type);
+u8 cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned int port);
+int cma_set_default_roce_tos(struct cma_device *a_dev, unsigned int port,
+			     u8 default_roce_tos);
 struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev);
 
 int  ib_device_register_sysfs(struct ib_device *device,
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
