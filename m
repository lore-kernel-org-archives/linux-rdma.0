From: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] IB/uverbs: Add struct ib_usrq_object and ib_uxrcd_object
Date: Mon, 25 Jan 2010 11:01:33 -0800
Message-ID: <1264446094-4460-4-git-send-email-rolandd@cisco.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1264446094-4460-1-git-send-email-rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When we add support for sharing XRC domains among multiple processes,
we will need to keep track of which XRCD each QP and SRQ is associated
with, and keep a per-userspace-context reference count for each XRCD.

Userspace QPs already have a struct ib_uqp_object associated with
them, so we can put an XRCD pointer there, but we don't have such an
object for SRQs.  To handle this, convert userspace SRQs from using
struct ib_uevent_object to a new struct ib_usrq_object.  To hold the
per-context XRCD reference count, we convert userspace XRCDs to use a
new struct ib_uxrcd_object.

This patch makes struct ib_usrq_object just contain a struct
ib_uevent_object and struct ib_uxrcd_object just contain a struct
ib_uobject.  The follow-up patch adding support for shared XRCDs will
add the extra fields.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    8 +++
 drivers/infiniband/core/uverbs_cmd.c  |   92 ++++++++++++++++----------------
 drivers/infiniband/core/uverbs_main.c |   12 +++--
 3 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index f9c051e..9180acd 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -119,6 +119,14 @@ struct ib_uevent_object {
 	u32			events_reported;
 };
 
+struct ib_uxrcd_object {
+	struct ib_uobject	uobject;
+};
+
+struct ib_usrq_object {
+	struct ib_uevent_object	uevent;
+};
+
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
 	struct list_head 	mcast_list;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 92f9f11..b209339 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1977,7 +1977,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_srq      cmd;
 	struct ib_uverbs_create_srq_resp resp;
 	struct ib_udata                  udata;
-	struct ib_uevent_object         *obj;
+	struct ib_usrq_object		*obj;
 	struct ib_pd                    *pd;
 	struct ib_srq                   *srq;
 	struct ib_srq_init_attr          attr;
@@ -1997,8 +1997,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &srq_lock_key);
-	down_write(&obj->uobject.mutex);
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &srq_lock_key);
+	down_write(&obj->uevent.uobject.mutex);
 
 	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -2012,8 +2012,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	attr.attr.max_sge   = cmd.max_sge;
 	attr.attr.srq_limit = cmd.srq_limit;
 
-	obj->events_reported     = 0;
-	INIT_LIST_HEAD(&obj->event_list);
+	obj->uevent.events_reported = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
 
 	srq = pd->device->create_srq(pd, &attr, &udata);
 	if (IS_ERR(srq)) {
@@ -2023,7 +2023,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 
 	srq->device    	   = pd->device;
 	srq->pd        	   = pd;
-	srq->uobject       = &obj->uobject;
+	srq->uobject       = &obj->uevent.uobject;
 	srq->event_handler = attr.event_handler;
 	srq->srq_context   = attr.srq_context;
 	srq->xrc_cq        = NULL;
@@ -2031,13 +2031,13 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	atomic_inc(&pd->usecnt);
 	atomic_set(&srq->usecnt, 0);
 
-	obj->uobject.object = srq;
-	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+	obj->uevent.uobject.object = srq;
+	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
-	resp.srq_handle = obj->uobject.id;
+	resp.srq_handle = obj->uevent.uobject.id;
 	resp.max_wr     = attr.attr.max_wr;
 	resp.max_sge    = attr.attr.max_sge;
 
@@ -2050,17 +2050,17 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	put_pd_read(pd);
 
 	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->srq_list);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->srq_list);
 	mutex_unlock(&file->mutex);
 
-	obj->uobject.live = 1;
+	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uobject.mutex);
+	up_write(&obj->uevent.uobject.mutex);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
@@ -2069,7 +2069,7 @@ err_put:
 	put_pd_read(pd);
 
 err:
-	put_uobj_write(&obj->uobject);
+	put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2080,7 +2080,7 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_xrc_srq  cmd;
 	struct ib_uverbs_create_srq_resp resp;
 	struct ib_udata			 udata;
-	struct ib_uevent_object		*obj;
+	struct ib_usrq_object		*obj;
 	struct ib_pd			*pd;
 	struct ib_srq			*srq;
 	struct ib_cq			*xrc_cq;
