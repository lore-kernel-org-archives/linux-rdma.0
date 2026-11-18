Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001489;
	b=jG+x7q52z1WXoR6zPggqNUF5ETpE9srYVXFSwXVV/oLxuNYV0iQa2DLH6h3HH4XgcsfS
	 2ckkL2r3shIjj93/ux8maQaotJ1PHu8ctwKwW6os/kTITnwJ7GU0yGp5ujGWjt/CokUTi
	 2DasTJ2XOueAZiJ8orFrIwE0yIYW3wmi8sGnQWHWMwLw58Nz1VOGDV7ewi8zBb1EMvVtw
	 fykJUdwmaVwXNl/cTZSHW/AsfbkFPR4GS+ZlrRHVBkLykSx1ZT35byTJw6KiJIop7UWCM
	 9TBvEk9pTxiS9/2sGwJDOz9x8Y4pWe7uUJh2CfRoYiVxbwHg65bMpsAdPs5uuN+sgKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001489;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=YQvWfAKCe363OQOp613hpE10Y0CGIY81n06v/XIJONk=;
	b=vddBDMrOCk0HiAhxesdMvYM0ZCxdHfL/aubr4oRZbfJkJMDXp7eNPqloTdIjf2ttPNZ5
	 PoexIDi+Ly6hRjb6S5fGGENf5yg4dFd3vLPj6uuDtdcLefuH2SQwkOW2KYmdKxhERDZFj
	 gtuqmoL7xs6Au8XJUBkn+DijNAZL+TPRhM1365t5vHRVoP2p+zAbgHFBw+bfWlDZNkiVB
	 HrykR+oZyNVcNQlj54i9DaE05Xi2jceyAbIdxLGI+q1fQHkSc/zzhtAte6hUzComLznwB
	 BDaFqlLV0e3wmdUI2W2RZlN9ATxo9G6sdgp0/ukp6+s6+EErtthdN4HjIqagMlejohQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=IxBo0iLx;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ECC606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95ECC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=IxBo0iLx
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261118113126epoutp03c1764f79a455ffa4ef80c6ed44ab4b25~pIFeMQ3NE2029320293epoutp03G
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261118113126epoutp03c1764f79a455ffa4ef80c6ed44ab4b25~pIFeMQ3NE2029320293epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795001486;
	bh=YQvWfAKCe363OQOp613hpE10Y0CGIY81n06v/XIJONk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxBo0iLxGq0vnEcss2Tb85WyrdGM3zC72OwqvV9zgbgtbrVDhyBwbpPApQ5ouiXiI
	 VNXK4BUyHP6uZ2uKJiH8xjgqHgUGtpgTcG3h6AEx5xYsGe8E5I4RFrPuui4yJ73vhp
	 LtvzPVMATOCbHYF5fNin6lGce5jBd5hk9PouW0vY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261118113125epcas5p2b2bd07c02d746f6e8ac331609d5076ff~pIFdAJadq1950619506epcas5p20;
	Wed, 18 Nov 2026 11:31:25 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jTzvH6SlMz6B9m5; Wed, 18 Nov
	2026 11:31:23 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261118103457epcas5p17770752b910960b84cc259d007120965~pHUJaF8YT0474604746epcas5p13;
	Wed, 18 Nov 2026 10:34:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261118103455epsmtip28fe8236e57078601536da828dbe3e189~pHUHt8_ST0245402454epsmtip2V;
	Wed, 18 Nov 2026 10:34:55 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com
Cc: nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [RFC 4/4] nvme-rdma: support dma-buf backed requests
Date: Wed, 18 Nov 2026 16:03:27 +0530
Message-Id: <20261118103327.1788667-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118103327.1788667-1-anuj20.g@samsung.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261118103457epcas5p17770752b910960b84cc259d007120965
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261118103457epcas5p17770752b910960b84cc259d007120965
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
	<CGME20261118103457epcas5p17770752b910960b84cc259d007120965@epcas5p1.samsung.com>

From: Nitesh Shetty <nj.shetty@samsung.com>

Implement ->init_dma_buf_io_ctx so that memory exported through dma-buf,
such as GPU memory, can be registered with io_uring and used for I/O to
an nvme-rdma namespace. The initiator RNIC can then DMA directly to and
from the dma-buf memory.

Map registered dma-bufs for the RDMA device and build the request
scatterlist from the retained DMA mapping. Register each request with a
fast-registration MR so the target can only access the requested range.
PI, software RDMA and multipath are not supported.

The controller's RDMA device is only available while the admin queue
exists and may change when the controller reconnects. Serialize
attachment with queue teardown and record the RDMA device each context
was attached for.

