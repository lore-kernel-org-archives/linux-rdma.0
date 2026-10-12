Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B23ACA5C
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805470; cv=none; b=jpXVCLIUp74ub/ofwDLYn3w53WWaoQUpGoxkwrHKHR1bHaIv1a0qy0KtMmSpStEVZVUanZ7vXmPUIrje4sAyZh5vaWBPuSO5eqLRMYbS07PyidtK7q5NYGsEtZc60lb+ywWBNqDm91iVLtz57kFuTqKh/z0VASxobUKMeF8ODlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805470; c=relaxed/simple;
	bh=UjDx7GVOTcV67wY8vGFOnq3NwX0mIDPjhrT7hMcJSLU=;
	h=To:From:Subject:Date:Message-Id:Cc:Mime-Version:References:
	 In-Reply-To:Content-Type; b=VDm355WFP4lKypd0TZiZbqiJWXXkuFC+QjseM7rCFclprCkEUzxTi+QsgfCUY9nZza3ZgsJ8mvuIWkuBBzYcpa/byr5vThA4iQ0LOevCN2YMTftrRr8SSP3laklSG5yZdV854LlO/ajOz5LJVyfqbsiCPpHztSOTlesvYHnTgk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=C6X55xP4; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="C6X55xP4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805452; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bRrq0W9njrlTAfZ21YGck9HYMs19+pob4KQD3bMGmoY=;
 b=C6X55xP4R5jS9GSB6IhfTwq59q8nCxcAFg9WJ1oakclkyvfXwKHgn3KS2ROgAbhXtUzjr5
 HLBr7Z1h6rlbUSylGbmrDf+wjc0dupEPI/whsGv6cxMdI8521PdaEmn5Zr6X6/55GcCBAX
 FU7xfOlVzpTh2OrDm+Bq1xjdnaMd02k/+oW236wzrNriz/X/wMR/lHZm1NB0NGXF/TCSAa
 k2EiQr7zyQpl64bFq7bfi1XeYpW1piltWLzzb9zckte4elUKzhvCsRDBYzt3kTRuncu1me
 zhr8I5jgMgiJV0iWI1jpR42qR04GZXFrxS72dgAeLltc3AsZ6wY6kuI/2a2/pA==
X-Original-From: Xin Tian <tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH 07/15] yunsilicon: add ethernet TX path
Date: Mon, 12 Oct 2026 19:44:09 +0800
Message-Id: <20261012114408.2471317-8-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:09 +0800
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26accc809+a0bfae+vger.kernel.org+tianx@yunsilicon.com>

Add the transmit path: WQE construction, completion handling and
ndo_start_xmit.  The channel layer opens its SQ/CQ pairs, enables NAPI
and advertises the TX offloads the driver implements.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 905 +++++++++++++++++-
 .../ethernet/yunsilicon/xsc/net/xsc_eth_tx.c  | 309 ++++++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         | 146 +++
 4 files changed, 1357 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c

diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
index 0e6249cec..ffb819884 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc_eth.o
 
-xsc_eth-y := main.o xsc_eth_wq.o
+xsc_eth-y := main.o xsc_eth_wq.o xsc_eth_txrx.o xsc_eth_tx.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
index b92c3ed19..a20d01618 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -97,6 +97,800 @@ static int xsc_eth_netdev_init(struct xsc_adapter *adapter)
 	return 0;
 }
 
