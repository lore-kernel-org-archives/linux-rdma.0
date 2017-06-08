From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rdma] IB/core: Fix sparse warnings
Date: Thu,  8 Jun 2017 17:30:47 +0300
Message-ID: <1496932247-119899-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Delete unused variables to prevent sparse warnings.

Fixes: db1b5ddd5336 ("IB/core: Rename uverbs event file structure")
Fixes: fd3c7904db6e ("IB/core: Change idr objects to use the new schema")
---

Hi Doug,

This simple patch deletes some unused variables which cause sparse
warnings. This is based over your k.o/for-4.12-rc branch.

Regards,
Matan

 drivers/infiniband/core/uverbs_cmd.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 70b7fb1..09d19d7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1296,7 +1296,6 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	struct ib_uobject		*uobj;
 	struct ib_cq               	*cq;
 	struct ib_ucq_object        	*obj;
-	struct ib_uverbs_event_queue	*ev_queue;
 	int                        	 ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -1313,7 +1312,6 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	 */
 	uverbs_uobject_get(uobj);
 	cq      = uobj->object;
-	ev_queue = cq->cq_context;
 	obj     = container_of(cq->uobject, struct ib_ucq_object, uobject);
 
 	memset(&resp, 0, sizeof(resp));
@@ -2091,7 +2089,6 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_qp      cmd;
 	struct ib_uverbs_destroy_qp_resp resp;
 	struct ib_uobject		*uobj;
-	struct ib_qp               	*qp;
 	struct ib_uqp_object        	*obj;
 	int                        	 ret = -EINVAL;
 
@@ -2105,7 +2102,6 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (IS_ERR(uobj))
 		return PTR_ERR(uobj);
 
-	qp  = uobj->object;
 	obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
 	/*
 	 * Make sure we don't free the memory in remove_commit as we still
@@ -3004,7 +3000,6 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_ex_destroy_wq	cmd = {};
 	struct ib_uverbs_ex_destroy_wq_resp	resp = {};
-	struct ib_wq			*wq;
 	struct ib_uobject		*uobj;
 	struct ib_uwq_object		*obj;
 	size_t required_cmd_sz;
@@ -3038,7 +3033,6 @@ int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
 	if (IS_ERR(uobj))
 		return PTR_ERR(uobj);
 
-	wq = uobj->object;
 	obj = container_of(uobj, struct ib_uwq_object, uevent.uobject);
 	/*
 	 * Make sure we don't free the memory in remove_commit as we still
@@ -3728,10 +3722,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_srq      cmd;
 	struct ib_uverbs_destroy_srq_resp resp;
 	struct ib_uobject		 *uobj;
-	struct ib_srq               	 *srq;
 	struct ib_uevent_object        	 *obj;
 	int                         	  ret = -EINVAL;
-	enum ib_srq_type		  srq_type;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
@@ -3741,9 +3733,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (IS_ERR(uobj))
 		return PTR_ERR(uobj);
 
-	srq = uobj->object;
 	obj = container_of(uobj, struct ib_uevent_object, uobject);
-	srq_type = srq->srq_type;
 	/*
 	 * Make sure we don't free the memory in remove_commit as we still
 	 * needs the uobject memory to create the response.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
