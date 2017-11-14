From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 23/31] RDMA/{core, cma}: Simplify rdma_translate_ip
Date: Tue, 14 Nov 2017 14:52:10 +0200
Message-ID: <20171114125218.20477-24-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since no caller needs vlan, rdma_translate_ip is simplified to avoid
vlan pointer.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 11 +++--------
 drivers/infiniband/core/cma.c  |  4 ++--
 include/rdma/ib_addr.h         |  2 +-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index e0086901d64c..0ae18608761c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -243,8 +243,7 @@ void rdma_copy_addr(struct rdma_dev_addr *dev_addr,
 EXPORT_SYMBOL(rdma_copy_addr);
 
 int rdma_translate_ip(const struct sockaddr *addr,
-		      struct rdma_dev_addr *dev_addr,
-		      u16 *vlan_id)
+		      struct rdma_dev_addr *dev_addr)
 {
 	struct net_device *dev;
 
@@ -267,8 +266,6 @@ int rdma_translate_ip(const struct sockaddr *addr,
 
 		rdma_copy_addr(dev_addr, dev, NULL);
 		dev_addr->bound_dev_if = dev->ifindex;
-		if (vlan_id)
-			*vlan_id = rdma_vlan_dev_vlan_id(dev);
 		dev_put(dev);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -280,8 +277,6 @@ int rdma_translate_ip(const struct sockaddr *addr,
 					  dev, 1)) {
 				rdma_copy_addr(dev_addr, dev, NULL);
 				dev_addr->bound_dev_if = dev->ifindex;
-				if (vlan_id)
-					*vlan_id = rdma_vlan_dev_vlan_id(dev);
 				break;
 			}
 		}
@@ -481,7 +476,7 @@ static int addr_resolve_neigh(struct dst_entry *dst,
 	if (dst->dev->flags & IFF_LOOPBACK) {
 		int ret;
 
-		ret = rdma_translate_ip(dst_in, addr, NULL);
+		ret = rdma_translate_ip(dst_in, addr);
 		if (!ret)
 			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
 			       MAX_ADDR_LEN);
@@ -558,7 +553,7 @@ static int addr_resolve(struct sockaddr *src_in,
 	}
 
 	if (ndev->flags & IFF_LOOPBACK) {
-		ret = rdma_translate_ip(dst_in, addr, NULL);
+		ret = rdma_translate_ip(dst_in, addr);
 		/*
 		 * Put the loopback device and get the translated
 		 * device instead.
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 48f593bafe33..19769ea4d71f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -601,7 +601,7 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 	int ret;
 
 	if (addr->sa_family != AF_IB) {
-		ret = rdma_translate_ip(addr, dev_addr, NULL);
+		ret = rdma_translate_ip(addr, dev_addr);
 	} else {
 		cma_translate_ib((struct sockaddr_ib *) addr, dev_addr);
 		ret = 0;
@@ -2131,7 +2131,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
 	conn_id->state = RDMA_CM_CONNECT;
 
-	ret = rdma_translate_ip(laddr, &conn_id->id.route.addr.dev_addr, NULL);
+	ret = rdma_translate_ip(laddr, &conn_id->id.route.addr.dev_addr);
 	if (ret) {
 		mutex_unlock(&conn_id->handler_mutex);
 		rdma_destroy_id(new_cm_id);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 3d17073ea338..dc0b642e0175 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -94,7 +94,7 @@ struct rdma_dev_addr {
  * The dev_addr->net field must be initialized.
  */
 int rdma_translate_ip(const struct sockaddr *addr,
-		      struct rdma_dev_addr *dev_addr, u16 *vlan_id);
+		      struct rdma_dev_addr *dev_addr);
 
 /**
  * rdma_resolve_ip - Resolve source and destination IP addresses to
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
