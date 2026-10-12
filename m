Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E449440B38C
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805479; cv=none; b=HdYpgMaIy7+CfBXej6VHcJODTjJI3RotzEBC++JzDDRUQt+s3+xhuTQBhiWbwoLMOAcj3LZyWFqjOn1lUMCLz2oOz8CUSzq9ZQu3hx4d9y8P8V16e2/7xH0PDt1wGbPoO7BZBHNTkMnot2yX5yAlFVF+1mD7oS1972qKnaPI3Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805479; c=relaxed/simple;
	bh=FIoGHX7sH61COIX/gY+C3ZWvEAocGKSYrg+SR39uBN4=;
	h=Subject:Date:References:From:Cc:In-Reply-To:To:Mime-Version:
	 Content-Type:Message-Id; b=VYnpp+WMzBqdTCB9kj13lpOQOTpnwdrbd4RayQejLgIq3JwQUbvkD+5CX2mWmgyqUkjS4Dk8Re7UKI6s5nkNEZc5YVWrZFtVQVvzAKQHjaoRA6MwQZqSMnqV4ls+ThwzcTWG+kosJ9bZ8e9vdJbs2cKawYcry7CNogtRqsirFFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=B6OnbeIo; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="B6OnbeIo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805462; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7YnVoC1tXTp34C38K1dt8rwza5swHOQm0/TORwPAPJE=;
 b=B6OnbeIoS+zNAjPNGR8/xo3qZwuxP6COyKyyuZDBBjDQVbOqRsZ5NKjRiatpJV6DXVqSpQ
 DSdmFrXL98JVXHlPvi9sMNmyanrExQWUSUdQ2+gmgkdNIoXRJ5ZTnKh3H0dOFZxfsgnTBy
 kHTerLme8/SPESRUyPbIkEjngYBW/vJBuP1oLE0pV5gwkocYgf+hOqjBkNJ0hqg7rz+xx+
 khMjZO6P2z3lH0/hh3Q8eCMIAI4tWOBFOT0sAabs2BH8NjWb/MDfRZOi0S0iQ1YRN3HTfF
 jtoI1OOqxXcTVfNd2zA9mSRSb3atpqHQMrRSjiQISGAGhsxgBgmaYOR3zTBpwQ==
Subject: [PATCH 11/15] yunsilicon: add RDMA CQ/SRQ/AH
Date: Mon, 12 Oct 2026 19:44:19 +0800
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
From: "Xin Tian" <tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Message-Id: <20261012114418.2471317-12-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:19 +0800
X-Lms-Return-Path: <lba+26accc814+7822bb+vger.kernel.org+tianx@yunsilicon.com>

Add the completion queues, shared receive queues and address handles: the
create/destroy/query/modify verbs and the CQ poll and completion
processing.

The QP receive helper and error-state tracking are included here
because the CQ and SRQ paths reference them.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/Makefile            |   2 +-
 drivers/infiniband/hw/xsc/ah.c                | 144 +++
 drivers/infiniband/hw/xsc/cq.c                | 895 ++++++++++++++++++
 drivers/infiniband/hw/xsc/main.c              |  15 +
 drivers/infiniband/hw/xsc/qp.c                | 239 +++++
 drivers/infiniband/hw/xsc/srq.c               | 426 +++++++++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   3 +-
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  10 +
 drivers/net/ethernet/yunsilicon/xsc/pci/srq.c |  92 ++
 drivers/net/ethernet/yunsilicon/xsc/pci/srq.h |  16 +
 10 files changed, 1840 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/hw/xsc/ah.c
 create mode 100644 drivers/infiniband/hw/xsc/cq.c
 create mode 100644 drivers/infiniband/hw/xsc/qp.c
 create mode 100644 drivers/infiniband/hw/xsc/srq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/srq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/srq.h

diff --git a/drivers/infiniband/hw/xsc/Makefile b/drivers/infiniband/hw/xsc/Makefile
index b535a6653..d5ad0e573 100644
--- a/drivers/infiniband/hw/xsc/Makefile
+++ b/drivers/infiniband/hw/xsc/Makefile
@@ -6,4 +6,4 @@ ccflags-y := -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_INFINIBAND_XSC) += xsc_ib.o
 
