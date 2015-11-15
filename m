From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 7/9] amso1100: fold c2_reg_phys_mr into c2_get_dma_mr
Date: Sun, 15 Nov 2015 19:06:00 +0100
Message-ID: <1447610762-3781-8-git-send-email-hch@lst.de>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447610762-3781-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/staging/rdma/amso1100/c2_provider.c | 67 ++++++-----------------------
 1 file changed, 12 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/staging/rdma/amso1100/c2_provider.c
index 6c3e9cc..2de5a8f 100644
--- a/drivers/staging/rdma/amso1100/c2_provider.c
+++ b/drivers/staging/rdma/amso1100/c2_provider.c
@@ -323,43 +323,21 @@ static inline u32 c2_convert_access(int acc)
 	    C2_ACF_LOCAL_READ | C2_ACF_WINDOW_BIND;
 }
 
-static struct ib_mr *c2_reg_phys_mr(struct ib_pd *ib_pd,
-				    struct ib_phys_buf *buffer_list,
-				    int num_phys_buf, int acc, u64 * iova_start)
+static struct ib_mr *c2_get_dma_mr(struct ib_pd *pd, int acc)
 {
 	struct c2_mr *mr;
 	u64 *page_list;
-	u32 total_len;
-	int err, i, j, k, page_shift, pbl_depth;
+	const u32 total_len = 0xffffffff;	/* AMSO1100 limit */
+	int err, page_shift, pbl_depth, i;
+	u64 kva = 0;
 
-	pbl_depth = 0;
-	total_len = 0;
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
-	page_shift = PAGE_SHIFT;
 	/*
-	 * If there is only 1 buffer we assume this could
-	 * be a map of all phy mem...use a 32k page_shift.
+	 * This is a map of all phy mem...use a 32k page_shift.
 	 */
-	if (num_phys_buf == 1)
-		page_shift += 3;
-
-	for (i = 0; i < num_phys_buf; i++) {
-
-		if (offset_in_page(buffer_list[i].addr)) {
-			pr_debug("Unaligned Memory Buffer: 0x%x\n",
-				(unsigned int) buffer_list[i].addr);
-			return ERR_PTR(-EINVAL);
-		}
-
-		if (!buffer_list[i].size) {
-			pr_debug("Invalid Buffer Size\n");
-			return ERR_PTR(-EINVAL);
-		}
-
-		total_len += buffer_list[i].size;
-		pbl_depth += ALIGN(buffer_list[i].size,
-				   BIT(page_shift)) >> page_shift;
-	}
+	page_shift = PAGE_SHIFT + 3;
+	pbl_depth = ALIGN(total_len, BIT(page_shift)) >> page_shift;
 
 	page_list = vmalloc(sizeof(u64) * pbl_depth);
 	if (!page_list) {
@@ -368,16 +346,8 @@ static struct ib_mr *c2_reg_phys_mr(struct ib_pd *ib_pd,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	for (i = 0, j = 0; i < num_phys_buf; i++) {
-
-		int naddrs;
-
- 		naddrs = ALIGN(buffer_list[i].size,
-			       BIT(page_shift)) >> page_shift;
-		for (k = 0; k < naddrs; k++)
-			page_list[j++] = (buffer_list[i].addr +
-						     (k << page_shift));
-	}
+	for (i = 0; i < pbl_depth; i++)
+		page_list[i++] = (i << page_shift);
 
 	mr = kmalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr) {
@@ -390,12 +360,12 @@ static struct ib_mr *c2_reg_phys_mr(struct ib_pd *ib_pd,
 	pr_debug("%s - page shift %d, pbl_depth %d, total_len %u, "
 		"*iova_start %llx, first pa %llx, last pa %llx\n",
 		__func__, page_shift, pbl_depth, total_len,
-		(unsigned long long) *iova_start,
+		(unsigned long long) kva,
 	       	(unsigned long long) page_list[0],
 	       	(unsigned long long) page_list[pbl_depth-1]);
   	err = c2_nsmr_register_phys_kern(to_c2dev(ib_pd->device), page_list,
 					 BIT(page_shift), pbl_depth,
-					 total_len, 0, iova_start,
+					 total_len, 0, &kva,
 					 c2_convert_access(acc), mr);
 	vfree(page_list);
 	if (err) {
@@ -406,19 +376,6 @@ static struct ib_mr *c2_reg_phys_mr(struct ib_pd *ib_pd,
 	return &mr->ibmr;
 }
 
-static struct ib_mr *c2_get_dma_mr(struct ib_pd *pd, int acc)
-{
-	struct ib_phys_buf bl;
-	u64 kva = 0;
-
-	pr_debug("%s:%u\n", __func__, __LINE__);
-
-	/* AMSO1100 limit */
-	bl.size = 0xffffffff;
-	bl.addr = 0;
-	return c2_reg_phys_mr(pd, &bl, 1, acc, &kva);
-}
-
 static struct ib_mr *c2_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				    u64 virt, int acc, struct ib_udata *udata)
 {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
