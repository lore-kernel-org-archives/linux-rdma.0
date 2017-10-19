From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 04/16] IB/uverbs: Add describe counter set support
Date: Thu, 19 Oct 2017 17:41:46 +0300
Message-ID: <1508424118-27205-5-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

User space application which uses counter set functionality,
is expected first to call counter set describe to get various
information on the counter set so it can be used later on.

The command returns the counter set static information as of
type, number of counters, attributes of the counter set, etc.
In case user asks for the counters names by supplying a buffer
rather than null this data will be returned as well in
case the buffer length is sufficient.
Based on the returned metadata, user can know the required buffer
size needed to hold the counters names, which is 64 * entries_count.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_cmd.c  | 75 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  1 +
 include/uapi/rdma/ib_user_verbs.h     | 21 +++++++++-
 4 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index deccefb..7a95153 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -307,5 +307,6 @@ struct ib_uverbs_flow_spec {
 IB_UVERBS_DECLARE_EX_CMD(destroy_rwq_ind_table);
 IB_UVERBS_DECLARE_EX_CMD(modify_qp);
 IB_UVERBS_DECLARE_EX_CMD(modify_cq);
+IB_UVERBS_DECLARE_EX_CMD(describe_counter_set);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 9c6b795..24775a5 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3909,3 +3909,78 @@ int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
 
 	return ret;
 }
+
+int ib_uverbs_ex_describe_counter_set(struct ib_uverbs_file *file,
+				      struct ib_device *ib_dev,
+				      struct ib_udata *ucore,
+				      struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_describe_counter_set	cmd = {};
+	struct ib_uverbs_ex_describe_counter_set_resp	resp = {};
+	struct ib_counter_set_describe_attr cs_describe_attr = {};
+	size_t	required_resp_len;
+	size_t	required_cmd_sz;
+	u16 buff_len;
+	int ret = 0;
+
+	required_cmd_sz = offsetof(typeof(cmd), cs_id) +
+			sizeof(cmd.cs_id);
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
+	if (cmd.comp_mask)
+		return -EOPNOTSUPP;
+
+	if (cmd.counters_names_resp) {
+		/* Prevent memory allocation rather than max expected size */
+		buff_len = min_t(u16, cmd.counters_names_max,
+				 MAX_COUNTER_SET_BUFF_LEN);
+		cs_describe_attr.counters_names_buff =
+				kzalloc(buff_len, GFP_KERNEL);
+		if (!cs_describe_attr.counters_names_buff)
+			return -ENOMEM;
+
+		cs_describe_attr.counters_names_len = buff_len;
+	}
+
+	ret = ib_dev->describe_counter_set(ib_dev, cmd.cs_id,
+					   &cs_describe_attr, uhw);
+	if (ret)
+		goto err;
+
+	if (cmd.counters_names_resp) {
+		if (copy_to_user(u64_to_user_ptr(cmd.counters_names_resp),
+				 cs_describe_attr.counters_names_buff,
+				 cs_describe_attr.entries_count *
+				 IB_COUNTER_NAME_LEN)) {
+			ret = -EFAULT;
+			goto err;
+		}
+	}
+
+	resp.num_of_cs = cs_describe_attr.num_of_cs;
+	resp.attributes = cs_describe_attr.attributes;
+	resp.counted_type = cs_describe_attr.counted_type;
+	resp.entries_count = cs_describe_attr.entries_count;
+	resp.response_length = required_resp_len;
+	ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
+
+err:
+	kfree(cs_describe_attr.counters_names_buff);
+	return ret;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 381fd9c..51b04bd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -129,6 +129,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL] = ib_uverbs_ex_destroy_rwq_ind_table,
 	[IB_USER_VERBS_EX_CMD_MODIFY_QP]        = ib_uverbs_ex_modify_qp,
 	[IB_USER_VERBS_EX_CMD_MODIFY_CQ]        = ib_uverbs_ex_modify_cq,
+	[IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET]	= ib_uverbs_ex_describe_counter_set,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index b3f952c..0bed600 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -101,7 +101,8 @@ enum {
 	IB_USER_VERBS_EX_CMD_DESTROY_WQ,
 	IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL,
 	IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL,
-	IB_USER_VERBS_EX_CMD_MODIFY_CQ
+	IB_USER_VERBS_EX_CMD_MODIFY_CQ,
+	IB_USER_VERBS_EX_CMD_DESCRIBE_COUNTER_SET,
 };
 
 /*
@@ -1168,6 +1169,24 @@ struct ib_uverbs_ex_modify_cq {
 	__u32 comp_mask;
 };
 
+#define MAX_COUNTER_SET_BUFF_LEN 4096
+struct ib_uverbs_ex_describe_counter_set  {
+	__u64 counters_names_resp;
+	__u32 comp_mask;
+	__u16 counters_names_max;
+	__u16 cs_id;
+};
+
+struct ib_uverbs_ex_describe_counter_set_resp {
+	__u64 num_of_cs;
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 attributes;
+	__u8 counted_type;
+	__u8 entries_count;
+	__u16 reserved;
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
