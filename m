From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: change get_user_pages() usage to always NULL vmas
Date: Mon, 15 Sep 2014 11:42:53 -0400
Message-ID: <20140915154253.2053.65270.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The static helper routine, __qib_get_user_pages(), accepts
a vma arg, but current use always passes NULL.

This has caused some confusion associated with the correct
use of this argument, but since the current use case doesn't
require the flexiblity, the best thing to do is to simplfy
the code to always pass NULL to get_user_pages().

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_user_pages.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
index 2bc1d2b..74f90b2 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -52,7 +52,7 @@ static void __qib_release_user_pages(struct page **p, size_t num_pages,
  * Call with current->mm->mmap_sem held.
  */
 static int __qib_get_user_pages(unsigned long start_page, size_t num_pages,
-				struct page **p, struct vm_area_struct **vma)
+				struct page **p)
 {
 	unsigned long lock_limit;
 	size_t got;
@@ -69,7 +69,7 @@ static int __qib_get_user_pages(unsigned long start_page, size_t num_pages,
 		ret = get_user_pages(current, current->mm,
 				     start_page + got * PAGE_SIZE,
 				     num_pages - got, 1, 1,
-				     p + got, vma);
+				     p + got, NULL);
 		if (ret < 0)
 			goto bail_release;
 	}
@@ -136,7 +136,7 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
 
 	down_write(&current->mm->mmap_sem);
 
-	ret = __qib_get_user_pages(start_page, num_pages, p, NULL);
+	ret = __qib_get_user_pages(start_page, num_pages, p);
 
 	up_write(&current->mm->mmap_sem);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