-xsc_ib-y := main.o mem.o mr.o
+xsc_ib-y := main.o cq.o qp.o mem.o mr.o srq.o ah.o
diff --git a/drivers/infiniband/hw/xsc/ah.c b/drivers/infiniband/hw/xsc/ah.c
new file mode 100644
index 000000000..4d916dbe7
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/ah.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include "xsc_ib.h"
+#include <rdma/xsc-abi.h>
+
+static u32 xsc_calc_roce_udp_flow_label(void)
+{
+	/* Generate a non-zero 20 bit flow label. */
+	return get_random_u32_below(IB_GRH_FLOWLABEL_MASK) + 1;
+}
+
+static u16 xsc_ah_get_udp_sport(const struct xsc_ib_dev *dev,
+				struct rdma_ah_attr *ah_attr)
+{
+	enum ib_gid_type gid_type = ah_attr->grh.sgid_attr->gid_type;
+	u16 sport = 0;
+	u32 fl = 0;
+
+	if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP &&
+	    (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) &&
+	    (ah_attr->grh.flow_label & IB_GRH_FLOWLABEL_MASK)) {
+		fl = ah_attr->grh.flow_label;
+	} else {
+		/*generate a 20bit flow_label and output to user layer*/
+		fl = xsc_calc_roce_udp_flow_label();
+		ah_attr->grh.flow_label = fl;
+	}
+
+	sport = rdma_flow_label_to_udp_sport(fl);
+	ibdev_dbg(&dev->ib_dev, "fl=0x%x,sport=0x%x\n", fl, sport);
+	return sport;
+}
+
+static struct ib_ah *create_ib_ah(struct xsc_ib_dev *dev,
+				  struct xsc_ib_ah *ah,
+				  struct rdma_ah_attr *ah_attr)
+{
+	enum ib_gid_type gid_type;
+
+	if (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) {
+		const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
+
+		memcpy(ah->av.rgid, &grh->dgid, 16);
+		ah->av.grh_gid_fl = cpu_to_be32(grh->flow_label |
+						(1 << 30) |
+						grh->sgid_index << 20);
+		ah->av.hop_limit = grh->hop_limit;
+		ah->av.tclass = grh->traffic_class;
+	}
+
+	ah->av.stat_rate_sl = (rdma_ah_get_static_rate(ah_attr) << 4);
+
+	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
+		gid_type = ah_attr->grh.sgid_attr->gid_type;
+
+		memcpy(ah->av.rmac, ah_attr->roce.dmac,
+		       sizeof(ah_attr->roce.dmac));
+
+		ah->av.udp_sport = xsc_ah_get_udp_sport(dev, ah_attr);
+		ah->av.stat_rate_sl |= (rdma_ah_get_sl(ah_attr) & 0x7) << 1;
+		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
+#define XSC_ECN_ENABLED BIT(1)
+			ah->av.tclass |= XSC_ECN_ENABLED;
+	} else {
+		ah->av.rlid = cpu_to_be16(rdma_ah_get_dlid(ah_attr));
+		ah->av.fl_mlid = rdma_ah_get_path_bits(ah_attr) & 0x7f;
+		ah->av.stat_rate_sl |= (rdma_ah_get_sl(ah_attr) & 0xf);
+	}
+
+	return &ah->ibah;
+}
+
+int xsc_ib_create_ah(struct ib_ah *ibah,
+		     struct rdma_ah_init_attr *init_attr,
+		      struct ib_udata *udata)
+{
+	struct xsc_ib_ah *ah = to_xah(ibah);
+	struct xsc_ib_dev *dev = to_xdev(ibah->device);
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
+	enum rdma_ah_attr_type ah_type = ah_attr->type;
+
+	if (ah_type == RDMA_AH_ATTR_TYPE_ROCE &&
+	    !(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
+		return -EINVAL;
+
+	if (ah_type == RDMA_AH_ATTR_TYPE_ROCE && udata) {
+		int err;
+		struct xsc_ib_create_ah_resp resp = {};
+		u32 min_resp_len = offsetof(typeof(resp), dmac) +
+				   sizeof(resp.dmac);
+
+		if (udata->outlen < min_resp_len)
+			return -EINVAL;
+
+		resp.response_length = min_resp_len;
+		memcpy(resp.dmac, ah_attr->roce.dmac, ETH_ALEN);
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err)
+			return err;
+	}
+
+	create_ib_ah(dev, ah, ah_attr); /* never fails */
+	return 0;
+}
+
+int xsc_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
+{
+	struct xsc_ib_ah *ah = to_xah(ibah);
+	u32 tmp;
+
+	memset(ah_attr, 0, sizeof(*ah_attr));
+	ah_attr->type = ibah->type;
+
+	tmp = be32_to_cpu(ah->av.grh_gid_fl);
+	if (tmp & (1 << 30)) {
+		rdma_ah_set_grh(ah_attr, NULL, tmp & IB_GRH_FLOWLABEL_MASK,
+				(tmp >> 20) & 0xff, ah->av.hop_limit,
+				ah->av.tclass);
+		rdma_ah_set_dgid_raw(ah_attr, ah->av.rgid);
+	}
+
+	rdma_ah_set_static_rate(ah_attr, ah->av.stat_rate_sl >> 4);
+	if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
+		rdma_ah_set_sl(ah_attr, (ah->av.stat_rate_sl >> 1) & 0x7);
+	} else {
+		rdma_ah_set_dlid(ah_attr, be16_to_cpu(ah->av.rlid));
+		rdma_ah_set_path_bits(ah_attr, ah->av.fl_mlid & 0x7f);
+		rdma_ah_set_sl(ah_attr, ah->av.stat_rate_sl & 0xf);
+	}
+
+	return 0;
+}
+
+int xsc_ib_destroy_ah(struct ib_ah *ibah, u32 flags)
+{
+	return 0;
+}
diff --git a/drivers/infiniband/hw/xsc/cq.c b/drivers/infiniband/hw/xsc/cq.c
new file mode 100644
index 000000000..04820bf3a
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/cq.c
@@ -0,0 +1,895 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kref.h>
+#include <rdma/ib_umem.h>
+#include "xsc_ib.h"
+#include <rdma/xsc-abi.h>
+#include "common/xsc_hsi.h"
+#include <linux/dma-direct.h>
+
+#ifndef IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN
+#define IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN BIT(1)
+#endif
+
+enum {
+	CQ_OK					=  0,
+	CQ_EMPTY				= -1,
+	CQ_POLL_ERR				= -2
+};
+
+enum {
+	XSC_CQE_APP_TAG_MATCHING = 1,
+};
+
+enum {
+	XSC_CQE_APP_OP_TM_CONSUMED = 0x1,
+	XSC_CQE_APP_OP_TM_EXPECTED = 0x2,
+	XSC_CQE_APP_OP_TM_UNEXPECTED = 0x3,
+	XSC_CQE_APP_OP_TM_NO_TAG = 0x4,
+	XSC_CQE_APP_OP_TM_APPEND = 0x5,
+	XSC_CQE_APP_OP_TM_REMOVE = 0x6,
+	XSC_CQE_APP_OP_TM_NOOP = 0x7,
+	XSC_CQE_APP_OP_TM_CONSUMED_SW_RDNV = 0x9,
+	XSC_CQE_APP_OP_TM_CONSUMED_MSG = 0xA,
+	XSC_CQE_APP_OP_TM_CONSUMED_MSG_SW_RDNV = 0xB,
+	XSC_CQE_APP_OP_TM_MSG_COMPLETION_CANCELED = 0xC,
+};
+
+static const u32 xsc_cqe_opcode[] = {
+	[XSC_OPCODE_RDMA_REQ_SEND]		= IB_WC_SEND,
+	[XSC_OPCODE_RDMA_REQ_SEND_IMMDT]	= IB_WC_SEND,
+	[XSC_OPCODE_RDMA_RSP_RECV]		= IB_WC_RECV,
+	[XSC_OPCODE_RDMA_RSP_RECV_IMMDT]	= IB_WC_RECV,
+	[XSC_OPCODE_RDMA_REQ_WRITE]		= IB_WC_RDMA_WRITE,
+	[XSC_OPCODE_RDMA_REQ_WRITE_IMMDT]	= IB_WC_RDMA_WRITE,
+	[XSC_OPCODE_RDMA_RSP_WRITE_IMMDT]	= IB_WC_RECV_RDMA_WITH_IMM,
+	[XSC_OPCODE_RDMA_REQ_READ]		= IB_WC_RDMA_READ,
+	[XSC_OPCODE_RDMA_MAD_REQ_SEND]		= IB_WC_SEND,
+	[XSC_OPCODE_RDMA_MAD_RSP_RECV]		= IB_WC_RECV,
+};
+
+static void xsc_ib_cq_comp(struct xsc_core_cq *cq)
+{
+	struct ib_cq *ibcq = &core_to_xcq(cq)->ibcq;
+
+	ibcq->comp_handler(ibcq, ibcq->cq_context);
+}
+
+static void xsc_ib_cq_event(struct xsc_core_cq *xcq, enum xsc_event type)
+{
+	struct xsc_ib_cq *cq = container_of(xcq, struct xsc_ib_cq, xcq);
+	struct xsc_ib_dev *dev = to_xdev(cq->ibcq.device);
+	struct ib_cq *ibcq = &cq->ibcq;
+	struct ib_event event;
+
+	if (type != XSC_EVENT_TYPE_CQ_ERROR) {
+		ibdev_err(&dev->ib_dev, "Unexpected event type %d on CQ %06x\n",
+			  type, xcq->cqn);
+		return;
+	}
+
+	if (ibcq->event_handler) {
+		event.device     = &dev->ib_dev;
+		event.event      = IB_EVENT_CQ_ERR;
+		event.element.cq = ibcq;
+		ibcq->event_handler(&event, ibcq->cq_context);
+		pr_info("xsc_ib: xsc async event 0x%x, ib event %d\n",
+			XSC_EVENT_TYPE_CQ_ERROR, IB_EVENT_CQ_ERR);
+	}
+}
+
+static void *get_cqe_from_buf(struct xsc_ib_cq_buf *buf, int n, int size)
+{
+	return xsc_buf_offset(&buf->buf, n * size);
+}
+
+static void *get_cqe(struct xsc_ib_cq *cq, int n)
+{
+	return get_cqe_from_buf(&cq->buf, n, cq->xcq.cqe_sz);
+}
+
+static void *get_sw_cqe(struct xsc_ib_cq *cq, int n)
+{
+	struct xsc_cqe *cqe;
+
+	cqe = (struct xsc_cqe *)get_cqe(cq, n & (cq->ibcq.cqe - 1));
+
+	return ((cqe->owner & XSC_CQE_OWNER_MASK) ^
+		!!(n & cq->ibcq.cqe)) ? NULL : cqe;
+}
+
+static inline void handle_good_req(struct ib_wc *wc,
+				   struct xsc_cqe *cqe,
+				   u8 opcode)
+{
+	wc->opcode = xsc_cqe_opcode[opcode];
+	if (opcode == XSC_OPCODE_RDMA_REQ_READ)
+		wc->byte_len  = RD_LE_32(cqe->msg_len);
+	wc->status = IB_WC_SUCCESS;
+}
+
+static void handle_responder(struct ib_wc *wc, struct xsc_cqe *cqe,
+			     struct xsc_ib_qp *qp, u8 opcode)
+{
+	struct xsc_ib_wq *wq = &qp->rq;
+	u16 idx;
+
+	wc->byte_len = RD_LE_32(cqe->msg_len);
+	wc->opcode = xsc_cqe_opcode[opcode];
+	wc->status = IB_WC_SUCCESS;
+
+	idx = wq->tail & (wq->wqe_cnt - 1);
+	wc->wr_id = wq->wrid[idx];
+	atomic_dec(&wq->flush_wqe_cnt);
+	++wq->tail;
+}
+
+static void *get_wqe(struct xsc_ib_qp *qp, int offset)
+{
+	return xsc_buf_offset(&qp->buf, offset);
+}
+
+static void *get_recv_wqe(struct xsc_ib_qp *qp, int n)
+{
+	return get_wqe(qp, qp->rq.offset + (n << qp->rq.wqe_shift));
+}
+
+static void *get_seg_wqe(void *first, int n)
+{
+	return first + (n << XSC_BASE_WQE_SHIFT);
+}
+
+static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
+					  struct xsc_ib_qp **cur_qp,
+					  struct ib_wc *wc,
+					  struct xsc_cqe *cqe,
+					  u8 opcode)
+{
+	struct xsc_ib_dev *dev = to_xdev(cq->ibcq.device);
+	void *recv;
+	struct xsc_wqe_data_seg *data_seg;
+	struct iphdr *ip4h = NULL;
+	struct ipv6hdr *ip6h;
+	struct udphdr *udph;
+	struct ib_unpacked_eth *eth;
+	struct ib_unpacked_vlan *vlan;
+	struct ib_grh *grh;
+	struct ib_mad *mad;
+	struct rxe_bth *bth;
+	struct rxe_deth *deth;
+	unsigned int pading_sz = 0;
+	struct xsc_ib_wq *wq;
+	int idx;
+	u16 eth_type;
+	void *l3_start;
+
+	wq = &(*cur_qp)->rq;
+	idx = wq->tail & (wq->wqe_cnt - 1);
+
+	handle_responder(wc, cqe, *cur_qp, opcode);
+
+	data_seg = get_seg_wqe(get_recv_wqe(*cur_qp, idx), 0);
+	recv = xsc_ib_recv_mad_sg_virt_addr(&dev->ib_dev, wc, data_seg->va);
+
+	eth = (struct ib_unpacked_eth *)recv;
+	grh = (struct ib_grh *)recv;
+	if (eth->type == htons(ETH_P_8021Q)) {
+		vlan = (struct ib_unpacked_vlan *)(eth + 1);
+		eth_type = ntohs(vlan->type);
+		l3_start = vlan + 1;
+
+		wc->vlan_id = ntohs(vlan->tag) & 0x0fff;
+		wc->sl = (ntohs(vlan->tag) >> 13) & 0x7;
+		wc->wc_flags |= IB_WC_WITH_VLAN;
+	} else {
+		eth_type = ntohs(eth->type);
+		l3_start = eth + 1;
+	}
+
+	if (eth_type == ETH_P_IP) {
+		ip4h = (struct iphdr *)l3_start;
+		udph = (struct udphdr *)(ip4h + 1);
+	} else {
+		ip6h = (struct ipv6hdr *)l3_start;
+		udph = (struct udphdr *)(ip6h + 1);
+	}
+	bth = (struct rxe_bth *)(udph + 1);
+	deth = (struct rxe_deth *)(bth + 1);
+	mad = (struct ib_mad *)(deth + 1);
+
+	if (eth_type == ETH_P_IP) {
+		pading_sz = sizeof(*grh) - sizeof(*ip4h);
+		memmove((u8 *)(grh + 1) - sizeof(*ip4h), ip4h, sizeof(*ip4h));
+		memset(grh, 0, pading_sz);
+	} else {
+		memmove(grh, ip6h, sizeof(*ip6h));
+	}
+	memmove(grh + 1, mad, sizeof(*mad));
+
+	wc->wc_flags |= IB_WC_GRH;
+
+	ibdev_dbg(&dev->ib_dev, "recv cqe idx:%u, len:%u\n", wq->tail, wc->byte_len);
+	ibdev_dbg(&dev->ib_dev, "qp[%d] recv MAD packet, msg_len=%d\n",
+		  (*cur_qp)->xqp.qpn, wc->byte_len);
+	wc->status = IB_WC_SUCCESS;
+}
+
+static void xsc_generate_lost_cqe(struct xsc_ib_dev *dev, struct xsc_ib_wq *wq,
+				  int qpn, int idx, struct ib_wc *wc)
+{
+	int lost_cqe_idx = wq->prev_ce_wqe[idx];
+
+	ibdev_err(&dev->ib_dev, "detected lost cqe, cur wqe idx of qp%d is %d\n", qpn, idx);
+
+	while (wq->prev_ce_wqe[lost_cqe_idx] != wq->last_comp_ce_wqe)
+		lost_cqe_idx = wq->prev_ce_wqe[lost_cqe_idx];
+	ibdev_err(&dev->ib_dev, "generate lost cqe idx of qp%d is %d\n", qpn, lost_cqe_idx);
+
+	wq->last_comp_ce_wqe = lost_cqe_idx;
+	wc->wr_id = wq->wrid[lost_cqe_idx];
+	wq->tail = wq->wqe_head[lost_cqe_idx] + 1;
+	atomic_dec(&wq->flush_wqe_cnt);
+	wq->need_flush[lost_cqe_idx] = 0;
+	wc->status = IB_WC_GENERAL_ERR;
+}
+
+static int xsc_poll_one(struct xsc_ib_cq *cq,
+			struct xsc_ib_qp **cur_qp,
+			struct ib_wc *wc)
+{
+	struct xsc_ib_dev *dev = to_xdev(cq->ibcq.device);
+	struct xsc_core_qp *xqp;
+	struct xsc_ib_wq *wq;
+	u8 opcode;
+	u32 qpn;
+	int idx;
+	struct xsc_cqe *cqe;
+	u32 *p = NULL;
+	struct xsc_ib_srq *xsrq;
+
+	cqe = get_sw_cqe(cq, cq->xcq.cons_index);
+	if (!cqe)
+		return -EAGAIN;
+
+	++cq->xcq.cons_index;
+
+	/* Make sure we read CQ entry contents after we've checked the
+	 * ownership bit.
+	 */
+	rmb();
+
+	p = (u32 *)cqe;
+
+	qpn = cqe->qp_id;
+	qpn = le32_to_cpu(qpn);
+	if (!*cur_qp || (qpn != (*cur_qp)->ibqp.qp_num)) {
+		/* We do not have to take the QP table lock here,
+		 * because CQs will be locked while QPs are removed
+		 * from the table.
+		 */
+		xqp = __xsc_qp_lookup(dev->xdev, qpn);
+		if (unlikely(!xqp)) {
+			ibdev_warn(&dev->ib_dev, "CQE@CQ %d for unknown QPN %d\n",
+				   cq->xcq.cqn, qpn);
+			return -EINVAL;
+		}
+
+		*cur_qp = core_to_xqp(xqp);
+	}
+
+	memset(wc, 0, sizeof(*wc));
+	wc->qp = &(*cur_qp)->ibqp;
+	opcode = xsc_get_cqe_opcode(dev->xdev, cqe);
+	switch (opcode) {
+	case XSC_OPCODE_RDMA_REQ_SEND_IMMDT:
+	case XSC_OPCODE_RDMA_REQ_WRITE_IMMDT:
+		wc->wc_flags |= IB_WC_WITH_IMM;
+		fallthrough;
+	case XSC_OPCODE_RDMA_REQ_SEND:
+	case XSC_OPCODE_RDMA_REQ_WRITE:
+	case XSC_OPCODE_RDMA_REQ_READ:
+	case XSC_OPCODE_RDMA_MAD_REQ_SEND:
+		wq = &(*cur_qp)->sq;
+		idx = xsc_get_cqe_wqe_id(dev->xdev, cqe) >> (wq->wqe_shift - XSC_BASE_WQE_SHIFT);
+		idx &= (wq->wqe_cnt - 1);
+		if (wq->prev_ce_wqe[idx] != wq->last_comp_ce_wqe) {
+			xsc_generate_lost_cqe(dev, wq, qpn, idx, wc);
+			cq->invalid = 1;
+			break;
+		}
+		wq->last_comp_ce_wqe = idx;
+		handle_good_req(wc, cqe, opcode);
+		wc->wr_id = wq->wrid[idx];
+		wq->tail = wq->wqe_head[idx] + 1;
+		if (opcode != XSC_OPCODE_RDMA_MAD_REQ_SEND)
+			atomic_dec(&wq->flush_wqe_cnt);
+		wq->need_flush[idx] = 0;
+		ibdev_dbg(&dev->ib_dev, "wqeid:%u, wq tail:%u qpn:%u\n", idx, wq->tail, qpn);
+		wc->status = IB_WC_SUCCESS;
+		break;
+	case XSC_OPCODE_RDMA_RSP_RECV_IMMDT:
+	case XSC_OPCODE_RDMA_RSP_WRITE_IMMDT:
+		wc->wc_flags |= IB_WC_WITH_IMM;
+		WR_BE_32(wc->ex.imm_data, RD_LE_32(cqe->imm_data));
+		fallthrough;
+	case XSC_OPCODE_RDMA_RSP_RECV:
+		wq = &(*cur_qp)->rq;
+		handle_responder(wc, cqe, *cur_qp, opcode);
+		if ((*cur_qp)->ibqp.srq) {
+			xsrq = to_xsrq((*cur_qp)->ibqp.srq);
+			xsc_free_one_cache_srq_wr(xsrq, *cur_qp, wc->wr_id);
+		}
+		ibdev_dbg(&dev->ib_dev, "recv cqe idx:%u, len:%u, qpn:%u\n",
+			  wq->tail, wc->byte_len, qpn);
+		wc->status = IB_WC_SUCCESS;
+		break;
+
+	case XSC_OPCODE_RDMA_MAD_RSP_RECV:
+		ibdev_dbg(&dev->ib_dev, "recv MAD, qpn:%u\n", qpn);
+		xsc_handle_rdma_mad_resp_recv(cq, cur_qp, wc, cqe, opcode);
+		break;
+
+	case XSC_OPCODE_RDMA_REQ_ERROR:
+		wq = &(*cur_qp)->sq;
+		idx = xsc_get_cqe_wqe_id(dev->xdev, cqe) >> (wq->wqe_shift - XSC_BASE_WQE_SHIFT);
+		idx &= (wq->wqe_cnt - 1);
+
+		if (!wq->need_flush[idx]) {
+			unsigned int i;
+			unsigned int tmp;
+			unsigned int prev = -1;
+
+			for (i = wq->tail; i != wq->head; i++) {
+				tmp = i & (wq->wqe_cnt - 1);
+				if (tmp == idx)
+					break;
+				if (wq->need_flush[tmp])
+					prev = tmp;
+			}
+
+			if (prev != -1) {
+				if (wq->prev_ce_wqe[prev] != wq->last_comp_ce_wqe) {
+					xsc_generate_lost_cqe(dev, wq, qpn, prev, wc);
+					cq->invalid = 1;
+					break;
+				}
+			}
+		} else {
+			if (wq->prev_ce_wqe[idx] != wq->last_comp_ce_wqe) {
+				xsc_generate_lost_cqe(dev, wq, qpn, idx, wc);
+				cq->invalid = 1;
+				break;
+			}
+		}
+
+		wc->wr_id = wq->wrid[idx];
+		wq->tail = wq->wqe_head[idx] + 1;
+		if (wq->need_flush[idx])
+			atomic_dec(&wq->flush_wqe_cnt);
+		wq->need_flush[idx] = 0;
+		ibdev_err(&dev->ib_dev, "req error\n%08x %08x %08x %08x %08x %08x\n",
+			  p[0], p[1], p[2], p[3], p[5], p[6]);
+		wc->status = IB_WC_GENERAL_ERR;
+		xsc_ib_err_state_qp(dev, *cur_qp, (*cur_qp)->state, XSC_QP_STATE_ERR);
+		break;
+	case XSC_OPCODE_RDMA_RSP_ERROR:
+		wq = &(*cur_qp)->rq;
+		idx = wq->tail & (wq->wqe_cnt - 1);
+		wc->wr_id = wq->wrid[idx];
+		wq->tail++;
+		atomic_dec(&wq->flush_wqe_cnt);
+		if ((*cur_qp)->ibqp.srq) {
+			xsrq = to_xsrq((*cur_qp)->ibqp.srq);
+			xsc_free_one_cache_srq_wr(xsrq, *cur_qp, wc->wr_id);
+		}
+		ibdev_err(&dev->ib_dev, "rsp error\n%08x %08x %08x %08x %08x %08x\n",
+			  p[0], p[1], p[2], p[3], p[5], p[6]);
+		wc->status = IB_WC_GENERAL_ERR;
+		xsc_ib_err_state_qp(dev, *cur_qp, (*cur_qp)->state, XSC_QP_STATE_ERR);
+		break;
+
+	default:
+		ibdev_err(&dev->ib_dev, "completion error\n%08x %08x %08x %08x %08x %08x\n",
+			  p[0], p[1], p[2], p[3], p[5], p[6]);
+		wc->status = IB_WC_GENERAL_ERR;
+		wc->wr_id = 0;
+		break;
+	}
+
+	return 0;
+}
+
+static inline void gen_flush_err_cqe(struct xsc_err_state_qp_node *err_node,
+				     struct ib_qp *ibqp, struct xsc_ib_wq *wq, u32 idx,
+				     struct ib_wc *wc)
+{
+	memset(wc, 0, sizeof(*wc));
+	if (err_node->is_sq) {
+		switch (wq->wr_opcode[idx]) {
+		case IB_WR_SEND:
+		case IB_WR_SEND_WITH_IMM:
+			wc->opcode = IB_WC_SEND;
+			break;
+		case IB_WR_RDMA_WRITE:
+		case IB_WR_RDMA_WRITE_WITH_IMM:
+			wc->opcode = IB_WC_RDMA_WRITE;
+			break;
+		case IB_WR_RDMA_READ:
+			wc->opcode = IB_WC_RDMA_READ;
+		}
+	} else {
+		wc->opcode = IB_WC_RECV;
+	}
+
+	wc->qp = ibqp;
+	wc->status = IB_WC_WR_FLUSH_ERR;
+	wc->vendor_err = XSC_ERR_CODE_FLUSH;
+	wc->wr_id = wq->wrid[idx];
+	wq->tail++;
+	atomic_dec(&wq->flush_wqe_cnt);
+	if (err_node->is_sq)
+		wq->need_flush[idx] = 0;
+}
+
+static inline int xsc_generate_flush_err_cqe(struct ib_cq *ibcq,
+					     int ne, int *npolled, struct ib_wc *wc)
+{
+	u32 qp_id = 0;
+	int flush_wqe_cnt = 0;
+	int sw_npolled = 0;
+	u32 idx = 0;
+	struct xsc_err_state_qp_node *err_qp_node;
+	struct xsc_core_qp *xqp;
+	struct xsc_ib_cq *cq = to_xcq(ibcq);
+	struct xsc_ib_wq *wq;
+	struct xsc_ib_dev *dev = to_xdev(cq->ibcq.device);
+
+	list_for_each_entry(err_qp_node, &cq->err_state_qp_list, entry) {
+		if (!err_qp_node)
+			break;
+
+		sw_npolled = 0;
+		qp_id = err_qp_node->qp_id;
+		xqp = __xsc_qp_lookup(dev->xdev, qp_id);
+		if (unlikely(!xqp)) {
+			ibdev_warn(&dev->ib_dev, "CQE@CQ %d for unknown QPN %d\n",
+				   cq->xcq.cqn, qp_id);
+			continue;
+		}
+		wq = err_qp_node->is_sq ? &(core_to_xqp(xqp)->sq) : &(core_to_xqp(xqp)->rq);
+		flush_wqe_cnt = atomic_read(&wq->flush_wqe_cnt);
+		ibdev_dbg(&dev->ib_dev, "is_sq %d, flush_wq_cnt %d, ne %d, npolled %d, qp_id %d, cqn %d\n",
+			  err_qp_node->is_sq, flush_wqe_cnt, ne, *npolled, qp_id, cq->xcq.cqn);
+
+		while (wq->tail != wq->head) {
+			idx = wq->tail & (wq->wqe_cnt - 1);
+			if (err_qp_node->is_sq && !wq->need_flush[idx]) {
+				wq->tail++;
+				continue;
+			} else {
+				gen_flush_err_cqe(err_qp_node, &(core_to_xqp(xqp)->ibqp), wq,
+						  idx, wc + *npolled + sw_npolled);
+				++sw_npolled;
+			}
+
+			if (sw_npolled == ne - *npolled)
+				break;
+		}
+		*npolled += sw_npolled;
+		if (*npolled == ne)
+			break;
+	}
+
+	return 0;
+}
+
+int xsc_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
+{
+	struct xsc_ib_cq *cq = to_xcq(ibcq);
+	struct xsc_core_cq *xcq = &cq->xcq;
+	struct xsc_ib_qp *cur_qp = NULL;
+	int npolled = 0;
+	int err = 0;
+	unsigned long flags;
+	u32 next_cid;
+
+	spin_lock_irqsave(&cq->lock, flags);
+	next_cid = xcq->cons_index;
+
+	for (npolled = 0; npolled < num_entries; npolled++) {
+		if (cq->invalid) {
+			err = -EINVAL;
+			break;
+		}
+		err = xsc_poll_one(cq, &cur_qp, wc + npolled);
+		if (err)
+			break;
+	}
+
+	if (err) {
+		if (npolled < num_entries && !(list_empty(&cq->err_state_qp_list)))
+			xsc_generate_flush_err_cqe(ibcq, num_entries, &npolled, wc);
+	}
+
+	if (next_cid != xcq->cons_index)
+		xsc_update_cq_ci(xcq->dev, xcq->cqn, xcq->cons_index);
+
+	spin_unlock_irqrestore(&cq->lock, flags);
+
+	return npolled;
+}
+
+static int xsc_cqe_is_empty(struct xsc_ib_cq *cq)
+{
+	struct xsc_cqe *cqe = get_sw_cqe(cq, cq->xcq.cons_index);
+
+	if (cq->invalid)
+		return 1;
+
+	if (!cqe)
+		return 1;
+
+	return 0;
+}
+
+int xsc_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
+{
+	struct xsc_ib_cq *xcq = to_xcq(ibcq);
+	struct xsc_core_cq *cq = &xcq->xcq;
+	int ret = 0;
+	unsigned long irq_flags;
+	u8 solicited = 0;
+
+	spin_lock_irqsave(&xcq->lock, irq_flags);
+	if (flags & IB_CQ_NEXT_COMP)
+		solicited = 0;
+	else if (flags & IB_CQ_SOLICITED)
+		solicited = 1;/* arm next:0 arm solicited:1 */
+
+	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && (!xsc_cqe_is_empty(xcq))) {
+		ret = 1;
+		goto out;
+	}
+
+	xsc_arm_cq(cq->dev, cq->cqn, cq->cons_index, solicited);
+out:
+	spin_unlock_irqrestore(&xcq->lock, irq_flags);
+	return ret;
+}
+
+static int alloc_cq_buf(struct xsc_ib_dev *dev, struct xsc_ib_cq_buf *buf,
+			int nent, int cqe_size)
+{
+	int err;
+
+	err = xsc_buf_alloc(dev->xdev, nent * cqe_size,
+			    PAGE_SIZE, &buf->buf);
+	if (err)
+		return err;
+
+	buf->cqe_size = cqe_size;
+
+	return 0;
+}
+
+static void free_cq_buf(struct xsc_ib_dev *dev, struct xsc_ib_cq_buf *buf)
+{
+	xsc_buf_free(dev->xdev, &buf->buf);
+}
+
+static struct ib_umem *cq_umem_get(struct xsc_ib_dev *dev,
+				   struct ib_udata *udata, struct ib_ucontext *context,
+	int entries, struct xsc_ib_create_cq *ucmd)
+{
+	struct ib_umem *umem;
+
+	umem = ib_umem_get_va(&dev->ib_dev, ucmd->buf_addr,
+			      entries * ucmd->cqe_size,
+			      IB_ACCESS_LOCAL_WRITE);
+	return umem;
+}
+
+static int create_cq_user(struct xsc_ib_dev *dev, struct ib_udata *udata,
+			  struct ib_ucontext *context, struct xsc_ib_cq *cq,
+			  int entries, struct xsc_create_cq_ex_mbox_in **cqb,
+			  int *cqe_size, int *index, int *inlen)
+{
+	struct xsc_ib_create_cq ucmd;
+	int page_shift;
+	int npages;
+	int ncont;
+	int err;
+	int log_cq_sz;
+	int hw_npages;
+	struct ib_umem_dmabuf *umem_dmabuf;
+
+	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
+		return -EFAULT;
+
+	*cqe_size = ucmd.cqe_size;
+
+	if (ucmd.dmabuf_fd != -1) {
+		umem_dmabuf = ib_umem_dmabuf_get_pinned(&dev->ib_dev, 0, ucmd.dmabuf_sz,
+							ucmd.dmabuf_fd, IB_ACCESS_LOCAL_WRITE);
+
+		if (IS_ERR(umem_dmabuf)) {
+			ibdev_warn(&dev->ib_dev, "umem_dmabuf get failed by fd %d (%ld)\n",
+				   ucmd.dmabuf_fd, PTR_ERR(umem_dmabuf));
+			return -ENOMEM;
+		}
+
+		cq->buf.umem = &umem_dmabuf->umem;
+		ibdev_dbg(&dev->ib_dev, "get umem_dmabuf success by fd %d, umem_dmabuf_addr %p\n",
+			  ucmd.dmabuf_fd, umem_dmabuf);
+	} else {
+		cq->buf.umem = cq_umem_get(dev, udata, context, entries, &ucmd);
+	}
+
+	if (IS_ERR(cq->buf.umem)) {
+		err = PTR_ERR(cq->buf.umem);
+		return err;
+	}
+
+	xsc_ib_cont_pages(cq->buf.umem, ucmd.buf_addr, &npages, &page_shift,
+			  &ncont);
+	if (ncont != npages) {
+		ibdev_dbg(&dev->ib_dev, "bad page_shift:%d, ncont:%d\n", page_shift, ncont);
+		/* amber doesn't support compound pages */
+		page_shift = PAGE_SHIFT;
+		ncont = npages;
+		ibdev_dbg(&dev->ib_dev, "overwrite to page_shift:%d, ncont:%d\n",
+			  page_shift, ncont);
+	}
+	log_cq_sz = ilog2(entries);
+	hw_npages = DIV_ROUND_UP((1 << log_cq_sz) * (*cqe_size), PAGE_SIZE_4K);
+	ibdev_dbg(&dev->ib_dev, "addr 0x%llx, entries %d, npages %d, hw_npages %d\n",
+		  ucmd.buf_addr, entries, npages, hw_npages);
+
+	*inlen = sizeof(**cqb) + sizeof(*(*cqb)->pas) * hw_npages;
+	*cqb = xsc_vzalloc(*inlen);
+	if (!*cqb) {
+		err = -ENOMEM;
+		goto err_umem;
+	}
+	xsc_ib_populate_pas(dev, cq->buf.umem, page_shift, (*cqb)->pas, hw_npages, true);
+	(*cqb)->ctx_ex.ctx.pa_num = cpu_to_be16(hw_npages);
+	(*cqb)->ctx_ex.pa_num_ex = cpu_to_be32(hw_npages);
+
+	return 0;
+
+err_umem:
+	ib_umem_release(cq->buf.umem);
+	return err;
+}
+
+static void destroy_cq_user(struct xsc_ib_cq *cq, struct ib_udata *udata)
+{
+	ib_umem_release(cq->buf.umem);
+}
+
+static int create_cq_kernel(struct xsc_ib_dev *dev, struct xsc_ib_cq *cq,
+			    int entries, int cqe_size,
+			    struct xsc_create_cq_ex_mbox_in **cqb,
+			    int *index, int *inlen)
+{
+	int err;
+	int i = 0;
+	struct xsc_cqe *cqe = NULL;
+	int hw_npages;
+
+	cq->xcq.cqe_sz = cqe_size;
+
+	err = alloc_cq_buf(dev, &cq->buf, entries, cqe_size);
+	if (err)
+		return err;
+
+	for (i = 0; i < entries; i++) {
+		cqe = (struct xsc_cqe *)get_cqe(cq, i);
+		cqe->owner = 1;
+	}
+
+	hw_npages = DIV_ROUND_UP(entries * cqe_size, PAGE_SIZE_4K);
+	*inlen = sizeof(**cqb) + sizeof(*(*cqb)->pas) * hw_npages;
+	*cqb = xsc_vzalloc(*inlen);
+	if (!*cqb) {
+		err = -ENOMEM;
+		goto err_buf;
+	}
+	xsc_fill_page_array(&cq->buf.buf, (*cqb)->pas, hw_npages);
+	(*cqb)->ctx_ex.ctx.pa_num = cpu_to_be16(hw_npages);
+	(*cqb)->ctx_ex.pa_num_ex = cpu_to_be32(hw_npages);
+
+	return 0;
+
+err_buf:
+	free_cq_buf(dev, &cq->buf);
+	return err;
+}
+
+static void destroy_cq_kernel(struct xsc_ib_dev *dev, struct xsc_ib_cq *cq)
+{
+	free_cq_buf(dev, &cq->buf);
+}
+
+int xsc_ib_create_cq(struct ib_cq *ibcq,
+		     const struct ib_cq_init_attr *attr,
+		     struct uverbs_attr_bundle *attrs)
+{
+	struct ib_device *ibdev = ibcq->device;
+	struct ib_udata *udata = attrs ? &attrs->driver_udata : NULL;
+	int entries = attr->cqe;
+	int vector = attr->comp_vector;
+	struct xsc_create_cq_ex_mbox_in *cqb = NULL;
+	struct xsc_ib_dev *dev = to_xdev(ibdev);
+	struct xsc_ib_cq *cq;
+	int index;
+	int inlen = 0;
+	int cqe_size;
+	int irqn;
+	int err;
+	unsigned int eqn;
+
+	entries = roundup_pow_of_two(entries);
+
+	ibdev_dbg(&dev->ib_dev, "entries:%d, vector:%d, max_cqes:%d\n", entries, vector,
+		  dev->xdev->caps.max_cqes);
+
+	if (entries > dev->xdev->caps.max_cqes)
+		entries = dev->xdev->caps.max_cqes;
+	cq = to_xcq(ibcq);
+	cq->ibcq.cqe = entries;
+	mutex_init(&cq->resize_mutex);
+	spin_lock_init(&cq->lock);
+	cq->resize_buf = NULL;
+	cq->resize_umem = NULL;
+	cq->create_flags = attr->flags;
+	cq->invalid = 0;
+
+	if (udata) {
+		err = create_cq_user(dev, udata, NULL, cq, entries,
+				     &cqb, &cqe_size, &index, &inlen);
+		if (err)
+			goto err_create;
+	} else {
+		cqe_size = is_support_cqe64(dev->xdev) ?
+			sizeof(struct xsc_cqe64) : sizeof(struct xsc_cqe);
+		err = create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index, &inlen);
+		if (err)
+			goto err_create;
+	}
+
+	cq->cqe_size = cqe_size;
+	cqb->ctx_ex.ctx.log_cq_sz = ilog2(entries);
+	cqb->ctx_ex.ctx.glb_func_id = cpu_to_be16(dev->xdev->glb_func_id);
+
+	err = xsc_vector2eqn(dev->xdev, vector, &eqn, &irqn);
+	if (err)
+		goto err_cqb;
+
+	cqb->ctx_ex.ctx.eqn = eqn;
+	cqb->ctx_ex.ctx.eqn = cpu_to_be16(cqb->ctx_ex.ctx.eqn);
+	cqb->ctx_ex.page_shift = PAGE_SHIFT;
+	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
+		cqb->ctx_ex.overrun_ignore = 1;
+
+	err = xsc_core_create_cq(dev->xdev, &cq->xcq, cqb, inlen);
+	if (err)
+		goto err_cqb;
+
+	ibdev_dbg(&dev->ib_dev, "succeeded to create cqn %d, vector=%d, cq_sz=%d, eqn=%d\n",
+		  cq->xcq.cqn, vector, entries, eqn);
+	cq->xcq.irqn = irqn;
+	cq->xcq.comp  = xsc_ib_cq_comp;
+	cq->xcq.event = xsc_ib_cq_event;
+
+	if (udata) {
+		if (ib_copy_to_udata(udata, &cq->xcq.cqn, sizeof(__u32))) {
+			err = -EFAULT;
+			goto err_cmd;
+		}
+	}
+
+	INIT_LIST_HEAD(&cq->send_qp_list);
+	INIT_LIST_HEAD(&cq->recv_qp_list);
+	INIT_LIST_HEAD(&cq->err_state_qp_list);
+	xsc_vfree(cqb);
+
+	return 0;
+
+err_cmd:
+	xsc_core_destroy_cq(dev->xdev, &cq->xcq);
+
+err_cqb:
+	xsc_vfree(cqb);
+	if (udata)
+		destroy_cq_user(cq, udata);
+	else
+		destroy_cq_kernel(dev, cq);
+
+err_create:
+
+	return err;
+}
+
+int xsc_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(cq->device);
+	struct xsc_ib_cq *xcq = to_xcq(cq);
+	struct xsc_err_state_qp_node *tmp = NULL, *err_qp_node = NULL;
+
+	list_for_each_entry_safe(err_qp_node, tmp, &xcq->err_state_qp_list, entry) {
+		list_del(&err_qp_node->entry);
+		kfree(err_qp_node);
+	}
+
+	xsc_core_destroy_cq(dev->xdev, &xcq->xcq);
+	if (udata)
+		destroy_cq_user(xcq, udata);
+	else
+		destroy_cq_kernel(dev, xcq);
+
+	return 0;
+}
+
+static int is_equal_rsn(struct xsc_cqe *cqe, u32 rsn)
+{
+	u32 qpn = le32_to_cpu(cqe->qp_id);
+	return rsn == qpn;
+}
+
+void __xsc_ib_cq_clean(struct xsc_ib_cq *cq, u32 rsn)
+{
+	struct xsc_cqe *cqe, *dest;
+	u32 prod_index;
+	int nfreed = 0;
+	u8 owner_bit;
+
+	if (!cq)
+		return;
+
+	/* First we need to find the current producer index, so we
+	 * know where to start cleaning from.  It doesn't matter if HW
+	 * adds new entries after this loop -- the QP we're worried
+	 * about is already in RESET, so the new entries won't come
+	 * from our QP and therefore don't need to be checked.
+	 */
+	for (prod_index = cq->xcq.cons_index; get_sw_cqe(cq, prod_index); prod_index++)
+		if (prod_index == cq->xcq.cons_index + cq->ibcq.cqe)
+			break;
+
+	/* Now sweep backwards through the CQ, removing CQ entries
+	 * that match our QP by copying older entries on top of them.
+	 */
+	while ((int)(--prod_index) - (int)cq->xcq.cons_index >= 0) {
+		cqe = (struct xsc_cqe *)get_cqe(cq, prod_index & (cq->ibcq.cqe - 1));
+		if (is_equal_rsn(cqe, rsn)) {
+			++nfreed;
+		} else if (nfreed) {
+			dest = (struct xsc_cqe *)get_cqe(cq, (prod_index + nfreed) &
+							 (cq->ibcq.cqe - 1));
+			owner_bit = dest->owner & XSC_CQE_OWNER_MASK;
+			memcpy(dest, cqe, cq->xcq.cqe_sz);
+			dest->owner = owner_bit |
+				(dest->owner & ~XSC_CQE_OWNER_MASK);
+		}
+	}
+
+	if (nfreed) {
+		cq->xcq.cons_index += nfreed;
+		xsc_update_cq_ci(cq->xcq.dev, cq->xcq.cqn, cq->xcq.cons_index);
+	}
+}
+
+void xsc_ib_cq_clean(struct xsc_ib_cq *cq, u32 qpn)
+{
+	if (!cq)
+		return;
+
+	spin_lock_irq(&cq->lock);
+	__xsc_ib_cq_clean(cq, qpn);
+	spin_unlock_irq(&cq->lock);
+}
diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index bd2c23b51..e9a9ba114 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -563,10 +563,17 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 
 	dev->ib_dev.ops.alloc_pd		= xsc_ib_alloc_pd;
 	dev->ib_dev.ops.dealloc_pd		= xsc_ib_dealloc_pd;
