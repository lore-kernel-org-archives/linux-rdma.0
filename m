Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807853;
	b=S86dB9XHObbsMnl5UxdvZ2Vgu81AGkdLVqKEX0HiJ4b0/H66HskqKgiNqenfSShoU+BG
	 j04BnL1LGcgDvIVxPD97JCdq92P+o0HFwaBPeA5i31TMvfGBzRO+n7b+OOgBOppn+6KKv
	 9rQoy3EbEBdOMfqm6IB4NX0tsoJc8emZ4GBaHw0PWrhIoSBVICxYawnbm0wOvVtHNDo8C
	 xkBYzEJsDDsRhQONpaNWbJwTnO0Jv3j1u11iYxWBVckyfRjWt6zm8OpEW6OB5h2PxGRpQ
	 Xmjlxq5RuZ0ToiRR2PaoskuBGEfeOwL6mMB1Xyw58oPiwyG9S9to+4rBPBzF1d5dRhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807853;
	h=DMARC-Filter:DKIM-Signature:References:X-Mailer:In-Reply-To:
	 X-Original-From:Cc:Date:Subject:X-Lms-Return-Path:Content-Type:
	 Content-Transfer-Encoding:To:From:Received:Message-Id:Mime-Version;
	bh=M7/pQbl/0dko8gyV7AbmFVVpg/enOO+QNlgqehiIRNg=;
	b=kFqmFarI8AkYSjYBlSWTr/bE27LWuppFOMd9KY2AQQ4JhP6cp9XFfUXQy5x64s8Bsn8S
	 DYdyds0EoqZOud8Ck9r3T0soAmLRVzgZYAUrIWkeDTqTP+r7ZkaX+kZJ4zI+WWFy8RuKG
	 tjg3H+9YfHHdNh2PS7l/ZFrtuUiDS52/5I980oetGxXlFGVXtpZJ+pwBKrJ/rsnyI40dr
	 5Er8EWY27GFmdsgYaz3UyZqinrpWbF6sm9L8td97cq8+uEwMMfv5F+66Sk8N3OWamzoBK
	 M+69H/aUaJl+c7K+OPSRWF4h2o37kkbWbZhu7RnAmWB5V2kXbGI0m/BOOlPL5Fe/zfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=MpA0V3+B;
	arc=none smtp.remote-ip=209.127.231.35
Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4825260A2622
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4825260A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=MpA0V3+B
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807847; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=M7/pQbl/0dko8gyV7AbmFVVpg/enOO+QNlgqehiIRNg=;
 b=MpA0V3+Bd0lZBY/4PwEOFB8v1L7QPaeVLCBjY74FPr68UNHTzaFJ5qSw2t1ZMcwWW9vcb7
 6IOzZHJwM0w4X6fuTvowWjUZut8BMFLArrM3gsWsjt2Ng1id3c6aNWUblkq6DmghU9Kyi9
 Ykyb2KDr5LD4jded/l9SN5jut0NII1nctMyA/x+ddpg23qeHWy1y6LFfSMHwzldInlhTKL
 zt+Lmqk3nwzwFYV+ZdOt+F+Ef1AZaVNKU4wCrhK388O05Qi3g2CuY3DNsWhCujjHfWPiKN
 qqq7jhuIVkzdcMDj3s5paoXyPEvggrTKAXWKmjC8HHQ1ncaVRv7namrq8Pf5fQ==
References: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Date: Wed, 04 Nov 2026 23:57:25 +0800
Subject: [PATCH v1 14/15] RDMA/xsc: add the RDMA send path
X-Lms-Return-Path: <lba+26aeb55e5+95f7d8+vger.kernel.org+tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:25 +0800
Message-Id: <20261104155723.37053-15-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

Implement the work request post and send path.

post_send validates the opcode, work queue headroom, SGE count (RDMA
reads are limited to a single SGE) and the drain gate, then writes
the WQE under the send queue lock.  RC queues build send, immediate,
write and remote-read WQEs and record the slot metadata the poll
loop needs; unsupported opcodes such as local invalidate and the
register-MR work requests are rejected.  Since the hardware rejects
zero-length RDMA reads, such a request is issued as a write and the
poll loop restores the read opcode on completion.

For QP1 and UD traffic the path packs a complete RoCEv2 header
(ethernet, IPv4 or IPv6, UDP, BTH, DETH) into a per-QP DMA header
slot, computes the ICRC over masked pseudo-headers and payload, and
posts a single SGE referencing the header.  The MAD payload is
copied into the header buffer through a DMA-to-CPU translation
helper, which fails when the IOMMU state makes CPU access to DMA
addresses impossible; the same helper failure makes QP1 receive
handling report a local access error.

