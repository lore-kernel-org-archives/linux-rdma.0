From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 10/11] ib_core: Add VLAN support to IBoE
Date: Thu, 18 Feb 2010 19:24:43 +0200
Message-ID: <20100218172443.GK12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add 802.1q vlan support to IBoE. The vlan tag is encoded within the GID
derived from a link local address in the following way:

GID[11] GID[12] contain the vlan ID.
The 3 bit user priority field is identical to the 3 bits of the SL.

In case rdma_cm apps, the TOS field is used to generate the SL field by doing a
shift right of 5 bits effectively taking to 3 MS bits of the TOS field. In
order to support userspace verbs consumers, ib_uverbs_get_mac has changed into
ib_uverbs_get_eth_l2_addr and now returns both MAC and VLAN information.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/cma.c       |   20 ++++++++-----
 drivers/infiniband/core/ucma.c      |   13 ++++++++-
 drivers/infiniband/core/ud_header.c |   31 ++++++++++++++++++++-
 include/rdma/ib_addr.h              |   49 ++++++++++++++++++++++++++++++++---
 include/rdma/ib_pack.h              |   19 ++++++-------
 5 files changed, 106 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index df5f636..108d1bb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1763,6 +1763,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	struct sockaddr_in *src_addr = (struct sockaddr_in *)&route->addr.src_addr;
 	struct sockaddr_in *dst_addr = (struct sockaddr_in *)&route->addr.dst_addr;
 	struct net_device *ndev = NULL;
+	u16 vid;
 
 	if (src_addr->sin_family != dst_addr->sin_family)
 		return -EINVAL;
@@ -1782,14 +1783,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	route->num_paths = 1;
 
-	iboe_mac_to_ll(&route->path_rec->sgid, addr->dev_addr.src_dev_addr);
-	iboe_mac_to_ll(&route->path_rec->dgid, addr->dev_addr.dst_dev_addr);
-
-	route->path_rec->hop_limit = 1;
-	route->path_rec->reversible = 1;
-	route->path_rec->pkey = cpu_to_be16(0xffff);
-	route->path_rec->mtu_selector = IB_SA_EQ;
-
 	if (addr->dev_addr.bound_dev_if)
 		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
 	if (!ndev) {
@@ -1797,6 +1790,17 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		goto err2;
 	}
 
