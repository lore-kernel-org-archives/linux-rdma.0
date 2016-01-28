From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 2/4] RDMA/ocrdma: Support RoCE-v2 in the UD path
Date: Thu, 28 Jan 2016 08:59:57 -0500
Message-ID: <1453989599-21307-3-git-send-email-devesh.sharma@avagotech.com>
References: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453989599-21307-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds following changes to support RoCE-v2
in the UD path.

 * During AH creation GID-type is resolved for a given gid-index.
 * Based on GID-type protocol header is built.
 * Work completion reports network header type and set
   IB_WC_WITH_NETWORK_HDR_TYPE flag in wc->wc_flags to indicate
   that the network header type is valid.

Signed-off-by: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 70 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  5 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 22 +++++++--
 4 files changed, 82 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 3ef0b52..b716259 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -360,6 +360,7 @@ struct ocrdma_ah {
 	struct ocrdma_av *av;
 	u16 sgid_index;
 	u32 id;
+	u8 hdr_type;
 };
 
 struct ocrdma_qp_hwq_info {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 3790771..4aed1db 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -55,6 +55,21 @@
 
 #define OCRDMA_VID_PCP_SHIFT	0xD
 
+static u16 ocrdma_hdr_type_to_proto_num(int devid, u8 hdr_type)
+{
+	switch (hdr_type) {
+	case OCRDMA_L3_TYPE_IB_GRH:
+		return (u16)0x8915;
+	case OCRDMA_L3_TYPE_IPV4:
+		return (u16)0x0800;
+	case OCRDMA_L3_TYPE_IPV6:
+		return (u16)0x86dd;
+	default:
+		pr_err("ocrdma%d: Invalid network header\n", devid);
+		return 0;
+	}
+}
+
 static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 			struct ib_ah_attr *attr, union ib_gid *sgid,
 			int pdid, bool *isvlan, u16 vlan_tag)
@@ -63,10 +78,23 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	struct ocrdma_eth_vlan eth;
 	struct ocrdma_grh grh;
 	int eth_sz;
+	u16 proto_num = 0;
+	u8 nxthdr = 0x11;
+	struct iphdr ipv4;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
 
 	memset(&eth, 0, sizeof(eth));
 	memset(&grh, 0, sizeof(grh));
 
+	/* Protocol Number */
+	proto_num = ocrdma_hdr_type_to_proto_num(dev->id, ah->hdr_type);
+	if (!proto_num)
+		return -EINVAL;
+	nxthdr = (proto_num == 0x8915) ? 0x1b : 0x11;
 	/* VLAN */
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
@@ -78,13 +106,13 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 				dev->id);
 		}
 		eth.eth_type = cpu_to_be16(0x8100);
-		eth.roce_eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
+		eth.roce_eth_type = cpu_to_be16(proto_num);
 		vlan_tag |= (dev->sl & 0x07) << OCRDMA_VID_PCP_SHIFT;
 		eth.vlan_tag = cpu_to_be16(vlan_tag);
 		eth_sz = sizeof(struct ocrdma_eth_vlan);
 		*isvlan = true;
 	} else {
-		eth.eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
+		eth.eth_type = cpu_to_be16(proto_num);
 		eth_sz = sizeof(struct ocrdma_eth_basic);
 	}
 	/* MAC */
@@ -93,18 +121,33 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	if (status)
 		return status;
 	ah->sgid_index = attr->grh.sgid_index;
-	memcpy(&grh.sgid[0], sgid->raw, sizeof(union ib_gid));
-	memcpy(&grh.dgid[0], attr->grh.dgid.raw, sizeof(attr->grh.dgid.raw));
-
-	grh.tclass_flow = cpu_to_be32((6 << 28) |
-			(attr->grh.traffic_class << 24) |
-			attr->grh.flow_label);
-	/* 0x1b is next header value in GRH */
-	grh.pdid_hoplimit = cpu_to_be32((pdid << 16) |
-			(0x1b << 8) | attr->grh.hop_limit);
 	/* Eth HDR */
 	memcpy(&ah->av->eth_hdr, &eth, eth_sz);
-	memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
+	if (ah->hdr_type == RDMA_NETWORK_IPV4) {
+		*((__be16 *)&ipv4) = htons((4 << 12) | (5 << 8) |
+					   attr->grh.traffic_class);
+		ipv4.id = cpu_to_be16(pdid);
+		ipv4.frag_off = htons(IP_DF);
+		ipv4.tot_len = htons(0);
+		ipv4.ttl = attr->grh.hop_limit;
+		ipv4.protocol = nxthdr;
+		rdma_gid2ip(&sgid_addr._sockaddr, sgid);
+		ipv4.saddr = sgid_addr._sockaddr_in.sin_addr.s_addr;
+		rdma_gid2ip(&dgid_addr._sockaddr, &attr->grh.dgid);
+		ipv4.daddr = dgid_addr._sockaddr_in.sin_addr.s_addr;
+		memcpy((u8 *)ah->av + eth_sz, &ipv4, sizeof(struct iphdr));
+	} else {
+		memcpy(&grh.sgid[0], sgid->raw, sizeof(union ib_gid));
+		grh.tclass_flow = cpu_to_be32((6 << 28) |
+					      (attr->grh.traffic_class << 24) |
+					      attr->grh.flow_label);
+		memcpy(&grh.dgid[0], attr->grh.dgid.raw,
+		       sizeof(attr->grh.dgid.raw));
+		grh.pdid_hoplimit = cpu_to_be32((pdid << 16) |
+						(nxthdr << 8) |
+						attr->grh.hop_limit);
+		memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
+	}
 	if (*isvlan)
 		ah->av->valid |= OCRDMA_AV_VLAN_VALID;
 	ah->av->valid = cpu_to_le32(ah->av->valid);
