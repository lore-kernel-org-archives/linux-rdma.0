From: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/8] infiniband: fix core/fmr_pool.c kernel-doc notation
Date: Fri, 05 Jan 2018 16:21:53 -0800
Message-ID: <5a5016a5.8b61650a.ce794.d4dd@mx.google.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix kernel-doc warning for ib_fmr_pool_map_phys() and also format it
with function description and text spacing.

../drivers/infiniband/core/fmr_pool.c:404: warning: Excess function parameter 'pool' description in 'ib_fmr_pool_map_phys'

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/core/fmr_pool.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-next-20171222.orig/drivers/infiniband/core/fmr_pool.c
+++ linux-next-20171222/drivers/infiniband/core/fmr_pool.c
@@ -388,13 +388,11 @@ int ib_flush_fmr_pool(struct ib_fmr_pool
 EXPORT_SYMBOL(ib_flush_fmr_pool);
 
 /**
- * ib_fmr_pool_map_phys -
- * @pool:FMR pool to allocate FMR from
- * @page_list:List of pages to map
- * @list_len:Number of pages in @page_list
- * @io_virtual_address:I/O virtual address for new FMR
- *
- * Map an FMR from an FMR pool.
+ * ib_fmr_pool_map_phys - Map an FMR from an FMR pool.
+ * @pool_handle: FMR pool to allocate FMR from
+ * @page_list: List of pages to map
+ * @list_len: Number of pages in @page_list
+ * @io_virtual_address: I/O virtual address for new FMR
  */
 struct ib_pool_fmr *ib_fmr_pool_map_phys(struct ib_fmr_pool *pool_handle,
 					 u64                *page_list,


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
