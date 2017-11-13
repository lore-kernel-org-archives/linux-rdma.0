From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 4/7] IB/uverbs: Add CQ moderation capability to query_device
Date: Mon, 13 Nov 2017 10:51:16 +0200
Message-ID: <20171113085119.1705-5-leon@kernel.org>
References: <20171113085119.1705-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113085119.1705-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The query_device function can now obtain the maximum values for
cq_max_count and cq_period, needed for CQ moderation.
cq_max_count is a 16 bits number that determines the number
of CQEs to accumulate before generating an event.
cq_period is a 16 bits number that determines the timeout in micro
seconds from the last event generated, upon which a new event will
be generated even if cq_max_count was not reached.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 9 +++++++++
 include/rdma/ib_verbs.h              | 6 ++++++
 include/uapi/rdma/ib_user_verbs.h    | 7 +++++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3c2673cd4090..53143e4b1c50 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3852,6 +3852,15 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.tm_caps.max_sge		= attr.tm_caps.max_sge;
 	resp.tm_caps.flags		= attr.tm_caps.flags;
 	resp.response_length += sizeof(resp.tm_caps);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.cq_moderation_caps))
+		goto end;
+
+	resp.cq_moderation_caps.max_cq_moderation_count  =
+		attr.cq_caps.max_cq_moderation_count;
+	resp.cq_moderation_caps.max_cq_moderation_period =
+		attr.cq_caps.max_cq_moderation_period;
+	resp.response_length += sizeof(resp.cq_moderation_caps);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e0d3780ce4e..0b484c023fa9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -315,6 +315,11 @@ enum ib_cq_attr_mask {
 	IB_CQ_MODERATE = 1 << 0,
 };

+struct ib_cq_caps {
+	u16     max_cq_moderation_count;
+	u16     max_cq_moderation_period;
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
@@ -365,6 +370,7 @@ struct ib_device_attr {
 	u32			max_wq_type_rq;
 	u32			raw_packet_caps; /* Use ib_raw_packet_caps enum */
 	struct ib_tm_caps	tm_caps;
+	struct ib_cq_caps       cq_caps;
 };

 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index cfa09d6095d6..5186fb12629b 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -125,6 +125,12 @@ struct ib_uverbs_comp_event_desc {
 	__u64 cq_handle;
 };

+struct ib_uverbs_cq_moderation_caps {
+	__u16     max_cq_moderation_count;
+	__u16     max_cq_moderation_period;
+	__u32     reserved;
+};
+
 /*
  * All commands from userspace should start with a __u32 command field
  * followed by __u16 in_words and out_words fields (which give the
@@ -263,6 +269,7 @@ struct ib_uverbs_ex_query_device_resp {
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
 	struct ib_uverbs_tm_caps tm_caps;
+	struct ib_uverbs_cq_moderation_caps cq_moderation_caps;
 };

 struct ib_uverbs_query_port {
--
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
