From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/12] IB/srpt: convert to the generic RDMA READ/WRITE API
Date: Mon, 11 Apr 2016 14:32:38 -0700
Message-ID: <1460410360-13104-11-git-send-email-hch@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Replace the homegrown RDMA READ/WRITE code in srpt with the generic API.
The only real twist here is that we need to allocate one Linux scatterlist
per direct buffer in the SRP command, and chain them before handing them
off to the target core.

As a side-effect of the conversion the driver will also chain the SEND
of the SRP response to the RDMA WRITE WRs for a DATA OUT command, and
properly account for RDMA WRITE WRs instead of just for RDMA READ WRs
like the driver previously did.

We now allocate half of the SQ size to RDMA READ/WRITE contexts, assuming
by default one RDMA READ or WRITE operation per command.  If a command
has multiple operations it will eat into the budget but will still succeed,
possible after waiting for WQEs to be available.

Also ensure the QPs request the maximum allowed SGEs so that RDMA R/W API
works correctly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 737 ++++++++++++----------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  31 +-
 2 files changed, 269 insertions(+), 499 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8b42401..d69b1a9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -765,52 +765,6 @@ static int srpt_post_recv(struct srpt_device *sdev,
 }
 
 /**
- * srpt_post_send() - Post an IB send request.
- *
- * Returns zero upon success and a non-zero value upon failure.
- */
-static int srpt_post_send(struct srpt_rdma_ch *ch,
-			  struct srpt_send_ioctx *ioctx, int len)
-{
-	struct ib_sge list;
-	struct ib_send_wr wr, *bad_wr;
-	struct srpt_device *sdev = ch->sport->sdev;
-	int ret;
-
-	atomic_inc(&ch->req_lim);
-
-	ret = -ENOMEM;
-	if (unlikely(atomic_dec_return(&ch->sq_wr_avail) < 0)) {
-		pr_warn("IB send queue full (needed 1)\n");
-		goto out;
-	}
-
-	ib_dma_sync_single_for_device(sdev->device, ioctx->ioctx.dma, len,
-				      DMA_TO_DEVICE);
-
-	list.addr = ioctx->ioctx.dma;
-	list.length = len;
-	list.lkey = sdev->pd->local_dma_lkey;
-
-	ioctx->ioctx.cqe.done = srpt_send_done;
-	wr.next = NULL;
-	wr.wr_cqe = &ioctx->ioctx.cqe;
-	wr.sg_list = &list;
-	wr.num_sge = 1;
-	wr.opcode = IB_WR_SEND;
-	wr.send_flags = IB_SEND_SIGNALED;
-
-	ret = ib_post_send(ch->qp, &wr, &bad_wr);
-
-out:
-	if (ret < 0) {
-		atomic_inc(&ch->sq_wr_avail);
-		atomic_dec(&ch->req_lim);
-	}
-	return ret;
-}
-
-/**
  * srpt_zerolength_write() - Perform a zero-length RDMA write.
  *
  * A quote from the InfiniBand specification: C9-88: For an HCA responder
@@ -843,6 +797,110 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 	}
 }
 
+static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
+		struct srp_direct_buf *db, int nbufs, struct scatterlist **sg,
+		unsigned *sg_cnt)
+{
+	enum dma_data_direction dir = target_reverse_dma_direction(&ioctx->cmd);
+	struct srpt_rdma_ch *ch = ioctx->ch;
+	struct scatterlist *prev = NULL;
+	unsigned prev_nents;
+	int ret, i;
+
+	if (nbufs == 1) {
+		ioctx->rw_ctxs = &ioctx->s_rw_ctx;
+	} else {
+		ioctx->rw_ctxs = kmalloc_array(nbufs, sizeof(*ioctx->rw_ctxs),
+				GFP_KERNEL);
+		if (!ioctx->rw_ctxs)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < nbufs; i++, db++) {
+		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+		u64 remote_addr = be64_to_cpu(db->va);
+		u32 size = be32_to_cpu(db->len);
+		u32 rkey = be32_to_cpu(db->key);
+
+		ret = target_alloc_sgl(&ctx->sg, &ctx->nents, size, false,
+				i < nbufs - 1);
+		if (ret)
+			goto unwind;
+
+		ret = rdma_rw_ctx_init(&ctx->rw, ch->qp, ch->sport->port,
+				ctx->sg, ctx->nents, 0, remote_addr, rkey, dir);
+		if (ret < 0) {
+			target_free_sgl(ctx->sg, ctx->nents);
+			goto unwind;
+		}
+
+		ioctx->n_rdma += ret;
+
+		if (prev) {
+			sg_unmark_end(&prev[prev_nents - 1]);
+			sg_chain(prev, prev_nents + 1, ctx->sg);
+		} else {
+			*sg = ctx->sg;
+		}
+
+		prev = ctx->sg;
+		prev_nents = ctx->nents;
+
+		*sg_cnt += ctx->nents;
+	}
+
+	ioctx->n_rw_ctx = nbufs;
+	return 0;
+
+unwind:
+	while (--i >= 0) {
+		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+
+		rdma_rw_ctx_destroy(&ctx->rw, ch->qp, ch->sport->port,
+				ctx->sg, ctx->nents, dir);
+		target_free_sgl(ctx->sg, ctx->nents);
+	}
+	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
+		kfree(ioctx->rw_ctxs);
+	return ret;
+}
+
+static void srpt_free_rw_ctxs(struct srpt_rdma_ch *ch,
+				    struct srpt_send_ioctx *ioctx)
+{
+	enum dma_data_direction dir = target_reverse_dma_direction(&ioctx->cmd);
+	int i;
+
+	for (i = 0; i < ioctx->n_rw_ctx; i++) {
+		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+
+		rdma_rw_ctx_destroy(&ctx->rw, ch->qp, ch->sport->port,
+				ctx->sg, ctx->nents, dir);
+		target_free_sgl(ctx->sg, ctx->nents);
+	}
+
+	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
+		kfree(ioctx->rw_ctxs);
+}
+
+static inline void *srpt_get_desc_buf(struct srp_cmd *srp_cmd)
+{
+	/*
+	 * The pointer computations below will only be compiled correctly
+	 * if srp_cmd::add_data is declared as s8*, u8*, s8[] or u8[], so check
+	 * whether srp_cmd::add_data has been declared as a byte pointer.
+	 */
+	BUILD_BUG_ON(!__same_type(srp_cmd->add_data[0], (s8)0) &&
+		     !__same_type(srp_cmd->add_data[0], (u8)0));
+
+	/*
+	 * According to the SRP spec, the lower two bits of the 'ADDITIONAL
+	 * CDB LENGTH' field are reserved and the size in bytes of this field
+	 * is four times the value specified in bits 3..7. Hence the "& ~3".
+	 */
+	return srp_cmd->add_data + (srp_cmd->add_cdb_len & ~3);
+}
+
 /**
  * srpt_get_desc_tbl() - Parse the data descriptors of an SRP_CMD request.
  * @ioctx: Pointer to the I/O context associated with the request.
@@ -858,94 +916,59 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
  * -ENOMEM when memory allocation fails and zero upon success.
  */
 static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