+static void xsc_eth_build_queue_param(struct xsc_adapter *adapter,
+				      struct xsc_queue_attr *attr, u8 type)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+
+	if (adapter->nic_param.sq_size == 0)
+		adapter->nic_param.sq_size = BIT(xdev->caps.log_max_qp_depth);
+	if (adapter->nic_param.rq_size == 0)
+		adapter->nic_param.rq_size = BIT(xdev->caps.log_max_qp_depth);
+
+	if (type == XSC_QUEUE_TYPE_RQCQ) {
+		attr->ele_num = min_t(int, XSC_RQCQ_ELE_NUM,
+				      xdev->caps.max_cqes);
+		attr->ele_size = XSC_RQCQ_ELE_SZ;
+		attr->ele_log_size = order_base_2(XSC_RQCQ_ELE_SZ);
+		attr->q_log_size = order_base_2(attr->ele_num);
+	} else if (type == XSC_QUEUE_TYPE_SQCQ) {
+		attr->ele_num = min_t(int, XSC_SQCQ_ELE_NUM,
+				      xdev->caps.max_cqes);
+		attr->ele_size = XSC_SQCQ_ELE_SZ;
+		attr->ele_log_size = order_base_2(XSC_SQCQ_ELE_SZ);
+		attr->q_log_size = order_base_2(attr->ele_num);
+	} else if (type == XSC_QUEUE_TYPE_RQ) {
+		attr->ele_num = adapter->nic_param.rq_size;
+		attr->ele_size = xdev->caps.recv_ds_num * XSC_RECV_WQE_DS;
+		attr->ele_log_size = order_base_2(attr->ele_size);
+		attr->q_log_size = order_base_2(attr->ele_num);
+	} else if (type == XSC_QUEUE_TYPE_SQ) {
+		attr->ele_num = adapter->nic_param.sq_size;
+		attr->ele_size = xdev->caps.send_ds_num * XSC_SEND_WQE_DS;
+		attr->ele_log_size = order_base_2(attr->ele_size);
+		attr->q_log_size = order_base_2(attr->ele_num);
+	}
+}
+
+static u32 xsc_rx_get_linear_frag_sz(u32 mtu)
+{
+	u32 byte_count = XSC_SW2HW_FRAG_SIZE(mtu);
+
+	return XSC_SKB_FRAG_SZ(byte_count);
+}
+
+static bool xsc_rx_is_linear_skb(u32 mtu)
+{
+	u32 linear_frag_sz = xsc_rx_get_linear_frag_sz(mtu);
+
+	return linear_frag_sz <= PAGE_SIZE;
+}
+
+static u32 xsc_get_rq_frag_info(struct xsc_rq_frags_info *frags_info, u32 mtu)
+{
+	u32 byte_count = XSC_SW2HW_FRAG_SIZE(mtu);
+	int frag_stride;
+	int i = 0;
+
+	if (xsc_rx_is_linear_skb(mtu)) {
+		frag_stride = xsc_rx_get_linear_frag_sz(mtu);
+		frag_stride = roundup_pow_of_two(frag_stride);
+
+		frags_info->arr[0].frag_size = byte_count;
+		frags_info->arr[0].frag_stride = frag_stride;
+		frags_info->num_frags = 1;
+		frags_info->wqe_bulk = PAGE_SIZE / frag_stride;
+		frags_info->wqe_bulk_min = frags_info->wqe_bulk;
+		goto out;
+	}
+
+	if (byte_count <= DEFAULT_FRAG_SIZE) {
+		frags_info->arr[0].frag_size = DEFAULT_FRAG_SIZE;
+		frags_info->arr[0].frag_stride = DEFAULT_FRAG_SIZE;
+		frags_info->num_frags = 1;
+	} else if (byte_count <= PAGE_SIZE_4K) {
+		frags_info->arr[0].frag_size = PAGE_SIZE_4K;
+		frags_info->arr[0].frag_stride = PAGE_SIZE_4K;
+		frags_info->num_frags = 1;
+	} else if (byte_count <= (PAGE_SIZE_4K + DEFAULT_FRAG_SIZE)) {
+		if (PAGE_SIZE < 2 * PAGE_SIZE_4K) {
+			frags_info->arr[0].frag_size = PAGE_SIZE_4K;
+			frags_info->arr[0].frag_stride = PAGE_SIZE_4K;
+			frags_info->arr[1].frag_size = PAGE_SIZE_4K;
+			frags_info->arr[1].frag_stride = PAGE_SIZE_4K;
+			frags_info->num_frags = 2;
+		} else {
+			frags_info->arr[0].frag_size = 2 * PAGE_SIZE_4K;
+			frags_info->arr[0].frag_stride = 2 * PAGE_SIZE_4K;
+			frags_info->num_frags = 1;
+		}
+	} else if (byte_count <= 2 * PAGE_SIZE_4K) {
+		if (PAGE_SIZE < 2 * PAGE_SIZE_4K) {
+			frags_info->arr[0].frag_size = PAGE_SIZE_4K;
+			frags_info->arr[0].frag_stride = PAGE_SIZE_4K;
+			frags_info->arr[1].frag_size = PAGE_SIZE_4K;
+			frags_info->arr[1].frag_stride = PAGE_SIZE_4K;
+			frags_info->num_frags = 2;
+		} else {
+			frags_info->arr[0].frag_size = 2 * PAGE_SIZE_4K;
+			frags_info->arr[0].frag_stride = 2 * PAGE_SIZE_4K;
+			frags_info->num_frags = 1;
+		}
+	} else {
+		if (PAGE_SIZE < 4 * PAGE_SIZE_4K) {
+			frags_info->num_frags =
+				roundup(byte_count,
+					PAGE_SIZE_4K) / PAGE_SIZE_4K;
+			for (i = 0; i < frags_info->num_frags; i++) {
+				frags_info->arr[i].frag_size = PAGE_SIZE_4K;
+				frags_info->arr[i].frag_stride = PAGE_SIZE_4K;
+			}
+		} else {
+			frags_info->arr[0].frag_size = 4 * PAGE_SIZE_4K;
+			frags_info->arr[0].frag_stride = 4 * PAGE_SIZE_4K;
+			frags_info->num_frags = 1;
+		}
+	}
+
+	if (PAGE_SIZE <= PAGE_SIZE_4K) {
+		frags_info->wqe_bulk_min = 4;
+		frags_info->wqe_bulk = max_t(u8, frags_info->wqe_bulk_min, 8);
+	} else if (PAGE_SIZE <= 2 * PAGE_SIZE_4K) {
+		frags_info->wqe_bulk = 2;
+		frags_info->wqe_bulk_min = frags_info->wqe_bulk;
+	} else {
+		frags_info->wqe_bulk =
+			PAGE_SIZE /
+			(frags_info->num_frags * frags_info->arr[0].frag_size);
+		frags_info->wqe_bulk_min = frags_info->wqe_bulk;
+	}
+
+out:
+	frags_info->log_num_frags = order_base_2(frags_info->num_frags);
+
+	return frags_info->num_frags * frags_info->arr[0].frag_size;
+}
+
+static void xsc_build_rq_frags_info(struct xsc_queue_attr *attr,
+				    struct xsc_rq_frags_info *frags_info,
+				    struct xsc_eth_params *params)
+{
+	params->rq_frags_size = xsc_get_rq_frag_info(frags_info, params->mtu);
+	frags_info->frags_max_num = attr->ele_size / XSC_RECV_WQE_DS;
+}
+
+static void xsc_eth_build_channel_param(struct xsc_adapter *adapter,
+					struct xsc_channel_param *chl_param)
+{
+	xsc_eth_build_queue_param(adapter, &chl_param->rqcq_param.cq_attr,
+				  XSC_QUEUE_TYPE_RQCQ);
+	chl_param->rqcq_param.wq.buf_numa_node = dev_to_node(adapter->dev);
+
+	xsc_eth_build_queue_param(adapter, &chl_param->sqcq_param.cq_attr,
+				  XSC_QUEUE_TYPE_SQCQ);
+	chl_param->sqcq_param.wq.buf_numa_node = dev_to_node(adapter->dev);
+
+	xsc_eth_build_queue_param(adapter, &chl_param->sq_param.sq_attr,
+				  XSC_QUEUE_TYPE_SQ);
+	chl_param->sq_param.wq.buf_numa_node = dev_to_node(adapter->dev);
+
+	xsc_eth_build_queue_param(adapter, &chl_param->rq_param.rq_attr,
+				  XSC_QUEUE_TYPE_RQ);
+	chl_param->rq_param.wq.buf_numa_node = dev_to_node(adapter->dev);
+
+	xsc_build_rq_frags_info(&chl_param->rq_param.rq_attr,
+				&chl_param->rq_param.frags_info,
+				&adapter->nic_param);
+}
+
+static void xsc_eth_cq_error_event(struct xsc_core_cq *xcq,
+				   enum xsc_event event)
+{
+	struct xsc_cq *xsc_cq = container_of(xcq, struct xsc_cq, xcq);
+	struct xsc_core_device *xdev = xsc_cq->xdev;
+
+	if (event != XSC_EVENT_TYPE_CQ_ERROR) {
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "Unexpected event type %d on CQ %06x\n",
+			   event, xcq->cqn);
+		return;
+	}
+
+	netdev_err(xsc_dev_to_netdev(xdev),
+		   "Eth catch CQ ERROR: %x, cqn: %d\n", event, xcq->cqn);
+}
+
+static void xsc_eth_completion_event(struct xsc_core_cq *xcq)
+{
+	struct xsc_cq *cq = container_of(xcq, struct xsc_cq, xcq);
+	struct xsc_core_device *xdev = cq->xdev;
+	struct xsc_rq *rq = NULL;
+
+	if (unlikely(!cq->channel)) {
+		netdev_err(xsc_dev_to_netdev(xdev), "cq%d->channel is null\n",
+			   xcq->cqn);
+		return;
+	}
+
+	rq = &cq->channel->qp.rq;
+
+	if (!test_bit(XSC_ETH_RQ_STATE_ENABLED, &rq->state))
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "ch%d_cq%d, napi_flag=0x%lx\n",
+			   cq->channel->chl_idx, xcq->cqn,
+			   cq->napi->state);
+
+	napi_schedule(cq->napi);
+	cq->event_ctr++;
+}
+
+static int xsc_eth_alloc_cq(struct xsc_channel *c, struct xsc_cq *pcq,
+			    struct xsc_cq_param *pcq_param)
+{
+	u8 ele_log_size = pcq_param->cq_attr.ele_log_size;
+	struct xsc_core_device *xdev = c->adapter->xdev;
+	u8 q_log_size = pcq_param->cq_attr.q_log_size;
+	struct xsc_core_cq *core_cq = &pcq->xcq;
+	int ret;
+	u32 i;
+
+	pcq_param->wq.db_numa_node = cpu_to_node(c->cpu);
+	pcq_param->wq.buf_numa_node = cpu_to_node(c->cpu);
+
+	ret = xsc_eth_cqwq_create(xdev, &pcq_param->wq,
+				  q_log_size, ele_log_size, &pcq->wq,
+				  &pcq->wq_ctrl);
+	if (ret)
+		return ret;
+
+	core_cq->cqe_sz = pcq_param->cq_attr.ele_num;
+	core_cq->comp = xsc_eth_completion_event;
+	core_cq->event = xsc_eth_cq_error_event;
+	core_cq->vector = c->chl_idx;
+
+	for (i = 0; i < xsc_cqwq_get_size(&pcq->wq); i++) {
+		struct xsc_cqe *cqe = xsc_cqwq_get_wqe(&pcq->wq, i);
+
+		cqe->data1 |= cpu_to_le32(XSC_CQE_OWNER);
+	}
+	pcq->xdev = xdev;
+
+	return ret;
+}
+
+static int xsc_eth_set_cq(struct xsc_channel *c,
+			  struct xsc_cq *pcq,
+			  struct xsc_cq_param *pcq_param)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+	struct xsc_create_cq_mbox_in *in;
+	unsigned int hw_npages;
+	unsigned int irqn;
+	int inlen;
+	u32 eqn;
+	int ret;
+
+	hw_npages = DIV_ROUND_UP(pcq->wq_ctrl.buf.size, PAGE_SIZE_4K);
+	/*mbox size + pas size*/
+	inlen = sizeof(struct xsc_create_cq_mbox_in) +
+		sizeof(__be64) * hw_npages;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	/*construct param of in struct*/
+	ret = xsc_core_vector2eqn(xdev, c->chl_idx, &eqn, &irqn);
+	if (ret)
+		goto err_free;
+
+	in->ctx.eqn = cpu_to_be16(eqn);
+	in->ctx.log_cq_sz = pcq_param->cq_attr.q_log_size;
+	in->ctx.pa_num = cpu_to_be16(hw_npages);
+	in->ctx.glb_func_id = cpu_to_be16(xdev->glb_func_id);
+
+	xsc_core_fill_page_frag_array(&pcq->wq_ctrl.buf,
+				      &in->pas[0],
+				      hw_npages);
+
+	ret = xsc_core_eth_create_cq(c->adapter->xdev, &pcq->xcq, in, inlen);
+	if (ret)
+		goto err_free;
+	pcq->xcq.irqn = irqn;
+	pcq->xcq.eq = xsc_core_eq_get(xdev, pcq->xcq.vector);
+	return 0;
+
+err_free:
+	kvfree(in);
+	return ret;
+}
+
+static void xsc_eth_free_cq(struct xsc_cq *cq)
+{
+	xsc_eth_wq_destroy(&cq->wq_ctrl);
+}
+
+static int xsc_eth_open_cq(struct xsc_channel *c,
+			   struct xsc_cq *pcq,
+			   struct xsc_cq_param *pcq_param)
+{
+	int ret;
+
+	ret = xsc_eth_alloc_cq(c, pcq, pcq_param);
+	if (ret)
+		return ret;
+
+	ret = xsc_eth_set_cq(c, pcq, pcq_param);
+	if (ret)
+		goto err_free_cq;
+
+	xsc_cq_notify_hw_rearm(pcq);
+
+	pcq->napi = &c->napi;
+	pcq->channel = c;
+
+	return 0;
+
+err_free_cq:
+	xsc_eth_free_cq(pcq);
+	return ret;
+}
+
+static int xsc_eth_close_cq(struct xsc_channel *c, struct xsc_cq *pcq)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+	int ret;
+
+	ret = xsc_core_eth_destroy_cq(xdev, &pcq->xcq);
+	if (ret) {
+		netdev_err(xsc_dev_to_netdev(xdev), "failed to close ch%d cq%d, ret=%d\n",
+			   c->chl_idx, pcq->xcq.cqn, ret);
+		return ret;
+	}
+
+	xsc_eth_free_cq(pcq);
+
+	return 0;
+}
+
+static void xsc_free_qp_sq_db(struct xsc_sq *sq)
+{
+	kvfree(sq->db.wqe_info);
+	kvfree(sq->db.dma_fifo);
+}
+
+static void xsc_free_qp_sq(struct xsc_sq *sq)
+{
+	xsc_free_qp_sq_db(sq);
+	xsc_eth_wq_destroy(&sq->wq_ctrl);
+}
+
+static int xsc_eth_alloc_qp_sq_db(struct xsc_sq *sq, int numa)
+{
+	struct xsc_core_device *xdev = sq->cq.xdev;
+	int wq_sz;
+	int df_sz;
+
+	wq_sz = xsc_wq_cyc_get_size(&sq->wq);
+	df_sz = wq_sz * xdev->caps.send_ds_num;
+	sq->db.dma_fifo = kvzalloc_node(array_size(df_sz,
+						   sizeof(*sq->db.dma_fifo)),
+					GFP_KERNEL,
+					numa);
+	sq->db.wqe_info = kvzalloc_node(array_size(wq_sz,
+						   sizeof(*sq->db.wqe_info)),
+					GFP_KERNEL,
+					numa);
+
+	if (!sq->db.dma_fifo || !sq->db.wqe_info) {
+		xsc_free_qp_sq_db(sq);
+		return -ENOMEM;
+	}
+
+	sq->dma_fifo_mask = df_sz - 1;
+
+	return 0;
+}
+
+static void xsc_eth_qp_event(struct xsc_core_qp *qp, int type)
+{
+	struct xsc_core_device *xdev;
+	struct xsc_rq *rq;
+	struct xsc_sq *sq;
+
+	if (qp->eth_queue_type == XSC_RES_RQ) {
+		rq = container_of(qp, struct xsc_rq, cqp);
+		xdev = rq->cq.xdev;
+	} else if (qp->eth_queue_type == XSC_RES_SQ) {
+		sq = container_of(qp, struct xsc_sq, cqp);
+		xdev = sq->cq.xdev;
+	} else {
+		pr_err("%s:Unknown eth qp type %d\n", __func__, type);
+		return;
+	}
+
+	switch (type) {
+	case XSC_EVENT_TYPE_WQ_CATAS_ERROR:
+	case XSC_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+	case XSC_EVENT_TYPE_WQ_ACCESS_ERROR:
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "%s:Async event %x on QP %d\n",
+			   __func__, type, qp->qpn);
+		break;
+	default:
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "%s: Unexpected event type %d on QP %d\n",
+			   __func__, type, qp->qpn);
+		return;
+	}
+}
+
+static int xsc_eth_open_qp_sq(struct xsc_channel *c,
+			      struct xsc_sq *psq,
+			      struct xsc_sq_param *psq_param)
+{
+	u8 ele_log_size = psq_param->sq_attr.ele_log_size;
+	u8 q_log_size = psq_param->sq_attr.q_log_size;
+	struct xsc_modify_raw_qp_mbox_in *modify_in;
+	struct xsc_channel_stats *channel_stats;
+	struct xsc_create_qp_mbox_in *in;
+	struct xsc_core_device *xdev;
+	struct xsc_adapter *adapter;
+	struct xsc_stats *stats;
+	unsigned int hw_npages;
+	int inlen;
+	int ret;
+
+	adapter = c->adapter;
+	xdev  = adapter->xdev;
+	stats = adapter->stats;
+	channel_stats = &stats->channel_stats[c->chl_idx];
+	psq->stats = &channel_stats->sq;
+	psq_param->wq.db_numa_node = cpu_to_node(c->cpu);
+
+	ret = xsc_eth_wq_cyc_create(xdev, &psq_param->wq,
+				    q_log_size, ele_log_size, &psq->wq,
+				    &psq->wq_ctrl);
+	if (ret)
+		return ret;
+
+	hw_npages = DIV_ROUND_UP(psq->wq_ctrl.buf.size, PAGE_SIZE_4K);
+	inlen = sizeof(struct xsc_create_qp_mbox_in) +
+		sizeof(__be64) * hw_npages;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		ret = -ENOMEM;
+		goto err_sq_wq_destroy;
+	}
+	in->req.input_qpn = cpu_to_be16(XSC_QPN_SQN_STUB); /*no use for eth*/
+	in->req.qp_type = XSC_QUEUE_TYPE_RAW_TSO; /*default sq is tso qp*/
+	in->req.log_sq_sz = ilog2(xdev->caps.send_ds_num) + q_log_size;
+	in->req.pa_num = cpu_to_be16(hw_npages);
+	in->req.cqn_send = cpu_to_be16(psq->cq.xcq.cqn);
+	in->req.cqn_recv = in->req.cqn_send;
+	in->req.glb_funcid = cpu_to_be16(xdev->glb_func_id);
+
+	xsc_core_fill_page_frag_array(&psq->wq_ctrl.buf,
+				      &in->req.pas[0], hw_npages);
+
+	ret = xsc_core_eth_create_qp(xdev, in, inlen, &psq->sqn);
+	if (ret)
+		goto err_sq_in_destroy;
+
+	psq->cqp.qpn = psq->sqn;
+	psq->cqp.event = xsc_eth_qp_event;
+	psq->cqp.eth_queue_type = XSC_RES_SQ;
+
+	ret = xsc_core_create_resource_common(xdev, &psq->cqp);
+	if (ret) {
+		netdev_err(adapter->netdev, "%s:error qp:%d errno:%d\n",
+			   __func__, psq->sqn, ret);
+		goto err_sq_destroy;
+	}
+
+	psq->channel = c;
+	psq->ch_ix = c->chl_idx;
+	psq->txq_ix = psq->ch_ix;
+
+	/*need to querify from hardware*/
+	psq->hw_mtu = XSC_ETH_HW_MTU_SEND;
+	psq->stop_room = 1;
+
+	ret = xsc_eth_alloc_qp_sq_db(psq, psq_param->wq.db_numa_node);
+	if (ret)
+		goto err_sq_common_destroy;
+
+	inlen = sizeof(struct xsc_modify_raw_qp_mbox_in);
+	modify_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!modify_in) {
+		ret = -ENOMEM;
+		goto err_sq_common_destroy;
+	}
+
+	modify_in->req.qp_out_port = xdev->pf_id;
+	modify_in->pcie_no = xdev->pcie_no;
+	modify_in->req.qpn = cpu_to_be16((u16)(psq->sqn));
+	modify_in->req.func_id = cpu_to_be16(xdev->glb_func_id);
+	modify_in->req.dma_direct = XSC_DMA_DIR_TO_MAC;
+	modify_in->req.prio = 0; /* single traffic class */
+	ret = xsc_core_eth_modify_raw_qp(xdev, modify_in);
+	if (ret)
+		goto err_sq_modify_in_destroy;
+
+	kvfree(modify_in);
+	kvfree(in);
+
+	return 0;
+
+err_sq_modify_in_destroy:
+	kvfree(modify_in);
+
+err_sq_common_destroy:
+	xsc_core_destroy_resource_common(xdev, &psq->cqp);
+
+err_sq_destroy:
+	xsc_core_eth_destroy_qp(xdev, psq->cqp.qpn);
+
+err_sq_in_destroy:
+	kvfree(in);
+
+err_sq_wq_destroy:
+	xsc_eth_wq_destroy(&psq->wq_ctrl);
+	return ret;
+}
+
+static int xsc_eth_close_qp_sq(struct xsc_channel *c, struct xsc_sq *psq)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+	int ret;
+
+	xsc_core_destroy_resource_common(xdev, &psq->cqp);
+
+	ret = xsc_core_eth_destroy_qp(xdev, psq->cqp.qpn);
+	if (ret)
+		return ret;
+
+	xsc_free_qp_sq(psq);
+
+	return 0;
+}
+
+static int xsc_eth_open_channel(struct xsc_adapter *adapter,
+				int idx,
+				struct xsc_channel *c,
+				struct xsc_channel_param *chl_param)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+	struct net_device *netdev = adapter->netdev;
+	const struct cpumask *aff;
+	unsigned int irqn;
+	u32 eqn;
+	int ret;
+
+	c->adapter = adapter;
+	c->netdev = adapter->netdev;
+	c->chl_idx = idx;
+
+	if (xdev->caps.msix_enable) {
+		ret = xsc_core_vector2eqn(xdev, c->chl_idx, &eqn, &irqn);
+		if (ret)
+			goto err_out;
+		aff = irq_get_affinity_mask(irqn);
+		c->aff_mask = aff;
+		c->cpu = cpumask_first(aff);
+	}
+
+	ret = xsc_eth_open_cq(c, &c->qp.rq.cq, &chl_param->rqcq_param);
+	if (ret)
+		goto err_out;
+
+	ret = xsc_eth_open_cq(c, &c->qp.sq.cq, &chl_param->sqcq_param);
+	if (ret)
+		goto err_close_rq_cq;
+
+	ret = xsc_eth_open_qp_sq(c, &c->qp.sq, &chl_param->sq_param);
+	if (ret)
+		goto err_close_sq_cq;
+
+	netif_napi_add(netdev, &c->napi, xsc_eth_napi_poll);
+
+	netdev_dbg(adapter->netdev, "open channel%d ok\n", idx);
+	return 0;
+
+err_close_sq_cq:
+	xsc_eth_close_cq(c, &c->qp.sq.cq);
+err_close_rq_cq:
+	xsc_eth_close_cq(c, &c->qp.rq.cq);
+err_out:
+	netdev_err(adapter->netdev, "failed to open channel: ch%d, err=%d\n",
+		   idx, ret);
+	return ret;
+}
+
+static int xsc_eth_modify_qps_channel(struct xsc_adapter *adapter,
+				      struct xsc_channel *c)
+{
+	return xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.sq.sqn,
+					     XSC_CMD_OP_RTR2RTS_QP);
+}
+
+static int xsc_eth_modify_qps(struct xsc_adapter *adapter,
+			      struct xsc_eth_channels *chls)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < chls->num_chl; i++) {
+		struct xsc_channel *c = &chls->c[i];
+
+		ret = xsc_eth_modify_qps_channel(adapter, c);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
+{
+	xsc_eth_close_qp_sq(c, &c->qp.sq);
+	xsc_eth_close_cq(c, &c->qp.sq.cq);
+
+	netif_napi_del(&c->napi);
+}
+
+static int xsc_eth_open_channels(struct xsc_adapter *adapter)
+{
+	struct xsc_eth_channels *chls = &adapter->channels;
+	struct xsc_core_device *xdev = adapter->xdev;
+	struct xsc_channel_param *chl_param;
+	int ret = 0;
+	int i;
+
+	chls->num_chl = adapter->nic_param.num_channels;
+	chls->c = kcalloc_node(chls->num_chl, sizeof(struct xsc_channel),
+			       GFP_KERNEL, xdev->numa_node);
+	if (!chls->c) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	chl_param = kvzalloc_obj(*chl_param, GFP_KERNEL);
+	if (!chl_param) {
+		ret = -ENOMEM;
+		goto err_free_ch;
+	}
+
+	xsc_eth_build_channel_param(adapter, chl_param);
+
+	for (i = 0; i < chls->num_chl; i++) {
+		ret = xsc_eth_open_channel(adapter, i, &chls->c[i], chl_param);
+		if (ret)
+			goto err_close_channel;
+	}
+
+	for (i = 0; i < chls->num_chl; i++)
+		napi_enable(&chls->c[i].napi);
+
+	/* flush cache to memory before interrupt and napi_poll running */
+	smp_wmb();
+
+	ret = xsc_eth_modify_qps(adapter, chls);
+	if (ret)
+		goto err_close_channel;
+
+	kvfree(chl_param);
+	return 0;
+
+err_close_channel:
+	for (--i; i >= 0; i--)
+		xsc_eth_close_channel(&chls->c[i], false);
+
+	kvfree(chl_param);
+err_free_ch:
+	kfree(chls->c);
+err_out:
+	chls->num_chl = 0;
+	netdev_err(adapter->netdev, "failed to open %d channels, err=%d\n",
+		   chls->num_chl, ret);
+	return ret;
+}
+
+static void xsc_eth_close_channels(struct xsc_adapter *adapter)
+{
+	struct xsc_channel *c;
+	int i;
+
+	for (i = 0; i < adapter->channels.num_chl; i++) {
+		c = &adapter->channels.c[i];
+
+		xsc_eth_close_channel(c, true);
+	}
+
+	kfree(adapter->channels.c);
+	adapter->channels.num_chl = 0;
+}
+
+static void xsc_eth_build_tx2sq_maps(struct xsc_adapter *adapter)
+{
+	struct xsc_channel *c;
+	struct xsc_sq *psq;
+	int i;
+
+	for (i = 0; i < adapter->channels.num_chl; i++) {
+		c = &adapter->channels.c[i];
+		psq = &c->qp.sq;
+		adapter->txq2sq[psq->txq_ix] = psq;
+	}
+}
+
+static void xsc_eth_activate_txqsq(struct xsc_channel *c)
+{
+	struct xsc_sq *psq = &c->qp.sq;
+
+	psq->txq = netdev_get_tx_queue(psq->channel->netdev, psq->txq_ix);
+	set_bit(XSC_ETH_SQ_STATE_ENABLED, &psq->state);
+	netdev_tx_reset_queue(psq->txq);
+	netif_tx_start_queue(psq->txq);
+}
+
+static void xsc_eth_deactivate_txqsq(struct xsc_channel *c)
+{
+	clear_bit(XSC_ETH_SQ_STATE_ENABLED, &c->qp.sq.state);
+}
+
+static void xsc_eth_activate_channel(struct xsc_channel *c)
+{
+	xsc_eth_activate_txqsq(c);
+}
+
+static void xsc_eth_deactivate_channel(struct xsc_channel *c)
+{
+	xsc_eth_deactivate_txqsq(c);
+}
+
+static void xsc_eth_activate_channels(struct xsc_eth_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num_chl; i++)
+		xsc_eth_activate_channel(&chs->c[i]);
+}
+
+static void xsc_eth_deactivate_channels(struct xsc_eth_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num_chl; i++)
+		xsc_eth_deactivate_channel(&chs->c[i]);
+
+	/* Sync with all NAPIs to wait until they stop using queues. */
+	synchronize_net();
+
+	for (i = 0; i < chs->num_chl; i++)
+		/* last doorbell out */
+		napi_disable(&chs->c[i].napi);
+}
+
+static void xsc_eth_activate_priv_channels(struct xsc_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	netif_set_real_num_tx_queues(netdev, adapter->channels.num_chl);
+	netif_set_real_num_rx_queues(netdev, adapter->channels.num_chl);
+
+	xsc_eth_build_tx2sq_maps(adapter);
+	xsc_eth_activate_channels(&adapter->channels);
+	netif_tx_start_all_queues(adapter->netdev);
+}
+
+static void xsc_eth_deactivate_priv_channels(struct xsc_adapter *adapter)
+{
+	netif_tx_disable(adapter->netdev);
+	xsc_eth_deactivate_channels(&adapter->channels);
+}
+
+static int xsc_eth_sw_init(struct xsc_adapter *adapter)
+{
+	int ret;
+
+	ret = xsc_eth_open_channels(adapter);
+	if (ret)
+		return ret;
+
+	xsc_eth_activate_priv_channels(adapter);
+
+	return 0;
+}
+
+static void xsc_eth_sw_deinit(struct xsc_adapter *adapter)
+{
+	xsc_eth_deactivate_priv_channels(adapter);
+
+	return xsc_eth_close_channels(adapter);
+}
+
 static bool xsc_eth_get_link_status(struct xsc_adapter *adapter)
 {
 	struct xsc_core_device *xdev = adapter->xdev;
@@ -144,6 +938,84 @@ static void xsc_eth_link_event_handler(void *arg)
 			   err);
 }
 
