From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 30/32] IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
Date: Wed, 11 Mar 2015 10:26:22 +0530
Message-ID: <81f95c05-1cee-493c-9e11-11137819fc2c@CMEXHTCAS2.ad.emulex.com>
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

RoCEv2 packets are sent over IP/UDP protocols.
The mlx4 driver uses a type of RAW QP to send packets for QP1 and
therefore needs to build the network headers below BTH in software.

This patche adds option to build QP1 packets with IP and UDP headers if
RoCEv2 is requested.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 84 +++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 1141cf0..fb37415 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -32,6 +32,8 @@
  */
 
 #include <linux/log2.h>
+#include <linux/if_ether.h>
+#include <net/ip.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 
@@ -2169,16 +2171,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
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
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
@@ -2198,6 +2191,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	bool is_eth;
 	bool is_vlan = false;
 	bool is_grh;
+	bool is_udp = false;
+	int ip_version = 0;
 
 	send_size = 0;
 	for (i = 0; i < wr->num_sge; ++i)
@@ -2206,6 +2201,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
+		struct ib_gid_attr gid_attr;
+
 		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
 			/* When multi-function is enabled, the ib_core gid
 			 * indexes don't necessarily match the hw ones, so
@@ -2216,23 +2213,31 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			if (err)
 				return err;
 		} else  {
-			err = ib_get_cached_gid(ib_dev,
+			err = ib_get_cached_gid(sqp->qp.ibqp.device,
 						be32_to_cpu(ah->av.ib.port_pd) >> 24,
-						ah->av.ib.gid_index, &sgid,
-						NULL);
+						ah->av.ib.gid_index, &sgid, &gid_attr);
 			if (!err && !memcmp(&sgid, &zgid, sizeof(sgid)))
 				err = -ENOENT;
-			if (err)
+			if (!err) {
+				is_udp = (gid_attr.gid_type == IB_GID_TYPE_ROCE_V2) ? true : false;
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
 
@@ -2243,12 +2248,14 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		sqp->ud_header.lrh.source_lid = cpu_to_be16(ah->av.ib.g_slid & 0x7f);
 	}
 
-	if (is_grh) {
+	if (is_grh || (ip_version == 6)) {
 		sqp->ud_header.grh.traffic_class =
 			(be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20) & 0xff;
 		sqp->ud_header.grh.flow_label    =
 			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
-		sqp->ud_header.grh.hop_limit     = ah->av.ib.hop_limit;
+
+		sqp->ud_header.grh.hop_limit     = (is_udp) ?
+			IPV6_DEFAULT_HOPLIMIT : ah->av.ib.hop_limit;
 		if (is_eth)
 			memcpy(sqp->ud_header.grh.source_gid.raw, sgid.raw, 16);
 		else {
@@ -2272,6 +2279,26 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		       ah->av.ib.dgid, 16);
 	}
 
+	if (ip_version == 4) {
+		sqp->ud_header.ip4.tos =
+			(be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20) & 0xff;
+		sqp->ud_header.ip4.id = 0;
+		sqp->ud_header.ip4.frag_off = htons(IP_DF);
+		sqp->ud_header.ip4.ttl = (is_udp) ?
+			IPV6_DEFAULT_HOPLIMIT : ah->av.eth.hop_limit;
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
@@ -2300,34 +2327,27 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 
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
