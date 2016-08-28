From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 05/10] IB/uverbs: Expose XRQ capabilities
Date: Sun, 28 Aug 2016 14:00:45 +0300
Message-ID: <1472382050-25908-6-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make XRQ capabilities available via ibv_query_device() verb.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e1fb1cd..548d4b4 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -4173,6 +4173,17 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 
 	resp.device_cap_flags_ex = attr.device_cap_flags;
 	resp.response_length += sizeof(resp.device_cap_flags_ex);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.xrq_caps))
+		goto end;
+
+	resp.xrq_caps.max_unexpected_tags = attr.xrq_caps.max_unexpected_tags;
+	resp.xrq_caps.tag_mask_length = attr.xrq_caps.tag_mask_length;
+	resp.xrq_caps.header_size = attr.xrq_caps.header_size;
+	resp.xrq_caps.app_context_size = attr.xrq_caps.app_context_size;
+	resp.xrq_caps.max_match_list = attr.xrq_caps.max_match_list;
+	resp.xrq_caps.capability_flags = attr.xrq_caps.capability_flags;
+	resp.response_length += sizeof(resp.xrq_caps);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
