From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/9] ib/addr: store net_device type instead of translating to RDMA transport
Date: Mon, 16 Nov 2009 16:02:08 -0800
Message-ID: <A1FD692E247847A4973F2EE7AD3294B0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The struct rdma_dev_addr stores net_device address information:
the source device address, destination hardware address, and
broadcast address.  For consistency, store the net_device type
rather than converting it to the rdma_node_type.

The type indicates the format of the various hardware addresses,
which is what we're concerned with, and not the RDMA node type
that the address may map to.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/addr.c |   13 +------------
 drivers/infiniband/core/cma.c  |    6 +++---
 include/rdma/ib_addr.h         |    3 ++-
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f5baf0b..4febc0e 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -36,7 +36,6 @@
 #include <linux/mutex.h>
 #include <linux/inetdevice.h>
 #include <linux/workqueue.h>
-#include <linux/if_arp.h>
 #include <net/arp.h>
 #include <net/neighbour.h>
 #include <net/route.h>
@@ -92,17 +91,7 @@ EXPORT_SYMBOL(rdma_addr_unregister_client);
 int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
 		     const unsigned char *dst_dev_addr)
 {
-	switch (dev->type) {
-	case ARPHRD_INFINIBAND:
-		dev_addr->dev_type = RDMA_NODE_IB_CA;
-		break;
-	case ARPHRD_ETHER:
-		dev_addr->dev_type = RDMA_NODE_RNIC;
-		break;
-	default:
-		return -EADDRNOTAVAIL;
-	}
-
+	dev_addr->dev_type = dev->type;
 	memcpy(dev_addr->src_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
 	memcpy(dev_addr->broadcast, dev->broadcast, MAX_ADDR_LEN);
 	if (dst_dev_addr)
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 699ad12..b305b5c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -330,11 +330,11 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	union ib_gid gid;
 	int ret = -ENODEV;
 
-	switch (rdma_node_get_transport(dev_addr->dev_type)) {
-	case RDMA_TRANSPORT_IB:
+	switch (dev_addr->dev_type) {
+	case ARPHRD_INFINIBAND:
 		ib_addr_get_sgid(dev_addr, &gid);
 		break;
-	case RDMA_TRANSPORT_IWARP:
+	case ARPHRD_ETHER:
 		iw_addr_get_sgid(dev_addr, &gid);
 		break;
 	default:
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 27f17cc..3a39c55 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -36,6 +36,7 @@
 
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/if_arp.h>
 #include <linux/netdevice.h>
 #include <linux/socket.h>
 #include <rdma/ib_verbs.h>
@@ -60,7 +61,7 @@ struct rdma_dev_addr {
 	unsigned char src_dev_addr[MAX_ADDR_LEN];
 	unsigned char dst_dev_addr[MAX_ADDR_LEN];
 	unsigned char broadcast[MAX_ADDR_LEN];
-	enum rdma_node_type dev_type;
+	unsigned short dev_type;
 	int bound_dev_if;
 };
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