Add the drain helpers the core uses on destruction: move the QP to
error, post tagged drain work requests and wait for their
completions, polling directly for direct-poll CQs and using the
completion callback otherwise.

The shared BTH and DETH header structs are renamed from the rxe
prefix to an xsc prefix to avoid colliding with the soft-RoCE module
on the include path.

The message-opcode map and the software CRC32 table are now built at
probe time since the send path is their first user.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/cq.c                |  36 +-
 drivers/infiniband/hw/xsc/main.c              |  22 +-
 drivers/infiniband/hw/xsc/qp.c                | 732 +++++++++++++++++-
 drivers/infiniband/hw/xsc/xsc_ib.h            | 144 ++--
 .../ethernet/yunsilicon/xsc/common/driver.h   |   4 +-
 5 files changed, 815 insertions(+), 123 deletions(-)

diff --git a/drivers/infiniband/hw/xsc/cq.c b/drivers/infiniband/hw/xsc/cq.c
index 36d122f8d..a5ab8d00d 100644
--- a/drivers/infiniband/hw/xsc/cq.c
+++ b/drivers/infiniband/hw/xsc/cq.c
@@ -143,11 +143,11 @@ static void *get_seg_wqe(void *first, int n)
 	return first + (n << XSC_BASE_WQE_SHIFT);
 }
 
-static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
-					  struct xsc_ib_qp **cur_qp,
-					  struct ib_wc *wc,
-					  struct xsc_cqe *cqe,
-					  u8 opcode)
+static int xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
+					 struct xsc_ib_qp **cur_qp,
+					 struct ib_wc *wc,
+					 struct xsc_cqe *cqe,
+					 u8 opcode)
 {
 	struct xsc_ib_dev *dev = to_xdev(cq->ibcq.device);
 	void *recv;
@@ -159,8 +159,8 @@ static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
 	struct ib_unpacked_vlan *vlan;
 	struct ib_grh *grh;
 	struct ib_mad *mad;
-	struct rxe_bth *bth;
-	struct rxe_deth *deth;
+	struct xsc_bth *bth;
+	struct xsc_deth *deth;
 	unsigned int pading_sz = 0;
 	struct xsc_ib_wq *wq;
 	int idx;
@@ -173,7 +173,13 @@ static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
 	handle_responder(wc, cqe, *cur_qp, opcode);
 
 	data_seg = get_seg_wqe(get_recv_wqe(*cur_qp, idx), 0);
-	recv = xsc_ib_recv_mad_sg_virt_addr(&dev->ib_dev, wc, data_seg->va);
+	recv = xsc_ib_mad_sg_virt_addr(&dev->ib_dev, data_seg->va);
+	if (unlikely(!recv)) {
+		ibdev_err(&dev->ib_dev,
+			  "cannot map the MAD receive buffer to a virtual address\n");
+		wc->status = IB_WC_LOC_ACCESS_ERR;
+		return -EOPNOTSUPP;
+	}
 
 	eth = (struct ib_unpacked_eth *)recv;
 	grh = (struct ib_grh *)recv;
@@ -197,8 +203,8 @@ static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
 		ip6h = (struct ipv6hdr *)l3_start;
 		udph = (struct udphdr *)(ip6h + 1);
 	}
