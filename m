From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/20 v2] rdma/uverbs: Export ib_open_qp() capability to
 user space
Date: Fri, 19 Aug 2011 02:14:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41AB3@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow processes that share the same xrc domain to open an
existing shareable QP.  This permits those processes to
receive events on the shared QP and transfer ownership,
so that any process may modify the QP.  The latter allows
the creating process to exit, while a remaining process can
still transition it for path migration purposes.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
changes from v1:
Everything in this patch is new too!

 drivers/infiniband/core/uverbs.h     |    1 
 drivers/infiniband/core/uverbs_cmd.c |   92 ++++++++++++++++++++++++++++++++++
 include/rdma/ib_user_verbs.h         |   14 +++++
 3 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 00ce032..5bcb2af 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -195,6 +195,7 @@ IB_UVERBS_DECLARE_CMD(poll_cq);
 IB_UVERBS_DECLARE_CMD(req_notify_cq);
 IB_UVERBS_DECLARE_CMD(destroy_cq);
 IB_UVERBS_DECLARE_CMD(create_qp);
+IB_UVERBS_DECLARE_CMD(open_qp);
 IB_UVERBS_DECLARE_CMD(query_qp);
 IB_UVERBS_DECLARE_CMD(modify_qp);
 IB_UVERBS_DECLARE_CMD(destroy_qp);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3d2226c..98ed04f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1545,6 +1545,98 @@ err_put:
 	return ret;
 }
 
+ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
+			  const char __user *buf, int in_len, int out_len)
+{
+	struct ib_uverbs_open_qp        cmd;
+	struct ib_uverbs_create_qp_resp resp;
+	struct ib_udata                 udata;
+	struct ib_uqp_object           *obj;
+	struct ib_xrcd		       *xrcd;
+	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
+	struct ib_qp                   *qp;
+	struct ib_qp_open_attr          attr;
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
+	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_key);
+	down_write(&obj->uevent.uobject.mutex);
+
+	xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
+	if (!xrcd) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
+	attr.event_handler = ib_uverbs_qp_event_handler;
+	attr.qp_context    = file;
+	attr.qp_num        = cmd.qpn;
+	attr.qp_type       = cmd.qp_type;
+
+	obj->uevent.events_reported = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
+	INIT_LIST_HEAD(&obj->mcast_list);
+
+	qp = ib_open_qp(xrcd, &attr);
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
+		goto err_put;
+	}
+
+	qp->uobject = &obj->uevent.uobject;
+
+	obj->uevent.uobject.object = qp;
+	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+	if (ret)
+		goto err_destroy;
+
+	memset(&resp, 0, sizeof resp);
+	resp.qpn       = qp->qp_num;
+	resp.qp_handle = obj->uevent.uobject.id;
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		ret = -EFAULT;
+		goto err_remove;
+	}
+
+	put_xrcd_read(xrcd_uobj);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
+	mutex_unlock(&file->mutex);
+
+	obj->uevent.uobject.live = 1;
+
+	up_write(&obj->uevent.uobject.mutex);
+
+	return in_len;
+
+err_remove:
+	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
+
+err_destroy:
+	ib_destroy_qp(qp);
+
+err_put:
+	put_xrcd_read(xrcd_uobj);
+	put_uobj_write(&obj->uevent.uobject);
+	return ret;
+}
+
 ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 			   const char __user *buf, int in_len,
 			   int out_len)
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index 100abbb..81aba3a 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -84,7 +84,8 @@ enum {
 	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 	IB_USER_VERBS_CMD_OPEN_XRCD,
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
-	IB_USER_VERBS_CMD_CREATE_XSRQ
+	IB_USER_VERBS_CMD_CREATE_XSRQ,
+	IB_USER_VERBS_CMD_OPEN_QP
 };
 
 /*
@@ -422,6 +423,17 @@ struct ib_uverbs_create_qp {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_open_qp {
+	__u64 response;
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 qpn;
+	__u8  qp_type;
+	__u8  reserved[7];
+	__u64 driver_data[0];
+};
+
+/* also used for open response */
 struct ib_uverbs_create_qp_resp {
 	__u32 qp_handle;
 	__u32 qpn;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