Detaching contexts on reconnect could deadlock on requeued requests that
still hold map references. Retain the contexts and fail requests whose
queues use a different RDMA device. Detach them when the controller is
deleted. Removing an RDMA device also deletes controllers that retain
contexts attached to it.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/dmabuf.c |  50 +++++++++-
 drivers/nvme/host/dmabuf.h |  28 ++++++
 drivers/nvme/host/rdma.c   | 182 +++++++++++++++++++++++++++++++++++--
 3 files changed, 248 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/dmabuf.c b/drivers/nvme/host/dmabuf.c
index f68ffa89e56f..142da218379c 100644
--- a/drivers/nvme/host/dmabuf.c
+++ b/drivers/nvme/host/dmabuf.c
@@ -120,20 +120,61 @@ void __nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
 }
 EXPORT_SYMBOL_GPL(__nvme_remove_dmabufs);
 
+/**
+ * __nvme_dmabufs_use_owner - check whether any context has the given owner
+ * @list:	the controller's dma-buf context list
+ * @owner:	the owner to look for
+ *
+ * Return: true if a dma-buf context in @list was attached for @owner.
+ */
+bool __nvme_dmabufs_use_owner(struct nvme_dma_buf_list *list, void *owner)
+{
+	struct nvme_dma_buf_io_ctx *ctx;
+	bool found = false;
+
+	mutex_lock(&list->lock);
+	list_for_each_entry(ctx, &list->ctxs, list) {
+		if (ctx->owner == owner) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&list->lock);
+	return found;
+}
+EXPORT_SYMBOL_GPL(__nvme_dmabufs_use_owner);
+
 static const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
 	.map		= nvme_dma_buf_io_map,
 	.unmap		= nvme_dma_buf_io_unmap,
 	.release	= nvme_dma_buf_io_release,
 };
 
-static int nvme_init_io_ctx_locked(struct nvme_ctrl *ctrl,
+/**
+ * __nvme_init_dma_buf_io_ctx_locked - initialise a dma-buf I/O context
+ * @ctrl:	controller the context issues I/O to
+ * @buf_list:	the controller's dma-buf context list
+ * @attach:	attachment of the dma-buf, see __nvme_init_dma_buf_io_ctx()
+ * @owner:	identifies the device @attach was made for, may be NULL
+ * @ctx:	dma-buf I/O context to initialise
+ *
+ * Locked variant of __nvme_init_dma_buf_io_ctx(), for transports that select
+ * the device and create @attach under @buf_list->lock, which the caller must
+ * hold. The attachment requirements and ownership rules are the same.
+ *
+ * Return: 0 on success, or a negative errno code otherwise.
+ */
+int __nvme_init_dma_buf_io_ctx_locked(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
-		struct dma_buf_attachment *attach,
+		struct dma_buf_attachment *attach, void *owner,
 		struct dma_buf_io_ctx *ctx)
+	__must_hold(&buf_list->lock)
 {
 	struct nvme_dma_buf_io_ctx *nvme_ctx;
 	int ret;
 
+	lockdep_assert_held(&buf_list->lock);
+
 	if (buf_list->dead) {
 		ret = -ENODEV;
 		goto err_detach;
@@ -148,6 +189,7 @@ static int nvme_init_io_ctx_locked(struct nvme_ctrl *ctrl,
 	nvme_get_ctrl(ctrl);
 	list_add(&nvme_ctx->list, &buf_list->ctxs);
 	nvme_ctx->attach = attach;
+	nvme_ctx->owner = owner;
 	nvme_ctx->base = ctx;
 	nvme_ctx->ctrl = ctrl;
 	nvme_ctx->buf_list = buf_list;
@@ -159,6 +201,7 @@ static int nvme_init_io_ctx_locked(struct nvme_ctrl *ctrl,
 	dma_buf_detach(ctx->dmabuf, attach);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__nvme_init_dma_buf_io_ctx_locked);
 
 /*
  * @attach must have been created with nvme_dmabuf_importer_ops and @ctx as
@@ -173,7 +216,8 @@ int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 	int ret;
 
 	mutex_lock(&buf_list->lock);
-	ret = nvme_init_io_ctx_locked(ctrl, buf_list, attach, ctx);
+	ret = __nvme_init_dma_buf_io_ctx_locked(ctrl, buf_list, attach, NULL,
+						ctx);
 	mutex_unlock(&buf_list->lock);
 	return ret;
 }
diff --git a/drivers/nvme/host/dmabuf.h b/drivers/nvme/host/dmabuf.h
index 0c12ee6d3584..5ea80d65aff8 100644
--- a/drivers/nvme/host/dmabuf.h
+++ b/drivers/nvme/host/dmabuf.h
@@ -21,6 +21,8 @@ struct nvme_dma_buf_io_ctx {
 	struct nvme_dma_buf_list *buf_list;
 	struct dma_buf_io_ctx *base;
 	struct nvme_ctrl *ctrl;
+	/* transport-specific device identifier */
+	void *owner;
 	struct list_head list;
 };
 
@@ -47,10 +49,16 @@ static inline struct nvme_dmabuf_map *nvme_req_to_map(struct request *req)
 extern const struct dma_buf_attach_ops nvme_dmabuf_importer_ops;
 
 void __nvme_remove_dmabufs(struct nvme_dma_buf_list *list);
+bool __nvme_dmabufs_use_owner(struct nvme_dma_buf_list *list, void *owner);
 int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
 		struct dma_buf_attachment *attach,
 		struct dma_buf_io_ctx *ctx);
+int __nvme_init_dma_buf_io_ctx_locked(struct nvme_ctrl *ctrl,
+		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_attachment *attach, void *owner,
+		struct dma_buf_io_ctx *ctx)
+	__must_hold(&buf_list->lock);
 
 static inline void nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
 {
@@ -58,6 +66,14 @@ static inline void nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
 		__nvme_remove_dmabufs(list);
 }
 
+static inline bool nvme_dmabufs_use_owner(struct nvme_dma_buf_list *list,
+		void *owner)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return false;
+	return __nvme_dmabufs_use_owner(list, owner);
+}
+
 static inline int nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
 		struct dma_buf_attachment *attach,
@@ -68,6 +84,18 @@ static inline int nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 	return __nvme_init_dma_buf_io_ctx(ctrl, buf_list, attach, ctx);
 }
 