+	dev->ib_dev.ops.create_ah		= xsc_ib_create_ah;
+	dev->ib_dev.ops.query_ah		= xsc_ib_query_ah;
+	dev->ib_dev.ops.destroy_ah		= xsc_ib_destroy_ah;
 
 	dev->ib_dev.ops.get_link_layer	= xsc_ib_port_link_layer;
 	dev->ib_dev.ops.get_netdev		= xsc_get_netdev;
 
+	dev->ib_dev.ops.create_cq		= xsc_ib_create_cq;
+	dev->ib_dev.ops.destroy_cq		= xsc_ib_destroy_cq;
+	dev->ib_dev.ops.poll_cq		= xsc_ib_poll_cq;
+	dev->ib_dev.ops.req_notify_cq	= xsc_ib_arm_cq;
 	dev->ib_dev.ops.get_dma_mr		= xsc_ib_get_dma_mr;
 	dev->ib_dev.ops.reg_user_mr		= xsc_ib_reg_user_mr; /* optional */
 	dev->ib_dev.ops.reg_user_mr_dmabuf	= xsc_ib_reg_user_mr_dmabuf;
@@ -575,9 +582,17 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 	dev->ib_dev.ops.get_port_immutable		= xsc_port_immutable;
 
 	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
+	dev->ib_dev.ops.create_srq		= xsc_ib_create_srq;
+	dev->ib_dev.ops.destroy_srq		= xsc_ib_destroy_srq;
+	dev->ib_dev.ops.query_srq		= xsc_ib_query_srq;
+	dev->ib_dev.ops.modify_srq		= xsc_ib_modify_srq;
+	dev->ib_dev.ops.post_srq_recv	= xsc_ib_post_srq_recv;
 
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ucontext, xsc_ib_ucontext, ibucontext);
+	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ah, xsc_ib_ah, ibah);
+	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_cq, xsc_ib_cq, ibcq);
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_pd, xsc_ib_pd, ibpd);
+	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_srq, xsc_ib_srq, ibsrq);
 }
 
 static void xsc_get_port_state(struct net_device *ndev, enum xsc_dev_event *ev)
diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/qp.c
new file mode 100644
index 000000000..28c8a1246
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/qp.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <rdma/ib_umem.h>
+#include "xsc_ib.h"
+#include <rdma/xsc-abi.h>
+#include "common/xsc_hsi.h"
+#include <linux/crc32.h>
+#include <linux/dma-direct.h>
+#include <rdma/ib_addr.h>
+
+#ifndef ETH_P_IBOE
+#define ETH_P_IBOE	0x8915
+#endif
+
+#define MAD_QUEUE_DEPTH        128
+
+enum {
+	XSC_IB_CACHE_LINE_SIZE	= 64,
+};
+
+#define UDP_SPORT_MASK_EN		0x40000000
+#define UDP_SPORT_MASK_EN_OFFSET	30
+#define UDP_SPORT_MASK			0xffff
+#define UDP_SPORT_OFFSET		0
+
+static int is_qp1(enum ib_qp_type qp_type)
+{
+	return qp_type == IB_QPT_GSI;
+}
+
+static void *get_wqe(struct xsc_ib_qp *qp, int offset)
+{
+	return xsc_buf_offset(&qp->buf, offset);
+}
+
+static void *get_recv_wqe(struct xsc_ib_qp *qp, int n)
+{
+	return get_wqe(qp, qp->rq.offset + (n << qp->rq.wqe_shift));
+}
+
+static void *get_seg_wqe(void *first, int n)
+{
+	return first + (n << XSC_BASE_WQE_SHIFT);
+}
+
+#define MAX_QP1_SQ_HDR_SIZE_V2	512
+#define MAX_QP1_SQ_HDR_SIZE	86
+	/* Ethernet header	=  14 */
+	/* ib_grh		=  40 (provided by MAD) */
+	/* ib_bth + ib_deth	=  20 */
+	/* MAD			= 256 (provided by MAD) */
+	/* iCRC			=   4 */
+#define MAX_QP1_RQ_HDR_SIZE_V2	512
+
+static inline void xsc_ib_trigger_cq_comp_handler(struct ib_cq *send_cq, struct ib_cq *recv_cq)
+{
+	if (send_cq)
+		send_cq->comp_handler(send_cq, send_cq->cq_context);
+
+	if (recv_cq && send_cq != recv_cq)
+		recv_cq->comp_handler(recv_cq, recv_cq->cq_context);
+}
+
+int xsc_ib_err_state_qp(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp,
+			enum xsc_qp_state cur_state, enum xsc_qp_state state)
+{
+	struct xsc_err_state_qp_node *tmp = NULL, *err_rq_node = NULL, *err_sq_node = NULL;
+	struct xsc_ib_cq *send_xcq, *recv_xcq;
+
+	ibdev_dbg(&dev->ib_dev, "modify qp: qpid %d, cur_qp_state %d, qp_state %d\n",
+		  qp->xqp.qpn, cur_state, state);
+	if (cur_state == XSC_QP_STATE_ERR && state != XSC_QP_STATE_ERR) {
+		if (!qp->ibqp.srq && qp->recv_cq) {
+			recv_xcq = to_xcq(qp->recv_cq);
+			list_for_each_entry_safe(err_rq_node, tmp,
+						 &recv_xcq->err_state_qp_list, entry) {
+				if (err_rq_node->qp_id == qp->xqp.qpn && !err_rq_node->is_sq) {
+					list_del(&err_rq_node->entry);
+					kfree(err_rq_node);
+				}
+			}
+		}
+
+		if (qp->send_cq) {
+			send_xcq = to_xcq(qp->send_cq);
+			list_for_each_entry_safe(err_sq_node, tmp,
+						 &send_xcq->err_state_qp_list, entry) {
+				if (err_sq_node->qp_id == qp->xqp.qpn && err_sq_node->is_sq) {
+					list_del(&err_sq_node->entry);
+					kfree(err_sq_node);
+				}
+			}
+		}
+		return 0;
+	}
+
+	if (cur_state != XSC_QP_STATE_ERR && state == XSC_QP_STATE_ERR &&
+	    !qp->has_trig_cq_comp_handle) {
+		if (!qp->ibqp.srq && qp->recv_cq) {
+			err_rq_node = kzalloc_obj(*err_rq_node, GFP_KERNEL);
+			if (!err_rq_node)
+				return -ENOMEM;
+			err_rq_node->qp_id = qp->xqp.qpn;
+			err_rq_node->is_sq = false;
+			recv_xcq = to_xcq(qp->recv_cq);
+			list_add_tail(&err_rq_node->entry, &recv_xcq->err_state_qp_list);
+		}
+
+		if (qp->send_cq) {
+			err_sq_node = kzalloc_obj(*err_sq_node, GFP_KERNEL);
+			if (!err_sq_node)
+				return -ENOMEM;
+			err_sq_node->qp_id = qp->xqp.qpn;
+			err_sq_node->is_sq = true;
+			send_xcq = to_xcq(qp->send_cq);
+			list_add_tail(&err_sq_node->entry, &send_xcq->err_state_qp_list);
+		}
+
+		xsc_ib_trigger_cq_comp_handler(qp->send_cq, qp->recv_cq);
+		qp->has_trig_cq_comp_handle = true;
+	}
+	return 0;
+}
+
+enum xsc_ib_qp_ex_attr_mask {
+	XSC_IB_QP_FLUSH		= 1 << 21,
+};
+
+static int xsc_wq_overflow(struct xsc_ib_wq *wq, int nreq, struct xsc_ib_cq *cq)
+{
+	unsigned int cur;
+
+	cur = wq->head - wq->tail;
+	if (likely(cur + nreq < wq->max_post))
+		return 0;
+
+	spin_lock(&cq->lock);
+	cur = wq->head - wq->tail;
+	spin_unlock(&cq->lock);
+
+	return cur + nreq >= wq->max_post;
+}
+
+#define BTH_QPN_MASK		(0x00ffffff)
+#define BTH_PSN_MASK		(0x00ffffff)
+
+/* Compute a partial ICRC for all the IB transport headers. */
+
+/* Routine for sending QP1 packets for RoCE V1 an V2 */
+/* TODO: sq hdr buf should be created dynamically for mult entry */
+
+int xsc_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
+		     const struct ib_recv_wr **bad_wr)
+{
+	struct xsc_ib_qp *qp = to_xqp(ibqp);
+	struct xsc_ib_dev *dev = to_xdev(ibqp->device);
+	struct xsc_core_device *xdev = dev->xdev;
+	struct xsc_wqe_data_seg *recv_head;
+	struct xsc_wqe_data_seg *data_seg;
+	unsigned long flags = 0;
+	int err = 0;
+	u32 next_pid = 0;
+	int nreq = 0;
+	u32 idx;
+	int i;
+
+	spin_lock_irqsave(&qp->rq.lock, flags);
+
+	idx = qp->rq.head & (qp->rq.wqe_cnt - 1);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (unlikely(xsc_wq_overflow(&qp->rq, nreq, to_xcq(qp->ibqp.recv_cq)))) {
+			ibdev_err(&dev->ib_dev, "recv work queue overflow\n");
+			err = -ENOMEM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(wr->num_sge > qp->rq.max_gs)) {
+			ibdev_err(&dev->ib_dev, "max gs exceeded %d (max = %d)\n",
+				  wr->num_sge, qp->rq.max_gs);
+			err = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(qp->post_recv_invalid)) {
+			ibdev_dbg(&dev->ib_dev, "qp %d has been draind, post recv invalid...\n",
+				  qp->xqp.qpn);
+			err = -EIO;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		recv_head = get_recv_wqe(qp, idx);
+
+		for (i = 0; i < wr->num_sge; ++i) {
+			if (unlikely(!wr->sg_list[i].length))
+				continue;
+			data_seg = get_seg_wqe(recv_head, i);
+			data_seg->in_line = 0;
+			WR_LE_64(data_seg->va, wr->sg_list[i].addr);
+			WR_LE_32(data_seg->mkey, wr->sg_list[i].lkey);
+			if (is_qp1(qp->xqp.qp_type))
+				WR_LE_32(data_seg->seg_len, xdev->caps.rx_pkt_len_max);
+			else
+				WR_LE_32(data_seg->seg_len, wr->sg_list[i].length);
+		}
+
+		qp->rq.wrid[idx] = wr->wr_id;
+
+		idx = (idx + 1) & (qp->rq.wqe_cnt - 1);
+		atomic_inc(&qp->rq.flush_wqe_cnt);
+	}
+
+out:
+	if (likely(nreq)) {
+		qp->rq.head += nreq;
+		next_pid = qp->rq.head << (qp->rq.wqe_shift - XSC_BASE_WQE_SHIFT);
+
+		xsc_update_rx_db(xdev, qp->doorbell_qpn, next_pid);
+	}
+
+	spin_unlock_irqrestore(&qp->rq.lock, flags);
+
+	return err;
+}
+
+struct xsc_ib_drain_cqe {
+	struct ib_cqe cqe;
+	struct completion done;
+	int qpn;
+};
+
diff --git a/drivers/infiniband/hw/xsc/srq.c b/drivers/infiniband/hw/xsc/srq.c
new file mode 100644
index 000000000..911820fa1
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/srq.c
@@ -0,0 +1,426 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/slab.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
+#include "xsc_ib.h"
+#include "common/srq.h"
+#include <rdma/xsc-abi.h>
+#include <linux/list_sort.h>
+
+static int xsc_init_cache_wr(struct ib_srq_init_attr *attr, struct xsc_ib_srq *srq)
+{
+	int srqn = srq->xsrq.srqn;
+	struct xsc_srq_cache_wr *cache_wr = srq->xsrq.cache_wr;
+
+	if (srqn >= XSC_MAX_SRQ_NUM)
+		return -EINVAL;
+
+	memset(&cache_wr[srqn], 0, sizeof(struct xsc_srq_cache_wr));
+	cache_wr[srqn].max_wr_num = attr->attr.max_wr;
+	return 0;
+}
+
+void xsc_restore_cache_srq_wrs(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp)
+{
+	int srqn = srq->xsrq.srqn;
+	struct xsc_srq_cache_wr *cache_wr = srq->xsrq.cache_wr;
+
+	if (qp->srq_tail_wr)
+		qp->srq_tail_wr->next = cache_wr[srqn].head_wr;
+	if (cache_wr[srqn].head_wr && qp->srq_head_wr)
+		cache_wr[srqn].head_wr = qp->srq_head_wr;
+}
+
+void xsc_free_one_cache_srq_wr(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp, u64 wr_id)
+{
+	struct ib_recv_wr *tmp_wr, *prev_wr = NULL;
+	int srqn = srq->xsrq.srqn;
+	struct xsc_srq_cache_wr *cache_wr = srq->xsrq.cache_wr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&srq->lock, flags);
+	tmp_wr = qp->srq_head_wr;
+	for (; tmp_wr; tmp_wr = tmp_wr->next) {
+		if (tmp_wr->wr_id == wr_id) {
+			if (prev_wr)
+				prev_wr->next = tmp_wr->next;
+			else
+				qp->srq_head_wr = tmp_wr->next;
+
+			kfree(tmp_wr->sg_list);
+			kfree(tmp_wr);
+			break;
+		}
+		prev_wr = tmp_wr;
+	}
+	cache_wr[srqn].wr_num--;
+	spin_unlock_irqrestore(&srq->lock, flags);
+}
+
+void xsc_free_all_cache_wrs(struct ib_recv_wr *wr)
+{
+	struct ib_recv_wr *prev_wr = NULL;
+
+	for (; wr; wr = wr->next) {
+		kfree(prev_wr);
+		kfree(wr->sg_list);
+		prev_wr = wr;
+	}
+	kfree(prev_wr);
+}
+
+static void xsc_destroy_cache_wr(struct xsc_ib_srq *srq)
+{
+	int srqn = srq->xsrq.srqn;
+	struct xsc_srq_cache_wr *cache_wr = srq->xsrq.cache_wr;
+
+	xsc_free_all_cache_wrs(cache_wr[srqn].head_wr);
+	memset(&cache_wr[srqn], 0, sizeof(struct xsc_srq_cache_wr));
+}
+
+static void xsc_ib_srq_event(struct xsc_core_srq *srq, enum xsc_event type)
+{
+	struct ib_event event;
+	struct ib_srq *ibsrq = &core_to_xsrq(srq)->ibsrq;
+
+	if (ibsrq->event_handler) {
+		event.device      = ibsrq->device;
+		event.element.srq = ibsrq;
+		switch (type) {
+		default:
+			pr_warn("xsc_ib: Unexpected event type %d on SRQ %06x\n",
+				type, srq->srqn);
+			return;
+		}
+
+		ibsrq->event_handler(&event, ibsrq->srq_context);
+	}
+}
+
+static int create_srq_user(struct ib_pd *pd, struct xsc_ib_srq *srq,
+			   struct ib_srq_init_attr *init_attr,
+			   struct ib_udata *udata, int buf_size)
+{
+	struct xsc_ib_dev *dev = to_xdev(pd->device);
+	struct xsc_ib_create_srq ucmd = {};
+	size_t ucmdlen;
+
+	ucmdlen = min(udata->inlen, sizeof(ucmd));
+
+	if (ib_copy_from_udata(&ucmd, udata, ucmdlen)) {
+		ibdev_dbg(&dev->ib_dev, "failed copy udata\n");
+		return -EFAULT;
+	}
+
+	if (ucmd.reserved0 || ucmd.reserved1)
+		return -EINVAL;
+
+	if (udata->inlen > sizeof(ucmd) &&
+	    !ib_is_udata_cleared(udata, sizeof(ucmd),
+				 udata->inlen - sizeof(ucmd)))
+		return -EINVAL;
+
+	srq->create_type = XSC_SRQ_USER;
+
+	return 0;
+}
+
+static int create_srq_kernel(struct xsc_ib_dev *dev, struct xsc_ib_srq *srq,
+			     struct ib_srq_init_attr *init_attr, int buf_size)
+{
+	srq->create_type = XSC_SRQ_KERNEL;
+	return 0;
+}
+
+static void destroy_srq_user(struct xsc_ib_srq *srq, struct ib_udata *udata)
+{
+}
+
+static void destroy_srq_kernel(struct xsc_ib_dev *dev, struct xsc_ib_srq *srq)
+{
+}
+
+int xsc_ib_create_srq(struct ib_srq *ib_srq,
+		      struct ib_srq_init_attr *init_attr,
+		      struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev;
+	struct xsc_ib_srq *srq;
+	int err;
+	u32 max_srq_wqes = 1 << XSC_MAX_SRQ_LOG_SIZE;
+	struct ib_pd *pd = ib_srq->pd;
+
+	if (pd) {
+		dev = to_xdev(pd->device);
+	} else {
+		pr_warn("%s: no PD for SRQ\n", __func__);
+		err = -EINVAL;
+		goto err_ret;
+	}
+
+	if (init_attr->srq_type != IB_SRQT_BASIC) {
+		err = -EOPNOTSUPP;
+		goto err_ret;
+	}
+
+	/* Sanity check SRQ size before proceeding */
+	if (init_attr->attr.max_wr >= max_srq_wqes) {
+		ibdev_dbg(&dev->ib_dev, "max_wr %d, cap %d\n",
+			  init_attr->attr.max_wr,
+			   max_srq_wqes);
+		err = -EINVAL;
+		goto err_ret;
+	}
+
+	srq = to_xsrq(ib_srq);
+
+	mutex_init(&srq->mutex);
+	spin_lock_init(&srq->lock);
+	srq->xsrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);
+	srq->xsrq.max_gs = init_attr->attr.max_sge;
+
+	if (udata)
+		err = create_srq_user(pd, srq, NULL, udata, 0);
+	else
+		err = create_srq_kernel(dev, srq, init_attr, 0);
+
+	if (err) {
+		ibdev_dbg(&dev->ib_dev, "create srq rsc failed, ret %d", err);
+		goto err_create_rsc;
+	}
+
+	err = xsc_core_create_srq(dev->xdev, &srq->xsrq);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "create srq failed, err=%d\n", err);
+		goto err_create;
+	}
+	ibdev_dbg(&dev->ib_dev, "create SRQ with srqn 0x%x, max_wr %d\n",
+		  srq->xsrq.srqn, init_attr->attr.max_wr);
+
+	srq->xsrq.event = xsc_ib_srq_event;
+	srq->ibsrq.ext.xrc.srq_num = srq->xsrq.srqn;
+
+	if (udata) {
+		struct xsc_ib_create_srq_resp resp = {
+			.srqn = srq->xsrq.srqn,
+		};
+
+		if (ib_copy_to_udata(udata, &resp,
+				     min(udata->outlen, sizeof(resp)))) {
+			ibdev_dbg(&dev->ib_dev, "copy to user failed\n");
+			err = -EFAULT;
+			goto err_rsp;
+		}
+	} else {
+		err = xsc_init_cache_wr(init_attr, srq);
+		if (err)
+			goto err_rsp;
+		INIT_LIST_HEAD(&srq->xsrq.srq_qp_list);
+	}
+
+	init_attr->attr.max_wr = srq->xsrq.max - 1;
+
+	return 0;
+err_rsp:
+	xsc_core_destroy_srq(dev->xdev, &srq->xsrq);
+err_create:
+	if (udata)
+		destroy_srq_user(srq, udata);
+	else
+		destroy_srq_kernel(dev, srq);
+err_create_rsc:
+err_ret:
+	return err;
+}
+
+int xsc_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		      enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
+{
+	/* We don't support resizing SRQs yet */
+	if (attr_mask & IB_SRQ_MAX_WR)
+		return -EINVAL;
+
+	if (attr_mask & IB_SRQ_LIMIT)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+int xsc_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
+{
+	struct xsc_ib_srq *srq = to_xsrq(ibsrq);
+
+	srq_attr->srq_limit = 0;
+	srq_attr->max_wr    = srq->xsrq.max - 1;
+	srq_attr->max_sge   = srq->xsrq.max_gs;
+
+	return 0;
+}
+
+int xsc_ib_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
+{
+	struct xsc_ib_srq *xsrq = to_xsrq(srq);
+	struct xsc_ib_dev *dev = to_xdev(srq->device);
+
+	xsc_core_destroy_srq(dev->xdev, &xsrq->xsrq);
+	if (xsrq->create_type == XSC_SRQ_USER) {
+		destroy_srq_user(xsrq, NULL);
+	} else {
+		xsc_destroy_cache_wr(xsrq);
+		destroy_srq_kernel(dev, xsrq);
+	}
+
+	ibdev_dbg(&dev->ib_dev, "destroy srq %d successfully.\n", xsrq->xsrq.srqn);
+	return 0;
+}
+
+static int cmp_flush_wqe_cnt(void *priv,
+			     const struct list_head *a,
+			     const struct list_head *b)
+{
+	const struct xsc_srq_qp_node *na =
+		list_entry(a, struct xsc_srq_qp_node, entry);
+	const struct xsc_srq_qp_node *nb =
+		list_entry(b, struct xsc_srq_qp_node, entry);
+
+	int fa = atomic_read(&(to_xqp(na->ibqp)->rq.flush_wqe_cnt));
+	int fb = atomic_read(&(to_xqp(nb->ibqp)->rq.flush_wqe_cnt));
+
+	return fa - fb;
+}
+
+static int xsc_cache_srq_wr(struct xsc_ib_srq *srq, const struct ib_recv_wr *wr, int *nreq)
+{
+	int i, n;
+	int srqn = srq->xsrq.srqn;
+	struct xsc_srq_cache_wr *cache_wr = srq->xsrq.cache_wr;
+	struct ib_recv_wr *head_wr = NULL, *new_wr = NULL, *prev_wr = NULL;
+
+	for (n = 0; wr; wr = wr->next, n++) {
+		new_wr = kcalloc(1, sizeof(struct ib_recv_wr), GFP_KERNEL);
+		if (prev_wr)
+			prev_wr->next = new_wr;
+		else
+			head_wr = new_wr;
+		new_wr->wr_id = wr->wr_id;
+		new_wr->sg_list = kcalloc(wr->num_sge, sizeof(struct ib_sge), GFP_KERNEL);
+		for (i = 0; i < wr->num_sge; i++)
+			memcpy(&new_wr->sg_list[i], &wr->sg_list[i], sizeof(struct ib_sge));
+		new_wr->num_sge = wr->num_sge;
+		prev_wr = new_wr;
+	};
+
+	if (!cache_wr[srqn].head_wr)
+		cache_wr[srqn].head_wr = head_wr;
+	else
+		cache_wr[srqn].tail_wr->next = head_wr;
+
+	cache_wr[srqn].tail_wr = new_wr;
+	cache_wr[srqn].wr_num += n;
+	*nreq = n;
+
+	if (cache_wr[srqn].wr_num > cache_wr[srqn].max_wr_num)
+		return -1;
+	else
+		return 0;
+}
+
+void xsc_post_cache_wrs(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp, int wr_num, bool init)
+{
+	int srqn = srq->xsrq.srqn;
+	struct xsc_srq_cache_wr *cache_wr = srq->xsrq.cache_wr;
+	int err = 0;
+	int i;
+	const struct ib_recv_wr *tmp_wr;
+	const struct ib_recv_wr *bad_wr;
+	struct ib_recv_wr *wr_head, *next_wr;
+
+	if (!cache_wr[srqn].head_wr)
+		return;
+
+	wr_head = cache_wr[srqn].head_wr;
+	next_wr = cache_wr[srqn].head_wr;
+
+	if (init)
+		qp->srq_head_wr = wr_head;
+	else
+		qp->srq_tail_wr->next = wr_head;
+
+	qp->srq_tail_wr = wr_head;
+	for (i = 0; next_wr && i < (wr_num - 1); i++) {
+		next_wr = next_wr->next;
+		if (next_wr)
+			qp->srq_tail_wr = next_wr;
+	}
+
+	cache_wr[srqn].head_wr = qp->srq_tail_wr->next;
+	qp->srq_tail_wr->next = NULL;
+	tmp_wr = wr_head;
+	err = xsc_ib_post_recv(&qp->ibqp, tmp_wr, &bad_wr);
+	if (err) {
+		qp->srq_tail_wr->next = cache_wr[srqn].head_wr;
+		qp->srq_tail_wr = NULL;
+		for (; wr_head && (bad_wr->wr_id != wr_head->wr_id); wr_head = wr_head->next)
+			qp->srq_tail_wr = wr_head;
+
+		if (!qp->srq_tail_wr) {
+			cache_wr[srqn].head_wr = wr_head;
+			qp->srq_head_wr = NULL;
+		} else {
+			cache_wr[srq->xsrq.srqn].head_wr = qp->srq_tail_wr->next;
+			qp->srq_tail_wr->next = NULL;
+		}
+	}
+}
+
+int xsc_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
+			 const struct ib_recv_wr **bad_wr)
+{
+	struct xsc_ib_srq *srq = to_xsrq(ibsrq);
+	struct xsc_ib_dev *dev = to_xdev(ibsrq->device);
+	struct xsc_srq_qp_node *qp_node;
+	struct xsc_ib_qp *qp;
+	unsigned long flags;
+	int err = 0;
+	int flush_wqe_cnt = 0;
+	int nreq = 0;
+	int wr_num = 0;
+
+	spin_lock_irqsave(&srq->lock, flags);
+
+	err = xsc_cache_srq_wr(srq, wr, &nreq);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "No more space to cache SRQ WRs...");
+		err = -EINVAL;
+		*bad_wr = wr;
+		goto out;
+	}
+
+	if (list_empty(&srq->xsrq.srq_qp_list))
+		goto out;
+
+	list_sort(NULL, &srq->xsrq.srq_qp_list, cmp_flush_wqe_cnt);
+
+	list_for_each_entry(qp_node, &srq->xsrq.srq_qp_list, entry) {
+		if (!qp_node || nreq <= 0)
+			break;
+
+		qp = to_xqp(qp_node->ibqp);
+		flush_wqe_cnt = atomic_read(&qp->rq.flush_wqe_cnt);
+		wr_num = min_t(int, nreq, (XSC_SRQ_MIN_WR_NUM - flush_wqe_cnt));
+		nreq -= wr_num;
+		ibdev_dbg(&dev->ib_dev, "srq_qp_list qp node qp %d, flush cnt %d, nreq %d, wr_num %d\n",
+			  qp_node->qp_id, flush_wqe_cnt, nreq, wr_num);
+		xsc_post_cache_wrs(srq, qp, wr_num, false);
+	}
+
+out:
+	spin_unlock_irqrestore(&srq->lock, flags);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 065d52ebf..fe0f9d175 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,5 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o pd.o mr.o link.o alloc.o eq.o pci_irq.o adev.o vport.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o pd.o mr.o srq.o link.o alloc.o eq.o pci_irq.o adev.o vport.o \
+		hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index c4416a78b..c2a9f4863 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -8,6 +8,7 @@
 #include "hw.h"
 #include "qp.h"
 #include "cq.h"
