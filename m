From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 3/4] uverbs_cmd: Add uverbs command definitions for
	reg_io_mr
Date: Thu, 29 Jul 2010 11:25:14 -0500
Message-ID: <20100729162514.14674.81115.stgit@build.ogc.int>
References: <20100729162339.14674.15788.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729162339.14674.15788.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Add the uverbs command definitions and marshalling and unmarshalling
routines to handle requests from user space.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 drivers/infiniband/core/uverbs.h      |    2 
 drivers/infiniband/core/uverbs_cmd.c  |  140 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |    2 
 include/rdma/ib_user_verbs.h          |   24 +++++-
 4 files changed, 167 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a078e56..17c0828 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -195,5 +195,7 @@ IB_UVERBS_DECLARE_CMD(create_srq);
 IB_UVERBS_DECLARE_CMD(modify_srq);
 IB_UVERBS_DECLARE_CMD(query_srq);
 IB_UVERBS_DECLARE_CMD(destroy_srq);
+IB_UVERBS_DECLARE_CMD(reg_io_mr);
+IB_UVERBS_DECLARE_CMD(dereg_io_mr);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fcfbeb..8e72a50 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -716,6 +716,146 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+ssize_t ib_uverbs_reg_io_mr(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_reg_io_mr      cmd;
+	struct ib_uverbs_reg_io_mr_resp resp;
+	struct ib_udata                   udata;
+	struct ib_uobject                *uobj;
+	struct ib_pd                     *pd;
+	struct ib_mr                     *mr;
+	int                               ret;
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
+	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
+		return -EINVAL;
+
+	/*
+	 * Local write permission is required if remote write or
+	 * remote atomic permission is also requested.
+	 */
+	if ((cmd.access_flags &
+	     (IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_REMOTE_WRITE)) &&
+	    !(cmd.access_flags & IB_ACCESS_LOCAL_WRITE))
+		return -EINVAL;
+
+	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
+	if (!uobj)
+		return -ENOMEM;
+
+	init_uobj(uobj, 0, file->ucontext, &mr_lock_key);
+	down_write(&uobj->mutex);
+
+	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	if (!pd) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	mr = pd->device->reg_io_mr(pd, cmd.start, cmd.length, cmd.hca_va,
+				   cmd.access_flags, &udata);
+	if (IS_ERR(mr)) {
+		ret = PTR_ERR(mr);
+		goto err_put;
+	}
+
+	mr->device  = pd->device;
+	mr->pd      = pd;
+	mr->uobject = uobj;
+	atomic_inc(&pd->usecnt);
+	atomic_set(&mr->usecnt, 0);
+
+	uobj->object = mr;
+	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	if (ret)
+		goto err_unreg;
+
+	memset(&resp, 0, sizeof resp);
+	resp.lkey      = mr->lkey;
+	resp.rkey      = mr->rkey;
+	resp.mr_handle = uobj->id;
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	put_pd_read(pd);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&uobj->list, &file->ucontext->mr_list);
+	mutex_unlock(&file->mutex);
+
+	uobj->live = 1;
+
+	up_write(&uobj->mutex);
+
+	return in_len;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+
+err_unreg:
+	ib_dereg_mr(mr);
+
+err_put:
+	put_pd_read(pd);
+
+err_free:
+	put_uobj_write(uobj);
+	return ret;
+}
+
+ssize_t ib_uverbs_dereg_io_mr(struct ib_uverbs_file *file,
+			      const char __user *buf, int in_len,
+			      int out_len)
+{
+	struct ib_uverbs_dereg_io_mr cmd;
+	struct ib_mr                 *mr;
+	struct ib_uobject	     *uobj;
+	int                           ret = -EINVAL;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
+	if (!uobj)
+		return -EINVAL;
+
+	mr = uobj->object;
+
+	ret = ib_dereg_mr(mr);
+	if (!ret)
+		uobj->live = 0;
+
+	put_uobj_write(uobj);
+
+	if (ret)
+		return ret;
+
+	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
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
index ec83e9f..2b4e110 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -86,6 +86,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_DEALLOC_PD]		= ib_uverbs_dealloc_pd,
 	[IB_USER_VERBS_CMD_REG_MR]		= ib_uverbs_reg_mr,
 	[IB_USER_VERBS_CMD_DEREG_MR]		= ib_uverbs_dereg_mr,
+	[IB_USER_VERBS_CMD_REG_IO_MR]		= ib_uverbs_reg_io_mr,
+	[IB_USER_VERBS_CMD_DEREG_IO_MR]		= ib_uverbs_dereg_io_mr,
 	[IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL] = ib_uverbs_create_comp_channel,
 	[IB_USER_VERBS_CMD_CREATE_CQ]		= ib_uverbs_create_cq,
 	[IB_USER_VERBS_CMD_RESIZE_CQ]		= ib_uverbs_resize_cq,
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index a17f771..2e1f7a0 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -81,7 +81,9 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_REG_IO_MR,
+	IB_USER_VERBS_CMD_DEREG_IO_MR,
 };
 
 /*
@@ -241,6 +243,26 @@ struct ib_uverbs_dereg_mr {
 	__u32 mr_handle;
 };
 
+struct ib_uverbs_reg_io_mr {
+	__u64 response;
+	__u64 start;
+	__u64 length;
+	__u64 hca_va;
+	__u32 pd_handle;
+	__u32 access_flags;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_reg_io_mr_resp {
+	__u32 mr_handle;
+	__u32 lkey;
+	__u32 rkey;
+};
+
+struct ib_uverbs_dereg_io_mr {
+	__u32 mr_handle;
+};
+
 struct ib_uverbs_create_comp_channel {
 	__u64 response;
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
