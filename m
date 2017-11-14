From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 02/31] IB/{core/cm}: Fix dmac query for IPv6 link local destination
Date: Tue, 14 Nov 2017 14:51:49 +0200
Message-ID: <20171114125218.20477-3-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ib_init_ah_from_wc() is querying dmac address for IPv6 link local
destination address and for all other address type without any association
with netdevice.
For resolving IPv6 link local address to its mac address, it is must to
provide the link local interface index as required by IPv6 stack.
Currently rdma_cm based RoCE applications fails to establish connection
using IPv6 link local addresses. This problem is described at [1].

Also, for rest of the IPv4 and IPv6 addresses, it is necessary to
consider netdevice from which the MAD packet is received.

Therefore, this patch refers to the GID index from wc. Each RoCE GID is
associated with respective netdevice. Patch uses the netdevice of such GID
entry to ensure that dmac resolve happens using netdevice of
received packet.
RoCE GID table management ensures that right upper netdevices of the
physical netdevices are added. Therefore init_ah_from_wc doesn't need to
perform such check.

Now that route lookup is done based on the netdevice of the GID entry,
simplify code to not have ifindex and vlan pointers.
As part of that, refactor to have netdevice as input parameter.
This is already discussed at [2].

Finally ib_init_ah_from_wc resolves dmac for unicast GID in similar way
as what ib_resolve_eth_dmac() does. So ib_resolve_eth_dmac is refactored
to split for unicast and non unicast GIDs, so that it can be reused by
ib_init_ah_from_wc.
While we are at refactoring ib_resolve_eth_dmac(), it is further
simplified
(a) to avoid hoplimit as optional parameter, as there is only one
user who always queries hoplimit.
(b) for empty line.
(c) avoided zero initialization of ret.
(d) removed as exported symbol as only ib core uses it.

For IPv6, this is tested using simple rping test as below.
rping -sv -a ::0
rping -c -a fe80::268a:7ff:fe55:4661%ens2f1 -C 1 -v -d

[1] https://www.spinics.net/lists/linux-rdma/msg45690.html
[2] https://www.spinics.net/lists/linux-rdma/msg45710.html

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c  |  24 ++-----
 drivers/infiniband/core/verbs.c | 136 +++++++++++++++++-----------------------
 include/rdma/ib_addr.h          |   2 +-
 3 files changed, 64 insertions(+), 98 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f4e8185bccd3..da4469c38eac 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -761,27 +761,23 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
 
 int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 				 const union ib_gid *dgid,
-				 u8 *dmac, u16 *vlan_id, int *if_index,
+				 u8 *dmac, const struct net_device *ndev,
 				 int *hoplimit)
 {
-	int ret = 0;
 	struct rdma_dev_addr dev_addr;
 	struct resolve_cb_context ctx;
-	struct net_device *dev;
-
 	union {
 		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
-
+	int ret;
 
 	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
 	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
-	if (if_index)
-		dev_addr.bound_dev_if = *if_index;
+	dev_addr.bound_dev_if = ndev->ifindex;
 	dev_addr.net = &init_net;
 
 	ctx.addr = &dev_addr;
@@ -798,19 +794,9 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 		return ret;
 
 	memcpy(dmac, dev_addr.dst_dev_addr, ETH_ALEN);
-	dev = dev_get_by_index(&init_net, dev_addr.bound_dev_if);
-	if (!dev)
-		return -ENODEV;
-	if (if_index)
-		*if_index = dev_addr.bound_dev_if;
-	if (vlan_id)
-		*vlan_id = rdma_vlan_dev_vlan_id(dev);
-	if (hoplimit)
-		*hoplimit = dev_addr.hoplimit;
-	dev_put(dev);
-	return ret;
+	*hoplimit = dev_addr.hoplimit;
+	return 0;
 }
-EXPORT_SYMBOL(rdma_addr_find_l2_eth_by_grh);
 
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
 {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3fb8fb6cc824..54b56c4fcc38 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -481,6 +481,40 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
 }
 EXPORT_SYMBOL(ib_get_gids_from_rdma_hdr);
 
+/* Resolve destination mac address and hop limit for unicast destination
+ * GID entry, considering the source GID entry as well.
+ * ah_attribute must have have valid port_num, sgid_index.
+ */
+static int ib_resolve_unicast_gid_dmac(struct ib_device *device,
+				       struct rdma_ah_attr *ah_attr)
+{
+	struct ib_gid_attr sgid_attr;
+	struct ib_global_route *grh;
+	int hop_limit = 0xff;
+	union ib_gid sgid;
+	int ret;
+
+	grh = rdma_ah_retrieve_grh(ah_attr);
+
+	ret = ib_query_gid(device,
+			   rdma_ah_get_port_num(ah_attr),
+			   grh->sgid_index,
+			   &sgid, &sgid_attr);
+	if (ret || !sgid_attr.ndev) {
+		if (!ret)
+			ret = -ENXIO;
+		return ret;
+	}
+
+	ret = rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
+					   ah_attr->roce.dmac,
+					   sgid_attr.ndev, &hop_limit);
+	dev_put(sgid_attr.ndev);
+
+	grh->hop_limit = hop_limit;
+	return ret;
+}
+
 /*
  * This function creates ah from the incoming packet.
  * Incoming packet has dgid of the receiver node on which this code is
@@ -490,9 +524,6 @@ EXPORT_SYMBOL(ib_get_gids_from_rdma_hdr);
  * as sgid and, sgid is used as dgid because sgid contains destinations
  * GID whom to respond to.
  *
- * This is why when calling rdma_addr_find_l2_eth_by_grh() function, the
- * position of arguments dgid and sgid do not match the order of the
- * parameters.
  */
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		       const struct ib_wc *wc, const struct ib_grh *grh,
@@ -523,57 +554,33 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 	if (ret)
 		return ret;
 
