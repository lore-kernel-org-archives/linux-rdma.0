From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 2/4] uverbs: Add common ib_iomem_get service
Date: Thu, 29 Jul 2010 11:25:09 -0500
Message-ID: <20100729162509.14674.34237.stgit@build.ogc.int>
References: <20100729162339.14674.15788.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729162339.14674.15788.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Add an ib_iomem_get service that converts a vma to an array of
physical addresses. This makes it easier for each device driver to
add support for the reg_io_mr provider method.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 drivers/infiniband/core/umem.c |  248 ++++++++++++++++++++++++++++++++++++++--
 include/rdma/ib_umem.h         |   14 ++
 2 files changed, 251 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 415e186..f103956 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -52,16 +52,18 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 	int i;
 
 	list_for_each_entry_safe(chunk, tmp, &umem->chunk_list, list) {
-		ib_dma_unmap_sg(dev, chunk->page_list,
-				chunk->nents, DMA_BIDIRECTIONAL);
-		for (i = 0; i < chunk->nents; ++i) {
-			struct page *page = sg_page(&chunk->page_list[i]);
-
-			if (umem->writable && dirty)
-				set_page_dirty_lock(page);
-			put_page(page);
-		}
+		if (umem->type == IB_UMEM_MEM_MAP) {
+			ib_dma_unmap_sg(dev, chunk->page_list,
+					chunk->nents, DMA_BIDIRECTIONAL);
+			for (i = 0; i < chunk->nents; ++i) {
+				struct page *page =
+					sg_page(&chunk->page_list[i]);
 
+				if (umem->writable && dirty)
+					set_page_dirty_lock(page);
+				put_page(page);
+			}
+		}
 		kfree(chunk);
 	}
 }
@@ -150,7 +152,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	while (npages) {
 		ret = get_user_pages(current, current->mm, cur_base,
 				     min_t(unsigned long, npages,
-					   PAGE_SIZE / sizeof (struct page *)),
+					   PAGE_SIZE / sizeof(struct page *)),
 				     1, !umem->writable, page_list, vma_list);
 
 		if (ret < 0)