-			     struct srp_cmd *srp_cmd,
-			     enum dma_data_direction *dir, u64 *data_len)
+		struct srp_cmd *srp_cmd, enum dma_data_direction *dir,
+		struct scatterlist **sg, unsigned *sg_cnt, u64 *data_len)
 {
-	struct srp_indirect_buf *idb;
-	struct srp_direct_buf *db;
-	unsigned add_cdb_offset;
-	int ret;
-
-	/*
-	 * The pointer computations below will only be compiled correctly
-	 * if srp_cmd::add_data is declared as s8*, u8*, s8[] or u8[], so check
-	 * whether srp_cmd::add_data has been declared as a byte pointer.
-	 */
-	BUILD_BUG_ON(!__same_type(srp_cmd->add_data[0], (s8)0)
-		     && !__same_type(srp_cmd->add_data[0], (u8)0));
-
 	BUG_ON(!dir);
 	BUG_ON(!data_len);
 
-	ret = 0;
-	*data_len = 0;
-
 	/*
 	 * The lower four bits of the buffer format field contain the DATA-IN
 	 * buffer descriptor format, and the highest four bits contain the
 	 * DATA-OUT buffer descriptor format.
 	 */
-	*dir = DMA_NONE;
 	if (srp_cmd->buf_fmt & 0xf)
 		/* DATA-IN: transfer data from target to initiator (read). */
 		*dir = DMA_FROM_DEVICE;
 	else if (srp_cmd->buf_fmt >> 4)
 		/* DATA-OUT: transfer data from initiator to target (write). */
 		*dir = DMA_TO_DEVICE;
+	else
+		*dir = DMA_NONE;
+
+	/* initialize data_direction early as srpt_alloc_rw_ctxs needs it */
+	ioctx->cmd.data_direction = *dir;
 
-	/*
-	 * According to the SRP spec, the lower two bits of the 'ADDITIONAL
-	 * CDB LENGTH' field are reserved and the size in bytes of this field
-	 * is four times the value specified in bits 3..7. Hence the "& ~3".
-	 */
-	add_cdb_offset = srp_cmd->add_cdb_len & ~3;
 	if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_DIRECT) ||
 	    ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_DIRECT)) {
-		ioctx->n_rbuf = 1;
-		ioctx->rbufs = &ioctx->single_rbuf;
+	    	struct srp_direct_buf *db = srpt_get_desc_buf(srp_cmd);
 
-		db = (struct srp_direct_buf *)(srp_cmd->add_data
-					       + add_cdb_offset);
-		memcpy(ioctx->rbufs, db, sizeof(*db));
 		*data_len = be32_to_cpu(db->len);
+		return srpt_alloc_rw_ctxs(ioctx, db, 1, sg, sg_cnt);
 	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
 		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
-		idb = (struct srp_indirect_buf *)(srp_cmd->add_data
-						  + add_cdb_offset);
+		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
+		int nbufs = be32_to_cpu(idb->table_desc.len) /
+				sizeof(struct srp_direct_buf);
 
-		ioctx->n_rbuf = be32_to_cpu(idb->table_desc.len) / sizeof(*db);
-
-		if (ioctx->n_rbuf >
+		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
 			pr_err("received unsupported SRP_CMD request"
 			       " type (%u out + %u in != %u / %zu)\n",
 			       srp_cmd->data_out_desc_cnt,
 			       srp_cmd->data_in_desc_cnt,
 			       be32_to_cpu(idb->table_desc.len),
-			       sizeof(*db));
-			ioctx->n_rbuf = 0;
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (ioctx->n_rbuf == 1)
-			ioctx->rbufs = &ioctx->single_rbuf;
-		else {
-			ioctx->rbufs =
-				kmalloc(ioctx->n_rbuf * sizeof(*db), GFP_ATOMIC);
-			if (!ioctx->rbufs) {
-				ioctx->n_rbuf = 0;
-				ret = -ENOMEM;
-				goto out;
-			}
+			       sizeof(struct srp_direct_buf));
+			return -EINVAL;
 		}
 
-		db = idb->desc_list;
-		memcpy(ioctx->rbufs, db, ioctx->n_rbuf * sizeof(*db));
 		*data_len = be32_to_cpu(idb->len);
+		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
+				sg, sg_cnt);
+	} else {
+		*data_len = 0;
+		return 0;
 	}
