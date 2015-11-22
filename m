From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Sun, 22 Nov 2015 18:46:48 +0100
Message-ID: <1448214409-7729-11-git-send-email-hch@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448214409-7729-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While IB supports the notion of returning separate local and remote keys
from a memory registration, the iWarp spec doesn't and neither does any
of our in-tree HCA drivers [1] nor consumers.  Consolidate the in-kernel
API to provide only a single key and make everyones life easier.

[1] the EHCA driver which is in the staging tree on it's way out can
    actually return two values from it's thick firmware interface.
    I doubt they ever were different, though.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c               |  8 +++---
 drivers/infiniband/core/verbs.c                    |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_mem.c             |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  4 +--
 drivers/infiniband/hw/cxgb4/qp.c                   |  2 +-
 drivers/infiniband/hw/mlx4/mr.c                    |  6 ++--
 drivers/infiniband/hw/mlx4/qp.c                    |  2 +-
 drivers/infiniband/hw/mlx5/mr.c                    | 11 +++-----
 drivers/infiniband/hw/mlx5/qp.c                    |  8 +++---
 drivers/infiniband/hw/mthca/mthca_av.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_mr.c             |  8 +++---
 drivers/infiniband/hw/mthca/mthca_provider.c       |  8 +++---
 drivers/infiniband/hw/mthca/mthca_qp.c             |  4 +--
 drivers/infiniband/hw/mthca/mthca_srq.c            |  4 +--
 drivers/infiniband/hw/nes/nes_cm.c                 |  2 +-
 drivers/infiniband/hw/nes/nes_verbs.c              | 33 ++++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        | 13 +++------
 drivers/infiniband/hw/qib/qib_keys.c               |  2 +-
 drivers/infiniband/hw/qib/qib_mr.c                 |  3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  2 +-
 drivers/infiniband/ulp/iser/iser_memory.c          | 17 ++++-------
 drivers/infiniband/ulp/isert/ib_isert.c            | 13 +++------
 drivers/infiniband/ulp/srp/ib_srp.c                | 21 ++++++--------
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  4 +--
 include/rdma/ib_verbs.h                            |  7 ++---
 net/rds/iw.h                                       |  4 +--
 net/rds/iw_rdma.c                                  |  6 ++--
 net/rds/iw_send.c                                  |  3 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |  7 ++---
 net/sunrpc/xprtrdma/physical_ops.c                 |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |  9 +++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  2 +-
 36 files changed, 98 insertions(+), 131 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b0f7872..f10b492 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -998,8 +998,8 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 		goto err_unreg;
 
 	memset(&resp, 0, sizeof resp);
-	resp.lkey      = mr->lkey;
-	resp.rkey      = mr->rkey;
+	resp.lkey      = mr->key;
+	resp.rkey      = mr->key;
 	resp.mr_handle = uobj->id;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
@@ -1108,8 +1108,8 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	}
 
 	memset(&resp, 0, sizeof(resp));
-	resp.lkey      = mr->lkey;
-	resp.rkey      = mr->rkey;
+	resp.lkey      = mr->key;
+	resp.rkey      = mr->key;
 
 	if (copy_to_user((void __user *)(unsigned long)cmd.response,
 			 &resp, sizeof(resp)))
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b31beb1..751a017 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -251,7 +251,7 @@ struct ib_pd *ib_alloc_pd(struct ib_device *device)
 		}
 
 		pd->local_mr = mr;
-		pd->local_dma_lkey = pd->local_mr->lkey;
+		pd->local_dma_lkey = pd->local_mr->key;
 	}
 	return pd;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_mem.c b/drivers/infiniband/hw/cxgb3/iwch_mem.c
index 1d04c87..4a27978 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_mem.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_mem.c
@@ -47,7 +47,7 @@ static int iwch_finish_mem_reg(struct iwch_mr *mhp, u32 stag)
 	mhp->attr.state = 1;
 	mhp->attr.stag = stag;
 	mmid = stag >> 8;
-	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
+	mhp->ibmr.key = stag;
 	PDBG("%s mmid 0x%x mhp %p\n", __func__, mmid, mhp);
 	return insert_handle(mhp->rhp, &mhp->rhp->mmidr, mhp, mmid);
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 097eb93..02b80b1 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -754,7 +754,7 @@ static struct ib_mr *iwch_alloc_mr(struct ib_pd *pd,
 	mhp->attr.stag = stag;
 	mhp->attr.state = 1;
 	mmid = (stag) >> 8;
-	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
+	mhp->ibmr.key = stag;
 	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid))
 		goto err3;
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index d939980..87be4be 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -156,7 +156,7 @@ static int build_memreg(union t3_wr *wqe, struct ib_reg_wr *wr,
 	if (mhp->npages > T3_MAX_FASTREG_DEPTH)
 		return -EINVAL;
 	*wr_cnt = 1;
-	wqe->fastreg.stag = cpu_to_be32(wr->key);
+	wqe->fastreg.stag = cpu_to_be32(wr->mr->key);
 	wqe->fastreg.len = cpu_to_be32(mhp->ibmr.length);
 	wqe->fastreg.va_base_hi = cpu_to_be32(mhp->ibmr.iova >> 32);
 	wqe->fastreg.va_base_lo_fbo =
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 1eb833a..f1e3973 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -364,7 +364,7 @@ static int finish_mem_reg(struct c4iw_mr *mhp, u32 stag)
 	mhp->attr.state = 1;
 	mhp->attr.stag = stag;
 	mmid = stag >> 8;
-	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
+	mhp->ibmr.key = stag;
 	PDBG("%s mmid 0x%x mhp %p\n", __func__, mmid, mhp);
 	return insert_handle(mhp->rhp, &mhp->rhp->mmidr, mhp, mmid);
 }
