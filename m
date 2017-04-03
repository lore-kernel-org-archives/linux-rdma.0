From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 01/10] IB: Replace ib_umem page_size by page_shift
Date: Mon,  3 Apr 2017 13:06:31 +0300
Message-ID: <20170403100640.3332-2-leon@kernel.org>
References: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Size of pages are held by struct ib_umem in page_size field.

It is better to store it as an exponent, because page size by nature
is always power-of-two and used as a factor, divisor or ilog2's argument.

The conversion of page_size to be page_shift allows to have portable
code and avoid following error while compiling on ARM:

  ERROR: "__aeabi_uldivmod" [drivers/infiniband/core/ib_core.ko] undefined!

CC: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
CC: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
CC: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
CC: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/umem.c                 | 15 ++++++---------
 drivers/infiniband/core/umem_odp.c             | 12 ++++++------
 drivers/infiniband/hw/bnxt_re/ib_verbs.c       | 12 ++++++------
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |  4 ++--
 drivers/infiniband/hw/cxgb4/mem.c              |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_cq.c        |  3 +--
 drivers/infiniband/hw/hns/hns_roce_mr.c        |  9 +++++----
 drivers/infiniband/hw/hns/hns_roce_qp.c        |  3 +--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      |  7 ++++---
 drivers/infiniband/hw/mlx4/cq.c                |  2 +-
 drivers/infiniband/hw/mlx4/mr.c                |  6 +++---
 drivers/infiniband/hw/mlx4/qp.c                |  2 +-
 drivers/infiniband/hw/mlx4/srq.c               |  2 +-
 drivers/infiniband/hw/mlx5/mem.c               |  4 ++--
 drivers/infiniband/hw/mlx5/odp.c               |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |  5 ++---
 drivers/infiniband/hw/nes/nes_verbs.c          |  4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    | 15 ++++++---------
 drivers/infiniband/hw/qedr/verbs.c             |  8 ++++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c |  2 +-
 drivers/infiniband/sw/rdmavt/mr.c              |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_mr.c             |  8 +++-----
 include/rdma/ib_umem.h                         |  4 ++--
 23 files changed, 66 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 27f155d2df8d..6b87c051ffd4 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -115,11 +115,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (!umem)
 		return ERR_PTR(-ENOMEM);

-	umem->context   = context;
-	umem->length    = size;
-	umem->address   = addr;
-	umem->page_size = PAGE_SIZE;
-	umem->pid       = get_task_pid(current, PIDTYPE_PID);
+	umem->context    = context;
+	umem->length     = size;
+	umem->address    = addr;
+	umem->page_shift = PAGE_SHIFT;
+	umem->pid	 = get_task_pid(current, PIDTYPE_PID);
 	/*
 	 * We ask for writable memory if any of the following
 	 * access flags are set.  "Local write" and "remote write"
@@ -315,7 +315,6 @@ EXPORT_SYMBOL(ib_umem_release);

 int ib_umem_page_count(struct ib_umem *umem)
 {
-	int shift;
 	int i;
 	int n;
 	struct scatterlist *sg;
@@ -323,11 +322,9 @@ int ib_umem_page_count(struct ib_umem *umem)
 	if (umem->odp_data)
 		return ib_umem_num_pages(umem);

-	shift = ilog2(umem->page_size);
-
 	n = 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, i)
-		n += sg_dma_len(sg) >> shift;
+		n += sg_dma_len(sg) >> umem->page_shift;

 	return n;
 }
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index cb2742b548bb..8ee30163497d 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -254,11 +254,11 @@ struct ib_umem *ib_alloc_odp_umem(struct ib_ucontext *context,
 	if (!umem)
 		return ERR_PTR(-ENOMEM);

-	umem->context   = context;
-	umem->length    = size;
-	umem->address   = addr;
-	umem->page_size = PAGE_SIZE;
-	umem->writable  = 1;
+	umem->context    = context;
+	umem->length     = size;
+	umem->address    = addr;
+	umem->page_shift = PAGE_SHIFT;
+	umem->writable   = 1;

 	odp_data = kzalloc(sizeof(*odp_data), GFP_KERNEL);
 	if (!odp_data) {
@@ -707,7 +707,7 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 	 * invalidations, so we must make sure we free each page only
 	 * once. */
 	mutex_lock(&umem->odp_data->umem_mutex);
