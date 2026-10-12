Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D9C489FBD
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805516; cv=none; b=NFOlsLAy0TkBp93mtzeYf+V5SJ8wN8B2N5AL3HAmEFzv3w4pTdHjdh3z0SpbvqUqPeD5hIsCascwoW1ZoF3oGXtj8kwpvAobXA0ssr6bmhTDRoXjd/ROOATSNqHuu3HMZQ2rT5lv04llUpgDRy703pA99zl6Rn713zoFLP9bN10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805516; c=relaxed/simple;
	bh=/g91i9DtlXWnHnp4O+2PFM4DzwuacHVuxkNqWsVJrjo=;
	h=Cc:Subject:Date:References:Content-Type:To:Message-Id:
	 Mime-Version:From:In-Reply-To; b=MhaZCwddxk8a2gV4p9ZFrFA7ix+rhIzaW5sf6j0JUxf3GWBZLYTIgLahWm+aHlJZSUapwcLMiGaNlvHGtKM840c2Lz7OmrCGwj2GhNcELyfYvVlAPLk3S3BejELRFezuCeKKqufNmtSt/OWp/FlWH8dQ0yUzqlSE5zZ+nNaAkV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=K3G7MX9W; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="K3G7MX9W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805465; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=pwcf5Ck/7DxtmRe1k97L/Zw34qbEOaD6TxXf8pUN06Y=;
 b=K3G7MX9WgkaLFTTewXKI0adEDISjIR49FT5YXAepX2Zb/ZGcrxoFtBSljHa/iTTw3GyMTA
 Ib5SZwlrMPnYybRITlP/cMLlhGv3QdnRyM54aabcqjaR4Irr611eaEE9FcyRxoDbvjdQ4l
 N6sEACNvMPq9Nw9d/vhk5h6xV+975tUxhIiLMDfget4kEQWZKaRdRoogh+82OfdwOiq86a
 HN4IhlnAAhhxTtP6q4zGqOu2sIzTPNfltuTJbCg5M9cJO3Smz4kNw2xrJNqYEPehgJRyok
 ZK5UpyHVll9E5ghAqhEMf0gWK2OyYW/1AC1bLCodXILyHu6PA4ZLSwa2bNLxRQ==
X-Lms-Return-Path: <lba+26accc817+d68b11+vger.kernel.org+tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: [PATCH 12/15] yunsilicon: add RDMA QP verbs
X-Mailer: git-send-email 2.25.1
Date: Mon, 12 Oct 2026 19:44:22 +0800
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:44:22 +0800
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Message-Id: <20261012114421.2471317-13-tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Xin Tian" <tianx@yunsilicon.com>
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>

Add the queue pair control path: create, destroy, modify and query, for
both kernel and user queue pairs, including the address path setup for
RoCE.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/main.c |    6 +
 drivers/infiniband/hw/xsc/qp.c   | 1321 ++++++++++++++++++++++++++++++
 2 files changed, 1327 insertions(+)

diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index e9a9ba114..c4f306318 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -570,6 +570,11 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 	dev->ib_dev.ops.get_link_layer	= xsc_ib_port_link_layer;
 	dev->ib_dev.ops.get_netdev		= xsc_get_netdev;
 
+	dev->ib_dev.ops.create_qp		= xsc_ib_create_qp;
+	dev->ib_dev.ops.modify_qp		= xsc_ib_modify_qp;
+	dev->ib_dev.ops.query_qp		= xsc_ib_query_qp;
+	dev->ib_dev.ops.destroy_qp		= xsc_ib_destroy_qp;
+	dev->ib_dev.ops.post_recv		= xsc_ib_post_recv;
 	dev->ib_dev.ops.create_cq		= xsc_ib_create_cq;
 	dev->ib_dev.ops.destroy_cq		= xsc_ib_destroy_cq;
 	dev->ib_dev.ops.poll_cq		= xsc_ib_poll_cq;
@@ -592,6 +597,7 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ah, xsc_ib_ah, ibah);
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_cq, xsc_ib_cq, ibcq);
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_pd, xsc_ib_pd, ibpd);
+	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_qp, xsc_ib_qp, ibqp);
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_srq, xsc_ib_srq, ibsrq);
 }
 
diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/qp.c
index 28c8a1246..6a83adc9c 100644
--- a/drivers/infiniband/hw/xsc/qp.c
+++ b/drivers/infiniband/hw/xsc/qp.c
@@ -28,11 +28,21 @@ enum {
 #define UDP_SPORT_MASK			0xffff
 #define UDP_SPORT_OFFSET		0
 
+static int is_qp0(enum ib_qp_type qp_type)
+{
+	return qp_type == IB_QPT_SMI;
+}
+
 static int is_qp1(enum ib_qp_type qp_type)
 {
 	return qp_type == IB_QPT_GSI;
 }
 
+static int is_sqp(enum ib_qp_type qp_type)
+{
+	return is_qp0(qp_type) || is_qp1(qp_type);
+}
+
 static void *get_wqe(struct xsc_ib_qp *qp, int offset)
 {
 	return xsc_buf_offset(&qp->buf, offset);
@@ -48,6 +58,258 @@ static void *get_seg_wqe(void *first, int n)
 	return first + (n << XSC_BASE_WQE_SHIFT);
 }
 
+static void xsc_ib_qp_event(struct xsc_core_qp *qp, int type)
+{
+	struct ib_qp *ibqp = &core_to_xqp(qp)->ibqp;
+	struct ib_event event;
+
+	if (ibqp->event_handler) {
+		event.device     = ibqp->device;
+		event.element.qp = ibqp;
+		switch (type) {
+		case XSC_EVENT_TYPE_WQ_CATAS_ERROR:
+			event.event = IB_EVENT_QP_FATAL;
+			break;
+		case XSC_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+			event.event = IB_EVENT_QP_REQ_ERR;
+			break;
+		case XSC_EVENT_TYPE_WQ_ACCESS_ERROR:
+			event.event = IB_EVENT_QP_ACCESS_ERR;
+			break;
+		default:
+			pr_warn("xsc_ib: Unexpected event type %d on QP %06x\n", type, qp->qpn);
+			return;
+		}
+
+		ibqp->event_handler(&event, ibqp->qp_context);
+		pr_info("xsc_ib: xsc async event 0x%x, ib event %d\n", type, event.event);
+	}
+}
+
+static int set_rq_size(struct xsc_ib_dev *dev, struct ib_qp_init_attr *init_attr,
+		       int has_rq, struct xsc_ib_qp *qp, struct xsc_ib_create_qp *ucmd)
+{
+	bool check_res = false;
+	u32 wqe_cnt = init_attr->cap.max_recv_wr ?
+		roundup_pow_of_two(init_attr->cap.max_recv_wr) : 0;
+
+	if (init_attr->srq)
+		wqe_cnt = to_xsrq(init_attr->srq)->xsrq.max;
+
+	/* Sanity check RQ size before proceeding */
+	check_res = xsc_check_max_qp_depth(dev->xdev, &wqe_cnt, dev->xdev->caps.max_wqes);
+	if (check_res) {
+		ibdev_err(&dev->ib_dev, "max_recv_wr:%d exceed max rq depth\n",
+			  init_attr->cap.max_recv_wr);
+		return -EINVAL;
+	}
+
+	if (!has_rq) {
+		qp->rq.max_gs = 0;
+		qp->rq.wqe_cnt = 0;
+		qp->rq.wqe_shift = 0;
+	} else {
+		if (ucmd) {
+			qp->rq.wqe_cnt = ucmd->rq_wqe_count;
+			qp->rq.wqe_shift = ucmd->rq_wqe_shift;
+			qp->rq.max_gs = 1;
+			qp->rq.max_post = qp->rq.wqe_cnt;
+		} else {
+			qp->rq.wqe_cnt = wqe_cnt;
+			if (qp->xqp.qp_type == IB_QPT_GSI)
+				qp->rq.wqe_shift = ilog2(xsc_get_recv_ds_num(dev->xdev))
+					+ XSC_RECV_WQE_SHIFT;
+			else
+				qp->rq.wqe_shift = dev->xdev->caps.recv_wqe_shift;
+			qp->rq.max_gs = dev->xdev->caps.recv_ds_num;
+			qp->rq.max_post = qp->rq.wqe_cnt;
+		}
+	}
+
+	return 0;
+}
+
+static int calc_sq_size(struct xsc_ib_dev *dev, struct ib_qp_init_attr *attr,
+			struct xsc_ib_qp *qp)
+{
+	int wqe_size;
+	int wq_size;
+	bool check_res = false;
+
+	if (!attr->cap.max_send_wr) {
+		ibdev_err(&dev->ib_dev, "invalid max_send_wr:%d\n", attr->cap.max_send_wr);
+		return -1;
+	}
+
+	wqe_size = 1 << dev->xdev->caps.send_wqe_shift;
+	qp->max_inline_data = (dev->xdev->caps.send_ds_num - 2) * sizeof(struct xsc_wqe_data_seg);
+	attr->cap.max_inline_data = qp->max_inline_data;
+
+	attr->cap.max_send_wr = min_t(u32, attr->cap.max_send_wr, dev->xdev->caps.max_wqes);
+	qp->sq.wqe_cnt = roundup_pow_of_two(attr->cap.max_send_wr);
+
+	check_res = xsc_check_max_qp_depth(dev->xdev, &qp->sq.wqe_cnt, dev->xdev->caps.max_wqes);
+	if (check_res) {
+		ibdev_err(&dev->ib_dev, "max_send_wr:%d exceed max sq depth\n",
+			  attr->cap.max_send_wr);
+		return -EINVAL;
+	}
+	qp->sq.ds_cnt = qp->sq.wqe_cnt << (dev->xdev->caps.send_wqe_shift - XSC_BASE_WQE_SHIFT);
+	wq_size = qp->sq.wqe_cnt * wqe_size;
+	qp->sq.wqe_shift = ilog2(wqe_size);
+	qp->sq.max_gs = dev->xdev->caps.send_ds_num - XSC_CTRL_SEG_NUM - XSC_RADDR_SEG_NUM;
+	qp->sq.max_post = qp->sq.wqe_cnt;
+
+	return wq_size;
+}
+
+static int qp_has_rq(struct ib_qp_init_attr *attr)
+{
+	if (!attr->srq && !attr->cap.max_recv_wr)
+		return 0;
+
+	return 1;
+}
+
+static enum xsc_qp_state to_xsc_state(enum ib_qp_state state)
+{
+	switch (state) {
+	case IB_QPS_RESET:	return XSC_QP_STATE_RST;
+	case IB_QPS_INIT:	return XSC_QP_STATE_INIT;
+	case IB_QPS_RTR:	return XSC_QP_STATE_RTR;
+	case IB_QPS_RTS:	return XSC_QP_STATE_RTS;
+	case IB_QPS_SQD:	return XSC_QP_STATE_SQD;
+	case IB_QPS_SQE:	return XSC_QP_STATE_SQER;
+	case IB_QPS_ERR:	return XSC_QP_STATE_ERR;
+	default:		return -1;
+	}
+}
+
+static char *qp_state_to_str(enum ib_qp_state state)
+{
+	switch (state) {
+	case IB_QPS_RESET:	return "RST";
+	case IB_QPS_INIT:	return "INIT";
+	case IB_QPS_RTR:	return "RTR";
+	case IB_QPS_RTS:	return "RTS";
+	case IB_QPS_SQD:	return "SQD";
+	case IB_QPS_SQE:	return "SQE";
+	case IB_QPS_ERR:	return "ERR";
+	default:		return "UNKNOWN";
+	}
+}
+
+static struct ib_umem *qp_umem_get(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp,
+				   struct ib_udata *udata, struct ib_pd *pd,
+	struct xsc_ib_create_qp *ucmd)
+{
+	struct ib_umem *umem;
+
+	umem = ib_umem_get_va(&dev->ib_dev, ucmd->buf_addr, qp->buf_size,
+			      IB_ACCESS_LOCAL_WRITE);
+	return umem;
+}
+
+static int create_user_qp(struct xsc_ib_dev *dev, struct ib_pd *pd,
+			  struct xsc_ib_qp *qp, struct ib_udata *udata,
+			  struct xsc_create_qp_mbox_in **in,
+			  struct xsc_ib_create_qp_resp *resp, int *inlen)
+{
+	struct xsc_ib_create_qp ucmd;
+	int page_shift;
+	int npages;
+	u32 offset;
+	int ncont;
+	int err;
+	int hw_npages;
+	struct ib_umem_dmabuf *umem_dmabuf;
+
+	err = ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
+	if (err) {
+		ibdev_err(&dev->ib_dev, "failed to copy from udata, err=%d\n", err);
+		return err;
+	}
+	ibdev_dbg(&dev->ib_dev, "buf_addr:0x%lx db_addr:0x%lx sq cnt:%u, rq cnt:%u, rq shift:%u\n",
+		  (uintptr_t)ucmd.buf_addr, (uintptr_t)ucmd.db_addr,
+		    ucmd.sq_wqe_count, ucmd.rq_wqe_count, ucmd.rq_wqe_shift);
+
+	qp->sq.ds_cnt = ucmd.sq_wqe_count;
+	qp->sq.wqe_cnt = ucmd.sq_wqe_count;
+	qp->sq.wqe_shift = XSC_BASE_WQE_SHIFT;
+	qp->rq.ds_cnt = ucmd.rq_wqe_count;
+	qp->rq.wqe_cnt = ucmd.rq_wqe_count;
+	qp->rq.wqe_shift = XSC_BASE_WQE_SHIFT;
+
+	qp->buf_size = (qp->sq.wqe_cnt << qp->sq.wqe_shift) + (qp->rq.wqe_cnt << qp->rq.wqe_shift);
+
+	if (ucmd.dmabuf_fd != -1) {
+		umem_dmabuf = ib_umem_dmabuf_get_pinned(&dev->ib_dev, 0, ucmd.dmabuf_sz,
+							ucmd.dmabuf_fd, IB_ACCESS_LOCAL_WRITE);
+
+		if (IS_ERR(umem_dmabuf)) {
+			ibdev_warn(&dev->ib_dev, "qp umem_dmabuf get failed (%ld)\n",
+				   PTR_ERR(umem_dmabuf));
+			return -ENOMEM;
+		}
+
+		qp->umem = &umem_dmabuf->umem;
+	} else {
+		qp->umem = qp_umem_get(dev, qp, udata, pd, &ucmd);
+	}
+
+	if (IS_ERR(qp->umem)) {
+		ibdev_err(&dev->ib_dev, "umem_get failed\n");
+		err = PTR_ERR(qp->umem);
+		goto err_uuar;
+	}
+
+	xsc_ib_cont_pages(qp->umem, ucmd.buf_addr, &npages, &page_shift,
+			  &ncont);
+	if (ncont != npages) {
+		/* TODO: peer memory support failed */
+		page_shift = PAGE_SHIFT;
+		ncont = npages;
+	}
+
+	hw_npages = DIV_ROUND_UP(qp->buf_size, PAGE_SIZE_4K);
+	err = xsc_ib_get_buf_offset(ucmd.buf_addr, page_shift, &offset);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "bad offset:%d\n", offset);
+		goto err_umem;
+	}
+	ibdev_dbg(&dev->ib_dev, "npage:%d, page_shift:%d, ncont:%d, offset:%d, hw_npages %d\n",
+		  npages, page_shift, ncont, offset, hw_npages);
+
+	*inlen = sizeof(**in) + sizeof(*((*in)->req.pas)) * hw_npages;
+	*in = xsc_vzalloc(*inlen);
+	if (!*in) {
+		err = -ENOMEM;
+		goto err_umem;
+	}
+	xsc_ib_populate_pas(dev, qp->umem, page_shift, (*in)->req.pas, hw_npages, true);
+	(*in)->req.pa_num = cpu_to_be16(hw_npages);
+
+	err = ib_copy_to_udata(udata, resp, sizeof(*resp));
+	if (err) {
+		ibdev_err(&dev->ib_dev, "failed to copy to udata, err=%d\n", err);
+		goto err_umem;
+	}
+	qp->create_type = XSC_QP_USER;
+
+	return 0;
+
+err_umem:
+	ib_umem_release(qp->umem);
+
+err_uuar:
+	return err;
+}
+
+static void destroy_qp_user(struct ib_pd *__maybe_unused pd, struct xsc_ib_qp *qp)
+{
+	ib_umem_release(qp->umem);
+}
+
 #define MAX_QP1_SQ_HDR_SIZE_V2	512
 #define MAX_QP1_SQ_HDR_SIZE	86
 	/* Ethernet header	=  14 */
