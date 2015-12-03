From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 11/11] IB/cma: Join and leave multicast groups with IGMP
Date: Thu,  3 Dec 2015 15:47:30 +0200
Message-ID: <1449150450-13679-24-git-send-email-matanb@mellanox.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449150450-13679-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since RoCEv2 is a protocol over IP header it is required to send IGMP
join and leave requests to the network when joining and leaving
multicast groups.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c       | 96 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/multicast.c | 17 ++++++-
 include/rdma/ib_sa.h                |  2 +
 3 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 8fab267..c30bfe3 100644
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
@@ -304,6 +305,7 @@ struct cma_multicast {
 	void			*context;
 	struct sockaddr_storage	addr;
 	struct kref		mcref;
+	bool			igmp_joined;
 };
 
 struct cma_work {
@@ -400,6 +402,26 @@ static inline void cma_set_ip_ver(struct cma_hdr *hdr, u8 ip_ver)
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
+						*(__be32 *)(mgid->raw + 12));
+			else
+				ip_mc_dec_group(in_dev,
+						*(__be32 *)(mgid->raw + 12));
+		}
+		rtnl_unlock();
+	}
+	return (in_dev) ? 0 : -ENODEV;
+}
+
 static void _cma_attach_to_dev(struct rdma_id_private *id_priv,
 			       struct cma_device *cma_dev)
 {
@@ -1535,8 +1557,24 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 				      id_priv->id.port_num)) {
 			ib_sa_free_multicast(mc->multicast.ib);
 			kfree(mc);
-		} else
+		} else {
+			if (mc->igmp_joined) {
+				struct rdma_dev_addr *dev_addr =
+					&id_priv->id.route.addr.dev_addr;
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
+		}
 	}
 }
 
@@ -3656,12 +3694,23 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	event.status = status;
 	event.param.ud.private_data = mc->context;
 	if (!status) {
+		struct rdma_dev_addr *dev_addr =
+			&id_priv->id.route.addr.dev_addr;
+		struct net_device *ndev =
+			dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+		enum ib_gid_type gid_type =
+			id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
+			rdma_start_port(id_priv->cma_dev->device)];
+
 		event.event = RDMA_CM_EVENT_MULTICAST_JOIN;
 		ib_init_ah_from_mcmember(id_priv->id.device,
 					 id_priv->id.port_num, &multicast->rec,
+					 ndev, gid_type,
 					 &event.param.ud.ah_attr);
 		event.param.ud.qp_num = 0xFFFFFF;
 		event.param.ud.qkey = be32_to_cpu(multicast->rec.qkey);
+		if (ndev)
+			dev_put(ndev);
 	} else
 		event.event = RDMA_CM_EVENT_MULTICAST_ERROR;
 
@@ -3794,9 +3843,10 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 {
 	struct iboe_mcast_work *work;
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
-	int err;
+	int err = 0;
 	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
 	struct net_device *ndev = NULL;
+	enum ib_gid_type gid_type;
 
 	if (cma_zero_addr((struct sockaddr *)&mc->addr))
 		return -EINVAL;
@@ -3826,9 +3876,25 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	mc->multicast.ib->rec.rate = iboe_get_rate(ndev);
 	mc->multicast.ib->rec.hop_limit = 1;
 	mc->multicast.ib->rec.mtu = iboe_get_mtu(ndev->mtu);
+
+	gid_type = id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
+		   rdma_start_port(id_priv->cma_dev->device)];
+	if (addr->sa_family == AF_INET) {
+		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
+			err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid,
+					    true);
+		if (!err) {
+			mc->igmp_joined = true;
+			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
+		}
+	} else {
+		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
+			err = -ENOTSUPP;
+	}
 	dev_put(ndev);
-	if (!mc->multicast.ib->rec.mtu) {
-		err = -EINVAL;
+	if (err || !mc->multicast.ib->rec.mtu) {
+		if (!err)
+			err = -EINVAL;
 		goto out2;
 	}
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
@@ -3867,7 +3933,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	memcpy(&mc->addr, addr, rdma_addr_size(addr));
 	mc->context = context;
 	mc->id_priv = id_priv;
-
+	mc->igmp_joined = false;
 	spin_lock(&id_priv->lock);
 	list_add(&mc->list, &id_priv->mc_list);
 	spin_unlock(&id_priv->lock);
@@ -3912,9 +3978,25 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 			if (rdma_cap_ib_mcast(id->device, id->port_num)) {
 				ib_sa_free_multicast(mc->multicast.ib);
 				kfree(mc);
-			} else if (rdma_protocol_roce(id->device, id->port_num))
+			} else if (rdma_protocol_roce(id->device, id->port_num)) {
+				if (mc->igmp_joined) {
+					struct rdma_dev_addr *dev_addr =
+						&id->route.addr.dev_addr;
+					struct net_device *ndev = NULL;
+
+					if (dev_addr->bound_dev_if)
+						ndev = dev_get_by_index(&init_net,
+									dev_addr->bound_dev_if);
+					if (ndev) {
+						cma_igmp_send(ndev,
+							      &mc->multicast.ib->rec.mgid,
+							      false);
+						dev_put(ndev);
+					}
+					mc->igmp_joined = false;
+				}
 				kref_put(&mc->mcref, release_mc);
-
+			}
 			return;
 		}
 	}
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 6911ae6..250937c 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -723,14 +723,27 @@ EXPORT_SYMBOL(ib_sa_get_mcmember_rec);
 
 int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 			     struct ib_sa_mcmember_rec *rec,
+			     struct net_device *ndev,
+			     enum ib_gid_type gid_type,
 			     struct ib_ah_attr *ah_attr)
 {
 	int ret;
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid, IB_GID_TYPE_IB,
-				 NULL, &p, &gid_index);
+	if (rdma_protocol_roce(device, port_num)) {
+		ret = ib_find_cached_gid_by_port(device, &rec->port_gid,
+						 gid_type, port_num,
+						 ndev,
+						 &gid_index);
+	} else if (rdma_protocol_ib(device, port_num)) {
+		ret = ib_find_cached_gid(device, &rec->port_gid,
+					 IB_GID_TYPE_IB, NULL, &p,
+					 &gid_index);
+	} else {
+		ret = -EINVAL;
+	}
+
 	if (ret)
 		return ret;
 
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 0a40ed2..cdc1c81 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -403,6 +403,8 @@ int ib_sa_get_mcmember_rec(struct ib_device *device, u8 port_num,
  */
 int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 			     struct ib_sa_mcmember_rec *rec,
+			     struct net_device *ndev,
+			     enum ib_gid_type gid_type,
 			     struct ib_ah_attr *ah_attr);
 
 /**
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