@@ -162,7 +164,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		off = 0;
 
 		while (ret) {
-			chunk = kmalloc(sizeof *chunk + sizeof (struct scatterlist) *
+			chunk = kmalloc(sizeof *chunk +
+					sizeof(struct scatterlist) *
 					min_t(int, ret, IB_UMEM_MAX_PAGE_CHUNK),
 					GFP_KERNEL);
 			if (!chunk) {
@@ -292,3 +295,226 @@ int ib_umem_page_count(struct ib_umem *umem)
 	return n;
 }
 EXPORT_SYMBOL(ib_umem_page_count);
+/*
+ * Return the PFN for the specified address in the vma. This only
+ * works for a vma that is VM_PFNMAP.
+ */
+static unsigned long follow_io_pfn(struct vm_area_struct *vma,
+				   unsigned long address, int write)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	unsigned long pfn;
+	struct mm_struct *mm = vma->vm_mm;
+
+	BUG_ON(0 == (vma->vm_flags & VM_PFNMAP));
+
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		return 0;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud))
+		return 0;
+	if (unlikely(pud_bad(*pud)))
+		return 0;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd))
+		return 0;
+	if (unlikely(pmd_bad(*pmd)))
+		return 0;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	pte = *ptep;
+	if (!pte_present(pte))
+		goto bad;
+	if (write && !pte_write(pte))
+		goto bad;
+
+	pfn = pte_pfn(pte);
+	pte_unmap_unlock(ptep, ptl);
+	return pfn;
+ bad:
+	pte_unmap_unlock(ptep, ptl);
+	return 0;
+}
+
+int ib_get_io_pfn(struct task_struct *tsk, struct mm_struct *mm,
+		  unsigned long start, int len, int write, int force,
+		  unsigned long *pfn_list, struct vm_area_struct **vmas)
+{
+	unsigned long pfn;
+	int i;
+	if (len <= 0)
+		return 0;
+
+	i = 0;
+	do {
+		struct vm_area_struct *vma;
+
+		vma = find_vma(mm, start);
+		if (0 == (vma->vm_flags & VM_PFNMAP))
+			return -EINVAL;
+
+		if (0 == (vma->vm_flags & VM_IO))
+			return -EFAULT;
+
+		if (is_vm_hugetlb_page(vma))
+			return -EFAULT;
+
+		do {
+			cond_resched();
+			pfn = follow_io_pfn(vma, start, write);
+			if (!pfn)
+				return -EFAULT;
+			if (pfn_list)
+				pfn_list[i] = pfn;
+			if (vmas)
+				vmas[i] = vma;
+			i++;
+			start += PAGE_SIZE;
+			len--;
+		} while (len && start < vma->vm_end);
+	} while (len);
+	return i;
+}
+
+/**
+ * ib_iomem_get - DMA map a userspace map of IO memory.
+ * @context: userspace context to map memory for
+ * @addr: userspace virtual address to start at
+ * @size: length of region to map
+ * @access: IB_ACCESS_xxx flags for memory being mapped
+ * @dmasync: flush in-flight DMA when the memory region is written
+ */
+struct ib_umem *ib_iomem_get(struct ib_ucontext *context, unsigned long addr,
+			     size_t size, int access, int dmasync)
+{
+	struct ib_umem *umem;
+	unsigned long *pfn_list;
+	struct ib_umem_chunk *chunk;
+	unsigned long locked;
+	unsigned long lock_limit;
+	unsigned long cur_base;
+	unsigned long npages;
+	int ret;
+	int off;
+	int i;
+	DEFINE_DMA_ATTRS(attrs);
+
+	if (dmasync)
+		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
+
+	if (!can_do_mlock())
+		return ERR_PTR(-EPERM);
+
+	umem = kmalloc(sizeof *umem, GFP_KERNEL);
+	if (!umem)
+		return ERR_PTR(-ENOMEM);
+
+	umem->type	= IB_UMEM_IO_MAP;
+	umem->context   = context;
+	umem->length    = size;
+	umem->offset    = addr & ~PAGE_MASK;
+	umem->page_size = PAGE_SIZE;
+	/*
+	 * We ask for writable memory if any access flags other than
+	 * "remote read" are set.  "Local write" and "remote write"
+	 * obviously require write access.  "Remote atomic" can do
+	 * things like fetch and add, which will modify memory, and
+	 * "MW bind" can change permissions by binding a window.
+	 */
+	umem->writable  = !!(access & ~IB_ACCESS_REMOTE_READ);
+
+	/* IO memory is not hugetlb memory */
+	umem->hugetlb   = 0;
+
+	INIT_LIST_HEAD(&umem->chunk_list);
+
+	pfn_list = (unsigned long *) __get_free_page(GFP_KERNEL);
+	if (!pfn_list) {
+		kfree(umem);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	npages = PAGE_ALIGN(size + umem->offset) >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+
+	locked     = npages + current->mm->locked_vm;
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
+		>> PAGE_SHIFT;
+
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cur_base = addr & PAGE_MASK;
+
+	ret = 0;
+	while (npages) {
+		ret = ib_get_io_pfn(current, current->mm, cur_base,
+				    min_t(unsigned long, npages,
+					  PAGE_SIZE / sizeof(unsigned long *)),
+				    umem->writable,
+				    !umem->writable, pfn_list, NULL);
+
+		if (ret < 0)
+			goto out;
+
+		cur_base += ret * PAGE_SIZE;
+		npages   -= ret;
+
+		off = 0;
+
+		while (ret) {
+			chunk = kmalloc(sizeof *chunk +
+					sizeof(struct scatterlist) *
+					min_t(int, ret, IB_UMEM_MAX_PAGE_CHUNK),
+					GFP_KERNEL);
+			if (!chunk) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			chunk->nents = min_t(int, ret, IB_UMEM_MAX_PAGE_CHUNK);
+			sg_init_table(chunk->page_list, chunk->nents);
+			/* The pfn_list we built is a set of Page
+			 * Frame Numbers (PFN) whose physical address
+			 * is PFN << PAGE_SHIFT. The SG DMA mapping
+			 * services expect page addresses, not PFN,
+			 * therefore, we have to do the dma mapping
+			 * ourselves here. */
+			for (i = 0; i < chunk->nents; ++i) {
+				sg_set_page(&chunk->page_list[i], 0,
+					    PAGE_SIZE, 0);
+				chunk->page_list[i].dma_address =
+					(pfn_list[i] << PAGE_SHIFT);
+				chunk->page_list[i].dma_length = PAGE_SIZE;
+			}
+			chunk->nmap = chunk->nents;
+			ret -= chunk->nents;
+			off += chunk->nents;
+			list_add_tail(&chunk->list, &umem->chunk_list);
+		}
+
+		ret = 0;
+	}
+
+out:
+	if (ret < 0) {
+		__ib_umem_release(context->device, umem, 0);
+		kfree(umem);
+	} else
+		current->mm->locked_vm = locked;
+	up_write(&current->mm->mmap_sem);
+	free_page((unsigned long) pfn_list);
+
+	return ret < 0 ? ERR_PTR(ret) : umem;
+}
+EXPORT_SYMBOL(ib_iomem_get);
+
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 9ee0d2e..2c64d82 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -39,8 +39,14 @@
 
 struct ib_ucontext;
 
+enum ib_umem_type {
+	IB_UMEM_MEM_MAP = 0,
+	IB_UMEM_IO_MAP = 1
+};
+
 struct ib_umem {
 	struct ib_ucontext     *context;
+	enum ib_umem_type	type;
 	size_t			length;
 	int			offset;
 	int			page_size;
@@ -61,6 +67,8 @@ struct ib_umem_chunk {
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
+struct ib_umem *ib_iomem_get(struct ib_ucontext *context, unsigned long addr,
+			     size_t size, int access, int dmasync);
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			    size_t size, int access, int dmasync);
 void ib_umem_release(struct ib_umem *umem);
@@ -70,6 +78,12 @@ int ib_umem_page_count(struct ib_umem *umem);
 
 #include <linux/err.h>
 
+static struct ib_umem *ib_iomem_get(struct ib_ucontext *context,
+				    unsigned long addr, size_t size,
+				    int access, int dmasync) {
+	return ERR_PTR(-EINVAL);
+}
+
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
 					  int access, int dmasync) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
