From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 13/26] IB/core: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:05 -0800
Message-ID: <20170112190718.6728-14-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Most changes in this patch and the subsequent patches, except for the
removal of variables that became superfluous and indentation adjustments,
have been generated as follows:

git grep -lE 'ib_(sg_|)dma_' |
  xargs -d\\n \
    sed -i -e 's/\([^[:alnum:]_]\)ib_dma_\([^(]*\)(\&\([^,]\+\),/\1dma_\2(\3.dma_device,/g' \
           -e 's/\([^[:alnum:]_]\)ib_dma_\([^(]*\)(\([^,]\+\),/\1dma_\2(\3->dma_device,/g' \
           -e 's/ib_sg_dma_\(len\|address\)(\([^,]\+\), /sg_dma_\1(/g'

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/core/mad.c      | 79 ++++++++++++++++++--------------------
 drivers/infiniband/core/rw.c       | 30 +++++++--------
 drivers/infiniband/core/umem.c     | 13 +++----
 drivers/infiniband/core/umem_odp.c | 12 +++---
 4 files changed, 61 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a009f7132c73..79aeef810c2e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1152,23 +1152,21 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 
 	mad_agent = mad_send_wr->send_buf.mad_agent;
 	sge = mad_send_wr->sg_list;
-	sge[0].addr = ib_dma_map_single(mad_agent->device,
-					mad_send_wr->send_buf.mad,
-					sge[0].length,
-					DMA_TO_DEVICE);
-	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[0].addr)))
+	sge[0].addr = dma_map_single(mad_agent->device->dma_device,
+				     mad_send_wr->send_buf.mad,
+				     sge[0].length, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(mad_agent->device->dma_device, sge[0].addr)))
 		return -ENOMEM;
 
 	mad_send_wr->header_mapping = sge[0].addr;
 
-	sge[1].addr = ib_dma_map_single(mad_agent->device,
-					ib_get_payload(mad_send_wr),
-					sge[1].length,
-					DMA_TO_DEVICE);
-	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[1].addr))) {
-		ib_dma_unmap_single(mad_agent->device,
-				    mad_send_wr->header_mapping,
-				    sge[0].length, DMA_TO_DEVICE);
+	sge[1].addr = dma_map_single(mad_agent->device->dma_device,
+				     ib_get_payload(mad_send_wr),
+				     sge[1].length, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(mad_agent->device->dma_device, sge[1].addr))) {
+		dma_unmap_single(mad_agent->device->dma_device,
+				 mad_send_wr->header_mapping,
+				 sge[0].length, DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 	mad_send_wr->payload_mapping = sge[1].addr;
@@ -1189,12 +1187,12 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 	}
 	spin_unlock_irqrestore(&qp_info->send_queue.lock, flags);
 	if (ret) {
-		ib_dma_unmap_single(mad_agent->device,
-				    mad_send_wr->header_mapping,
-				    sge[0].length, DMA_TO_DEVICE);
-		ib_dma_unmap_single(mad_agent->device,
-				    mad_send_wr->payload_mapping,
-				    sge[1].length, DMA_TO_DEVICE);
+		dma_unmap_single(mad_agent->device->dma_device,
+				 mad_send_wr->header_mapping,
+				 sge[0].length, DMA_TO_DEVICE);
+		dma_unmap_single(mad_agent->device->dma_device,
+				 mad_send_wr->payload_mapping,
+				 sge[1].length, DMA_TO_DEVICE);
 	}
 	return ret;
 }
@@ -2191,10 +2189,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header,
 				    mad_list);
 	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
-	ib_dma_unmap_single(port_priv->device,
-			    recv->header.mapping,
-			    mad_priv_dma_size(recv),
-			    DMA_FROM_DEVICE);
+	dma_unmap_single(port_priv->device->dma_device, recv->header.mapping,
+			 mad_priv_dma_size(recv), DMA_FROM_DEVICE);
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
@@ -2432,12 +2428,12 @@ static void ib_mad_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	qp_info = send_queue->qp_info;
 
 retry:
-	ib_dma_unmap_single(mad_send_wr->send_buf.mad_agent->device,
-			    mad_send_wr->header_mapping,
-			    mad_send_wr->sg_list[0].length, DMA_TO_DEVICE);
-	ib_dma_unmap_single(mad_send_wr->send_buf.mad_agent->device,
-			    mad_send_wr->payload_mapping,
-			    mad_send_wr->sg_list[1].length, DMA_TO_DEVICE);
+	dma_unmap_single(mad_send_wr->send_buf.mad_agent->device->dma_device,
+			 mad_send_wr->header_mapping,
+			 mad_send_wr->sg_list[0].length, DMA_TO_DEVICE);
+	dma_unmap_single(mad_send_wr->send_buf.mad_agent->device->dma_device,
+			 mad_send_wr->payload_mapping,
+			 mad_send_wr->sg_list[1].length, DMA_TO_DEVICE);
 	queued_send_wr = NULL;
 	spin_lock_irqsave(&send_queue->lock, flags);
 	list_del(&mad_list->list);
