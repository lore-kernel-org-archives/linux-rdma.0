From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/12] IB/hfi1: Fix memory leak in user ExpRcv and SDMA
Date: Tue, 12 Apr 2016 10:46:29 -0700
Message-ID: <20160412174628.19295.45866.stgit@scvm10.sc.intel.com>
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

The driver had two memory leaks - one in the user
expected receive code and one in SDMA buffer cache.

The leak in the expected receive code only showed up
when the user/admin had set ulimit sufficiently low
and the driver did not have enough room in the cache
before hitting the limit of allowed cachable memory.

When this condition occurred, the driver returned
early signaling userland that it needed to free some
buffers to free up room in the cache.

The bug was that the driver was not cleaning up
allocated memory prior to returning early.

The leak in the SDMA buffer cache could occur (even
though it never did), when the insertion of a buffer
node in the interval RB tree failed. In this case, the
driver failed to unpin the pages of the node instead
erroneously returning success.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c |    7 +++++--
 drivers/staging/rdma/hfi1/user_sdma.c    |    3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 5b72849..7507b62 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -397,8 +397,11 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 	 * pages, accept the amount pinned so far and program only that.
 	 * User space knows how to deal with partially programmed buffers.
 	 */
-	if (!hfi1_can_pin_pages(dd, fd->tid_n_pinned, npages))
-		return -ENOMEM;
+	if (!hfi1_can_pin_pages(dd, fd->tid_n_pinned, npages)) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
 	pinned = hfi1_acquire_user_pages(vaddr, npages, true, pages);
 	if (pinned <= 0) {
 		ret = pinned;
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 032949b..044d337 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1139,7 +1139,8 @@ retry:
 				list_del(&node->list);
 			pq->n_locked -= node->npages;
 			spin_unlock(&pq->evict_lock);
-			ret = 0;
+			unpin_vector_pages(current->mm, node->pages, 0,
+					   node->npages);
 			goto bail;
 		}
 	} else {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
