From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/8] ib_umem: With the new ib_umem_get_attrs, simplify ib_umem_get
Date: Fri, 16 Sep 2016 20:31:14 +0200
Message-ID: <1ed37efb20798db49b5d6789a0e2fb77b83848b1.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, Hans-C
List-Id: linux-rdma@vger.kernel.org

Instead of having most drivers provide a specialized
and weakly typed "boolean" argument
dmasync = 0 argument which are only set to nonzero 3 places,
instead let these special use cases use the
more generic ib_umem_get_attrs which gives access to
the full range of dma attributes and also dma direction,
and eliminate the dmasync parameter from the ib_umem_get call,

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/umem.c               |  8 ++------
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c            |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  2 +-
 drivers/infiniband/hw/mlx4/cq.c              |  4 ++--
 drivers/infiniband/hw/mlx4/doorbell.c        |  2 +-
 drivers/infiniband/hw/mlx4/mr.c              |  5 ++---
 drivers/infiniband/hw/mlx4/qp.c              |  2 +-
 drivers/infiniband/hw/mlx4/srq.c             |  2 +-
 drivers/infiniband/hw/mlx5/cq.c              | 12 +++++++-----
 drivers/infiniband/hw/mlx5/doorbell.c        |  2 +-
 drivers/infiniband/hw/mlx5/mr.c              |  2 +-
 drivers/infiniband/hw/mlx5/qp.c              |  4 ++--
 drivers/infiniband/hw/mlx5/srq.c             |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |  8 ++++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
 drivers/infiniband/sw/rdmavt/mr.c            |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c           |  2 +-
 include/rdma/ib_umem.h                       |  4 ++--
 20 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 699a0f7..938c940 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -77,15 +77,11 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
- * @dmasync: flush in-flight DMA when the memory region is written
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync)
+			    size_t size, int access)
 {
-	unsigned long dma_attrs = 0;
-	if (dmasync)
-		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
-	return ib_umem_get_attrs(context, addr, size, access, DMA_BIDIRECTIONAL, dma_attrs);
+	return ib_umem_get_attrs(context, addr, size, access, DMA_BIDIRECTIONAL, 0);
 }
 EXPORT_SYMBOL(ib_umem_get);
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 3edb806..4225479 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -576,7 +576,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mhp->rhp = rhp;
 
-	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc);
 	if (IS_ERR(mhp->umem)) {
 		err = PTR_ERR(mhp->umem);
 		kfree(mhp);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 0b91b0f..7a30b55 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -509,7 +509,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mhp->rhp = rhp;
 
-	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc);
 	if (IS_ERR(mhp->umem)) {
 		err = PTR_ERR(mhp->umem);
 		kfree_skb(mhp->dereg_skb);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 2360338..3cf1c23 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1703,7 +1703,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 
 	if (length > I40IW_MAX_MR_SIZE)
 		return ERR_PTR(-EINVAL);
-	region = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	region = ib_umem_get(pd->uobject->context, start, length, acc);
 	if (IS_ERR(region))
 		return (struct ib_mr *)region;
 
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index d6fc8a6..8c3ef00 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -141,8 +141,8 @@ static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_ucontext *cont
 	int err;
 	int cqe_size = dev->dev->caps.cqe_size;
 
-	*umem = ib_umem_get(context, buf_addr, cqe * cqe_size,
-			    IB_ACCESS_LOCAL_WRITE, 1);
+	*umem = ib_umem_get_attrs(context, buf_addr, cqe * cqe_size,
+			IB_ACCESS_LOCAL_WRITE, DMA_BIDIRECTIONAL, DMA_ATTR_WRITE_BARRIER);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
 
diff --git a/drivers/infiniband/hw/mlx4/doorbell.c b/drivers/infiniband/hw/mlx4/doorbell.c
index c517409..f87aa5f 100644
--- a/drivers/infiniband/hw/mlx4/doorbell.c
+++ b/drivers/infiniband/hw/mlx4/doorbell.c
@@ -62,7 +62,7 @@ int mlx4_ib_db_map_user(struct mlx4_ib_ucontext *context, unsigned long virt,
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
 	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0, 0);
+				      PAGE_SIZE, 0);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 5d73989..31ee0f7 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -148,7 +148,7 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	/* Force registering the memory as writable. */
 	/* Used for memory re-registeration. HCA protects the access */
 	mr->umem = ib_umem_get(pd->uobject->context, start, length,
-			       access_flags | IB_ACCESS_LOCAL_WRITE, 0);
+			       access_flags | IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
@@ -230,8 +230,7 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 		ib_umem_release(mmr->umem);
 		mmr->umem = ib_umem_get(mr->uobject->context, start, length,
 					mr_access_flags |
-					IB_ACCESS_LOCAL_WRITE,
-					0);
+					IB_ACCESS_LOCAL_WRITE);
 		if (IS_ERR(mmr->umem)) {
 			err = PTR_ERR(mmr->umem);
 			/* Prevent mlx4_ib_dereg_mr from free'ing invalid pointer */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 768085f..363b1cb 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -742,7 +742,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 
 		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0, 0);
+				       qp->buf_size, 0);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 0597f3e..31c297b 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -115,7 +115,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		}
 
 		srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-					buf_size, 0, 0);
