From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/9] rdma/cm: replace net_device pointer with index
Date: Mon, 16 Nov 2009 15:58:45 -0800
Message-ID: <15F2FB67E0744ADE90BFB2DF74A81305@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Provide the device interface when resolving route information to
ensure that the correct outbound device is used.  This will also
simplify processing of sin6_scope_id for IPv6 support.

Based on work from:
David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Jason Gunthorpe <jgunthrope-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/addr.c |   14 +++++++++++++-
 drivers/infiniband/core/cma.c  |    2 +-
 include/rdma/ib_addr.h         |    2 +-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index de16126..ccc0f91 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -107,7 +107,7 @@ int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
 	memcpy(dev_addr->broadcast, dev->broadcast, MAX_ADDR_LEN);
 	if (dst_dev_addr)
 		memcpy(dev_addr->dst_dev_addr, dst_dev_addr, MAX_ADDR_LEN);
-	dev_addr->src_dev = dev;
+	dev_addr->bound_dev_if = dev->ifindex;
 	return 0;
 }
 EXPORT_SYMBOL(rdma_copy_addr);
@@ -117,6 +117,15 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 	struct net_device *dev;
 	int ret = -EADDRNOTAVAIL;
 
+	if (dev_addr->bound_dev_if) {
+		dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+		if (!dev)
+			return -ENODEV;
+		ret = rdma_copy_addr(dev_addr, dev, NULL);
+		dev_put(dev);
+		return ret;
+	}
+
 	switch (addr->sa_family) {
 	case AF_INET:
 		dev = ip_dev_find(&init_net,
@@ -231,6 +240,8 @@ static int addr4_resolve_remote(struct sockaddr_in *src_in,
 	memset(&fl, 0, sizeof fl);
 	fl.nl_u.ip4_u.daddr = dst_ip;
 	fl.nl_u.ip4_u.saddr = src_ip;
+	fl.oif = addr->bound_dev_if;
+
 	ret = ip_route_output_key(&init_net, &rt, &fl);
 	if (ret)
 		goto out;
@@ -279,6 +290,7 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 	memset(&fl, 0, sizeof fl);
 	fl.nl_u.ip6_u.daddr = dst_in->sin6_addr;
 	fl.nl_u.ip6_u.saddr = src_in->sin6_addr;
+	fl.oif = addr->bound_dev_if;
 
 	dst = ip6_route_output(&init_net, NULL, &fl);
 	if (!dst)
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 052b4c0..699ad12 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2820,7 +2820,7 @@ static int cma_netdev_change(struct net_device *ndev, struct rdma_id_private *id
 
 	dev_addr = &id_priv->id.route.addr.dev_addr;
 
-	if ((dev_addr->src_dev == ndev) &&
+	if ((dev_addr->bound_dev_if == ndev->ifindex) &&
 	    memcmp(dev_addr->src_dev_addr, ndev->dev_addr, ndev->addr_len)) {
 		printk(KERN_INFO "RDMA CM addr change for ndev %s used by id %p\n",
 		       ndev->name, &id_priv->id);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 483057b..27f17cc 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -61,7 +61,7 @@ struct rdma_dev_addr {
 	unsigned char dst_dev_addr[MAX_ADDR_LEN];
 	unsigned char broadcast[MAX_ADDR_LEN];
 	enum rdma_node_type dev_type;
-	struct net_device *src_dev;
+	int bound_dev_if;
 };
 
 /**



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
