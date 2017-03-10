From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] infiniband: Fix alignment of mmap cookies to support VIPT
 caching
Date: Fri, 10 Mar 2017 11:34:20 -0700
Message-ID: <20170310183420.GA7410@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When vmalloc_user is used to create memory that is supposed to be mmap'd
to user space, it is necessary for the mmap cookie (eg the offset) to be
aligned to SHMLBA.

This creates a situation where all virtual mappings of the same physical
page share the same virtual cache index and guarantees VIPT coherence.
Otherwise the cache is non-coherent and the kernel will not see writes
by userspace when reading the shared page (or vice-versa).

Reported-by: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mmap.c  | 4 ++--
 drivers/infiniband/sw/rxe/rxe_mmap.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

The psm cdevs are still broken. Josh confirmed the patch does what it
is supposed to, but it doesn't fix VIVT caches.

It is depressing the exact same lines are copied between rxe and
rdmavt.

diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index e202b8142759f5..6b712eecbd37d9 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -170,9 +170,9 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 
 	spin_lock_irq(&rdi->mmap_offset_lock);
 	if (rdi->mmap_offset == 0)
-		rdi->mmap_offset = PAGE_SIZE;
+		rdi->mmap_offset = ALIGN(PAGE_SIZE, SHMLBA);
 	ip->offset = rdi->mmap_offset;
-	rdi->mmap_offset += size;
+	rdi->mmap_offset += ALIGN(size, SHMLBA);
 	spin_unlock_irq(&rdi->mmap_offset_lock);
 
 	INIT_LIST_HEAD(&ip->pending_mmaps);
diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index c572a4c09359c9..bd812e00988ed3 100644
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c
+++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -156,10 +156,10 @@ struct rxe_mmap_info *rxe_create_mmap_info(struct rxe_dev *rxe,
 	spin_lock_bh(&rxe->mmap_offset_lock);
 
 	if (rxe->mmap_offset == 0)
-		rxe->mmap_offset = PAGE_SIZE;
+		rxe->mmap_offset = ALIGN(PAGE_SIZE, SHMLBA);
 
 	ip->info.offset = rxe->mmap_offset;
-	rxe->mmap_offset += size;
+	rxe->mmap_offset += ALIGN(size, SHMLBA);
 
 	spin_unlock_bh(&rxe->mmap_offset_lock);
 
-- 
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
