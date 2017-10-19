From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 06/16] IB/uverbs: Add create/destroy counter set support
Date: Thu, 19 Oct 2017 17:41:48 +0300
Message-ID: <1508424118-27205-7-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

User space application which uses counter set functionality,
is expected to allocate/release the counter set hardware
resources by calling create/destroy verbs and in turn get
a unique handle that can be used to bind the counter set to
its counted type so the hardware related counters could be
queried.

Downstream patches in this series will introduce the bind and the
query functionality.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h           |   2 +
 drivers/infiniband/core/uverbs_cmd.c       | 117 +++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c      |   2 +
 drivers/infiniband/core/uverbs_std_types.c |  15 +++-
 include/rdma/uverbs_std_types.h            |   1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h    |   1 +
 include/uapi/rdma/ib_user_verbs.h          |  25 ++++++
 7 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 7a95153..e1e8379 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -308,5 +308,7 @@ struct ib_uverbs_flow_spec {
 IB_UVERBS_DECLARE_EX_CMD(modify_qp);
 IB_UVERBS_DECLARE_EX_CMD(modify_cq);
 IB_UVERBS_DECLARE_EX_CMD(describe_counter_set);
+IB_UVERBS_DECLARE_EX_CMD(create_counter_set);
+IB_UVERBS_DECLARE_EX_CMD(destroy_counter_set);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 24775a5..b648c8f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3984,3 +3984,120 @@ int ib_uverbs_ex_describe_counter_set(struct ib_uverbs_file *file,
 	kfree(cs_describe_attr.counters_names_buff);
 	return ret;
 }
+
+int ib_uverbs_ex_create_counter_set(struct ib_uverbs_file *file,
+				    struct ib_device *ib_dev,
+				    struct ib_udata *ucore,
+				    struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_create_counter_set	cmd = {};
+	struct ib_uverbs_ex_create_counter_set_resp	resp = {};
+	struct ib_counter_set	*cs;
+	struct ib_uobject	*uobj;
+	size_t	required_resp_len;
+	size_t	required_cmd_sz;
+	int	ret = 0;
+
+	required_cmd_sz = offsetof(typeof(cmd), reserved) +
+			sizeof(cmd.reserved);
+	required_resp_len = offsetof(typeof(resp), reserved) +
+			sizeof(resp.reserved);
+
+	if (ucore->inlen < required_cmd_sz)
+		return -EINVAL;
+
+	if (ucore->outlen < required_resp_len)
+		return -ENOSPC;
+
+	if (ucore->inlen > sizeof(cmd) &&
+	    !ib_is_udata_cleared(ucore, sizeof(cmd),
+			ucore->inlen - sizeof(cmd)))
+		return -EOPNOTSUPP;
+
+	ret = ib_copy_from_udata(&cmd, ucore, min(sizeof(cmd), ucore->inlen));
+	if (ret)
+		return ret;
+
+	if (cmd.comp_mask || cmd.reserved)
+		return -EOPNOTSUPP;
+
+	uobj = uobj_alloc(uobj_get_type(counter_set), file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
+	cs = ib_dev->create_counter_set(ib_dev, cmd.cs_id, uhw);
+	if (IS_ERR(cs)) {
+		ret = PTR_ERR(cs);
+		goto err_uobj;
+	}
+	uobj->object = cs;
+	cs->device = ib_dev;
+	cs->uobject = uobj;
+	cs->cs_id = cmd.cs_id;
+	atomic_set(&cs->usecnt, 0);
+	resp.cs_handle = uobj->id;
+	resp.response_length = required_resp_len;
+	ret = ib_copy_to_udata(ucore,
+			       &resp, required_resp_len);
+	if (ret)
+		goto err_copy;
+
+	uobj_alloc_commit(uobj);
+
+	return 0;
+
+err_copy:
+	ib_destroy_counter_set(cs);
+err_uobj:
+	uobj_alloc_abort(uobj);
+	return ret;
+}
+
+int ib_uverbs_ex_destroy_counter_set(struct ib_uverbs_file *file,
+				     struct ib_device *ib_dev,
+				     struct ib_udata *ucore,
+				     struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_destroy_counter_set	cmd = {};
+	struct ib_uverbs_ex_destroy_counter_set_resp	resp = {};
+	struct ib_uobject	*uobj;
+	size_t	required_resp_len;
+	size_t	required_cmd_sz;
+	int	ret;
+
+	required_cmd_sz = offsetof(typeof(cmd), cs_handle) +
+			sizeof(cmd.cs_handle);
+	required_resp_len = offsetof(typeof(resp), response_length) +
+			sizeof(resp.response_length);
+
+	if (ucore->inlen < required_cmd_sz)
+		return -EINVAL;
+
+	if (ucore->outlen < required_resp_len)
+		return -ENOSPC;
+
+	if (ucore->inlen > sizeof(cmd) &&
+	    !ib_is_udata_cleared(ucore, sizeof(cmd),
+			   ucore->inlen - sizeof(cmd)))
+		return -EOPNOTSUPP;
+
+	ret = ib_copy_from_udata(&cmd, ucore, min(sizeof(cmd), ucore->inlen));
+	if (ret)
+		return ret;
+
+	if (cmd.comp_mask)
+		return -EOPNOTSUPP;
+
+	uobj  = uobj_get_write(uobj_get_type(counter_set),
+			       cmd.cs_handle,
+			       file->ucontext);
+	if (IS_ERR(uobj))
+		return PTR_ERR(uobj);
+
+	ret = uobj_remove_commit(uobj);
+	if (ret)
+		return ret;
+
+	resp.response_length = required_resp_len;
+	return ib_copy_to_udata(ucore, &resp, resp.response_length);
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 51b04bd..e9e575d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -130,6 +130,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_MODIFY_QP]        = ib_uverbs_ex_modify_qp,
 	[IB_USER_VERBS_EX_CMD_MODIFY_CQ]        = ib_uverbs_ex_modify_cq,
 	[IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET]	= ib_uverbs_ex_describe_counter_set,
+	[IB_USER_VERBS_EX_CMD_CREATE_COUNTER_SET]	= ib_uverbs_ex_create_counter_set,
+	[IB_USER_VERBS_EX_CMD_DESTROY_COUNTER_SET]	= ib_uverbs_ex_destroy_counter_set,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index b095bce..b49cc75 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -190,6 +190,15 @@ static int uverbs_free_pd(struct ib_uobject *uobject,
 	return 0;
 }
 
+static int uverbs_free_counter_set(struct ib_uobject *uobject,
+				   enum rdma_remove_reason why)
+{
+	struct ib_counter_set *ib_cs =
+			(struct ib_counter_set *)(uobject->object);
+
+	return ib_destroy_counter_set(ib_cs);
+}
+
 static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_file,
 						   enum rdma_remove_reason why)
 {
@@ -435,6 +444,9 @@ static DECLARE_UVERBS_METHOD(
 		      /* 2 is used in order to free the PD after MRs */
 		      &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd));
 
+DECLARE_UVERBS_OBJECT(uverbs_object_counter_set, UVERBS_OBJECT_COUNTER_SET,
+		      &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_counter_set));
+
 DECLARE_UVERBS_OBJECT(uverbs_object_device, UVERBS_OBJECT_DEVICE, NULL);
 
 DECLARE_UVERBS_OBJECT_TREE(uverbs_default_objects,
@@ -450,4 +462,5 @@ static DECLARE_UVERBS_METHOD(
 			   &uverbs_object_flow,
 			   &uverbs_object_wq,
 			   &uverbs_object_rwq_ind_table,
-			   &uverbs_object_xrcd);
+			   &uverbs_object_xrcd,
+			   &uverbs_object_counter_set);
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 5f8e20b..1690c52 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -51,6 +51,7 @@
 extern const struct uverbs_object_def uverbs_object_pd;
 extern const struct uverbs_object_def uverbs_object_xrcd;
 extern const struct uverbs_object_def uverbs_object_device;
