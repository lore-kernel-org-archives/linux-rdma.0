From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 09/20] IB/core: Improve uverbs_cleanup_ucontext algorithm
Date: Sun, 17 Jun 2018 12:59:55 +0300
Message-ID: <20180617100006.30663-10-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Improve uverbs_cleanup_ucontext algorithm to work properly even when
there are two objects from the same type and one points to the other.
For that case to work the 'destroy_order' is not used any more as it's
static per type and can't support this use case.

Instead, the new algorithm iterates over the objects in a LIFO mode as
was before, at the end of each loop if were left objects that couldn't
be destroyed it re-iterates over them give another chance to destroy them
successfully.

If was one iteration that didn't cleanup any object the last iteration
will force the cleanup as was done before this change, this is coming to
prevent memory leaks even in that fatal case.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/rdma_core.c                | 96 ++++++++++++----------
 drivers/infiniband/core/uverbs_std_types.c         | 22 +++--
 .../infiniband/core/uverbs_std_types_counters.c    |  2 +-
 drivers/infiniband/core/uverbs_std_types_cq.c      |  2 +-
 drivers/infiniband/core/uverbs_std_types_dm.c      |  3 +-
 .../infiniband/core/uverbs_std_types_flow_action.c |  2 +-
 drivers/infiniband/core/uverbs_std_types_mr.c      |  3 +-
 include/rdma/ib_verbs.h                            |  2 +-
 include/rdma/uverbs_types.h                        | 11 +--
 9 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index df3c40533252..f4554de59659 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -645,61 +645,69 @@ void uverbs_close_fd(struct file *f)
 	kref_put(uverbs_file_ref, ib_uverbs_release_file);
 }
 
-void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
+static int __uverbs_cleanup_ucontext(struct ib_ucontext *ucontext,
+				    enum rdma_remove_reason reason)
 {
-	enum rdma_remove_reason reason = device_removed ?
-		RDMA_REMOVE_DRIVER_REMOVE : RDMA_REMOVE_CLOSE;
-	unsigned int cur_order = 0;
+	struct ib_uobject *obj, *next_obj;
+	int ret = -EINVAL;
+	int err = 0;
 
+	/*
+	 * This shouldn't run while executing other commands on this
+	 * context. Thus, the only thing we should take care of is
+	 * releasing a FD while traversing this list. The FD could be
+	 * closed and released from the _release fop of this FD.
+	 * In order to mitigate this, we add a lock.
+	 * We take and release the lock per traversal in order to let
+	 * other threads (which might still use the FDs) chance to run.
+	 */
+	mutex_lock(&ucontext->uobjects_lock);
 	ucontext->cleanup_reason = reason;
+	list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects, list) {
+		/*
+		 * if we hit this WARN_ON, that means we are
+		 * racing with a lookup_get.
+		 */
+		WARN_ON(uverbs_try_lock_object(obj, true));
+		err = obj->type->type_class->remove_commit(obj, reason);
+		if (err) {
+			if (reason == RDMA_REMOVE_DESTROY) {
+				pr_debug("ib_uverbs: failed to remove uobject id %d err %d\n",
+					 obj->id, err);
+				atomic_set(&obj->usecnt, 0);
+				continue;
+			}
+
+			pr_warn("ib_uverbs: unable to remove uobject id %d err %d\n",
+				obj->id, err);
+		}
+
+		list_del(&obj->list);
+		/* put the ref we took when we created the object */
+		uverbs_uobject_put(obj);
+		ret = 0;
+	}
+	mutex_unlock(&ucontext->uobjects_lock);
+	return ret;
+}
+
+void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
+{
 	/*
 	 * Waits for all remove_commit and alloc_commit to finish. Logically, We
 	 * want to hold this forever as the context is going to be destroyed,
 	 * but we'll release it since it causes a "held lock freed" BUG message.
 	 */
 	down_write(&ucontext->cleanup_rwsem);
+	while (!list_empty(&ucontext->uobjects))
+		if (__uverbs_cleanup_ucontext(ucontext, RDMA_REMOVE_DESTROY))
+			/* No entry was cleaned-up successfully during this iteration */
+			break;
 
-	while (!list_empty(&ucontext->uobjects)) {
-		struct ib_uobject *obj, *next_obj;
-		unsigned int next_order = UINT_MAX;
+	if (!list_empty(&ucontext->uobjects))
+		__uverbs_cleanup_ucontext(ucontext, device_removed ?
+			RDMA_REMOVE_DRIVER_REMOVE : RDMA_REMOVE_CLOSE);
 
-		/*
-		 * This shouldn't run while executing other commands on this
-		 * context. Thus, the only thing we should take care of is
-		 * releasing a FD while traversing this list. The FD could be
-		 * closed and released from the _release fop of this FD.
-		 * In order to mitigate this, we add a lock.
-		 * We take and release the lock per order traversal in order
-		 * to let other threads (which might still use the FDs) chance
-		 * to run.
-		 */
-		mutex_lock(&ucontext->uobjects_lock);
-		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
-					 list) {
-			if (obj->type->destroy_order == cur_order) {
-				int ret;
-
-				/*
-				 * if we hit this WARN_ON, that means we are
-				 * racing with a lookup_get.
-				 */
-				WARN_ON(uverbs_try_lock_object(obj, true));
-				ret = obj->type->type_class->remove_commit(obj,
-									   reason);
-				list_del(&obj->list);
-				if (ret)
-					pr_warn("ib_uverbs: failed to remove uobject id %d order %u\n",
-						obj->id, cur_order);
-				/* put the ref we took when we created the object */
-				uverbs_uobject_put(obj);
-			} else {
-				next_order = min(next_order,
-						 obj->type->destroy_order);
-			}
-		}
-		mutex_unlock(&ucontext->uobjects_lock);
-		cur_order = next_order;
-	}
 	up_write(&ucontext->cleanup_rwsem);
 }
 
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 0df0ac9c1de3..0901b7877408 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -246,44 +246,42 @@ void create_udata(struct uverbs_attr_bundle *ctx, struct ib_udata *udata)
 }
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_COMP_CHANNEL,
-			    &UVERBS_TYPE_ALLOC_FD(0,
-						  sizeof(struct ib_uverbs_completion_event_file),
+			    &UVERBS_TYPE_ALLOC_FD(sizeof(struct ib_uverbs_completion_event_file),
 						  uverbs_hot_unplug_completion_event_file,
 						  &uverbs_event_fops,
 						  "[infinibandevent]", O_RDONLY));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_QP,
