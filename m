From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 3/7] IB/uverbs: Add WQ support
Date: Sun, 18 Oct 2015 19:00:36 +0300
Message-ID: <1445184040-5306-4-git-send-email-yishaih@mellanox.com>
References: <1445184040-5306-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445184040-5306-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add Work Queue support, it includes create, modify and
destroy commands.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    9 ++
 drivers/infiniband/core/uverbs_cmd.c  |  218 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   25 ++++
 include/rdma/ib_verbs.h               |    3 +
 include/uapi/rdma/ib_user_verbs.h     |   41 ++++++
 5 files changed, 296 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 3863d33..ab3d331 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -162,6 +162,10 @@ struct ib_uqp_object {
 	struct ib_uxrcd_object *uxrcd;
 };
 
+struct ib_uwq_object {
+	struct ib_uevent_object	uevent;
+};
+
 struct ib_ucq_object {
 	struct ib_uobject	uobject;
 	struct ib_uverbs_file  *uverbs_file;
@@ -181,6 +185,7 @@ extern struct idr ib_uverbs_qp_idr;
 extern struct idr ib_uverbs_srq_idr;
 extern struct idr ib_uverbs_xrcd_idr;
 extern struct idr ib_uverbs_rule_idr;
+extern struct idr ib_uverbs_wq_idr;
 
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
@@ -199,6 +204,7 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context);
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr);
+void ib_uverbs_wq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
@@ -272,5 +278,8 @@ IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 IB_UVERBS_DECLARE_EX_CMD(query_device);
 IB_UVERBS_DECLARE_EX_CMD(create_cq);
+IB_UVERBS_DECLARE_EX_CMD(create_wq);
+IB_UVERBS_DECLARE_EX_CMD(modify_wq);
+IB_UVERBS_DECLARE_EX_CMD(destroy_wq);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index be4cb9f..d316cd7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -57,6 +57,7 @@ static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
 static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