-	bth = (struct rxe_bth *)(udph + 1);
-	deth = (struct rxe_deth *)(bth + 1);
+	bth = (struct xsc_bth *)(udph + 1);
+	deth = (struct xsc_deth *)(bth + 1);
 	mad = (struct ib_mad *)(deth + 1);
 
 	if (eth_type == ETH_P_IP) {
@@ -216,6 +222,8 @@ static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
 	ibdev_dbg(&dev->ib_dev, "qp[%d] recv MAD packet, msg_len=%d\n",
 		  (*cur_qp)->xqp.qpn, wc->byte_len);
 	wc->status = IB_WC_SUCCESS;
+
+	return 0;
 }
 
 static void xsc_generate_lost_cqe(struct xsc_ib_dev *dev, struct xsc_ib_wq *wq,
@@ -303,6 +311,10 @@ static int xsc_poll_one(struct xsc_ib_cq *cq,
 			break;
 		}
 		wq->last_comp_ce_wqe = idx;
+		if (wq->zero_length_read[idx]) {
+			opcode = XSC_OPCODE_RDMA_REQ_READ;
+			wq->zero_length_read[idx] = 0;
+		}
 		handle_good_req(wc, cqe, opcode);
 		wc->wr_id = wq->wrid[idx];
 		wq->tail = wq->wqe_head[idx] + 1;
@@ -331,7 +343,8 @@ static int xsc_poll_one(struct xsc_ib_cq *cq,
 
 	case XSC_OPCODE_RDMA_MAD_RSP_RECV:
 		ibdev_dbg(&dev->ib_dev, "recv MAD, qpn:%u\n", qpn);
-		xsc_handle_rdma_mad_resp_recv(cq, cur_qp, wc, cqe, opcode);
+		if (xsc_handle_rdma_mad_resp_recv(cq, cur_qp, wc, cqe, opcode))
+			wc->status = IB_WC_LOC_ACCESS_ERR;
 		break;
 
 	case XSC_OPCODE_RDMA_REQ_ERROR:
@@ -372,6 +385,7 @@ static int xsc_poll_one(struct xsc_ib_cq *cq,
 		if (wq->need_flush[idx])
 			atomic_dec(&wq->flush_wqe_cnt);
 		wq->need_flush[idx] = 0;
+		wq->zero_length_read[idx] = 0;
 		ibdev_err(&dev->ib_dev, "req error\n%08x %08x %08x %08x %08x %08x\n",
 			  p[0], p[1], p[2], p[3], p[5], p[6]);
 		wc->status = IB_WC_GENERAL_ERR;
diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index 138ca1a80..057468798 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -474,6 +474,22 @@ static int init_node_data(struct xsc_ib_dev *dev)
 	return 0;
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
@@ -521,6 +537,7 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 	dev->ib_dev.ops.modify_qp		= xsc_ib_modify_qp;
 	dev->ib_dev.ops.query_qp		= xsc_ib_query_qp;
 	dev->ib_dev.ops.destroy_qp		= xsc_ib_destroy_qp;
+	dev->ib_dev.ops.post_send		= xsc_ib_post_send;
 	dev->ib_dev.ops.post_recv		= xsc_ib_post_recv;
 	dev->ib_dev.ops.create_cq		= xsc_ib_create_cq;
 	dev->ib_dev.ops.destroy_cq		= xsc_ib_destroy_cq;
@@ -533,6 +550,8 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 
 	dev->ib_dev.ops.get_port_immutable		= xsc_port_immutable;
 
+	dev->ib_dev.ops.drain_sq		= xsc_ib_drain_sq;
+	dev->ib_dev.ops.drain_rq		= xsc_ib_drain_rq;
 	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
 	dev->ib_dev.ops.create_srq		= xsc_ib_create_srq;
 	dev->ib_dev.ops.destroy_srq		= xsc_ib_destroy_srq;
@@ -678,6 +697,8 @@ static int init_one(struct xsc_core_device *xdev,
 	if (err)
 		goto err_free;
 
+	crc_table_init(dev);
+	build_opcode_map(dev);
 	err = xsc_reg_local_dma_mr(xdev);
 	if (err)
 		goto err_free;
@@ -688,7 +709,6 @@ static int init_one(struct xsc_core_device *xdev,
 	if (err)
 		goto err_free;
 
-	rdma_roce_rescan_device(&dev->ib_dev);
 	dev->ib_active = true;
 	*ibdev = dev;
 
diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/qp.c
index 0dfb10294..46ca3dd95 100644
--- a/drivers/infiniband/hw/xsc/qp.c
+++ b/drivers/infiniband/hw/xsc/qp.c
@@ -11,13 +11,10 @@
 #include <rdma/xsc-abi.h>
 #include "common/xsc_hsi.h"
 #include <linux/crc32.h>
+#include <linux/unaligned.h>
 #include <linux/dma-direct.h>
 #include <rdma/ib_addr.h>
 
-#ifndef ETH_P_IBOE
-#define ETH_P_IBOE	0x8915
-#endif
-
 #define MAD_QUEUE_DEPTH        128
 
 enum {
@@ -29,6 +26,23 @@ enum {
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
@@ -59,6 +73,83 @@ static void *get_seg_wqe(void *first, int n)
 	return first + (n << XSC_BASE_WQE_SHIFT);
 }
 
+void *xsc_get_send_wqe(struct xsc_ib_qp *qp, int n)
+{
+	return get_wqe(qp, qp->sq.offset + (n << qp->sq.wqe_shift));
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
+static int set_data_inl_seg(struct xsc_ib_qp *qp, const struct ib_send_wr *wr, void *ctrl,
+			    unsigned int seg_index, unsigned int *num_segs)
+{
+	unsigned int ds_len = sizeof(struct xsc_wqe_data_seg);
+	unsigned int segs_per_wqe;
+	unsigned int offset = 0;
+	size_t total_len = 0;
+	struct xsc_wqe_data_seg *data_seg;
+	void *addr;
+	int len;
+	int i;
+
+	segs_per_wqe = XSC_SEND_SEG_NUM << (qp->sq.wqe_shift - XSC_SEND_WQE_SHIFT);
+
+	for (i = 0; i < wr->num_sge; ++i)
+		total_len += wr->sg_list[i].length;
+
+	/* max_inline_data is the byte budget of the whole WQE, not of a SGE */
+	if (total_len > qp->max_inline_data)
+		return -ENOMEM;
+
+	/* bound the payload segments by the WQE slot before any memcpy lands */
+	if (seg_index + DIV_ROUND_UP(total_len, ds_len) > segs_per_wqe)
+		return -ENOMEM;
+
+	for (i = 0; i < wr->num_sge; ++i) {
+		addr = (void *)(unsigned long)wr->sg_list[i].addr;
+		len  = wr->sg_list[i].length;
+
+		while (len) {
+			unsigned int copy_len;
+
+			if (!offset) {
+				data_seg = get_seg_wqe(ctrl, seg_index);
+				seg_index++;
+			}
+			copy_len = min_t(unsigned int, len, ds_len - offset);
+			memcpy((char *)data_seg + offset, addr, copy_len);
+			offset = (offset + copy_len) % ds_len;
+			addr += copy_len;
+			len -= copy_len;
+		}
+	}
+
+	*num_segs = seg_index;
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
@@ -308,7 +399,6 @@ static int create_user_qp(struct xsc_ib_dev *dev, struct ib_pd *pd,
 	xsc_ib_cont_pages(qp->umem, ucmd->buf_addr, &npages, &page_shift,
 			  &ncont);
 	if (ncont != npages) {
-		/* TODO: peer memory support failed */
 		page_shift = PAGE_SHIFT;
 		ncont = npages;
 	}
@@ -419,12 +509,15 @@ static int create_kernel_qp(struct xsc_ib_dev *dev,
 	qp->sq.wqe_head = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.wqe_head), GFP_KERNEL);
 	qp->sq.wr_opcode = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.wr_opcode), GFP_KERNEL);
 	qp->sq.need_flush = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.need_flush), GFP_KERNEL);
+	qp->sq.zero_length_read = kcalloc(qp->sq.wqe_cnt,
+					  sizeof(*qp->sq.zero_length_read), GFP_KERNEL);
 	qp->sq.prev_ce_wqe = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.prev_ce_wqe), GFP_KERNEL);
 	qp->sq.last_comp_ce_wqe = -1;
 	qp->sq.last_post_ce_wqe = -1;
 
 	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid || !qp->sq.prev_ce_wqe ||
-	    !qp->sq.w_list || !qp->sq.wqe_head || !qp->sq.wr_opcode || !qp->sq.need_flush) {
+	    !qp->sq.w_list || !qp->sq.wqe_head || !qp->sq.wr_opcode || !qp->sq.need_flush ||
+	    !qp->sq.zero_length_read) {
 		err = -ENOMEM;
 		goto err_wrid;
 	}
@@ -450,6 +543,7 @@ static int create_kernel_qp(struct xsc_ib_dev *dev,
 err_wrid:
 	xsc_vfree(*in);
 	*in = NULL;
+	kfree(qp->sq.zero_length_read);
 	kfree(qp->sq.prev_ce_wqe);
 	kfree(qp->sq.need_flush);
 	kfree(qp->sq.wr_opcode);
@@ -471,6 +565,7 @@ static void destroy_qp_kernel(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp)
 				  qp->sq.hdr_buf, qp->sq.hdr_dma);
 	kfree(qp->sq.prev_ce_wqe);
 	kfree(qp->sq.need_flush);
+	kfree(qp->sq.zero_length_read);
 	kfree(qp->sq.wr_opcode);
 	kfree(qp->sq.wqe_head);
 	kfree(qp->sq.w_list);
@@ -1437,13 +1532,538 @@ static int xsc_wq_overflow(struct xsc_ib_wq *wq, int nreq)
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
+static int xsc_icrc_hdr(struct xsc_ib_dev *dev, void *pkt, u32 size, u32 *icrc)
+{
+	struct iphdr *ip4h = NULL;
+	struct ipv6hdr *ip6h = NULL;
+	struct udphdr *udph;
+	struct ib_unpacked_eth *eth;
+	struct xsc_bth *bth;
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
+		sizeof(*bth) + sizeof(*deth)] __aligned(4);
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
 
-/* Routine for sending QP1 packets for RoCE V1 an V2 */
-/* TODO: sq hdr buf should be created dynamically for mult entry */
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
+	bth = (struct xsc_bth *)(udph + 1);
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
+	bth = (struct xsc_bth *)(udph + 1);
+	/* exclude bth.resv8a */
+	bth->qpn |= cpu_to_be32(~BTH_QPN_MASK);
+
+	*icrc = xsc_crc32(dev, crc, pshdr, crc_field_len);
+
+	return 0;
+}
+
+/* Routine for sending QP1 packets for RoCE V2 */
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
+	bool is_eth = false;
+	bool is_vlan = false;
+	u8 ip_version = 0;
+	u16 vlan_id = 0xFFFF;
+	int rc = 0;
+	int cm_pcp = 0;
+	void *hdr_buf;
+	struct net_device *ndev;
+
+	memset(&qp->qp1_hdr, 0, sizeof(qp->qp1_hdr));
+
+	if (!qp->sq.hdr_buf) {
+		ibdev_err(&dev->ib_dev, "QP1 buffer is empty!");
+		return -ENOMEM;
+	}
+	hdr_buf = (u8 *)qp->sq.hdr_buf + MAX_QP1_SQ_HDR_SIZE_V2 * qp->sq.mad_index;
+
+	if (!sgid_attr) {
+		ibdev_err(&dev->ib_dev, "sgid_addr is null\n");
+		return -ENXIO;
+	}
+
+	if (sgid_attr->gid_type != IB_GID_TYPE_ROCE_UDP_ENCAP) {
+		ibdev_err(&dev->ib_dev, "RoCEv1 GID type not supported\n");
+		return -EINVAL;
+	}
+
+	rc = rdma_read_gid_l2_fields(sgid_attr, &vlan_id, NULL);
+	if (rc)
+		return rc;
+
+	if (ipv6_addr_v4mapped((struct in6_addr *)&sgid_attr->gid)) {
+		ip_version = 4;
+		ether_type = ETH_P_IP;
+	} else {
+		ip_version = 6;
+		ether_type = ETH_P_IPV6;
+	}
+
+	is_eth = true;
+	is_vlan = (vlan_id && (vlan_id < 0x1000)) ? true : false;
+
+	ib_ud_header_init(payload_size, !is_eth, is_eth, is_vlan, false,
+			  ip_version, true, 0, &qp->qp1_hdr);
+
+	/* ETH */
+	ether_addr_copy(qp->qp1_hdr.eth.dmac_h, ah->av.rmac);
+	ndev = ib_device_get_netdev(&dev->ib_dev, qp->port);
+	if (!ndev) {
+		ibdev_err(&dev->ib_dev, "no netdev for port %u\n", qp->port);
+		return -ENODEV;
+	}
+	ether_addr_copy(qp->qp1_hdr.eth.smac_h, ndev->dev_addr);
+	dev_put(ndev);
+
+	/* For vlan, check the sgid for vlan existence */
+	if (!is_vlan) {
+		qp->qp1_hdr.eth.type = cpu_to_be16(ether_type);
+	} else {
+		if (dev->xdev->priv.cm_pcp != XSC_DSCP_PCP_UNSET)
+			cm_pcp = dev->xdev->priv.cm_pcp << 13;
+		else
+			cm_pcp = ((ah->av.stat_rate_sl >> 1) & 0x7) << 13;
+		qp->qp1_hdr.vlan.type = cpu_to_be16(ether_type);
+		qp->qp1_hdr.vlan.tag = cpu_to_be16(vlan_id | cm_pcp);
+	}
+
+#define ECN_CAPABLE_TRANSPORT 0x2
+	if (ip_version == 6) {
+		memcpy(qp->qp1_hdr.grh.source_gid.raw, sgid_attr->gid.raw,
+		       sizeof(sgid_attr->gid));
+		memcpy(qp->qp1_hdr.grh.destination_gid.raw, ah->av.rgid,
+		       sizeof(ah->av.rgid));
+		qp->qp1_hdr.grh.hop_limit     = ah->av.hop_limit;
+
+		if (dev->xdev->priv.cm_dscp != XSC_DSCP_PCP_UNSET)
+			qp->qp1_hdr.grh.traffic_class =
+				(dev->xdev->priv.cm_dscp << 2) | ECN_CAPABLE_TRANSPORT;
+		else
+			qp->qp1_hdr.grh.traffic_class = ECN_CAPABLE_TRANSPORT;
+	}
+
+	if (ip_version == 4) {
+		if (dev->xdev->priv.cm_dscp != XSC_DSCP_PCP_UNSET)
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
+	qp->qp1_hdr.udp.dport = htons(dev->xdev->cm_udp_dst_port);
+	qp->qp1_hdr.udp.sport = htons(ah->av.udp_sport);
+	qp->qp1_hdr.udp.csum = 0;
+	ibdev_dbg(&dev->ib_dev, "CM packet used udp_sport=%d\n", ah->av.udp_sport);
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
+	if (ip_version == 4)
+		sge->length -= 20;
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
+		u32 ds_data_num = 0;
+		u32 ctrl_val = 0;
+		bool ce;
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
+		if (unlikely(xsc_wq_overflow(&qp->sq, nreq))) {
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
+		ctrl->data0 &= cpu_to_le32(XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK);
+		ce = (wr->send_flags & IB_SEND_SIGNALED) ||
+		     (qp->sq_signal_bits & XSC_WQE_CTRL_CQ_UPDATE);
+		for (i = 0; i < wr->num_sge; ++i) {
+			if (likely(wr->sg_list[i].length))
+				msg_len += wr->sg_list[i].length;
+		}
+		ctrl->msg_len = msg_len;
+
+		switch (ibqp->qp_type) {
+		case IB_QPT_RC:
+			ds_data_num = wr->num_sge;
+			switch (wr->opcode) {
+			case IB_WR_SEND:
+				break;
+			case IB_WR_SEND_WITH_IMM:
+				ctrl_val |= XSC_WQE_CTRL_SEG_DATA0_WITH_IMM;
+				WR_LE_32(ctrl->data2, RD_BE_32(send_ieth(wr)));
+				break;
+			case IB_WR_RDMA_WRITE_WITH_IMM:
+				ctrl_val |= XSC_WQE_CTRL_SEG_DATA0_WITH_IMM;
+				WR_LE_32(ctrl->data2, RD_BE_32(send_ieth(wr)));
+				fallthrough;
+			case IB_WR_RDMA_READ:
+			case IB_WR_RDMA_WRITE:
+				if (msg_len == 0)
+					break;
+				ds_data_num++;
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
+			if (unlikely(wr->opcode == IB_WR_RDMA_READ && msg_len == 0)) {
+				ibdev_dbg(&dev->ib_dev, "post zero-length read wr\n");
+				/* HW rejects zero-length reads; poll backfills the
+				 * READ opcode from qp->sq.zero_length_read[]
+				 */
+				ctrl_val |= FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
+						       dev->opcode_map[IB_WR_RDMA_WRITE]);
+				qp->sq.zero_length_read[idx] = 1;
+			} else {
+				ctrl_val |= FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
+						       dev->opcode_map[wr->opcode]);
+			}
+			break;
+		case IB_QPT_UD:
+		case IB_QPT_GSI:
+			ctrl_val |= FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
+					       xsc_ib_opcode->mad);
+			ds_data_num++;
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
+					vaddr = xsc_ib_mad_sg_virt_addr(&dev->ib_dev,
+									wr->sg_list[i].addr);
+					if (unlikely(!vaddr)) {
+						ibdev_err(&dev->ib_dev,
+							  "cannot map MAD sg entry %d to a virtual address\n",
+							  i);
+						err = -EOPNOTSUPP;
+						*bad_wr = wr;
+						goto out;
+					}
+					memcpy(cur_p, vaddr, wr->sg_list[i].length);
+				}
+				cur_p += wr->sg_list[i].length;
+			}
+			crc = xsc_crc32(dev, crc, mad_send_base + sg.length, ctrl->msg_len);
+			ctrl->msg_len += sg.length;
+			seg_index++;
+
+			put_unaligned(~crc, (u32 *)&mad_send_base[ctrl->msg_len]);
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
+		ctrl_val |= FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_DS_DATA_NUM_MASK, ds_data_num);
+		ctrl->data0 |= cpu_to_le32(ctrl_val);
+		ctrl->data3 = cpu_to_le32((wr->send_flags & IB_SEND_SOLICITED ?
+					   XSC_WQE_CTRL_SEG_DATA3_SE : 0) |
+					  (ce ? XSC_WQE_CTRL_SEG_DATA3_CE : 0));
+
+		if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
+			unsigned int segs_used;
+
+			err = set_data_inl_seg(qp, wr, ctrl, seg_index, &segs_used);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				ibdev_err(&dev->ib_dev, "inline layout failed, err %d\n", err);
+				goto out;
+			}
+			ds_data_num = segs_used - 1;
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
+		if (ce) {
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
@@ -1628,6 +2248,100 @@ int xsc_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_
 struct xsc_ib_drain_cqe {
 	struct ib_cqe cqe;
 	struct completion done;
-	int qpn;
 };
 
+static void xsc_ib_drain_rq_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct xsc_ib_drain_cqe *cqe = container_of(wc->wr_cqe,
+						     struct xsc_ib_drain_cqe, cqe);
+
+	complete(&cqe->done);
+}
+
+static void xsc_ib_drain_sq_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct xsc_ib_drain_cqe *cqe = container_of(wc->wr_cqe,
+						     struct xsc_ib_drain_cqe, cqe);
+
+	complete(&cqe->done);
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
+	if (cq->poll_ctx == IB_POLL_DIRECT)
+		while (wait_for_completion_timeout(&rdrain.done, HZ / 10) <= 0)
+			ib_process_cq_direct(cq, -1);
+	else
+		xcq->xcq.comp(&xcq->xcq);
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
+	if (cq->poll_ctx == IB_POLL_DIRECT)
+		while (wait_for_completion_timeout(&sdrain.done, HZ / 10) <= 0)
+			ib_process_cq_direct(cq, -1);
+	else
+		xcq->xcq.comp(&xcq->xcq);
+	wait_for_completion(&sdrain.done);
+}
diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/xsc/xsc_ib.h
index 126fcf789..fe111b2c6 100644
--- a/drivers/infiniband/hw/xsc/xsc_ib.h
+++ b/drivers/infiniband/hw/xsc/xsc_ib.h
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <rdma/ib_verbs.h>
-#include <rdma/ib_smi.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_mad.h>
 #include "common/xsc_core.h"
