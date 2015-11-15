From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/9] IB: remove support for phys MRs
Date: Sun, 15 Nov 2015 19:05:56 +0100
Message-ID: <1447610762-3781-4-git-send-email-hch@lst.de>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447610762-3781-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have stopped using phys MRs in the kernel a while ago, so let's
remove all the cruft used to implement them.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_mem.c       |  31 ---
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  69 ------
 drivers/infiniband/hw/cxgb3/iwch_provider.h  |   4 -
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |  11 -
 drivers/infiniband/hw/cxgb4/mem.c            | 248 ---------------------
 drivers/infiniband/hw/cxgb4/provider.c       |   2 -
 drivers/infiniband/hw/mthca/mthca_provider.c |  84 -------
 drivers/infiniband/hw/nes/nes_cm.c           |   7 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |   3 +-
 drivers/infiniband/hw/nes/nes_verbs.h        |   5 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  | 163 --------------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |   3 -
 drivers/infiniband/hw/qib/qib_mr.c           |  51 +----
 drivers/infiniband/hw/qib/qib_verbs.c        |   1 -
 drivers/infiniband/hw/qib/qib_verbs.h        |   4 -
 drivers/staging/rdma/amso1100/c2_provider.c  |   1 -
 drivers/staging/rdma/ehca/ehca_iverbs.h      |  11 -
 drivers/staging/rdma/ehca/ehca_main.c        |   2 -
 drivers/staging/rdma/ehca/ehca_mrmw.c        | 321 ---------------------------
 drivers/staging/rdma/ehca/ehca_mrmw.h        |   5 -
 drivers/staging/rdma/hfi1/mr.c               |  51 +----
 drivers/staging/rdma/hfi1/verbs.c            |   1 -
 drivers/staging/rdma/hfi1/verbs.h            |   4 -
 drivers/staging/rdma/ipath/ipath_mr.c        |  55 -----
 drivers/staging/rdma/ipath/ipath_verbs.c     |   1 -
 drivers/staging/rdma/ipath/ipath_verbs.h     |   4 -
 include/rdma/ib_verbs.h                      |  16 +-
 28 files changed, 15 insertions(+), 1144 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_mem.c b/drivers/infiniband/hw/cxgb3/iwch_mem.c
index 5c36ee2..3a5e27d 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_mem.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_mem.c
@@ -75,37 +75,6 @@ int iwch_register_mem(struct iwch_dev *rhp, struct iwch_pd *php,
 	return ret;
 }
 
-int iwch_reregister_mem(struct iwch_dev *rhp, struct iwch_pd *php,
-					struct iwch_mr *mhp,
-					int shift,
-					int npages)
-{
-	u32 stag;
-	int ret;
-
-	/* We could support this... */
-	if (npages > mhp->attr.pbl_size)
-		return -ENOMEM;
-
-	stag = mhp->attr.stag;
-	if (cxio_reregister_phys_mem(&rhp->rdev,
-				   &stag, mhp->attr.pdid,
-				   mhp->attr.perms,
-				   mhp->attr.zbva,
-				   mhp->attr.va_fbo,
-				   mhp->attr.len,
-				   shift - 12,
-				   mhp->attr.pbl_size, mhp->attr.pbl_addr))
-		return -ENOMEM;
-
-	ret = iwch_finish_mem_reg(mhp, stag);
-	if (ret)
-		cxio_dereg_mem(&rhp->rdev, mhp->attr.stag, mhp->attr.pbl_size,
-		       mhp->attr.pbl_addr);
-
-	return ret;
-}
-
 int iwch_alloc_pbl(struct iwch_mr *mhp, int npages)
 {
 	mhp->attr.pbl_addr = cxio_hal_pblpool_alloc(&mhp->rhp->rdev,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 1567b5b..9576e15 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -556,73 +556,6 @@ err:
 
 }
 
-static int iwch_reregister_phys_mem(struct ib_mr *mr,
-				     int mr_rereg_mask,
-				     struct ib_pd *pd,
-	                             struct ib_phys_buf *buffer_list,
-	                             int num_phys_buf,
-	                             int acc, u64 * iova_start)
-{
-
-	struct iwch_mr mh, *mhp;
-	struct iwch_pd *php;
-	struct iwch_dev *rhp;
-	__be64 *page_list = NULL;
-	int shift = 0;
-	u64 total_size;
-	int npages = 0;
-	int ret;
-
-	PDBG("%s ib_mr %p ib_pd %p\n", __func__, mr, pd);
-
-	/* There can be no memory windows */
-	if (atomic_read(&mr->usecnt))
-		return -EINVAL;
-
-	mhp = to_iwch_mr(mr);
-	rhp = mhp->rhp;
-	php = to_iwch_pd(mr->pd);
-
-	/* make sure we are on the same adapter */
-	if (rhp != php->rhp)
-		return -EINVAL;
-
-	memcpy(&mh, mhp, sizeof *mhp);
-
-	if (mr_rereg_mask & IB_MR_REREG_PD)
-		php = to_iwch_pd(pd);
-	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
-		mh.attr.perms = iwch_ib_to_tpt_access(acc);
-	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
-		ret = build_phys_page_list(buffer_list, num_phys_buf,
-					   iova_start,
-					   &total_size, &npages,
-					   &shift, &page_list);
-		if (ret)
-			return ret;
-	}
-
-	ret = iwch_reregister_mem(rhp, php, &mh, shift, npages);
-	kfree(page_list);
-	if (ret) {
-		return ret;
-	}
-	if (mr_rereg_mask & IB_MR_REREG_PD)
-		mhp->attr.pdid = php->pdid;
-	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
-		mhp->attr.perms = iwch_ib_to_tpt_access(acc);
-	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
-		mhp->attr.zbva = 0;
-		mhp->attr.va_fbo = *iova_start;
-		mhp->attr.page_size = shift - 12;
-		mhp->attr.len = (u32) total_size;
-		mhp->attr.pbl_size = npages;
-	}
-
-	return 0;
-}
-
-
 static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				      u64 virt, int acc, struct ib_udata *udata)
 {
@@ -1414,8 +1347,6 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.resize_cq = iwch_resize_cq;
 	dev->ibdev.poll_cq = iwch_poll_cq;
 	dev->ibdev.get_dma_mr = iwch_get_dma_mr;
-	dev->ibdev.reg_phys_mr = iwch_register_phys_mem;
-	dev->ibdev.rereg_phys_mr = iwch_reregister_phys_mem;
 	dev->ibdev.reg_user_mr = iwch_reg_user_mr;
 	dev->ibdev.dereg_mr = iwch_dereg_mr;
 	dev->ibdev.alloc_mw = iwch_alloc_mw;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 2ac85b8..f4fa6d6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -341,10 +341,6 @@ void iwch_unregister_device(struct iwch_dev *dev);
 void stop_read_rep_timer(struct iwch_qp *qhp);
 int iwch_register_mem(struct iwch_dev *rhp, struct iwch_pd *php,
 		      struct iwch_mr *mhp, int shift);
-int iwch_reregister_mem(struct iwch_dev *rhp, struct iwch_pd *php,
-					struct iwch_mr *mhp,
-					int shift,
-					int npages);
 int iwch_alloc_pbl(struct iwch_mr *mhp, int npages);
 void iwch_free_pbl(struct iwch_mr *mhp);
 int iwch_write_pbl(struct iwch_mr *mhp, __be64 *pages, int npages, int offset);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 00e55fa..dd00cf2 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -968,17 +968,6 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
 					   u64 length, u64 virt, int acc,
 					   struct ib_udata *udata);
 struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc);
