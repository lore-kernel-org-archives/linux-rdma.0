From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/uverbs: Introduce RWQ Indirection table
Date: Thu, 15 Oct 2015 10:16:49 +0300
Message-ID: <1444893410-13242-7-git-send-email-yishaih@mellanox.com>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444893410-13242-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce RWQ indirection table uverbs commands, it includes:
create, destroy.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    3 +
 drivers/infiniband/core/uverbs_cmd.c  |  187 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   13 +++
 include/rdma/ib_verbs.h               |    1 +
 include/uapi/rdma/ib_user_verbs.h     |   24 ++++
 5 files changed, 228 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ab3d331..0885d7a 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -186,6 +186,7 @@ extern struct idr ib_uverbs_srq_idr;
 extern struct idr ib_uverbs_xrcd_idr;
 extern struct idr ib_uverbs_rule_idr;
 extern struct idr ib_uverbs_wq_idr;
+extern struct idr ib_uverbs_rwq_ind_tbl_idr;
 
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
@@ -281,5 +282,7 @@ IB_UVERBS_DECLARE_EX_CMD(create_cq);
 IB_UVERBS_DECLARE_EX_CMD(create_wq);
 IB_UVERBS_DECLARE_EX_CMD(modify_wq);
 IB_UVERBS_DECLARE_EX_CMD(destroy_wq);
+IB_UVERBS_DECLARE_EX_CMD(create_rwq_ind_table);
+IB_UVERBS_DECLARE_EX_CMD(destroy_rwq_ind_table);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d316cd7..7653a0c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -58,6 +58,7 @@ static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
 static struct uverbs_lock_class wq_lock_class = { .name = "WQ-uobj" };
+static struct uverbs_lock_class rwq_ind_table_lock_class = { .name = "IND_TBL-uobj" };
 
 /*
  * The ib_uobject locking scheme is as follows:
@@ -339,6 +340,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
 	INIT_LIST_HEAD(&ucontext->wq_list);
+	INIT_LIST_HEAD(&ucontext->rwq_ind_tbl_list);
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	INIT_LIST_HEAD(&ucontext->rule_list);
 	rcu_read_lock();
@@ -3133,6 +3135,191 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 	return ret;
 }
 
+int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
+				      struct ib_device *ib_dev,
+				      struct ib_udata *ucore,
+				      struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_create_rwq_ind_table	  cmd;
+	struct ib_uverbs_ex_create_rwq_ind_table_resp	resp;
+	struct ib_uobject		  *uobj;
+	int err = 0;
+	struct ib_rwq_ind_table_init_attr init_attr;
+	struct ib_rwq_ind_table *rwq_ind_tbl;
+	struct ib_wq	**wqs = NULL;
+	u32 *wqs_handles = NULL;
+	struct ib_wq	*wq = NULL;
+	int i, j, num_read_wqs;
+	u32 num_wq_handles;
+	u32 expected_in_size;
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
+	ucore->inbuf += sizeof(cmd);
+	ucore->inlen -= sizeof(cmd);
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	num_wq_handles = 1 << cmd.log_ind_tbl_size;
+	expected_in_size = num_wq_handles * sizeof(__u32);
+	if (num_wq_handles == 1)
+		/* input size for wq handles is u64 aligned */
+		expected_in_size += sizeof(__u32);
+
+	if (ucore->inlen != expected_in_size)
+		return -EINVAL;
+
+	wqs_handles = kcalloc(num_wq_handles, sizeof(*wqs_handles),
+			      GFP_KERNEL);
+	if (!wqs_handles)
+		return -ENOMEM;
+
+	err = ib_copy_from_udata(wqs_handles, ucore,
+				 num_wq_handles * sizeof(__u32));
+	if (err)
+		goto err_free;
+
+	wqs = kcalloc(num_wq_handles, sizeof(*wqs), GFP_KERNEL);
+	if (!wqs)
+		goto  err_free;
+
+	for (num_read_wqs = 0; num_read_wqs < num_wq_handles;
+			num_read_wqs++) {
+		wq = idr_read_wq(wqs_handles[num_read_wqs], file->ucontext);
+		if (!wq)
+			goto put_wqs;
+
+		wqs[num_read_wqs] = wq;
+	}
+
+	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
+	if (!uobj) {
+		err = -ENOMEM;
+		goto put_wqs;
+	}
+
+	init_uobj(uobj, 0, file->ucontext, &rwq_ind_table_lock_class);
+	down_write(&uobj->mutex);
+	memset(&init_attr, 0, sizeof(init_attr));
+	init_attr.log_ind_tbl_size = cmd.log_ind_tbl_size;
+	init_attr.ind_tbl = wqs;
+	rwq_ind_tbl = ib_dev->create_rwq_ind_table(ib_dev, &init_attr, uhw);
+
+	if (IS_ERR(rwq_ind_tbl)) {
+		err = PTR_ERR(rwq_ind_tbl);
+		goto err_uobj;
+	}
+
+	rwq_ind_tbl->ind_tbl = wqs;
+	rwq_ind_tbl->log_ind_tbl_size = init_attr.log_ind_tbl_size;
+	rwq_ind_tbl->uobject = uobj;
+	uobj->object = rwq_ind_tbl;
+	rwq_ind_tbl->device = ib_dev;
+	atomic_set(&rwq_ind_tbl->usecnt, 0);
+
+	for (i = 0; i < num_wq_handles; i++)
+		atomic_inc(&wqs[i]->usecnt);
+
+	err = idr_add_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+	if (err)
+		goto destroy_ind_tbl;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.ind_tbl_handle = uobj->id;
+	resp.ind_tbl_num = rwq_ind_tbl->ind_tbl_num;
+	resp.response_length = offsetof(typeof(resp), ind_tbl_num) + sizeof(resp.ind_tbl_num);
+
+	err = ib_copy_to_udata(ucore,
+			       &resp, sizeof(resp));
+	if (err)
+		goto err_copy;
+
+	kfree(wqs_handles);
+
+	for (j = 0; j < num_read_wqs; j++)
+		put_wq_read(wqs[j]);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&uobj->list, &file->ucontext->rwq_ind_tbl_list);
+	mutex_unlock(&file->mutex);
+
+	uobj->live = 1;
+
+	up_write(&uobj->mutex);
+	return 0;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+destroy_ind_tbl:
+	ib_destroy_rwq_ind_table(rwq_ind_tbl);
+err_uobj:
+	put_uobj_write(uobj);
+put_wqs:
+	for (j = 0; j < num_read_wqs; j++)
+		put_wq_read(wqs[j]);
+err_free:
+	kfree(wqs_handles);
+	kfree(wqs);
+	return err;
+}
+
+int ib_uverbs_ex_destroy_rwq_ind_table(struct ib_uverbs_file *file,
+				       struct ib_device *ib_dev,
+				       struct ib_udata *ucore,
+				       struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_destroy_rwq_ind_table	cmd;
+	struct ib_rwq_ind_table *rwq_ind_tbl;
+	struct ib_uobject		*uobj;
+	int			ret;
+	struct ib_wq	**ind_tbl;
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
+	uobj = idr_write_uobj(&ib_uverbs_rwq_ind_tbl_idr, cmd.ind_tbl_handle,
+			      file->ucontext);
+	if (!uobj)
+		return -EINVAL;
+	rwq_ind_tbl = uobj->object;
+	ind_tbl = rwq_ind_tbl->ind_tbl;
+
+	ret = ib_destroy_rwq_ind_table(rwq_ind_tbl);
+	if (!ret)
+		uobj->live = 0;
+
+	put_uobj_write(uobj);
+
+	if (ret)
+		return ret;
+
+	idr_remove_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+
+	mutex_lock(&file->mutex);
+	list_del(&uobj->list);
+	mutex_unlock(&file->mutex);
+
+	put_uobj(uobj);
+	kfree(ind_tbl);
+	return ret;
+}
+
 int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 			     struct ib_device *ib_dev,
 			     struct ib_udata *ucore,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8ae75cc..cf548df 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -75,6 +75,7 @@ DEFINE_IDR(ib_uverbs_srq_idr);
 DEFINE_IDR(ib_uverbs_xrcd_idr);
 DEFINE_IDR(ib_uverbs_rule_idr);
 DEFINE_IDR(ib_uverbs_wq_idr);
