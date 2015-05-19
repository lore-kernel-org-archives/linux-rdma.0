From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 07/14] IB/core: GID attribute should be returned from verbs API and cache API
Date: Tue, 19 May 2015 17:27:10 +0300
Message-ID: <1432045637-9090-8-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Along with the GID itself, we now store GIDs attribute.
This GID attribute contains important meta information regarding
the GID itself, for example the netdevice. Thus, this information
needs to be returned in APIs. This patch changes the following APIs:
(a) ib_get_cached_gid
(b) ib_find_cached_gid
(c) ib_find_cached_gid_by_port
(d) ib_query_gid

It changes the usage of those APIs and use the RoCE GID table
when needed.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c                | 289 ++++++++++++++++++++-----
 drivers/infiniband/core/cm.c                   |   6 +-
 drivers/infiniband/core/cma.c                  |  84 ++++---
 drivers/infiniband/core/device.c               |  29 ++-
 drivers/infiniband/core/mad.c                  |   2 +-
 drivers/infiniband/core/multicast.c            |   3 +-
 drivers/infiniband/core/sa_query.c             |   7 +-
 drivers/infiniband/core/sysfs.c                |   2 +-
 drivers/infiniband/core/uverbs_marshall.c      |   4 +-
 drivers/infiniband/core/verbs.c                |   7 +-
 drivers/infiniband/hw/mlx4/qp.c                |   5 +-
 drivers/infiniband/hw/mthca/mthca_av.c         |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   3 +-
 include/rdma/ib_cache.h                        |  44 +++-
 include/rdma/ib_sa.h                           |   4 +-
 include/rdma/ib_verbs.h                        |   7 +-
 19 files changed, 401 insertions(+), 103 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 80f6cf2..5af1e6a 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -42,6 +42,8 @@
 
 #include "core_priv.h"
 
+#define __IB_ONLY
+
 struct ib_pkey_cache {
 	int             table_len;
 	u16             table[0];
@@ -69,68 +71,215 @@ static inline int end_port(struct ib_device *device)
 		0 : device->phys_port_cnt;
 }
 