+static inline int nvme_init_dma_buf_io_ctx_locked(struct nvme_ctrl *ctrl,
+		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_attachment *attach, void *owner,
+		struct dma_buf_io_ctx *ctx)
+	__must_hold(&buf_list->lock)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	return __nvme_init_dma_buf_io_ctx_locked(ctrl, buf_list, attach, owner,
+						 ctx);
+}
+
 static inline void nvme_init_buf_list(struct nvme_dma_buf_list *buf_list)
 {
 	INIT_LIST_HEAD(&buf_list->ctxs);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 32189fdfc0f5..e7c26bd4f77d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -27,6 +27,7 @@
 
 #include "nvme.h"
 #include "fabrics.h"
+#include "dmabuf.h"
 
 
 #define NVME_RDMA_CM_TIMEOUT_MS		3000		/* 3 second */
@@ -139,6 +140,12 @@ struct nvme_rdma_ctrl {
 	struct nvme_ctrl	ctrl;
 	bool			use_inline_data;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	/*
+	 * dma-buf I/O contexts. Registration is refused while there is no
+	 * admin queue, as ctrl->device is not valid then.
+	 */
+	struct nvme_dma_buf_list dmabufs;
 };
 
 static inline struct nvme_rdma_ctrl *to_rdma_ctrl(struct nvme_ctrl *ctrl)
@@ -780,8 +787,17 @@ static int nvme_rdma_alloc_tag_set(struct nvme_ctrl *ctrl)
 			cmd_size);
 }
 
