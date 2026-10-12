Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7A046AECF
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805470; cv=none; b=Z5QYtReKyrCVkYf97hRO4bn/WKjGA+7rM+D9hmNMsd0Y2tpr3Oh5VRsb8NNs7JWwKA7oEo4Rd4wcHzpCDXq3eaYAR8UZa5NYebsfndwoI/gJkcrZJJBiQNIxxDxCtyuz8Udj8WtlSQ8rTjeJzAfhTfUIY8NI8eyPBuhUaG3OD5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805470; c=relaxed/simple;
	bh=O0hB9zAqD2At4usvU6f/RDNkQM+f5kc6HsejRqXifyk=;
	h=Subject:Message-Id:In-Reply-To:Cc:Mime-Version:References:
	 Content-Type:To:From:Date; b=RfsEDjt8r3Ckiz8zAW3FpmjmE27lp9jGg2gutiSsAoww8P9Wut0LBBpSFB3OkUmtZDS2wpT1OaTccm5djgJagZnG8Xr9HPrvXb6m8w4LyI3cw0ehFmm+9FVYzowYRE0BU5AsJZkDPIpNMTjtEvCk3msPKKJsZX/n6U5F8aonNjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=WE9vZ1Tc; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="WE9vZ1Tc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805454; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=hEhA3hI8Erc4BQy3s8DPFF5sbpkaFwf2/PgX0orQLPo=;
 b=WE9vZ1TcR2gjNavqG21HFk0IRzxEuvE2+esha6VQ5FRhSeTC0XTW9pzCczeuJUqgTuu07F
 VOtLb30YoK3yxRMev9pmsos2c6l1/0rby901p7aFZGpHsztrtg/DzR4Bf4am0/cL57HKYo
 KBlBkSaxbjdXR08ZuzJqNzD7oNmK9UPG2V4ZdxnT9vaIHcx0au12fRpp0FvfCbICO4/B6x
 hy2bSFBJO+N8EZJlJuQiICHVd7+w5HKa6X98zkDDsjtbyRYGf8g76IXphw5gp9zY6uGKSd
 GGSGdtLbmdJMUinLjJwisVNecWIe7hDxIjHV5WWvroI4i2bte20Fz/QQzpCNDA==
Subject: [PATCH 08/15] yunsilicon: add ethernet RX path and statistics
Message-Id: <20261012114410.2471317-9-tianx@yunsilicon.com>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
X-Lms-Return-Path: <lba+26accc80c+61f0dd+vger.kernel.org+tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Date: Mon, 12 Oct 2026 19:44:11 +0800
X-Mailer: git-send-email 2.25.1
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:11 +0800

Add the receive path: RX queues backed by page_pool, the NAPI poll loop,
CQ processing and the RSS/checksum handling.  The channel layer now
opens the RQ/CQ pairs as well, and the driver advertises RX checksum and
hash offloads.  Also report the per-channel software counters through
ndo_get_stats64.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 367 +++++++++++-
 .../ethernet/yunsilicon/xsc/net/xsc_eth_rx.c  | 551 ++++++++++++++++++
 .../yunsilicon/xsc/net/xsc_eth_stats.c        |  39 ++
 .../yunsilicon/xsc/net/xsc_eth_txrx.c         |  17 +-
 5 files changed, 971 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.c

diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
index ffb819884..43d049e42 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc_eth.o
 
-xsc_eth-y := main.o xsc_eth_wq.o xsc_eth_txrx.o xsc_eth_tx.o
+xsc_eth-y := main.o xsc_eth_wq.o xsc_eth_txrx.o xsc_eth_tx.o xsc_eth_rx.o xsc_eth_stats.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
index a20d01618..d1f72043f 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -691,6 +691,14 @@ static int xsc_eth_open_channel(struct xsc_adapter *adapter,
 static int xsc_eth_modify_qps_channel(struct xsc_adapter *adapter,
 				      struct xsc_channel *c)
 {
+	int ret;
+
+	c->qp.rq.post_wqes(&c->qp.rq);
+	ret = xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.rq.rqn,
+					    XSC_CMD_OP_RTR2RTS_QP);
+	if (ret)
+		return ret;
+
 	return xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.sq.sqn,
 					     XSC_CMD_OP_RTR2RTS_QP);
 }
@@ -712,8 +720,332 @@ static int xsc_eth_modify_qps(struct xsc_adapter *adapter,
 	return 0;
 }
 
