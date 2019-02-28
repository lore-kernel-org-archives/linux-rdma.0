From: Shaobo He <shaobo@cs.utah.edu>
Subject: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Thu, 28 Feb 2019 15:38:38 -0700
Message-ID: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: shaobo@cs.utah.edu, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

In function `c4iw_dealloc_mw`, variable mhp's value is printed after
freed, which triggers undefined behavior according to this post:
https://trust-in-soft.com/dangling-pointer-indeterminate/.

This commit fixes it by swapping the order of `kfree` and `pr_debug`.

Signed-off-by: Shaobo He <shaobo@cs.utah.edu>
---
 drivers/infiniband/hw/cxgb4/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7b76e6f..bb8e0bc 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -684,8 +684,8 @@ int c4iw_dealloc_mw(struct ib_mw *mw)
 			  mhp->wr_waitp);
 	kfree_skb(mhp->dereg_skb);
 	c4iw_put_wr_wait(mhp->wr_waitp);
-	kfree(mhp);
 	pr_debug("ib_mw %p mmid 0x%x ptr %p\n", mw, mmid, mhp);
+	kfree(mhp);
 	return 0;
 }
 
-- 
2.7.4
