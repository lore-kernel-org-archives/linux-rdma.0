From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 07/15] IB/usnic: Fix printk format warnings
Date: Thu,  9 Jan 2014 14:47:35 -0800
Message-ID: <1389307663-11296-8-git-send-email-umalhi@cisco.com>
References: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307663-11296-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

dma_addr_t is formatted as %llx and size_t as %lx at few places
in usNIC. Change these to %pa and %zx, respectively.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  6 +++---
 drivers/infiniband/hw/usnic/usnic_uiom.c     | 32 ++++++++++++++++------------
 drivers/infiniband/hw/usnic/usnic_vnic.c     |  4 ++--
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 9f0945a..8f8dfa2 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -592,7 +592,7 @@ int usnic_ib_dereg_mr(struct ib_mr *ibmr)
 {
 	struct usnic_ib_mr *mr = to_umr(ibmr);
 
-	usnic_dbg("va 0x%lx length 0x%lx\n", mr->umem->va, mr->umem->length);
+	usnic_dbg("va 0x%lx length 0x%zx\n", mr->umem->va, mr->umem->length);
 
 	usnic_uiom_reg_release(mr->umem, ibmr->pd->uobject->context->closing);
 	kfree(mr);
@@ -667,8 +667,8 @@ int usnic_ib_mmap(struct ib_ucontext *context,
 			}
 			bus_addr = bar->bus_addr;
 			len = bar->len;
-			usnic_dbg("bus: 0x%llx vaddr: %p size: %ld\n",
-					bus_addr, bar->vaddr, bar->len);
+			usnic_dbg("bus: %pa vaddr: %p size: %ld\n",
+					&bus_addr, bar->vaddr, bar->len);
 			mutex_unlock(&us_ibdev->usdev_lock);
 
 			return remap_pfn_range(vma,
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 359897d..0477d70 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -81,15 +81,16 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
 	struct usnic_uiom_chunk *chunk, *tmp;
 	struct page *page;
 	int i;
+	dma_addr_t pa;
 
 	list_for_each_entry_safe(chunk, tmp, chunk_list, list) {
 		for (i = 0; i < chunk->nents; i++) {
 			page = sg_page(&chunk->page_list[i]);
+			pa = sg_phys(&chunk->page_list[i]);
 			if (dirty)
 				set_page_dirty_lock(page);
 			put_page(page);
-			usnic_dbg("pa: 0x%llx\n",
-					sg_phys(&chunk->page_list[i]));
+			usnic_dbg("pa: %pa\n", &pa);
 		}
 		kfree(chunk);
 	}
@@ -108,6 +109,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 	int off;
 	int i;
 	int flags;
+	dma_addr_t pa;
 	DEFINE_DMA_ATTRS(attrs);
 
 	if (dmasync)
@@ -167,9 +169,9 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 				sg_set_page(&chunk->page_list[i],
 							page_list[i + off],
 							PAGE_SIZE, 0);
-				usnic_dbg("va: 0x%lx pa: 0x%llx\n",
-						cur_base + i*PAGE_SIZE,
-						sg_phys(&chunk->page_list[i]));
+				pa = sg_phys(&chunk->page_list[i]);
+				usnic_dbg("va: 0x%lx pa: %pa\n",
+						cur_base + i*PAGE_SIZE, &pa);
 			}
 			cur_base += chunk->nents * PAGE_SIZE;
 			ret -= chunk->nents;
@@ -247,7 +249,9 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 	size_t size;
 	struct usnic_uiom_chunk *chunk;
 	struct usnic_uiom_interval_node *interval_node;
-	long int pa, pa_start, pa_end;
+	dma_addr_t pa;
+	dma_addr_t pa_start = 0;
+	dma_addr_t pa_end = 0;
 	long int va_start = -EINVAL;
 	struct usnic_uiom_pd *pd = uiomr->pd;
 	long int va = uiomr->va & PAGE_MASK;
@@ -276,13 +280,13 @@ iter_chunk:
 					(pa != pa_start)) {
 				/* PAs are not contiguous */
 				size = pa_end - pa_start + PAGE_SIZE;
-				usnic_dbg("va 0x%lx pa 0x%lx size 0x%lx flags 0x%x",
-					va_start, pa_start, size, flags);
+				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
+					va_start, &pa_start, size, flags);
 				err = iommu_map(pd->domain, va_start, pa_start,
 							size, flags);
 				if (err) {
-					usnic_err("Failed to map va 0x%lx pa 0x%lx size 0x%zx with err %d\n",
-						va_start, pa_start, size, err);
+					usnic_err("Failed to map va 0x%lx pa 0x%pa size 0x%zx with err %d\n",
+						va_start, &pa_start, size, err);
 					goto err_out;
 				}
 				va_start = va;
@@ -293,13 +297,13 @@ iter_chunk:
 			if ((va >> PAGE_SHIFT) == interval_node->last) {
 				/* Last page of the interval */
 				size = pa - pa_start + PAGE_SIZE;
-				usnic_dbg("va 0x%lx pa 0x%lx size 0x%lx flags 0x%x\n",
-					va_start, pa_start, size, flags);
+				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
+					va_start, &pa_start, size, flags);
 				err = iommu_map(pd->domain, va_start, pa_start,
 						size, flags);
 				if (err) {
-					usnic_err("Failed to map va 0x%lx pa 0x%lx size 0x%zx with err %d\n",
-						va_start, pa_start, size, err);
+					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
+						va_start, &pa_start, size, err);
 					goto err_out;
 				}
 				break;
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index ff0b32d..02d66d9 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -86,9 +86,9 @@ int usnic_vnic_dump(struct usnic_vnic *vnic, char *buf,
 	offset = 0;
 	bar0 = usnic_vnic_get_bar(vnic, 0);
 	offset += scnprintf(buf + offset, buf_sz - offset,
-			"VF:%hu BAR0 bus_addr=0x%llx vaddr=0x%p size=%ld ",
+			"VF:%hu BAR0 bus_addr=%pa vaddr=0x%p size=%ld ",
 			usnic_vnic_get_index(vnic),
-			bar0->bus_addr,
+			&bar0->bus_addr,
 			bar0->vaddr, bar0->len);
 	if (printtitle)
 		offset += printtitle(hdr_obj, buf + offset, buf_sz - offset);
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
