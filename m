From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC] IB/core: Verbs handlers which modify objects should use exclusive lock
Date: Tue, 18 Apr 2017 12:39:38 +0300
Message-ID: <1492508378-33817-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Verbs handlers such as resize_cq, modify_qp and modify_srq should
use an exclusive lock in order to prevent concurrent modification
to the same object. This usually makes sense, as modify the same
QP concurrently to state X and state Y (where X != Y) could either
lead to the QP begin in its original state, in state X or in state Y.
The user could either get a success or an error return code for each
call. This goes similarly for resize_cq and modify_srq.

However, sometimes this behavior is valid. For example, changing two
different QP/SRQ attributes in the same state is a valid behaviour
for two concurrent modify_qp/modify_srq. The same goes for resizing a
CQ concurrently to the same size. These seems to be esoteric cases,
but it does changes the current user's experience.

This could be solved differently by using a mutex and serialize these
calls in the uverbs handlers. However, I'm not sure these bizarre
usages qualify introducing more locks.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Doug,

This RFC's goal is to handle the abnormal behavior of the
current uverbs_cmd modify_xxxx handler, where the object
is modified, but only a read lock is acquired. The current behaviour
is inconsistent and racy in respect of user-space applications.
It could be solved by (at least) two approaches. This patch
demonstrates the simplified one. Since it could lead to changes in how
applications behave, I thought it's better to first post it as a RFC.

Regards,
Matan

 drivers/infiniband/core/uverbs_cmd.c | 12 ++++++------
 include/rdma/uverbs_std_types.h      | 12 ++++++++++++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e2fee04..87ba859 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1165,7 +1165,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
+	cq = uobj_get_obj_write(cq, cmd.cq_handle, file->ucontext);
 	if (!cq)
 		return -EINVAL;
 
@@ -1180,7 +1180,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 		ret = -EFAULT;
 
 out:
-	uobj_put_obj_read(cq);
+	uobj_put_obj_write(cq);
 
 	return ret ? ret : in_len;
 }
@@ -1914,7 +1914,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 	if (!attr)
 		return -ENOMEM;
 
-	qp = uobj_get_obj_read(qp, cmd->base.qp_handle, file->ucontext);
+	qp = uobj_get_obj_write(qp, cmd->base.qp_handle, file->ucontext);
 	if (!qp) {
 		ret = -EINVAL;
 		goto out;
@@ -1986,7 +1986,7 @@ static int modify_qp(struct ib_uverbs_file *file,
 	}
 
 release_qp:
-	uobj_put_obj_read(qp);
+	uobj_put_obj_write(qp);
 
 out:
 	kfree(attr);
@@ -3607,7 +3607,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
 		   out_len);
 
-	srq = uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);
+	srq = uobj_get_obj_write(srq, cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
 
@@ -3616,7 +3616,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 
 	ret = srq->device->modify_srq(srq, &attr, cmd.attr_mask, &udata);
 
-	uobj_put_obj_read(srq);
+	uobj_put_obj_write(srq);
 
 	return ret ? ret : in_len;
 }
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 7771ce9..1a1cb48 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -73,6 +73,15 @@ static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
 #define uobj_get_write(_type, _id, _ucontext)				\
 	 __uobj_get(&(_type), true, _ucontext, _id)
 
+#define uobj_get_obj_write(_type, _id, _ucontext)			\
+({									\
+	struct ib_uobject *uobj =					\
+		__uobj_get(&uobj_get_type(_type),			\
+			   true, _ucontext, _id);			\
+									\
+	(struct ib_##_type *)(IS_ERR(uobj) ? NULL : uobj->object);	\
+})
+
 static inline void uobj_put_read(struct ib_uobject *uobj)
 {
 	rdma_lookup_put_uobject(uobj, false);
@@ -86,6 +95,9 @@ static inline void uobj_put_write(struct ib_uobject *uobj)
 	rdma_lookup_put_uobject(uobj, true);
 }
 
+#define uobj_put_obj_write(_obj)				\
+	uobj_put_write((_obj)->uobject)
+
 static inline int __must_check uobj_remove_commit(struct ib_uobject *uobj)
 {
 	return rdma_remove_commit_uobject(uobj);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
