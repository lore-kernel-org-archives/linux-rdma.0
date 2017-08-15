From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 07/11] IB/uverbs: Expose XRQ capabilities
Date: Tue, 15 Aug 2017 11:59:08 +0300
Message-ID: <20170815085912.10181-8-leon@kernel.org>
References: <20170815085912.10181-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085912.10181-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make XRQ capabilities available via ibv_query_device() verb.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 10 ++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 15 +++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e3ac272a0fa9..1996f096c4f8 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3850,6 +3850,16 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 
 	resp.raw_packet_caps = attr.raw_packet_caps;
 	resp.response_length += sizeof(resp.raw_packet_caps);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.xrq_caps))
+		goto end;
+
+	resp.xrq_caps.max_rndv_hdr_size = attr.xrq_caps.max_rndv_hdr_size;
+	resp.xrq_caps.max_num_tags      = attr.xrq_caps.max_num_tags;
+	resp.xrq_caps.max_ops		= attr.xrq_caps.max_ops;
+	resp.xrq_caps.max_sge		= attr.xrq_caps.max_sge;
+	resp.xrq_caps.flags		= attr.xrq_caps.flags;
+	resp.response_length += sizeof(resp.xrq_caps);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index d5434bbf40c8..9a0b6479fe0c 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -236,6 +236,20 @@ struct ib_uverbs_rss_caps {
 	__u32 reserved;
 };
 
+struct ib_uverbs_tm_caps {
+	/* Max size of rendezvous request message */
+	__u32 max_rndv_hdr_size;
+	/* Max number of entries in tag matching list */
+	__u32 max_num_tags;
+	/* TM flags */
+	__u32 flags;
+	/* Max number of outstanding list operations */
+	__u32 max_ops;
+	/* Max number of SGE in tag matching entry */
+	__u32 max_sge;
+	__u32 reserved;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -247,6 +261,7 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_rss_caps rss_caps;
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
+	struct ib_uverbs_tm_caps xrq_caps;
 };
 
 struct ib_uverbs_query_port {
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