@@ -651,7 +651,7 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 	mhp->attr.stag = stag;
 	mhp->attr.state = 1;
 	mmid = (stag) >> 8;
-	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
+	mhp->ibmr.key = stag;
 	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid)) {
 		ret = -ENOMEM;
 		goto err3;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e99345e..cb8031b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -624,7 +624,7 @@ static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
 	wqe->fr.mem_perms = c4iw_ib_to_tpt_access(wr->access);
 	wqe->fr.len_hi = 0;
 	wqe->fr.len_lo = cpu_to_be32(mhp->ibmr.length);
-	wqe->fr.stag = cpu_to_be32(wr->key);
+	wqe->fr.stag = cpu_to_be32(wr->mr->key);
 	wqe->fr.va_hi = cpu_to_be32(mhp->ibmr.iova >> 32);
 	wqe->fr.va_lo_fbo = cpu_to_be32(mhp->ibmr.iova &
 					0xffffffff);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 242b94e..a544a94 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -72,7 +72,7 @@ struct ib_mr *mlx4_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	if (err)
 		goto err_mr;
 
-	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+	mr->ibmr.key = mr->mmr.key;
 	mr->umem = NULL;
 
 	return &mr->ibmr;
@@ -169,7 +169,7 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err)
 		goto err_mr;
 
-	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+	mr->ibmr.key = mr->mmr.key;
 
 	return &mr->ibmr;
 
@@ -407,7 +407,7 @@ struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
 	if (err)
 		goto err_free_pl;
 