+static bool xsc_get_pct_drop_config(struct xsc_core_device *xdev)
+{
+	return (xdev->pdev->device == XSC_MC_PF_DEV_ID) ||
+		(xdev->pdev->device == XSC_MF_SOC_PF_DEV_ID) ||
+		(xdev->pdev->device == XSC_MS_PF_DEV_ID) ||
+		(xdev->pdev->device == XSC_MV_SOC_PF_DEV_ID);
+}
+
+static int xsc_eth_enable_nic_hca(struct xsc_adapter *adapter)
+{
+	struct xsc_cmd_enable_nic_hca_mbox_out out = {};
+	struct xsc_cmd_enable_nic_hca_mbox_in in = {};
+	struct xsc_core_device *xdev = adapter->xdev;
+	struct net_device *netdev = adapter->netdev;
+	u16 caps_mask = 0;
+	u16 caps = 0;
+	int err;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_ENABLE_NIC_HCA);
+
+	in.rss.rss_en = 1;
+	in.rss.rqn_base = cpu_to_be16(adapter->channels.rqn_base -
+				xdev->caps.raweth_rss_qp_id_base);
+	in.rss.rqn_num = cpu_to_be16(adapter->channels.num_chl);
+	/* hfunc is a constant: the driver never negotiates anything else */
+	in.rss.hfunc = XSC_HASH_FUNC_TOP;
+	in.rss.hash_tmpl = cpu_to_be32(adapter->rss_param.rss_hash_tmpl);
+	caps_mask |= BIT(XSC_TBM_CAP_RSS);
+
+	if (netdev->features & NETIF_F_RXCSUM)
+		caps |= BIT(XSC_TBM_CAP_HASH_PPH);
+	caps_mask |= BIT(XSC_TBM_CAP_HASH_PPH);
+
+	if (xsc_get_pct_drop_config(xdev) && !(netdev->flags & IFF_SLAVE))
+		caps |= BIT(XSC_TBM_CAP_PCT_DROP_CONFIG);
+	caps_mask |= BIT(XSC_TBM_CAP_PCT_DROP_CONFIG);
+
+	memcpy(in.nic.mac_addr, netdev->dev_addr, ETH_ALEN);
+
+	in.nic.caps = cpu_to_be16(caps);
+	in.nic.caps_mask = cpu_to_be16(caps_mask);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		netdev_err(netdev, "failed!! err=%d, status=%d\n",
+			   err, out.hdr.status);
+		return -ENOEXEC;
+	}
+
+	return 0;
+}
+
+static int xsc_eth_disable_nic_hca(struct xsc_adapter *adapter)
+{
+	struct xsc_cmd_disable_nic_hca_mbox_out out = {};
+	struct xsc_cmd_disable_nic_hca_mbox_in in = {};
+	struct xsc_core_device *xdev = adapter->xdev;
+	struct net_device *netdev = adapter->netdev;
+	u16 caps = 0;
+	int err;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DISABLE_NIC_HCA);
+
+	if (xsc_get_pct_drop_config(xdev) &&
+	    !(netdev->priv_flags & IFF_BONDING))
+		caps |= BIT(XSC_TBM_CAP_PCT_DROP_CONFIG);
+
+	in.nic.caps = cpu_to_be16(caps);
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		netdev_err(netdev, "failed!! err=%d, status=%d\n",
+			   err, out.hdr.status);
+		return -ENOEXEC;
+	}
+
+	return 0;
+}
+
 static void xsc_set_default_xps_cpumasks(struct xsc_adapter *adapter)
 {
 	struct xsc_core_device *xdev = adapter->xdev;
@@ -175,11 +1047,20 @@ static int xsc_eth_open(struct net_device *netdev)
 {
 	struct xsc_adapter *adapter = netdev_priv(netdev);
 	struct xsc_core_device *xdev = adapter->xdev;
+	int ret;
 
 	if (adapter->opened) {
 		netdev_err(adapter->netdev, "ndo_open on an already opened device\n");
 		return 0;
 	}
+	ret = xsc_eth_sw_init(adapter);
+	if (ret)
+		return ret;
+
+	ret = xsc_eth_enable_nic_hca(adapter);
+	if (ret)
+		goto err_sw_deinit;
+
 	xsc_irq_event_register(xdev, xsc_eth_link_event_handler);
 
 	if (xsc_eth_get_link_status(adapter))	{
@@ -196,12 +1077,16 @@ static int xsc_eth_open(struct net_device *netdev)
 	xsc_set_port_admin_status(adapter, XSC_PORT_UP);
 
 	return 0;
+
+err_sw_deinit:
+	xsc_eth_sw_deinit(adapter);
+	return ret;
 }
 
 static int xsc_eth_close(struct net_device *netdev)
 {
 	struct xsc_adapter *adapter = netdev_priv(netdev);
-	struct xsc_core_device *xdev = adapter->xdev;
+	int ret;
 
 	if (!adapter->opened)
 		return 0;
@@ -209,11 +1094,16 @@ static int xsc_eth_close(struct net_device *netdev)
 
 	netif_carrier_off(adapter->netdev);
 
-	xsc_irq_event_unregister(xdev);
+	xsc_eth_sw_deinit(adapter);
+
+	ret = xsc_eth_disable_nic_hca(adapter);
+	if (ret)
+		netdev_err(adapter->netdev, "failed to disable nic hca, err=%d\n",
+			   ret);
 
 	xsc_set_port_admin_status(adapter, XSC_PORT_DOWN);
 
-	return 0;
+	return ret;
 }
 
 static int xsc_eth_set_hw_mtu(struct xsc_core_device *xdev,
@@ -246,6 +1136,7 @@ static int xsc_eth_set_hw_mtu(struct xsc_core_device *xdev,
 static const struct net_device_ops xsc_netdev_ops = {
 	.ndo_open		= xsc_eth_open,
 	.ndo_stop		= xsc_eth_close,
+	.ndo_start_xmit		= xsc_eth_xmit_start,
 };
 
 static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
@@ -260,7 +1151,13 @@ static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
 	/*mtu - macheaderlen - ipheaderlen should be aligned in 8B*/
 	netdev->mtu = SW_DEFAULT_MTU;
 
-	netdev->features = NETIF_F_HIGHDMA;
+	netdev->vlan_features |= NETIF_F_SG |
+				 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				 NETIF_F_TSO | NETIF_F_TSO6;
+
+	netdev->hw_features = netdev->vlan_features;
+
+	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 }
 
 static int xsc_eth_nic_init(struct xsc_adapter *adapter, u32 ch_num)
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
new file mode 100644
index 000000000..7495b12b7
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_tx.c
@@ -0,0 +1,309 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/tcp.h>
+
+#include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
+
+#define XSC_OPCODE_RAW 7
+
+static void xsc_dma_push(struct xsc_sq *sq, dma_addr_t addr, u32 size,
+			 enum xsc_dma_map_type map_type)
+{
+	struct xsc_sq_dma *dma = xsc_dma_get(sq, sq->dma_fifo_pc++);
+
+	dma->addr = addr;
+	dma->size = size;
+	dma->type = map_type;
+}
+
+static void xsc_dma_unmap_wqe(struct xsc_sq *sq, u8 num_dma)
+{
+	struct xsc_adapter *adapter = sq->channel->adapter;
+	struct device *dev  = adapter->dev;
+	int i;
+
+	for (i = 0; i < num_dma; i++) {
+		struct xsc_sq_dma *last_pushed_dma;
+
+		last_pushed_dma = xsc_dma_get(sq, --sq->dma_fifo_pc);
+		xsc_tx_dma_unmap(dev, last_pushed_dma);
+	}
+}
+
+static void *xsc_sq_fetch_wqe(struct xsc_sq *sq, size_t size, u16 *pi)
+{
+	struct xsc_wq_cyc *wq = &sq->wq;
+	void *wqe;
+
+	/*caution, sp->pc is default to be zero*/
+	*pi  = xsc_wq_cyc_ctr2ix(wq, sq->pc);
+	wqe = xsc_wq_cyc_get_wqe(wq, *pi);
+	memset(wqe, 0, size);
+
+	return wqe;
+}
+
+static u16 xsc_tx_get_gso_ihs(struct xsc_sq *sq, struct sk_buff *skb)
+{
+	u16 ihs;
+
+	if (skb->encapsulation) {
+		ihs = skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
+	} else {
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
+		else
+			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	}
+
+	return ihs;
+}
+
+static void xsc_txwqe_build_cseg_csum(struct xsc_sq *sq,
+				      struct sk_buff *skb,
+				      struct xsc_send_wqe_ctrl_seg *cseg)
+{
+	u32 val = le32_to_cpu(cseg->data0);
+
+	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		if (skb->encapsulation)
+			val |= FIELD_PREP(XSC_WQE_CTRL_SEG_CSUM_EN_MASK,
+					  XSC_ETH_WQE_INNER_AND_OUTER_CSUM);
+		else
+			val |= FIELD_PREP(XSC_WQE_CTRL_SEG_CSUM_EN_MASK,
+					  XSC_ETH_WQE_OUTER_CSUM);
+	} else {
+		val |= FIELD_PREP(XSC_WQE_CTRL_SEG_CSUM_EN_MASK,
+				  XSC_ETH_WQE_NONE_CSUM);
+	}
+	cseg->data0 = cpu_to_le32(val);
+}
+
+static void xsc_txwqe_build_csegs(struct xsc_sq *sq, struct sk_buff *skb,
+				  u16 mss, u16 ihs, u16 headlen,
+				  u8 opcode, u16 ds_cnt, u32 msglen,
+				  struct xsc_send_wqe_ctrl_seg *cseg)
+{
+	struct xsc_core_device *xdev = sq->cq.xdev;
+	int send_wqe_ds_num_log;
+	u32 val = 0;
+
+	send_wqe_ds_num_log = ilog2(xdev->caps.send_ds_num);
+	xsc_txwqe_build_cseg_csum(sq, skb, cseg);
+
+	if (mss != 0) {
+		val |= XSC_WQE_CTRL_SEG_HAS_PPH |
+		       XSC_WQE_CTRL_SEG_SO_TYPE |
+		       FIELD_PREP(XSC_WQE_CTRL_SEG_SO_HDR_LEN_MASK, ihs) |
+		       FIELD_PREP(XSC_WQE_CTRL_SEG_SO_DATA_SIZE_MASK, mss);
+		cseg->data2 = cpu_to_le32(val);
+	}
+
+	val = le32_to_cpu(cseg->data0);
+	val |= FIELD_PREP(XSC_WQE_CTRL_SEG_MSG_OPCODE_MASK, opcode) |
+	       FIELD_PREP(XSC_WQE_CTRL_SEG_WQE_ID_MASK,
+			  sq->pc << send_wqe_ds_num_log) |
+	       FIELD_PREP(XSC_WQE_CTRL_SEG_DS_DATA_NUM_MASK,
+			  ds_cnt - XSC_SEND_WQEBB_CTRL_NUM_DS);
+	cseg->data0 = cpu_to_le32(val);
+	cseg->msg_len = cpu_to_le32(msglen);
+	cseg->data3 = cpu_to_le32(XSC_WQE_CTRL_SEG_CE);
+}
+
+static int xsc_txwqe_build_dsegs(struct xsc_sq *sq, struct sk_buff *skb,
+				 u16 ihs, u16 headlen,
+				 struct xsc_wqe_data_seg *dseg)
+{
+	struct xsc_adapter *adapter = sq->channel->adapter;
+	struct device *dev = adapter->dev;
+	dma_addr_t dma_addr = 0;
+	u8 num_dma = 0;
+	int i;
+
+	if (headlen) {
+		dma_addr = dma_map_single(dev,
+					  skb->data,
+					  headlen,
+					  DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, dma_addr)))
+			goto err_dma_unmap_wqe;
+
+		dseg->va = cpu_to_le64(dma_addr);
+		dseg->mkey  = cpu_to_le32(be32_to_cpu(sq->mkey_be));
+		dseg->data0 |=
+			cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_SEG_LEN_MASK,
+					       headlen));
+
+		xsc_dma_push(sq, dma_addr, headlen, XSC_DMA_MAP_SINGLE);
+		num_dma++;
+		dseg++;
+	}
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		int fsz = skb_frag_size(frag);
+
+		dma_addr = skb_frag_dma_map(dev, frag, 0, fsz, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, dma_addr)))
+			goto err_dma_unmap_wqe;
+
+		dseg->va = cpu_to_le64(dma_addr);
+		dseg->mkey = cpu_to_le32(be32_to_cpu(sq->mkey_be));
+		dseg->data0 |=
+			cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_SEG_LEN_MASK,
+					       fsz));
+
+		xsc_dma_push(sq, dma_addr, fsz, XSC_DMA_MAP_PAGE);
+		num_dma++;
+		dseg++;
+	}
+
+	return num_dma;
+
+err_dma_unmap_wqe:
+	xsc_dma_unmap_wqe(sq, num_dma);
+	return -ENOMEM;
+}
+
+static void xsc_sq_notify_hw(struct xsc_wq_cyc *wq, u16 pc,
+			     struct xsc_sq *sq)
+{
+	struct xsc_adapter *adapter = sq->channel->adapter;
+	struct xsc_core_device *xdev  = adapter->xdev;
+	int send_ds_num_log = ilog2(xdev->caps.send_ds_num);
+
+	/* reverse wqe index to ds index */
+	xsc_update_tx_db(xdev, sq->sqn, pc << send_ds_num_log);
+}
+
+static void xsc_txwqe_complete(struct xsc_sq *sq, struct sk_buff *skb,
+			       u8 opcode, u16 ds_cnt,
+			       u8 num_wqebbs, u32 num_bytes, u8 num_dma,
+			       struct xsc_tx_wqe_info *wi)
+{
+	struct xsc_wq_cyc *wq = &sq->wq;
+
+	wi->num_bytes = num_bytes;
+	wi->num_dma = num_dma;
+	wi->num_wqebbs = num_wqebbs;
+	wi->skb = skb;
+
+	netdev_tx_sent_queue(sq->txq, num_bytes);
+
+	sq->pc += wi->num_wqebbs;
+
+	if (unlikely(!xsc_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room)))
+		netif_tx_stop_queue(sq->txq);
+
+	if (!netdev_xmit_more() || netif_xmit_stopped(sq->txq))
+		xsc_sq_notify_hw(wq, sq->pc, sq);
+}
+
+static uint32_t xsc_eth_xmit_frame(struct sk_buff *skb,
+				   struct xsc_sq *sq,
+				   struct xsc_tx_wqe *wqe,
+				   u16 pi)
+{
+	struct xsc_core_device *xdev = sq->cq.xdev;
+	struct xsc_sq_stats *stats = sq->stats;
+	struct xsc_send_wqe_ctrl_seg *cseg;
+	struct xsc_wqe_data_seg *dseg;
+	struct xsc_tx_wqe_info *wi;
+	u16 mss, ihs, headlen;
+	u32 num_bytes;
+	u8 num_wqebbs;
+	int num_dma;
+	u16 ds_cnt;
+	u8 opcode;
+
+retry_send:
+	/* Calc ihs and ds cnt, no writes to wqe yet; ctrl-ds is reduced by
+	 * ds_data_num.
+	 */
+	ds_cnt = XSC_SEND_WQEBB_CTRL_NUM_DS;
+
+	if (skb_is_gso(skb)) {
+		opcode		= XSC_OPCODE_RAW;
+		mss		= skb_shinfo(skb)->gso_size;
+		ihs		= xsc_tx_get_gso_ihs(sq, skb);
+		num_bytes	= skb->len +
+				  (skb_shinfo(skb)->gso_segs - 1) * ihs;
+		stats->packets	+= skb_shinfo(skb)->gso_segs;
+	} else {
+		opcode		= XSC_OPCODE_RAW;
+		mss		= 0;
+		ihs		= 0;
+		num_bytes	= skb->len;
+		stats->packets++;
+	}
+
+	/*linear data in skb*/
+	headlen = skb->len - skb->data_len;
+	ds_cnt += !!headlen;
+	ds_cnt += skb_shinfo(skb)->nr_frags;
+
+	/* Check packet size. */
+	if (unlikely(mss == 0 && skb->len > sq->hw_mtu))
+		goto err_drop;
+
+	num_wqebbs = DIV_ROUND_UP(ds_cnt, xdev->caps.send_ds_num);
+	/*if ds_cnt exceed one wqe, drop it*/
+	if (num_wqebbs != 1) {
+		if (skb_linearize(skb))
+			goto err_drop;
+		goto retry_send;
+	}
+
+	/* fill wqe */
+	wi   = (struct xsc_tx_wqe_info *)&sq->db.wqe_info[pi];
+	cseg = &wqe->ctrl;
+	dseg = &wqe->data[0];
+
+	if (unlikely(skb->len == 0))
+		goto err_drop;
+
+	xsc_txwqe_build_csegs(sq, skb, mss, ihs, headlen,
+			      opcode, ds_cnt, skb->len, cseg);
+
+	/*inline header is also use dma to transport*/
+	num_dma = xsc_txwqe_build_dsegs(sq, skb, ihs, headlen, dseg);
+	if (unlikely(num_dma < 0))
+		goto err_drop;
+
+	xsc_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
+			   num_dma, wi);
+	stats->bytes     += num_bytes;
+
+	return NETDEV_TX_OK;
+
+err_drop:
+	stats->dropped++;
+	dev_kfree_skb_any(skb);
+
+	return NETDEV_TX_OK;
+}
+
+netdev_tx_t xsc_eth_xmit_start(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+	struct xsc_tx_wqe *wqe;
+	struct xsc_sq *sq;
+	u32 ds_num;
+	u16 pi;
+
+	if (!adapter->opened)
+		return NETDEV_TX_BUSY;
+
+	sq = adapter->txq2sq[skb_get_queue_mapping(skb)];
+	if (unlikely(!sq))
+		return NETDEV_TX_BUSY;
+
+	ds_num = adapter->xdev->caps.send_ds_num;
+	wqe = xsc_sq_fetch_wqe(sq, ds_num * XSC_SEND_WQE_DS, &pi);
+
+	return xsc_eth_xmit_frame(skb, sq, wqe, pi);
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
new file mode 100644
index 000000000..228070851
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "xsc_eth_common.h"
+#include "xsc_eth_txrx.h"
+
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
+static bool xsc_channel_no_affinity_change(struct xsc_channel *c)
+{
+	int current_cpu = smp_processor_id();
+
+	return cpumask_test_cpu(current_cpu, c->aff_mask);
+}
+
+static void xsc_dump_error_sqcqe(struct xsc_sq *sq,
+				 struct xsc_cqe *cqe)
+{
+	struct net_device *netdev = sq->channel->netdev;
+	u32 ci = xsc_cqwq_get_ci(&sq->cq.wq);
+
+	net_err_ratelimited("Err cqe on dev %s cqn=0x%x ci=0x%x sqn=0x%x err_code=0x%x qpid=0x%lx\n",
+			    netdev->name, sq->cq.xcq.cqn, ci,
+			    sq->sqn, get_cqe_opcode(cqe),
+			    FIELD_GET(XSC_CQE_QP_ID_MASK,
+				      le32_to_cpu(cqe->data0)));
+}
+
+static bool xsc_poll_tx_cq(struct xsc_cq *cq, int napi_budget)
+{
+	struct xsc_adapter *adapter;
+	struct xsc_cqe *cqe;
+	struct device *dev;
+	struct xsc_sq *sq;
+	u32 dma_fifo_cc;
+	u32 nbytes = 0;
+	u16 npkts = 0;
+	int i = 0;
+	u16 sqcc;
+
+	sq = container_of(cq, struct xsc_sq, cq);
+	if (!test_bit(XSC_ETH_SQ_STATE_ENABLED, &sq->state))
+		return false;
+
+	adapter = sq->channel->adapter;
+	dev = adapter->dev;
+
+	cqe = xsc_cqwq_get_cqe(&cq->wq);
+	if (!cqe)
+		goto out;
+
+	if (unlikely(get_cqe_opcode(cqe) & BIT(7))) {
+		xsc_dump_error_sqcqe(sq, cqe);
+		return false;
+	}
+
+	sqcc = sq->cc;
+
+	/* avoid dirtying sq cache line every cqe */
+	dma_fifo_cc = sq->dma_fifo_cc;
+	i = 0;
+	do {
+		struct xsc_tx_wqe_info *wi;
+		struct sk_buff *skb;
+		int j;
+		u16 ci;
+
+		xsc_cqwq_pop(&cq->wq);
+
+		ci = xsc_wq_cyc_ctr2ix(&sq->wq, sqcc);
+		wi = &sq->db.wqe_info[ci];
+		skb = wi->skb;
+
+		/*cqe may be overstanding in real test, not by nop in other*/
+		if (unlikely(!skb))
+			continue;
+
+		for (j = 0; j < wi->num_dma; j++) {
+			struct xsc_sq_dma *dma = xsc_dma_get(sq, dma_fifo_cc++);
+
+			xsc_tx_dma_unmap(dev, dma);
+		}
+
+		npkts++;
+		nbytes += wi->num_bytes;
+		sqcc += wi->num_wqebbs;
+		napi_consume_skb(skb, 0);
+
+	} while ((++i <= napi_budget) && (cqe = xsc_cqwq_get_cqe(&cq->wq)));
+
+	xsc_cq_notify_hw(cq);
+
+	/* ensure cq space is freed before enabling more cqes */
+	wmb();
+
+	sq->dma_fifo_cc = dma_fifo_cc;
+	sq->cc = sqcc;
+
+	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
+
+	if (netif_tx_queue_stopped(sq->txq) &&
+	    xsc_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room)) {
+		netif_tx_wake_queue(sq->txq);
+	}
+
+out:
+	return (i == napi_budget);
+}
+
+int xsc_eth_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct xsc_channel *c = container_of(napi, struct xsc_channel, napi);
+	struct xsc_eth_params *params = &c->adapter->nic_param;
+	bool busy = false;
+	int tx_budget;
+
+	rcu_read_lock();
+
+	tx_budget = params->sq_size >> 2;
+	busy |= xsc_poll_tx_cq(&c->qp.sq.cq, tx_budget);
+
+	if (busy) {
+		if (likely(xsc_channel_no_affinity_change(c))) {
+			rcu_read_unlock();
+			return budget;
+		}
+	}
+
+	if (unlikely(!napi_complete_done(napi, 0)))
+		goto err_out;
+
+	xsc_cq_notify_hw_rearm(&c->qp.sq.cq);
+err_out:
+	rcu_read_unlock();
+	return 0;
+}
