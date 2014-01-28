From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/CMA: Fix initialization of hop_limit instead of hardcode to 1.
Date: Tue, 28 Jan 2014 12:34:09 +0530
Message-ID: <90ba6b41-2a1a-4419-bb49-4ed8c216e2a7@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As suggested by Sean Hefty, take into account src/dst addresses on different 
subnets and set hop_limit in cma_resolve_iboe_route accordingly instead of
blind hardcode to 1 or any other value.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
Incorporated comments by Sean Hefty

 drivers/infiniband/core/addr.c |    5 +++++
 drivers/infiniband/core/cma.c  |    2 +-
 include/rdma/ib_addr.h         |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index e90f2b2..6fa4721 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -250,6 +250,8 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 		goto put;
 	}
 
+	addr->uses_gateway = rt->rt_uses_gateway;
+
 	ret = dst_fetch_ha(&rt->dst, addr, &fl4.daddr);
 put:
 	ip_rt_put(rt);
@@ -263,6 +265,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 			 struct rdma_dev_addr *addr)
 {
 	struct flowi6 fl6;
+	struct rt6_info *rt;
 	struct dst_entry *dst;
 	int ret;
 
@@ -275,6 +278,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 	if ((ret = dst->error))
 		goto put;
 
+	rt = (struct rt6_info *)dst;
 	if (ipv6_addr_any(&fl6.saddr)) {
 		ret = ipv6_dev_get_saddr(&init_net, ip6_dst_idev(dst)->dev,
 					 &fl6.daddr, 0, &fl6.saddr);
@@ -298,6 +302,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 		goto put;
 	}
 
+	addr->uses_gateway = rt->rt6i_flags & RTF_GATEWAY;
 	ret = dst_fetch_ha(dst, addr, &fl6.daddr);
 put:
 	dst_release(dst);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 8e49db6..ae60104 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1902,7 +1902,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	iboe_mac_vlan_to_ll(&route->path_rec->sgid, addr->dev_addr.src_dev_addr, vid);
 	iboe_mac_vlan_to_ll(&route->path_rec->dgid, addr->dev_addr.dst_dev_addr, vid);
 
-	route->path_rec->hop_limit = 1;
+	route->path_rec->hop_limit = addr->uses_gateway ? 0xFF : 1;
 	route->path_rec->reversible = 1;
 	route->path_rec->pkey = cpu_to_be16(0xffff);
 	route->path_rec->mtu_selector = IB_SA_EQ;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index f3ac0f2..24bc985 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -64,6 +64,7 @@ struct rdma_dev_addr {
 	unsigned char dst_dev_addr[MAX_ADDR_LEN];
 	unsigned char broadcast[MAX_ADDR_LEN];
 	unsigned short dev_type;
+	bool uses_gateway;
 	int bound_dev_if;
 	enum rdma_transport_type transport;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
