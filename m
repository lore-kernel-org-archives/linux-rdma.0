From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [for-next 3/5] RDMA/bnxt_re: Add support for MRs with Huge pages
Date: Fri,  5 Jan 2018 06:40:32 -0500
Message-ID: <1515152434-13105-4-git-send-email-devesh.sharma@broadcom.com>
References: <1515152434-13105-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515152434-13105-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Depending on the OS page-table configurations, applications
may request MRs which has page size alignment other than 4K

Underlying provider driver needs to adjust its PBL boundaries
according to the incoming page boundaries in the PA list.

Adding a capability to register MRs having pages-sizes other
than 4K (Hugepages).

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  26 ++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 120 +++++++++++++++++++++----------
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |  12 +++-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |   2 +-
 drivers/infiniband/hw/bnxt_re/roce_hsi.h |  28 +++++++-
 5 files changed, 137 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index b604277..085ca00 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -43,15 +43,23 @@
 #define ROCE_DRV_MODULE_VERSION		"1.0.0"
 
 #define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
-
-#define BNXT_RE_PAGE_SIZE_4K		BIT(12)
-#define BNXT_RE_PAGE_SIZE_8K		BIT(13)
-#define BNXT_RE_PAGE_SIZE_64K		BIT(16)
-#define BNXT_RE_PAGE_SIZE_2M		BIT(21)
-#define BNXT_RE_PAGE_SIZE_8M		BIT(23)
-#define BNXT_RE_PAGE_SIZE_1G		BIT(30)
-
-#define BNXT_RE_MAX_MR_SIZE		BIT(30)
+#define BNXT_RE_PAGE_SHIFT_4K		(12)
+#define BNXT_RE_PAGE_SHIFT_8K		(13)
+#define BNXT_RE_PAGE_SHIFT_64K		(16)
+#define BNXT_RE_PAGE_SHIFT_2M		(21)
+#define BNXT_RE_PAGE_SHIFT_8M		(23)
+#define BNXT_RE_PAGE_SHIFT_1G		(30)
+
+#define BNXT_RE_PAGE_SIZE_4K		BIT(BNXT_RE_PAGE_SHIFT_4K)
+#define BNXT_RE_PAGE_SIZE_8K		BIT(BNXT_RE_PAGE_SHIFT_8K)
+#define BNXT_RE_PAGE_SIZE_64K		BIT(BNXT_RE_PAGE_SHIFT_64K)
+#define BNXT_RE_PAGE_SIZE_2M		BIT(BNXT_RE_PAGE_SHIFT_2M)
+#define BNXT_RE_PAGE_SIZE_8M		BIT(BNXT_RE_PAGE_SHIFT_8M)
+#define BNXT_RE_PAGE_SIZE_1G		BIT(BNXT_RE_PAGE_SHIFT_1G)
+
+#define BNXT_RE_MAX_MR_SIZE_LOW		BIT(BNXT_RE_PAGE_SHIFT_1G)
+#define BNXT_RE_MAX_MR_SIZE_HIGH	BIT(39)
+#define BNXT_RE_MAX_MR_SIZE		BNXT_RE_MAX_MR_SIZE_HIGH
 
 #define BNXT_RE_MAX_QPC_COUNT		(64 * 1024)
 #define BNXT_RE_MAX_MRW_COUNT		(64 * 1024)
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 8a80e95..c3135f6 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -147,7 +147,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	bnxt_qplib_get_guid(rdev->netdev->dev_addr,
 			    (u8 *)&ib_attr->sys_image_guid);
 	ib_attr->max_mr_size = BNXT_RE_MAX_MR_SIZE;
-	ib_attr->page_size_cap = BNXT_RE_PAGE_SIZE_4K;
+	ib_attr->page_size_cap = BNXT_RE_PAGE_SIZE_4K | BNXT_RE_PAGE_SIZE_2M;
 
 	ib_attr->vendor_id = rdev->en_dev->pdev->vendor;
 	ib_attr->vendor_part_id = rdev->en_dev->pdev->device;
@@ -248,8 +248,7 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 				    IB_PORT_VENDOR_CLASS_SUP |
 				    IB_PORT_IP_BASED_GIDS;
 
-	/* Max MSG size set to 2G for now */
-	port_attr->max_msg_sz = 0x80000000;
+	port_attr->max_msg_sz = (u32)BNXT_RE_MAX_MR_SIZE_LOW;
 	port_attr->bad_pkey_cntr = 0;
 	port_attr->qkey_viol_cntr = 0;
 	port_attr->pkey_tbl_len = dev_attr->max_pkey;
