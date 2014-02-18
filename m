From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] IB/qib: Convert qib_user_sdma_pin_pages() to use
 get_user_pages_fast()
Date: Tue, 18 Feb 2014 16:46:30 -0500
Message-ID: <20140218214629.8685.24069.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 603e7729920e42b3c2f4dbfab9eef4878cb6e8fa upstream.

qib_user_sdma_queue_pkts() gets called with mmap_sem held for
writing. Except for get_user_pages() deep down in
qib_user_sdma_pin_pages() we don't seem to need mmap_sem at all.  Even
more interestingly the function qib_user_sdma_queue_pkts() (and also
qib_user_sdma_coalesce() called somewhat later) call copy_from_user()
which can hit a page fault and we deadlock on trying to get mmap_sem
when handling that fault.

So just make qib_user_sdma_pin_pages() use get_user_pages_fast() and
leave mmap_sem locking for mm.

This deadlock has actually been observed in the wild when the node
is under memory pressure.

Patch against v3.10.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Roland Dreier <roland@purestorage.com>
[Backported to 3.10: (Thanks to Ben Huthings)
 - Adjust context
 - Adjust indentation and nr_pages argument in qib_user_sdma_pin_pages()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 8244208..573b460 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -284,8 +284,7 @@ static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 	int j;
 	int ret;
 
-	ret = get_user_pages(current, current->mm, addr,
-			     npages, 0, 1, pages, NULL);
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 
 	if (ret != npages) {
 		int i;
@@ -830,10 +829,7 @@ int qib_user_sdma_writev(struct qib_ctxtdata *rcd,
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
 		ret = qib_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret <= 0)
 			goto done_unlock;
 		else {
