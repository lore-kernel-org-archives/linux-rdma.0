From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 4/7] RDMA/core: Add resource tracking for create and destroy CQs
Date: Tue,  2 Jan 2018 10:18:29 +0200
Message-ID: <20180102081832.5264-5-leon@kernel.org>
References: <20180102081832.5264-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102081832.5264-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Track all creation and destroy of CQ objects.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cq.c               | 3 +++
 drivers/infiniband/core/uverbs_cmd.c       | 1 +
 drivers/infiniband/core/uverbs_std_types.c | 2 ++
 drivers/infiniband/core/verbs.c            | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index f2ae75fa3128..6344e007dbce 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -154,6 +154,8 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	if (!cq->wc)
 		goto out_destroy_cq;
 
+	rdma_restrack_add(&cq->res, RDMA_RESTRACK_CQ, NULL);
+
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
 		cq->comp_handler = ib_cq_completion_direct;
@@ -208,6 +210,7 @@ void ib_free_cq(struct ib_cq *cq)
 		WARN_ON_ONCE(1);
 	}
 
+	rdma_restrack_del(&cq->res, RDMA_RESTRACK_CQ);
 	kfree(cq->wc);
 	ret = cq->device->destroy_cq(cq);
 	WARN_ON_ONCE(ret);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 62b3c5d71cce..c6ac0ee57f7c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1033,6 +1033,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 		goto err_cb;
 
 	uobj_alloc_commit(&obj->uobject);
+	rdma_restrack_add(&cq->res, RDMA_RESTRACK_CQ, NULL);
 
 	return obj;
 
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index c3ee5d9b336d..2d0d27865b09 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_verbs.h>
 #include <linux/bug.h>
 #include <linux/file.h>
+#include <rdma/restrack.h>
 #include "rdma_core.h"
 #include "uverbs.h"
 
@@ -319,6 +320,7 @@ static int uverbs_create_cq_handler(struct ib_device *ib_dev,
 	obj->uobject.object = cq;
 	obj->uobject.user_handle = user_handle;
 	atomic_set(&cq->usecnt, 0);
+	rdma_restrack_add(&cq->res, RDMA_RESTRACK_CQ, NULL);
 
 	ret = uverbs_copy_to(attrs, CREATE_CQ_RESP_CQE, &cq->cqe);
 	if (ret)
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c369a3bdab07..23d5862a4898 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1546,6 +1546,7 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
 		cq->event_handler = event_handler;
 		cq->cq_context    = cq_context;
 		atomic_set(&cq->usecnt, 0);
+		rdma_restrack_add(&cq->res, RDMA_RESTRACK_CQ, NULL);
 	}
 
 	return cq;
@@ -1564,6 +1565,7 @@ int ib_destroy_cq(struct ib_cq *cq)
 	if (atomic_read(&cq->usecnt))
 		return -EBUSY;
 
+	rdma_restrack_del(&cq->res, RDMA_RESTRACK_CQ);
 	return cq->device->destroy_cq(cq);
 }
 EXPORT_SYMBOL(ib_destroy_cq);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
