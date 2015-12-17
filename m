From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/14] staging/rdma/hfi1: Start adding building blocks for TID caching
Date: Thu, 17 Dec 2015 02:00:18 -0500
Message-ID: <1450335624-12134-9-git-send-email-ira.weiny@intel.com>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450335624-12134-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Functions added by this patch are building blocks for the upcoming
TID caching functionality. The functions added are currently unsed
(and marked as such.)

The functions' purposes are to find physically contigous pages in
the user's virtual buffer, program the RcvArray group entries with
these physical chunks, and unprogram the RcvArray groups.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 310 +++++++++++++++++++++++++++++++
 1 file changed, 310 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 7f15024daab9..0eb888fcaf70 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -83,8 +83,20 @@ static const char * const mmu_types[] = {
 	"RANGE"
 };
 
+struct tid_pageset {
+	u16 idx;
+	u16 count;
+};
+
 #define EXP_TID_SET_EMPTY(set) (set.count == 0 && list_empty(&set.list))
 
+static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
+			    struct rb_root *) __maybe_unused;
+static u32 find_phys_blocks(struct page **, unsigned,
+			    struct tid_pageset *) __maybe_unused;
+static int set_rcvarray_entry(struct file *, unsigned long, u32,
+			      struct tid_group *, struct page **,
+			      unsigned) __maybe_unused;
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
 static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
@@ -103,6 +115,21 @@ static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
 static inline void mmu_notifier_range_start(struct mmu_notifier *,
 					    struct mm_struct *,
 					    unsigned long, unsigned long);
+static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
+			    struct tid_pageset *, unsigned, u16, struct page **,
+			    u32 *, unsigned *, unsigned *) __maybe_unused;
+static int unprogram_rcvarray(struct file *, u32,
+			      struct tid_group **) __maybe_unused;
+static void clear_tid_node(struct hfi1_filedata *, u16,
+			   struct mmu_rb_node *) __maybe_unused;
+
+static inline u32 rcventry2tidinfo(u32 rcventry)
+{
+	u32 pair = rcventry & ~0x1;
+
+	return EXP_TID_SET(IDX, pair >> 1) |
+		EXP_TID_SET(CTRL, 1 << (rcventry - pair));
+}
 
 static inline void exp_tid_group_init(struct exp_tid_set *set)
 {
@@ -193,6 +220,289 @@ int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo)
 	return -EINVAL;
 }
 
