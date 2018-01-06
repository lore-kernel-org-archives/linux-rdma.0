From: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] infiniband: fix core/verbs.c kernel-doc notation
Date: Fri, 05 Jan 2018 16:21:40 -0800
Message-ID: <5a50169a.472e620a.6c71b.37c1@mx.google.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change function parameter name in kernel-doc notation and other comments
to eliminate a kernel-doc warning.

../drivers/infiniband/core/verbs.c:1790: warning: Excess function parameter 'wq_init_attr' description in 'ib_create_wq'

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/core/verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20171222.orig/drivers/infiniband/core/verbs.c
+++ linux-next-20171222/drivers/infiniband/core/verbs.c
@@ -1774,11 +1774,11 @@ EXPORT_SYMBOL(ib_dealloc_xrcd);
  * ib_create_wq - Creates a WQ associated with the specified protection
  * domain.
  * @pd: The protection domain associated with the WQ.
- * @wq_init_attr: A list of initial attributes required to create the
+ * @wq_attr: A list of initial attributes required to create the
  * WQ. If WQ creation succeeds, then the attributes are updated to
  * the actual capabilities of the created WQ.
  *
- * wq_init_attr->max_wr and wq_init_attr->max_sge determine
+ * wq_attr->max_wr and wq_attr->max_sge determine
  * the requested size of the WQ, and set to the actual values allocated
  * on return.
  * If ib_create_wq() succeeds, then max_wr and max_sge will always be


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
