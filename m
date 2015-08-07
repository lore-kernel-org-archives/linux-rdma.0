From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 02/10] IB/core: Expose and rename ib_find_cached_gid_by_port cache API
Date: Fri,  7 Aug 2015 16:00:55 +0300
Message-ID: <1438952463-23707-3-git-send-email-matanb@mellanox.com>
References: <1438952463-23707-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438952463-23707-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sometime consumers might want to search for a GID in a specific port.
For example, when a WC arrives and we want to search the GID
that matches that port - it's better to search only the relevant
port.
Exposing and renaming ib_cache_gid_find_by_port in order to match
the naming convention of the module.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c     |  9 +++++----
 drivers/infiniband/core/core_priv.h |  5 -----
 drivers/infiniband/core/device.c    |  4 ++--
 include/rdma/ib_cache.h             | 19 +++++++++++++++++++
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 78fe196..639a8fb 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -409,10 +409,10 @@ static int ib_cache_gid_find(struct ib_device *ib_dev,
 					mask, port, index);
 }
 
-int ib_cache_gid_find_by_port(struct ib_device *ib_dev,
-			      const union ib_gid *gid,
-			      u8 port, struct net_device *ndev,
-			      u16 *index)
+int ib_find_cached_gid_by_port(struct ib_device *ib_dev,
+			       const union ib_gid *gid,
+			       u8 port, struct net_device *ndev,
+			       u16 *index)
 {
 	int local_index;
 	struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
@@ -438,6 +438,7 @@ int ib_cache_gid_find_by_port(struct ib_device *ib_dev,
 
 	return -ENOENT;
 }
+EXPORT_SYMBOL(ib_find_cached_gid_by_port);
 
 static struct ib_gid_table *alloc_gid_table(int sz)
 {
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0ebcd29..b968467 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -65,11 +65,6 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
 			      roce_netdev_callback cb,
 			      void *cookie);
 
-int ib_cache_gid_find_by_port(struct ib_device *ib_dev,
-			      const union ib_gid *gid,
-			      u8 port, struct net_device *ndev,
-			      u16 *index);
-
 enum ib_cache_gid_default_mode {
 	IB_CACHE_GID_DEFAULT_MODE_SET,
 	IB_CACHE_GID_DEFAULT_MODE_DELETE
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6fe360a..491068c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -806,8 +806,8 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
 		if (rdma_cap_roce_gid_table(device, port)) {
-			if (!ib_cache_gid_find_by_port(device, gid, port,
-						       ndev, index))
+			if (!ib_find_cached_gid_by_port(device, gid, port,
+							ndev, index))
 				*port_num = port;
 				return 0;
 		}
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index dcc9bed..679d7ca 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -75,6 +75,25 @@ int ib_find_cached_gid(struct ib_device *device,
 		       u16              *index);
 
 /**
+ * ib_find_cached_gid_by_port - Returns the GID table index where a specified
+ * GID value occurs
+ * @device: The device to query.
+ * @gid: The GID value to search for.
+ * @port_num: The port number of the device where the GID value sould be
+ *   searched.
+ * @ndev: In RoCE, the net device of the device. Null means ignore.
+ * @index: The index into the cached GID table where the GID was found.  This
+ *   parameter may be NULL.
+ *
+ * ib_find_cached_gid() searches for the specified GID value in
+ * the local software cache.
+ */
+int ib_find_cached_gid_by_port(struct ib_device *device,
+			       const union ib_gid *gid,
+			       u8               port_num,
+			       struct net_device *ndev,
+			       u16              *index);
+/**
  * ib_get_cached_pkey - Returns a cached PKey table entry
  * @device: The device to query.
  * @port_num: The port number of the device to query.
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
