From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Tue,  8 Mar 2016 19:16:38 +0100
Message-ID: <1457461000-24088-8-git-send-email-hch@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457461000-24088-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This supports both manual mapping of lots of SGEs, as well as using MRs
from the QP's MR pool, for iWarp or other cases where it's more optimal.
For now, MRs are only used for iWARP transports.  The user of the RDMA-RW
API must allocate the QP MR pool as well as size the SQ accordingly.

Thanks to Steve Wise for testing, fixing and rewriting the iWarp support,
and to Sagi Grimberg for ideas, reviews and fixes.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/Makefile |   2 +-
 drivers/infiniband/core/rw.c     | 419 +++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/verbs.c  |  25 +++
 include/rdma/ib_verbs.h          |  14 +-
 include/rdma/rw.h                |  69 +++++++
 5 files changed, 527 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/core/rw.c
 create mode 100644 include/rdma/rw.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 48bd9d8..26987d9 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
-ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
+ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
 				roce_gid_mgmt.o mr_pool.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
new file mode 100644
index 0000000..7311b95
--- /dev/null
+++ b/drivers/infiniband/core/rw.c
@@ -0,0 +1,419 @@
+/*
+ * Copyright (c) 2016 HGST, a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/slab.h>
+#include <rdma/mr_pool.h>
+#include <rdma/rw.h>
+
+/*
+ * Check if the device needs a memory registration.  We currently always use
+ * memory registrations for iWarp, and never for IB and RoCE.  In the future
+ * we can hopefully fine tune this based on HCA driver input.
+ */
+static inline bool rdma_rw_use_mr(struct ib_device *dev, u8 port_num)
+{
+	return rdma_protocol_iwarp(dev, port_num);
+}
+
+static inline u32 rdma_rw_max_sge(struct ib_device *dev,
+		enum dma_data_direction dir)
+{
+	return dir == DMA_TO_DEVICE ?
+		dev->attrs.max_sge : dev->attrs.max_sge_rd;
+}
+
+static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
+{
+	/* arbitrary limit to avoid allocating gigantic resources */
+	return min_t(u32, dev->attrs.max_fast_reg_page_list_len, 256);
+}
+
+static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct scatterlist *sg, u32 offset,
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
+{
+	int pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
+	int pages_left = ctx->dma_nents;
+	u32 va_offset = 0;
+	int i, ret = 0, count = 0;
+
+	ctx->nr_ops = (ctx->dma_nents + pages_per_mr - 1) / pages_per_mr;
+	ctx->reg = kcalloc(ctx->nr_ops, sizeof(*ctx->reg), GFP_KERNEL);
+	if (!ctx->reg) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < ctx->nr_ops; i++) {
+		struct rdma_rw_reg_ctx *prev = i ? &ctx->reg[i - 1] : NULL;
+		struct rdma_rw_reg_ctx *reg = &ctx->reg[i];
+		int nents = min(pages_left, pages_per_mr);
+
+		reg->mr = ib_mr_pool_get(qp, &qp->rdma_mrs);
+		if (!reg->mr) {
+			pr_info("failed to allocate MR from pool\n");
+			ret = -EAGAIN;
+			goto out_free;
+		}
+
+		if (reg->mr->need_inval) {
+			reg->inv_wr.opcode = IB_WR_LOCAL_INV;
+			reg->inv_wr.ex.invalidate_rkey = reg->mr->lkey;
+			reg->inv_wr.next = &reg->reg_wr.wr;
+			if (prev)
+				prev->wr.wr.next = &reg->inv_wr;
+
+			count++;
+		} else if (prev) {
+			prev->wr.wr.next = &reg->reg_wr.wr;
+		}
+
+		ib_update_fast_reg_key(reg->mr, ib_inc_rkey(reg->mr->lkey));
+
+		ret = ib_map_mr_sg(reg->mr, sg, nents, offset,
+				PAGE_SIZE);
+		if (ret < nents) {
+			pr_info("failed to map MR\n");
+			ib_mr_pool_put(qp, &qp->rdma_mrs, reg->mr);
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		reg->reg_wr.wr.opcode = IB_WR_REG_MR;
+		reg->reg_wr.mr = reg->mr;
+		reg->reg_wr.key = reg->mr->lkey;
+		reg->reg_wr.wr.next = &reg->wr.wr;
+		count++;
+
+		reg->reg_wr.access = IB_ACCESS_LOCAL_WRITE;
+		if (rdma_protocol_iwarp(qp->device, port_num))
+			reg->reg_wr.access |= IB_ACCESS_REMOTE_WRITE;
+
+		reg->sge.lkey = reg->mr->lkey;
+		reg->sge.addr = reg->mr->iova;
+		reg->sge.length = reg->mr->length;
+
+		reg->wr.wr.sg_list = &reg->sge;
+		reg->wr.wr.num_sge = 1;
+		reg->wr.remote_addr = remote_addr + va_offset;
+		reg->wr.rkey = rkey;
+		count++;
+
+		if (dir == DMA_FROM_DEVICE) {
+			if (rdma_cap_read_inv(qp->device, port_num)) {
+				reg->wr.wr.opcode = IB_WR_RDMA_READ_WITH_INV;
+				reg->wr.wr.ex.invalidate_rkey = reg->mr->lkey;
+				reg->mr->need_inval = false;
+			}  else {
+				reg->wr.wr.opcode = IB_WR_RDMA_READ;
+				reg->mr->need_inval = true;
+			}
+		} else {
+			reg->wr.wr.opcode = IB_WR_RDMA_WRITE;
+			reg->mr->need_inval = true;
+		}
+
+		va_offset += reg->sge.length;
+		pages_left -= nents;
+		sg = sg_next(sg);
+		offset = 0;
+	}
+
+	return count;
+
+out_free:
+	while (--i >= 0)
+		ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->reg[i].mr);
+	kfree(ctx->reg);
+out:
+	return ret;
+}
+
+static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		struct scatterlist *sg, u32 offset, u64 remote_addr, u32 rkey,
+		enum dma_data_direction dir)
+{
+	struct ib_device *dev = qp->pd->device;
+	u32 max_sge = rdma_rw_max_sge(dev, dir);
+	u32 sge_left = ctx->dma_nents;
+	struct ib_sge *sge;
+	u32 total_len = 0, i, j;
+
+	ctx->nr_ops = DIV_ROUND_UP(ctx->dma_nents, max_sge);
+
+	ctx->map.sges = sge = kcalloc(ctx->dma_nents, sizeof(*sge), GFP_KERNEL);
+	if (!ctx->map.sges)
+		goto out;
+
+	ctx->map.wrs = kcalloc(ctx->nr_ops, sizeof(*ctx->map.wrs), GFP_KERNEL);
+	if (!ctx->map.wrs)
+		goto out_free_sges;
+
+	for (i = 0; i < ctx->nr_ops; i++) {
+		struct ib_rdma_wr *rdma_wr = &ctx->map.wrs[i];
+		u32 nr_sge = min(sge_left, max_sge);
+
+		if (dir == DMA_TO_DEVICE)
+			rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
+		else
+			rdma_wr->wr.opcode = IB_WR_RDMA_READ;
+		rdma_wr->remote_addr = remote_addr + total_len;
+		rdma_wr->rkey = rkey;
+		rdma_wr->wr.sg_list = sge;
+
+		for (j = 0; j < nr_sge; j++, sg = sg_next(sg)) {
+			rdma_wr->wr.num_sge++;
+
+			sge->addr = ib_sg_dma_address(dev, sg) + offset;
+			sge->length = ib_sg_dma_len(dev, sg) - offset;
+			sge->lkey = qp->pd->local_dma_lkey;
+
+			total_len += sge->length;
+			sge++;
+			sge_left--;
+			offset = 0;
+		}
+
+		if (i + 1 != ctx->nr_ops)
+			rdma_wr->wr.next = &ctx->map.wrs[i + 1].wr;
+	}
+
+	return ctx->nr_ops;
+
+out_free_sges:
+	kfree(ctx->map.sges);
+out:
+	return -ENOMEM;
+}
+
+static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		struct scatterlist *sg, u32 offset, u64 remote_addr, u32 rkey,
+		enum dma_data_direction dir)
+{
+	struct ib_device *dev = qp->pd->device;
+	struct ib_rdma_wr *rdma_wr = &ctx->single.wr;
+
+	ctx->nr_ops = 1;
+
+	ctx->single.sge.lkey = qp->pd->local_dma_lkey;
+	ctx->single.sge.addr = ib_sg_dma_address(dev, sg) + offset;
+	ctx->single.sge.length = ib_sg_dma_len(dev, sg) - offset;
+
+	memset(rdma_wr, 0, sizeof(*rdma_wr));
+	if (dir == DMA_TO_DEVICE)
+		rdma_wr->wr.opcode = IB_WR_RDMA_WRITE;
+	else
+		rdma_wr->wr.opcode = IB_WR_RDMA_READ;
+	rdma_wr->wr.sg_list = &ctx->single.sge;
+	rdma_wr->wr.num_sge = 1;
+	rdma_wr->remote_addr = remote_addr;
+	rdma_wr->rkey = rkey;
+
+	return 1;
+}
+
+/**
+ * rdma_rw_ctx_init - initialize a RDMA READ/WRITE context
+ * @ctx:	context to initialize
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @sg:		scatterlist to READ/WRITE from/to
+ * @sg_cnt:	number of entries in @sg
+ * @sg_offset:	current byte offset into @sg
+ * @length:	total length of @sg in bytes
+ * @remote_addr:remote address to read/write (relative to @rkey)
+ * @rkey:	remote key to operate on
+ * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ *
+ * If we're going to use a FR to map this context @max_nents should be smaller
+ * or equal to the MR size.
+ *
+ * Returns the number of WQEs that will be needed on the workqueue if
+ * successful, or a negative error code.
+ */
+int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
+{
+	struct ib_device *dev = qp->pd->device;
+	int ret;
+
+	ctx->dma_nents = ib_dma_map_sg(dev, sg, sg_cnt, dir);
+	if (!ctx->dma_nents)
+		return -ENOMEM;
+
+	/*
+	 * Skip to the S/G entry that sg_offset falls into:
+	 */
+	for (; sg; sg = sg_next(sg)) {
+		u32 len = ib_sg_dma_len(dev, sg);
+
+		if (sg_offset < len)
+			break;
+
+		sg_offset -= len;
+		ctx->dma_nents--;
+	}
+
+	if (rdma_rw_use_mr(qp->device, port_num)) {
+		ret = rdma_rw_init_mr_wrs(ctx, qp, port_num, sg, sg_offset,
+				remote_addr, rkey, dir);
+	} else if (ctx->dma_nents > 1) {
+		ret = rdma_rw_init_map_wrs(ctx, qp, sg, sg_offset,
+				remote_addr, rkey, dir);
+	} else {
+		ret = rdma_rw_init_single_wr(ctx, qp, sg, sg_offset,
+				remote_addr, rkey, dir);
+	}
+
+	if (ret < 0)
+		goto out_unmap_sg;
+	return ret;
+
+out_unmap_sg:
+	ib_dma_unmap_sg(dev, sg, sg_cnt, dir);
+	return ret;
+}
+EXPORT_SYMBOL(rdma_rw_ctx_init);
+
+/**
+ * rdma_rw_ctx_destroy - release all resources allocated by rdma_rw_ctx_init
+ * @ctx:	context to release
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @sg:		scatterlist that was used for the READ/WRITE
+ * @sg_cnt:	number of entries in @sg
+ * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ */
+void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct scatterlist *sg, u32 sg_cnt, enum dma_data_direction dir)
+{
+	if (rdma_rw_use_mr(qp->device, port_num)) {
+		int i;
+
+		for (i = 0; i < ctx->nr_ops; i++)
+			ib_mr_pool_put(qp, &qp->rdma_mrs, ctx->reg[i].mr);
+		kfree(ctx->reg);
+	} else if (ctx->dma_nents > 1) {
+		kfree(ctx->map.wrs);
+		kfree(ctx->map.sges);
+	}
+
+	ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+}
+EXPORT_SYMBOL(rdma_rw_ctx_destroy);
+
+/**
+ * rdma_rw_ctx_wrs - return chain of WRs for a RDMA READ or WRITE operation
+ * @ctx:	context to operate on
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @cqe:	completion queue entry for the last WR
+ * @chain_wr:	WR to append to the posted chain
+ *
+ * Return the WR chain for the set of RDMA READ/WRITE operations described by
+ * @ctx, as well as any memory registration operations needed.  If @chain_wr
+ * is non-NULL the WR it points to will be appended to the chain of WRs posted.
+ * If @chain_wr is not set @cqe must be set so that the caller gets a
+ * completion notification.
+ */
+struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
+{
+	struct ib_send_wr *first_wr, *last_wr;
+
+	if (rdma_rw_use_mr(qp->device, port_num)) {
+		if (ctx->reg[0].inv_wr.next)
+			first_wr = &ctx->reg[0].inv_wr;
+		else
+			first_wr = &ctx->reg[0].reg_wr.wr;
+		last_wr = &ctx->reg[ctx->nr_ops - 1].wr.wr;
+	} else if (ctx->dma_nents > 1) {
+		first_wr = &ctx->map.wrs[0].wr;
+		last_wr = &ctx->map.wrs[ctx->nr_ops - 1].wr;
+	} else {
+		first_wr = &ctx->single.wr.wr;
+		last_wr = &ctx->single.wr.wr;
+	}
+
+	if (chain_wr) {
+		last_wr->next = chain_wr;
+	} else {
+		last_wr->wr_cqe = cqe;
+		last_wr->send_flags |= IB_SEND_SIGNALED;
+	}
+
+	return first_wr;
+}
+EXPORT_SYMBOL(rdma_rw_ctx_wrs);
+
+/**
+ * rdma_rw_ctx_post - post a RDMA READ or RDMA WRITE operation
+ * @ctx:	context to operate on
+ * @qp:		queue pair to operate on
+ * @port_num:	port num to which the connection is bound
+ * @cqe:	completion queue entry for the last WR
+ * @chain_wr:	WR to append to the posted chain
+ *
+ * Post the set of RDMA READ/WRITE operations described by @ctx, as well as
+ * any memory registration operations needed.  If @chain_wr is non-NULL the
+ * WR it points to will be appended to the chain of WRs posted.  If @chain_wr
+ * is not set @cqe must be set so that the caller gets a completion
+ * notification.
+ */
+int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
+{
+	struct ib_send_wr *first_wr, *bad_wr;
+
+	first_wr = rdma_rw_ctx_wrs(ctx, qp, port_num, cqe, chain_wr);
+	return ib_post_send(qp, first_wr, &bad_wr);
+}
+EXPORT_SYMBOL(rdma_rw_ctx_post);
+
+void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
+{
+	/*
+	 * Each context needs at least one RDMA READ or WRITE WR.
+	 *
+	 * For some hardware we might need more, eventually we should ask the
+	 * HCA driver for a multiplier here.
+	 */
+	attr->cap.max_send_wr += attr->cap.max_rdma_ctxs;
+
+	/*
+	 * If the devices needs MRs to perform RDMA READ or WRITE operations,
+	 * we'll need two additional MRs for the registrations and the
+	 * invalidation.
+	 */
+	if (rdma_rw_use_mr(dev, attr->port_num))
+		attr->cap.max_send_wr += 2 * attr->cap.max_rdma_ctxs;
+}
+
+int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr)
+{
+	struct ib_device *dev = qp->pd->device;
+	int ret = 0;
+
+	if (rdma_rw_use_mr(dev, attr->port_num)) {
+		ret = ib_mr_pool_init(qp, &qp->rdma_mrs,
+				attr->cap.max_rdma_ctxs, IB_MR_TYPE_MEM_REG,
+				rdma_rw_fr_page_list_len(dev));
+	}
+
+	return ret;
+}
+
+void rdma_rw_cleanup_mrs(struct ib_qp *qp)
+{
+	ib_mr_pool_destroy(qp, &qp->rdma_mrs);
+}
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 69689866..72f4fbd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -48,6 +48,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>
+#include <rdma/rw.h>
 
 #include "core_priv.h"
 