+					buf_size, 0);
 		if (IS_ERR(srq->umem)) {
 			err = PTR_ERR(srq->umem);
 			goto err_srq;
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 35a9f71..c505f0b 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -776,9 +776,11 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
 	*cqe_size = ucmd.cqe_size;
 
-	cq->buf.umem = ib_umem_get(context, ucmd.buf_addr,
-				   entries * ucmd.cqe_size,
-				   IB_ACCESS_LOCAL_WRITE, 1);
+	cq->buf.umem = ib_umem_get_attrs(context, ucmd.buf_addr,
+					 entries * ucmd.cqe_size,
+					 IB_ACCESS_LOCAL_WRITE,
+					 DMA_BIDIRECTIONAL,
+					 DMA_ATTR_WRITE_BARRIER);
 	if (IS_ERR(cq->buf.umem)) {
 		err = PTR_ERR(cq->buf.umem);
 		return err;
@@ -1137,8 +1139,8 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	if (ucmd.reserved0 || ucmd.reserved1)
 		return -EINVAL;
 
-	umem = ib_umem_get(context, ucmd.buf_addr, entries * ucmd.cqe_size,
-			   IB_ACCESS_LOCAL_WRITE, 1);
+	umem = ib_umem_get_attrs(context, ucmd.buf_addr, entries * ucmd.cqe_size,
+			IB_ACCESS_LOCAL_WRITE, DMA_BIDIRECTIONAL, DMA_ATTR_WRITE_BARRIER);
 	if (IS_ERR(umem)) {
 		err = PTR_ERR(umem);
 		return err;
diff --git a/drivers/infiniband/hw/mlx5/doorbell.c b/drivers/infiniband/hw/mlx5/doorbell.c
index a0e4e6d..b9f8158 100644
--- a/drivers/infiniband/hw/mlx5/doorbell.c
+++ b/drivers/infiniband/hw/mlx5/doorbell.c
@@ -64,7 +64,7 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context, unsigned long virt,
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
 	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0, 0);
+				      PAGE_SIZE, 0);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6f7e347..baca6e7 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -822,7 +822,7 @@ static struct ib_umem *mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct ib_umem *umem = ib_umem_get(pd->uobject->context, start, length,
-					   access_flags, 0);
+					   access_flags);
 	if (IS_ERR(umem)) {
 		mlx5_ib_err(dev, "umem get failed (%ld)\n", PTR_ERR(umem));
 		return (void *)umem;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f3c943f..3a48d9d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -632,7 +632,7 @@ static int mlx5_ib_umem_get(struct mlx5_ib_dev *dev,
 {
 	int err;
 
-	*umem = ib_umem_get(pd->uobject->context, addr, size, 0, 0);
+	*umem = ib_umem_get(pd->uobject->context, addr, size, 0);
 	if (IS_ERR(*umem)) {
 		mlx5_ib_dbg(dev, "umem_get failed\n");
 		return PTR_ERR(*umem);
@@ -684,7 +684,7 @@ static int create_user_rq(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	context = to_mucontext(pd->uobject->context);
 	rwq->umem = ib_umem_get(pd->uobject->context, ucmd->buf_addr,
-			       rwq->buf_size, 0, 0);
+			       rwq->buf_size, 0);
 	if (IS_ERR(rwq->umem)) {
 		mlx5_ib_dbg(dev, "umem_get failed\n");
 		err = PTR_ERR(rwq->umem);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index ed6ac52..f2f614c 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -112,7 +112,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
 	srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr, buf_size,
-				0, 0);
+				0);
 	if (IS_ERR(srq->umem)) {
 		mlx5_ib_dbg(dev, "failed umem get, size %d\n", buf_size);
 		err = PTR_ERR(srq->umem);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index da2335f..86c60dc 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -910,6 +910,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int i, k, entry;
 	int err = 0;
 	int write_mtt_size;
+	unsigned long dma_attrs = 0;
 
 	if (udata->inlen - sizeof (struct ib_uverbs_cmd_hdr) < sizeof ucmd) {
 		if (!to_mucontext(pd->uobject->context)->reg_mr_warned) {
@@ -926,8 +927,11 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc,
-			       ucmd.mr_attrs & MTHCA_MR_DMASYNC);
+	if (ucmd.mr_attrs & MTHCA_MR_DMASYNC)
+		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
+
+	mr->umem = ib_umem_get_attrs(pd->uobject->context, start, length, acc,
+				DMA_BIDIRECTIONAL, dma_attrs);
 
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index bd69125..f417e1d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2170,7 +2170,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	u8 stag_key;
 	int first_page = 1;
 
-	region = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	region = ib_umem_get(pd->uobject->context, start, length, acc);
 	if (IS_ERR(region)) {
 		return (struct ib_mr *)region;
 	}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index b1a3d91..5c80765 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -967,7 +967,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(status);
-	mr->umem = ib_umem_get(ibpd->uobject->context, start, len, acc, 0);
+	mr->umem = ib_umem_get(ibpd->uobject->context, start, len, acc);
 	if (IS_ERR(mr->umem)) {
 		status = -EFAULT;
 		goto umem_err;
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 80c4b6b..564724a 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -369,7 +369,7 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-EINVAL);
 
 	umem = ib_umem_get(pd->uobject->context, start, length,
-			   mr_access_flags, 0);
+			   mr_access_flags);
 	if (IS_ERR(umem))
 		return (void *)umem;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index f3dab65..f4d47fd 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -169,7 +169,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 	void			*vaddr;
 	int err;
 
-	umem = ib_umem_get(pd->ibpd.uobject->context, start, length, access, 0);
+	umem = ib_umem_get(pd->ibpd.uobject->context, start, length, access);
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2876679..472c2f6 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -84,7 +84,7 @@ static inline size_t ib_umem_num_pages(struct ib_umem *umem)
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync);
+			    size_t size, int access);
 struct ib_umem *ib_umem_get_attrs(struct ib_ucontext *context, unsigned long addr,
 				  size_t size, int access,
 				  enum dma_data_direction dir,
@@ -100,7 +100,7 @@ int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
-					  int access, int dmasync) {
+					  int access) {
 	return ERR_PTR(-EINVAL);
 }
 static inline struct ib_umem *ib_umem_get_attrs(struct ib_ucontext *context,
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
