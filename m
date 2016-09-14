From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 2/2] Add support for UD traffic on RoCE v2
Date: Wed, 14 Sep 2016 17:31:52 +0300
Message-ID: <1473863512-11218-3-git-send-email-yishaih@mellanox.com>
References: <1473863512-11218-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473863512-11218-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When creating an Address Handle from a Work Completion, source GID index must
be set. To enable RoCE v2, libibverbs should select the right GID index for
it.

RoCE v2 is using UDP/IP layers so a WC's GRH could be either an IB GRH, IPv4
header or an IPv6 header. Libibverbs should be able to differ between them in a
driver-agnostic way to avoid API changes.

This patch is using the fact that for RoCE v2, the GRH is either an IPv6 header
or 20 garbled bytes followed by an IPv4 header, as defined in RoCE v2 annex.
The annex also specifies that for packets with IPv4 header, the version number
is 4, for packets with IPv6 header it's 6 or the packet is silently dropped.
This fact is also taken into account when parsing the GRH.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/verbs.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 159 insertions(+), 19 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 08f03e3..fc8b9f6 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -41,6 +41,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <string.h>
+#include <linux/ip.h>
 #include <dirent.h>
 
 #include "ibverbs.h"
@@ -651,48 +652,187 @@ int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
 }
 
 static int ibv_find_gid_index(struct ibv_context *context, uint8_t port_num,
-			      union ibv_gid *gid)
+			      union ibv_gid *gid, enum ibv_gid_type gid_type)
 {
+	enum ibv_gid_type sgid_type = 0;
 	union ibv_gid sgid;
 	int i = 0, ret;
 
 	do {
-		ret = ibv_query_gid(context, port_num, i++, &sgid);
-	} while (!ret && memcmp(&sgid, gid, sizeof *gid));
+		ret = ibv_query_gid(context, port_num, i, &sgid);
+		if (!ret) {
+			ret = ibv_query_gid_type(context, port_num, i,
+						 &sgid_type);
+		}
+		i++;
+	} while (!ret && (memcmp(&sgid, gid, sizeof(*gid)) ||
+		 (gid_type != sgid_type)));
 
 	return ret ? ret : i - 1;
 }
 
-int ibv_init_ah_from_wc(struct ibv_context *context, uint8_t port_num,
-			struct ibv_wc *wc, struct ibv_grh *grh,
-			struct ibv_ah_attr *ah_attr)
+static inline void map_ipv4_addr_to_ipv6(__be32 ipv4, struct in6_addr *ipv6)
+{
+	ipv6->s6_addr32[0] = 0;
+	ipv6->s6_addr32[1] = 0;
+	ipv6->s6_addr32[2] = htonl(0x0000FFFF);
+	ipv6->s6_addr32[3] = ipv4;
+}
+
+static inline uint16_t ipv4_calc_hdr_csum(uint16_t *data, unsigned int num_hwords)
+{
+	unsigned int i = 0;
+	uint32_t sum = 0;
+
+	for (i = 0; i < num_hwords; i++)
+		sum += *(data++);
+
+	sum = (sum & 0xffff) + (sum >> 16);
+
+	return ~sum;
+}
+
+static inline int get_grh_header_version(struct ibv_grh *grh)
+{
+	int ip6h_version = (ntohl(grh->version_tclass_flow) >> 28) & 0xf;
+	struct iphdr *ip4h = (struct iphdr *)((void *)grh + 20);
+	struct iphdr ip4h_checked;
+
+	if (ip6h_version != 6) {
+		if (ip4h->version == 4)
+			return 4;
+		errno = EPROTONOSUPPORT;
+		return -1;
+	}
+	/* version may be 6 or 4 */
+	if (ip4h->ihl != 5) /* IPv4 header length must be 5 for RoCE v2. */
+		return 6;
+	/*
+	* Verify checksum.
+	* We can't write on scattered buffers so we have to copy to temp
+	* buffer.
+	*/
+	memcpy(&ip4h_checked, ip4h, sizeof(ip4h_checked));
+	/* Need to set the checksum field (check) to 0 before re-calculating
+	 * the checksum.
+	 */
+	ip4h_checked.check = 0;
+	ip4h_checked.check = ipv4_calc_hdr_csum((uint16_t *)&ip4h_checked, 10);
+	/* if IPv4 header checksum is OK, believe it */
+	if (ip4h->check == ip4h_checked.check)
+		return 4;
+	return 6;
+}
+
+static inline void set_ah_attr_generic_fields(struct ibv_ah_attr *ah_attr,
+					      struct ibv_wc *wc,
+					      struct ibv_grh *grh,
+					      uint8_t port_num)
 {
 	uint32_t flow_class;
-	int ret;
 
-	memset(ah_attr, 0, sizeof *ah_attr);
+	flow_class = ntohl(grh->version_tclass_flow);
+	ah_attr->grh.flow_label = flow_class & 0xFFFFF;
 	ah_attr->dlid = wc->slid;
 	ah_attr->sl = wc->sl;
 	ah_attr->src_path_bits = wc->dlid_path_bits;
 	ah_attr->port_num = port_num;
+}
 