-out:
-	return ret;
 }
 
 /**
@@ -1049,217 +1072,6 @@ static int srpt_ch_qp_err(struct srpt_rdma_ch *ch)
 }
 
 /**
- * srpt_unmap_sg_to_ib_sge() - Unmap an IB SGE list.
- */
-static void srpt_unmap_sg_to_ib_sge(struct srpt_rdma_ch *ch,
-				    struct srpt_send_ioctx *ioctx)
-{
-	struct scatterlist *sg;
-	enum dma_data_direction dir;
-
-	BUG_ON(!ch);
-	BUG_ON(!ioctx);
-	BUG_ON(ioctx->n_rdma && !ioctx->rdma_wrs);
-
-	while (ioctx->n_rdma)
-		kfree(ioctx->rdma_wrs[--ioctx->n_rdma].wr.sg_list);
-
-	kfree(ioctx->rdma_wrs);
-	ioctx->rdma_wrs = NULL;
-
-	if (ioctx->mapped_sg_count) {
-		sg = ioctx->sg;
-		WARN_ON(!sg);
-		dir = ioctx->cmd.data_direction;
-		BUG_ON(dir == DMA_NONE);
-		ib_dma_unmap_sg(ch->sport->sdev->device, sg, ioctx->sg_cnt,
-				target_reverse_dma_direction(&ioctx->cmd));
-		ioctx->mapped_sg_count = 0;
-	}
-}
-
-/**
- * srpt_map_sg_to_ib_sge() - Map an SG list to an IB SGE list.
- */
-static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
-				 struct srpt_send_ioctx *ioctx)
-{
-	struct ib_device *dev = ch->sport->sdev->device;
-	struct se_cmd *cmd;
-	struct scatterlist *sg, *sg_orig;
-	int sg_cnt;
-	enum dma_data_direction dir;
-	struct ib_rdma_wr *riu;
-	struct srp_direct_buf *db;
-	dma_addr_t dma_addr;
-	struct ib_sge *sge;
-	u64 raddr;
-	u32 rsize;
-	u32 tsize;
-	u32 dma_len;
-	int count, nrdma;
-	int i, j, k;
-
-	BUG_ON(!ch);
-	BUG_ON(!ioctx);
-	cmd = &ioctx->cmd;
-	dir = cmd->data_direction;
-	BUG_ON(dir == DMA_NONE);
-
-	ioctx->sg = sg = sg_orig = cmd->t_data_sg;
-	ioctx->sg_cnt = sg_cnt = cmd->t_data_nents;
-
-	count = ib_dma_map_sg(ch->sport->sdev->device, sg, sg_cnt,
-			      target_reverse_dma_direction(cmd));
-	if (unlikely(!count))
-		return -EAGAIN;
-
-	ioctx->mapped_sg_count = count;
-
-	if (ioctx->rdma_wrs && ioctx->n_rdma_wrs)
-		nrdma = ioctx->n_rdma_wrs;
-	else {
-		nrdma = (count + SRPT_DEF_SG_PER_WQE - 1) / SRPT_DEF_SG_PER_WQE
-			+ ioctx->n_rbuf;
-
-		ioctx->rdma_wrs = kcalloc(nrdma, sizeof(*ioctx->rdma_wrs),
-				GFP_KERNEL);
-		if (!ioctx->rdma_wrs)
-			goto free_mem;
-
-		ioctx->n_rdma_wrs = nrdma;
-	}
-
-	db = ioctx->rbufs;
-	tsize = cmd->data_length;
-	dma_len = ib_sg_dma_len(dev, &sg[0]);
-	riu = ioctx->rdma_wrs;
-
-	/*
-	 * For each remote desc - calculate the #ib_sge.
-	 * If #ib_sge < SRPT_DEF_SG_PER_WQE per rdma operation then
-	 *      each remote desc rdma_iu is required a rdma wr;
-	 * else
-	 *      we need to allocate extra rdma_iu to carry extra #ib_sge in
-	 *      another rdma wr
-	 */
-	for (i = 0, j = 0;
-	     j < count && i < ioctx->n_rbuf && tsize > 0; ++i, ++riu, ++db) {
-		rsize = be32_to_cpu(db->len);
-		raddr = be64_to_cpu(db->va);
-		riu->remote_addr = raddr;
-		riu->rkey = be32_to_cpu(db->key);
-		riu->wr.num_sge = 0;
-
-		/* calculate how many sge required for this remote_buf */
-		while (rsize > 0 && tsize > 0) {
-
-			if (rsize >= dma_len) {
-				tsize -= dma_len;
-				rsize -= dma_len;
-				raddr += dma_len;
-
-				if (tsize > 0) {
-					++j;
-					if (j < count) {
-						sg = sg_next(sg);
-						dma_len = ib_sg_dma_len(
-								dev, sg);
-					}
-				}
-			} else {
-				tsize -= rsize;
-				dma_len -= rsize;
-				rsize = 0;
-			}
-
-			++riu->wr.num_sge;
-
-			if (rsize > 0 &&
-			    riu->wr.num_sge == SRPT_DEF_SG_PER_WQE) {
-				++ioctx->n_rdma;
-				riu->wr.sg_list = kmalloc_array(riu->wr.num_sge,
-						sizeof(*riu->wr.sg_list),
-						GFP_KERNEL);
-				if (!riu->wr.sg_list)
-					goto free_mem;
-
-				++riu;
-				riu->wr.num_sge = 0;
-				riu->remote_addr = raddr;
-				riu->rkey = be32_to_cpu(db->key);
-			}
-		}
-
-		++ioctx->n_rdma;
-		riu->wr.sg_list = kmalloc_array(riu->wr.num_sge,
-					sizeof(*riu->wr.sg_list),
-					GFP_KERNEL);
-		if (!riu->wr.sg_list)
-			goto free_mem;
-	}
-
-	db = ioctx->rbufs;
-	tsize = cmd->data_length;
-	riu = ioctx->rdma_wrs;
-	sg = sg_orig;
-	dma_len = ib_sg_dma_len(dev, &sg[0]);
-	dma_addr = ib_sg_dma_address(dev, &sg[0]);
-
-	/* this second loop is really mapped sg_addres to rdma_iu->ib_sge */
-	for (i = 0, j = 0;
-	     j < count && i < ioctx->n_rbuf && tsize > 0; ++i, ++riu, ++db) {
-		rsize = be32_to_cpu(db->len);
-		sge = riu->wr.sg_list;
-		k = 0;
-
-		while (rsize > 0 && tsize > 0) {
-			sge->addr = dma_addr;
-			sge->lkey = ch->sport->sdev->pd->local_dma_lkey;
-
-			if (rsize >= dma_len) {
-				sge->length =
-					(tsize < dma_len) ? tsize : dma_len;
-				tsize -= dma_len;
-				rsize -= dma_len;
-
-				if (tsize > 0) {
-					++j;
-					if (j < count) {
-						sg = sg_next(sg);
-						dma_len = ib_sg_dma_len(
-								dev, sg);
-						dma_addr = ib_sg_dma_address(
-								dev, sg);
-					}
-				}
-			} else {
-				sge->length = (tsize < rsize) ? tsize : rsize;
-				tsize -= rsize;
-				dma_len -= rsize;
-				dma_addr += rsize;
-				rsize = 0;
-			}
-
-			++k;
-			if (k == riu->wr.num_sge && rsize > 0 && tsize > 0) {
-				++riu;
-				sge = riu->wr.sg_list;
-				k = 0;
-			} else if (rsize > 0 && tsize > 0)
-				++sge;
-		}
-	}
-
-	return 0;
-
-free_mem:
-	srpt_unmap_sg_to_ib_sge(ch, ioctx);
-
-	return -ENOMEM;
-}
-
-/**
  * srpt_get_send_ioctx() - Obtain an I/O context for sending to the initiator.
  */
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
@@ -1284,12 +1096,7 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	BUG_ON(ioctx->ch != ch);
 	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