+extern const struct uverbs_object_def uverbs_object_counter_set;
 
 extern const struct uverbs_object_tree_def uverbs_default_objects;
 static inline const struct uverbs_object_tree_def *uverbs_default_get_objects(void)
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 842792e..1ab80ed 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -52,6 +52,7 @@ enum uverbs_default_objects {
 	UVERBS_OBJECT_XRCD,
 	UVERBS_OBJECT_RWQ_IND_TBL,
 	UVERBS_OBJECT_WQ,
+	UVERBS_OBJECT_COUNTER_SET,
 	UVERBS_OBJECT_LAST,
 };
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 0bed600..fa15ac0 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -103,6 +103,8 @@ enum {
 	IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL,
 	IB_USER_VERBS_EX_CMD_MODIFY_CQ,
 	IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET,
+	IB_USER_VERBS_EX_CMD_CREATE_COUNTER_SET,
+	IB_USER_VERBS_EX_CMD_DESTROY_COUNTER_SET,
 };
 
 /*
@@ -1187,6 +1189,29 @@ struct ib_uverbs_ex_describe_counter_set_resp {
 	__u16 reserved;
 };
 
+struct ib_uverbs_ex_create_counter_set {
+	__u32 comp_mask;
+	__u16 cs_id;
+	__u16 reserved;
+};
+
+struct ib_uverbs_ex_create_counter_set_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 cs_handle;
+	__u32 reserved;
+};
+
+struct ib_uverbs_ex_destroy_counter_set  {
+	__u32 comp_mask;
+	__u32 cs_handle;
+};
+
+struct ib_uverbs_ex_destroy_counter_set_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+};
+
 #define IB_DEVICE_NAME_MAX 64
 
 #endif /* IB_USER_VERBS_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
