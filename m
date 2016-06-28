From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/5] IB/core: Add max_sge argument to rdma_rw_ctx_init()
Date: Tue, 28 Jun 2016 13:26:03 +0200
Message-ID: <ce96b1f4-e9b9-31e2-f9d2-77e71f8bbcd1@sandisk.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <419391ba-0c39-11ce-f249-84b428dc73d5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SGE limit for a queue pair is typically lower than what is
defined by the HCA limits. Hence make max_sge an argument.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/rw.c            | 17 ++++++-----------
 drivers/infiniband/ulp/isert/ib_isert.c |  7 +++++--
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  8 +++++++-
 include/rdma/rw.h                       |  3 ++-
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 13d4067..3894f9e 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -58,13 +58,6 @@ static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 	return false;
 }
 
-static inline u32 rdma_rw_max_sge(struct ib_device *dev,
-		enum dma_data_direction dir)
-{
-	return dir == DMA_TO_DEVICE ?
-		dev->attrs.max_sge : dev->attrs.max_sge_rd;
-}
-
 static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
 {
 	/* arbitrary limit to avoid allocating gigantic resources */
@@ -183,10 +176,10 @@ out:
 
 static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		struct scatterlist *sg, u32 sg_cnt, u32 offset,
-		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
+		u32 max_sge)
 {
 	struct ib_device *dev = qp->pd->device;
-	u32 max_sge = rdma_rw_max_sge(dev, dir);
 	struct ib_sge *sge;
 	u32 total_len = 0, i, j;
 
@@ -275,13 +268,15 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
  * @remote_addr:remote address to read/write (relative to @rkey)
  * @rkey:	remote key to operate on
  * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ * @max_sge:    maximum number of SG elements per work request
  *
  * Returns the number of WQEs that will be needed on the workqueue if
  * successful, or a negative error code.
  */
 int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
-		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
+		u32 max_sge)
 {
 	struct ib_device *dev = qp->pd->device;
 	int ret;
@@ -314,7 +309,7 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 				sg_offset, remote_addr, rkey, dir);
 	} else if (sg_cnt > 1) {
 		ret = rdma_rw_init_map_wrs(ctx, qp, sg, sg_cnt, sg_offset,
-				remote_addr, rkey, dir);
+				remote_addr, rkey, dir, max_sge);
 	} else {
 		ret = rdma_rw_init_single_wr(ctx, qp, sg, sg_offset,
 				remote_addr, rkey, dir);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a990c04..06a5671 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2075,21 +2075,24 @@ static int
 isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 		struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
 {
+	struct ib_device *dev = conn->device->ib_device;
 	struct se_cmd *se_cmd = &cmd->iscsi_cmd->se_cmd;
 	enum dma_data_direction dir = target_reverse_dma_direction(se_cmd);
 	u8 port_num = conn->cm_id->port_num;
 	u64 addr;
-	u32 rkey, offset;
+	u32 rkey, offset, max_sge;
 	int ret;
 
 	if (dir == DMA_FROM_DEVICE) {
 		addr = cmd->write_va;
 		rkey = cmd->write_stag;
 		offset = cmd->iscsi_cmd->write_data_done;
+		max_sge = dev->attrs.max_sge_rd;
 	} else {
 		addr = cmd->read_va;
 		rkey = cmd->read_stag;
 		offset = 0;
+		max_sge = dev->attrs.max_sge;
 	}
 
 	if (isert_prot_cmd(conn, se_cmd)) {
@@ -2107,7 +2110,7 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 	} else {
 		ret = rdma_rw_ctx_init(&cmd->rw, conn->qp, port_num,
 				se_cmd->t_data_sg, se_cmd->t_data_nents,
-				offset, addr, rkey, dir);
+				offset, addr, rkey, dir, max_sge);
 	}
 	if (ret < 0) {
 		isert_err("Cmd: %p failed to prepare RDMA res\n", cmd);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4a41556..2ed65f5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -803,7 +803,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 {
 	enum dma_data_direction dir = target_reverse_dma_direction(&ioctx->cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
+	struct ib_device *dev = ch->qp->pd->device;
 	struct scatterlist *prev = NULL;
+	u32 max_sge;
 	unsigned prev_nents;
 	int ret, i;
 
@@ -816,6 +818,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 			return -ENOMEM;
 	}
 
+	max_sge = dir == DMA_TO_DEVICE ? dev->attrs.max_sge :
+		dev->attrs.max_sge_rd;
+
 	for (i = ioctx->n_rw_ctx; i < nbufs; i++, db++) {
 		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 		u64 remote_addr = be64_to_cpu(db->va);
@@ -828,7 +833,8 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 			goto unwind;
 
 		ret = rdma_rw_ctx_init(&ctx->rw, ch->qp, ch->sport->port,
-				ctx->sg, ctx->nents, 0, remote_addr, rkey, dir);
+				ctx->sg, ctx->nents, 0, remote_addr, rkey, dir,
+				max_sge);
 		if (ret < 0) {
 			target_free_sgl(ctx->sg, ctx->nents);
 			goto unwind;
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
index 377d865..590a8aec 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -61,7 +61,8 @@ struct rdma_rw_ctx {
 
 int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
-		u64 remote_addr, u32 rkey, enum dma_data_direction dir);
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
+		u32 max_sge);
 void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt,
 		enum dma_data_direction dir);
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
