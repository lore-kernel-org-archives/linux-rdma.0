From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/ocrdma: Changes to comply with RoCEv2 Specification changes
Date: Thu, 27 Nov 2014 06:26:59 +0530
Message-ID: <2b04806d-55ea-48f9-a841-f096c9e810af@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Made changes to convey 'network_hdr_type' to card both during modify_qp and
create_ah.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   64 +++++++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   26 +++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   16 ++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   11 ++++-
 5 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b43456a..daf6c9e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -92,6 +92,7 @@ struct ocrdma_dev_attr {
 	u8 local_ca_ack_delay;
 	u8 ird;
 	u8 num_ird_pages;
+	u8 network_hdr_type;
 };
 
 struct ocrdma_dma_mem {
@@ -304,6 +305,7 @@ struct ocrdma_ah {
 	struct ocrdma_av *av;
 	u16 sgid_index;
 	u32 id;
+	u8 network_hdr_type;
 };
 
 struct ocrdma_qp_hwq_info {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index ac02ce4..a1712c7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -45,6 +45,13 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	struct ocrdma_eth_vlan eth;
 	struct ocrdma_grh grh;
 	int eth_sz;
+	ushort roce_l3_type = 0;
+	struct iphdr ipv4;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
 
 	memset(&eth, 0, sizeof(eth));
 	memset(&grh, 0, sizeof(grh));
@@ -53,35 +60,65 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	vlan_tag = attr->vlan_id;
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
+
+	switch (attr->grh.network_hdr_type) {
+	case OCRDMA_L3_TYPE_IB_GRH:
+		roce_l3_type = 0x8915;
+		break;
+	case OCRDMA_L3_TYPE_IPV4:
+		roce_l3_type = 0x0800;
+		break;
+	case OCRDMA_L3_TYPE_IPV6:
+		roce_l3_type = 0x86dd;
+		break;
+	}
 	if (vlan_tag && (vlan_tag < 0x1000)) {
 		eth.eth_type = cpu_to_be16(0x8100);
-		eth.roce_eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
+		eth.roce_eth_type = cpu_to_be16(roce_l3_type);
 		vlan_tag |= (dev->sl & 0x07) << OCRDMA_VID_PCP_SHIFT;
 		eth.vlan_tag = cpu_to_be16(vlan_tag);
 		eth_sz = sizeof(struct ocrdma_eth_vlan);
 		vlan_enabled = true;
 	} else {
-		eth.eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
+		eth.eth_type = cpu_to_be16(roce_l3_type);
 		eth_sz = sizeof(struct ocrdma_eth_basic);
 	}
+	ah->network_hdr_type = attr->grh.network_hdr_type;
 	/* MAC */
 	memcpy(&eth.smac[0], &dev->nic_info.mac_addr[0], ETH_ALEN);
 	status = ocrdma_resolve_dmac(dev, attr, &eth.dmac[0]);
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
+
 	/* Eth HDR */
 	memcpy(&ah->av->eth_hdr, &eth, eth_sz);
-	memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
+	if (attr->grh.network_hdr_type == RDMA_NETWORK_IPv4) {
+		*((__be16 *)&ipv4) = htons((4 << 12) | (5 << 8) |
+				     attr->grh.traffic_class);
+		ipv4.id = cpu_to_be16(pdid);
+		ipv4.frag_off = htons(IP_DF);
+		ipv4.tot_len = htons(20);
+		ipv4.ttl = attr->grh.hop_limit;
+		/* TBD Set protocol to 0x11(UDP) */
+		ipv4.protocol = 0x1b;
+		rdma_gid2ip(&sgid_addr._sockaddr, sgid);
+		ipv4.saddr = sgid_addr._sockaddr_in.sin_addr.s_addr;
+		rdma_gid2ip(&dgid_addr._sockaddr, &attr->grh.dgid);
+		ipv4.daddr = dgid_addr._sockaddr_in.sin_addr.s_addr;
+		memcpy((u8 *)ah->av + eth_sz, &ipv4, sizeof(struct iphdr));
+	} else {
+		memcpy(&grh.sgid[0], sgid->raw, sizeof(union ib_gid));
+		grh.tclass_flow = cpu_to_be32((6 << 28) |
+				(attr->grh.traffic_class << 24) |
+				attr->grh.flow_label);
+		memcpy(&grh.dgid[0], attr->grh.dgid.raw,
+		       sizeof(attr->grh.dgid.raw));
+		/* 0x1b is next header value in GRH */
+		grh.pdid_hoplimit = cpu_to_be32((pdid << 16) |
+				(0x1b << 8) | attr->grh.hop_limit);
+		memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
+	}
 	if (vlan_enabled)
 		ah->av->valid |= OCRDMA_AV_VLAN_VALID;
 	ah->av->valid = cpu_to_le32(ah->av->valid);
@@ -122,7 +159,8 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	if (pd->uctx &&
 	    memcmp(attr->dmac, &zmac, ETH_ALEN)) {
 		status = rdma_addr_find_dmac_by_grh(&sgid, &attr->grh.dgid,
-                                        attr->dmac, &attr->vlan_id);
+						    attr->dmac, &attr->vlan_id,
+						   &attr->grh.network_hdr_type);
 		if (status) {
 			pr_err("%s(): Failed to resolve dmac from gid." 
 				"status = %d\n", __func__, status);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 638bff1..9aa485f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1083,6 +1083,9 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->local_ca_ack_delay = (rsp->max_pd_ca_ack_delay &
 				    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK) >>
 	    OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT;
+	attr->network_hdr_type = (rsp->max_pd_ca_ack_delay &
+				  OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK) >>
+				  OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT;
 	attr->max_mw = rsp->max_mw;
 	attr->max_mr = rsp->max_mr;
 	attr->max_mr_size = ((u64)rsp->max_mr_size_hi << 32) |
@@ -2281,6 +2284,11 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	union ib_gid sgid, zgid;
 	u32 vlan_id;
 	u8 mac_addr[6];
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
 
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
 		return -EINVAL;
@@ -2310,6 +2318,20 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	ocrdma_resolve_dmac(qp->dev, ah_attr, &mac_addr[0]);
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
 				(mac_addr[2] << 16) | (mac_addr[3] << 24);
+
+	if (attrs->ah_attr.grh.network_hdr_type == RDMA_NETWORK_IPv4) {
+		status = rdma_gid2ip(&sgid_addr._sockaddr, &sgid);
+		if (status)
+			return status;
+
+		status = rdma_gid2ip(&dgid_addr._sockaddr, &ah_attr->grh.dgid);
+		if (status)
+			return status;
+		memcpy(&cmd->params.dgid[0],
+		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
+		memcpy(&cmd->params.sgid[0],
+		       &sgid_addr._sockaddr_in.sin_addr.s_addr, 4);
+	}
 	/* convert them to LE format. */
 	ocrdma_cpu_to_le32(&cmd->params.dgid[0], sizeof(cmd->params.dgid));
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
@@ -2322,6 +2344,10 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		cmd->params.rnt_rc_sl_fl |=
 			(qp->dev->sl & 0x07) << OCRDMA_QP_PARAMS_SL_SHIFT;
 	}
+	cmd->params.max_sge_recv_flags |=
+					((attrs->ah_attr.grh.network_hdr_type <<
+					 OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT) &
+					 OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 4e03648..5f6ed51 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -122,6 +122,12 @@ enum {
 	OCRDMA_DB_RQ_SHIFT		= 24
 };
 
+enum {
+	OCRDMA_L3_TYPE_IB_GRH	= 0x00,
+	OCRDMA_L3_TYPE_IPV4	= 0x01,
+	OCRDMA_L3_TYPE_IPV6	= 0x02
+};
+
 #define OCRDMA_DB_CQ_RING_ID_MASK       0x3FF	/* bits 0 - 9 */
 #define OCRDMA_DB_CQ_RING_ID_EXT_MASK  0x0C00	/* bits 10-11 of qid at 12-11 */
 /* qid #2 msbits at 12-11 */
@@ -460,6 +466,9 @@ enum {
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT		= 8,
 	OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_MASK		= 0xFF <<
 				OCRDMA_MBX_QUERY_CFG_CA_ACK_DELAY_SHIFT,
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT		= 0,
+	OCRDMA_MBX_QUERY_CFG_L3_TYPE_MASK		= 0xFF <<
+				OCRDMA_MBX_QUERY_CFG_L3_TYPE_SHIFT,
 
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_SHIFT		= 0,
 	OCRDMA_MBX_QUERY_CFG_MAX_SEND_SGE_MASK		= 0xFFFF,
@@ -1021,6 +1030,8 @@ enum {
 	OCRDMA_QP_PARAMS_STATE_MASK		= BIT(5) | BIT(6) | BIT(7),
 	OCRDMA_QP_PARAMS_FLAGS_SQD_ASYNC	= BIT(8),
 	OCRDMA_QP_PARAMS_FLAGS_INB_ATEN		= BIT(9),
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_SHIFT	= 11,
+	OCRDMA_QP_PARAMS_FLAGS_L3_TYPE_MASK	= BIT(11) | BIT(12) | BIT(13),
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT	= 16,
 	OCRDMA_QP_PARAMS_MAX_SGE_RECV_MASK	= 0xFFFF <<
 					OCRDMA_QP_PARAMS_MAX_SGE_RECV_SHIFT,
@@ -1607,8 +1618,11 @@ enum {
 
 	/* w1 */
 	OCRDMA_CQE_UD_XFER_LEN_SHIFT	= 16,
+	OCRDMA_CQE_UD_XFER_LEN_MASK	= 0x1FFF,
 	OCRDMA_CQE_PKEY_SHIFT		= 0,
 	OCRDMA_CQE_PKEY_MASK		= 0xFFFF,
+	OCRDMA_CQE_UD_L3TYPE_SHIFT	= 29,
+	OCRDMA_CQE_UD_L3TYPE_MASK	= 0x07,
 
 	/* w2 */
 	OCRDMA_CQE_QPN_SHIFT		= 0,
@@ -1732,7 +1746,7 @@ struct ocrdma_ewqe_ud_hdr {
 	u32 rsvd_dest_qpn;
 	u32 qkey;
 	u32 rsvd_ahid;
-	u32 rsvd;
+	u32 network_hdr_type;
 };
 
 /* extended wqe followed by hdr_wqe for Fast Memory register */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index ef6c78c..f85765e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1829,6 +1829,7 @@ static void ocrdma_build_ud_hdr(struct ocrdma_qp *qp,
 	else
 		ud_hdr->qkey = wr->wr.ud.remote_qkey;
 	ud_hdr->rsvd_ahid = ah->id;
+	ud_hdr->network_hdr_type = ah->network_hdr_type;
 }
 
 static void ocrdma_build_sges(struct ocrdma_hdr_wqe *hdr,
@@ -2563,6 +2564,7 @@ static bool ocrdma_poll_scqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 static int ocrdma_update_ud_rcqe(struct ib_wc *ibwc, struct ocrdma_cqe *cqe)
 {
 	int status;
+	u16 network_hdr_type = 0;
 
 	status = (le32_to_cpu(cqe->flags_status_srcqpn) &
 		OCRDMA_CQE_UD_STATUS_MASK) >> OCRDMA_CQE_UD_STATUS_SHIFT;
@@ -2572,7 +2574,14 @@ static int ocrdma_update_ud_rcqe(struct ib_wc *ibwc, struct ocrdma_cqe *cqe)
 						OCRDMA_CQE_PKEY_MASK;
 	ibwc->wc_flags = IB_WC_GRH;
 	ibwc->byte_len = (le32_to_cpu(cqe->ud.rxlen_pkey) >>
-					OCRDMA_CQE_UD_XFER_LEN_SHIFT);
+			  OCRDMA_CQE_UD_XFER_LEN_SHIFT) &
+			  OCRDMA_CQE_UD_XFER_LEN_MASK;
+	network_hdr_type = (le32_to_cpu(cqe->ud.rxlen_pkey) >>
+		   OCRDMA_CQE_UD_L3TYPE_SHIFT) & OCRDMA_CQE_UD_L3TYPE_MASK;
+
+	ibwc->wc_flags |= IB_WC_WITH_L3_TYPE;
+	ibwc->network_hdr_type = network_hdr_type;
+
 	return status;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