+	rdma_ah_set_sl(ah_attr, wc->sl);
+	rdma_ah_set_port_num(ah_attr, port_num);
+
 	if (rdma_protocol_roce(device, port_num)) {
-		int if_index = 0;
 		u16 vlan_id = wc->wc_flags & IB_WC_WITH_VLAN ?
 				wc->vlan_id : 0xffff;
-		struct net_device *idev;
-		struct net_device *resolved_dev;
 
 		if (!(wc->wc_flags & IB_WC_GRH))
 			return -EPROTOTYPE;
 
-		if (!device->get_netdev)
-			return -EOPNOTSUPP;
-
-		idev = device->get_netdev(device, port_num);
-		if (!idev)
-			return -ENODEV;
-
-		ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
-						   ah_attr->roce.dmac,
-						   wc->wc_flags & IB_WC_WITH_VLAN ?
-						   NULL : &vlan_id,
-						   &if_index, &hoplimit);
-		if (ret) {
-			dev_put(idev);
-			return ret;
-		}
-
-		resolved_dev = dev_get_by_index(&init_net, if_index);
-		rcu_read_lock();
-		if (resolved_dev != idev && !rdma_is_upper_dev_rcu(idev,
-								   resolved_dev))
-			ret = -EHOSTUNREACH;
-		rcu_read_unlock();
-		dev_put(idev);
-		dev_put(resolved_dev);
-		if (ret)
-			return ret;
-
-		ret = get_sgid_index_from_eth(device, port_num, vlan_id,
-					      &dgid, gid_type, &gid_index);
+		ret = get_sgid_index_from_eth(device, port_num,
+					      vlan_id, &dgid,
+					      gid_type, &gid_index);
 		if (ret)
 			return ret;
-	}
 
-	rdma_ah_set_dlid(ah_attr, wc->slid);
-	rdma_ah_set_sl(ah_attr, wc->sl);
-	rdma_ah_set_path_bits(ah_attr, wc->dlid_path_bits);
-	rdma_ah_set_port_num(ah_attr, port_num);
+		flow_class = be32_to_cpu(grh->version_tclass_flow);
+		rdma_ah_set_grh(ah_attr, &sgid,
+				flow_class & 0xFFFFF,
+				(u8)gid_index, hoplimit,
+				(flow_class >> 20) & 0xFF);
+		return ib_resolve_unicast_gid_dmac(device, ah_attr);
+	} else {
+		rdma_ah_set_dlid(ah_attr, wc->slid);
+		rdma_ah_set_path_bits(ah_attr, wc->dlid_path_bits);
 
-	if (wc->wc_flags & IB_WC_GRH) {
-		if (!rdma_cap_eth_ah(device, port_num)) {
+		if (wc->wc_flags & IB_WC_GRH) {
 			if (dgid.global.interface_id != cpu_to_be64(IB_SA_WELL_KNOWN_GUID)) {
 				ret = ib_find_cached_gid_by_port(device, &dgid,
 								 IB_GID_TYPE_IB,
@@ -584,16 +591,15 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 			} else {
 				gid_index = 0;
 			}
-		}
-
-		flow_class = be32_to_cpu(grh->version_tclass_flow);
-		rdma_ah_set_grh(ah_attr, &sgid,
-				flow_class & 0xFFFFF,
-				(u8)gid_index, hoplimit,
-				(flow_class >> 20) & 0xFF);
 
+			flow_class = be32_to_cpu(grh->version_tclass_flow);
+			rdma_ah_set_grh(ah_attr, &sgid,
+					flow_class & 0xFFFFF,
+					(u8)gid_index, hoplimit,
+					(flow_class >> 20) & 0xFF);
+		}
+		return 0;
 	}
-	return 0;
 }
 EXPORT_SYMBOL(ib_init_ah_from_wc);
 
@@ -1290,34 +1296,8 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
 					(char *)ah_attr->roce.dmac);
 		}
 	} else {
-		union ib_gid		sgid;
-		struct ib_gid_attr	sgid_attr;
-		int			ifindex;
-		int			hop_limit;
-
-		ret = ib_query_gid(device,
-				   rdma_ah_get_port_num(ah_attr),
-				   grh->sgid_index,
-				   &sgid, &sgid_attr);
-
-		if (ret || !sgid_attr.ndev) {
-			if (!ret)
-				ret = -ENXIO;
-			goto out;
-		}
-
-		ifindex = sgid_attr.ndev->ifindex;
-
-		ret =
-		rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
-					     ah_attr->roce.dmac,
-					     NULL, &ifindex, &hop_limit);
-
-		dev_put(sgid_attr.ndev);
-
-		grh->hop_limit = hop_limit;
+		ret = ib_resolve_unicast_gid_dmac(device, ah_attr);
 	}
-out:
 	return ret;
 }
 
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 18c564f60e93..d5c3bbb84608 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -134,7 +134,7 @@ int rdma_addr_size(struct sockaddr *addr);
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
 int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 				 const union ib_gid *dgid,
-				 u8 *smac, u16 *vlan_id, int *if_index,
+				 u8 *dmac, const struct net_device *ndev,
 				 int *hoplimit);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