@@ -2102,8 +2102,8 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &srq_lock_key);
-	down_write(&obj->uobject.mutex);
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &srq_lock_key);
+	down_write(&obj->uevent.uobject.mutex);
 
 	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
 	if (!pd) {
@@ -2129,8 +2129,8 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 	attr.attr.max_sge   = cmd.max_sge;
 	attr.attr.srq_limit = cmd.srq_limit;
 
-	obj->events_reported     = 0;
-	INIT_LIST_HEAD(&obj->event_list);
+	obj->uevent.events_reported = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
 
 	srq = pd->device->create_xrc_srq(pd, xrc_cq, xrcd, &attr, &udata);
 	if (IS_ERR(srq)) {
@@ -2140,7 +2140,7 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 
 	srq->device	   = pd->device;
 	srq->pd		   = pd;
-	srq->uobject	   = &obj->uobject;
+	srq->uobject	   = &obj->uevent.uobject;
 	srq->event_handler = attr.event_handler;
 	srq->srq_context   = attr.srq_context;
 	srq->xrc_cq	   = xrc_cq;
@@ -2151,13 +2151,13 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 
 	atomic_set(&srq->usecnt, 0);
 
-	obj->uobject.object = srq;
-	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+	obj->uevent.uobject.object = srq;
+	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
-	resp.srq_handle	= obj->uobject.id;
+	resp.srq_handle	= obj->uevent.uobject.id;
 	resp.max_wr	= attr.attr.max_wr;
 	resp.max_sge	= attr.attr.max_sge;
 
@@ -2172,17 +2172,17 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 	put_pd_read(pd);
 
 	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->srq_list);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->srq_list);
 	mutex_unlock(&file->mutex);
 
-	obj->uobject.live = 1;
+	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uobject.mutex);
+	up_write(&obj->uevent.uobject.mutex);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
@@ -2197,7 +2197,7 @@ err_put_pd:
 	put_pd_read(pd);
 
 err:
-	put_uobj_write(&obj->uobject);
+	put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
@@ -2279,7 +2279,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_destroy_srq_resp resp;
 	struct ib_uobject		 *uobj;
 	struct ib_srq               	 *srq;
-	struct ib_uevent_object        	 *obj;
+	struct ib_usrq_object		 *obj;
 	int                         	  ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -2289,7 +2289,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (!uobj)
 		return -EINVAL;
 	srq = uobj->object;
-	obj = container_of(uobj, struct ib_uevent_object, uobject);
+	obj = container_of(uobj, struct ib_usrq_object, uevent.uobject);
 
 	ret = ib_destroy_srq(srq);
 	if (!ret)
@@ -2306,10 +2306,10 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
-	ib_uverbs_release_uevent(file, obj);
+	ib_uverbs_release_uevent(file, &obj->uevent);
 
 	memset(&resp, 0, sizeof resp);
-	resp.events_reported = obj->events_reported;
+	resp.events_reported = obj->uevent.events_reported;
 
 	put_uobj(uobj);
 
@@ -2327,7 +2327,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	struct ib_uverbs_open_xrcd	cmd;
 	struct ib_uverbs_open_xrcd_resp	resp;
 	struct ib_udata			udata;
-	struct ib_uobject	       *uobj;
+	struct ib_uxrcd_object	       *obj;
 	struct ib_xrcd		       *xrcd;
 	int ret;
 
@@ -2345,12 +2345,12 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
+	obj = kmalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &xrcd_lock_key);
-	down_write(&uobj->mutex);
+	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_key);
+	down_write(&obj->uobject.mutex);
 
 	xrcd = file->device->ib_dev->alloc_xrcd(file->device->ib_dev,
 						file->ucontext, &udata);
@@ -2359,17 +2359,17 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		goto err;
 	}
 
-	xrcd->uobject = uobj;
+	xrcd->uobject = &obj->uobject;
 	xrcd->device  = file->device->ib_dev;
 	atomic_set(&xrcd->usecnt, 0);
 
-	uobj->object = xrcd;
-	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, uobj);
+	obj->uobject.object = xrcd;
+	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 	if (ret)
 		goto err_idr;
 
 	memset(&resp, 0, sizeof resp);
-	resp.xrcd_handle = uobj->id;
+	resp.xrcd_handle = obj->uobject.id;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
@@ -2378,23 +2378,23 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	}
 
 	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->xrcd_list);
+	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
 	mutex_unlock(&file->mutex);
 
-	uobj->live = 1;
+	obj->uobject.live = 1;
 
-	up_write(&uobj->mutex);
+	up_write(&obj->uobject.mutex);
 
 	return in_len;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 
 err_idr:
 	ib_dealloc_xrcd(xrcd);
 
 err:
-	put_uobj_write(uobj);
+	put_uobj_write(&obj->uobject);
 	return ret;
 }
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 09b5b58..2a97810 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -219,13 +219,13 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
 		struct ib_srq *srq = uobj->object;
-		struct ib_uevent_object *uevent =
-			container_of(uobj, struct ib_uevent_object, uobject);
+		struct ib_usrq_object *usrq =
+			container_of(uobj, struct ib_usrq_object, uevent.uobject);
 
 		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 		ib_destroy_srq(srq);
-		ib_uverbs_release_uevent(file, uevent);
-		kfree(uevent);
+		ib_uverbs_release_uevent(file, &usrq->uevent);
+		kfree(usrq);
 	}
 
 	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
@@ -252,10 +252,12 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
 		struct ib_xrcd *xrcd = uobj->object;
+		struct ib_uxrcd_object *uxrcd =
+			container_of(uobj, struct ib_uxrcd_object, uobject);
 
 		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
 		ib_dealloc_xrcd(xrcd);
-		kfree(uobj);
+		kfree(uxrcd);
 	}
 
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
