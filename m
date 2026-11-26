Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.59
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705072;
	b=e7VuE/BKrJkzCEa+vZPmEWLPpE/zHaBQNlekeRl8QRbL3eMYQBxBoNclutA4h0zHHBH6
	 DPAexLoFzSj/oOAh3gkJvjVy7UtYCOIYDo+91kgrcfkhZghRh+0HIhJ9pu1l0tGD/YxDg
	 uD2unRobuLdWBpaGpV0CNql91O6wph46ZhzDX/bffs4wQXpWPQ/3OTAPVU06t9lcr1Wnj
	 QNj6V9QZp4hVlCM34gB6l5YRhWlVL4EtsT173Xrpg747bStrvSGDi/I5lvuzTvTP2jGI7
	 N8Z4/9bU24YZQZ1VJj5qJDpIj1xZ47LDw1rXBo6OOfr63B++5d30az5R9qE4I/V/rNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705072;
	h=DMARC-Filter:DKIM-Signature:Cc:From:Content-Type:To:X-Original-From:
	 Mime-Version:X-Lms-Return-Path:References:Received:
	 Content-Transfer-Encoding:Date:Message-Id:X-Mailer:In-Reply-To:
	 Subject;
	bh=8MNItBQKsCSCEGU2GmXLWwEBwciN6UfmKmEuqXLq/3g=;
	b=d1DaCDLlmSoUVR5GQedHBiWdVn/AFlYSqxYDRi/CIcwXLzX1b6pLahTWyiJ8KS2kyfzx
	 NfbLAHy13a1q03HIT6XSIW4PNFarDSUWzrAWo8FrH+CFaUFX3sFvp488NPomgYegZlw+m
	 CJfXiaUyPa3iD9A1z3aofaUpwjX7b0nkeh0WAlHfxGHyX5f5wOlwMF3CfrC8T9fI1hdC+
	 MgkAo+EJ7yt3DbSXJ6FFbBybRYf4VgW/+SIR4rfkBt9F05JY17BW89hQrM16LzZA7pV4D
	 vEpScg4TR6IyVp2Ii0Bm0v4TqGjmRe9E5J9uVGIHZoMLW5YKp5Wl9L/zNHmGr2EeMvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=NvgXNg9J;
	arc=none smtp.remote-ip=209.127.231.59
Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78562606A69B
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78562606A69B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=NvgXNg9J
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705066; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=8MNItBQKsCSCEGU2GmXLWwEBwciN6UfmKmEuqXLq/3g=;
 b=NvgXNg9JNz3fD9IwvJep7AbgXd4R6yq3LqU7bSuuSOgaKfkRHs1IxuUH0DN3b7gdI8vqPZ
 bVZ8Uz4IN5OWS6KzX+b/n/Euvc3s+/tMFKqSKW0g9nI4fSwesc8UY255xuZ5c1WS6yKg7e
 +fXrTHbaeWLBmA3wjoeI/4Xak/OXaraT2mUVga9Y/qwtz2dN5+CqElCNdUXiQ7k2kQfd93
 mjjb9lSDwgDE60/UyxrM+HAmoK+2AhMRxq4qCE2U6Btz8FeFq60w+JKgNbsSoyR1yRuDpE
 EdhyKWAEcDz6xbjPN3TxUKGTZOqGecWwU/B7r4l1mp4rrH0jczQtln9O+1f6Mg==
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26b0848e9+d71316+vger.kernel.org+tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:44 +0800
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Nov 2026 22:57:44 +0800
Message-Id: <20261126145742.70868-12-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
Subject: [PATCH v2 11/11] net/xsc: add the receive path

Receive linear skbs from the completion queue with a page pool and
handle both queue completions from a single NAPI poll.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |   4 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/net/main.c    |  30 +++
 .../yunsilicon/xsc/net/xsc_eth_common.h       |   1 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_rx.c  | 210 ++++++++++++++++++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         |  25 +++
 .../yunsilicon/xsc/net/xsc_eth_txrx.h         |   9 +
 .../ethernet/yunsilicon/xsc/net/xsc_queue.h   |   2 +-
 8 files changed, 281 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 872080d09..238bab4ec 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -134,6 +134,10 @@ struct xsc_cqe {
 	__le32		data1;
 };
 