+static void xsc_eth_init_frags_partition(struct xsc_rq *rq)
+{
+	struct xsc_wqe_frag_info next_frag = {};
+	struct xsc_wqe_frag_info *prev;
+	int i;
+
+	next_frag.di = &rq->wqe.di[0];
+	next_frag.offset = 0;
+	prev = NULL;
+
+	for (i = 0; i < xsc_wq_cyc_get_size(&rq->wqe.wq); i++) {
+		struct xsc_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+		struct xsc_wqe_frag_info *frag =
+			&rq->wqe.frags[i << rq->wqe.info.log_num_frags];
+		int f;
+
+		for (f = 0; f < rq->wqe.info.num_frags; f++, frag++) {
+			if (next_frag.offset + frag_info[f].frag_stride >
+				XSC_RX_FRAG_SZ) {
+				next_frag.di++;
+				next_frag.offset = 0;
+				if (prev)
+					prev->last_in_page = 1;
+			}
+			*frag = next_frag;
+
+			/* prepare next */
+			next_frag.offset += frag_info[f].frag_stride;
+			prev = frag;
+		}
+	}
+
+	if (prev)
+		prev->last_in_page = 1;
+}
+
+static int xsc_eth_init_di_list(struct xsc_rq *rq, u32 wq_sz, int cpu)
+{
+	int len = wq_sz << rq->wqe.info.log_num_frags;
+
+	rq->wqe.di = kvzalloc_node(array_size(len, sizeof(*rq->wqe.di)),
+				   GFP_KERNEL, cpu_to_node(cpu));
+	if (!rq->wqe.di)
+		return -ENOMEM;
+
+	xsc_eth_init_frags_partition(rq);
+
+	return 0;
+}
+
+static void xsc_eth_free_di_list(struct xsc_rq *rq)
+{
+	kvfree(rq->wqe.di);
+}
+
+static int xsc_eth_alloc_rq(struct xsc_channel *c,
+			    struct xsc_rq *prq,
+			    struct xsc_rq_param *prq_param)
+{
+	u8 ele_log_size = prq_param->rq_attr.ele_log_size;
+	u8 q_log_size = prq_param->rq_attr.q_log_size;
+	struct page_pool_params pagepool_params = {0};
+	struct xsc_adapter *adapter = c->adapter;
+	struct xsc_channel_stats *channel_stats;
+	u32 pool_size = 1 << q_log_size;
+	struct xsc_stats *stats;
+	int ret = 0;
+	u32 wq_sz;
+	int i, f;
+
+	stats = c->adapter->stats;
+	channel_stats = &stats->channel_stats[c->chl_idx];
+	prq->stats = &channel_stats->rq;
+	prq_param->wq.db_numa_node = cpu_to_node(c->cpu);
+
+	ret = xsc_eth_wq_cyc_create(c->adapter->xdev, &prq_param->wq,
+				    q_log_size, ele_log_size, &prq->wqe.wq,
+				    &prq->wq_ctrl);
+	if (ret)
+		return ret;
+
+	wq_sz = xsc_wq_cyc_get_size(&prq->wqe.wq);
+
+	prq->wqe.info = prq_param->frags_info;
+	prq->wqe.frags =
+		kvzalloc_node(array_size((wq_sz << prq->wqe.info.log_num_frags),
+					 sizeof(*prq->wqe.frags)),
+			      GFP_KERNEL,
+			      cpu_to_node(c->cpu));
+	if (!prq->wqe.frags) {
+		ret = -ENOMEM;
+		goto err_destroy_wq;
+	}
+
+	ret = xsc_eth_init_di_list(prq, wq_sz, c->cpu);
+	if (ret)
+		goto err_free_frags;
+
+	prq->buff.map_dir = DMA_FROM_DEVICE;
+
+	/* Create a page_pool and register it with rxq */
+	pool_size = wq_sz << prq->wqe.info.log_num_frags;
+	pagepool_params.order = XSC_RX_FRAG_SZ_ORDER;
+	pagepool_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pagepool_params.pool_size = pool_size;
+	pagepool_params.nid = cpu_to_node(c->cpu);
+	pagepool_params.dev = c->adapter->dev;
+	pagepool_params.dma_dir	= prq->buff.map_dir;
+	pagepool_params.max_len = PAGE_SIZE;
+
+	prq->page_pool = page_pool_create(&pagepool_params);
+	if (IS_ERR(prq->page_pool)) {
+		ret = PTR_ERR(prq->page_pool);
+		prq->page_pool = NULL;
+		goto err_free_di_list;
+	}
+
+	if (c->chl_idx == 0)
+		netdev_dbg(adapter->netdev,
+			   "page pool: size=%d, cpu=%d, pool_numa=%d, mtu=%d, wqe_numa=%d\n",
+			   pool_size, c->cpu, pagepool_params.nid,
+			   adapter->nic_param.mtu,
+			   prq_param->wq.buf_numa_node);
+
+	for (i = 0; i < wq_sz; i++) {
+		struct xsc_eth_rx_wqe_cyc *wqe =
+			xsc_wq_cyc_get_wqe(&prq->wqe.wq, i);
+
+		for (f = 0; f < prq->wqe.info.num_frags; f++) {
+			u32 frag_size = prq->wqe.info.arr[f].frag_size;
+			u32 val = 0;
+
+			val |= FIELD_PREP(XSC_WQE_DATA_SEG_SEG_LEN_MASK,
+					  frag_size);
+			wqe->data[f].data0 = cpu_to_le32(val);
+			wqe->data[f].mkey = cpu_to_le32(XSC_INVALID_LKEY);
+		}
+
+		for (; f < prq->wqe.info.frags_max_num; f++) {
+			wqe->data[f].data0 = 0;
+			wqe->data[f].mkey = cpu_to_le32(XSC_INVALID_LKEY);
+			wqe->data[f].va = 0;
+		}
+	}
+
+	prq->post_wqes = xsc_eth_post_rx_wqes;
+	prq->handle_rx_cqe = xsc_eth_handle_rx_cqe;
+	prq->dealloc_wqe = xsc_eth_dealloc_rx_wqe;
+	prq->wqe.skb_from_cqe = xsc_rx_is_linear_skb(adapter->nic_param.mtu) ?
+					xsc_skb_from_cqe_linear :
+					xsc_skb_from_cqe_nonlinear;
+	prq->ix = c->chl_idx;
+	prq->frags_sz = adapter->nic_param.rq_frags_size;
+
+	return 0;
+
+err_free_di_list:
+	xsc_eth_free_di_list(prq);
+err_free_frags:
+	kvfree(prq->wqe.frags);
+err_destroy_wq:
+	xsc_eth_wq_destroy(&prq->wq_ctrl);
+	return ret;
+}
+
+static void xsc_free_qp_rq(struct xsc_rq *rq)
+{
+	kvfree(rq->wqe.frags);
+	kvfree(rq->wqe.di);
+
+	if (rq->page_pool)
+		page_pool_destroy(rq->page_pool);
+
+	xsc_eth_wq_destroy(&rq->wq_ctrl);
+}
+
+static int xsc_eth_open_rss_qp_rqs(struct xsc_adapter *adapter,
+				   struct xsc_rq_param *prq_param,
+				   struct xsc_eth_channels *chls,
+				   unsigned int num_chl)
+{
+	u8 q_log_size = prq_param->rq_attr.q_log_size;
+	struct xsc_create_multiqp_mbox_in *in;
+	struct xsc_create_qp_request *req;
+	unsigned int hw_npages;
+	struct xsc_channel *c;
+	int ret = 0, err = 0;
+	struct xsc_rq *prq;
+	int paslen = 0;
+	int entry_len;
+	u32 rqn_base;
+	int i, n;
+	int inlen;
+
+	for (i = 0; i < num_chl; i++) {
+		c = &chls->c[i];
+		prq = &c->qp.rq;
+
+		ret = xsc_eth_alloc_rq(c, prq, prq_param);
+		if (ret)
+			goto err_alloc_rqs;
+
+		hw_npages = DIV_ROUND_UP(prq->wq_ctrl.buf.size, PAGE_SIZE_4K);
+		/*support different npages number smoothly*/
+		entry_len = sizeof(struct xsc_create_qp_request) +
+			sizeof(__be64) * hw_npages;
+
+		paslen += entry_len;
+	}
+
+	inlen = sizeof(struct xsc_create_multiqp_mbox_in) + paslen;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		ret = -ENOMEM;
+		goto err_create_rss_rqs;
+	}
+
+	in->qp_num = cpu_to_be16(num_chl);
+	in->qp_type = XSC_QUEUE_TYPE_RAW;
+	in->req_len = cpu_to_be32(inlen);
+
+	req = (struct xsc_create_qp_request *)&in->data[0];
+	n = 0;
+	for (i = 0; i < num_chl; i++) {
+		c = &chls->c[i];
+		prq = &c->qp.rq;
+
+		hw_npages = DIV_ROUND_UP(prq->wq_ctrl.buf.size, PAGE_SIZE_4K);
+		/* no use for eth */
+		req->input_qpn = cpu_to_be16(0);
+		req->qp_type = XSC_QUEUE_TYPE_RAW;
+		req->log_rq_sz = ilog2(adapter->xdev->caps.recv_ds_num)
+					+ q_log_size;
+		req->pa_num = cpu_to_be16(hw_npages);
+		req->cqn_recv = cpu_to_be16(prq->cq.xcq.cqn);
+		req->cqn_send = req->cqn_recv;
+		req->glb_funcid = cpu_to_be16(adapter->xdev->glb_func_id);
+
+		xsc_core_fill_page_frag_array(&prq->wq_ctrl.buf,
+					      &req->pas[0], hw_npages);
+		n++;
+		entry_len = sizeof(struct xsc_create_qp_request) +
+			sizeof(__be64) * hw_npages;
+		req = (struct xsc_create_qp_request *)
+			((u8 *)req + entry_len);
+	}
+
+	ret = xsc_core_eth_create_rss_qp_rqs(adapter->xdev, in, inlen,
+					     &rqn_base);
+	kvfree(in);
+	if (ret)
+		goto err_create_rss_rqs;
+
+	n = 0;
+	for (i = 0; i < num_chl; i++) {
+		c = &chls->c[i];
+		prq = &c->qp.rq;
+
+		prq->rqn = rqn_base + n;
+		prq->cqp.qpn = prq->rqn;
+		prq->cqp.event = xsc_eth_qp_event;
+		prq->cqp.eth_queue_type = XSC_RES_RQ;
+		ret = xsc_core_create_resource_common(adapter->xdev,
+						      &prq->cqp);
+		if (ret) {
+			err = ret;
+			netdev_err(adapter->netdev,
+				   "create resource common error qp:%d errno:%d\n",
+				   prq->rqn, ret);
+			continue;
+		}
+
+		n++;
+	}
+	if (err)
+		return err;
+
+	adapter->channels.rqn_base = rqn_base;
+	return 0;
+
+err_create_rss_rqs:
+	i = num_chl;
+err_alloc_rqs:
+	for (--i; i >= 0; i--) {
+		c = &chls->c[i];
+		xsc_free_qp_rq(&c->qp.rq);
+	}
+	return ret;
+}
+
+static void xsc_eth_free_rx_wqe(struct xsc_rq *rq)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	u16 wqe_ix;
+
+	while (!xsc_wq_cyc_is_empty(wq)) {
+		wqe_ix = xsc_wq_cyc_get_tail(wq);
+		rq->dealloc_wqe(rq, wqe_ix);
+		xsc_wq_cyc_pop(wq);
+	}
+}
+
+static int xsc_eth_close_qp_rq(struct xsc_channel *c, struct xsc_rq *prq)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+	int ret;
+
+	xsc_core_destroy_resource_common(xdev, &prq->cqp);
+
+	ret = xsc_core_eth_destroy_qp(xdev, prq->cqp.qpn);
+	if (ret)
+		return ret;
+
+	xsc_eth_free_rx_wqe(prq);
+	xsc_free_qp_rq(prq);
+
+	return 0;
+}
+
 static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
 {
+	if (free_rq)
+		xsc_eth_close_qp_rq(c, &c->qp.rq);
+	xsc_eth_close_cq(c, &c->qp.rq.cq);
+	memset(&c->qp.rq, 0, sizeof(struct xsc_rq));
+
 	xsc_eth_close_qp_sq(c, &c->qp.sq);
 	xsc_eth_close_cq(c, &c->qp.sq.cq);
 
@@ -725,6 +1057,7 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
 	struct xsc_eth_channels *chls = &adapter->channels;
 	struct xsc_core_device *xdev = adapter->xdev;
 	struct xsc_channel_param *chl_param;
+	bool free_rq = false;
 	int ret = 0;
 	int i;
 
@@ -750,6 +1083,14 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
 			goto err_close_channel;
 	}
 