-	if (wc->wc_flags & IBV_WC_GRH) {
-		ah_attr->is_global = 1;
-		ah_attr->grh.dgid = grh->sgid;
+static inline int set_ah_attr_by_ipv4(struct ibv_context *context,
+				      struct ibv_ah_attr *ah_attr,
+				      struct iphdr *ip4h, uint8_t port_num)
+{
+	union ibv_gid sgid;
+	int ret;
+
+	/* No point searching multicast GIDs in GID table */
+	if (IN_CLASSD(ntohl(ip4h->daddr))) {
+		errno = EINVAL;
+		return -1;
+	}
 
-		ret = ibv_find_gid_index(context, port_num, &grh->dgid);
-		if (ret < 0)
-			return ret;
+	map_ipv4_addr_to_ipv6(ip4h->daddr, (struct in6_addr *)&sgid);
+	ret = ibv_find_gid_index(context, port_num, &sgid,
+				 IBV_GID_TYPE_ROCE_V2);
+	if (ret < 0)
+		return ret;
 
-		ah_attr->grh.sgid_index = (uint8_t) ret;
-		flow_class = ntohl(grh->version_tclass_flow);
-		ah_attr->grh.flow_label = flow_class & 0xFFFFF;
-		ah_attr->grh.hop_limit = grh->hop_limit;
-		ah_attr->grh.traffic_class = (flow_class >> 20) & 0xFF;
+	map_ipv4_addr_to_ipv6(ip4h->saddr,
+			      (struct in6_addr *)&ah_attr->grh.dgid);
+	ah_attr->grh.sgid_index = (uint8_t) ret;
+	ah_attr->grh.hop_limit = ip4h->ttl;
+	ah_attr->grh.traffic_class = ip4h->tos;
+
+	return 0;
+}
+
+#define IB_NEXT_HDR    0x1b
+static inline int set_ah_attr_by_ipv6(struct ibv_context *context,
+				  struct ibv_ah_attr *ah_attr,
+				  struct ibv_grh *grh, uint8_t port_num)
+{
+	uint32_t flow_class;
+	uint32_t sgid_type;
+	int ret;
+
+	/* No point searching multicast GIDs in GID table */
+	if (grh->dgid.raw[0] == 0xFF) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	ah_attr->grh.dgid = grh->sgid;
+	if (grh->next_hdr == IPPROTO_UDP) {
+		sgid_type = IBV_GID_TYPE_ROCE_V2;
+	} else if (grh->next_hdr == IB_NEXT_HDR) {
+		sgid_type = IBV_GID_TYPE_IB_ROCE_V1;
+	} else {
+		errno = EPROTONOSUPPORT;
+		return -1;
 	}
+
+	ret = ibv_find_gid_index(context, port_num, &grh->dgid,
+				 sgid_type);
+	if (ret < 0)
+		return ret;
+
+	ah_attr->grh.sgid_index = (uint8_t) ret;
+	flow_class = ntohl(grh->version_tclass_flow);
+	ah_attr->grh.hop_limit = grh->hop_limit;
+	ah_attr->grh.traffic_class = (flow_class >> 20) & 0xFF;
+
 	return 0;
 }
 
+int ibv_init_ah_from_wc(struct ibv_context *context, uint8_t port_num,
+			struct ibv_wc *wc, struct ibv_grh *grh,
+			struct ibv_ah_attr *ah_attr)
+{
+	int version;
+	int ret = 0;
+
+	memset(ah_attr, 0, sizeof *ah_attr);
+	set_ah_attr_generic_fields(ah_attr, wc, grh, port_num);
+
+	if (wc->wc_flags & IBV_WC_GRH) {
+		ah_attr->is_global = 1;
+		version = get_grh_header_version(grh);
+
+		if (version == 4)
+			ret = set_ah_attr_by_ipv4(context, ah_attr,
+						  (struct iphdr *)((void *)grh + 20),
+						  port_num);
+		else if (version == 6)
+			ret = set_ah_attr_by_ipv6(context, ah_attr, grh,
+						  port_num);
+		else
+			ret = -1;
+	}
+
+	return ret;
+}
+
 struct ibv_ah *ibv_create_ah_from_wc(struct ibv_pd *pd, struct ibv_wc *wc,
 				     struct ibv_grh *grh, uint8_t port_num)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