+#define XSC_CQE_DATA0_MSG_OPCD_MASK		GENMASK(7, 0)
+#define XSC_CQE_DATA0_ERR_CODE_MASK		GENMASK(6, 0)
+#define XSC_CQE_DATA0_IS_ERR			BIT(7)
+#define XSC_CQE_DATA0_QP_ID_MASK		GENMASK(22, 8)
 #define XSC_CQE_DATA1_OWNER			BIT(31)
 
 /* eq */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
index ffb819884..ce2fffd48 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc_eth.o
 
-xsc_eth-y := main.o xsc_eth_wq.o xsc_eth_txrx.o xsc_eth_tx.o
+xsc_eth-y := main.o xsc_eth_wq.o xsc_eth_txrx.o xsc_eth_tx.o xsc_eth_rx.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
index 8eda3c8b1..e7b0871c1 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -106,6 +106,13 @@ static void xsc_eth_cq_error_event(struct xsc_core_cq *xcq,
 		   "Eth catch CQ ERROR: %x, cqn: %d\n", event, xcq->cqn);
 }
 
+static void xsc_eth_comp(struct xsc_core_cq *xcq)
+{
+	struct xsc_cq *cq = container_of(xcq, struct xsc_cq, xcq);
+
+	napi_schedule(cq->napi);
+}
+
 static int xsc_eth_alloc_cq(struct xsc_channel *c, struct xsc_cq *pcq,
 			    struct xsc_cq_param *pcq_param)
 {
@@ -125,6 +132,7 @@ static int xsc_eth_alloc_cq(struct xsc_channel *c, struct xsc_cq *pcq,
 	if (ret)
 		return ret;
 
+	core_cq->comp = xsc_eth_comp;
 	core_cq->event = xsc_eth_cq_error_event;
 	core_cq->vector = 0;
 
@@ -204,6 +212,7 @@ static int xsc_eth_open_cq(struct xsc_channel *c,
 
 	xsc_arm_cq(pcq->xdev, pcq->xcq.cqn, pcq->wq.cc, 0);
 
+	pcq->napi = &c->napi;
 	pcq->channel = c;
 
 	return 0;
@@ -448,6 +457,8 @@ static int xsc_eth_open_channel(struct xsc_adapter *adapter,
 	if (ret)
 		goto err_close_sq_cq;
 
+	netif_napi_add(adapter->netdev, &c->napi, xsc_eth_napi_poll);
+
 	netdev_dbg(adapter->netdev, "open channel ok\n");
 	return 0;
 
@@ -465,6 +476,8 @@ static int xsc_eth_modify_qps_channel(struct xsc_adapter *adapter,
 {
 	int ret;
 
+	xsc_eth_post_rx_wqes(&c->qp.rq);
+
 	ret = xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.rq.rqn,
 					    XSC_CMD_OP_RTR2RTS_QP);
 	if (ret)
@@ -612,6 +625,8 @@ static int xsc_eth_open_qp_rq(struct xsc_channel *c,
 static void xsc_eth_close_qp_rq(struct xsc_channel *c, struct xsc_rq *prq)
 {
 	struct xsc_core_device *xdev = c->adapter->xdev;
+	u32 wq_sz = xsc_wq_cyc_get_size(&prq->wqe.wq);
+	u32 i;
 
 	xsc_core_destroy_resource_common(xdev, &prq->cqp);
 
@@ -625,11 +640,17 @@ static void xsc_eth_close_qp_rq(struct xsc_channel *c, struct xsc_rq *prq)
 		return;
 	}
 
+	/* return the pages still posted to hardware before the pool dies */
+	for (i = 0; i < wq_sz; i++)
+		xsc_eth_dealloc_rx_wqe(prq, i);
+
 	xsc_eth_free_qp_rq(prq);
 }
 
 static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
 {
+	netif_napi_del(&c->napi);
+
 	if (free_rq)
 		xsc_eth_close_qp_rq(c, &c->qp.rq);
 	xsc_eth_close_cq(c, &c->qp.rq.cq);
@@ -644,6 +665,7 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
 {
 	struct xsc_channel_param *chl_param;
 	bool free_rq = false;
+	bool napi_enabled = false;
 	int ret = 0;
 
 	chl_param = kvzalloc_obj(*chl_param, GFP_KERNEL);
@@ -662,6 +684,9 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
 		goto err_close_channel;
 	free_rq = true;
 
+	napi_enable(&adapter->channel.napi);
+	napi_enabled = true;
+
 	ret = xsc_eth_modify_qps_channel(adapter, &adapter->channel);
 	if (ret)
 		goto err_close_channel;
@@ -670,6 +695,8 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
 	return 0;
 
 err_close_channel:
+	if (napi_enabled)
+		napi_disable(&adapter->channel.napi);
 	xsc_eth_close_channel(&adapter->channel, free_rq);
 err_free_param:
 	kvfree(chl_param);
@@ -702,6 +729,9 @@ static void xsc_eth_deactivate_channel(struct xsc_channel *c)
 	clear_bit(XSC_ETH_SQ_STATE_ENABLED, &c->qp.sq.state);
 
 	synchronize_net();
+
+	/* last doorbell out */
+	napi_disable(&c->napi);
 }
 
 static int xsc_eth_sw_init(struct xsc_adapter *adapter)
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
index a20ba7e62..1d03209cb 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_common.h
@@ -106,6 +106,7 @@ struct xsc_eth_params {
 struct xsc_channel {
 	/* data path */
 	struct xsc_eth_qp	qp;
+	struct napi_struct	napi;
 
 	/* relationship */
 	struct xsc_adapter	*adapter;
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
new file mode 100644
index 000000000..2c07f8092
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
+
+static void xsc_rq_notify_hw(struct xsc_rq *rq)
+{
+	struct xsc_core_device *xdev = rq->cq.xdev;
+
+	/* reverse wqe index to ds index */
+	xsc_update_rx_db(xdev, rq->rqn,
+			 rq->wqe.wq.wqe_ctr << ilog2(xdev->caps.recv_ds_num));
+}
+
+static struct sk_buff *xsc_skb_from_cqe(struct xsc_rq *rq,
+					struct xsc_dma_info *di,
+					u32 cqe_bcnt)
+{
+	struct sk_buff *skb;
+	void *va;
+	u32 frag_size;
+
+	va = page_address(di->page);
+	frag_size = XSC_SKB_FRAG_SZ(cqe_bcnt);
+
+	dma_sync_single_range_for_cpu(rq->cq.xdev->device, di->addr,
+				      0, frag_size, DMA_FROM_DEVICE);
+	net_prefetch(va + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+
+	skb = napi_build_skb(va, frag_size);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_put(skb, cqe_bcnt);
+	skb_mark_for_recycle(skb);
+
+	return skb;
+}
+
+static void xsc_dump_error_rqcqe(struct xsc_rq *rq, struct xsc_cqe *cqe)
+{
+	struct xsc_channel *c = rq->cq.channel;
+	u32 data0 = le32_to_cpu(cqe->data0);
+
+	net_err_ratelimited("Error cqe on dev=%s, cqn=%d, ci=%d, rqn=%d, qpn=%lu, error_code=0x%lx\n",
+			    c->netdev->name, rq->cq.xcq.cqn,
+			    xsc_cqwq_get_ci(&rq->cq.wq), rq->rqn,
+			    FIELD_GET(XSC_CQE_DATA0_QP_ID_MASK, data0),
+			    FIELD_GET(XSC_CQE_DATA0_ERR_CODE_MASK, data0));
+}
+
+void xsc_eth_handle_rx_cqe(struct xsc_rq *rq, struct xsc_cqe *cqe)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	struct xsc_dma_info *di;
+	struct sk_buff *skb;
+	u32 cqe_bcnt;
+	u16 ci;
+
+	ci = xsc_wq_cyc_ctr2ix(wq, rq->cq.wq.cc);
+	di = &rq->wqe.di[ci];
+
+	if (unlikely(le32_to_cpu(cqe->data0) & XSC_CQE_DATA0_IS_ERR)) {
+		xsc_dump_error_rqcqe(rq, cqe);
+		page_pool_recycle_direct(rq->page_pool, di->page);
+		di->page = NULL;
+		xsc_wq_cyc_pop(wq);
+		return;
+	}
+
+	cqe_bcnt = le32_to_cpu(cqe->msg_len);
+	skb = (cqe_bcnt >= ETH_HLEN && cqe_bcnt <= rq->frag_size) ?
+	      xsc_skb_from_cqe(rq, di, cqe_bcnt) : NULL;
+
+	if (skb) {
+		skb_record_rx_queue(skb, 0);
+		skb->protocol = eth_type_trans(skb, rq->cq.channel->netdev);
+
+		napi_gro_receive(rq->cq.napi, skb);
+	} else {
+		/* when the skb took the page, it recycles it via pp_recycle */
+		page_pool_recycle_direct(rq->page_pool, di->page);
+	}
+	di->page = NULL;
+
+	xsc_wq_cyc_pop(wq);
+}
+
+int xsc_poll_rx_cq(struct xsc_cq *cq, int budget)
+{
+	struct xsc_rq *rq = container_of(cq, struct xsc_rq, cq);
+	struct xsc_cqe *cqe;
+	int work_done = 0;
+
+	if (!test_bit(XSC_ETH_RQ_STATE_ENABLED, &rq->state))
+		return 0;
+
+	while (work_done < budget) {
+		cqe = xsc_cqwq_get_cqe(&cq->wq);
+		if (!cqe)
+			break;
+		/* ensure cqe content is read after cqe ownership bit */
+		dma_rmb();
+
+		xsc_eth_handle_rx_cqe(rq, cqe);
+		++work_done;
+
+		xsc_cqwq_pop(&cq->wq);
+	}
+
+	if (work_done)
+		xsc_cq_notify_hw(cq);
+
+	return work_done;
+}
+
+void xsc_eth_dealloc_rx_wqe(struct xsc_rq *rq, u16 ix)
+{
+	struct xsc_dma_info *di = &rq->wqe.di[ix];
+
+	if (!di->page)
+		return;
+
+	page_pool_recycle_direct(rq->page_pool, di->page);
+	di->page = NULL;
+}
+
+static int xsc_alloc_rx_wqes(struct xsc_rq *rq, u16 head, int bulk)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	struct xsc_dma_info *di;
+	struct xsc_eth_rx_wqe_cyc *wqe;
+	int i;
+
+	for (i = 0; i < bulk; i++) {
+		u16 ix = xsc_wq_cyc_ctr2ix(wq, head + i);
+
+		di = &rq->wqe.di[ix];
+		di->page = page_pool_dev_alloc_pages(rq->page_pool);
+		if (unlikely(!di->page)) {
+			while (--i >= 0)
+				xsc_eth_dealloc_rx_wqe(rq,
+						       xsc_wq_cyc_ctr2ix(wq, head + i));
+			return -ENOMEM;
+		}
+		di->addr = page_pool_get_dma_addr(di->page);
+
+		wqe = xsc_wq_cyc_get_wqe(wq, ix);
+		wqe->data[0].va = cpu_to_le64(di->addr);
+	}
+
+	return 0;
+}
+
+bool xsc_eth_post_rx_wqes(struct xsc_rq *rq)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	int alloc;
+	u16 head;
+
+	if (xsc_wq_cyc_missing(wq) < rq->wqe.wqe_bulk)
+		return false;
+
+	do {
+		head = xsc_wq_cyc_get_head(wq);
+		alloc = min_t(int, rq->wqe.wqe_bulk, xsc_wq_cyc_missing(wq));
+
+		if (xsc_alloc_rx_wqes(rq, head, alloc))
+			return true;
+
+		xsc_wq_cyc_push_n(wq, alloc);
+	} while (xsc_wq_cyc_missing(wq) >= rq->wqe.wqe_bulk);
+
+	dma_wmb();
+
+	/* ensure wqes are visible to device before updating doorbell record */
+	xsc_rq_notify_hw(rq);
+
+	return false;
+}
+
+int xsc_eth_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct xsc_channel *c = container_of(napi, struct xsc_channel, napi);
+	struct xsc_rq *rq = &c->qp.rq;
+	bool busy;
+	int work_done;
+
+	busy = xsc_poll_tx_cq(&c->qp.sq.cq, xsc_cqwq_get_size(&c->qp.sq.cq.wq));
+
+	work_done = xsc_poll_rx_cq(&rq->cq, budget);
+	busy |= work_done == budget;
+
+	if (xsc_eth_post_rx_wqes(rq))
+		busy = true;
+
+	if (busy)
+		return budget;
+
+	if (unlikely(!napi_complete_done(napi, work_done)))
+		return work_done;
+
+	xsc_cq_notify_hw_rearm(&c->qp.sq.cq);
+	xsc_cq_notify_hw_rearm(&rq->cq);
+
+	return work_done;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
index ee6554ed8..b3c926506 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
@@ -18,6 +18,28 @@ struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq)
 	return cqe;
 }
 
+void xsc_cq_notify_hw_rearm(struct xsc_cq *cq)
+{
+	xsc_arm_cq(cq->xdev, cq->xcq.cqn, cq->wq.cc, 0);
+}
+
+void xsc_cq_notify_hw(struct xsc_cq *cq)
+{
+	xsc_update_cq_ci(cq->xdev, cq->xcq.cqn, cq->wq.cc);
+}
+
+static void xsc_dump_error_sqcqe(struct xsc_sq *sq, struct xsc_cqe *cqe)
+{
+	struct xsc_channel *c = sq->channel;
+	u32 data0 = le32_to_cpu(cqe->data0);
+
+	net_err_ratelimited("Err cqe on dev %s cqn=0x%x ci=0x%x sqn=0x%x err_code=0x%lx qpid=0x%lx\n",
+			    c->netdev->name, sq->cq.xcq.cqn,
+			    xsc_cqwq_get_ci(&sq->cq.wq), sq->sqn,
+			    FIELD_GET(XSC_CQE_DATA0_ERR_CODE_MASK, data0),
+			    FIELD_GET(XSC_CQE_DATA0_QP_ID_MASK, data0));
+}
+
 int xsc_poll_tx_cq(struct xsc_cq *cq, int budget)
 {
 	struct xsc_cqe *cqe;
@@ -43,6 +65,9 @@ int xsc_poll_tx_cq(struct xsc_cq *cq, int budget)
 		/* ensure cqe content is read after cqe ownership bit */
 		dma_rmb();
 
+		if (unlikely(le32_to_cpu(cqe->data0) & XSC_CQE_DATA0_IS_ERR))
+			xsc_dump_error_sqcqe(sq, cqe);
+
 		xsc_cqwq_pop(&cq->wq);
 		wi = &sq->wqe_info[xsc_wq_cyc_ctr2ix(&sq->wq, sqcc)];
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
index 02aaa0980..a7e090b4b 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
@@ -16,6 +16,12 @@ int xsc_poll_tx_cq(struct xsc_cq *cq, int budget);
 void xsc_free_tx_wqe(struct device *dev, struct xsc_sq *sq);
 netdev_tx_t xsc_eth_xmit(struct sk_buff *skb, struct net_device *netdev);
 
+int xsc_poll_rx_cq(struct xsc_cq *cq, int budget);
+int xsc_eth_napi_poll(struct napi_struct *napi, int budget);
+void xsc_eth_handle_rx_cqe(struct xsc_rq *rq, struct xsc_cqe *cqe);
+bool xsc_eth_post_rx_wqes(struct xsc_rq *rq);
+void xsc_eth_dealloc_rx_wqe(struct xsc_rq *rq, u16 ix);
+
 struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq);
 
 static inline bool xsc_wqc_has_room_for(struct xsc_wq_cyc *wq,
@@ -24,4 +30,7 @@ static inline bool xsc_wqc_has_room_for(struct xsc_wq_cyc *wq,
 	return (xsc_wq_cyc_ctr2ix(wq, cc - pc) >= n) || (cc == pc);
 }
 
+void xsc_cq_notify_hw(struct xsc_cq *cq);
+void xsc_cq_notify_hw_rearm(struct xsc_cq *cq);
+
 #endif /* __XSC_ETH_TXRX_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
index d89e62d93..61a2de9ef 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_queue.h
@@ -37,7 +37,7 @@ enum {
 struct xsc_cq {
 	/* data path - accessed per cqe */
 	struct xsc_cqwq		wq;
-
+	struct napi_struct	*napi;
 	struct xsc_core_cq	xcq;
 	struct xsc_channel	*channel;
 
-- 
2.43.0
