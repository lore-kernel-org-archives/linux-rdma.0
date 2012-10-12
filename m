From: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] iw_cxgb4: do not free chunk that we have failed to allocate
Date: Fri, 12 Oct 2012 18:10:11 -0300
Message-ID: <1350076211-24310-1-git-send-email-cascardo@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the error path of registering memory, in case there is a failure when
trying to allocate a chunk from the memory pool, it will try to free the
same chunk, which will BUG.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 57e07c6..afd8179 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -468,7 +468,7 @@ struct ib_mr *c4iw_register_phys_mem(struct ib_pd *pd,
 	ret = alloc_pbl(mhp, npages);
 	if (ret) {
 		kfree(page_list);
-		goto err_pbl;
+		goto err;
 	}
 
 	ret = write_pbl(&mhp->rhp->rdev, page_list, mhp->attr.pbl_addr,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