-	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+	mr->ibmr.key = mr->mmr.key;
 	mr->umem = NULL;
 
 	return &mr->ibmr;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9781ac3..afba1a9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2510,7 +2510,7 @@ static void set_reg_seg(struct mlx4_wqe_fmr_seg *fseg,
 	struct mlx4_ib_mr *mr = to_mmr(wr->mr);
 
 	fseg->flags		= convert_access(wr->access);
-	fseg->mem_key		= cpu_to_be32(wr->key);
+	fseg->mem_key		= cpu_to_be32(wr->mr->key);
 	fseg->buf_list		= cpu_to_be64(mr->page_map);
 	fseg->start_addr	= cpu_to_be64(mr->ibmr.iova);
 	fseg->reg_len		= cpu_to_be64(mr->ibmr.length);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ec8993a..c86cab1 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -651,8 +651,7 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 		goto err_in;
 
 	kfree(in);
-	mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.rkey = mr->mmr.key;
+	mr->ibmr.key = mr->mmr.key;
 	mr->umem = NULL;
 
 	return &mr->ibmr;
@@ -1084,8 +1083,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->umem = umem;
 	mr->npages = npages;
 	atomic_add(npages, &dev->mdev->priv.reg_pages);
-	mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.rkey = mr->mmr.key;
+	mr->ibmr.key = mr->mmr.key;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (umem->odp_data) {
@@ -1355,8 +1353,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	if (err)
 		goto err_destroy_psv;
 
-	mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.rkey = mr->mmr.key;
+	mr->ibmr.key = mr->mmr.key;
 	mr->umem = NULL;
 	kfree(in);
 
@@ -1407,7 +1404,7 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 		if (!mmr->sig->sig_err_exists)
 			goto done;
 
-		if (ibmr->lkey == mmr->sig->err_item.key)
+		if (ibmr->key == mmr->sig->err_item.key)
 			memcpy(&mr_status->sig_err, &mmr->sig->err_item,
 			       sizeof(mr_status->sig_err));
 		else {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 307bdbc..ba39045 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2327,7 +2327,7 @@ static void set_sig_mkey_segment(struct mlx5_mkey_seg *seg,
 				 u32 length, u32 pdn)
 {
 	struct ib_mr *sig_mr = wr->sig_mr;
-	u32 sig_key = sig_mr->rkey;
+	u32 sig_key = sig_mr->key;
 	u8 sigerr = to_mmr(sig_mr)->sig->sigerr_count & 1;
 
 	memset(seg, 0, sizeof(*seg));
@@ -2449,7 +2449,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	if (unlikely((*seg == qp->sq.qend)))
 		*seg = mlx5_get_send_wqe(qp, 0);
 
-	set_reg_mkey_seg(*seg, mr, wr->key, wr->access);
+	set_reg_mkey_seg(*seg, mr, wr->mr->key, wr->access);
 	*seg += sizeof(struct mlx5_mkey_seg);
 	*size += sizeof(struct mlx5_mkey_seg) / 16;
 	if (unlikely((*seg == qp->sq.qend)))
@@ -2670,7 +2670,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			case IB_WR_REG_MR:
 				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 				qp->sq.wr_data[idx] = IB_WR_REG_MR;
-				ctrl->imm = cpu_to_be32(reg_wr(wr)->key);
+				ctrl->imm = cpu_to_be32(reg_wr(wr)->mr->key);
 				err = set_reg_wr(qp, reg_wr(wr), &seg, &size);
 				if (err) {
 					*bad_wr = wr;
@@ -2683,7 +2683,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				qp->sq.wr_data[idx] = IB_WR_REG_SIG_MR;
 				mr = to_mmr(sig_handover_wr(wr)->sig_mr);
 
-				ctrl->imm = cpu_to_be32(mr->ibmr.rkey);
+				ctrl->imm = cpu_to_be32(mr->ibmr.key);
 				err = set_sig_umr_wr(wr, qp, &seg, &size);
 				if (err) {
 					mlx5_ib_warn(dev, "\n");
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index bcac294..046a442 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -194,7 +194,7 @@ on_hca_fail:
 		av = ah->av;
 	}
 
-	ah->key = pd->ntmr.ibmr.lkey;
+	ah->key = pd->ntmr.ibmr.key;
 
 	memset(av, 0, MTHCA_AV_SIZE);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index a6531ff..01dc054 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -836,7 +836,7 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
 	cq_context->error_eqn       = cpu_to_be32(dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn);
 	cq_context->comp_eqn        = cpu_to_be32(dev->eq_table.eq[MTHCA_EQ_COMP].eqn);
 	cq_context->pd              = cpu_to_be32(pdn);
-	cq_context->lkey            = cpu_to_be32(cq->buf.mr.ibmr.lkey);
+	cq_context->lkey            = cpu_to_be32(cq->buf.mr.ibmr.key);
 	cq_context->cqn             = cpu_to_be32(cq->cqn);
 
 	if (mthca_is_memfree(dev)) {
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 6902017..83a25e8 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -540,7 +540,7 @@ static int mthca_create_eq(struct mthca_dev *dev,
 		eq_context->tavor_pd         = cpu_to_be32(dev->driver_pd.pd_num);
 	}
 	eq_context->intr            = intr;
-	eq_context->lkey            = cpu_to_be32(eq->mr.ibmr.lkey);
+	eq_context->lkey            = cpu_to_be32(eq->mr.ibmr.key);
 
 	err = mthca_SW2HW_EQ(dev, mailbox, eq->eqn);
 	if (err) {
diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index ed9a989..9bd8274 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -441,7 +441,7 @@ int mthca_mr_alloc(struct mthca_dev *dev, u32 pd, int buffer_size_shift,
 	if (key == -1)
 		return -ENOMEM;
 	key = adjust_key(dev, key);
-	mr->ibmr.rkey = mr->ibmr.lkey = hw_index_to_key(dev, key);
+	mr->ibmr.key = hw_index_to_key(dev, key);
 
 	if (mthca_is_memfree(dev)) {
 		err = mthca_table_get(dev, dev->mr_table.mpt_table, key);
@@ -478,7 +478,7 @@ int mthca_mr_alloc(struct mthca_dev *dev, u32 pd, int buffer_size_shift,
 				    mr->mtt->first_seg * dev->limits.mtt_seg_size);
 
 	if (0) {
-		mthca_dbg(dev, "Dumping MPT entry %08x:\n", mr->ibmr.lkey);
+		mthca_dbg(dev, "Dumping MPT entry %08x:\n", mr->ibmr.key);
 		for (i = 0; i < sizeof (struct mthca_mpt_entry) / 4; ++i) {
 			if (i % 4 == 0)
 				printk("[%02x] ", i * 4);
@@ -555,12 +555,12 @@ void mthca_free_mr(struct mthca_dev *dev, struct mthca_mr *mr)
 	int err;
 
 	err = mthca_HW2SW_MPT(dev, NULL,
-			      key_to_hw_index(dev, mr->ibmr.lkey) &
+			      key_to_hw_index(dev, mr->ibmr.key) &
 			      (dev->limits.num_mpts - 1));
 	if (err)
 		mthca_warn(dev, "HW2SW_MPT failed (%d)\n", err);
 
-	mthca_free_region(dev, mr->ibmr.lkey);
+	mthca_free_region(dev, mr->ibmr.key);
 	mthca_free_mtt(dev, mr->mtt);
 }
 
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 6d0a1db..13f3fd1 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -460,7 +460,7 @@ static struct ib_srq *mthca_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_free;
 
-		srq->mr.ibmr.lkey = ucmd.lkey;
+		srq->mr.ibmr.key  = ucmd.lkey;
 		srq->db_index     = ucmd.db_index;
 	}
 
@@ -555,7 +555,7 @@ static struct ib_qp *mthca_create_qp(struct ib_pd *pd,
 				return ERR_PTR(err);
 			}
 
-			qp->mr.ibmr.lkey = ucmd.lkey;
+			qp->mr.ibmr.key  = ucmd.lkey;
 			qp->sq.db_index  = ucmd.sq_db_index;
 			qp->rq.db_index  = ucmd.rq_db_index;
 		}
@@ -680,7 +680,7 @@ static struct ib_cq *mthca_create_cq(struct ib_device *ibdev,
 	}
 
 	if (context) {
-		cq->buf.mr.ibmr.lkey = ucmd.lkey;
+		cq->buf.mr.ibmr.key  = ucmd.lkey;
 		cq->set_ci_db_index  = ucmd.set_db_index;
 		cq->arm_db_index     = ucmd.arm_db_index;
 	}
@@ -789,7 +789,7 @@ static int mthca_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *uda
 		ret = mthca_alloc_resize_buf(dev, cq, entries);
 		if (ret)
 			goto out;
-		lkey = cq->resize_buf->buf.mr.ibmr.lkey;
+		lkey = cq->resize_buf->buf.mr.ibmr.key;
 	} else {
 		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
 			ret = -EFAULT;
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 35fe506..23a0a49 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -692,7 +692,7 @@ static int __mthca_modify_qp(struct ib_qp *ibqp,
 	/* leave rdd as 0 */
 	qp_context->pd         = cpu_to_be32(to_mpd(ibqp->pd)->pd_num);
 	/* leave wqe_base as 0 (we always create an MR based at 0 for WQs) */
-	qp_context->wqe_lkey   = cpu_to_be32(qp->mr.ibmr.lkey);
+	qp_context->wqe_lkey   = cpu_to_be32(qp->mr.ibmr.key);
 	qp_context->params1    = cpu_to_be32((MTHCA_ACK_REQ_FREQ << 28) |
 					     (MTHCA_FLIGHT_LIMIT << 24) |
 					     MTHCA_QP_BIT_SWE);
@@ -1535,7 +1535,7 @@ static int build_mlx_header(struct mthca_dev *dev, struct mthca_sqp *sqp,
 					ind * MTHCA_UD_HEADER_SIZE);
 
 	data->byte_count = cpu_to_be32(header_size);
-	data->lkey       = cpu_to_be32(to_mpd(sqp->qp.ibqp.pd)->ntmr.ibmr.lkey);
+	data->lkey       = cpu_to_be32(to_mpd(sqp->qp.ibqp.pd)->ntmr.ibmr.key);
 	data->addr       = cpu_to_be64(sqp->header_dma +
 				       ind * MTHCA_UD_HEADER_SIZE);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_srq.c b/drivers/infiniband/hw/mthca/mthca_srq.c
index d22f970..d25063c 100644
--- a/drivers/infiniband/hw/mthca/mthca_srq.c
+++ b/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -101,7 +101,7 @@ static void mthca_tavor_init_srq_context(struct mthca_dev *dev,
 
 	context->wqe_base_ds = cpu_to_be64(1 << (srq->wqe_shift - 4));
 	context->state_pd    = cpu_to_be32(pd->pd_num);
-	context->lkey        = cpu_to_be32(srq->mr.ibmr.lkey);
+	context->lkey        = cpu_to_be32(srq->mr.ibmr.key);
 
 	if (pd->ibpd.uobject)
 		context->uar =
@@ -126,7 +126,7 @@ static void mthca_arbel_init_srq_context(struct mthca_dev *dev,
 	max = srq->max;
 	logsize = ilog2(max);
 	context->state_logsize_srqn = cpu_to_be32(logsize << 24 | srq->srqn);
-	context->lkey = cpu_to_be32(srq->mr.ibmr.lkey);
+	context->lkey = cpu_to_be32(srq->mr.ibmr.key);
 	context->db_index = cpu_to_be32(srq->db_index);
 	context->logstride_usrpage = cpu_to_be32((srq->wqe_shift - 4) << 29);
 	if (pd->ibpd.uobject)
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index bc37adb..8a1c95b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -3348,7 +3348,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 				    (u64)(unsigned long)(*start_buff));
 		wqe->wqe_words[NES_IWARP_SQ_WQE_LENGTH0_IDX] =
 			cpu_to_le32(buff_len);
-		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = ibmr->lkey;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = ibmr->key;
 		if (nesqp->sq_kmapped) {
 			nesqp->sq_kmapped = 0;
 			kunmap(nesqp->page);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 4e57bf0..f7f1f78 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -363,8 +363,7 @@ static struct ib_mr *nes_alloc_mr(struct ib_pd *ibpd,
 	ret = alloc_fast_reg_mr(nesdev, nespd, stag, max_num_sg);
 
 	if (ret == 0) {
-		nesmr->ibmr.rkey = stag;
-		nesmr->ibmr.lkey = stag;
+		nesmr->ibmr.key = stag;
 		nesmr->mode = IWNES_MEMREG_TYPE_FMEM;
 		ibmr = &nesmr->ibmr;
 	} else {
@@ -2044,8 +2043,7 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd, u64 addr, u64 size,
 			&nesmr->pbls_used, &nesmr->pbl_4k);
 
 	if (ret == 0) {
-		nesmr->ibmr.rkey = stag;
-		nesmr->ibmr.lkey = stag;
+		nesmr->ibmr.key = stag;
 		nesmr->mode = IWNES_MEMREG_TYPE_MEM;
 		ibmr = &nesmr->ibmr;
 	} else {
@@ -2313,8 +2311,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			nes_debug(NES_DBG_MR, "ret=%d\n", ret);
 
 			if (ret == 0) {
-				nesmr->ibmr.rkey = stag;
-				nesmr->ibmr.lkey = stag;
+				nesmr->ibmr.key = stag;
 				nesmr->mode = IWNES_MEMREG_TYPE_MEM;
 				ibmr = &nesmr->ibmr;
 			} else {
@@ -2419,8 +2416,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			} else {
 				list_add_tail(&nespbl->list, &nes_ucontext->cq_reg_mem_list);
 			}
-			nesmr->ibmr.rkey = -1;
-			nesmr->ibmr.lkey = -1;
+			nesmr->ibmr.key = -1;
 			nesmr->mode = req.reg_type;
 			return &nesmr->ibmr;
 	}
@@ -2475,18 +2471,19 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_OPCODE_IDX,
 			NES_CQP_DEALLOCATE_STAG | NES_CQP_STAG_VA_TO |
 			NES_CQP_STAG_DEALLOC_PBLS | NES_CQP_STAG_MR);
-	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, ib_mr->rkey);
+	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX,
+			ib_mr->key);
 
 	atomic_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
-	nes_debug(NES_DBG_MR, "Waiting for deallocate STag 0x%08X completed\n", ib_mr->rkey);
+	nes_debug(NES_DBG_MR, "Waiting for deallocate STag 0x%08X completed\n", ib_mr->key);
 	ret = wait_event_timeout(cqp_request->waitq, (cqp_request->request_done != 0),
 			NES_EVENT_TIMEOUT);
 	nes_debug(NES_DBG_MR, "Deallocate STag 0x%08X completed, wait_event_timeout ret = %u,"
 			" CQP Major:Minor codes = 0x%04X:0x%04X\n",
-			ib_mr->rkey, ret, cqp_request->major_code, cqp_request->minor_code);
+			ib_mr->key, ret, cqp_request->major_code, cqp_request->minor_code);
 
 	major_code = cqp_request->major_code;
 	minor_code = cqp_request->minor_code;
@@ -2495,13 +2492,13 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
 
 	if (!ret) {
 		nes_debug(NES_DBG_MR, "Timeout waiting to destroy STag,"
-				" ib_mr=%p, rkey = 0x%08X\n",
-				ib_mr, ib_mr->rkey);
+				" ib_mr=%p, key = 0x%08X\n",
+				ib_mr, ib_mr->key);
 		return -ETIME;
 	} else if (major_code) {
 		nes_debug(NES_DBG_MR, "Error (0x%04X:0x%04X) while attempting"
-				" to destroy STag, ib_mr=%p, rkey = 0x%08X\n",
-				major_code, minor_code, ib_mr, ib_mr->rkey);
+				" to destroy STag, ib_mr=%p, key = 0x%08X\n",
+				major_code, minor_code, ib_mr, ib_mr->key);
 		return -EIO;
 	}
 
@@ -2525,7 +2522,7 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
 		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
 	}
 	nes_free_resource(nesadapter, nesadapter->allocated_mrs,
-			(ib_mr->rkey & 0x0fffff00) >> 8);
+			(ib_mr->key & 0x0fffff00) >> 8);
 
 	kfree(nesmr);
 
@@ -3217,7 +3214,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 					    NES_IWARP_SQ_FMR_WQE_LENGTH_HIGH_IDX, 0);
 			set_wqe_32bit_value(wqe->wqe_words,
 					    NES_IWARP_SQ_FMR_WQE_MR_STAG_IDX,
-					    reg_wr(ib_wr)->key);
+					    reg_wr(ib_wr)->mr->key);
 
 			if (page_shift == 12) {
 				wqe_misc |= NES_IWARP_SQ_FMR_WQE_PAGE_SIZE_4K;
@@ -3258,7 +3255,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 				  "page_list_len: %u, wqe_misc: %x\n",
 				  (unsigned long long) mr->ibmr.iova,
 				  mr->ibmr.length,
-				  reg_wr(ib_wr)->key,
+				  reg_wr(ib_wr)->mr->key,
 				  (unsigned long long) mr->paddr,
 				  mr->npages,
 				  wqe_misc);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 3cffab7..6d09634 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -744,9 +744,7 @@ static int ocrdma_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
 	if (status)
 		return status;
 
-	mr->ibmr.lkey = mr->hwmr.lkey;
-	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
-		mr->ibmr.rkey = mr->hwmr.lkey;
+	mr->ibmr.key = mr->hwmr.lkey;
 	return 0;
 }
 
@@ -944,9 +942,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, acc);
 	if (status)
 		goto mbx_err;
