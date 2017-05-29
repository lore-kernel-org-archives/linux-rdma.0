From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/2] RDMA/qedr: Add 64KB PAGE_SIZE support to user-space queues
Date: Mon, 29 May 2017 16:23:11 +0300
Message-ID: <1496064191-11442-3-git-send-email-Ram.Amrani@cavium.com>
References: <1496064191-11442-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496064191-11442-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add 64KB PAGE_SIZE support to user-space CQ, SQ and RQ queues.
De-facto it means that code was added to translate 64KB
pages to smaller 4KB pages that the FW can handle. Otherwise,
the FW would wrap (or jump to the next page)  when reaching 4KB
while the user space library will continue on the same large page.

Note that MR code remains as is since the FW supports larger pages
for MRs.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr.h  |  4 ++-
 drivers/infiniband/hw/qedr/verbs.c | 64 ++++++++++++++++++++++----------------
 2 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index bb32e47..b55a961 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -57,7 +57,9 @@
 #define QEDR_MSG_QP   "  QP"
 #define QEDR_MSG_GSI  " GSI"
 
-#define QEDR_CQ_MAGIC_NUMBER   (0x11223344)
+#define QEDR_CQ_MAGIC_NUMBER	(0x11223344)
+
+#define FW_PAGE_SIZE		(RDMA_RING_PAGE_SIZE)
 
 struct qedr_dev;
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index f3ed4cc..7007450 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -652,14 +652,15 @@ static int qedr_prepare_pbl_tbl(struct qedr_dev *dev,
 
 static void qedr_populate_pbls(struct qedr_dev *dev, struct ib_umem *umem,
 			       struct qedr_pbl *pbl,
-			       struct qedr_pbl_info *pbl_info)
+			       struct qedr_pbl_info *pbl_info, u32 pg_size)
 {
 	int shift, pg_cnt, pages, pbe_cnt, total_num_pbes = 0;
+	u32 fw_pg_cnt, fw_pg_per_umem_pg;
 	struct qedr_pbl *pbl_tbl;
 	struct scatterlist *sg;
 	struct regpair *pbe;
+	u64 pg_addr;
 	int entry;
-	u32 addr;
 
 	if (!pbl_info->num_pbes)
 		return;
@@ -682,29 +683,35 @@ static void qedr_populate_pbls(struct qedr_dev *dev, struct ib_umem *umem,
 
 	shift = ilog2(umem->page_size);
 
+	fw_pg_per_umem_pg = umem->page_size / pg_size;
+
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
 		pages = sg_dma_len(sg) >> shift;
+		pg_addr = sg_dma_address(sg);
 		for (pg_cnt = 0; pg_cnt < pages; pg_cnt++) {
-			/* store the page address in pbe */
-			pbe->lo = cpu_to_le32(sg_dma_address(sg) +
-					      umem->page_size * pg_cnt);
-			addr = upper_32_bits(sg_dma_address(sg) +
-					     umem->page_size * pg_cnt);
-			pbe->hi = cpu_to_le32(addr);
-			pbe_cnt++;
-			total_num_pbes++;
-			pbe++;
-
-			if (total_num_pbes == pbl_info->num_pbes)
-				return;
-
-			/* If the given pbl is full storing the pbes,
-			 * move to next pbl.
-			 */
-			if (pbe_cnt == (pbl_info->pbl_size / sizeof(u64))) {
-				pbl_tbl++;
-				pbe = (struct regpair *)pbl_tbl->va;
-				pbe_cnt = 0;
+			for (fw_pg_cnt = 0; fw_pg_cnt < fw_pg_per_umem_pg;) {
+				pbe->lo = cpu_to_le32(pg_addr);
+				pbe->hi = cpu_to_le32(upper_32_bits(pg_addr));
+
+				pg_addr += pg_size;
+				pbe_cnt++;
+				total_num_pbes++;
+				pbe++;
+
+				if (total_num_pbes == pbl_info->num_pbes)
+					return;
+
+				/* If the given pbl is full storing the pbes,
+				 * move to next pbl.
+				 */
+				if (pbe_cnt ==
+				    (pbl_info->pbl_size / sizeof(u64))) {
+					pbl_tbl++;
+					pbe = (struct regpair *)pbl_tbl->va;
+					pbe_cnt = 0;
+				}
+
+				fw_pg_cnt++;
 			}
 		}
 	}
@@ -753,7 +760,7 @@ static inline int qedr_init_user_queue(struct ib_ucontext *ib_ctx,
 				       u64 buf_addr, size_t buf_len,
 				       int access, int dmasync)
 {
-	int page_cnt;
+	u32 fw_pages;
 	int rc;
 
 	q->buf_addr = buf_addr;
@@ -765,8 +772,10 @@ static inline int qedr_init_user_queue(struct ib_ucontext *ib_ctx,
 		return PTR_ERR(q->umem);
 	}
 
-	page_cnt = ib_umem_page_count(q->umem);
-	rc = qedr_prepare_pbl_tbl(dev, &q->pbl_info, page_cnt, 0);
+	fw_pages = ib_umem_page_count(q->umem) *
+	    (q->umem->page_size / FW_PAGE_SIZE);
+
+	rc = qedr_prepare_pbl_tbl(dev, &q->pbl_info, fw_pages, 0);
 	if (rc)
 		goto err0;
 
@@ -776,7 +785,8 @@ static inline int qedr_init_user_queue(struct ib_ucontext *ib_ctx,
 		goto err0;
 	}
 
-	qedr_populate_pbls(dev, q->umem, q->pbl_tbl, &q->pbl_info);
+		qedr_populate_pbls(dev, q->umem, q->pbl_tbl, &q->pbl_info,
+				   FW_PAGE_SIZE);
 
 	return 0;
 
@@ -2168,7 +2178,7 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 		goto err1;
 
 	qedr_populate_pbls(dev, mr->umem, mr->info.pbl_table,
-			   &mr->info.pbl_info);
+			   &mr->info.pbl_info, mr->umem->page_size);
 
 	rc = dev->ops->rdma_alloc_tid(dev->rdma_ctx, &mr->hw_mr.itid);
 	if (rc) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