@@ -22,7 +21,6 @@
 #include <linux/iommu.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-mapping.h>
-#include <crypto/hash.h>
 #include <rdma/uverbs_ioctl.h>
 
 #define	XSC_PAGE_SHIFT_4K	12
@@ -82,6 +80,7 @@ struct xsc_ib_wq {
 	u32			*wr_opcode;
 	u32			*need_flush;
 	atomic_t	flush_wqe_cnt;
+	u8			*zero_length_read;
 	int			*prev_ce_wqe;
 	int			last_comp_ce_wqe;
 	int			last_post_ce_wqe;
@@ -211,13 +210,17 @@ struct xsc_ib_mr {
 	u32			npages;
 };
 
+#define MAX_OPCODE	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD
+
 struct xsc_ib_dev {
 	struct ib_device		ib_dev;
 	struct xsc_core_device *xdev;
 	int				num_ports;
 	int				num_comp_vectors;
 	u8				ib_active;
+	u32				crc_32_table[256];
 	int iommu_state;
+	u32				opcode_map[MAX_OPCODE + 1];
 };
 
 struct xsc_err_state_qp_node {
@@ -289,6 +292,8 @@ static inline struct xsc_ib_srq *core_to_xsrq(struct xsc_core_srq *xsrq)
 	return container_of(xsrq, struct xsc_ib_srq, xsrq);
 }
 
+void build_opcode_map(struct xsc_ib_dev *dev);
+
 int xsc_ib_create_ah(struct ib_ah *ibah,
 		     struct rdma_ah_init_attr *init_attr,
 		     struct ib_udata *udata);
@@ -402,6 +407,23 @@ static inline enum ib_mtu xsc_net_to_ib_mtu(unsigned int mtu)
 		return 0;
 }
 