@@ -542,7 +541,7 @@ static int bnxt_re_create_fence_mr(struct bnxt_re_pd *pd)
 	mr->qplib_mr.total_size = BNXT_RE_FENCE_BYTES;
 	pbl_tbl = dma_addr;
 	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, &pbl_tbl,
-			       BNXT_RE_FENCE_PBL_SIZE, false);
+			       BNXT_RE_FENCE_PBL_SIZE, false, PAGE_SIZE);
 	if (rc) {
 		dev_err(rdev_to_dev(rdev), "Failed to register fence-MR\n");
 		goto fail;
@@ -3091,7 +3090,8 @@ struct ib_mr *bnxt_re_get_dma_mr(struct ib_pd *ib_pd, int mr_access_flags)
 
 	mr->qplib_mr.hwq.level = PBL_LVL_MAX;
 	mr->qplib_mr.total_size = -1; /* Infinte length */
-	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, &pbl, 0, false);
+	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, &pbl, 0, false,
+			       PAGE_SIZE);
 	if (rc)
 		goto fail_mr;
 
@@ -3261,6 +3261,46 @@ int bnxt_re_dealloc_mw(struct ib_mw *ib_mw)
 	return rc;
 }
 
+static int bnxt_re_page_size_ok(int page_shift)
+{
+	switch (page_shift) {
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_4K:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_8K:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_64K:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_2M:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_256K:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_1M:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_4M:
+	case CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_1G:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static int fill_umem_pbl_tbl(struct ib_umem *umem, u64 *pbl_tbl_orig,
+			     int page_shift)
+{
+	u64 *pbl_tbl = pbl_tbl_orig;
+	u64 paddr;
+	u64 page_mask = (1ULL << page_shift) - 1;
+	int i, pages;
+	struct scatterlist *sg;
+	int entry;
+
+	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
+		pages = sg_dma_len(sg) >> PAGE_SHIFT;
+		for (i = 0; i < pages; i++) {
+			paddr = sg_dma_address(sg) + (i << PAGE_SHIFT);
+			if (pbl_tbl == pbl_tbl_orig)
+				*pbl_tbl++ = paddr & ~page_mask;
+			else if ((paddr & page_mask) == 0)
+				*pbl_tbl++ = paddr;
+		}
+	}
+	return pbl_tbl - pbl_tbl_orig;
+}
+
 /* uverbs */
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
@@ -3270,10 +3310,8 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	struct bnxt_re_dev *rdev = pd->rdev;
 	struct bnxt_re_mr *mr;
 	struct ib_umem *umem;
-	u64 *pbl_tbl, *pbl_tbl_orig;
-	int i, umem_pgs, pages, rc;
-	struct scatterlist *sg;
-	int entry;
+	u64 *pbl_tbl = NULL;
+	int umem_pgs, page_shift, rc;
 
 	if (length > BNXT_RE_MAX_MR_SIZE) {
 		dev_err(rdev_to_dev(rdev), "MR Size: %lld > Max supported:%ld\n",
@@ -3290,64 +3328,70 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	mr->qplib_mr.flags = __from_ib_access_flags(mr_access_flags);
 	mr->qplib_mr.type = CMDQ_ALLOCATE_MRW_MRW_FLAGS_MR;
 
+	rc = bnxt_qplib_alloc_mrw(&rdev->qplib_res, &mr->qplib_mr);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "Failed to allocate MR");
+		goto free_mr;
+	}
+	/* The fixed portion of the rkey is the same as the lkey */
+	mr->ib_mr.rkey = mr->qplib_mr.rkey;
+
 	umem = ib_umem_get(ib_pd->uobject->context, start, length,
 			   mr_access_flags, 0);
 	if (IS_ERR(umem)) {
 		dev_err(rdev_to_dev(rdev), "Failed to get umem");
 		rc = -EFAULT;
-		goto free_mr;
+		goto free_mrw;
 	}
 	mr->ib_umem = umem;
 
-	rc = bnxt_qplib_alloc_mrw(&rdev->qplib_res, &mr->qplib_mr);
-	if (rc) {
-		dev_err(rdev_to_dev(rdev), "Failed to allocate MR");
-		goto release_umem;
-	}
-	/* The fixed portion of the rkey is the same as the lkey */
-	mr->ib_mr.rkey = mr->qplib_mr.rkey;
-
 	mr->qplib_mr.va = virt_addr;
 	umem_pgs = ib_umem_page_count(umem);
 	if (!umem_pgs) {
 		dev_err(rdev_to_dev(rdev), "umem is invalid!");
 		rc = -EINVAL;
-		goto free_mrw;
+		goto free_umem;
 	}
 	mr->qplib_mr.total_size = length;
 
 	pbl_tbl = kcalloc(umem_pgs, sizeof(u64 *), GFP_KERNEL);
 	if (!pbl_tbl) {
-		rc = -EINVAL;
+		rc = -ENOMEM;
 		goto free_mrw;
 	}
-	pbl_tbl_orig = pbl_tbl;
 
-	if (umem->hugetlb) {
-		dev_err(rdev_to_dev(rdev), "umem hugetlb not supported!");
+	page_shift = umem->page_shift;
+
+	if (!bnxt_re_page_size_ok(page_shift)) {
+		dev_err(rdev_to_dev(rdev), "umem page size unsupported!");
+		kfree(pbl_tbl);
 		rc = -EFAULT;
-		goto fail;
+		goto free_umem;
 	}
 
-	if (umem->page_shift != PAGE_SHIFT) {
-		dev_err(rdev_to_dev(rdev), "umem page shift unsupported!");
-		rc = -EFAULT;
+	if (!umem->hugetlb && length > BNXT_RE_MAX_MR_SIZE_LOW) {
+		dev_err(rdev_to_dev(rdev), "Requested MR Sz:%llu Max sup:%llu",
+			length,	(u64)BNXT_RE_MAX_MR_SIZE_LOW);
+		kfree(pbl_tbl);
+		rc = -EINVAL;
 		goto fail;
 	}
-	/* Map umem buf ptrs to the PBL */
-	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-		pages = sg_dma_len(sg) >> umem->page_shift;
-		for (i = 0; i < pages; i++, pbl_tbl++)
-			*pbl_tbl = sg_dma_address(sg) + (i << umem->page_shift);
+	if (umem->hugetlb && length > BNXT_RE_PAGE_SIZE_2M) {
+		page_shift = BNXT_RE_PAGE_SHIFT_2M;
+		dev_warn(rdev_to_dev(rdev), "umem hugetlb set page_size %x",
+			 1 << page_shift);
 	}
-	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, pbl_tbl_orig,
-			       umem_pgs, false);
+
+	/* Map umem buf ptrs to the PBL */
+	umem_pgs = fill_umem_pbl_tbl(umem, pbl_tbl, page_shift);
+	rc = bnxt_qplib_reg_mr(&rdev->qplib_res, &mr->qplib_mr, pbl_tbl,
+			       umem_pgs, false, 1 << page_shift);
 	if (rc) {
 		dev_err(rdev_to_dev(rdev), "Failed to register user MR");
 		goto fail;
 	}
 
-	kfree(pbl_tbl_orig);
+	kfree(pbl_tbl);
 
 	mr->ib_mr.lkey = mr->qplib_mr.lkey;
 	mr->ib_mr.rkey = mr->qplib_mr.lkey;
@@ -3355,11 +3399,11 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 
 	return &mr->ib_mr;
 fail:
-	kfree(pbl_tbl_orig);
+	kfree(pbl_tbl);
+free_umem:
+	ib_umem_release(umem);
 free_mrw:
 	bnxt_qplib_free_mrw(&rdev->qplib_res, &mr->qplib_mr);
-release_umem:
-	ib_umem_release(umem);
 free_mr:
 	kfree(mr);
 	return ERR_PTR(rc);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 60377a3..b805495 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -660,7 +660,7 @@ int bnxt_qplib_dereg_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mrw,
 }
 
 int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
-		      u64 *pbl_tbl, int num_pbls, bool block)
+		      u64 *pbl_tbl, int num_pbls, bool block, u32 buf_pg_size)
 {
 	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
 	struct cmdq_register_mr req;
@@ -671,6 +671,9 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 	u32 pg_size;
 
 	if (num_pbls) {
+		/* Allocate memory for the non-leaf pages to store buf ptrs.
+		 * Non-leaf pages always uses system PAGE_SIZE
+		 */
 		pg_ptrs = roundup_pow_of_two(num_pbls);
 		pages = pg_ptrs >> MAX_PBL_LVL_1_PGS_SHIFT;
 		if (!pages)
@@ -688,6 +691,7 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 			bnxt_qplib_free_hwq(res->pdev, &mr->hwq);
 
 		mr->hwq.max_elements = pages;
+		/* Use system PAGE_SIZE */
 		rc = bnxt_qplib_alloc_init_hwq(res->pdev, &mr->hwq, NULL, 0,
 					       &mr->hwq.max_elements,
 					       PAGE_SIZE, 0, PAGE_SIZE,
@@ -708,18 +712,22 @@ int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
 
 	/* Configure the request */
 	if (mr->hwq.level == PBL_LVL_MAX) {
+		/* No PBL provided, just use system PAGE_SIZE */
 		level = 0;
 		req.pbl = 0;
 		pg_size = PAGE_SIZE;
 	} else {
 		level = mr->hwq.level + 1;
 		req.pbl = cpu_to_le64(mr->hwq.pbl[PBL_LVL_0].pg_map_arr[0]);
-		pg_size = mr->hwq.pbl[PBL_LVL_0].pg_size;
 	}
+	pg_size = buf_pg_size ? buf_pg_size : PAGE_SIZE;
 	req.log2_pg_size_lvl = (level << CMDQ_REGISTER_MR_LVL_SFT) |
 			       ((ilog2(pg_size) <<
 				 CMDQ_REGISTER_MR_LOG2_PG_SIZE_SFT) &
 				CMDQ_REGISTER_MR_LOG2_PG_SIZE_MASK);
+	req.log2_pbl_pg_size = cpu_to_le16(((ilog2(PAGE_SIZE) <<
+				 CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_SFT) &
+				CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_MASK));
 	req.access = (mr->flags & 0xFFFF);
 	req.va = cpu_to_le64(mr->va);
 	req.key = cpu_to_le32(mr->lkey);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 0828bb1..074e5e3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -159,7 +159,7 @@ int bnxt_qplib_alloc_mrw(struct bnxt_qplib_res *res,
 int bnxt_qplib_dereg_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mrw,
 			 bool block);
 int bnxt_qplib_reg_mr(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr,
-		      u64 *pbl_tbl, int num_pbls, bool block);
+		      u64 *pbl_tbl, int num_pbls, bool block, u32 buf_pg_size);
 int bnxt_qplib_free_mrw(struct bnxt_qplib_res *res, struct bnxt_qplib_mrw *mr);
 int bnxt_qplib_alloc_fast_reg_mr(struct bnxt_qplib_res *res,
 				 struct bnxt_qplib_mrw *mr, int max);
diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index f429fdb..5cd31de 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -1383,8 +1383,20 @@ struct cmdq_register_mr {
 	#define CMDQ_REGISTER_MR_LVL_LVL_0			   0x0UL
 	#define CMDQ_REGISTER_MR_LVL_LVL_1			   0x1UL
 	#define CMDQ_REGISTER_MR_LVL_LVL_2			   0x2UL
+	#define CMDQ_REGISTER_MR_LVL_LAST             CMDQ_REGISTER_MR_LVL_LVL_2
 	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_MASK		    0x7cUL
 	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_SFT		    2
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_4K    (0xcUL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_8K    (0xdUL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_64K   (0x10UL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_256K  (0x12UL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_1M    (0x14UL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_2M    (0x15UL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_4M    (0x16UL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_1G    (0x1eUL << 2)
+	#define CMDQ_REGISTER_MR_LOG2_PG_SIZE_LAST	\
+					CMDQ_REGISTER_MR_LOG2_PG_SIZE_PG_1G
+	#define CMDQ_REGISTER_MR_UNUSED1             0x80UL
 	u8 access;
 	#define CMDQ_REGISTER_MR_ACCESS_LOCAL_WRITE		    0x1UL
 	#define CMDQ_REGISTER_MR_ACCESS_REMOTE_READ		    0x2UL
@@ -1392,7 +1404,21 @@ struct cmdq_register_mr {
 	#define CMDQ_REGISTER_MR_ACCESS_REMOTE_ATOMIC		    0x8UL
 	#define CMDQ_REGISTER_MR_ACCESS_MW_BIND		    0x10UL
 	#define CMDQ_REGISTER_MR_ACCESS_ZERO_BASED		    0x20UL
-	__le16 unused_1;
+	__le16	log2_pbl_pg_size;
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_MASK   0x1fUL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_SFT    0
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_4K    0xcUL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_8K    0xdUL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_64K   0x10UL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_256K  0x12UL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_1M    0x14UL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_2M    0x15UL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_4M    0x16UL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_1G    0x1eUL
+	#define CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_LAST    \
+				CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_PG_1G
+	#define CMDQ_REGISTER_MR_UNUSED11_MASK           0xffe0UL
+	#define CMDQ_REGISTER_MR_UNUSED11_SFT            5
 	__le32 key;
 	__le64 pbl;
 	__le64 va;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
