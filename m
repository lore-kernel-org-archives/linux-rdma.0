From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 4/9] IB/core: Extend ib_uverbs_create_cq
Date: Sun, 31 May 2015 15:14:12 +0300
Message-ID: <1433074457-26437-5-git-send-email-ogerlitz@mellanox.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433074457-26437-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ib_uverbs_ex_create_cq follows the extension verbs
mechanism. New features (for example, CQ creation flags
field which is added in a downstream patch) could used
via user-space libraries without breaking the ABI.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    1 +
 drivers/infiniband/core/uverbs_cmd.c  |  170 ++++++++++++++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c |    1 +
 include/uapi/rdma/ib_user_verbs.h     |   17 ++++
 4 files changed, 154 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b716b08..ba365b6 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -259,5 +259,6 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 IB_UVERBS_DECLARE_EX_CMD(query_device);
+IB_UVERBS_DECLARE_EX_CMD(create_cq);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 1954ebb..51311b1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1330,41 +1330,37 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	return in_len;
 }
 
-ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
+				       struct ib_udata *ucore,
+				       struct ib_udata *uhw,
+				       struct ib_uverbs_ex_create_cq *cmd,
+				       size_t cmd_sz,
+				       int (*cb)(struct ib_uverbs_file *file,
+						 struct ib_ucq_object *obj,
+						 struct ib_uverbs_ex_create_cq_resp *resp,
+						 struct ib_udata *udata,
+						 void *context),
+				       void *context)
 {
-	struct ib_uverbs_create_cq      cmd;
-	struct ib_uverbs_create_cq_resp resp;
-	struct ib_udata                 udata;
 	struct ib_ucq_object           *obj;
 	struct ib_uverbs_event_file    *ev_file = NULL;
 	struct ib_cq                   *cq;
 	int                             ret;
+	struct ib_uverbs_ex_create_cq_resp resp;
 	struct ib_cq_init_attr attr = {};
 
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
-	if (cmd.comp_vector >= file->device->num_comp_vectors)
-		return -EINVAL;
+	if (cmd->comp_vector >= file->device->num_comp_vectors)
+		return ERR_PTR(-EINVAL);
 
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
 	if (!obj)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	init_uobj(&obj->uobject, cmd.user_handle, file->ucontext, &cq_lock_class);
+	init_uobj(&obj->uobject, cmd->user_handle, file->ucontext, &cq_lock_class);
 	down_write(&obj->uobject.mutex);
 
-	if (cmd.comp_channel >= 0) {
-		ev_file = ib_uverbs_lookup_comp_file(cmd.comp_channel);
+	if (cmd->comp_channel >= 0) {
+		ev_file = ib_uverbs_lookup_comp_file(cmd->comp_channel);
 		if (!ev_file) {
 			ret = -EINVAL;
 			goto err;
@@ -1377,10 +1373,14 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&obj->comp_list);
 	INIT_LIST_HEAD(&obj->async_list);
 
-	attr.cqe = cmd.cqe;
-	attr.comp_vector = cmd.comp_vector;
+	attr.cqe = cmd->cqe;
+	attr.comp_vector = cmd->comp_vector;
+
+	if (cmd_sz > offsetof(typeof(*cmd), flags) + sizeof(cmd->flags))
+		attr.flags = cmd->flags;
+
 	cq = file->device->ib_dev->create_cq(file->device->ib_dev, &attr,
-					     file->ucontext, &udata);
+					     file->ucontext, uhw);
 	if (IS_ERR(cq)) {
 		ret = PTR_ERR(cq);
 		goto err_file;
@@ -1399,14 +1399,15 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 		goto err_free;
 
 	memset(&resp, 0, sizeof resp);
-	resp.cq_handle = obj->uobject.id;
-	resp.cqe       = cq->cqe;
+	resp.base.cq_handle = obj->uobject.id;
+	resp.base.cqe       = cq->cqe;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
-		ret = -EFAULT;
-		goto err_copy;
-	}
+	resp.response_length = offsetof(typeof(resp), response_length) +
+		sizeof(resp.response_length);
+
+	ret = cb(file, obj, &resp, ucore, context);
+	if (ret)
+		goto err_cb;
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uobject.list, &file->ucontext->cq_list);
@@ -1416,9 +1417,9 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 
 	up_write(&obj->uobject.mutex);
 
-	return in_len;
+	return obj;
 
-err_copy:
+err_cb:
 	idr_remove_uobj(&ib_uverbs_cq_idr, &obj->uobject);
 
 err_free:
@@ -1430,7 +1431,106 @@ err_file:
 
 err:
 	put_uobj_write(&obj->uobject);
-	return ret;
+
+	return ERR_PTR(ret);
+}
+
+static int ib_uverbs_create_cq_cb(struct ib_uverbs_file *file,
+				  struct ib_ucq_object *obj,
+				  struct ib_uverbs_ex_create_cq_resp *resp,
+				  struct ib_udata *ucore, void *context)
+{
+	if (ib_copy_to_udata(ucore, &resp->base, sizeof(resp->base)))
+		return -EFAULT;
+
+	return 0;
+}
+
+ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_create_cq      cmd;
+	struct ib_uverbs_ex_create_cq	cmd_ex;
+	struct ib_uverbs_create_cq_resp resp;
+	struct ib_udata                 ucore;
+	struct ib_udata                 uhw;
+	struct ib_ucq_object           *obj;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	INIT_UDATA(&ucore, buf, cmd.response, sizeof(cmd), sizeof(resp));
+
+	INIT_UDATA(&uhw, buf + sizeof(cmd),
+		   (unsigned long)cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd), out_len - sizeof(resp));
+
+	memset(&cmd_ex, 0, sizeof(cmd_ex));
+	cmd_ex.user_handle = cmd.user_handle;
+	cmd_ex.cqe = cmd.cqe;
+	cmd_ex.comp_vector = cmd.comp_vector;
+	cmd_ex.comp_channel = cmd.comp_channel;
+
+	obj = create_cq(file, &ucore, &uhw, &cmd_ex,
+			offsetof(typeof(cmd_ex), comp_channel) +
+			sizeof(cmd.comp_channel), ib_uverbs_create_cq_cb,
+			NULL);
+
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	return in_len;
+}
+
+static int ib_uverbs_ex_create_cq_cb(struct ib_uverbs_file *file,
+				     struct ib_ucq_object *obj,
+				     struct ib_uverbs_ex_create_cq_resp *resp,
+				     struct ib_udata *ucore, void *context)
+{
+	if (ib_copy_to_udata(ucore, resp, resp->response_length))
+		return -EFAULT;
+
+	return 0;
+}
+
+int ib_uverbs_ex_create_cq(struct ib_uverbs_file *file,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_create_cq_resp resp;
+	struct ib_uverbs_ex_create_cq  cmd;
+	struct ib_ucq_object           *obj;
+	int err;
+
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
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
+	obj = create_cq(file, ucore, uhw, &cmd,
+			min(ucore->inlen, sizeof(cmd)),
+			ib_uverbs_ex_create_cq_cb, NULL);
+
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	return 0;
 }
 
 ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 88cce9b..f6eef2d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -124,6 +124,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
 	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device,
+	[IB_USER_VERBS_EX_CMD_CREATE_CQ]	= ib_uverbs_ex_create_cq,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index b513e66..19f0256 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -91,6 +91,7 @@ enum {
 
 enum {
 	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
+	IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
 };
@@ -353,11 +354,27 @@ struct ib_uverbs_create_cq {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_ex_create_cq {
+	__u64 user_handle;
+	__u32 cqe;
+	__u32 comp_vector;
+	__s32 comp_channel;
+	__u32 comp_mask;
+	__u32 flags;
+	__u32 reserved;
+};
+
 struct ib_uverbs_create_cq_resp {
 	__u32 cq_handle;
 	__u32 cqe;
 };
 
+struct ib_uverbs_ex_create_cq_resp {
+	struct ib_uverbs_create_cq_resp base;
+	__u32 comp_mask;
+	__u32 response_length;
+};
+
 struct ib_uverbs_resize_cq {
 	__u64 response;
 	__u32 cq_handle;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