-	mr->ibmr.lkey = mr->hwmr.lkey;
-	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
-		mr->ibmr.rkey = mr->hwmr.lkey;
+	mr->ibmr.key = mr->hwmr.lkey;
 
 	return &mr->ibmr;
 
@@ -2117,7 +2113,7 @@ static int ocrdma_build_reg(struct ocrdma_qp *qp,
 		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_WR;
 	if (wr->access & IB_ACCESS_REMOTE_READ)
 		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_RD;
-	hdr->lkey = wr->key;
+	hdr->lkey = wr->mr->key;
 	hdr->total_len = mr->ibmr.length;
 
 	fbo = mr->ibmr.iova - mr->pages[0];
@@ -3003,8 +2999,7 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
 	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, 0);
 	if (status)
 		goto mbx_err;
-	mr->ibmr.rkey = mr->hwmr.lkey;
-	mr->ibmr.lkey = mr->hwmr.lkey;
+	mr->ibmr.key = mr->hwmr.lkey;
 	dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] =
 		(unsigned long) mr;
 	return &mr->ibmr;
diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index d725c56..1be4807 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -344,7 +344,7 @@ int qib_reg_mr(struct qib_qp *qp, struct ib_reg_wr *wr)
 	struct qib_pd *pd = to_ipd(qp->ibqp.pd);
 	struct qib_mr *mr = to_imr(wr->mr);
 	struct qib_mregion *mrg;