+static struct uverbs_lock_class wq_lock_class = { .name = "WQ-uobj" };
 
 /*
  * The ib_uobject locking scheme is as follows:
@@ -241,6 +242,16 @@ static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
 }
 
+static struct ib_wq *idr_read_wq(int wq_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_wq_idr, wq_handle, context, 0);
+}
+
+static void put_wq_read(struct ib_wq *wq)
+{
+	put_uobj_read(wq->uobject);
+}
+
 static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
@@ -327,6 +338,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->qp_list);
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
+	INIT_LIST_HEAD(&ucontext->wq_list);
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	INIT_LIST_HEAD(&ucontext->rule_list);
 	rcu_read_lock();
@@ -2915,6 +2927,212 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 	return 0;
 }
 
+int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_create_wq	  cmd;
+	struct ib_uverbs_ex_create_wq_resp resp;
+	struct ib_uwq_object           *obj;
+	int err = 0;
+	struct ib_cq *cq;
+	struct ib_pd *pd;
+	struct ib_wq *wq;
+	struct ib_wq_init_attr wq_init_attr;
+
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	if (ucore->outlen < sizeof(resp))
+		return -ENOSPC;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext,
+		  &wq_lock_class);
+	down_write(&obj->uevent.uobject.mutex);
+	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+	if (!pd) {
+		err = -EINVAL;
+		goto err_uobj;
+	}
+
+	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
+	if (!cq) {
+		err = -EINVAL;
+		goto err_put_pd;
+	}
+
+	memset(&wq_init_attr, 0, sizeof(wq_init_attr));
+	wq_init_attr.cq = cq;
+	wq_init_attr.max_sge = cmd.max_sge;
+	wq_init_attr.max_wr = cmd.max_wr;
+	wq_init_attr.wq_context = file;
+	wq_init_attr.wq_type = cmd.wq_type;
+	wq_init_attr.event_handler = ib_uverbs_wq_event_handler;
+	obj->uevent.events_reported = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
+	wq = pd->device->create_wq(pd, &wq_init_attr, uhw);
+	if (IS_ERR(wq)) {
+		err = PTR_ERR(wq);
+		goto err_put_cq;
+	}
+
+	wq->uobject = &obj->uevent.uobject;
+	obj->uevent.uobject.object = wq;
+	wq->wq_type = wq_init_attr.wq_type;
+	wq->cq = cq;
+	wq->pd = pd;
+	wq->device = pd->device;
+	wq->wq_context = wq_init_attr.wq_context;
+	atomic_set(&wq->usecnt, 0);
+	atomic_inc(&pd->usecnt);
+	atomic_inc(&cq->usecnt);
+	wq->uobject = &obj->uevent.uobject;
+	obj->uevent.uobject.object = wq;
+	err = idr_add_uobj(&ib_uverbs_wq_idr, &obj->uevent.uobject);
+	if (err)
+		goto destroy_wq;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.wq_handle = obj->uevent.uobject.id;
+	resp.max_sge = wq_init_attr.max_sge;
+	resp.max_wr = wq_init_attr.max_wr;
+	resp.wqn = wq->wq_num;
+	resp.response_length = offsetof(typeof(resp), wqn) + sizeof(resp.wqn);
+	err = ib_copy_to_udata(ucore,
+			       &resp, sizeof(resp));
+	if (err)
+		goto err_copy;
+
+	put_pd_read(pd);
+	put_cq_read(cq);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->wq_list);
+	mutex_unlock(&file->mutex);
+
+	obj->uevent.uobject.live = 1;
+	up_write(&obj->uevent.uobject.mutex);
+	return 0;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_wq_idr, &obj->uevent.uobject);
+destroy_wq:
+	ib_destroy_wq(wq);
+err_put_cq:
+	put_cq_read(cq);
+err_put_pd:
+	put_pd_read(pd);
+err_uobj:
+	put_uobj_write(&obj->uevent.uobject);
+
+	return err;
+}
+
+int ib_uverbs_ex_destroy_wq(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
+			    struct ib_udata *ucore,
+			    struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_destroy_wq	cmd;
+	struct ib_uverbs_ex_destroy_wq_resp	resp;
+	struct ib_wq			*wq;
+	struct ib_uobject		*uobj;
+	struct ib_uwq_object		*obj;
+	int				ret;
+
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	ret = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.response_length = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
+	if (ucore->outlen < resp.response_length)
+		return -ENOSPC;
+
+	uobj = idr_write_uobj(&ib_uverbs_wq_idr, cmd.wq_handle,
+			      file->ucontext);
+	if (!uobj)
+		return -EINVAL;
+
+	wq = uobj->object;
+	obj = container_of(uobj, struct ib_uwq_object, uevent.uobject);
+	ret = ib_destroy_wq(wq);
+	if (!ret)
+		uobj->live = 0;
+
+	put_uobj_write(uobj);
+	if (ret)
+		return ret;
+
+	idr_remove_uobj(&ib_uverbs_wq_idr, uobj);
+
+	mutex_lock(&file->mutex);
+	list_del(&uobj->list);
+	mutex_unlock(&file->mutex);
+
+	ib_uverbs_release_uevent(file, &obj->uevent);
+	resp.events_reported = obj->uevent.events_reported;
+	put_uobj(uobj);
+
+	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_modify_wq cmd;
+	struct ib_wq *wq;
+	int ret;
+	struct ib_wq_attr wq_attr;
+	enum ib_wq_attr_mask attr_mask;
+
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	ret = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	if (!cmd.comp_mask)
+		return -EINVAL;
+
+	attr_mask = cmd.comp_mask;
+	wq = idr_read_wq(cmd.wq_handle, file->ucontext);
+	if (!wq)
+		return -EINVAL;
+
+	memset(&wq_attr, 0, sizeof(wq_attr));
+	wq_attr.curr_wq_state = cmd.curr_wq_state;
+	wq_attr.wq_state = cmd.wq_state;
+	ret = wq->device->modify_wq(wq, &wq_attr, attr_mask, uhw);
+	put_wq_read(wq);
+	return ret;
+}
+
 int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 			     struct ib_device *ib_dev,
 			     struct ib_udata *ucore,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index c29a660..8ae75cc 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -74,6 +74,7 @@ DEFINE_IDR(ib_uverbs_qp_idr);
 DEFINE_IDR(ib_uverbs_srq_idr);
 DEFINE_IDR(ib_uverbs_xrcd_idr);
 DEFINE_IDR(ib_uverbs_rule_idr);
+DEFINE_IDR(ib_uverbs_wq_idr);
 
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
@@ -127,6 +128,9 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
 	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device,
 	[IB_USER_VERBS_EX_CMD_CREATE_CQ]	= ib_uverbs_ex_create_cq,
+	[IB_USER_VERBS_EX_CMD_CREATE_WQ]	= ib_uverbs_ex_create_wq,
+	[IB_USER_VERBS_EX_CMD_MODIFY_WQ]	= ib_uverbs_ex_modify_wq,
+	[IB_USER_VERBS_EX_CMD_DESTROY_WQ]	= ib_uverbs_ex_destroy_wq,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -251,6 +255,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uqp);
 	}
 
+	list_for_each_entry_safe(uobj, tmp, &context->wq_list, list) {
+		struct ib_wq *wq = uobj->object;
+		struct ib_uwq_object *uwq =
+			container_of(uobj, struct ib_uwq_object, uevent.uobject);
+
+		idr_remove_uobj(&ib_uverbs_wq_idr, uobj);
+		ib_destroy_wq(wq);
+		ib_uverbs_release_uevent(file, &uwq->uevent);
+		kfree(uwq);
+	}
+
 	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
 		struct ib_srq *srq = uobj->object;
 		struct ib_uevent_object *uevent =
@@ -554,6 +569,16 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 				&uobj->events_reported);
 }
 
+void ib_uverbs_wq_event_handler(struct ib_event *event, void *context_ptr)
+{
+	struct ib_uevent_object *uobj = container_of(event->element.wq->uobject,
+						  struct ib_uevent_object, uobject);
+
+	ib_uverbs_async_handler(context_ptr, uobj->uobject.user_handle,
+				event->event, &uobj->event_list,
+				&uobj->events_reported);
+}
+
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr)
 {
 	struct ib_uevent_object *uobj;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 64d0983..7436773 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -474,6 +474,7 @@ enum ib_event_type {
 	IB_EVENT_QP_LAST_WQE_REACHED,
 	IB_EVENT_CLIENT_REREGISTER,
 	IB_EVENT_GID_CHANGE,
+	IB_EVENT_WQ_FATAL,
 };
 
 __attribute_const__ const char *ib_event_msg(enum ib_event_type event);
@@ -484,6 +485,7 @@ struct ib_event {
 		struct ib_cq	*cq;
 		struct ib_qp	*qp;
 		struct ib_srq	*srq;
+		struct ib_wq	*wq;
 		u8		port_num;
 	} element;
 	enum ib_event_type	event;
@@ -1218,6 +1220,7 @@ struct ib_ucontext {
 	struct list_head	ah_list;
 	struct list_head	xrcd_list;
 	struct list_head	rule_list;
+	struct list_head	wq_list;
 	int			closing;
 
 	struct pid             *tgid;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 978841e..2dc47e0 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -94,6 +94,9 @@ enum {
 	IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_EX_CMD_CREATE_WQ,
+	IB_USER_VERBS_EX_CMD_MODIFY_WQ,
+	IB_USER_VERBS_EX_CMD_DESTROY_WQ,
 };
 
 /*
@@ -919,4 +922,42 @@ struct ib_uverbs_destroy_srq_resp {
 	__u32 events_reported;
 };
 
+struct ib_uverbs_ex_create_wq  {
+	__u32 comp_mask;
+	__u32 wq_type;
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 cq_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+};
+
+struct ib_uverbs_ex_create_wq_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 wq_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+	__u32 wqn;
+};
+
+struct ib_uverbs_ex_destroy_wq  {
+	__u32 comp_mask;
+	__u32 wq_handle;
+};
+
+struct ib_uverbs_ex_destroy_wq_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 events_reported;
+	__u32 reserved;
+};
+
+struct ib_uverbs_ex_modify_wq  {
+	__u32 comp_mask;
+	__u32 wq_handle;
+	__u32 wq_state;
+	__u32 curr_wq_state;
+};
+
 #endif /* IB_USER_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
