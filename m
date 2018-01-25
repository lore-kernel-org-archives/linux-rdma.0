From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v6 5/8] RDMA/core: Add resource tracking for create and destroy CQs
Date: Thu, 25 Jan 2018 17:12:24 +0200
Message-ID: <20180125151227.28202-6-leon@kernel.org>
References: <20180125151227.28202-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125151227.28202-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Track create and destroy operations of CQ objects.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cq.c               | 6 ++++++
 drivers/infiniband/core/uverbs_cmd.c       | 2 ++
 drivers/infiniband/core/uverbs_std_types.c | 3 +++
 drivers/infiniband/core/verbs.c            | 3 +++
 4 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index d99565dbd12f..bc79ca8215d7 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -159,6 +159,10 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private,
 	if (!cq->wc)
 		goto out_destroy_cq;
 
+	cq->res.type = RDMA_RESTRACK_CQ;
+	cq->res.kern_name = caller;
+	rdma_restrack_add(&cq->res);
+
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
 		cq->comp_handler = ib_cq_completion_direct;
@@ -183,6 +187,7 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private,
 
 out_free_wc:
 	kfree(cq->wc);
+	rdma_restrack_del(&cq->res);
 out_destroy_cq:
 	cq->device->destroy_cq(cq);
 	return ERR_PTR(ret);
@@ -214,6 +219,7 @@ void ib_free_cq(struct ib_cq *cq)
 	}
 
 	kfree(cq->wc);
+	rdma_restrack_del(&cq->res);
 	ret = cq->device->destroy_cq(cq);
 	WARN_ON_ONCE(ret);
 }
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 825325c764a1..3e95acd29de7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1033,6 +1033,8 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 		goto err_cb;
 
 	uobj_alloc_commit(&obj->uobject);
+	cq->res.type = RDMA_RESTRACK_CQ;
+	rdma_restrack_add(&cq->res);
 
 	return obj;
 
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index c3ee5d9b336d..b571176babbe 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_verbs.h>
 #include <linux/bug.h>
 #include <linux/file.h>
+#include <rdma/restrack.h>
 #include "rdma_core.h"
 #include "uverbs.h"
 
@@ -319,6 +320,8 @@ static int uverbs_create_cq_handler(struct ib_device *ib_dev,
 	obj->uobject.object = cq;
 	obj->uobject.user_handle = user_handle;
 	atomic_set(&cq->usecnt, 0);
+	cq->res.type = RDMA_RESTRACK_CQ;
+	rdma_restrack_add(&cq->res);
 
 	ret = uverbs_copy_to(attrs, CREATE_CQ_RESP_CQE, &cq->cqe);
 	if (ret)
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c3628a437403..983b49ffb8d5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1578,6 +1578,8 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
 		cq->event_handler = event_handler;
 		cq->cq_context    = cq_context;
 		atomic_set(&cq->usecnt, 0);
+		cq->res.type = RDMA_RESTRACK_CQ;
+		rdma_restrack_add(&cq->res);
 	}
 
 	return cq;
@@ -1596,6 +1598,7 @@ int ib_destroy_cq(struct ib_cq *cq)
 	if (atomic_read(&cq->usecnt))
 		return -EBUSY;
 
+	rdma_restrack_del(&cq->res);
 	return cq->device->destroy_cq(cq);
 }
 EXPORT_SYMBOL(ib_destroy_cq);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
