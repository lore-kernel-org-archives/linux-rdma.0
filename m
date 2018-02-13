From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 10/15] IB/uverbs: Hold the uobj write lock after allocate
Date: Tue, 13 Feb 2018 12:18:36 +0200
Message-ID: <20180213101841.20101-11-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This clarifies the design intention that time between allocate and
commit has the uobj exclusive to the caller. We already guarantee
this by delaying publishing the uobj pointer via idr_insert,
fd_install, list_add, etc.

Additionally holding the usecnt lock during this period provides
extra clarity and more protection against future mistakes.

Fixes: 3832125624b7 ("IB/core: Add support for idr types")
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 85b5ee4defa4..82afb0cdcca3 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -141,7 +141,12 @@ static struct ib_uobject *alloc_uobj(struct ib_ucontext *context,
 	 */
 	uobj->context = context;
 	uobj->type = type;
-	atomic_set(&uobj->usecnt, 0);
+	/*
+	 * Allocated objects start out as write locked to deny any other
+	 * syscalls from accessing them until they are commited. See
+	 * rdma_alloc_commit_uobject
+	 */
+	atomic_set(&uobj->usecnt, -1);
 	kref_init(&uobj->ref);
 
 	return uobj;
@@ -527,6 +532,10 @@ int rdma_alloc_commit_uobject(struct ib_uobject *uobj)
 		return ret;
 	}
 
+	/* matches atomic_set(-1) in alloc_uobj */
+	lockdep_check(uobj, true);
+	atomic_set(&uobj->usecnt, 0);
+
 	uobj->type->type_class->alloc_commit(uobj);
 	up_read(&uobj->context->cleanup_rwsem);
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