@@ -751,6 +752,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 {
 	struct ib_device *device = pd ? pd->device : qp_init_attr->xrcd->device;
 	struct ib_qp *qp;
+	int ret;
+
+	/*
+	 * If the callers is using the RDMA API calculate the resources
+	 * needed for the RDMA READ/WRITE operations.
+	 *
+	 * Note that these callers need to pass in a port number.
+	 */
+	if (qp_init_attr->cap.max_rdma_ctxs)
+		rdma_rw_init_qp(device, qp_init_attr);
 
 	qp = device->create_qp(pd, qp_init_attr, NULL);
 	if (IS_ERR(qp))
@@ -764,6 +775,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	atomic_set(&qp->usecnt, 0);
 	qp->mrs_used = 0;
 	spin_lock_init(&qp->mr_lock);
+	INIT_LIST_HEAD(&qp->rdma_mrs);
 
 	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
 		return ib_create_xrc_qp(qp, qp_init_attr);
@@ -787,6 +799,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 
 	atomic_inc(&pd->usecnt);
 	atomic_inc(&qp_init_attr->send_cq->usecnt);
+
+	if (qp_init_attr->cap.max_rdma_ctxs) {
+		ret = rdma_rw_init_mrs(qp, qp_init_attr);
+		if (ret) {
+			pr_err("failed to init MR pool ret= %d\n", ret);
+			ib_destroy_qp(qp);
+			qp = ERR_PTR(ret);
+		}
+	}
+
 	return qp;
 }
 EXPORT_SYMBOL(ib_create_qp);