@@ -2853,11 +2849,11 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			}
 		}
 		sg_list.length = mad_priv_dma_size(mad_priv);
-		sg_list.addr = ib_dma_map_single(qp_info->port_priv->device,
-						 &mad_priv->grh,
-						 mad_priv_dma_size(mad_priv),
-						 DMA_FROM_DEVICE);
-		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
+		sg_list.addr = dma_map_single(qp_info->port_priv->device->dma_device,
+					      &mad_priv->grh,
+					      mad_priv_dma_size(mad_priv),
+					      DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(qp_info->port_priv->device->dma_device,
 						  sg_list.addr))) {
 			ret = -ENOMEM;
 			break;
@@ -2878,10 +2874,10 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			list_del(&mad_priv->header.mad_list.list);
 			recv_queue->count--;
 			spin_unlock_irqrestore(&recv_queue->lock, flags);
-			ib_dma_unmap_single(qp_info->port_priv->device,
-					    mad_priv->header.mapping,
-					    mad_priv_dma_size(mad_priv),
-					    DMA_FROM_DEVICE);
+			dma_unmap_single(qp_info->port_priv->device->dma_device,
+					 mad_priv->header.mapping,
+					 mad_priv_dma_size(mad_priv),
+					 DMA_FROM_DEVICE);
 			kfree(mad_priv);
 			dev_err(&qp_info->port_priv->device->dev,
 				"ib_post_recv failed: %d\n", ret);
@@ -2917,10 +2913,9 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 		/* Remove from posted receive MAD list */
 		list_del(&mad_list->list);
 
-		ib_dma_unmap_single(qp_info->port_priv->device,
-				    recv->header.mapping,
-				    mad_priv_dma_size(recv),
-				    DMA_FROM_DEVICE);
+		dma_unmap_single(qp_info->port_priv->device->dma_device,
+				 recv->header.mapping, mad_priv_dma_size(recv),
+				 DMA_FROM_DEVICE);
 		kfree(recv);
 	}
 
diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index dbfd854c32c9..f8aef874f636 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -178,7 +178,6 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		struct scatterlist *sg, u32 sg_cnt, u32 offset,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
-	struct ib_device *dev = qp->pd->device;
 	u32 max_sge = dir == DMA_TO_DEVICE ? qp->max_write_sge :
 		      qp->max_read_sge;
 	struct ib_sge *sge;
@@ -208,8 +207,8 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		rdma_wr->wr.sg_list = sge;
 
 		for (j = 0; j < nr_sge; j++, sg = sg_next(sg)) {
-			sge->addr = ib_sg_dma_address(dev, sg) + offset;
-			sge->length = ib_sg_dma_len(dev, sg) - offset;
+			sge->addr = sg_dma_address(sg) + offset;
+			sge->length = sg_dma_len(sg) - offset;
 			sge->lkey = qp->pd->local_dma_lkey;
 
 			total_len += sge->length;
@@ -235,14 +234,13 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		struct scatterlist *sg, u32 offset, u64 remote_addr, u32 rkey,
 		enum dma_data_direction dir)
 {
-	struct ib_device *dev = qp->pd->device;
 	struct ib_rdma_wr *rdma_wr = &ctx->single.wr;
 
 	ctx->nr_ops = 1;
 
 	ctx->single.sge.lkey = qp->pd->local_dma_lkey;
-	ctx->single.sge.addr = ib_sg_dma_address(dev, sg) + offset;
-	ctx->single.sge.length = ib_sg_dma_len(dev, sg) - offset;
+	ctx->single.sge.addr = sg_dma_address(sg) + offset;
+	ctx->single.sge.length = sg_dma_len(sg) - offset;
 
 	memset(rdma_wr, 0, sizeof(*rdma_wr));
 	if (dir == DMA_TO_DEVICE)
@@ -280,7 +278,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 	struct ib_device *dev = qp->pd->device;
 	int ret;
 
-	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
+	ret = dma_map_sg(dev->dma_device, sg, sg_cnt, dir);
 	if (!ret)
 		return -ENOMEM;
 	sg_cnt = ret;
@@ -289,7 +287,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 	 * Skip to the S/G entry that sg_offset falls into:
 	 */
 	for (;;) {
-		u32 len = ib_sg_dma_len(dev, sg);
+		u32 len = sg_dma_len(sg);
 
 		if (sg_offset < len)
 			break;
@@ -319,7 +317,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 	return ret;
 
 out_unmap_sg:
-	ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+	dma_unmap_sg(dev->dma_device, sg, sg_cnt, dir);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_rw_ctx_init);
@@ -358,12 +356,12 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		return -EINVAL;
 	}
 
