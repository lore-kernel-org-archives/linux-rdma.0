From: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] IB/uverbs: Support for XRC
Date: Mon, 25 Jan 2010 11:01:32 -0800
Message-ID: <1264446094-4460-3-git-send-email-rolandd@cisco.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1264446094-4460-1-git-send-email-rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Add support for core userspace XRC operations (alloc/dealloc XRC
domain, create XRC SRQ), including adding an ABI for marshalling
requests and responses.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    4 +
 drivers/infiniband/core/uverbs_cmd.c  |  274 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/uverbs_main.c |   35 +++--
 include/rdma/ib_user_verbs.h          |   35 ++++-
 4 files changed, 334 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b3ea958..f9c051e 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -141,6 +141,7 @@ extern struct idr ib_uverbs_ah_idr;
 extern struct idr ib_uverbs_cq_idr;
 extern struct idr ib_uverbs_qp_idr;
 extern struct idr ib_uverbs_srq_idr;
+extern struct idr ib_uverbs_xrcd_idr;
 
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
@@ -194,5 +195,8 @@ IB_UVERBS_DECLARE_CMD(create_srq);
 IB_UVERBS_DECLARE_CMD(modify_srq);
 IB_UVERBS_DECLARE_CMD(query_srq);
 IB_UVERBS_DECLARE_CMD(destroy_srq);
+IB_UVERBS_DECLARE_CMD(create_xrc_srq);
+IB_UVERBS_DECLARE_CMD(open_xrcd);
+IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 112d397..92f9f11 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -46,6 +46,7 @@ static struct lock_class_key cq_lock_key;
 static struct lock_class_key qp_lock_key;
 static struct lock_class_key ah_lock_key;
 static struct lock_class_key srq_lock_key;
+static struct lock_class_key xrcd_lock_key;
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
@@ -254,6 +255,17 @@ static void put_srq_read(struct ib_srq *srq)
 	put_uobj_read(srq->uobject);
 }
 
+static struct ib_xrcd *idr_read_xrcd(int xrcd_handle,
+				     struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
+}
+
+static void put_xrcd_read(struct ib_xrcd *xrcd)
+{
+	put_uobj_read(xrcd->uobject);
+}
+
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      const char __user *buf,
 			      int in_len, int out_len)
@@ -297,6 +309,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->qp_list);
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
+	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	ucontext->closing = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
@@ -1026,6 +1039,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_srq                  *srq;
 	struct ib_qp                   *qp;
 	struct ib_qp_init_attr          attr;
+	struct ib_xrcd		       *xrcd;
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -1045,13 +1059,17 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_key);
 	down_write(&obj->uevent.uobject.mutex);
 
-	srq = cmd.is_srq ? idr_read_srq(cmd.srq_handle, file->ucontext) : NULL;
+	srq = (cmd.is_srq && cmd.qp_type != IB_QPT_XRC) ?
+		idr_read_srq(cmd.srq_handle, file->ucontext) : NULL;
+	xrcd = cmd.qp_type == IB_QPT_XRC ?
+		idr_read_xrcd(cmd.srq_handle, file->ucontext) : NULL;
 	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
 	scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, 0);
 	rcq = cmd.recv_cq_handle == cmd.send_cq_handle ?
 		scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
 
-	if (!pd || !scq || !rcq || (cmd.is_srq && !srq)) {
+	if (!pd || !scq || !rcq || (cmd.is_srq && !srq) ||
+	    (cmd.qp_type == IB_QPT_XRC && !xrcd)) {
 		ret = -EINVAL;
 		goto err_put;
 	}
@@ -1063,6 +1081,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	attr.srq           = srq;
 	attr.sq_sig_type   = cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
 	attr.qp_type       = cmd.qp_type;
+	attr.xrcd          = xrcd;
 	attr.create_flags  = 0;
 
 	attr.cap.max_send_wr     = cmd.max_send_wr;
@@ -1090,11 +1109,14 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	qp->event_handler = attr.event_handler;
 	qp->qp_context    = attr.qp_context;
 	qp->qp_type	  = attr.qp_type;
+	qp->xrcd	  = attr.xrcd;
 	atomic_inc(&pd->usecnt);
 	atomic_inc(&attr.send_cq->usecnt);
 	atomic_inc(&attr.recv_cq->usecnt);
 	if (attr.srq)
 		atomic_inc(&attr.srq->usecnt);
+	else if (attr.xrcd)
+		atomic_inc(&attr.xrcd->usecnt);
 
 	obj->uevent.uobject.object = qp;
 	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
@@ -1122,6 +1144,8 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (xrcd)
+		put_xrcd_read(xrcd);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -1148,6 +1172,8 @@ err_put:
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (xrcd)
+		put_xrcd_read(xrcd);
 
 	put_uobj_write(&obj->uevent.uobject);
 	return ret;
@@ -2000,6 +2026,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	srq->uobject       = &obj->uobject;
 	srq->event_handler = attr.event_handler;
 	srq->srq_context   = attr.srq_context;
+	srq->xrc_cq        = NULL;
+	srq->xrcd          = NULL;
 	atomic_inc(&pd->usecnt);
 	atomic_set(&srq->usecnt, 0);
 
@@ -2045,6 +2073,134 @@ err:
 	return ret;
 }
 
+ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
+				 const char __user *buf, int in_len,
+				 int out_len)
+{
+	struct ib_uverbs_create_xrc_srq  cmd;
+	struct ib_uverbs_create_srq_resp resp;
+	struct ib_udata			 udata;
+	struct ib_uevent_object		*obj;
+	struct ib_pd			*pd;
+	struct ib_srq			*srq;
+	struct ib_cq			*xrc_cq;
+	struct ib_xrcd			*xrcd;
+	struct ib_srq_init_attr		 attr;
+	int ret;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		   (unsigned long) cmd.response + sizeof resp,
+		   in_len - sizeof cmd, out_len - sizeof resp);
+
+	obj = kmalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &srq_lock_key);
+	down_write(&obj->uobject.mutex);
+
+	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+	if (!pd) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	xrc_cq  = idr_read_cq(cmd.xrc_cq, file->ucontext, 0);
+	if (!xrc_cq) {
+		ret = -EINVAL;
+		goto err_put_pd;
+	}
+
+	xrcd  = idr_read_xrcd(cmd.xrcd_handle, file->ucontext);
+	if (!xrcd) {
+		ret = -EINVAL;
+		goto err_put_cq;
+	}
+
+	attr.event_handler  = ib_uverbs_srq_event_handler;
+	attr.srq_context    = file;
+	attr.attr.max_wr    = cmd.max_wr;
+	attr.attr.max_sge   = cmd.max_sge;
+	attr.attr.srq_limit = cmd.srq_limit;
+
+	obj->events_reported     = 0;
+	INIT_LIST_HEAD(&obj->event_list);
+
+	srq = pd->device->create_xrc_srq(pd, xrc_cq, xrcd, &attr, &udata);
+	if (IS_ERR(srq)) {
+		ret = PTR_ERR(srq);
+		goto err_put;
+	}
+
+	srq->device	   = pd->device;
+	srq->pd		   = pd;
+	srq->uobject	   = &obj->uobject;
+	srq->event_handler = attr.event_handler;
+	srq->srq_context   = attr.srq_context;
+	srq->xrc_cq	   = xrc_cq;
+	srq->xrcd	   = xrcd;
+	atomic_inc(&pd->usecnt);
+	atomic_inc(&xrc_cq->usecnt);
+	atomic_inc(&xrcd->usecnt);
+
+	atomic_set(&srq->usecnt, 0);
+
+	obj->uobject.object = srq;
+	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+	if (ret)
+		goto err_destroy;
+
+	memset(&resp, 0, sizeof resp);
+	resp.srq_handle	= obj->uobject.id;
+	resp.max_wr	= attr.attr.max_wr;
+	resp.max_sge	= attr.attr.max_sge;
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	put_xrcd_read(xrcd);
+	put_cq_read(xrc_cq);
+	put_pd_read(pd);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&obj->uobject.list, &file->ucontext->srq_list);
+	mutex_unlock(&file->mutex);
+
+	obj->uobject.live = 1;
+
+	up_write(&obj->uobject.mutex);
+
+	return in_len;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+
+err_destroy:
+	ib_destroy_srq(srq);
+
+err_put:
+	put_xrcd_read(xrcd);
+
+err_put_cq:
+	put_cq_read(xrc_cq);
+
+err_put_pd:
+	put_pd_read(pd);
+
+err:
+	put_uobj_write(&obj->uobject);
+	return ret;
+}
+
 ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 			     const char __user *buf, int in_len,
 			     int out_len)