-	ioctx->n_rbuf = 0;
-	ioctx->rbufs = NULL;
-	ioctx->n_rdma = 0;
-	ioctx->n_rdma_wrs = 0;
-	ioctx->rdma_wrs = NULL;
-	ioctx->mapped_sg_count = 0;
+	ioctx->n_rw_ctx = 0;
 	init_completion(&ioctx->tx_done);
 	ioctx->queue_status_only = false;
 	/*
@@ -1359,7 +1166,6 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		 * SRP_RSP sending failed or the SRP_RSP send completion has
 		 * not been received in time.
 		 */
-		srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
 		transport_generic_free_cmd(&ioctx->cmd, 0);
 		break;
 	case SRPT_STATE_MGMT_RSP_SENT:
@@ -1387,6 +1193,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	WARN_ON(ioctx->n_rdma <= 0);
 	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
+	ioctx->n_rdma = 0;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		pr_info("RDMA_READ for ioctx 0x%p failed with status %d\n",
@@ -1403,23 +1210,6 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 		       __LINE__, srpt_get_cmd_state(ioctx));
 }
 
-static void srpt_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct srpt_send_ioctx *ioctx =
-		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
-
-	if (unlikely(wc->status != IB_WC_SUCCESS)) {
-		/*
-		 * Note: if an RDMA write error completion is received that
-		 * means that a SEND also has been posted. Defer further
-		 * processing of the associated command until the send error
-		 * completion has been received.
-		 */
-		pr_info("RDMA_WRITE for ioctx 0x%p failed with status %d\n",
-			ioctx, wc->status);
-	}
-}
-
 /**
  * srpt_build_cmd_rsp() - Build an SRP_RSP response.
  * @ch: RDMA channel through which the request has been received.
@@ -1531,12 +1321,14 @@ static int srpt_check_stop_free(struct se_cmd *cmd)
 /**
  * srpt_handle_cmd() - Process SRP_CMD.
  */
