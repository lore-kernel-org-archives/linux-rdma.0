Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705063;
	b=OqxxD1K57cUs6CJbuxpbrAj1lIKEe3BkWahBGcOz3xle1ZGe3F+6Dld61m4vTxlGUJ9P
	 UVl5cN9OxkxrfeevwBk2zMHGrDUPABYrQ4kRaueuRqu/NXQloQW4vLpJX9Wp+tbOWicJc
	 4Gi7NXQPchrTyF9dL2ZQzsBbbexuVXBaQD56werRVga9fHrOfN1YN6UHEZqSws5PAda3x
	 IORE0gfHt+aQmBCr19wAkxDaaXM8Q6nWfV6i32gdXv5A+SLCFPyUm/IhvClGbCurZMSQN
	 GXuRFPvHMo0SR840YNEc0zf0FJikF0KETiM77c0G9xa0whrwiAT3s5zZSbbf9KcEtZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705063;
	h=DMARC-Filter:DKIM-Signature:To:From:Date:Message-Id:References:
	 X-Mailer:In-Reply-To:X-Lms-Return-Path:Content-Type:Subject:Received:
	 Cc:Mime-Version:X-Original-From:Content-Transfer-Encoding;
	bh=RA2VRedfC+WXSHmdn6bDXzUWmkuL3T+63AP2mHD86Xo=;
	b=P+WHjaoY/zkNbA7iW1mOmtQA+JWxm5IsGDTPWN/OI42AT5pKwVr+dXVkfAjrzMXOxZdd
	 DdpNM4V4q/atzEQVvSOlAzRX1uQecKXI8KXsXgVMKqd0xtqi+iB2E3vRSyJ8E9v/uJXs0
	 KDMnUVZcsc42pz7rNYKVSofcmYZ3sSeOLfvb2sEFJ3xdeNdWfCbFGgGItYjtoyMO9j/RH
	 hF4I6SgoTboAzHPFeyJZ2jF+6S2uc+uj9M8eQJV3GuAY7zGdX7XL7zhERaLQf8bKl3Ewp
	 i8UHtrEVEI/QOiwdRcIBroStf4KfA1teM0+stZo+gTDt8VwXfjetFnIuG8sC53oGQtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=fgGexQYn;
	arc=none smtp.remote-ip=209.127.231.41
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32336606A6A3
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32336606A6A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=fgGexQYn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705058; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=RA2VRedfC+WXSHmdn6bDXzUWmkuL3T+63AP2mHD86Xo=;
 b=fgGexQYnWHNpB9VX/vlaTaNErCzpkcpQn+ncKTx1OKGQHHo60kSUZGhr+dgm37ih1fpunP
 GiZXZxyp7lmnoCqu1YuT8+BBRgK550CSa0OxurDy38F0vuYvQf0v1/OU75Ug12DuQtdeI+
 X0ZzadPwhIAQesltf1XGPRsXnGlzcsR4mJScZrVkv1ZlSqZFOsEn9dJ+VLh27+Mu4Y1SJy
 lttoqxlo1bSHG//dBY8bQMC1fWl0jokFH2xEdI3IDq0I+zo3L4Ui0lskJNvU/R76E4BXgk
 QWDOq+/ahKxaA5GQGvLhls2JP6raDDEj78qYquAqIUqgtkBbUGpXsPgwOf4MNA==
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Date: Thu, 26 Nov 2026 22:57:35 +0800
Message-Id: <20261126145733.70868-9-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26b0848e0+dca55a+vger.kernel.org+tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v2 08/11] net/xsc: add the single TX/RX channel
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:35 +0800
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit

Bring up one channel on top of the netdev: build the queue parameters,
create the CQ, SQ and RQ through the core, and enable the NIC HCA so the
channel can move packets. The queue ring helpers and the fragmented
buffer allocation they rely on are added here as well.

The CQ completion callback and NAPI poll are set up by the receive patch
that follows, so the channel cannot move packets yet and the interface
must not be opened in this state.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |   9 +
 .../net/ethernet/yunsilicon/xsc/net/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/net/main.c    | 791 +++++++++++++++++-
 .../ethernet/yunsilicon/xsc/net/xsc_eth_wq.c  |  80 ++
 .../net/ethernet/yunsilicon/xsc/pci/alloc.c   | 102 +++
 5 files changed, 982 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 74cd5b66f..a72143ae6 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -279,6 +279,15 @@ void xsc_irq_event_register(struct xsc_core_device *xdev,
 			    void (*handler)(void *xdev));
 void xsc_irq_event_unregister(struct xsc_core_device *xdev);
 