-	u32 key = wr->key;
+	u32 key = wr->mr->key;
 	unsigned i, n, m;
 	int ret = -EINVAL;
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 5f53304..45beb66 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -154,8 +154,7 @@ static struct qib_mr *alloc_mr(int count, struct ib_pd *pd)
 	rval = qib_alloc_lkey(&mr->mr, 0);
 	if (rval)
 		goto bail_mregion;
-	mr->ibmr.lkey = mr->mr.lkey;
-	mr->ibmr.rkey = mr->mr.lkey;
+	mr->ibmr.key = mr->mr.lkey;
 done:
 	return mr;
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 740170c..75251b3 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -615,7 +615,7 @@ struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_free;
 	}
 
-	mr->ibmr.lkey = mr->ibmr.rkey = 0;
+	mr->ibmr.key = 0;
 	return &mr->ibmr;
 
 err_free:
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 81ad5e9..fb4ca76 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -250,7 +250,7 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	struct scatterlist *sg = mem->sg;
 
 	reg->sge.lkey = device->pd->local_dma_lkey;
-	reg->rkey = device->mr->rkey;
+	reg->rkey = device->mr->key;
 	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
 	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
 
@@ -415,16 +415,13 @@ iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 static void
 iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 {
-	u32 rkey;
-
 	inv_wr->opcode = IB_WR_LOCAL_INV;
 	inv_wr->wr_id = ISER_FASTREG_LI_WRID;
-	inv_wr->ex.invalidate_rkey = mr->rkey;
+	inv_wr->ex.invalidate_rkey = mr->key;
 	inv_wr->send_flags = 0;
 	inv_wr->num_sge = 0;
 
-	rkey = ib_inc_rkey(mr->rkey);
-	ib_update_fast_reg_key(mr, rkey);
+	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->key));
 }
 
 static int
@@ -466,8 +463,8 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 			   IB_ACCESS_REMOTE_WRITE;
 	pi_ctx->sig_mr_valid = 0;
 
-	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
-	sig_reg->rkey = pi_ctx->sig_mr->rkey;
+	sig_reg->sge.lkey = pi_ctx->sig_mr->key;
+	sig_reg->rkey = pi_ctx->sig_mr->key;
 	sig_reg->sge.addr = 0;
 	sig_reg->sge.length = scsi_transfer_length(iser_task->sc);
 