+/*
+ * MMIO doorbells and MAD payloads are accessed by the CPU, so the driver
+ * needs the kernel virtual address behind a DMA address.  There is no such
+ * conversion API, so the address space is classified once at probe time and
+ * the matching trick is used:
+ *
+ *   NORMAL  - an IOMMU DMA domain is attached; iova_to_phys() is available.
+ *   DISABLE - no IOMMU translation, DMA address == physical address.
+ *   UNKNOWN - address translation exists but is not owned by the IOMMU
+ *             layer (forced software bounce buffering, or a hypervisor that
+ *             translates DMA addresses), so neither trick works.
+ *
+ * UNKNOWN is not supported: MAD and doorbell traffic cannot be addressed by
+ * the CPU there, and QP1 (SMI/GSI) creation is refused as a result, which
+ * disables SA/CM on such a system.  Systems with an IOMMU or without any
+ * translation are unaffected.
+ */
 #define XSC_IB_IOMMU_MAP_DISABLE 0
 #define XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN 1
 #define XSC_IB_IOMMU_MAP_NORMAL 2
@@ -417,114 +439,36 @@ static inline void *xsc_ib_iova_to_virt(struct ib_device *ibdev, dma_addr_t iova
 	struct iommu_domain *domain;
 
 	domain = iommu_get_domain_for_dev(ibdev->dma_device);
-	if (likely(domain)) {
-		phyaddr = iommu_iova_to_phys(domain, iova);
-		phyaddr |= iova & (PAGE_SIZE - 1);
-	} else {
-		phyaddr = dma_to_phys(ibdev->dma_device, iova);
-	}
+	if (unlikely(!domain))
+		return NULL;
+
+	phyaddr = iommu_iova_to_phys(domain, iova);
+	if (unlikely(!phyaddr))
+		return NULL;
+	phyaddr |= iova & (PAGE_SIZE - 1);
 
 	return phys_to_virt(phyaddr);
 }
 
