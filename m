From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/4] IB/core: export ib_get_cached_port_state
Date: Mon, 12 Dec 2016 14:19:05 +0200
Message-ID: <b5fbdcba-dffe-241f-5c4f-184b93c1cd73@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 025db27..1b064cf 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1025,6 +1025,24 @@ int ib_get_cached_lmc(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_lmc);

+int ib_get_cached_port_state(struct ib_device   *device,
+                 u8                  port_num,
+                 enum ib_port_state *port_state)
Can you please fix the style (indentation)

+{
+    unsigned long flags;
+    int ret = 0;
+
+    if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
+        return -EINVAL;
+
+    read_lock_irqsave(&device->cache.lock, flags);
+    *port_state = device->cache.port_state_cache[port_num -
rdma_start_port(device)];
+    read_unlock_irqrestore(&device->cache.lock, flags);
+
+    return ret;
Why do you need ret? just return 0.

+}
+EXPORT_SYMBOL(ib_get_cached_port_state);
+
 static void ib_cache_update(struct ib_device *device,
                 u8                port)
 {
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index e30f19b..385ec88 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -165,4 +165,17 @@ int ib_get_cached_lmc(struct ib_device *device,
               u8                port_num,
               u8                *lmc);

+/**
+ * ib_get_cached_port_state - Returns a cached port state table entry
+ * @device: The device to query.
+ * @port_num: The port number of the device to query.
+ * @port_state: port_state for the specified port for that device.
+ *
+ * ib_get_cached_port_state() fetches the specified port_state table
entry stored in
+ * the local software cache.
+ */
+int ib_get_cached_port_state(struct ib_device *device,
+                  u8                port_num,
+                  enum ib_port_state *port_active);
+
 #endif /* _IB_CACHE_H */
-- 
2.7.4


Mark.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
