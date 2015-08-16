From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Sun, 16 Aug 2015 19:05:27 +0300
Message-ID: <1439741133-30145-2-git-send-email-eranbe@mellanox.com>
References: <1439741133-30145-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439741133-30145-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_uverbs_ex_create_qp follows the extension verbs
mechanism. New features (for example, QP creation flags
field which is added in a downstream patch) could used
via user-space libraries without breaking the ABI.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 256 +++++++++++++++++++++++++---------
 drivers/infiniband/core/uverbs_main.c |   1 +
 include/uapi/rdma/ib_user_verbs.h     |  26 ++++
 4 files changed, 220 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ba365b6..627cec1 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -260,5 +260,6 @@ IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 IB_UVERBS_DECLARE_EX_CMD(query_device);
 IB_UVERBS_DECLARE_EX_CMD(create_cq);
+IB_UVERBS_DECLARE_EX_CMD(create_qp);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ff..2bac2f1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1721,65 +1721,65 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	return in_len;
 }
 
-ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
-{
-	struct ib_uverbs_create_qp      cmd;
-	struct ib_uverbs_create_qp_resp resp;
-	struct ib_udata                 udata;
-	struct ib_uqp_object           *obj;
-	struct ib_device	       *device;
-	struct ib_pd                   *pd = NULL;
-	struct ib_xrcd		       *xrcd = NULL;
-	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
-	struct ib_cq                   *scq = NULL, *rcq = NULL;
-	struct ib_srq                  *srq = NULL;
-	struct ib_qp                   *qp;
-	struct ib_qp_init_attr          attr;
-	int ret;
-
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
-	if (copy_from_user(&cmd, buf, sizeof cmd))
-		return -EFAULT;
+static int create_qp(struct ib_uverbs_file *file,
+		     struct ib_udata *ucore,
+		     struct ib_udata *uhw,
+		     struct ib_uverbs_ex_create_qp *cmd,
+		     size_t cmd_sz,
+		     int (*cb)(struct ib_uverbs_file *file,
+			       struct ib_uverbs_ex_create_qp_resp *resp,
+			       struct ib_udata *udata),
+		     void *context)
+{
+	struct ib_uqp_object		*obj;
+	struct ib_device		*device;
+	struct ib_pd			*pd = NULL;
+	struct ib_xrcd			*xrcd = NULL;
+	struct ib_uobject		*uninitialized_var(xrcd_uobj);
+	struct ib_cq			*scq = NULL, *rcq = NULL;
+	struct ib_srq			*srq = NULL;
+	struct ib_qp			*qp;
+	char				*buf;
+	struct ib_qp_init_attr		attr;
+	struct ib_uverbs_ex_create_qp_resp resp;
+	int				ret;
 
-	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
-
 	obj = kzalloc(sizeof *obj, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_class);
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
+		  &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
-	if (cmd.qp_type == IB_QPT_XRC_TGT) {
-		xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
+	if (cmd->qp_type == IB_QPT_XRC_TGT) {
+		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
+				     &xrcd_uobj);
 		if (!xrcd) {
 			ret = -EINVAL;
 			goto err_put;
 		}
 		device = xrcd->device;
 	} else {
-		if (cmd.qp_type == IB_QPT_XRC_INI) {
-			cmd.max_recv_wr = cmd.max_recv_sge = 0;
+		if (cmd->qp_type == IB_QPT_XRC_INI) {
+			cmd->max_recv_wr = 0;
+			cmd->max_recv_sge = 0;
 		} else {
-			if (cmd.is_srq) {
-				srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+			if (cmd->is_srq) {
+				srq = idr_read_srq(cmd->srq_handle,
+						   file->ucontext);
 				if (!srq || srq->srq_type != IB_SRQT_BASIC) {
 					ret = -EINVAL;
 					goto err_put;
 				}
 			}
 
-			if (cmd.recv_cq_handle != cmd.send_cq_handle) {
-				rcq = idr_read_cq(cmd.recv_cq_handle, file->ucontext, 0);
+			if (cmd->recv_cq_handle != cmd->send_cq_handle) {
+				rcq = idr_read_cq(cmd->recv_cq_handle,
+						  file->ucontext, 0);
 				if (!rcq) {
 					ret = -EINVAL;
 					goto err_put;
@@ -1787,9 +1787,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 			}
 		}
 
-		scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, !!rcq);
+		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
 		rcq = rcq ?: scq;
-		pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
 		if (!pd || !scq) {
 			ret = -EINVAL;
 			goto err_put;
@@ -1804,31 +1804,54 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	attr.recv_cq       = rcq;
 	attr.srq           = srq;
 	attr.xrcd	   = xrcd;
-	attr.sq_sig_type   = cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
-	attr.qp_type       = cmd.qp_type;
+	attr.sq_sig_type   = cmd->sq_sig_all ? IB_SIGNAL_ALL_WR :
+					      IB_SIGNAL_REQ_WR;
+	attr.qp_type       = cmd->qp_type;
 	attr.create_flags  = 0;
 
-	attr.cap.max_send_wr     = cmd.max_send_wr;
-	attr.cap.max_recv_wr     = cmd.max_recv_wr;
-	attr.cap.max_send_sge    = cmd.max_send_sge;
-	attr.cap.max_recv_sge    = cmd.max_recv_sge;
-	attr.cap.max_inline_data = cmd.max_inline_data;
+	attr.cap.max_send_wr     = cmd->max_send_wr;
+	attr.cap.max_recv_wr     = cmd->max_recv_wr;
+	attr.cap.max_send_sge    = cmd->max_send_sge;
+	attr.cap.max_recv_sge    = cmd->max_recv_sge;
+	attr.cap.max_inline_data = cmd->max_inline_data;
 
 	obj->uevent.events_reported     = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 	INIT_LIST_HEAD(&obj->mcast_list);
 
-	if (cmd.qp_type == IB_QPT_XRC_TGT)
+	if (cmd_sz >= offsetof(typeof(*cmd), create_flags) +
+		      sizeof(cmd->create_flags))
+		attr.create_flags = cmd->create_flags;
+
+	if (attr.create_flags) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
+	if (cmd->comp_mask) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
+	buf = (void *)cmd + sizeof(*cmd);
+	if (cmd_sz > sizeof(*cmd))
+		if (!(buf[0] == 0 && !memcmp(buf, buf + 1,
+					     cmd_sz - sizeof(*cmd) - 1))) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+
+	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
-		qp = device->create_qp(pd, &attr, &udata);
+		qp = device->create_qp(pd, &attr, uhw);
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
 		goto err_put;
 	}
 
-	if (cmd.qp_type != IB_QPT_XRC_TGT) {
+	if (cmd->qp_type != IB_QPT_XRC_TGT) {
 		qp->real_qp	  = qp;
 		qp->device	  = device;
 		qp->pd		  = pd;
@@ -1854,19 +1877,20 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		goto err_destroy;
 
 	memset(&resp, 0, sizeof resp);
-	resp.qpn             = qp->qp_num;
-	resp.qp_handle       = obj->uevent.uobject.id;
-	resp.max_recv_sge    = attr.cap.max_recv_sge;
-	resp.max_send_sge    = attr.cap.max_send_sge;
-	resp.max_recv_wr     = attr.cap.max_recv_wr;
-	resp.max_send_wr     = attr.cap.max_send_wr;
-	resp.max_inline_data = attr.cap.max_inline_data;
+	resp.base.qpn             = qp->qp_num;
+	resp.base.qp_handle       = obj->uevent.uobject.id;
+	resp.base.max_recv_sge    = attr.cap.max_recv_sge;
+	resp.base.max_send_sge    = attr.cap.max_send_sge;
+	resp.base.max_recv_wr     = attr.cap.max_recv_wr;
+	resp.base.max_send_wr     = attr.cap.max_send_wr;
+	resp.base.max_inline_data = attr.cap.max_inline_data;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
-		ret = -EFAULT;
-		goto err_copy;
-	}
+	resp.response_length = offsetof(typeof(resp), response_length) +
+			       sizeof(resp.response_length);
+
+	ret = cb(file, &resp, ucore);
+	if (ret)
+		goto err_cb;
 
 	if (xrcd) {
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
@@ -1892,9 +1916,8 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 
 	up_write(&obj->uevent.uobject.mutex);
 
-	return in_len;
-
-err_copy:
+	return 0;
+err_cb:
 	idr_remove_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
 
 err_destroy:
@@ -1916,6 +1939,111 @@ err_put:
 	return ret;
 }
 
+static int ib_uverbs_create_qp_cb(struct ib_uverbs_file *file,
+				  struct ib_uverbs_ex_create_qp_resp *resp,
+				  struct ib_udata *ucore)
+{
+	if (ib_copy_to_udata(ucore, &resp->base, sizeof(resp->base)))
+		return -EFAULT;
+
+	return 0;
+}
+
+ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_create_qp      cmd;
+	struct ib_uverbs_ex_create_qp	cmd_ex;
+	struct ib_udata			ucore;
+	struct ib_udata			uhw;
+	ssize_t resp_size = sizeof(struct ib_uverbs_create_qp_resp);
+	int				err;
+
+	if (out_len < resp_size)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response, sizeof(cmd),
+		   resp_size);
+	INIT_UDATA(&uhw, buf + sizeof(cmd),
+		   (unsigned long)cmd.response + resp_size,
+		   in_len - sizeof(cmd), out_len - resp_size);
+
+	memset(&cmd_ex, 0, sizeof(cmd_ex));
+	cmd_ex.user_handle = cmd.user_handle;
+	cmd_ex.pd_handle = cmd.pd_handle;
+	cmd_ex.send_cq_handle = cmd.send_cq_handle;
+	cmd_ex.recv_cq_handle = cmd.recv_cq_handle;
+	cmd_ex.srq_handle = cmd.srq_handle;
+	cmd_ex.max_send_wr = cmd.max_send_wr;
+	cmd_ex.max_recv_wr = cmd.max_recv_wr;
+	cmd_ex.max_send_sge = cmd.max_send_sge;
+	cmd_ex.max_recv_sge = cmd.max_recv_sge;
+	cmd_ex.max_inline_data = cmd.max_inline_data;
+	cmd_ex.sq_sig_all = cmd.sq_sig_all;
+	cmd_ex.qp_type = cmd.qp_type;
+	cmd_ex.is_srq = cmd.is_srq;
+
+	err = create_qp(file, &ucore, &uhw, &cmd_ex,
+			offsetof(typeof(cmd_ex), is_srq) +
+			sizeof(cmd.is_srq), ib_uverbs_create_qp_cb,
+			NULL);
+
+	if (err)
+		return err;
+
+	return in_len;
+}
+
+static int ib_uverbs_ex_create_qp_cb(struct ib_uverbs_file *file,
+				     struct ib_uverbs_ex_create_qp_resp *resp,
+				     struct ib_udata *ucore)
+{
+	if (ib_copy_to_udata(ucore, resp, resp->response_length))
+		return -EFAULT;
+
+	return 0;
+}
+
+int ib_uverbs_ex_create_qp(struct ib_uverbs_file *file,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_create_qp_resp resp;
+	struct ib_uverbs_ex_create_qp cmd = {0};
+	int err;
+
+	if (ucore->inlen < (offsetof(typeof(cmd), comp_mask) +
+			    sizeof(cmd.comp_mask)))
+		return -EINVAL;
+
+	err = ib_copy_from_udata(&cmd, ucore, min(sizeof(cmd), ucore->inlen));
+	if (err)
+		return err;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	if (cmd.reserved)
+		return -EINVAL;
+
+	if (ucore->outlen < (offsetof(typeof(resp), response_length) +
+			     sizeof(resp.response_length)))
+		return -ENOSPC;
+
+	err = create_qp(file, ucore, uhw, &cmd,
+			min(ucore->inlen, sizeof(cmd)),
+			ib_uverbs_ex_create_qp_cb, NULL);
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
 ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 			  const char __user *buf, int in_len, int out_len)
 {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 46c9229..392a05b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -125,6 +125,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
 	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device,
 	[IB_USER_VERBS_EX_CMD_CREATE_CQ]	= ib_uverbs_ex_create_cq,
+	[IB_USER_VERBS_EX_CMD_CREATE_QP]        = ib_uverbs_ex_create_qp,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 978841e..8126c14 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -92,6 +92,7 @@ enum {
 enum {
 	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
 	IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ,
+	IB_USER_VERBS_EX_CMD_CREATE_QP = IB_USER_VERBS_CMD_CREATE_QP,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
 };
@@ -516,6 +517,25 @@ struct ib_uverbs_create_qp {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_ex_create_qp {
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 send_cq_handle;
+	__u32 recv_cq_handle;
+	__u32 srq_handle;
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_send_sge;
+	__u32 max_recv_sge;
+	__u32 max_inline_data;
+	__u8  sq_sig_all;
+	__u8  qp_type;
+	__u8  is_srq;
+	__u8 reserved;
+	__u32 comp_mask;
+	__u32 create_flags;
+};
+
 struct ib_uverbs_open_qp {
 	__u64 response;
 	__u64 user_handle;
@@ -538,6 +558,12 @@ struct ib_uverbs_create_qp_resp {
 	__u32 reserved;
 };
 
+struct ib_uverbs_ex_create_qp_resp {
+	struct ib_uverbs_create_qp_resp base;
+	__u32 comp_mask;
+	__u32 response_length;
+};
+
 /*
  * This struct needs to remain a multiple of 8 bytes to keep the
  * alignment of the modify QP parameters.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