+static u32 find_phys_blocks(struct page **pages, unsigned npages,
+			    struct tid_pageset *list)
+{
+	unsigned pagecount, pageidx, setcount = 0, i;
+	unsigned long pfn, this_pfn;
+
+	if (!npages)
+		return 0;
+
+	/*
+	 * Look for sets of physically contiguous pages in the user buffer.
+	 * This will allow us to optimize Expected RcvArray entry usage by
+	 * using the bigger supported sizes.
+	 */
+	pfn = page_to_pfn(pages[0]);
+	for (pageidx = 0, pagecount = 1, i = 1; i <= npages; i++) {
+		this_pfn = i < npages ? page_to_pfn(pages[i]) : 0;
+
+		/*
+		 * If the pfn's are not sequential, pages are not physically
+		 * contiguous.
+		 */
+		if (this_pfn != ++pfn) {
+			/*
+			 * At this point we have to loop over the set of
+			 * physically contiguous pages and break them down it
+			 * sizes supported by the HW.
+			 * There are two main constraints:
+			 *     1. The max buffer size is MAX_EXPECTED_BUFFER.
+			 *        If the total set size is bigger than that
+			 *        program only a MAX_EXPECTED_BUFFER chunk.
+			 *     2. The buffer size has to be a power of two. If
+			 *        it is not, round down to the closes power of
+			 *        2 and program that size.
+			 */
+			while (pagecount) {
+				int maxpages = pagecount;
+				u32 bufsize = pagecount * PAGE_SIZE;
+
+				if (bufsize > MAX_EXPECTED_BUFFER)
+					maxpages =
+						MAX_EXPECTED_BUFFER >>
+						PAGE_SHIFT;
+				else if (!is_power_of_2(bufsize))
+					maxpages =
+						rounddown_pow_of_two(bufsize) >>
+						PAGE_SHIFT;
+
+				list[setcount].idx = pageidx;
+				list[setcount].count = maxpages;
+				pagecount -= maxpages;
+				pageidx += maxpages;
+				setcount++;
+			}
+			pageidx = i;
+			pagecount = 1;
+			pfn = this_pfn;
+		} else {
+			pagecount++;
+		}
+	}
+	return setcount;
+}
+
+static int program_rcvarray(struct file *fp, unsigned long vaddr,
+			    struct tid_group *grp,
+			    struct tid_pageset *sets,
+			    unsigned start, u16 count, struct page **pages,
+			    u32 *tidlist, unsigned *tididx, unsigned *pmapped)
+{
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = uctxt->dd;
+	u16 idx;
+	u32 tidinfo = 0, rcventry, useidx = 0;
+	int mapped = 0;
+
+	/* Count should never be larger than the group size */
+	if (count > grp->size)
+		return -EINVAL;
+
+	/* Find the first unused entry in the group */
+	for (idx = 0; idx < grp->size; idx++) {
+		if (!(grp->map & (1 << idx))) {
+			useidx = idx;
+			break;
+		}
+		rcv_array_wc_fill(dd, grp->base + idx);
+	}
+
+	idx = 0;
+	while (idx < count) {
+		u16 npages, pageidx, setidx = start + idx;
+		int ret = 0;
+
+		/*
+		 * If this entry in the group is used, move to the next one.
+		 * If we go past the end of the group, exit the loop.
+		 */
+		if (useidx >= grp->size) {
+			break;
+		} else if (grp->map & (1 << useidx)) {
+			rcv_array_wc_fill(dd, grp->base + useidx);
+			useidx++;
+			continue;
+		}
+
+		rcventry = grp->base + useidx;
+		npages = sets[setidx].count;
+		pageidx = sets[setidx].idx;
+
+		ret = set_rcvarray_entry(fp, vaddr + (pageidx * PAGE_SIZE),
+					 rcventry, grp, pages + pageidx,
+					 npages);
+		if (ret)
+			return ret;
+		mapped += npages;
+
+		tidinfo = rcventry2tidinfo(rcventry - uctxt->expected_base) |
+			EXP_TID_SET(LEN, npages);
+		tidlist[(*tididx)++] = tidinfo;
+		grp->used++;
+		grp->map |= 1 << useidx++;
+		idx++;
+	}
+
+	/* Fill the rest of the group with "blank" writes */
+	for (; useidx < grp->size; useidx++)
+		rcv_array_wc_fill(dd, grp->base + useidx);
+	*pmapped = mapped;
+	return idx;
+}
+
+static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
+			      u32 rcventry, struct tid_group *grp,
+			      struct page **pages, unsigned npages)
+{
+	int ret;
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct mmu_rb_node *node;
+	struct hfi1_devdata *dd = uctxt->dd;
+	struct rb_root *root = &fd->tid_rb_root;
+	dma_addr_t phys;
+
+	/*
+	 * Allocate the node first so we can handle a potential
+	 * failure before we've programmed anything.
+	 */
+	node = kzalloc(sizeof(*node) + (sizeof(struct page *) * npages),
+		       GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	phys = pci_map_single(dd->pcidev,
+			      __va(page_to_phys(pages[0])),
+			      npages * PAGE_SIZE, PCI_DMA_FROMDEVICE);
+	if (dma_mapping_error(&dd->pcidev->dev, phys)) {
+		dd_dev_err(dd, "Failed to DMA map Exp Rcv pages 0x%llx\n",
+			   phys);
+		kfree(node);
+		return -EFAULT;
+	}
+
+	node->virt = vaddr;
+	node->phys = page_to_phys(pages[0]);
+	node->len = npages * PAGE_SIZE;
+	node->npages = npages;
+	node->rcventry = rcventry;
+	node->dma_addr = phys;
+	node->grp = grp;
+	node->freed = false;
+	memcpy(node->pages, pages, sizeof(struct page *) * npages);
+
+	spin_lock(&fd->rb_lock);
+	ret = fd->mmu_rb_insert(root, node);
+	spin_unlock(&fd->rb_lock);
+
+	if (ret) {
+		hfi1_cdbg(TID, "Failed to insert RB node %u 0x%lx, 0x%lx %d",
+			  node->rcventry, node->virt, node->phys, ret);
+		pci_unmap_single(dd->pcidev, phys, npages * PAGE_SIZE,
+				 PCI_DMA_FROMDEVICE);
+		kfree(node);
+		return -EFAULT;
+	}
+	hfi1_put_tid(dd, rcventry, PT_EXPECTED, phys, ilog2(npages) + 1);
+	return 0;
+}
+
+static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
+			      struct tid_group **grp)
+{
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = uctxt->dd;
+	struct mmu_rb_node *node;
+	u8 tidctrl = EXP_TID_GET(tidinfo, CTRL);
+	u32 tidbase = uctxt->expected_base,
+		tididx = EXP_TID_GET(tidinfo, IDX) << 1, rcventry;
+
+	if (tididx > uctxt->expected_count) {
+		dd_dev_err(dd, "Invalid RcvArray entry (%u) index for ctxt %u\n",
+			   tididx, uctxt->ctxt);
+		return -EINVAL;
+	}
+
+	if (tidctrl == 0x3)
+		return -EINVAL;
+
+	rcventry = tidbase + tididx + (tidctrl - 1);
+
+	spin_lock(&fd->rb_lock);
+	node = mmu_rb_search_by_entry(&fd->tid_rb_root, rcventry);
+	if (!node) {
+		spin_unlock(&fd->rb_lock);
+		return -EBADF;
+	}
+	rb_erase(&node->rbnode, &fd->tid_rb_root);
+	spin_unlock(&fd->rb_lock);
+	if (grp)
+		*grp = node->grp;
+	clear_tid_node(fd, fd->subctxt, node);
+	return 0;
+}
+
+static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
+			   struct mmu_rb_node *node)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = uctxt->dd;
+
+	hfi1_put_tid(dd, node->rcventry, PT_INVALID, 0, 0);
+	/*
+	 * Make sure device has seen the write before we unpin the
+	 * pages.
+	 */
+	flush_wc();
+
+	pci_unmap_single(dd->pcidev, node->dma_addr, node->len,
+			 PCI_DMA_FROMDEVICE);
+	hfi1_release_user_pages(node->pages, node->npages, true);
+
+	node->grp->used--;
+	node->grp->map &= ~(1 << (node->rcventry - node->grp->base));
+
+	if (node->grp->used == node->grp->size - 1)
+		tid_group_move(node->grp, &uctxt->tid_full_list,
+			       &uctxt->tid_used_list);
+	else if (!node->grp->used)
+		tid_group_move(node->grp, &uctxt->tid_used_list,
+			       &uctxt->tid_group_list);
+	kfree(node);
+}
+
+static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
+			    struct exp_tid_set *set, struct rb_root *root)
+{
+	struct tid_group *grp, *ptr;
+	struct hfi1_filedata *fd = container_of(root, struct hfi1_filedata,
+						tid_rb_root);
+	int i;
+
+	list_for_each_entry_safe(grp, ptr, &set->list, list) {
+		list_del_init(&grp->list);
+
+		spin_lock(&fd->rb_lock);
+		for (i = 0; i < grp->size; i++) {
+			if (grp->map & (1 << i)) {
+				u16 rcventry = grp->base + i;
+				struct mmu_rb_node *node;
+
+				node = mmu_rb_search_by_entry(root, rcventry);
+				if (!node)
+					continue;
+				rb_erase(&node->rbnode, root);
+				clear_tid_node(fd, -1, node);
+			}
+		}
+		spin_unlock(&fd->rb_lock);
+	}
+}
+
 static inline void mmu_notifier_page(struct mmu_notifier *mn,
 				     struct mm_struct *mm, unsigned long addr)
 {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
