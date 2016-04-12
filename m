From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/12] IB/hfi1: Prevent unpinning of wrong pages
Date: Tue, 12 Apr 2016 10:46:16 -0700
Message-ID: <20160412174615.19295.59944.stgit@scvm10.sc.intel.com>
References: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412173504.19295.7241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The routine used by the SDMA cache to handle already
cached nodes can extend an already existing node.

In its error handling code, the routine will unpin pages
when not all pages of the buffer extension were pinned.

There was a bug in that part of the routine, which would
mistakenly unpin pages from the original set rather than
the newly pinned pages.

This commit fixes that bug by offsetting the page array
to the proper place pointing at the beginning of the newly
pinned pages.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index e08c74f..d53a659 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -278,7 +278,8 @@ static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
 static void user_sdma_free_request(struct user_sdma_request *, bool);
 static int pin_vector_pages(struct user_sdma_request *,
 			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct mm_struct *, struct page **, unsigned);
+static void unpin_vector_pages(struct mm_struct *, struct page **, unsigned,
+			       unsigned);
 static int check_header_template(struct user_sdma_request *,
 				 struct hfi1_pkt_header *, u32, u32);
 static int set_txreq_header(struct user_sdma_request *,
@@ -1110,7 +1111,8 @@ retry:
 			goto bail;
 		}
 		if (pinned != npages) {
-			unpin_vector_pages(current->mm, pages, pinned);
+			unpin_vector_pages(current->mm, pages, node->npages,
+					   pinned);
 			ret = -EFAULT;
 			goto bail;
 		}
@@ -1150,9 +1152,9 @@ bail:
 }
 
 static void unpin_vector_pages(struct mm_struct *mm, struct page **pages,
-			       unsigned npages)
+			       unsigned start, unsigned npages)
 {
-	hfi1_release_user_pages(mm, pages, npages, 0);
+	hfi1_release_user_pages(mm, pages + start, npages, 0);
 	kfree(pages);
 }
 
@@ -1566,7 +1568,8 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 	 * prevent a deadlock when hfi1_release_user_pages() attempts to
 	 * take the mmap_sem, which the MMU notifier has already taken.
 	 */
-	unpin_vector_pages(mm ? NULL : current->mm, node->pages, node->npages);
+	unpin_vector_pages(mm ? NULL : current->mm, node->pages, 0,
+			   node->npages);
 	/*
 	 * If called by the MMU notifier, we have to adjust the pinned
 	 * page count ourselves.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
