From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/16] IB/hfi1: Switch to using the pin query function
Date: Tue, 08 Mar 2016 11:15:39 -0800
Message-ID: <20160308191538.30542.88681.stgit@scvm10.sc.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308191210.30542.91885.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the new function to query whether the expected receive
user buffer can be pinned successfully. This requires that
a new variable be added to the hfi1_filedata structure used
to hold the number of pages pinned by the expected receive
code.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h          |    1 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 3dc644d..16cbdc4 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1190,6 +1190,7 @@ struct hfi1_filedata {
 	struct hfi1_user_sdma_pkt_q *pq;
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
+	u32 tid_n_pinned;
 	struct rb_root tid_rb_root;
 	struct tid_rb_node **entry_to_rb;
 	spinlock_t tid_lock; /* protect tid_[limit,used] counters */
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 591605a..0861e09 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -396,11 +396,14 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 	 * pages, accept the amount pinned so far and program only that.
 	 * User space knows how to deal with partially programmed buffers.
 	 */
+	if (!hfi1_can_pin_pages(dd, fd->tid_n_pinned, npages))
+		return -ENOMEM;
 	pinned = hfi1_acquire_user_pages(vaddr, npages, true, pages);
 	if (pinned <= 0) {
 		ret = pinned;
 		goto bail;
 	}
+	fd->tid_n_pinned += npages;
 
 	/* Find sets of physically contiguous pages */
 	npagesets = find_phys_blocks(pages, pinned, pagesets);
@@ -549,10 +552,12 @@ nomem:
 	 * If not everything was mapped (due to insufficient RcvArray entries,
 	 * for example), unpin all unmapped pages so we can pin them nex time.
 	 */
-	if (mapped_pages != pinned)
+	if (mapped_pages != pinned) {
 		hfi1_release_user_pages(current->mm, &pages[mapped_pages],
 					pinned - mapped_pages,
 					false);
+		fd->tid_n_pinned -= pinned - mapped_pages;
+	}
 bail:
 	kfree(pagesets);
 	kfree(pages);
@@ -924,6 +929,7 @@ static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
 	pci_unmap_single(dd->pcidev, node->dma_addr, node->mmu.len,
 			 PCI_DMA_FROMDEVICE);
 	hfi1_release_user_pages(current->mm, node->pages, node->npages, true);
+	fd->tid_n_pinned -= node->npages;
 
 	node->grp->used--;
 	node->grp->map &= ~(1 << (node->rcventry - node->grp->base));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
