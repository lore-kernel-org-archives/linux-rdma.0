From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 8/9] ehca: stop using struct ib_phys_buf
Date: Sun, 15 Nov 2015 19:06:01 +0100
Message-ID: <1447610762-3781-9-git-send-email-hch@lst.de>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447610762-3781-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

And simplify the calling convention for full-memory registrations.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/staging/rdma/ehca/ehca_classes.h |  5 +-
 drivers/staging/rdma/ehca/ehca_mrmw.c    | 94 +++++++++++++++-----------------
 2 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_classes.h b/drivers/staging/rdma/ehca/ehca_classes.h
index bd45e0f..e8c3387 100644
--- a/drivers/staging/rdma/ehca/ehca_classes.h
+++ b/drivers/staging/rdma/ehca/ehca_classes.h
@@ -316,9 +316,8 @@ struct ehca_mr_pginfo {
 
 	union {
 		struct { /* type EHCA_MR_PGI_PHYS section */
-			int num_phys_buf;
-			struct ib_phys_buf *phys_buf_array;
-			u64 next_buf;
+			u64 addr;
+			u16 size;
 		} phy;
 		struct { /* type EHCA_MR_PGI_USER section */
 			struct ib_umem *region;
diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
index c6e3245..1814af7 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.c
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.c
@@ -1289,7 +1289,6 @@ int ehca_reg_internal_maxmr(
 	u64 *iova_start;
 	u64 size_maxmr;
 	struct ehca_mr_pginfo pginfo;
-	struct ib_phys_buf ib_pbuf;
 	u32 num_kpages;
 	u32 num_hwpages;
 	u64 hw_pgsize;
@@ -1310,8 +1309,6 @@ int ehca_reg_internal_maxmr(
 	/* register internal max-MR on HCA */
 	size_maxmr = ehca_mr_len;
 	iova_start = (u64 *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START));
-	ib_pbuf.addr = 0;
-	ib_pbuf.size = size_maxmr;
 	num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
 				PAGE_SIZE);
 	hw_pgsize = ehca_get_max_hwpage_size(shca);
@@ -1323,8 +1320,8 @@ int ehca_reg_internal_maxmr(
 	pginfo.num_kpages = num_kpages;
 	pginfo.num_hwpages = num_hwpages;
 	pginfo.hwpage_size = hw_pgsize;
-	pginfo.u.phy.num_phys_buf = 1;
-	pginfo.u.phy.phys_buf_array = &ib_pbuf;
+	pginfo.u.phy.addr = 0;
+	pginfo.u.phy.size = size_maxmr;
 
 	ret = ehca_reg_mr(shca, e_mr, iova_start, size_maxmr, 0, e_pd,
 			  &pginfo, &e_mr->ib.ib_mr.lkey,
@@ -1620,57 +1617,54 @@ static int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
 				 u32 number, u64 *kpage)
 {
 	int ret = 0;
-	struct ib_phys_buf *pbuf;
+	u64 addr = pginfo->u.phy.addr;
+	u64 size = pginfo->u.phy.size;
 	u64 num_hw, offs_hw;
 	u32 i = 0;
 
-	/* loop over desired phys_buf_array entries */
-	while (i < number) {
-		pbuf   = pginfo->u.phy.phys_buf_array + pginfo->u.phy.next_buf;
-		num_hw  = NUM_CHUNKS((pbuf->addr % pginfo->hwpage_size) +
-				     pbuf->size, pginfo->hwpage_size);
-		offs_hw = (pbuf->addr & ~(pginfo->hwpage_size - 1)) /
-			pginfo->hwpage_size;
-		while (pginfo->next_hwpage < offs_hw + num_hw) {
-			/* sanity check */
-			if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
-			    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
-				ehca_gen_err("kpage_cnt >= num_kpages, "
-					     "kpage_cnt=%llx num_kpages=%llx "
-					     "hwpage_cnt=%llx "
-					     "num_hwpages=%llx i=%x",
-					     pginfo->kpage_cnt,
-					     pginfo->num_kpages,
-					     pginfo->hwpage_cnt,
-					     pginfo->num_hwpages, i);
-				return -EFAULT;
-			}
-			*kpage = (pbuf->addr & ~(pginfo->hwpage_size - 1)) +
-				 (pginfo->next_hwpage * pginfo->hwpage_size);
-			if ( !(*kpage) && pbuf->addr ) {
-				ehca_gen_err("pbuf->addr=%llx pbuf->size=%llx "
-					     "next_hwpage=%llx", pbuf->addr,
-					     pbuf->size, pginfo->next_hwpage);
-				return -EFAULT;
-			}
-			(pginfo->hwpage_cnt)++;
-			(pginfo->next_hwpage)++;
-			if (PAGE_SIZE >= pginfo->hwpage_size) {
-				if (pginfo->next_hwpage %
-				    (PAGE_SIZE / pginfo->hwpage_size) == 0)
-					(pginfo->kpage_cnt)++;
-			} else
-				pginfo->kpage_cnt += pginfo->hwpage_size /
-					PAGE_SIZE;
-			kpage++;
-			i++;
-			if (i >= number) break;
+	num_hw  = NUM_CHUNKS((addr % pginfo->hwpage_size) + size,
+				pginfo->hwpage_size);
+	offs_hw = (addr & ~(pginfo->hwpage_size - 1)) / pginfo->hwpage_size;
+
+	while (pginfo->next_hwpage < offs_hw + num_hw) {
+		/* sanity check */
+		if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
+		    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
+			ehca_gen_err("kpage_cnt >= num_kpages, "
+				     "kpage_cnt=%llx num_kpages=%llx "
+				     "hwpage_cnt=%llx "
+				     "num_hwpages=%llx i=%x",
+				     pginfo->kpage_cnt,
+				     pginfo->num_kpages,
+				     pginfo->hwpage_cnt,
+				     pginfo->num_hwpages, i);
+			return -EFAULT;
 		}
-		if (pginfo->next_hwpage >= offs_hw + num_hw) {
-			(pginfo->u.phy.next_buf)++;
-			pginfo->next_hwpage = 0;
+		*kpage = (addr & ~(pginfo->hwpage_size - 1)) +
+			 (pginfo->next_hwpage * pginfo->hwpage_size);
+		if ( !(*kpage) && addr ) {
+			ehca_gen_err("addr=%llx size=%llx "
+				     "next_hwpage=%llx", addr,
+				     size, pginfo->next_hwpage);
+			return -EFAULT;
 		}
+		(pginfo->hwpage_cnt)++;
+		(pginfo->next_hwpage)++;
+		if (PAGE_SIZE >= pginfo->hwpage_size) {
+			if (pginfo->next_hwpage %
+			    (PAGE_SIZE / pginfo->hwpage_size) == 0)
+				(pginfo->kpage_cnt)++;
+		} else
+			pginfo->kpage_cnt += pginfo->hwpage_size /
+				PAGE_SIZE;
+		kpage++;
+		i++;
+		if (i >= number) break;
+	}
+	if (pginfo->next_hwpage >= offs_hw + num_hw) {
+		pginfo->next_hwpage = 0;
 	}
+
 	return ret;
 }
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