-			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
+			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object),
 						      uverbs_free_qp));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_MW,
-			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_mw));
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_mw));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_SRQ,
-			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0,
+			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object),
 						      uverbs_free_srq));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_AH,
-			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_ah));
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_ah));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_FLOW,
 			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uflow_object),
-						      0, uverbs_free_flow));
+						      uverbs_free_flow));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_WQ,
-			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object), 0,
+			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object),
 						      uverbs_free_wq));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_RWQ_IND_TBL,
-			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_rwq_ind_tbl));
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_rwq_ind_tbl));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_XRCD,
-			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object), 0,
+			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object),
 						      uverbs_free_xrcd));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_PD,
-			    /* 2 is used in order to free the PD after MRs */
-			    &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd));
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_pd));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_DEVICE, NULL);
 
diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
index 03b182a684a6..e2d82b5ba732 100644
--- a/drivers/infiniband/core/uverbs_std_types_counters.c
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -150,7 +150,7 @@ static DECLARE_UVERBS_NAMED_METHOD(UVERBS_METHOD_COUNTERS_READ,
 			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_COUNTERS,
-			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_counters),
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_counters),
 			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_CREATE),
 			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_DESTROY),
 			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_READ));
diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c b/drivers/infiniband/core/uverbs_std_types_cq.c
index 3d293d01afea..278528f56f1f 100644
--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -201,7 +201,7 @@ static DECLARE_UVERBS_NAMED_METHOD(UVERBS_METHOD_CQ_DESTROY,
 			     UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_CQ,
-			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
+			    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object),
 						      uverbs_free_cq),
 #if IS_ENABLED(CONFIG_INFINIBAND_EXP_LEGACY_VERBS_NEW_UAPI)
 			    &UVERBS_METHOD(UVERBS_METHOD_CQ_CREATE),
