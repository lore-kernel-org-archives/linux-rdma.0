From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/17] rdma/uverbs: Export XRC SRQs to user space
Date: Wed, 15 Jun 2011 06:28:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302101E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We require additional information to create XRC SRQs than we
can exchange using the existing create SRQ ABI.  Provide an
enhanced create ABI for extended SRQ types.

Based on patches by Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
and Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    6 +
 drivers/infiniband/core/uverbs_cmd.c  |  172 +++++++++++++++++++++++++--------
 drivers/infiniband/core/uverbs_main.c |    1 
 include/rdma/ib_user_verbs.h          |   19 +++-
 4 files changed, 156 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 461e2f3..00ce032 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -127,6 +127,11 @@ struct ib_uxrcd_object {
 	atomic_t		refcnt;
 };
 
+struct ib_usrq_object {
+	struct ib_uevent_object	uevent;
+	struct ib_uxrcd_object *uxrcd;
+};
+
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
 	struct list_head 	mcast_list;
@@ -204,6 +209,7 @@ IB_UVERBS_DECLARE_CMD(create_srq);
 IB_UVERBS_DECLARE_CMD(modify_srq);
 IB_UVERBS_DECLARE_CMD(query_srq);
 IB_UVERBS_DECLARE_CMD(destroy_srq);
+IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7b2b3b8..095b393 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1401,7 +1401,8 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	rcq = cmd.recv_cq_handle == cmd.send_cq_handle ?
 		scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
 
-	if (!pd || !scq || !rcq || (cmd.is_srq && !srq)) {
+	if (!pd || !scq || !rcq ||
+	    (cmd.is_srq && (!srq || srq->srq_type != IB_SRQT_BASIC))) {
 		ret = -EINVAL;
 		goto err_put;
 	}
@@ -2294,108 +2295,199 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
-			     const char __user *buf, int in_len,
-			     int out_len)
+int __uverbs_create_xsrq(struct ib_uverbs_file *file,
+			 struct ib_uverbs_create_xsrq *cmd,
+			 struct ib_udata *udata)
 {
-	struct ib_uverbs_create_srq      cmd;
 	struct ib_uverbs_create_srq_resp resp;
-	struct ib_udata                  udata;
-	struct ib_uevent_object         *obj;
+	struct ib_usrq_object           *obj;
 	struct ib_pd                    *pd;
 	struct ib_srq                   *srq;
+	struct ib_uobject               *uninitialized_var(xrcd_uobj);
 	struct ib_srq_init_attr          attr;
 	int ret;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
-	if (copy_from_user(&cmd, buf, sizeof cmd))
-		return -EFAULT;
-
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
-
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &srq_lock_key);
-	down_write(&obj->uobject.mutex);
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_key);
+	down_write(&obj->uevent.uobject.mutex);
 
-	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err;
 	}
 
+	if (cmd->srq_type == IB_SRQT_XRC) {
+		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		if (!attr.ext.xrc.cq) {
+			ret = -EINVAL;
+			goto err_put_pd;
+		}
+
+		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
+		if (!attr.ext.xrc.xrcd) {
+			ret = -EINVAL;
+			goto err_put_cq;
+		}
+
+		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
+		atomic_inc(&obj->uxrcd->refcnt);
+	}
+
 	attr.event_handler  = ib_uverbs_srq_event_handler;
 	attr.srq_context    = file;
-	attr.srq_type       = IB_SRQT_BASIC;
-	attr.attr.max_wr    = cmd.max_wr;
-	attr.attr.max_sge   = cmd.max_sge;
-	attr.attr.srq_limit = cmd.srq_limit;
+	attr.srq_type       = cmd->srq_type;
+	attr.attr.max_wr    = cmd->max_wr;
+	attr.attr.max_sge   = cmd->max_sge;
+	attr.attr.srq_limit = cmd->srq_limit;
 
-	obj->events_reported     = 0;
-	INIT_LIST_HEAD(&obj->event_list);
+	obj->uevent.events_reported = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
 
-	srq = pd->device->create_srq(pd, &attr, &udata);
+	srq = pd->device->create_srq(pd, &attr, udata);
 	if (IS_ERR(srq)) {
 		ret = PTR_ERR(srq);
 		goto err_put;
 	}
 
-	srq->device    	   = pd->device;
-	srq->pd        	   = pd;
-	srq->uobject       = &obj->uobject;
+	srq->device        = pd->device;
+	srq->pd            = pd;
+	srq->srq_type	   = cmd->srq_type;
+	srq->uobject       = &obj->uevent.uobject;
 	srq->event_handler = attr.event_handler;
 	srq->srq_context   = attr.srq_context;
