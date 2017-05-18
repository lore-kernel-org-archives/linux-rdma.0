From: Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ib/core: not to set page dirty bit if it's already set.
Date: Thu, 18 May 2017 16:33:53 -0700
Message-ID: <20170518233353.14370-1-qing.huang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This change will optimize kernel memory deregistration operations.
__ib_umem_release() used to call set_page_dirty_lock() against every
writable page in its memory region. Its purpose is to keep data
synced between CPU and DMA device when swapping happens after mem
deregistration ops. Now we choose not to set page dirty bit if it's
already set by kernel prior to calling __ib_umem_release(). This
reduces memory deregistration time by half or even more when we ran
application simulation test program.

Signed-off-by: Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 3dbf811..21e60b1 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -58,7 +58,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 	for_each_sg(umem->sg_head.sgl, sg, umem->npages, i) {
 
 		page = sg_page(sg);
-		if (umem->writable && dirty)
+		if (!PageDirty(page) && umem->writable && dirty)
 			set_page_dirty_lock(page);
 		put_page(page);
 	}
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
