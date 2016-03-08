From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/16] IB/hfi1: Specify mm when releasing pages
Date: Tue, 08 Mar 2016 11:15:33 -0800
Message-ID: <20160308191533.30542.73584.stgit@scvm10.sc.intel.com>
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

This change adds a pointer to the process mm_struct when
calling hfi1_release_user_pages().

Previously, the function used the mm_struct of the current
process to adjust the number of pinned pages. However, is some
cases, namely when unpinning pages due to a MMU notifier call,
we want to drop into that code block as it will cause a deadlock
(the MMU notifiers take the process' mmap_sem prior to calling
the callbacks).

By allowing to caller to specify the pointer to the mm_struct,
the caller has finer control over that part of hfi1_release_user_pages().

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h          |    2 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    4 ++--
 drivers/infiniband/hw/hfi1/user_pages.c   |   11 ++++++-----
 drivers/infiniband/hw/hfi1/user_sdma.c    |   19 +++++++++++++------
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index ff3b37a..3dc644d 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1666,7 +1666,7 @@ void shutdown_led_override(struct hfi1_pportdata *ppd);
 
 bool hfi1_can_pin_pages(struct hfi1_devdata *, u32, u32);
 int hfi1_acquire_user_pages(unsigned long, size_t, bool, struct page **);
-void hfi1_release_user_pages(struct page **, size_t, bool);
+void hfi1_release_user_pages(struct mm_struct *, struct page **, size_t, bool);
 
 static inline void clear_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index bf670cb..591605a 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -550,7 +550,7 @@ nomem:
 	 * for example), unpin all unmapped pages so we can pin them nex time.
 	 */
 	if (mapped_pages != pinned)
-		hfi1_release_user_pages(&pages[mapped_pages],
+		hfi1_release_user_pages(current->mm, &pages[mapped_pages],
 					pinned - mapped_pages,
 					false);
 bail:
@@ -923,7 +923,7 @@ static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
 
 	pci_unmap_single(dd->pcidev, node->dma_addr, node->mmu.len,
 			 PCI_DMA_FROMDEVICE);
-	hfi1_release_user_pages(node->pages, node->npages, true);
+	hfi1_release_user_pages(current->mm, node->pages, node->npages, true);
 
 	node->grp->used--;
 	node->grp->map &= ~(1 << (node->rcventry - node->grp->base));
diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index bd7a8ab..88e10b5 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -116,7 +116,8 @@ int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
 	return ret;
 }
 
-void hfi1_release_user_pages(struct page **p, size_t npages, bool dirty)
+void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
+			     size_t npages, bool dirty)
 {
 	size_t i;
 
@@ -126,9 +127,9 @@ void hfi1_release_user_pages(struct page **p, size_t npages, bool dirty)
 		put_page(p[i]);
 	}
 
-	if (current->mm) { /* during close after signal, mm can be NULL */
-		down_write(&current->mm->mmap_sem);
-		current->mm->pinned_vm -= npages;
-		up_write(&current->mm->mmap_sem);
+	if (mm) { /* during close after signal, mm can be NULL */
+		down_write(&mm->mmap_sem);
+		mm->pinned_vm -= npages;
+		up_write(&mm->mmap_sem);
 	}
 }
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index a53edb9..bf55a41 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -277,7 +277,7 @@ static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
 static void user_sdma_free_request(struct user_sdma_request *, bool);
 static int pin_vector_pages(struct user_sdma_request *,
 			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct page **, unsigned);
+static void unpin_vector_pages(struct mm_struct *, struct page **, unsigned);
 static int check_header_template(struct user_sdma_request *,
 				 struct hfi1_pkt_header *, u32, u32);
 static int set_txreq_header(struct user_sdma_request *,
@@ -1072,7 +1072,7 @@ static int pin_vector_pages(struct user_sdma_request *req,
 			goto bail;
 		}
 		if (pinned != npages) {
-			unpin_vector_pages(pages, pinned);
+			unpin_vector_pages(current->mm, pages, pinned);
 			ret = -EFAULT;
 			goto bail;
 		}
@@ -1097,9 +1097,10 @@ bail:
 	return ret;
 }
 
-static void unpin_vector_pages(struct page **pages, unsigned npages)
+static void unpin_vector_pages(struct mm_struct *mm, struct page **pages,
+			       unsigned npages)
 {
-	hfi1_release_user_pages(pages, npages, 0);
+	hfi1_release_user_pages(mm, pages, npages, 0);
 	kfree(pages);
 }
 
@@ -1502,8 +1503,14 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
 
-	if (!notifier)
-		unpin_vector_pages(node->pages, node->npages);
+	unpin_vector_pages(notifier ? NULL : current->mm, node->pages,
+			   node->npages);
+	/*
+	 * If called by the MMU notifier, we have to adjust the pinned
+	 * page count ourselves.
+	 */
+	if (notifier)
+		current->mm->pinned_vm -= node->npages;
 	kfree(node);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
