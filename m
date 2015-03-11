From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 29/32] IB/core: Initialize UD header structure with IP and UDP headers
Date: Wed, 11 Mar 2015 10:26:21 +0530
Message-ID: <2f032b9c-f023-44af-ba01-d002f9332abd@CMEXHTCAS2.ad.emulex.com>
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

ib_ud_header_init() is used to format InfiniBand headers
in a buffer up to (but not with) BTH. For RoCEv2 it is required that
this function would be able to build also IP and UDP headers.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/ud_header.c    | 153 ++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx4/qp.c        |   7 +-
 drivers/infiniband/hw/mthca/mthca_qp.c |   2 +-
 include/rdma/ib_pack.h                 |  44 ++++++++--
 4 files changed, 186 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 72feee6..a4d4072 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -35,6 +35,7 @@
 #include <linux/string.h>
 #include <linux/export.h>
 #include <linux/if_ether.h>
+#include <linux/ip.h>
 
 #include <rdma/ib_pack.h>
 
@@ -116,6 +117,68 @@ static const struct ib_field vlan_table[]  = {
 	  .size_bits    = 16 }
 };
 
+static const struct ib_field ip4_table[]  = {
+	{ STRUCT_FIELD(ip4, ver_len),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ STRUCT_FIELD(ip4, tos),
+	  .offset_words = 0,
+	  .offset_bits  = 8,
+	  .size_bits    = 8 },
+	{ STRUCT_FIELD(ip4, tot_len),
+	  .offset_words = 0,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(ip4, id),
+	  .offset_words = 1,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(ip4, frag_off),
+	  .offset_words = 1,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(ip4, ttl),
+	  .offset_words = 2,
+	  .offset_bits  = 0,
+	  .size_bits    = 8 },
+	{ STRUCT_FIELD(ip4, protocol),
+	  .offset_words = 2,
+	  .offset_bits  = 8,
+	  .size_bits    = 8 },
+	{ STRUCT_FIELD(ip4, check),
+	  .offset_words = 2,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(ip4, saddr),
+	  .offset_words = 3,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 },
+	{ STRUCT_FIELD(ip4, daddr),
+	  .offset_words = 4,
+	  .offset_bits  = 0,
+	  .size_bits    = 32 }
+};
+
+static const struct ib_field udp_table[]  = {
+	{ STRUCT_FIELD(udp, sport),
+	  .offset_words = 0,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(udp, dport),
+	  .offset_words = 0,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(udp, length),
+	  .offset_words = 1,
+	  .offset_bits  = 0,
+	  .size_bits    = 16 },
+	{ STRUCT_FIELD(udp, csum),
+	  .offset_words = 1,
+	  .offset_bits  = 16,
+	  .size_bits    = 16 }
+};
+
 static const struct ib_field grh_table[]  = {
 	{ STRUCT_FIELD(grh, ip_version),
 	  .offset_words = 0,
@@ -213,6 +276,26 @@ static const struct ib_field deth_table[] = {
 	  .size_bits    = 24 }
 };
 
+__be16 ib_ud_ip4_csum(struct ib_ud_header *header)
+{
+	struct iphdr iph;
+
+	iph.ihl		= 5;
+	iph.version	= 4;
+	iph.tos		= header->ip4.tos;
+	iph.tot_len	= header->ip4.tot_len;
+	iph.id		= header->ip4.id;
+	iph.frag_off	= header->ip4.frag_off;
+	iph.ttl		= header->ip4.ttl;
+	iph.protocol	= header->ip4.protocol;
+	iph.check	= 0;
+	iph.saddr	= header->ip4.saddr;
+	iph.daddr	= header->ip4.daddr;
+
+	return ip_fast_csum((u8 *)&iph, iph.ihl);
+}
+EXPORT_SYMBOL(ib_ud_ip4_csum);
+
 /**
  * ib_ud_header_init - Initialize UD header structure
  * @payload_bytes:Length of packet payload
@@ -220,19 +303,35 @@ static const struct ib_field deth_table[] = {
  * @eth_present: specify if Eth header is present
  * @vlan_present: packet is tagged vlan
  * @grh_present:GRH flag (if non-zero, GRH will be included)
+ * @ip_version:GRH flag (if non-zero, IP header, V4 or V6, will be included)
+ * @grh_present:GRH flag (if non-zero, UDP header will be included)
  * @immediate_present: specify if immediate data is present
  * @header:Structure to initialize
  */
-void ib_ud_header_init(int     		    payload_bytes,
-		       int		    lrh_present,
-		       int		    eth_present,
-		       int		    vlan_present,
-		       int    		    grh_present,
-		       int		    immediate_present,
-		       struct ib_ud_header *header)
+int ib_ud_header_init(int     payload_bytes,
+		      int    lrh_present,
+		      int    eth_present,
+		      int    vlan_present,
+		      int    grh_present,
+		      int    ip_version,
+		      int    udp_present,
+		      int    immediate_present,
+		      struct ib_ud_header *header)
 {
+	int ipv4_present;
+	int ipv6_present;
+
+	grh_present = grh_present && !ip_version;
 	memset(header, 0, sizeof *header);
 
+	/*
+	 * UDP header without IP header doesn't make sense
+	 */
+	if (udp_present && ip_version != 4 && ip_version != 6)
+		return -EINVAL;
+
+	ipv4_present = (ip_version == 4);
+	ipv6_present = (ip_version == 6);
 	if (lrh_present) {
 		u16 packet_length;
 
@@ -252,7 +351,7 @@ void ib_ud_header_init(int     		    payload_bytes,
 	if (vlan_present)
 		header->eth.type = cpu_to_be16(ETH_P_8021Q);
 
-	if (grh_present) {
+	if (ipv6_present || grh_present) {
 		header->grh.ip_version      = 6;
 		header->grh.payload_length  =
 			cpu_to_be16((IB_BTH_BYTES     +
@@ -260,8 +359,29 @@ void ib_ud_header_init(int     		    payload_bytes,
 				     payload_bytes    +
 				     4                + /* ICRC     */
 				     3) & ~3);          /* round up */
-		header->grh.next_header     = 0x1b;
+		header->grh.next_header     = udp_present ? IPPROTO_UDP : 0x1b;
+	}
+
+	if (ipv4_present) {
+		int udp_bytes = udp_present ? IB_UDP_BYTES : 0;
+
+		header->ip4.ver_len = 0x45; /* version 4, 5 words */
+		header->ip4.tot_len =
+			cpu_to_be16(IB_IP4_BYTES   +
+				     udp_bytes     +
+				     IB_BTH_BYTES  +
+				     IB_DETH_BYTES +
+				     payload_bytes +
+				     4);     /* ICRC     */
+		header->ip4.protocol = IPPROTO_UDP;
 	}
+	if (udp_present && ip_version)
+		header->udp.length =
+			cpu_to_be16(IB_UDP_BYTES   +
+				     IB_BTH_BYTES  +
+				     IB_DETH_BYTES +
+				     payload_bytes +
+				     4);     /* ICRC     */
 
 	if (immediate_present)
 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
@@ -273,8 +393,11 @@ void ib_ud_header_init(int     		    payload_bytes,
 	header->lrh_present = lrh_present;
 	header->eth_present = eth_present;
 	header->vlan_present = vlan_present;
-	header->grh_present = grh_present;
+	header->grh_present = grh_present || ipv6_present;
+	header->ipv4_present = ipv4_present;
+	header->udp_present = udp_present;
 	header->immediate_present = immediate_present;
+	return 0;
 }
 EXPORT_SYMBOL(ib_ud_header_init);
 
@@ -311,6 +434,16 @@ int ib_ud_header_pack(struct ib_ud_header *header,
 			&header->grh, buf + len);
 		len += IB_GRH_BYTES;
 	}
+	if (header->ipv4_present) {
+		ib_pack(ip4_table, ARRAY_SIZE(ip4_table),
+			&header->ip4, buf + len);
+		len += IB_IP4_BYTES;
+	}
+	if (header->udp_present) {
+		ib_pack(udp_table, ARRAY_SIZE(udp_table),
+			&header->udp, buf + len);
+		len += IB_UDP_BYTES;
+	}
 
 	ib_pack(bth_table, ARRAY_SIZE(bth_table),
 		&header->bth, buf + len);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index d7d7c5a..1141cf0 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2085,7 +2085,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER)
 		send_size += sizeof (struct mlx4_ib_tunnel_header);
 
-	ib_ud_header_init(send_size, 1, 0, 0, 0, 0, &sqp->ud_header);
+	ib_ud_header_init(send_size, 1, 0, 0, 0, 0, 0, 0, &sqp->ud_header);
 
 	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER) {
 		sqp->ud_header.lrh.service_level =
@@ -2231,7 +2231,10 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			is_vlan = 1;
 		}
 	}
-	ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh, 0, &sqp->ud_header);
+	err = ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh,
+				0, 0, 0, &sqp->ud_header);
+	if (err)
+		return err;
 
 	if (!is_eth) {
 		sqp->ud_header.lrh.service_level =
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index e354b2f..22a04fd 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1485,7 +1485,7 @@ static int build_mlx_header(struct mthca_dev *dev, struct mthca_sqp *sqp,
 	u16 pkey;
 
 	ib_ud_header_init(256, /* assume a MAD */ 1, 0, 0,
-			  mthca_ah_grh_present(to_mah(wr->wr.ud.ah)), 0,
+			  mthca_ah_grh_present(to_mah(wr->wr.ud.ah)), 0, 0, 0,
 			  &sqp->ud_header);
 
 	err = mthca_read_ah(dev, to_mah(wr->wr.ud.ah), &sqp->ud_header);
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index b1f7592..acbc1af 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -41,6 +41,8 @@ enum {
 	IB_ETH_BYTES  = 14,
 	IB_VLAN_BYTES = 4,
 	IB_GRH_BYTES  = 40,
+	IB_IP4_BYTES  = 20,
+	IB_UDP_BYTES  = 8,
 	IB_BTH_BYTES  = 12,
 	IB_DETH_BYTES = 8
 };
@@ -221,6 +223,26 @@ struct ib_unpacked_eth {
 	__be16	type;
 };
 
+struct ib_unpacked_ip4 {
+	u8	ver_len;
+	u8	tos;
+	__be16	tot_len;
+	__be16	id;
+	__be16	frag_off;
+	u8	ttl;
+	u8	protocol;
+	__be16	check;
+	__be32	saddr;
+	__be32	daddr;
+};
+
+struct ib_unpacked_udp {
+	__be16	sport;
+	__be16	dport;
+	__be16	length;
+	__be16	csum;
+};
+
 struct ib_unpacked_vlan {
 	__be16  tag;
 	__be16  type;
@@ -235,6 +257,10 @@ struct ib_ud_header {
 	struct ib_unpacked_vlan vlan;
 	int			grh_present;
 	struct ib_unpacked_grh	grh;
+	int			ipv4_present;
+	struct ib_unpacked_ip4	ip4;
+	int			udp_present;
+	struct ib_unpacked_udp	udp;
 	struct ib_unpacked_bth	bth;
 	struct ib_unpacked_deth deth;
 	int			immediate_present;
@@ -251,13 +277,17 @@ void ib_unpack(const struct ib_field        *desc,
 	       void                         *buf,
 	       void                         *structure);
 
-void ib_ud_header_init(int		    payload_bytes,
-		       int		    lrh_present,
-		       int		    eth_present,
-		       int		    vlan_present,
-		       int		    grh_present,
-		       int		    immediate_present,
-		       struct ib_ud_header *header);
+__be16 ib_ud_ip4_csum(struct ib_ud_header *header);
+
+int ib_ud_header_init(int		    payload_bytes,
+		      int		    lrh_present,
+		      int		    eth_present,
+		      int		    vlan_present,
+		      int		    grh_present,
+		      int		    ip_version,
+		      int		    udp_present,
+		      int		    immediate_present,
+		      struct ib_ud_header *header);
 
 int ib_ud_header_pack(struct ib_ud_header *header,
 		      void                *buf);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
