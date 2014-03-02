From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 02/20] IB/core: Replace ib_umem's offset field with a full address
Date: Sun,  2 Mar 2014 12:49:20 +0200
Message-ID: <1393757378-16412-3-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to allow umems that do not pin memory we need the umem to keep track
of its region's address.

This makes the offset field redundant, and so this patch removes it.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem.c               |  6 +++---
 drivers/infiniband/hw/amso1100/c2_provider.c |  2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |  2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c       |  2 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |  4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
 drivers/infiniband/hw/qib/qib_mr.c           |  2 +-
 include/rdma/ib_umem.h                       | 25 ++++++++++++++++++++++++-
 8 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 1fba9d3..ab14b33 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -103,7 +103,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	umem->context   = context;
 	umem->length    = size;
-	umem->offset    = addr & ~PAGE_MASK;
+	umem->address   = addr;
 	umem->page_size = PAGE_SIZE;
 	/*
 	 * We ask for writable memory if any of the following
@@ -133,7 +133,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (!vma_list)
 		umem->hugetlb = 0;
 
-	npages = PAGE_ALIGN(size + umem->offset) >> PAGE_SHIFT;
+	npages = ib_umem_num_pages(umem);
 
 	down_write(&current->mm->mmap_sem);
 
@@ -242,7 +242,7 @@ void ib_umem_release(struct ib_umem *umem)
 		return;
 	}
 
-	diff = PAGE_ALIGN(umem->length + umem->offset) >> PAGE_SHIFT;
+	diff = ib_umem_num_pages(umem);
 
 	/*
 	 * We may be called with the mm's mmap_sem already held.  This
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 8af33cf..056c405 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -476,7 +476,7 @@ static struct ib_mr *c2_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 					 c2mr->umem->page_size,
 					 i,
 					 length,
-					 c2mr->umem->offset,
+					 ib_umem_offset(c2mr->umem),
 					 &kva,
 					 c2_convert_access(acc),
 					 c2mr);
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 7168f59..d64c9cc 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -399,7 +399,7 @@ reg_user_mr_fallback:
 	pginfo.num_kpages = num_kpages;
 	pginfo.num_hwpages = num_hwpages;
 	pginfo.u.usr.region = e_mr->umem;
-	pginfo.next_hwpage = e_mr->umem->offset / hwpage_size;
+	pginfo.next_hwpage = ib_umem_offset(e_mr->umem) / hwpage_size;
 	pginfo.u.usr.next_sg = pginfo.u.usr.region->sg_head.sgl;
 	ret = ehca_reg_mr(shca, e_mr, (u64 *)virt, length, mr_access_flags,
 			  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/infiniband/hw/ipath/ipath_mr.c
index 5e61e9b..c7278f6 100644
--- a/drivers/infiniband/hw/ipath/ipath_mr.c
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -214,7 +214,7 @@ struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->mr.user_base = start;
 	mr->mr.iova = virt_addr;
 	mr->mr.length = length;
-	mr->mr.offset = umem->offset;
+	mr->mr.offset = ib_umem_offset(umem);
 	mr->mr.access_flags = mr_access_flags;
 	mr->mr.max_segs = n;
 	mr->umem = umem;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 32d3682..e049750 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2342,7 +2342,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			(unsigned long int)start, (unsigned long int)virt, (u32)length,
 			region->offset, region->page_size);
 
-	skip_pages = ((u32)region->offset) >> 12;
+	skip_pages = ((u32)ib_umem_offset(region)) >> 12;
 
 	if (ib_copy_from_udata(&req, udata, sizeof(req))) {
 		ib_umem_release(region);
@@ -2407,7 +2407,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				region_length -= skip_pages << 12;
 				for (page_index = skip_pages; page_index < chunk_pages; page_index++) {
 					skip_pages = 0;
-					if ((page_count != 0) && (page_count<<12)-(region->offset&(4096-1)) >= region->length)
+					if ((page_count != 0) && (page_count << 12) - (ib_umem_offset(region) & (4096 - 1)) >= region->length)
 						goto enough_pages;
 					if ((page_count&0x01FF) == 0) {
 						if (page_count >= 1024 * 512) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 0de3473..fe5264a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -802,7 +802,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 		goto umem_err;
 
 	mr->hwmr.pbe_size = mr->umem->page_size;
-	mr->hwmr.fbo = mr->umem->offset;
+	mr->hwmr.fbo = ib_umem_offset(mr->umem);
 	mr->hwmr.va = usr_addr;
 	mr->hwmr.len = len;
 	mr->hwmr.remote_wr = (acc & IB_ACCESS_REMOTE_WRITE) ? 1 : 0;
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 9bbb553..a77fb4f 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -258,7 +258,7 @@ struct ib_mr *qib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->mr.user_base = start;
 	mr->mr.iova = virt_addr;
 	mr->mr.length = length;
-	mr->mr.offset = umem->offset;
+	mr->mr.offset = ib_umem_offset(umem);
 	mr->mr.access_flags = mr_access_flags;
 	mr->umem = umem;
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 1ea0b65..0e120f4 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -42,7 +42,7 @@ struct ib_ucontext;
 struct ib_umem {
 	struct ib_ucontext     *context;
 	size_t			length;
-	int			offset;
+	unsigned long		address;
 	int			page_size;
 	int                     writable;
 	int                     hugetlb;
@@ -54,6 +54,29 @@ struct ib_umem {
 	int             npages;
 };
 
+/* Returns the offset of the umem start relative to the first page. */
+static inline int ib_umem_offset(struct ib_umem *umem)
+{
+	return umem->address & ~PAGE_MASK;
+}
+
+/* Returns the first page of an ODP umem. */
+static inline unsigned long ib_umem_start(struct ib_umem *umem)
+{
+	return umem->address & PAGE_MASK;
+}
+
+/* Returns the address of the page after the last one of an ODP umem. */
+static inline unsigned long ib_umem_end(struct ib_umem *umem)
+{
+	return PAGE_ALIGN(umem->address + umem->length);
+}
+
+static inline size_t ib_umem_num_pages(struct ib_umem *umem)
+{
+	return (ib_umem_end(umem) - ib_umem_start(umem)) >> PAGE_SHIFT;
+}
+
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