+
+	if (cmd->srq_type == IB_SRQT_XRC) {
+		srq->ext.xrc.cq   = attr.ext.xrc.cq;
+		srq->ext.xrc.xrcd = attr.ext.xrc.xrcd;
+		atomic_inc(&attr.ext.xrc.cq->usecnt);
+		atomic_inc(&attr.ext.xrc.xrcd->usecnt);
+	}
+
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
+	if (cmd->srq_type == IB_SRQT_XRC)
+		resp.srqn = srq->ext.xrc.srq_num;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+	if (copy_to_user((void __user *) (unsigned long) cmd->response,
 			 &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
 
+	if (cmd->srq_type == IB_SRQT_XRC) {
+		put_uobj_read(xrcd_uobj);
+		put_cq_read(attr.ext.xrc.cq);
+	}
 	put_pd_read(pd);
 
 	mutex_lock(&file->mutex);
-	list_add_tail(&obj->uobject.list, &file->ucontext->srq_list);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->srq_list);
 	mutex_unlock(&file->mutex);
 
-	obj->uobject.live = 1;
+	obj->uevent.uobject.live = 1;
 
-	up_write(&obj->uobject.mutex);
+	up_write(&obj->uevent.uobject.mutex);
 
-	return in_len;
+	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uobject);
+	idr_remove_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 
 err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
+	if (cmd->srq_type == IB_SRQT_XRC) {
+		atomic_dec(&obj->uxrcd->refcnt);
+		put_uobj_read(xrcd_uobj);
+	}
+
+err_put_cq:
+	if (cmd->srq_type == IB_SRQT_XRC)
+		put_cq_read(attr.ext.xrc.cq);
+
+err_put_pd:
 	put_pd_read(pd);
 
 err:
-	put_uobj_write(&obj->uobject);
+	put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
+ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
+			     const char __user *buf, int in_len,
+			     int out_len)
+{
+	struct ib_uverbs_create_srq      cmd;
+	struct ib_uverbs_create_xsrq     xcmd;
+	struct ib_uverbs_create_srq_resp resp;
+	struct ib_udata                  udata;
+	int ret;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	xcmd.response = cmd.response;
+	xcmd.user_handle = cmd.user_handle;
+	xcmd.srq_type = IB_SRQT_BASIC;
+	xcmd.pd_handle = cmd.pd_handle;
+	xcmd.max_wr = cmd.max_wr;
+	xcmd.max_sge= cmd.max_sge;
+	xcmd.srq_limit = cmd.srq_limit;
+
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		   (unsigned long) cmd.response + sizeof resp,
+		   in_len - sizeof cmd, out_len - sizeof resp);
+
+	ret = __uverbs_create_xsrq(file, &xcmd, &udata);
+	if (ret)
+		return ret;
+
+	return in_len;
+}
+
+ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
+			      const char __user *buf, int in_len, int out_len)
+{
+	struct ib_uverbs_create_xsrq     cmd;
+	struct ib_uverbs_create_srq_resp resp;
+	struct ib_udata                  udata;
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
+	ret = __uverbs_create_xsrq(file, &cmd, &udata);
+	if (ret)
+		return ret;
+
+	return in_len;
+}
+
 ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 			     const char __user *buf, int in_len,
 			     int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index ee16817..dbe9064 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -110,6 +110,7 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]		= ib_uverbs_destroy_srq,
 	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
+	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index b5cb63f..100abbb 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -83,7 +83,8 @@ enum {
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
 	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 	IB_USER_VERBS_CMD_OPEN_XRCD,
-	IB_USER_VERBS_CMD_CLOSE_XRCD
+	IB_USER_VERBS_CMD_CLOSE_XRCD,
+	IB_USER_VERBS_CMD_CREATE_XSRQ
 };
 
 /*
@@ -665,11 +666,25 @@ struct ib_uverbs_create_srq {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_create_xsrq {
+	__u64 response;
+	__u64 user_handle;
+	__u32 srq_type;
+	__u32 pd_handle;
+	__u32 max_wr;
+	__u32 max_sge;
+	__u32 srq_limit;
+	__u32 reserved;
+	__u32 xrcd_handle;
+	__u32 cq_handle;
+	__u64 driver_data[0];
+};
+
 struct ib_uverbs_create_srq_resp {
 	__u32 srq_handle;
 	__u32 max_wr;
 	__u32 max_sge;
-	__u32 reserved;
+	__u32 srqn;
 };
 
 struct ib_uverbs_modify_srq {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
