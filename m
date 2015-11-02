From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: use RCU for uverbs id lookup
Date: Mon, 02 Nov 2015 12:13:25 -0500
Message-ID: <20151102171325.7601.96477.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current implementation gets a spin_lock, and at any scale with
qib and hfi1 post send, the lock contention grows exponentially
with the number of QPs.

idr_find() is RCU compatibile, so read doesn't need the lock.

Change to use rcu_read_lock() and rcu_read_unlock() in
__idr_get_uobj().

kfree_rcu() is used to insure a grace period between the
idr removal and actual free.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   12 +++++++-----
 include/rdma/ib_verbs.h              |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index be4cb9f..eb7f74f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -62,9 +62,11 @@ static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
  * The ib_uobject locking scheme is as follows:
  *
  * - ib_uverbs_idr_lock protects the uverbs idrs themselves, so it
- *   needs to be held during all idr operations.  When an object is
+ *   needs to be held during all idr write operations.  When an object is
  *   looked up, a reference must be taken on the object's kref before
- *   dropping this lock.
+ *   dropping this lock.  For read operations, the rcu_read_lock()
+ *   and rcu_write_lock() but similarly the kref reference is grabbed
+ *   before the rcu_read_unlock().
  *
  * - Each object also has an rwsem.  This rwsem must be held for
  *   reading while an operation that uses the object is performed.
@@ -96,7 +98,7 @@ static void init_uobj(struct ib_uobject *uobj, u64 user_handle,
 
 static void release_uobj(struct kref *kref)
 {
-	kfree(container_of(kref, struct ib_uobject, ref));
+	kfree_rcu(container_of(kref, struct ib_uobject, ref), rcu);
 }
 
 static void put_uobj(struct ib_uobject *uobj)
@@ -145,7 +147,7 @@ static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
 {
 	struct ib_uobject *uobj;
 
-	spin_lock(&ib_uverbs_idr_lock);
+	rcu_read_lock();
 	uobj = idr_find(idr, id);
 	if (uobj) {
 		if (uobj->context == context)
@@ -153,7 +155,7 @@ static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
 		else
 			uobj = NULL;
 	}
-	spin_unlock(&ib_uverbs_idr_lock);
+	rcu_read_unlock();
 
 	return uobj;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7845fae..f46092f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1246,6 +1246,7 @@ struct ib_uobject {
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
+	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