-int ib_get_cached_gid(struct ib_device *device,
-		      u8                port_num,
-		      int               index,
-		      union ib_gid     *gid)
+static int __IB_ONLY __ib_get_cached_gid(struct ib_device *device,
+					 u8                port_num,
+					 int               index,
+					 union ib_gid     *gid)
 {
 	struct ib_gid_cache *cache;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
+	if (!device->cache.gid_cache)
+		return -ENOENT;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.gid_cache[port_num - start_port(device)];
-
-	if (index < 0 || index >= cache->table_len)
-		ret = -EINVAL;
-	else
+	if (cache && index >= 0 && index < cache->table_len) {
 		*gid = cache->table[index];
+		ret = 0;
+	}
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
+	return ret;
+}
+
+int ib_cache_use_roce_gid_table(struct ib_device *device, u8 port_num)
+{
+	if (rdma_port_get_link_layer(device, port_num) ==
+	    IB_LINK_LAYER_ETHERNET) {
+		if (device->cache.roce_gid_table)
+			return 0;
+		else
+			return -EAGAIN;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ib_cache_use_roce_gid_table);
+
+int ib_get_cached_gid(struct ib_device *device,
+		      u8                port_num,
+		      int               index,
+		      union ib_gid     *gid,
+		      struct ib_gid_attr *attr)
+{
+	int ret;
+
+	if (port_num < start_port(device) || port_num > end_port(device))
+		return -EINVAL;
+
+	ret = ib_cache_use_roce_gid_table(device, port_num);
+	if (!ret)
+		return roce_gid_table_get_gid(device, port_num, index, gid,
+					      attr);
+
+	if (ret == -EAGAIN)
+		return ret;
+
+	ret = __ib_get_cached_gid(device, port_num, index, gid);
+
+	if (!ret && attr) {
+		memset(attr, 0, sizeof(*attr));
+		attr->gid_type = IB_GID_TYPE_IB;
+	}
 
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
 
-int ib_find_cached_gid(struct ib_device *device,
-		       union ib_gid	*gid,
-		       u8               *port_num,
-		       u16              *index)
+static int __IB_ONLY ___ib_find_cached_gid_by_port(struct ib_device *device,
+						   u8               port_num,
+						   const union ib_gid *gid,
+						   u16              *index)
 {
 	struct ib_gid_cache *cache;
+	u8 p = port_num - start_port(device);
+	int i;
+
+	if (port_num < start_port(device) || port_num > end_port(device))
+		return -EINVAL;
+	if (!ib_cache_use_roce_gid_table(device, port_num))
+		return -EPROTONOSUPPORT;
+	if (!device->cache.gid_cache)
+		return -ENOENT;
+
+	cache = device->cache.gid_cache[p];
+	if (!cache)
+		return -ENOENT;
+
+	for (i = 0; i < cache->table_len; ++i) {
+		if (!memcmp(gid, &cache->table[i], sizeof(*gid))) {
+			if (index)
+				*index = i;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int __IB_ONLY __ib_find_cached_gid_by_port(struct ib_device *device,
+						  u8		    port_num,
+						  union ib_gid     *gid,
+						  u16              *index)
+{
 	unsigned long flags;
-	int p, i;
+	u16 found_index;
+	int ret;
+
+	if (index)
+		*index = -1;
+
+	read_lock_irqsave(&device->cache.lock, flags);
+
+	ret = ___ib_find_cached_gid_by_port(device, port_num, gid,
+					    &found_index);
+
+	read_unlock_irqrestore(&device->cache.lock, flags);
+
+	if (!ret && index)
+		*index = found_index;
+
+	return ret;
+}
+
+static int __IB_ONLY __ib_find_cached_gid(struct ib_device *device,
+					  union ib_gid     *gid,
+					  u8               *port_num,
+					  u16              *index)
+{
+	unsigned long flags;
+	u16 found_index;
+	int p;
 	int ret = -ENOENT;
 
-	*port_num = -1;
+	if (port_num)
+		*port_num = -1;
 	if (index)
 		*index = -1;
 
 	read_lock_irqsave(&device->cache.lock, flags);
 
-	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
-		cache = device->cache.gid_cache[p];
-		for (i = 0; i < cache->table_len; ++i) {
-			if (!memcmp(gid, &cache->table[i], sizeof *gid)) {
-				*port_num = p + start_port(device);
-				if (index)
-					*index = i;
-				ret = 0;
-				goto found;
-			}
+	for (p = start_port(device); p <= end_port(device); ++p) {
+		if (!___ib_find_cached_gid_by_port(device, p, gid,
+						   &found_index)) {
+			if (port_num)
+				*port_num = p;
+			ret = 0;
+			break;
 		}
 	}
-found:
+
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
+	if (!ret && index)
+		*index = found_index;
+
+	return ret;
+}
+
+int ib_find_cached_gid(struct ib_device *device,
+		       union ib_gid	*gid,
+		       enum ib_gid_type gid_type,
+		       struct net	*net,
+		       int		if_index,
+		       u8               *port_num,
+		       u16              *index)
+{
+	int ret = -ENOENT;
+
+	/* Look for a RoCE device with the specified GID. */
+	if (device->cache.roce_gid_table)
+		ret = roce_gid_table_find_gid(device, gid, gid_type, net,
+					      if_index, port_num, index);
+
+	/* If no RoCE devices with the specified GID, look for IB device. */
+	if (ret && gid_type == IB_GID_TYPE_IB)
+		ret =  __ib_find_cached_gid(device, gid, port_num, index);
+
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_cached_gid);
 
+int ib_find_cached_gid_by_port(struct ib_device *device,
+			       union ib_gid	*gid,
+			       enum ib_gid_type gid_type,
+			       u8               port_num,
+			       struct net	*net,
+			       int		if_index,
+			       u16              *index)
+{
+	int ret = -ENOENT;
+
+	/* Look for a RoCE device with the specified GID. */
+	if (!ib_cache_use_roce_gid_table(device, port_num))
+		return roce_gid_table_find_gid_by_port(device, gid, gid_type,
+						       port_num, net, if_index,
+						       index);
+
+	/* If no RoCE devices with the specified GID, look for IB device. */
+	if (gid_type == IB_GID_TYPE_IB)
+		ret = __ib_find_cached_gid_by_port(device, port_num,
+						   gid, index);
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_find_cached_gid_by_port);
+
 int ib_get_cached_pkey(struct ib_device *device,
 		       u8                port_num,
 		       int               index,
@@ -138,22 +287,23 @@ int ib_get_cached_pkey(struct ib_device *device,
 {
 	struct ib_pkey_cache *cache;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
 
+	if (!device->cache.pkey_cache)
+		return -ENOENT;
+
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - start_port(device)];
-
-	if (index < 0 || index >= cache->table_len)
-		ret = -EINVAL;
-	else
+	if (cache && index >= 0 && index < cache->table_len) {
 		*pkey = cache->table[index];
+		ret = 0;
+	}
 
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);
@@ -172,9 +322,14 @@ int ib_find_cached_pkey(struct ib_device *device,
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
 
+	if (!device->cache.pkey_cache)
+		return -ENOENT;
+
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	if (!cache)
+		goto out;
 
 	*index = -1;
 
@@ -193,8 +348,8 @@ int ib_find_cached_pkey(struct ib_device *device,
 		ret = 0;
 	}
 
+out:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_cached_pkey);
@@ -212,9 +367,14 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
 
+	if (!device->cache.pkey_cache)
+		return -ENOENT;
+
 	read_lock_irqsave(&device->cache.lock, flags);
 
 	cache = device->cache.pkey_cache[port_num - start_port(device)];
+	if (!cache)
+		goto out;
 
 	*index = -1;
 
@@ -224,9 +384,8 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 			ret = 0;
 			break;
 		}
-
+out:
 	read_unlock_irqrestore(&device->cache.lock, flags);
-
 	return ret;
 }
 EXPORT_SYMBOL(ib_find_exact_cached_pkey);
@@ -236,13 +395,16 @@ int ib_get_cached_lmc(struct ib_device *device,
 		      u8                *lmc)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
 
 	read_lock_irqsave(&device->cache.lock, flags);
-	*lmc = device->cache.lmc_cache[port_num - start_port(device)];
+	if (device->cache.lmc_cache) {
+		*lmc = device->cache.lmc_cache[port_num - start_port(device)];
+		ret = 0;
+	}
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
 	return ret;
@@ -254,9 +416,19 @@ static void ib_cache_update(struct ib_device *device,
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
-	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache;
+	struct ib_gid_cache       *gid_cache = NULL, *old_gid_cache = NULL;
 	int                        i;
 	int                        ret;
+	bool			   use_roce_gid_table =
+					!ib_cache_use_roce_gid_table(device,
+								     port);
+
+	if (port < start_port(device) || port > end_port(device))
+		return;
+
+	if (!(device->cache.pkey_cache && device->cache.gid_cache &&
+	      device->cache.lmc_cache))
+		return;
 
 	tprops = kmalloc(sizeof *tprops, GFP_KERNEL);
 	if (!tprops)
@@ -276,12 +448,14 @@ static void ib_cache_update(struct ib_device *device,
 
 	pkey_cache->table_len = tprops->pkey_tbl_len;
 
-	gid_cache = kmalloc(sizeof *gid_cache + tprops->gid_tbl_len *
-			    sizeof *gid_cache->table, GFP_KERNEL);
-	if (!gid_cache)
-		goto err;
+	if (!use_roce_gid_table) {
+		gid_cache = kmalloc(sizeof(*gid_cache) + tprops->gid_tbl_len *
+			    sizeof(*gid_cache->table), GFP_KERNEL);
+		if (!gid_cache)
+			goto err;
 
-	gid_cache->table_len = tprops->gid_tbl_len;
+		gid_cache->table_len = tprops->gid_tbl_len;
+	}
 
 	for (i = 0; i < pkey_cache->table_len; ++i) {
 		ret = ib_query_pkey(device, port, i, pkey_cache->table + i);
@@ -292,22 +466,28 @@ static void ib_cache_update(struct ib_device *device,
 		}
 	}
 
-	for (i = 0; i < gid_cache->table_len; ++i) {
-		ret = ib_query_gid(device, port, i, gid_cache->table + i);
-		if (ret) {
-			printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
-			       ret, device->name, i);
-			goto err;
+	if (!use_roce_gid_table) {
+		for (i = 0;  i < gid_cache->table_len; ++i) {
+			ret = ib_query_gid(device, port, i,
+					   gid_cache->table + i, NULL);
+			if (ret) {
+				printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
+				       ret, device->name, i);
+				goto err;
+			}
 		}
 	}
 
 	write_lock_irq(&device->cache.lock);
 
 	old_pkey_cache = device->cache.pkey_cache[port - start_port(device)];
-	old_gid_cache  = device->cache.gid_cache [port - start_port(device)];
+	if (!use_roce_gid_table)
+		old_gid_cache  =
+			device->cache.gid_cache[port - start_port(device)];
 
 	device->cache.pkey_cache[port - start_port(device)] = pkey_cache;
-	device->cache.gid_cache [port - start_port(device)] = gid_cache;
+	if (!use_roce_gid_table)
+		device->cache.gid_cache[port - start_port(device)] = gid_cache;
 
 	device->cache.lmc_cache[port - start_port(device)] = tprops->lmc;
 
@@ -403,12 +583,19 @@ err:
 	kfree(device->cache.pkey_cache);
 	kfree(device->cache.gid_cache);
 	kfree(device->cache.lmc_cache);
+	device->cache.pkey_cache = NULL;
+	device->cache.gid_cache = NULL;
+	device->cache.lmc_cache = NULL;
 }
 
 static void ib_cache_cleanup_one(struct ib_device *device)
 {
 	int p;
 
+	if (!(device->cache.pkey_cache && device->cache.gid_cache &&
+	      device->cache.lmc_cache))
+		return;
+
 	ib_unregister_event_handler(&device->cache.event_handler);
 	flush_workqueue(ib_wq);
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..d88f2ae 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -360,6 +360,8 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
+					IB_GID_TYPE_IB, path->net,
+					path->ifindex,
 					&p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
@@ -379,7 +381,6 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
 			     &av->ah_attr);
 	av->timeout = path->packet_life_time + 1;
-	memcpy(av->smac, path->smac, sizeof(av->smac));
 
 	av->valid = 1;
 	return 0;
@@ -1566,7 +1567,8 @@ static int cm_req_handler(struct cm_work *work)
 	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
 	if (ret) {
 		ib_get_cached_gid(work->port->cm_dev->ib_device,
-				  work->port->port_num, 0, &work->path[0].sgid);
+				  work->port->port_num, 0, &work->path[0].sgid,
+				  NULL);
 		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
 			       &work->path[0].sgid, sizeof work->path[0].sgid,
 			       NULL, 0);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 06441a4..7e6a0b2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -356,7 +356,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 	struct cma_device *cma_dev;
 	union ib_gid gid, iboe_gid;
 	int ret = -ENODEV;
-	u8 port, found_port;
+	u8 port;
 	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
 		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
 
@@ -375,16 +375,28 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 				     listen_id_priv->id.port_num) == dev_ll) {
 		cma_dev = listen_id_priv->cma_dev;
 		port = listen_id_priv->id.port_num;
-		if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
-		    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
-			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
-						 &found_port, NULL);
-		else
-			ret = ib_find_cached_gid(cma_dev->device, &gid,
-						 &found_port, NULL);
+		if (rdma_node_get_transport(cma_dev->device->node_type) ==
+		    RDMA_TRANSPORT_IB &&
+		    rdma_port_get_link_layer(cma_dev->device, port) ==
+		    IB_LINK_LAYER_ETHERNET) {
+			int if_index =
+				id_priv->id.route.addr.dev_addr.bound_dev_if;
+
+			ret = ib_find_cached_gid_by_port(cma_dev->device,
+							 &iboe_gid,
+							 IB_GID_TYPE_IB,
+							 port,
+							 &init_net,
+							 if_index,
+							 NULL);
+		} else {
+			ret = ib_find_cached_gid_by_port(cma_dev->device, &gid,
+							 IB_GID_TYPE_IB, port,
+							 NULL, 0, NULL);
+		}
 
-		if (!ret && (port  == found_port)) {
-			id_priv->id.port_num = found_port;
+		if (!ret) {
+			id_priv->id.port_num = port;
 			goto out;
 		}
 	}
@@ -394,15 +406,34 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 			    listen_id_priv->cma_dev == cma_dev &&
 			    listen_id_priv->id.port_num == port)
 				continue;
-			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
-				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
-				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
-					ret = ib_find_cached_gid(cma_dev->device, &iboe_gid, &found_port, NULL);
-				else
-					ret = ib_find_cached_gid(cma_dev->device, &gid, &found_port, NULL);
-
-				if (!ret && (port == found_port)) {
-					id_priv->id.port_num = found_port;
+			if (rdma_port_get_link_layer(cma_dev->device, port) ==
+			    dev_ll) {
+				if (rdma_node_get_transport(cma_dev->device->node_type) ==
+				    RDMA_TRANSPORT_IB &&
+				    rdma_port_get_link_layer(cma_dev->device, port) ==
+				    IB_LINK_LAYER_ETHERNET) {
+					int if_index =
+						id_priv->id.route.addr.dev_addr.bound_dev_if;
+
+					ret = ib_find_cached_gid_by_port(cma_dev->device,
+									 &iboe_gid,
+									 IB_GID_TYPE_IB,
+									 port,
+									 &init_net,
+									 if_index,
+									 NULL);
+				} else {
+					ret = ib_find_cached_gid_by_port(cma_dev->device,
+									 &gid,
+									 IB_GID_TYPE_IB,
+									 port,
+									 NULL,
+									 0,
+									 NULL);
+				}
+
+				if (!ret) {
+					id_priv->id.port_num = port;
 					goto out;
 				}
 			}
@@ -442,7 +473,9 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
 				continue;
 
-			for (i = 0; !ib_get_cached_gid(cur_dev->device, p, i, &gid); i++) {
+			for (i = 0; !ib_get_cached_gid(cur_dev->device, p, i,
+						       &gid, NULL);
+			     i++) {
 				if (!memcmp(&gid, dgid, sizeof(gid))) {
 					cma_dev = cur_dev;
 					sgid = gid;
@@ -629,7 +662,7 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
 		goto out;
 
 	ret = ib_query_gid(id_priv->id.device, id_priv->id.port_num,
-			   qp_attr.ah_attr.grh.sgid_index, &sgid);
+			   qp_attr.ah_attr.grh.sgid_index, &sgid, NULL);
 	if (ret)
 		goto out;
 
@@ -1915,16 +1948,17 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	route->num_paths = 1;
 
-	if (addr->dev_addr.bound_dev_if)
+	if (addr->dev_addr.bound_dev_if) {
 		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
+		route->path_rec->net = &init_net;
+		route->path_rec->ifindex = addr->dev_addr.bound_dev_if;
+	}
 	if (!ndev) {
 		ret = -ENODEV;
 		goto err2;
 	}
 
-	route->path_rec->vlan_id = rdma_vlan_dev_vlan_id(ndev);
 	memcpy(route->path_rec->dmac, addr->dev_addr.dst_dev_addr, ETH_ALEN);
-	memcpy(route->path_rec->smac, ndev->dev_addr, ndev->addr_len);
 
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
 		    &route->path_rec->sgid);
@@ -2058,7 +2092,7 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 	p = 1;
 
 port_found:
-	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid);
+	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid, NULL);
 	if (ret)
 		goto out;
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 697c715..cacbf1a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -40,6 +40,7 @@
 #include <linux/mutex.h>
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib_cache.h>
 
 #include "core_priv.h"
 
@@ -616,12 +617,21 @@ EXPORT_SYMBOL(ib_query_port);
  * @port_num:Port number to query
  * @index:GID table index to query
  * @gid:Returned GID
+ * @attr: Returned GID's attribute (only in RoCE)
  *
  * ib_query_gid() fetches the specified GID table entry.
  */
 int ib_query_gid(struct ib_device *device,
-		 u8 port_num, int index, union ib_gid *gid)
+		 u8 port_num, int index, union ib_gid *gid,
+		 struct ib_gid_attr *attr)
 {
+	if (!ib_cache_use_roce_gid_table(device, port_num))
+		return roce_gid_table_get_gid(device, port_num, index, gid,
+					      attr);
+
+	if (attr)
+		return -EINVAL;
+
 	return device->query_gid(device, port_num, index, gid);
 }
 EXPORT_SYMBOL(ib_query_gid);
@@ -768,19 +778,32 @@ EXPORT_SYMBOL(ib_modify_port);
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @gid_type: Type of GID.
+ * @net: The namespace to search this GID in (RoCE only).
+ *	 Valid only if if_index != 0.
+ * @if_index: The if_index assigned with this GID (RoCE only).
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the GID table where the GID was found.  This
  *   parameter may be NULL.
  */
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index)
+		enum ib_gid_type gid_type, struct net *net,
+		int if_index, u8 *port_num, u16 *index)
 {
 	union ib_gid tmp_gid;
 	int ret, port, i;
 
+	if (device->cache.roce_gid_table &&
+	    !roce_gid_table_find_gid(device, gid, gid_type, net, if_index,
+				     port_num, index))
+		return 0;
+
 	for (port = start_port(device); port <= end_port(device); ++port) {
+		if (!ib_cache_use_roce_gid_table(device, port))
+			continue;
+
 		for (i = 0; i < device->gid_tbl_len[port - start_port(device)]; ++i) {
-			ret = ib_query_gid(device, port, i, &tmp_gid);
+			ret = ib_query_gid(device, port, i, &tmp_gid, NULL);
 			if (ret)
 				return ret;
 			if (!memcmp(&tmp_gid, gid, sizeof *gid)) {
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 74c30f4..5d59cce 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1791,7 +1791,7 @@ static inline int rcv_has_same_gid(struct ib_mad_agent_private *mad_agent_priv,
 					  ((1 << lmc) - 1)));
 		} else {
 			if (ib_get_cached_gid(device, port_num,
-					      attr.grh.sgid_index, &sgid))
+					      attr.grh.sgid_index, &sgid, NULL))
 				return 0;
 			return !memcmp(sgid.raw, rwc->recv_buf.grh->dgid.raw,
 				       16);
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index fa17b55..f1927f1 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -729,7 +729,8 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid, &p, &gid_index);
+	ret = ib_find_cached_gid(device, &rec->port_gid, IB_GID_TYPE_IB,
+				 NULL, 0, &p, &gid_index);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c38f030..5b20237 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -546,7 +546,8 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = rec->dgid;
 