-struct ib_mr *c4iw_register_phys_mem(struct ib_pd *pd,
-					struct ib_phys_buf *buffer_list,
-					int num_phys_buf,
-					int acc,
-					u64 *iova_start);
-int c4iw_reregister_phys_mem(struct ib_mr *mr,
-				     int mr_rereg_mask,
-				     struct ib_pd *pd,
-				     struct ib_phys_buf *buffer_list,
-				     int num_phys_buf,
-				     int acc, u64 *iova_start);
 int c4iw_dereg_mr(struct ib_mr *ib_mr);
 int c4iw_destroy_cq(struct ib_cq *ib_cq);
 struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index e1629ab..1eb833a 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -392,32 +392,6 @@ static int register_mem(struct c4iw_dev *rhp, struct c4iw_pd *php,
 	return ret;
 }
 
-static int reregister_mem(struct c4iw_dev *rhp, struct c4iw_pd *php,
-			  struct c4iw_mr *mhp, int shift, int npages)
-{
-	u32 stag;
-	int ret;
-
-	if (npages > mhp->attr.pbl_size)
-		return -ENOMEM;
-
-	stag = mhp->attr.stag;
-	ret = write_tpt_entry(&rhp->rdev, 0, &stag, 1, mhp->attr.pdid,
-			      FW_RI_STAG_NSMR, mhp->attr.perms,
-			      mhp->attr.mw_bind_enable, mhp->attr.zbva,
-			      mhp->attr.va_fbo, mhp->attr.len, shift - 12,
-			      mhp->attr.pbl_size, mhp->attr.pbl_addr);
-	if (ret)
-		return ret;
-
-	ret = finish_mem_reg(mhp, stag);
-	if (ret)
-		dereg_mem(&rhp->rdev, mhp->attr.stag, mhp->attr.pbl_size,
-		       mhp->attr.pbl_addr);
-
-	return ret;
-}
-
 static int alloc_pbl(struct c4iw_mr *mhp, int npages)
 {
 	mhp->attr.pbl_addr = c4iw_pblpool_alloc(&mhp->rhp->rdev,
@@ -431,228 +405,6 @@ static int alloc_pbl(struct c4iw_mr *mhp, int npages)
 	return 0;
 }
 
-static int build_phys_page_list(struct ib_phys_buf *buffer_list,
-				int num_phys_buf, u64 *iova_start,
-				u64 *total_size, int *npages,
-				int *shift, __be64 **page_list)
-{
-	u64 mask;
-	int i, j, n;
-
-	mask = 0;
-	*total_size = 0;
-	for (i = 0; i < num_phys_buf; ++i) {
-		if (i != 0 && buffer_list[i].addr & ~PAGE_MASK)
-			return -EINVAL;
-		if (i != 0 && i != num_phys_buf - 1 &&
-		    (buffer_list[i].size & ~PAGE_MASK))
-			return -EINVAL;
-		*total_size += buffer_list[i].size;
-		if (i > 0)
-			mask |= buffer_list[i].addr;
-		else
-			mask |= buffer_list[i].addr & PAGE_MASK;
-		if (i != num_phys_buf - 1)
-			mask |= buffer_list[i].addr + buffer_list[i].size;
-		else
-			mask |= (buffer_list[i].addr + buffer_list[i].size +
-				PAGE_SIZE - 1) & PAGE_MASK;
-	}
-
-	if (*total_size > 0xFFFFFFFFULL)
-		return -ENOMEM;
-
-	/* Find largest page shift we can use to cover buffers */
-	for (*shift = PAGE_SHIFT; *shift < 27; ++(*shift))
-		if ((1ULL << *shift) & mask)
-			break;
-
-	buffer_list[0].size += buffer_list[0].addr & ((1ULL << *shift) - 1);
-	buffer_list[0].addr &= ~0ull << *shift;
-
-	*npages = 0;
-	for (i = 0; i < num_phys_buf; ++i)
-		*npages += (buffer_list[i].size +
-			(1ULL << *shift) - 1) >> *shift;
-
-	if (!*npages)
-		return -EINVAL;
-
-	*page_list = kmalloc(sizeof(u64) * *npages, GFP_KERNEL);
-	if (!*page_list)
-		return -ENOMEM;
-
-	n = 0;
-	for (i = 0; i < num_phys_buf; ++i)
-		for (j = 0;
-		     j < (buffer_list[i].size + (1ULL << *shift) - 1) >> *shift;
-		     ++j)
-			(*page_list)[n++] = cpu_to_be64(buffer_list[i].addr +
-			    ((u64) j << *shift));
-
-	PDBG("%s va 0x%llx mask 0x%llx shift %d len %lld pbl_size %d\n",
-	     __func__, (unsigned long long)*iova_start,
-	     (unsigned long long)mask, *shift, (unsigned long long)*total_size,
-	     *npages);
-
-	return 0;
-
-}
-
-int c4iw_reregister_phys_mem(struct ib_mr *mr, int mr_rereg_mask,
-			     struct ib_pd *pd, struct ib_phys_buf *buffer_list,
-			     int num_phys_buf, int acc, u64 *iova_start)
-{
-
-	struct c4iw_mr mh, *mhp;
-	struct c4iw_pd *php;
-	struct c4iw_dev *rhp;
-	__be64 *page_list = NULL;
-	int shift = 0;
-	u64 total_size;
-	int npages;
-	int ret;
-
-	PDBG("%s ib_mr %p ib_pd %p\n", __func__, mr, pd);
-
-	/* There can be no memory windows */
-	if (atomic_read(&mr->usecnt))
-		return -EINVAL;
-
-	mhp = to_c4iw_mr(mr);
-	rhp = mhp->rhp;
-	php = to_c4iw_pd(mr->pd);
-
-	/* make sure we are on the same adapter */
-	if (rhp != php->rhp)
-		return -EINVAL;
-
-	memcpy(&mh, mhp, sizeof *mhp);
-
-	if (mr_rereg_mask & IB_MR_REREG_PD)
-		php = to_c4iw_pd(pd);
-	if (mr_rereg_mask & IB_MR_REREG_ACCESS) {
-		mh.attr.perms = c4iw_ib_to_tpt_access(acc);
-		mh.attr.mw_bind_enable = (acc & IB_ACCESS_MW_BIND) ==
-					 IB_ACCESS_MW_BIND;
-	}
-	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
-		ret = build_phys_page_list(buffer_list, num_phys_buf,
-						iova_start,
-						&total_size, &npages,
-						&shift, &page_list);
-		if (ret)
-			return ret;
-	}
-
-	if (mr_exceeds_hw_limits(rhp, total_size)) {
-		kfree(page_list);
-		return -EINVAL;
-	}
-
-	ret = reregister_mem(rhp, php, &mh, shift, npages);
-	kfree(page_list);
-	if (ret)
-		return ret;
-	if (mr_rereg_mask & IB_MR_REREG_PD)
-		mhp->attr.pdid = php->pdid;
-	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
-		mhp->attr.perms = c4iw_ib_to_tpt_access(acc);
-	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
-		mhp->attr.zbva = 0;
-		mhp->attr.va_fbo = *iova_start;
-		mhp->attr.page_size = shift - 12;
-		mhp->attr.len = (u32) total_size;
-		mhp->attr.pbl_size = npages;
-	}
-
-	return 0;
-}
-
-struct ib_mr *c4iw_register_phys_mem(struct ib_pd *pd,
-				     struct ib_phys_buf *buffer_list,
-				     int num_phys_buf, int acc, u64 *iova_start)
-{
-	__be64 *page_list;
-	int shift;
-	u64 total_size;
-	int npages;
-	struct c4iw_dev *rhp;
-	struct c4iw_pd *php;
-	struct c4iw_mr *mhp;
-	int ret;
-
-	PDBG("%s ib_pd %p\n", __func__, pd);
-	php = to_c4iw_pd(pd);
-	rhp = php->rhp;
-
-	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
-	if (!mhp)
-		return ERR_PTR(-ENOMEM);
-
-	mhp->rhp = rhp;
-
-	/* First check that we have enough alignment */
-	if ((*iova_start & ~PAGE_MASK) != (buffer_list[0].addr & ~PAGE_MASK)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
-	if (num_phys_buf > 1 &&
-	    ((buffer_list[0].addr + buffer_list[0].size) & ~PAGE_MASK)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
-	ret = build_phys_page_list(buffer_list, num_phys_buf, iova_start,
-					&total_size, &npages, &shift,
-					&page_list);
-	if (ret)
-		goto err;
-
-	if (mr_exceeds_hw_limits(rhp, total_size)) {
-		kfree(page_list);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	ret = alloc_pbl(mhp, npages);
-	if (ret) {
-		kfree(page_list);
-		goto err;
-	}
-
-	ret = write_pbl(&mhp->rhp->rdev, page_list, mhp->attr.pbl_addr,
-			     npages);
-	kfree(page_list);
-	if (ret)
-		goto err_pbl;
-
-	mhp->attr.pdid = php->pdid;
-	mhp->attr.zbva = 0;
-
-	mhp->attr.perms = c4iw_ib_to_tpt_access(acc);
-	mhp->attr.va_fbo = *iova_start;
-	mhp->attr.page_size = shift - 12;
-
-	mhp->attr.len = (u32) total_size;
-	mhp->attr.pbl_size = npages;
-	ret = register_mem(rhp, php, mhp, shift);
-	if (ret)
-		goto err_pbl;
-
-	return &mhp->ibmr;
-
-err_pbl:
-	c4iw_pblpool_free(&mhp->rhp->rdev, mhp->attr.pbl_addr,
-			      mhp->attr.pbl_size << 3);
-
-err:
-	kfree(mhp);
-	return ERR_PTR(ret);
-
-}
-
 struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
 {
 	struct c4iw_dev *rhp;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index b7703bc..186319e 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -509,8 +509,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.resize_cq = c4iw_resize_cq;
 	dev->ibdev.poll_cq = c4iw_poll_cq;
 	dev->ibdev.get_dma_mr = c4iw_get_dma_mr;
-	dev->ibdev.reg_phys_mr = c4iw_register_phys_mem;
-	dev->ibdev.rereg_phys_mr = c4iw_reregister_phys_mem;
 	dev->ibdev.reg_user_mr = c4iw_reg_user_mr;
 	dev->ibdev.dereg_mr = c4iw_dereg_mr;
 	dev->ibdev.alloc_mw = c4iw_alloc_mw;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 28d7a8b..6d0a1db 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -892,89 +892,6 @@ static struct ib_mr *mthca_get_dma_mr(struct ib_pd *pd, int acc)
 	return &mr->ibmr;
 }
 
-static struct ib_mr *mthca_reg_phys_mr(struct ib_pd       *pd,
-				       struct ib_phys_buf *buffer_list,
-				       int                 num_phys_buf,
-				       int                 acc,
-				       u64                *iova_start)
-{
-	struct mthca_mr *mr;
-	u64 *page_list;
-	u64 total_size;
-	unsigned long mask;
-	int shift;
-	int npages;
-	int err;
-	int i, j, n;
-
-	mask = buffer_list[0].addr ^ *iova_start;
-	total_size = 0;
-	for (i = 0; i < num_phys_buf; ++i) {
-		if (i != 0)
-			mask |= buffer_list[i].addr;
-		if (i != num_phys_buf - 1)
-			mask |= buffer_list[i].addr + buffer_list[i].size;
-
-		total_size += buffer_list[i].size;
-	}
-
-	if (mask & ~PAGE_MASK)
-		return ERR_PTR(-EINVAL);
-
-	shift = __ffs(mask | 1 << 31);
-
-	buffer_list[0].size += buffer_list[0].addr & ((1ULL << shift) - 1);
-	buffer_list[0].addr &= ~0ull << shift;
-
-	mr = kmalloc(sizeof *mr, GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
-
-	npages = 0;
-	for (i = 0; i < num_phys_buf; ++i)
-		npages += (buffer_list[i].size + (1ULL << shift) - 1) >> shift;
-
-	if (!npages)
-		return &mr->ibmr;
-
-	page_list = kmalloc(npages * sizeof *page_list, GFP_KERNEL);
-	if (!page_list) {
-		kfree(mr);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	n = 0;
-	for (i = 0; i < num_phys_buf; ++i)
-		for (j = 0;
-		     j < (buffer_list[i].size + (1ULL << shift) - 1) >> shift;
-		     ++j)
-			page_list[n++] = buffer_list[i].addr + ((u64) j << shift);
-
-	mthca_dbg(to_mdev(pd->device), "Registering memory at %llx (iova %llx) "
-		  "in PD %x; shift %d, npages %d.\n",
-		  (unsigned long long) buffer_list[0].addr,
-		  (unsigned long long) *iova_start,
-		  to_mpd(pd)->pd_num,
-		  shift, npages);
-
-	err = mthca_mr_alloc_phys(to_mdev(pd->device),
-				  to_mpd(pd)->pd_num,
-				  page_list, shift, npages,
-				  *iova_start, total_size,
-				  convert_access(acc), mr);
-
-	if (err) {
-		kfree(page_list);
-		kfree(mr);
-		return ERR_PTR(err);
-	}
-
-	kfree(page_list);
-	mr->umem = NULL;
-
-	return &mr->ibmr;
-}
-
 static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				       u64 virt, int acc, struct ib_udata *udata)
 {
@@ -1339,7 +1256,6 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.destroy_cq           = mthca_destroy_cq;
 	dev->ib_dev.poll_cq              = mthca_poll_cq;
 	dev->ib_dev.get_dma_mr           = mthca_get_dma_mr;
-	dev->ib_dev.reg_phys_mr          = mthca_reg_phys_mr;
 	dev->ib_dev.reg_user_mr          = mthca_reg_user_mr;
 	dev->ib_dev.dereg_mr             = mthca_dereg_mr;
 	dev->ib_dev.get_port_immutable   = mthca_port_immutable;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 8a3ad17..242c87d 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -3319,10 +3319,9 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		ibphysbuf.addr = nesqp->ietf_frame_pbase + mpa_frame_offset;
 		ibphysbuf.size = buff_len;
 		tagged_offset = (u64)(unsigned long)*start_buff;
-		ibmr = nesibdev->ibdev.reg_phys_mr((struct ib_pd *)nespd,
-						   &ibphysbuf, 1,
-						   IB_ACCESS_LOCAL_WRITE,
-						   &tagged_offset);
+		ibmr = nes_reg_phys_mr(&nespd->ibpd, &ibphysbuf, 1,
+					IB_ACCESS_LOCAL_WRITE,
+					&tagged_offset);
 		if (!ibmr) {
 			nes_debug(NES_DBG_CM, "Unable to register memory region"
 				  "for lSMM for cm_node = %p \n",
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 2bad036..453ebc2 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2019,7 +2019,7 @@ static int nes_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 /**
  * nes_reg_phys_mr
  */
-static struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
+struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 		struct ib_phys_buf *buffer_list, int num_phys_buf, int acc,
 		u64 * iova_start)
 {
@@ -3832,7 +3832,6 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.destroy_cq = nes_destroy_cq;
 	nesibdev->ibdev.poll_cq = nes_poll_cq;
 	nesibdev->ibdev.get_dma_mr = nes_get_dma_mr;
-	nesibdev->ibdev.reg_phys_mr = nes_reg_phys_mr;
 	nesibdev->ibdev.reg_user_mr = nes_reg_user_mr;
 	nesibdev->ibdev.dereg_mr = nes_dereg_mr;
 	nesibdev->ibdev.alloc_mw = nes_alloc_mw;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index a204b67..38e38cf 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -190,4 +190,9 @@ struct nes_qp {
 	u8                    pau_state;
 	__u64                 nesuqp_addr;
 };
+
+struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
+		struct ib_phys_buf *buffer_list, int num_phys_buf, int acc,
+		u64 * iova_start);
+
 #endif			/* NES_VERBS_H */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 963be66..f91131f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -174,7 +174,6 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	dev->ibdev.req_notify_cq = ocrdma_arm_cq;
 
 	dev->ibdev.get_dma_mr = ocrdma_get_dma_mr;
-	dev->ibdev.reg_phys_mr = ocrdma_reg_kernel_mr;
 	dev->ibdev.dereg_mr = ocrdma_dereg_mr;
 	dev->ibdev.reg_user_mr = ocrdma_reg_user_mr;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 74cf67a..3cffab7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -3017,169 +3017,6 @@ pl_err:
 	return ERR_PTR(-ENOMEM);
 }
 
-#define MAX_KERNEL_PBE_SIZE 65536
-static inline int count_kernel_pbes(struct ib_phys_buf *buf_list,
-				    int buf_cnt, u32 *pbe_size)
-{
-	u64 total_size = 0;
-	u64 buf_size = 0;
-	int i;
-	*pbe_size = roundup(buf_list[0].size, PAGE_SIZE);
-	*pbe_size = roundup_pow_of_two(*pbe_size);
-
-	/* find the smallest PBE size that we can have */
-	for (i = 0; i < buf_cnt; i++) {
-		/* first addr may not be page aligned, so ignore checking */
-		if ((i != 0) && ((buf_list[i].addr & ~PAGE_MASK) ||
-				 (buf_list[i].size & ~PAGE_MASK))) {
-			return 0;
-		}
-
-		/* if configured PBE size is greater then the chosen one,
-		 * reduce the PBE size.
-		 */
-		buf_size = roundup(buf_list[i].size, PAGE_SIZE);
-		/* pbe_size has to be even multiple of 4K 1,2,4,8...*/
-		buf_size = roundup_pow_of_two(buf_size);
-		if (*pbe_size > buf_size)
-			*pbe_size = buf_size;
-
-		total_size += buf_size;
-	}
-	*pbe_size = *pbe_size > MAX_KERNEL_PBE_SIZE ?
-	    (MAX_KERNEL_PBE_SIZE) : (*pbe_size);
-
-	/* num_pbes = total_size / (*pbe_size);  this is implemented below. */
-
-	return total_size >> ilog2(*pbe_size);
-}
-
-static void build_kernel_pbes(struct ib_phys_buf *buf_list, int ib_buf_cnt,
-			      u32 pbe_size, struct ocrdma_pbl *pbl_tbl,
-			      struct ocrdma_hw_mr *hwmr)
-{
-	int i;
-	int idx;
-	int pbes_per_buf = 0;
-	u64 buf_addr = 0;
-	int num_pbes;
-	struct ocrdma_pbe *pbe;
-	int total_num_pbes = 0;
-
-	if (!hwmr->num_pbes)
-		return;
-
-	pbe = (struct ocrdma_pbe *)pbl_tbl->va;
-	num_pbes = 0;
-
-	/* go through the OS phy regions & fill hw pbe entries into pbls. */
-	for (i = 0; i < ib_buf_cnt; i++) {
-		buf_addr = buf_list[i].addr;
-		pbes_per_buf =
-		    roundup_pow_of_two(roundup(buf_list[i].size, PAGE_SIZE)) /
-		    pbe_size;
-		hwmr->len += buf_list[i].size;
-		/* number of pbes can be more for one OS buf, when
-		 * buffers are of different sizes.
-		 * split the ib_buf to one or more pbes.
-		 */
-		for (idx = 0; idx < pbes_per_buf; idx++) {
-			/* we program always page aligned addresses,
-			 * first unaligned address is taken care by fbo.
-			 */
-			if (i == 0) {
-				/* for non zero fbo, assign the
-				 * start of the page.
-				 */
-				pbe->pa_lo =
-				    cpu_to_le32((u32) (buf_addr & PAGE_MASK));
-				pbe->pa_hi =
-				    cpu_to_le32((u32) upper_32_bits(buf_addr));
-			} else {
-				pbe->pa_lo =
-				    cpu_to_le32((u32) (buf_addr & 0xffffffff));
-				pbe->pa_hi =
-				    cpu_to_le32((u32) upper_32_bits(buf_addr));
-			}
-			buf_addr += pbe_size;
-			num_pbes += 1;
-			total_num_pbes += 1;
-			pbe++;
-
-			if (total_num_pbes == hwmr->num_pbes)
-				goto mr_tbl_done;
-			/* if the pbl is full storing the pbes,
-			 * move to next pbl.
-			 */
-			if (num_pbes == (hwmr->pbl_size/sizeof(u64))) {
-				pbl_tbl++;
-				pbe = (struct ocrdma_pbe *)pbl_tbl->va;
-				num_pbes = 0;
-			}
-		}
-	}
-mr_tbl_done:
-	return;
-}
-
-struct ib_mr *ocrdma_reg_kernel_mr(struct ib_pd *ibpd,
-				   struct ib_phys_buf *buf_list,
-				   int buf_cnt, int acc, u64 *iova_start)
-{
-	int status = -ENOMEM;
-	struct ocrdma_mr *mr;
-	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
-	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
-	u32 num_pbes;
-	u32 pbe_size = 0;
-
-	if ((acc & IB_ACCESS_REMOTE_WRITE) && !(acc & IB_ACCESS_LOCAL_WRITE))
-		return ERR_PTR(-EINVAL);
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(status);
-
-	num_pbes = count_kernel_pbes(buf_list, buf_cnt, &pbe_size);
-	if (num_pbes == 0) {
-		status = -EINVAL;
-		goto pbl_err;
-	}
-	status = ocrdma_get_pbl_info(dev, mr, num_pbes);
-	if (status)
-		goto pbl_err;
-
-	mr->hwmr.pbe_size = pbe_size;
-	mr->hwmr.fbo = *iova_start - (buf_list[0].addr & PAGE_MASK);
-	mr->hwmr.va = *iova_start;
-	mr->hwmr.local_rd = 1;
-	mr->hwmr.remote_wr = (acc & IB_ACCESS_REMOTE_WRITE) ? 1 : 0;
-	mr->hwmr.remote_rd = (acc & IB_ACCESS_REMOTE_READ) ? 1 : 0;
-	mr->hwmr.local_wr = (acc & IB_ACCESS_LOCAL_WRITE) ? 1 : 0;
-	mr->hwmr.remote_atomic = (acc & IB_ACCESS_REMOTE_ATOMIC) ? 1 : 0;
-	mr->hwmr.mw_bind = (acc & IB_ACCESS_MW_BIND) ? 1 : 0;
-
-	status = ocrdma_build_pbl_tbl(dev, &mr->hwmr);
-	if (status)
-		goto pbl_err;
-	build_kernel_pbes(buf_list, buf_cnt, pbe_size, mr->hwmr.pbl_table,
-			  &mr->hwmr);
-	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, acc);
-	if (status)
-		goto mbx_err;
-
-	mr->ibmr.lkey = mr->hwmr.lkey;
-	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
-		mr->ibmr.rkey = mr->hwmr.lkey;
-	return &mr->ibmr;
-
-mbx_err:
-	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
-pbl_err:
-	kfree(mr);
-	return ERR_PTR(status);
-}
-
 static int ocrdma_set_page(struct ib_mr *ibmr, u64 addr)
 {
 	struct ocrdma_mr *mr = get_ocrdma_mr(ibmr);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index f2ce048..82f476f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -115,9 +115,6 @@ int ocrdma_post_srq_recv(struct ib_srq *, struct ib_recv_wr *,
 
 int ocrdma_dereg_mr(struct ib_mr *);
 struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *, int acc);
-struct ib_mr *ocrdma_reg_kernel_mr(struct ib_pd *,
-				   struct ib_phys_buf *buffer_list,
-				   int num_phys_buf, int acc, u64 *iova_start);
 struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *, u64 start, u64 length,
 				 u64 virt, int acc, struct ib_udata *);
 struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 294f5c7..5f53304 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -150,10 +150,7 @@ static struct qib_mr *alloc_mr(int count, struct ib_pd *pd)
 	rval = init_qib_mregion(&mr->mr, pd, count);
 	if (rval)
 		goto bail;
-	/*
-	 * ib_reg_phys_mr() will initialize mr->ibmr except for
-	 * lkey and rkey.
-	 */
+
 	rval = qib_alloc_lkey(&mr->mr, 0);
 	if (rval)
 		goto bail_mregion;
@@ -171,52 +168,6 @@ bail:
 }
 
 /**
- * qib_reg_phys_mr - register a physical memory region
- * @pd: protection domain for this memory region
- * @buffer_list: pointer to the list of physical buffers to register
- * @num_phys_buf: the number of physical buffers to register
- * @iova_start: the starting address passed over IB which maps to this MR
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_mr *qib_reg_phys_mr(struct ib_pd *pd,
-			      struct ib_phys_buf *buffer_list,
-			      int num_phys_buf, int acc, u64 *iova_start)
-{
-	struct qib_mr *mr;
-	int n, m, i;
-	struct ib_mr *ret;
-
-	mr = alloc_mr(num_phys_buf, pd);
-	if (IS_ERR(mr)) {
-		ret = (struct ib_mr *)mr;
-		goto bail;
-	}
-
-	mr->mr.user_base = *iova_start;
-	mr->mr.iova = *iova_start;
-	mr->mr.access_flags = acc;
-
-	m = 0;
-	n = 0;
-	for (i = 0; i < num_phys_buf; i++) {
-		mr->mr.map[m]->segs[n].vaddr = (void *) buffer_list[i].addr;
-		mr->mr.map[m]->segs[n].length = buffer_list[i].size;
-		mr->mr.length += buffer_list[i].size;
-		n++;
-		if (n == QIB_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-
-	ret = &mr->ibmr;
-
-bail:
-	return ret;
-}
-
-/**
  * qib_reg_user_mr - register a userspace memory region
  * @pd: protection domain for this memory region
  * @start: starting userspace address
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9e1af0b..e56bd65 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2206,7 +2206,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->poll_cq = qib_poll_cq;
 	ibdev->req_notify_cq = qib_req_notify_cq;
 	ibdev->get_dma_mr = qib_get_dma_mr;
-	ibdev->reg_phys_mr = qib_reg_phys_mr;
 	ibdev->reg_user_mr = qib_reg_user_mr;
 	ibdev->dereg_mr = qib_dereg_mr;
 	ibdev->alloc_mr = qib_alloc_mr;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 2baf5ad..2d538c8c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1032,10 +1032,6 @@ int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 
 struct ib_mr *qib_get_dma_mr(struct ib_pd *pd, int acc);
 
-struct ib_mr *qib_reg_phys_mr(struct ib_pd *pd,
-			      struct ib_phys_buf *buffer_list,
-			      int num_phys_buf, int acc, u64 *iova_start);
-
 struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			      u64 virt_addr, int mr_access_flags,
 			      struct ib_udata *udata);
diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/staging/rdma/amso1100/c2_provider.c
index ee2ff87..6c3e9cc 100644
--- a/drivers/staging/rdma/amso1100/c2_provider.c
+++ b/drivers/staging/rdma/amso1100/c2_provider.c
@@ -831,7 +831,6 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.destroy_cq = c2_destroy_cq;
 	dev->ibdev.poll_cq = c2_poll_cq;
 	dev->ibdev.get_dma_mr = c2_get_dma_mr;
-	dev->ibdev.reg_phys_mr = c2_reg_phys_mr;
 	dev->ibdev.reg_user_mr = c2_reg_user_mr;
 	dev->ibdev.dereg_mr = c2_dereg_mr;
 	dev->ibdev.get_port_immutable = c2_port_immutable;
diff --git a/drivers/staging/rdma/ehca/ehca_iverbs.h b/drivers/staging/rdma/ehca/ehca_iverbs.h
index 4a45ca3..219f635 100644
--- a/drivers/staging/rdma/ehca/ehca_iverbs.h
+++ b/drivers/staging/rdma/ehca/ehca_iverbs.h
@@ -79,21 +79,10 @@ int ehca_destroy_ah(struct ib_ah *ah);
 
 struct ib_mr *ehca_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
 
-struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
-			       struct ib_phys_buf *phys_buf_array,
-			       int num_phys_buf,
-			       int mr_access_flags, u64 *iova_start);
-
 struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			       u64 virt, int mr_access_flags,
 			       struct ib_udata *udata);
 
-int ehca_rereg_phys_mr(struct ib_mr *mr,
-		       int mr_rereg_mask,
-		       struct ib_pd *pd,
-		       struct ib_phys_buf *phys_buf_array,
-		       int num_phys_buf, int mr_access_flags, u64 *iova_start);
-
 int ehca_dereg_mr(struct ib_mr *mr);
 
 struct ib_mw *ehca_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
diff --git a/drivers/staging/rdma/ehca/ehca_main.c b/drivers/staging/rdma/ehca/ehca_main.c
index 0be7959..ba023426 100644
--- a/drivers/staging/rdma/ehca/ehca_main.c
+++ b/drivers/staging/rdma/ehca/ehca_main.c
@@ -511,10 +511,8 @@ static int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.req_notify_cq	    = ehca_req_notify_cq;
 	/* shca->ib_device.req_ncomp_notif  = ehca_req_ncomp_notif; */
 	shca->ib_device.get_dma_mr	    = ehca_get_dma_mr;
-	shca->ib_device.reg_phys_mr	    = ehca_reg_phys_mr;
 	shca->ib_device.reg_user_mr	    = ehca_reg_user_mr;
 	shca->ib_device.dereg_mr	    = ehca_dereg_mr;
-	shca->ib_device.rereg_phys_mr	    = ehca_rereg_phys_mr;
 	shca->ib_device.alloc_mw	    = ehca_alloc_mw;
 	shca->ib_device.bind_mw		    = ehca_bind_mw;
 	shca->ib_device.dealloc_mw	    = ehca_dealloc_mw;
diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
index eb274c1..1c1a8dd 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.c
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.c
@@ -196,120 +196,6 @@ get_dma_mr_exit0:
 
 /*----------------------------------------------------------------------*/
 
-struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
-			       struct ib_phys_buf *phys_buf_array,
-			       int num_phys_buf,
-			       int mr_access_flags,
-			       u64 *iova_start)
-{
-	struct ib_mr *ib_mr;
-	int ret;
-	struct ehca_mr *e_mr;
-	struct ehca_shca *shca =
-		container_of(pd->device, struct ehca_shca, ib_device);
-	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
-
-	u64 size;
-
-	if ((num_phys_buf <= 0) || !phys_buf_array) {
-		ehca_err(pd->device, "bad input values: num_phys_buf=%x "
-			 "phys_buf_array=%p", num_phys_buf, phys_buf_array);
-		ib_mr = ERR_PTR(-EINVAL);
-		goto reg_phys_mr_exit0;
-	}
-	if (((mr_access_flags & IB_ACCESS_REMOTE_WRITE) &&
-	     !(mr_access_flags & IB_ACCESS_LOCAL_WRITE)) ||
-	    ((mr_access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-	     !(mr_access_flags & IB_ACCESS_LOCAL_WRITE))) {
-		/*
-		 * Remote Write Access requires Local Write Access
-		 * Remote Atomic Access requires Local Write Access
-		 */
-		ehca_err(pd->device, "bad input values: mr_access_flags=%x",
-			 mr_access_flags);
-		ib_mr = ERR_PTR(-EINVAL);
-		goto reg_phys_mr_exit0;
-	}
-
-	/* check physical buffer list and calculate size */
-	ret = ehca_mr_chk_buf_and_calc_size(phys_buf_array, num_phys_buf,
-					    iova_start, &size);
-	if (ret) {
-		ib_mr = ERR_PTR(ret);
-		goto reg_phys_mr_exit0;
-	}
-	if ((size == 0) ||
-	    (((u64)iova_start + size) < (u64)iova_start)) {
-		ehca_err(pd->device, "bad input values: size=%llx iova_start=%p",
-			 size, iova_start);
-		ib_mr = ERR_PTR(-EINVAL);
-		goto reg_phys_mr_exit0;
-	}
-
-	e_mr = ehca_mr_new();
-	if (!e_mr) {
-		ehca_err(pd->device, "out of memory");
-		ib_mr = ERR_PTR(-ENOMEM);
-		goto reg_phys_mr_exit0;
-	}
-
-	/* register MR on HCA */
-	if (ehca_mr_is_maxmr(size, iova_start)) {
-		e_mr->flags |= EHCA_MR_FLAG_MAXMR;
-		ret = ehca_reg_maxmr(shca, e_mr, iova_start, mr_access_flags,
-				     e_pd, &e_mr->ib.ib_mr.lkey,
-				     &e_mr->ib.ib_mr.rkey);
-		if (ret) {
-			ib_mr = ERR_PTR(ret);
-			goto reg_phys_mr_exit1;
-		}
-	} else {
-		struct ehca_mr_pginfo pginfo;
-		u32 num_kpages;
-		u32 num_hwpages;
-		u64 hw_pgsize;
-
-		num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size,
-					PAGE_SIZE);
-		/* for kernel space we try most possible pgsize */
-		hw_pgsize = ehca_get_max_hwpage_size(shca);
-		num_hwpages = NUM_CHUNKS(((u64)iova_start % hw_pgsize) + size,
-					 hw_pgsize);
-		memset(&pginfo, 0, sizeof(pginfo));
-		pginfo.type = EHCA_MR_PGI_PHYS;
-		pginfo.num_kpages = num_kpages;
-		pginfo.hwpage_size = hw_pgsize;
-		pginfo.num_hwpages = num_hwpages;
-		pginfo.u.phy.num_phys_buf = num_phys_buf;
-		pginfo.u.phy.phys_buf_array = phys_buf_array;
-		pginfo.next_hwpage =
-			((u64)iova_start & ~PAGE_MASK) / hw_pgsize;
-
-		ret = ehca_reg_mr(shca, e_mr, iova_start, size, mr_access_flags,
-				  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
-				  &e_mr->ib.ib_mr.rkey, EHCA_REG_MR);
-		if (ret) {
-			ib_mr = ERR_PTR(ret);
-			goto reg_phys_mr_exit1;
-		}
-	}
-
-	/* successful registration of all pages */
-	return &e_mr->ib.ib_mr;
-
-reg_phys_mr_exit1:
-	ehca_mr_delete(e_mr);
-reg_phys_mr_exit0:
-	if (IS_ERR(ib_mr))
-		ehca_err(pd->device, "h_ret=%li pd=%p phys_buf_array=%p "
-			 "num_phys_buf=%x mr_access_flags=%x iova_start=%p",
-			 PTR_ERR(ib_mr), pd, phys_buf_array,
-			 num_phys_buf, mr_access_flags, iova_start);
-	return ib_mr;
-} /* end ehca_reg_phys_mr() */
-
-/*----------------------------------------------------------------------*/
-
 struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			       u64 virt, int mr_access_flags,
 			       struct ib_udata *udata)
@@ -437,158 +323,6 @@ reg_user_mr_exit0:
 
 /*----------------------------------------------------------------------*/
 
-int ehca_rereg_phys_mr(struct ib_mr *mr,
-		       int mr_rereg_mask,
-		       struct ib_pd *pd,
-		       struct ib_phys_buf *phys_buf_array,
-		       int num_phys_buf,
-		       int mr_access_flags,
-		       u64 *iova_start)
-{
-	int ret;
-
-	struct ehca_shca *shca =
-		container_of(mr->device, struct ehca_shca, ib_device);
-	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
-	u64 new_size;
-	u64 *new_start;
-	u32 new_acl;
-	struct ehca_pd *new_pd;
-	u32 tmp_lkey, tmp_rkey;
-	unsigned long sl_flags;
-	u32 num_kpages = 0;
-	u32 num_hwpages = 0;
-	struct ehca_mr_pginfo pginfo;
-
-	if (!(mr_rereg_mask & IB_MR_REREG_TRANS)) {
-		/* TODO not supported, because PHYP rereg hCall needs pages */
-		ehca_err(mr->device, "rereg without IB_MR_REREG_TRANS not "
-			 "supported yet, mr_rereg_mask=%x", mr_rereg_mask);
-		ret = -EINVAL;
-		goto rereg_phys_mr_exit0;
-	}
-
-	if (mr_rereg_mask & IB_MR_REREG_PD) {
-		if (!pd) {
-			ehca_err(mr->device, "rereg with bad pd, pd=%p "
-				 "mr_rereg_mask=%x", pd, mr_rereg_mask);
-			ret = -EINVAL;
-			goto rereg_phys_mr_exit0;
-		}
-	}
-
-	if ((mr_rereg_mask &
-	     ~(IB_MR_REREG_TRANS | IB_MR_REREG_PD | IB_MR_REREG_ACCESS)) ||
-	    (mr_rereg_mask == 0)) {
-		ret = -EINVAL;
-		goto rereg_phys_mr_exit0;
-	}
-
-	/* check other parameters */
-	if (e_mr == shca->maxmr) {
-		/* should be impossible, however reject to be sure */
-		ehca_err(mr->device, "rereg internal max-MR impossible, mr=%p "
-			 "shca->maxmr=%p mr->lkey=%x",
-			 mr, shca->maxmr, mr->lkey);
-		ret = -EINVAL;
-		goto rereg_phys_mr_exit0;
-	}
-	if (mr_rereg_mask & IB_MR_REREG_TRANS) { /* transl., i.e. addr/size */
-		if (e_mr->flags & EHCA_MR_FLAG_FMR) {
-			ehca_err(mr->device, "not supported for FMR, mr=%p "
-				 "flags=%x", mr, e_mr->flags);
-			ret = -EINVAL;
-			goto rereg_phys_mr_exit0;
-		}
-		if (!phys_buf_array || num_phys_buf <= 0) {
-			ehca_err(mr->device, "bad input values mr_rereg_mask=%x"
-				 " phys_buf_array=%p num_phys_buf=%x",
-				 mr_rereg_mask, phys_buf_array, num_phys_buf);
-			ret = -EINVAL;
-			goto rereg_phys_mr_exit0;
-		}
-	}
-	if ((mr_rereg_mask & IB_MR_REREG_ACCESS) &&	/* change ACL */
-	    (((mr_access_flags & IB_ACCESS_REMOTE_WRITE) &&
-	      !(mr_access_flags & IB_ACCESS_LOCAL_WRITE)) ||
-	     ((mr_access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-	      !(mr_access_flags & IB_ACCESS_LOCAL_WRITE)))) {
-		/*
-		 * Remote Write Access requires Local Write Access
-		 * Remote Atomic Access requires Local Write Access
-		 */
-		ehca_err(mr->device, "bad input values: mr_rereg_mask=%x "
-			 "mr_access_flags=%x", mr_rereg_mask, mr_access_flags);
-		ret = -EINVAL;
-		goto rereg_phys_mr_exit0;
-	}
-
-	/* set requested values dependent on rereg request */
-	spin_lock_irqsave(&e_mr->mrlock, sl_flags);
-	new_start = e_mr->start;
-	new_size = e_mr->size;
-	new_acl = e_mr->acl;
-	new_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
-
-	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
-		u64 hw_pgsize = ehca_get_max_hwpage_size(shca);
-
-		new_start = iova_start;	/* change address */
-		/* check physical buffer list and calculate size */
-		ret = ehca_mr_chk_buf_and_calc_size(phys_buf_array,
-						    num_phys_buf, iova_start,
-						    &new_size);
-		if (ret)
-			goto rereg_phys_mr_exit1;
-		if ((new_size == 0) ||
-		    (((u64)iova_start + new_size) < (u64)iova_start)) {
-			ehca_err(mr->device, "bad input values: new_size=%llx "
-				 "iova_start=%p", new_size, iova_start);
-			ret = -EINVAL;
-			goto rereg_phys_mr_exit1;
-		}
-		num_kpages = NUM_CHUNKS(((u64)new_start % PAGE_SIZE) +
-					new_size, PAGE_SIZE);
-		num_hwpages = NUM_CHUNKS(((u64)new_start % hw_pgsize) +
-					 new_size, hw_pgsize);
-		memset(&pginfo, 0, sizeof(pginfo));
-		pginfo.type = EHCA_MR_PGI_PHYS;
-		pginfo.num_kpages = num_kpages;
-		pginfo.hwpage_size = hw_pgsize;
-		pginfo.num_hwpages = num_hwpages;
-		pginfo.u.phy.num_phys_buf = num_phys_buf;
-		pginfo.u.phy.phys_buf_array = phys_buf_array;
-		pginfo.next_hwpage =
-			((u64)iova_start & ~PAGE_MASK) / hw_pgsize;
-	}
-	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
-		new_acl = mr_access_flags;
-	if (mr_rereg_mask & IB_MR_REREG_PD)
-		new_pd = container_of(pd, struct ehca_pd, ib_pd);
-
-	ret = ehca_rereg_mr(shca, e_mr, new_start, new_size, new_acl,
-			    new_pd, &pginfo, &tmp_lkey, &tmp_rkey);
-	if (ret)
-		goto rereg_phys_mr_exit1;
-
-	/* successful reregistration */
-	if (mr_rereg_mask & IB_MR_REREG_PD)
-		mr->pd = pd;
-	mr->lkey = tmp_lkey;
-	mr->rkey = tmp_rkey;
-
-rereg_phys_mr_exit1:
-	spin_unlock_irqrestore(&e_mr->mrlock, sl_flags);
-rereg_phys_mr_exit0:
-	if (ret)
-		ehca_err(mr->device, "ret=%i mr=%p mr_rereg_mask=%x pd=%p "
-			 "phys_buf_array=%p num_phys_buf=%x mr_access_flags=%x "
-			 "iova_start=%p",
-			 ret, mr, mr_rereg_mask, pd, phys_buf_array,
-			 num_phys_buf, mr_access_flags, iova_start);
-	return ret;
-} /* end ehca_rereg_phys_mr() */
-
 int ehca_dereg_mr(struct ib_mr *mr)
 {
 	int ret = 0;
@@ -1713,61 +1447,6 @@ ehca_dereg_internal_maxmr_exit0:
 
 /*----------------------------------------------------------------------*/
 
-/*
- * check physical buffer array of MR verbs for validness and
- * calculates MR size
- */
-int ehca_mr_chk_buf_and_calc_size(struct ib_phys_buf *phys_buf_array,
-				  int num_phys_buf,
-				  u64 *iova_start,
-				  u64 *size)
-{
-	struct ib_phys_buf *pbuf = phys_buf_array;
-	u64 size_count = 0;
-	u32 i;
-
-	if (num_phys_buf == 0) {
-		ehca_gen_err("bad phys buf array len, num_phys_buf=0");
-		return -EINVAL;
-	}
-	/* check first buffer */
-	if (((u64)iova_start & ~PAGE_MASK) != (pbuf->addr & ~PAGE_MASK)) {
-		ehca_gen_err("iova_start/addr mismatch, iova_start=%p "
-			     "pbuf->addr=%llx pbuf->size=%llx",
-			     iova_start, pbuf->addr, pbuf->size);
-		return -EINVAL;
-	}
-	if (((pbuf->addr + pbuf->size) % PAGE_SIZE) &&
-	    (num_phys_buf > 1)) {
-		ehca_gen_err("addr/size mismatch in 1st buf, pbuf->addr=%llx "
-			     "pbuf->size=%llx", pbuf->addr, pbuf->size);
-		return -EINVAL;
-	}
-
-	for (i = 0; i < num_phys_buf; i++) {
-		if ((i > 0) && (pbuf->addr % PAGE_SIZE)) {
-			ehca_gen_err("bad address, i=%x pbuf->addr=%llx "
-				     "pbuf->size=%llx",
-				     i, pbuf->addr, pbuf->size);
-			return -EINVAL;
-		}
-		if (((i > 0) &&	/* not 1st */
-		     (i < (num_phys_buf - 1)) &&	/* not last */
-		     (pbuf->size % PAGE_SIZE)) || (pbuf->size == 0)) {
-			ehca_gen_err("bad size, i=%x pbuf->size=%llx",
-				     i, pbuf->size);
-			return -EINVAL;
-		}
-		size_count += pbuf->size;
-		pbuf++;
-	}
-
-	*size = size_count;
-	return 0;
-} /* end ehca_mr_chk_buf_and_calc_size() */
-
-/*----------------------------------------------------------------------*/
-
 /* check page list of map FMR verb for validness */
 int ehca_fmr_check_page_list(struct ehca_mr *e_fmr,
 			     u64 *page_list,
diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.h b/drivers/staging/rdma/ehca/ehca_mrmw.h
index 50d8b51..52bfa95 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.h
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.h
@@ -98,11 +98,6 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 
 int ehca_dereg_internal_maxmr(struct ehca_shca *shca);
 
-int ehca_mr_chk_buf_and_calc_size(struct ib_phys_buf *phys_buf_array,
-				  int num_phys_buf,
-				  u64 *iova_start,
-				  u64 *size);
-
 int ehca_fmr_check_page_list(struct ehca_mr *e_fmr,
 			     u64 *page_list,
 			     int list_len);
diff --git a/drivers/staging/rdma/hfi1/mr.c b/drivers/staging/rdma/hfi1/mr.c
index 568f185..a3f8b88 100644
--- a/drivers/staging/rdma/hfi1/mr.c
+++ b/drivers/staging/rdma/hfi1/mr.c
@@ -167,10 +167,7 @@ static struct hfi1_mr *alloc_mr(int count, struct ib_pd *pd)
 	rval = init_mregion(&mr->mr, pd, count);
 	if (rval)
 		goto bail;
-	/*
-	 * ib_reg_phys_mr() will initialize mr->ibmr except for
-	 * lkey and rkey.
-	 */
+
 	rval = hfi1_alloc_lkey(&mr->mr, 0);
 	if (rval)
 		goto bail_mregion;
@@ -188,52 +185,6 @@ bail:
 }
 
 /**
- * hfi1_reg_phys_mr - register a physical memory region
- * @pd: protection domain for this memory region
- * @buffer_list: pointer to the list of physical buffers to register
- * @num_phys_buf: the number of physical buffers to register
- * @iova_start: the starting address passed over IB which maps to this MR
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_mr *hfi1_reg_phys_mr(struct ib_pd *pd,
-			       struct ib_phys_buf *buffer_list,
-			       int num_phys_buf, int acc, u64 *iova_start)
-{
-	struct hfi1_mr *mr;
-	int n, m, i;
-	struct ib_mr *ret;
-
-	mr = alloc_mr(num_phys_buf, pd);
-	if (IS_ERR(mr)) {
-		ret = (struct ib_mr *)mr;
-		goto bail;
-	}
-
-	mr->mr.user_base = *iova_start;
-	mr->mr.iova = *iova_start;
-	mr->mr.access_flags = acc;
-
-	m = 0;
-	n = 0;
-	for (i = 0; i < num_phys_buf; i++) {
-		mr->mr.map[m]->segs[n].vaddr = (void *) buffer_list[i].addr;
-		mr->mr.map[m]->segs[n].length = buffer_list[i].size;
-		mr->mr.length += buffer_list[i].size;
-		n++;
-		if (n == HFI1_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-
-	ret = &mr->ibmr;
-
-bail:
-	return ret;
-}
-
-/**
  * hfi1_reg_user_mr - register a userspace memory region
  * @pd: protection domain for this memory region
  * @start: starting userspace address
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index cb5b346..1b3d8d9 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2011,7 +2011,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->poll_cq = hfi1_poll_cq;
 	ibdev->req_notify_cq = hfi1_req_notify_cq;
 	ibdev->get_dma_mr = hfi1_get_dma_mr;
-	ibdev->reg_phys_mr = hfi1_reg_phys_mr;
 	ibdev->reg_user_mr = hfi1_reg_user_mr;
 	ibdev->dereg_mr = hfi1_dereg_mr;
 	ibdev->alloc_mr = hfi1_alloc_mr;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 041ad07..255792a 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -1012,10 +1012,6 @@ int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 
 struct ib_mr *hfi1_get_dma_mr(struct ib_pd *pd, int acc);
 
-struct ib_mr *hfi1_reg_phys_mr(struct ib_pd *pd,
-			       struct ib_phys_buf *buffer_list,
-			       int num_phys_buf, int acc, u64 *iova_start);
-
 struct ib_mr *hfi1_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			       u64 virt_addr, int mr_access_flags,
 			       struct ib_udata *udata);
diff --git a/drivers/staging/rdma/ipath/ipath_mr.c b/drivers/staging/rdma/ipath/ipath_mr.c
index c7278f6..b76b0ce 100644
--- a/drivers/staging/rdma/ipath/ipath_mr.c
+++ b/drivers/staging/rdma/ipath/ipath_mr.c
@@ -98,10 +98,6 @@ static struct ipath_mr *alloc_mr(int count,
 	}
 	mr->mr.mapsz = m;
 
-	/*
-	 * ib_reg_phys_mr() will initialize mr->ibmr except for
-	 * lkey and rkey.
-	 */
 	if (!ipath_alloc_lkey(lk_table, &mr->mr))
 		goto bail;
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mr.lkey;
@@ -121,57 +117,6 @@ done:
 }
 
 /**
- * ipath_reg_phys_mr - register a physical memory region
- * @pd: protection domain for this memory region
- * @buffer_list: pointer to the list of physical buffers to register
- * @num_phys_buf: the number of physical buffers to register
- * @iova_start: the starting address passed over IB which maps to this MR
- *
- * Returns the memory region on success, otherwise returns an errno.
- */
-struct ib_mr *ipath_reg_phys_mr(struct ib_pd *pd,
-				struct ib_phys_buf *buffer_list,
-				int num_phys_buf, int acc, u64 *iova_start)
-{
-	struct ipath_mr *mr;
-	int n, m, i;
-	struct ib_mr *ret;
-
-	mr = alloc_mr(num_phys_buf, &to_idev(pd->device)->lk_table);
-	if (mr == NULL) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	mr->mr.pd = pd;
-	mr->mr.user_base = *iova_start;
-	mr->mr.iova = *iova_start;
-	mr->mr.length = 0;
-	mr->mr.offset = 0;
-	mr->mr.access_flags = acc;
-	mr->mr.max_segs = num_phys_buf;
-	mr->umem = NULL;
-
-	m = 0;
-	n = 0;
-	for (i = 0; i < num_phys_buf; i++) {
-		mr->mr.map[m]->segs[n].vaddr = (void *) buffer_list[i].addr;
-		mr->mr.map[m]->segs[n].length = buffer_list[i].size;
-		mr->mr.length += buffer_list[i].size;
-		n++;
-		if (n == IPATH_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-
-	ret = &mr->ibmr;
-
-bail:
-	return ret;
-}
-
-/**
  * ipath_reg_user_mr - register a userspace memory region
  * @pd: protection domain for this memory region
  * @start: starting userspace address
diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/staging/rdma/ipath/ipath_verbs.c
index 7ab1520..02d8834 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.c
+++ b/drivers/staging/rdma/ipath/ipath_verbs.c
@@ -2149,7 +2149,6 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->poll_cq = ipath_poll_cq;
 	dev->req_notify_cq = ipath_req_notify_cq;
 	dev->get_dma_mr = ipath_get_dma_mr;
-	dev->reg_phys_mr = ipath_reg_phys_mr;
 	dev->reg_user_mr = ipath_reg_user_mr;
 	dev->dereg_mr = ipath_dereg_mr;
 	dev->alloc_fmr = ipath_alloc_fmr;
diff --git a/drivers/staging/rdma/ipath/ipath_verbs.h b/drivers/staging/rdma/ipath/ipath_verbs.h
index 0a90a56..6c70a89 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.h
+++ b/drivers/staging/rdma/ipath/ipath_verbs.h
@@ -828,10 +828,6 @@ int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 
 struct ib_mr *ipath_get_dma_mr(struct ib_pd *pd, int acc);
 
-struct ib_mr *ipath_reg_phys_mr(struct ib_pd *pd,
-				struct ib_phys_buf *buffer_list,
-				int num_phys_buf, int acc, u64 *iova_start);
-
 struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				u64 virt_addr, int mr_access_flags,
 				struct ib_udata *udata);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 83d6ee8..a3402af 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1165,6 +1165,10 @@ struct ib_phys_buf {
 	u64      size;
 };
 
+/*
+ * XXX: these are apparently used for ->rereg_user_mr, no idea why they
+ * are hidden here instead of a uapi header!
+ */
 enum ib_mr_rereg_flags {
 	IB_MR_REREG_TRANS	= 1,
 	IB_MR_REREG_PD		= (1<<1),
@@ -1683,11 +1687,6 @@ struct ib_device {
 						      int wc_cnt);
 	struct ib_mr *             (*get_dma_mr)(struct ib_pd *pd,
 						 int mr_access_flags);
-	struct ib_mr *             (*reg_phys_mr)(struct ib_pd *pd,
-						  struct ib_phys_buf *phys_buf_array,
-						  int num_phys_buf,
-						  int mr_access_flags,
-						  u64 *iova_start);
 	struct ib_mr *             (*reg_user_mr)(struct ib_pd *pd,
 						  u64 start, u64 length,
 						  u64 virt_addr,
@@ -1707,13 +1706,6 @@ struct ib_device {
 	int                        (*map_mr_sg)(struct ib_mr *mr,
 						struct scatterlist *sg,
 						int sg_nents);
-	int                        (*rereg_phys_mr)(struct ib_mr *mr,
-						    int mr_rereg_mask,
-						    struct ib_pd *pd,
-						    struct ib_phys_buf *phys_buf_array,
-						    int num_phys_buf,
-						    int mr_access_flags,
-						    u64 *iova_start);
 	struct ib_mw *             (*alloc_mw)(struct ib_pd *pd,
 					       enum ib_mw_type type);
 	int                        (*bind_mw)(struct ib_qp *qp,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
