From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] RDMA/core: Remove RoCE support from rdma_addr_get_sgid()
Date: Tue,  9 Jan 2018 13:10:56 +0200
Message-ID: <20180109111058.29534-2-leon@kernel.org>
References: <20180109111058.29534-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109111058.29534-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are number of issues with RoCE support in rdma_addr_get_sgid() call:

1. With IP based GIDs, SGID derived using iboe_addr_get_sgid() was
not used in connection establishment process. SGID was always derived
using ip2gid().

2. It returns the first IP address of the netdevice, while netdevice
can have multiple IP addresses and connection could have been established
using non first IP address.

3. It returns SGID based on IPv4 address. It doesn't cover IPv6 addresses.

4. As the comment of rdma_dev_addr src_dev_addr and dst_dev_addr suggest,
such members of rdma_dev_addr stores the mac address. Therefore it is not
the best place to store the RoCE GIDs. RoCE GIDs are derived from the IP
addresses and they are already available in cm_id->route->addr.***_addr.

It was only used to return SGID to rds/ib.c and ucma.c modules, where it
returned incorrect SGID in above matching conditions.

Therefore code is simplified to not support RoCE.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_addr.h | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index dc0b642e0175..fa809a7b48e7 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -197,34 +197,17 @@ static inline void rdma_gid2ip(struct sockaddr *out, const union ib_gid *gid)
 	}
 }
 
-static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
+/*
+ * rdma_get/set_sgid/dgid() APIs are applicable to IB and iWARP.
+ * They are not applicable to RoCE, because RoCE GIDs are derived
+ * from the IP addresses.
+ */
+static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr,
 				      union ib_gid *gid)
 {
-	struct net_device *dev;
-	struct in_device *ip4;
-
-	dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
-	if (dev) {
-		ip4 = in_dev_get(dev);
-		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
-			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
-					       (struct in6_addr *)gid);
-
-		if (ip4)
-			in_dev_put(ip4);
-
-		dev_put(dev);
-	}
-}
-
-static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
-{
-	if (dev_addr->transport == RDMA_TRANSPORT_IB &&
-	    dev_addr->dev_type != ARPHRD_INFINIBAND)
-		iboe_addr_get_sgid(dev_addr, gid);
-	else
-		memcpy(gid, dev_addr->src_dev_addr +
-		       rdma_addr_gid_offset(dev_addr), sizeof *gid);
+	memcpy(gid,
+	       dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr),
+	       sizeof(*gid));
 }
 
 static inline void rdma_addr_set_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
