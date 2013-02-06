From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 07/10] IB/uverbs: Implement memory windows support in uverbs
Date: Wed,  6 Feb 2013 18:19:13 +0200
Message-ID: <1360167556-20756-8-git-send-email-ogerlitz@mellanox.com>
References: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360167556-20756-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The existing user/kernel uverbs API has IB_USER_VERBS_CMD_ALLOC/DEALLOC_MW,
implement these calls, along with destroying user memory windows
during process cleanup.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    2 +
 drivers/infiniband/core/uverbs_cmd.c  |  121 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   13 +++-
 include/uapi/rdma/ib_user_verbs.h     |   16 +++++
 4 files changed, 150 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 5bcb2af..0fcd7aa 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -188,6 +188,8 @@ IB_UVERBS_DECLARE_CMD(alloc_pd);
 IB_UVERBS_DECLARE_CMD(dealloc_pd);
 IB_UVERBS_DECLARE_CMD(reg_mr);
 IB_UVERBS_DECLARE_CMD(dereg_mr);
+IB_UVERBS_DECLARE_CMD(alloc_mw);
+IB_UVERBS_DECLARE_CMD(dealloc_mw);
 IB_UVERBS_DECLARE_CMD(create_comp_channel);
 IB_UVERBS_DECLARE_CMD(create_cq);
 IB_UVERBS_DECLARE_CMD(resize_cq);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0cb0007..3983a05 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -48,6 +48,7 @@ struct uverbs_lock_class {
 
 static struct uverbs_lock_class pd_lock_class	= { .name = "PD-uobj" };
 static struct uverbs_lock_class mr_lock_class	= { .name = "MR-uobj" };
+static struct uverbs_lock_class mw_lock_class	= { .name = "MW-uobj" };
 static struct uverbs_lock_class cq_lock_class	= { .name = "CQ-uobj" };
 static struct uverbs_lock_class qp_lock_class	= { .name = "QP-uobj" };
 static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
@@ -1049,6 +1050,126 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
+			 const char __user *buf, int in_len,
+			 int out_len)
+{
+	struct ib_uverbs_alloc_mw      cmd;
+	struct ib_uverbs_alloc_mw_resp resp;
+	struct ib_uobject             *uobj;
+	struct ib_pd                  *pd;
+	struct ib_mw                  *mw;
+	int                            ret;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
+	if (!uobj)
+		return -ENOMEM;
+
+	init_uobj(uobj, 0, file->ucontext, &mw_lock_class);
+	down_write(&uobj->mutex);
+
+	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	if (!pd) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	mw = pd->device->alloc_mw(pd, cmd.mw_type);
+	if (IS_ERR(mw)) {
+		ret = PTR_ERR(mw);
+		goto err_put;
+	}
+
+	mw->device  = pd->device;
+	mw->pd      = pd;
+	mw->uobject = uobj;
+	atomic_inc(&pd->usecnt);
+
+	uobj->object = mw;
+	ret = idr_add_uobj(&ib_uverbs_mw_idr, uobj);
+	if (ret)
+		goto err_unalloc;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.rkey      = mw->rkey;
+	resp.mw_handle = uobj->id;
+
+	if (copy_to_user((void __user *)(unsigned long)cmd.response,
+			 &resp, sizeof(resp))) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	put_pd_read(pd);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&uobj->list, &file->ucontext->mw_list);
+	mutex_unlock(&file->mutex);
+
+	uobj->live = 1;
+
+	up_write(&uobj->mutex);
+
+	return in_len;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+
+err_unalloc:
+	ib_dealloc_mw(mw);
+
+err_put:
+	put_pd_read(pd);
+
+err_free:
+	put_uobj_write(uobj);
+	return ret;
+}
+
+ssize_t ib_uverbs_dealloc_mw(struct ib_uverbs_file *file,
+			   const char __user *buf, int in_len,
+			   int out_len)
+{
+	struct ib_uverbs_dealloc_mw cmd;
+	struct ib_mw               *mw;
+	struct ib_uobject	   *uobj;
+	int                         ret = -EINVAL;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	uobj = idr_write_uobj(&ib_uverbs_mw_idr, cmd.mw_handle, file->ucontext);
+	if (!uobj)
+		return -EINVAL;
+
+	mw = uobj->object;
+
+	ret = ib_dealloc_mw(mw);
+	if (!ret)
+		uobj->live = 0;
+
+	put_uobj_write(uobj);
+
+	if (ret)
+		return ret;
+
+	idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+
+	mutex_lock(&file->mutex);
+	list_del(&uobj->list);
+	mutex_unlock(&file->mutex);
+
+	put_uobj(uobj);
+
+	return in_len;
+}
+
 ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 				      const char __user *buf, int in_len,
 				      int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 6f2ce6f..2c6f0f2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -87,6 +87,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_DEALLOC_PD]		= ib_uverbs_dealloc_pd,
 	[IB_USER_VERBS_CMD_REG_MR]		= ib_uverbs_reg_mr,
 	[IB_USER_VERBS_CMD_DEREG_MR]		= ib_uverbs_dereg_mr,
+	[IB_USER_VERBS_CMD_ALLOC_MW]		= ib_uverbs_alloc_mw,
+	[IB_USER_VERBS_CMD_DEALLOC_MW]		= ib_uverbs_dealloc_mw,
 	[IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL] = ib_uverbs_create_comp_channel,
 	[IB_USER_VERBS_CMD_CREATE_CQ]		= ib_uverbs_create_cq,
 	[IB_USER_VERBS_CMD_RESIZE_CQ]		= ib_uverbs_resize_cq,
@@ -201,6 +203,15 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	/* Remove MWs before QPs, in order to support type 2A MWs. */
+	list_for_each_entry_safe(uobj, tmp, &context->mw_list, list) {
+		struct ib_mw *mw = uobj->object;
+
+		idr_remove_uobj(&ib_uverbs_mw_idr, uobj);
+		ib_dealloc_mw(mw);
+		kfree(uobj);
+	}
+
 	list_for_each_entry_safe(uobj, tmp, &context->qp_list, list) {
 		struct ib_qp *qp = uobj->object;
 		struct ib_uqp_object *uqp =
@@ -240,8 +251,6 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uevent);
 	}
 
-	/* XXX Free MWs */
-
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 81aba3a..805711e 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -261,6 +261,22 @@ struct ib_uverbs_dereg_mr {
 	__u32 mr_handle;
 };
 
+struct ib_uverbs_alloc_mw {
+	__u64 response;
+	__u32 pd_handle;
+	__u8  mw_type;
+	__u8  reserved[3];
+};
+
+struct ib_uverbs_alloc_mw_resp {
+	__u32 mw_handle;
+	__u32 rkey;
+};
+
+struct ib_uverbs_dealloc_mw {
+	__u32 mw_handle;
+};
+
 struct ib_uverbs_create_comp_channel {
 	__u64 response;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