-	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
+	ret = dma_map_sg(dev->dma_device, sg, sg_cnt, dir);
 	if (!ret)
 		return -ENOMEM;
 	sg_cnt = ret;
 
-	ret = ib_dma_map_sg(dev, prot_sg, prot_sg_cnt, dir);
+	ret = dma_map_sg(dev->dma_device, prot_sg, prot_sg_cnt, dir);
 	if (!ret) {
 		ret = -ENOMEM;
 		goto out_unmap_sg;
@@ -457,9 +455,9 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 out_free_ctx:
 	kfree(ctx->sig);
 out_unmap_prot_sg:
-	ib_dma_unmap_sg(dev, prot_sg, prot_sg_cnt, dir);
+	dma_unmap_sg(dev->dma_device, prot_sg, prot_sg_cnt, dir);
 out_unmap_sg:
-	ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+	dma_unmap_sg(dev->dma_device, sg, sg_cnt, dir);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_rw_ctx_signature_init);
@@ -606,7 +604,7 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		break;
 	}
 
-	ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+	dma_unmap_sg(qp->pd->device->dma_device, sg, sg_cnt, dir);
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 
@@ -631,11 +629,11 @@ void rdma_rw_ctx_destroy_signature(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		return;
 
 	ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->data.mr);
-	ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+	dma_unmap_sg(qp->pd->device->dma_device, sg, sg_cnt, dir);
 
 	if (ctx->sig->prot.mr) {
 		ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->prot.mr);
-		ib_dma_unmap_sg(qp->pd->device, prot_sg, prot_sg_cnt, dir);
+		dma_unmap_sg(qp->pd->device->dma_device, prot_sg, prot_sg_cnt, dir);
 	}
 
 	ib_mr_pool_put(qp, &qp->sig_mrs, ctx->sig->sig_mr);
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 1e62a5f0cb28..d30803441f68 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -50,9 +50,8 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 	int i;
 
 	if (umem->nmap > 0)
-		ib_dma_unmap_sg(dev, umem->sg_head.sgl,
-				umem->npages,
-				DMA_BIDIRECTIONAL);
+		dma_unmap_sg(dev->dma_device, umem->sg_head.sgl, umem->npages,
+			     DMA_BIDIRECTIONAL);
 
 	for_each_sg(umem->sg_head.sgl, sg, umem->npages, i) {
 
@@ -214,11 +213,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		sg_list_start = sg;
 	}
 
-	umem->nmap = ib_dma_map_sg_attrs(context->device,
-				  umem->sg_head.sgl,
-				  umem->npages,
-				  DMA_BIDIRECTIONAL,
-				  dma_attrs);
+	umem->nmap = dma_map_sg_attrs(context->device->dma_device,
+				      umem->sg_head.sgl, umem->npages,
+				      DMA_BIDIRECTIONAL, dma_attrs);
 
 	if (umem->nmap <= 0) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 6b079a31dced..8ebaf97bd7be 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -456,11 +456,9 @@ static int ib_umem_odp_map_dma_single_page(
 		goto out;
 	}
 	if (!(umem->odp_data->dma_list[page_index])) {
-		dma_addr = ib_dma_map_page(dev,
-					   page,
-					   0, PAGE_SIZE,
-					   DMA_BIDIRECTIONAL);
-		if (ib_dma_mapping_error(dev, dma_addr)) {
+		dma_addr = dma_map_page(dev->dma_device, page, 0, PAGE_SIZE,
+					DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dev->dma_device, dma_addr)) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -645,8 +643,8 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 
 			WARN_ON(!dma_addr);
 
-			ib_dma_unmap_page(dev, dma_addr, PAGE_SIZE,
-					  DMA_BIDIRECTIONAL);
+			dma_unmap_page(dev->dma_device, dma_addr, PAGE_SIZE,
+				       DMA_BIDIRECTIONAL);
 			if (dma & ODP_WRITE_ALLOWED_BIT) {
 				struct page *head_page = compound_head(page);
 				/*
-- 
2.11.0