+	ret = xsc_eth_open_rss_qp_rqs(adapter,
+				      &chl_param->rq_param,
+				      chls,
+				      chls->num_chl);
+	if (ret)
+		goto err_close_channel;
+	free_rq = true;
+
 	for (i = 0; i < chls->num_chl; i++)
 		napi_enable(&chls->c[i].napi);
 
@@ -765,7 +1106,7 @@ static int xsc_eth_open_channels(struct xsc_adapter *adapter)
 
 err_close_channel:
 	for (--i; i >= 0; i--)
-		xsc_eth_close_channel(&chls->c[i], false);
+		xsc_eth_close_channel(&chls->c[i], free_rq);
 
 	kvfree(chl_param);
 err_free_ch:
@@ -820,13 +1161,25 @@ static void xsc_eth_deactivate_txqsq(struct xsc_channel *c)
 	clear_bit(XSC_ETH_SQ_STATE_ENABLED, &c->qp.sq.state);
 }
 
+static void xsc_activate_rq(struct xsc_channel *c)
+{
+	set_bit(XSC_ETH_RQ_STATE_ENABLED, &c->qp.rq.state);
+}
+
+static void xsc_deactivate_rq(struct xsc_channel *c)
+{
+	clear_bit(XSC_ETH_RQ_STATE_ENABLED, &c->qp.rq.state);
+}
+
 static void xsc_eth_activate_channel(struct xsc_channel *c)
 {
 	xsc_eth_activate_txqsq(c);
+	xsc_activate_rq(c);
 }
 
 static void xsc_eth_deactivate_channel(struct xsc_channel *c)
 {
+	xsc_deactivate_rq(c);
 	xsc_eth_deactivate_txqsq(c);
 }
 
