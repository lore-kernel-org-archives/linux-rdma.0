From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 32/32] IB/cma: Join and leave multicast groups with IGMP
Date: Wed, 11 Mar 2015 10:26:24 +0530
Message-ID: <c3b93263-9f7b-49a0-bea6-8044109a8908@CMEXHTCAS2.ad.emulex.com>
References: <1426049785-30364-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426049785-30364-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
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
 drivers/infiniband/core/cma.c       | 78 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/multicast.c | 18 ++++++++-
 include/rdma/ib_sa.h                |  3 ++
 3 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 2bfe798..bc30bc5 100644
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
@@ -196,6 +197,7 @@ struct cma_multicast {
 	void			*context;
 	struct sockaddr_storage	addr;
 	struct kref		mcref;
+	bool			igmp_joined;
 };
 
 struct cma_work {
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
@@ -1076,6 +1098,20 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 			kfree(mc);
 			break;
 		case IB_LINK_LAYER_ETHERNET:
+			if (mc->igmp_joined) {
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
@@ -3356,7 +3392,7 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 {
 	struct iboe_mcast_work *work;
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
-	int err;
+	int err = 0;
 	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
 	struct net_device *ndev = NULL;
 
@@ -3388,13 +3424,30 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	mc->multicast.ib->rec.rate = iboe_get_rate(ndev);
 	mc->multicast.ib->rec.hop_limit = 1;
 	mc->multicast.ib->rec.mtu = iboe_get_mtu(ndev->mtu);
+	mc->multicast.ib->rec.ifindex = dev_addr->bound_dev_if;
+	mc->multicast.ib->rec.net = &init_net;
+	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
+		    &mc->multicast.ib->rec.port_gid);
+
+	if (addr->sa_family == AF_INET) {
+		mc->multicast.ib->rec.gid_type =
+			id_priv->cma_dev->default_gid_type;
+		if (mc->multicast.ib->rec.gid_type == IB_GID_TYPE_ROCE_V2)
+			err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid,
+					    true);
+		if (!err) {
+			mc->igmp_joined = true;
+			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
+		}
+	} else {
+		mc->multicast.ib->rec.gid_type = IB_GID_TYPE_IB;
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
@@ -3429,7 +3482,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	memcpy(&mc->addr, addr, rdma_addr_size(addr));
 	mc->context = context;
 	mc->id_priv = id_priv;
-
+	mc->igmp_joined = false;
 	spin_lock(&id_priv->lock);
 	list_add(&mc->list, &id_priv->mc_list);
 	spin_unlock(&id_priv->lock);
@@ -3486,6 +3539,21 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 					kfree(mc);
 					break;
 				case IB_LINK_LAYER_ETHERNET:
+					if (mc->igmp_joined) {
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
+						mc->igmp_joined = false;
+					}
 					kref_put(&mc->mcref, release_mc);
 					break;
 				default:
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index f1927f1..9cbee6c 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -729,8 +729,22 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid, IB_GID_TYPE_IB,
-				 NULL, 0, &p, &gid_index);
+	switch (rdma_port_get_link_layer(device, port_num)) {
+	case IB_LINK_LAYER_ETHERNET:
+		ret = ib_find_cached_gid_by_port(device, &rec->port_gid,
+						 rec->gid_type, port_num,
+						 rec->net, rec->ifindex,
+						 &gid_index);
+		break;
+	case IB_LINK_LAYER_INFINIBAND:
+		ret = ib_find_cached_gid(device, &rec->port_gid,
+					 IB_GID_TYPE_IB, NULL, 0, &p,
+					 &gid_index);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
 	if (ret)
 		return ret;
 
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 61bc231..653d538 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -198,6 +198,9 @@ struct ib_sa_mcmember_rec {
 	u8           scope;
 	u8           join_state;
 	int          proxy_join;
+	int	     ifindex;
+	struct net  *net;
+	enum ib_gid_type gid_type;
 };
 
 /* Service Record Component Mask Sec 15.2.5.14 Ver 1.1	*/
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
