From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] IB/core: Add on demand paging caps to ib_uverbs_ex_query_device
Date: Sun,  8 Feb 2015 13:28:51 +0200
Message-ID: <1423394932-2965-3-git-send-email-haggaie@mellanox.com>
References: <1423394932-2965-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423394932-2965-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a on-demand capabilities reporting to the extended query device verb.

Yann Droneaud writes:
> Note: as offsetof() is used to retrieve the size of the lower chunk
> of the response, beware that it only works if the upper chunk
> is right after, without any implicit padding. And, as the size of
> the latter chunk is added to the base size, implicit padding at the
> end of the structure is not taken in account. Both point must be
> taken in account when extending the uverbs functionalities.

Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 20 +++++++++++++++++++-
 include/uapi/rdma/ib_user_verbs.h    | 11 +++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8f507538c42b..04ca04559ce5 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3318,7 +3318,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (cmd.reserved)
 		return -EINVAL;
 
-	resp.response_length = sizeof(resp);
+	resp.response_length = offsetof(typeof(resp), odp_caps);
 
 	if (ucore->outlen < resp.response_length)
 		return -ENOSPC;
@@ -3330,6 +3330,24 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	copy_query_dev_fields(file, &resp.base, &attr);
 	resp.comp_mask = 0;
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
+		goto end;
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
+	resp.odp_caps.per_transport_caps.rc_odp_caps =
+		attr.odp_caps.per_transport_caps.rc_odp_caps;
+	resp.odp_caps.per_transport_caps.uc_odp_caps =
+		attr.odp_caps.per_transport_caps.uc_odp_caps;
+	resp.odp_caps.per_transport_caps.ud_odp_caps =
+		attr.odp_caps.per_transport_caps.ud_odp_caps;
+	resp.odp_caps.reserved = 0;
+#else
+	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
+#endif
+	resp.response_length += sizeof(resp.odp_caps);
+
+end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (err)
 		return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index f0f799afd856..b513e662d8e4 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -207,10 +207,21 @@ struct ib_uverbs_ex_query_device {
 	__u32 reserved;
 };
 
+struct ib_uverbs_odp_caps {
+	__u64 general_caps;
+	struct {
+		__u32 rc_odp_caps;
+		__u32 uc_odp_caps;
+		__u32 ud_odp_caps;
+	} per_transport_caps;
+	__u32 reserved;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
 	__u32 response_length;
+	struct ib_uverbs_odp_caps odp_caps;
 };
 
 struct ib_uverbs_query_port {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
