From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 4/6] drivers/IB,hfi1: do not se mmap_sem
Date: Wed,  6 Feb 2019 09:59:18 -0800
Message-ID: <20190206175920.31082-5-dave@stgolabs.net>
References: <20190206175920.31082-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206175920.31082-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca, akpm@linux-foundation.org
Cc: dledford@redhat.com, jgg@mellanox.com, jack@suse.cz, willy@infradead.org, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.det>
List-Id: linux-rdma@vger.kernel.org

This driver already uses gup_fast() and thus we can just drop
the mmap_sem protection around the pinned_vm counter. Note that
the window between when hfi1_can_pin_pages() is called and the
actual counter is incremented remains the same as mmap_sem was
_only_ used for when ->pinned_vm was touched.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Davidlohr Bueso <dbueso@suse.det>
---
 drivers/infiniband/hw/hfi1/user_pages.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index 40a6e434190f..24b592c6522e 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -91,9 +91,7 @@ bool hfi1_can_pin_pages(struct hfi1_devdata *dd, struct mm_struct *mm,
 	/* Convert to number of pages */
 	size = DIV_ROUND_UP(size, PAGE_SIZE);
 
-	down_read(&mm->mmap_sem);
 	pinned = atomic64_read(&mm->pinned_vm);
-	up_read(&mm->mmap_sem);
 
 	/* First, check the absolute limit against all pinned pages. */
 	if (pinned + npages >= ulimit && !can_lock)
@@ -111,9 +109,7 @@ int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t np
 	if (ret < 0)
 		return ret;
 
-	down_write(&mm->mmap_sem);
 	atomic64_add(ret, &mm->pinned_vm);
-	up_write(&mm->mmap_sem);
 
 	return ret;
 }
@@ -130,8 +126,6 @@ void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
 	}
 
 	if (mm) { /* during close after signal, mm can be NULL */
-		down_write(&mm->mmap_sem);
 		atomic64_sub(npages, &mm->pinned_vm);
-		up_write(&mm->mmap_sem);
 	}
 }
-- 
2.16.4
