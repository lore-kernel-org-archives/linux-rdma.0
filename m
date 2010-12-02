From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 2/2] IB/uverbs: Add support for user registration of mmap
	memory
Date: Thu, 02 Dec 2010 13:02:30 -0600
Message-ID: <20101202190229.13657.85728.stgit@build.ogc.int>
References: <20101202190157.13657.58176.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101202190157.13657.58176.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tom-/Yg/VP3ZvrM@public.gmane.org, garlick-i2BcT+NCU+M@public.gmane.org, acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added support to the ib_umem_get helper function for handling
mmaped memory.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 drivers/infiniband/core/umem.c |  272 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 253 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 415e186..357ca5e 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -52,30 +52,24 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
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
+				struct page *page = sg_page(&chunk->page_list[i]);
 
+				if (umem->writable && dirty)
+					set_page_dirty_lock(page);
+				put_page(page);
+			}
+		}
 		kfree(chunk);
 	}
 }
 
-/**
- * ib_umem_get - Pin and DMA map userspace memory.
- * @context: userspace context to pin memory for
- * @addr: userspace virtual address to start at
- * @size: length of region to pin
- * @access: IB_ACCESS_xxx flags for memory being pinned
- * @dmasync: flush in-flight DMA when the memory region is written
- */
-struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync)
+static struct ib_umem *__umem_get(struct ib_ucontext *context,
+				  unsigned long addr, size_t size,
+				  int access, int dmasync)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -100,6 +94,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (!umem)
 		return ERR_PTR(-ENOMEM);
 
+	umem->type	= IB_UMEM_MEM_MAP;
 	umem->context   = context;
 	umem->length    = size;
 	umem->offset    = addr & ~PAGE_MASK;
@@ -215,6 +210,245 @@ out:
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
 }
+
+/*
+ * Return the PFN for the specified address in the vma. This only
+ * works for a vma that is VM_PFNMAP.
+ */
+static unsigned long __follow_io_pfn(struct vm_area_struct *vma,
+				     unsigned long address, int write)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	unsigned long pfn;
+	struct mm_struct *mm = vma->vm_mm;
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
+static int __get_io_pfn(struct task_struct *tsk, struct mm_struct *mm,
+			unsigned long start, int len, int write, int force,
+			unsigned long *pfn_list, struct vm_area_struct **vmas)
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
+		if (!(vma->vm_flags & VM_PFNMAP))
+			return -EINVAL;
+
+		if (!(vma->vm_flags & VM_IO))
+			return -EFAULT;
+
+		if (is_vm_hugetlb_page(vma))
+			return -EFAULT;
+
+		do {
+			cond_resched();
+			pfn = __follow_io_pfn(vma, start, write);
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
+static struct ib_umem *__iomem_get(struct ib_ucontext *context,
+				   unsigned long addr, size_t size,
+				   int access, int dmasync)
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
+
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
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
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
+		ret = __get_io_pfn(current, current->mm, cur_base,
+				   min_t(unsigned long, npages,
+					 PAGE_SIZE / sizeof(unsigned long *)),
+				   umem->writable,
+				   !umem->writable, pfn_list, NULL);
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
+					(pfn_list[i + off] << PAGE_SHIFT);
+				chunk->page_list[i].dma_length = PAGE_SIZE;
+			}
+			chunk->nmap = chunk->nents;
+			ret -= chunk->nents;
+			off += chunk->nents;
+			list_add_tail(&chunk->list, &umem->chunk_list);
+		}
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
+	return ret < 0 ? ERR_PTR(ret) : umem;
+}
+
+/**
+ * ib_umem_get - Pin and DMA map userspace memory.
+ * @context: userspace context to pin memory for
+ * @addr: userspace virtual address to start at
+ * @size: length of region to pin
+ * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmasync: flush in-flight DMA when the memory region is written
+ */
+struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
+			    size_t size, int access, int dmasync)
+{
+	/* Do a quick lookup of the containing VMA to determine it's type. */
+	struct vm_area_struct *vma;
+	int do_pfn_map = 0;
+
+	down_write(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, addr & PAGE_MASK);
+	if (vma)
+		do_pfn_map = vma->vm_flags & VM_PFNMAP;
+	up_write(&current->mm->mmap_sem);
+	if (!vma)
+		return ERR_PTR(-EINVAL);
+
+	if (do_pfn_map)
+		return __iomem_get(context, addr, size, access, dmasync);
+
+	return __umem_get(context, addr, size, access, dmasync);
+}
 EXPORT_SYMBOL(ib_umem_get);
 
 static void ib_umem_account(struct work_struct *work)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
