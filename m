From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/4] Ib/core: Mark local uverbs_std_types functions to be static
Date: Sat, 22 Apr 2017 17:28:49 +0300
Message-ID: <20170422142852.18882-2-leon@kernel.org>
References: <20170422142852.18882-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170422142852.18882-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Functions declared in uverbs_std_types.c are local to that file, but
they lack static declarations. This produces a lot of sparse warnings,
like the one below:

drivers/infiniband/core/uverbs_std_types.c:41:5: warning: symbol
				'uverbs_free_ah' was not declared.
				Should it be static?

So mark them as static.

CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 48 +++++++++++++++---------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index e3338b19d6a2..ad3caad40945 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -38,26 +38,26 @@
 #include "rdma_core.h"
 #include "uverbs.h"
 
-int uverbs_free_ah(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_ah(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	return ib_destroy_ah((struct ib_ah *)uobject->object);
 }
 
-int uverbs_free_flow(struct ib_uobject *uobject,
-		     enum rdma_remove_reason why)
+static int uverbs_free_flow(struct ib_uobject *uobject,
+			    enum rdma_remove_reason why)
 {
 	return ib_destroy_flow((struct ib_flow *)uobject->object);
 }
 
-int uverbs_free_mw(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_mw(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	return uverbs_dealloc_mw((struct ib_mw *)uobject->object);
 }
 
-int uverbs_free_qp(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_qp(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	struct ib_qp *qp = uobject->object;
 	struct ib_uqp_object *uqp =
@@ -82,8 +82,8 @@ int uverbs_free_qp(struct ib_uobject *uobject,
 	return ret;
 }
 
-int uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject,
-			    enum rdma_remove_reason why)
+static int uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject,
+				   enum rdma_remove_reason why)
 {
 	struct ib_rwq_ind_table *rwq_ind_tbl = uobject->object;
 	struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
@@ -95,8 +95,8 @@ int uverbs_free_rwq_ind_tbl(struct ib_uobject *uobject,
 	return ret;
 }
 
-int uverbs_free_wq(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_wq(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	struct ib_wq *wq = uobject->object;
 	struct ib_uwq_object *uwq =
@@ -109,8 +109,8 @@ int uverbs_free_wq(struct ib_uobject *uobject,
 	return ret;
 }
 
-int uverbs_free_srq(struct ib_uobject *uobject,
-		    enum rdma_remove_reason why)
+static int uverbs_free_srq(struct ib_uobject *uobject,
+			   enum rdma_remove_reason why)
 {
 	struct ib_srq *srq = uobject->object;
 	struct ib_uevent_object *uevent =
@@ -134,8 +134,8 @@ int uverbs_free_srq(struct ib_uobject *uobject,
 	return ret;
 }
 
-int uverbs_free_cq(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_cq(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	struct ib_cq *cq = uobject->object;
 	struct ib_uverbs_event_queue *ev_queue = cq->cq_context;
@@ -153,14 +153,14 @@ int uverbs_free_cq(struct ib_uobject *uobject,
 	return ret;
 }
 
-int uverbs_free_mr(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_mr(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	return ib_dereg_mr((struct ib_mr *)uobject->object);
 }
 
-int uverbs_free_xrcd(struct ib_uobject *uobject,
-		     enum rdma_remove_reason why)
+static int uverbs_free_xrcd(struct ib_uobject *uobject,
+			    enum rdma_remove_reason why)
 {
 	struct ib_xrcd *xrcd = uobject->object;
 	struct ib_uxrcd_object *uxrcd =
@@ -178,8 +178,8 @@ int uverbs_free_xrcd(struct ib_uobject *uobject,
 	return ret;
 }
 
-int uverbs_free_pd(struct ib_uobject *uobject,
-		   enum rdma_remove_reason why)
+static int uverbs_free_pd(struct ib_uobject *uobject,
+			  enum rdma_remove_reason why)
 {
 	struct ib_pd *pd = uobject->object;
 
@@ -190,8 +190,8 @@ int uverbs_free_pd(struct ib_uobject *uobject,
 	return 0;
 }
 
-int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_file,
-					    enum rdma_remove_reason why)
+static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_file,
+						   enum rdma_remove_reason why)
 {
 	struct ib_uverbs_completion_event_file *comp_event_file =
 		container_of(uobj_file, struct ib_uverbs_completion_event_file,
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
