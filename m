Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FA14718D7
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805483; cv=none; b=Hqlcvf2JyAOPKEcZkv/18mtbncRg70WEFN7rZKpmCLIoluBh6pzevcB70V4hK2Bk5/GnjxR1nujbTFPWIvzRCogIUkS6fbDGlJAmjPa6bcwcueF+TiImpbSSxcEoMQiKltoZqgaGLMcPqCyzC81WNbevTvaDLKIL2/UlWv1Q8mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805483; c=relaxed/simple;
	bh=A4NwCe44H5dRBXui6rQiGku6HLtykrA3TqoKox0G448=;
	h=From:Subject:Message-Id:Mime-Version:To:Cc:In-Reply-To:Date:
	 References:Content-Type; b=MARhugnDcyOK6cv5f9EHp7nYLymtLTyz9ump2k3yUP2GMPX53bK/zOTA23Ads3ULVlniqeh2iIRPQU4uJJKgTWtc0S8Bg/MEzK9D+Qe70rD3FI55U46Y4MTJocqffvbFRrQncSew1PWCwGbOAmO/Ihxn+NG0baDiwg+xAjln5Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=VFlynPe/; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="VFlynPe/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805467; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=77qLxxAGY7lqnsLgjF+lQ/+fXiJ9KPXUQ/TmLakzoRc=;
 b=VFlynPe/sCrQcUazR55y9+oUFNaTlAd1tYz7kHmZoOokw/rEezoXG9VlGKrngCWSvs0x0J
 +XzDQO3T9PRUnsis/iiQsIMzp29aa0MHq1wKYBQP7NsTsuTr7IticARFOTBL5z2gxvRBJb
 7WxyEzmY41eHZMMFENzqx4pqp2abTMcdzXsyN/eJLwcPq91EPVrkEubeShwOSIDB2LC+FV
 D2R0z4c1QEL9AY6tAW4OAqHVOeeoQtI7srFS/mmk9b2e7+kP90amPPcUeHLQWgbxYk63yn
 BilVCEI3eoaFH471NIbAXAXTnSgAMZLg3CMSHrh4rU29l2k1+f9WtUOlEsVQHQ==
X-Original-From: Xin Tian <tianx@yunsilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH 13/15] yunsilicon: add the RDMA send path
Message-Id: <20261012114423.2471317-14-tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26accc819+d930ec+vger.kernel.org+tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:24 +0800
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
Date: Mon, 12 Oct 2026 19:44:24 +0800
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Add the post send path: WQE construction for the supported work request
types (including the UD QP1 header build), the doorbell update and the
send queue drain helpers.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/main.c |  21 +
 drivers/infiniband/hw/xsc/qp.c   | 691 +++++++++++++++++++++++++++++++
 2 files changed, 712 insertions(+)

diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index c4f306318..30927006b 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -526,6 +526,22 @@ static void xsc_ib_event(struct xsc_core_device *dev, void *context,
 		ib_dispatch_event(&ibev);
 }
 
