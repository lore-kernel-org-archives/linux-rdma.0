From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/umem: Drop hugetlb variable and VMA allocation
Date: Sun, 19 Mar 2017 10:55:56 +0200
Message-ID: <20170319085557.6023-3-leon@kernel.org>
References: <20170319085557.6023-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170319085557.6023-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IB umem structure has field hugetlb which was assigned, but except
i40iw driver, it was actually never used.

This patch drops that variable out of the struct ib_umem, removes
all writes to it, get rids of VMA allocation which wasn't used and
removes check hugetlb from i40iw driver, because it is checked anyway in
i40iw_set_hugetlb_values() routine.

CC: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/umem.c            | 23 ++---------------------
 drivers/infiniband/core/umem_odp.c        |  1 -
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  6 +-----
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c  |  1 -
 include/rdma/ib_umem.h                    |  1 -
 6 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 27f155d2df8d..6455256533df 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -37,7 +37,6 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/export.h>
-#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <rdma/ib_umem_odp.h>
 
@@ -85,7 +84,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 {
 	struct ib_umem *umem;
 	struct page **page_list;
-	struct vm_area_struct **vma_list;
 	unsigned long locked;
 	unsigned long lock_limit;
 	unsigned long cur_base;
@@ -143,9 +141,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	umem->odp_data = NULL;
 
-	/* We assume the memory is from hugetlb until proved otherwise */
-	umem->hugetlb   = 1;
-
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list) {
 		put_pid(umem->pid);
@@ -153,14 +148,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/*
-	 * if we can't alloc the vma_list, it's not so bad;
-	 * just assume the memory is not hugetlb memory
-	 */
-	vma_list = (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
-	if (!vma_list)
-		umem->hugetlb = 0;
-
 	npages = ib_umem_num_pages(umem);
 
 	down_write(&current->mm->mmap_sem);
@@ -194,7 +181,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		ret = get_user_pages(cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
-				     gup_flags, page_list, vma_list);
+				     gup_flags, page_list, NULL);
 
 		if (ret < 0)
 			goto out;
@@ -203,12 +190,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		cur_base += ret * PAGE_SIZE;
 		npages   -= ret;
 
-		for_each_sg(sg_list_start, sg, ret, i) {
-			if (vma_list && !is_vm_hugetlb_page(vma_list[i]))
-				umem->hugetlb = 0;
-
+		for_each_sg(sg_list_start, sg, ret, i)
 			sg_set_page(sg, page_list[i], PAGE_SIZE, 0);
-		}
 
 		/* preparing for next loop */
 		sg_list_start = sg;
@@ -237,8 +220,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		current->mm->pinned_vm = locked;
 
 	up_write(&current->mm->mmap_sem);
-	if (vma_list)
-		free_page((unsigned long) vma_list);
 	free_page((unsigned long) page_list);
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index cb2742b548bb..2d7b90b63ba0 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -325,7 +325,6 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 		goto out_mm;
 	}
 
-	umem->hugetlb = 0;
 	umem->odp_data = kzalloc(sizeof(*umem->odp_data), GFP_KERNEL);
 	if (!umem->odp_data) {
 		ret_val = -ENOMEM;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 33af2e3de399..60c86fe5a5a4 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3063,16 +3063,12 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	pbl_tbl_orig = pbl_tbl;
 
 	page_shift = ilog2(umem->page_size);
-	if (umem->hugetlb) {
-		dev_err(rdev_to_dev(rdev), "umem hugetlb not supported!");
-		rc = -EFAULT;
-		goto fail;
-	}
 	if (umem->page_size != PAGE_SIZE) {
 		dev_err(rdev_to_dev(rdev), "umem page size unsupported!");
 		rc = -EFAULT;
 		goto fail;
 	}
+
 	/* Map umem buf ptrs to the PBL */
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
 		pages = sg_dma_len(sg) >> page_shift;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 9b2849979756..59c8d74e3704 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1850,7 +1850,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	iwmr->page_size = region->page_size;
 	iwmr->page_msk = PAGE_MASK;
 
-	if (region->hugetlb && (req.reg_type == IW_MEMREG_TYPE_MEM))
+	if (req.reg_type == IW_MEMREG_TYPE_MEM)
 		i40iw_set_hugetlb_values(start, iwmr);
 
 	region_length = region->length + (start & (iwmr->page_size - 1));
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c49db7c33979..f836f35f87ab 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -36,7 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
-#include <linux/hugetlb.h>
 #include <linux/iommu.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2d83cfd7e6ce..3d06d25a33ac 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -46,7 +46,6 @@ struct ib_umem {
 	unsigned long		address;
 	int			page_size;
 	int                     writable;
-	int                     hugetlb;
 	struct work_struct	work;
 	struct pid             *pid;
 	struct mm_struct       *mm;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
