From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 10/12] IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
Date: Thu, 14 Jan 2016 17:50:41 +0200
Message-ID: <adb71dd11e1fe566acbaee2757989c908c441af7.1452780850.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCEv2 packets are sent over IP/UDP protocols.
The mlx4 driver uses a type of RAW QP to send packets for QP1 and
therefore needs to build the network headers below BTH in software.

This patch adds option to build QP1 packets with IP and UDP headers if
RoCEv2 is requested.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ud_header.c |  2 +-
 drivers/infiniband/hw/mlx4/qp.c     | 60 +++++++++++++++++++++++++++++++------
 include/rdma/ib_pack.h              |  4 +--
 3 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 96697e7..19837d2 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -280,7 +280,7 @@ static const struct ib_field deth_table[] = {
 	  .size_bits    = 24 }
 };
 
-__be16 ib_ud_ip4_csum(struct ib_ud_header *header)
+__sum16 ib_ud_ip4_csum(struct ib_ud_header *header)
 {
 	struct iphdr iph;
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index cb1fa8d..659035d 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -33,6 +33,7 @@
 
 #include <linux/log2.h>
 #include <linux/etherdevice.h>
+#include <net/ip.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -2288,6 +2289,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	return 0;
 }
 
+#define MLX4_ROCEV2_QP1_SPORT 0xC000
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
@@ -2307,6 +2309,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	bool is_eth;
 	bool is_vlan = false;
 	bool is_grh;
+	bool is_udp = false;
+	int ip_version = 0;
 
 	send_size = 0;
 	for (i = 0; i < wr->wr.num_sge; ++i)
@@ -2315,6 +2319,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
+		struct ib_gid_attr gid_attr;
+
 		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
 			/* When multi-function is enabled, the ib_core gid
 			 * indexes don't necessarily match the hw ones, so
@@ -2328,20 +2334,33 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			err = ib_get_cached_gid(ib_dev,
 						be32_to_cpu(ah->av.ib.port_pd) >> 24,
 						ah->av.ib.gid_index, &sgid,
-						NULL);
-			if (!err && !memcmp(&sgid, &zgid, sizeof(sgid)))
-				err = -ENOENT;
-			if (err)
+						&gid_attr);
+			if (!err) {
+				if (gid_attr.ndev)
+					dev_put(gid_attr.ndev);
+				if (!memcmp(&sgid, &zgid, sizeof(sgid)))
+					err = -ENOENT;
+			}
+			if (!err) {
+				is_udp = gid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP;
+				if (is_udp) {
+					if (ipv6_addr_v4mapped((struct in6_addr *)&sgid))
+						ip_version = 4;
+					else
+						ip_version = 6;
+					is_grh = false;
+				}
+			} else {
 				return err;
+			}
 		}
-
 		if (ah->av.eth.vlan != cpu_to_be16(0xffff)) {
 			vlan = be16_to_cpu(ah->av.eth.vlan) & 0x0fff;
 			is_vlan = 1;
 		}
 	}
 	err = ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh,
-				0, 0, 0, &sqp->ud_header);
+			  ip_version, is_udp, 0, &sqp->ud_header);
 	if (err)
 		return err;
 
@@ -2352,7 +2371,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		sqp->ud_header.lrh.source_lid = cpu_to_be16(ah->av.ib.g_slid & 0x7f);
 	}
 
-	if (is_grh) {
+	if (is_grh || (ip_version == 6)) {
 		sqp->ud_header.grh.traffic_class =
 			(be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20) & 0xff;
 		sqp->ud_header.grh.flow_label    =
@@ -2381,6 +2400,25 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		       ah->av.ib.dgid, 16);
 	}
 
+	if (ip_version == 4) {
+		sqp->ud_header.ip4.tos =
+			(be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20) & 0xff;
+		sqp->ud_header.ip4.id = 0;
+		sqp->ud_header.ip4.frag_off = htons(IP_DF);
+		sqp->ud_header.ip4.ttl = ah->av.eth.hop_limit;
+
+		memcpy(&sqp->ud_header.ip4.saddr,
+		       sgid.raw + 12, 4);
+		memcpy(&sqp->ud_header.ip4.daddr, ah->av.ib.dgid + 12, 4);
+		sqp->ud_header.ip4.check = ib_ud_ip4_csum(&sqp->ud_header);
+	}
+
+	if (is_udp) {
+		sqp->ud_header.udp.dport = htons(ROCE_V2_UDP_DPORT);
+		sqp->ud_header.udp.sport = htons(MLX4_ROCEV2_QP1_SPORT);
+		sqp->ud_header.udp.csum = 0;
+	}
+
 	mlx->flags &= cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
 
 	if (!is_eth) {
@@ -2409,8 +2447,12 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 
 	if (is_eth) {
 		struct in6_addr in6;
+		u16 ether_type;
 		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 
+		ether_type = (!is_udp) ? MLX4_IB_IBOE_ETHERTYPE :
+			(ip_version == 4 ? ETH_P_IP : ETH_P_IPV6);
+
 		mlx->sched_prio = cpu_to_be16(pcp);
 
 		ether_addr_copy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac);
@@ -2423,9 +2465,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6))
 			mlx->flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
 		if (!is_vlan) {
-			sqp->ud_header.eth.type = cpu_to_be16(MLX4_IB_IBOE_ETHERTYPE);
+			sqp->ud_header.eth.type = cpu_to_be16(ether_type);
 		} else {
-			sqp->ud_header.vlan.type = cpu_to_be16(MLX4_IB_IBOE_ETHERTYPE);
+			sqp->ud_header.vlan.type = cpu_to_be16(ether_type);
 			sqp->ud_header.vlan.tag = cpu_to_be16(vlan | pcp);
 		}
 	} else {
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index a193081..0f3daae 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -234,7 +234,7 @@ struct ib_unpacked_ip4 {
 	__be16	frag_off;
 	u8	ttl;
 	u8	protocol;
-	__be16	check;
+	__sum16	check;
 	__be32	saddr;
 	__be32	daddr;
 };
@@ -280,7 +280,7 @@ void ib_unpack(const struct ib_field        *desc,
 	       void                         *buf,
 	       void                         *structure);
 
-__be16 ib_ud_ip4_csum(struct ib_ud_header *header);
+__sum16 ib_ud_ip4_csum(struct ib_ud_header *header);
 
 int ib_ud_header_init(int		    payload_bytes,
 		      int		    lrh_present,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
