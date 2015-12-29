From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/7] IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
Date: Tue, 29 Dec 2015 15:24:05 +0200
Message-ID: <1451395447-5198-6-git-send-email-matanb@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RoCEv2 packets are sent over IP/UDP protocols.
The mlx4 driver uses a type of RAW QP to send packets for QP1 and
therefore needs to build the network headers below BTH in software.

This patche adds option to build QP1 packets with IP and UDP headers if
RoCEv2 is requested.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 86 ++++++++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c0dee79..8485602 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -32,6 +32,8 @@
  */
 
 #include <linux/log2.h>
+#include <linux/if_ether.h>
+#include <net/ip.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -2282,16 +2284,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	return 0;
 }
 
-static void mlx4_u64_to_smac(u8 *dst_mac, u64 src_mac)
-{
-	int i;
-
-	for (i = ETH_ALEN; i; i--) {
-		dst_mac[i - 1] = src_mac & 0xff;
-		src_mac >>= 8;
-	}
-}
-
+#define MLX4_ROCEV2_QP1_SPORT 0xC000
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
@@ -2311,6 +2304,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	bool is_eth;
 	bool is_vlan = false;
 	bool is_grh;
+	bool is_udp = false;
+	int ip_version = 0;
 
 	send_size = 0;
 	for (i = 0; i < wr->wr.num_sge; ++i)
@@ -2319,6 +2314,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
+		struct ib_gid_attr gid_attr;
+
 		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
 			/* When multi-function is enabled, the ib_core gid
 			 * indexes don't necessarily match the hw ones, so
@@ -2329,23 +2326,36 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			if (err)
 				return err;
 		} else  {
-			err = ib_get_cached_gid(ib_dev,
+			err = ib_get_cached_gid(sqp->qp.ibqp.device,
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
 
@@ -2356,7 +2366,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		sqp->ud_header.lrh.source_lid = cpu_to_be16(ah->av.ib.g_slid & 0x7f);
 	}
 
-	if (is_grh) {
+	if (is_grh || (ip_version == 6)) {
 		sqp->ud_header.grh.traffic_class =
 			(be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20) & 0xff;
 		sqp->ud_header.grh.flow_label    =
@@ -2385,6 +2395,25 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
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
@@ -2413,34 +2442,27 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 
 	if (is_eth) {
 		struct in6_addr in6;
-
+		u16 ether_type;
 		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 
+		ether_type = (!is_udp) ? MLX4_IB_IBOE_ETHERTYPE :
+			(ip_version == 4 ? ETH_P_IP : ETH_P_IPV6);
+
 		mlx->sched_prio = cpu_to_be16(pcp);
 
+		ether_addr_copy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac);
 		memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac, 6);
-		/* FIXME: cache smac value? */
 		memcpy(&ctrl->srcrb_flags16[0], ah->av.eth.mac, 2);
 		memcpy(&ctrl->imm, ah->av.eth.mac + 2, 4);
 		memcpy(&in6, sgid.raw, sizeof(in6));
 
-		if (!mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
-			u64 mac = atomic64_read(&to_mdev(ib_dev)->iboe.mac[sqp->qp.port - 1]);
-			u8 smac[ETH_ALEN];
-
-			mlx4_u64_to_smac(smac, mac);
-			memcpy(sqp->ud_header.eth.smac_h, smac, ETH_ALEN);
-		} else {
-			/* use the src mac of the tunnel */
-			memcpy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac, ETH_ALEN);
-		}
 
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
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