-		ret = ib_find_cached_gid(device, &rec->sgid, &port_num,
+		ret = ib_find_cached_gid(device, &rec->sgid, IB_GID_TYPE_IB,
+					 rec->net, rec->ifindex, &port_num,
 					 &gid_index);
 		if (ret)
 			return ret;
@@ -677,9 +678,9 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 
 		ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table),
 			  mad->data, &rec);
-		rec.vlan_id = 0xffff;
+		rec.net = NULL;
+		rec.ifindex = 0;
 		memset(rec.dmac, 0, ETH_ALEN);
-		memset(rec.smac, 0, ETH_ALEN);
 		query->callback(status, &rec, query->context);
 	} else
 		query->callback(status, NULL, query->context);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cbd0383..5cee246 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -289,7 +289,7 @@ static ssize_t show_port_gid(struct ib_port *p, struct port_attribute *attr,
 	union ib_gid gid;
 	ssize_t ret;
 
-	ret = ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid);
+	ret = ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index abd9724..7d2f14c 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -141,8 +141,8 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 
-	memset(dst->smac, 0, sizeof(dst->smac));
 	memset(dst->dmac, 0, sizeof(dst->dmac));
-	dst->vlan_id = 0xffff;
+	dst->net = NULL;
+	dst->ifindex = 0;
 }
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f93eb8d..1fe3e71 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -229,8 +229,8 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = grh->sgid;
 
