From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 06/10] IB/umem: Add contiguous ODP support
Date: Wed,  5 Apr 2017 09:23:55 +0300
Message-ID: <20170405062359.26623-7-leon@kernel.org>
References: <20170405062359.26623-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405062359.26623-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currenlty ODP supports only regular MMU pages.
Add ODP support for regions consisting of physically contiguous chunks
of arbitrary order (huge pages for instance) to improve performance.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c | 50 +++++++++++++++++++++++---------------
 include/rdma/ib_umem.h             |  4 +--
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 8ee30163497d..73053c8a9e3b 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -504,7 +504,6 @@ void ib_umem_odp_release(struct ib_umem *umem)
 static int ib_umem_odp_map_dma_single_page(
 		struct ib_umem *umem,
 		int page_index,
-		u64 base_virt_addr,
 		struct page *page,
 		u64 access_mask,
 		unsigned long current_seq)
@@ -527,7 +526,7 @@ static int ib_umem_odp_map_dma_single_page(
 	if (!(umem->odp_data->dma_list[page_index])) {
 		dma_addr = ib_dma_map_page(dev,
 					   page,
-					   0, PAGE_SIZE,
+					   0, BIT(umem->page_shift),
 					   DMA_BIDIRECTIONAL);
 		if (ib_dma_mapping_error(dev, dma_addr)) {
 			ret = -EFAULT;
@@ -555,8 +554,9 @@ static int ib_umem_odp_map_dma_single_page(
 	if (remove_existing_mapping && umem->context->invalidate_range) {
 		invalidate_page_trampoline(
 			umem,
-			base_virt_addr + (page_index * PAGE_SIZE),
-			base_virt_addr + ((page_index+1)*PAGE_SIZE),
+			ib_umem_start(umem) + (page_index >> umem->page_shift),
+			ib_umem_start(umem) + ((page_index + 1) >>
+					       umem->page_shift),
 			NULL);
 		ret = -EAGAIN;
 	}
@@ -595,10 +595,10 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
 	struct task_struct *owning_process  = NULL;
 	struct mm_struct   *owning_mm       = NULL;
 	struct page       **local_page_list = NULL;
-	u64 off;
-	int j, k, ret = 0, start_idx, npages = 0;
-	u64 base_virt_addr;
+	u64 page_mask, off;
+	int j, k, ret = 0, start_idx, npages = 0, page_shift;
 	unsigned int flags = 0;
+	phys_addr_t p = 0;
 
 	if (access_mask == 0)
 		return -EINVAL;
@@ -611,9 +611,10 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
 	if (!local_page_list)
 		return -ENOMEM;
 
-	off = user_virt & (~PAGE_MASK);
-	user_virt = user_virt & PAGE_MASK;
-	base_virt_addr = user_virt;
+	page_shift = umem->page_shift;
+	page_mask = ~(BIT(page_shift) - 1);
+	off = user_virt & (~page_mask);
+	user_virt = user_virt & page_mask;
 	bcnt += off; /* Charge for the first page offset as well. */
 
 	owning_process = get_pid_task(umem->context->tgid, PIDTYPE_PID);
@@ -631,13 +632,13 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
 	if (access_mask & ODP_WRITE_ALLOWED_BIT)
 		flags |= FOLL_WRITE;
 
-	start_idx = (user_virt - ib_umem_start(umem)) >> PAGE_SHIFT;
+	start_idx = (user_virt - ib_umem_start(umem)) >> page_shift;
 	k = start_idx;
 
 	while (bcnt > 0) {
-		const size_t gup_num_pages =
-			min_t(size_t, ALIGN(bcnt, PAGE_SIZE) / PAGE_SIZE,
-			      PAGE_SIZE / sizeof(struct page *));
+		const size_t gup_num_pages = min_t(size_t,
+				(bcnt + BIT(page_shift) - 1) >> page_shift,
+				PAGE_SIZE / sizeof(struct page *));
 
 		down_read(&owning_mm->mmap_sem);
 		/*
@@ -656,14 +657,25 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
 			break;
 
 		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
-		user_virt += npages << PAGE_SHIFT;
 		mutex_lock(&umem->odp_data->umem_mutex);
-		for (j = 0; j < npages; ++j) {
+		for (j = 0; j < npages; j++, user_virt += PAGE_SIZE) {
+			if (user_virt & ~page_mask) {
+				p += PAGE_SIZE;
+				if (page_to_phys(local_page_list[j]) != p) {
+					ret = -EFAULT;
+					break;
+				}
+				put_page(local_page_list[j]);
+				continue;
+			}
+
 			ret = ib_umem_odp_map_dma_single_page(
-				umem, k, base_virt_addr, local_page_list[j],
-				access_mask, current_seq);
+					umem, k, local_page_list[j],
+					access_mask, current_seq);
 			if (ret < 0)
 				break;
+
+			p = page_to_phys(local_page_list[j]);
 			k++;
 		}
 		mutex_unlock(&umem->odp_data->umem_mutex);
@@ -708,7 +720,7 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 	 * once. */
 	mutex_lock(&umem->odp_data->umem_mutex);
 	for (addr = virt; addr < bound; addr += BIT(umem->page_shift)) {
-		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
+		idx = (addr - ib_umem_start(umem)) >> umem->page_shift;
 		if (umem->odp_data->page_list[idx]) {
 			struct page *page = umem->odp_data->page_list[idx];
 			dma_addr_t dma = umem->odp_data->dma_list[idx];
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 7f4af1e1ae64..23159dd5be18 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -72,12 +72,12 @@ static inline unsigned long ib_umem_start(struct ib_umem *umem)
 /* Returns the address of the page after the last one of an ODP umem. */
 static inline unsigned long ib_umem_end(struct ib_umem *umem)
 {
-	return PAGE_ALIGN(umem->address + umem->length);
+	return ALIGN(umem->address + umem->length, BIT(umem->page_shift));
 }
 
 static inline size_t ib_umem_num_pages(struct ib_umem *umem)
 {
-	return (ib_umem_end(umem) - ib_umem_start(umem)) >> PAGE_SHIFT;
+	return (ib_umem_end(umem) - ib_umem_start(umem)) >> umem->page_shift;
 }
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