+static void nvme_rdma_set_dmabufs_dead(struct nvme_rdma_ctrl *ctrl, bool dead)
+{
+	mutex_lock(&ctrl->dmabufs.lock);
+	ctrl->dmabufs.dead = dead;
+	mutex_unlock(&ctrl->dmabufs.lock);
+}
+
 static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl)
 {
+	nvme_rdma_set_dmabufs_dead(ctrl, true);
+
 	if (ctrl->async_event_sqe.data) {
 		cancel_work_sync(&ctrl->ctrl.async_event_work);
 		nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
@@ -854,6 +870,7 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	if (error)
 		goto out_quiesce_queue;
 
+	nvme_rdma_set_dmabufs_dead(ctrl, false);
 	return 0;
 
 out_quiesce_queue:
@@ -1249,6 +1266,13 @@ static void nvme_rdma_dma_unmap_req(struct ib_device *ibdev, struct request *rq)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
 
+	/* dma-buf addresses are mapped for the lifetime of the map */
+	if (blk_mq_rq_is_dmabuf(rq)) {
+		sg_free_table_chained(&req->data_sgl.sg_table,
+				      NVME_INLINE_SG_CNT);
+		return;
+	}
+
 	if (blk_integrity_rq(rq)) {
 		ib_dma_unmap_sg(ibdev, req->metadata_sgl->sg_table.sgl,
 				req->metadata_sgl->nents, rq_dma_dir(rq));
@@ -1555,6 +1579,100 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 	return ret;
 }
 
+/*
+ * Build the data scatterlist of a dma-buf request from the DMA address
+ * table of its map. The addresses are already mapped for the RDMA device
+ * the dma-buf is attached to, so there is no DMA mapping here.
+ */
+static int nvme_rdma_dma_map_dmabuf_req(struct nvme_rdma_queue *queue,
+		struct request *rq, int *count)
+{
+	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_dmabuf_map *map = nvme_req_to_map(rq);
+	struct nvme_dma_buf_io_ctx *nvme_ctx = map->base.ctx->dev_priv;
+	size_t offset = rq->bio->bi_iter.bi_offset;
+	size_t remaining = blk_rq_payload_bytes(rq);
+	unsigned int first = offset / NVME_CTRL_PAGE_SIZE;
+	unsigned int last = (offset + remaining - 1) / NVME_CTRL_PAGE_SIZE;
+	dma_addr_t *dma_list = map->dma_list;
+	struct scatterlist *sg;
+	unsigned int i, nents = 1;
+	dma_addr_t addr;
+	size_t len;
+	int ret;
+
+	BUILD_BUG_ON(NVME_CTRL_PAGE_SIZE != SZ_4K);
+
+	/* A reconnect may have moved the controller to another RDMA device. */
+	if (unlikely(nvme_ctx->owner != queue->device->dev))
+		return -ENODEV;
+	if (WARN_ON_ONCE(!remaining || last >= map->nr_entries))
+		return -EINVAL;
+
+	for (i = first + 1; i <= last; i++)
+		if (dma_list[i] != dma_list[i - 1] + NVME_CTRL_PAGE_SIZE)
+			nents++;
+
+	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
+	ret = sg_alloc_table_chained(&req->data_sgl.sg_table, nents,
+			req->data_sgl.sg_table.sgl, NVME_INLINE_SG_CNT);
+	if (ret)
+		return -ENOMEM;
+
+	sg = req->data_sgl.sg_table.sgl;
+	addr = dma_list[first] + (offset & (NVME_CTRL_PAGE_SIZE - 1));
+	len = min_t(size_t, remaining,
+		    NVME_CTRL_PAGE_SIZE - (offset & (NVME_CTRL_PAGE_SIZE - 1)));
+	remaining -= len;
+
+	for (i = first + 1; i <= last; i++) {
+		size_t chunk = min_t(size_t, remaining, NVME_CTRL_PAGE_SIZE);
+
+		if (dma_list[i] != addr + len) {
+			sg_dma_address(sg) = addr;
+			sg_dma_len(sg) = len;
+			sg->length = len;
+			sg = sg_next(sg);
+			addr = dma_list[i];
+			len = 0;
+		}
+		len += chunk;
+		remaining -= chunk;
+	}
+	sg_dma_address(sg) = addr;
+	sg_dma_len(sg) = len;
+	sg->length = len;
+
+	req->data_sgl.nents = nents;
+	*count = nents;
+	return 0;
+}
+
+static int nvme_rdma_map_dmabuf(struct nvme_rdma_queue *queue,
+		struct request *rq, struct nvme_command *c)
+{
+	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	int count, ret;
+
+	/* No PI support for dma-buf requests yet */
+	if (req->use_sig_mr || blk_integrity_rq(rq))
+		return -EOPNOTSUPP;
+
+	ret = nvme_rdma_dma_map_dmabuf_req(queue, rq, &count);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * Always register a memory region, so that the target can only access
+	 * the range of the dma-buf this request covers.
+	 */
+	ret = nvme_rdma_map_sg_fr(queue, req, c, count);
+	if (unlikely(ret))
+		sg_free_table_chained(&req->data_sgl.sg_table,
+				      NVME_INLINE_SG_CNT);
+	return ret;
+}
+
 static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 		struct request *rq, struct nvme_command *c)
 {
@@ -1572,6 +1690,9 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 	if (!blk_rq_nr_phys_segments(rq))
 		return nvme_rdma_set_sg_null(c);
 
+	if (blk_mq_rq_is_dmabuf(rq))
+		return nvme_rdma_map_dmabuf(queue, rq, c);
+
 	ret = nvme_rdma_dma_map_req(ibdev, rq, &count, &pi_count);
 	if (unlikely(ret))
 		return ret;
@@ -2194,9 +2315,13 @@ static void nvme_rdma_shutdown_ctrl(struct nvme_rdma_ctrl *ctrl, bool shutdown)
 	nvme_rdma_teardown_admin_queue(ctrl, shutdown);
 }
 
-static void nvme_rdma_delete_ctrl(struct nvme_ctrl *ctrl)
+static void nvme_rdma_delete_ctrl(struct nvme_ctrl *nctrl)
 {
-	nvme_rdma_shutdown_ctrl(to_rdma_ctrl(ctrl), true);
+	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
+
+	nvme_rdma_shutdown_ctrl(ctrl, true);
+	/* Namespace removal has drained I/O, so detach the contexts. */
+	nvme_remove_dmabufs(&ctrl->dmabufs);
 }
 
 static void nvme_rdma_reset_ctrl_work(struct work_struct *work)
@@ -2232,6 +2357,37 @@ static bool nvme_rdma_supports_pci_p2pdma(struct nvme_ctrl *ctrl)
 	return ib_dma_pci_p2p_dma_supported(r_ctrl->device->dev);
 }
 