+DEFINE_IDR(ib_uverbs_rwq_ind_tbl_idr);
 
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
@@ -131,6 +132,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_CREATE_WQ]	= ib_uverbs_ex_create_wq,
 	[IB_USER_VERBS_EX_CMD_MODIFY_WQ]	= ib_uverbs_ex_modify_wq,
 	[IB_USER_VERBS_EX_CMD_DESTROY_WQ]	= ib_uverbs_ex_destroy_wq,
+	[IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL] = ib_uverbs_ex_create_rwq_ind_table,
+	[IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL] = ib_uverbs_ex_destroy_rwq_ind_table,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -255,6 +258,16 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uqp);
 	}
 
+	list_for_each_entry_safe(uobj, tmp, &context->rwq_ind_tbl_list, list) {
+		struct ib_rwq_ind_table *rwq_ind_tbl = uobj->object;
+		struct ib_wq **ind_tbl = rwq_ind_tbl->ind_tbl;
+
+		idr_remove_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
+		ib_destroy_rwq_ind_table(rwq_ind_tbl);
+		kfree(ind_tbl);
+		kfree(uobj);
+	}
+
 	list_for_each_entry_safe(uobj, tmp, &context->wq_list, list) {
 		struct ib_wq *wq = uobj->object;
 		struct ib_uwq_object *uwq =
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d517abe..36f4a45 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1221,6 +1221,7 @@ struct ib_ucontext {
 	struct list_head	xrcd_list;
 	struct list_head	rule_list;
 	struct list_head	wq_list;
+	struct list_head	rwq_ind_tbl_list;
 	int			closing;
 
 	struct pid             *tgid;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 2dc47e0..d4b92ee 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -97,6 +97,8 @@ enum {
 	IB_USER_VERBS_EX_CMD_CREATE_WQ,
 	IB_USER_VERBS_EX_CMD_MODIFY_WQ,
 	IB_USER_VERBS_EX_CMD_DESTROY_WQ,
+	IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL,
+	IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL
 };
 
 /*
@@ -960,4 +962,26 @@ struct ib_uverbs_ex_modify_wq  {
 	__u32 curr_wq_state;
 };
 
+struct ib_uverbs_ex_create_rwq_ind_table  {
+	__u32 comp_mask;
+	__u32 log_ind_tbl_size;
+	/* Following are the wq handles according to log_ind_tbl_size
+	 * wq_handle1
+	 * wq_handle2
+	 */
+	__u32 wq_handles[0];
+};
+
+struct ib_uverbs_ex_create_rwq_ind_table_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 ind_tbl_handle;
+	__u32 ind_tbl_num;
+};
+
+struct ib_uverbs_ex_destroy_rwq_ind_table  {
+	__u32 comp_mask;
+	__u32 ind_tbl_handle;
+};
+
 #endif /* IB_USER_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