+#include "srq.h"
 #include "eq.h"
 #include "pci_irq.h"
 #include "adev.h"
@@ -120,11 +121,20 @@ static int xsc_dev_res_init(struct xsc_core_device *xdev)
 	mutex_init(&dev_res->alloc_mutex);
 	spin_lock_init(&dev_res->mkey_lock);
 
+	if (xsc_create_srq_res(xdev))
+		goto err_free;
+
 	return 0;
+
+err_free:
+	kfree(dev_res);
+	xdev->dev_res = NULL;
+	return -ENOMEM;
 }
 
 static void xsc_dev_res_cleanup(struct xsc_core_device *xdev)
 {
+	xsc_destroy_srq_res(xdev);
 	kfree(xdev->dev_res);
 }
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/srq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/srq.c
new file mode 100644
index 000000000..c2f9c1a88
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/srq.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "common/xsc_core.h"
+#include "common/srq.h"
+#include "srq.h"
+
+int xsc_create_srq_res(struct xsc_core_device *xdev)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+	u32 max_srq_num = XSC_MAX_SRQ_NUM;
+
+	dev_res->srq_tbl = bitmap_zalloc(max_srq_num, GFP_KERNEL);
+	if (!dev_res->srq_tbl)
+		return -ENOMEM;
+
+	dev_res->srq_cache_wr = vzalloc(max_srq_num *
+					sizeof(*dev_res->srq_cache_wr));
+	if (!dev_res->srq_cache_wr) {
+		bitmap_free(dev_res->srq_tbl);
+		dev_res->srq_tbl = NULL;
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&dev_res->srq_lock);
+	dev_res->max_srq_num = max_srq_num;
+
+	return 0;
+}
+
+void xsc_destroy_srq_res(struct xsc_core_device *xdev)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+
+	vfree(dev_res->srq_cache_wr);
+	dev_res->srq_cache_wr = NULL;
+	bitmap_free(dev_res->srq_tbl);
+	dev_res->srq_tbl = NULL;
+	dev_res->max_srq_num = 0;
+}
+
+int xsc_core_create_srq(struct xsc_core_device *xdev, struct xsc_core_srq *srq)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+	u32 srqn;
+
+	spin_lock(&dev_res->srq_lock);
+	srqn = find_first_zero_bit(dev_res->srq_tbl, dev_res->max_srq_num);
+	if (srqn == dev_res->max_srq_num) {
+		spin_unlock(&dev_res->srq_lock);
+		pci_err(xdev->pdev, "no free srq number\n");
+		return -ENOMEM;
+	}
+	set_bit(srqn, dev_res->srq_tbl);
+	spin_unlock(&dev_res->srq_lock);
+
+	srq->srqn = srqn;
+	/* array base: callers index it by srqn */
+	srq->cache_wr = dev_res->srq_cache_wr;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_create_srq);
+
+int xsc_core_destroy_srq(struct xsc_core_device *xdev, struct xsc_core_srq *srq)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+
+	if (srq->srqn >= dev_res->max_srq_num) {
+		pci_err(xdev->pdev, "invalid srqn %u\n", srq->srqn);
+		return -EINVAL;
+	}
+
+	spin_lock(&dev_res->srq_lock);
+	clear_bit(srq->srqn, dev_res->srq_tbl);
+	spin_unlock(&dev_res->srq_lock);
+
+	/*
+	 * The caller still owns the cached recv WRs in cache_wr[srqn] and
+	 * releases them right after this call, so the slot must be left
+	 * untouched here.
+	 */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_destroy_srq);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/srq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/srq.h
new file mode 100644
index 000000000..a70faf9e7
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/srq.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_SRQ_H
+#define __XSC_SRQ_H
+
+#include "common/xsc_core.h"
+#include "common/srq.h"
+
+/* return 0 on success, negative errno otherwise */
+int xsc_create_srq_res(struct xsc_core_device *xdev);
+void xsc_destroy_srq_res(struct xsc_core_device *xdev);
+
+#endif /* __XSC_SRQ_H */