@@ -1271,6 +1293,9 @@ int ib_destroy_qp(struct ib_qp *qp)
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
 
+	if (!qp->uobject)
+		rdma_rw_cleanup_mrs(qp);
+
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
 		if (pd)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 068d540..074854d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -915,6 +915,13 @@ struct ib_qp_cap {
 	u32	max_send_sge;
 	u32	max_recv_sge;
 	u32	max_inline_data;
+
+	/*
+	 * Maximum number of rdma_rw_ctx structures in flight at a time.
+	 * ib_create_qp() will calculate the right amount of neededed WRs
+	 * and MRs based on this.
+	 */
+	u32	max_rdma_ctxs;
 };
 
 enum ib_sig_type {
@@ -986,7 +993,11 @@ struct ib_qp_init_attr {
 	enum ib_sig_type	sq_sig_type;
 	enum ib_qp_type		qp_type;
 	enum ib_qp_create_flags	create_flags;
-	u8			port_num; /* special QP types only */
+
+	/*
+	 * Only needed for special QP types, or when using the RW API.
+	 */
+	u8			port_num;
 };
 
 struct ib_qp_open_attr {
@@ -1407,6 +1418,7 @@ struct ib_qp {
 	struct ib_cq	       *recv_cq;
 	spinlock_t		mr_lock;
 	int			mrs_used;
+	struct list_head	rdma_mrs;
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
new file mode 100644
index 0000000..57ea304
--- /dev/null
+++ b/include/rdma/rw.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2016 HGST, a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#ifndef _RDMA_RW_H
+#define _RDMA_RW_H
+
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_cm.h>
+#include <rdma/mr_pool.h>
+
+struct rdma_rw_ctx {
+	/* number of SGL entries returned by dma_map_sg */
+	u32			dma_nents;
+
+	/* number of RDMA READ/WRITE WRs (not counting MR WRs) */
+	u32			nr_ops;
+
+	union {
+		/* for mapping a single SGE: */
+		struct {
+			struct ib_sge		sge;
+			struct ib_rdma_wr	wr;
+		} single;
+
+		/* for mapping of multiple SGEs: */
+		struct {
+			struct ib_sge		*sges;
+			struct ib_rdma_wr	*wrs;
+		} map;
+
+		/* for registering multiple WRs: */
+		struct rdma_rw_reg_ctx {
+			struct ib_sge		sge;
+			struct ib_rdma_wr	wr;
+			struct ib_reg_wr	reg_wr;
+			struct ib_send_wr	inv_wr;
+			struct ib_mr		*mr;
+		} *reg;
+	};
+};
+
+int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir);
+void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct scatterlist *sg, u32 sg_cnt,
+		enum dma_data_direction dir);
+
+struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+		u8 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr);
+int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		struct ib_cqe *cqe, struct ib_send_wr *chain_wr);
+
+void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr);
+int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr);
+void rdma_rw_cleanup_mrs(struct ib_qp *qp);
+
+#endif /* _RDMA_RW_H */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
