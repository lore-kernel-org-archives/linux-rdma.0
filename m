From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 08/16] IB/uverbs: Add query counter set support
Date: Thu, 19 Oct 2017 17:41:50 +0300
Message-ID: <1508424118-27205-9-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch exposes the query counter set verb to user space
applications.
By that verb the user can read the hardware counters which
are associated with the counter set.

The application needs to provide a sufficient memory to
hold the statistics based on the information it read via
the describe counter set API.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_cmd.c  | 82 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  1 +
 include/uapi/rdma/ib_user_verbs.h     | 14 ++++++
 4 files changed, 98 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index e1e8379..50c4bb4 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -310,5 +310,6 @@ struct ib_uverbs_flow_spec {
 IB_UVERBS_DECLARE_EX_CMD(describe_counter_set);
 IB_UVERBS_DECLARE_EX_CMD(create_counter_set);
 IB_UVERBS_DECLARE_EX_CMD(destroy_counter_set);
+IB_UVERBS_DECLARE_EX_CMD(query_counter_set);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b648c8f..bf2b95a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -4101,3 +4101,85 @@ int ib_uverbs_ex_destroy_counter_set(struct ib_uverbs_file *file,
 	resp.response_length = required_resp_len;
 	return ib_copy_to_udata(ucore, &resp, resp.response_length);
 }
+
+int ib_uverbs_ex_query_counter_set(struct ib_uverbs_file *file,
+				   struct ib_device *ib_dev,
+				   struct ib_udata *ucore,
+				   struct ib_udata *uhw)
+{
+	struct ib_counter_set_query_attr cs_query_attr = {};
+	struct ib_uverbs_ex_query_counter_set	cmd = {};
+	struct ib_uverbs_ex_query_counter_set_resp	resp = {};
+	struct ib_counter_set	*cs;
+	size_t	required_resp_len;
+	size_t	required_cmd_sz;
+	u32 buff_len;
+	int	ret;
+
+	required_cmd_sz = offsetof(typeof(cmd), comp_mask) +
+			sizeof(cmd.comp_mask);
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
+	cs = uobj_get_obj_read(counter_set,
+			       cmd.cs_handle,
+			       file->ucontext);
+
+	if (!cs)
+		return -EINVAL;
+
+	if (!atomic_read(&cs->usecnt)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Prevent memory allocation rather than max expected size */
+	buff_len = min_t(u32, cmd.out_buff_len,
+			 MAX_COUNTER_SET_BUFF_LEN);
+	cs_query_attr.buff_len = buff_len;
+	cs_query_attr.out_buff = kzalloc(buff_len, GFP_KERNEL);
+	if (!cs_query_attr.out_buff) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	cs_query_attr.query_flags = cmd.query_attr;
+	ret = ib_dev->query_counter_set(cs, &cs_query_attr, uhw);
+	if (ret)
+		goto err_query;
+
+	if (copy_to_user(u64_to_user_ptr(cmd.out_buff),
+			 cs_query_attr.out_buff,
+			 cs_query_attr.outlen)) {
+		ret = -EFAULT;
+		goto err_query;
+	}
+
+	resp.response_length = required_resp_len;
+	ret = ib_copy_to_udata(ucore,
+			       &resp, required_resp_len);
+
+err_query:
+	kfree(cs_query_attr.out_buff);
+err:
+	uobj_put_obj_read(cs);
+	return ret;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e9e575d..d6d056c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -132,6 +132,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET]	= ib_uverbs_ex_describe_counter_set,
 	[IB_USER_VERBS_EX_CMD_CREATE_COUNTER_SET]	= ib_uverbs_ex_create_counter_set,
 	[IB_USER_VERBS_EX_CMD_DESTROY_COUNTER_SET]	= ib_uverbs_ex_destroy_counter_set,
+	[IB_USER_VERBS_EX_CMD_QUERY_COUNTER_SET]	= ib_uverbs_ex_query_counter_set,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index fa15ac0..49d9b2d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -105,6 +105,7 @@ enum {
 	IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET,
 	IB_USER_VERBS_EX_CMD_CREATE_COUNTER_SET,
 	IB_USER_VERBS_EX_CMD_DESTROY_COUNTER_SET,
+	IB_USER_VERBS_EX_CMD_QUERY_COUNTER_SET,
 };
 
 /*
@@ -1212,6 +1213,19 @@ struct ib_uverbs_ex_destroy_counter_set_resp {
 	__u32 response_length;
 };
 
+struct ib_uverbs_ex_query_counter_set {
+	__u64 out_buff;
+	__u32 out_buff_len;
+	__u32 query_attr; /* Use enum ib_query_counter_set_flags */
+	__u32 cs_handle;
+	__u32 comp_mask;
+};
+
+struct ib_uverbs_ex_query_counter_set_resp {
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
