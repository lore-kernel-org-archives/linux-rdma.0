From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/core: Don't pass the lock state to _rdma_remove_commit_uobject
Date: Tue, 18 Apr 2017 12:03:38 +0300
Message-ID: <1492506222-28999-3-git-send-email-matanb@mellanox.com>
References: <1492506222-28999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492506222-28999-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only scenario where this function was called while the lock is
already taken is in the context cleanup scenario. Thus, in order not
to pass the lock state to this function, we just call the remove logic
straight from the cleanup context function.

Fixes: 3832125624b7 ('IB/core: Add support for idr types')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 88d1e59..699a659 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -363,8 +363,7 @@ static void lockdep_check(struct ib_uobject *uobj, bool exclusive)
 }
 
 static int __must_check _rdma_remove_commit_uobject(struct ib_uobject *uobj,
-						    enum rdma_remove_reason why,
-						    bool lock)
+						    enum rdma_remove_reason why)
 {
 	int ret;
 	struct ib_ucontext *ucontext = uobj->context;
@@ -375,11 +374,9 @@ static int __must_check _rdma_remove_commit_uobject(struct ib_uobject *uobj,
 		atomic_set(&uobj->usecnt, 0);
 		uobj->type->type_class->lookup_put(uobj, true);
 	} else {
-		if (lock)
-			mutex_lock(&ucontext->uobjects_lock);
+		mutex_lock(&ucontext->uobjects_lock);
 		list_del(&uobj->list);
-		if (lock)
-			mutex_unlock(&ucontext->uobjects_lock);
+		mutex_unlock(&ucontext->uobjects_lock);
 		/* put the ref we took when we created the object */
 		uverbs_uobject_put(uobj);
 	}
@@ -401,7 +398,7 @@ int __must_check rdma_remove_commit_uobject(struct ib_uobject *uobj)
 		return 0;
 	}
 	lockdep_check(uobj, true);
-	ret = _rdma_remove_commit_uobject(uobj, RDMA_REMOVE_DESTROY, true);
+	ret = _rdma_remove_commit_uobject(uobj, RDMA_REMOVE_DESTROY);
 
 	up_read(&ucontext->cleanup_rwsem);
 	return ret;
@@ -534,8 +531,7 @@ static void _uverbs_close_fd(struct ib_uobject_file *uobj_file)
 		goto unlock;
 
 	ucontext = uobj_file->uobj.context;
-	ret = _rdma_remove_commit_uobject(&uobj_file->uobj, RDMA_REMOVE_CLOSE,
-					  true);
+	ret = _rdma_remove_commit_uobject(&uobj_file->uobj, RDMA_REMOVE_CLOSE);
 	up_read(&ucontext->cleanup_rwsem);
 	if (ret)
 		pr_warn("uverbs: unable to clean up uobject file in uverbs_close_fd.\n");
@@ -583,7 +579,7 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
 		 */
 		mutex_lock(&ucontext->uobjects_lock);
 		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
-					 list)
+					 list) {
 			if (obj->type->destroy_order == cur_order) {
 				int ret;
 
@@ -592,15 +588,19 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
 				 * racing with a lookup_get.
 				 */
 				WARN_ON(uverbs_try_lock_object(obj, true));
-				ret = _rdma_remove_commit_uobject(obj, reason,
-								  false);
+				ret = obj->type->type_class->remove_commit(obj,
+									   reason);
+				list_del(&obj->list);
 				if (ret)
 					pr_warn("ib_uverbs: failed to remove uobject id %d order %u\n",
 						obj->id, cur_order);
+				/* put the ref we took when we created the object */
+				uverbs_uobject_put(obj);
 			} else {
 				next_order = min(next_order,
 						 obj->type->destroy_order);
 			}
+		}
 		mutex_unlock(&ucontext->uobjects_lock);
 		cur_order = next_order;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