-struct ib_mad_list_head {
-	struct list_head list;
-	struct ib_cqe cqe;
-	struct ib_mad_queue *mad_queue;
-};
-
-#define IB_MAD_SEND_REQ_MAX_SG 2
-struct ib_mad_send_wr_private {
-	struct ib_mad_list_head mad_list;
-	struct list_head agent_list;
-	struct ib_mad_agent_private *mad_agent_priv;
-	struct ib_mad_send_buf send_buf;
-	u64 header_mapping;
-	u64 payload_mapping;
-	struct ib_ud_wr send_wr;
-	struct ib_sge sg_list[IB_MAD_SEND_REQ_MAX_SG];
-	__be64 tid;
-	unsigned long timeout;
-	int max_retries;
-	int retries_left;
-	int retry;
-	int refcount;
-	enum ib_wc_status status;
-
-	/* RMPP control */
-	struct list_head rmpp_list;
-	struct ib_rmpp_segment *last_ack_seg;
-	struct ib_rmpp_segment *cur_seg;
-	int last_ack;
-	int seg_num;
-	int newwin;
-	int pad;
-};
-
-struct ib_mad_private_header {
-	struct ib_mad_list_head mad_list;
-	struct ib_mad_recv_wc recv_wc;
-	struct ib_wc wc;
-	u64 mapping;
-} __packed;
-
-struct ib_mad_private {
-	struct ib_mad_private_header header;
-	size_t mad_size;
-	struct ib_grh grh;
-	DECLARE_FLEX_ARRAY(u8, mad);
-} __packed;
-
-static inline void *xsc_ib_send_mad_sg_virt_addr(struct ib_device *ibdev,
-						 const struct ib_send_wr *wr,
-						 int sg)
+/*
+ * Translate the DMA address of a MAD scatter/gather entry to a kernel
+ * virtual address so that the payload can be copied to or from the WQE.
+ * Returns NULL when the address cannot be translated, which happens only
+ * for XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN (see above) or when the IOMMU has no
+ * mapping for the address.
+ */
+static inline void *xsc_ib_mad_sg_virt_addr(struct ib_device *ibdev,
+					    dma_addr_t dma_addr)
 {
-	struct ib_mad_send_wr_private *mad_send_wr;
-	struct ib_mad_list_head *mad_list;
 	int iommu_state = xsc_ib_iommu_dma_map(ibdev);
 
-	/* direct dma mapping */
-	if (!iommu_state)
-		return phys_to_virt(dma_to_phys(ibdev->dma_device, wr->sg_list[sg].addr));
-
 	if (iommu_state == XSC_IB_IOMMU_MAP_NORMAL)
-		return xsc_ib_iova_to_virt(ibdev, wr->sg_list[sg].addr);
-
-	mad_list = container_of(wr->wr_cqe, struct ib_mad_list_head, cqe);
-	mad_send_wr = container_of(mad_list, struct ib_mad_send_wr_private,
-				   mad_list);
-
-	/* sg_list[0] */
-	if (sg == 0)
-		return mad_send_wr->send_buf.mad;
-
-	/* sg_list[1] */
-	if (mad_send_wr->send_buf.seg_count)
-		return ib_get_rmpp_segment(&mad_send_wr->send_buf,
-					   mad_send_wr->seg_num);
-	return mad_send_wr->send_buf.mad + mad_send_wr->send_buf.hdr_len;
-}
+		return xsc_ib_iova_to_virt(ibdev, dma_addr);
 