+static int nvme_rdma_init_dma_buf_io_ctx(struct nvme_ctrl *nctrl,
+		struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
+	struct dma_buf_attachment *attach;
+	struct ib_device *ibdev;
+	int ret;
+
+	/*
+	 * Attach for the RDMA device the controller is currently connected
+	 * through. ctrl->device is valid while the context list is not dead.
+	 */
+	mutex_lock(&ctrl->dmabufs.lock);
+	if (ctrl->dmabufs.dead) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+	ibdev = ctrl->device->dev;
+	attach = ib_dma_buf_dynamic_attach(ibdev, ctx->dmabuf,
+					   &nvme_dmabuf_importer_ops, ctx);
+	if (IS_ERR(attach)) {
+		ret = PTR_ERR(attach);
+		goto out_unlock;
+	}
+	ret = nvme_init_dma_buf_io_ctx_locked(nctrl, &ctrl->dmabufs, attach,
+					      ibdev, ctx);
+out_unlock:
+	mutex_unlock(&ctrl->dmabufs.lock);
+	return ret;
+}
+
 static const struct nvme_ctrl_ops nvme_rdma_ctrl_ops = {
 	.name			= "rdma",
 	.module			= THIS_MODULE,
@@ -2247,6 +2403,7 @@ static const struct nvme_ctrl_ops nvme_rdma_ctrl_ops = {
 	.stop_ctrl		= nvme_rdma_stop_ctrl,
 	.get_virt_boundary	= nvme_get_virt_boundary,
 	.supports_pci_p2pdma	= nvme_rdma_supports_pci_p2pdma,
+	.init_dma_buf_io_ctx	= nvme_rdma_init_dma_buf_io_ctx,
 };
 
 /*
@@ -2344,6 +2501,9 @@ static struct nvme_rdma_ctrl *nvme_rdma_alloc_ctrl(struct device *dev,
 	for (i = 0; i < ctrl->ctrl.queue_count; i++)
 		ctrl->queues[i].ctrl = ctrl;
 
+	nvme_init_buf_list(&ctrl->dmabufs);
+	ctrl->dmabufs.dead = true;
+
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_rdma_ctrl_ops,
 				0 /* no quirks, we're perfect! */);
 	if (ret)
@@ -2413,7 +2573,7 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 {
 	struct nvme_rdma_ctrl *ctrl;
 	struct nvme_rdma_device *ndev;
-	bool found = false;
+	bool found = false, need_flush;
 
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(ndev, &device_list, entry) {
@@ -2423,20 +2583,24 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 		}
 	}
 	mutex_unlock(&device_list_mutex);
+	need_flush = found;
 
-	if (!found)
-		return;
-
-	/* Delete all controllers using this device */
+	/*
+	 * Delete controllers using this device, and controllers that
+	 * reconnected elsewhere but still have dma-bufs attached to it.
+	 */
 	mutex_lock(&nvme_rdma_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list) {
-		if (ctrl->device->dev != ib_device)
+		if (!(found && ctrl->device->dev == ib_device) &&
+		    !nvme_dmabufs_use_owner(&ctrl->dmabufs, ib_device))
 			continue;
 		nvme_delete_ctrl(&ctrl->ctrl);
+		need_flush = true;
 	}
 	mutex_unlock(&nvme_rdma_ctrl_mutex);
 
-	flush_workqueue(nvme_delete_wq);
+	if (need_flush)
+		flush_workqueue(nvme_delete_wq);
 }
 
 static struct ib_client nvme_rdma_ib_client = {
-- 
2.25.1