-	for (addr = virt; addr < bound; addr += (u64)umem->page_size) {
+	for (addr = virt; addr < bound; addr += BIT(umem->page_shift)) {
 		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
 		if (umem->odp_data->page_list[idx]) {
 			struct page *page = umem->odp_data->page_list[idx];
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 33af2e3de399..a4edb44f03bb 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3016,7 +3016,7 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	struct bnxt_re_mr *mr;
 	struct ib_umem *umem;
 	u64 *pbl_tbl, *pbl_tbl_orig;
-	int i, umem_pgs, pages, page_shift, rc;
+	int i, umem_pgs, pages, rc;
 	struct scatterlist *sg;
 	int entry;

@@ -3062,22 +3062,22 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	}
 	pbl_tbl_orig = pbl_tbl;

-	page_shift = ilog2(umem->page_size);
 	if (umem->hugetlb) {
 		dev_err(rdev_to_dev(rdev), "umem hugetlb not supported!");
 		rc = -EFAULT;
 		goto fail;
 	}
-	if (umem->page_size != PAGE_SIZE) {
-		dev_err(rdev_to_dev(rdev), "umem page size unsupported!");
+
+	if (umem->page_shift != PAGE_SHIFT) {
+		dev_err(rdev_to_dev(rdev), "umem page shift unsupported!");
 		rc = -EFAULT;
 		goto fail;
 	}
 	/* Map umem buf ptrs to the PBL */
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-		pages = sg_dma_len(sg) >> page_shift;
+		pages = sg_dma_len(sg) >> umem->page_shift;
 		for (i = 0; i < pages; i++, pbl_tbl++)
-			*pbl_tbl = sg_dma_address(sg) + (i << page_shift);
+			*pbl_tbl = sg_dma_address(sg) + (i << umem->page_shift);
 	}
 	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, pbl_tbl_orig,
 			       umem_pgs, false);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 86ecd3ea6a4b..0a7568aea009 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -584,7 +584,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(err);
 	}

-	shift = ffs(mhp->umem->page_size) - 1;
+	shift = mhp->umem->page_shift;

 	n = mhp->umem->nmap;

@@ -604,7 +604,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			len = sg_dma_len(sg) >> shift;
 			for (k = 0; k < len; ++k) {
 				pages[i++] = cpu_to_be64(sg_dma_address(sg) +
-					mhp->umem->page_size * k);
+							 (k << shift));
 				if (i == PAGE_SIZE / sizeof *pages) {
 					err = iwch_write_pbl(mhp, pages, i, n);
 					if (err)
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 410408f886c1..89b9acd37109 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -517,7 +517,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(err);
 	}

-	shift = ffs(mhp->umem->page_size) - 1;
+	shift = mhp->umem->page_shift;

 	n = mhp->umem->nmap;
 	err = alloc_pbl(mhp, n);
