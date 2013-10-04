From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/qib: Convert qib_user_sdma_pin_pages() to use
 get_user_pages_fast()
Date: Fri, 04 Oct 2013 09:29:12 -0400
Message-ID: <20131004132911.29162.55257.stgit@phlsvslse11.ph.intel.com>
References: <20131004132821.29162.46169.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131004132821.29162.46169.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Function qib_user_sdma_queue_pkts() gets called with mmap_sem held for
writing. Except for get_user_pages() deep down in
qib_user_sdma_pin_pages() we don't seem to need mmap_sem at all.  Even
more interestingly the function qib_user_sdma_queue_pkts() (and also
qib_user_sdma_coalesce() called somewhat later) call copy_from_user()
which can hit a page fault and we deadlock on trying to get mmap_sem
when handling that fault. So just make qib_user_sdma_pin_pages() use
get_user_pages_fast() and leave mmap_sem locking for mm.

This deadlock has actually been observed in the wild when the node
is under memory pressure.

Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index d0a0ea0..165aee2 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -594,8 +594,7 @@ static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 		else
 			j = npages;
 
-		ret = get_user_pages(current, current->mm, addr,
-			     j, 0, 1, pages, NULL);
+		ret = get_user_pages_fast(addr, j, 0, pages);
 		if (ret != j) {
 			i = 0;
 			j = ret;
@@ -1294,11 +1293,8 @@ int qib_user_sdma_writev(struct qib_ctxtdata *rcd,
 		int mxp = 8;
 		int ndesc = 0;
 
-		down_write(&current->mm->mmap_sem);
 		ret = qib_user_sdma_queue_pkts(dd, ppd, pq,
 				iov, dim, &list, &mxp, &ndesc);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret < 0)
 			goto done_unlock;
 		else {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
