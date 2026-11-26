Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705068;
	b=c8Wepie0eWw7M0pr2qFgbNcmvfhJ7haw3hS8hDQq3BZgAodeaGIOkIM9G3A6RdF3xgaH
	 wG30rPVkack3hPez1wpSzr6O0Vsh3GxBOGKwHLhaADsFQj7Ym13ONGyYBWZaEiLNhDbxT
	 nv1s/q+auXm2+TVZdJ/Lx53x/++Yu15CHqs+w3avWLaQl8kUPBdKzIg+OyKV6bZeDo1XW
	 7ly37jzxESCYU3ujlBiwf/ngtHksfwHPcQCAYsWEYQSVmTtjiZV1CEWd37b1OyHJPm3dK
	 SVh4wZrew0dieyz6QYcq6yOWVWj2RmsdAgawZbMOFZXbTr3gZVwOGYUp5Pn4MKXTBFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705068;
	h=DMARC-Filter:DKIM-Signature:In-Reply-To:Cc:References:X-Mailer:
	 X-Original-From:X-Lms-Return-Path:Date:Message-Id:Received:From:
	 Subject:Content-Type:Content-Transfer-Encoding:To:Mime-Version;
	bh=xZG8r2nai1OljYpxPj5e6R9sMaHkHJudXjJ2m50rBBY=;
	b=i1cNceQTTJGNeHig091ZKIlOX/Eu2AnTH7QBG0PjYALobZuYkSiRuqTvLclYsJXincqN
	 rbDIOmm83lPWXsL6xKH/NQMUwVq3aJ04flXpHW9bKird9+TiVwmjWfiU9P1E5OpOEkxit
	 S9O4rn69d//5Ay//vQ6rocZXZtP3p7oBUb33FQbx1D0DEr6LZ4JElQAKsYbcfUKQJxGAk
	 BFVmkGgmiygz9sJS093uoLiN+K7VHqY4N+w3fz9z/eA9nRstvmJd1ONYqlYak/Zm5t5Pl
	 IzaY7bDCqYyv5vhciMDau72DVvjM7IgLuQW+ijf0Wn68yiTjKcCtwWWInjSlJTCyukw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=P7AIIaks;
	arc=none smtp.remote-ip=209.127.231.16
Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398AE606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 398AE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=P7AIIaks
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705063; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xZG8r2nai1OljYpxPj5e6R9sMaHkHJudXjJ2m50rBBY=;
 b=P7AIIakshZUAVEI1nQcjO49en3aIFZtxDy+XCR5YVz/J9W9dHSK3HvR9MhUQ8Of9kEepcP
 44GkPwLZq3mWy20tLNUgGlTXllVUaWtHOQiyZFKS9l8kC/EOHkI80gWhzENfePqTuLpk3t
 dR6jcz0yNzLINe/0jtPxm/1EGpDXFdp+5R41PHE1/nP4oa3hJuPLN8LjKKfxRqYKkwwGJf
 68MeTZ1n7Qvp0Aq1yI6EkL/Vo7Q1YUAPGx5pWpShJOPOKzioxUaMePd5xUibLzgfBfaj6K
 NmG6YPj7dv1RWa39NYmcqla4nJCWme7xU81+Mf89RGWihdmaxzMASjzzNvQc0A==
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
X-Original-From: Xin Tian <tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26b0848e5+a98874+vger.kernel.org+tianx@yunsilicon.com>
Date: Thu, 26 Nov 2026 22:57:41 +0800
Message-Id: <20261126145740.70868-11-tianx@yunsilicon.com>
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:41 +0800
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH v2 10/11] net/xsc: add the transmit path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

Post linear skbs to the send queue, ring the doorbell, and reap
completions. Without offloads every frame takes the same simple path.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  4 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |  2 +-
 .../net/ethernet/yunsilicon/xsc/net/main.c    |  3 +
 .../ethernet/yunsilicon/xsc/net/xsc_eth_tx.c  | 87 +++++++++++++++++++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         | 70 +++++++++++++++
 .../yunsilicon/xsc/net/xsc_eth_txrx.h         | 27 ++++++
 6 files changed, 192 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index cca1fafc8..872080d09 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -115,6 +115,10 @@ struct xsc_wqe_data_seg {
 	__le64		va;
 };
 
