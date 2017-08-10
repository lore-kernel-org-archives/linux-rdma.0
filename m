From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 13/33] RDMA/core: Add iterator over ib_devices
Date: Thu, 10 Aug 2017 14:08:07 +0300
Message-ID: <20170810110827.9952-14-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The coming nldev needs to iterate over all IB devices in the system
and in order to not expose the ib_devices list outside the devices.c,
it is necessary to provide function iterator.

Current version is written explicitly for nldev callback to avoid
over-engineering at this stage, but it can be easily extended for
other types.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  8 ++++++++
 drivers/infiniband/core/device.c    | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index e759c27113cd..0c175590cf92 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -102,6 +102,14 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
 			      roce_netdev_callback cb,
 			      void *cookie);
 
+typedef int (*nldev_callback)(struct ib_device *device,
+			      struct sk_buff *skb,
+			      struct netlink_callback *cb,
+			      unsigned int idx);
+
+int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
+		     struct netlink_callback *cb);
+
 enum ib_cache_gid_default_mode {
 	IB_CACHE_GID_DEFAULT_MODE_SET,
 	IB_CACHE_GID_DEFAULT_MODE_DELETE
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 33a39518848c..8828f26250a8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -892,6 +892,31 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
 	up_read(&lists_rwsem);
 }
 
+/**
+ * ib_enum_all_devs - enumerate all ib_devices
+ * @cb: Callback to call for each found ib_device
+ *
+ * Enumerates all ib_devices and calls callback() on each device.
+ */
+int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
+		     struct netlink_callback *cb)
+{
+	struct ib_device *dev;
+	unsigned int idx = 0;
+	int ret = 0;
+
+	down_read(&lists_rwsem);
+	list_for_each_entry(dev, &device_list, core_list) {
+		ret = nldev_cb(dev, skb, cb, idx);
+		if (ret)
+			break;
+		idx++;
+	}
+
+	up_read(&lists_rwsem);
+	return ret;
+}
+
 /**
  * ib_query_pkey - Get P_Key table entry
  * @device:Device to query
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