@@ -504,15 +501,13 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	wr->wr.send_flags = 0;
 	wr->wr.num_sge = 0;
 	wr->mr = mr;
-	wr->key = mr->rkey;
 	wr->access = IB_ACCESS_LOCAL_WRITE  |
 		     IB_ACCESS_REMOTE_WRITE |
 		     IB_ACCESS_REMOTE_READ;
 
 	rsc->mr_valid = 0;
 
-	reg->sge.lkey = mr->lkey;
-	reg->rkey = mr->rkey;
+	reg->sge.lkey = mr->key;
 	reg->sge.addr = mr->iova;
 	reg->sge.length = mr->length;
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8d9a167..d38a1e7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2489,16 +2489,12 @@ unmap_cmd:
 static inline void
 isert_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 {
-	u32 rkey;
-
 	memset(inv_wr, 0, sizeof(*inv_wr));
 	inv_wr->wr_id = ISER_FASTREG_LI_WRID;
 	inv_wr->opcode = IB_WR_LOCAL_INV;
-	inv_wr->ex.invalidate_rkey = mr->rkey;
+	inv_wr->ex.invalidate_rkey = mr->key;
 
-	/* Bump the key */
-	rkey = ib_inc_rkey(mr->rkey);
-	ib_update_fast_reg_key(mr, rkey);
+	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->key));
 }
 
 static int
@@ -2552,7 +2548,6 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	reg_wr.wr.send_flags = 0;
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = mr;
-	reg_wr.key = mr->lkey;
 	reg_wr.access = IB_ACCESS_LOCAL_WRITE;
 
 	if (!wr)
@@ -2567,7 +2562,7 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	}
 	fr_desc->ind &= ~ind;
 
-	sge->lkey = mr->lkey;
+	sge->lkey = mr->key;
 	sge->addr = mr->iova;
 	sge->length = mr->length;
 
@@ -2680,7 +2675,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	}
 	fr_desc->ind &= ~ISERT_SIG_KEY_VALID;
 
-	rdma_wr->ib_sg[SIG].lkey = pi_ctx->sig_mr->lkey;
+	rdma_wr->ib_sg[SIG].lkey = pi_ctx->sig_mr->key;
 	rdma_wr->ib_sg[SIG].addr = 0;
 	rdma_wr->ib_sg[SIG].length = se_cmd->data_length;
 	if (se_cmd->prot_op != TARGET_PROT_DIN_STRIP &&
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8521c4a..6a8ef10 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1070,11 +1070,11 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		struct srp_fr_desc **pfr;
 
 		for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++) {
-			res = srp_inv_rkey(ch, (*pfr)->mr->rkey);
+			res = srp_inv_rkey(ch, (*pfr)->mr->key);
 			if (res < 0) {
 				shost_printk(KERN_ERR, target->scsi_host, PFX
 				  "Queueing INV WR for rkey %#x failed (%d)\n",
-				  (*pfr)->mr->rkey, res);
+				  (*pfr)->mr->key, res);
 				queue_work(system_long_wq,
 					   &target->tl_err_work);
 			}
@@ -1286,7 +1286,7 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
 
 	if (state->npages == 1 && target->global_mr) {
 		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     target->global_mr->rkey);
+			     target->global_mr->key);
 		goto reset_state;
 	}
 
@@ -1316,7 +1316,6 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	struct ib_send_wr *bad_wr;
 	struct ib_reg_wr wr;
 	struct srp_fr_desc *desc;
-	u32 rkey;
 	int n, err;
 
 	if (state->fr.next >= state->fr.end)
@@ -1330,7 +1329,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	if (state->sg_nents == 1 && target->global_mr) {
 		srp_map_desc(state, sg_dma_address(state->sg),
 			     sg_dma_len(state->sg),
-			     target->global_mr->rkey);
+			     target->global_mr->key);
 		return 1;
 	}
 
@@ -1338,8 +1337,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	if (!desc)
 		return -ENOMEM;
 
-	rkey = ib_inc_rkey(desc->mr->rkey);
-	ib_update_fast_reg_key(desc->mr, rkey);
+	ib_update_fast_reg_key(desc->mr, ib_inc_rkey(desc->mr->key));
 
 	n = ib_map_mr_sg(desc->mr, state->sg, state->sg_nents,
 			 dev->mr_page_size);
@@ -1352,7 +1350,6 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	wr.wr.num_sge = 0;
 	wr.wr.send_flags = 0;
 	wr.mr = desc->mr;
-	wr.key = desc->mr->rkey;
 	wr.access = (IB_ACCESS_LOCAL_WRITE |
 		     IB_ACCESS_REMOTE_READ |
 		     IB_ACCESS_REMOTE_WRITE);
@@ -1361,7 +1358,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	state->nmdesc++;
 
 	srp_map_desc(state, desc->mr->iova,
-		     desc->mr->length, desc->mr->rkey);
+		     desc->mr->length, desc->mr->key);
 
 	err = ib_post_send(ch->qp, &wr.wr, &bad_wr);
 	if (unlikely(err))
@@ -1480,7 +1477,7 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 	for_each_sg(scat, sg, count, i) {
 		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
 			     ib_sg_dma_len(dev->dev, sg),
-			     target->global_mr->rkey);
+			     target->global_mr->key);
 	}
 
 	req->nmdesc = state->nmdesc;
@@ -1589,7 +1586,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
 		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
-		buf->key = cpu_to_be32(target->global_mr->rkey);
+		buf->key = cpu_to_be32(target->global_mr->key);
 		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
 
 		req->nmdesc = 0;