-static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
+static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			    struct srpt_recv_ioctx *recv_ioctx,
 			    struct srpt_send_ioctx *send_ioctx)
 {
 	struct se_cmd *cmd;
 	struct srp_cmd *srp_cmd;
+	struct scatterlist *sg = NULL;
+	unsigned sg_cnt = 0;
 	u64 data_len;
 	enum dma_data_direction dir;
 	int rc;
@@ -1563,26 +1355,34 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		break;
 	}
 
-	if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
-		pr_err("0x%llx: parsing SRP descriptor table failed.\n",
-		       srp_cmd->tag);
+	rc = srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &sg, &sg_cnt,
+			&data_len);
+	if (rc) {
+		if (rc != -EAGAIN) {
+			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
+			       srp_cmd->tag);
+		} else {
+			printk_ratelimited("out of MRs for 0x%llx\n", srp_cmd->tag);
+		}
 		goto release_ioctx;
 	}
 
-	rc = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
+	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
 			       &send_ioctx->sense_data[0],
 			       scsilun_to_int(&srp_cmd->lun), data_len,
-			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
+			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
+			       sg, sg_cnt, NULL, 0, NULL, 0);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto release_ioctx;
 	}
-	return;
+	return 0;
 
 release_ioctx:
 	send_ioctx->state = SRPT_STATE_DONE;
 	srpt_release_cmd(cmd);
+	return rc;
 }
 
 static int srp_tmr_to_tcm(int fn)
@@ -1664,28 +1464,24 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 				   recv_ioctx->ioctx.dma, srp_max_req_size,
 				   DMA_FROM_DEVICE);
 
-	if (unlikely(ch->state == CH_CONNECTING)) {
-		list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
-		goto out;
-	}
+	if (unlikely(ch->state == CH_CONNECTING))
+		goto out_wait;
 
 	if (unlikely(ch->state != CH_LIVE))
-		goto out;
+		return;
 
 	srp_cmd = recv_ioctx->ioctx.buf;
 	if (srp_cmd->opcode == SRP_CMD || srp_cmd->opcode == SRP_TSK_MGMT) {
 		if (!send_ioctx)
 			send_ioctx = srpt_get_send_ioctx(ch);
-		if (unlikely(!send_ioctx)) {
-			list_add_tail(&recv_ioctx->wait_list,
-				      &ch->cmd_wait_list);
-			goto out;
-		}
+		if (unlikely(!send_ioctx))
+			goto out_wait;
 	}
 
 	switch (srp_cmd->opcode) {
 	case SRP_CMD:
-		srpt_handle_cmd(ch, recv_ioctx, send_ioctx);
+		if (srpt_handle_cmd(ch, recv_ioctx, send_ioctx) == -EAGAIN)
+			goto out_wait;
 		break;
 	case SRP_TSK_MGMT:
 		srpt_handle_tsk_mgmt(ch, recv_ioctx, send_ioctx);
@@ -1709,8 +1505,10 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 	}
 
 	srpt_post_recv(ch->sport->sdev, recv_ioctx);