+static void crc_table_init(struct xsc_ib_dev *dev)
+{
+	u32 c, i, j;
+
+	for (i = 0; i < 256; i++) {
+		c = i;
+		for (j = 0; j < 8; j++) {
+			if (c & 1)
+				c = 0xedb88320L ^ (c >> 1);
+			else
+				c = c >> 1;
+		}
+		dev->crc_32_table[i] = c;
+	}
+}
+
 static void xsc_ib_get_dev_fw_str(struct ib_device *ibdev, char *str)
 {
 	struct xsc_core_device *dev = to_xdev(ibdev)->xdev;
@@ -574,6 +590,7 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 	dev->ib_dev.ops.modify_qp		= xsc_ib_modify_qp;
 	dev->ib_dev.ops.query_qp		= xsc_ib_query_qp;
 	dev->ib_dev.ops.destroy_qp		= xsc_ib_destroy_qp;
+	dev->ib_dev.ops.post_send		= xsc_ib_post_send;
 	dev->ib_dev.ops.post_recv		= xsc_ib_post_recv;
 	dev->ib_dev.ops.create_cq		= xsc_ib_create_cq;
 	dev->ib_dev.ops.destroy_cq		= xsc_ib_destroy_cq;
@@ -586,6 +603,8 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 
 	dev->ib_dev.ops.get_port_immutable		= xsc_port_immutable;
 
+	dev->ib_dev.ops.drain_sq		= xsc_ib_drain_sq;
+	dev->ib_dev.ops.drain_rq		= xsc_ib_drain_rq;
 	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
 	dev->ib_dev.ops.create_srq		= xsc_ib_create_srq;
 	dev->ib_dev.ops.destroy_srq		= xsc_ib_destroy_srq;
@@ -709,7 +728,9 @@ static int init_one(struct xsc_core_device *xdev,
 
 	init_node_data(dev);
 
+	crc_table_init(dev);
 
+	build_opcode_map(dev);
 
 	xsc_reg_local_dma_mr(xdev);
 
diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/qp.c
index 6a83adc9c..9c79e09a7 100644
--- a/drivers/infiniband/hw/xsc/qp.c
+++ b/drivers/infiniband/hw/xsc/qp.c
@@ -28,6 +28,23 @@ enum {
 #define UDP_SPORT_MASK			0xffff
 #define UDP_SPORT_OFFSET		0
 
+void build_opcode_map(struct xsc_ib_dev *dev)
+{
+	struct xsc_msg_opcode *xsc_ib_opcode = dev->xdev->board_info->msg_opcode;
+
+	dev->opcode_map[IB_WR_SEND] = xsc_ib_opcode->send;
+	dev->opcode_map[IB_WR_SEND_WITH_IMM] = xsc_ib_opcode->send_with_imm;
+	dev->opcode_map[IB_WR_RDMA_WRITE] = xsc_ib_opcode->rdma_write;
+	dev->opcode_map[IB_WR_RDMA_WRITE_WITH_IMM] = xsc_ib_opcode->rdma_write_with_imm;
+	dev->opcode_map[IB_WR_RDMA_READ] = xsc_ib_opcode->rdma_read;
+	dev->opcode_map[IB_WR_ATOMIC_CMP_AND_SWP] = xsc_ib_opcode->atomic_cmp_and_swp;
+	dev->opcode_map[IB_WR_ATOMIC_FETCH_AND_ADD] = xsc_ib_opcode->atomic_fetch_and_add;
+	dev->opcode_map[IB_WR_MASKED_ATOMIC_CMP_AND_SWP] =
+		xsc_ib_opcode->masked_atomic_cmp_and_swp;
+	dev->opcode_map[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD] =
+		xsc_ib_opcode->masked_atomic_fetch_and_add;
+}
+
 static int is_qp0(enum ib_qp_type qp_type)
 {
 	return qp_type == IB_QPT_SMI;
@@ -58,6 +75,79 @@ static void *get_seg_wqe(void *first, int n)
 	return first + (n << XSC_BASE_WQE_SHIFT);
 }
 
+void *xsc_get_send_wqe(struct xsc_ib_qp *qp, int n)
+{
+	return get_wqe(qp, qp->sq.offset + (n << qp->sq.wqe_shift));
+}
+
+static int iboe_tos_to_sl(struct net_device *ndev, int tos)
+{
+	int prio;
+	struct net_device *dev;
+
+	prio = rt_tos2priority(tos);
+	dev = is_vlan_dev(ndev) ? vlan_dev_real_dev(ndev) : ndev;
+	if (dev->num_tc)
+		return netdev_get_prio_tc_map(dev, prio);
+
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
+	if (is_vlan_dev(ndev))
+		return (vlan_dev_get_egress_qos_mask(ndev, prio) &
+				VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+#endif
+	return 0;
+}
+
+static inline void set_remote_addr_seg(struct xsc_core_device *xdev,
+				       struct xsc_wqe_data_seg *remote_seg,
+				       u32 msg_len, u64 remote_addr, u32 rkey)
+{
+	xsc_set_data_seg(xdev, remote_seg, remote_addr, rkey, msg_len);
+}
+
+static void set_local_data_seg(struct xsc_core_device *xdev,
+			       struct xsc_wqe_data_seg *data_seg, struct ib_sge *sg)
+{
+	xsc_set_data_seg(xdev, data_seg, sg->addr, sg->lkey, sg->length);
+}
+
+static int set_data_inl_seg(struct xsc_ib_qp *qp, const struct ib_send_wr *wr, void *ctrl)
+{
+	struct xsc_wqe_data_seg *data_seg;
+	unsigned int seg_index;
+	void *addr;
+	int len;
+	int i;
+
+	for (i = 0, seg_index = 1; i < wr->num_sge; ++i, ++seg_index) {
+		if (likely(wr->sg_list[i].length)) {
+			addr = (void *)wr->sg_list[i].addr;
+			len  = wr->sg_list[i].length;
+
+			if (unlikely(len > qp->max_inline_data))
+				return -ENOMEM;
+
+			data_seg = get_seg_wqe(ctrl, seg_index);
+			data_seg->in_line = 1;
+			data_seg->len = len;
+			memcpy(data_seg->in_line_data, addr, len);
+		}
+	}
+
+	return 0;
+}
+
+static __be32 send_ieth(const struct ib_send_wr *wr)
+{
+	switch (wr->opcode) {
+	case IB_WR_SEND_WITH_IMM:
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		return wr->ex.imm_data;
+	default:
+		return 0;
+	}
+}
+
 static void xsc_ib_qp_event(struct xsc_core_qp *qp, int type)
 {
 	struct ib_qp *ibqp = &core_to_xqp(qp)->ibqp;
@@ -1367,13 +1457,521 @@ static int xsc_wq_overflow(struct xsc_ib_wq *wq, int nreq, struct xsc_ib_cq *cq)
 	return cur + nreq >= wq->max_post;
 }
 
+static inline void xsc_post_send_db(struct xsc_ib_qp *qp,
+				    struct xsc_core_device *xdev,
+				    int nreq)
+{
+	u32 next_pid;
+
+	if (unlikely(!nreq))
+		return;
+
+	qp->sq.head += nreq;
+
+	next_pid = qp->sq.head << (qp->sq.wqe_shift - XSC_BASE_WQE_SHIFT);
+	xsc_update_tx_db(xdev, qp->doorbell_qpn, next_pid);
+}
+
+static inline u32 xsc_crc32(struct xsc_ib_dev *dev, u32 crc, u8 *buf, size_t len)
+{
+	u32 i;
+
+	for (i = 0; i < len; i++)
+		crc = dev->crc_32_table[(crc ^ buf[i]) & 0xff] ^ (crc >> 8);
+
+	return crc;
+}
+
 #define BTH_QPN_MASK		(0x00ffffff)
 #define BTH_PSN_MASK		(0x00ffffff)
 
 /* Compute a partial ICRC for all the IB transport headers. */
+static u32 xsc_icrc_hdr(struct xsc_ib_dev *dev, void *pkt, u32 size, u32 *icrc)
+{
+	struct iphdr *ip4h = NULL;
+	struct ipv6hdr *ip6h = NULL;
+	struct udphdr *udph;
+	struct ib_unpacked_eth *eth;
+	struct rxe_bth *bth;
+	struct ib_unpacked_deth *deth;
+	struct ib_unpacked_vlan *vlan;
+	int crc;
+	int crc_field_len;
+	__be16 l3_type;
+	u8 *l3_start;
+
+	int hdr_size;
+
+	/* pseudo header buffer size is calculate using ipv6 header size since
+	 * it is bigger than ipv4
+	 */
+	u8 pshdr[sizeof(struct udphdr) +
+		sizeof(struct ipv6hdr) +
+		sizeof(*bth) + sizeof(*deth)];
+
+	eth = pkt;
+
+	if (eth->type == htons(ETH_P_8021Q)) {
+		vlan = (struct ib_unpacked_vlan *)(eth + 1);
+		l3_type = vlan->type;
+		l3_start = (u8 *)(vlan + 1);
+		size -= 4;
+	} else {
+		l3_type = eth->type;
+		l3_start = (u8 *)(eth + 1);
+	}
+
+	hdr_size = sizeof(struct udphdr) +
+		(l3_type == htons(ETH_P_IP) ?
+		sizeof(struct iphdr) : sizeof(struct ipv6hdr));
+
+	crc_field_len = hdr_size + sizeof(*bth) + sizeof(*deth);
+
+	if (crc_field_len != size) {
+		ibdev_err(&dev->ib_dev, "Unmatched hdr: expect %d actual %d\n",
+			  crc_field_len, size);
+		return -EINVAL;
+	}
+
+	ip4h = (struct iphdr *)(l3_start);
+	ip6h = (struct ipv6hdr *)(l3_start);
+	udph = (struct udphdr *)(ip4h + 1);
+	bth = (struct rxe_bth *)(udph + 1);
+
+	memcpy(pshdr, l3_start, crc_field_len);
+
+	/* This seed is the result of computing a CRC with a seed of
+	 * 0xfffffff and 8 bytes of 0xff representing a masked LRH.
+	 */
+	crc = 0xdebb20e3;
+
+	if (l3_type == htons(ETH_P_IP)) { /* IPv4 */
+		memcpy(pshdr, ip4h, hdr_size);
+		ip4h = (struct iphdr *)pshdr;
+		udph = (struct udphdr *)(ip4h + 1);
+
+		ip4h->ttl = 0xff;
+		ip4h->check = CSUM_MANGLED_0;
+		ip4h->tos = 0xff;
+	} else {				/* IPv6 */
+		memcpy(pshdr, ip6h, hdr_size);
+		ip6h = (struct ipv6hdr *)pshdr;
+		udph = (struct udphdr *)(ip6h + 1);
+
+		memset(ip6h->flow_lbl, 0xff, sizeof(ip6h->flow_lbl));
+		ip6h->priority = 0xf;
+		ip6h->hop_limit = 0xff;
+	}
+	udph->check = CSUM_MANGLED_0;
+
+	bth = (struct rxe_bth *)(udph + 1);
+	/* exclude bth.resv8a */
+	bth->qpn |= cpu_to_be32(~BTH_QPN_MASK);
+
+	*icrc = xsc_crc32(dev, crc, pshdr, crc_field_len);
+
+	return 0;
+}
 
 /* Routine for sending QP1 packets for RoCE V1 an V2 */
 /* TODO: sq hdr buf should be created dynamically for mult entry */
+static int build_qp1_send_v2(struct xsc_ib_dev *dev,
+			     struct xsc_ib_qp *qp,
+			     const struct ib_send_wr *wr,
+			     struct ib_sge *sge,
+			     int payload_size, u32 *crc)
+{
+	struct xsc_ib_ah *ah = container_of(ud_wr((struct ib_send_wr *)wr)->ah, struct xsc_ib_ah,
+					    ibah);
+	const struct ib_gid_attr *sgid_attr = ah->ibah.sgid_attr;
+	u16 ether_type;
+	union ib_gid dgid;
+	bool is_eth = false;
+	bool is_vlan = false;
+	bool is_grh = false;
+	bool is_udp = false;
+	u8 ip_version = 0;
+	u16 vlan_id = 0xFFFF;
+	int rc = 0;
+	int cm_pcp = 0;
+	void *hdr_buf;
+
+	memset(&qp->qp1_hdr, 0, sizeof(qp->qp1_hdr));
+
+	if (!qp->sq.hdr_buf) {
+		ibdev_err(&dev->ib_dev, "QP1 buffer is empty!");
+		return -ENOMEM;
+	}
+	hdr_buf = (u8 *)qp->sq.hdr_buf + MAX_QP1_SQ_HDR_SIZE_V2 * qp->sq.mad_index;
+
+	if (!sgid_attr || !sgid_attr->ndev) {
+		ibdev_err(&dev->ib_dev, "sgid_addr or ndev is null\n");
+		return -ENXIO;
+	}
+
+	if (is_vlan_dev(sgid_attr->ndev))
+		vlan_id = vlan_dev_vlan_id(sgid_attr->ndev);
+
+	is_udp = sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP;
+	memcpy(&dgid.raw, &ah->av.rgid, 16);
+	if (is_udp) {
+		if (ipv6_addr_v4mapped((struct in6_addr *)&sgid_attr->gid)) {
+			ip_version = 4;
+			ether_type = ETH_P_IP;
+		} else {
+			ip_version = 6;
+			ether_type = ETH_P_IPV6;
+		}
+		is_grh = false;
+	} else {
+		ether_type = ETH_P_IBOE;
+		is_grh = true;
+	}
+
+	is_eth = true;
+	is_vlan = (vlan_id && (vlan_id < 0x1000)) ? true : false;
+
+	ib_ud_header_init(payload_size, !is_eth, is_eth, is_vlan, is_grh,
+			  ip_version, is_udp, 0, &qp->qp1_hdr);
+
+	/* ETH */
+	ether_addr_copy(qp->qp1_hdr.eth.dmac_h, ah->av.rmac);
+	ether_addr_copy(qp->qp1_hdr.eth.smac_h, dev->netdev->dev_addr);
+
+	/* For vlan, check the sgid for vlan existence */
+	if (!is_vlan) {
+		qp->qp1_hdr.eth.type = cpu_to_be16(ether_type);
+	} else {
+		if (dev->xdev->priv.cm_pcp != DSCP_PCP_UNSET)
+			cm_pcp = dev->xdev->priv.cm_pcp << 13;
+		else
+			cm_pcp = (iboe_tos_to_sl(sgid_attr->ndev, ah->av.tclass) << 13);
+		qp->qp1_hdr.vlan.type = cpu_to_be16(ether_type);
+		qp->qp1_hdr.vlan.tag = cpu_to_be16(vlan_id | cm_pcp);
+	}
+
+#define ECN_CAPABLE_TRANSPORT 0x2
+	if (is_grh || ip_version == 6) {
+		memcpy(qp->qp1_hdr.grh.source_gid.raw, sgid_attr->gid.raw,
+		       sizeof(sgid_attr->gid));
+		memcpy(qp->qp1_hdr.grh.destination_gid.raw, ah->av.rgid,
+		       sizeof(ah->av.rgid));
+		qp->qp1_hdr.grh.hop_limit     = ah->av.hop_limit;
+
+		if (dev->xdev->priv.cm_dscp != DSCP_PCP_UNSET)
+			qp->qp1_hdr.grh.traffic_class =
+				(dev->xdev->priv.cm_dscp << 2) | ECN_CAPABLE_TRANSPORT;
+		else
+			qp->qp1_hdr.grh.traffic_class = ECN_CAPABLE_TRANSPORT;
+	}
+
+	if (ip_version == 4) {
+		if (dev->xdev->priv.cm_dscp != DSCP_PCP_UNSET)
+			qp->qp1_hdr.ip4.tos =
+				(dev->xdev->priv.cm_dscp << 2) | ECN_CAPABLE_TRANSPORT;
+		else
+			qp->qp1_hdr.ip4.tos = ECN_CAPABLE_TRANSPORT;
+		qp->qp1_hdr.ip4.id = 0;
+		qp->qp1_hdr.ip4.frag_off = htons(IP_DF);
+		qp->qp1_hdr.ip4.ttl = ah->av.hop_limit;
+
+		memcpy(&qp->qp1_hdr.ip4.saddr, sgid_attr->gid.raw + 12, 4);
+		memcpy(&qp->qp1_hdr.ip4.daddr, ah->av.rgid + 12, 4);
+		qp->qp1_hdr.ip4.check = ib_ud_ip4_csum(&qp->qp1_hdr);
+	}
+
+	if (is_udp) {
+		qp->qp1_hdr.udp.dport = htons(dev->xdev->cm_udp_dst_port);
+		qp->qp1_hdr.udp.sport = htons(ah->av.udp_sport);
+		qp->qp1_hdr.udp.csum = 0;
+		ibdev_dbg(&dev->ib_dev, "CM packet used udp_sport=%d\n", ah->av.udp_sport);
+	}
+
+	/* BTH */
+	if (wr->opcode == IB_WR_SEND_WITH_IMM) {
+		qp->qp1_hdr.bth.opcode = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
+		qp->qp1_hdr.immediate_present = 1;
+	} else {
+		qp->qp1_hdr.bth.opcode = IB_OPCODE_UD_SEND_ONLY;
+	}
+	if (wr->send_flags & IB_SEND_SOLICITED)
+		qp->qp1_hdr.bth.solicited_event = 1;
+	/* pad_count */
+	qp->qp1_hdr.bth.pad_count = (4 - payload_size) & 3;
+
+	/* P_key for QP1 is for all members */
+	qp->qp1_hdr.bth.pkey = cpu_to_be16(0xFFFF);
+	qp->qp1_hdr.bth.destination_qpn = IB_QP1;
+	qp->qp1_hdr.bth.ack_req = 0;
+	qp->send_psn++;
+	qp->send_psn &= BTH_PSN_MASK;
+	qp->qp1_hdr.bth.psn = cpu_to_be32(qp->send_psn);
+	/* DETH */
+	/* Use the privileged Q_Key for QP1 */
+	qp->qp1_hdr.deth.qkey = cpu_to_be32(IB_QP1_QKEY);
+	qp->qp1_hdr.deth.source_qpn = IB_QP1;
+
+	/* Pack the QP1 to the transmit buffer */
+	sge->addr = (dma_addr_t)(qp->sq.hdr_dma + MAX_QP1_SQ_HDR_SIZE_V2 * qp->sq.mad_index);
+	sge->lkey = 0xFFFFFFFF;
+	sge->length = MAX_QP1_SQ_HDR_SIZE;
+
+	ib_ud_header_pack(&qp->qp1_hdr, hdr_buf);
+	/*
+	 * Max Header buf size for IPV6 RoCE V2 is 86,
+	 * which is same as the QP1 SQ header buffer.
+	 * Header buf size for IPV4 RoCE V2 can be 66.
+	 * ETH(14) + VLAN(4)+ IP(20) + UDP (8) + BTH(20).
+	 * Subtract 20 bytes from QP1 SQ header buf size
+	 */
+	if (is_udp && ip_version == 4)
+		sge->length -= 20;
+	/*
+	 * Max Header buf size for RoCE V1 is 78.
+	 * ETH(14) + VLAN(4) + GRH(40) + BTH(20).
+	 * Subtract 8 bytes from QP1 SQ header buf size
+	 */
+	if (!is_udp)
+		sge->length -= 8;
+
+	/* Subtract 4 bytes for non vlan packets */
+	if (!is_vlan)
+		sge->length -= 4;
+
+	rc = xsc_icrc_hdr(dev, hdr_buf, sge->length - sizeof(struct ib_unpacked_eth), crc);
+	if (rc) {
+		ibdev_err(&dev->ib_dev, "CRC error: hdr size %ld\n",
+			  sge->length - sizeof(struct ib_unpacked_eth));
+	}
+	return rc;
+}
+
+static void zero_send_ds(struct xsc_ib_qp *qp, int idx)
+{
+	void *seg;
+	int i;
+	int ds_num;
+	u64 *p;
+
+	ds_num = XSC_SEND_SEG_NUM << (qp->sq.wqe_shift - XSC_SEND_WQE_SHIFT);
+	seg = (void *)xsc_get_send_wqe(qp, idx);
+	for (i = 1; i < ds_num; i++) {
+		p = get_seg_wqe(seg, i);
+		p[0] = 0;
+		p[1] = 0;
+	}
+}
+
+int xsc_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
+		     const struct ib_send_wr **bad_wr)
+{
+	struct xsc_ib_qp *qp = to_xqp(ibqp);
+	struct xsc_ib_dev *dev = to_xdev(ibqp->device);
+	void *seg;
+	struct xsc_send_wqe_ctrl_seg *ctrl;
+	struct xsc_wqe_data_seg *data_seg;
+	u32 crc;
+	int nreq = 0;
+	int err = 0;
+	int i;
+	unsigned int idx;
+	unsigned long irqflag = 0;
+	struct ib_sge sg;
+	u8 *cur_p = NULL;
+	u8 *mad_send_base = NULL;
+	void *vaddr;
+	struct xsc_msg_opcode *xsc_ib_opcode = dev->xdev->board_info->msg_opcode;
+
+	spin_lock_irqsave(&qp->sq.lock, irqflag);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		unsigned int seg_index = 1;
+		unsigned int msg_len = 0;
+		struct ib_sge *sgl = &wr->sg_list[0];
+		int sg_n = wr->num_sge;
+
+		if (unlikely(wr->opcode == IB_WR_REG_MR ||
+			     wr->opcode == IB_WR_LOCAL_INV ||
+			     wr->opcode == IB_WR_SEND_WITH_INV)) {
+			ibdev_err(&dev->ib_dev, "opcode %d not supported\n",
+				  wr->opcode);
+			err = -EOPNOTSUPP;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(wr->opcode < 0 || wr->opcode >= ARRAY_SIZE(dev->opcode_map))) {
+			ibdev_err(&dev->ib_dev, "bad opcode %d\n", wr->opcode);
+			err = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(xsc_wq_overflow(&qp->sq, nreq,
+					     to_xcq(qp->ibqp.send_cq)))) {
+			ibdev_err(&dev->ib_dev, "send work queue overflow\n");
+			err = -ENOMEM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
+			ibdev_err(&dev->ib_dev, "max gs exceeded %d (max = %d)\n",
+				  wr->num_sge, qp->sq.max_gs);
+			err = -ENOMEM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(wr->opcode == IB_WR_RDMA_READ && wr->num_sge > 1)) {
+			ibdev_err(&dev->ib_dev, "rdma read, max gs exceeded %d (max = 1)\n",
+				  wr->num_sge);
+			err = -ENOMEM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(qp->post_send_invalid)) {
+			ibdev_dbg(&dev->ib_dev, "qp %d has been draind, post send invalid...\n",
+				  qp->xqp.qpn);
+			err = -EIO;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		idx = qp->sq.cur_post & (qp->sq.wqe_cnt - 1);
+		zero_send_ds(qp, idx);
+		seg = xsc_get_send_wqe(qp, idx);
+		ctrl = seg;
+		xsc_set_wqe_id(dev->xdev, ctrl, qp->sq.cur_post <<
+			       (qp->sq.wqe_shift - XSC_BASE_WQE_SHIFT));
+		ctrl->ds_data_num = 0;
+		ctrl->se = wr->send_flags & IB_SEND_SOLICITED ? 1 : 0;
+		ctrl->ce = wr->send_flags & IB_SEND_SIGNALED ? 1 : 0;
+		for (i = 0; i < wr->num_sge; ++i) {
+			if (likely(wr->sg_list[i].length))
+				msg_len += wr->sg_list[i].length;
+		}
+		ctrl->msg_len = msg_len;
+		ctrl->with_immdt = 0;
+
+		if (unlikely(wr->opcode == IB_WR_RDMA_READ && msg_len == 0)) {
+			ibdev_err(&dev->ib_dev, "rdma read, msg len should not be 0\n");
+			/* workaround, return success for posting zero-length read */
+			err = 0;
+			goto out;
+		}
+		switch (ibqp->qp_type) {
+		case IB_QPT_RC:
+			ctrl->ds_data_num = wr->num_sge;
+			switch (wr->opcode) {
+			case IB_WR_SEND:
+				break;
+			case IB_WR_SEND_WITH_IMM:
+				ctrl->with_immdt = 1;
+				WR_LE_32(ctrl->opcode_data, RD_BE_32(send_ieth(wr)));
+				break;
+			case IB_WR_RDMA_WRITE_WITH_IMM:
+				ctrl->with_immdt = 1;
+				WR_LE_32(ctrl->opcode_data, RD_BE_32(send_ieth(wr)));
+				fallthrough;
+			case IB_WR_RDMA_READ:
+			case IB_WR_RDMA_WRITE:
+				if (ctrl->msg_len == 0)
+					break;
+				ctrl->ds_data_num++;
+				data_seg = get_seg_wqe(ctrl, seg_index);
+				set_remote_addr_seg(dev->xdev, data_seg,
+						    msg_len,
+						    rdma_wr(wr)->remote_addr,
+						    rdma_wr(wr)->rkey);
+				seg_index++;
+				break;
+			default:
+				ibdev_err(&dev->ib_dev, "unsupported send opcode %u\n",
+					  wr->opcode);
+				err = -EPERM;
+				*bad_wr = wr;
+				goto out;
+			}
+			ctrl->msg_opcode = dev->opcode_map[wr->opcode];
+			break;
+		case IB_QPT_UD:
+		case IB_QPT_GSI:
+			ctrl->msg_opcode = xsc_ib_opcode->mad;
+			ctrl->ds_data_num++;
+			data_seg = get_seg_wqe(ctrl, seg_index);
+			mad_send_base = (u8 *)qp->sq.hdr_buf +
+				MAX_QP1_SQ_HDR_SIZE_V2 * qp->sq.mad_index;
+
+			err = build_qp1_send_v2(dev, qp, wr, &sg, msg_len, &crc);
+			if (err) {
+				*bad_wr = wr;
+				goto out;
+			}
+
+			cur_p = mad_send_base + sg.length;
+			for (i = 0; i < wr->num_sge; ++i) {
+				if (likely(wr->sg_list[i].length)) {
+					vaddr = xsc_ib_send_mad_sg_virt_addr(&dev->ib_dev, wr, i);
+					memcpy(cur_p, vaddr, wr->sg_list[i].length);
+				}
+				cur_p += wr->sg_list[i].length;
+			}
+			crc = xsc_crc32(dev, crc, mad_send_base + sg.length, ctrl->msg_len);
+			ctrl->msg_len += sg.length;
+			seg_index++;
+
+			*(u32 *)&mad_send_base[ctrl->msg_len] = ~crc;
+			ctrl->msg_len += sizeof(crc);
+			sg.length = ctrl->msg_len;
+			set_local_data_seg(dev->xdev, data_seg, &sg);
+			ibdev_dbg(&dev->ib_dev, "qp[%d] send MAD packet, msg_len:%d\n",
+				  qp->xqp.qpn, ctrl->msg_len);
+			qp->sq.mad_index = (qp->sq.mad_index + 1) % MAD_QUEUE_DEPTH;
+
+			sg_n = 0;
+			break;
+		default:
+			ibdev_err(&dev->ib_dev, "qp type:%u NOT supported\n", ibqp->qp_type);
+			err = -EPERM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
+			err = set_data_inl_seg(qp, wr, ctrl);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				ibdev_err(&dev->ib_dev, "inline layout failed, err %d\n", err);
+				goto out;
+			}
+		} else {
+			for (i = 0; i < sg_n; ++i, ++seg_index) {
+				if (likely(sgl[i].length)) {
+					data_seg = get_seg_wqe(ctrl, seg_index);
+					set_local_data_seg(dev->xdev, data_seg, &sgl[i]);
+				}
+			}
+		}
+		qp->sq.wrid[idx] = wr->wr_id;
+		qp->sq.wqe_head[idx] = qp->sq.head + nreq;
+		qp->sq.cur_post += 1;
+		if (ctrl->ce) {
+			atomic_inc(&qp->sq.flush_wqe_cnt);
+			qp->sq.need_flush[idx] = 1;
+			qp->sq.prev_ce_wqe[idx] = qp->sq.last_post_ce_wqe;
+			qp->sq.last_post_ce_wqe = idx;
+		}
+		qp->sq.wr_opcode[idx] = wr->opcode;
+	}
+out:
+	ibdev_dbg(&dev->ib_dev, "nreq:%d\n", nreq);
+	xsc_post_send_db(qp, dev->xdev, nreq);
+	spin_unlock_irqrestore(&qp->sq.lock, irqflag);
+
+	return err;
+}
 
 int xsc_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 		     const struct ib_recv_wr **bad_wr)
@@ -1558,3 +2156,96 @@ struct xsc_ib_drain_cqe {
 	int qpn;
 };
 
+static void xsc_ib_drain_rq_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct xsc_ib_drain_cqe *cqe = container_of(wc->wr_cqe,
+						     struct xsc_ib_drain_cqe, cqe);
+	struct xsc_ib_dev *dev = to_xdev(cq->device);
+
+	complete(&cqe->done);
+	ibdev_dbg(&dev->ib_dev, "QP %d ib_drain_rq done!", cqe->qpn);
+}
+
+static void xsc_ib_drain_sq_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct xsc_ib_drain_cqe *cqe = container_of(wc->wr_cqe,
+						     struct xsc_ib_drain_cqe, cqe);
+	struct xsc_ib_dev *dev = to_xdev(cq->device);
+
+	complete(&cqe->done);
+	ibdev_dbg(&dev->ib_dev, "QP %d ib_drain_sq done!", cqe->qpn);
+}
+
+void xsc_ib_drain_rq(struct ib_qp *qp)
+{
+	struct ib_cq *cq = qp->recv_cq;
+	struct xsc_ib_cq *xcq = to_xcq(cq);
+	struct xsc_ib_qp *xqp = to_xqp(qp);
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct xsc_ib_drain_cqe rdrain;
+	const struct ib_recv_wr rwr = {
+		.next = NULL,
+		{.wr_cqe = &rdrain.cqe,},
+	};
+	const struct ib_recv_wr *bad_rwr;
+	int ret;
+	struct xsc_ib_dev *dev = to_xdev(qp->device);
+
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		ibdev_err(&dev->ib_dev, "failed to drain recv queue: %d\n", ret);
+		return;
+	}
+
+	rdrain.qpn = xqp->xqp.qpn;
+	rdrain.cqe.done = xsc_ib_drain_rq_done;
+	init_completion(&rdrain.done);
+
+	ret = xsc_ib_post_recv(qp, &rwr, &bad_rwr);
+	if (ret) {
+		ibdev_err(&dev->ib_dev, "failed to drain recv queue: %d\n", ret);
+		return;
+	}
+	xqp->post_recv_invalid = true;
+
+	xcq->xcq.comp(&xcq->xcq);
+	wait_for_completion(&rdrain.done);
+}
+
+void xsc_ib_drain_sq(struct ib_qp *qp)
+{
+	struct ib_cq *cq = qp->send_cq;
+	struct xsc_ib_cq *xcq = to_xcq(cq);
+	struct xsc_ib_qp *xqp = to_xqp(qp);
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct xsc_ib_drain_cqe sdrain;
+	const struct ib_send_wr *bad_swr;
+	const struct ib_send_wr swr = {
+		.next = NULL,
+		{ .wr_cqe	= &sdrain.cqe, },
+		.opcode	= IB_WR_RDMA_WRITE,
+		.send_flags = IB_SEND_SIGNALED,
+	};
+	int ret;
+	struct xsc_ib_dev *dev = to_xdev(qp->device);
+
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		ibdev_err(&dev->ib_dev, "failed to drain send queue: %d\n", ret);
+		return;
+	}
+
+	sdrain.qpn = xqp->xqp.qpn;
+	sdrain.cqe.done = xsc_ib_drain_sq_done;
+	init_completion(&sdrain.done);
+
+	ret = xsc_ib_post_send(qp, &swr, &bad_swr);
+	if (ret) {
+		ibdev_err(&dev->ib_dev, "failed to drain send queue: %d\n", ret);
+		return;
+	}
+	xqp->post_send_invalid = true;
+
+	xcq->xcq.comp(&xcq->xcq);
+	wait_for_completion(&sdrain.done);
+}