+#define XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK		GENMASK(7, 0)
+#define XSC_WQE_CTRL_SEG_DATA0_DS_DATA_NUM_MASK		GENMASK(15, 11)
+#define XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK		GENMASK(31, 16)
+#define XSC_WQE_CTRL_SEG_DATA3_CE			BIT(1)
 #define XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK	GENMASK(31, 1)
 
 /* cqe */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
index 0e6249cec..ffb819884 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc_eth.o
 
-xsc_eth-y := main.o xsc_eth_wq.o
+xsc_eth-y := main.o xsc_eth_wq.o xsc_eth_txrx.o xsc_eth_tx.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
index 75a6abd6e..8eda3c8b1 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -12,6 +12,7 @@
 #include "common/xsc_cmd.h"
 #include "xsc_eth_common.h"
 #include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
 
 static void xsc_eth_build_nic_params(struct xsc_adapter *adapter)
 {
@@ -410,6 +411,7 @@ static void xsc_eth_close_qp_sq(struct xsc_channel *c, struct xsc_sq *psq)
 		return;
 	}
 
+	xsc_free_tx_wqe(c->adapter->dev, psq);
 	xsc_free_qp_sq(psq);
 }
 
@@ -952,6 +954,7 @@ static int xsc_eth_set_hw_mtu(struct xsc_core_device *xdev,
 static const struct net_device_ops xsc_netdev_ops = {
 	.ndo_open		= xsc_eth_open,
 	.ndo_stop		= xsc_eth_close,
+	.ndo_start_xmit		= xsc_eth_xmit,
 };
 
 static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
new file mode 100644
index 000000000..580af1f23
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
+
+#define XSC_OPCODE_RAW			7
+
+netdev_tx_t xsc_eth_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+	struct xsc_core_device *xdev = adapter->xdev;
+	struct xsc_send_wqe_ctrl_seg *cseg;
+	struct xsc_tx_wqe_info *wi;
+	struct xsc_sq *sq = &adapter->channel.qp.sq;
+	struct xsc_tx_wqe *wqe;
+	u32 ds_num_log = ilog2(xdev->caps.send_ds_num);
+	dma_addr_t dma_addr;
+	u16 pi;
+
+	if (!adapter->opened)
+		return NETDEV_TX_BUSY;
+
+	if (unlikely(skb_is_nonlinear(skb) || skb->len == 0 ||
+		     skb->len > sq->hw_mtu))
+		goto err_drop;
+
+	pi = xsc_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wqe = xsc_wq_cyc_get_wqe(&sq->wq, pi);
+	memset(wqe, 0, xdev->caps.send_ds_num * XSC_SEND_WQE_DS);
+
+	dma_addr = dma_map_single(sq->channel->adapter->dev, skb->data,
+				  skb->len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->channel->adapter->dev, dma_addr)))
+		goto err_drop;
+
+	wi = &sq->wqe_info[pi];
+	wi->skb = skb;
+	wi->dma_addr = dma_addr;
+
+	cseg = &wqe->ctrl;
+	cseg->data0 = cpu_to_le32(FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
+					     XSC_OPCODE_RAW) |
+				  FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_DS_DATA_NUM_MASK,
+					     1) |
+				  FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK,
+					     sq->pc << ds_num_log));
+	cseg->msg_len = cpu_to_le32(skb->len);
+	cseg->data3 = cpu_to_le32(XSC_WQE_CTRL_SEG_DATA3_CE);
+	wqe->data[0].data0 =
+		cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK,
+				       skb->len));
+	wqe->data[0].va = cpu_to_le64(dma_addr);
+
+	sq->pc++;
+	if (unlikely(!xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
+					   sq->stop_room)))
+		netif_tx_stop_queue(sq->txq);
+
+	if (!netdev_xmit_more() || netif_xmit_stopped(sq->txq))
+		xsc_update_tx_db(xdev, sq->sqn, sq->pc << ds_num_log);
+
+	return NETDEV_TX_OK;
+
+err_drop:
+	dev_kfree_skb_any(skb);
+	if (!netdev_xmit_more() || netif_xmit_stopped(sq->txq))
+		xsc_update_tx_db(xdev, sq->sqn, sq->pc << ds_num_log);
+	return NETDEV_TX_OK;
+}
+
+void xsc_free_tx_wqe(struct device *dev, struct xsc_sq *sq)
+{
+	for (; sq->cc != sq->pc; sq->cc++) {
+		struct xsc_tx_wqe_info *wi =
+			&sq->wqe_info[xsc_wq_cyc_ctr2ix(&sq->wq, sq->cc)];
+
+		if (!wi->skb)
+			continue;
+
+		dma_unmap_single(dev, wi->dma_addr, wi->skb->len,
+				 DMA_TO_DEVICE);
+		dev_kfree_skb_any(wi->skb);
+	}
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
new file mode 100644
index 000000000..ee6554ed8
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
+
+struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq)
+{
+	struct xsc_cqe *cqe = xsc_frag_buf_get_wqe(&wq->fbc,
+						   xsc_cqwq_get_ci(wq));
+
+	if (!!(le32_to_cpu(cqe->data1) & XSC_CQE_DATA1_OWNER) !=
+	    (xsc_cqwq_get_wrap_cnt(wq) & 1))
+		return NULL;
+
+	return cqe;
+}
+
+int xsc_poll_tx_cq(struct xsc_cq *cq, int budget)
+{
+	struct xsc_cqe *cqe;
+	struct device *dev;
+	struct xsc_sq *sq;
+	u16 sqcc;
+	int i = 0;
+
+	sq = container_of(cq, struct xsc_sq, cq);
+	if (!test_bit(XSC_ETH_SQ_STATE_ENABLED, &sq->state))
+		return 0;
+
+	dev = sq->channel->adapter->dev;
+	sqcc = sq->cc;
+
+	while (i < budget) {
+		struct xsc_tx_wqe_info *wi;
+		struct sk_buff *skb;
+
+		cqe = xsc_cqwq_get_cqe(&cq->wq);
+		if (!cqe)
+			break;
+		/* ensure cqe content is read after cqe ownership bit */
+		dma_rmb();
+
+		xsc_cqwq_pop(&cq->wq);
+		wi = &sq->wqe_info[xsc_wq_cyc_ctr2ix(&sq->wq, sqcc)];
+
+		skb = wi->skb;
+		wi->skb = NULL;
+		if (skb) {
+			dma_unmap_single(dev, wi->dma_addr, skb->len,
+					 DMA_TO_DEVICE);
+			dev_kfree_skb_any(skb);
+		}
+
+		sqcc++;
+		i++;
+	}
+
+	xsc_update_cq_ci(cq->xdev, cq->xcq.cqn, cq->wq.cc);
+
+	sq->cc = sqcc;
+
+	if (netif_tx_queue_stopped(sq->txq) &&
+	    xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room))
+		netif_tx_wake_queue(sq->txq);
+
+	return i == budget;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
new file mode 100644
index 000000000..02aaa0980
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ETH_TXRX_H
+#define __XSC_ETH_TXRX_H
+
+#include <linux/dma-mapping.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
+#include "xsc_eth.h"
+
+int xsc_poll_tx_cq(struct xsc_cq *cq, int budget);
+void xsc_free_tx_wqe(struct device *dev, struct xsc_sq *sq);
+netdev_tx_t xsc_eth_xmit(struct sk_buff *skb, struct net_device *netdev);
+
+struct xsc_cqe *xsc_cqwq_get_cqe(struct xsc_cqwq *wq);
+
+static inline bool xsc_wqc_has_room_for(struct xsc_wq_cyc *wq,
+					u16 cc, u16 pc, u16 n)
+{
+	return (xsc_wq_cyc_ctr2ix(wq, cc - pc) >= n) || (cc == pc);
+}
+
+#endif /* __XSC_ETH_TXRX_H */
-- 
2.43.0