+void xsc_core_fill_page_frag_array(struct xsc_frag_buf *buf,
+				   __be64 *pas, unsigned int npages);
+int xsc_core_frag_buf_alloc_node(struct xsc_core_device *xdev,
+				 unsigned long size,
+				 struct xsc_frag_buf *buf,
+				 int node);
+void xsc_core_frag_buf_free(struct xsc_core_device *xdev,
+			    struct xsc_frag_buf *buf);
+
 static inline void *xsc_buf_offset(struct xsc_buf *buf, unsigned long offset)
 {
 	if (likely(buf->nbufs == 1))
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
index db289d974..0e6249cec 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_ETH) += xsc_eth.o
 
-xsc_eth-y := main.o
+xsc_eth-y := main.o xsc_eth_wq.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
index b9e75d7e1..1c7bbc27d 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
@@ -25,6 +25,774 @@ static void xsc_eth_netdev_init(struct xsc_adapter *adapter)
 	netif_carrier_off(adapter->netdev);
 }
 
+static void xsc_eth_build_queue_param(struct xsc_adapter *adapter,
+				      struct xsc_queue_attr *attr, u8 type)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+
+	if (adapter->nic_param.sq_size == 0)
+		adapter->nic_param.sq_size = min_t(u32,
+						   BIT(xdev->caps.log_max_qp_depth),
+						   XSC_SQCQ_ELE_NUM);
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
+	return XSC_SKB_FRAG_SZ(XSC_SW2HW_FRAG_SIZE(mtu));
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
+	chl_param->rq_param.frag_size = XSC_SW2HW_FRAG_SIZE(adapter->nic_param.mtu);
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
+	core_cq->event = xsc_eth_cq_error_event;
+	core_cq->vector = 0;
+
+	for (i = 0; i < xsc_cqwq_get_size(&pcq->wq); i++) {
+		struct xsc_cqe *cqe = xsc_cqwq_get_wqe(&pcq->wq, i);
+
+		cqe->data1 |= cpu_to_le32(XSC_CQE_DATA1_OWNER);
+	}
+	pcq->xdev = xdev;
+	return 0;
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
+	hw_npages = DIV_ROUND_UP(pcq->wq_ctrl.buf.size, XSC_PAGE_SIZE_4K);
+	/*mbox size + pas size*/
+	inlen = sizeof(struct xsc_create_cq_mbox_in) +
+		sizeof(__be64) * hw_npages;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	ret = xsc_core_vector2eqn(xdev, pcq->xcq.vector, &eqn, &irqn);
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
+	ret = xsc_core_eth_create_cq(xdev, &pcq->xcq, in, inlen);
+	if (ret)
+		goto err_free;
+	pcq->xcq.irqn = irqn;
+	kvfree(in);
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
+	xsc_arm_cq(pcq->xdev, pcq->xcq.cqn, pcq->wq.cc, 0);
+
+	pcq->channel = c;
+
+	return 0;
+
+err_free_cq:
+	xsc_eth_free_cq(pcq);
+	return ret;
+}
+
+static void xsc_eth_close_cq(struct xsc_channel *c, struct xsc_cq *pcq)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+
+	/* If DESTROY_CQ failed the firmware may still own this CQ and keep
+	 * writing CQEs into its buffer; leak the buffer rather than hand it
+	 * back to the allocator while the device can still DMA into it.
+	 */
+	if (xsc_core_eth_destroy_cq(xdev, &pcq->xcq)) {
+		netdev_err(xsc_dev_to_netdev(xdev), "failed to close cq%d\n",
+			   pcq->xcq.cqn);
+		return;
+	}
+
+	xsc_eth_free_cq(pcq);
+}
+
+static void xsc_free_qp_sq_db(struct xsc_sq *sq)
+{
+	kvfree(sq->wqe_info);
+	sq->wqe_info = NULL;
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
+	sq->wqe_info = kvzalloc_node(array_size(xsc_wq_cyc_get_size(&sq->wq),
+						sizeof(*sq->wqe_info)),
+				     GFP_KERNEL, numa);
+	if (!sq->wqe_info)
+		return -ENOMEM;
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
+	struct xsc_create_qp_mbox_in *in;
+	struct xsc_core_device *xdev;
+	struct xsc_adapter *adapter;
+	unsigned int hw_npages;
+	int inlen;
+	int ret;
+
+	adapter = c->adapter;
+	xdev  = adapter->xdev;
+	psq_param->wq.db_numa_node = cpu_to_node(c->cpu);
+
+	ret = xsc_eth_wq_cyc_create(xdev, &psq_param->wq,
+				    q_log_size, ele_log_size, &psq->wq,
+				    &psq->wq_ctrl);
+	if (ret)
+		return ret;
+
+	hw_npages = DIV_ROUND_UP(psq->wq_ctrl.buf.size, XSC_PAGE_SIZE_4K);
+	inlen = sizeof(struct xsc_create_qp_mbox_in) +
+		sizeof(__be64) * hw_npages;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		ret = -ENOMEM;
+		goto err_sq_wq_destroy;
+	}
+	in->req.input_qpn = cpu_to_be16(XSC_QPN_SQN_STUB);
+	in->req.qp_type = XSC_QUEUE_TYPE_RAW_TSO;
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
+
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
+	modify_in->req.prio = 0;
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
+	xsc_free_qp_sq_db(psq);
+
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
+static void xsc_eth_close_qp_sq(struct xsc_channel *c, struct xsc_sq *psq)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+
+	xsc_core_destroy_resource_common(xdev, &psq->cqp);
+
+	/* If DESTROY_QP failed the QP is still live in the firmware with its
+	 * WQ pages programmed; leak the WQ buffer (and in-flight skbs) rather
+	 * than free pages the device can still DMA into.
+	 */
+	if (xsc_core_eth_destroy_qp(xdev, psq->cqp.qpn)) {
+		netdev_err(c->adapter->netdev, "failed to close sq%d\n",
+			   psq->cqp.qpn);
+		return;
+	}
+
+	xsc_free_qp_sq(psq);
+}
+
+static int xsc_eth_open_channel(struct xsc_adapter *adapter,
+				struct xsc_channel *c,
+				struct xsc_channel_param *chl_param)
+{
+	struct xsc_core_device *xdev = adapter->xdev;
+	const struct cpumask *aff;
+	unsigned int irqn;
+	u32 eqn;
+	int ret;
+
+	c->adapter = adapter;
+	c->netdev = adapter->netdev;
+	c->cpu = 0;
+
+	ret = xsc_core_vector2eqn(xdev, 0, &eqn, &irqn);
+	if (ret)
+		goto err_out;
+	aff = irq_get_affinity_mask(irqn);
+	if (aff)
+		c->cpu = cpumask_first(aff);
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
+	netdev_dbg(adapter->netdev, "open channel ok\n");
+	return 0;
+
+err_close_sq_cq:
+	xsc_eth_close_cq(c, &c->qp.sq.cq);
+err_close_rq_cq:
+	xsc_eth_close_cq(c, &c->qp.rq.cq);
+err_out:
+	netdev_err(adapter->netdev, "failed to open channel, err=%d\n", ret);
+	return ret;
+}
+
+static int xsc_eth_modify_qps_channel(struct xsc_adapter *adapter,
+				      struct xsc_channel *c)
+{
+	int ret;
+
+	ret = xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.rq.rqn,
+					    XSC_CMD_OP_RTR2RTS_QP);
+	if (ret)
+		return ret;
+
+	return xsc_core_eth_modify_qp_status(adapter->xdev, c->qp.sq.sqn,
+					     XSC_CMD_OP_RTR2RTS_QP);
+}
+
+static void xsc_eth_free_qp_rq(struct xsc_rq *rq)
+{
+	kvfree(rq->wqe.di);
+
+	if (rq->page_pool)
+		page_pool_destroy(rq->page_pool);
+
+	xsc_eth_wq_destroy(&rq->wq_ctrl);
+}
+
+static int xsc_eth_alloc_rq(struct xsc_channel *c,
+			    struct xsc_rq *prq,
+			    struct xsc_rq_param *prq_param)
+{
+	u8 ele_log_size = prq_param->rq_attr.ele_log_size;
+	struct page_pool_params pagepool_params = {0};
+	u8 q_log_size = prq_param->rq_attr.q_log_size;
+	u32 wq_sz;
+	int ret = 0;
+	int i;
+
+	prq_param->wq.db_numa_node = cpu_to_node(c->cpu);
+
+	ret = xsc_eth_wq_cyc_create(c->adapter->xdev, &prq_param->wq,
+				    q_log_size, ele_log_size, &prq->wqe.wq,
+				    &prq->wq_ctrl);
+	if (ret)
+		return ret;
+
+	wq_sz = xsc_wq_cyc_get_size(&prq->wqe.wq);
+	prq->wqe.di = kvzalloc_node(array_size(wq_sz, sizeof(*prq->wqe.di)),
+				    GFP_KERNEL, cpu_to_node(c->cpu));
+	if (!prq->wqe.di)
+		goto err_destroy_wq;
+
+	prq->wqe.wqe_bulk = PAGE_SIZE /
+		roundup_pow_of_two(xsc_rx_get_linear_frag_sz(c->adapter->nic_param.mtu));
+
+	pagepool_params.order = XSC_RX_FRAG_SZ_ORDER;
+	pagepool_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pagepool_params.pool_size = wq_sz;
+	pagepool_params.nid = cpu_to_node(c->cpu);
+	pagepool_params.dev = c->adapter->dev;
+	pagepool_params.dma_dir = DMA_FROM_DEVICE;
+	pagepool_params.max_len = PAGE_SIZE;
+	prq->page_pool = page_pool_create(&pagepool_params);
+	if (IS_ERR(prq->page_pool)) {
+		ret = PTR_ERR(prq->page_pool);
+		prq->page_pool = NULL;
+		goto err_free_di;
+	}
+
+	for (i = 0; i < wq_sz; i++) {
+		struct xsc_eth_rx_wqe_cyc *wqe =
+			xsc_wq_cyc_get_wqe(&prq->wqe.wq, i);
+
+		wqe->data[0].data0 =
+			cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK,
+					       prq_param->frag_size));
+		wqe->data[0].mkey = cpu_to_le32(XSC_INVALID_LKEY);
+	}
+
+	prq->frag_size = prq_param->frag_size;
+
+	return 0;
+
+err_free_di:
+	kvfree(prq->wqe.di);
+err_destroy_wq:
+	xsc_eth_wq_destroy(&prq->wq_ctrl);
+	return ret;
+}
+
+static int xsc_eth_open_qp_rq(struct xsc_channel *c,
+			      struct xsc_rq *prq,
+			      struct xsc_rq_param *prq_param)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+	struct xsc_create_qp_mbox_in *in;
+	unsigned int hw_npages;
+	u8 q_log_size;
+	int inlen;
+	int ret;
+
+	ret = xsc_eth_alloc_rq(c, prq, prq_param);
+	if (ret)
+		return ret;
+
+	q_log_size = prq_param->rq_attr.q_log_size;
+	hw_npages = DIV_ROUND_UP(prq->wq_ctrl.buf.size, XSC_PAGE_SIZE_4K);
+	inlen = sizeof(struct xsc_create_qp_mbox_in) +
+		sizeof(__be64) * hw_npages;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		ret = -ENOMEM;
+		goto err_free_rq;
+	}
+
+	in->req.input_qpn = cpu_to_be16(0);
+	in->req.qp_type = XSC_QUEUE_TYPE_RAW;
+	in->req.log_rq_sz = ilog2(xdev->caps.recv_ds_num) + q_log_size;
+	in->req.pa_num = cpu_to_be16(hw_npages);
+	in->req.cqn_recv = cpu_to_be16(prq->cq.xcq.cqn);
+	in->req.cqn_send = in->req.cqn_recv;
+	in->req.glb_funcid = cpu_to_be16(xdev->glb_func_id);
+
+	xsc_core_fill_page_frag_array(&prq->wq_ctrl.buf,
+				      &in->req.pas[0], hw_npages);
+
+	ret = xsc_core_eth_create_qp(xdev, in, inlen, &prq->rqn);
+	kvfree(in);
+	if (ret)
+		goto err_free_rq;
+
+	prq->cqp.qpn = prq->rqn;
+	prq->cqp.event = xsc_eth_qp_event;
+	prq->cqp.eth_queue_type = XSC_RES_RQ;
+
+	ret = xsc_core_create_resource_common(xdev, &prq->cqp);
+	if (ret) {
+		netdev_err(c->adapter->netdev,
+			   "create resource common error qp:%d errno:%d\n",
+			   prq->rqn, ret);
+		goto err_destroy_qp;
+	}
+
+	return 0;
+
+err_destroy_qp:
+	xsc_core_eth_destroy_qp(xdev, prq->rqn);
+err_free_rq:
+	xsc_eth_free_qp_rq(prq);
+	return ret;
+}
+
+static void xsc_eth_close_qp_rq(struct xsc_channel *c, struct xsc_rq *prq)
+{
+	struct xsc_core_device *xdev = c->adapter->xdev;
+
+	xsc_core_destroy_resource_common(xdev, &prq->cqp);
+
+	/* If DESTROY_QP failed the RQ is still live in the firmware with its
+	 * WQ pages posted; leak the WQ buffer and page_pool rather than return
+	 * buffer pages the device can still DMA into.
+	 */
+	if (xsc_core_eth_destroy_qp(xdev, prq->cqp.qpn)) {
+		netdev_err(c->adapter->netdev, "failed to close rq%d\n",
+			   prq->cqp.qpn);
+		return;
+	}
+
+	xsc_eth_free_qp_rq(prq);
+}
+
+static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
+{
+	if (free_rq)
+		xsc_eth_close_qp_rq(c, &c->qp.rq);
+	xsc_eth_close_cq(c, &c->qp.rq.cq);
+	memset(&c->qp.rq, 0, sizeof(struct xsc_rq));
+
+	xsc_eth_close_qp_sq(c, &c->qp.sq);
+	xsc_eth_close_cq(c, &c->qp.sq.cq);
+	memset(&c->qp.sq, 0, sizeof(struct xsc_sq));
+}
+
+static int xsc_eth_open_channels(struct xsc_adapter *adapter)
+{
+	struct xsc_channel_param *chl_param;
+	bool free_rq = false;
+	int ret = 0;
+
+	chl_param = kvzalloc_obj(*chl_param, GFP_KERNEL);
+	if (!chl_param)
+		return -ENOMEM;
+
+	xsc_eth_build_channel_param(adapter, chl_param);
+
+	ret = xsc_eth_open_channel(adapter, &adapter->channel, chl_param);
+	if (ret)
+		goto err_free_param;
+
+	ret = xsc_eth_open_qp_rq(&adapter->channel, &adapter->channel.qp.rq,
+				 &chl_param->rq_param);
+	if (ret)
+		goto err_close_channel;
+	free_rq = true;
+
+	ret = xsc_eth_modify_qps_channel(adapter, &adapter->channel);
+	if (ret)
+		goto err_close_channel;
+
+	kvfree(chl_param);
+	return 0;
+
+err_close_channel:
+	xsc_eth_close_channel(&adapter->channel, free_rq);
+err_free_param:
+	kvfree(chl_param);
+	netdev_err(adapter->netdev, "failed to open channel, err=%d\n", ret);
+	return ret;
+}
+
+static void xsc_eth_close_channels(struct xsc_adapter *adapter)
+{
+	xsc_eth_close_channel(&adapter->channel, true);
+}
+
+static void xsc_eth_activate_channel(struct xsc_channel *c)
+{
+	struct xsc_sq *psq = &c->qp.sq;
+
+	psq->txq = netdev_get_tx_queue(c->netdev, 0);
+	set_bit(XSC_ETH_SQ_STATE_ENABLED, &psq->state);
+	netdev_tx_reset_queue(psq->txq);
+	netif_tx_start_queue(psq->txq);
+
+	set_bit(XSC_ETH_RQ_STATE_ENABLED, &c->qp.rq.state);
+}
+
+static void xsc_eth_deactivate_channel(struct xsc_channel *c)
+{
+	netif_tx_disable(c->netdev);
+
+	clear_bit(XSC_ETH_RQ_STATE_ENABLED, &c->qp.rq.state);
+	clear_bit(XSC_ETH_SQ_STATE_ENABLED, &c->qp.sq.state);
+
+	synchronize_net();
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
+	xsc_eth_activate_channel(&adapter->channel);
+
+	return 0;
+}
+
+static void xsc_eth_sw_deinit(struct xsc_adapter *adapter)
+{
+	xsc_eth_deactivate_channel(&adapter->channel);
+	xsc_eth_close_channels(adapter);
+}
+
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
+	in.rss.rqn_base = cpu_to_be16(adapter->channel.qp.rq.rqn);
+	in.rss.rqn_num = cpu_to_be16(1);
+	in.rss.hfunc = XSC_HASH_FUNC_TOP;
+	in.rss.hash_tmpl = cpu_to_be32(XSC_HASH_IP_PORTS | XSC_HASH_IP6_PORTS);
+	caps_mask |= BIT(XSC_TBM_CAP_RSS);
+	caps_mask |= BIT(XSC_TBM_CAP_HASH_PPH);
+
+	if (xsc_get_pct_drop_config(xdev))
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
+	if (xsc_get_pct_drop_config(xdev))
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
 static void xsc_set_port_admin_status(struct xsc_adapter *adapter,
 				      enum xsc_port_status status)
 {
@@ -45,25 +813,46 @@ static void xsc_set_port_admin_status(struct xsc_adapter *adapter,
 static int xsc_eth_open(struct net_device *netdev)
 {
 	struct xsc_adapter *adapter = netdev_priv(netdev);
+	int ret;
+
+	ret = xsc_eth_sw_init(adapter);
+	if (ret)
+		return ret;
+
+	ret = xsc_eth_enable_nic_hca(adapter);
+	if (ret)
+		goto err_sw_deinit;
 
 	adapter->opened = true;
 
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
+	int ret;
 
 	adapter->opened = false;
 
 	netif_carrier_off(adapter->netdev);
 
+	xsc_eth_sw_deinit(adapter);
+
+	ret = xsc_eth_disable_nic_hca(adapter);
+	if (ret)
+		netdev_err(adapter->netdev, "failed to disable nic hca, err=%d\n",
+			   ret);
+
 	xsc_set_port_admin_status(adapter, XSC_PORT_DOWN);
 
-	return 0;
+	return ret;
 }
 
 static int xsc_eth_set_hw_mtu(struct xsc_core_device *xdev,
diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
new file mode 100644
index 000000000..b69a4e373
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/net/xsc_eth_wq.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd. All
+ * rights reserved.
+ * Copyright (c) 2013-2015, Mellanox Technologies, Ltd.  All rights reserved.
+ */
+
+#include "xsc_eth_wq.h"
+#include "xsc_eth.h"
+
+u32 xsc_wq_cyc_get_size(struct xsc_wq_cyc *wq)
+{
+	return (u32)wq->fbc.sz_m1 + 1;
+}
+
+static u32 wq_get_byte_sz(u8 log_sz, u8 log_stride)
+{
+	return ((u32)1 << log_sz) << log_stride;
+}
+
+int xsc_eth_cqwq_create(struct xsc_core_device *xdev,
+			struct xsc_wq_param *param,
+			u8 q_log_size,
+			u8 ele_log_size,
+			struct xsc_cqwq *wq,
+			struct xsc_wq_ctrl *wq_ctrl)
+{
+	u8 log_wq_stride = ele_log_size;
+	u8 log_wq_sz     = q_log_size;
+	int err;
+
+	err = xsc_core_frag_buf_alloc_node(xdev,
+					   wq_get_byte_sz(log_wq_sz,
+							  log_wq_stride),
+					   &wq_ctrl->buf,
+					   param->buf_numa_node);
+	if (err) {
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "xsc_core_frag_buf_alloc_node failed, %d\n", err);
+		return err;
+	}
+
+	xsc_init_fbc(wq_ctrl->buf.frags, log_wq_stride, log_wq_sz, &wq->fbc);
+	wq_ctrl->xdev = xdev;
+	return 0;
+}
+
+int xsc_eth_wq_cyc_create(struct xsc_core_device *xdev,
+			  struct xsc_wq_param *param,
+			  u8 q_log_size,
+			  u8 ele_log_size,
+			  struct xsc_wq_cyc *wq,
+			  struct xsc_wq_ctrl *wq_ctrl)
+{
+	struct xsc_frag_buf_ctrl *fbc = &wq->fbc;
+	u8 log_wq_stride = ele_log_size;
+	u8 log_wq_sz = q_log_size;
+	int err;
+
+	err = xsc_core_frag_buf_alloc_node(xdev,
+					   wq_get_byte_sz(log_wq_sz,
+							  log_wq_stride),
+					   &wq_ctrl->buf,
+					   param->buf_numa_node);
+	if (err) {
+		netdev_err(xsc_dev_to_netdev(xdev),
+			   "xsc_core_frag_buf_alloc_node failed, %d\n", err);
+		return err;
+	}
+
+	xsc_init_fbc(wq_ctrl->buf.frags, log_wq_stride, log_wq_sz, fbc);
+	wq->sz = xsc_wq_cyc_get_size(wq);
+	wq_ctrl->xdev = xdev;
+	return 0;
+}
+
+void xsc_eth_wq_destroy(struct xsc_wq_ctrl *wq_ctrl)
+{
+	xsc_core_frag_buf_free(wq_ctrl->xdev, &wq_ctrl->buf);
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
index 46eb0b031..0b0478c64 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
@@ -121,3 +121,105 @@ void xsc_fill_page_array(struct xsc_buf *buf, __be64 *pas, unsigned int npages)
 		pas[i] = cpu_to_be64(addr);
 	}
 }
+EXPORT_SYMBOL_GPL(xsc_fill_page_array);
+
+void xsc_core_fill_page_frag_array(struct xsc_frag_buf *buf,
+				   __be64 *pas,
+				   unsigned int npages)
+{
+	int i;
+	dma_addr_t addr;
+	unsigned int shift = PAGE_SHIFT - XSC_PAGE_SHIFT_4K;
+	unsigned int mask = (1 << shift) - 1;
+
+	for (i = 0; i < npages; i++) {
+		addr = buf->frags[i >> shift].map +
+			((i & mask) << XSC_PAGE_SHIFT_4K);
+		pas[i] = cpu_to_be64(addr);
+	}
+}
+EXPORT_SYMBOL_GPL(xsc_core_fill_page_frag_array);
+
+static void *xsc_dma_zalloc_coherent_node(struct xsc_core_device *xdev,
+					  size_t size, dma_addr_t *dma_handle,
+					  int node)
+{
+	struct device *device = &xdev->pdev->dev;
+	int original_node;
+	void *cpu_handle;
+
+	/* WA for kernels that don't use numa_mem_id in alloc_pages_node */
+	if (node == NUMA_NO_NODE)
+		node = numa_mem_id();
+
+	original_node = dev_to_node(device);
+	set_dev_node(device, node);
+	cpu_handle = dma_alloc_coherent(device, size, dma_handle, GFP_KERNEL);
+	set_dev_node(device, original_node);
+
+	return cpu_handle;
+}
+
+int xsc_core_frag_buf_alloc_node(struct xsc_core_device *xdev,
+				 unsigned long size,
+				 struct xsc_frag_buf *buf,
+				 int node)
+{
+	int i;
+
+	buf->size = size;
+	buf->npages = DIV_ROUND_UP(size, PAGE_SIZE);
+	buf->page_shift = PAGE_SHIFT;
+	buf->frags = kcalloc(buf->npages, sizeof(struct xsc_buf_list),
+			     GFP_KERNEL);
+	if (!buf->frags)
+		goto err_out;
+
+	for (i = 0; i < buf->npages; i++) {
+		unsigned long frag_sz = min_t(unsigned long, size, PAGE_SIZE);
+		struct xsc_buf_list *frag = &buf->frags[i];
+
+		frag->buf = xsc_dma_zalloc_coherent_node(xdev, frag_sz,
+							 &frag->map, node);
+		if (!frag->buf)
+			goto err_free_buf;
+		if (frag->map & ((1 << buf->page_shift) - 1)) {
+			dma_free_coherent(&xdev->pdev->dev, frag_sz,
+					  buf->frags[i].buf, buf->frags[i].map);
+			pci_err(xdev->pdev, "unexpected map alignment: %pad, page_shift=%d\n",
+				&frag->map, buf->page_shift);
+			goto err_free_buf;
+		}
+		size -= frag_sz;
+	}
+
+	return 0;
+
+err_free_buf:
+	while (i--)
+		dma_free_coherent(&xdev->pdev->dev,
+				  PAGE_SIZE,
+				  buf->frags[i].buf,
+				  buf->frags[i].map);
+	kfree(buf->frags);
+err_out:
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xsc_core_frag_buf_alloc_node);
+
+void xsc_core_frag_buf_free(struct xsc_core_device *xdev,
+			    struct xsc_frag_buf *buf)
+{
+	unsigned long size = buf->size;
+	int i;
+
+	for (i = 0; i < buf->npages; i++) {
+		unsigned long frag_sz = min_t(unsigned long, size, PAGE_SIZE);
+
+		dma_free_coherent(&xdev->pdev->dev, frag_sz, buf->frags[i].buf,
+				  buf->frags[i].map);
+		size -= frag_sz;
+	}
+	kfree(buf->frags);
+}
+EXPORT_SYMBOL_GPL(xsc_core_frag_buf_free);
-- 
2.43.0