@@ -536,7 +536,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		len = sg_dma_len(sg) >> shift;
 		for (k = 0; k < len; ++k) {
 			pages[i++] = cpu_to_be64(sg_dma_address(sg) +
-				mhp->umem->page_size * k);
+						 (k << shift));
 			if (i == PAGE_SIZE / sizeof *pages) {
 				err = write_pbl(&mhp->rhp->rdev,
 				      pages,
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 589496c8fb9e..b89fd711019e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -219,8 +219,7 @@ static int hns_roce_ib_get_cq_umem(struct hns_roce_dev *hr_dev,
 		return PTR_ERR(*umem);

 	ret = hns_roce_mtt_init(hr_dev, ib_umem_page_count(*umem),
-				ilog2((unsigned int)(*umem)->page_size),
-				&buf->hr_mtt);
+				(*umem)->page_shift, &buf->hr_mtt);
 	if (ret)
 		goto err_buf;

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 4139abee3b54..024a81529281 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -503,7 +503,8 @@ int hns_roce_ib_umem_write_mtt(struct hns_roce_dev *hr_dev,
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
 		len = sg_dma_len(sg) >> mtt->page_shift;
 		for (k = 0; k < len; ++k) {
-			pages[i++] = sg_dma_address(sg) + umem->page_size * k;
+			pages[i++] = sg_dma_address(sg) +
+				(k << umem->page_shift);
 			if (i == PAGE_SIZE / sizeof(u64)) {
 				ret = hns_roce_write_mtt(hr_dev, mtt, n, i,
 							 pages);
@@ -563,9 +564,9 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}

 	n = ib_umem_page_count(mr->umem);
-	if (mr->umem->page_size != HNS_ROCE_HEM_PAGE_SIZE) {
-		dev_err(dev, "Just support 4K page size but is 0x%x now!\n",
-			mr->umem->page_size);
+	if (mr->umem->page_shift != HNS_ROCE_HEM_PAGE_SHIFT) {
+		dev_err(dev, "Just support 4K page size but is 0x%lx now!\n",
+			BIT(mr->umem->page_shift));
 		ret = -EINVAL;
 		goto err_umem;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 3f44f2f91f03..054c52699090 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -437,8 +437,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 		}

 		ret = hns_roce_mtt_init(hr_dev, ib_umem_page_count(hr_qp->umem),
-				    ilog2((unsigned int)hr_qp->umem->page_size),
-				    &hr_qp->mtt);
+					hr_qp->umem->page_shift, &hr_qp->mtt);
 		if (ret) {
 			dev_err(dev, "hns_roce_mtt_init error for create qp\n");
 			goto err_buf;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 9b2849979756..fb3a4ca354be 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1354,14 +1354,15 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr *iwmr,

 	pinfo = (level == I40IW_LEVEL_1) ? NULL : palloc->level2.leaf;

-	pg_shift = ffs(region->page_size) - 1;
+	pg_shift = region->page_shift;
 	for_each_sg(region->sg_head.sgl, sg, region->nmap, entry) {
 		chunk_pages = sg_dma_len(sg) >> pg_shift;
 		if ((iwmr->type == IW_MEMREG_TYPE_QP) &&
 		    !iwpbl->qp_mr.sq_page)
 			iwpbl->qp_mr.sq_page = sg_page(sg);
 		for (i = 0; i < chunk_pages; i++) {
-			pg_addr = sg_dma_address(sg) + region->page_size * i;
+			pg_addr = sg_dma_address(sg) +
+				(i << region->page_shift);

 			if ((entry + i) == 0)
 				*pbl = cpu_to_le64(pg_addr & iwmr->page_msk);
@@ -1847,7 +1848,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	iwmr->ibmr.device = pd->device;
 	ucontext = to_ucontext(pd->uobject->context);

-	iwmr->page_size = region->page_size;
+	iwmr->page_size = PAGE_SIZE;
 	iwmr->page_msk = PAGE_MASK;

 	if (region->hugetlb && (req.reg_type == IW_MEMREG_TYPE_MEM))
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 6a0fec357dae..4f5a143fc0a7 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -147,7 +147,7 @@ static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_ucontext *cont
 		return PTR_ERR(*umem);

 	err = mlx4_mtt_init(dev->dev, ib_umem_page_count(*umem),
-			    ilog2((*umem)->page_size), &buf->mtt);
+			    (*umem)->page_shift, &buf->mtt);
 	if (err)
 		goto err_buf;

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 433bcdbdd680..e6f77f63da75 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -107,7 +107,7 @@ int mlx4_ib_umem_write_mtt(struct mlx4_ib_dev *dev, struct mlx4_mtt *mtt,
 		len = sg_dma_len(sg) >> mtt->page_shift;
 		for (k = 0; k < len; ++k) {
 			pages[i++] = sg_dma_address(sg) +
-				umem->page_size * k;
+				(k << umem->page_shift);
 			/*
 			 * Be friendly to mlx4_write_mtt() and
 			 * pass it chunks of appropriate size.
@@ -155,7 +155,7 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}

 	n = ib_umem_page_count(mr->umem);
-	shift = ilog2(mr->umem->page_size);
+	shift = mr->umem->page_shift;

 	err = mlx4_mr_alloc(dev->dev, to_mpd(pd)->pdn, virt_addr, length,
 			    convert_access(access_flags), n, shift, &mr->mmr);
@@ -239,7 +239,7 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,
 			goto release_mpt_entry;
 		}
 		n = ib_umem_page_count(mmr->umem);
-		shift = ilog2(mmr->umem->page_size);
+		shift = mmr->umem->page_shift;

 		err = mlx4_mr_rereg_mem_write(dev->dev, &mmr->mmr,
 					      virt_addr, length, n, shift,
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c34eebc7db65..8f382318f888 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -745,7 +745,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		}

 		err = mlx4_mtt_init(dev->dev, ib_umem_page_count(qp->umem),
-				    ilog2(qp->umem->page_size), &qp->mtt);
+				    qp->umem->page_shift, &qp->mtt);
 		if (err)
 			goto err_buf;

diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 7dd3f267f06b..e32dd58937a8 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -122,7 +122,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		}

 		err = mlx4_mtt_init(dev->dev, ib_umem_page_count(srq->umem),
-				    ilog2(srq->umem->page_size), &srq->mtt);
+				    srq->umem->page_shift, &srq->mtt);
 		if (err)
 			goto err_buf;

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 778d8a18925f..a0c2af964249 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -59,7 +59,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
 	u64 pfn;
 	struct scatterlist *sg;
 	int entry;
-	unsigned long page_shift = ilog2(umem->page_size);
+	unsigned long page_shift = umem->page_shift;

 	/* With ODP we must always match OS page size. */
 	if (umem->odp_data) {
@@ -156,7 +156,7 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 			    int page_shift, size_t offset, size_t num_pages,
 			    __be64 *pas, int access_flags)
 {
-	unsigned long umem_page_shift = ilog2(umem->page_size);
+	unsigned long umem_page_shift = umem->page_shift;
 	int shift = page_shift - umem_page_shift;
 	int mask = (1 << shift) - 1;
 	int i, k, idx;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d7b12f0750e2..3bfa3a9c3be0 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -206,7 +206,7 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
 	 * but they will write 0s as well, so no difference in the end result.
 	 */

-	for (addr = start; addr < end; addr += (u64)umem->page_size) {
+	for (addr = start; addr < end; addr += BIT(umem->page_shift)) {
 		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
 		/*
 		 * Strive to write the MTTs in chunks, but avoid overwriting
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 22d0e6ee5af6..e1b8940558d2 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -937,7 +937,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err;
 	}

-	shift = ffs(mr->umem->page_size) - 1;
+	shift = mr->umem->page_shift;
 	n = mr->umem->nmap;

 	mr->mtt = mthca_alloc_mtt(dev, n);
@@ -959,8 +959,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	for_each_sg(mr->umem->sg_head.sgl, sg, mr->umem->nmap, entry) {
 		len = sg_dma_len(sg) >> shift;
 		for (k = 0; k < len; ++k) {
-			pages[i++] = sg_dma_address(sg) +
-				mr->umem->page_size * k;
+			pages[i++] = sg_dma_address(sg) + (k << shift);
 			/*
 			 * Be friendly to write_mtt and pass it chunks
 			 * of appropriate size.
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index ccf0a4cffe9c..11f7c308c7ad 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2165,9 +2165,9 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}

 	nes_debug(NES_DBG_MR, "User base = 0x%lX, Virt base = 0x%lX, length = %u,"
-			" offset = %u, page size = %u.\n",
+			" offset = %u, page size = %lu.\n",
 			(unsigned long int)start, (unsigned long int)virt, (u32)length,
-			ib_umem_offset(region), region->page_size);
+			ib_umem_offset(region), BIT(region->page_shift));

 	skip_pages = ((u32)ib_umem_offset(region)) >> 12;

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index bc9fb144e57b..e6c65852797d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -914,21 +914,18 @@ static void build_user_pbes(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
 	pbe = (struct ocrdma_pbe *)pbl_tbl->va;
 	pbe_cnt = 0;

-	shift = ilog2(umem->page_size);
+	shift = umem->page_shift;

 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
 		pages = sg_dma_len(sg) >> shift;
 		for (pg_cnt = 0; pg_cnt < pages; pg_cnt++) {
 			/* store the page address in pbe */
 			pbe->pa_lo =
-			    cpu_to_le32(sg_dma_address
-					(sg) +
-					(umem->page_size * pg_cnt));
+			    cpu_to_le32(sg_dma_address(sg) +
+					(pg_cnt << shift));
 			pbe->pa_hi =
-			    cpu_to_le32(upper_32_bits
-					((sg_dma_address
-					  (sg) +
-					  umem->page_size * pg_cnt)));
+			    cpu_to_le32(upper_32_bits(sg_dma_address(sg) +
+					 (pg_cnt << shift)));
 			pbe_cnt += 1;
 			total_num_pbes += 1;
 			pbe++;
@@ -978,7 +975,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	if (status)
 		goto umem_err;

-	mr->hwmr.pbe_size = mr->umem->page_size;
+	mr->hwmr.pbe_size = BIT(mr->umem->page_shift);
 	mr->hwmr.fbo = ib_umem_offset(mr->umem);
 	mr->hwmr.va = usr_addr;
 	mr->hwmr.len = len;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 6b3bb32803bd..e741cc662606 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -680,16 +680,16 @@ static void qedr_populate_pbls(struct qedr_dev *dev, struct ib_umem *umem,

 	pbe_cnt = 0;

-	shift = ilog2(umem->page_size);
+	shift = umem->page_shift;

 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
 		pages = sg_dma_len(sg) >> shift;
 		for (pg_cnt = 0; pg_cnt < pages; pg_cnt++) {
 			/* store the page address in pbe */
 			pbe->lo = cpu_to_le32(sg_dma_address(sg) +
-					      umem->page_size * pg_cnt);
+					      (pg_cnt << shift));
 			addr = upper_32_bits(sg_dma_address(sg) +
-					     umem->page_size * pg_cnt);
+					     (pg_cnt << shift));
 			pbe->hi = cpu_to_le32(addr);
 			pbe_cnt++;
 			total_num_pbes++;
@@ -2189,7 +2189,7 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	mr->hw_mr.pbl_ptr = mr->info.pbl_table[0].pa;
 	mr->hw_mr.pbl_two_level = mr->info.pbl_info.two_layered;
 	mr->hw_mr.pbl_page_size_log = ilog2(mr->info.pbl_info.pbl_size);
-	mr->hw_mr.page_size_log = ilog2(mr->umem->page_size);
+	mr->hw_mr.page_size_log = mr->umem->page_shift;
 	mr->hw_mr.fbo = ib_umem_offset(mr->umem);
 	mr->hw_mr.length = len;
 	mr->hw_mr.vaddr = usr_addr;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
index 948b5ccd2a70..6ef4df6c8c4a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
@@ -194,7 +194,7 @@ int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
 		len = sg_dma_len(sg) >> PAGE_SHIFT;
 		for (j = 0; j < len; j++) {
 			dma_addr_t addr = sg_dma_address(sg) +
-					  umem->page_size * j;
+					  (j << umem->page_shift);

 			ret = pvrdma_page_dir_insert_dma(pdir, i, addr);
 			if (ret)
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index ae30b6838d79..4e989e1caa40 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -405,8 +405,7 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->mr.access_flags = mr_access_flags;
 	mr->umem = umem;

-	if (is_power_of_2(umem->page_size))
-		mr->mr.page_shift = ilog2(umem->page_size);
+	mr->mr.page_shift = umem->page_shift;
 	m = 0;
 	n = 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
@@ -418,8 +417,9 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			goto bail_inval;
 		}
 		mr->mr.map[m]->segs[n].vaddr = vaddr;
-		mr->mr.map[m]->segs[n].length = umem->page_size;
-		trace_rvt_mr_user_seg(&mr->mr, m, n, vaddr, umem->page_size);
+		mr->mr.map[m]->segs[n].length = BIT(umem->page_shift);
+		trace_rvt_mr_user_seg(&mr->mr, m, n, vaddr,
+				      BIT(umem->page_shift));
 		n++;
 		if (n == RVT_SEGSZ) {
 			m++;
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 37eea7441ca4..251058b3403c 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -191,10 +191,8 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 		goto err1;
 	}

-	WARN_ON_ONCE(!is_power_of_2(umem->page_size));
-
-	mem->page_shift		= ilog2(umem->page_size);
-	mem->page_mask		= umem->page_size - 1;
+	mem->page_shift		= umem->page_shift;
+	mem->page_mask		= BIT(umem->page_shift) - 1;

 	num_buf			= 0;
 	map			= mem->map;
@@ -210,7 +208,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 			}

 			buf->addr = (uintptr_t)vaddr;
-			buf->size = umem->page_size;
+			buf->size = BIT(umem->page_shift);
 			num_buf++;
 			buf++;

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2d83cfd7e6ce..7f4af1e1ae64 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -44,7 +44,7 @@ struct ib_umem {
 	struct ib_ucontext     *context;
 	size_t			length;
 	unsigned long		address;
-	int			page_size;
+	int			page_shift;
 	int                     writable;
 	int                     hugetlb;
 	struct work_struct	work;
@@ -60,7 +60,7 @@ struct ib_umem {
 /* Returns the offset of the umem start relative to the first page. */
 static inline int ib_umem_offset(struct ib_umem *umem)
 {
-	return umem->address & ((unsigned long)umem->page_size - 1);
+	return umem->address & (BIT(umem->page_shift) - 1);
 }

 /* Returns the first page of an ODP umem. */
--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
