From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH RFC] IB/core: Move start_port() and end_port() to head file
Date: Thu, 19 Mar 2015 15:33:09 +0100
Message-ID: <550ADE25.9060605@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

start_port() and end_port() has been defined in both 'cache.c' and
'device.c' with exactly the same implementation.

This patch move them to the head file 'core_priv.h' for all the IB
core files to utilize.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
  drivers/infiniband/core/cache.c     | 11 -----------
  drivers/infiniband/core/core_priv.h | 12 ++++++++++++
  drivers/infiniband/core/device.c    | 12 ------------
  3 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/core/cache.c 
b/drivers/infiniband/core/cache.c
index 80f6cf2..02315a1 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -58,17 +58,6 @@ struct ib_update_work {
      u8                 port_num;
  };

-static inline int start_port(struct ib_device *device)
-{
-    return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
-}
-
-static inline int end_port(struct ib_device *device)
-{
-    return (device->node_type == RDMA_NODE_IB_SWITCH) ?
-        0 : device->phys_port_cnt;
-}
-
  int ib_get_cached_gid(struct ib_device *device,
                u8                port_num,
                int               index,
diff --git a/drivers/infiniband/core/core_priv.h 
b/drivers/infiniband/core/core_priv.h
index 87d1936..3a74db0 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -51,4 +51,16 @@ void ib_cache_cleanup(void);

  int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
                  struct ib_qp_attr *qp_attr, int *qp_attr_mask);
+
+static inline int start_port(struct ib_device *device)
+{
+    return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
+}
+
+static inline int end_port(struct ib_device *device)
+{
+    return (device->node_type == RDMA_NODE_IB_SWITCH) ?
+        0 : device->phys_port_cnt;
+}
+
  #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c 
b/drivers/infiniband/core/device.c
index 18c1ece..2c29dea 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -151,18 +151,6 @@ static int alloc_name(char *name)
      return 0;
  }

-static int start_port(struct ib_device *device)
-{
-    return (device->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
-}
-
-
-static int end_port(struct ib_device *device)
-{
-    return (device->node_type == RDMA_NODE_IB_SWITCH) ?
-        0 : device->phys_port_cnt;
-}
-
  /**
   * ib_alloc_device - allocate an IB device struct
   * @size:size of structure to allocate
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
