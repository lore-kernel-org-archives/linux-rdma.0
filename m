From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Utilize physically mapped memory regions
Date: Wed, 30 Nov 2016 14:56:14 -0600
Message-ID: <20161130205614.11224-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support to use physically mapped WQ's and MR's if determined
that the OS registered user-memory for the region is physically
contiguous. This feature will eliminate the need for unnecessarily
setting up and using PBL's when not required.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 102 +++++++++++++++++++++++++++---
 1 file changed, 93 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 462f5a7..59f613b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1358,10 +1358,62 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr *iwmr,
 }
 
 /**
+ * i40iw_check_mem_contiguous - check if pbls stored in arr are contiguous
+ * @arr: lvl1 pbl array
+ * @npages: page count
+ * pg_size: page size
+ *
+ */
+static bool i40iw_check_mem_contiguous(u64 *arr, u32 npages, u32 pg_size)
+{
+	u32 pg_idx;
+
+	for (pg_idx = 0; pg_idx < npages; pg_idx++) {
+		if ((*arr + (pg_size * pg_idx)) != arr[pg_idx])
+			return false;
+	}
+	return true;
+}
+
+/**
+ * i40iw_check_mr_contiguous - check if MR is physically contiguous
+ * @palloc: pbl allocation struct
+ * pg_size: page size
+ */
+static bool i40iw_check_mr_contiguous(struct i40iw_pble_alloc *palloc, u32 pg_size)
+{
+	struct i40iw_pble_level2 *lvl2 = &palloc->level2;
+	struct i40iw_pble_info *leaf = lvl2->leaf;
+	u64 *arr = NULL;
+	u64 *start_addr = NULL;
+	int i;
+	bool ret;
+
+	if (palloc->level == I40IW_LEVEL_1) {
+		arr = (u64 *)palloc->level1.addr;
+		ret = i40iw_check_mem_contiguous(arr, palloc->total_cnt, pg_size);
+		return ret;
+	}
+
+	start_addr = (u64 *)leaf->addr;
+
+	for (i = 0; i < lvl2->leaf_cnt; i++, leaf++) {
+		arr = (u64 *)leaf->addr;
+		if ((*start_addr + (i * pg_size * PBLE_PER_PAGE)) != *arr)
+			return false;
+		ret = i40iw_check_mem_contiguous(arr, leaf->cnt, pg_size);
+		if (!ret)
+			return false;
+	}
+
+	return true;
+}
+
+/**
  * i40iw_setup_pbles - copy user pg address to pble's
  * @iwdev: iwarp device
  * @iwmr: mr pointer for this memory registration
- * @use_pbles: flag if to use pble's or memory (level 0)
+ * @use_pbles: flag if to use pble's
  */
 static int i40iw_setup_pbles(struct i40iw_device *iwdev,
 			     struct i40iw_mr *iwmr,
@@ -1374,9 +1426,6 @@ static int i40iw_setup_pbles(struct i40iw_device *iwdev,
 	enum i40iw_status_code status;
 	enum i40iw_pble_level level = I40IW_LEVEL_1;
 
-	if (!use_pbles && (iwmr->page_cnt > MAX_SAVE_PAGE_ADDRS))
-		return -ENOMEM;
-
 	if (use_pbles) {
 		mutex_lock(&iwdev->pbl_mutex);
 		status = i40iw_get_pble(&iwdev->sc_dev, iwdev->pble_rsrc, palloc, iwmr->page_cnt);
@@ -1393,6 +1442,10 @@ static int i40iw_setup_pbles(struct i40iw_device *iwdev,
 	}
 
 	i40iw_copy_user_pgaddrs(iwmr, pbl, level);
+
+	if (use_pbles)
+		iwmr->pgaddrmem[0] = *pbl;
+
 	return 0;
 }
 
@@ -1414,14 +1467,18 @@ static int i40iw_handle_q_mem(struct i40iw_device *iwdev,
 	struct i40iw_cq_mr *cqmr = &iwpbl->cq_mr;
 	struct i40iw_hmc_pble *hmc_p;
 	u64 *arr = iwmr->pgaddrmem;
+	u32 pg_size;
 	int err;
 	int total;
+	bool ret = true;
 
 	total = req->sq_pages + req->rq_pages + req->cq_pages;
+	pg_size = iwmr->region->page_size;
 
 	err = i40iw_setup_pbles(iwdev, iwmr, use_pbles);
 	if (err)
 		return err;
+
 	if (use_pbles && (palloc->level != I40IW_LEVEL_1)) {
 		i40iw_free_pble(iwdev->pble_rsrc, palloc);
 		iwpbl->pbl_allocated = false;
@@ -1430,26 +1487,44 @@ static int i40iw_handle_q_mem(struct i40iw_device *iwdev,
 
 	if (use_pbles)
 		arr = (u64 *)palloc->level1.addr;
-	if (req->reg_type == IW_MEMREG_TYPE_QP) {
+
+	if (iwmr->type == IW_MEMREG_TYPE_QP) {
 		hmc_p = &qpmr->sq_pbl;
 		qpmr->shadow = (dma_addr_t)arr[total];
+
 		if (use_pbles) {
+			ret = i40iw_check_mem_contiguous(arr, req->sq_pages, pg_size);
+			if (ret)
+				ret = i40iw_check_mem_contiguous(&arr[req->sq_pages], req->rq_pages, pg_size);
+		}
+
+		if (!ret) {
 			hmc_p->idx = palloc->level1.idx;
 			hmc_p = &qpmr->rq_pbl;
 			hmc_p->idx = palloc->level1.idx + req->sq_pages;
 		} else {
 			hmc_p->addr = arr[0];
 			hmc_p = &qpmr->rq_pbl;
-			hmc_p->addr = arr[1];
+			hmc_p->addr = arr[req->sq_pages];
 		}
 	} else {		/* CQ */
 		hmc_p = &cqmr->cq_pbl;
 		cqmr->shadow = (dma_addr_t)arr[total];
+
 		if (use_pbles)
+			ret = i40iw_check_mem_contiguous(arr, req->cq_pages, pg_size);
+
+		if (!ret)
 			hmc_p->idx = palloc->level1.idx;
 		else
 			hmc_p->addr = arr[0];
 	}
+
+	if (use_pbles && ret) {
+		i40iw_free_pble(iwdev->pble_rsrc, palloc);
+		iwpbl->pbl_allocated = false;
+	}
+
 	return err;
 }
 
@@ -1648,7 +1723,7 @@ static int i40iw_hwreg_mr(struct i40iw_device *iwdev,
 	stag_info->pd_id = iwpd->sc_pd.pd_id;
 	stag_info->addr_type = I40IW_ADDR_TYPE_VA_BASED;
 
-	if (iwmr->page_cnt > 1) {
+	if (iwpbl->pbl_allocated) {
 		if (palloc->level == I40IW_LEVEL_1) {
 			stag_info->first_pm_pbl_index = palloc->level1.idx;
 			stag_info->chunk_size = 1;
@@ -1704,6 +1779,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	bool use_pbles = false;
 	unsigned long flags;
 	int err = -ENOSYS;
+	int ret;
 
 	if (length > I40IW_MAX_MR_SIZE)
 		return ERR_PTR(-EINVAL);
@@ -1760,13 +1836,21 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
 		break;
 	case IW_MEMREG_TYPE_MEM:
+		use_pbles = (iwmr->page_cnt != 1);
 		access = I40IW_ACCESS_FLAGS_LOCALREAD;
 
-		use_pbles = (iwmr->page_cnt != 1);
 		err = i40iw_setup_pbles(iwdev, iwmr, use_pbles);
 		if (err)
 			goto error;
 
+		if (use_pbles) {
+			ret = i40iw_check_mr_contiguous(palloc, region->page_size);
+			if (ret) {
+				i40iw_free_pble(iwdev->pble_rsrc, palloc);
+				iwpbl->pbl_allocated = false;
+			}
+		}
+
 		access |= i40iw_get_user_access(acc);
 		stag = i40iw_create_stag(iwdev);
 		if (!stag) {
@@ -1794,7 +1878,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	return &iwmr->ibmr;
 
 error:
-	if (palloc->level != I40IW_LEVEL_0)
+	if (palloc->level != I40IW_LEVEL_0 && iwpbl->pbl_allocated)
 		i40iw_free_pble(iwdev->pble_rsrc, palloc);
 	ib_umem_release(region);
 	kfree(iwmr);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