@@ -57,6 +319,690 @@ static void *get_seg_wqe(void *first, int n)
 	/* iCRC			=   4 */
 #define MAX_QP1_RQ_HDR_SIZE_V2	512
 
+static int create_kernel_qp(struct xsc_ib_dev *dev,
+			    struct ib_qp_init_attr *init_attr,
+			    struct xsc_ib_qp *qp,
+			    struct xsc_create_qp_mbox_in **in, int *inlen)
+{
+	int err;
+	int sq_size;
+	int hw_npages;
+
+	sq_size = calc_sq_size(dev, init_attr, qp);
+	if (sq_size < 0) {
+		err = -EINVAL;
+		ibdev_err(&dev->ib_dev, "err %d\n", err);
+		return err;
+	}
+
+	qp->rq.ds_cnt = qp->rq.wqe_cnt << (qp->rq.wqe_shift - XSC_BASE_WQE_SHIFT);
+	qp->rq.offset = 0;
+	qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+	qp->buf_size = qp->sq.offset + sq_size;
+	qp->send_psn = 0;
+
+	err = xsc_buf_alloc(dev->xdev, qp->buf_size, PAGE_SIZE, &qp->buf);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "failed to alloc qp buffer,err=%d\n", err);
+		return err;
+	}
+
+	qp->sq.qend = qp->buf.direct.buf + qp->sq.offset + sq_size;
+	hw_npages = DIV_ROUND_UP(qp->buf_size, PAGE_SIZE_4K);
+	*inlen = sizeof(**in) + sizeof(*(*in)->req.pas) * hw_npages;
+	*in = xsc_vzalloc(*inlen);
+	if (!*in) {
+		err = -ENOMEM;
+		goto err_buf;
+	}
+
+	xsc_fill_page_array(&qp->buf, (*in)->req.pas, hw_npages);
+	(*in)->req.pa_num = cpu_to_be16(hw_npages);
+
+	qp->sq.wrid = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.wrid), GFP_KERNEL);
+	qp->sq.wr_data = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.wr_data), GFP_KERNEL);
+	qp->rq.wrid = kcalloc(qp->rq.wqe_cnt, sizeof(*qp->rq.wrid), GFP_KERNEL);
+	qp->sq.w_list = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.w_list), GFP_KERNEL);
+	qp->sq.wqe_head = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.wqe_head), GFP_KERNEL);
+	qp->sq.wr_opcode = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.wr_opcode), GFP_KERNEL);
+	qp->sq.need_flush = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.need_flush), GFP_KERNEL);
+	qp->sq.prev_ce_wqe = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.prev_ce_wqe), GFP_KERNEL);
+	qp->sq.last_comp_ce_wqe = -1;
+	qp->sq.last_post_ce_wqe = -1;
+
+	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid || !qp->sq.prev_ce_wqe ||
+	    !qp->sq.w_list || !qp->sq.wqe_head || !qp->sq.wr_opcode || !qp->sq.need_flush) {
+		err = -ENOMEM;
+		goto err_wrid;
+	}
+	qp->create_type = XSC_QP_KERNEL;
+
+	if (init_attr->qp_type == IB_QPT_GSI) {
+		qp->sq.mad_index = 0;
+		qp->sq.mad_queue_depth = MAD_QUEUE_DEPTH;
+		qp->sq.hdr_size = MAX_QP1_SQ_HDR_SIZE_V2 * MAD_QUEUE_DEPTH;
+		qp->sq.hdr_buf = dma_alloc_coherent(dev->ib_dev.dma_device,
+						    qp->sq.hdr_size,
+						    &qp->sq.hdr_dma,
+						    GFP_KERNEL);
+		if (!qp->sq.hdr_buf) {
+			err = -ENOMEM;
+			ibdev_err(&dev->ib_dev, "Failed to create sq_hdr_buf");
+			goto err_wrid;
+		}
+	}
+
+	return 0;
+
+err_wrid:
+	kfree(qp->sq.prev_ce_wqe);
+	kfree(qp->sq.need_flush);
+	kfree(qp->sq.wr_opcode);
+	kfree(qp->sq.wqe_head);
+	kfree(qp->sq.w_list);
+	kfree(qp->sq.wrid);
+	kfree(qp->sq.wr_data);
+	kfree(qp->rq.wrid);
+
+err_buf:
+	xsc_buf_free(dev->xdev, &qp->buf);
+	return err;
+}
+
+static void destroy_qp_kernel(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp)
+{
+	if (qp->sq.hdr_buf)
+		dma_free_coherent(dev->ib_dev.dma_device, qp->sq.hdr_size,
+				  qp->sq.hdr_buf, qp->sq.hdr_dma);
+	kfree(qp->sq.prev_ce_wqe);
+	kfree(qp->sq.need_flush);
+	kfree(qp->sq.wr_opcode);
+	kfree(qp->sq.wqe_head);
+	kfree(qp->sq.w_list);
+	kfree(qp->sq.wrid);
+	kfree(qp->sq.wr_data);
+	kfree(qp->rq.wrid);
+	xsc_buf_free(dev->xdev, &qp->buf);
+}
+
+static u8 ib_to_xsc_qp_type(enum ib_qp_type qp_type, __u32 flags)
+{
+	if (qp_type == IB_QPT_RC) {
+		if (flags & XSC_QP_FLAG_WORC)
+			return XSC_QUEUE_TYPE_WORC;
+		else
+			return XSC_QUEUE_TYPE_RDMA_RC;
+	} else if ((qp_type == IB_QPT_GSI) || (qp_type == IB_QPT_SMI)) {
+		return XSC_QUEUE_TYPE_RDMA_MAD;
+	} else if (qp_type == IB_QPT_RAW_PACKET) {
+		if (flags & XSC_QP_FLAG_RAWPACKET_TSO)
+			return XSC_QUEUE_TYPE_RAW_TSO;
+		else if (flags & XSC_QP_FLAG_RAWPACKET_TX)
+			return XSC_QUEUE_TYPE_RAW_TX;
+		else if (flags & XSC_QP_FLAG_RAWPACKET_SNIFFER)
+			return XSC_QUEUE_TYPE_SNIFFER;
+		else
+			return XSC_QUEUE_TYPE_RAW;
+	} else {
+		return XSC_QUEUE_TYPE_INVALID;
+	}
+}
+
+static void get_cqs(enum ib_qp_type qp_type,
+		    struct ib_cq *ib_send_cq, struct ib_cq *ib_recv_cq,
+		    struct xsc_ib_cq **send_cq, struct xsc_ib_cq **recv_cq)
+{
+	switch (qp_type) {
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+	case IB_QPT_RC:
+	case IB_QPT_UC:
+	case IB_QPT_UD:
+	case IB_QPT_RAW_PACKET:
+		*send_cq = ib_send_cq ? to_xcq(ib_send_cq) : NULL;
+		*recv_cq = ib_recv_cq ? to_xcq(ib_recv_cq) : NULL;
+		break;
+	default:
+		*send_cq = NULL;
+		*recv_cq = NULL;
+		break;
+	}
+}
+
+static void xsc_ib_lock_cqs(struct xsc_ib_cq *send_cq, struct xsc_ib_cq *recv_cq)
+	__acquires(&send_cq->lock) __acquires(&recv_cq->lock)
+{
+	if (send_cq) {
+		if (recv_cq) {
+			if (send_cq->xcq.cqn < recv_cq->xcq.cqn)  {
+				spin_lock_irq(&send_cq->lock);
+				spin_lock_nested(&recv_cq->lock,
+						 SINGLE_DEPTH_NESTING);
+			} else if (send_cq->xcq.cqn == recv_cq->xcq.cqn) {
+				spin_lock_irq(&send_cq->lock);
+				__acquire(&recv_cq->lock);
+			} else {
+				spin_lock_irq(&recv_cq->lock);
+				spin_lock_nested(&send_cq->lock,
+						 SINGLE_DEPTH_NESTING);
+			}
+		} else {
+			spin_lock_irq(&send_cq->lock);
+		}
+	} else if (recv_cq) {
+		spin_lock_irq(&recv_cq->lock);
+	}
+}
+
+static void xsc_ib_unlock_cqs(struct xsc_ib_cq *send_cq, struct xsc_ib_cq *recv_cq)
+	__releases(&send_cq->lock) __releases(&recv_cq->lock)
+{
+	if (send_cq) {
+		if (recv_cq) {
+			if (send_cq->xcq.cqn < recv_cq->xcq.cqn)  {
+				spin_unlock(&recv_cq->lock);
+				spin_unlock_irq(&send_cq->lock);
+			} else if (send_cq->xcq.cqn == recv_cq->xcq.cqn) {
+				__release(&recv_cq->lock);
+				spin_unlock_irq(&send_cq->lock);
+			} else {
+				spin_unlock(&send_cq->lock);
+				spin_unlock_irq(&recv_cq->lock);
+			}
+		} else {
+			spin_unlock_irq(&send_cq->lock);
+		}
+	} else if (recv_cq) {
+		spin_unlock_irq(&recv_cq->lock);
+	}
+}
+
+static int create_qp_common(struct xsc_ib_dev *dev, struct ib_pd *pd,
+			    struct ib_qp_init_attr *init_attr,
+			    struct ib_udata *udata, struct xsc_ib_qp *qp)
+{
+	struct xsc_ib_create_qp_resp resp;
+	struct xsc_create_qp_mbox_in *in = NULL;
+	struct xsc_ib_create_qp ucmd;
+	struct xsc_ib_cq *send_cq;
+	struct xsc_ib_cq *recv_cq;
+	struct xsc_srq_qp_node *qp_node;
+	int inlen = sizeof(*in);
+	int err;
+	char buf[256];
+	char *ptr = buf;
+	int ret = 0;
+
+	mutex_init(&qp->mutex);
+	spin_lock_init(&qp->sq.lock);
+	spin_lock_init(&qp->rq.lock);
+	spin_lock_init(&qp->lock);
+
+	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
+		qp->sq_signal_bits = XSC_WQE_CTRL_CQ_UPDATE;
+
+	if (pd->uobject) {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
+			ibdev_err(&dev->ib_dev, "failed to copy from udata\n");
+			return -EFAULT;
+		}
+	}
+
+	qp->has_rq = qp_has_rq(init_attr);
+
+	err = set_rq_size(dev, init_attr, qp->has_rq,
+			  qp, pd->uobject ? &ucmd : NULL);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "failed to set rq size %d\n", err);
+		return err;
+	}
+
+	if (pd->uobject) {
+		err = create_user_qp(dev, pd, qp, udata, &in, &resp, &inlen);
+		if (err)
+			ibdev_err(&dev->ib_dev, "failed to create user qp, err = %d\n", err);
+	} else {
+		err = create_kernel_qp(dev, init_attr, qp, &in, &inlen);
+		if (err)
+			ibdev_err(&dev->ib_dev, "failed to create kernel qp, err = %d\n", err);
+		else
+			qp->pa_lkey = to_xpd(pd)->pa_lkey;
+	}
+
+	if (err)
+		return err;
+
+	if (is_sqp(init_attr->qp_type))
+		qp->port = init_attr->port_num;
+
+	if (is_qp1(init_attr->qp_type))
+		in->req.input_qpn = cpu_to_be16(1);
+
+	in->req.pdn = cpu_to_be32(to_xpd(pd)->pdn);
+
+	if (qp->rq.ds_cnt)
+		in->req.log_rq_sz = ilog2(qp->rq.ds_cnt);
+
+	if (qp->sq.ds_cnt)
+		in->req.log_sq_sz = ilog2(qp->sq.ds_cnt);
+	else
+		in->req.log_sq_sz = ilog2(0x80);
+
+	if (init_attr->send_cq) {
+		qp->send_cq = init_attr->send_cq;
+		in->req.cqn_send = to_xcq(init_attr->send_cq)->xcq.cqn;
+		in->req.cqn_send = cpu_to_be16(in->req.cqn_send);
+	}
+
+	if (init_attr->recv_cq) {
+		qp->recv_cq = init_attr->recv_cq;
+		in->req.cqn_recv = to_xcq(init_attr->recv_cq)->xcq.cqn;
+		in->req.cqn_recv = cpu_to_be16(in->req.cqn_recv);
+	}
+
+	in->req.qp_type = ib_to_xsc_qp_type(init_attr->qp_type, pd->uobject ?
+					    ucmd.flags : 0);
+
+	if (in->req.qp_type == XSC_QUEUE_TYPE_INVALID) {
+		ibdev_err(&dev->ib_dev, "invalid qp type:%d\n", init_attr->qp_type);
+		goto err_create;
+	}
+	in->req.glb_funcid = cpu_to_be16(dev->xdev->glb_func_id);
+	in->req.page_shift = PAGE_SHIFT;
+
+	qp->xqp.qp_type_internal = in->req.qp_type;
+
+	err = xsc_core_create_qp(dev->xdev, &qp->xqp, in, inlen);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "create qp failed, err=%d\n", err);
+		goto err_create;
+	}
+
+	qp->doorbell_qpn = qp->xqp.qpn;
+
+	qp->xqp.event = xsc_ib_qp_event;
+	qp->xqp.qp_type = init_attr->qp_type;
+	ret += snprintf(ptr + ret, 256 - ret, "pdn=%d,", to_xpd(pd)->pdn);
+	ret += snprintf(ptr + ret, 256 - ret, "log_rq_sz=%d,", in->req.log_rq_sz);
+	ret += snprintf(ptr + ret, 256 - ret, "log_sq_sz=%d,", in->req.log_sq_sz);
+	ret += snprintf(ptr + ret, 256 - ret, "scqn=%d,", to_xcq(init_attr->send_cq)->xcq.cqn);
+	ret += snprintf(ptr + ret, 256 - ret, "rcqn=%d", to_xcq(init_attr->recv_cq)->xcq.cqn);
+
+	get_cqs(init_attr->qp_type, init_attr->send_cq, init_attr->recv_cq, &send_cq, &recv_cq);
+	xsc_ib_lock_cqs(send_cq, recv_cq);
+	if (send_cq)
+		list_add_tail(&qp->cq_send_list, &send_cq->send_qp_list);
+	if (recv_cq)
+		list_add_tail(&qp->cq_recv_list, &recv_cq->recv_qp_list);
+	xsc_ib_unlock_cqs(send_cq, recv_cq);
+
+	if (!pd->uobject && init_attr->srq) {
+		qp_node = kvzalloc_obj(*qp_node, GFP_KERNEL);
+		if (!qp_node)
+			goto err_create;
+		qp_node->ibqp = &qp->ibqp;
+		qp_node->qp_id = qp->xqp.qpn;
+		ibdev_dbg(&dev->ib_dev, "qpn:%u add into srq_qp_list\n", qp_node->qp_id);
+		list_add_tail(&qp_node->entry, &to_xsrq(init_attr->srq)->xsrq.srq_qp_list);
+	}
+
+	qp->xqp.qp_protocol_mode = dev->xdev->rdma_proto_mode;
+
+	ibdev_dbg(&dev->ib_dev, "succeeded to create qp:%d, %s\n", qp->xqp.qpn, buf);
+
+	xsc_vfree(in);
+
+	return 0;
+
+err_create:
+	if (qp->create_type == XSC_QP_USER)
+		destroy_qp_user(pd, qp);
+	else if (qp->create_type == XSC_QP_KERNEL)
+		destroy_qp_kernel(dev, qp);
+
+	xsc_vfree(in);
+	return err;
+}
+
+static struct xsc_ib_pd *get_pd(struct xsc_ib_qp *qp)
+{
+	return to_xpd(qp->ibqp.pd);
+}
+
+static void destroy_qp_common(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp)
+{
+	struct xsc_ib_cq *send_cq = NULL;
+	struct xsc_ib_cq *recv_cq = NULL;
+	struct xsc_modify_qp_mbox_in *in;
+	int err;
+
+	in = kzalloc_obj(*in, GFP_KERNEL);
+	if (!in)
+		return;
+
+	if (qp->xqp.qp_type_internal == XSC_QUEUE_TYPE_RAW ||
+	    qp->xqp.qp_type_internal == XSC_QUEUE_TYPE_RAW_TSO ||
+	    qp->xqp.qp_type_internal == XSC_QUEUE_TYPE_RAW_TX ||
+	    qp->state != IB_QPS_RESET)
+		if (xsc_core_qp_modify(dev->xdev, to_xsc_state(qp->state),
+				       XSC_QP_STATE_RST, in, sizeof(*in), &qp->xqp))
+			ibdev_warn(&dev->ib_dev, "modify QP %06x to RESET failed\n", qp->xqp.qpn);
+
+	get_cqs(qp->xqp.qp_type, qp->ibqp.send_cq, qp->ibqp.recv_cq, &send_cq, &recv_cq);
+	xsc_ib_lock_cqs(send_cq, recv_cq);
+	if (send_cq)
+		list_del(&qp->cq_send_list);
+
+	if (recv_cq)
+		list_del(&qp->cq_recv_list);
+
+	if (qp->create_type == XSC_QP_KERNEL) {
+		__xsc_ib_cq_clean(recv_cq, qp->xqp.qpn);
+		if (send_cq != recv_cq)
+			__xsc_ib_cq_clean(send_cq, qp->xqp.qpn);
+	}
+	xsc_ib_unlock_cqs(send_cq, recv_cq);
+
+	err = xsc_core_destroy_qp(dev->xdev, &qp->xqp);
+	if (err)
+		ibdev_warn(&dev->ib_dev, "failed to destroy QP 0x%x\n", qp->xqp.qpn);
+	kfree(in);
+
+	if (qp->create_type == XSC_QP_KERNEL)
+		destroy_qp_kernel(dev, qp);
+	else if (qp->create_type == XSC_QP_USER)
+		destroy_qp_user(&get_pd(qp)->ibpd, qp);
+}
+
+static const char *ib_qp_type_str(enum ib_qp_type type)
+{
+	switch (type) {
+	case IB_QPT_SMI:
+		return "IB_QPT_SMI";
+	case IB_QPT_GSI:
+		return "IB_QPT_GSI";
+	case IB_QPT_RC:
+		return "IB_QPT_RC";
+	case IB_QPT_UC:
+		return "IB_QPT_UC";
+	case IB_QPT_UD:
+		return "IB_QPT_UD";
+	case IB_QPT_RAW_IPV6:
+		return "IB_QPT_RAW_IPV6";
+	case IB_QPT_RAW_ETHERTYPE:
+		return "IB_QPT_RAW_ETHERTYPE";
+	case IB_QPT_RAW_PACKET:
+		return "IB_QPT_RAW_PACKET";
+	case IB_QPT_MAX:
+	default:
+		return "Invalid QP type";
+	}
+}
+
+int xsc_ib_create_qp(struct ib_qp *ibqp,
+		     struct ib_qp_init_attr *init_attr,
+		     struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev;
+	struct xsc_ib_qp *qp;
+	struct ib_pd *pd = ibqp->pd;
+	int err;
+
+	if (pd) {
+		dev = to_xdev(pd->device);
+	} else {
+		pr_warn("%s: no PD for transport %s\n", __func__,
+			ib_qp_type_str(init_attr->qp_type));
+		return -EINVAL;
+	}
+
+	if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
+		if (!is_support_rdma(dev->xdev) ||
+		    (is_qp1(init_attr->qp_type) && !is_support_rdma_cm(dev->xdev))) {
+			return -EPROTONOSUPPORT;
+		}
+	}
+
+	qp = to_xqp(ibqp);
+
+	qp->xqp.qp_type = init_attr->qp_type;
+
+	switch (init_attr->qp_type) {
+	case IB_QPT_RC:
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+	case IB_QPT_RAW_PACKET:
+		err = create_qp_common(dev, pd, init_attr, udata, qp);
+		if (err) {
+			ibdev_err(&dev->ib_dev, "create_qp_common failed\n");
+			return err;
+		}
+
+		if (is_qp0(init_attr->qp_type)) {
+			qp->ibqp.qp_num = 0;
+		} else if (is_qp1(init_attr->qp_type)) {
+			qp->ibqp.qp_num = 1;
+			dev->xdev->gsi_qpn = qp->xqp.qpn;
+		} else {
+			qp->ibqp.qp_num = qp->xqp.qpn;
+		}
+
+		break;
+
+	case IB_QPT_RAW_IPV6:
+	case IB_QPT_RAW_ETHERTYPE:
+	case IB_QPT_MAX:
+	default:
+		ibdev_err(&dev->ib_dev, "unsupported qp type %d\n",
+			  init_attr->qp_type);
+		/* Don't support raw QPs */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int xsc_ib_destroy_qp(struct ib_qp *qp, struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(qp->device);
+	struct xsc_ib_qp *xqp = to_xqp(qp);
+	struct xsc_err_state_qp_node *tmp = NULL, *err_rq_node = NULL, *err_sq_node = NULL;
+	struct xsc_srq_qp_node *qp_node = NULL, *tmp_qp_node = NULL;
+	unsigned long flags;
+	struct xsc_ib_srq *xsrq;
+
+	if (qp->qp_type == IB_QPT_RC) {
+		if (xqp->recv_cq) {
+			spin_lock_irq(&to_xcq(xqp->recv_cq)->lock);
+			list_for_each_entry_safe(err_rq_node, tmp,
+						 &to_xcq(xqp->recv_cq)->err_state_qp_list, entry) {
+				if (err_rq_node->qp_id == xqp->xqp.qpn && !err_rq_node->is_sq) {
+					list_del(&err_rq_node->entry);
+					kfree(err_rq_node);
+				}
+			}
+			spin_unlock_irq(&to_xcq(xqp->recv_cq)->lock);
+		}
+
+		if (xqp->send_cq) {
+			spin_lock_irq(&to_xcq(xqp->send_cq)->lock);
+			list_for_each_entry_safe(err_sq_node, tmp,
+						 &to_xcq(xqp->send_cq)->err_state_qp_list, entry) {
+				if (err_sq_node->qp_id == xqp->xqp.qpn && err_sq_node->is_sq) {
+					list_del(&err_sq_node->entry);
+					kfree(err_sq_node);
+				}
+			}
+			spin_unlock_irq(&to_xcq(xqp->send_cq)->lock);
+		}
+	}
+
+	if (xqp->create_type == XSC_QP_KERNEL && qp->srq) {
+		if (!to_xsrq(qp->srq) || list_empty(&to_xsrq(qp->srq)->xsrq.srq_qp_list))
+			ibdev_warn(&dev->ib_dev, "srq_qp_list is empty!\n");
+
+		xsrq = to_xsrq(qp->srq);
+		spin_lock_irqsave(&xsrq->lock, flags);
+		xsc_restore_cache_srq_wrs(xsrq, xqp);
+		list_for_each_entry_safe(qp_node, tmp_qp_node,
+					 &to_xsrq(qp->srq)->xsrq.srq_qp_list, entry) {
+			if (qp_node->qp_id == xqp->xqp.qpn) {
+				to_xsrq(qp->srq)->qp_num--;
+				ibdev_dbg(&dev->ib_dev, "srq_qp_list del node qpn:%u qp_num:%d\n",
+					  qp_node->qp_id, to_xsrq(qp->srq)->qp_num);
+				list_del_init(&qp_node->entry);
+				kvfree(qp_node);
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&xsrq->lock, flags);
+	}
+
+	destroy_qp_common(dev, xqp);
+
+	return 0;
+}
+
+static inline u16 xsc_calc_udp_sport(u32 lqpn, u32 rqpn)
+{
+	unsigned char *p;
+	u8 ports[2];
+	u16 sport;
+	u64 tqpn;
+
+	tqpn = ((u64)(lqpn & 0xffffff)) * ((u64)(rqpn & 0xffffff));
+	p = (unsigned char *)&tqpn;
+	ports[0] = p[0] ^ p[2] ^ p[4];
+	ports[1] = p[1] ^ p[3] ^ p[5];
+	sport = *((u16 *)ports) | 0xC000;
+
+	return sport;
+}
+
+static inline void xsc_path_set_udp_sport(struct xsc_qp_path *path,
+					  const struct rdma_ah_attr *ah,
+					  u32 lqpn, u32 rqpn)
+{
+	if ((ah->grh.flow_label & UDP_SPORT_MASK) != 0) {
+		if ((ah->grh.flow_label & UDP_SPORT_MASK_EN) == 0)
+			path->sport = cpu_to_be16(rdma_flow_label_to_udp_sport(ah->grh.flow_label));
+		else
+			path->sport = cpu_to_be16((ah->grh.flow_label & UDP_SPORT_MASK) >>
+							UDP_SPORT_OFFSET);
+	} else {
+		path->sport = cpu_to_be16(xsc_calc_udp_sport(lqpn, rqpn));
+	}
+}
+
+static int xsc_set_path(struct xsc_ib_dev *dev, const struct rdma_ah_attr *ah,
+			struct xsc_qp_path *path, u8 port, int attr_mask,
+			u32 path_flags, const struct ib_qp_attr *attr, struct xsc_ib_qp *qp)
+{
+	struct ib_global_route *grh = rdma_ah_retrieve_grh((struct rdma_ah_attr *)ah);
+	union ib_gid *dgid = &grh->dgid;
+	const struct ib_gid_attr *sgid_attr = grh->sgid_attr;
+	union ib_gid *sgid = &((struct ib_gid_attr *)sgid_attr)->gid;
+	union {
+		struct sockaddr     _sockaddr;
+		struct sockaddr_in  _sockaddr_in;
+		struct sockaddr_in6 _sockaddr_in6;
+	} sgid_addr, dgid_addr;
+	int force_pcp, force_dscp;
+	char buf[256] = {0};
+	char *ptr = buf;
+	int ret = 0;
+
+	if (ah->type == RDMA_AH_ATTR_TYPE_ROCE) {
+		if (!(rdma_ah_get_ah_flags(ah) & IB_AH_GRH))
+			return -EINVAL;
+
+		if (qp->ibqp.qp_type == IB_QPT_RC ||
+		    qp->ibqp.qp_type == IB_QPT_UC) {
+			if (((ah->grh.flow_label & UDP_SPORT_MASK_EN) != 0) &&
+			    qp->xqp.qp_protocol_mode == RDMA_PROTO_VEROCE) {
+				ibdev_err(&dev->ib_dev,
+					  "qp type is  RDMA_PROTO_VEROCE, using flow_label to set the UDP sport %d is not allowed.",
+					   (ah->grh.flow_label & UDP_SPORT_MASK) >>
+					   UDP_SPORT_OFFSET);
+				return -EINVAL;
+			}
+			xsc_path_set_udp_sport(path, ah, qp->ibqp.qp_num, attr->dest_qp_num);
+		}
+
+		if (sgid_attr->gid_type != IB_GID_TYPE_ROCE_UDP_ENCAP) {
+			ibdev_err(&dev->ib_dev, "gid type not ROCEv2\n");
+			return -EINVAL;
+		}
+
+		force_dscp = dev->xdev->priv.force_dscp;
+		if (force_dscp == DSCP_PCP_UNSET)
+			path->ecn_dscp = (grh->traffic_class >> 2) & 0x3f;
+		else
+			path->ecn_dscp = force_dscp;
+		path->hop_limit = grh->hop_limit;
+
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, dgid);
+
+		if (sgid_addr._sockaddr.sa_family == AF_INET &&
+		    dgid_addr._sockaddr.sa_family == AF_INET) {
+			memcpy(path->sip, &sgid_addr._sockaddr_in.sin_addr.s_addr,
+			       sizeof(struct in_addr));
+			memcpy(path->dip, &dgid_addr._sockaddr_in.sin_addr.s_addr,
+			       sizeof(struct in_addr));
+			path->af_type = AF_INET;
+			ret += snprintf(ptr + ret, 256 - ret, "sip=%#x,",
+					be32_to_cpu(path->sip[0]));
+			ret += snprintf(ptr + ret, 256 - ret, "dip=%#x,",
+					be32_to_cpu(path->dip[0]));
+		} else if (sgid_addr._sockaddr.sa_family == AF_INET6 &&
+			   dgid_addr._sockaddr.sa_family == AF_INET6) {
+			memcpy(path->sip, &sgid_addr._sockaddr_in6.sin6_addr.s6_addr,
+			       sizeof(path->sip));
+			memcpy(path->dip, &dgid_addr._sockaddr_in6.sin6_addr.s6_addr,
+			       sizeof(path->dip));
+			path->af_type = AF_INET6;
+			ret += snprintf(ptr + ret, 256 - ret, "sip=%08x%08x%08x%08x,",
+					be32_to_cpu(path->sip[0]), be32_to_cpu(path->sip[1]),
+					be32_to_cpu(path->sip[2]), be32_to_cpu(path->sip[3]));
+			ret += snprintf(ptr + ret, 256 - ret, "dip=%08x%08x%08x%08x,",
+					be32_to_cpu(path->dip[0]), be32_to_cpu(path->dip[1]),
+					be32_to_cpu(path->dip[2]), be32_to_cpu(path->dip[3]));
+		} else {
+			return -EINVAL;
+		}
+
+		ether_addr_copy(path->smac, dev->netdev->dev_addr);
+
+		memcpy(path->dmac, ah->roce.dmac, sizeof(ah->roce.dmac));
+		ret += snprintf(ptr + ret, 256 - ret, "smac=%02x%02x%02x%02x%02x%02x,",
+				path->smac[0], path->smac[1], path->smac[2],
+				path->smac[3], path->smac[4], path->smac[5]);
+		ret += snprintf(ptr + ret, 256 - ret, "dmac=%02x%02x%02x%02x%02x%02x",
+				path->dmac[0], path->dmac[1], path->dmac[2],
+				path->dmac[3], path->dmac[4], path->dmac[5]);
+		if (is_zero_ether_addr(path->dmac))
+			ibdev_err(&dev->ib_dev, "path dmac is zero!\n");
+		else
+			ibdev_dbg(&dev->ib_dev, "ib path info:%s\n", buf);
+
+		if (is_vlan_dev(sgid_attr->ndev)) {
+			path->vlan_valid = 1;
+			path->vlan_id = cpu_to_be16(vlan_dev_vlan_id(sgid_attr->ndev));
+
+			force_pcp = dev->xdev->priv.force_pcp;
+			if (force_pcp == DSCP_PCP_UNSET)
+				path->dci_cfi_prio_sl = (ah->sl & 0x7);
+			else
+				path->dci_cfi_prio_sl = force_pcp;
+		} else {
+			path->vlan_valid = 0;
+		}
+	}
+	ibdev_dbg(&dev->ib_dev, "path dscp %d pcp %d\n", path->ecn_dscp, path->dci_cfi_prio_sl);
+	return 0;
+}
+
 static inline void xsc_ib_trigger_cq_comp_handler(struct ib_cq *send_cq, struct ib_cq *recv_cq)
 {
 	if (send_cq)
@@ -127,10 +1073,285 @@ int xsc_ib_err_state_qp(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp,
 	return 0;
 }
 
+static inline void xsc_set_qp_access_flag(struct xsc_modify_qp_mbox_in *in,
+					  struct xsc_qp_context *context, int access_flags)
+{
+	in->hdr.ver = cpu_to_be16(XSC_QP_CONTEXT_V1);
+	context->qp_access_flags = 0;
+
+	if (access_flags & IB_ACCESS_REMOTE_READ)
+		context->qp_access_flags |= QP_ACCESS_REMOTE_READ;
+	if (access_flags & IB_ACCESS_REMOTE_WRITE)
+		context->qp_access_flags |= QP_ACCESS_REMOTE_WRITE;
+	if (access_flags & IB_ACCESS_REMOTE_ATOMIC)
+		context->qp_access_flags |= QP_ACCESS_REMOTE_ATOMIC;
+
+	context->qp_access_flags = cpu_to_be32(context->qp_access_flags);
+}
+
+static int __xsc_ib_modify_qp(struct ib_qp *ibqp,
+			      const struct ib_qp_attr *attr, int attr_mask,
+			      enum ib_qp_state cur_state, enum ib_qp_state new_state,
+			      const struct xsc_ib_modify_qp *ucmd,
+			      struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(ibqp->device);
+	struct xsc_ib_qp *qp = to_xqp(ibqp);
+	struct xsc_ib_cq *send_cq, *recv_cq;
+	struct xsc_qp_context *context;
+	struct xsc_modify_qp_mbox_in *in;
+	struct xsc_qp_path path;
+	int sqd_event;
+	int err;
+	char buf[256] = {0};
+	char *ptr = buf;
+	int ret = 0;
+	struct xsc_core_device *xdev = dev->xdev;
+
+	in = kzalloc_obj(*in, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	context = &qp->ctx;
+
+	if (attr_mask & IB_QP_PATH_MTU) {
+		if (attr->path_mtu != IB_MTU_1024 &&
+		    attr->path_mtu != IB_MTU_4096 &&
+		    attr->path_mtu != IB_MTU_8192) {
+			ibdev_warn(&dev->ib_dev, "invalid mtu %d\n", attr->path_mtu);
+		}
+
+		if (attr->path_mtu < IB_MTU_4096)
+			context->mtu_mode = 0;
+		else if (attr->path_mtu < IB_MTU_8192)
+			context->mtu_mode = 1;
+		else
+			context->mtu_mode = 2;
+		ret = snprintf(ptr, 256, "path_mtu=%d,", attr->path_mtu);
+	}
+
+	if (attr_mask & IB_QP_DEST_QPN) {
+		context->remote_qpn = cpu_to_be32(attr->dest_qp_num);
+		ret += snprintf(ptr + ret, 256 - ret, "dest_qp_num=%d,", attr->dest_qp_num);
+	}
+
+	if (attr_mask & IB_QP_AV) {
+		err = xsc_set_path(dev, &attr->ah_attr, &path,
+				   attr_mask & IB_QP_PORT ? attr->port_num : qp->port,
+				   attr_mask, 0, attr, qp);
+		if (err)
+			goto out;
+
+		context->src_udp_port = path.sport;
+		context->dscp = path.ecn_dscp;
+		context->hop_limit = path.hop_limit;
+		context->ip_type = (path.af_type == AF_INET ? 0 : 1);
+		context->ip_type = cpu_to_be16(context->ip_type);
+		memcpy(context->dip, path.dip, sizeof(context->dip));
+		memcpy(context->sip, path.sip, sizeof(context->sip));
+		memcpy(context->dmac, path.dmac, sizeof(path.dmac));
+		memcpy(context->smac, path.smac, sizeof(path.smac));
+
+		context->vlan_valid = path.vlan_valid;
+		context->dci_cfi_prio_sl = path.dci_cfi_prio_sl;
+		context->vlan_id = path.vlan_id;
+	}
+
+	if (attr_mask & IB_QP_RNR_RETRY) {
+		context->rnr_retry = attr->rnr_retry;
+		ret += snprintf(ptr + ret, 256 - ret, "rnr_retry=%d,", attr->rnr_retry);
+	}
+
+	if (attr_mask & IB_QP_RETRY_CNT) {
+		context->retry_cnt = attr->retry_cnt;
+		ret += snprintf(ptr + ret, 256 - ret, "retry_cnt=%d,", attr->retry_cnt);
+	}
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC && attr->max_rd_atomic)
+		context->max_sra = min_t(u32, attr->max_rd_atomic, dev->xdev->caps.max_ra_req_qp);
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC && attr->max_dest_rd_atomic)
+		context->max_rra = attr->max_dest_rd_atomic;
+
+	if (attr_mask & IB_QP_SQ_PSN) {
+		context->next_send_psn = cpu_to_be32(attr->sq_psn);
+		ret += snprintf(ptr + ret, 256 - ret, "sq_psn=%#x,", attr->sq_psn);
+	}
+
+	if (attr_mask & IB_QP_RQ_PSN) {
+		context->next_recv_psn = cpu_to_be32(attr->rq_psn);
+		ret += snprintf(ptr + ret, 256 - ret, "rq_psn=%#x,", attr->rq_psn);
+	}
+
+	if (attr_mask & IB_QP_ACCESS_FLAGS) {
+		xsc_set_qp_access_flag(in, context, attr->qp_access_flags);
+		ret += snprintf(ptr + ret, 256 - ret, "qp_access_flags=%#x,\n",
+				attr->qp_access_flags);
+	}
+
+	if (udata && udata->inlen && attr_mask & IB_QP_STATE && new_state == IB_QPS_RTR) {
+		if (!ucmd->profile &&
+		    xdev->rdma_proto_mode == RDMA_PROTO_VEROCE) {
+			context->swith_qp_type = 1;
+			context->qp_access_flags |= QP_ACCESS_MODIFY_QP_TYPE;
+			context->qp_access_flags = cpu_to_be32(context->qp_access_flags);
+			qp->xqp.qp_protocol_mode =
+				ucmd->profile ? RDMA_PROTO_VEROCE : RDMA_PROTO_ROCEV2;
+			in->hdr.ver = cpu_to_be16(XSC_QP_CONTEXT_V2);
+			ibdev_dbg(&dev->ib_dev,
+				  "local is VEROCE,remote is RoCEv2, switch qp_type from VEROCE to RoCEv2!\n");
+		}
+	}
+
+	if (attr_mask & IB_QP_STATE && new_state == IB_QPS_RESET)
+		qp->xqp.qp_protocol_mode = xdev->rdma_proto_mode;
+
+	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
+	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
+		sqd_event = 1;
+	else
+		sqd_event = 0;
+
+	memcpy(&in->ctx, context, sizeof(*context));
+	err = xsc_core_qp_modify(xdev, to_xsc_state(cur_state),
+				 to_xsc_state(new_state), in, sqd_event,
+				 &qp->xqp);
+	if (err) {
+		ibdev_err(&dev->ib_dev, "failed to modify qp[%d] from %s to %s\n",
+			  qp->xqp.qpn, qp_state_to_str(cur_state), qp_state_to_str(new_state));
+		goto out;
+	}
+
+	qp->state = new_state;
+	ibdev_dbg(&dev->ib_dev, "succeeded to modify qp[%d] from %s to %s with attr_mask=%#x, %s\n",
+		  qp->xqp.qpn, qp_state_to_str(cur_state), qp_state_to_str(new_state),
+		    attr_mask, buf);
+
+	if (qp->state == IB_QPS_INIT) {
+		qp->post_recv_invalid = false;
+		qp->post_send_invalid = false;
+	}
+
+	if (attr_mask & IB_QP_ACCESS_FLAGS)
+		qp->atomic_rd_en = attr->qp_access_flags;
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		qp->resp_depth = attr->max_dest_rd_atomic;
+	if (attr_mask & IB_QP_PORT)
+		qp->port = attr->port_num;
+	if (attr_mask & IB_QP_ALT_PATH)
+		qp->alt_port = attr->alt_port_num;
+
+	/*
+	 * If we moved a kernel QP to RESET, clean up all old CQ
+	 * entries and reinitialize the QP.
+	 */
+	if (new_state == IB_QPS_RESET && !ibqp->uobject) {
+		get_cqs(qp->xqp.qp_type, qp->ibqp.send_cq, qp->ibqp.recv_cq, &send_cq, &recv_cq);
+		xsc_ib_cq_clean(recv_cq, qp->xqp.qpn);
+		if (send_cq != recv_cq)
+			xsc_ib_cq_clean(send_cq, qp->xqp.qpn);
+
+		qp->rq.head = 0;
+		qp->rq.tail = 0;
+		qp->sq.head = 0;
+		qp->sq.tail = 0;
+		qp->sq.cur_post = 0;
+		qp->sq.last_poll = 0;
+		qp->sq.last_comp_ce_wqe = -1;
+		qp->sq.last_post_ce_wqe = -1;
+		qp->has_trig_cq_comp_handle = false;
+	}
+
+out:
+	kfree(in);
+	return err;
+}
+
 enum xsc_ib_qp_ex_attr_mask {
 	XSC_IB_QP_FLUSH		= 1 << 21,
 };
 
+int xsc_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		     int attr_mask, struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(ibqp->device);
+	struct xsc_ib_qp *qp = to_xqp(ibqp);
+	enum ib_qp_state cur_state, new_state;
+	int err = -EINVAL;
+	int wr_num;
+	struct xsc_ib_srq *srq;
+	unsigned long flags;
+	struct xsc_ib_cq *send_cq;
+	struct xsc_ib_cq *recv_cq;
+	struct xsc_ib_modify_qp ucmd = {};
+
+	if (udata && udata->inlen) {
+		if (udata->inlen < offsetofend(typeof(ucmd), profile))
+			return -EINVAL;
+
+		if (ib_copy_from_udata(&ucmd, udata,
+				       min(udata->inlen, sizeof(ucmd))))
+			return -EFAULT;
+	}
+
+	mutex_lock(&qp->mutex);
+
+	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
+	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
+
+	if ((attr_mask & IB_QP_PORT) &&
+	    (attr->port_num == 0 || attr->port_num > dev->xdev->caps.num_ports)) {
+		ibdev_err(&dev->ib_dev, "error port num\n");
+		goto out;
+	}
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
+	    attr->max_dest_rd_atomic > dev->xdev->caps.max_ra_res_qp) {
+		ibdev_err(&dev->ib_dev, "dest rd atomic:%u exeeded", attr->max_dest_rd_atomic);
+		goto out;
+	}
+
+	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
+		err = 0;
+		goto out;
+	}
+
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask)) {
+		ibdev_err(&dev->ib_dev, "ib_modify_qp not ok, type=%d mask=0x%x state from%d to%d\n",
+			  ibqp->qp_type, attr_mask, cur_state, new_state);
+		goto out;
+	}
+
+	err = __xsc_ib_modify_qp(ibqp, attr, attr_mask, cur_state, new_state, &ucmd, udata);
+
+	if (!err && (attr_mask & IB_QP_STATE) && !udata) {
+		get_cqs(qp->xqp.qp_type, qp->send_cq, qp->recv_cq, &send_cq, &recv_cq);
+		xsc_ib_lock_cqs(send_cq, recv_cq);
+		err = xsc_ib_err_state_qp(dev, qp, to_xsc_state(cur_state),
+					  to_xsc_state(new_state));
+		xsc_ib_unlock_cqs(send_cq, recv_cq);
+
+		if (!ibqp->srq)
+			goto out;
+
+		if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+			srq = to_xsrq(ibqp->srq);
+			spin_lock_irqsave(&srq->lock, flags);
+			srq->qp_num++;
+			wr_num = XSC_SRQ_MIN_WR_NUM;
+			ibdev_dbg(&dev->ib_dev,
+				  "SRQ %d: qp %d to INIT, post %d srq wrs, qp_num %d\n",
+				   srq->xsrq.srqn, qp->xqp.qpn, wr_num, srq->qp_num);
+			xsc_post_cache_wrs(srq, qp, wr_num, true);
+			spin_unlock_irqrestore(&srq->lock, flags);
+		}
+	}
+
+out:
+	mutex_unlock(&qp->mutex);
+	return err;
+}
+
 static int xsc_wq_overflow(struct xsc_ib_wq *wq, int nreq, struct xsc_ib_cq *cq)
 {
 	unsigned int cur;
@@ -231,6 +1452,106 @@ int xsc_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	return err;
 }
 
