From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] rdma/cm: Allow user to select specific RDMA loopback device
Date: Fri,  3 May 2013 15:19:51 -0700
Message-ID: <1367619592-2363-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

RDMA connections to a loopback address must map to a physical
RDMA device/port.  By default, a connection to a loopback address
automatically binds the corresponding cm_id to the first active
RDMA device/port.  The result is that all loopback connections
are forced to use the same device, even if multiple devices
are present.

In order to map loopback connections across multiple RDMA devices,
we expose the mapping directly to the user.  For IPv4, we make use
of the multiple loopback addresses which are available, with
each loopback address matched with a specific RDMA device/port.
For IPv6, we use the scope ID as an index into the RDMA CM
device/port list.

For compatibility, if the IPv4 loopback address is the common
localhost (127.0.0.1) address or if no scope ID is given, we follow
the current algorithm of selecting the first active device/port.
Otherwise, the address/scope ID is used as an index into the
device/port list.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 71c2c71..7203a0f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1913,13 +1913,27 @@ err:
 }
 EXPORT_SYMBOL(rdma_resolve_route);
 
+static int cma_loopback_index(struct rdma_id_private *id_priv)
+{
+	struct sockaddr *addr = (struct sockaddr *) &id_priv->id.route.addr.dst_addr;
+
+	if (addr->sa_family == AF_INET)
+		return ntohl(((struct sockaddr_in *) addr)->sin_addr.s_addr) -
+		       INADDR_LOOPBACK;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (addr->sa_family == AF_INET6)
+		return ((struct sockaddr_in6 *) addr)->sin6_scope_id;
+#endif
+	return 0;
+}
+
 static int cma_bind_loopback(struct rdma_id_private *id_priv)
 {
 	struct cma_device *cma_dev;
 	struct ib_port_attr port_attr;
 	union ib_gid gid;
 	u16 pkey;
-	int ret;
+	int ret, index;
 	u8 p;
 
 	mutex_lock(&lock);
@@ -1927,6 +1941,17 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 		ret = -ENODEV;
 		goto out;
 	}
+
+	index = cma_loopback_index(id_priv);
+	if (index) {
+		list_for_each_entry(cma_dev, &dev_list, list) {
+			if (index <= cma_dev->device->phys_port_cnt) {
+				p = index;
+				goto port_found;
+			}
+			index -= cma_dev->device->phys_port_cnt;
+		}
+	}
 	list_for_each_entry(cma_dev, &dev_list, list)
 		for (p = 1; p <= cma_dev->device->phys_port_cnt; ++p)
 			if (!ib_query_port(cma_dev->device, p, &port_attr) &&
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
