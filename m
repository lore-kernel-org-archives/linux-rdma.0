From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 30/30] IB/cma: Join and leave multicast groups with IGMP
Date: Thu, 19 Feb 2015 15:56:09 +0530
Message-ID: <de3af747-fa37-4d26-8590-4e202dc223e7@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since RoCEv2 is a protocol over IP header it is required to send IGMP
join and leave requests to the network when joining and leaving
multicast groups.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   78 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 50635fe..6e658e8 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -38,6 +38,7 @@
 #include <linux/in6.h>
 #include <linux/mutex.h>
 #include <linux/random.h>
+#include <linux/igmp.h>
 #include <linux/idr.h>
 #include <linux/inetdevice.h>
 #include <linux/slab.h>
@@ -185,6 +186,7 @@ struct rdma_id_private {
 	u8			reuseaddr;
 	u8			afonly;
 	enum ib_gid_type	gid_type;
+	bool			igmp_joined;
 };
 
 struct cma_multicast {
@@ -283,6 +285,26 @@ static inline void cma_set_ip_ver(struct cma_hdr *hdr, u8 ip_ver)
 	hdr->ip_version = (ip_ver << 4) | (hdr->ip_version & 0xF);
 }
 
+static int cma_igmp_send(struct net_device *ndev, union ib_gid *mgid, bool join)
+{
+	struct in_device *in_dev = NULL;
+
+	if (ndev) {
+		rtnl_lock();
+		in_dev = __in_dev_get_rtnl(ndev);
+		if (in_dev) {
+			if (join)
+				ip_mc_inc_group(in_dev,
+						*(__be32 *)(mgid->raw+12));
+			else
+				ip_mc_dec_group(in_dev,
+						*(__be32 *)(mgid->raw+12));
+		}
+		rtnl_unlock();
+	}
+	return (in_dev) ? 0 : -ENODEV;
+}
+
 static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 			      struct cma_device *cma_dev)
 {
@@ -585,6 +607,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	INIT_LIST_HEAD(&id_priv->listen_list);
 	INIT_LIST_HEAD(&id_priv->mc_list);
 	get_random_bytes(&id_priv->seq_num, sizeof id_priv->seq_num);
+	id_priv->igmp_joined = false;
 
 	return &id_priv->id;
 }
@@ -1076,6 +1099,20 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 			kfree(mc);
 			break;
 		case IB_LINK_LAYER_ETHERNET:
+			if (id_priv->igmp_joined) {
+				struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
+				struct net_device *ndev = NULL;
+
+				if (dev_addr->bound_dev_if)
+					ndev = dev_get_by_index(&init_net,
+								dev_addr->bound_dev_if);
+				if (ndev) {
+					cma_igmp_send(ndev,
+						      &mc->multicast.ib->rec.mgid,
+						      false);
+					dev_put(ndev);
+				}
+			}
 			kref_put(&mc->mcref, release_mc);
 			break;
 		default:
@@ -3356,7 +3393,7 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 {
 	struct iboe_mcast_work *work;
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
-	int err;
+	int err = 0;
 	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
 	struct net_device *ndev = NULL;
 
@@ -3388,13 +3425,31 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	mc->multicast.ib->rec.rate = iboe_get_rate(ndev);
 	mc->multicast.ib->rec.hop_limit = 1;
 	mc->multicast.ib->rec.mtu = iboe_get_mtu(ndev->mtu);
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &mc->multicast.ib->rec.port_gid);
+
+	if (addr->sa_family == AF_INET) {
+		u16 sgid_index;
+
+		err = ib_find_cached_gid_by_port(id_priv->cma_dev->device,
+						 &mc->multicast.ib->rec.port_gid,
+						 IB_GID_TYPE_ROCE_V2,
+						 id_priv->id.port_num,
+						 &init_net, dev_addr->bound_dev_if,
+						 &sgid_index);
+		if (!err)
+			err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid, true);
+		if (!err) {
+			id_priv->igmp_joined = true;
+			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
+		}
+	}
 	dev_put(ndev);
-	if (!mc->multicast.ib->rec.mtu) {
+	if (err || !mc->multicast.ib->rec.mtu) {
 		err = -EINVAL;
 		goto out2;
 	}
-	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
-		    &mc->multicast.ib->rec.port_gid);
+
 	work->id = id_priv;
 	work->mc = mc;
 	INIT_WORK(&work->work, iboe_mcast_work_handler);
@@ -3486,6 +3541,21 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 					kfree(mc);
 					break;
 				case IB_LINK_LAYER_ETHERNET:
+					if (id_priv->igmp_joined) {
+						struct rdma_dev_addr *dev_addr = &id->route.addr.dev_addr;
+						struct net_device *ndev = NULL;
+
+						if (dev_addr->bound_dev_if)
+							ndev = dev_get_by_index(&init_net,
+										dev_addr->bound_dev_if);
+						if (ndev) {
+							cma_igmp_send(ndev,
+								      &mc->multicast.ib->rec.mgid,
+								      false);
+							dev_put(ndev);
+						}
+						id_priv->igmp_joined = false;
+					}
 					kref_put(&mc->mcref, release_mc);
 					break;
 				default:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