+	vid = rdma_vlan_dev_vlan_id(ndev);
+
+	iboe_mac_vlan_to_ll(&route->path_rec->sgid, addr->dev_addr.src_dev_addr, vid);
+	iboe_mac_vlan_to_ll(&route->path_rec->dgid, addr->dev_addr.dst_dev_addr, vid);
+
+	route->path_rec->hop_limit = 1;
+	route->path_rec->reversible = 1;
+	route->path_rec->pkey = cpu_to_be16(0xffff);
+	route->path_rec->mtu_selector = IB_SA_EQ;
+	route->path_rec->sl = id_priv->tos >> 5;
+
 	route->path_rec->mtu = iboe_get_mtu(ndev->mtu);
 	route->path_rec->rate_selector = IB_SA_EQ;
 	route->path_rec->rate = iboe_get_rate(ndev);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index fcc27bc..ed670f5 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -586,13 +586,22 @@ static void ucma_copy_iboe_route(struct rdma_ucm_query_route_resp *resp,
 				 struct rdma_route *route)
 {
 	struct rdma_dev_addr *dev_addr;
+	struct net_device *dev;
+	u16 vid = 0;
 
 	resp->num_paths = route->num_paths;
 	switch (route->num_paths) {
 	case 0:
 		dev_addr = &route->addr.dev_addr;
-		iboe_mac_to_ll((union ib_gid *) &resp->ib_route[0].dgid,
-			       dev_addr->dst_dev_addr);
+		dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+			if (dev) {
+				vid = rdma_vlan_dev_vlan_id(dev);
+				dev_put(dev);
+			}
+
+
+		iboe_mac_vlan_to_ll((union ib_gid *) &resp->ib_route[0].dgid,
+				    dev_addr->dst_dev_addr, vid);
 		iboe_addr_get_sgid(dev_addr,
 				   (union ib_gid *) &resp->ib_route[0].sgid);
 		resp->ib_route[0].pkey = cpu_to_be16(0xffff);
diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 7650313..7d03cf1 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -33,6 +33,7 @@
 
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/if_ether.h>
 
 #include <rdma/ib_pack.h>
 
@@ -103,6 +104,17 @@ static const struct ib_field eth_table[]  = {
 	  .size_bits    = 16 }
 };
 
+static const struct ib_field vlan_table[]  = {
+	{ STRUCT_FIELD(vlan, tag),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(vlan, type),
+	  .offset_words = 0,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 }
+};
+
 static const struct ib_field grh_table[]  = {
 	{ STRUCT_FIELD(grh, ip_version),
 	  .offset_words = 0,
@@ -205,6 +217,7 @@ static const struct ib_field deth_table[] = {
  * @payload_bytes:Length of packet payload
  * @lrh_present: specify if LRH is present
  * @eth_present: specify if Eth header is present
+ * @vlan_present: packet is tagged vlan
  * @grh_present:GRH flag (if non-zero, GRH will be included)
  * @immediate_present: specify if immediate data is present
  * @header:Structure to initialize
@@ -212,6 +225,7 @@ static const struct ib_field deth_table[] = {
 void ib_ud_header_init(int     		    payload_bytes,
 		       int		    lrh_present,
 		       int		    eth_present,
+		       int		    vlan_present,
 		       int    		    grh_present,
 		       int		    immediate_present,
 		       struct ib_ud_header *header)
@@ -227,8 +241,14 @@ void ib_ud_header_init(int     		    payload_bytes,
 		packet_length = IB_LRH_BYTES;
 	}
 
-	if (eth_present)
-		packet_length = IB_ETH_BYTES;
+	if (eth_present) {
+		if (vlan_present) {
+			header->eth.type = cpu_to_be16(ETH_P_8021Q);
+			packet_length += IB_VLAN_BYTES;
+
+		}
+		packet_length += IB_ETH_BYTES;
+	}
 
 	packet_length += IB_BTH_BYTES + IB_DETH_BYTES + payload_bytes +
 		4       + /* ICRC     */
@@ -258,6 +278,7 @@ void ib_ud_header_init(int     		    payload_bytes,
 
 	header->lrh_present = lrh_present;
 	header->eth_present = eth_present;
+	header->vlan_present = vlan_present;
 	header->grh_present = grh_present;
 	header->immediate_present = immediate_present;
 }
@@ -287,6 +308,12 @@ int ib_ud_header_pack(struct ib_ud_header *header,
 		len += IB_ETH_BYTES;
 	}
 
+	if (header->vlan_present) {
+		ib_pack(vlan_table, ARRAY_SIZE(vlan_table),
+			&header->vlan, buf + len);
+		len += IB_VLAN_BYTES;
+	}
+
 	if (header->grh_present) {
 		ib_pack(grh_table, ARRAY_SIZE(grh_table),
 			&header->grh, buf + len);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 23b184e..7e75bfa 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -41,6 +41,7 @@
 #include <linux/socket.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
+#include <linux/if_vlan.h>
 
 struct rdma_addr_client {
 	atomic_t refcount;
@@ -129,12 +130,17 @@ static inline int rdma_addr_gid_offset(struct rdma_dev_addr *dev_addr)
 	return dev_addr->dev_type == ARPHRD_INFINIBAND ? 4 : 0;
 }
 
-static inline void iboe_mac_to_ll(union ib_gid *gid, u8 *mac)
+static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16 vid)
 {
 	memset(gid->raw, 0, 16);
 	*((u32 *)gid->raw) = cpu_to_be32(0xfe800000);
-	gid->raw[12] = 0xfe;
-	gid->raw[11] = 0xff;
+	if (vid) {
+		gid->raw[12] = vid & 0xff;
+		gid->raw[11] = vid >> 8;
+	} else {
+		gid->raw[12] = 0xfe;
+		gid->raw[11] = 0xff;
+	}
 	memcpy(gid->raw + 13, mac + 3, 3);
 	memcpy(gid->raw + 8, mac, 3);
 	gid->raw[8] ^= 2;
@@ -143,7 +149,16 @@ static inline void iboe_mac_to_ll(union ib_gid *gid, u8 *mac)
 static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
 				      union ib_gid *gid)
 {
-	iboe_mac_to_ll(gid, dev_addr->src_dev_addr);
+	struct net_device *dev;
+	u16 vid = 0;
+
+	dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
+	if (dev) {
+		vid = vlan_dev_vlan_id(dev);
+		dev_put(dev);
+	}
+
+	iboe_mac_vlan_to_ll(gid, dev_addr->src_dev_addr, vid);
 }
 
 static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
@@ -243,4 +258,30 @@ static inline void rdma_get_mcast_mac(struct in6_addr *addr, u8 *mac)
 	for (i = 2; i < 6; ++i)
 		mac[i] = addr->s6_addr[i + 10];
 }
+
+static inline u16 rdma_get_vlan_id(union ib_gid *dgid)
+{
+	u16 vid;
+
+	vid = dgid->raw[11] << 8 | dgid->raw[12];
+	return vid == 0xfffe ? 0 : vid  & 0xfff;
+}
+
+static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev) {
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+	return vlan_dev_vlan_id(dev);
+#else
+	return 0;
+#endif
+}
+
+static inline struct net_device *rdma_vlan_dev_real_dev(const struct net_device *dev)
+{
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+	return vlan_dev_real_dev(dev);
+#else
+	return 0;
+#endif
+}
+
 #endif /* IB_ADDR_H */
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index 67a85f3..1678be7 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -38,6 +38,7 @@
 enum {
 	IB_LRH_BYTES  = 8,
 	IB_ETH_BYTES  = 14,
+	IB_VLAN_BYTES = 4,
 	IB_GRH_BYTES  = 40,
 	IB_BTH_BYTES  = 12,
 	IB_DETH_BYTES = 8
@@ -219,21 +220,18 @@ struct ib_unpacked_eth {
 	__be16	type;
 };
 
+struct ib_unpacked_vlan {
+	__be16  tag;
+	__be16  type;
+};
+
 struct ib_ud_header {
 	int                     lrh_present;
 	struct ib_unpacked_lrh  lrh;
 	int                     eth_present;
 	struct ib_unpacked_eth  eth;
-	int                     grh_present;
-	struct ib_unpacked_grh  grh;
-	struct ib_unpacked_bth  bth;
-	struct ib_unpacked_deth deth;
-	int            		immediate_present;
-	__be32         		immediate_data;
-};
-
-struct eth_ud_header {
-	struct ib_unpacked_eth  eth;
+	int                     vlan_present;
+	struct ib_unpacked_vlan vlan;
 	int                     grh_present;
 	struct ib_unpacked_grh  grh;
 	struct ib_unpacked_bth  bth;
@@ -255,6 +253,7 @@ void ib_unpack(const struct ib_field        *desc,
 void ib_ud_header_init(int     		    payload_bytes,
 		       int		    lrh_present,
 		       int		    eth_present,
+		       int		    vlan_present,
 		       int    		    grh_present,
 		       int		    immediate_present,
 		       struct ib_ud_header *header);
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