@@ -2163,3 +2319,117 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
+
+ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_open_xrcd	cmd;
+	struct ib_uverbs_open_xrcd_resp	resp;
+	struct ib_udata			udata;
+	struct ib_uobject	       *uobj;
+	struct ib_xrcd		       *xrcd;
+	int ret;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	/* file descriptors/inodes not yet implemented */
+	if (cmd.fd != -1)
+		return -ENOSYS;
+
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		   (unsigned long) cmd.response + sizeof resp,
+		   in_len - sizeof cmd, out_len - sizeof resp);
+
+	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
+	if (!uobj)
+		return -ENOMEM;
+
+	init_uobj(uobj, 0, file->ucontext, &xrcd_lock_key);
+	down_write(&uobj->mutex);
+
+	xrcd = file->device->ib_dev->alloc_xrcd(file->device->ib_dev,
+						file->ucontext, &udata);
+	if (IS_ERR(xrcd)) {
+		ret = PTR_ERR(xrcd);
+		goto err;
+	}
+
+	xrcd->uobject = uobj;
+	xrcd->device  = file->device->ib_dev;
+	atomic_set(&xrcd->usecnt, 0);
+
+	uobj->object = xrcd;
+	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, uobj);
+	if (ret)
+		goto err_idr;
+
+	memset(&resp, 0, sizeof resp);
+	resp.xrcd_handle = uobj->id;
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&uobj->list, &file->ucontext->xrcd_list);
+	mutex_unlock(&file->mutex);
+
+	uobj->live = 1;
+
+	up_write(&uobj->mutex);
+
+	return in_len;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+
+err_idr:
+	ib_dealloc_xrcd(xrcd);
+
+err:
+	put_uobj_write(uobj);
+	return ret;
+}
+
+ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
+				   const char __user *buf, int in_len,
+				   int out_len)
+{
+	struct ib_uverbs_close_xrcd	cmd;
+	struct ib_uobject	       *uobj;
+	int				ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle,
+			      file->ucontext);
+	if (!uobj)
+		return -EINVAL;
+
+	ret = ib_dealloc_xrcd(uobj->object);
+	if (!ret)
+		uobj->live = 0;
+
+	put_uobj_write(uobj);
+
+	if (ret)
+		return ret;
+
+	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+
+	mutex_lock(&file->mutex);
+	list_del(&uobj->list);
+	mutex_unlock(&file->mutex);
+
+	put_uobj(uobj);
+
+	return in_len;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5f284ff..09b5b58 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -73,6 +73,7 @@ DEFINE_IDR(ib_uverbs_ah_idr);
 DEFINE_IDR(ib_uverbs_cq_idr);
 DEFINE_IDR(ib_uverbs_qp_idr);
 DEFINE_IDR(ib_uverbs_srq_idr);
+DEFINE_IDR(ib_uverbs_xrcd_idr);
 
 static DEFINE_SPINLOCK(map_lock);
 static struct ib_uverbs_device *dev_table[IB_UVERBS_MAX_DEVICES];
@@ -109,6 +110,9 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_MODIFY_SRQ]    	= ib_uverbs_modify_srq,
 	[IB_USER_VERBS_CMD_QUERY_SRQ]     	= ib_uverbs_query_srq,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]   	= ib_uverbs_destroy_srq,
+	[IB_USER_VERBS_CMD_CREATE_XRC_SRQ]	= ib_uverbs_create_xrc_srq,
+	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
+	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 };
 
 static struct vfsmount *uverbs_event_mnt;
@@ -212,17 +216,6 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uqp);
 	}
 
-	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
-		struct ib_cq *cq = uobj->object;
-		struct ib_uverbs_event_file *ev_file = cq->cq_context;
-		struct ib_ucq_object *ucq =
-			container_of(uobj, struct ib_ucq_object, uobject);
-
-		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
-		ib_destroy_cq(cq);
-		ib_uverbs_release_ucq(file, ev_file, ucq);
-		kfree(ucq);
-	}
 
 	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
 		struct ib_srq *srq = uobj->object;
@@ -235,6 +228,18 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uevent);
 	}
 
+	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
+		struct ib_cq *cq = uobj->object;
+		struct ib_uverbs_event_file *ev_file = cq->cq_context;
+		struct ib_ucq_object *ucq =
+			container_of(uobj, struct ib_ucq_object, uobject);
+
+		idr_remove_uobj(&ib_uverbs_cq_idr, uobj);
+		ib_destroy_cq(cq);
+		ib_uverbs_release_ucq(file, ev_file, ucq);
+		kfree(ucq);
+	}
+
 	/* XXX Free MWs */
 
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
@@ -245,6 +250,14 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
+		struct ib_xrcd *xrcd = uobj->object;
+
+		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+		ib_dealloc_xrcd(xrcd);
+		kfree(uobj);
+	}
+
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index a17f771..c9e540c 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -81,7 +81,10 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_CREATE_XRC_SRQ,
+	IB_USER_VERBS_CMD_OPEN_XRCD,
+	IB_USER_VERBS_CMD_CLOSE_XRCD
 };
 
 /*
@@ -647,6 +650,18 @@ struct ib_uverbs_create_srq {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_create_xrc_srq {
+	__u64 response;
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+	__u32 srq_limit;
+	__u32 xrcd_handle;
+	__u32 xrc_cq;
+	__u64 driver_data[0];
+};
+
 struct ib_uverbs_create_srq_resp {
 	__u32 srq_handle;
 	__u32 max_wr;
@@ -686,4 +701,22 @@ struct ib_uverbs_destroy_srq_resp {
 	__u32 events_reported;
 };
 
+struct ib_uverbs_open_xrcd {
+	__u64 response;
+	__s32 fd;
+	__u32 oflags;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_open_xrcd_resp {
+	__u32 xrcd_handle;
+};
+
+struct ib_uverbs_close_xrcd {
+	__u64 response;
+	__u32 xrcd_handle;
+	__u32 reserved;
+	__u64 driver_data[0];
+};
+
 #endif /* IB_USER_VERBS_H */
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