diff --git a/drivers/infiniband/core/uverbs_std_types_dm.c b/drivers/infiniband/core/uverbs_std_types_dm.c
index 8b681575b615..8fd976d30895 100644
--- a/drivers/infiniband/core/uverbs_std_types_dm.c
+++ b/drivers/infiniband/core/uverbs_std_types_dm.c
@@ -102,7 +102,6 @@ static DECLARE_UVERBS_NAMED_METHOD_WITH_HANDLER(UVERBS_METHOD_DM_FREE,
 			 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_DM,
-			    /* 1 is used in order to free the DM after MRs */
-			    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_dm),
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_dm),
 			    &UVERBS_METHOD(UVERBS_METHOD_DM_ALLOC),
 			    &UVERBS_METHOD(UVERBS_METHOD_DM_FREE));
diff --git a/drivers/infiniband/core/uverbs_std_types_flow_action.c b/drivers/infiniband/core/uverbs_std_types_flow_action.c
index a7be51cf2e42..0cc15f8ee455 100644
--- a/drivers/infiniband/core/uverbs_std_types_flow_action.c
+++ b/drivers/infiniband/core/uverbs_std_types_flow_action.c
@@ -428,7 +428,7 @@ static DECLARE_UVERBS_NAMED_METHOD_WITH_HANDLER(UVERBS_METHOD_FLOW_ACTION_DESTRO
 			 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_FLOW_ACTION,
-			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_flow_action),
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_flow_action),
 			    &UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_ESP_CREATE),
 			    &UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_DESTROY),
 			    &UVERBS_METHOD(UVERBS_METHOD_FLOW_ACTION_ESP_MODIFY));
diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 68f7cadf088f..d7f7ba3802af 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -142,6 +142,5 @@ static DECLARE_UVERBS_NAMED_METHOD(UVERBS_METHOD_DM_MR_REG,
 			     UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_MR,
-			    /* 1 is used in order to free the MR after all the MWs */
-			    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr),
+			    &UVERBS_TYPE_ALLOC_IDR(uverbs_free_mr),
 			    &UVERBS_METHOD(UVERBS_METHOD_DM_MR_REG));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4c6241bc2039..152b5907c864 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1473,7 +1473,7 @@ struct ib_fmr_attr {
 struct ib_umem;
 
 enum rdma_remove_reason {
-	/* Userspace requested uobject deletion. Call could fail */
+	/* Userspace requested uobject deletion or initial try to remove uobject via cleanup. Call could fail */
 	RDMA_REMOVE_DESTROY,
 	/* Context deletion. This call should delete the actual object itself */
 	RDMA_REMOVE_CLOSE,
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index cc04ec65588d..175495d1b0b8 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -93,7 +93,6 @@ struct uverbs_obj_type_class {
 struct uverbs_obj_type {
 	const struct uverbs_obj_type_class * const type_class;
 	size_t	     obj_size;
-	unsigned int destroy_order;
 };
 
 /*
@@ -152,10 +151,9 @@ extern const struct uverbs_obj_type_class uverbs_fd_class;
 
 #define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
 				   sizeof(char))
-#define UVERBS_TYPE_ALLOC_FD(_order, _obj_size, _context_closed, _fops, _name, _flags)\
+#define UVERBS_TYPE_ALLOC_FD(_obj_size, _context_closed, _fops, _name, _flags)\
 	((&((const struct uverbs_obj_fd_type)				\
 	 {.type = {							\
-		.destroy_order = _order,				\
 		.type_class = &uverbs_fd_class,				\
 		.obj_size = (_obj_size) +				\
 			UVERBS_BUILD_BUG_ON((_obj_size) < sizeof(struct ib_uobject_file)), \
@@ -164,18 +162,17 @@ extern const struct uverbs_obj_type_class uverbs_fd_class;
 	 .fops = _fops,							\
 	 .name = _name,							\
 	 .flags = _flags}))->type)
-#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order, _destroy_object)	\
+#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _destroy_object)	\
 	((&((const struct uverbs_obj_idr_type)				\
 	 {.type = {							\
-		.destroy_order = _order,				\
 		.type_class = &uverbs_idr_class,			\
 		.obj_size = (_size) +					\
 			UVERBS_BUILD_BUG_ON((_size) <			\
 					    sizeof(struct ib_uobject))	\
 	 },								\
 	 .destroy_object = _destroy_object,}))->type)
-#define UVERBS_TYPE_ALLOC_IDR(_order, _destroy_object)			\
-	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject), _order,	\
+#define UVERBS_TYPE_ALLOC_IDR(_destroy_object)			\
+	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject),	\
 				  _destroy_object)
 
 #endif
-- 
2.14.4