+static inline enum ib_qp_state to_ib_qp_state(enum xsc_qp_state xsc_state)
+{
+	switch (xsc_state) {
+	case XSC_QP_STATE_RST:      return IB_QPS_RESET;
+	case XSC_QP_STATE_INIT:     return IB_QPS_INIT;
+	case XSC_QP_STATE_RTR:      return IB_QPS_RTR;
+	case XSC_QP_STATE_RTS:      return IB_QPS_RTS;
+	case XSC_QP_STATE_SQ_DRAINING:
+	case XSC_QP_STATE_SQD:      return IB_QPS_SQD;
+	case XSC_QP_STATE_SQER:     return IB_QPS_SQE;
+	case XSC_QP_STATE_ERR:      return IB_QPS_ERR;
+	default:		     return -1;
+	}
+}
+
+static inline enum ib_mig_state to_ib_mig_state(int xsc_mig_state)
+{
+	switch (xsc_mig_state) {
+	case XSC_QP_PM_ARMED:		return IB_MIG_ARMED;
+	case XSC_QP_PM_REARM:		return IB_MIG_REARM;
+	case XSC_QP_PM_MIGRATED:	return IB_MIG_MIGRATED;
+	default: return -1;
+	}
+}
+
+int xsc_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_mask,
+		    struct ib_qp_init_attr *qp_init_attr)
+{
+	struct xsc_ib_dev *dev = to_xdev(ibqp->device);
+	struct xsc_ib_qp *qp = to_xqp(ibqp);
+	struct xsc_query_qp_mbox_out *outb;
+	struct xsc_qp_context *context;
+	int err = 0;
+
+	mutex_lock(&qp->mutex);
+
+	if (qp_attr_mask & XSC_IB_QP_FLUSH) {
+		xsc_ib_trigger_cq_comp_handler(qp->send_cq, qp->recv_cq);
+		goto out;
+	}
+
+	outb = kzalloc_obj(*outb, GFP_KERNEL);
+	if (!outb) {
+		err = -ENOMEM;
+		goto out;
+	}
+	context = &outb->ctx;
+	err = xsc_core_qp_query(dev->xdev, &qp->xqp, outb, sizeof(*outb));
+	if (err)
+		goto out_free;
+
+	if (qp->xqp.err_occurred) {
+		qp->state = IB_QPS_ERR;
+		qp->xqp.err_occurred = 0;
+	}
+	qp_attr->qp_state	     = qp->state;
+	qp_attr->path_mtu	     = context->mtu_mode ? IB_MTU_4096 : IB_MTU_1024;
+	qp_attr->rq_psn		     = be32_to_cpu(context->next_recv_psn) & 0xffffff;
+	qp_attr->sq_psn		     = be32_to_cpu(context->next_send_psn) & 0xffffff;
+	qp_attr->dest_qp_num	     = be32_to_cpu(context->remote_qpn) & 0xffffff;
+	qp_attr->sq_draining = 0;
+	qp_attr->retry_cnt	    = context->retry_cnt;
+	qp_attr->rnr_retry	    = context->rnr_retry;
+	qp_attr->cur_qp_state	     = qp_attr->qp_state;
+	qp_attr->cap.max_recv_wr     = qp->rq.wqe_cnt;
+	qp_attr->cap.max_recv_sge    = qp->rq.max_gs;
+	qp_attr->max_rd_atomic = context->max_sra;
+	qp_attr->max_dest_rd_atomic = context->max_rra;
+	qp_attr->port_num = 1;
+
+	if (!ibqp->uobject) {
+		qp_attr->cap.max_send_wr  = qp->sq.wqe_cnt;
+		qp_attr->cap.max_send_sge = qp->sq.max_gs;
+	} else {
+		qp_attr->cap.max_send_wr  = qp->sq.wqe_cnt;
+		qp_attr->cap.max_send_sge = qp->sq.max_gs;
+	}
+
+	/* We don't support inline sends for kernel QPs (yet), and we
+	 * don't know what userspace's value should be.
+	 */
+	qp_attr->cap.max_inline_data = 0;
+
+	qp_init_attr->cap	     = qp_attr->cap;
+
+	qp_init_attr->create_flags = 0;
+	if (qp->flags & XSC_IB_QP_BLOCK_MULTICAST_LOOPBACK)
+		qp_init_attr->create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
+
+	qp_init_attr->sq_sig_type = qp->sq_signal_bits & XSC_WQE_CTRL_CQ_UPDATE ?
+		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
+
+out_free:
+	kfree(outb);
+
+out:
+	mutex_unlock(&qp->mutex);
+	return err;
+}
+
 struct xsc_ib_drain_cqe {
 	struct ib_cqe cqe;
 	struct completion done;
