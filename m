From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/11] cxgb3: simplify iwch_get_dma_wr
Date: Sun, 22 Nov 2015 18:46:43 +0100
Message-ID: <1448214409-7729-6-git-send-email-hch@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448214409-7729-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fold simplified versions of build_phys_page_list and
iwch_register_phys_mem into iwch_get_dma_wr now that no other callers
are left.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_mem.c      | 71 ----------------------------
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 73 ++++++++++-------------------
 drivers/infiniband/hw/cxgb3/iwch_provider.h |  8 ----
 3 files changed, 26 insertions(+), 126 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_mem.c b/drivers/infiniband/hw/cxgb3/iwch_mem.c
index 3a5e27d..1d04c87 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_mem.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_mem.c
@@ -99,74 +99,3 @@ int iwch_write_pbl(struct iwch_mr *mhp, __be64 *pages, int npages, int offset)
 	return cxio_write_pbl(&mhp->rhp->rdev, pages,
 			      mhp->attr.pbl_addr + (offset << 3), npages);
 }
-
-int build_phys_page_list(struct ib_phys_buf *buffer_list,
-					int num_phys_buf,
-					u64 *iova_start,
-					u64 *total_size,
-					int *npages,
-					int *shift,
-					__be64 **page_list)
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
-	     __func__, (unsigned long long) *iova_start,
-	     (unsigned long long) mask, *shift, (unsigned long long) *total_size,
-	     *npages);
-
-	return 0;
-
-}
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b184933..097eb93 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -479,24 +479,25 @@ static int iwch_dereg_mr(struct ib_mr *ib_mr)
 	return 0;
 }
 
-static struct ib_mr *iwch_register_phys_mem(struct ib_pd *pd,
-					struct ib_phys_buf *buffer_list,
-					int num_phys_buf,
-					int acc,
-					u64 *iova_start)
+static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
 {
-	__be64 *page_list;
-	int shift;
-	u64 total_size;
-	int npages;
-	struct iwch_dev *rhp;
-	struct iwch_pd *php;
+	const u64 total_size = 0xffffffff;
+	const u64 mask = (total_size + PAGE_SIZE - 1) & PAGE_MASK;
+	struct iwch_pd *php = to_iwch_pd(pd);
+	struct iwch_dev *rhp = php->rhp;
 	struct iwch_mr *mhp;
-	int ret;
+	__be64 *page_list;
+	int shift = 26, npages, ret, i;
 
 	PDBG("%s ib_pd %p\n", __func__, pd);
-	php = to_iwch_pd(pd);
-	rhp = php->rhp;
+
+	/*
+	 * T3 only supports 32 bits of size.
+	 */
+	if (sizeof(phys_addr_t) > 4) {
+		pr_warn_once(MOD "Cannot support dma_mrs on this platform.\n");
+		return ERR_PTR(-ENOTSUPP);
+	}
 
 	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
 	if (!mhp)
@@ -504,22 +505,23 @@ static struct ib_mr *iwch_register_phys_mem(struct ib_pd *pd,
 
 	mhp->rhp = rhp;
 
-	/* First check that we have enough alignment */
-	if ((*iova_start & ~PAGE_MASK) != (buffer_list[0].addr & ~PAGE_MASK)) {
+	npages = (total_size + (1ULL << shift) - 1) >> shift;
+	if (!npages) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	if (num_phys_buf > 1 &&
-	    ((buffer_list[0].addr + buffer_list[0].size) & ~PAGE_MASK)) {
-		ret = -EINVAL;
+	page_list = kmalloc_array(npages, sizeof(u64), GFP_KERNEL);
+	if (!page_list) {
+		ret = -ENOMEM;
 		goto err;
 	}
 
-	ret = build_phys_page_list(buffer_list, num_phys_buf, iova_start,
-				   &total_size, &npages, &shift, &page_list);
-	if (ret)
-		goto err;
+	for (i = 0; i < npages; i++)
+		page_list[i] = cpu_to_be64((u64)i << shift);
+
+	PDBG("%s mask 0x%llx shift %d len %lld pbl_size %d\n",
+		__func__, mask, shift, total_size, npages);
 
 	ret = iwch_alloc_pbl(mhp, npages);
 	if (ret) {
@@ -536,7 +538,7 @@ static struct ib_mr *iwch_register_phys_mem(struct ib_pd *pd,
 	mhp->attr.zbva = 0;
 
 	mhp->attr.perms = iwch_ib_to_tpt_access(acc);
-	mhp->attr.va_fbo = *iova_start;
+	mhp->attr.va_fbo = 0;
 	mhp->attr.page_size = shift - 12;
 
 	mhp->attr.len = (u32) total_size;
@@ -553,7 +555,6 @@ err_pbl:
 err:
 	kfree(mhp);
 	return ERR_PTR(ret);
-
 }
 
 static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
@@ -659,28 +660,6 @@ err:
 	return ERR_PTR(err);
 }
 
-static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
-{
-	struct ib_phys_buf bl;
-	u64 kva;
-	struct ib_mr *ibmr;
-
-	PDBG("%s ib_pd %p\n", __func__, pd);
-
-	/*
-	 * T3 only supports 32 bits of size.
-	 */
-	if (sizeof(phys_addr_t) > 4) {
-		pr_warn_once(MOD "Cannot support dma_mrs on this platform.\n");
-		return ERR_PTR(-ENOTSUPP);
-	}
-	bl.size = 0xffffffff;
-	bl.addr = 0;
-	kva = 0;
-	ibmr = iwch_register_phys_mem(pd, &bl, 1, acc, &kva);
-	return ibmr;
-}
-
 static struct ib_mw *iwch_alloc_mw(struct ib_pd *pd, enum ib_mw_type type)
 {
 	struct iwch_dev *rhp;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index f24df44..252c464 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -341,14 +341,6 @@ int iwch_register_mem(struct iwch_dev *rhp, struct iwch_pd *php,
 int iwch_alloc_pbl(struct iwch_mr *mhp, int npages);
 void iwch_free_pbl(struct iwch_mr *mhp);
 int iwch_write_pbl(struct iwch_mr *mhp, __be64 *pages, int npages, int offset);
-int build_phys_page_list(struct ib_phys_buf *buffer_list,
-					int num_phys_buf,
-					u64 *iova_start,
-					u64 *total_size,
-					int *npages,
-					int *shift,
-					__be64 **page_list);
-
 
 #define IWCH_NODE_DESC "cxgb3 Chelsio Communications"
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