-		ret = ib_find_cached_gid(device, &grh->dgid, &port_num,
-					 &gid_index);
+		ret = ib_find_cached_gid(device, &grh->dgid, IB_GID_TYPE_IB,
+					 NULL, 0, &port_num, &gid_index);
 		if (ret)
 			return ret;
 
@@ -873,7 +873,8 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 	if ((*qp_attr_mask & IB_QP_AV)  &&
 	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
 		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
-				   qp_attr->ah_attr.grh.sgid_index, &sgid);
+				   qp_attr->ah_attr.grh.sgid_index, &sgid,
+				   NULL);
 		if (ret)
 			goto out;
 		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 02fc91c6..58a95b5 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2192,7 +2192,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		} else  {
 			err = ib_get_cached_gid(ib_dev,
 						be32_to_cpu(ah->av.ib.port_pd) >> 24,
-						ah->av.ib.gid_index, &sgid);
+						ah->av.ib.gid_index, &sgid,
+						NULL);
 			if (err)
 				return err;
 		}
@@ -2234,7 +2235,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			ib_get_cached_gid(ib_dev,
 					  be32_to_cpu(ah->av.ib.port_pd) >> 24,
 					  ah->av.ib.gid_index,
-					  &sqp->ud_header.grh.source_gid);
+					  &sqp->ud_header.grh.source_gid, NULL);
 		}
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 32f6c63..bcac294 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -281,7 +281,7 @@ int mthca_read_ah(struct mthca_dev *dev, struct mthca_ah *ah,
 		ib_get_cached_gid(&dev->ib_dev,
 				  be32_to_cpu(ah->av->port_pd) >> 24,
 				  ah->av->gid_index % dev->limits.gid_table_len,
-				  &header->grh.source_gid);
+				  &header->grh.source_gid, NULL);
 		memcpy(header->grh.destination_gid.raw,
 		       ah->av->dgid, 16);
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9e1b203..16242aa 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1610,7 +1610,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	priv->dev->broadcast[8] = priv->pkey >> 8;
 	priv->dev->broadcast[9] = priv->pkey & 0xff;
 
