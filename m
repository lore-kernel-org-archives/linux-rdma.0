From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 05/10] IB/cma: cma_validate_port should verify the port and netdevice
Date: Fri,  7 Aug 2015 16:00:58 +0300
Message-ID: <1438952463-23707-6-git-send-email-matanb@mellanox.com>
References: <1438952463-23707-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438952463-23707-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously, cma_validate_port searched for GIDs in IB cache and then
tried to verify the found port. This could fail when there are
identical GIDs on both ports. In addition, netdevice should be taken
into account when searching the GID table.
Fixing cma_validate_port to search only the relevant port's cache
and netdevice.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 131f658..bbd3d53 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -378,10 +378,11 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 }
 
 static inline int cma_validate_port(struct ib_device *device, u8 port,
-				      union ib_gid *gid, int dev_type)
+				      union ib_gid *gid, int dev_type,
+				      int bound_if_index)
 {
-	u8 found_port;
 	int ret = -ENODEV;
+	struct net_device *ndev = NULL;
 
 	if ((dev_type == ARPHRD_INFINIBAND) && !rdma_protocol_ib(device, port))
 		return ret;
@@ -389,9 +390,13 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
 	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
 		return ret;
 
-	ret = ib_find_cached_gid(device, gid, NULL, &found_port, NULL);
-	if (port != found_port)
-		return -ENODEV;
+	if (dev_type == ARPHRD_ETHER)
+		ndev = dev_get_by_index(&init_net, bound_if_index);
+
+	ret = ib_find_cached_gid_by_port(device, gid, port, ndev, NULL);
+
+	if (ndev)
+		dev_put(ndev);
 
 	return ret;
 }
@@ -423,7 +428,8 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 		       &iboe_gid : &gid;
 
 		ret = cma_validate_port(cma_dev->device, port, gidp,
-					dev_addr->dev_type);
+					dev_addr->dev_type,
+					dev_addr->bound_dev_if);
 		if (!ret) {
 			id_priv->id.port_num = port;
 			goto out;
@@ -441,7 +447,8 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 			       &iboe_gid : &gid;
 
 			ret = cma_validate_port(cma_dev->device, port, gidp,
-						dev_addr->dev_type);
+						dev_addr->dev_type,
+						dev_addr->bound_dev_if);
 			if (!ret) {
 				id_priv->id.port_num = port;
 				goto out;
@@ -1946,8 +1953,11 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
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
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