@@ -1106,6 +1459,14 @@ static int xsc_eth_close(struct net_device *netdev)
 	return ret;
 }
 
+static void xsc_eth_get_stats(struct net_device *netdev,
+			      struct rtnl_link_stats64 *stats)
+{
+	struct xsc_adapter *adapter = netdev_priv(netdev);
+
+	xsc_eth_fold_sw_stats64(adapter, stats);
+}
+
 static int xsc_eth_set_hw_mtu(struct xsc_core_device *xdev,
 			      u16 mtu, u16 rx_buf_sz)
 {
@@ -1137,6 +1498,7 @@ static const struct net_device_ops xsc_netdev_ops = {
 	.ndo_open		= xsc_eth_open,
 	.ndo_stop		= xsc_eth_close,
 	.ndo_start_xmit		= xsc_eth_xmit_start,
+	.ndo_get_stats64	= xsc_eth_get_stats,
 };
 
 static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
@@ -1153,7 +1515,8 @@ static void xsc_eth_build_nic_netdev(struct xsc_adapter *adapter)
 
 	netdev->vlan_features |= NETIF_F_SG |
 				 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_TSO | NETIF_F_TSO6;
+				 NETIF_F_TSO | NETIF_F_TSO6 |
+				 NETIF_F_RXCSUM | NETIF_F_RXHASH;
 
 	netdev->hw_features = netdev->vlan_features;
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
new file mode 100644
index 000000000..3913a9671
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_rx.c
@@ -0,0 +1,551 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd. All
+ * rights reserved.
+ * Copyright (c) 2015-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#include <linux/net_tstamp.h>
+#include <linux/device.h>
+
+#include "xsc_pp.h"
+#include "xsc_eth.h"
+#include "xsc_eth_txrx.h"
+#include "xsc_eth_common.h"
+#include "xsc_pph.h"
+
+static void xsc_rq_notify_hw(struct xsc_rq *rq)
+{
+	struct xsc_core_device *xdev = rq->cq.xdev;
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	u64 rqwqe_id;
+
+	rqwqe_id = wq->wqe_ctr << (ilog2(xdev->caps.recv_ds_num));
+	/* reverse wqe index to ds index */
+	xsc_update_rx_db(xdev, rq->rqn, rqwqe_id);
+}
+
+static void xsc_skb_set_hash(struct xsc_adapter *adapter,
+			     struct xsc_cqe *cqe,
+			     struct sk_buff *skb)
+{
+	struct xsc_rss_params *rss = &adapter->rss_param;
+	bool l3_hash = false;
+	bool l4_hash = false;
+	u32 hash_field;
+	int ht = 0;
+
+	if (adapter->netdev->features & NETIF_F_RXHASH) {
+		if (skb->protocol == htons(ETH_P_IP)) {
+			hash_field = rss->rx_hash_fields[XSC_TT_IPV4_TCP];
+			if (hash_field & XSC_HASH_FIELD_SEL_SRC_IP ||
+			    hash_field & XSC_HASH_FIELD_SEL_DST_IP)
+				l3_hash = true;
+
+			if (hash_field & XSC_HASH_FIELD_SEL_SPORT ||
+			    hash_field & XSC_HASH_FIELD_SEL_DPORT)
+				l4_hash = true;
+		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+			hash_field = rss->rx_hash_fields[XSC_TT_IPV6_TCP];
+			if (hash_field & XSC_HASH_FIELD_SEL_SRC_IPV6 ||
+			    hash_field & XSC_HASH_FIELD_SEL_DST_IPV6)
+				l3_hash = true;
+
+			if (hash_field & XSC_HASH_FIELD_SEL_SPORT_V6 ||
+			    hash_field & XSC_HASH_FIELD_SEL_DPORT_V6)
+				l4_hash = true;
+		}
+
+		if (l3_hash && l4_hash)
+			ht = PKT_HASH_TYPE_L4;
+		else if (l3_hash)
+			ht = PKT_HASH_TYPE_L3;
+		if (ht)
+			skb_set_hash(skb, le32_to_cpu(cqe->vni), ht);
+	}
+}
+
+static void xsc_handle_csum(struct xsc_cqe *cqe, struct xsc_rq *rq,
+			    struct sk_buff *skb, struct xsc_wqe_frag_info *wi)
+{
+	struct xsc_dma_info *dma_info;
+	struct net_device *netdev;
+	void *hw_pph;
+	struct xsc_channel *c;
+	int offset_from;
+
+	c = rq->cq.channel;
+	netdev = c->adapter->netdev;
+	dma_info = wi->di;
+	offset_from = wi->offset;
+	hw_pph = page_address(dma_info->page) + offset_from;
+
+	if (unlikely((netdev->features & NETIF_F_RXCSUM) == 0))
+		goto csum_none;
+
+	if (unlikely(XSC_GET_EPP2SOC_PPH_ERROR_BITMAP(hw_pph) & PACKET_UNKNOWN))
+		goto csum_none;
+
+	if (XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(hw_pph) &&
+	    (!(FIELD_GET(XSC_CQE_CSUM_ERR_MASK, le32_to_cpu(cqe->data0)) &
+	       OUTER_AND_INNER))) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->csum_level = 1;
+		skb->encapsulation = 1;
+	} else if (XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(hw_pph) &&
+		   (!(FIELD_GET(XSC_CQE_CSUM_ERR_MASK,
+				le32_to_cpu(cqe->data0)) &
+		      OUTER_BIT) &&
+		    (FIELD_GET(XSC_CQE_CSUM_ERR_MASK,
+			       le32_to_cpu(cqe->data0)) &
+		     INNER_BIT))) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->csum_level = 0;
+		skb->encapsulation = 1;
+	} else if (!XSC_GET_EPP2SOC_PPH_EXT_TUNNEL_TYPE(hw_pph) &&
+		   (!(FIELD_GET(XSC_CQE_CSUM_ERR_MASK,
+				le32_to_cpu(cqe->data0)) &
+		      OUTER_BIT))) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+
+	goto out;
+
+csum_none:
+	skb->csum = 0;
+	skb->ip_summed = CHECKSUM_NONE;
+out:
+	return;
+}
+
+static void xsc_build_rx_skb(struct xsc_cqe *cqe,
+			     u32 cqe_bcnt,
+			     struct xsc_rq *rq,
+			     struct sk_buff *skb,
+			     struct xsc_wqe_frag_info *wi)
+{
+	struct xsc_adapter *adapter;
+	struct net_device *netdev;
+	struct xsc_channel *c;
+
+	c = rq->cq.channel;
+	adapter = c->adapter;
+	netdev = c->netdev;
+
+	skb->mac_len = ETH_HLEN;
+
+	skb_record_rx_queue(skb, rq->ix);
+	xsc_handle_csum(cqe, rq, skb, wi);
+
+	skb->protocol = eth_type_trans(skb, netdev);
+	xsc_skb_set_hash(adapter, cqe, skb);
+}
+
+static void xsc_complete_rx_cqe(struct xsc_rq *rq,
+				struct xsc_cqe *cqe,
+				u32 cqe_bcnt,
+				struct sk_buff *skb,
+				struct xsc_wqe_frag_info *wi)
+{
+	struct xsc_rq_stats *stats = rq->stats;
+
+	stats->packets++;
+	stats->bytes += cqe_bcnt;
+	xsc_build_rx_skb(cqe, cqe_bcnt, rq, skb, wi);
+}
+
+static void xsc_add_skb_frag(struct xsc_rq *rq,
+			     struct sk_buff *skb,
+			     struct xsc_dma_info *di,
+			     u32 frag_offset, u32 len,
+			     unsigned int truesize)
+{
+	struct xsc_channel *c = rq->cq.channel;
+	struct device *dev = c->adapter->dev;
+
+	dma_sync_single_for_cpu(dev, di->addr + frag_offset,
+				len, DMA_FROM_DEVICE);
+	page_ref_inc(di->page);
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			di->page, frag_offset, len, truesize);
+}
+
+static void xsc_copy_skb_header(struct device *dev,
+				struct sk_buff *skb,
+				struct xsc_dma_info *dma_info,
+				int offset_from, u32 headlen)
+{
+	void *from = page_address(dma_info->page) + offset_from;
+	/* Aligning len to sizeof(long) optimizes memcpy performance */
+	unsigned int len = ALIGN(headlen, sizeof(long));
+
+	dma_sync_single_for_cpu(dev, dma_info->addr + offset_from, len,
+				DMA_FROM_DEVICE);
+	skb_copy_to_linear_data(skb, from, len);
+}
+
+static struct sk_buff *xsc_build_linear_skb(struct xsc_rq *rq, void *va,
+					    u32 frag_size, u16 headroom,
+					    u32 cqe_bcnt)
+{
+	struct sk_buff *skb = build_skb(va, frag_size);
+
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, cqe_bcnt);
+
+	return skb;
+}
+
+struct sk_buff *xsc_skb_from_cqe_linear(struct xsc_rq *rq,
+					struct xsc_wqe_frag_info *wi,
+					u32 cqe_bcnt, u8 has_pph)
+{
+	int pph_len = has_pph ? XSC_PPH_HEAD_LEN : 0;
+	u16 rx_headroom = rq->buff.headroom;
+	struct xsc_dma_info *di = wi->di;
+	struct sk_buff *skb;
+	void *va, *data;
+	u32 frag_size;
+
+	va = page_address(di->page) + wi->offset;
+	data = va + rx_headroom + pph_len;
+	frag_size = XSC_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
+
+	dma_sync_single_range_for_cpu(rq->cq.xdev->device, di->addr, wi->offset,
+				      frag_size, DMA_FROM_DEVICE);
+	net_prefetchw(va); /* xdp_frame data area */
+	net_prefetch(data);
+
+	skb = xsc_build_linear_skb(rq, va, frag_size, (rx_headroom + pph_len),
+				   (cqe_bcnt - pph_len));
+	if (unlikely(!skb))
+		return NULL;
+
+	/* queue up for recycling/reuse */
+	page_ref_inc(di->page);
+
+	return skb;
+}
+
+struct sk_buff *xsc_skb_from_cqe_nonlinear(struct xsc_rq *rq,
+					   struct xsc_wqe_frag_info *wi,
+					   u32 cqe_bcnt, u8 has_pph)
+{
+	struct xsc_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+	u16 headlen  = min_t(u32, XSC_RX_MAX_HEAD, cqe_bcnt);
+	struct xsc_wqe_frag_info *head_wi = wi;
+	struct xsc_wqe_frag_info *rx_wi = wi;
+	u16 head_offset = head_wi->offset;
+	u16 byte_cnt = cqe_bcnt - headlen;
+	u16 frag_consumed_bytes = 0;
+	u16 frag_headlen = headlen;
+	struct net_device *netdev;
+	struct xsc_channel *c;
+	struct sk_buff *skb;
+	struct device *dev;
+	u8 fragcnt = 0;
+	int i = 0;
+
+	c = rq->cq.channel;
+	dev = c->adapter->dev;
+	netdev = c->adapter->netdev;
+
+	skb = napi_alloc_skb(rq->cq.napi, ALIGN(XSC_RX_MAX_HEAD, sizeof(long)));
+	if (unlikely(!skb))
+		return NULL;
+
+	net_prefetchw(skb->data);
+
+	if (likely(has_pph)) {
+		headlen = min_t(u32, XSC_RX_MAX_HEAD,
+				(cqe_bcnt - XSC_PPH_HEAD_LEN));
+		frag_headlen = headlen + XSC_PPH_HEAD_LEN;
+		byte_cnt = cqe_bcnt - headlen - XSC_PPH_HEAD_LEN;
+		head_offset += XSC_PPH_HEAD_LEN;
+	}
+
+	for (i = 0; i < rq->wqe.info.num_frags; i++, rx_wi++)
+		rx_wi->is_available = 0;
+
+	while (byte_cnt) {
+		/*figure out whether the first fragment can be a page ?*/
+		frag_consumed_bytes =
+			min_t(u16, frag_info->frag_size - frag_headlen,
+			      byte_cnt);
+
+		xsc_add_skb_frag(rq, skb, wi->di, wi->offset + frag_headlen,
+				 frag_consumed_bytes, frag_info->frag_stride);
+		byte_cnt -= frag_consumed_bytes;
+
+		/*to protect extend wqe read, drop exceed bytes*/
+		frag_headlen = 0;
+		fragcnt++;
+		if (fragcnt == rq->wqe.info.num_frags) {
+			if (byte_cnt) {
+				netdev_warn(netdev,
+					    "large packet reach the maximum rev-wqe num.\n");
+				netdev_warn(netdev,
+					    "%u bytes dropped: frag_num=%d, headlen=%d, cqe_cnt=%d, frag0_bytes=%d, frag_size=%d\n",
+					    byte_cnt, fragcnt,
+					    headlen, cqe_bcnt,
+					    frag_consumed_bytes,
+					    frag_info->frag_size);
+			}
+			break;
+		}
+
+		frag_info++;
+		wi++;
+	}
+
+	/* copy header */
+	xsc_copy_skb_header(dev, skb, head_wi->di, head_offset, headlen);
+
+	/* skb linear part was allocated with headlen and aligned to long */
+	skb->tail += headlen;
+	skb->len += headlen;
+
+	return skb;
+}
+
+static void xsc_put_rx_frag(struct xsc_rq *rq,
+			    struct xsc_wqe_frag_info *frag, bool recycle)
+{
+	if (frag->last_in_page)
+		page_pool_recycle_direct(rq->page_pool, frag->di->page);
+}
+
+static struct xsc_wqe_frag_info *get_frag(struct xsc_rq *rq, u16 ix)
+{
+	return &rq->wqe.frags[ix << rq->wqe.info.log_num_frags];
+}
+
+static void xsc_free_rx_wqe(struct xsc_rq *rq,
+			    struct xsc_wqe_frag_info *wi, bool recycle)
+{
+	int i;
+
+	for (i = 0; i < rq->wqe.info.num_frags; i++, wi++) {
+		if (wi->is_available && recycle)
+			continue;
+		xsc_put_rx_frag(rq, wi, recycle);
+	}
+}
+
+static void xsc_dump_error_rqcqe(struct xsc_rq *rq,
+				 struct xsc_cqe *cqe)
+{
+	struct net_device *netdev;
+	struct xsc_channel *c;
+	u32 ci;
+
+	c = rq->cq.channel;
+	netdev  = c->adapter->netdev;
+	ci = xsc_cqwq_get_ci(&rq->cq.wq);
+
+	net_err_ratelimited("Error cqe on dev=%s, cqn=%d, ci=%d, rqn=%d, qpn=%ld, error_code=0x%x\n",
+			    netdev->name, rq->cq.xcq.cqn, ci,
+			    rq->rqn,
+			    FIELD_GET(XSC_CQE_QP_ID_MASK,
+				      le32_to_cpu(cqe->data0)),
+			    get_cqe_opcode(cqe));
+}
+
+void xsc_eth_handle_rx_cqe(struct xsc_cqwq *cqwq,
+			   struct xsc_rq *rq, struct xsc_cqe *cqe)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	u8 cqe_opcode = get_cqe_opcode(cqe);
+	struct xsc_wqe_frag_info *wi;
+	struct sk_buff *skb;
+	u32 cqe_bcnt;
+	u16 ci;
+
+	ci = xsc_wq_cyc_ctr2ix(wq, cqwq->cc);
+	wi = get_frag(rq, ci);
+	if (unlikely(cqe_opcode & BIT(7))) {
+		xsc_dump_error_rqcqe(rq, cqe);
+		goto free_wqe;
+	}
+
+	cqe_bcnt = le32_to_cpu(cqe->msg_len);
+	if ((le32_to_cpu(cqe->data0) & XSC_CQE_HAS_PPH) &&
+	    cqe_bcnt <= XSC_PPH_HEAD_LEN)
+		goto free_wqe;
+
+	if (unlikely(cqe_bcnt > rq->frags_sz))
+		goto free_wqe;
+
+	cqe_bcnt = min_t(u32, cqe_bcnt, rq->frags_sz);
+	skb = rq->wqe.skb_from_cqe(rq, wi, cqe_bcnt,
+				   !!(le32_to_cpu(cqe->data0) &
+				      XSC_CQE_HAS_PPH));
+	if (!skb)
+		goto free_wqe;
+
+	xsc_complete_rx_cqe(rq, cqe,
+			    (le32_to_cpu(cqe->data0) & XSC_CQE_HAS_PPH) ?
+			    cqe_bcnt - XSC_PPH_HEAD_LEN : cqe_bcnt,
+			    skb, wi);
+
+	napi_gro_receive(rq->cq.napi, skb);
+
+free_wqe:
+	xsc_free_rx_wqe(rq, wi, true);
+	xsc_wq_cyc_pop(wq);
+}
+
+int xsc_poll_rx_cq(struct xsc_cq *cq, int budget)
+{
+	struct xsc_rq *rq = container_of(cq, struct xsc_rq, cq);
+	struct xsc_cqwq *cqwq = &cq->wq;
+	struct xsc_cqe *cqe;
+	int work_done = 0;
+
+	if (!test_bit(XSC_ETH_RQ_STATE_ENABLED, &rq->state))
+		return 0;
+
+	while ((work_done < budget) && (cqe = xsc_cqwq_get_cqe(cqwq))) {
+		rq->handle_rx_cqe(cqwq, rq, cqe);
+		++work_done;
+
+		xsc_cqwq_pop(cqwq);
+	}
+
+	if (!work_done)
+		goto out;
+
+	xsc_cq_notify_hw(cq);
+	/* ensure cq space is freed before enabling more cqes */
+	wmb();
+
+out:
+	return work_done;
+}
+
+static int xsc_page_alloc_pool(struct xsc_rq *rq,
+			       struct xsc_dma_info *dma_info)
+{
+	dma_info->page = page_pool_dev_alloc_pages(rq->page_pool);
+	if (unlikely(!dma_info->page))
+		return -ENOMEM;
+	dma_info->addr = page_pool_get_dma_addr(dma_info->page);
+
+	return 0;
+}
+
+static int xsc_get_rx_frag(struct xsc_rq *rq,
+			   struct xsc_wqe_frag_info *frag)
+{
+	int err = 0;
+
+	if (!frag->offset && !frag->is_available)
+		/* On first frag (offset == 0), replenish page (dma_info
+		 * actually). Other frags that point to the same dma_info
+		 * (with a different offset) should just use the new one
+		 * without replenishing again by themselves.
+		 */
+		err = xsc_page_alloc_pool(rq, frag->di);
+
+	return err;
+}
+
+static int xsc_alloc_rx_wqe(struct xsc_rq *rq,
+			    struct xsc_eth_rx_wqe_cyc *wqe,
+			    u16 ix)
+{
+	struct xsc_wqe_frag_info *frag = get_frag(rq, ix);
+	u64 addr;
+	int err;
+	int i;
+
+	for (i = 0; i < rq->wqe.info.num_frags; i++, frag++) {
+		err = xsc_get_rx_frag(rq, frag);
+		if (unlikely(err))
+			goto err_free_frags;
+
+		addr = frag->di->addr + frag->offset + rq->buff.headroom;
+		wqe->data[i].va = cpu_to_le64(addr);
+	}
+
+	return 0;
+
+err_free_frags:
+	while (--i >= 0)
+		xsc_put_rx_frag(rq, --frag, true);
+
+	return err;
+}
+
+void xsc_eth_dealloc_rx_wqe(struct xsc_rq *rq, u16 ix)
+{
+	struct xsc_wqe_frag_info *wi = get_frag(rq, ix);
+
+	xsc_free_rx_wqe(rq, wi, false);
+}
+
+static int xsc_alloc_rx_wqes(struct xsc_rq *rq, u16 ix, u8 wqe_bulk)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	struct xsc_eth_rx_wqe_cyc *wqe;
+	int err;
+	int idx;
+	int i;
+
+	for (i = 0; i < wqe_bulk; i++) {
+		idx = xsc_wq_cyc_ctr2ix(wq, (ix + i));
+		wqe = xsc_wq_cyc_get_wqe(wq, idx);
+
+		err = xsc_alloc_rx_wqe(rq, wqe, idx);
+		if (unlikely(err))
+			goto err_free_wqes;
+	}
+
+	return 0;
+
+err_free_wqes:
+	while (--i >= 0)
+		xsc_eth_dealloc_rx_wqe(rq, ix + i);
+
+	return err;
+}
+
+bool xsc_eth_post_rx_wqes(struct xsc_rq *rq)
+{
+	struct xsc_wq_cyc *wq = &rq->wqe.wq;
+	u8 wqe_bulk, wqe_bulk_min;
+	int err = 0;
+	int alloc;
+	u16 head;
+
+	wqe_bulk = rq->wqe.info.wqe_bulk;
+	wqe_bulk_min = rq->wqe.info.wqe_bulk_min;
+	if (xsc_wq_cyc_missing(wq) < wqe_bulk)
+		return false;
+
+	do {
+		head = xsc_wq_cyc_get_head(wq);
+
+		alloc = min_t(int, wqe_bulk, xsc_wq_cyc_missing(wq));
+		if (alloc < wqe_bulk && alloc >= wqe_bulk_min)
+			alloc = alloc & 0xfffffffe;
+
+		if (alloc > 0) {
+			err = xsc_alloc_rx_wqes(rq, head, alloc);
+			if (unlikely(err))
+				break;
+
+			xsc_wq_cyc_push_n(wq, alloc);
+		}
+	} while (xsc_wq_cyc_missing(wq) >= wqe_bulk_min);
+
+	dma_wmb();
+
+	/* ensure wqes are visible to device before updating doorbell record */
+	xsc_rq_notify_hw(rq);
+
+	return !!err;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.c
new file mode 100644
index 000000000..b466fc1f0
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_stats.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "xsc_eth_stats.h"
+#include "xsc_eth.h"
+
+static int xsc_get_netdev_max_channels(struct xsc_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	return min_t(unsigned int, netdev->num_rx_queues,
+		     netdev->num_tx_queues);
+}
+
+void xsc_eth_fold_sw_stats64(struct xsc_adapter *adapter,
+			     struct rtnl_link_stats64 *s)
+{
+	int i;
+
+	for (i = 0; i < xsc_get_netdev_max_channels(adapter); i++) {
+		struct xsc_channel_stats *channel_stats;
+		struct xsc_rq_stats *rq_stats;
+		struct xsc_sq_stats *sq_stats;
+
+		channel_stats = &adapter->stats->channel_stats[i];
+		rq_stats = &channel_stats->rq;
+		sq_stats = &channel_stats->sq;
+
+		s->rx_packets   += rq_stats->packets;
+		s->rx_bytes     += rq_stats->bytes;
+
+		s->tx_packets    += sq_stats->packets;
+		s->tx_bytes      += sq_stats->bytes;
+		s->tx_dropped    += sq_stats->dropped;
+	}
+}
+
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
index 228070851..3effa79ef 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_txrx.c
@@ -121,7 +121,9 @@ int xsc_eth_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct xsc_channel *c = container_of(napi, struct xsc_channel, napi);
 	struct xsc_eth_params *params = &c->adapter->nic_param;
+	struct xsc_rq *rq = &c->qp.rq;
 	bool busy = false;
+	int work_done = 0;
 	int tx_budget;
 
 	rcu_read_lock();
@@ -129,18 +131,29 @@ int xsc_eth_napi_poll(struct napi_struct *napi, int budget)
 	tx_budget = params->sq_size >> 2;
 	busy |= xsc_poll_tx_cq(&c->qp.sq.cq, tx_budget);
 
+	/* budget=0 means: don't poll rx rings */
+	if (likely(budget)) {
+		work_done = xsc_poll_rx_cq(&rq->cq, budget);
+		busy |= work_done == budget;
+	}
+
+	busy |= rq->post_wqes(rq);
+
 	if (busy) {
 		if (likely(xsc_channel_no_affinity_change(c))) {
 			rcu_read_unlock();
 			return budget;
 		}
+		if (budget && work_done == budget)
+			work_done--;
 	}
 
-	if (unlikely(!napi_complete_done(napi, 0)))
+	if (unlikely(!napi_complete_done(napi, work_done)))
 		goto err_out;
 
 	xsc_cq_notify_hw_rearm(&c->qp.sq.cq);
+	xsc_cq_notify_hw_rearm(&rq->cq);
 err_out:
 	rcu_read_unlock();
-	return 0;
+	return work_done;
 }
