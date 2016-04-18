From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Mon, 18 Apr 2016 16:14:22 -0400
Message-ID: <1461010463-6603-12-git-send-email-hch@lst.de>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1461010463-6603-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/core/rw.c    | 227 +++++++++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/verbs.c |   1 +
 include/rdma/ib_verbs.h         |   1 +
 include/rdma/rw.h               |  19 ++++
 4 files changed, 243 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index bd700ff..9993be0 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -19,6 +19,7 @@ enum {
 	RDMA_RW_SINGLE_WR,
 	RDMA_RW_MULTI_WR,
 	RDMA_RW_MR,
+	RDMA_RW_SIG_MR,
 };
 
 static bool rdma_rw_force_mr;
@@ -325,6 +326,146 @@ out_unmap_sg:
 }
 EXPORT_SYMBOL(rdma_rw_ctx_init);
 
+/**
+ * rdma_rw_ctx_signature init - initialize a RW context with signature offload
+ * @ctx:	context to initialize
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @sg:		scatterlist to READ/WRITE from/to
+ * @sg_cnt:	number of entries in @sg
+ * @prot_sg:	scatterlist to READ/WRITE protection information from/to
+ * @prot_sg_cnt: number of entries in @prot_sg
+ * @sig_attrs:	signature offloading algorithms
+ * @remote_addr:remote address to read/write (relative to @rkey)
+ * @rkey:	remote key to operate on
+ * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ *
+ * Returns the number of WQEs that will be needed on the workqueue if
+ * successful, or a negative error code.
+ */
+int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		struct scatterlist *prot_sg, u32 prot_sg_cnt,
+		struct ib_sig_attrs *sig_attrs,
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
+{
+	struct ib_device *dev = qp->pd->device;
+	u32 pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
+	struct ib_rdma_wr *rdma_wr;
+	struct ib_send_wr *prev_wr = NULL;
+	int count = 0, ret;
+
+	if (sg_cnt > pages_per_mr || prot_sg_cnt > pages_per_mr) {
+		pr_err("SG count too large\n");
+		return -EINVAL;
+	}
+
+	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
+	if (!ret)
+		return -ENOMEM;
+	sg_cnt = ret;
+
+	ret = ib_dma_map_sg(dev, prot_sg, prot_sg_cnt, dir);
+	if (!ret) {
+		ret = -ENOMEM;
+		goto out_unmap_sg;
+	}
+	prot_sg_cnt = ret;
+
+	ctx->type = RDMA_RW_SIG_MR;
+	ctx->nr_ops = 1;
+	ctx->sig = kcalloc(1, sizeof(*ctx->sig), GFP_KERNEL);
+	if (!ctx->sig) {
+		ret = -ENOMEM;
+		goto out_unmap_prot_sg;
+	}
+
+	ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->data, sg, sg_cnt, 0);
+	if (ret < 0)
+		goto out_free_ctx;
+	count += ret;
+	prev_wr = &ctx->sig->data.reg_wr.wr;
+
+	if (prot_sg_cnt) {
+		ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
+				prot_sg, prot_sg_cnt, 0);
+		if (ret < 0)
+			goto out_destroy_data_mr;
+		count += ret;
+
+		if (ctx->sig->prot.inv_wr.next)
+			prev_wr->next = &ctx->sig->prot.inv_wr;
+		else
+			prev_wr->next = &ctx->sig->prot.reg_wr.wr;
+		prev_wr = &ctx->sig->prot.reg_wr.wr;
+	} else {
+		ctx->sig->prot.mr = NULL;
+	}
+
+	ctx->sig->sig_mr = ib_mr_pool_get(qp, &qp->sig_mrs);
+	if (!ctx->sig->sig_mr) {
+		ret = -EAGAIN;
+		goto out_destroy_prot_mr;
+	}
+
+	if (ctx->sig->sig_mr->need_inval) {
+		memset(&ctx->sig->sig_inv_wr, 0, sizeof(ctx->sig->sig_inv_wr));
+
+		ctx->sig->sig_inv_wr.opcode = IB_WR_LOCAL_INV;
+		ctx->sig->sig_inv_wr.ex.invalidate_rkey = ctx->sig->sig_mr->rkey;
+
+		prev_wr->next = &ctx->sig->sig_inv_wr;
+		prev_wr = &ctx->sig->sig_inv_wr;
+	}
+
+	ctx->sig->sig_wr.wr.opcode = IB_WR_REG_SIG_MR;
+	ctx->sig->sig_wr.wr.wr_cqe = NULL;
+	ctx->sig->sig_wr.wr.sg_list = &ctx->sig->data.sge;
+	ctx->sig->sig_wr.wr.num_sge = 1;
+	ctx->sig->sig_wr.access_flags = IB_ACCESS_LOCAL_WRITE;
+	ctx->sig->sig_wr.sig_attrs = sig_attrs;
+	ctx->sig->sig_wr.sig_mr = ctx->sig->sig_mr;
+	if (prot_sg_cnt)
+		ctx->sig->sig_wr.prot = &ctx->sig->prot.sge;
+	prev_wr->next = &ctx->sig->sig_wr.wr;
+	prev_wr = &ctx->sig->sig_wr.wr;
+	count++;
+
+	ctx->sig->sig_sge.addr = 0;
+	ctx->sig->sig_sge.length = ctx->sig->data.sge.length;
+	if (sig_attrs->wire.sig_type != IB_SIG_TYPE_NONE)
+		ctx->sig->sig_sge.length += ctx->sig->prot.sge.length;
+
+	rdma_wr = &ctx->sig->data.wr;
+	rdma_wr->wr.sg_list = &ctx->sig->sig_sge;
+	rdma_wr->wr.num_sge = 1;
+	rdma_wr->remote_addr = remote_addr;
+	rdma_wr->rkey = rkey;
+	if (dir == DMA_TO_DEVICE)
+		rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
+	else
+		rdma_wr->wr.opcode = IB_WR_RDMA_READ;
+	prev_wr->next = &rdma_wr->wr;
+	prev_wr = &rdma_wr->wr;
+	count++;
+
+	return count;
+
+out_destroy_prot_mr:
+	if (prot_sg_cnt)
+		ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->prot.mr);
+out_destroy_data_mr:
+	ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->data.mr);
+out_free_ctx:
+	kfree(ctx->sig);
+out_unmap_prot_sg:
+	ib_dma_unmap_sg(dev, prot_sg, prot_sg_cnt, dir);
+out_unmap_sg:
+	ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+	return ret;
+}
+EXPORT_SYMBOL(rdma_rw_ctx_signature_init);
+
 /*
  * Now that we are going to post the WRs we can update the lkey and need_inval
  * state on the MRs.  If we were doing this at init time, we would get double
@@ -360,6 +501,22 @@ struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 	int i;
 
 	switch (ctx->type) {
+	case RDMA_RW_SIG_MR:
+		rdma_rw_update_lkey(&ctx->sig->data, true);
+		if (ctx->sig->prot.mr)
+			rdma_rw_update_lkey(&ctx->sig->prot, true);
+	
+		ctx->sig->sig_mr->need_inval = true;
+		ib_update_fast_reg_key(ctx->sig->sig_mr,
+			ib_inc_rkey(ctx->sig->sig_mr->lkey));
+		ctx->sig->sig_sge.lkey = ctx->sig->sig_mr->lkey;
+
+		if (ctx->sig->data.inv_wr.next)
+			first_wr = &ctx->sig->data.inv_wr;
+		else
+			first_wr = &ctx->sig->data.reg_wr.wr;
+		last_wr = &ctx->sig->data.wr.wr;
+		break;
 	case RDMA_RW_MR:
 		for (i = 0; i < ctx->nr_ops; i++) {
 			rdma_rw_update_lkey(&ctx->reg[i],
@@ -455,6 +612,38 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 
+/**
+ * rdma_rw_ctx_destroy_signature - release all resources allocated by
+ *	rdma_rw_ctx_init_signature
+ * @ctx:	context to release
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @sg:		scatterlist that was used for the READ/WRITE
+ * @sg_cnt:	number of entries in @sg
+ * @prot_sg:	scatterlist that was used for the READ/WRITE of the PI
+ * @prot_sg_cnt: number of entries in @prot_sg
+ * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ */
+void rdma_rw_ctx_destroy_signature(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		struct scatterlist *prot_sg, u32 prot_sg_cnt,
+		enum dma_data_direction dir)
+{
+	if (WARN_ON_ONCE(ctx->type != RDMA_RW_SIG_MR))
+		return;
+
+	ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->data.mr);
+	if (ctx->sig->prot.mr)
+		ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->sig->prot.mr);
+	ib_mr_pool_put(qp, &qp->sig_mrs, ctx->sig->sig_mr);
+	kfree(ctx->sig);
+
+	if (ctx->sig->prot.mr)
+		ib_dma_unmap_sg(qp->pd->device, prot_sg, prot_sg_cnt, dir);
+	ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+}
+EXPORT_SYMBOL(rdma_rw_ctx_destroy_signature);
+
 void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 {
 	u32 factor;
@@ -474,7 +663,9 @@ void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 	 * we'll need two additional MRs for the registrations and the
 	 * invalidation.
 	 */
-	if (rdma_rw_can_use_mr(dev, attr->port_num))
+	if (attr->create_flags & IB_QP_CREATE_SIGNATURE_EN)
+		factor += 6;	/* (inv + reg) * (data + prot + sig) */
+	else if (rdma_rw_can_use_mr(dev, attr->port_num))
 		factor += 2;	/* inv + reg */
 
 	attr->cap.max_send_wr += factor * attr->cap.max_rdma_ctxs;
@@ -490,20 +681,46 @@ void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr)
 {
 	struct ib_device *dev = qp->pd->device;
+	u32 nr_mrs = 0, nr_sig_mrs = 0;
 	int ret = 0;
 
-	if (rdma_rw_can_use_mr(dev, attr->port_num)) {
-		ret = ib_mr_pool_init(qp, &qp->rdma_mrs,
-				attr->cap.max_rdma_ctxs, IB_MR_TYPE_MEM_REG,
+	if (attr->create_flags & IB_QP_CREATE_SIGNATURE_EN) {
+		nr_sig_mrs = attr->cap.max_rdma_ctxs;
+		nr_mrs = attr->cap.max_rdma_ctxs * 2;
+	} else if (rdma_rw_can_use_mr(dev, attr->port_num)) {
+		nr_mrs = attr->cap.max_rdma_ctxs;
+	}
+
+	if (nr_mrs) {
+		ret = ib_mr_pool_init(qp, &qp->rdma_mrs, nr_mrs,
+				IB_MR_TYPE_MEM_REG,
 				rdma_rw_fr_page_list_len(dev));
-		if (ret)
+		if (ret) {
+			pr_err("%s: failed to allocated %d MRs\n",
+				__func__, nr_mrs);
 			return ret;
+		}
 	}
 
+	if (nr_sig_mrs) {
+		ret = ib_mr_pool_init(qp, &qp->sig_mrs, nr_sig_mrs,
+				IB_MR_TYPE_SIGNATURE, 2);
+		if (ret) {
+			pr_err("%s: failed to allocated %d SIG MRs\n",
+				__func__, nr_mrs);
+			goto out_free_rdma_mrs;
+		}
+	}
+
+	return 0;
+
+out_free_rdma_mrs:
+	ib_mr_pool_destroy(qp, &qp->rdma_mrs);
 	return ret;
 }
 
 void rdma_rw_cleanup_mrs(struct ib_qp *qp)
 {
+	ib_mr_pool_destroy(qp, &qp->sig_mrs);
 	ib_mr_pool_destroy(qp, &qp->rdma_mrs);
 }
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 769b000..e2b6634 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -776,6 +776,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp->mrs_used = 0;
 	spin_lock_init(&qp->mr_lock);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
+	INIT_LIST_HEAD(&qp->sig_mrs);
 
 	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
 		return ib_create_xrc_qp(qp, qp_init_attr);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index dd8e15d..544c55b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1435,6 +1435,7 @@ struct ib_qp {
 	spinlock_t		mr_lock;
 	int			mrs_used;
 	struct list_head	rdma_mrs;
+	struct list_head	sig_mrs;
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
index d3896bb..377d865 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -47,6 +47,15 @@ struct rdma_rw_ctx {
 			struct ib_send_wr	inv_wr;
 			struct ib_mr		*mr;
 		} *reg;
+
+		struct {
+			struct rdma_rw_reg_ctx	data;
+			struct rdma_rw_reg_ctx	prot;
+			struct ib_send_wr	sig_inv_wr;
+			struct ib_mr		*sig_mr;
+			struct ib_sge		sig_sge;
+			struct ib_sig_handover_wr sig_wr;
+		} *sig;
 	};
 };
 
@@ -57,6 +66,16 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt,
 		enum dma_data_direction dir);
 
+int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		struct scatterlist *prot_sg, u32 prot_sg_cnt,
+		struct ib_sig_attrs *sig_attrs, u64 remote_addr, u32 rkey,
+		enum dma_data_direction dir);
+void rdma_rw_ctx_destroy_signature(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		struct scatterlist *prot_sg, u32 prot_sg_cnt,
+		enum dma_data_direction dir);
+
 struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u8 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr);
 int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
-- 
2.1.4