-out:
 	return;
+
+out_wait:
+	list_add_tail(&recv_ioctx->wait_list, &ch->cmd_wait_list);
 }
 
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -1779,14 +1577,13 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	WARN_ON(state != SRPT_STATE_CMD_RSP_SENT &&
 		state != SRPT_STATE_MGMT_RSP_SENT);
 
-	atomic_inc(&ch->sq_wr_avail);
+	atomic_add(1 + ioctx->n_rdma, &ch->sq_wr_avail);
 
 	if (wc->status != IB_WC_SUCCESS)
 		pr_info("sending response for ioctx 0x%p failed"
 			" with status %d\n", ioctx, wc->status);
 
 	if (state != SRPT_STATE_DONE) {
-		srpt_unmap_sg_to_ib_sge(ch, ioctx);
 		transport_generic_free_cmd(&ioctx->cmd, 0);
 	} else {
 		pr_err("IB completion has been received too late for"
@@ -1832,8 +1629,18 @@ retry:
 	qp_init->srq = sdev->srq;
 	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_init->qp_type = IB_QPT_RC;
-	qp_init->cap.max_send_wr = srp_sq_size;
-	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
+	/*
+	 * We divide up our send queue size into half SEND WRs to send the
+	 * completions, and half R/W contexts to actually do the RDMA
+	 * READ/WRITE transfers.  Note that we need to allocate CQ slots for
+	 * both both, as RDMA contexts will also post completions for the
+	 * RDMA READ case.
+	 */
+	qp_init->cap.max_send_wr = srp_sq_size / 2;
+	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
+	qp_init->cap.max_send_sge = max(sdev->device->attrs.max_sge_rd,
+					sdev->device->attrs.max_sge);
+	qp_init->port_num = ch->sport->port;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
 	if (IS_ERR(ch->qp)) {
@@ -2386,95 +2193,6 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	return ret;
 }
 
-/**
- * srpt_perform_rdmas() - Perform IB RDMA.
- *
- * Returns zero upon success or a negative number upon failure.
- */
-static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
-			      struct srpt_send_ioctx *ioctx)
-{
-	struct ib_send_wr *bad_wr;
-	int sq_wr_avail, ret, i;
-	enum dma_data_direction dir;
-	const int n_rdma = ioctx->n_rdma;
-
-	dir = ioctx->cmd.data_direction;
-	if (dir == DMA_TO_DEVICE) {
-		/* write */
-		ret = -ENOMEM;
-		sq_wr_avail = atomic_sub_return(n_rdma, &ch->sq_wr_avail);
-		if (sq_wr_avail < 0) {
-			pr_warn("IB send queue full (needed %d)\n",
-				n_rdma);
-			goto out;
-		}
-	}
-
-	for (i = 0; i < n_rdma; i++) {
-		struct ib_send_wr *wr = &ioctx->rdma_wrs[i].wr;
-
-		wr->opcode = (dir == DMA_FROM_DEVICE) ?
-				IB_WR_RDMA_WRITE : IB_WR_RDMA_READ;
-
-		if (i == n_rdma - 1) {
-			/* only get completion event for the last rdma read */
-			if (dir == DMA_TO_DEVICE) {
-				wr->send_flags = IB_SEND_SIGNALED;
-				ioctx->rdma_cqe.done = srpt_rdma_read_done;
-			} else {
-				ioctx->rdma_cqe.done = srpt_rdma_write_done;
-			}
-			wr->wr_cqe = &ioctx->rdma_cqe;
-			wr->next = NULL;
-		} else {
-			wr->wr_cqe = NULL;
-			wr->next = &ioctx->rdma_wrs[i + 1].wr;
-		}
-	}
-
-	ret = ib_post_send(ch->qp, &ioctx->rdma_wrs->wr, &bad_wr);
-	if (ret)
-		pr_err("%s[%d]: ib_post_send() returned %d for %d/%d\n",
-				 __func__, __LINE__, ret, i, n_rdma);
-out:
-	if (unlikely(dir == DMA_TO_DEVICE && ret < 0))
-		atomic_add(n_rdma, &ch->sq_wr_avail);
-	return ret;
-}
-
-/**
- * srpt_xfer_data() - Start data transfer from initiator to target.
- */
-static int srpt_xfer_data(struct srpt_rdma_ch *ch,
-			  struct srpt_send_ioctx *ioctx)
-{
-	int ret;
-
-	ret = srpt_map_sg_to_ib_sge(ch, ioctx);
-	if (ret) {
-		pr_err("%s[%d] ret=%d\n", __func__, __LINE__, ret);
-		goto out;
-	}
-
-	ret = srpt_perform_rdmas(ch, ioctx);
-	if (ret) {
-		if (ret == -EAGAIN || ret == -ENOMEM)
-			pr_info("%s[%d] queue full -- ret=%d\n",
-				__func__, __LINE__, ret);
-		else
-			pr_err("%s[%d] fatal error -- ret=%d\n",
-			       __func__, __LINE__, ret);
-		goto out_unmap;
-	}
-
-out:
-	return ret;
-out_unmap:
-	srpt_unmap_sg_to_ib_sge(ch, ioctx);
-	goto out;
-}
-
 static int srpt_write_pending_status(struct se_cmd *se_cmd)
 {
 	struct srpt_send_ioctx *ioctx;
@@ -2491,11 +2209,42 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx =
 		container_of(se_cmd, struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
+	struct ib_send_wr *first_wr = NULL, *bad_wr;
+	struct ib_cqe *cqe = &ioctx->rdma_cqe;
 	enum srpt_command_state new_state;
+	int ret, i;
 
 	new_state = srpt_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA);
 	WARN_ON(new_state == SRPT_STATE_DONE);
-	return srpt_xfer_data(ch, ioctx);
+
+	if (atomic_sub_return(ioctx->n_rdma, &ch->sq_wr_avail) < 0) {
+		pr_warn("%s: IB send queue full (needed %d)\n",
+				__func__, ioctx->n_rdma);
+		ret = -ENOMEM;
+		goto out_undo;
+	}
+
+	cqe->done = srpt_rdma_read_done;
+	for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
+		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+
+		first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp, ch->sport->port,
+				cqe, first_wr);
+		cqe = NULL;
+	}
+	
+	ret = ib_post_send(ch->qp, first_wr, &bad_wr);
+	if (ret) {
+		pr_err("%s: ib_post_send() returned %d for %d (avail: %d)\n",
+			 __func__, ret, ioctx->n_rdma,
+			 atomic_read(&ch->sq_wr_avail));
+		goto out_undo;
+	}
+
+	return 0;
+out_undo:
+	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
+	return ret;
 }
 
 static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
