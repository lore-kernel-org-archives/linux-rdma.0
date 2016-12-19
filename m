From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for rdma-next] RDMA: Adding ethertype ETH_P_IBOE
Date: Mon, 19 Dec 2016 11:28:46 -0800
Message-ID: <1482175726-27366-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the if_ether.h with the  ethertype for Infiniband over
Ethernet packets. Also, removing the occurances of 0x8915
from infiniband vendor drivers.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c                    | 6 +-----
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           | 4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           | 3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          | 5 -----
 drivers/infiniband/hw/qedr/qedr_cm.c               | 2 +-
 drivers/infiniband/hw/qedr/qedr_cm.h               | 1 -
 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h | 1 -
 drivers/infiniband/hw/usnic/usnic_fwd.h            | 3 ++-
 include/uapi/linux/if_ether.h                      | 1 +
 9 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c068add..7d76f76 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -76,10 +76,6 @@ enum {
 	MLX4_IB_LSO_HEADER_SPARE	= 128,
 };
 
-enum {
-	MLX4_IB_IBOE_ETHERTYPE		= 0x8915
-};
-
 struct mlx4_ib_sqp {
 	struct mlx4_ib_qp	qp;
 	int			pkey_index;
@@ -2588,7 +2584,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		u16 ether_type;
 		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 
-		ether_type = (!is_udp) ? MLX4_IB_IBOE_ETHERTYPE :
+		ether_type = (!is_udp) ? ETH_P_IBOE:
 			(ip_version == 4 ? ETH_P_IP : ETH_P_IPV6);
 
 		mlx->sched_prio = cpu_to_be16(pcp);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 14d33b0..cd66e1e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -59,7 +59,7 @@ static u16 ocrdma_hdr_type_to_proto_num(int devid, u8 hdr_type)
 {
 	switch (hdr_type) {
 	case OCRDMA_L3_TYPE_IB_GRH:
-		return (u16)0x8915;
+		return (u16)ETH_P_IBOE;
 	case OCRDMA_L3_TYPE_IPV4:
 		return (u16)0x0800;
 	case OCRDMA_L3_TYPE_IPV6:
@@ -94,7 +94,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	proto_num = ocrdma_hdr_type_to_proto_num(dev->id, ah->hdr_type);
 	if (!proto_num)
 		return -EINVAL;
-	nxthdr = (proto_num == 0x8915) ? 0x1b : 0x11;
+	nxthdr = (proto_num == ETH_P_IBOE) ? 0x1b : 0x11;
 	/* VLAN */
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 9a30520..aa69671 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -44,6 +44,7 @@
 #include <linux/interrupt.h>
 #include <linux/log2.h>
 #include <linux/dma-mapping.h>
+#include <linux/if_ether.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
@@ -2984,7 +2985,7 @@ static int ocrdma_parse_dcbxcfg_rsp(struct ocrdma_dev *dev, int ptype,
 				OCRDMA_APP_PARAM_APP_PROTO_MASK;
 
 		if (
-			valid && proto == OCRDMA_APP_PROTO_ROCE &&
+			valid && proto == ETH_P_IBOE &&
 			proto_sel == OCRDMA_PROTO_SELECT_L2) {
 			for (slindx = 0; slindx <
 				OCRDMA_MAX_SERVICE_LEVEL_INDEX; slindx++) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 37df448..6ef89c2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1901,7 +1901,6 @@ struct ocrdma_eth_vlan {
 	u8 smac[6];
 	__be16 eth_type;
 	__be16 vlan_tag;
-#define OCRDMA_ROCE_ETH_TYPE 0x8915
 	__be16 roce_eth_type;
 } __packed;
 
@@ -2179,10 +2178,6 @@ enum OCRDMA_DCBX_PARAM_TYPE {
 	OCRDMA_PARAMETER_TYPE_PEER	= 0x02
 };
 
-enum OCRDMA_DCBX_APP_PROTO {
-	OCRDMA_APP_PROTO_ROCE	= 0x8915
-};
-
 enum OCRDMA_DCBX_PROTO {
 	OCRDMA_PROTO_SELECT_L2	= 0x00,
 	OCRDMA_PROTO_SELECT_L4	= 0x01
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index 63890eb..c6aee03 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -293,7 +293,7 @@ static inline int qedr_gsi_build_header(struct qedr_dev *dev,
 	has_udp = (sgid_attr.gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP);
 	if (!has_udp) {
 		/* RoCE v1 */
-		ether_type = ETH_P_ROCE;
+		ether_type = ETH_P_IBOE;
 		*roce_mode = ROCE_V1;
 	} else if (ipv6_addr_v4mapped((struct in6_addr *)&sgid)) {
 		/* RoCE v2 IPv4 */
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.h b/drivers/infiniband/hw/qedr/qedr_cm.h
index 9ba6e15..78efb1b 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.h
+++ b/drivers/infiniband/hw/qedr/qedr_cm.h
@@ -37,7 +37,6 @@
 
 #define QEDR_GSI_MAX_RECV_SGE	(1)	/* LL2 FW limitation */
 
-#define ETH_P_ROCE		(0x8915)
 #define QEDR_ROCE_V2_UDP_SPORT	(0000)
 
 static inline u32 qedr_get_ipv4_from_gid(u8 *gid)
diff --git a/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h b/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
index 596e0ed..bf7d197 100644
--- a/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
+++ b/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
@@ -34,7 +34,6 @@
 #ifndef USNIC_CMN_PKT_HDR_H
 #define USNIC_CMN_PKT_HDR_H
 
-#define USNIC_ROCE_ETHERTYPE		(0x8915)
 #define USNIC_ROCE_GRH_VER              (8)
 #define USNIC_PROTO_VER                 (1)
 #define USNIC_ROCE_GRH_VER_SHIFT        (4)
diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.h b/drivers/infiniband/hw/usnic/usnic_fwd.h
index 3a8add9..b2ac22b 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.h
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.h
@@ -36,6 +36,7 @@
 
 #include <linux/if.h>
 #include <linux/netdevice.h>
+#include <linux/if_ether.h>
 #include <linux/pci.h>
 #include <linux/in.h>
 
@@ -97,7 +98,7 @@ static inline void usnic_fwd_init_usnic_filter(struct filter *filter,
 						uint32_t usnic_id)
 {
 	filter->type = FILTER_USNIC_ID;
-	filter->u.usnic.ethtype = USNIC_ROCE_ETHERTYPE;
+	filter->u.usnic.ethtype = ETH_P_IBOE;
 	filter->u.usnic.flags = FILTER_FIELD_USNIC_ETHTYPE |
 				FILTER_FIELD_USNIC_ID |
 				FILTER_FIELD_USNIC_PROTO;
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 117d02e..625c08c 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -90,6 +90,7 @@
 #define ETH_P_NCSI	0x88F8		/* NCSI protocol		*/
 #define ETH_P_PRP	0x88FB		/* IEC 62439-3 PRP/HSRv0	*/
 #define ETH_P_FCOE	0x8906		/* Fibre Channel over Ethernet  */
+#define ETH_P_IBOE	0x8915		/* Infiniband over Ethernet	*/
 #define ETH_P_TDLS	0x890D          /* TDLS */
 #define ETH_P_FIP	0x8914		/* FCoE Initialization Protocol */
 #define ETH_P_80221	0x8917		/* IEEE 802.21 Media Independent Handover Protocol */
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
