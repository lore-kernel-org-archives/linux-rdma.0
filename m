From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 8/8] verbs: Remove tests for NULL ops
Date: Mon,  8 Jan 2018 14:26:32 -0700
Message-ID: <20180108212632.5183-9-jgg@ziepe.ca>
References: <20180108212632.5183-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ops can no longer be null, the correct error return is generated inside
the dummy. This removes some overhead and fixes a missing errno = ENOSYS
in the create_srq path.

We cannot change the tests inlined the header file, since the app might link
to an older verbs.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/device.c |  3 +--
 libibverbs/verbs.c  | 14 +-------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/libibverbs/device.c b/libibverbs/device.c
index 491918b1999fb4..e0cb16bae1bcf8 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -359,8 +359,7 @@ LATEST_SYMVER_FUNC(ibv_get_async_event, 1_1, "IBVERBS_1.1",
 		break;
 	}
 
-	if (context->ops.async_event)
-		context->ops.async_event(event);
+	context->ops.async_event(event);
 
 	return 0;
 }
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index 65d9c1c8ca2fc4..c772335e06d71a 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -269,11 +269,6 @@ LATEST_SYMVER_FUNC(ibv_rereg_mr, 1_1, "IBVERBS_1.1",
 		return IBV_REREG_MR_ERR_INPUT;
 	}
 
-	if (!mr->context->ops.rereg_mr) {
-		errno = ENOSYS;
-		return IBV_REREG_MR_ERR_INPUT;
-	}
-
 	if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
 		err = ibv_dontfork_range(addr, length);
 		if (err)
@@ -420,9 +415,6 @@ LATEST_SYMVER_FUNC(ibv_resize_cq, 1_1, "IBVERBS_1.1",
 		   int,
 		   struct ibv_cq *cq, int cqe)
 {
-	if (!cq->context->ops.resize_cq)
-		return ENOSYS;
-
 	return cq->context->ops.resize_cq(cq, cqe);
 }
 
@@ -459,8 +451,7 @@ LATEST_SYMVER_FUNC(ibv_get_cq_event, 1_1, "IBVERBS_1.1",
 	*cq         = (struct ibv_cq *) (uintptr_t) ev.cq_handle;
 	*cq_context = (*cq)->cq_context;
 
-	if ((*cq)->context->ops.cq_event)
-		(*cq)->context->ops.cq_event(*cq);
+	(*cq)->context->ops.cq_event(*cq);
 
 	return 0;
 }
@@ -482,9 +473,6 @@ LATEST_SYMVER_FUNC(ibv_create_srq, 1_1, "IBVERBS_1.1",
 {
 	struct ibv_srq *srq;
 
-	if (!pd->context->ops.create_srq)
-		return NULL;
-
 	srq = pd->context->ops.create_srq(pd, srq_init_attr);
 	if (srq) {
 		srq->context          = pd->context;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