@@ -2517,17 +2266,17 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
  */
 static void srpt_queue_response(struct se_cmd *cmd)
 {
-	struct srpt_rdma_ch *ch;
-	struct srpt_send_ioctx *ioctx;
+	struct srpt_send_ioctx *ioctx =
+		container_of(cmd, struct srpt_send_ioctx, cmd);
+	struct srpt_rdma_ch *ch = ioctx->ch;
+	struct srpt_device *sdev = ch->sport->sdev;
+	struct ib_send_wr send_wr, *first_wr = NULL, *bad_wr;
+	struct ib_sge sge;
 	enum srpt_command_state state;
 	unsigned long flags;
-	int ret;
-	enum dma_data_direction dir;
-	int resp_len;
+	int resp_len, ret, i;
 	u8 srp_tm_status;
 
-	ioctx = container_of(cmd, struct srpt_send_ioctx, cmd);
-	ch = ioctx->ch;
 	BUG_ON(!ch);
 
 	spin_lock_irqsave(&ioctx->spinlock, flags);
@@ -2554,17 +2303,19 @@ static void srpt_queue_response(struct se_cmd *cmd)
 		return;
 	}
 
-	dir = ioctx->cmd.data_direction;
-
 	/* For read commands, transfer the data to the initiator. */
-	if (dir == DMA_FROM_DEVICE && ioctx->cmd.data_length &&
+	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
+	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
-		ret = srpt_xfer_data(ch, ioctx);
-		if (ret) {
-			pr_err("xfer_data failed for tag %llu\n",
-			       ioctx->cmd.tag);
-			return;
+		for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
+			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+
+			first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
+					ch->sport->port, NULL,
+					first_wr ? first_wr : &send_wr);
 		}
+	} else {
+		first_wr = &send_wr;
 	}
 
 	if (state != SRPT_STATE_MGMT)
@@ -2576,14 +2327,46 @@ static void srpt_queue_response(struct se_cmd *cmd)
 		resp_len = srpt_build_tskmgmt_rsp(ch, ioctx, srp_tm_status,
 						 ioctx->cmd.tag);
 	}
