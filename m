From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/uverbs: Expose RSS related capabilities
Date: Sun, 28 Aug 2016 11:28:44 +0300
Message-ID: <1472372925-17660-3-git-send-email-leon@kernel.org>
References: <1472372925-17660-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472372925-17660-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Query RSS related attributes and return them to user-space via the
extended query device uverbs command.

It includes both direct ones (i.e. struct ib_uverbs_rss_caps) and
max_wq_type_rq which may be used in both RSS and non RSS flows.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 17 +++++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 14 ++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f664731..f44e675 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -4173,6 +4173,23 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 
 	resp.device_cap_flags_ex = attr.device_cap_flags;
 	resp.response_length += sizeof(resp.device_cap_flags_ex);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.rss_caps))
+		goto end;
+
+	resp.rss_caps.supported_qpts = attr.rss_caps.supported_qpts;
+	resp.rss_caps.max_rwq_indirection_tables =
+		attr.rss_caps.max_rwq_indirection_tables;
+	resp.rss_caps.max_rwq_indirection_table_size =
+		attr.rss_caps.max_rwq_indirection_table_size;
+
+	resp.response_length += sizeof(resp.rss_caps);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.max_wq_type_rq))
+		goto end;
+
+	resp.max_wq_type_rq = attr.max_wq_type_rq;
+	resp.response_length += sizeof(resp.max_wq_type_rq);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 7f035f4b..a9ebb47 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -224,6 +224,17 @@ struct ib_uverbs_odp_caps {
 	__u32 reserved;
 };
 
+struct ib_uverbs_rss_caps {
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_UD
+	 */
+	__u32 supported_qpts;
+	__u32 max_rwq_indirection_tables;
+	__u32 max_rwq_indirection_table_size;
+	__u32 reserved;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -232,6 +243,9 @@ struct ib_uverbs_ex_query_device_resp {
 	__u64 timestamp_mask;
 	__u64 hca_core_clock; /* in KHZ */
 	__u64 device_cap_flags_ex;
+	struct ib_uverbs_rss_caps rss_caps;
+	__u32  max_wq_type_rq;
+	__u32 reserved;
 };
 
 struct ib_uverbs_query_port {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