@@ -128,6 +171,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 
 	if (atomic_cmpxchg(&dev->update_sl, 1, 0))
 		ocrdma_init_service_level(dev);
+
 	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
@@ -148,6 +192,8 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 			vlan_tag = vlan_dev_vlan_id(sgid_attr.ndev);
 		dev_put(sgid_attr.ndev);
 	}
+	/* Get network header type for this GID */
+	ah->hdr_type = ib_gid_to_network_type(sgid_attr.gid_type, &sgid);
 
 	if ((pd->uctx) &&
 	    (!rdma_is_multicast_addr((struct in6_addr *)attr->grh.dgid.raw)) &&
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 8d75bd4..3d15948 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1740,8 +1740,11 @@ enum {
 
 	/* w1 */
 	OCRDMA_CQE_UD_XFER_LEN_SHIFT	= 16,
+	OCRDMA_CQE_UD_XFER_LEN_MASK     = 0x1FFF,
 	OCRDMA_CQE_PKEY_SHIFT		= 0,
 	OCRDMA_CQE_PKEY_MASK		= 0xFFFF,
+	OCRDMA_CQE_UD_L3TYPE_SHIFT      = 29,
+	OCRDMA_CQE_UD_L3TYPE_MASK       = 0x07,
 
 	/* w2 */
 	OCRDMA_CQE_QPN_SHIFT		= 0,
@@ -1866,7 +1869,7 @@ struct ocrdma_ewqe_ud_hdr {
 	u32 rsvd_dest_qpn;
 	u32 qkey;
 	u32 rsvd_ahid;
-	u32 rsvd;
+	u32 hdr_type;
 };
 
 /* extended wqe followed by hdr_wqe for Fast Memory register */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d4c687b..a8e7391 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2006,6 +2006,7 @@ static void ocrdma_build_ud_hdr(struct ocrdma_qp *qp,
 	else
 		ud_hdr->qkey = ud_wr(wr)->remote_qkey;
 	ud_hdr->rsvd_ahid = ah->id;
+	ud_hdr->hdr_type = ah->hdr_type;
 	if (ah->av->valid & OCRDMA_AV_VLAN_VALID)
 		hdr->cw |= (OCRDMA_FLAG_AH_VLAN_PR << OCRDMA_WQE_FLAGS_SHIFT);
 }
@@ -2718,9 +2719,11 @@ static bool ocrdma_poll_scqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 	return expand;
 }
 
-static int ocrdma_update_ud_rcqe(struct ib_wc *ibwc, struct ocrdma_cqe *cqe)
+static int ocrdma_update_ud_rcqe(struct ocrdma_dev *dev, struct ib_wc *ibwc,
+				 struct ocrdma_cqe *cqe)
 {
 	int status;
+	u16 hdr_type = 0;
 
 	status = (le32_to_cpu(cqe->flags_status_srcqpn) &
 		OCRDMA_CQE_UD_STATUS_MASK) >> OCRDMA_CQE_UD_STATUS_SHIFT;
@@ -2730,7 +2733,17 @@ static int ocrdma_update_ud_rcqe(struct ib_wc *ibwc, struct ocrdma_cqe *cqe)
 						OCRDMA_CQE_PKEY_MASK;
 	ibwc->wc_flags = IB_WC_GRH;
 	ibwc->byte_len = (le32_to_cpu(cqe->ud.rxlen_pkey) >>
-					OCRDMA_CQE_UD_XFER_LEN_SHIFT);
+			  OCRDMA_CQE_UD_XFER_LEN_SHIFT) &
+			  OCRDMA_CQE_UD_XFER_LEN_MASK;
+
+	if (ocrdma_is_udp_encap_supported(dev)) {
+		hdr_type = (le32_to_cpu(cqe->ud.rxlen_pkey) >>
+			    OCRDMA_CQE_UD_L3TYPE_SHIFT) &
+			    OCRDMA_CQE_UD_L3TYPE_MASK;
+		ibwc->wc_flags |= IB_WC_WITH_NETWORK_HDR_TYPE;
+		ibwc->network_hdr_type = hdr_type;
+	}
+
 	return status;
 }
 
@@ -2793,12 +2806,15 @@ static bool ocrdma_poll_err_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 static void ocrdma_poll_success_rcqe(struct ocrdma_qp *qp,
 				     struct ocrdma_cqe *cqe, struct ib_wc *ibwc)
 {
+	struct ocrdma_dev *dev;
+
+	dev = get_ocrdma_dev(qp->ibqp.device);
 	ibwc->opcode = IB_WC_RECV;
 	ibwc->qp = &qp->ibqp;
 	ibwc->status = IB_WC_SUCCESS;
 
 	if (qp->qp_type == IB_QPT_UD || qp->qp_type == IB_QPT_GSI)
-		ocrdma_update_ud_rcqe(ibwc, cqe);
+		ocrdma_update_ud_rcqe(dev, ibwc, cqe);
 	else
 		ibwc->byte_len = le32_to_cpu(cqe->rq.rxlen);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
