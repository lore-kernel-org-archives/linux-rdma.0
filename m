From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Add 2MB page support
Date: Wed, 30 Nov 2016 14:57:40 -0600
Message-ID: <20161130205740.13812-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support to allow each independent memory region to
be configured for 2MB page size in addition to 4KB
page size.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 59 +++++++++++++++++++++++++------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h |  2 ++
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 59f613b..a563e1c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -37,6 +37,7 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
+#include <linux/hugetlb.h>
 #include <asm/byteorder.h>
 #include <net/ip.h>
 #include <rdma/ib_verbs.h>
@@ -1307,13 +1308,11 @@ static u32 i40iw_create_stag(struct i40iw_device *iwdev)
 
 /**
  * i40iw_next_pbl_addr - Get next pbl address
- * @palloc: Poiner to allocated pbles
  * @pbl: pointer to a pble
  * @pinfo: info pointer
  * @idx: index
  */
-static inline u64 *i40iw_next_pbl_addr(struct i40iw_pble_alloc *palloc,
-				       u64 *pbl,
+static inline u64 *i40iw_next_pbl_addr(u64 *pbl,
 				       struct i40iw_pble_info **pinfo,
 				       u32 *idx)
 {
@@ -1341,9 +1340,11 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr *iwmr,
 	struct i40iw_pble_alloc *palloc = &iwpbl->pble_alloc;
 	struct i40iw_pble_info *pinfo;
 	struct scatterlist *sg;
+	u64 pg_addr = 0;
 	u32 idx = 0;
 
 	pinfo = (level == I40IW_LEVEL_1) ? NULL : palloc->level2.leaf;
+
 	pg_shift = ffs(region->page_size) - 1;
 	for_each_sg(region->sg_head.sgl, sg, region->nmap, entry) {
 		chunk_pages = sg_dma_len(sg) >> pg_shift;
@@ -1351,8 +1352,35 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr *iwmr,
 		    !iwpbl->qp_mr.sq_page)
 			iwpbl->qp_mr.sq_page = sg_page(sg);
 		for (i = 0; i < chunk_pages; i++) {
-			*pbl = cpu_to_le64(sg_dma_address(sg) + region->page_size * i);
-			pbl = i40iw_next_pbl_addr(palloc, pbl, &pinfo, &idx);
+			pg_addr = sg_dma_address(sg) + region->page_size * i;
+
+			if ((entry + i) == 0)
+				*pbl = cpu_to_le64(pg_addr & iwmr->page_msk);
+			else if (!(pg_addr & ~iwmr->page_msk))
+				*pbl = cpu_to_le64(pg_addr);
+			else
+				continue;
+			pbl = i40iw_next_pbl_addr(pbl, &pinfo, &idx);
+		}
+	}
+}
+
+/**
+ * i40iw_set_hugetlb_params - set MR pg size and mask to huge pg values.
+ * @addr: virtual address
+ * @iwmr: mr pointer for this memory registration
+ */
+static void i40iw_set_hugetlb_values(u64 addr, struct i40iw_mr *iwmr)
+{
+	struct vm_area_struct *vma;
+	struct hstate *h;
+
+	vma = find_vma(current->mm, addr);
+	if (vma && is_vm_hugetlb_page(vma)) {
+		h = hstate_vma(vma);
+		if (huge_page_size(h) == 0x200000) {
+			iwmr->page_size = huge_page_size(h);
+			iwmr->page_msk = huge_page_mask(h);
 		}
 	}
 }
@@ -1473,7 +1501,7 @@ static int i40iw_handle_q_mem(struct i40iw_device *iwdev,
 	bool ret = true;
 
 	total = req->sq_pages + req->rq_pages + req->cq_pages;
-	pg_size = iwmr->region->page_size;
+	pg_size = iwmr->page_size;
 
 	err = i40iw_setup_pbles(iwdev, iwmr, use_pbles);
 	if (err)
@@ -1722,6 +1750,7 @@ static int i40iw_hwreg_mr(struct i40iw_device *iwdev,
 	stag_info->access_rights = access;
 	stag_info->pd_id = iwpd->sc_pd.pd_id;
 	stag_info->addr_type = I40IW_ADDR_TYPE_VA_BASED;
+	stag_info->page_size = iwmr->page_size;
 
 	if (iwpbl->pbl_allocated) {
 		if (palloc->level == I40IW_LEVEL_1) {
@@ -1780,6 +1809,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	unsigned long flags;
 	int err = -ENOSYS;
 	int ret;
+	int pg_shift;
 
 	if (length > I40IW_MAX_MR_SIZE)
 		return ERR_PTR(-EINVAL);
@@ -1804,9 +1834,17 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	iwmr->ibmr.pd = pd;
 	iwmr->ibmr.device = pd->device;
 	ucontext = to_ucontext(pd->uobject->context);
-	region_length = region->length + (start & 0xfff);
-	pbl_depth = region_length >> 12;
-	pbl_depth += (region_length & (4096 - 1)) ? 1 : 0;
+
+	iwmr->page_size = region->page_size;
+	iwmr->page_msk = PAGE_MASK;
+
+	if (region->hugetlb && (req.reg_type == IW_MEMREG_TYPE_MEM))
+		i40iw_set_hugetlb_values(start, iwmr);
+
+	region_length = region->length + (start & (iwmr->page_size - 1));
+	pg_shift = ffs(iwmr->page_size) - 1;
+	pbl_depth = region_length >> pg_shift;
+	pbl_depth += (region_length & (iwmr->page_size - 1)) ? 1 : 0;
 	iwmr->length = region->length;
 
 	iwpbl->user_base = virt;
@@ -1844,7 +1882,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 			goto error;
 
 		if (use_pbles) {
-			ret = i40iw_check_mr_contiguous(palloc, region->page_size);
+			ret = i40iw_check_mr_contiguous(palloc, iwmr->page_size);
 			if (ret) {
 				i40iw_free_pble(iwdev->pble_rsrc, palloc);
 				iwpbl->pbl_allocated = false;
@@ -1867,6 +1905,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 			i40iw_free_stag(iwdev, stag);
 			goto error;
 		}
+
 		break;
 	default:
 		goto error;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.h b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
index 0069be8..6549c93 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
@@ -92,6 +92,8 @@ struct i40iw_mr {
 	struct ib_umem *region;
 	u16 type;
 	u32 page_cnt;
+	u32 page_size;
+	u64 page_msk;
 	u32 npages;
 	u32 stag;
 	u64 length;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