@@ -1655,7 +1652,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 			return ret;
 		req->nmdesc++;
 	} else {
-		idb_rkey = target->global_mr->rkey;
+		idb_rkey = target->global_mr->key;
 	}
 
 	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 2607503..cc89770 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -161,7 +161,7 @@ kiblnd_post_rx(kib_rx_t *rx, int credit)
 	mr = kiblnd_find_dma_mr(conn->ibc_hdev, rx->rx_msgaddr, IBLND_MSG_SIZE);
 	LASSERT(mr != NULL);
 
-	rx->rx_sge.lkey   = mr->lkey;
+	rx->rx_sge.lkey   = mr->key;
 	rx->rx_sge.addr   = rx->rx_msgaddr;
 	rx->rx_sge.length = IBLND_MSG_SIZE;
 
@@ -645,7 +645,7 @@ static int kiblnd_map_tx(lnet_ni_t *ni, kib_tx_t *tx, kib_rdma_desc_t *rd,
 	mr = kiblnd_find_rd_dma_mr(hdev, rd);
 	if (mr != NULL) {
 		/* found pre-mapping MR */
-		rd->rd_key = (rd != tx->tx_rd) ? mr->rkey : mr->lkey;
+		rd->rd_key = mr->key;
 		return 0;
 	}
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 81e047e..51dd3a7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1089,7 +1089,6 @@ static inline struct ib_ud_wr *ud_wr(struct ib_send_wr *wr)
 struct ib_reg_wr {
 	struct ib_send_wr	wr;
 	struct ib_mr		*mr;
-	u32			key;
 	int			access;
 };
 
@@ -1273,8 +1272,7 @@ struct ib_mr {
 	struct ib_device  *device;
 	struct ib_pd	  *pd;
 	struct ib_uobject *uobject;
-	u32		   lkey;
-	u32		   rkey;
+	u32		   key;
 	u64		   iova;
 	u32		   length;
 	unsigned int	   page_size;
@@ -2799,8 +2797,7 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
  */
 static inline void ib_update_fast_reg_key(struct ib_mr *mr, u8 newkey)
 {
-	mr->lkey = (mr->lkey & 0xffffff00) | newkey;
-	mr->rkey = (mr->rkey & 0xffffff00) | newkey;
+	mr->key = (mr->key & 0xffffff00) | newkey;
 }
 
 /**
diff --git a/net/rds/iw.h b/net/rds/iw.h
index 5af01d1..e9d4d8c 100644
--- a/net/rds/iw.h
+++ b/net/rds/iw.h
@@ -63,7 +63,6 @@ struct rds_iw_mapping {
 	spinlock_t		m_lock;	/* protect the mapping struct */
 	struct list_head	m_list;
 	struct rds_iw_mr	*m_mr;
-	uint32_t		m_rkey;
 	struct rds_iw_scatterlist m_sg;
 };
 
@@ -267,7 +266,8 @@ static inline void rds_iw_dma_sync_sg_for_device(struct ib_device *dev,
 
 static inline u32 rds_iw_local_dma_lkey(struct rds_iw_connection *ic)
 {
-	return ic->i_dma_local_lkey ? ic->i_cm_id->device->local_dma_lkey : ic->i_mr->lkey;
+	return ic->i_dma_local_lkey ?
+		ic->i_cm_id->device->local_dma_lkey : ic->i_mr->key;
 }
 
 /* ib.c */
diff --git a/net/rds/iw_rdma.c b/net/rds/iw_rdma.c
index b09a40c..3e683a9 100644
--- a/net/rds/iw_rdma.c
+++ b/net/rds/iw_rdma.c
@@ -603,7 +603,7 @@ void *rds_iw_get_mr(struct scatterlist *sg, unsigned long nents,
 
 	ret = rds_iw_map_reg(rds_iwdev->mr_pool, ibmr, sg, nents);
 	if (ret == 0)
-		*key_ret = ibmr->mr->rkey;
+		*key_ret = ibmr->mr->key;
 	else
 		printk(KERN_WARNING "RDS/IW: failed to map mr (errno=%d)\n", ret);
 
@@ -675,7 +675,6 @@ static int rds_iw_rdma_reg_mr(struct rds_iw_mapping *mapping)
 	reg_wr.wr.wr_id = RDS_IW_REG_WR_ID;
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = ibmr->mr;
-	reg_wr.key = mapping->m_rkey;
 	reg_wr.access = IB_ACCESS_LOCAL_WRITE |
 			IB_ACCESS_REMOTE_READ |
 			IB_ACCESS_REMOTE_WRITE;
@@ -687,7 +686,6 @@ static int rds_iw_rdma_reg_mr(struct rds_iw_mapping *mapping)
 	 * counter, which should guarantee uniqueness.
 	 */
 	ib_update_fast_reg_key(ibmr->mr, ibmr->remap_count++);
-	mapping->m_rkey = ibmr->mr->rkey;
 
 	failed_wr = &reg_wr.wr;
 	ret = ib_post_send(ibmr->cm_id->qp, &reg_wr.wr, &failed_wr);
@@ -709,7 +707,7 @@ static int rds_iw_rdma_fastreg_inv(struct rds_iw_mr *ibmr)
 	memset(&s_wr, 0, sizeof(s_wr));
 	s_wr.wr_id = RDS_IW_LOCAL_INV_WR_ID;
 	s_wr.opcode = IB_WR_LOCAL_INV;
-	s_wr.ex.invalidate_rkey = ibmr->mr->rkey;
+	s_wr.ex.invalidate_rkey = ibmr->mr->key;
 	s_wr.send_flags = IB_SEND_SIGNALED;
 
 	failed_wr = &s_wr;
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index e20bd50..acfe38a 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -775,7 +775,6 @@ static int rds_iw_build_send_reg(struct rds_iw_send_work *send,
 	send->s_reg_wr.wr.wr_id = 0;
 	send->s_reg_wr.wr.num_sge = 0;
 	send->s_reg_wr.mr = send->s_mr;
-	send->s_reg_wr.key = send->s_mr->rkey;
 	send->s_reg_wr.access = IB_ACCESS_REMOTE_WRITE;
 
 	ib_update_fast_reg_key(send->s_mr, send->s_remap_count++);
@@ -917,7 +916,7 @@ int rds_iw_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 			send->s_rdma_wr.wr.num_sge = 1;
 			send->s_sge[0].addr = conn->c_xmit_rm->m_rs->rs_user_addr;
 			send->s_sge[0].length = conn->c_xmit_rm->m_rs->rs_user_bytes;
-			send->s_sge[0].lkey = ic->i_sends[fr_pos].s_mr->lkey;
+			send->s_sge[0].lkey = ic->i_sends[fr_pos].s_mr->key;
 		}
 
 		rdsdebug("send %p wr %p num_sge %u next %p\n", send,
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index ae2a241..0b1b89b 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -377,7 +377,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	dprintk("RPC:       %s: Using frmr %p to map %u segments (%u bytes)\n",
 		__func__, mw, frmr->sg_nents, mr->length);
 
-	key = (u8)(mr->rkey & 0x000000FF);
+	key = (u8)(mr->key & 0x000000FF);
 	ib_update_fast_reg_key(mr, ++key);
 
 	reg_wr.wr.next = NULL;
@@ -386,7 +386,6 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	reg_wr.wr.num_sge = 0;
 	reg_wr.wr.send_flags = 0;
 	reg_wr.mr = mr;
-	reg_wr.key = mr->rkey;
 	reg_wr.access = writing ?
 			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
 			IB_ACCESS_REMOTE_READ;
@@ -398,7 +397,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 
 	seg1->mr_dir = direction;
 	seg1->rl_mw = mw;
-	seg1->mr_rkey = mr->rkey;
+	seg1->mr_rkey = mr->key;
 	seg1->mr_base = mr->iova;
 	seg1->mr_nsegs = frmr->sg_nents;
 	seg1->mr_len = mr->length;
@@ -433,7 +432,7 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
 	memset(&invalidate_wr, 0, sizeof(invalidate_wr));
 	invalidate_wr.wr_id = (unsigned long)(void *)mw;
 	invalidate_wr.opcode = IB_WR_LOCAL_INV;
-	invalidate_wr.ex.invalidate_rkey = frmr->fr_mr->rkey;
+	invalidate_wr.ex.invalidate_rkey = frmr->fr_mr->key;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
 	ib_dma_unmap_sg(ia->ri_device, frmr->sg, frmr->sg_nents, seg1->mr_dir);
diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
index 617b76f..856730b 100644
--- a/net/sunrpc/xprtrdma/physical_ops.c
+++ b/net/sunrpc/xprtrdma/physical_ops.c
@@ -66,7 +66,7 @@ physical_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 
 	rpcrdma_map_one(ia->ri_device, seg, rpcrdma_data_dir(writing));
-	seg->mr_rkey = ia->ri_dma_mr->rkey;
+	seg->mr_rkey = ia->ri_dma_mr->key;
 	seg->mr_base = seg->mr_dma;
 	seg->mr_nsegs = 1;
 	return 1;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index ff4f01e..b1d7528 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -289,11 +289,11 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	}
 
 	/* Bump the key */
-	key = (u8)(frmr->mr->lkey & 0x000000FF);
+	key = (u8)(frmr->mr->key & 0x000000FF);
 	ib_update_fast_reg_key(frmr->mr, ++key);
 
 	ctxt->sge[0].addr = frmr->mr->iova;
-	ctxt->sge[0].lkey = frmr->mr->lkey;
+	ctxt->sge[0].lkey = frmr->mr->key;
 	ctxt->sge[0].length = frmr->mr->length;
 	ctxt->count = 1;
 	ctxt->read_hdr = head;
@@ -304,7 +304,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	reg_wr.wr.send_flags = IB_SEND_SIGNALED;
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = frmr->mr;
-	reg_wr.key = frmr->mr->lkey;
 	reg_wr.access = frmr->access_flags;
 	reg_wr.wr.next = &read_wr.wr;
 
@@ -318,7 +317,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	if (xprt->sc_dev_caps & SVCRDMA_DEVCAP_READ_W_INV) {
 		read_wr.wr.opcode = IB_WR_RDMA_READ_WITH_INV;
 		read_wr.wr.wr_id = (unsigned long)ctxt;
-		read_wr.wr.ex.invalidate_rkey = ctxt->frmr->mr->lkey;
+		read_wr.wr.ex.invalidate_rkey = ctxt->frmr->mr->key;
 	} else {
 		read_wr.wr.opcode = IB_WR_RDMA_READ;
 		read_wr.wr.next = &inv_wr;
@@ -327,7 +326,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 		inv_wr.wr_id = (unsigned long)ctxt;
 		inv_wr.opcode = IB_WR_LOCAL_INV;
 		inv_wr.send_flags = IB_SEND_SIGNALED | IB_SEND_FENCE;
-		inv_wr.ex.invalidate_rkey = frmr->mr->lkey;
+		inv_wr.ex.invalidate_rkey = frmr->mr->key;
 	}
 	ctxt->wr_op = read_wr.wr.opcode;
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 9f3eb89..779c22d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1045,7 +1045,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 				ret);
 			goto errout;
 		}
-		newxprt->sc_dma_lkey = newxprt->sc_phys_mr->lkey;
+		newxprt->sc_dma_lkey = newxprt->sc_phys_mr->key;
 	} else
 		newxprt->sc_dma_lkey = dev->local_dma_lkey;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