-	result = ib_query_gid(hca, port, 0, &priv->local_gid);
+	result = ib_query_gid(hca, port, 0, &priv->local_gid, NULL);
 	if (result) {
 		printk(KERN_WARNING "%s: ib_query_gid port %d failed (ret = %d)\n",
 		       hca->name, port, result);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 0d23e05..0323c2f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -530,7 +530,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	}
 	priv->local_lid = port_attr.lid;
 
-	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid))
+	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid, NULL))
 		ipoib_warn(priv, "ib_query_gid() failed\n");
 	else
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 918814c..79977aa 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3206,7 +3206,7 @@ static ssize_t srp_create_target(struct device *dev,
 	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
-	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
+	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid, NULL);
 	if (ret)
 		goto err;
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9b84b4c..8e13050 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -546,7 +546,8 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	sport->sm_lid = port_attr.sm_lid;
 	sport->lid = port_attr.lid;
 
-	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid);
+	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid,
+			   NULL);
 	if (ret)
 		goto err_query_port;
 
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index ad9a3c2..96009ca 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -36,6 +36,17 @@
 #define _IB_CACHE_H
 
 #include <rdma/ib_verbs.h>
+#include <net/net_namespace.h>
+
+/**
+ * ib_cache_use_roce_gid_table - Returns whether the device uses roce gid table
+ * @device: The device to query
+ * @port_num: The port number of the device to query.
+ *
+ * ib_cache_use_roce_gid_table() returns 0 if this port uses the roce_gid_table
+ * to store GIDs and error otherwise.
+ */
+int ib_cache_use_roce_gid_table(struct ib_device *device, u8 port_num);
 
 /**
  * ib_get_cached_gid - Returns a cached GID table entry
@@ -43,6 +54,7 @@
  * @port_num: The port number of the device to query.
  * @index: The index into the cached GID table to query.
  * @gid: The GID value found at the specified index.
+ * @attr: The GID attribute found at the specified index (only in RoCE).
  *
  * ib_get_cached_gid() fetches the specified GID table entry stored in
  * the local software cache.
@@ -50,13 +62,17 @@
 int ib_get_cached_gid(struct ib_device    *device,
 		      u8                   port_num,
 		      int                  index,
-		      union ib_gid        *gid);
+		      union ib_gid        *gid,
+		      struct ib_gid_attr  *attr);
 
 /**
  * ib_find_cached_gid - Returns the port number and GID table index where
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @gid_type: The GID type to search for.
+ * @net: In RoCE, the namespace of the device.
+ * @if_index: In RoCE, the if_index of the device. Zero means ignore.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the cached GID table where the GID was found.  This
  *   parameter may be NULL.
@@ -66,10 +82,36 @@ int ib_get_cached_gid(struct ib_device    *device,
  */
 int ib_find_cached_gid(struct ib_device *device,
 		       union ib_gid	*gid,
+		       enum ib_gid_type gid_type,
+		       struct net	  *net,
+		       int		   if_index,
 		       u8               *port_num,
 		       u16              *index);
 
 /**
+ * ib_find_cached_gid_by_port - Returns the GID table index where a specified
+ * GID value occurs
+ * @device: The device to query.
+ * @gid: The GID value to search for.
+ * @gid_type: The GID type to search for.
+ * @port_num: The port number of the device where the GID value sould be
+ *   searched.
+ * @net: In RoCE, the namespace of the device.
+ * @if_index: In RoCE, the if_index of the device. Zero means ignore.
+ * @index: The index into the cached GID table where the GID was found.  This
+ *   parameter may be NULL.
+ *
+ * ib_find_cached_gid() searches for the specified GID value in
+ * the local software cache.
+ */
+int ib_find_cached_gid_by_port(struct ib_device *device,
+			       union ib_gid	*gid,
+			       enum ib_gid_type gid_type,
+			       u8               port_num,
+			       struct net	*net,
+			       int		if_index,
+			       u16              *index);
+/**
  * ib_get_cached_pkey - Returns a cached PKey table entry
  * @device: The device to query.
  * @port_num: The port number of the device to query.
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 7e071a6..6a1b994 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -156,7 +156,9 @@ struct ib_sa_path_rec {
 	u8           preference;
 	u8           smac[ETH_ALEN];
 	u8           dmac[ETH_ALEN];
-	u16	     vlan_id;
+	u16          vlan_id;
+	int	     ifindex;
+	struct net  *net;
 };
 
 #define IB_SA_MCMEMBER_REC_MGID				IB_SA_COMP_MASK( 0)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f9afa91..9e7505a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -48,6 +48,7 @@
 #include <linux/rwsem.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
+#include <net/net_namespace.h>
 #include <uapi/linux/if_ether.h>
 
 #include <linux/atomic.h>
@@ -1805,7 +1806,8 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 					       u8 port_num);
 
 int ib_query_gid(struct ib_device *device,
-		 u8 port_num, int index, union ib_gid *gid);
+		 u8 port_num, int index, union ib_gid *gid,
+		 struct ib_gid_attr *attr);
 
 int ib_query_pkey(struct ib_device *device,
 		  u8 port_num, u16 index, u16 *pkey);
@@ -1819,7 +1821,8 @@ int ib_modify_port(struct ib_device *device,
 		   struct ib_port_modify *port_modify);
 
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index);
+		enum ib_gid_type gid_type, struct net *net,
+		int if_index, u8 *port_num, u16 *index);
 
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