-static inline void *xsc_ib_recv_mad_sg_virt_addr(struct ib_device *ibdev,
-						 struct ib_wc *wc,
-						 u64 sg_addr)
-{
-	struct ib_mad_private_header *mad_priv_hdr;
-	struct ib_mad_private *recv;
-	struct ib_mad_list_head *mad_list;
-	int iommu_state = xsc_ib_iommu_dma_map(ibdev);
-
-	/* direct dma mapping */
-	if (!iommu_state)
-		return phys_to_virt(dma_to_phys(ibdev->dma_device, sg_addr));
-
-	if (iommu_state == XSC_IB_IOMMU_MAP_NORMAL)
-		return xsc_ib_iova_to_virt(ibdev, sg_addr);
+	if (iommu_state == XSC_IB_IOMMU_MAP_DISABLE)
+		return phys_to_virt(dma_to_phys(ibdev->dma_device, dma_addr));
 
-	mad_list = container_of(wc->wr_cqe, struct ib_mad_list_head, cqe);
-	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header, mad_list);
-	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
-	return &recv->grh;
+	return NULL;
 }
 
 struct xsc_ib_burst_info {
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/driver.h b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
index 0c91574d6..d58d75fb3 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
@@ -22,7 +22,7 @@
 #include "common/xsc_hsi.h"
 #include "common/srq.h"
 
-struct rxe_bth {
+struct xsc_bth {
 	u8			opcode;
 	u8			flags;
 	__be16			pkey;
@@ -30,7 +30,7 @@ struct rxe_bth {
 	__be32			apsn;
 };
 
-struct rxe_deth {
+struct xsc_deth {
 	__be32			qkey;
 	__be32			src_qp;
 };
-- 
2.18.4