-	ret = srpt_post_send(ch, ioctx, resp_len);
-	if (ret) {
-		pr_err("sending cmd response failed for tag %llu\n",
-		       ioctx->cmd.tag);
-		srpt_unmap_sg_to_ib_sge(ch, ioctx);
-		srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
-		target_put_sess_cmd(&ioctx->cmd);
+
+	atomic_inc(&ch->req_lim);
+
+	if (unlikely(atomic_sub_return(1 + ioctx->n_rdma,
+			&ch->sq_wr_avail) < 0)) {
+		pr_warn("%s: IB send queue full (needed %d)\n",
+				__func__, ioctx->n_rdma);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ib_dma_sync_single_for_device(sdev->device, ioctx->ioctx.dma, resp_len,
+				      DMA_TO_DEVICE);
+
+	sge.addr = ioctx->ioctx.dma;
+	sge.length = resp_len;
+	sge.lkey = sdev->pd->local_dma_lkey;
+
+	ioctx->ioctx.cqe.done = srpt_send_done;
+	send_wr.next = NULL;
+	send_wr.wr_cqe = &ioctx->ioctx.cqe;
+	send_wr.sg_list = &sge;
+	send_wr.num_sge = 1;
+	send_wr.opcode = IB_WR_SEND;
+	send_wr.send_flags = IB_SEND_SIGNALED;
+
+	ret = ib_post_send(ch->qp, first_wr, &bad_wr);
+	if (ret < 0) {
+		pr_err("%s: sending cmd response failed for tag %llu (%d)\n",
+			__func__, ioctx->cmd.tag, ret);
+		goto out;
 	}
+
+	return;
+
+out:
+	atomic_add(1 + ioctx->n_rdma, &ch->sq_wr_avail);
+	atomic_dec(&ch->req_lim);
+	srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
+	target_put_sess_cmd(&ioctx->cmd);
 }
 
 static int srpt_queue_data_in(struct se_cmd *cmd)
@@ -2599,10 +2382,6 @@ static void srpt_queue_tm_rsp(struct se_cmd *cmd)
 
 static void srpt_aborted_task(struct se_cmd *cmd)
 {
-	struct srpt_send_ioctx *ioctx = container_of(cmd,
-				struct srpt_send_ioctx, cmd);
-
-	srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
 }
 
 static int srpt_queue_status(struct se_cmd *cmd)
@@ -2903,12 +2682,10 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 	unsigned long flags;
 
 	WARN_ON(ioctx->state != SRPT_STATE_DONE);
-	WARN_ON(ioctx->mapped_sg_count != 0);
 
-	if (ioctx->n_rbuf > 1) {
-		kfree(ioctx->rbufs);
-		ioctx->rbufs = NULL;
-		ioctx->n_rbuf = 0;
+	if (ioctx->n_rw_ctx) {
+		srpt_free_rw_ctxs(ch, ioctx);
+		ioctx->n_rw_ctx = 0;
 	}
 
 	spin_lock_irqsave(&ch->spinlock, flags);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index af9b8b5..fee6bfd 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -42,6 +42,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_sa.h>
 #include <rdma/ib_cm.h>
+#include <rdma/rw.h>
 
 #include <scsi/srp.h>
 
@@ -105,7 +106,6 @@ enum {
 	SRP_LOGIN_RSP_MULTICHAN_MAINTAINED = 0x2,
 
 	SRPT_DEF_SG_TABLESIZE = 128,
-	SRPT_DEF_SG_PER_WQE = 16,
 
 	MIN_SRPT_SQ_SIZE = 16,
 	DEF_SRPT_SQ_SIZE = 4096,
@@ -174,21 +174,17 @@ struct srpt_recv_ioctx {
 	struct srpt_ioctx	ioctx;
 	struct list_head	wait_list;
 };
+	
+struct srpt_rw_ctx {
+	struct rdma_rw_ctx	rw;
+	struct scatterlist	*sg;
+	unsigned int		nents;
+};
 
 /**
  * struct srpt_send_ioctx - SRPT send I/O context.
  * @ioctx:       See above.
  * @ch:          Channel pointer.
- * @free_list:   Node in srpt_rdma_ch.free_list.
- * @n_rbuf:      Number of data buffers in the received SRP command.
- * @rbufs:       Pointer to SRP data buffer array.
- * @single_rbuf: SRP data buffer if the command has only a single buffer.
- * @sg:          Pointer to sg-list associated with this I/O context.
- * @sg_cnt:      SG-list size.
- * @mapped_sg_count: ib_dma_map_sg() return value.
- * @n_rdma_wrs:  Number of elements in the rdma_wrs array.
- * @rdma_wrs:    Array with information about the RDMA mapping.
- * @tag:         Tag of the received SRP information unit.
  * @spinlock:    Protects 'state'.
  * @state:       I/O context state.
  * @cmd:         Target core command data structure.
@@ -197,21 +193,18 @@ struct srpt_recv_ioctx {
 struct srpt_send_ioctx {
 	struct srpt_ioctx	ioctx;
 	struct srpt_rdma_ch	*ch;
-	struct ib_rdma_wr	*rdma_wrs;
+
+	struct srpt_rw_ctx	s_rw_ctx;
+	struct srpt_rw_ctx	*rw_ctxs;
+
 	struct ib_cqe		rdma_cqe;
-	struct srp_direct_buf	*rbufs;
-	struct srp_direct_buf	single_rbuf;
-	struct scatterlist	*sg;
 	struct list_head	free_list;
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
 	struct completion	tx_done;
-	int			sg_cnt;
-	int			mapped_sg_count;
-	u16			n_rdma_wrs;
 	u8			n_rdma;
-	u8			n_rbuf;
+	u8			n_rw_ctx;
 	bool			queue_status_only;
 	u8			sense_data[TRANSPORT_SENSE_BUFFER];
 };
-- 
2.1.4
